table 50030 "Specification Values"
{
    Caption = 'Specification Values';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Specification; Code[30])
        {
            Caption = 'Specification';
            Editable = false;
        }
        field(2; "Value"; Code[30])
        {
            Caption = 'Value';
        }
    }
    keys
    {
        key(PK; Specification, "Value")
        {
            Clustered = true;
        }
    }
}
