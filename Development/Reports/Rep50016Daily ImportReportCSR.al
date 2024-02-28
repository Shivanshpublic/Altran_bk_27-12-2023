report 50016 "Daily Import Report CSR"
{
    ProcessingOnly = true;
    Caption = 'Daily Import Report CSR';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = FIELD("No.");

                RequestFilterFields = Type, "No.", "Buy-from Vendor No.";
                trigger OnPreDataItem()
                begin
                    if ShowOnlyRcvdnotInv then
                        SetFilter("Qty. Rcd. Not Invoiced", '<>%1', 0);
                    //IF (StartingDate <> 0D) AND (EndingDate <> 0D) then
                    //SetRange("Order Date", StartingDate, EndingDate);
                end;

                trigger OnAfterGetRecord()
                begin
                    ExporttoExcel;
                end;


            }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", "Document Type"::Order);
                IF (StartingDate <> 0D) AND (EndingDate <> 0D) then
                    SetRange("Creation Date", StartingDate, EndingDate);
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
        ResEntry: Record "Reservation Entry";
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
        lPOShipTo: Text[100];
        lSOShipTo: Text[100];
        lItemCategory: Code[20];
        lSOLLocationCode: Code[10];
        lPOLLocationCode: Code[10];
        lCustomer: Text[100];
        lCustomerPO: Code[35];
        lVia: Code[20];
        lForwarder: Code[20];
        lForwarderName: Text[100];
        lETD: Date;
        lETA: Date;
        lCBM: Decimal;
        lCTNS: Decimal;
        lKG: Decimal;
        lVessel: Code[20];
        lBLAWB: Text[250];
        lContainer: Text[50];
        lInvoiceNo: code[20];
        lVendorInvoiceNo: code[35];
        lInvoiceReceived: Date;
        lFreightRate: Decimal;
        lShipTrackingNo: code[20];
        ShowOnlyRcvdnotInv: Boolean;
        lMBL: Text[200];
        lHBL: Text[200];
        lRcptNo: Code[250];
        lRcptLineNo: Integer;
        lRemarks: Text[250];
        lDeliveryLeadTime: DateFormula;
        lPortOfDispatch: Text[50];
        lPortOfLoad: Text[50];
        lFCLLCL: Enum FCL_LCL_Option;
        lShipmentDate: Date;
        lPlanShipDate: Date;
        lAssignedCSR: Code[50];
        lSOOrderNo: Code[250];
        lPurchNote: Text[250];
        lExpArriveFGDropShip: Date;
        lBookedDate: Date;
        lFactoryReadyDate: Date;
        Vendor: Record Vendor;

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
        ExcelBuffer.AddColumn('Lot', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipment Status', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Part Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Notes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Factory Ready Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Booked Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receipt Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        //ExcelBuffer.AddColumn('Receipt Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receipt Total Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Expected to Arrive at FG/DropShip', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PO Lines Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ship-To', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('VIA', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CBM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CTNS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Received', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Invoice No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Order No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer P.O.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Assigned CSR', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Lines Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Sell', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Required Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Planned Shipment Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipment Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Ship-To', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipment Tracking No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Forwarder Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Container #', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vessel', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BL/AWB #', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MBL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HBL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FCL/LCL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Port Of Dispatch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Port Of Load', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date Of Dispatch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date Of Dispatch (Calendar Week)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Delivery Lead Time', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Date Of Arrival', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Shipment Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Remarks', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure ExporttoExcel()
    var
        SalesQty: Decimal;
        S_CostAmountActual: Decimal;
        S_SalesAmountActual: Decimal;
        BlankDate: Date;
    begin
        ExcelBuffer.NewRow;
        ClearVariable;
        PurchHeader.Get("Purchase Line"."Document Type", "Purchase Line"."Document No.");
        SalesHeader.Reset();
        SalesLine.Reset();
        SalesInvHeader.Reset();
        SalesInvLine.Reset();
        ShipmentTrackingHeader.Reset();
        ResEntry.Reset();
        ResEntry.Setrange("Source Type", 39);
        ResEntry.Setrange("Source Subtype", 1);
        ResEntry.Setrange("Source ID", "Purchase Line"."Document No.");
        ResEntry.Setrange("Source Ref. No.", "Purchase Line"."Line No.");
        if ResEntry.FindFirst() then
            repeat
                if LotInfo <> '' then
                    LotInfo += ', ' + ResEntry."Lot No."
                else
                    LotInfo += ResEntry."Lot No.";
            until ResEntry.Next() = 0;

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
            lShipmentDate := SalesLine."Shipment Date";
            lPlanShipDate := SalesLine."Planned Shipment Date";
            lAssignedCSR := SalesLine."Assigned CSR";
            lSOLLocationCode := SalesLine."Location Code";
            lSOShipTo := SalesHeader."Ship-to Name";

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
                lVendorInvoiceNo := SalesInvHeader."External Document No.";
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
                lVendorInvoiceNo := SalesInvHeader."External Document No.";
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
            Clear(LotInfo);
            repeat
                if PurchRcptLine."Item Rcpt. Entry No." <> 0 then begin
                    PurchILE.SetRange("Entry No.", PurchRcptLine."Item Rcpt. Entry No.")
                end else begin
                    PurchILE.SetRange("Document Line No.", PurchRcptLine."Line No.");
                end;
                PurchILE.SetRange("Document No.", PurchRcptLine."Document No.");
                IF PurchILE.FindFirst() then
                    repeat
                        if PurchILE."Lot No." <> '' then
                            if LotInfo <> '' then
                                LotInfo += ', ' + PurchILE."Lot No."
                            else
                                LotInfo += PurchILE."Lot No.";

                        SalesILE.SetRange("Lot No.", PurchILE."Lot No.");
                        if SalesILE.FindFirst() then
                            repeat
                                // if SalesILE."Lot No." <> '' then
                                //     if LotInfo <> '' then
                                //         LotInfo += ', ' + SalesILE."Lot No."
                                //     else
                                //         LotInfo += SalesILE."Lot No.";
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
            if Vendor.Get(ShipmentTrackingHeader."Supplier No.") then
                lForwarderName := Vendor.Name;
            lVessel := ShipmentTrackingHeader."MMSI Code";
            lShipTrackingNo := ShipmentTrackingHeader.Code;
            lMBL := ShipmentTrackingHeader.MBL;
            lHBL := ShipmentTrackingHeader.HBL;
            lRemarks := ShipmentTrackingHeader.Remarks;
            lDeliveryLeadTime := ShipmentTrackingHeader."Delivery Lead Time";
            lPortOfDispatch := ShipmentTrackingHeader."Port of Dispatch";
            lPortOfLoad := ShipmentTrackingHeader."Port of Load";
            lFCLLCL := ShipmentTrackingHeader."FCL/LCL";
            lShipmentStatus := ShipmentTrackingHeader."Milestone Status";
            //lRcptNo := ShipmentTrackingLine."Receipt No.";
            //lRcptLineNo := ShipmentTrackingLine."Receipt Line No.";
        end;

        //lPODate := "Purchase Line"."Order Date";
        lPODate := PurchHeader."Creation Date";
        lPONo := "Purchase Line"."Document No.";
        if "Purchase Line".Quantity <> "Purchase Line"."Quantity Received" then
            lShipmentStatus := "Purchase Line"."Milestone Status";
        lSupplier := PurchHeader."Buy-from Vendor Name";
        lPartNumber := "Purchase Line"."No.";
        lQuantity := "Purchase Line".Quantity;
        lCost := "Purchase Line"."Direct Unit Cost";
        lTotalCost := "Purchase Line".Amount;
        lPRQuantity := "Purchase Line"."Quantity Received";
        lPRCost := "Purchase Line"."Direct Unit Cost";
        lPRTotalCost := lPRQuantity * lPRCost;
        lPOShipTo := PurchHeader."Ship-to Name";
        lVia := PurchHeader.VIA;
        lCBM := "Purchase Line"."Total CBM";
        lCTNS := 0;
        lKG := "Purchase Line"."Total Gross (KG)";
        //LotInfo := "Purchase Line"."Lot No.";
        lFactoryReadyDate := "Purchase Line"."Promised Receipt Date";
        lBookedDate := "Purchase Line"."Planned Receipt Date";
        lExpArriveFGDropShip := "Purchase Line"."Expected Receipt Date";
        lPurchNote := "Purchase Line"."Order Note";
        lSOOrderNo := "Purchase Line"."SO No.";
        lPOLLocationCode := "Purchase Line"."Location Code";
        if "Purchase Line".Type = "Purchase Line".Type::Item then
            If Item.Get("Purchase Line"."No.") then
                lItemCategory := Item."Item Category Code";

        ExcelBuffer.AddColumn(lPODate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lPONo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lRcptNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lRcptLineNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(LotInfo, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lShipmentStatus, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSupplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPartNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lItemCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPurchNote, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lFactoryReadyDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lBookedDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lQuantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lTotalCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lPRQuantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        //ExcelBuffer.AddColumn(lPRCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lPRTotalCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lExpArriveFGDropShip, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPOLLocationCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPOShipTo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lVia, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCBM, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCTNS, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lKG, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lInvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lInvoiceReceived, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lVendorInvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSOOrderNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCustomerPO, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCustomer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lAssignedCSR, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSOLLocationCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSellingQty, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lSellingCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lSellingPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lTotalSell, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCustomerReqDate, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lPlanShipDate, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lShipmentDate, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lSOShipTo, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lShipTrackingNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lForwarder, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lContainer, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lVessel, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lBLAWB, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lMBL, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lHBL, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lFCLLCL, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPortOfDispatch, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPortOfLoad, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lETD, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        if lETD = BlankDate then
            ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn(Date2DWY(lETD, 2), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lDeliveryLeadTime, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lETA, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lFreightRate, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lRemarks, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

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
        Clear(lPOShipTo);
        Clear(lSOShipTo);
        Clear(lSOLLocationCode);
        Clear(lPOLLocationCode);
        Clear(lItemCategory);
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
        Clear(lVendorInvoiceNo);
        Clear(lInvoiceReceived);
        Clear(lFreightRate);
        Clear(lShipTrackingNo);
        Clear(lMBL);
        Clear(lHBL);
        Clear(lRcptNo);
        Clear(lRcptLineNo);
        Clear(lRemarks);
        Clear(lDeliveryLeadTime);
        Clear(lPortOfDispatch);
        Clear(lPortOfLoad);
        Clear(lFCLLCL);
        Clear(lShipmentDate);
        Clear(lPlanShipDate);
        Clear(lAssignedCSR);
        Clear(lSOOrderNo);
        Clear(lPurchNote);
        Clear(lExpArriveFGDropShip);
        Clear(lBookedDate);
        Clear(lFactoryReadyDate);
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

