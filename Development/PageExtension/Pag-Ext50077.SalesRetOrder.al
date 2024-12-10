pageextension 50077 SalesRetOrder extends "Sales Return Order"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                Caption = 'Reason Code';
                ApplicationArea = All;
            }
        }
        modify("Your Reference")
        {
            Caption = 'RMA No.';
        }
    }
}

