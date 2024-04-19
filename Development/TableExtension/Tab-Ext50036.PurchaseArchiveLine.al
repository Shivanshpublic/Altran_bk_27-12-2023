tableextension 50036 PurchaseArchiveLine extends "Purchase Line Archive"
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
            TableRelation = "Sales Line"."Line No." where("Document Type" = const(Order), "Document No." = field("SO No."), "No." = field("No."));
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
        field(50019; "Posting Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header Archive"."Posting Description" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50020; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header Archive"."Buy-from Vendor Name" where("Document Type" = field("Document Type"), "No." = field("Document No.")));

        }
        field(50220; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        modify("Description 2")
        {
            Caption = 'Model No.';
        }
        modify("Promised Receipt Date")
        {
            Caption = 'Factory Ready Date';
        }
        modify("Planned Receipt Date")
        {
            Caption = 'Booked Date';
        }
        modify("Expected Receipt Date")
        {
            Caption = 'Expected To Arrive';
        }

        field(50018; "Rev."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50079; "Buy-from Vendor Name"; Text[100])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(50110; "Expected Receipt Date1"; Date)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Expected to Arrive';

        }
        field(50111; "UL Certificate Available"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50112; "Assigned By"; Enum ItemChargeAssnOption)
        {
        }
        field(50113; "Order Note"; Text[250])
        {
            Caption = 'Order Note';
        }

        field(55400; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';

        }

    }
}
