table 50005 "Shipping Port"
{
    Caption = 'Shipping Port';
    DataClassification = ToBeClassified;
    LookupPageId = "Shipping Port";
    DrillDownPageId = "Shipping Port";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
