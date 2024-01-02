codeunit 50002 ShipmentTrackingLog
{
    TableNo = "Tracking Shipment Header";

    trigger OnRun()
    begin
        CreateLog(Rec);
    end;

    PROCEDURE CreateLog(var Rec: Record "Tracking Shipment Header")
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
    BEGIN
        ShipmentTrackingLine.RESET;
        ShipmentTrackingLine.SETRANGE("Tracking Code", Rec.Code);
        IF ShipmentTrackingLine.FINDFIRST THEN BEGIN
            REPEAT
                //ShipmentTrackingLog2.RESET;
                //ShipmentTrackingLog2.SETRANGE("Tracking Code", ShipmentTrackingLine."Tracking Code");
                //ShipmentTrackingLog2.SETRANGE("Line No.", ShipmentTrackingLine."Line No.");
                //IF NOT ShipmentTrackingLog2.FINDFIRST THEN BEGIN
                ShipmentTrackingLog.INIT;
                ShipmentTrackingLog."Entry No." := 0;
                ShipmentTrackingLog.INSERT;
                ShipmentTrackingLog."Tracking Code" := ShipmentTrackingLine."Tracking Code";
                ShipmentTrackingLog."Line No." := ShipmentTrackingLine."Line No.";
                ShipmentTrackingLog."PO No." := ShipmentTrackingLine."PO No.";
                ShipmentTrackingLog."Buy From Vendor No." := ShipmentTrackingLine."Buy From Vendor No.";
                ShipmentTrackingLog."Buy From Vendor Name" := ShipmentTrackingLine."Buy From Vendor Name";
                ShipmentTrackingLog."Date of Dispatch" := ShipmentTrackingLine."Date of Dispatch";
                ShipmentTrackingLog."Date of Arrival" := ShipmentTrackingLine."Date of Arrival";
                ShipmentTrackingLog."Created Date" := WORKDATE;
                ShipmentTrackingLog."Created By" := UserId;
                ShipmentTrackingLog."Modified By" := UserId;
                ShipmentTrackingLog."Modified Date" := WORKDATE;
                IF ShipmentTrackingLine."Delayed by Days" <> 0 THEN BEGIN
                    ShipmentTrackingLog."Delayed by Days" := ShipmentTrackingLine."Delayed by Days";
                    ShipmentTrackingLog."New Arrival Date" := CALCDATE(FORMAT(ShipmentTrackingLine."Delayed by Days") + 'D', ShipmentTrackingLine."Date of Arrival");
                END;
                IF ShipmentTrackingLog.MODIFY THEN BEGIN
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
                END;
            //END
            //ELSE BEGIN
            /*
            ShipmentTrackingLog2."Modified By" := UserId;
            ShipmentTrackingLog2."Modified Date" := WORKDATE;
            IF ShipmentTrackingLine."Delayed by Days" <> 0 THEN BEGIN
                ShipmentTrackingLog2."Delayed by Days" := ShipmentTrackingLine."Delayed by Days";
                ShipmentTrackingLog2."New Arrival Date" := CALCDATE(FORMAT(ShipmentTrackingLine."Delayed by Days") + 'D', ShipmentTrackingLine."Date of Arrival");
            END;
            ShipmentTrackingLog2.MODIFY;
            */
            //END;
            UNTIL ShipmentTrackingLine.NEXT = 0;
        END;
    END;
}
