table 50026 "Start Capacitors"
{
    Caption = 'Start Capacitors';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum StartCapaType_Option)
        {
            Caption = 'Type';
        }
        field(2; Capacitance; Code[20])
        {
            Caption = 'Capacitance';
        }
        field(3; "Case ID"; Enum "StartCapaCase ID_Option")
        {
            Caption = 'Case ID';
        }
        field(4; "Voltage Rating"; Enum "StartCapaVoltage Rating_Option")
        {
            Caption = 'Voltage Rating';
        }
        field(5; "Terminal Code"; Enum "StartCapTerminalCode_Option")
        {
            Caption = 'Terminal Code';
        }
    }
    keys
    {
        key(PK; "Type")
        {
            Clustered = true;
        }
    }
}
