tableextension 50007 SalesLine extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Type = Type::Item then begin
                    If Item.Get("No.") then
                        "UL Certificate Available" := Item."UL Certificate Available";
                end;
            end;
        }
        modify("Planned Delivery Date")
        {
            Caption = 'Customer Required Date';
        }
        field(50000; "PO No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(50001; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Order), "Document No." = field("PO No."));
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
        field(50014; "Shipment Tracking Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Header";
            Editable = false;
        }
        field(50015; "Shipment Tracking Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Line"."Line No." where("Tracking Code" = field("Shipment Tracking Code"));
            Editable = false;
        }
        field(50016; "Surcharge Per Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50018; "Parent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Line"."Line No." where("Document Type" = field("Document Type"), "Document No." = field("Document No."));
        }
        field(50019; "VIA"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Milestone Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Milestone Status";

        }
        field(50021; "Pallet Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        modify("Description 2")
        {
            Caption = 'Model No.';
        }
        //18-09-2023-start
        field(50022; "Origin Criteria"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Certification Indicator"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "USMCA Qualified Y/N"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        //18-09-2023-end
        field(50025; "Linked SO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Line"."Line No." where("Document No." = field("Document No."), "Document Type" = field("Document Type"));
            trigger OnValidate()
            var
                RecItem: Record Item;
            begin
                if (Rec."No." <> '') AND (Rec.Type = Rec.Type::Item) AND (Rec."Line No." <> 0) then begin
                    RecItem.GET(Rec."No.");
                    if RecItem.Type = RecItem.Type::Inventory then
                        Error('Type must not be equal to Inventory in Item: No.=%1.', Rec."No.");
                end;
            end;
            //TableRelation="Sales Line"."No." where("Document Type"=field("Document Type"),"Document No."=field("Document No."))
        }
        field(50030; "Assigned CSR"; Code[50])
        {
            Caption = 'Assigned CSR';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup";
            Editable = false;
        }
        field(50031; "External Document No."; Code[35])
        {
            Editable = false;
        }
        field(50032; "Sell-to Customer Name"; Text[50])
        {
            Editable = false;
        }
        field(50033; "Salesperson Name"; Text[50])
        {
            Caption = 'Sales Director Name';
            Editable = false;
        }
        field(50034; "Internal Team Name"; Text[50])
        {
            Caption = 'Regional Manager Name';
            Editable = false;
        }
        FIELD(50035; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Regional Manager';
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if Salesperson.Get("Internal Team") then
                    "Internal Team Name" := Salesperson.Name
                else
                    "Internal Team Name" := '';
            end;
        }
        FIELD(50036; "External Rep"; Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if Salesperson.Get("External Rep") then
                    "External Team Name" := Salesperson.Name
                else
                    "External Team Name" := '';
            end;

            TRIGGER OnLookup()
            BEGIN
                LookupOnExternalRep();
            END;
        }
        field(50037; "External Team Name"; Text[50])
        {
            Caption = 'External Team Name';
            Editable = false;
        }
        field(50038; "Salesperson Code"; Code[20])
        {
            Caption = 'Sales Director';
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if Salesperson.Get("Salesperson Code") then
                    "Salesperson Name" := Salesperson.Name
                else
                    "Salesperson Name" := '';
            end;

        }
        field(50111; "UL Certificate Available"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
            end;
        }
    }

    trigger OnInsert()
    var
        RecHdr: Record "Sales Header";
        Salesperson: Record "Salesperson/Purchaser";
    begin
        RecHdr := GetSalesHeader();
        if "Country of Origin" = '' then
            "Country of Origin" := RecHdr."Country of Origin";
        if "Country of Acquisition" = '' then
            "Country of Acquisition" := RecHdr."Country of Acquisition";
        if "Country of provenance" = '' then
            "Country of provenance" := RecHdr."Country of provenance";
        if "Milestone Status" = '' then
            "Milestone Status" := RecHdr."Milestone Status";
        "Assigned CSR" := RecHdr."Assigned User ID";
        "External Document No." := RecHdr."External Document No.";
        "Sell-to Customer Name" := RecHdr."Sell-to Customer Name";
        if Salesperson.Get(RecHdr."Internal Team") then
            Validate("Internal Team", RecHdr."Internal Team");
        if Salesperson.Get(RecHdr."External Rep") then
            Validate("External Rep", RecHdr."External Rep");
        if Salesperson.Get(RecHdr."Salesperson Code") then
            Validate("Salesperson Code", RecHdr."Salesperson Code");
    end;

    trigger OnModify()
    var
        RecHdr: Record "Sales Header";
    begin
        RecHdr := GetSalesHeader();
        if "Country of Origin" = '' then
            "Country of Origin" := RecHdr."Country of Origin";
        if "Country of Acquisition" = '' then
            "Country of Acquisition" := RecHdr."Country of Acquisition";
        if "Country of provenance" = '' then
            "Country of provenance" := RecHdr."Country of provenance";
        "Assigned CSR" := RecHdr."Assigned User ID";
        "External Document No." := RecHdr."External Document No.";
        "Sell-to Customer Name" := RecHdr."Sell-to Customer Name";
    end;

    PROCEDURE LookupOnExternalRep()
    VAR
        SalesPersonList: Page "Salespersons/Purchasers";
    BEGIN
        SalesPersonList.LOOKUPMODE(TRUE);
        IF SalesPersonList.RUNMODAL = ACTION::LookupOK THEN
            VALIDATE("External Rep", SalesPersonList.GetSelectionFilter);
    END;
}
