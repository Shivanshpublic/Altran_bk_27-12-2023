tableextension 50006 PurchaseLine extends "Purchase Line"
{
    fields
    {
        field(50000; "SO No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
            //Editable = false;
            trigger OnValidate()
            begin
                if xrec."SO No." <> "SO No." then begin
                    TestField("Qty. Rcd. Not Invoiced", 0);
                    TestField("Quantity Received", 0);
                    ResetSOLineFromPOLine(xrec."SO No.", "SO Line No.");
                    "SO Line No." := 0;
                end;
            end;
        }
        field(50001; "SO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Line"."Line No." where("Document Type" = const(Order), "Document No." = field("SO No."), "No." = field("No."));
            //Editable = false;
            trigger OnValidate()
            var
            begin
                if xRec."SO Line No." <> Rec."SO Line No." then begin
                    TestField("Qty. Rcd. Not Invoiced", 0);
                    TestField("Quantity Received", 0);
                end;
                if ("SO No." <> '') AND ("SO Line No." <> 0) then begin
                    UpdatePOLineFromSOLine();

                end;
            end;
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
            CalcFormula = lookup("Purchase Header"."Posting Description" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50020; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Buy-from Vendor Name" where("Document Type" = field("Document Type"), "No." = field("Document No.")));

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

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                RecHdr: Record "Purchase Header";
                Item: Record Item;
            begin
                RecHdr := GetPurchHeader();
                if "Country of Origin" = '' then
                    "Country of Origin" := RecHdr."Country of Origin";
                if "Country of Acquisition" = '' then
                    "Country of Acquisition" := RecHdr."Country of Acquisition";
                if "Country of provenance" = '' then
                    "Country of provenance" := RecHdr."Country of provenance";
                if "Milestone Status" = '' then
                    "Milestone Status" := RecHdr."Milestone Status";
                if Type = Type::Item then begin
                    If Item.Get("No.") then
                        "UL Certificate Available" := Item."UL Certificate Available";
                end;
            end;
        }
        field(50018; "Rev."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        modify("Sales Order No.")
        {
            trigger OnAfterValidate()
            begin
                if "SO No." = '' then
                    "SO No." := "Sales Order No.";
            end;
        }
        modify("Sales Order Line No.")
        {
            trigger OnAfterValidate()
            begin
                if "SO Line No." = 0 then
                    "SO Line No." := "Sales Order Line No.";
            end;
        }
        field(50079; "Buy-from Vendor Name"; Text[100])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(50110; "Expected Receipt Date1"; Date)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Expected to Arrive';

            trigger OnValidate()
            begin
                "Expected Receipt Date" := "Expected Receipt Date1";
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
        field(50112; "Assigned By"; Enum ItemChargeAssnOption)
        {
            trigger OnValidate()
            var
                ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
            begin
                if (xRec."Assigned By" <> Rec."Assigned By") then begin
                    ItemChargeAssgntPurch.SetRange("Document Type", "Document Type");
                    ItemChargeAssgntPurch.SetRange("Document No.", "Document No.");
                    ItemChargeAssgntPurch.SetRange("Document Line No.", "Line No.");

                    if not ItemChargeAssgntPurch.IsEmpty() then begin
                        ItemChargeAssgntPurch.ModifyAll("Assigned By", "Assigned By");
                        ItemChargeAssgntPurch.ModifyAll("Amount to Assign", 0);
                        ItemChargeAssgntPurch.ModifyAll("Qty. to Assign", 0);
                        ItemChargeAssgntPurch.ModifyAll("Amount to Handle", 0);
                        ItemChargeAssgntPurch.ModifyAll("Qty. to Handle", 0);
                    end;
                end;
            end;
        }
        field(50113; "Order Note"; Text[250])
        {
            Caption = 'Order Note';
        }

        field(55400; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';

            trigger OnValidate()
            var
                PurchHead: Record "Purchase Header";
            begin
                PurchHead.Get(Rec."Document Type", Rec."Document No.");
                if "Lot No." <> xRec."Lot No." then begin
                    PurchHead.DeleteReservationEntry(PurchHead, Rec."Line No.");
                    if "Lot No." <> '' then
                        PurchHead.AssignLotNo(PurchHead, Rec."Line No.", Rec."Lot No.");
                end;
            end;
        }

    }

    trigger OnInsert()
    var
        RecHdr: Record "Purchase Header";
    begin
        "Creation Date" := Today;
        RecHdr := GetPurchHeader();
        /*
        if "Country of Origin" = '' then
            "Country of Origin" := RecHdr."Country of Origin";
        if "Country of Acquisition" = '' then
            "Country of Acquisition" := RecHdr."Country of Acquisition";
        if "Country of provenance" = '' then
            "Country of provenance" := RecHdr."Country of provenance";
        if "Milestone Status" = '' then
            "Milestone Status" := RecHdr."Milestone Status";
        */
    end;

    trigger OnModify()
    var
        RecHdr: Record "Purchase Header";
    begin
        RecHdr := GetPurchHeader();
        //"Country of Origin" := RecHdr."Country of Origin";
        //"Country of Acquisition" := RecHdr."Country of Acquisition";
        //"Country of provenance" := RecHdr."Country of provenance";
        if Rec."SO Line No." <> 0 then begin
            UpdateSOLineFromPOLine(RecHdr, Rec);
        end
    end;

    local procedure UpdatePOLineFromSOLine();
    var
        Sheader: Record "Sales Header";
        Sline: Record "Sales Line";
    begin
        Clear(Sline);
        Clear(Sheader);
        Sheader.SetRange("Document Type", Sheader."Document Type"::Order);
        Sheader.SetRange("No.", "SO No.");
        if Sheader.FindFirst() then begin
            Sline.SetRange("Document Type", Sline."Document Type"::Order);
            Sline.SetRange("Document No.", "SO No.");
            //Sline.SetRange(Type, Sline.Type::Item);
            Sline.SetRange("Line No.", "SO Line No.");
            if Sline.FindFirst() then begin
                if "HS Code" = '' then
                    "HS Code" := Sline."HS Code";
                if "HTS Code" = '' then
                    "HTS Code" := Sline."HTS Code";
                if "No. of Packages" = 0 then
                    "No. of Packages" := Sline."No. of Packages";
                if "Total Gross (KG)" = 0 then
                    "Total Gross (KG)" := Sline."Total Gross (KG)";
                if "Total CBM" = 0 then
                    "Total CBM" := Sline."Total CBM";
                if "Total Net (KG)" = 0 then
                    "Total Net (KG)" := Sline."Total Net (KG)";
                if "Port of Load" = '' then
                    "Port of Load" := Sline."Port of Load";
                if "Port of Discharge" = '' then
                    "Port of Discharge" := Sline."Port of Discharge";
                if "Country of Origin" = '' then
                    "Country of Origin" := Sline."Country of Origin";
                if "Country of provenance" = '' then
                    "Country of provenance" := Sline."Country of provenance";
                if "Country of Acquisition" = '' then
                    "Country of Acquisition" := Sline."Country of Acquisition";
                if "VIA" = '' then
                    "VIA" := Sline."VIA";
                if "Milestone Status" = '' then
                    "Milestone Status" := Sline."Milestone Status";
                if "Pallet Quantity" = 0 then
                    "Pallet Quantity" := Sline."Pallet Quantity";
            end;
        end;
    end;

    local procedure UpdateSOLineFromPOLine(PurchOrderHeader: Record "Purchase Header"; PurchOrderLine: Record "Purchase Line");
    var
        Sheader: Record "Sales Header";
        Sline: Record "Sales Line";
    begin
        Clear(Sline);
        Clear(Sheader);
        Sheader.SetRange("Document Type", Sheader."Document Type"::Order);
        Sheader.SetRange("No.", PurchOrderLine."SO No.");
        if Sheader.FindFirst() then begin
            Sline.SetRange("Document Type", Sline."Document Type"::Order);
            Sline.SetRange("Document No.", PurchOrderLine."SO No.");
            //Sline.SetRange(Type, Sline.Type::Item);
            Sline.SetRange("Line No.", PurchOrderLine."SO Line No.");
            if Sline.FindFirst() then begin
                // if PurchOrderLine."HS Code" <> Sline."HS Code" then
                //     Sline."HS Code" := PurchOrderLine."HS Code";
                // if PurchOrderLine."HTS Code" <> Sline."HTS Code" then
                //     Sline."HTS Code" := PurchOrderLine."HTS Code";
                Sline."PO No." := PurchOrderLine."Document No.";
                Sline."PO Line No." := PurchOrderLine."Line No.";
                if PurchOrderLine."No. of Packages" <> Sline."No. of Packages" then
                    Sline."No. of Packages" := PurchOrderLine."No. of Packages";
                if PurchOrderLine."Total Gross (KG)" <> Sline."Total Gross (KG)" then
                    Sline."Total Gross (KG)" := PurchOrderLine."Total Gross (KG)";
                if PurchOrderLine."Total CBM" <> Sline."Total CBM" then
                    Sline."Total CBM" := PurchOrderLine."Total CBM";
                if PurchOrderLine."Total Net (KG)" <> Sline."Total Net (KG)" then
                    Sline."Total Net (KG)" := PurchOrderLine."Total Net (KG)";
                // if PurchOrderLine."Port of Load" <> '' then
                //     if PurchOrderLine."Port of Load" <> Sline."Port of Load" then
                //         Sline."Port of Load" := PurchOrderLine."Port of Load";
                // if PurchOrderLine."Port of Discharge" <> '' then
                //     if PurchOrderLine."Port of Discharge" <> Sline."Port of Discharge" then
                //         Sline."Port of Discharge" := PurchOrderLine."Port of Discharge";
                // if PurchOrderLine."Country of Origin" <> '' then
                //     if PurchOrderLine."Country of Origin" <> Sline."Country of Origin" then
                //         Sline."Country of Origin" := PurchOrderLine."Country of Origin";
                // if PurchOrderLine."Country of provenance" <> '' then
                //     if PurchOrderLine."Country of provenance" <> Sline."Country of provenance" then
                //         Sline."Country of provenance" := PurchOrderLine."Country of provenance";
                // if PurchOrderLine."Country of Acquisition" <> '' then
                //     if PurchOrderLine."Country of Acquisition" <> Sline."Country of Acquisition" then
                //         Sline."Country of Acquisition" := PurchOrderLine."Country of Acquisition";
                // if PurchOrderLine.VIA <> '' then
                //     if PurchOrderLine.VIA <> Sline.VIA then
                //         Sline."VIA" := PurchOrderLine."VIA";
                // if PurchOrderLine."Milestone Status" <> '' then
                //     if PurchOrderLine."Milestone Status" <> Sline."Milestone Status" then
                //         Sline."Milestone Status" := PurchOrderLine."Milestone Status";
                //if PurchOrderLine."Pallet Quantity" <> Sline."Pallet Quantity" then
                //    Sline."Pallet Quantity" := PurchOrderLine."Pallet Quantity";
                Sline.Modify();
            end;
        end;
    end;

    local procedure ResetSOLineFromPOLine(SONo: Code[20]; SOLineNo: Integer);
    var
        Sheader: Record "Sales Header";
        Sline: Record "Sales Line";
    begin
        Clear(Sline);
        Clear(Sheader);
        Sheader.SetRange("Document Type", Sheader."Document Type"::Order);
        Sheader.SetRange("No.", SONo);
        if Sheader.FindFirst() then begin
            Sline.SetRange("Document Type", Sheader."Document Type");
            Sline.SetRange("Document No.", Sheader."No.");
            Sline.SetRange("Line No.", SOLineNo);
            if Sline.FindFirst() then begin
                Sline."PO No." := '';
                Sline."PO Line No." := 0;
                Sline.Modify();
            end;
        end;
    end;

}
