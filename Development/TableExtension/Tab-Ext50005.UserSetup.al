tableextension 50005 UserSetup extends "User Setup"
{
    fields
    {
        field(50000; "Edit Shipment Tracking"; Boolean)
        {
            Caption = 'Allow to Edit Shipment Tracking';
            DataClassification = ToBeClassified;
        }
        field(50001; "Approve Shipment Tracking Log"; Boolean)
        {
            Caption = 'Approve Shipment Tracking Log';
            DataClassification = ToBeClassified;
        }
        field(50002; "View Cost"; Boolean)
        {
            Caption = 'View Cost';
            DataClassification = ToBeClassified;
        }
        field(50003; "Modify PO on SO"; Boolean)
        {
            Caption = 'Modify PO on SO';
            DataClassification = ToBeClassified;
        }
    }
}
