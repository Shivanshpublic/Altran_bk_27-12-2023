table 50015 Motors
{

    fields
    {
        field(1; "Size(mm)"; Decimal) { }
        field(2; "Voltage 1"; Enum Voltage1_Option) { }
        field(3; "Voltage 2"; Enum Voltage2_Option) { }
        field(4; "Voltage 3"; Enum Voltage3_Option) { }
        field(5; "HP 1"; Enum HP1_Option) { }
        field(6; "HP 2"; Enum HP2_Option) { }
        field(7; "HP 3"; Enum HP3_Option) { }
        field(8; "Frequency 1 (Hz)"; Enum Frequency_Option) { }
        field(9; "Frequency 2 (Hz)"; Enum Frequency_Option) { }
        field(10; "RPM 1"; Decimal) { }
        field(11; "RPM 2"; Decimal) { }
        field(12; "RPM 3"; Decimal) { }
        field(13; "RPM 4"; Decimal) { }
        field(14; "Amps 1"; Decimal) { }
        field(15; "Amps 2"; Decimal) { }
        field(16; "Amps 3"; Decimal) { }
        field(17; "Watts 1"; Decimal) { }
        field(18; "Watts 2"; Decimal) { }
        field(19; "Pole"; Enum Pole_Option) { }
        field(20; "ph"; Enum Ph_Option) { }
        field(21; "Insulation"; Enum Insulation_Option) { }
        field(22; "Bracket"; Enum Bracket_Option) { }
        field(23; "Enclosure"; Enum Enclosure_Option) { }
        field(24; "Protection"; Enum Protection_Option) { }
        field(25; "Start Cap (MFD)"; Enum StartCapMFD_Option) { }
        field(26; "Run Cap (MFD)"; Enum RunCapMFD_Option) { }
        field(27; "Rotation"; Enum Rotation_Option) { }
        field(28; "Torque (Nm)"; Decimal) { }
        field(29; "IP"; Enum IP_Option) { }
        field(30; "Shaft Di X Length (mm)"; Decimal) { }
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




        //field(5; "Size(mm)"; Decimal) { }
        // field(6; "Size(mm)"; Decimal) { }
        // field(7; "Size(mm)"; Decimal) { }
        // field(8; "Size(mm)"; Decimal) { }
        // field(9; "Size(mm)"; Decimal) { }
        // field(10; "Size(mm)"; Decimal) { }
        // field(11; "Size(mm)"; Decimal) { }
        // field(12; "Size(mm)"; Decimal) { }
        // field(13; "Size(mm)"; Decimal) { }
        // field(14; "Size(mm)"; Decimal) { }


    }

    keys
    {
        key(Key1; "Item Category Code", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var

}

