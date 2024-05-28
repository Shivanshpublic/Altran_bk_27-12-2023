table 50018 DP
{
    Caption = 'DP';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Rated current"; Enum "Rated current_Option")
        {
            Caption = 'Rated current';
        }
        field(2; "Coil voltage"; Enum "Coil voltage_Option")
        {
            Caption = 'Coil voltage';
        }
        field(3; "Number of poles "; Enum "Number of poles_Option")
        {
            Caption = 'Number of poles ';
        }
        field(4; Termination; Text[20])
        {
            Caption = 'Termination';
        }
        field(5; "Special options"; Enum "Special options_Option")
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
