report 50039 "Daily Import Report CSR New"
{
    ProcessingOnly = true;
    Caption = 'Daily Import Report CSR New';
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
                DataItemTableView = where(Type = filter(Item));
                trigger OnPreDataItem()
                begin

                    if ShowOnlyRcvdnotInv then
                        SetFilter("Qty. Rcd. Not Invoiced", '<>%1', 0);
                    //IF (StartingDate <> 0D) AND (EndingDate <> 0D) then
                    //SetRange("Order Date", StartingDate, EndingDate);
                end;

                trigger OnAfterGetRecord()
                var
                    PRcptLine: Record "Purch. Rcpt. Line";
                    RcptExists: Boolean;
                begin
                    // IF "Purchase Line"."Document No." = 'PO-00432' then
                    //     Message('PO-00432');
                    RcptExists := false;
                    PRcptLine.Reset();
                    PRcptLine.SetRange("Order No.", "Purchase Line"."Document No.");
                    PRcptLine.SetRange("Order Line No.", "Purchase Line"."Line No.");
                    PRcptLine.SetRange(Type, PRcptLine.Type::Item);
                    PRcptLine.SetRange("No.", "Purchase Line"."No.");
                    PRcptLine.SetFilter(Quantity, '<>%1', 0);
                    if PRcptLine.FindFirst() then begin
                        repeat
                            RcptExists := true;
                            ExporttoExcel("Purchase Line", PRcptLine, RcptExists);
                        until PRcptLine.Next() = 0;
                    end else
                        ExporttoExcel("Purchase Line", PRcptLine, RcptExists);
                end;


            }
            trigger OnPreDataItem()
            var
            begin
                SetRange("Document Type", "Document Type"::Order);
                IF (StartingDate <> 0D) AND (EndingDate <> 0D) then
                    SetRange("Creation Date", StartingDate, EndingDate);
            end;

        }
        dataitem("Purchase Header Archive"; "Purchase Header Archive")
        {
            //DataItemTableView = SORTING("PO Exists", "Latest Version") WHERE("PO Exists" = FILTER(false), "Latest Version" = FILTER(true));
            CalcFields = "PO Exists", "Latest Version";
            dataitem("Purchase Line Archive"; "Purchase Line Archive")
            {
                DataItemLinkReference = "Purchase Header Archive";
                RequestFilterFields = Type, "No.", "Buy-from Vendor No.";
                DataItemTableView = where(Type = filter(Item));
                trigger OnPreDataItem()
                begin
                    SetRange("Document Type", "Purchase Header Archive"."Document Type");
                    SetRange("Document No.", "Purchase Header Archive"."No.");
                    SetRange("Doc. No. Occurrence", "Purchase Header Archive"."Doc. No. Occurrence");
                    SetRange("Version No.", "Purchase Header Archive"."Version No.");
                    //if ShowOnlyRcvdnotInv then
                    //    SetFilter("Qty. Rcd. Not Invoiced", '<>%1', 0);
                    //IF (StartingDate <> 0D) AND (EndingDate <> 0D) then
                    //SetRange("Order Date", StartingDate, EndingDate);
                end;

                trigger OnAfterGetRecord()
                var
                    PRcptLine: Record "Purch. Rcpt. Line";
                    RcptExists: Boolean;
                begin
                    // IF "Purchase Line Archive"."Document No." = 'PO-00432' then
                    //     Message('PO-00432');
                    RcptExists := false;
                    PRcptLine.Reset();
                    PRcptLine.SetRange("Order No.", "Purchase Line Archive"."Document No.");
                    PRcptLine.SetRange("Order Line No.", "Purchase Line Archive"."Line No.");
                    PRcptLine.SetRange(Type, PRcptLine.Type::Item);
                    PRcptLine.SetRange("No.", "Purchase Line Archive"."No.");
                    PRcptLine.SetFilter(Quantity, '<>%1', 0);
                    if PRcptLine.FindFirst() then begin
                        repeat
                            RcptExists := true;
                            ExporttoExcelArchive("Purchase Line Archive", PRcptLine, RcptExists);
                        until PRcptLine.Next() = 0;
                    end else
                        ExporttoExcelArchive("Purchase Line Archive", PRcptLine, RcptExists);
                end;


            }
            trigger OnPreDataItem()
            var
            begin
                SetRange("Document Type", "Document Type"::Order);
                IF (StartingDate <> 0D) AND (EndingDate <> 0D) then
                    SetRange("Creation Date", StartingDate, EndingDate);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                if "Purchase Header Archive"."PO Exists" = true then
                    CurrReport.Skip();
                if "Purchase Header Archive"."Version No." <> "Purchase Header Archive"."Latest Version" then
                    CurrReport.Skip();
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
        SalesLineArchive: Record "Sales Line Archive";
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";
        PurchHeader: Record "Purchase Header";
        PurchArHeader: Record "Purchase Header Archive";
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
        lModelNumber: Text[50];
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
        SampleOrder: Boolean;
        lATD: Date;
        ATAPort: Date;
        ATASterling: Date;
        TotalInTransitDays: Integer;
        TotalNetKG: Decimal;
        PalletQty: Decimal;
        CustomerIncoterms: Text[100];
        SalesDirector: Text[50];
        RegionalManager: Text[50];
        ExternalRep: Text[50];
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
        lLineType: Enum "Purchase Line Type";
        PurchUOM: Code[20];
        SalesUOM: Code[20];
        lExpArriveFGDropShip: Date;
        lBookedDate: Date;
        lFactoryReadyDate: Date;
        Vendor: Record Vendor;
        Salesperson: Record "Salesperson/Purchaser";
        TmpPurchInvLine: Record "Purch. Inv. Line" temporary;
        PurchInvHead: Record "Purch. Inv. Header";

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
        ExcelBuffer.AddColumn('Shipment Tracking No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Lot', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Received', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Invoice No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Notes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Factory Ready Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Booked Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ETD', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('(Actual Time to Departcher) ATD', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Origin Ship Date (Calendar Week)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ETA (Port)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ATA (Port)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ATA (Sterling)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Part Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Model Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Line Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
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
        ExcelBuffer.AddColumn('Customer', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Order No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer P.O.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sample Order', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Assigned CSR', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Director', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regional Manager', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('External Team', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Lines Location Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        // ExcelBuffer.AddColumn('Sell Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Sell', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Required Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Planned Shipment Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Actual Shipment Date (ASD)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SO Ship-To', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Incoterms', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Forwarder Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Container #', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vessel', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('AWB #', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MBL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HBL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Mode of Shipment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Port Of Destination', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Port Of Origin', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Delivery Lead Time (Port)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total in-Transit Days', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CBM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CTNS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('KGS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Net (KG)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Pallet Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        // ExcelBuffer.AddColumn('Port Of Dispatch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        // ExcelBuffer.AddColumn('Port Of Load', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        // ExcelBuffer.AddColumn('Date Of Dispatch', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        // ExcelBuffer.AddColumn('Date Of Dispatch (Calendar Week)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        // ExcelBuffer.AddColumn('Date Of Arrival', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Shipment Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Remarks', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure ExporttoExcel(var PL: Record "Purchase Line"; var PRcptLine: Record "Purch. Rcpt. Line"; RcptExists: Boolean)
    var
        SalesQty: Decimal;
        S_CostAmountActual: Decimal;
        S_SalesAmountActual: Decimal;
        BlankDate: Date;
        ShipmentMethod: Record "Shipment Method";

    begin
        ExcelBuffer.NewRow;
        ClearVariable;

        //Purchase Order
        PurchHeader.Get(PL."Document Type", PL."Document No.");
        lPODate := PurchHeader."Creation Date";
        lPOShipTo := PurchHeader."Ship-to Name";
        lVia := PurchHeader.VIA;
        lPONo := PL."Document No.";
        if PL.Quantity <> PL."Quantity Received" then
            lShipmentStatus := PL."Milestone Status";
        lSupplier := PurchHeader."Buy-from Vendor Name";
        lPartNumber := PL."No.";
        lModelNumber := PL."Description 2";
        lQuantity := PL.Quantity;
        lLineType := PL.Type;
        PurchUOM := PL."Unit of Measure Code";
        lCost := PL."Direct Unit Cost";
        lTotalCost := PL.Amount;
        lCBM := PL."Total CBM";
        lCTNS := 0;
        lKG := PL."Total Gross (KG)";
        //LotInfo := "Purchase Line"."Lot No.";
        lFactoryReadyDate := PL."Promised Receipt Date";
        lBookedDate := PL."Planned Receipt Date";
        lExpArriveFGDropShip := PL."Expected Receipt Date";
        lPurchNote := PL."Order Note";
        lSOOrderNo := PL."SO No.";
        lPOLLocationCode := PL."Location Code";
        if PL.Type = PL.Type::Item then
            If Item.Get(PL."No.") then
                lItemCategory := Item."Item Category Code";
        if lShipmentStatus = '' then
            lShipmentStatus := PL."Milestone Status";

        ResEntry.Reset();
        ResEntry.Setrange("Source Type", 39);
        ResEntry.Setrange("Source Subtype", 1);
        ResEntry.Setrange("Source ID", PL."Document No.");
        ResEntry.Setrange("Source Ref. No.", PL."Line No.");
        if ResEntry.FindFirst() then
            repeat
                if LotInfo <> '' then
                    LotInfo += ', ' + ResEntry."Lot No."
                else
                    LotInfo += ResEntry."Lot No.";
            until ResEntry.Next() = 0;


        //Purchase Receipt Details
        if RcptExists = true then begin
            PurchInvHead.Reset();
            lRcptNo := PRcptLine."Document No.";
            lRcptLineNo := PRcptLine."Line No.";
            lShipmentStatus := PRcptLine."Milestone Status";
            lPRQuantity := PRcptLine.Quantity;
            lLineType := PRcptLine.Type;
            PurchUOM := PRcptLine."Unit of Measure Code";
            lPRCost := PRcptLine."Direct Unit Cost";
            lPRTotalCost := lPRQuantity * lPRCost;
            GetPurchInvLines(TmpPurchInvLine, PL, PRcptLine);
            if TmpPurchInvLine.FindFirst() then begin
                PurchInvHead.Get(TmpPurchInvLine."Document No.");
                lInvoiceNo := PurchInvHead."No.";
                lInvoiceReceived := PurchInvHead."Posting Date";
                lVendorInvoiceNo := PurchInvHead."Vendor Invoice No.";
                TmpPurchInvLine.DeleteAll();
            end;
        end;

        //Shipment Tracking Details
        ShipmentTrackingHeader.Reset();
        ShipmentTrackingLine.Reset();
        if RcptExists = false then begin
            ShipmentTrackingLine.SetRange("PO No.", "Purchase Line"."Document No.");
            ShipmentTrackingLine.SetRange("PO Line No.", "Purchase Line"."Line No.");
        end else begin
            ShipmentTrackingLine.SetRange("Receipt No.", PRcptLine."Document No.");
            ShipmentTrackingLine.SetRange("Receipt Line No.", PRcptLine."Line No.");
        end;
        ShipmentTrackingLine.SetRange("Item No.", "Purchase Line"."No.");
        if ShipmentTrackingLine.FindFirst() then begin
            ShipmentTrackingHeader.Get(ShipmentTrackingLine."Tracking Code");
            lBLAWB := ShipmentTrackingHeader."Freight Details";
            lContainer := ShipmentTrackingHeader."Container No.";
            lATD := ShipmentTrackingHeader.ATD;
            ATAPort := ShipmentTrackingHeader."ATA(Port)";
            ATASterling := ShipmentTrackingHeader."ATA(Sterling)";
            //lFreightRate := ShipmentTrackingHeader."Total Shipment Cost";
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
            //ShipmentTrackingHeader.CalcFields("Total Net (KG)", "Pallet Quantity");
            TotalInTransitDays := ShipmentTrackingHeader."Total in-Transit Days";
            lFreightRate := ShipmentTrackingLine."Shipment Cost";
            if ShipmentTrackingLine."Date of Dispatch" = 0D then
                lETD := ShipmentTrackingHeader."Date of Dispatch"
            else
                lETD := ShipmentTrackingLine."Date of Dispatch";

            TotalNetKG := ShipmentTrackingLine."Total Net (KG)";
            PalletQty := ShipmentTrackingLine."Pallet Quantity";
            lETA := ShipmentTrackingLine."Date of Arrival";
        end;


        //Sales Details
        SalesHeader.Reset();
        SalesLine.Reset();
        SalesHeaderArchive.Reset();
        SalesLineArchive.Reset();
        SalesInvHeader.Reset();
        SalesInvLine.Reset();

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", PL."No.");
        SalesLine.SetRange("PO No.", PL."Document No.");
        SalesLine.SetRange("PO Line No.", PL."Line No.");
        //SalesLine.SetRange("Shipment Tracking Code", ShipmentTrackingLine."Tracking Code");
        //SalesLine.SetRange("Shipment Tracking Line No.", ShipmentTrackingLine."Line No.");
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
            SalesUOM := SalesLine."Unit of Measure Code";
            lSOLLocationCode := SalesLine."Location Code";
            lSOShipTo := SalesHeader."Ship-to Name";
            if ShipmentMethod.Get(SalesHeader."Shipment Method Code") then
                CustomerIncoterms := ShipmentMethod.Description;
            SalesDirector := SalesLine."Salesperson Name";
            RegionalManager := SalesLine."Internal Team Name";
            if Salesperson.Get(SalesLine."External Rep") then
                ExternalRep := Salesperson.Name;
            SampleOrder := SalesHeader."Sample Order";
            SalesInvLine.SetRange("Order No.", SalesLine."Document No.");
            SalesInvLine.SetRange("Order Line No.", SalesLine."Line No.");
            SalesInvLine.SetRange("PO No.", SalesLine."PO No.");
            SalesInvLine.SetRange("PO Line No.", SalesLine."PO Line No.");
            SalesInvLine.SetRange("Shipment Tracking Code", SalesLine."Shipment Tracking Code");
            SalesInvLine.SetRange("Shipment Tracking Line No.", SalesLine."Shipment Tracking Line No.");
            SalesInvLine.SetRange(Type, SalesLine.Type);
            SalesInvLine.SetRange("No.", SalesLine."No.");
            if SalesInvLine.FindFirst() then begin
                lSellingQty := SalesInvLine.Quantity;
                lSellingPrice := SalesInvLine."Unit Price";
                lTotalSell := SalesInvLine."Line Amount";
            end;
        end else begin
            SalesLineArchive.SetRange("Document Type", SalesLineArchive."Document Type"::Order);
            SalesLineArchive.SetRange(Type, SalesLineArchive.Type::Item);
            SalesLineArchive.SetRange("No.", PL."No.");
            SalesLineArchive.SetRange("PO No.", PL."Document No.");
            SalesLineArchive.SetRange("PO Line No.", PL."Line No.");
            //SalesLineArchive.SetRange("Shipment Tracking Code", ShipmentTrackingLine."Tracking Code");
            //SalesLineArchive.SetRange("Shipment Tracking Line No.", ShipmentTrackingLine."Line No.");
            if SalesLineArchive.FindLast() then begin
                SalesHeaderArchive.Get(SalesLineArchive."Document Type", SalesLineArchive."Document No.", SalesLineArchive."Doc. No. Occurrence", SalesLineArchive."Version No.");
                lCustomer := SalesHeaderArchive."Sell-to Customer Name";
                lCustomerPO := SalesHeaderArchive."External Document No.";
                lCustomerReqDate := SalesLineArchive."Planned Delivery Date";
                lShipmentDate := SalesLineArchive."Shipment Date";
                lPlanShipDate := SalesLineArchive."Planned Shipment Date";
                lAssignedCSR := SalesLineArchive."Assigned CSR";
                SalesUOM := SalesLineArchive."Unit of Measure Code";
                lSOLLocationCode := SalesLineArchive."Location Code";
                lSOShipTo := SalesHeaderArchive."Ship-to Name";
                if ShipmentMethod.Get(SalesHeaderArchive."Shipment Method Code") then
                    CustomerIncoterms := ShipmentMethod.Description;
                SalesDirector := SalesLineArchive."Salesperson Name";
                RegionalManager := SalesLineArchive."Internal Team Name";
                if Salesperson.Get(SalesLineArchive."External Rep") then
                    ExternalRep := Salesperson.Name;
                SampleOrder := SalesHeaderArchive."Sample Order";
            end;

            SalesInvLine.SetRange("Order No.", PL."SO No.");
            SalesInvLine.SetRange("Order Line No.", PL."SO Line No.");
            SalesInvLine.SetRange("PO No.", PL."Document No.");
            SalesInvLine.SetRange("PO Line No.", PL."Line No.");
            SalesInvLine.SetRange("Shipment Tracking Code", ShipmentTrackingLine."Tracking Code");
            SalesInvLine.SetRange("Shipment Tracking Line No.", ShipmentTrackingLine."Line No.");
            SalesInvLine.SetRange(Type, SalesInvLine.Type);
            SalesInvLine.SetRange("No.", PL."No.");
            if SalesInvLine.FindFirst() then begin
                SalesInvHeader.Get(SalesInvLine."Document No.");
                lSellingQty := SalesInvLine.Quantity;
                lSellingPrice := SalesInvLine."Unit Price";
                lCustomer := SalesInvHeader."Sell-to Customer Name";
                lCustomerPO := SalesInvHeader."External Document No.";
                lTotalSell := SalesInvLine."Line Amount";
                SampleOrder := SalesInvHeader."Sample Order";
            end;
        end;


        PurchILE.Reset();
        PurchILE.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
        PurchILE.SetRange("Document No.", PRcptLine."Document No.");
        PurchILE.SetRange("Document Type", PurchILE."Document Type"::"Purchase Receipt");
        PurchILE.SetRange("Item No.", PRcptLine."No.");

        if PRcptLine."Item Rcpt. Entry No." <> 0 then begin
            PurchILE.SetRange("Entry No.", PRcptLine."Item Rcpt. Entry No.")
        end else begin
            PurchILE.SetRange("Document Line No.", PRcptLine."Line No.");
        end;
        IF PurchILE.FindFirst() then
            repeat
                if PurchILE."Lot No." <> '' then
                    if LotInfo <> '' then
                        LotInfo += ', ' + PurchILE."Lot No."
                    else
                        LotInfo += PurchILE."Lot No.";

            until PurchILE.Next() = 0;


        ExcelBuffer.AddColumn(lPODate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lPONo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lRcptNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lRcptLineNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lShipmentStatus, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lShipTrackingNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(LotInfo, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSupplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lInvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lInvoiceReceived, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lVendorInvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPurchNote, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lFactoryReadyDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lBookedDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lETD, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lATD, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        if lATD = BlankDate then
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn(Date2DWY(lATD, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lETA, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ATAPort, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ATASterling, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPartNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lModelNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lLineType, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lItemCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchUOM, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
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
        ExcelBuffer.AddColumn(lCustomer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSOOrderNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCustomerPO, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SampleOrder, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lAssignedCSR, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesDirector, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RegionalManager, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ExternalRep, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSOLLocationCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesUOM, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSellingQty, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        // ExcelBuffer.AddColumn(lSellingCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lSellingPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lTotalSell, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCustomerReqDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lPlanShipDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lShipmentDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lSOShipTo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CustomerIncoterms, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lForwarderName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lContainer, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lVessel, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lBLAWB, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lMBL, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lHBL, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lFCLLCL, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPortOfDispatch, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPortOfLoad, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lDeliveryLeadTime, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TotalInTransitDays, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCBM, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCTNS, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lKG, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalNetKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(PalletQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lFreightRate, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lRemarks, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

    end;

    local procedure ExporttoExcelArchive(var PLA: Record "Purchase Line Archive"; var PRcptLine: Record "Purch. Rcpt. Line"; RcptExists: Boolean)
    var
        SalesQty: Decimal;
        S_CostAmountActual: Decimal;
        S_SalesAmountActual: Decimal;
        BlankDate: Date;
        ShipmentMethod: Record "Shipment Method";

    begin
        ExcelBuffer.NewRow;
        ClearVariable;

        //Purchase Order Archive
        //"Document Type", "No.", "Doc. No. Occurrence", "Version No."
        PurchArHeader.Get(PLA."Document Type", PLA."Document No.", PLA."Doc. No. Occurrence", PLA."Version No.");
        lPODate := PurchArHeader."Creation Date";
        lPOShipTo := PurchArHeader."Ship-to Name";
        lVia := PurchArHeader.VIA;
        lPONo := PLA."Document No.";
        if PLA.Quantity <> PLA."Quantity Received" then
            lShipmentStatus := PLA."Milestone Status";
        lSupplier := PurchArHeader."Buy-from Vendor Name";
        lPartNumber := PLA."No.";
        lModelNumber := PLA."Description 2";
        lQuantity := PLA.Quantity;
        lLineType := PLA.Type;
        PurchUOM := PLA."Unit of Measure Code";
        lCost := PLA."Direct Unit Cost";
        lTotalCost := PLA.Amount;
        lCBM := PLA."Total CBM";
        lCTNS := 0;
        lKG := PLA."Total Gross (KG)";
        //LotInfo := PLA."Lot No.";
        lFactoryReadyDate := PLA."Promised Receipt Date";
        lBookedDate := PLA."Planned Receipt Date";
        lExpArriveFGDropShip := PLA."Expected Receipt Date";
        lPurchNote := PLA."Order Note";
        lSOOrderNo := PLA."SO No.";
        lPOLLocationCode := PLA."Location Code";
        if PLA.Type = PLA.Type::Item then
            If Item.Get(PLA."No.") then
                lItemCategory := Item."Item Category Code";
        if lShipmentStatus = '' then
            lShipmentStatus := PLA."Milestone Status";

        // ResEntry.Reset();
        // ResEntry.Setrange("Source Type", 39);
        // ResEntry.Setrange("Source Subtype", 1);
        // ResEntry.Setrange("Source ID", PLA."Document No.");
        // ResEntry.Setrange("Source Ref. No.", PLA."Line No.");
        // if ResEntry.FindFirst() then
        //     repeat
        //         if LotInfo <> '' then
        //             LotInfo += ', ' + ResEntry."Lot No."
        //         else
        //             LotInfo += ResEntry."Lot No.";
        //     until ResEntry.Next() = 0;


        //Purchase Receipt Details
        if RcptExists = true then begin
            PurchInvHead.Reset();
            lRcptNo := PRcptLine."Document No.";
            lRcptLineNo := PRcptLine."Line No.";
            lShipmentStatus := PRcptLine."Milestone Status";
            lPRQuantity := PRcptLine.Quantity;
            lLineType := PRcptLine.Type;
            PurchUOM := PRcptLine."Unit of Measure Code";
            lPRCost := PRcptLine."Direct Unit Cost";
            lPRTotalCost := lPRQuantity * lPRCost;
            GetPurchInvLinesArchive(TmpPurchInvLine, PLA, PRcptLine);
            if TmpPurchInvLine.FindFirst() then begin
                PurchInvHead.Get(TmpPurchInvLine."Document No.");
                lInvoiceNo := PurchInvHead."No.";
                lInvoiceReceived := PurchInvHead."Posting Date";
                lVendorInvoiceNo := PurchInvHead."Vendor Invoice No.";
                TmpPurchInvLine.DeleteAll();
            end;
        end;

        //Shipment Tracking Details

        ShipmentTrackingHeader.Reset();
        ShipmentTrackingLine.Reset();
        if RcptExists = false then begin
            ShipmentTrackingLine.SetRange("PO No.", PLA."Document No.");
            ShipmentTrackingLine.SetRange("PO Line No.", PLA."Line No.");
        end else begin
            ShipmentTrackingLine.SetRange("Receipt No.", PRcptLine."Document No.");
            ShipmentTrackingLine.SetRange("Receipt Line No.", PRcptLine."Line No.");
        end;
        //ShipmentTrackingLine.SetRange("Item No.", "Purchase Line"."No.");
        if ShipmentTrackingLine.FindFirst() then begin
            ShipmentTrackingHeader.Get(ShipmentTrackingLine."Tracking Code");
            lBLAWB := ShipmentTrackingHeader."Freight Details";
            lContainer := ShipmentTrackingHeader."Container No.";
            lATD := ShipmentTrackingHeader.ATD;
            ATAPort := ShipmentTrackingHeader."ATA(Port)";
            ATASterling := ShipmentTrackingHeader."ATA(Sterling)";
            //lFreightRate := ShipmentTrackingHeader."Total Shipment Cost";
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
            //ShipmentTrackingHeader.CalcFields("Total Net (KG)", "Pallet Quantity");
            TotalInTransitDays := ShipmentTrackingHeader."Total in-Transit Days";
            lFreightRate := ShipmentTrackingLine."Shipment Cost";
            if ShipmentTrackingLine."Date of Dispatch" = 0D then
                lETD := ShipmentTrackingHeader."Date of Dispatch"
            else
                lETD := ShipmentTrackingLine."Date of Dispatch";

            TotalNetKG := ShipmentTrackingLine."Total Net (KG)";
            PalletQty := ShipmentTrackingLine."Pallet Quantity";
            lETA := ShipmentTrackingLine."Date of Arrival";
        end;


        //Sales Details
        SalesHeader.Reset();
        SalesLine.Reset();
        SalesInvHeader.Reset();
        SalesInvLine.Reset();

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", PLA."No.");
        SalesLine.SetRange("PO No.", PLA."Document No.");
        SalesLine.SetRange("PO Line No.", PLA."Line No.");
        //SalesLine.SetRange("Shipment Tracking Code", ShipmentTrackingLine."Tracking Code");
        //SalesLine.SetRange("Shipment Tracking Line No.", ShipmentTrackingLine."Line No.");
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
            SalesUOM := SalesLine."Unit of Measure Code";
            lSOLLocationCode := SalesLine."Location Code";
            lSOShipTo := SalesHeader."Ship-to Name";
            if ShipmentMethod.Get(SalesHeader."Shipment Method Code") then
                CustomerIncoterms := ShipmentMethod.Description;
            SalesDirector := SalesLine."Salesperson Name";
            RegionalManager := SalesLine."Internal Team Name";
            if Salesperson.Get(SalesLine."External Rep") then
                ExternalRep := Salesperson.Name;
            SampleOrder := SalesHeader."Sample Order";

            SalesInvLine.SetRange("Order No.", SalesLine."Document No.");
            SalesInvLine.SetRange("Order Line No.", SalesLine."Line No.");
            SalesInvLine.SetRange("PO No.", SalesLine."PO No.");
            SalesInvLine.SetRange("PO Line No.", SalesLine."PO Line No.");
            SalesInvLine.SetRange("Shipment Tracking Code", SalesLine."Shipment Tracking Code");
            SalesInvLine.SetRange("Shipment Tracking Line No.", SalesLine."Shipment Tracking Line No.");
            SalesInvLine.SetRange(Type, SalesLine.Type);
            SalesInvLine.SetRange("No.", SalesLine."No.");
            if SalesInvLine.FindFirst() then begin
                //SalesInvHeader.Get(SalesInvLine."Document No.");
                lSellingQty := SalesInvLine.Quantity;
                lSellingPrice := SalesInvLine."Unit Price";
                lTotalSell := SalesInvLine."Line Amount";

                //lInvoiceNo := SalesInvLine."Document No.";
                //lInvoiceReceived := SalesInvLine."Posting Date";
                //lVendorInvoiceNo := SalesInvHeader."External Document No.";
            end;
        end else begin
            SalesLineArchive.SetRange("Document Type", SalesLineArchive."Document Type"::Order);
            SalesLineArchive.SetRange(Type, SalesLineArchive.Type::Item);
            SalesLineArchive.SetRange("No.", PLA."No.");
            SalesLineArchive.SetRange("PO No.", PLA."Document No.");
            SalesLineArchive.SetRange("PO Line No.", PLA."Line No.");
            //SalesLineArchive.SetRange("Shipment Tracking Code", ShipmentTrackingLine."Tracking Code");
            //SalesLineArchive.SetRange("Shipment Tracking Line No.", ShipmentTrackingLine."Line No.");
            if SalesLineArchive.FindLast() then begin
                SalesHeaderArchive.Get(SalesLineArchive."Document Type", SalesLineArchive."Document No.", SalesLineArchive."Doc. No. Occurrence", SalesLineArchive."Version No.");

                lCustomerReqDate := SalesLineArchive."Planned Delivery Date";
                lShipmentDate := SalesLineArchive."Shipment Date";
                lPlanShipDate := SalesLineArchive."Planned Shipment Date";
                lAssignedCSR := SalesLineArchive."Assigned CSR";
                SalesUOM := SalesLineArchive."Unit of Measure Code";
                lSOLLocationCode := SalesLineArchive."Location Code";
                lSOShipTo := SalesHeaderArchive."Ship-to Name";
                if ShipmentMethod.Get(SalesHeaderArchive."Shipment Method Code") then
                    CustomerIncoterms := ShipmentMethod.Description;
                SalesDirector := SalesLineArchive."Salesperson Name";
                RegionalManager := SalesLineArchive."Internal Team Name";
                if Salesperson.Get(SalesLineArchive."External Rep") then
                    ExternalRep := Salesperson.Name;
                SampleOrder := SalesHeaderArchive."Sample Order";

                lSellingQty := SalesLineArchive.Quantity;
                lSellingPrice := SalesLineArchive."Unit Price";
                lCustomer := SalesHeaderArchive."Sell-to Customer Name";
                lCustomerPO := SalesHeaderArchive."External Document No.";
                lTotalSell := SalesLineArchive."Line Amount";
            end;

            SalesInvLine.SetRange("Order No.", PLA."SO No.");
            SalesInvLine.SetRange("Order Line No.", PLA."SO Line No.");
            SalesInvLine.SetRange("PO No.", PLA."Document No.");
            SalesInvLine.SetRange("PO Line No.", PLA."Line No.");
            SalesInvLine.SetRange("Shipment Tracking Code", ShipmentTrackingLine."Tracking Code");
            SalesInvLine.SetRange("Shipment Tracking Line No.", ShipmentTrackingLine."Line No.");
            SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
            SalesInvLine.SetRange("No.", PLA."No.");
            if SalesInvLine.FindFirst() then begin
                SalesInvHeader.Get(SalesInvLine."Document No.");
                lSellingQty := SalesInvLine.Quantity;
                lSellingPrice := SalesInvLine."Unit Price";
                if lCustomer = '' then
                    lCustomer := SalesInvHeader."Sell-to Customer Name";
                if lCustomerPO = '' then
                    lCustomerPO := SalesInvHeader."External Document No.";
                lTotalSell := SalesInvLine."Line Amount";
                //lInvoiceNo := SalesInvLine."Document No.";
                //lInvoiceReceived := SalesInvLine."Posting Date";
                //lVendorInvoiceNo := SalesInvHeader."External Document No.";
            end;
        end;

        Clear(LotInfo);
        PurchILE.Reset();
        PurchILE.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
        PurchILE.SetRange("Document No.", PRcptLine."Document No.");
        PurchILE.SetRange("Document Type", PurchILE."Document Type"::"Purchase Receipt");
        PurchILE.SetRange("Item No.", PRcptLine."No.");
        if PRcptLine."Item Rcpt. Entry No." <> 0 then begin
            PurchILE.SetRange("Entry No.", PRcptLine."Item Rcpt. Entry No.")
        end else begin
            PurchILE.SetRange("Document Line No.", PRcptLine."Line No.");
        end;
        IF PurchILE.FindFirst() then
            repeat
                if PurchILE."Lot No." <> '' then
                    if LotInfo <> '' then
                        LotInfo += ', ' + PurchILE."Lot No."
                    else
                        LotInfo += PurchILE."Lot No.";
            until PurchILE.Next() = 0;


        ExcelBuffer.AddColumn(lPODate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lPONo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lRcptNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lRcptLineNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lShipmentStatus, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lShipTrackingNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(LotInfo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSupplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lInvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lInvoiceReceived, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lVendorInvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPurchNote, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lFactoryReadyDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lBookedDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lETD, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lATD, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        if lATD = BlankDate then
            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn(Date2DWY(lATD, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lETA, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ATAPort, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ATASterling, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPartNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lModelNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lLineType, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lItemCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchUOM, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
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
        ExcelBuffer.AddColumn(lCustomer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSOOrderNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCustomerPO, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SampleOrder, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lAssignedCSR, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesDirector, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RegionalManager, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ExternalRep, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSOLLocationCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesUOM, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSellingQty, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        // ExcelBuffer.AddColumn(lSellingCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lSellingPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lTotalSell, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCustomerReqDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lPlanShipDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lShipmentDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(lSOShipTo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CustomerIncoterms, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lForwarderName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lContainer, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lVessel, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lBLAWB, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lMBL, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lHBL, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lFCLLCL, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPortOfDispatch, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPortOfLoad, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lDeliveryLeadTime, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TotalInTransitDays, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCBM, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCTNS, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lKG, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalNetKG, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(PalletQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
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
        Clear(lModelNumber);
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
        Clear(lForwarderName);
        Clear(SampleOrder);
        Clear(lETD);
        Clear(lATD);
        Clear(ATAPort);
        Clear(ATASterling);
        Clear(TotalInTransitDays);
        Clear(TotalNetKG);
        Clear(PalletQty);
        Clear(CustomerIncoterms);
        Clear(SalesDirector);
        Clear(RegionalManager);
        Clear(ExternalRep);
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
        Clear(lLineType);
        Clear(PurchUOM);
        Clear(SalesUOM);
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

    procedure GetPurchInvLines(var TempPurchInvLine: Record "Purch. Inv. Line" temporary; PL: Record "Purchase Line"; PRL: Record "Purch. Rcpt. Line")
    var
        PurchInvLine: Record "Purch. Inv. Line";
        ValueItemLedgerEntries: Query "Value Item Ledger Entries";
    begin
        TempPurchInvLine.Reset();
        TempPurchInvLine.DeleteAll();

        if PRL.Type <> PRL.Type::Item then
            exit;

        ValueItemLedgerEntries.SetRange(Item_Ledg_Document_No, PRL."Document No.");
        ValueItemLedgerEntries.SetRange(Item_Ledg_Document_Type, Enum::"Item Ledger Document Type"::"Purchase Receipt");
        ValueItemLedgerEntries.SetRange(Item_Ledg_Document_Line_No, PRL."Line No.");
        ValueItemLedgerEntries.SetFilter(Item_Ledg_Invoice_Quantity, '<>0');
        ValueItemLedgerEntries.SetRange(Value_Entry_Type, Enum::"Cost Entry Type"::"Direct Cost");
        ValueItemLedgerEntries.SetFilter(Value_Entry_Invoiced_Qty, '<>0');
        ValueItemLedgerEntries.SetRange(Value_Entry_Doc_Type, Enum::"Item Ledger Document Type"::"Purchase Invoice");
        ValueItemLedgerEntries.Open();
        while ValueItemLedgerEntries.Read() do
            if PurchInvLine.Get(ValueItemLedgerEntries.Value_Entry_Doc_No, ValueItemLedgerEntries.Value_Entry_Doc_Line_No) then begin
                TempPurchInvLine.Init();
                TempPurchInvLine := PurchInvLine;
                if TempPurchInvLine.Insert() then;
            end;
    end;

    procedure GetPurchInvLinesArchive(var TempPurchInvLine: Record "Purch. Inv. Line" temporary; PLA: Record "Purchase Line Archive"; PRL: Record "Purch. Rcpt. Line")
    var
        PurchInvLine: Record "Purch. Inv. Line";
        ValueItemLedgerEntries: Query "Value Item Ledger Entries";
    begin
        TempPurchInvLine.Reset();
        TempPurchInvLine.DeleteAll();

        if PRL.Type <> PRL.Type::Item then
            exit;

        ValueItemLedgerEntries.SetRange(Item_Ledg_Document_No, PRL."Document No.");
        ValueItemLedgerEntries.SetRange(Item_Ledg_Document_Type, Enum::"Item Ledger Document Type"::"Purchase Receipt");
        ValueItemLedgerEntries.SetRange(Item_Ledg_Document_Line_No, PRL."Line No.");
        ValueItemLedgerEntries.SetFilter(Item_Ledg_Invoice_Quantity, '<>0');
        ValueItemLedgerEntries.SetRange(Value_Entry_Type, Enum::"Cost Entry Type"::"Direct Cost");
        ValueItemLedgerEntries.SetFilter(Value_Entry_Invoiced_Qty, '<>0');
        ValueItemLedgerEntries.SetRange(Value_Entry_Doc_Type, Enum::"Item Ledger Document Type"::"Purchase Invoice");
        ValueItemLedgerEntries.Open();
        while ValueItemLedgerEntries.Read() do
            if PurchInvLine.Get(ValueItemLedgerEntries.Value_Entry_Doc_No, ValueItemLedgerEntries.Value_Entry_Doc_Line_No) then begin
                TempPurchInvLine.Init();
                TempPurchInvLine := PurchInvLine;
                if TempPurchInvLine.Insert() then;
            end;
    end;
}

