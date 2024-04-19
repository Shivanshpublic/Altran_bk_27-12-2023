table 50024 "IEC Contactors"
{
    Caption = 'IEC Contactors';
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
        field(3; "Number of poles"; Enum "Number of poles_Option")
        {
            Caption = 'Number of poles';
        }
        field(4; Polarity; Enum Polarity_Option)
        {
            Caption = 'Polarity';
        }
        field(5; "Auxiliary contacts"; Enum "Auxiliary contacts_Option")
        {
            Caption = 'Auxiliary contacts';
        }
        field(6; Termination; Enum Termination_Option)
        {
            Caption = 'Termination';
        }
        field(7; "Special options"; Text[30])
        {
            Caption = 'Special options';
        }
    }
    keys
    {
        key(PK; "Rated current")
        {
            Clustered = true;
        }
    }
}
