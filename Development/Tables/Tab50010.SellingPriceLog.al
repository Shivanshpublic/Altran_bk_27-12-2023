table 50010 SellingPriceLog
{
    Caption = 'SellingPriceLog';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Total Est. Landed Cost"; Decimal)
        {
            Caption = 'Total Est. Landed Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Profit Margin %"; Decimal)
        {
            Caption = 'Profit Margin %';
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Profit Margin"; Decimal)
        {
            Caption = 'Profit Margin';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Suggested Selling Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(23; "Creation Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Created By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Creation Date" := CurrentDateTime;
    end;
}
