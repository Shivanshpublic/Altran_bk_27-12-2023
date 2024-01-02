pageextension 50022 SalesSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Surcharge Limit"; Rec."Surcharge Limit")
            {
                ApplicationArea = All;
            }
            field("Un earned surcharge account"; Rec."Un earned surcharge account")
            {
                ApplicationArea = All;
            }
            field("Earned surcharge account"; Rec."Earned surcharge account")
            {
                ApplicationArea = All;
            }
        }
    }
}
