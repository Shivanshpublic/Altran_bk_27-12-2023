table 50023 Relays
{
    Caption = 'Relays';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Series; Enum Series_Option)
        {
            Caption = 'Series';
        }
        field(2; "Contact Form"; Enum "Contact Form_Option")
        {
            Caption = 'Contact Form';
        }
        field(3; "Coil Voltage"; Enum "Coil voltage_Option")
        {
            Caption = 'Coil Voltage';
        }
        field(4; "Insulation Class"; Enum "Insulation Class_Option")
        {
            Caption = 'Insulation Class';
        }
        field(5; "Contact Ratings"; Enum "Contact Ratings_Option")
        {
            Caption = 'Contact Ratings';
        }
        field(6; "Contact Material"; Enum "Contact Material_Option")
        {
            Caption = 'Contact Material';
        }
        field(7; Sealing; Enum Sealing_Option)
        {
            Caption = 'Sealing';
        }
        field(8; "Special Functions"; Enum "Special Functions_Option")
        {
            Caption = 'Special Functions';
        }
        field(9; Termination; Enum Termination_Option)
        {
            Caption = 'Termination';
        }
        field(10; Mounting; Enum Mounting_Option)
        {
            Caption = 'Mounting';
        }
        field(11; Packaging; Enum Packaging_Option)
        {
            Caption = 'Packaging';
        }
        field(12; "Special Requests"; Text[30])
        {
            Caption = 'Special Requests';
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
