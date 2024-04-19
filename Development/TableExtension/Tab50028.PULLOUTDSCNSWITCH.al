table 50028 "PULLOUT-DSCN-SWITCH "
{
    Caption = 'PULLOUT-DSCN-SWITCH ';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Material; Enum Material_Option)
        {
            Caption = 'Material';
        }
        field(2; Fuse; Enum Fuse_Option)
        {
            Caption = 'Fuse';
        }
        field(3; "Rated Current"; Enum "PULLOUTRated Current_Option")
        {
            Caption = 'Rated Current';
        }
    }
    keys
    {
        key(PK; Material)
        {
            Clustered = true;
        }
    }
}
