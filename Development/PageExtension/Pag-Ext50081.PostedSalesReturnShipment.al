pageextension 50081 PostedSalesReturnShipment extends "Posted Return Shipment"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                Caption = 'Reason Code';
                ApplicationArea = All;
            }
        }

    }
}

