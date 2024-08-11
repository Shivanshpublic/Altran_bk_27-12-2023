TABLE 50004 "Sales Commission Entry"
{
    DataClassification = ToBeClassified;

    FIELDS
    {
        FIELD(1; "Salesperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(2; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = ToBeClassified;
        }
        FIELD(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(4; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(5; "External Team"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        FIELD(6; "Document Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(7; "Commission Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(8; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(9; "Gross Margin %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(10; "Commission %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    KEYS
    {
        KEY(PK; "Salesperson Code", "Document Type", "Document No.")
        {
            Clustered = true;
        }
    }

}