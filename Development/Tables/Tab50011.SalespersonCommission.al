table 50012 "Salesperson Commission"
{
    Caption = 'Salesperson Commission';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
            //Editable = false;
        }
        field(2; Type; Enum CommissionOption)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if xRec.Type <> Rec.Type then
                    validate(Code, '');
            end;
        }

        field(3; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST("Item Category")) "Item Category"
            ELSE
            IF (Type = CONST(Item)) Item;
            trigger OnValidate()
            begin

            end;
        }
        field(4; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin

            end;
        }
        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin

            end;
        }
        field(7; "From Margin %"; Decimal)
        {
            Caption = 'From Margin %';
            DataClassification = ToBeClassified;
        }
        field(8; "To Margin %"; Decimal)
        {
            Caption = 'To Margin %';
            DataClassification = ToBeClassified;
        }
        field(9; "Commission %"; Decimal)
        {
            Caption = 'Commission %';
            DataClassification = ToBeClassified;
        }

        field(23; "Creation Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Created By"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Salesperson Code", Type, Code, "From Date", "To Date", "From Margin %", "To Margin %")
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
