table 50011 "Item Volume"
{
    Caption = 'Item Volume';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
            Editable = false;
        }
        field(2; "Volume Code"; Code[10])
        {
            Caption = 'Volume Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(3; Length; Decimal)
        {
            Caption = 'Length';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateVolume();
            end;
        }
        field(4; Width; Decimal)
        {
            Caption = 'Width';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateVolume();
            end;
        }
        field(5; Height; Decimal)
        {
            Caption = 'Height';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateVolume();
            end;
        }
        field(6; Volume; Decimal)
        {
            Caption = 'Volume';
            DataClassification = ToBeClassified;
            Editable = false;
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
        key(PK; "Item No.", "Volume Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Creation Date" := CurrentDateTime;
    end;

    local procedure CalculateVolume()
    begin
        Validate(Volume, Length * Width * Height);
    end;
}
