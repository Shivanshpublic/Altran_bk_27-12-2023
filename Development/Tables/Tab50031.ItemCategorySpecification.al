table 50031 "Item Category Specification"
{
    Caption = 'Item Category Specification';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ItemCategory; Code[20])
        {
            Caption = 'Item Category Code';
            Editable = false;
        }
        field(2; Specification; Code[30])
        {
            Caption = 'Specification';
        }
    }
    keys
    {
        key(PK; ItemCategory, Specification)
        {
            Clustered = true;
        }
    }
}
