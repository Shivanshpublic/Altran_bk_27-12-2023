report 50025 ComissionReport_ALT
{
    ApplicationArea = All;
    Caption = 'Commission Report ALT';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = true;
    dataset
    {
        dataitem("CustLedgerEntry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.") order(ascending) where("Document Type" = const(Invoice));
            // RequestFilterFields = "Posting Date";

            DATAITEM("SalesInvoiceLineInv"; "Sales Invoice Line")
            {
                DataItemLinkReference = "CustLedgerEntry";
                DataItemLink = "Document No." = FIELD("Document No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item));
                RequestFilterFields = Type, "No.", "Sell-to Customer No.";
                trigger OnAfterGetRecord()
                var
                    SInvHeader: Record "Sales Invoice Header";
                    RecSperson: Record "Salesperson/Purchaser";
                    RecItem: Record Item;
                    RecDCLE: Record "Detailed Cust. Ledg. Entry";
                    TempItemLedgEntry: Record "Item Ledger Entry" temporary;
                    ItmTrMgmt: Codeunit "Item Tracking Doc. Management";
                    TotalLandedvcost, TotalSalesAmount : Decimal;
                    AppliedNo: Code[20];
                    AppliedDate: Date;
                begin
                    ItmTrMgmt.RetrieveEntriesFromPostedInvoice(TempItemLedgEntry, SalesInvoiceLineInv.RowID1());
                    if RecItem.Type <> RecItem.Type::"Inventory" then CurrReport.Skip();
                    if SalesInvoiceLineInv.Quantity = 0 then CurrReport.Skip();
                    if RecItem.GET(SalesInvoiceLineInv."No.") then;
                    if TempItemLedgEntry.FindSet() then begin
                        repeat
                            Clear(SInvHeader);
                            SInvHeader.GET(SalesInvoiceLineInv."Document No.");
                            ExcelBuf.NewRow;
                            ExcelBuf.AddColumn(CustLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(CustLedgerEntry."Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(CustLedgerEntry."Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(SInvHeader."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if RecSperson.Get(SInvHeader."Salesperson Code") then;
                            ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(SInvHeader."External Rep", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if RecSperson.Get(SInvHeader."External Rep") then;
                            ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if RecSperson.Get(SInvHeader."Internal Team") then;
                            ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(SInvHeader."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(SInvHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            Clear(RecDCLE);
                            RecDCLE.SetCurrentKey("Entry No.");
                            RecDCLE.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                            RecDCLE.SetRange("Entry Type", RecDCLE."Entry Type"::Application);
                            RecDCLE.SetRange("Document Type", RecDCLE."Document Type"::Payment);
                            if RecDCLE.FindLast() then begin
                                AppliedNo := RecDCLE."Document No.";
                                AppliedDate := RecDCLE."Posting Date";
                            end else begin
                                if CustLedgerEntry.Open = false then begin
                                    RecDCLE.SetRange("Document Type", RecDCLE."Document Type"::"Credit Memo");
                                    if RecDCLE.FindLast() then begin
                                        AppliedNo := RecDCLE."Document No.";
                                        AppliedDate := RecDCLE."Posting Date";
                                    end else begin
                                        AppliedNo := CustLedgerEntry."Document No.";
                                        AppliedDate := CustLedgerEntry."Posting Date";
                                    end;
                                end;
                            end;


                            ExcelBuf.AddColumn(AppliedNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(AppliedDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if CustLedgerEntry.Open then
                                ExcelBuf.AddColumn('Unpaid', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                            else
                                ExcelBuf.AddColumn('Paid', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if RecItem.GET(SalesInvoiceLineInv."No.") then;
                            ExcelBuf.AddColumn(RecItem."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(RecItem."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(TempItemLedgEntry."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                            CalcCOstBasedONTrackingLine(SalesInvoiceLineInv."Document No.", SalesInvoiceLineInv."Line No.", SalesInvoiceLineInv."No.", TempItemLedgEntry.Quantity, SalesInvoiceLineInv.RowID1(), TempItemLedgEntry."Lot No.");
                            // CalcCost(SalesInvoiceLineInv."Document No.", SalesInvoiceLineInv."Line No.", SalesInvoiceLineInv."No.", SalesInvoiceLineInv.Quantity);
                            ExcelBuf.AddColumn(VendorCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(Tariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(Duties, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(VendorCost + Tariff + Duties + Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            TotalLandedvcost := (VendorCost + Tariff + Duties + Shipping) * TempItemLedgEntry.Quantity;
                            ExcelBuf.AddColumn(TotalLandedvcost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(SalesInvoiceLineInv."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            CalcCost(SalesInvoiceLineInv."Document No.", SalesInvoiceLineInv."Line No.", SalesInvoiceLineInv."Linked SO Line No.", TempItemLedgEntry.Quantity);
                            ExcelBuf.AddColumn(Tariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(SalesInvoiceLineInv."Unit Price" + Tariff + shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(TempItemLedgEntry.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            TotalSalesAmount := (SalesInvoiceLineInv."Unit Price" + Tariff + shipping) * TempItemLedgEntry.Quantity;
                            ExcelBuf.AddColumn(TotalSalesAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            lCommissionable := SalesInvoiceLineInv."Unit Price" * TempItemLedgEntry.Quantity;
                            ExcelBuf.AddColumn(lCommissionable, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            if TotalSalesAmount <> 0 then
                                lMargingPct := ((TotalSalesAmount - TotalLandedvcost) / TotalSalesAmount) * 100
                            else
                                lMargingPct := 0;

                            ExcelBuf.AddColumn(lMargingPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            CalculateComissionAndPerct(SInvHeader."Salesperson Code", SalesInvoiceLineInv."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLineInv."Item Category Code");

                            //++
                            ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            //ExcelBuf.AddColumn(GetTeamCommission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                            lCommissionPct := 0;
                            lCommissionAmt := 0;
                            CalculateComissionAndPerct(SInvHeader."Internal Team", SalesInvoiceLineInv."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLineInv."Item Category Code");

                            //++
                            ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            //ExcelBuf.AddColumn(GetTeamCommission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                            lCommissionPct := 0;
                            lCommissionAmt := 0;
                            CalculateComissionAndPerct(SInvHeader."External Rep", SalesInvoiceLineInv."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLineInv."Item Category Code");

                            //++
                            ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            //ExcelBuf.AddColumn(GetTeamCommission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        until TempItemLedgEntry.Next() = 0;
                    end else begin
                        Clear(SInvHeader);
                        SInvHeader.GET(SalesInvoiceLineInv."Document No.");
                        ExcelBuf.NewRow;
                        ExcelBuf.AddColumn(CustLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(CustLedgerEntry."Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(CustLedgerEntry."Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(SInvHeader."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        if RecSperson.Get(SInvHeader."Salesperson Code") then;
                        ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(SInvHeader."External Rep", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        if RecSperson.Get(SInvHeader."External Rep") then;
                        ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        if RecSperson.Get(SInvHeader."Internal Team") then;
                        ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(SInvHeader."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(SInvHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        Clear(RecDCLE);
                        RecDCLE.SetCurrentKey("Entry No.");
                        RecDCLE.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        RecDCLE.SetRange("Entry Type", RecDCLE."Entry Type"::Application);
                        RecDCLE.SetRange("Document Type", RecDCLE."Document Type"::Payment);
                        if RecDCLE.FindLast() then begin
                            AppliedNo := RecDCLE."Document No.";
                            AppliedDate := RecDCLE."Posting Date";
                        end else begin
                            if CustLedgerEntry.Open = false then begin
                                RecDCLE.SetRange("Document Type", RecDCLE."Document Type"::"Credit Memo");
                                if RecDCLE.FindLast() then begin
                                    AppliedNo := RecDCLE."Document No.";
                                    AppliedDate := RecDCLE."Posting Date";
                                end else begin
                                    AppliedNo := CustLedgerEntry."Document No.";
                                    AppliedDate := CustLedgerEntry."Posting Date";
                                end;
                            end;
                        end;


                        ExcelBuf.AddColumn(AppliedNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(AppliedDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                        if CustLedgerEntry.Open then
                            ExcelBuf.AddColumn('Unpaid', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                        else
                            ExcelBuf.AddColumn('Paid', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        if RecItem.GET(SalesInvoiceLineInv."No.") then;
                        ExcelBuf.AddColumn(RecItem."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn(RecItem."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                        CalcCOstBasedONTrackingLine(SalesInvoiceLineInv."Document No.", SalesInvoiceLineInv."Line No.", SalesInvoiceLineInv."No.", SalesInvoiceLineInv.Quantity, SalesInvoiceLineInv.RowID1(), '');
                        // CalcCost(SalesInvoiceLineInv."Document No.", SalesInvoiceLineInv."Line No.", SalesInvoiceLineInv."No.", SalesInvoiceLineInv.Quantity);
                        ExcelBuf.AddColumn(VendorCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(Tariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(Duties, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn((VendorCost + Tariff + Duties + Shipping), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        TotalLandedvcost := (VendorCost + Tariff + Duties + Shipping) * SalesInvoiceLineInv.Quantity;
                        ExcelBuf.AddColumn(TotalLandedvcost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(SalesInvoiceLineInv."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        CalcCost(SalesInvoiceLineInv."Document No.", SalesInvoiceLineInv."Line No.", SalesInvoiceLineInv."Linked SO Line No.", SalesInvoiceLineInv.Quantity);
                        ExcelBuf.AddColumn(Tariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(SalesInvoiceLineInv."Unit Price" + Tariff + shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(SalesInvoiceLineInv.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        TotalSalesAmount := (SalesInvoiceLineInv."Unit Price" + Tariff + shipping) * SalesInvoiceLineInv.Quantity;
                        ExcelBuf.AddColumn(TotalSalesAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        lCommissionable := SalesInvoiceLineInv."Unit Price" * SalesInvoiceLineInv.Quantity;
                        ExcelBuf.AddColumn(lCommissionable, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        if ((SalesInvoiceLineInv."Unit Price" + Tariff + shipping) * SalesInvoiceLineInv.Quantity) <> 0 then
                            lMargingPct := ((TotalSalesAmount - TotalLandedvcost) / TotalSalesAmount) * 100
                        else
                            lMargingPct := 0;

                        ExcelBuf.AddColumn(lMargingPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        CalculateComissionAndPerct(SInvHeader."Salesperson Code", SalesInvoiceLineInv."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLineInv."Item Category Code");

                        //++
                        ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        //--
                        lCommissionPct := 0;
                        lCommissionAmt := 0;
                        CalculateComissionAndPerct(SInvHeader."Internal Team", SalesInvoiceLineInv."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLineInv."Item Category Code");

                        //++
                        ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        //--
                        //--
                        lCommissionPct := 0;
                        lCommissionAmt := 0;
                        CalculateComissionAndPerct(SInvHeader."External Rep", SalesInvoiceLineInv."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLineInv."Item Category Code");

                        //++
                        ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        //--
                    end;

                end;

            }


            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", StartDate, EndDate);
            end;
        }

        dataitem("CustLedgerEntryPayment"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.") order(ascending) where("Document Type" = const(Payment));
            // RequestFilterFields = "Posting Date";
            DATAITEM("DetailedCustLedgEntry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = CustLedgerEntryPayment;
                DataItemLink = "Closed By Entry No." = FIELD("Entry No.");
                DataItemTableView = sorting("Entry No.") order(ascending) where("Document Type" = const(Invoice));
                CalcFields = Amount;
                DATAITEM("SalesInvoiceLinePay"; "Sales Invoice Line")
                {
                    DataItemLinkReference = "DetailedCustLedgEntry";
                    DataItemLink = "Document No." = FIELD("Document No.");
                    DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item));
                    trigger OnAfterGetRecord()
                    var
                        SInvHeader: Record "Sales Invoice Header";
                        RecSperson: Record "Salesperson/Purchaser";
                        RecItem: Record Item;
                        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
                        ItmTrMgmt: Codeunit "Item Tracking Doc. Management";
                        TotalLandedvcost, TotalSalesAmount : Decimal;
                    begin
                        if RecITem.GET(SalesInvoiceLinePay."No.") then;
                        if RecItem.Type <> RecItem.Type::"Inventory" then CurrReport.Skip();
                        if SalesInvoiceLinePay.Quantity = 0 then CurrReport.Skip();
                        if (SalesInvoiceLinePay."Posting Date" > StartDate) and (SalesInvoiceLinePay."Posting Date" < EndDate) then
                            CurrReport.Skip();
                        ItmTrMgmt.RetrieveEntriesFromPostedInvoice(TempItemLedgEntry, SalesInvoiceLinePay.RowID1());
                        if TempItemLedgEntry.FindSet() then begin
                            repeat

                                Clear(SInvHeader);
                                SInvHeader.GET(SalesInvoiceLinePay."Document No.");
                                ExcelBuf.NewRow;
                                ExcelBuf.AddColumn(DetailedCustLedgEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(DetailedCustLedgEntry."Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(DetailedCustLedgEntry."Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(SInvHeader."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                if RecSperson.Get(SInvHeader."Salesperson Code") then;
                                ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(SInvHeader."External Rep", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                if RecSperson.Get(SInvHeader."External Rep") then;
                                ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                if RecSperson.Get(SInvHeader."Internal Team") then;
                                ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(SInvHeader."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(SInvHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(CustLedgerEntryPayment."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(CustLedgerEntryPayment."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                if DetailedCustLedgEntry.Open then
                                    ExcelBuf.AddColumn('Unpaid', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                                else
                                    ExcelBuf.AddColumn('Paid', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                if RecItem.GET(SalesInvoiceLinePay."No.") then;
                                ExcelBuf.AddColumn(RecItem."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(RecItem."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                                ExcelBuf.AddColumn(TempItemLedgEntry."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                                CalcCOstBasedONTrackingLine(SalesInvoiceLinePay."Document No.", SalesInvoiceLinePay."Line No.", SalesInvoiceLinePay."No.", TempItemLedgEntry.Quantity, SalesInvoiceLinePay.RowID1(), TempItemLedgEntry."Lot No.");
                                //CalcCost(SalesInvoiceLinePay."Document No.", SalesInvoiceLinePay."Line No.", SalesInvoiceLinePay."No.", SalesInvoiceLinePay.Quantity);
                                ExcelBuf.AddColumn(VendorCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(Tariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(Duties, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(VendorCost + Tariff + Duties + Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                TotalLandedvcost := (VendorCost + Tariff + Duties + Shipping) * TempItemLedgEntry.Quantity;

                                ExcelBuf.AddColumn(TotalLandedvcost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(SalesInvoiceLinePay."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                CalcCost(SalesInvoiceLinePay."Document No.", SalesInvoiceLinePay."Line No.", SalesInvoiceLinePay."Linked SO Line No.", TempItemLedgEntry.Quantity);
                                ExcelBuf.AddColumn(Tariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(SalesInvoiceLinePay."Unit Price" + Tariff + shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(TempItemLedgEntry.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                TotalSalesAmount := (SalesInvoiceLinePay."Unit Price" + Tariff + shipping) * TempItemLedgEntry.Quantity;
                                ExcelBuf.AddColumn(TotalSalesAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                lCommissionable := SalesInvoiceLinePay."Unit Price" * TempItemLedgEntry.Quantity;
                                ExcelBuf.AddColumn(lCommissionable, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                if TotalSalesAmount <> 0 then
                                    lMargingPct := ((TotalSalesAmount - TotalLandedvcost) / TotalSalesAmount) * 100
                                else
                                    lMargingPct := 0;


                                ExcelBuf.AddColumn(lMargingPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                CalculateComissionAndPerct(SInvHeader."Salesperson Code", SalesInvoiceLinePay."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLinePay."Item Category Code");

                                //++
                                ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                                lCommissionPct := 0;
                                lCommissionAmt := 0;
                                CalculateComissionAndPerct(SInvHeader."Internal Team", SalesInvoiceLinePay."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLinePay."Item Category Code");

                                //++
                                ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                                lCommissionPct := 0;
                                lCommissionAmt := 0;
                                CalculateComissionAndPerct(SInvHeader."External Rep", SalesInvoiceLinePay."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLinePay."Item Category Code");

                                //++
                                ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                                ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                            until TempItemLedgEntry.Next() = 0;
                        end else begin
                            Clear(SInvHeader);
                            SInvHeader.GET(SalesInvoiceLinePay."Document No.");
                            ExcelBuf.NewRow;
                            ExcelBuf.AddColumn(DetailedCustLedgEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(DetailedCustLedgEntry."Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(DetailedCustLedgEntry."Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(SInvHeader."Salesperson Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if RecSperson.Get(SInvHeader."Salesperson Code") then;
                            ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(SInvHeader."External Rep", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if RecSperson.Get(SInvHeader."External Rep") then;
                            ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if RecSperson.Get(SInvHeader."Internal Team") then;
                            ExcelBuf.AddColumn(RecSperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(SInvHeader."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(SInvHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(CustLedgerEntryPayment."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(CustLedgerEntryPayment."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if DetailedCustLedgEntry.Open then
                                ExcelBuf.AddColumn('Unpaid', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                            else
                                ExcelBuf.AddColumn('Paid', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            if RecItem.GET(SalesInvoiceLinePay."No.") then;
                            ExcelBuf.AddColumn(RecItem."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(RecItem."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            CalcCOstBasedONTrackingLine(SalesInvoiceLinePay."Document No.", SalesInvoiceLinePay."Line No.", SalesInvoiceLinePay."No.", SalesInvoiceLinePay.Quantity, SalesInvoiceLinePay.RowID1(), '');
                            //CalcCost(SalesInvoiceLinePay."Document No.", SalesInvoiceLinePay."Line No.", SalesInvoiceLinePay."No.", SalesInvoiceLinePay.Quantity);
                            ExcelBuf.AddColumn(VendorCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(Tariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(Duties, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(VendorCost + Tariff + Duties + Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            TotalLandedvcost := (VendorCost + Tariff + Duties + Shipping) * SalesInvoiceLinePay.Quantity;

                            ExcelBuf.AddColumn(TotalLandedvcost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(SalesInvoiceLinePay."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            CalcCost(SalesInvoiceLinePay."Document No.", SalesInvoiceLinePay."Line No.", SalesInvoiceLinePay."Linked SO Line No.", SalesInvoiceLinePay.Quantity);
                            ExcelBuf.AddColumn(Tariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(Shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(SalesInvoiceLinePay."Unit Price" + Tariff + shipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(SalesInvoiceLinePay.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            TotalSalesAmount := (SalesInvoiceLinePay."Unit Price" + Tariff + shipping) * SalesInvoiceLinePay.Quantity;

                            ExcelBuf.AddColumn(TotalSalesAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            lCommissionable := SalesInvoiceLinePay."Unit Price" * SalesInvoiceLinePay.Quantity;
                            ExcelBuf.AddColumn(lCommissionable, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            if TotalSalesAmount <> 0 then
                                lMargingPct := ((TotalSalesAmount - TotalLandedvcost) / TotalSalesAmount) * 100
                            else
                                lMargingPct := 0;


                            ExcelBuf.AddColumn(lMargingPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            CalculateComissionAndPerct(SInvHeader."Salesperson Code", SalesInvoiceLinePay."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLinePay."Item Category Code");

                            //++
                            ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                            lCommissionPct := 0;
                            lCommissionAmt := 0;
                            CalculateComissionAndPerct(SInvHeader."Internal Team", SalesInvoiceLinePay."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLinePay."Item Category Code");

                            //++
                            ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                            lCommissionPct := 0;
                            lCommissionAmt := 0;
                            CalculateComissionAndPerct(SInvHeader."External Rep", SalesInvoiceLinePay."No.", SInvHeader."Posting Date", lMargingPct, SalesInvoiceLinePay."Item Category Code");

                            //++
                            ExcelBuf.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            //ExcelBuf.AddColumn(GetTeamCOmmission(SInvHeader."Internal Team", lMargingPct), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        end;

                        //--
                    end;
                }
            }

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", StartDate, EndDate);
            end;
        }
        /*dataitem("CustLedgerEntryCrMemo"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.") order(ascending) where("Document Type" = const("Credit Memo"));
            // RequestFilterFields = "Posting Date";

            DATAITEM("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = "CustLedgerEntryCrMemo";
                DataItemLink = "Document No." = FIELD("Document No.");
            }


            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", StartDate, EndDate);
            end;
        }*/
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
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            // if CloseAction In [Action::OK, Action::LookupOK, CloseAction::Yes] then begin
            // end;
        end;

        trigger OnOpenPage()
        begin
            if (StartDate = 0D) and (EndDate = 0D) then
                EndDate := WorkDate();
        end;
    }
    local procedure GetTeamCOmmission(salespersoncode: code[20]; MargingPer: Decimal): Decimal
    var
        SalespersonCommision: Record "Salesperson Commission";
    begin
        Clear(SalespersonCommision);
        SalespersonCommision.SetRange("Salesperson Code", Salespersoncode);
        SalespersonCommision.SetRange(Type, SalespersonCommision.Type::All);
        SalespersonCommision.SetFilter("From Margin %", '<=%1', MargingPer);
        SalespersonCommision.SetFilter("To Margin %", '>=%1', MargingPer);
        if SalespersonCommision.FindFirst() then
            exit(SalespersonCommision."Commission %")
        else
            exit(0);
    end;

    local procedure CalcCostBasedOnTrackingLine(DocNumber: code[20]; LineN: Integer; Item: code[20]; Qty: Decimal; ROwID: Text[250]; LotN: code[20])
    var
        RecIle: Record "Item Ledger Entry";
        RecValueEntry2: Record "Value Entry";
    begin
        Tariff := 0;
        Duties := 0;
        Shipping := 0;
        VendorCost := 0;
        // ItmTrMgmt.RetrieveEntriesFromPostedInvoice(TempItemLedgEntry, ROwID);
        if LotN <> '' then begin

            Clear(RecIle);
            RecIle.SetFilter("Entry Type", '%1|%2', RecIle."Entry Type"::Purchase, RecIle."Entry Type"::"Positive Adjmt.");
            RecIle.SetRange("Item No.", Item);
            RecIle.SetRange("Lot No.", LotN);
            if RecIle.FindLast() then begin
                if RecIle."Entry Type" = RecIle."Entry Type"::Purchase then begin
                    Clear(RecValueEntry2);
                    RecValueEntry2.SETRANGE("Item Ledger Entry No.", RecIle."Entry No.");
                    IF RecValueEntry2.FINDSET THEN begin
                        REPEAT
                            IF RecValueEntry2."Item Charge No." = 'TARIFF' THEN
                                Tariff += ((RecValueEntry2."Cost Amount (Actual)") / RecIle.Quantity)// * Qty
                            ELSE
                                IF RecValueEntry2."Item Charge No." = 'CUSTOM-DUTY' THEN
                                    Duties += ((RecValueEntry2."Cost Amount (Actual)") / RecIle.Quantity) //* Qty
                                ELSE
                                    IF RecValueEntry2."Item Charge No." = 'FREIGHT' THEN
                                        Shipping += ((RecValueEntry2."Cost Amount (Actual)") / RecIle.Quantity) //* Qty;
                                    else
                                        IF RecValueEntry2."Item Charge No." = '' THEN
                                            VendorCost += ((RecValueEntry2."Cost Amount (Actual)") / RecIle.Quantity) //* Qty;

                        UNTIL RecValueEntry2.NEXT = 0;
                    end;
                end else begin
                    RecIle.CalcFields("Cost Amount (Actual)");
                    VendorCost := RecIle."Cost Amount (Actual)" / RecIle."Quantity"
                end;

            end;

        end else begin

            Clear(RecValueEntry2);
            RecValueEntry2.SETRANGE("Document No.", DocNumber);
            RecValueEntry2.SetRange("Document Line No.", LineN);
            RecValueEntry2.SetRange(Adjustment, false);
            RecValueEntry2.SETFILTER("Item Ledger Entry Type", '=%1', RecValueEntry2."Item Ledger Entry Type"::Sale);
            IF RecValueEntry2.FINDFIRST THEN begin
                Clear(RecIle);
                RecIle.SetRange("Entry No.", RecValueEntry2."Item Ledger Entry No.");
                if RecIle.FindFirst() then begin
                    RecIle.CalcFields("Cost Amount (Actual)");
                    VendorCost := RecIle."Cost Amount (Actual)" / RecIle."Quantity"
                end;
            end;
        end;
    end;

    local procedure CalcCost(DocNumber: code[20]; LineN: Integer; LinkedItem: Integer; Qty: Decimal)
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        Tariff := 0;
        Duties := 0;
        Shipping := 0;
        VendorCost := 0;

        Clear(SalesInvLine);
        SalesInvLine.SetRange("Document No.", DocNumber);
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetRange("Linked SO Line No.", LineN);
        if SalesInvLine.FindSet() then begin
            REPEAT
                IF SalesInvLine."Gen. Prod. Posting Group" = 'TARIFF' THEN
                    Tariff += (SalesInvLine."Amount Including VAT" / SalesInvLine.Quantity)// * Qty
                ELSE
                    IF SalesInvLine."Gen. Prod. Posting Group" = 'SHIPPING' THEN
                        Shipping += (SalesInvLine."Amount Including VAT" / SalesInvLine.Quantity)// * Qty;

            UNTIL SalesInvLine.NEXT = 0;
        end;
    end;

    trigger OnPreReport()
    begin

        MakeExcelDataHeader();
        if (StartDate = 0D) and (EndDate = 0D) then
            EndDate := WorkDate();


    end;

    trigger OnPostReport()
    begin

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




    local procedure MakeExcelDataHeader()
    begin
        Clear(CheckList);
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Filter', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('From Date', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StartDate, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('To Date', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(EndDate, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('Customer No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Salesperson', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Salesperson Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('External Rep', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('External Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Team Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('External Document No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Payment Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Paid/Unpaid', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Category', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Part No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Lot No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Vendor Cost', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Tariff', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Duties', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Shipping', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Landed Cost per Unit', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Total Landed Cost', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Sell Price', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Tariffs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Shipping', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Total Selling Price', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Total Pieces', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Total Sales Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Commisionable', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Margin %', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Sales Rep.(Rep Group) commission %', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Commission', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Sales Manager Comission %', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Sales Manager Commission', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('External Rep Comission %', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('External Rep Commission', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
    END;

    local procedure CreateExcelbook()
    begin
        ExcelBuf.CreateNewBook(ReportName);
        ExcelBuf.WriteSheet(ReportName, COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        // ExcelBuf.OpenExcel();
        DownloadExcelFile('ComissionReport_' + DelChr(FORMAT(CurrentDateTime), '=', '.:/\-AMPM') + '.xlsx');
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

    local procedure CalculateComissionAndPerct(Salespersoncode: code[20]; PartNumber: code[20]; PostingDate: Date; MargingPer: Decimal; ProdCat: Code[20])
    var
        SalespersonCommision: Record "Salesperson Commission";
    begin
        Clear(SalespersonCommision);
        SalespersonCommision.SetRange("Salesperson Code", Salespersoncode);
        SalespersonCommision.SetRange(Type, SalespersonCommision.Type::Item);
        SalespersonCommision.SetRange(Code, PartNumber);
        SalespersonCommision.SetFilter("From Date", '<=%1', PostingDate);
        SalespersonCommision.SetFilter("To Date", '>=%1', PostingDate);
        SalespersonCommision.SetFilter("From Margin %", '<=%1', MargingPer);
        SalespersonCommision.SetFilter("To Margin %", '>=%1', MargingPer);
        if SalespersonCommision.FindFirst() then
            lCommissionPct := SalespersonCommision."Commission %"
        else begin
            Clear(SalespersonCommision);
            SalespersonCommision.SetRange("Salesperson Code", Salespersoncode);
            SalespersonCommision.SetRange(Type, SalespersonCommision.Type::"Item Category");
            SalespersonCommision.SetRange(Code, ProdCat);
            SalespersonCommision.SetFilter("From Margin %", '<=%1', MargingPer);
            SalespersonCommision.SetFilter("To Margin %", '>=%1', MargingPer);
            if SalespersonCommision.FindFirst() then
                lCommissionPct := SalespersonCommision."Commission %"
            else begin
                Clear(SalespersonCommision);
                SalespersonCommision.SetRange("Salesperson Code", Salespersoncode);
                SalespersonCommision.SetRange(Type, SalespersonCommision.Type::All);
                SalespersonCommision.SetFilter("From Margin %", '<=%1', MargingPer);
                SalespersonCommision.SetFilter("To Margin %", '>=%1', MargingPer);
                if SalespersonCommision.FindFirst() then
                    lCommissionPct := SalespersonCommision."Commission %"
            end;
        end;

        lCommissionAmt := (lCommissionable * lCommissionPct) / 100;
    end;

    var

        CheckList: List of [Text];
        ExcelBuf: Record "Excel Buffer" temporary;
        ReportName: Label 'Commission Report';
        FileInStream: OutStream;
        StartDate: Date;
        EndDate: Date;
        CompanyInfo: Record "Company Information";
        Tariff, Duties, Shipping, VendorCost, lCommissionable, lCommissionPct, lCommissionAmt, lMargingPct : Decimal;

}

