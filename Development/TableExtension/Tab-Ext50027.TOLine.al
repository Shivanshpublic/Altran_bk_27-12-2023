tableextension 50027 TOLine extends "Transfer Line"
{
    fields
    {
        field(50014; "Shipment Tracking Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Header";
            Editable = false;
        }
    }
}
