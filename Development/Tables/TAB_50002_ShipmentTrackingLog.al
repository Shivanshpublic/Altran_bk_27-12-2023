TABLE 50002 "Tracking Shipment Log"
{
    DataClassification = ToBeClassified;

    FIELDS
    {
        FIELD(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = TRUE;
        }
        FIELD(2; "Tracking Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Header".Code;
        }
        FIELD(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Line"."Line No." where("Tracking Code" = field("Tracking Code"), "Line No." = field("Line No."));
            trigger OnValidate()
            var
                ShipmentTrackingLine: Record "Tracking Shipment Line";
                ShipmentTracking: Record "Tracking Shipment Header";
                PurchaseHead: Record "Purchase Header";
                PurchaseLine: Record "Purchase Line";
                SalesHead: Record "Sales Header";
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if ShipmentTrackingLine.Get("Tracking Code", "Line No.") then begin
                    ShipmentTracking.Get("Tracking Code");
                    "MMSI Code" := ShipmentTracking."MMSI Code";
                    "PO No." := ShipmentTrackingLine."PO No.";
                    "PO Line No." := ShipmentTrackingLine."PO Line No.";
                    if PurchaseHead.Get(PurchaseHead."Document Type"::Order, "PO No.") then begin
                        Rec."Buy From Vendor No." := PurchaseHead."Buy-from Vendor No.";
                        Rec."Buy From Vendor Name" := PurchaseHead."Buy-from Vendor Name";
                        if PurchaseLine.Get(PurchaseLine."Document Type"::Order, ShipmentTrackingLine."PO No.", ShipmentTrackingLine."PO Line No.") then begin
                            if PurchaseLine."Sales Order No." <> '' then
                                if SalesHead.Get(SalesHead."Document Type"::Order, PurchaseLine."Sales Order No.") then
                                    if Salesperson.Get(SalesHead."Salesperson Code") then begin
                                        "Salesperson Code" := Salesperson.Code;
                                        "Salesperson Email ID" := Salesperson."E-Mail";
                                    end;
                        end;
                    end;

                    "Date of Dispatch" := ShipmentTrackingLine."Date of Dispatch";
                    "Delivery Lead Time" := ShipmentTrackingLine."Delivery Lead Time";
                    "Date of Arrival" := ShipmentTrackingLine."Date of Arrival";
                    "Delayed by Days" := ShipmentTrackingLine."Delayed by Days";
                    "New Arrival Date" := ShipmentTrackingLine."Date of Arrival";
                end;
            end;
        }
        FIELD(4; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order), Status = filter(Released));
            Editable = false;
            ValidateTableRelation = false;
        }
        FIELD(5; "Buy From Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            Editable = false;
        }
        FIELD(6; "Buy From Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(7; "Date of Dispatch"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(8; "Date of Arrival"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateDelays();
            end;
        }
        FIELD(9; "Created Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(10; "Modified Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(11; "New Arrival Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                DispDate: Date;
            begin
                if "Date of Dispatch" = DispDate then
                    "Date of Dispatch" := "New Arrival Date";
                "Delayed by Days" := ("New Arrival Date" - "Date of Dispatch") - "Delivery Lead Time";
            end;
        }
        FIELD(12; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = FALSE;
            Editable = false;
        }
        FIELD(13; "Delayed by Days"; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "Delayed by Days" <> 0 THEN BEGIN
                    "Delayed by Days" := "Delayed by Days";
                    "New Arrival Date" := CALCDATE(FORMAT("Delayed by Days") + 'D', "Date of Arrival");
                END;
            end;
        }

        FIELD(14; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = FALSE;
            Editable = false;
        }
        FIELD(19; "MMSI Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
            begin

            end;
        }
        field(20; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Order), "Document No." = field("PO No."), "Shipment Tracking Line No." = filter(= 0));
            Editable = false;
            ValidateTableRelation = false;
        }
        FIELD(21; "Shipment Date Updated on SO"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(22; "Notification Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(23; "Approved by"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(24; "Delivery Lead Time"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(25; "Salesperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
            //Editable = false;
        }
        FIELD(26; "Salesperson Email ID"; Text[80])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
        }
        FIELD(27; "Created by API"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(28; ETA; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(29; "ETA Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIELD(30; "ETA Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    KEYS
    {
        KEY(PK; "Entry No.")
        {
            Clustered = true;
        }
    }


    TRIGGER OnInsert()
    BEGIN
        "Created Date" := WORKDATE;
        "Created By" := UserId;
        "Modified By" := UserId;
        "Modified Date" := WORKDATE;

    END;

    TRIGGER OnModify()
    BEGIN
        "Modified By" := UserId;
        "Modified Date" := WORKDATE;

    END;

    TRIGGER OnDelete()
    BEGIN

    END;

    TRIGGER OnRename()
    BEGIN

    END;

    procedure CalculateDelays()
    begin
        Rec."Delayed by Days" := ("Date of Arrival" - "Date of Dispatch") - "Delivery Lead Time";
    end;

    PROCEDURE CreateShipmentLog(MMSICode: Text[30]; ETA: Text[30])
    VAR
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CurrentPOStatus: Enum "Purchase Document Status";
        CurrentSOStatus: Enum "Sales Document Status";
        ShipmentTrackingLog: Record "Tracking Shipment Log";
        ShipmentTrackingLog2: Record "Tracking Shipment Log";
        ShipmentTrackingLine: Record "Tracking Shipment Line";
        ShipmentTrackingHeader: Record "Tracking Shipment Header";
        Ok: Boolean;
    BEGIN
        ShipmentTrackingHeader.SetRange("MMSI Code", MMSICode);
        if ShipmentTrackingHeader.FindFirst() then
            repeat
                //until ShipmentTrackingHeader.Next() = 0;
                ShipmentTrackingLine.RESET;
                ShipmentTrackingLine.SETRANGE("Tracking Code", ShipmentTrackingHeader.Code);
                IF ShipmentTrackingLine.FINDFIRST THEN BEGIN
                    REPEAT
                        ShipmentTrackingLog.INIT;
                        ShipmentTrackingLog."Entry No." := 0;
                        ShipmentTrackingLog.INSERT;
                        ShipmentTrackingLog.Validate("MMSI Code", MMSICode);
                        ShipmentTrackingLog.Validate("Tracking Code", ShipmentTrackingLine."Tracking Code");
                        ShipmentTrackingLog.Validate("Line No.", ShipmentTrackingLine."Line No.");
                        //ShipmentTrackingLog."PO No." := ShipmentTrackingLine."PO No.";
                        //ShipmentTrackingLog."PO Line No." := ShipmentTrackingLine."PO Line No.";
                        //ShipmentTrackingLog."Buy From Vendor No." := ShipmentTrackingLine."Buy From Vendor No.";
                        //ShipmentTrackingLog."Buy From Vendor Name" := ShipmentTrackingLine."Buy From Vendor Name";
                        //ShipmentTrackingLog."Date of Dispatch" := ShipmentTrackingLine."Date of Dispatch";
                        //ShipmentTrackingLog."Date of Arrival" := ShipmentTrackingLine."Date of Arrival";
                        ShipmentTrackingLog."Created Date" := WORKDATE;
                        ShipmentTrackingLog."Created By" := UserId;
                        ShipmentTrackingLog."Modified By" := UserId;
                        ShipmentTrackingLog."Modified Date" := WORKDATE;
                        ShipmentTrackingLog.ETA := ETA;
                        Ok := Evaluate(ShipmentTrackingLog."ETA Date Time", ETA);
                        ShipmentTrackingLog."ETA Date" := DT2DATE(ShipmentTrackingLog."ETA Date Time");
                        ShipmentTrackingLog.Validate("New Arrival Date", ShipmentTrackingLog."ETA Date");
                        ShipmentTrackingLog."Created by API" := true;
                        ShipmentTrackingLog.Modify();
                    //ShipmentTrackingLog."New Arrival Date" := ;
                    //ShipmentTrackingLog."Delayed by Days" := ;
                    UNTIL ShipmentTrackingLine.NEXT = 0;
                END;
            UNTIL ShipmentTrackingHeader.Next() = 0;

    END;

    PROCEDURE UpdateLinkedDoc(var ShipmentTrackingLog: Record "Tracking Shipment Log")
    VAR
        UserSetup: Record "User Setup";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CurrentPOStatus: Enum "Purchase Document Status";
        CurrentSOStatus: Enum "Sales Document Status";
        ShipmentTrackingLog2: Record "Tracking Shipment Log";
        ShipmentTrackingLine: Record "Tracking Shipment Line";
        ConfirmDocUpdate: Label 'Do you wish to update Shipment date on Sales Order & Expected Receipt Date on Purchase Order ?';
        ConfirmDocument: Boolean;
        Text50001: TextConst ENU = 'Document update Interrupted';
        Text50002: TextConst ENU = 'You are not authorized to approve changes.';
    BEGIN
        UserSetup.Get(UserId);
        if UserSetup."Approve Shipment Tracking Log" = false then
            Error(Text50002);

        if Confirm(ConfirmDocUpdate, false) then
            ConfirmDocument := true
        else begin
            ConfirmDocument := false;
            Error(Text50001);
        end;

        if ShipmentTrackingLine.Get("Tracking Code", "Line No.") then begin
            PurchaseHeader.RESET;
            PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
            PurchaseHeader.SETRANGE("No.", ShipmentTrackingLine."PO No.");
            IF PurchaseHeader.FINDFIRST THEN BEGIN
                CLEAR(CurrentPOStatus);
                IF PurchaseHeader.Status <> PurchaseHeader.Status::Open THEN BEGIN
                    CurrentPOStatus := PurchaseHeader.Status;
                    PurchaseHeader.Status := PurchaseHeader.Status::Open;

                    PurchaseHeader.MODIFY();
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE("Line No.", ShipmentTrackingLine."PO Line No.");
                    PurchaseLine.SETFILTER(Quantity, '<>%1', 0);
                    IF PurchaseLine.FINDFIRST THEN BEGIN
                        REPEAT
                            //SO Changes
                            SalesHeader.RESET;
                            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                            if PurchaseLine."Sales Order No." <> '' then
                                SalesHeader.SETRANGE("No.", PurchaseLine."Sales Order No.")
                            else
                                SalesHeader.SETRANGE("No.", PurchaseLine."SO No.");

                            IF SalesHeader.FINDFIRST THEN BEGIN
                                CLEAR(CurrentSOStatus);
                                IF SalesHeader.Status <> SalesHeader.Status::Open THEN BEGIN
                                    CurrentSOStatus := SalesHeader.Status;
                                    SalesHeader.Status := SalesHeader.Status::Open;
                                    SalesHeader.MODIFY;
                                    SalesLine.RESET;
                                    SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                                    SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                                    SalesLine.SETRANGE("Line No.", PurchaseLine."Sales Order Line No.");
                                    IF SalesLine.FINDFIRST THEN BEGIN
                                        SalesLine."Shipment Date" := ShipmentTrackingLog."New Arrival Date";
                                        SalesLine.MODIFY;
                                    END;
                                    SalesHeader.Status := CurrentSOStatus;
                                    SalesHeader.MODIFY;
                                END
                                ELSE BEGIN
                                    SalesLine.RESET;
                                    SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                                    SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                                    if PurchaseLine."Sales Order Line No." <> 0 then
                                        SalesLine.SETRANGE("Line No.", PurchaseLine."Sales Order Line No.")
                                    else
                                        SalesLine.SETRANGE("Line No.", PurchaseLine."SO Line No.");
                                    IF SalesLine.FINDFIRST THEN BEGIN
                                        SalesLine."Shipment Date" := ShipmentTrackingLog."New Arrival Date";
                                        SalesLine.MODIFY;
                                    END;
                                END;
                            END;
                            //SO Changes
                            PurchaseLine."Expected Receipt Date" := ShipmentTrackingLog."New Arrival Date";
                            PurchaseLine."Shipment Tracking Code" := ShipmentTrackingLine."Tracking Code";
                            PurchaseLine.MODIFY;
                        UNTIL PurchaseLine.NEXT = 0;
                    END;
                    PurchaseHeader.Status := CurrentPOStatus;
                    PurchaseHeader.MODIFY();
                END
                ELSE BEGIN
                    PurchaseHeader.MODIFY();
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE("Line No.", ShipmentTrackingLine."PO Line No.");
                    PurchaseLine.SETFILTER(Quantity, '<>%1', 0);
                    IF PurchaseLine.FINDFIRST THEN BEGIN
                        REPEAT
                            //SO Changes
                            SalesHeader.RESET;
                            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                            if PurchaseLine."Sales Order No." <> '' then
                                SalesHeader.SETRANGE("No.", PurchaseLine."Sales Order No.")
                            else
                                SalesHeader.SETRANGE("No.", PurchaseLine."SO No.");

                            IF SalesHeader.FINDFIRST THEN BEGIN
                                CLEAR(CurrentSOStatus);
                                IF SalesHeader.Status <> SalesHeader.Status::Open THEN BEGIN
                                    CurrentSOStatus := SalesHeader.Status;
                                    SalesHeader.Status := SalesHeader.Status::Open;
                                    SalesHeader.MODIFY;
                                    SalesLine.RESET;
                                    SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                                    SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                                    SalesLine.SETRANGE("Line No.", PurchaseLine."Sales Order Line No.");
                                    IF SalesLine.FINDFIRST THEN BEGIN
                                        SalesLine."Shipment Date" := ShipmentTrackingLog."New Arrival Date";
                                        SalesLine.MODIFY;
                                    END;
                                    SalesHeader.Status := CurrentSOStatus;
                                    SalesHeader.MODIFY;
                                END
                                ELSE BEGIN
                                    SalesLine.RESET;
                                    SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                                    SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                                    if PurchaseLine."Sales Order Line No." <> 0 then
                                        SalesLine.SETRANGE("Line No.", PurchaseLine."Sales Order Line No.")
                                    else
                                        SalesLine.SETRANGE("Line No.", PurchaseLine."SO Line No.");
                                    IF SalesLine.FINDFIRST THEN BEGIN
                                        SalesLine."Shipment Date" := ShipmentTrackingLog."New Arrival Date";
                                        SalesLine.MODIFY;
                                    END;
                                END;
                            END;
                            //SO Changes                                
                            PurchaseLine."Expected Receipt Date" := ShipmentTrackingLog."New Arrival Date";
                            PurchaseLine."Shipment Tracking Code" := ShipmentTrackingLine."Tracking Code";
                            PurchaseLine.MODIFY;
                        UNTIL PurchaseLine.NEXT = 0;
                    END;
                END;
            END;
            ShipmentTrackingLog."Shipment Date Updated on SO" := true;
            ShipmentTrackingLog."Approved by" := UserId;
            ShipmentTrackingLog.Modify();
        end;
    END;

    procedure SendEmail(EmailID: Text)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Cancelled: Boolean;
        MailSent: Boolean;
        Selection: Integer;
        OptionsLbl: Label 'Send, Open Preview';
        ListTo: List of [Text];
    begin
        if EmailID = '' then
            EmailID := 'shivanshitlpublic@gmail.com';
        Selection := Dialog.StrMenu(OptionsLbl);
        ListTo.Add(EmailID);
        EmailMessage.Create(ListTo, 'This is the Subject', 'This is the body', true);

        Cancelled := false;
        if Selection = 1 then
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        if Selection = 2 then begin
            Email.OpenInEditor(EmailMessage, Enum::"Email Scenario"::Default);
            Cancelled := not MailSent;
        end;
        if (Selection <> 0) and not MailSent and not Cancelled then
            Error(GetLastErrorText());

    end;
}