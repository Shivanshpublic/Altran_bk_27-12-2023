pageextension 50076 SalesCrMemo extends "Sales Credit Memo"
{
    layout
    {
        addafter("External Document No.")
        {
            // field("Reason Code"; Rec."Reason Code")
            // {
            //     Caption = 'Reason Code';
            //     ApplicationArea = All;
            // }
        }
        modify("Your Reference")
        {
            Caption = 'RMA No.';
        }
    }
}

