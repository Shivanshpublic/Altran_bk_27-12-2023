TABLE 50000 "Tracking Shipment Header"
{
    DataClassification = ToBeClassified;
    Permissions = TableData "Purch. Cr. Memo Line" = rm, TableData "Purch. Inv. Line" = rm,
TableData "Return Shipment Line" = rm, TableData "Purch. Rcpt. Line" = rm,
TableData "Sales Cr.Memo Line" = rm, TableData "Sales Shipment Line" = rm,
TableData "Return Receipt Line" = rm, TableData "Sales Invoice Line" = rm;

    FIELDS
    {
        FIELD(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(2; Status; Enum ShipTrackStatus)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(3; "Container No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(4; "Port of Dispatch"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(5; "Date of Dispatch"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Dispatch Date';
            trigger OnValidate()
            var
                TrackingShipmentLine: Record "Tracking Shipment Line";
            begin
                TrackingShipmentLine.Reset();
                TrackingShipmentLine.SetRange("Tracking Code", Rec.Code);
                if TrackingShipmentLine.FindFirst() then
                    repeat
                        TrackingShipmentLine.Validate("Date Of Dispatch", "Date Of Dispatch");
                        TrackingShipmentLine.Modify();
                    until TrackingShipmentLine.Next() = 0;
            end;
        }
        FIELD(6; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(7; "Supplier Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Supplier Name';
        }
        FIELD(8; "Freight Details"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'BL/AWB #';
        }
        FIELD(9; "Created Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(10; "Modified Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(11; "Notification Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Reference No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
        }
        field(14; "Total Shipment Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                SurchargeLineExists();
                //CalculateSurcharge();
            end;
        }
        field(15; "Surcharge Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Additional Revenue"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Surcharge Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 1;
            NotBlank = true;
            trigger OnValidate()
            begin
                SurchargeLineExists();
                //CalculateSurcharge();
            end;
        }
        FIELD(18; "Sub Status"; Enum ShipTrackSubStatus)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if (xRec."Sub Status" = xRec."Sub Status"::"Surcharge Calculated") and (Rec."Sub Status" = Rec."Sub Status"::" ") then
                    SurchargeLineExists();
            end;
        }
        FIELD(19; "MMSI Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(21; "Surcharge Allocated to SO"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(22; "Supplier No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Tablerelation = Vendor;
            Caption = 'Supplier No.';
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Supplier No.") then
                    "Supplier Name" := Vendor.Name
                else
                    "Supplier Name" := ''
            end;
        }
        FIELD(23; "MBL"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(24; "HBL"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        FIELD(25; "Total Quantity"; Decimal)
        {
            CalcFormula = Sum("Tracking Shipment Line"."PO Quantity" WHERE("Tracking Code" = FIELD(Code)));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        FIELD(26; "Pallet Quantity"; Decimal)
        {
            CalcFormula = Sum("Tracking Shipment Line"."Pallet Quantity" WHERE("Tracking Code" = FIELD(Code)));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

        }
        FIELD(27; "Delivery Lead Time"; DateFormula)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                TrackingShipmentLine: Record "Tracking Shipment Line";
            begin
                TrackingShipmentLine.Reset();
                TrackingShipmentLine.SetRange("Tracking Code", Rec.Code);
                if TrackingShipmentLine.FindFirst() then
                    repeat
                        TrackingShipmentLine.Validate("Delivery Lead Time", "Delivery Lead Time");
                        TrackingShipmentLine.Modify();
                    until TrackingShipmentLine.Next() = 0;
            end;
        }
        field(31; "Total CBM"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            CalcFormula = Sum("Tracking Shipment Line"."Total CBM" WHERE("Tracking Code" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        FIELD(32; "FCL/LCL"; Enum FCL_LCL_Option)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(33; "Port of Load"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Milestone Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Status';
            TableRelation = "Milestone Status";
        }
    }

    KEYS
    {
        KEY(PK; Code)
        {
            Clustered = true;
        }
    }


    TRIGGER OnInsert()
    var
        recNoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedSetup: Record "General Ledger Setup";
    BEGIN
        GenLedSetup.GET;
        GenLedSetup.TestField("Shipment Tracking Nos.");
        if Code = '' then begin
            Code := recNoSeriesMgt.GetNextNo(GenLedSetup."Shipment Tracking Nos.", Today, true);
        end;

        IF Code <> '' THEN
            Status := Status::Open;

        "Created Date" := WorkDate();
    END;

    TRIGGER OnModify()
    BEGIN
        TESTFIELD(Code);
    END;

    TRIGGER OnDelete()
    VAR
        ShipmentTrackingLog: Record "Tracking Shipment Log";
        ShipmentTrackingLine: Record "Tracking Shipment Line";
    BEGIN
        ShipmentTrackingLine.RESET;
        ShipmentTrackingLine.SETRANGE("Tracking Code", Rec.Code);
        IF ShipmentTrackingLine.FINDFIRST THEN
            ShipmentTrackingLine.DELETEALL;

        ShipmentTrackingLog.RESET;
        ShipmentTrackingLog.SETRANGE("Tracking Code", Rec.Code);
        IF ShipmentTrackingLog.FINDFIRST THEN
            ShipmentTrackingLog.DELETEALL;
    END;

    TRIGGER OnRename()
    VAR
        ShipmentTrackingLog: Record "Tracking Shipment Log";
        ShipmentTrackingLine: Record "Tracking Shipment Line";
    BEGIN
        ShipmentTrackingLine.RESET;
        ShipmentTrackingLine.SETRANGE("Tracking Code", Rec.Code);
        IF ShipmentTrackingLine.FINDFIRST THEN BEGIN
            REPEAT
                ShipmentTrackingLine.RENAME(Rec.Code, ShipmentTrackingLine."Line No.");
            UNTIL ShipmentTrackingLine.NEXT = 0;
        END;
        ShipmentTrackingLog.RESET;
        ShipmentTrackingLog.SETRANGE("Tracking Code", Rec.Code);
        IF ShipmentTrackingLog.FINDFIRST THEN BEGIN
            REPEAT
                ShipmentTrackingLog."Tracking Code" := Rec.Code;
                ShipmentTrackingLog.MODIFY;
            UNTIL ShipmentTrackingLog.NEXT = 0;
        END;
    END;

    procedure CalculateSurcharge()
    VAR
        ShipmentTrackingLine: Record "Tracking Shipment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        TotPalletQty: Decimal;
        ConfirmSOAllocation: Label 'Do you wish calculated surcharge value to be allocated on the sales order ?';
        ConfirmSOAlloc: Boolean;
    BEGIN
        TestField("Status", "Status"::Released);
        SalesSetup.Get();
        SurchargeLineExists();
        if Confirm(ConfirmSOAllocation, false) then
            ConfirmSOAlloc := true
        else
            ConfirmSOAlloc := false;

        Validate("Surcharge Limit", SalesSetup."Surcharge Limit");
        //Validate("Additional Revenue", ("Total Shipment Cost" - SalesSetup."Surcharge Limit") * "Surcharge Factor");
        Validate("Additional Revenue", ("Total Shipment Cost" - SalesSetup."Surcharge Limit") * "Surcharge Factor");

        ShipmentTrackingLine.Reset;
        ShipmentTrackingLine.SetRange("Tracking Code", Rec.Code);
        ShipmentTrackingLine.SetRange("Allocate Surcharge", true);
        ShipmentTrackingLine.CalcSums("Pallet Quantity");
        TotPalletQty := ShipmentTrackingLine."Pallet Quantity";
        if ShipmentTrackingLine.FindFirst() then
            repeat
                ShipmentTrackingLine.CheckPOPosted(ShipmentTrackingLine."PO No.", ShipmentTrackingLine."PO Line No.");
                if TotPalletQty > 0 then begin
                    ShipmentTrackingLine."Shipment Cost" := (ShipmentTrackingLine."Pallet Quantity" / TotPalletQty) * Rec."Additional Revenue";
                end else begin
                    ShipmentTrackingLine."Shipment Cost" := 0;
                end;
                ShipmentTrackingLine.Modify();
                if ConfirmSOAlloc then
                    InsertSalesSurcharge(ShipmentTrackingLine);
            until ShipmentTrackingLine.Next() = 0;
        if ConfirmSOAlloc then begin
            Rec."Sub Status" := Rec."Sub Status"::"Surcharge Calculated";
            Rec."Surcharge Allocated to SO" := true;
        end;
        Rec.Modify();
    end;

    procedure InsertSalesSurcharge(VAR ShipmentTrackingLine: Record "Tracking Shipment Line")
    VAR
        PurchaseLine: Record "Purchase Line";
        PurchaseHead: Record "Purchase Header";
        SalesLine: Record "Sales Line";
        SalesHead: Record "Sales Header";
        SalesLine1: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
    BEGIN
        SalesSetup.Get();
        SalesSetup.TestField("Un earned surcharge account");

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document No.", ShipmentTrackingLine."PO No.");
        PurchaseLine.SetRange("Line No.", ShipmentTrackingLine."PO Line No.");
        if PurchaseLine.FindFirst() then begin
            PurchaseHead.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            PurchaseHead.TestField(Status, PurchaseHead.Status::Released);
            if SalesLine1.Get(PurchaseLine."Document Type"::Order, PurchaseLine."SO No.", PurchaseLine."SO Line No.") then begin
                SalesHead.Get(SalesLine1."Document Type", SalesLine1."Document No.");
                SalesHead.TestField(Status, SalesHead.Status::Released);
                SalesLine1.TestField("Quantity Shipped", 0);
                ShipmentLineExists(SalesLine1);
                InvoiceLineExists(SalesLine1);
                SalesLine.SuspendStatusCheck(true);
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesLine1."Document Type");
                SalesLine.Validate("Document No.", SalesLine1."Document No.");
                SalesLine.Validate("Line No.", SalesLine1."Line No." + 5);
                SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                SalesLine.Validate("No.", SalesSetup."Un earned surcharge account");
                SalesLine.Validate("Location Code", SalesLine1."Location Code");
                SalesLine.Validate(Quantity, SalesLine1.Quantity);
                if SalesLine.Quantity <> 0 then
                    SalesLine1."Surcharge Per Qty." := (ShipmentTrackingLine."Shipment Cost" / SalesLine.Quantity);
                SalesLine.Validate("Unit Price", SalesLine1."Surcharge Per Qty.");
                SalesLine.Validate("Surcharge Per Qty.", SalesLine1."Surcharge Per Qty.");
                SalesLine.Validate("Tax Group Code", SalesLine1."Tax Group Code");
                SalesLine."Shipment Tracking Code" := ShipmentTrackingLine."Tracking Code";
                SalesLine."Shipment Tracking Line No." := ShipmentTrackingLine."Line No.";
                SalesLine.Insert(true);
                SalesLine1."Shipment Tracking Code" := ShipmentTrackingLine."Tracking Code";
                SalesLine1."Shipment Tracking Line No." := ShipmentTrackingLine."Line No.";
                SalesLine1.Modify();
            end;
        end;
    end;

    procedure ResetSurcharge()
    VAR
        ShipmentTrackingLine: Record "Tracking Shipment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        TotPalletQty: Decimal;
        ResetAllocation: Label 'Surcharge allocated to Sales Order line will be deleted.';
        ConfirmSOAlloc: Boolean;
    BEGIN
        TestField("Status", "Status"::Released);
        SalesSetup.Get();
        Message(ResetAllocation);

        ShipmentTrackingLine.Reset;
        ShipmentTrackingLine.SetRange("Tracking Code", Rec.Code);
        ShipmentTrackingLine.SetRange("Allocate Surcharge", true);
        if ShipmentTrackingLine.FindFirst() then
            repeat
                ShipmentTrackingLine."Shipment Cost" := 0;
                ShipmentTrackingLine.Modify();
            until ShipmentTrackingLine.Next() = 0;
        DeleteSalesSurcharge(Rec);
    end;

    procedure DeleteSalesSurcharge(VAR ShipmentTrackingHead: Record "Tracking Shipment Header")
    VAR
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
    BEGIN
        SalesSetup.Get();
        SalesSetup.TestField("Un earned surcharge account");
        SalesLine.SetRange("Shipment Tracking Code", ShipmentTrackingHead.Code);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindFirst() then begin
            SalesLine.Validate("Surcharge Per Qty.", 0);
            SalesLine."Shipment Tracking Code" := '';
            SalesLine."Shipment Tracking Line No." := 0;
            SalesLine.Modify();
        end;

        SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
        SalesLine.SetRange("No.", SalesSetup."Un earned surcharge account");
        if SalesLine.FindFirst() then begin
            SalesLine.DeleteAll();
        end;
    end;

    procedure SurchargeLineExists()
    VAR
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ErrSalesLineExist: TextConst ENU = 'Surcharge Sales Line already exists linked to it.';
        SalesShipLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        ErrShipLineExist: TextConst ENU = 'Shipment Sales Line already exists linked to Sales Order %1.';
        ErrInvLineExist: TextConst ENU = 'Invoice Sales Line already exists linked to Sales Order %1.';
    BEGIN
        SalesSetup.Get();
        TestField("Sub Status", "Sub Status"::" ");
        SalesShipLine.SetRange("Shipment Tracking Code", Rec.Code);
        SalesShipLine.SetRange(Type, SalesShipLine.Type::Item);
        SalesShipLine.SetFilter("Quantity", '<>%1', 0);
        if SalesShipLine.FindFirst() then
            Error(ErrShipLineExist, SalesShipLine."Document No.");

        SalesInvLine.SetRange("Shipment Tracking Code", Rec.Code);
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetFilter("Quantity", '<>%1', 0);
        if SalesInvLine.FindFirst() then
            Error(ErrInvLineExist, SalesInvLine."Document No.");

        ResetSurcharge();

        // SalesLine.SetRange("Shipment Tracking Code", Rec.Code);
        // SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
        // SalesLine.SetRange("No.", SalesSetup."Un earned surcharge account");
        // if SalesLine.FindFirst() then
        //     Error(ErrSalesLineExist);

    end;

    procedure ShipmentLineExists(SalesLine: Record "Sales Line")
    VAR
        SalesShipLine: Record "Sales Shipment Line";
        ErrShipLineExist: TextConst ENU = 'Shipment Sales Line already exists linked to Sales Order %1.';
    BEGIN
        SalesShipLine.SetRange("Order No.", SalesLine."Document No.");
        SalesShipLine.SetRange(Type, SalesShipLine.Type::Item);
        SalesShipLine.SetFilter("Quantity", '<>%1', 0);
        if SalesShipLine.FindFirst() then
            Error(ErrShipLineExist, SalesShipLine."Document No.");
    end;

    procedure InvoiceLineExists(SalesLine: Record "Sales Line")
    VAR
        SalesInvLine: Record "Sales Invoice Line";
        ErrInvLineExist: TextConst ENU = 'Invoice Sales Line already exists linked to Sales Order %1.';
    BEGIN
        SalesInvLine.SetRange("Order No.", SalesLine."Document No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetFilter("Quantity", '<>%1', 0);
        if SalesInvLine.FindFirst() then
            Error(ErrInvLineExist, SalesInvLine."Document No.");
    end;

    procedure UpdateRcptLine()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TrackShptLine: Record "Tracking Shipment Line";
    begin
        TrackShptLine.Reset();
        TrackShptLine.SetRange("Tracking Code", Rec.Code);
        TrackShptLine.SetFilter("Receipt No.", '<>%1', '');
        TrackShptLine.SetFilter("Receipt Line No.", '<>%1', 0);
        if TrackShptLine.FindFirst() then
            repeat
                PurchRcptLine.SetRange("Document No.", TrackShptLine."Receipt No.");
                PurchRcptLine.SetRange("Line No.", TrackShptLine."Receipt Line No.");
                if PurchRcptLine.FindFirst() then begin
                    PurchRcptLine."Milestone Status" := "Milestone Status";
                    PurchRcptLine.Modify();
                end;
            until TrackShptLine.Next() = 0;
    end;
}