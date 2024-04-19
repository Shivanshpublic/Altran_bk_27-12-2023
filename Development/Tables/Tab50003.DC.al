table 50003 DC
{
    Caption = 'DC';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Humidity w/o Ice/Dew"; Code[20])
        {
            Caption = 'Humidity w/o Ice/Dew';
        }
        field(2; "Storage - C"; Code[20])
        {
            Caption = 'Storage - C';
        }
        field(3; "Axuiliary Contact Config."; Code[20])
        {
            Caption = 'Axuiliary Contact Configuration';
        }
        field(4; "Contact Configuration"; Code[20])
        {
            Caption = 'Contact Configuration';
        }
        field(5; "Working - C"; Code[20])
        {
            Caption = 'Working - C';
        }
        field(6; "Pull in Time M Sec Max"; Decimal)
        {
            Caption = 'Pull in Time M Sec Max';
        }
        field(7; "Coil Voltage VDC"; Code[20])
        {
            Caption = 'Coil Voltage VDC';
        }
        field(8; "Release Time M Sec Max"; Decimal)
        {
            Caption = 'Release Time M Sec Max';
        }
        field(9; "Coil Power W"; Decimal)
        {
            Caption = 'Coil Power W';
        }
        field(10; "Pull in Voltage VDC"; Decimal)
        {
            Caption = 'Pull in Voltage VDC';
        }
        field(11; "Release Voltage VDC"; Decimal)
        {
            Caption = 'Release Voltage VDC';
        }
    }
    keys
    {
        key(PK; "Humidity w/o Ice/Dew")
        {
            Clustered = true;
        }
    }
}
