codeunit 50006 ItemTracking
{
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnBeforeInsertOrModify', '', false, false)]

    // local procedure OnCreateEntrySummary2OnBeforeInsertOrModify(var TempGlobalEntrySummary: Record "Entry Summary" temporary; TempReservEntry: Record "Reservation Entry" temporary; TrackingSpecification: Record "Tracking Specification")
    // var
    //     ItemLedgEntry: Record "Item Ledger Entry";
    // begin
    //     If ItemLedgEntry.Get(TrackingSpecification."Item Ledger Entry No.") then
    //         TempGlobalEntrySummary."Warranty Date" := ItemLedgEntry."Posting Date"
    //     else
    //         TempGlobalEntrySummary."Warranty Date" := TempReservEntry."Creation Date";
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnAfterAssignTrackingFromReservEntry', '', false, false)]

    local procedure OnCreateEntrySummary2OnAfterAssignTrackingFromReservEntry(var TempGlobalEntrySummary: Record "Entry Summary" temporary; TempReservEntry: Record "Reservation Entry" temporary);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin

        //If TempGlobalEntrySummary."Table ID" = 32 then begin
        if ItemLedgEntry.Get(TempReservEntry."Source Ref. No.") then
            TempGlobalEntrySummary."Expiration Date" := ItemLedgEntry."Posting Date"
        else
            TempGlobalEntrySummary."Expiration Date" := TempReservEntry."Creation Date";
        //end;
        TempReservEntry."Expiration Date" := TempGlobalEntrySummary."Expiration Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnAfterSetDoubleEntryAdjustment', '', false, false)]
    local procedure OnCreateEntrySummary2OnAfterSetDoubleEntryAdjustment(var TempGlobalEntrySummary: Record "Entry Summary"; var TempReservEntry: Record "Reservation Entry")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        //If TempGlobalEntrySummary."Table ID" = 32 then begin
        if ItemLedgEntry.Get(TempReservEntry."Source Ref. No.") then
            TempGlobalEntrySummary."Expiration Date" := ItemLedgEntry."Posting Date"
        else
            TempGlobalEntrySummary."Expiration Date" := TempReservEntry."Creation Date";
        //end;
        TempReservEntry."Expiration Date" := TempGlobalEntrySummary."Expiration Date";
    end;


    procedure AssignLotNo(var SalesHead: Record "Sales Header")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        GlobalReservEntry: Record "Reservation Entry";
        ReservationEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        UOMMgt: Codeunit "Unit of Measure Management";
        OrderLineQty: Decimal;
        AvailableQty: Decimal;
        ReserEntryNo: Integer;
        Cnt: Integer;
    begin
        SalesHead.TestField(Status, SalesHead.Status::Released);

        GlobalReservEntry.LockTable();
        if GlobalReservEntry.FindLast then
            ReserEntryNo := GlobalReservEntry."Entry No.";

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHead."Document Type");
        SalesLine.SetRange("Document No.", SalesHead."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        //SalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
        SalesLine.SetFilter("Qty. to Ship", '>%1', 0);
        if SalesLine.FindFirst() then
            repeat

                //OrderLineQty := SalesLine."Quantity (Base)";
                OrderLineQty := SalesLine."Qty. to Ship (Base)";
                ItemLedgEntry.Reset();
                ItemLedgEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
                ItemLedgEntry.SetRange("Item No.", SalesLine."No.");
                ItemLedgEntry.SetRange("Variant Code", SalesLine."Variant Code");
                ItemLedgEntry.SetRange(Open, true);
                ItemLedgEntry.SetRange("Location Code", SalesLine."Location Code");

                ItemLedgEntry.SetLoadFields(
                  "Entry No.", "Item No.", "Variant Code", Positive, "Location Code", "Serial No.", "Lot No.", "Package No.",
                  "Remaining Quantity", "Warranty Date", "Expiration Date");
                if ItemLedgEntry.FindSet() then
                    repeat
                        if ItemLedgEntry.TrackingExists() then begin
                            SalesLine.TestField("Outstanding Quantity");
                            GlobalReservEntry.Init();
                            //TempGlobalReservEntry."Entry No." := -ItemLedgEntry."Entry No.";

                            ReservationEntry.Reset();
                            ReservationEntry.SetCurrentKey(
                              "Item No.", "Source Type", "Source Subtype", "Reservation Status",
                              "Location Code", "Variant Code", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");

                            ReservationEntry.SetRange("Item No.", ItemLedgEntry."Item No.");
                            ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
                            ReservationEntry.SetRange("Location Code", ItemLedgEntry."Location Code");
                            ReservationEntry.SetRange("Variant Code", ItemLedgEntry."Variant Code");
                            ReservationEntry.SetRange("Serial No.", ItemLedgEntry."Serial No.");
                            ReservationEntry.SetRange("Lot No.", ItemLedgEntry."Lot No.");
                            ReservationEntry.SetRange(Positive, false);
                            if ReservationEntry.FindFirst() then begin
                                ReservationEntry.CalcSums("Quantity (Base)");
                                AvailableQty := ItemLedgEntry."Remaining Quantity" + ReservationEntry."Quantity (Base)"
                            end else
                                AvailableQty := ItemLedgEntry."Remaining Quantity";


                            GlobalReservEntry."Reservation Status" := GlobalReservEntry."Reservation Status"::Surplus;
                            GlobalReservEntry."Item No." := ItemLedgEntry."Item No.";
                            GlobalReservEntry."Variant Code" := ItemLedgEntry."Variant Code";
                            GlobalReservEntry."Location Code" := ItemLedgEntry."Location Code";
                            GlobalReservEntry.Description := SalesLine.Description;
                            GlobalReservEntry."Creation Date" := WorkDate();
                            GlobalReservEntry."Created By" := UserId;
                            GlobalReservEntry."Shipment Date" := SalesLine."Planned Shipment Date";
                            GlobalReservEntry.Positive := false;

                            if OrderLineQty <= AvailableQty then begin
                                GlobalReservEntry."Quantity (Base)" := -1 * OrderLineQty;
                                OrderLineQty := 0;
                            end else begin
                                GlobalReservEntry."Quantity (Base)" := -1 * AvailableQty;
                                OrderLineQty += GlobalReservEntry."Quantity (Base)";
                            end;
                            GlobalReservEntry."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";

                            GlobalReservEntry.Positive := (GlobalReservEntry."Quantity (Base)" > 0);
                            if GlobalReservEntry."Qty. per Unit of Measure" <> 0 then
                                GlobalReservEntry.Quantity := Round(GlobalReservEntry."Quantity (Base)" / GlobalReservEntry."Qty. per Unit of Measure", UOMMgt.QtyRndPrecision());

                            GlobalReservEntry."Qty. to Handle (Base)" := GlobalReservEntry."Quantity (Base)";
                            GlobalReservEntry."Qty. to Invoice (Base)" := GlobalReservEntry."Quantity (Base)";

                            GlobalReservEntry."Item Tracking" := GlobalReservEntry."Item Tracking"::"Lot No.";
                            GlobalReservEntry."Source Type" := Database::"Sales Line";
                            GlobalReservEntry."Source Subtype" := 1;
                            GlobalReservEntry."Source ID" := SalesLine."Document No.";
                            GlobalReservEntry."Source Ref. No." := SalesLine."Line No.";
                            GlobalReservEntry."Lot No." := ItemLedgEntry."Lot No.";
                            //TempGlobalReservEntry.CopyTrackingFromItemLedgEntry(ItemLedgEntry);
                            if GlobalReservEntry."Quantity (Base)" <> 0 then begin
                                GlobalReservEntry."Entry No." := ReserEntryNo + 1;
                                ReserEntryNo += 1;
                                GlobalReservEntry.Insert();
                                Cnt += 1;
                            end;

                        end;
                    until (ItemLedgEntry.Next() = 0) or (OrderLineQty = 0);
            until SalesLine.Next() = 0;
        if Cnt > 0 then
            Message('Lot No. assigned successfully.')
        else
            Message('Lot No. not assigned.');
    end;

    procedure DeleteReservationEntry(SalesHead: Record "Sales Header")
    var
        ReservEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
    begin
        ReservEntry.Reset();
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Source Subtype", SalesHead."Document Type".AsInteger());
        ReservEntry.SetRange("Source ID", SalesHead."No.");
        ReservEntry.SetRange("Source Batch Name", '');
        ReservEntry.SetRange("Source Prod. Order Line", 0);
        ReservEntry.SetRange("Quantity Invoiced (Base)", 0);
        // if LineNo <> 0 then
        //     ReservEntry.SetRange("Source Ref. No.", LineNo);
        if ReservEntry.FindFirst() then
            Repeat
                ReservEntry.Delete();
            Until ReservEntry.Next() = 0;

        Message('Lot No. removed successfully.')
    end;

}
