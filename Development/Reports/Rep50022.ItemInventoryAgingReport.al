report 50022 "Item Inventory Aging Report"
{
    ApplicationArea = All;
    Caption = 'Item Inventory Aging Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/ItemInventoryAging.rdl';

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            RequestFilterFields = "Location Code";
            DataItemTableView = sorting("Entry No.") order(ascending) where("Remaining Quantity" = filter(<> 0));

            COLUMN(CompanyInfoLogo; CompanyInfo.Picture)
            {
            }
            COLUMN(CompanyName; CompanyInfo.Name)
            {
            }
            COLUMN(CompanyAddress; CompanyInfo.Address)
            {
            }
            COLUMN(CompanyAddress2; CompanyInfo."Address 2")//AddSpaceOrComma(CompanyInfo."Address 2", ', '))
            {
            }
            COLUMN(CompanyCity; AddSpaceOrComma(CompanyInfo.City, ', ') + AddSpaceOrComma(CompanyInfo.County, ', '))
            {
            }
            COLUMN(CompanyPhoneNo; 'Phone: ' + CompanyInfo."Phone No.")
            {
            }
            COLUMN(CompanyFax; 'Fax: ' + CompanyInfo."Fax No.")
            {
            }
            COLUMN(CompanyPostCode; CompanyInfo."Post Code")
            {
            }
            COLUMN(CompanyCountry; GetCountryDesc(CompanyInfo."Country/Region Code"))
            {
            }
            COLUMN(ShowCost; ShowCost)
            {
            }
            column(Item_No_; "Item No.")
            {

            }
            column(ItemDesc; RecItem.Description)
            {

            }
            column(ItemDesc2; RecItem."Description 2")
            {

            }
            column(Lot_No_; "Lot No.")
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(TotalQty; TotalQty)
            {

            }
            column(SubTotalQty; SubTotalQty)
            {

            }
            column(SubTotalAmt; SubTotalAmt)
            {

            }
            column(GrandTotalQty; GrandTotalQty)
            {

            }
            column(GrandTotalAmt; GrandTotalAmt)
            {

            }
            column(UnitCost; Round(RecItem."Unit Cost", 0.1, '='))
            {

            }
            column(TotalCost; Round(TotalQty * RecItem."Unit Cost", 0.1, '='))
            {

            }
            column(Days; Days)
            {

            }
            column(ExpDate; ExpDate)
            {

            }
            column(YellowColor; YellowColor)
            {

            }
            column(B1; B1)
            {

            }
            column(B2; B2)
            {

            }
            column(B3; B3)
            {

            }
            column(B4; B4)
            {

            }
            column(B5; B5)
            {

            }
            column(B1Qty; B1Qty)
            {

            }
            column(B2Qty; B2Qty)
            {

            }
            column(B3Qty; B3Qty)
            {

            }
            column(B4Qty; B4Qty)
            {

            }
            column(B5Qty; B5Qty)
            {

            }
            column(B1TotQty; B1TotQty)
            {

            }
            column(B2TotQty; B2TotQty)
            {

            }
            column(B3TotQty; B3TotQty)
            {

            }
            column(B4TotQty; B4TotQty)
            {

            }
            column(B5TotQty; B5TotQty)
            {

            }
            column(B1Caption; ' < ' + FORMAT(Bucket1) + ' Days')
            {

            }
            column(B2Caption; ' ' + FORMAT(Bucket1 + 1) + '-' + FORMAT(Bucket2) + ' Days')
            {

            }
            column(B3Caption; ' ' + FORMAT(Bucket2 + 1) + '-' + FORMAT(Bucket3) + ' Days')
            {

            }
            column(B4Caption; ' ' + FORMAT(Bucket3 + 1) + '-' + FORMAT(Bucket4) + ' Days')
            {

            }
            column(B5Caption; ' > ' + FORMAT(Bucket4) + ' Days')
            {

            }
            dataitem("Bin Content"; "Bin Content")
            {
                DataItemLinkReference = ItemLedgerEntry;
                DataItemLink = "Item No." = field("Item No."), "Location Code" = field("Location Code"), "Lot No. Filter" = field("Lot No.");
                DataItemTableView = sorting("Location Code", "Bin Code", "Item No.", "Variant Code", "Unit of Measure Code") order(ascending) where(Quantity = filter(<> 0));
                CalcFields = Quantity;
                column(Bin_Code; "Bin Code")
                {

                }
                column(Bin_Desc; BinDesc)
                {

                }
                column(Desc3; Description)
                {

                }

                column(Quantity; Quantity)
                {

                }
                trigger OnPreDataItem()
                begin
                    SetFilter("Location Code", '<>%1', 'IN TRANSIT');
                    SetFilter("Lot No. Filter", ItemLedgerEntry."Lot No.");
                end;

                trigger OnAfterGetRecord()
                var
                    RecCustomer: Record Customer;
                    RecBin: Record Bin;
                begin
                    Clear(TotalQty);
                    Clear(Days);
                    Clear(ExpDate);
                    Clear(B1);
                    Clear(B2);
                    Clear(B3);
                    Clear(B4);
                    Clear(B5);
                    Clear(B1Qty);
                    Clear(B2Qty);
                    Clear(B3Qty);
                    Clear(B4Qty);
                    Clear(B5Qty);
                    Clear(Description);
                    Clear(BinDesc);
                    RecItem.GET("Item No.");
                    if RecCustomer.Get("Bin Code") then
                        Description := RecCustomer.Name
                    else
                        Description := '';
                    if RecBin.Get(ItemLedgerEntry."Location Code", "Bin Code") then
                        BinDesc := RecBin.Description
                    else
                        BinDesc := '';
                    SubTotalQty += "Bin Content".Quantity;
                    SubTotalAmt += ("Bin Content".Quantity * RecItem."Unit Cost");
                    GrandTotalQty += "Bin Content".Quantity;
                    GrandTotalAmt += ("Bin Content".Quantity * RecItem."Unit Cost");
                    if not GenerateExcel then begin
                        TotalQty := "Bin Content".Quantity;
                        if ItemLedgerEntry."Expiration Date" <> 0D then
                            ExpDate := ItemLedgerEntry."Expiration Date"
                        else
                            ExpDate := GetExpirationDate("Item No.", ItemLedgerEntry.GetFilter("Location Code"), ItemLedgerEntry."Lot No.");

                        if ExpDate <> 0D then
                            Days := (Today() - ExpDate);

                        if Days <= Bucket1 then begin
                            B1 := Days;
                            B1Qty := TotalQty;
                            B1TotQty += TotalQty;
                        end else
                            if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                B2 := Days;
                                B2Qty := TotalQty;
                                B2TotQty += TotalQty;
                            end else
                                if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                    B3 := Days;
                                    B3Qty := TotalQty;
                                    B3TotQty += TotalQty;
                                end else
                                    if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                        B4 := Days;
                                        B4Qty := TotalQty;
                                        B4TotQty += TotalQty;
                                    end else begin
                                        B5 := Days;
                                        B5Qty := TotalQty;
                                        B5TotQty += TotalQty;
                                    end
                    end;

                    if GenerateExcel then begin
                        ExcelBuf.NewRow;
                        ExcelBuf.AddColumn("Item No.", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(RecItem."Description 2", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(ItemLedgerEntry.Description, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(ItemLedgerEntry."Lot No.", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn("Location Code", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn("Bin Code", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                        //GetTotalRemainingQty("Item No.", ItemLedgerEntry.GetFilter("Location Code"), ItemLedgerEntry."Lot No.", ItemLedgerEntry.GetFilter("Posting Date"));
                        TotalQty := "Bin Content".Quantity;
                        ExcelBuf.AddColumn(TotalQty, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(RecItem."Unit Cost", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(Round(TotalQty * RecItem."Unit Cost", 0.1, '='), FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                        if ItemLedgerEntry."Expiration Date" <> 0D then begin
                            ExpDate := ItemLedgerEntry."Expiration Date";
                            ExcelBuf.AddColumn(ItemLedgerEntry."Expiration Date", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Date);
                            Days := (Today() - ItemLedgerEntry."Expiration Date");
                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                            if Days <= Bucket1 then begin
                                B1 := Days;
                                B1Qty := TotalQty;
                                B1TotQty += TotalQty;
                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                            end else
                                if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                    B2 := Days;
                                    B2Qty := TotalQty;
                                    B2TotQty += TotalQty;
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                end else
                                    if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                        B3 := Days;
                                        B3Qty := TotalQty;
                                        B3TotQty += TotalQty;
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);

                                    end
                                    else
                                        if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                            B4 := Days;
                                            B4Qty := TotalQty;
                                            B4TotQty += TotalQty;
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);

                                        end
                                        else begin
                                            B5 := Days;
                                            B5Qty := TotalQty;
                                            B5TotQty += TotalQty;
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        end;
                        end else begin
                            ExpDate := GetExpirationDate("Item No.", ItemLedgerEntry.GetFilter("Location Code"), ItemLedgerEntry."Lot No.");
                            if ExpDate <> 0D then begin
                                ExcelBuf.AddColumn(ExpDate, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Date);
                                Days := (Today() - ExpDate);
                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                if Days <= Bucket1 then begin
                                    B1 := Days;
                                    B1Qty := TotalQty;
                                    B1TotQty += TotalQty;
                                    ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                end else
                                    if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                        B2 := Days;
                                        B2Qty := TotalQty;
                                        B2TotQty += TotalQty;
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    end else
                                        if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                            B3 := Days;
                                            B3Qty := TotalQty;
                                            B3TotQty += TotalQty;
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);

                                        end
                                        else
                                            if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                                B4 := Days;
                                                B4Qty := TotalQty;
                                                B4TotQty += TotalQty;
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);

                                            end
                                            else begin
                                                B5 := Days;
                                                B5Qty := TotalQty;
                                                B5TotQty += TotalQty;
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            end;
                            end else begin
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                            end;
                        end;
                    end;
                end;

            }
            dataitem(ItemIntransit; Item)
            {
                DataItemLinkReference = ItemLedgerEntry;
                DataItemLink = "No." = field("Item No."), "Location Filter" = field("Location Code"), "Lot No. Filter" = field("Lot No.");
                DataItemTableView = SORTING("No.");
                CalcFields = "Net Change";
                column(Intransit_ItemCode; RecItem."No.")
                {

                }
                column(Intransit_LocCode; ItemLedgerEntry."Location Code")
                {

                }
                column(Intransit_Code; 'In Transit')
                {

                }

                column(Intransit; ItemIntransit."Net Change")
                {

                }
                trigger OnPreDataItem()
                begin
                    ItemIntransit.SetFilter("Location Filter", '=%1', 'IN TRANSIT');
                    //ItemIntransit.SetFilter("Lot No. Filter", ItemLedgerEntry."Lot No.");
                end;

                trigger OnAfterGetRecord()
                var
                    RecCustomer: Record Customer;
                begin
                    Clear(TotalQty);
                    Clear(Days);
                    Clear(ExpDate);
                    Clear(B1);
                    Clear(B2);
                    Clear(B3);
                    Clear(B4);
                    Clear(B5);
                    Clear(B1Qty);
                    Clear(B2Qty);
                    Clear(B3Qty);
                    Clear(B4Qty);
                    Clear(B5Qty);

                    Clear(Description);
                    RecItem.Reset();
                    if ItemLedgerEntry."Location Code" = 'IN Transit' then begin
                        RecItem.GET(ItemLedgerEntry."Item No.");

                        SubTotalQty += ItemIntransit."Net Change";
                        SubTotalAmt += (ItemIntransit."Net Change" * ItemIntransit."Unit Cost");
                        GrandTotalQty += ItemIntransit."Net Change";
                        GrandTotalAmt += (ItemIntransit."Net Change" * ItemIntransit."Unit Cost");
                        if not GenerateExcel then begin
                            //TotalInTransitQty := ItemIntransit."Net Change";
                            TotalQty := ItemIntransit."Net Change";
                            if ItemLedgerEntry."Expiration Date" <> 0D then
                                ExpDate := ItemLedgerEntry."Expiration Date"
                            else
                                ExpDate := GetExpirationDate(ItemIntransit."No.", ItemLedgerEntry.GetFilter("Location Code"), ItemLedgerEntry."Lot No.");

                            if ExpDate <> 0D then
                                Days := (Today() - ExpDate);

                            if Days <= Bucket1 then begin
                                B1 := Days;
                                B1Qty := TotalQty;
                                B1TotQty += TotalQty;
                            end else
                                if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                    B2 := Days;
                                    B2Qty := TotalQty;
                                    B2TotQty += TotalQty;
                                end else
                                    if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                        B3 := Days;
                                        B3Qty := TotalQty;
                                        B3TotQty += TotalQty;
                                    end else
                                        if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                            B4 := Days;
                                            B4Qty := TotalQty;
                                            B4TotQty += TotalQty;
                                        end else begin
                                            B5 := Days;
                                            B5Qty := TotalQty;
                                            B5TotQty += TotalQty;
                                        end;
                        end;
                        if GenerateExcel AND (TotalQty <> 0) then begin
                            ExcelBuf.NewRow;
                            ExcelBuf.AddColumn(ItemIntransit."No.", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(ItemIntransit."Description 2", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(ItemLedgerEntry.Description, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(ItemLedgerEntry."Lot No.", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(ItemLedgerEntry."Location Code", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn('In Transit', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                            //GetTotalRemainingQty("Item No.", ItemLedgerEntry.GetFilter("Location Code"), ItemLedgerEntry."Lot No.", ItemLedgerEntry.GetFilter("Posting Date"));
                            TotalQty := ItemIntransit."Net Change";
                            ExcelBuf.AddColumn(TotalQty, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(ItemIntransit."Unit Cost", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(Round(TotalQty * ItemIntransit."Unit Cost", 0.1, '='), FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                            if ItemLedgerEntry."Expiration Date" <> 0D then begin
                                ExpDate := ItemLedgerEntry."Expiration Date";
                                ExcelBuf.AddColumn(ItemLedgerEntry."Expiration Date", FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Date);
                                Days := (Today() - ItemLedgerEntry."Expiration Date");
                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                if Days <= Bucket1 then begin
                                    B1 := Days;
                                    B1Qty := TotalQty;
                                    B1TotQty += TotalQty;
                                    ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                end else
                                    if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                        B2 := Days;
                                        B2Qty := TotalQty;
                                        B2TotQty += TotalQty;
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    end else
                                        if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                            B3 := Days;
                                            B3Qty := TotalQty;
                                            B3TotQty += TotalQty;
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);

                                        end
                                        else
                                            if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                                B4 := Days;
                                                B4Qty := TotalQty;
                                                B4TotQty += TotalQty;
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);

                                            end
                                            else begin
                                                B5 := Days;
                                                B5Qty := TotalQty;
                                                B5TotQty += TotalQty;
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            end;
                            end else begin
                                ExpDate := GetExpirationDate(RecItem."No.", ItemLedgerEntry.GetFilter("Location Code"), ItemLedgerEntry."Lot No.");
                                if ExpDate <> 0D then begin
                                    ExcelBuf.AddColumn(ExpDate, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Date);
                                    Days := (Today() - ExpDate);
                                    ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    if Days <= Bucket1 then begin
                                        B1 := Days;
                                        B1Qty := TotalQty;
                                        B1TotQty += TotalQty;
                                        ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    end else
                                        if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                            B2 := Days;
                                            B2Qty := TotalQty;
                                            B2TotQty += TotalQty;
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        end else
                                            if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                                B3 := Days;
                                                B3Qty := TotalQty;
                                                B3TotQty += TotalQty;
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);

                                            end
                                            else
                                                if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                                    B4 := Days;
                                                    B4Qty := TotalQty;
                                                    B4TotQty += TotalQty;
                                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                    ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);

                                                end
                                                else begin
                                                    B5 := Days;
                                                    B5Qty := TotalQty;
                                                    B5TotQty += TotalQty;
                                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                    ExcelBuf.AddColumn(Days, FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                end;
                                end else begin
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, True, FALSE, '', ExcelBuf."Cell Type"::Number);
                                end;
                            end;
                        end;
                    end;
                end;

            }
            trigger OnAfterGetRecord()
            var
                RecBinContent: Record "Bin Content";
            begin
                if not CheckList.Contains(ItemLedgerEntry."Item No." + ItemLedgerEntry."Lot No.") then begin
                    CheckList.Add(ItemLedgerEntry."Item No." + ItemLedgerEntry."Lot No.");

                    Clear(TotalQty);
                    Clear(Days);
                    Clear(ExpDate);
                    Clear(B1);
                    Clear(B2);
                    Clear(B3);
                    Clear(B4);
                    Clear(B5);
                    Clear(B1Qty);
                    Clear(B2Qty);
                    Clear(B3Qty);
                    Clear(B4Qty);
                    Clear(B5Qty);

                    if (PrevItemNo = '') AND (PrevLotNo = '') then begin
                        PrevItemNo := ItemLedgerEntry."Item No.";
                        PrevLotNo := ItemLedgerEntry."Lot No.";
                    end else begin
                        if PrevItemNo <> ItemLedgerEntry."Item No." then
                            PrevItemNo := ItemLedgerEntry."Item No.";
                        if PrevLotNo <> ItemLedgerEntry."Lot No." then begin
                            PrevItemNo := ItemLedgerEntry."Lot No.";
                            SubTotalQty := 0;
                            SubTotalAmt := 0;
                        end;
                    end;

                    RecItem.GET("Item No.");
                    TotalQty := GetTotalRemainingQty("Item No.", ItemLedgerEntry.GetFilter("Location Code"), "Lot No.", ItemLedgerEntry.GetFilter("Posting Date"));


                    if not GenerateExcel then begin
                        if ItemLedgerEntry."Expiration Date" <> 0D then
                            ExpDate := ItemLedgerEntry."Expiration Date"
                        else
                            ExpDate := GetExpirationDate("Item No.", ItemLedgerEntry.GetFilter("Location Code"), ItemLedgerEntry."Lot No.");

                        if ExpDate <> 0D then
                            Days := (Today() - ExpDate);

                        if Days <= Bucket1 then begin
                            B1 := Days;
                            B1Qty := TotalQty;
                        end else
                            if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                B2 := Days;
                                B2Qty := TotalQty;
                            end else
                                if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                    B3 := Days;
                                    B3Qty := TotalQty;
                                end else
                                    if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                        B4 := Days;
                                        B4Qty := TotalQty;
                                    end else begin
                                        B5 := Days;
                                        B5Qty := TotalQty;
                                    end;
                    end;

                    if GenerateExcel then begin
                        ExcelBuf.NewRow;
                        ExcelBuf.AddColumn("Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(RecItem."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn("Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn("Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(TotalQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(RecItem."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(Round(TotalQty * RecItem."Unit Cost", 0.1, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        if "Expiration Date" <> 0D then begin
                            ExpDate := "Expiration Date";
                            ExcelBuf.AddColumn("Expiration Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
                            Days := (Today() - "Expiration Date");
                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            if Days <= Bucket1 then begin
                                B1 := Days;
                                B1Qty := TotalQty;
                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            end else
                                if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                    B2 := Days;
                                    B2Qty := TotalQty;
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                end else
                                    if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                        B3 := Days;
                                        B3Qty := TotalQty;
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                                    end
                                    else
                                        if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                            B4 := Days;
                                            B4Qty := TotalQty;
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                                        end
                                        else begin
                                            B5 := Days;
                                            B5Qty := TotalQty;
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        end;
                        end else begin
                            ExpDate := GetExpirationDate("Item No.", ItemLedgerEntry.GetFilter("Location Code"), "Lot No.");
                            if ExpDate <> 0D then begin
                                ExcelBuf.AddColumn(ExpDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
                                Days := (Today() - ExpDate);
                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                if Days <= Bucket1 then begin
                                    B1 := Days;
                                    B1Qty := TotalQty;
                                    ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                end else
                                    if (Days >= Bucket1 + 1) AND (Days <= Bucket2) then begin
                                        B2 := Days;
                                        B2Qty := TotalQty;
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                    end else
                                        if (Days >= Bucket2 + 1) AND (Days <= Bucket3) then begin
                                            B3 := Days;
                                            B3Qty := TotalQty;
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                                        end
                                        else
                                            if (Days >= Bucket3 + 1) AND (Days <= Bucket4) then begin
                                                B4 := Days;
                                                B4Qty := TotalQty;
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                                            end
                                            else begin
                                                B5 := Days;
                                                B5Qty := TotalQty;
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                                ExcelBuf.AddColumn(Days, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                            end;
                            end else begin
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            end;
                        end;
                    end;
                end else
                    CurrReport.Skip();

            end;

            trigger OnPreDataItem()
            begin
                ItemLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
            end;

        }

    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(GenerateExcel; GenerateExcel)
                    {
                        ApplicationArea = all;
                        Caption = 'Generate Excel';
                    }
                    field(StartingDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(EndingDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(Bucket1; Bucket1)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging Bucket 1';
                    }

                    field(Bucket2; Bucket2)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging Bucket 2';
                        trigger OnValidate()
                        begin
                            if Bucket2 < Bucket1 then
                                Error('Bucket 2 must be greater than Bucket 1');
                        end;
                    }

                    field(Bucket3; Bucket3)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging Bucket 3';
                        trigger OnValidate()
                        begin
                            if Bucket3 < Bucket2 then
                                Error('Bucket 3 must be greater than Bucket 2');
                        end;
                    }
                    field(Bucket4; Bucket4)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging Bucket 4';
                        trigger OnValidate()
                        begin
                            if Bucket4 < Bucket3 then
                                Error('Bucket 4 must be greater than Bucket 3');
                        end;
                    }
                    field(ShowCost; ShowCost)
                    {
                        ApplicationArea = All;
                        Caption = 'ShowCost';
                        trigger OnValidate()
                        begin
                        end;
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            myInt: Integer;
        begin
            if CloseAction In [Action::OK, Action::LookupOK, CloseAction::Yes] then begin
                if Bucket1 = 0 then
                    Error('Please enter first bucket value. Example: 30 for 0 to 30 Days')
                else
                    if Bucket2 = 0 then
                        Error('Please enter second bucket value. Example: %1 for %2 to %3 Days', Bucket1 + 30, Bucket1 + 1, Bucket1 + 30)
                    else
                        if Bucket2 < Bucket1 then
                            Error('Bucket 2 must be greater than Bucket 1')
                        else
                            if Bucket3 = 0 then
                                Error('Please enter third bucket value. Example: %1 for %2 to %3 Days', Bucket2 + 30, Bucket2 + 1, Bucket2 + 30)
                            else
                                if Bucket3 < Bucket2 then
                                    Error('Bucket 3 must be greater than Bucket 2')
                                else
                                    if Bucket4 = 0 then
                                        Error('Please enter fourth bucket value. Example: %1 for %2 to %3 Days', Bucket3 + 30, Bucket3 + 1, Bucket3 + 30)
                                    else
                                        if Bucket4 < Bucket3 then
                                            Error('Bucket 4 must be greater than Bucket 3');
            end;
        end;

        trigger OnOpenPage()
        begin
            if (StartDate = 0D) and (EndDate = 0D) then
                EndDate := WorkDate();
        end;
    }



    trigger OnPreReport()
    begin
        if GenerateExcel then
            MakeExcelDataHeader();
        if (StartDate = 0D) and (EndDate = 0D) then
            EndDate := WorkDate();
        CompanyInfo.GET;
        CompanyInfo.CalcFields(Picture);
        if CompanyName.Contains('Altran') then
            YellowColor := true
        else
            YellowColor := false;

    end;

    trigger OnPostReport()
    begin
        if GenerateExcel then
            CreateExcelbook();
    end;

    local procedure AddSpaceOrComma(AddressText: Text; AppendText: Text): Text
    begin
        if AddressText <> '' then
            exit(AddressText + AppendText)
        else
            exit(AddressText);
    end;

    local procedure GetCountryDesc(CountryCode: code[20]): Text[100]
    var
        RecCountry: Record "Country/Region";
    begin
        if CountryCode <> '' then begin
            RecCountry.GET(CountryCode);
            exit(RecCountry.Name);
        end else
            exit('');
    end;

    local procedure GetTotalRemainingQty(ItemNo: code[20]; LocationFilter: Text; LotNumber: code[20]; DateFilter: Text): Decimal
    var
        ItemLotLocCombination: Query ItemLotLocationCombination;
        TotalQty: Decimal;
    begin
        TotalQty := 0;
        if ItemNo <> '' then
            ItemLotLocCombination.SetRange(Item_No, ItemNo);
        //if LotNumber <> '' then
        ItemLotLocCombination.SetRange(Lot_No, LotNumber);
        if LocationFilter <> '' then
            ItemLotLocCombination.SetFilter(Location_Code, LocationFilter);
        //if DateFilter <> '' then
        //    ItemLotLocCombination.SetFilter(Posting_Date, DateFilter);
        ItemLotLocCombination.Open;
        while ItemLotLocCombination.Read do begin
            TotalQty += ItemLotLocCombination.Sum_Of_RemQty;
        end;
        exit(TotalQty);
    end;

    local procedure GetExpirationDate(ItemNo: code[20]; LocationFilter: Text; LotNumber: code[20]): Date
    var
        RecILE: Record "Item Ledger Entry";
    begin
        Clear(RecILE);
        RecILE.SetCurrentKey("Entry No.");
        RecILE.SetRange("Item No.", ItemNo);
        if LocationFilter <> '' then
            RecILE.SetFilter("Location Code", LocationFilter);
        RecILE.SetRange("Lot No.", LotNumber);
        RecILE.SetFilter("Entry Type", '<>%1', RecILE."Entry Type"::Purchase);
        RecILE.SetAscending("Entry No.", true);
        if RecILE.FindFirst() then
            exit(RecILE."Posting Date")
        else
            exit(0D);
    end;

    local procedure MakeExcelDataHeader()
    begin
        Clear(CheckList);
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Item No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Model No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Batch No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Bin Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Quantity', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Cost', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Total cost', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Batch Receipt Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('No. of Days', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(' < ' + FORMAT(Bucket1) + ' Days', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(' ' + FORMAT(Bucket1 + 1) + '-' + FORMAT(Bucket2) + ' Days', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(' ' + FORMAT(Bucket2 + 1) + '-' + FORMAT(Bucket3) + ' Days', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(' ' + FORMAT(Bucket3 + 1) + '-' + FORMAT(Bucket4) + ' Days', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(' > ' + FORMAT(Bucket4) + ' Days', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);

    END;

    local procedure CreateExcelbook()
    begin
        ExcelBuf.CreateNewBook(ReportName);
        ExcelBuf.WriteSheet(ReportName, COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        // ExcelBuf.OpenExcel();
        DownloadExcelFile('ItemInvAging_' + DelChr(FORMAT(CurrentDateTime), '=', '.:/\-AMPM') + '.xlsx');
    end;

    procedure DownloadExcelFile(FileName: Text)
    var
        InStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        TempBlob.CreateOutStream(FileInStream);
        ExcelBuf.SaveToStream(FileInStream, True);
        TempBlob.CreateInStream(InStream);
        File.DownloadFromStream(InStream, '', '', '', FileName);
    end;

    var
        ILE: Record "Item Ledger Entry";
        CheckList: List of [Text];
        ExcelBuf: Record "Excel Buffer" temporary;
        ReportName: Label 'Item Inventory Aging';
        FileInStream: OutStream;
        Bucket1, Bucket2, Bucket3, Bucket4 : Integer;
        StartDate: Date;
        EndDate: Date;
        GenerateExcel: Boolean;
        CompanyInfo: Record "Company Information";
        RecItem: Record Item;
        TotalQty: Decimal;
        SubTotalQty: Decimal;
        SubTotalAmt: Decimal;
        PrevLotNo: Code[50];
        PrevItemNo: Code[20];
        GrandTotalQty: Decimal;
        GrandTotalAmt: Decimal;
        Days: Integer;
        ExpDate: Date;
        B1, B2, B3, B4, B5 : Integer;
        B1Qty, B2Qty, B3Qty, B4Qty, B5Qty : Decimal;
        B1TotQty, B2TotQty, B3TotQty, B4TotQty, B5TotQty : Decimal;
        YellowColor: Boolean;
        Description: Text[100];
        ShowCost: Boolean;
        BinDesc: Text[100];
}
