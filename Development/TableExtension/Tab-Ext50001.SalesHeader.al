TABLEEXTENSION 50001 "Ext Sales Header" EXTENDS "Sales Header"
{
    FIELDS
    {
        MODIFY("Sell-to Customer No.")
        {
            TRIGGER OnAfterValidate()
            VAR
                Customer: Record Customer;
            BEGIN
                IF Customer.GET("Sell-to Customer No.") THEN BEGIN
                    "Internal Team" := Customer."Internal Team";
                    "External Rep" := Customer."External Rep";
                END;
            END;
        }
        MODIFY("Assigned User ID")
        {
            TRIGGER OnAfterValidate()
            var
                SalesLine: Record "Sales Line";
            begin
                if xRec."Assigned User ID" <> Rec."Assigned User ID" then begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    if SalesLine.FindFirst() then begin
                        SalesLine.ModifyAll("Assigned CSR", "Assigned User ID");
                    end;
                end;
            end;
        }

        FIELD(50000; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Regional Manager';
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Salesperson: Record "Salesperson/Purchaser";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst() then
                    repeat
                        SalesLine.Validate("Internal Team", "Internal Team");
                        // if Salesperson.Get("Internal Team") then
                        //     SalesLine."Internal Team Name" := Salesperson.Name
                        // else
                        //     SalesLine."Internal Team Name" := '';
                        SalesLine.Modify();
                    until SalesLine.Next() = 0;

            end;
        }
        Modify("Salesperson Code")
        {
            Caption = 'Sales Director';
            trigger OnAfterValidate()
            var
                SalesLine: Record "Sales Line";
                Salesperson: Record "Salesperson/Purchaser";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst() then
                    repeat
                        SalesLine.Validate("Salesperson Code", "Salesperson Code");
                        // if Salesperson.Get("Salesperson Code") then
                        //     SalesLine."Salesperson Name" := Salesperson.Name
                        // else
                        //     SalesLine."Salesperson Name" := '';
                        SalesLine.Modify();
                    until SalesLine.Next() = 0;
            end;
        }
        FIELD(50001; "External Rep"; Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Salesperson: Record "Salesperson/Purchaser";
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst() then
                    repeat
                        SalesLine."External Rep" := "External Rep";
                        if Salesperson.Get("External Rep") then
                            SalesLine."External Team Name" := Salesperson.Name
                        else
                            SalesLine."External Team Name" := '';
                        SalesLine.Modify();
                    until SalesLine.Next() = 0;

            end;

            TRIGGER OnLookup()
            BEGIN
                LookupOnExternalRep();
            END;
        }

        //consignee-start
        field(50002; "Consignee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Customer,Vendor;
            trigger OnValidate()
            begin
                if Rec."Consignee Type" <> xRec."Consignee Type" then begin
                    "Consignee No." := '';
                    "Consignee Name" := '';
                    "Consignee Name 2" := '';
                    "Consignee Address" := '';
                    "Consignee Address 2" := '';
                    "Consignee City" := '';
                    "Consignee Country/Region code" := '';
                end;

            end;
        }
        field(50003; "Consignee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = If ("Consignee Type" = const(customer)) Customer ELSE
            IF ("Consignee Type" = const(Vendor)) Vendor;

            trigger OnValidate()
            var
                RecCustomer: Record Customer;
                RecVendor: Record Vendor;
            begin
                if "Consignee No." <> '' then begin
                    case "Consignee Type" of
                        Rec."Consignee Type"::Customer:
                            begin
                                Clear(RecCustomer);
                                RecCustomer.GET(Rec."Consignee No.");
                                "Consignee Name" := RecCustomer.Name;
                                "Consignee Name 2" := RecCustomer."Name 2";
                                "Consignee Address" := RecCustomer.Address;
                                "Consignee Address 2" := RecCustomer."Address 2";
                                "Consignee City" := RecCustomer.City;
                                "Consignee Country/Region code" := RecCustomer."Country/Region Code";
                            end;
                        Rec."Consignee Type"::Vendor:
                            begin
                                Clear(RecVendor);
                                RecVendor.GET(Rec."Consignee No.");
                                "Consignee Name" := RecVendor.Name;
                                "Consignee Name 2" := RecVendor."Name 2";
                                "Consignee Address" := RecVendor.Address;
                                "Consignee Address 2" := RecVendor."Address 2";
                                "Consignee City" := RecVendor.City;
                                "Consignee Country/Region code" := RecVendor."Country/Region Code";
                            end;
                    end;
                end;
            end;
        }
        field(50004; "Consignee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Consignee Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Consignee Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Consignee Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Consignee City"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Consignee Country/Region code"; code[10])
        {
            DataClassification = ToBeClassified;
        }
        //consignee-end

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
        field(50014; "Consignee Post Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(50016; "Sample Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "VIA"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnModify()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        if SalesLine.FindFirst() then
            repeat
                SalesLine."External Document No." := "External Document No.";
                SalesLine.Modify();
            until SalesLine.Next() = 0;
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