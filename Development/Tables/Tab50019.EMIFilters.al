table 50019 "EMI Filters"
{
    Caption = 'EMI Filters';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type "; Enum EMIType_Option)
        {
            Caption = 'Type ';
        }
        field(2; Voltage; Enum EMIVoltage_Option)
        {
            Caption = 'Voltage';
        }
        field(3; Current; Text[30])
        {
            Caption = 'Current';
        }
        field(4; Leakage; Text[30])
        {
            Caption = 'Leakage';
        }
        field(5; Inductance; Text[30])
        {
            Caption = 'Inductance';
        }
        field(6; "Capacitance (Cx)"; Text[30])
        {
            Caption = 'Capacitance (Cx)';
        }
        field(7; "Capacitance (Cy)"; Text[30])
        {
            Caption = 'Capacitance (Cy)';
        }
        field(8; Resistor; Text[30])
        {
            Caption = 'Resistor';
        }
        field(9; Termination; Enum EMITermination_Option)
        {
            Caption = 'Termination';
        }

    }
    keys
    {
        key(PK; "Type ")
        {
            Clustered = true;
        }
    }
}
