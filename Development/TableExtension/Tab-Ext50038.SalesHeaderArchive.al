TABLEEXTENSION 50038 "Ext Sales Header Archive" EXTENDS "Sales Header Archive"
{
    FIELDS
    {
        FIELD(50000; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Regional Manager';
            TableRelation = "Salesperson/Purchaser";
        }
        FIELD(50001; "External Rep"; Text[250])
        {
            DataClassification = ToBeClassified;
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
        }
        field(50003; "Consignee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = If ("Consignee Type" = const(customer)) Customer ELSE
            IF ("Consignee Type" = const(Vendor)) Vendor;
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


    PROCEDURE LookupOnExternalRep()
    VAR
        SalesPersonList: Page "Salespersons/Purchasers";
    BEGIN
        SalesPersonList.LOOKUPMODE(TRUE);
        IF SalesPersonList.RUNMODAL = ACTION::LookupOK THEN
            VALIDATE("External Rep", SalesPersonList.GetSelectionFilter);
    END;
}