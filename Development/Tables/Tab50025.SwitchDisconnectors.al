table 50025 "Switch Disconnectors"
{
    Caption = 'Switch Disconnectors';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Rated current"; Enum "Rated current_Option")
        {
            Caption = 'Rated current';
        }
        field(2; "Number of poles "; Enum "Number of poles_Option")
        {
            Caption = 'Number of poles ';
        }
        field(3; "Switch Type"; Enum "Switch Type_Option")
        {
            Caption = 'Switch Type';
        }
        field(4; "Switch Color"; Enum "Switch Color_Option")
        {
            Caption = 'Switch Color';
        }
        field(5; Mounting; Enum Mounting_Option)
        {
            Caption = 'Mounting';
        }
        field(6; "Special options"; Text[30])
        {
            Caption = 'Special options';
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
