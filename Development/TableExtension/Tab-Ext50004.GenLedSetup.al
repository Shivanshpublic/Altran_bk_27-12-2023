tableextension 50004 GenLedSetup extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Shipment Tracking Nos."; Code[10])
        {
            Caption = 'Shipment Tracking Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}
