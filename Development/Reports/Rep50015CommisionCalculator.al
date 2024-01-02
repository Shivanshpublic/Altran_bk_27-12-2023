report 50015 "Commision Calculator Report"
{

    ProcessingOnly = true;
    Caption = 'Commision Calculation Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            RequestFilterFields = Type, "No.", "Sell-to Customer No.";
            trigger OnPreDataItem()
            begin
                IF (StartingDate <> 0D) AND (EndingDate <> 0D) then
                    SetRange("Posting Date", StartingDate, EndingDate);
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
        SalesInvHeader: Record "Sales Invoice Header";
        PurchaseLine: Record "Purchase Line";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Item: Record Item;
        Customer: Record Customer;
        SalespersonCommision: Record "Salesperson Commission";
        ExcelBuffer: Record "Excel Buffer" temporary;
        StartingDate: Date;
        EndingDate: Date;
        lDate: Date;
        lCustomer: Code[20];
        lSalesperson: Code[20];
        lInvoiceNo: Code[20];
        lPaymentStatus: Code[10];
        lProductCategory: Code[20];
        lPartNumber: Code[20];
        lVendorCost: Decimal;
        lLCTariff: Decimal;
        lLCDuties: Decimal;
        lLCShipping: Decimal;
        lLandedCostPerUnit: Decimal;
        lTotalLandedCost: Decimal;
        lRevSellingPrice: Decimal;
        lRevTariff: Decimal;
        lRevShipping: Decimal;
        lTotalPieces: Decimal;
        lTotalSalesAmt: Decimal;
        lCommissionable: Decimal;
        lMarginPct: Decimal;
        lCommissionPct: Decimal;
        lCommissionAmt: Decimal;
        lCommissionPct1: Decimal;
        lCommissionAmt1: Decimal;
        lCustomerName: Text[100];
        lDescriptionC: Text[100];
        lExternalRep: Text[100];
        lDescriptionE: Text[100];
        lTeamNameDesc: Text[100];
        lExternalDocNo: Text[35];
        lPaymentNo: Text[200];
        lPaymentDate: Text[200];

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
        ExcelBuffer.AddColumn('Commission Calculator', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Landing Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revenue For GM%', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Salesperson', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description (c)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('External Rep', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description (E)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Team Name (desc)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('External Document No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Payment No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Payment Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Paid/Unpaid', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Product Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Part Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Tariff', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Duties', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipping', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Landed Cost per Unit', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Landed Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sell Price', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Tariffs', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipping', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Pieces', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Sales Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Commisionable', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Margin %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Commision %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Commision', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SM Commision %', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SM Commision', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure ExporttoExcel()
    var
        DetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        i: Integer;
        ExternalRep: Record "Salesperson/Purchaser";
        SalesPerson: Record "Salesperson/Purchaser";
    begin
        ExcelBuffer.NewRow;
        ClearVariable;
        SalesInvHeader.Get("Sales Invoice Line"."Document No.");
        lDate := "Sales Invoice Line"."Posting Date";
        lCustomer := "Sales Invoice Line"."Sell-to Customer No.";
        lInvoiceNo := "Sales Invoice Line"."Document No.";
        lSalesperson := SalesInvHeader."Salesperson Code";
        lCustomerName := SalesInvHeader."Sell-to Customer Name";
        lExternalDocNo := SalesInvHeader."External Document No.";
        lExternalRep := SalesInvHeader."External Rep";
        if SalesPerson.Get(SalesInvHeader."Internal Team") then
            lTeamNameDesc := SalesPerson.Name;
        if SalesPerson.Get(SalesInvHeader."Salesperson Code") then
            lDescriptionC := SalesPerson.Name;
        if SalesPerson.Get(SalesInvHeader."External Rep") then
            lDescriptionE := SalesPerson.Name;

        if CustLedgEntry.Get(SalesInvHeader."Cust. Ledger Entry No.") then begin
            CustLedgEntry.CalcFields("Remaining Amount");
            if CustLedgEntry."Remaining Amount" <> 0 then
                lPaymentStatus := 'UnPaid'
            else begin
                lPaymentStatus := 'Paid';
                DetCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.");
                DetCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                DetCustLedgEntry.SetRange("Document Type", DetCustLedgEntry."Document Type"::Payment);
                if DetCustLedgEntry.FindFirst() then
                    repeat
                        if i = 0 then begin
                            lPaymentNo := lPaymentNo + DetCustLedgEntry."Document No.";
                            lPaymentDate := lPaymentDate + FORMAT(DetCustLedgEntry."Posting Date");
                        end else begin
                            lPaymentNo := lPaymentNo + '| ' + DetCustLedgEntry."Document No.";
                            lPaymentDate := lPaymentDate + '| ' + FORMAT(DetCustLedgEntry."Posting Date");
                        end;
                        i += 1;
                    until DetCustLedgEntry.Next() = 0;
                DetCustLedgEntry.SetRange("Document Type", DetCustLedgEntry."Document Type"::"Credit Memo");
                if DetCustLedgEntry.FindFirst() then begin
                    lPaymentStatus := 'Returned'
                end;
            end;
        end;

        if Item.Get("Sales Invoice Line"."No.") then begin
            lProductCategory := "Sales Invoice Line"."Item Category Code";
            lPartNumber := "Sales Invoice Line"."No.";
        end;

        if PurchaseLine.Get(PurchaseLine."Document Type"::Order, "Sales Invoice Line"."PO No.", "Sales Invoice Line"."PO Line No.") then begin
            lVendorCost := PurchaseLine.Amount;
        end;

        //lLCTariff := ;
        //lLCDuties := ;
        //lLCShipping := ;
        ValueEntry.Reset();
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        ValueEntry.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
        if ValueEntry.FindSet() then begin
            repeat
                ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.");
                ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                lTotalLandedCost += ItemLedgerEntry."Cost Amount (Actual)";
            until ValueEntry.Next() = 0;
        end;
        lTotalLandedCost := -1 * lTotalLandedCost;
        if "Sales Invoice Line".Quantity <> 0 then
            lLandedCostPerUnit := lTotalLandedCost / "Sales Invoice Line".Quantity;
        if SalesInvHeader."Currency Factor" <> 0 then
            lRevSellingPrice := "Sales Invoice Line"."Unit Price" * SalesInvHeader."Currency Factor"
        else
            lRevSellingPrice := "Sales Invoice Line"."Unit Price" * 1;
        //lRevTariff := ;
        //lRevShipping := ;
        lTotalPieces := "Sales Invoice Line".Quantity;
        lTotalSalesAmt := lTotalPieces * lRevSellingPrice;
        lCommissionable := ((lRevSellingPrice + lRevTariff) - lLandedCostPerUnit) * lTotalPieces;
        if lTotalSalesAmt <> 0 then
            lMarginPct := ((lTotalSalesAmt - lTotalLandedCost) / lTotalSalesAmt) * 100;

        SalespersonCommision.Reset;
        SalespersonCommision.SetRange(Code, SalesInvHeader."Salesperson Code");
        SalespersonCommision.SetRange(Type, SalespersonCommision.Type::Item);
        SalespersonCommision.SetRange(Code, lPartNumber);
        SalespersonCommision.SetFilter("From Date", '<=%1', "Sales Invoice Line"."Posting Date");
        SalespersonCommision.SetFilter("To Date", '>=%1', "Sales Invoice Line"."Posting Date");
        SalespersonCommision.SetFilter("From Margin %", '<=%1', lMarginPct);
        SalespersonCommision.SetFilter("To Margin %", '>=%1', lMarginPct);
        if SalespersonCommision.FindFirst() then
            lCommissionPct := SalespersonCommision."Commission %"
        else begin
            SalespersonCommision.SetRange(Type, SalespersonCommision.Type::"Item Category");
            SalespersonCommision.SetRange(Code, lProductCategory);
            if SalespersonCommision.FindFirst() then
                lCommissionPct := SalespersonCommision."Commission %"
            else begin
                SalespersonCommision.SetRange(Type, SalespersonCommision.Type::All);
                SalespersonCommision.SetRange(Code);
                if SalespersonCommision.FindFirst() then
                    lCommissionPct := SalespersonCommision."Commission %"
            end;
        end;

        lCommissionAmt := (lCommissionable * lCommissionPct) / 100;

        SalespersonCommision.Reset;
        SalespersonCommision.SetRange(Code, SalesInvHeader."Internal Team");
        SalespersonCommision.SetRange(Type, SalespersonCommision.Type::Item);
        SalespersonCommision.SetRange(Code, lPartNumber);
        SalespersonCommision.SetFilter("From Date", '<=%1', "Sales Invoice Line"."Posting Date");
        SalespersonCommision.SetFilter("To Date", '>=%1', "Sales Invoice Line"."Posting Date");
        SalespersonCommision.SetFilter("From Margin %", '<=%1', lMarginPct);
        SalespersonCommision.SetFilter("To Margin %", '>=%1', lMarginPct);
        if SalespersonCommision.FindFirst() then
            lCommissionPct1 := SalespersonCommision."Commission %"
        else begin
            SalespersonCommision.SetRange(Type, SalespersonCommision.Type::"Item Category");
            SalespersonCommision.SetRange(Code, lProductCategory);
            if SalespersonCommision.FindFirst() then
                lCommissionPct1 := SalespersonCommision."Commission %"
            else begin
                SalespersonCommision.SetRange(Type, SalespersonCommision.Type::All);
                SalespersonCommision.SetRange(Code);
                if SalespersonCommision.FindFirst() then
                    lCommissionPct1 := SalespersonCommision."Commission %"
            end;
        end;

        lCommissionAmt1 := (lCommissionable * lCommissionPct1) / 100;

        ExcelBuffer.AddColumn(lDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCustomer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lCustomerName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lSalesperson, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lDescriptionC, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lExternalRep, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lDescriptionE, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lTeamNameDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lExternalDocNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lInvoiceNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPaymentNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPaymentDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPaymentStatus, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lProductCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lPartNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lVendorCost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lLCTariff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lLCDuties, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lLCShipping, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(lLandedCostPerUnit, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lTotalLandedCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lRevSellingPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lRevTariff, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lRevShipping, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lTotalPieces, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lTotalSalesAmt, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCommissionable, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lMarginPct, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCommissionPct, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCommissionAmt, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCommissionPct1, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(lCommissionAmt1, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure ClearVariable()
    begin
        Clear(lDate);
        Clear(lCustomer);
        Clear(lSalesperson);
        Clear(lInvoiceNo);
        Clear(lPaymentStatus);
        Clear(lProductCategory);
        Clear(lPartNumber);
        Clear(lVendorCost);
        Clear(lLCTariff);
        Clear(lLCDuties);
        Clear(lLCShipping);
        Clear(lLandedCostPerUnit);
        Clear(lTotalLandedCost);
        Clear(lRevSellingPrice);
        Clear(lRevTariff);
        Clear(lRevShipping);
        Clear(lTotalPieces);
        Clear(lTotalSalesAmt);
        Clear(lCommissionable);
        Clear(lMarginPct);
        Clear(lCommissionPct);
        Clear(lCommissionAmt);
        Clear(lCommissionPct1);
        Clear(lCommissionAmt1);
        Clear(lCustomerName);
        Clear(lDescriptionC);
        Clear(lExternalRep);
        Clear(lDescriptionE);
        Clear(lTeamNameDesc);
        Clear(lExternalDocNo);
        Clear(lPaymentNo);
        Clear(lPaymentDate);
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

