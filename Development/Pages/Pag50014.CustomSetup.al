page 50014 "Custom Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Custom Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,General,Posting,Journal Templates';
    SourceTable = "Custom Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Vessel URL"; Rec."Vessel URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value of Vessel URL field for Vessel Inegration.';
                }
                field("Vessel User Key"; Rec."Vessel User Key")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies value of Vessel User Key field for Vessel Inegration.';
                }
                field("Vessel Extra Data"; Rec."Vessel Extra Data")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value of Vessel Extra data field for Vessel Inegration.';
                }
                field("Vessel Interval"; Rec."Vessel Interval")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value of Vessel Interval field for Vessel Inegration.';
                }
                field("Vessel locode"; Rec."Vessel locode")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies value of Vessel locode field for Vessel Inegration.';
                }

            }
            group(Other)
            {
                Caption = 'Other';
            }

        }
    }


    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

    end;

    var
}

