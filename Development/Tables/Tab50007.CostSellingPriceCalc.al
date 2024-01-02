table 50007 "Cost & Selling Price Calc"
{
    Caption = 'Cost & Selling Price Calc';
    DataClassification = ToBeClassified;
    LookupPageId = "Item Volumes";
    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateValues();
            end;
        }
        field(2; "Tariff Applies"; Boolean)
        {
            Caption = 'Tariff Applies';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Customer is in USA"; Boolean)
        {
            Caption = 'Customer is in USA';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                UpdateTarrifApplies();
                if "Customer is in USA" then
                    "Number of Pallets/Container" := 20;
                CalculateValues();
            end;
        }
        field(4; "Vendor is in China"; Boolean)
        {
            Caption = 'Vendor is in China';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                UpdateTarrifApplies();
                CalculateValues();
            end;
        }
        field(5; "Duties Apply"; Boolean)
        {
            Caption = 'Duties Apply';
            DataClassification = ToBeClassified;
        }
        field(6; "Customer is in USA (Duties)"; Boolean)
        {
            Caption = 'Customer is in USA (Duties)';
            DataClassification = ToBeClassified;
        }
        field(7; "Special Taxes"; Decimal)
        {
            Caption = 'Special Taxes';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateValues();
            end;
        }
        field(8; "Estimated Annual Usage"; Decimal)
        {
            Caption = 'Estimated Annual Usage';
            DataClassification = ToBeClassified;
        }
        field(9; "No. of items/pallet"; Decimal)
        {
            Caption = 'No. of items/pallet';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateValues();
            end;
        }
        field(10; "Used Shipping Cost/Container"; Decimal)
        {
            Caption = 'Used Shipping Cost/Container';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateValues();
            end;
        }
        field(11; "Number of Pallets/Container"; Decimal)
        {
            Caption = 'Number of Pallets/Container';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateValues();
            end;
        }
        field(12; "Product Description"; Text[100])
        {
            Caption = 'Product Description';
            DataClassification = ToBeClassified;
        }
        field(13; "Product Category"; code[20])
        {
            Caption = 'Product Category';
            DataClassification = ToBeClassified;
        }
        field(14; "Altran Part #"; Text[50])
        {
            Caption = 'Altran Part #';
            DataClassification = ToBeClassified;
        }
        field(15; "Customer Part #"; Text[50])
        {
            Caption = 'Customer Part #';
            DataClassification = ToBeClassified;
        }
        field(16; Cost; Decimal)
        {
            Caption = 'Cost';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateValues();
            end;
        }
        field(17; Tariff; Decimal)
        {
            Caption = 'Tariff';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; Duties; Decimal)
        {
            Caption = 'Duties';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Special taxes/expenses"; Decimal)
        {
            Caption = 'Special taxes/expenses';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; Shipping; Decimal)
        {
            Caption = 'Shipping';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Total Estimated Landed cost"; Decimal)
        {
            Caption = 'Total Estimated Landed cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            trigger OnValidate()
            var
                Reccust: Record Customer;
            begin
                if "Customer No." <> '' then begin
                    Clear(Reccust);
                    Reccust.GET("Customer No.");
                    if Reccust."Country/Region Code" = 'US' then begin
                        Validate("Customer is in USA", true);
                        Validate("Customer is in USA (Duties)", true);
                    end else begin
                        Validate("Customer is in USA", false);
                        Validate("Customer is in USA (Duties)", false);
                    end;
                end else begin
                    Validate("Customer is in USA", false);
                    Validate("Customer is in USA (Duties)", false);
                end;
            end;
        }
        field(23; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            trigger OnValidate()
            var
                RecVendor: Record Vendor;
            begin
                if "Vendor No." <> '' then begin
                    Clear(RecVendor);
                    RecVendor.GET("Vendor No.");
                    if RecVendor."Country/Region Code" = 'CN' then begin
                        Validate("Vendor is in China", true);
                    end else begin
                        Validate("Vendor is in China", false);
                    end;
                end else begin
                    Validate("Vendor is in China", false);
                end;
            end;
        }
        field(24; "Shipping Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Standard Shipping to Sterling","Less than Container Load (LCL)","Air Freight";
            trigger OnValidate()
            var
                RecItemL: Record Item;
            begin
                if "Shipping Type" = "Shipping Type"::"Less than Container Load (LCL)" then begin
                    "Estimated Annual Usage" := 0;
                    "LCL Cost per CBM" := 0;
                    "Item Weight in KG" := 0;
                    "Air Freight Cost per KG" := 0;
                    CalculateCBM()
                end else
                    if "Shipping Type" = "Shipping Type"::"Air Freight" then begin
                        Clear(RecItemL);
                        RecItemL.GET("Item No.");
                        "Estimated Annual Usage" := RecItemL."Estimated Annual Usage";
                        "LCL Cost per CBM" := RecItemL."LCL Cost per CBM";
                        "Item Weight in KG" := RecItemL."Item Weight in KG";
                        "Air Freight Cost per KG" := RecItemL."Air Freight Cost per KG";
                        CalculateFreight();
                    end
                    else
                        if "Shipping Type" = "Shipping Type"::"Standard Shipping to Sterling" then begin
                            Clear(RecItemL);
                            "Estimated Annual Usage" := 0;
                            "LCL Cost per CBM" := 0;
                            "Item Weight in KG" := 0;
                            "Air Freight Cost per KG" := 0;
                            RecItemL.GET("Item No.");
                            "No. of items/pallet" := RecItemL."No. of items/pallet";
                            "Used Shipping Cost/Container" := 10000;

                            CalcShippingStdCost();
                        end;
            end;
        }
        field(28; "Box Volume in CBM"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(29; "Items Per Box"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateCBM();
            end;
        }
        field(30; "Item Volume in CBM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "LCL Cost per CBM"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateCBM();
            end;
        }
        field(32; "Item Weight in KG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Air Freight Cost per KG"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateFreight();
            end;
        }
        field(34; "Item Volume Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Volume"."Volume Code" WHERE("Item No." = FIELD("Item No."));
            trigger OnValidate()
            var
                ItemVolume: Record "Item Volume";
            begin
                if ItemVolume.Get("Item No.", "Item Volume Code") then
                    "Box Volume in CBM" := ItemVolume.Volume
                else
                    "Box Volume in CBM" := 0;
            end;
        }
    }
    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    procedure CalculateValues()
    var
        RecItem: Record Item;
        ItemCat: Record "Item Category";
    begin
        if "Item No." <> '' then begin
            RecItem.GET("Item No.");
            "Product Description" := RecItem.Description;
            "Product Category" := RecItem."Item Category Code";
            // if "Used Shipping Cost/Container" = 0 then
            //     "Used Shipping Cost/Container" := 10000;
            // if "No. of items/pallet" = 0 then
            //     "No. of items/pallet" := RecItem."No. of items/pallet";
            if RecItem."Item Category Code" <> '' then begin
                Clear(ItemCat);
                ItemCat.GET(RecItem."Item Category Code");
                if Cost = 0 then
                    Cost := RecItem."Last Direct Cost"; //ItemCat.Cost;
                if "Tariff Applies" then
                    Tariff := Round(Cost * ItemCat.Tariff, 0.01, '=')
                else
                    Tariff := 0;

                if "Customer is in USA (Duties)" then
                    Duties := Round((Cost * ItemCat."Total Duties") / 100, 0.01, '=')
                else
                    Duties := 0;
            end;
        end;
    end;

    local procedure UpdateTarrifApplies()
    begin
        if "Customer is in USA" AND "Vendor is in China" then
            "Tariff Applies" := true
        else
            "Tariff Applies" := false;
    end;

    local procedure CreateLogEntries()
    var
        CostNPriceLog: Record "Cost & Price Log";
    begin
        CostNPriceLog.Init();
        CostNPriceLog."Entry No." := 0;
        CostNPriceLog.Insert(true);
        CostNPriceLog.TransferFields(Rec);
        CostNPriceLog.Modify();
    end;

    local procedure CalculateCBM()
    begin
        if "Shipping Type" = "Shipping Type"::"Less than Container Load (LCL)" then
            Shipping := "Item Volume in CBM" * "LCL Cost per CBM";
    end;

    local procedure CalculateFreight()
    begin
        Shipping := "Item Weight in KG" * "Air Freight Cost per KG";
    end;

    local procedure CalcShippingStdCost()
    var
        RecItem: Integer;
    begin
        if ("Number of Pallets/Container" <> 0) AND ("No. of items/pallet" <> 0) then
            Shipping := Round("Used Shipping Cost/Container" / "Number of Pallets/Container" / "No. of items/pallet", 0.01, '=')
        else
            Shipping := 0;
    end;

    procedure CalcLandedCostAndSaveLog()
    var
        myInt: Integer;
    begin
        "Special taxes/expenses" := "Special Taxes";
        "Total Estimated Landed cost" := Round(Cost + Tariff + Duties + Shipping + "Special taxes/expenses", 0.01, '=');
        //creating log
        CreateLogEntries();
    end;
}
