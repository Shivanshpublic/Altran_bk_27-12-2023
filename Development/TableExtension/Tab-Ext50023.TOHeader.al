tableextension 50023 TOHeader extends "Transfer Header"
{
    fields
    {
        field(50014; "Shipment Tracking Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Header";
            Editable = false;
        }
    }
    procedure GetTransferShipmentLines()
    var
        TransShptHeader: Record "Transfer Shipment Header";
        TempTransShptHeader: Record "Transfer Shipment Header" temporary;
        TransferShipments: Page "Posted Transfer Shipments";
    begin
        TransShptHeader.SetRange("Transfer-from Code", "Transfer-from Code");
        TransferShipments.SetTableView(TransShptHeader);
        TransferShipments.LookupMode := true;
        if TransferShipments.RunModal() = ACTION::LookupOK then begin
            TransferShipments.GetSelectedRecords(TempTransShptHeader);
            CreateTransferLinesFromSelectedTransferShipments(TempTransShptHeader);
        end;
    end;

    local procedure CreateTransferLinesFromSelectedTransferShipments(var TempTransShptHeader: Record "Transfer Shipment Header" temporary)
    var
        TransShptLine: Record "Transfer Shipment Line";
        TempTransShptLine: Record "Transfer Shipment Line" temporary;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        TransferShipmentLines: Page "Posted Transfer Shipment Lines";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(TempTransShptHeader);
        TransShptLine.SetFilter(
          "Document No.",
          SelectionFilterManagement.GetSelectionFilter(RecRef, TempTransShptHeader.FieldNo("No.")));
        TransShptLine.SetRange("Transfer-from Code", "Transfer-from Code");
        TransferShipmentLines.SetTableView(TransShptLine);
        TransferShipmentLines.LookupMode := true;
        if TransferShipmentLines.RunModal() = ACTION::LookupOK then begin
            TransferShipmentLines.GetSelectedRecords(TempTransShptLine);
            CreateTransferLinesFromSelectedShipmentLines(TempTransShptLine);
        end;
    end;

    local procedure CreateTransferLinesFromSelectedShipmentLines(var TransShptLine: Record "Transfer Shipment Line")
    var
        TransferLine: Record "Transfer Line";
        LineNo: Integer;
    begin
        TransferLine.SetRange("Document No.", "No.");
        if TransferLine.FindLast() then;
        LineNo := TransferLine."Line No.";

        if TransShptLine.FindSet() then
            repeat
                LineNo := LineNo + 10000;
                AddTransferLineFromTransShipLine(TransShptLine, LineNo);
            until TransShptLine.Next() = 0;
    end;

    local procedure AddTransferLineFromTransShipLine(TransShptLine: Record "Transfer Shipment Line"; LineNo: Integer)
    var
        TransferHead: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferLine1: Record "Transfer Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        RecBin: Record Bin;
    begin
        if TransferHead.Get("No.") then;
        TransferLine."Document No." := TransferHead."No.";
        TransferLine."Line No." := TransShptLine."Line No.";//LineNo;
        TransferLine.Validate("Item No.", TransShptLine."Item No.");
        //TransferLine.Validate("Variant Code", TransShptLine."Variant Code");
        TransferLine.Validate(Quantity, TransShptLine.Quantity);
        TransferLine.Validate("Unit of Measure Code", TransShptLine."Unit of Measure Code");

        if RecBin.GET(TransferHead."Transfer-from Code", TransShptLine."Transfer-from Bin Code") then begin
            TransferLine.Validate("Transfer-from Bin Code", TransShptLine."Transfer-from Bin Code");
        end;
        if RecBin.GET(TransferHead."Transfer-to Code", TransShptLine."Transfer-to Bin Code") then begin
            //TransferLine.Validate("Transfer-to Bin Code", TransShptLine."Transfer-to Bin Code");
            TransferLine."Transfer-to Bin Code" := TransShptLine."Transfer-to Bin Code";
        end;

        TransferLine."Shortcut Dimension 1 Code" := TransShptLine."Shortcut Dimension 1 Code";
        TransferLine."Shortcut Dimension 2 Code" := TransShptLine."Shortcut Dimension 2 Code";
        TransferLine."Dimension Set ID" := TransShptLine."Dimension Set ID";
        TransferLine."Shipment Tracking Code" := TransShptLine."Shipment Tracking Code";
        TransferLine.Insert(true);

        TransShptLine.FilterPstdDocLnItemLedgEntries(ItemLedgerEntry);
        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempItemLedgerEntry, ItemLedgerEntry);
        ItemTrackingMgt.CopyItemLedgEntryTrkgToTransferLine(TempItemLedgerEntry, TransferLine);
    end;

    procedure GetTransferReceiptLines()
    var
        TransRcptHeader: Record "Transfer Receipt Header";
        TempTransRcptHeader: Record "Transfer Receipt Header" temporary;
        TransferReceipts: Page "Posted Transfer Receipts";
    begin
        //TransRcptHeader.SetRange("Transfer-from Code", "Transfer-from Code");
        TransRcptHeader.SetRange("Transfer-to Code", "Transfer-from Code");
        TransferReceipts.SetTableView(TransRcptHeader);
        TransferReceipts.LookupMode := true;
        if TransferReceipts.RunModal() = ACTION::LookupOK then begin
            TransferReceipts.GetSelectedRecords(TempTransRcptHeader);
            CreateTransferLinesFromSelectedTransferReceipts(TempTransRcptHeader);
        end;
    end;

    local procedure CreateTransferLinesFromSelectedTransferReceipts(var TempTransRcptHeader: Record "Transfer Receipt Header" temporary)
    var
        TransRcptLine: Record "Transfer Receipt Line";
        TempTransRcptLine: Record "Transfer Receipt Line" temporary;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        TransferReceiptLines: Page "Posted Transfer Receipt Lines";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(TempTransRcptHeader);
        TransRcptLine.SetFilter(
          "Document No.",
          SelectionFilterManagement.GetSelectionFilter(RecRef, TempTransRcptHeader.FieldNo("No.")));
        //TransRcptLine.SetRange("Transfer-from Code", "Transfer-from Code");
        TransRcptLine.SetRange("Transfer-to Code", "Transfer-from Code");
        TransferReceiptLines.SetTableView(TransRcptLine);
        TransferReceiptLines.LookupMode := true;
        if TransferReceiptLines.RunModal() = ACTION::LookupOK then begin
            TransferReceiptLines.GetSelectedRecords(TempTransRcptLine);
            CreateTransferLinesFromSelectedReceiptLines(TempTransRcptLine);
        end;
    end;

    local procedure CreateTransferLinesFromSelectedReceiptLines(var TransRcptLine: Record "Transfer Receipt Line")
    var
        TransferLine: Record "Transfer Line";
        LineNo: Integer;
    begin
        TransferLine.SetRange("Document No.", "No.");
        if TransferLine.FindLast() then;
        LineNo := TransferLine."Line No.";

        if TransRcptLine.FindSet() then
            repeat
                LineNo := LineNo + 10000;
                AddTransferLineFromTransRcptLine(TransRcptLine, LineNo);
            until TransRcptLine.Next() = 0;
    end;

    local procedure AddTransferLineFromTransRcptLine(TransRcptLine: Record "Transfer Receipt Line"; LineNo: Integer)
    var
        TransferHead: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferLine1: Record "Transfer Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        RecBin: Record Bin;
    begin
        if TransferHead.Get("No.") then;
        TransferLine."Document No." := TransferHead."No.";
        TransferLine."Line No." := TransRcptLine."Line No.";//LineNo;
        TransferLine.Validate("Item No.", TransRcptLine."Item No.");
        //TransferLine.Validate("Variant Code", TransShptLine."Variant Code");
        TransferLine.Validate(Quantity, TransRcptLine.Quantity);
        TransferLine.Validate("Unit of Measure Code", TransRcptLine."Unit of Measure Code");

        if RecBin.GET(TransferHead."Transfer-from Code", TransRcptLine."Transfer-from Bin Code") then begin
            TransferLine.Validate("Transfer-from Bin Code", TransRcptLine."Transfer-from Bin Code");
        end;
        if RecBin.GET(TransferHead."Transfer-to Code", TransRcptLine."Transfer-to Bin Code") then begin
            //TransferLine.Validate("Transfer-to Bin Code", TransShptLine."Transfer-to Bin Code");
            TransferLine."Transfer-to Bin Code" := TransRcptLine."Transfer-to Bin Code";
        end;

        TransferLine."Shortcut Dimension 1 Code" := TransRcptLine."Shortcut Dimension 1 Code";
        TransferLine."Shortcut Dimension 2 Code" := TransRcptLine."Shortcut Dimension 2 Code";
        TransferLine."Dimension Set ID" := TransRcptLine."Dimension Set ID";
        TransferLine."Shipment Tracking Code" := TransRcptLine."Shipment Tracking Code";
        TransferLine.Insert(true);

        TransRcptLine.FilterPstdDocLnItemLedgEntries(ItemLedgerEntry);
        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempItemLedgerEntry, ItemLedgerEntry);
        ItemTrackingMgt.CopyItemLedgEntryTrkgToTransferLine(TempItemLedgerEntry, TransferLine);
    end;

}
