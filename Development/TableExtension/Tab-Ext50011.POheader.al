tableextension 50011 POheader extends "Purchase Header"
{
    fields
    {
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
        field(50014; "VIA"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    procedure AssignLotNo(PurchHead: Record "Purchase Header"; LineNo: Integer; LotNo: Code[50])
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        QtyToCreate: Decimal;
        IsHandled: Boolean;
        ReservEntry1: Record "Reservation Entry";
        ReservationEntry: Record "Reservation Entry";
        CheckResEntry: Record "Reservation Entry";
        OldTrackingSpecification: Record "Tracking Specification";
        PurchLine: Record "Purchase Line";
        Item: Record Item;
        Question: Text;
        Answer: Boolean;
        Cnt: Integer;
        Text000: Label 'Lot no. %1 already exist against line %2, Do you still want to add additional line ?';
        Text001: Label 'Do you want replace lot no. on lines with %1.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        PurchHead.TestField(Status, PurchHead.Status::Released);
        if PurchHead.Status = PurchHead.Status::Released then begin
            // if LineNo = 0 then begin
            //     Question := Text001;
            //     Answer := Dialog.Confirm(Question, true, PurchHead."Lot No.");
            // end else
            //     Answer := true;
            Answer := true;
            if Answer then begin
                Question := Text000;
                CheckResEntry.Reset();
                CheckResEntry.SetRange("Source Type", DATABASE::"Purchase Line");
                CheckResEntry.SetRange("Source Subtype", PurchLine."Document Type".AsInteger());
                CheckResEntry.SetRange("Source ID", PurchLine."Document No.");
                CheckResEntry.SetRange("Source Batch Name", '');
                CheckResEntry.SetRange("Source Prod. Order Line", 0);
                CheckResEntry.SetRange(CheckResEntry."Quantity Invoiced (Base)", 0);

                PurchLine.SetRange("Document Type", PurchHead."Document Type");
                PurchLine.SetRange("Document No.", PurchHead."No.");
                if LineNo <> 0 then
                    PurchLine.SetRange("Line No.", LineNo);
                PurchLine.SetRange(Type, PurchLine.Type::Item);
                PurchLine.SetFilter("Qty. to Receive", '<> %1', 0);
                PurchLine.SetFilter("Lot No.", '= %1', '');
                if PurchLine.FindFirst() then begin
                    repeat
                        if Item.Get(PurchLine."No.") then begin
                            if (Item.Type = Item.Type::Inventory) And (Item."Item Tracking Code" <> '') then begin
                                Answer := false;
                                //if PurchLine."Lot No." = '' then
                                LotNo := '';
                                if LineNo = 0 then begin
                                    if PurchLine."Lot No." = '' then begin
                                        Item.TestField("Lot Nos.");
                                        NoSeriesMgt.InitSeries(Item."Lot Nos.", Item."Lot Nos.", 0D, PurchLine."Lot No.", Item."Lot Nos.");
                                        LotNo := PurchLine."Lot No.";
                                    end;
                                end;
                                CheckResEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
                                CheckResEntry.SetRange("Lot No.", LotNo);
                                if CheckResEntry.FindFirst() then begin
                                    Answer := Dialog.Confirm(Question, true, CheckResEntry."Lot No.", PurchLine."Line No.");
                                    if Answer then
                                        PurchHead.CreatePOReservationEntry(PurchLine, Cnt, LotNo);
                                end else begin
                                    PurchHead.CreatePOReservationEntry(PurchLine, Cnt, LotNo);
                                end;
                            end;
                        end;
                        PurchLine.Modify();
                    until PurchLine.Next() = 0;
                    If Cnt > 0 then
                        Message('%1 Item tracking line created successfully', Cnt);
                end else
                    Message('There are no Item lines with Qty. to Receive')
            end;
        end;
    end;

    procedure CreatePOReservationEntry(PurchLine: Record "Purchase Line"; Var Cnt: Integer; LotNo: Code[50])
    var
        ReservEntry: Record "Reservation Entry";
        CurrentEntryStatus: Enum "Reservation Status";
        ShipmentDate: Date;
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        if PurchLine."Drop Shipment" then
            CurrentEntryStatus := CurrentEntryStatus::Surplus
        else
            CurrentEntryStatus := CurrentEntryStatus::Prospect;

        ShipmentDate := 0D;

        ReservEntry.LockTable();
        ReservEntry.Init();
        ReservEntry."Reservation Status" := CurrentEntryStatus;
        ReservEntry."Item No." := PurchLine."No.";
        ReservEntry."Variant Code" := PurchLine."Variant Code";
        ReservEntry."Location Code" := PurchLine."Location Code";
        ReservEntry.Description := PurchLine.Description;
        ReservEntry."Creation Date" := WorkDate();
        ReservEntry."Created By" := UserId;
        ReservEntry."Expected Receipt Date" := PurchLine."Expected Receipt Date";
        ReservEntry."Shipment Date" := ShipmentDate;
        ReservEntry."Quantity (Base)" := PurchLine."Qty. to Receive (Base)";
        ReservEntry."Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
        //ReservEntry."Transferred from Entry No." := TransferredFromEntryNo;
        ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
        if ReservEntry."Qty. per Unit of Measure" <> 0 then
            ReservEntry.Quantity := Round(ReservEntry."Quantity (Base)" / ReservEntry."Qty. per Unit of Measure", UOMMgt.QtyRndPrecision());
        //if not QtyToHandleAndInvoiceIsSet then begin
        ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
        ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
        //end;
        ReservEntry."Untracked Surplus" := false;
        ReservEntry."Source Type" := Database::"Purchase Line";
        ReservEntry."Source Subtype" := PurchLine."Document Type".AsInteger();
        ReservEntry."Source ID" := PurchLine."Document No.";
        ReservEntry."Source Batch Name" := '';
        ReservEntry."Source Prod. Order Line" := 0;
        ReservEntry."Source Ref. No." := PurchLine."Line No.";
        ReservEntry."Lot No." := LotNo;
        Cnt += 1;
        ReservEntry.Insert();
    end;

    procedure DeleteReservationEntry(PurchHead: Record "Purchase Header"; LineNo: Integer)
    var
        ReservEntry: Record "Reservation Entry";
        PurchLine: Record "Purchase Line";
    begin
        ReservEntry.Reset();
        ReservEntry.SetRange("Source Type", DATABASE::"Purchase Line");
        ReservEntry.SetRange("Source Subtype", Rec."Document Type".AsInteger());
        ReservEntry.SetRange("Source ID", Rec."No.");
        ReservEntry.SetRange("Source Batch Name", '');
        ReservEntry.SetRange("Source Prod. Order Line", 0);
        ReservEntry.SetRange("Quantity Invoiced (Base)", 0);
        if LineNo <> 0 then
            ReservEntry.SetRange("Source Ref. No.", LineNo);
        if ReservEntry.FindFirst() then
            Repeat
                ReservEntry.Delete();
                PurchLine.SetRange("Document Type", Rec."Document Type");
                PurchLine.SetRange("Document No.", Rec."No.");
                if LineNo <> 0 then
                    PurchLine.SetRange("Line No.", LineNo);
                PurchLine.SetFilter("Lot No.", '<> %1', '');
                if PurchLine.FindFirst() then
                    repeat
                        PurchLine."Lot No." := '';
                        PurchLine.Modify();
                    until PurchLine.Next() = 0;
            Until ReservEntry.Next() = 0;
    end;
}
