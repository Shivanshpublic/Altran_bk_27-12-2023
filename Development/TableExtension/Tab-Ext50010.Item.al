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
        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            var
                ItemCategory: Record "Item Category";
                ItemCatSpec: Record "Item Category Specification";
                ItemSpec: Record "Item Specification";
            begin
                if (Type = Type::Inventory) AND ("Item Category Code" <> '') then begin
                    if ItemCategory.Get("Item Category Code") then begin
                        "HS Code" := ItemCategory."HS Code";
                        "HTS Code" := ItemCategory."HTS Code";
                        Validate("Item Tracking Code", ItemCategory."Item Tracking Code");
                        Validate("Lot Nos.", ItemCategory."Lot Nos.");
                        Validate("Expiration Calculation", ItemCategory."Expiration Calculation");
                    end;
                end;

                ItemCatSpec.Reset();
                ItemCatSpec.SetRange(ItemCategory, "Item Category Code");
                if ItemCatSpec.FindFirst() then
                    repeat
                        ItemSpec.Init();
                        ItemSpec."Item No." := "No.";
                        ItemSpec.Specification := ItemCatSpec.Specification;
                        if ItemSpec.Insert() then;
                    until ItemCatSpec.Next() = 0;
            end;
        }
        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Vendor No.") then begin
                    Validate("Vendor Name", Vendor.Name);
                    Validate("Country of Origin", Vendor."Country/Region Code");
                end else begin
                    Validate("Vendor Name", '');
                    Validate("Country of Origin", '');
                end;
            end;
        }
        field(50010; "UL Certificate Available"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
            end;
        }
        field(50011; "UL"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "CUL"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "TUV"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "VDE"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "SEMKO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "DEMKO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "ENEC"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "CSA"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "CE"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "No of items/box"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Country of Origin"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
            Editable = false;
        }
        field(50022; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Preferred Vendor Name';
            Editable = false;
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
