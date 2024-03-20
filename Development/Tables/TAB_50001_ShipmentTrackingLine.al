TABLE 50001 "Tracking Shipment Line"
{
    DataClassification = ToBeClassified;
    Permissions = TableData "Purch. Rcpt. Line" = m;
    FIELDS
    {
        FIELD(1; "Tracking Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(3; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order), Status = filter(Released));
            ValidateTableRelation = false;
            TRIGGER OnValidate()
            VAR
                PurchaseHeader: Record "Purchase Header";
                PurchaseLine: Record "Purchase Line";
            BEGIN

                if xRec."PO No." <> '' then
                    if xRec."PO No." <> "PO No." then begin
                        CheckPOPosted(xRec."PO No.", "PO Line No.");
                        ResetPOLine(xRec."PO No.", "PO Line No.");
                        //UpdatePOLine("PO No.", 0);
                    end;

                if PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, "PO No.") then begin
                    "Buy From Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                    "Buy From Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                    "PO Line No." := 0;
                end else begin
                    "Buy From Vendor No." := '';
                    "Buy From Vendor Name" := '';
                    "PO Line No." := 0;
                end;

            END;
        }
        FIELD(4; "Buy From Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            Editable = false;
        }
        FIELD(5; "Buy From Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(6; "Date of Dispatch"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'ETD';
            TRIGGER OnValidate()
            VAR
                ShipmentTrackingHeader: Record "Tracking Shipment Header";
            BEGIN
                ShipmentTrackingHeader.GET(Rec."Tracking Code");
                ShipmentTrackingHeader.TESTFIELD(Status, ShipmentTrackingHeader.Status::Open);
                IF "Date of Arrival" <> 0D THEN
                    IF "Date of Dispatch" > "Date of Arrival" THEN
                        ERROR('Date of dispatch should be before date of arrival');

                CalculateArrivalDate();

            END;
        }
        FIELD(7; "Date of Arrival"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'ETA';

            TRIGGER OnValidate()
            VAR
                ShipmentTrackingHeader: Record "Tracking Shipment Header";
                PurchLine: Record "Purchase Line";
            BEGIN
                ShipmentTrackingHeader.GET(Rec."Tracking Code");
                IF ShipmentTrackingHeader.Status = ShipmentTrackingHeader.Status::"Pending For Approval" THEN
                    ERROR('Document status should be open to modify the date of arrival');

                IF "Date of Dispatch" <> 0D THEN
                    IF "Date of Dispatch" > "Date of Arrival" THEN
                        ERROR('Date of arrival should be after date of dispatch');

                IF ShipmentTrackingHeader.Status = ShipmentTrackingHeader.Status::Released THEN BEGIN
                    IF NOT CONFIRM('Date of Arrival is modified. Please get the approval for changes to be affected, Do you want to continue?', FALSE) THEN
                        EXIT;

                    IF "Date of Arrival" = 0D THEN
                        ERROR('Date of Arrival should not be blank');

                    IF xRec."Date of Arrival" > Rec."Date of Arrival" THEN
                        "Delayed by Days" := Rec."Date of Arrival" - xRec."Date of Arrival"
                    ELSE
                        "Delayed by Days" := xRec."Date of Arrival" - Rec."Date of Arrival";

                    ShipmentTrackingHeader."Notification Sent" := FALSE;
                    ShipmentTrackingHeader.Status := ShipmentTrackingHeader.Status::Open;
                    ShipmentTrackingHeader.MODIFY;

                    if PurchLine.Get(PurchLine."Document Type"::Order, "PO No.", "PO Line No.") then begin
                        PurchLine.Validate("Expected Receipt Date1", "Date of Arrival");
                        PurchLine.Modify();
                    end;
                END;
            END;
        }
        FIELD(8; "Delayed by Days"; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 1;

            TRIGGER OnValidate()
            VAR
                ShipmentTrackingHeader: Record "Tracking Shipment Header";
            BEGIN
                TestStatusOpen();
                ShipmentTrackingHeader.GET(Rec."Tracking Code");
                IF ShipmentTrackingHeader.Status = ShipmentTrackingHeader.Status::"Pending For Approval" THEN
                    ERROR('Document status pending for approval');

                IF "Delayed by Days" < 1 THEN
                    ERROR('Delayed days should be more than 1');

                CalculateArrivalDate();
                // IF ShipmentTrackingHeader.Status = ShipmentTrackingHeader.Status::Released THEN BEGIN
                //     IF NOT CONFIRM('Shipment is delayed. Please get the approval for changes to be affected, Do you want to continue?', FALSE) THEN
                //         EXIT;

                //     IF "Delayed by Days" < 1 THEN
                //         ERROR('Delayed by days should not be blank');

                //     ShipmentTrackingHeader.Status := ShipmentTrackingHeader.Status::Open;
                //     //PCalculateArrivalDate();
                //     ShipmentTrackingHeader.MODIFY;

                // END;
            END;

        }
        field(9; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Order), "Document No." = field("PO No."), "Shipment Tracking Line No." = filter(= 0));
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Order), "Document No." = field("PO No."));
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                TestStatusOpen();
                if xRec."PO Line No." <> 0 then
                    if xRec."PO Line No." <> "PO Line No." then begin
                        CheckPOPosted(Rec."PO No.", xRec."PO Line No.");
                        ResetPOLine("PO No.", xRec."PO Line No.");
                    end;
                SelectedPOLineExists(Rec."PO No.", Rec."PO Line No.");
                if "PO Line No." <> 0 then
                    UpdatePOLine("PO No.", "PO Line No.");
            end;
        }
        field(10; "Item No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;
            Editable = false;

        }
        field(11; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Shipped Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
            end;
        }
        field(13; "PO Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Transit Quantity';
        }
        field(14; "Shipment Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Estimated Surcharge Income';
            Editable = false;
        }
        field(15; "Pallet Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
                if "Receipt Line No." <> 0 then
                    UpdateRcptLine("Receipt No.", "Receipt Line No.", "PO No.", "PO Line No.");

            end;
        }
        FIELD(20; "Delivery Lead Time"; DateFormula)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateArrivalDate();
            end;
        }
        FIELD(21; "Allocate Surcharge"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = true;

        }
        field(22; "Receipt Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purch. Rcpt. Line"."Line No." where("Document No." = field("Receipt No."), "Order No." = field("PO No."), "Order Line No." = field("PO Line No."));
            trigger OnValidate()
            begin
                TestStatusOpen();
                SelectedRcptLineExists("Receipt No.", "Receipt Line No.", Rec."PO No.", Rec."PO Line No.");
                if "Receipt Line No." <> 0 then
                    UpdateRcptLine("Receipt No.", "Receipt Line No.", "PO No.", "PO Line No.");
            end;
        }
        field(23; "Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purch. Rcpt. Header"."No." where("Order No." = field("PO No."));
            trigger OnValidate()
            begin
                TestStatusOpen();
                if xRec."Receipt No." <> '' then
                    if xRec."Receipt No." <> "Receipt No." then begin
                        ResetRcptLine(xRec."PO No.", "PO Line No.");
                        "Receipt Line No." := 0;
                    end;
            end;
        }
        field(31; "Total CBM"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
            trigger OnValidate()
            begin
                TestStatusOpen();
                //if "Receipt Line No." <> 0 then
                //    UpdateRcptLine("Receipt No.", "Receipt Line No.", "PO No.", "PO Line No.");
            end;
        }
        field(36; "Total Gross (KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
            trigger OnValidate()
            begin
                TestStatusOpen();
                //if "Receipt Line No." <> 0 then
                //    UpdateRcptLine("Receipt No.", "Receipt Line No.", "PO No.", "PO Line No.");
            end;
        }
        field(37; "Total Net (KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
            trigger OnValidate()
            begin
                TestStatusOpen();
                //if "Receipt Line No." <> 0 then
                //    UpdateRcptLine("Receipt No.", "Receipt Line No.", "PO No.", "PO Line No.");
            end;
        }
    }

    KEYS
    {
        KEY(PK; "Tracking Code", "Line No.")
        {
            Clustered = true;
        }
    }

    VAR
        RecHdr: Record "Tracking Shipment Header";

    TRIGGER OnInsert()
    BEGIN
        Clear(RecHdr);
        RecHdr.GET(Rec."Tracking Code");
        RecHdr.TestField(Status, RecHdr.Status::Open);
        if "PO Line No." <> 0 then
            UpdatePOLine("PO No.", "PO Line No.");
        if "Receipt Line No." <> 0 then
            UpdateRcptLine("Receipt No.", "Receipt Line No.", "PO No.", "PO Line No.");
    END;

    TRIGGER OnModify()
    BEGIN
        //UpdatePOLine("PO No.", "PO Line No.");
    END;

    TRIGGER OnDelete()
    BEGIN
        CheckPOPosted("PO No.", "PO Line No.");
        ResetPOLine("PO No.", "PO Line No.");
        ResetRcptLine("Receipt No.", "Receipt Line No.");//New
    END;

    TRIGGER OnRename()
    BEGIN

    END;

    local procedure SelectedPOLineExists(PONo: Code[20]; POLineNo: Integer)
    var
        ShipmentTrackingLine: Record "Tracking Shipment Line";
        PurchaseLine: Record "Purchase Line";
        PurchaseLineExists: TextConst ENU = 'Purchase Order %1 and Line %2 already selected';
    begin
        /*
        ShipmentTrackingLine.SetRange("Tracking Code", "Tracking Code");
        ShipmentTrackingLine.SetRange("Line No.", "Line No.");
        ShipmentTrackingLine.SetRange("PO No.", PONo);
        ShipmentTrackingLine.SetRange("PO Line No.", POLineNo);
        if ShipmentTrackingLine.FindFirst() then
            Error(PurchaseLineExists, PONo, POLineNo);
        */
    end;

    local procedure SelectedRcptLineExists(RcptNo: Code[20]; RcptLineNo: Integer; PONo: Code[20]; POLineNo: Integer)
    var
        ShipmentTrackingLine: Record "Tracking Shipment Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchaseRcptLineExists: TextConst ENU = 'Purchase Receipt %1 and Line %2 already selected on Shipment Tracking %3.';
    begin
        //ShipmentTrackingLine.SetRange("Tracking Code", "Tracking Code");
        //ShipmentTrackingLine.SetRange("Line No.", "Line No.");
        ShipmentTrackingLine.SetRange("PO No.", PONo);
        ShipmentTrackingLine.SetRange("PO Line No.", POLineNo);
        ShipmentTrackingLine.SetRange("Receipt No.", RcptNo);
        ShipmentTrackingLine.SetRange("Receipt Line No.", RcptLineNo);
        if ShipmentTrackingLine.FindFirst() then
            Error(PurchaseRcptLineExists, PONo, POLineNo, ShipmentTrackingLine."Tracking Code");
    end;

    local procedure ResetPOLine(PONo: Code[20]; POLineNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", PONo);
        PurchaseLine.SetRange("Line No.", POLineNo);
        if PurchaseLine.FindFirst() then
            repeat
                PurchaseLine."Shipment Tracking Code" := '';
                PurchaseLine."Shipment Tracking Line No." := 0;
                PurchaseLine.Modify()
            until PurchaseLine.Next() = 0;
        if ("Receipt Line No." = 0) then begin
            "Item No." := '';
            Description := '';
            "PO Quantity" := 0;
        end;
    end;

    local procedure ResetRcptLine(RcptNo: Code[20]; RcptLineNo: Integer)
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.SetRange("Document No.", RcptNo);
        PurchRcptLine.SetRange("Line No.", RcptLineNo);
        if PurchRcptLine.FindFirst() then
            repeat
                PurchRcptLine."Shipment Tracking Code" := '';
                PurchRcptLine."Shipment Tracking Line No." := 0;
                PurchRcptLine."Pallet Quantity" := 0;
                PurchRcptLine."Total CBM" := 0;
                PurchRcptLine."Total Gross (KG)" := 0;
                PurchRcptLine."Total Net (KG)" := 0;
                PurchRcptLine.Modify()
            until PurchRcptLine.Next() = 0;
    end;

    procedure CheckPOPosted(PONo: Code[20]; POLineNo: Integer)
    var
        PurchaseInvLine: Record "Purch. Inv. Line";
        PostedPurchaseLineExists: TextConst ENU = 'Purchase Order %1 and Line %2 already have posted entries';
    begin
        PurchaseInvLine.SetRange("Shipment Tracking Code", "Tracking Code");
        PurchaseInvLine.SetRange("Shipment Tracking Line No.", "Line No.");
        if PurchaseInvLine.FindFirst() then begin
            Error(PostedPurchaseLineExists, "PO No.", "PO Line No.");
        end;
        CheckSOPosted(PONo, POLineNo);
    end;

    procedure CheckSOPosted(PONo: Code[20]; POLineNo: Integer)
    var
        SalesInvLine: Record "Sales Invoice Line";
        PostedSalesLineExists: TextConst ENU = 'Sale Order %1 and Line %2 already have posted entries';
    begin
        SalesInvLine.SetRange("Shipment Tracking Code", "Tracking Code");
        SalesInvLine.SetRange("Shipment Tracking Line No.", "Line No.");
        if SalesInvLine.FindFirst() then begin
            Error(PostedSalesLineExists, SalesInvLine."Order No.", SalesInvLine."Order Line No.");
        end;
    end;

    local procedure UpdatePOLine(PONo: Code[20]; POLineNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;

    begin
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", PONo);
        //if POLineNo <> 0 then
        PurchaseLine.SetRange("Line No.", POLineNo);
        if PurchaseLine.FindFirst() then
            repeat
                if Item.Get(PurchaseLine."No.") then
                    if Item.Type = Item.Type::Inventory then
                        if Item."No. of items/pallet" = 0 then
                            Error('No. of Items/pallet must be filled for Item %1', PurchaseLine."No.");

                PurchaseLine."Shipment Tracking Code" := Rec."Tracking Code";
                //if POLineNo <> 0 then
                PurchaseLine."Shipment Tracking Line No." := Rec."Line No.";
                //PurchaseLine.Validate("Total Gross (KG)", "Total Gross (KG)");
                //PurchaseLine.Validate("Total CBM", "Total CBM");
                PurchaseLine.Validate(PurchaseLine."Expected Receipt Date1", "Date of Arrival");
                PurchaseLine.Modify();
                if POLineNo <> 0 then begin
                    "Item No." := PurchaseLine."No.";
                    Description := PurchaseLine.Description;
                    "PO Quantity" := PurchaseLine.Quantity;
                    "Total CBM" := PurchaseLine."Total CBM";
                    "Total Gross (KG)" := PurchaseLine."Total Gross (KG)";
                    "Total Net (KG)" := PurchaseLine."Total Net (KG)";
                    //Validate("Date of Arrival", PurchaseLine."Expected Receipt Date1");                    
                end;
            until PurchaseLine.Next() = 0;
    end;

    local procedure UpdateRcptLine(RcptNo: Code[20]; RcptLineNo: integer; PONo: Code[20]; POLineNo: Integer)
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TrackShptHeader: Record "Tracking Shipment Header";
    begin
        PurchRcptLine.SetRange("Document No.", RcptNo);
        PurchRcptLine.SetRange("Line No.", RcptLineNo);
        PurchRcptLine.SetRange("Order No.", PONo);
        //if POLineNo <> 0 then
        PurchRcptLine.SetRange("Order Line No.", POLineNo);
        if PurchRcptLine.FindFirst() then begin
            PurchRcptLine."Shipment Tracking Code" := Rec."Tracking Code";
            //if POLineNo <> 0 then
            PurchRcptLine."Shipment Tracking Line No." := Rec."Line No.";
            "Item No." := PurchRcptLine."No.";
            Description := PurchRcptLine.Description;
            "Total CBM" := PurchRcptLine."Total CBM";
            "Total Gross (KG)" := PurchRcptLine."Total Gross (KG)";
            "Pallet Quantity" := PurchRcptLine."Gross Weight";
            //"Pallet Quantity" := PurchRcptLine."Pallet Quantity";
            "Total Net (KG)" := PurchRcptLine."Total Net (KG)";
            "Buy From Vendor No." := PurchRcptLine."Buy-from Vendor No.";
            "Buy From Vendor Name" := PurchRcptLine."Buy-from Vendor Name";
            if TrackShptHeader.Get(Rec."Tracking Code") then begin
                PurchRcptLine."Milestone Status" := TrackShptHeader."Milestone Status";
            end;

            if PurchRcptLine.Quantity <> 0 then
                PurchRcptLine."Unit Volume" := rec."Pallet Quantity" / PurchRcptLine.Quantity;
            PurchRcptLine.Modify();
            if RcptLineNo <> 0 then begin
                "PO Quantity" := PurchRcptLine.Quantity;
            end;
        end;
    end;

    procedure CalculateArrivalDate()
    VAR
        DelByDay: DateFormula;
        Expr1: Text[30];
    BEGIN
        Expr1 := FORMAT('<' + Format("Delivery Lead Time") + '+' + FORMAT("Delayed by Days") + 'D' + '>');
        //"Date of Arrival" := CalcDate(FORMAT("Delivery Lead Time" + ("Delayed by Days" + 'D')), "Date of Dispatch");
        if "Date of Dispatch" <> 0D then
            "Date of Arrival" := CalcDate(Expr1, "Date of Dispatch")
        else
            "Date of Arrival" := 0D;
        //"Date of Arrival" := CalcDate("Delivery Lead Time", "Date of Dispatch")
    end;

    procedure TestStatusOpen()
    VAR
        ShipTrackHead: Record "Tracking Shipment Header";
    BEGIN
        if ShipTrackHead.Get("Tracking Code") then
            ShipTrackHead.TestField(Status, ShipTrackHead.Status::Open);
    end;
}