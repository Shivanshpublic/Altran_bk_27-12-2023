pageextension 50044 "TransferShipLinesSubPageExt" extends "Posted Transfer Shpt. Subform"
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
