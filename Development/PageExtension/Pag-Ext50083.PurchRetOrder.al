pageextension 50083 PurchRetOrder extends "Purchase Return Order"
{
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                Caption = 'Reason Code';
                ApplicationArea = All;
            }
        }

    }
}

