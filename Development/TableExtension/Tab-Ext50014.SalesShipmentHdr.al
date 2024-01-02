tableextension 50014 SalesShipmentHdr extends "Sales Shipment Header"
{
    fields
    {
        FIELD(50000; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        FIELD(50001; "External Rep"; Text[250])
        {
            DataClassification = ToBeClassified;
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
        field(50019; "VIA"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}