PAGEEXTENSION 50010 "Ext. Customer Card" EXTENDS "Customer Card"
{
    LAYOUT
    {
        ADDAFTER("Salesperson Code")
        {
            FIELD("Internal Team"; Rec."Internal Team")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            FIELD("External Rep"; Rec."External Rep")
            {
                ApplicationArea = All;
                //ShowMandatory = true;
            }
            FIELD("Assigned User ID"; Rec."Assigned User ID")
            {
                ApplicationArea = All;
            }
        }
        Modify("Salesperson Code")
        {
            ShowMandatory = true;
        }

        Modify(Address)
        {
            ShowMandatory = true;
        }
        Modify(City)
        {
            ShowMandatory = true;
        }
        Modify("Post Code")
        {
            ShowMandatory = true;
        }
        // Modify(County)
        // {
        //     ShowMandatory = true;
        // }
        Modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        Modify("Phone No.")
        {
            ShowMandatory = true;
        }
    }
}