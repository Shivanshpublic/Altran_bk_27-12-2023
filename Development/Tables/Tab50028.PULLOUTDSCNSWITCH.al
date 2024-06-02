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
        field(100; "Item Category Code"; code[20])
        {
            TableRelation = "Item Category";
            Editable = false;
        }
        field(101; "Item No."; code[20])
        {
            TableRelation = "Item";
            Editable = false;
        }

    }
    keys
    {
        key(Key1; "Item Category Code", "Item No.")
        {
            Clustered = true;
        }
    }
}
