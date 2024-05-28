table 50029 Specification
{
    Caption = 'Specification';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Specification; Code[30])
        {
            Caption = 'Specification';
        }
    }
    keys
    {
        key(PK; Specification)
        {
            Clustered = true;
        }
    }
}
