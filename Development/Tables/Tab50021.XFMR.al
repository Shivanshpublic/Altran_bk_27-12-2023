table 50021 XFMR
{
    Caption = 'XFMR';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Primary/Secondary Voltage"; Code[20])
        {
            Caption = 'Primary/Secondary Voltage';
        }
        field(2; "Core Rating"; Code[20])
        {
            Caption = 'Core Rating';
        }
        field(3; Frequency; Code[20])
        {
            Caption = 'Frequency';
        }
        field(4; "Core Size"; Code[20])
        {
            Caption = 'Core Size';
        }
        field(5; Protection; Code[20])
        {
            Caption = 'Protection';
        }
        field(6; Termination; Text[30])
        {
            Caption = 'Termination';
        }
        field(7; Mounting; Text[30])
        {
            Caption = 'Mounting';
        }
        field(8; Packaging; Code[20])
        {
            Caption = 'Packaging';
        }
        field(9; "Special Requests"; Text[30])
        {
            Caption = 'Special Requests';
        }
    }
    keys
    {
        key(PK; "Primary/Secondary Voltage")
        {
            Clustered = true;
        }
    }
}
