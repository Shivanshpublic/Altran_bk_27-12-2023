tableextension 50010 Item extends Item
{
    fields
    {
        field(50000; "HS Code"; Code[50])
        {
            Caption = 'HS Code';
            DataClassification = ToBeClassified;
        }
        field(50001; "HTS Code"; Code[50])
        {
            Caption = 'HTS Code';
            DataClassification = ToBeClassified;
        }
        field(50002; "No. of items/pallet"; Decimal)
        {
            Caption = 'No. of items/pallet';
            DataClassification = ToBeClassified;
        }
        field(50003; "Item Weight in KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Item Volume Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Volume"."Volume Code" WHERE("Item No." = FIELD("No."));
            trigger OnValidate()
            var
                ItemVolume: Record "Item Volume";
            begin
                if ItemVolume.Get("No.", "Item Volume Code") then
                    "Item Volume" := ItemVolume.Volume
                else
                    "Item Volume" := 0;
            end;
        }
        field(50005; "Item Volume"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Estimated Annual Usage"; Decimal)
        {
            Caption = 'Estimated Annual Usage';
            DataClassification = ToBeClassified;
        }
        field(50007; "LCL Cost per CBM"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
            trigger OnValidate()
            begin
            end;
        }
        field(50009; "Air Freight Cost per KG"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
            end;
        }
        modify("Description 2")
        {
            Caption = 'Model No.';
        }
        modify(Blocked)
        {
            trigger OnBeforeValidate()
            begin
                if (Type = Type::Inventory) AND (Blocked = false) AND ("Item Tracking Code" = '') then
                    Error('Item Tracking Code must be filled before unblocking Inventory Item.');
                ;
            end;
        }
        field(50010; "UL Certificate Available"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
            end;
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Description 2") { }
        addlast(Brick; "Description 2") { }
    }
    trigger OnAfterInsert()
    begin
        Blocked := true;
    end;


}
