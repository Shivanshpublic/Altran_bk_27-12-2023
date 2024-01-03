codeunit 50003 CustomEvents
{
    var


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure OnAfterCopyFromItem(var SalesLine: Record "Sales Line"; Item: Record Item; CurrentFieldNo: Integer);
    begin
        SalesLine."HS Code" := Item."HS Code";
        SalesLine."HTS Code" := Item."HTS Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnCopyFromItemOnAfterCheck', '', false, false)]
    local procedure OnCopyFromItemOnAfterCheck(var PurchaseLine: Record "Purchase Line"; Item: Record Item; CallingFieldNo: Integer);
    begin
        PurchaseLine."HS Code" := Item."HS Code";
        PurchaseLine."HTS Code" := Item."HTS Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Doc. From Sales Doc.", 'OnCopySalesLinesToPurchaseLinesOnBeforeInsert', '', false, false)]
    local procedure OnCopySalesLinesToPurchaseLinesOnBeforeInsert(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line");
    begin
        PurchaseLine."SO No." := SalesLine."Document No.";
        PurchaseLine."SO Line No." := SalesLine."Line No.";

        PurchaseLine."HS Code" := SalesLine."HS Code";
        PurchaseLine."HTS Code" := SalesLine."HTS Code";
        PurchaseLine."No. of Packages" := SalesLine."No. of Packages";
        PurchaseLine."Total Gross (KG)" := SalesLine."Total Gross (KG)";
        PurchaseLine."Total CBM" := SalesLine."Total CBM";
        PurchaseLine."Total Net (KG)" := SalesLine."Total Net (KG)";
        PurchaseLine."Port of Load" := SalesLine."Port of Load";
        PurchaseLine."Port of Discharge" := SalesLine."Port of Discharge";
        PurchaseLine."Country of Origin" := SalesLine."Country of Origin";
        PurchaseLine."Country of provenance" := SalesLine."Country of provenance";
        PurchaseLine."Country of Acquisition" := SalesLine."Country of Acquisition";
        PurchaseLine."VIA" := SalesLine."VIA";
        PurchaseLine."Milestone Status" := SalesLine."Milestone Status";


        SalesLine."PO No." := PurchaseLine."Document No.";
        SalesLine."PO Line No." := PurchaseLine."Line No.";

        SalesLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", OnBeforePurchOrderLineInsert, '', false, false)]
    local procedure OnBeforePurchOrderLineInsert(var PurchOrderHeader: Record "Purchase Header"; var PurchOrderLine: Record "Purchase Line"; var ReqLine: Record "Requisition Line"; CommitIsSuppressed: Boolean);
    var
        Sheader: Record "Sales Header";
        Sline: Record "Sales Line";
    begin
        Clear(Sline);
        Clear(Sheader);
        Sheader.SetRange("Document Type", Sheader."Document Type"::Order);
        Sheader.SetRange("No.", ReqLine."Demand Order No.");
        if Sheader.FindFirst() then begin
            Sline.SetRange("Document Type", Sline."Document Type"::Order);
            Sline.SetRange("Document No.", ReqLine."Demand Order No.");
            Sline.SetRange("Line No.", ReqLine."Demand Line No.");
            if Sline.FindFirst() then begin
                PurchOrderLine."SO No." := Sline."Document No.";
                PurchOrderLine."SO Line No." := Sline."Line No.";

                PurchOrderLine."HS Code" := Sline."HS Code";
                PurchOrderLine."HTS Code" := Sline."HTS Code";
                PurchOrderLine."No. of Packages" := Sline."No. of Packages";
                PurchOrderLine."Total Gross (KG)" := Sline."Total Gross (KG)";
                PurchOrderLine."Total CBM" := Sline."Total CBM";
                PurchOrderLine."Total Net (KG)" := Sline."Total Net (KG)";
                PurchOrderLine."Port of Load" := Sline."Port of Load";
                PurchOrderLine."Port of Discharge" := Sline."Port of Discharge";
                PurchOrderLine."Country of Origin" := Sline."Country of Origin";
                PurchOrderLine."Country of provenance" := Sline."Country of provenance";
                PurchOrderLine."Country of Acquisition" := Sline."Country of Acquisition";
                PurchOrderLine."VIA" := Sline."VIA";
                PurchOrderLine."Milestone Status" := Sline."Milestone Status";

                PurchOrderLine."Pallet Quantity" := Sline."Pallet Quantity";
                //PurchOrderLine."Rev." := Sline."Rev.";
            end;
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInitPurchOrderLine', '', false, false)]
    local procedure OnAfterInitPurchOrderLine(var PurchaseLine: Record "Purchase Line"; RequisitionLine: Record "Requisition Line")
    var
        SalesLine: Record "Sales Line";
    begin
        PurchaseLine."SO No." := RequisitionLine."Demand Order No.";
        PurchaseLine."SO Line No." := RequisitionLine."Demand Line No.";
        if SalesLine.Get(SalesLine."Document Type"::Order, RequisitionLine."Demand Order No.", RequisitionLine."Demand Line No.") then begin
            SalesLine."PO No." := PurchaseLine."Document No.";
            SalesLine."PO Line No." := PurchaseLine."Line No.";
            SalesLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostPurchLineOnBeforeRoundAmount', '', false, false)]
    local procedure OnPostPurchLineOnBeforeRoundAmount(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; SrcCode: Code[10])
    var
        Text50001: TextConst ENU = 'Shipment Tracking Line No. must not be blank in PO  %1 and Line No. %2';
    begin
        if (PurchaseLine."Shipment Tracking Code" <> '') and (PurchaseLine."Shipment Tracking Line No." = 0) then
            Error(Text50001, PurchaseLine."Document No.", PurchaseLine."Line No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DocumentNoVisibility, 'OnBeforeItemNoIsVisible', '', false, false)]

    local procedure OnBeforeItemNoIsVisible(var IsVisible: Boolean; var IsHandled: Boolean)
    begin
        IsVisible := true;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeValidatePlannedDeliveryDate, '', false, false)]
    local procedure OnBeforeValidatePlannedDeliveryDate(var Sender: Record "Sales Line"; var IsHandled: Boolean; var SalesLine: Record "Sales Line");
    begin
        SalesLine.TestStatusOpen();
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeValidatePlannedShipmentDate, '', false, false)]
    local procedure OnBeforeValidatePlannedShipmentDate(var Sender: Record "Sales Line"; var IsHandled: Boolean; var SalesLine: Record "Sales Line");
    begin
        SalesLine.TestStatusOpen();
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateShipmentDate', '', false, false)]
    local procedure OnBeforeValidateShipmentDate(var IsHandled: Boolean; var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
        SalesLine.TestStatusOpen();
        IsHandled := true;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateRequestedDeliveryDate', '', false, false)]
    local procedure OnBeforeValidateRequestedDeliveryDate(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        SalesLine.TestStatusOpen();
        IsHandled := true;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidatePromisedDeliveryDate', '', false, false)]
    local procedure OnBeforeValidatePromisedDeliveryDate(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        SalesLine.TestStatusOpen();
        IsHandled := true;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateOrderDate', '', false, false)]
    local procedure OnBeforeValidateOrderDate(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer; TrackingBlocked: Boolean; var IsHandled: Boolean);
    begin
        PurchaseLine.TestStatusOpen();
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateLeadTimeCalculation', '', false, false)]
    local procedure OnBeforeValidateLeadTimeCalculation(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer; var InHandled: Boolean);
    begin
        PurchaseLine.TestStatusOpen();
        InHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidatePlannedReceiptDate', '', false, false)]
    local procedure OnBeforeValidatePlannedReceiptDate(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer; TrackingBlocked: Boolean; var InHandled: Boolean);
    begin
        PurchaseLine.TestStatusOpen();
        InHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidatePromisedReceiptDate', '', false, false)]
    local procedure OnBeforeValidatePromisedReceiptDate(var PurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer; var IsHandled: Boolean; xPurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine.TestStatusOpen();
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateExpectedReceiptDateOnBeforeCheckDateConflict', '', false, false)]
    local procedure OnValidateExpectedReceiptDateOnBeforeCheckDateConflict(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        PurchaseLine.TestStatusOpen();
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAddTransferLineFromReceiptLineOnBeforeTransferLineInsert', '', false, false)]
    local procedure OnAddTransferLineFromReceiptLineOnBeforeTransferLineInsert(var TransferLine: Record "Transfer Line"; PurchRcptLine: Record "Purch. Rcpt. Line"; var TransferHeader: Record "Transfer Header")
    var
        Bin: Record Bin;
    begin
        TransferLine."Shipment Tracking Code" := PurchRcptLine."Shipment Tracking Code";
        if Bin.Get(TransferLine."Transfer-from Code", PurchRcptLine."Bin Code") then
            TransferLine."Transfer-from Bin Code" := PurchRcptLine."Bin Code";

        if Bin.Get(TransferLine."Transfer-to Code", PurchRcptLine."Bin Code") then
            TransferLine."Transfer-To Bin Code" := PurchRcptLine."Bin Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnInitHeaderDefaultsOnBeforeSetVATBusPostingGroup', '', false, false)]
    local procedure OnInitHeaderDefaultsOnBeforeSetVATBusPostingGroup(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        RecVendor: Record Vendor;
    begin
        if RecVendor.Get(PurchaseLine."Buy-from Vendor No.") then
            PurchaseLine."Buy-from Vendor Name" := RecVendor.Name;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptLine', '', false, false)]

    local procedure OnBeforeInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; TransShptHeader: Record "Transfer Shipment Header")
    begin
        TransShptLine."Shipment Tracking Code" := TransLine."Shipment Tracking Code";
        TransShptLine."Transfer-To Bin Code" := TransLine."Transfer-To Bin Code";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', false, false)]
    local procedure OnBeforeInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        TransRcptLine."Shipment Tracking Code" := TransLine."Shipment Tracking Code";
        TransRcptLine."Transfer-from Bin Code" := TransLine."Transfer-from Bin Code";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostUpdateOrderLineOnSetDefaultQtyBlank', '', false, false)]
    local procedure OnPostUpdateOrderLineOnSetDefaultQtyBlank(var PurchaseHeader: Record "Purchase Header"; var TempPurchaseLine: Record "Purchase Line" temporary; PurchPost: Record "Purchases & Payables Setup"; var SetDefaultQtyBlank: Boolean)
    begin
        TempPurchaseLine."Lot No." := '';
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Charge Assignment (Purch)", 'OnAfterUpdateQty', '', false, false)]
    local procedure OnAfterUpdateQty(var ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)"; var QtyToReceiveBase: Decimal; var QtyReceivedBase: Decimal; var QtyToShipBase: Decimal; var QtyShippedBase: Decimal; var GrossWeight: Decimal; var UnitVolume: Decimal)
    begin
        if ItemChargeAssignmentPurch."Assigned By" = ItemChargeAssignmentPurch."Assigned By"::"Total CBM" then
            GrossWeight := ItemChargeAssignmentPurch."Total CBM";
        if ItemChargeAssignmentPurch."Assigned By" = ItemChargeAssignmentPurch."Assigned By"::"Total Gross (KG)" then
            GrossWeight := ItemChargeAssignmentPurch."Total Gross (KG)";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnShowItemChargeAssgntOnBeforeCalcItemCharge', '', false, false)]
    local procedure OnShowItemChargeAssgntOnBeforeCalcItemCharge(var PurchaseLine: Record "Purchase Line"; var ItemChargeAssgntLineAmt: Decimal; Currency: Record Currency; var IsHandled: Boolean; var ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    begin
        ItemChargeAssgntPurch."Assigned By" := PurchaseLine."Assigned By";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnAfterCreateDocChargeAssgnt', '', false, false)]
    local procedure OnAfterCreateDocChargeAssgnt(var LastItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; var ReceiptNo: Code[20])
    var
        FromPurchLine: Record "Purchase Line";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        NextLineNo: Integer;
    begin
        if LastItemChargeAssgntPurch."Assigned By" <> LastItemChargeAssgntPurch."Assigned By"::" " then begin
            with LastItemChargeAssgntPurch do begin
                FromPurchLine.SetRange("Document Type", "Document Type");
                FromPurchLine.SetRange("Document No.", "Document No.");
                FromPurchLine.SetRange(Type, FromPurchLine.Type::Item);
                if FromPurchLine.Find('-') then begin
                    NextLineNo := "Line No.";
                    ItemChargeAssgntPurch.Reset();
                    ItemChargeAssgntPurch.SetRange("Document Type", "Document Type");
                    ItemChargeAssgntPurch.SetRange("Document No.", "Document No.");
                    ItemChargeAssgntPurch.SetRange("Document Line No.", "Document Line No.");
                    ItemChargeAssgntPurch.SetRange("Applies-to Doc. No.", "Document No.");
                    repeat
                        if (FromPurchLine.Quantity <> 0) and
                           (FromPurchLine.Quantity <> FromPurchLine."Quantity Invoiced") and
                           (FromPurchLine."Work Center No." = '') and
                           ((ReceiptNo = '') or (FromPurchLine."Receipt No." = ReceiptNo)) and
                           FromPurchLine."Allow Item Charge Assignment"
                        then begin
                            ItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.", FromPurchLine."Line No.");
                            if ItemChargeAssgntPurch.FindFirst() then begin
                                ItemChargeAssgntPurch."Assigned By" := LastItemChargeAssgntPurch."Assigned By";
                                ItemChargeAssgntPurch."Total CBM" := FromPurchLine."Total CBM";
                                ItemChargeAssgntPurch."Total Gross (KG)" := FromPurchLine."Total Gross (KG)";
                                ItemChargeAssgntPurch.Modify();
                            end;
                        end;
                    until FromPurchLine.Next() = 0;
                end;
            end;
        end else begin
            with LastItemChargeAssgntPurch do begin
                FromPurchLine.SetRange("Document Type", "Document Type");
                FromPurchLine.SetRange("Document No.", "Document No.");
                FromPurchLine.SetRange(Type, FromPurchLine.Type::Item);
                if FromPurchLine.Find('-') then begin
                    NextLineNo := "Line No.";
                    ItemChargeAssgntPurch.Reset();
                    ItemChargeAssgntPurch.SetRange("Document Type", "Document Type");
                    ItemChargeAssgntPurch.SetRange("Document No.", "Document No.");
                    ItemChargeAssgntPurch.SetRange("Document Line No.", "Document Line No.");
                    ItemChargeAssgntPurch.SetRange("Applies-to Doc. No.", "Document No.");
                    repeat
                        if (FromPurchLine.Quantity <> 0) and
                           (FromPurchLine.Quantity <> FromPurchLine."Quantity Invoiced") and
                           (FromPurchLine."Work Center No." = '') and
                           ((ReceiptNo = '') or (FromPurchLine."Receipt No." = ReceiptNo)) and
                           FromPurchLine."Allow Item Charge Assignment"
                        then begin
                            ItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.", FromPurchLine."Line No.");
                            if ItemChargeAssgntPurch.FindFirst() then begin
                                ItemChargeAssgntPurch."Assigned By" := LastItemChargeAssgntPurch."Assigned By";
                                ItemChargeAssgntPurch."Total CBM" := 0;
                                ItemChargeAssgntPurch."Total Gross (KG)" := 0;
                                ItemChargeAssgntPurch.Modify();
                            end;
                        end;
                    until FromPurchLine.Next() = 0;
                end;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnAfterGetItemValues', '', false, false)]
    local procedure OnAfterGetItemValues(var TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary; var DecimalArray: array[3] of Decimal)
    var
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReturnShptLine: Record "Return Shipment Line";
        TransferRcptLine: Record "Transfer Receipt Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
    begin
        with TempItemChargeAssgntPurch do
            case "Applies-to Doc. Type" of
                "Applies-to Doc. Type"::Order,
                "Applies-to Doc. Type"::Invoice,
                "Applies-to Doc. Type"::"Return Order",
                "Applies-to Doc. Type"::"Credit Memo":
                    begin
                        PurchLine.Get("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
                        DecimalArray[1] := PurchLine.Quantity;
                        if TempItemChargeAssgntPurch."Assigned By" = TempItemChargeAssgntPurch."Assigned By"::"Total CBM" then
                            DecimalArray[2] := PurchLine."Total CBM"
                        else
                            if TempItemChargeAssgntPurch."Assigned By" = TempItemChargeAssgntPurch."Assigned By"::"Total Gross (KG)" then
                                DecimalArray[2] := PurchLine."Total Gross (KG)"
                            else
                                DecimalArray[2] := PurchLine."Gross Weight";
                        DecimalArray[3] := PurchLine."Unit Volume";
                    end;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnSuggestAssgntOnAfterItemChargeAssgntPurchSetFilters', '', false, false)]
    local procedure OnSuggestAssgntOnAfterItemChargeAssgntPurchSetFilters(var ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)"; PurchLine: Record "Purchase Line"; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal; var IsHandled: Boolean)
    begin
        if (PurchLine."Assigned By" = PurchLine."Assigned By"::"Total CBM") OR (PurchLine."Assigned By" = PurchLine."Assigned By"::"Total Gross (KG)") then
            Message('In case of assigned by Total CBM or Total Gross KG, assignment must be done using Weight option.');
    end;

}
