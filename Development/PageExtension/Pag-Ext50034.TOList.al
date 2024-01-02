pageextension 50034 "TOList" extends "Transfer Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
        }

    }
    var
        ShipmentTrackingCode: Code[20];

    procedure SetShipmentTrackingCode(ShipTrackCode: Code[20])
    begin
        ShipmentTrackingCode := ShipTrackCode;
    end;
}
