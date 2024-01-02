table 50013 "Custom Setup"
{
    Caption = 'Custom Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(101; "Vessel URL"; Text[250])
        {
            Caption = 'Vessel URL';
        }
        field(102; "Vessel User Key"; Text[50])
        {
            Caption = 'Vessel User Key';
        }
        field(103; "Vessel Extra Data"; Text[100])
        {
            Caption = 'Vessel Extra Data';
        }
        field(104; "Vessel Interval"; Text[10])
        {
            Caption = 'Vessel Interval';
        }
        field(105; "Vessel locode"; Text[50])
        {
            Caption = 'Vessel locode';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var

}

