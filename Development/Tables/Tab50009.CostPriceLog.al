table 50009 "Cost & Price Log"
{
    Caption = 'Cost & Price Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
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
        }
        field(4; "Vendor is in China"; Boolean)
        {
            Caption = 'Vendor is in China';
            DataClassification = ToBeClassified;
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
        }
        field(10; "Used Shipping Cost/Container"; Decimal)
        {
            Caption = 'Used Shipping Cost/Container';
            DataClassification = ToBeClassified;
        }
        field(11; "Number of Pallets/Container"; Decimal)
        {
            Caption = 'Number of Pallets/Container';
            DataClassification = ToBeClassified;
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
        field(122; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(123; "Creation Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(124; "Created By"; Text[50])
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
