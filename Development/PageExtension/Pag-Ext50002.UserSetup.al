pageextension 50002 UserSetup extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Edit Shipment Tracking"; Rec."Edit Shipment Tracking")
            {
                ApplicationArea = All;
            }
            field("Approve Shipment Tracking Log"; Rec."Approve Shipment Tracking Log")
            {
                ApplicationArea = All;
            }
            field("View Cost"; Rec."View Cost")
            {
                ApplicationArea = All;
            }
            field("Modify PO on SO"; Rec."Modify PO on SO")
            {
                ApplicationArea = All;
            }
        }
    }
}
