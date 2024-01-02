PAGE 50005 "Sales Commission Entry"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sales Commission Entry";
    Editable = FALSE;
    DeleteAllowed = FALSE;

    LAYOUT
    {
        AREA(Content)
        {
            REPEATER(GroupName)
            {
                FIELD("Salesperson Code"; Rec."Salesperson Code") { ApplicationArea = All; }
                FIELD("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                FIELD("Document No."; Rec."Document No.") { ApplicationArea = All; }
                FIELD("Internal Team"; Rec."Internal Team") { ApplicationArea = All; }
                FIELD("External Team"; Rec."External Team") { ApplicationArea = All; }
                FIELD("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                FIELD("Gross Margin %"; Rec."Gross Margin %") { ApplicationArea = All; }
                FIELD("Commission %"; Rec."Commission %") { ApplicationArea = All; }
                FIELD("Document Amount"; Rec."Document Amount") { ApplicationArea = All; }
                FIELD("Commission Amount"; Rec."Commission Amount") { ApplicationArea = All; }
            }
        }
    }

    ACTIONS
    {
        AREA(Processing)
        {
            ACTION("Calculate Commission")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = TRUE;
                PromotedCategory = Process;

                TRIGGER OnAction();
                BEGIN

                END;
            }
        }
    }
}