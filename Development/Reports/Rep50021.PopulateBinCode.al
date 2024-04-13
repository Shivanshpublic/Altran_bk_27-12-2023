report 50021 "Populate Bin Code"
{
    ApplicationArea = All;
    Caption = 'Populate Bin Code';
    UsageCategory = ReportsAndAnalysis;
    UseRequestPage = true;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") order(ascending) where(Type = const(Inventory));
            dataitem(Location; Location)
            {
                DataItemTableView = sorting(Code) order(ascending);
                dataitem(Bin; Bin)
                {
                    DataItemLinkReference = Location;
                    DataItemTableView = sorting("Location Code", Code) order(ascending);
                    DataItemLink = "Location Code" = field(Code);
                    trigger OnAfterGetRecord()
                    var
                        BinContent: Record "Bin Content";
                    begin

                        Clear(BinContent);
                        BinContent.SetCurrentKey("Location Code", "Item No.");
                        BinContent.SetRange("Item No.", Item."No.");
                        BinContent.SetRange("Location Code", Location.Code);
                        BinContent.SetRange("Bin Code", Bin.Code);

                        if not BinContent.FindFirst() then begin
                            BinContent.Init();
                            BinContent.Validate("Location Code", Location.Code);
                            BinContent.Validate("Item No.", Item."No.");
                            BinContent.Validate("Bin Code", Bin.Code);
                            BinContent.Validate(Fixed, true);
                            BinContent.Insert();
                        end;
                        RecCount += 1;
                        DialogBox.UPDATE(1, RecCount);

                    end;
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        if not Confirm('Do you want to update Location Wise Bin Code in all Items?', false) then begin
            CurrReport.Quit();
            exit;
        end;
        RecCount := 0;
        DialogBox.OPEN(tcProgress);
    end;

    trigger OnPostReport()
    begin
        DialogBox.Close();
        Message('All Location wise Bins have been populated in Item successfully.\Total No. of Records retrieved %1', RecCount);
    end;

    var
        DialogBox: Dialog;
        RecCount: Integer;
        tcProgress: Label 'Updating Records #1';
}
