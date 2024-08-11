report 50021 "Populate Bin Code"
{
    ApplicationArea = All;
    Caption = 'Populate Bin Code';
    UsageCategory = ReportsAndAnalysis;
    UseRequestPage = true;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.") order(ascending) where(Blocked = filter(false), "Bin Content Exist" = filter(false));
            CalcFields = "Bin Content Exist", "Bin Exist";
            trigger OnPreDataItem()
            var
                CustomerRec: Record Customer;
                LocationRec: Record Location;
                BinRec: Record Bin;
            begin
                Clear(BinRec);
                Clear(CustomerRec);
                CustomerRec.SetRange("Bin Exist", false);
                if CustomerRec.FindFirst() then
                    repeat
                        LocationRec.Reset();
                        LocationRec.SetRange("Use As In-Transit", false);
                        if LocationRec.FindFirst() then
                            repeat
                                BinRec.SetRange("Location Code", LocationRec.Code);
                                BinRec.SetRange(Code, CustomerRec."No.");
                                if not BinRec.FindFirst() then begin
                                    BinRec.Init();
                                    BinRec."Location Code" := LocationRec.Code;
                                    BinRec.Code := CustomerRec."No.";
                                    BinRec.Description := CustomerRec.Name;
                                    BinRec.Insert()
                                end;
                            until LocationRec.Next() = 0;
                    until CustomerRec.Next() = 0;
                Commit();
            end;

            trigger OnPostDataItem()
            begin
                Commit();
            end;

            trigger OnAfterGetRecord()
            var
                BinContent: Record "Bin Content";
                ItemRec: Record Item;
                CustomerRec: Record Customer;
                LocationRec: Record Location;
            begin
                Clear(BinContent);
                BinContent.SetCurrentKey("Bin Code");
                BinContent.SetRange("Bin Code", Customer."No.");
                ItemRec.SetRange(Type, ItemRec.Type::Inventory);
                ItemRec.SetRange(Blocked, false);
                if ItemRec.FindFirst() then
                    repeat
                        BinContent.SetRange("Item No.", ItemRec."No.");
                        LocationRec.SetRange("Use As In-Transit", false);
                        if LocationRec.FindFirst() then
                            repeat
                                BinContent.SetRange("Location Code", LocationRec.Code);
                                if not BinContent.FindFirst() then begin
                                    BinContent.Init();
                                    BinContent.Validate("Location Code", LocationRec.Code);
                                    BinContent.Validate("Item No.", ItemRec."No.");
                                    BinContent.Validate("Bin Code", Customer."No.");
                                    BinContent.Validate(Fixed, true);
                                    BinContent.Insert();
                                end;
                                RecCount += 1;
                                if GuiAllowed then begin
                                    DialogBox.UPDATE(1, RecCount);
                                end;
                            until LocationRec.Next() = 0;
                    until ItemRec.Next() = 0;
            end;
        }
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") order(ascending) where(Type = const(Inventory), Blocked = filter(false), "Bin Content Exist" = filter(false));
            CalcFields = "Bin Content Exist";
            trigger OnPostDataItem()
            begin
                Commit();
            end;

            trigger OnAfterGetRecord()
            var
                BinContent: Record "Bin Content";
                ItemRec: Record Item;
                CustomerRec: Record Customer;
                LocationRec: Record Location;
            begin
                Clear(BinContent);
                BinContent.SetCurrentKey("Item No.");
                BinContent.SetRange("Item No.", Item."No.");
                if CustomerRec.FindFirst() then
                    repeat
                        BinContent.SetRange("Bin Code", CustomerRec."No.");
                        LocationRec.SetRange("Use As In-Transit", false);
                        if LocationRec.FindFirst() then
                            repeat
                                BinContent.SetRange("Location Code", LocationRec.Code);
                                if not BinContent.FindFirst() then begin
                                    BinContent.Init();
                                    BinContent.Validate("Location Code", LocationRec.Code);
                                    BinContent.Validate("Item No.", Item."No.");
                                    BinContent.Validate("Bin Code", CustomerRec."No.");
                                    BinContent.Validate(Fixed, true);
                                    BinContent.Insert();
                                end;
                                RecCount += 1;
                                if GuiAllowed then begin
                                    DialogBox.UPDATE(1, RecCount);
                                end;
                            until LocationRec.Next() = 0;
                    until CustomerRec.Next() = 0;
            end;
        }
        dataitem(Location; Location)
        {
            DataItemTableView = sorting(Code) order(ascending) where("Use As In-Transit" = filter(false), "Bin Content Exist" = filter(false));
            CalcFields = "Bin Content Exist";
            trigger OnPostDataItem()
            begin
                Commit();
            end;

            trigger OnAfterGetRecord()
            var
                BinContent: Record "Bin Content";
                ItemRec: Record Item;
                CustomerRec: Record Customer;
                LocationRec: Record Location;
            begin
                Clear(BinContent);
                BinContent.SetCurrentKey("Location Code", "Bin Code", "Item No.");
                BinContent.SetRange("Location Code", Location.Code);
                if CustomerRec.FindFirst() then
                    repeat
                        BinContent.SetRange("Bin Code", CustomerRec."No.");
                        ItemRec.SetRange(Type, ItemRec.Type::Inventory);
                        ItemRec.SetRange(Blocked, false);
                        if ItemRec.FindFirst() then
                            repeat
                                BinContent.SetRange("Item No.", ItemRec."No.");
                                if not BinContent.FindFirst() then begin
                                    BinContent.Init();
                                    BinContent.Validate("Location Code", Location.Code);
                                    BinContent.Validate("Item No.", ItemRec."No.");
                                    BinContent.Validate("Bin Code", CustomerRec."No.");
                                    BinContent.Validate(Fixed, true);
                                    BinContent.Insert();
                                end;
                                RecCount += 1;
                                if GuiAllowed then begin
                                    DialogBox.UPDATE(1, RecCount);
                                end;
                            until ItemRec.Next() = 0;
                    until CustomerRec.Next() = 0;
            end;
        }
    }
    trigger OnPreReport()
    begin
        if GuiAllowed then begin
            if not Confirm('Do you want to update Location Wise Bin Code in all Items?', false) then begin
                CurrReport.Quit();
                exit;
            end;
        end;

        RecCount := 0;
        if GuiAllowed then begin
            DialogBox.OPEN(tcProgress);
        end;
    end;

    trigger OnPostReport()
    begin
        if GuiAllowed then begin
            DialogBox.Close();
            Message('All Location wise Bins have been populated in Item successfully.\Total No. of Records retrieved %1', RecCount);
        end;
    end;

    var
        DialogBox: Dialog;
        RecCount: Integer;
        tcProgress: Label 'Updating Records #1';
}
