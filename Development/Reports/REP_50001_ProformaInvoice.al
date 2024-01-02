REPORT 50001 "Proforma Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/ProformaInvoice.rdl';
    Caption = 'Proforma Invoice';


    DATASET
    {
        DATAITEM(SalesInvoiceHeader; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            COLUMN(SalesInvoiceHeaderNo; SalesInvoiceHeader."No.") { }
            COLUMN(Shipment_Method_Code; ShipmentCode.Code) { }
            COLUMN(Payment_Terms_Code; "Payment Terms Code") { }
            DATAITEM(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                COLUMN(OutPutNo; OutPutNo) { }
                DATAITEM(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    COLUMN(LocationCode; SalesInvoiceHeader."Location Code") { }
                    COLUMN(PostingDate; SalesInvoiceHeader."Posting Date") { }
                    column(DocumentDate; Format(SalesInvoiceHeader."Document Date", 0, '<Month,2>/<Day,2>/<Year4>'))
                    {

                    }
                    COLUMN(CompanyInfoLogo; CompanyInfo.Picture) { }
                    COLUMN(ProformaInvoiceNo; SalesInvoiceHeader."External Document No.") { }
                    COLUMN(CompanyName; CompanyInfo.Name) { }
                    COLUMN(CompanyAddress; CompanyInfo.Address) { }
                    COLUMN(CompanyAddress2; CompanyInfo."Address 2") { }
                    COLUMN(CompanyCity; CompanyInfo.City) { }
                    COLUMN(CompanyPhoneNo; CompanyInfo."Phone No.") { }
                    COLUMN(CompanyPostCode; CompanyInfo."Post Code") { }
                    COLUMN(CompanyCountry; CompanyInfo."Country/Region Code") { }
                    COLUMN(ShiptoName; SalesInvoiceHeader."Ship-to Name") { }
                    COLUMN(ShiptoAddress; SalesInvoiceHeader."Ship-to Address") { }
                    COLUMN(ShiptoAddress2; SalesInvoiceHeader."Ship-to Address 2") { }
                    COLUMN(ShiptoCity; SalesInvoiceHeader."Ship-to City") { }
                    COLUMN(ShiptoPostCode; SalesInvoiceHeader."Ship-to Post Code") { }
                    COLUMN(ShiptoCountryRegionCode; SalesInvoiceHeader."Ship-to Country/Region Code") { }

                    COLUMN(SelltoCustomerName; SalesInvoiceHeader."Consignee Name") { }
                    COLUMN(SelltoAddress; SalesInvoiceHeader."Consignee Address") { }
                    COLUMN(SelltoAddress2; SalesInvoiceHeader."Consignee Address 2") { }
                    COLUMN(SelltoPhoneNo; SalesInvoiceHeader."Sell-to Phone No.") { }
                    COLUMN(SellToCity; SalesInvoiceHeader."Consignee City") { }
                    COLUMN(SelltoPostCode; SalesInvoiceHeader."Consignee Post Code") { }
                    COLUMN(SellToCountry; SalesInvoiceHeader."Consignee Country/Region code") { }

                    COLUMN(SelltoEMail; SalesInvoiceHeader."Sell-to E-Mail") { }
                    COLUMN(PaymentTermsCode; SalesInvoiceHeader."Payment Terms Code") { }
                    COLUMN(BankAccountNo; CompanyInfo."Bank Account No.") { }
                    COLUMN(BankName; CompanyInfo."Bank Name") { }
                    COLUMN(BankBranchNo; CompanyInfo."Bank Branch No.") { }
                    COLUMN(CountryOfOrigin; CountryOfOrigin) { }
                    COLUMN(CountryOfProvenance; CountryOfProvenance) { }
                    COLUMN(CountryOfAcquisition; CountryOfAcquisition) { }
                    COLUMN(NoOfPackages; NoOfPackages) { }
                    COLUMN(TotalCBM; TotalCBM) { }
                    COLUMN(TotalGrossKG; TotalGrossKG) { }
                    COLUMN(TotalNetKG; TotalNetKG) { }

                    DATAITEM(SalesInvoiceLine; "Sales Line")
                    {
                        DataItemLinkReference = SalesInvoiceHeader;
                        DataItemLink = "Document No." = FIELD("No.");
                        COLUMN(ItemNo; "No.") { }
                        COLUMN(Description; Description) { }
                        COLUMN(Description2; "Description 2") { }
                        COLUMN(UnitofMeasureCode; "Unit of Measure Code") { }
                        COLUMN(HSCode; "HS Code") { }
                        COLUMN(HTSCode; "HTS Code") { }
                        COLUMN(Quantity; Quantity) { }
                        COLUMN(UnitPrice; "Unit Price") { }
                        COLUMN(ExtendedPrice; ExtendedPrice) { }
                        COLUMN(Line_Amount; "Line Amount") { }
                        COLUMN(Line_Discount_Amount; "Line Discount Amount") { }
                        COLUMN(LineAmountAfterDisc; "Line Discount Amount" - "Line Amount") { }
                        COLUMN(Amount_Including_VAT; "Amount Including VAT") { }

                        TRIGGER OnPreDataItem()
                        BEGIN
                            NoOfRecords := SalesInvoiceLine.COUNT;
                        END;
                    }

                    DATAITEM(FixedLength; Integer)
                    {
                        DataItemLinkReference = PageLoop;
                        DataItemTableView = SORTING(Number);
                        COLUMN(FixedLinNo; FixedLength.Number) { }

                        TRIGGER OnPreDataItem()
                        BEGIN
                            //Fixed Empty blank lines for page
                            IF NoOfRecords <= 18 THEN BEGIN
                                NoOfRows := 18;
                            END
                            ELSE
                                IF (NoOfRecords > 18) AND (NoOfRecords <= 36) THEN BEGIN
                                    NoOfRows := 36;
                                END
                                ELSE
                                    IF (NoOfRecords > 36) AND (NoOfRecords <= 54) THEN BEGIN
                                        NoOfRows := 54;
                                    END;

                            FixedLength.SETRANGE(FixedLength.Number, 1, NoOfRows - NoOfRecords);
                            //Fixed Empty blank lines for page
                        END;
                    }
                }

                TRIGGER OnPreDataItem()
                BEGIN
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    IF NoOfLoops <= 1 THEN
                        NoOfLoops := 1;
                    COPYTEXT := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutPutNo := 1;
                END;

                TRIGGER OnAfterGetRecord()
                BEGIN
                    OutPutNo += 1;
                    CLEAR(ShipmentCode);
                    IF ShipmentCode.GET(SalesInvoiceHeader."Shipment Method Code") THEN;
                END;
            }
        }
    }


    REQUESTPAGE
    {
        LAYOUT
        {
            AREA(Content)
            {
                GROUP(GroupName)
                {
                }
            }
        }

        ACTIONS
        {
            AREA(processing)
            {
                ACTION(ActionName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    TRIGGER OnPreReport()
    BEGIN
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

    END;

    VAR
        CompanyInfo: Record "Company Information";
        CountryOfOrigin: Text;
        CountryOfProvenance: Text;
        CountryOfAcquisition: Text;
        NoOfPackages: Decimal;
        TotalCBM: Decimal;
        TotalGrossKG: Decimal;
        TotalNetKG: Decimal;
        HSCode: Code[20];
        ExtendedPrice: Decimal;
        OutputNo: Integer;
        NoOfLoops: Integer;
        NoOfCopies: Integer;
        NoOfRows: Integer;
        NoOfRecords: Integer;
        COPYTEXT: Text;
        ShipmentCode: Record "Shipment Method";
}