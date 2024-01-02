tableextension 50019 PurchaseRcptLine extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50000; "SO No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(50001; "SO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Line"."Line No." where("Document Type" = const(Order), "Document No." = field("SO No."));
        }
        field(50002; "HS Code"; Code[50])
        {
            Caption = 'HS Code';
            DataClassification = ToBeClassified;
        }
        field(50003; "HTS Code"; Code[50])
        {
            Caption = 'HTS Code';
            DataClassification = ToBeClassified;
        }
        field(50004; "No. of Packages"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Total Gross (KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Total CBM"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(50007; "Total Net (KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Port of Load"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Port";
        }
        field(50009; "Port of Discharge"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Port";
        }
        field(50010; "Country of Origin"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50011; "Country of provenance"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50012; "Country of Acquisition"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50013; "Milestone Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Milestone Status";
        }
        field(50014; "Shipment Tracking Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Header";
            Editable = false;
            ValidateTableRelation = false;
        }
        field(50015; "Shipment Tracking Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Line"."Line No." where("Tracking Code" = field("Shipment Tracking Code"));
            Editable = false;
            ValidateTableRelation = false;
        }
        field(50016; "Pallet Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "VIA"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        modify("Description 2")
        {
            Caption = 'Model No.';
        }
        field(50018; "Rev."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50079; "Buy-from Vendor Name"; Text[100])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(50111; "UL Certificate Available"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
            end;
        }
    }
}
