table 50027 "Run Caps"
{
    Caption = 'Run Caps';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Capacitance; Code[20])
        {
            Caption = 'Capacitance';
        }
        field(2; "Single/Dual"; Enum "Single/Dual_Option")
        {
            Caption = 'Single/Dual';
        }
        field(3; "Capacitor Shape"; Enum "Capacitor Shape_Option")
        {
            Caption = 'Capacitor Shape';
        }
        field(4; "Operating Voltage"; Code[20])
        {
            Caption = 'Operating Voltage';
        }
        field(5; "Options Code"; Enum "Options Code_Option")
        {
            Caption = 'Options Code';
        }
        field(6; "Relative Class/Grade"; Enum "Relative Class/Grade_Option")
        {
            Caption = 'Relative Class/Grade';
        }

    }
    keys
    {
        key(PK; Capacitance)
        {
            Clustered = true;
        }
    }
}
