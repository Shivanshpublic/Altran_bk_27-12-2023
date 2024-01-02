pageextension 50043 "Transfer Lines Ext" extends "Transfer Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Description 21"; Rec."Description 2")
            {
                ApplicationArea = all;
                Caption = 'Model No.';
            }
            field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
