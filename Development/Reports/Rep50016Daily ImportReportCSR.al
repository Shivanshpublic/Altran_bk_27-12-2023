report 50016 "Daily Import Report CSR"
{
    ProcessingOnly = true;
    Caption = 'Daily Import Report CSR';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            RequestFilterFields = Type, "No.", "Buy-from Vendor No.";
            trigger OnPreDataItem()
            begin
                if ShowOnlyRcvdnotInv then
                    SetFilter("Qty. Rcd. Not Invoiced", '<>%1', 0);
                IF (StartingDate <> 0D) AND (EndingDate <> 0D) then
                    SetRange("Order Date", StartingDate, EndingDate);
            end;

            trigger OnAfterGetRecord()
            begin
                ExporttoExcel;
            end;


        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(StartingDate; StartingDate)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                    }
                    field(EndingDate; EndingDate)
                    {
                        Caption = 'Ending Date';
                        ApplicationArea = All;
                    }
                    field(ShowOnlyRcvdnotInv; ShowOnlyRcvdnotInv)
                    {
                        Caption = 'Show only received not Invoiced';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;

    trigger OnPreReport()
    begin
        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();
        MakeHeader;
    end;

    var

        i: Integer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";
        PurchHeader: Record "Purchase Header";
        PurchRcptHead: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchILE: Record "Item Ledger Entry";
        SalesILE: Record "Item Ledger Entry";
        ShipmentTrackingHeader: Record "Tracking Shipment Header";
        ShipmentTrackingLine: Record "Tracking Shipment Line";
        Item: Record Item;
        Customer: Record Customer;
        ExcelBuffer: Record "Excel Buffer" temporary;
        StartingDate: Date;
        EndingDate: Date;
        lPODate: Date;
        lPONo: Code[20];
        lShipmentStatus: Code[20];
        lCustomerReqDate: Date;
        lSupplier: Text[100];
        lPartNumber: Code[20];
        lQuantity: Decimal;
        lCost: Decimal;
        lTotalCost: Decimal;
        lPRQuantity: Decimal;
        lPRCost: Decimal;
        lPRTotalCost: Decimal;
        lSellingQty: Decimal;
        lSellingCost: Decimal;
        lSellingPrice: Decimal;
        LotInfo: Text[250];
        lTotalSell: Decimal;
        lShipTo: Text[100];
        lCustomer: Text[100];
        lCustomerPO: Code[35];
        lVia: Code[20];
        lForwarder: Code[20];
        lETD: Date;
        lETA: Date;
        lCBM: Decimal;
        lCTNS: Decimal;
        lKG: Decimal;
        lVessel: Code[20];
        lBLAWB: Text[250];
        lContainer: Text[50];
        lInvoiceNo: code[20];
        lInvoiceReceived: Date;
        lFreightRate: Decimal;
        lShipTrackingNo: code[20];
        ShowOnlyRcvdnotInv: Boolean;
        lMBL: Text[200];
        lHBL: Text[200];
        lRcptNo: Code[250];
        lRcptLineNo: Integer;

    local procedure MakeHeader()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Company Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(COMPANYNAME, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Period of Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(FORMAT(StartingDate) + '..' + FORMAT(EndingDate), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;

        ExcelBuffer.AddColumn('Type of Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Daily Import Report CSR', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;


        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('P.O. Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('P.O. #', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receipt Doc', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receipt Doc Line No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipment Status', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        //ExcelBuffer.AddColumn('Updates/Factory Ship Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Part Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receipt Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receipt Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receipt Total Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Sell', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ship-To', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer P.O.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('VIA', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Forwarder', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date Of Dispatch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date Of Arrival', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CBM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CTNS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vessel', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BL/AWB #', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Container #', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Received', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Shipment Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipment Tracking No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MBL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HBL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Lot', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure ExporttoExcel()
    var
        SalesQty: Decimal;
        S_CostAmountActual: Decimal;
        S_SalesAmountActual: Decimal;
    begin
        ExcelBuffer.NewRow;
        ClearVariable;
        PurchHeader.Get("Purchase Line"."Document Type", "Purchase Line"."Document No.");
        SalesHeader.Reset();
        SalesLine.Reset();
        SalesInvHeader.Reset();
        SalesInvLine.Reset();
        ShipmentTrackingHeader.Reset();

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", "Purchase Line"."No.");
        SalesLine.SetRange("PO No.", "Purchase Line"."Document No.");
        SalesLine.SetRange("PO Line No.", "Purchase Line"."Line No.");
        if SalesLine.FindFirst() then begin
            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
            lSellingQty := SalesLine.Quantity;
            lSellingPrice := SalesLine."Unit Price";
            lCustomerReqDate := SalesLine."Planned Delivery Date";
            lCustomer := SalesHeader."Sell-to Customer Name";
            lCustomerPO := SalesHeader."External Document No.";
            lTotalSell := SalesLine."Line Amount";

            SalesInvLine.SetRange("Order No.", SalesLine."Document No.");
            SalesInvLine.SetRange("Order Line No.", SalesLine."Line No.");
            SalesInvLine.SetRange("PO No.", SalesLine."PO No.");
            SalesInvLine.SetRange("PO Line No.", SalesLine."PO Line No.");
            SalesInvLine.SetRange(Type, SalesLine.Type);
            SalesInvLine.SetRange("No.", SalesLine."No.");
            if SalesInvLine.FindFirst() then begin
                SalesInvHeader.Get(SalesInvLine."Document No.");
                lInvoiceNo := SalesInvLine."Document No.";
                lInvoiceReceived := SalesInvLine."Posting Date";
            end;
        end else begin
            SalesInvLine.SetRange("Order No.", SalesLine."Document No.");
            SalesInvLine.SetRange("Order Line No.", SalesLine."Line No.");
            SalesInvLine.SetRange("PO No.", SalesLine."PO No.");
            SalesInvLine.SetRange("PO Line No.", SalesLine."PO Line No.");
            SalesInvLine.SetRange(Type, SalesLine.Type);
            SalesInvLine.SetRange("No.", SalesLine."No.");
            if SalesInvLine.FindFirst() then begin
                SalesInvHeader.Get(SalesInvLine."Document No.");
                lSellingQty := SalesInvLine.Quantity;
                lSellingPrice := SalesInvLine."Unit Price";
                lCustomer := SalesInvHeader."Sell-to Customer Name";
                lCustomerPO := SalesInvHeader."External Document No.";
                lTotalSell := SalesInvLine."Line Amount";
                lInvoiceNo := SalesInvLine."Document No.";
                lInvoiceReceived := SalesInvLine."Posting Date";
            end;
        end;

        SalesILE.Reset();
        SalesILE.SetCurrentKey("Item No.", "Entry Type");
        SalesILE.SetRange("Item No.", "Purchase Line"."No.");
        SalesILE.SetRange("Entry Type", PurchILE."Entry Type"::Sale);
        SalesILE.SetRange("Document Type", PurchILE."Document Type"::"Sales Shipment");

        PurchILE.Reset();
        PurchILE.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
        //PurchILE.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type");
        //PurchILE.SetCurrentKey("Item No.", "Entry Type");
        PurchILE.SetRange("Document No.", PurchRcptLine."Document No.");
        PurchILE.SetRange("Document Type", PurchILE."Document Type"::"Purchase Receipt");
        PurchILE.SetRange("Item No.", "Purchase Line"."No.");

        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Order No.", "Purchase Line"."Document No.");
        PurchRcptLine.SetRange("Order Line No.", "Purchase Line"."Line No.");
        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SetRange("No.", "Purchase Line"."No.");
        if PurchRcptLine.FindFirst() then begin
            repeat
                if PurchRcptLine."Item Rcpt. Entry No." <> 0 then begin
                    PurchILE.SetRange("Entry No.", PurchRcptLine."Item Rcpt. Entry No.")
                end else begin
                    PurchILE.SetRange("Document Line No.", PurchRcptLine."Line No.");
                end;
                PurchILE.SetRange("Document No.", PurchRcptLine."Document No.");
                IF PurchILE.FindFirst() then
                    repeat
                        SalesILE.SetRange("Lot No.", PurchILE."Lot No.");
                        if SalesILE.FindFirst() then
                            repeat
                                if SalesILE."Lot No." <> '' then
                                    if LotInfo <> '' then
                                        LotInfo += ', ' + SalesILE."Lot No."
                                    else
                                        LotInfo += SalesILE."Lot No.";
                                SalesILE.CalcFields("Cost Amount (Actual)", "Sales Amount (Actual)");
                                SalesQty += (-1 * SalesILE.Quantity);
                                S_CostAmountActual += (-1 * SalesILE."Cost Amount (Actual)");
                                S_SalesAmountActual += SalesILE."Sales Amount (Actual)";
                            until SalesILE.Next() = 0;
                    until PurchILE.Next() = 0;
                if lRcptNo <> '' then
                    lRcptNo += ', ' + PurchRcptLine."Document No."
                else
                    lRcptNo += PurchRcptLine."Document No.";
                if lRcptLineNo = 0 then
                    lRcptLineNo := PurchRcptLine."Line No.";
            until PurchRcptLine.Next() = 0;
        end;

        if S_SalesAmountActual <> 0 then begin
            lSellingCost := S_CostAmountActual;
            lTotalSell := S_SalesAmountActual;
            lSellingQty := SalesQty;
            if lSellingQty <> 0 then
                lSellingPrice := S_SalesAmountActual / lSellingQty;
        end;

        ShipmentTrackingLine.Reset();
        ShipmentTrackingLine.SetRange("PO No.", "Purchase Line"."Document No.");
        ShipmentTrackingLine.SetRange("PO Line No.", "Purchase Line"."Line No.");
        ShipmentTrackingLine.SetRange("Item No.", "Purchase Line"."No.");
        if ShipmentTrackingLine.FindFirst() then begin
            ShipmentTrackingHeader.Get(ShipmentTrackingLine."Tracking Code");
            lBLAWB := ShipmentTrackingHeader."Freight Details";
            lContainer := ShipmentTrackingHeader."Container No.";
            lFreightRate := ShipmentTrackingHeader."Total Shipment Cost";
            if ShipmentTrackingLine."Date of Dispatch" = 0D then
                lETD := ShipmentTrackingHeader."Date of Dispatch"
            else
                lETD := ShipmentTrackingLine."Date of Dispatch";
            lETA := ShipmentTrackingLine."Date of Arrival";
            lForwarder := ShipmentTrackingHeader."Supplier No.";
            lVessel := ShipmentTrackingHeader."MMSI Code";
            lShipTrackingNo := ShipmentTrackingHeader.Code;
            lMBL := ShipmentTrackingHeader.MBL;
            lHBL := ShipmentTrackingHeader.HBL;
            //lRcptNo := ShipmentTrackingLine."Receipt No.";
            //lRcptLineNo := ShipmentTrackingLine."Receipt Line No.";
        end;

        lPODate := "Purchase Line"."Order Date";
        lPONo := "Purchase Line"."Document No.";
        lShipmentStatus := "Purchase Line"."Milestone Status";
        lSupplier := PurchHeader."Buy-from Vendor Name";
        lPartNumber := "Purchase Line"."No.";
        lQuantity := "Purchase Line".Quantity;
        lCost := "Purchase Line"."Direct Unit Cost";
        lTotalCost := "Purchase Line".Amount;
        lPRQuantity := "Purchase Line"."Quantity Received";
        lPRCost := "Purchase Line"."Direct Unit Cost";
        lPRTotalCost := lPRQuantity * lPRCost;
        lShipTo := PurchHeader."Ship-to Name";
        lVia := PurchHeader.VIA;
        lCBM := "Purchase Line"."Total CBM";
        lCTNS := 0;
        lKG := "Purchase Line"."Total Gross (KG)";


        ExcelBuffer.AddColumn(lPODate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPONo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lRcptNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lRcptLineNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lShipmentStatus, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        //ExcelBuffer.AddColumn(lCustomerReqDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSupplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPartNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lQuantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lTotalCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPRQuantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPRCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPRTotalCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSellingQty, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lSellingCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lSellingPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lTotalSell, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lShipTo, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCustomer, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCustomerPO, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lVia, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lForwarder, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lETD, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lETA, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCBM, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCTNS, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lKG, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lVessel, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lBLAWB, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lContainer, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lInvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lInvoiceReceived, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lFreightRate, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lShipTrackingNo, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lMBL, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lHBL, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(LotInfo, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure ClearVariable()
    begin
        Clear(lPODate);
        Clear(lPONo);
        Clear(lShipmentStatus);
        Clear(lCustomerReqDate);
        Clear(lSupplier);
        Clear(lPartNumber);
        Clear(lQuantity);
        Clear(lCost);
        Clear(lTotalCost);
        Clear(lPRQuantity);
        Clear(lPRCost);
        Clear(lPRTotalCost);
        Clear(lSellingQty);
        Clear(lSellingCost);
        Clear(lSellingPrice);
        Clear(LotInfo);
        Clear(lTotalSell);
        Clear(lShipTo);
        Clear(lCustomer);
        Clear(lCustomerPO);
        Clear(lVia);
        Clear(lForwarder);
        Clear(lETD);
        Clear(lETA);
        Clear(lCBM);
        Clear(lCTNS);
        Clear(lKG);
        Clear(lVessel);
        Clear(lBLAWB);
        Clear(lContainer);
        Clear(lInvoiceNo);
        Clear(lInvoiceReceived);
        Clear(lFreightRate);
        Clear(lShipTrackingNo);
        Clear(lMBL);
        Clear(lHBL);
        Clear(lRcptNo);
        Clear(lRcptLineNo);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('BookName');
        ExcelBuffer.WriteSheet('BookName', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('BookName');
        ExcelBuffer.OpenExcel();
    end;

}

