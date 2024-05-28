table 50017 SSR
{
    Caption = 'SSR';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Current; Decimal)
        {
            Caption = 'Current';
        }
        field(2; "Output voltage"; Decimal)
        {
            Caption = 'Output voltage';
        }
        field(3; "Control "; Enum Control_Option)
        {
            Caption = 'Control ';
        }
        field(4; "Type "; Enum Type_Option)
        {
            Caption = 'Type ';
        }
        field(5; "Mounting "; Enum Mounting_Option)
        {
            Caption = 'Mounting ';
        }
        field(6; "No of Phases"; Enum "No of Phases_Option")
        {
            Caption = 'No of Phases';
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
