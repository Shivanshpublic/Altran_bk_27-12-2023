table 50020 "Circuit Breakers"
{
    Caption = 'Circuit Breakers';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Rated current"; Enum "CircuitRated current_Option")
        {
            Caption = 'Rated current';
        }
        field(2; "Number of poles "; Enum "CircuitNumber of poles_Option ")
        {
            Caption = 'Number of poles ';
        }
        field(3; Termination; Enum Termination_Option)
        {
            Caption = 'Termination';
        }
        field(4; Voltage; Enum CircuitVoltage_Option)
        {
            Caption = 'Voltage';
        }
        field(5; "Rated Breaking Capacity"; Enum "CircuitRated Breaking Capacity")
        {
            Caption = 'Rated Breaking Capacity';
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
