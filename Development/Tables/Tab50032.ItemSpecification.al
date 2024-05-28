table 50032 "Item Specification"
{
    Caption = 'Item Specification';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            Editable = false;
        }
        field(2; Specification; Code[30])
        {
            Caption = 'Specification';
            TableRelation = Specification;
        }
        field(3; "Value"; Code[30])
        {
            Caption = 'Value';
            TableRelation = "Specification Values".Value where(Specification = field(Specification));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                SpecValue: record "Specification Values";
                SpecValueExists: Boolean;
            begin
                SpecValue.Reset();
                SpecValue.SetRange(Specification, Rec.Specification);
                SpecValue.SetFilter(Value, '<> %1', '');
                if SpecValue.FindFirst() then begin
                    SpecValueExists := true;
                end;

                SpecValue.Reset();
                if SpecValueExists = true then
                    SpecValue.Get(Rec.Specification, Rec.Value);
            end;
        }
    }
    keys
    {
        key(PK; "Item No.", Specification)
        {
            Clustered = true;
        }
    }
}
