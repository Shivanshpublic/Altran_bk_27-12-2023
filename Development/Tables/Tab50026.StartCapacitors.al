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
