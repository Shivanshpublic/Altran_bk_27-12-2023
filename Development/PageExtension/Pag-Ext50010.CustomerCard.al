PAGEEXTENSION 50010 "Ext. Customer Card" EXTENDS "Customer Card"
{
    LAYOUT
    {
        ADDAFTER("Salesperson Code")
        {
            FIELD("Internal Team"; Rec."Internal Team")
            {
                ApplicationArea = All;
            }
            FIELD("External Rep"; Rec."External Rep")
            {
                ApplicationArea = All;
            }
            FIELD("Assigned User ID"; Rec."Assigned User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}