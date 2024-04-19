table 50022 "Voltage Monitors"
{
    Caption = 'Voltage Monitors';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Supply Voltage"; Code[20])
        {
            Caption = 'Supply Voltage';
        }
        field(2; "Phase Asymmetry"; Code[20])
        {
            Caption = 'Phase Asymmetry';
        }
        field(3; "Over Voltage"; Code[20])
        {
            Caption = 'Over Voltage';
        }
        field(4; "Under Voltage"; Code[20])
        {
            Caption = 'Under Voltage';
        }
        field(5; "Delay Type (ON/OFF)"; Code[20])
        {
            Caption = 'Delay Type (ON/OFF)';
        }
        field(6; "Power (ON/OFF) Delay"; Code[20])
        {
            Caption = 'Power (ON/OFF) Delay';
        }
        field(7; "Delay from Phase Fault"; Text[30])
        {
            Caption = 'Delay from Phase Fault';
        }
        field(8; "Special Requests"; Text[30])
        {
            Caption = 'Special Requests';
        }
    }
    keys
    {
        key(PK; "Supply Voltage")
        {
            Clustered = true;
        }
    }
}
