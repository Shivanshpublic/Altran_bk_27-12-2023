REPORT 50033 "Sales Order Report1"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/SalesOrderReport1.rdl';
    Caption = 'Sales Order Report';
    DATASET
    {
        DATAITEM(SalesHeader; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            COLUMN(No_; "No.")
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            column(CustReqDate; "Shipment Date")
            {
            }
            column(SalesRep; "Salesperson Code")
            {
            }
            column(SalesManager; '')
            {
            }
            column(CustPONumber; "External Document No.")
            {
            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(IncoTerms; ShipmentCode.Code)
            {
            }
            column(Quote_No_; "Quote No.")
            {
            }
            DATAITEM(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                COLUMN(OutPutNo; OutPutNo)
                {
                }
                DATAITEM(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    COLUMN(LocationCode; SalesHeader."Location Code")
                    {
                    }
                    COLUMN(PostingDate; SalesHeader."Posting Date")
                    {
                    }
                    COLUMN(CompanyInfoLogo; CompanyInfo.Picture)
                    {
                    }
                    COLUMN(ProformaInvoiceNo; SalesHeader."External Document No.")
                    {
                    }
                    COLUMN(CompanyName; CompanyInfo.Name)
                    {
                    }
                    COLUMN(CompanyAddress; CompanyInfo.Address)
                    {
                    }
                    COLUMN(CompanyAddress2; CompanyInfo."Address 2")
                    {
                    }
                    COLUMN(CompanyCity; CompanyInfo.City)
                    {
                    }
                    COLUMN(CompanyPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    COLUMN(CompanyPostCode; CompanyInfo."Post Code")
                    {
                    }
                    COLUMN(CompanyCountry; CompanyInfo."Country/Region Code")
                    {
                    }
                    COLUMN(ShiptoName; SalesHeader."Ship-to Name")
                    {
                    }
                    COLUMN(ShiptoAddress; SalesHeader."Ship-to Address")
                    {
                    }
                    COLUMN(ShiptoAddress2; SalesHeader."Ship-to Address 2")
                    {
                    }
                    COLUMN(ShiptoCity; SalesHeader."Ship-to City")
                    {
                    }
                    COLUMN(ShiptoPostCode; SalesHeader."Ship-to Post Code")
                    {
                    }
                    COLUMN(ShiptoCountryRegionCode; SalesHeader."Ship-to Country/Region Code")
                    {
                    }
                    COLUMN(SelltoCustomerName; SalesHeader."Sell-to Customer Name")
                    {
                    }
                    COLUMN(SelltoAddress; SalesHeader."Sell-to Address")
                    {
                    }
                    COLUMN(SelltoAddress2; SalesHeader."Sell-to Address 2")
                    {
                    }
                    COLUMN(SelltoPhoneNo; SalesHeader."Sell-to Phone No.")
                    {
                    }
                    COLUMN(SelltoPostCode; SalesHeader."Sell-to Post Code")
                    {
                    }
                    COLUMN(SelltoEMail; SalesHeader."Sell-to E-Mail")
                    {
                    }
                    COLUMN(PaymentTermsCode; SalesHeader."Payment Terms Code")
                    {
                    }
                    COLUMN(BankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    COLUMN(BankName; CompanyInfo."Bank Name")
                    {
                    }
                    COLUMN(BankBranchNo; CompanyInfo."Bank Branch No.")
                    {
                    }
                    COLUMN(CountryOfOrigin; CountryOfOrigin)
                    {
                    }
                    COLUMN(CountryOfProvenance; CountryOfProvenance)
                    {
                    }
                    COLUMN(CountryOfAcquisition; CountryOfAcquisition)
                    {
                    }
                    COLUMN(NoOfPackages; NoOfPackages)
                    {
                    }
                    COLUMN(TotalCBM; TotalCBM)
                    {
                    }
                    COLUMN(TotalGrossKG; TotalGrossKG)
                    {
                    }
                    COLUMN(TotalNetKG; TotalNetKG)
                    {
                    }

                    DATAITEM(SalesLine; "Sales Line")
                    {
                        DataItemLinkReference = SalesHeader;
                        DataItemLink = "Document No." = FIELD("No.");
                        COLUMN(ItemNo; "No.")
                        {
                        }
                        column(Item; "Description 2")
                        {
                        }
                        column(Ordered; '')
                        {
                        }
                        COLUMN(Description; Description)
                        {
                        }
                        COLUMN(UnitofMeasureCode; "Unit of Measure Code")
                        {
                        }
                        COLUMN(HSCode; "HS Code")
                        {
                        }
                        COLUMN(HTSCode; "HTS Code")
                        {
                        }
                        COLUMN(Quantity; Quantity)
                        {
                        }
                        COLUMN(UnitPrice; "Unit Price")
                        {
                        }
                        COLUMN(ExtendedPrice; Amount)
                        {
                        }
                        TRIGGER OnPreDataItem()
                        BEGIN
                            NoOfRecords := SalesLine.COUNT;
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
                            IF NoOfRecords <= 30 THEN BEGIN
                                NoOfRows := 30;
                            END
                            ELSE
                                IF (NoOfRecords > 30) AND (NoOfRecords <= 60) THEN BEGIN
                                    NoOfRows := 60;
                                END
                                ELSE
                                    IF (NoOfRecords > 60) AND (NoOfRecords <= 90) THEN BEGIN
                                        NoOfRows := 90;
                                    END;

                            FixedLength.SETRANGE(FixedLength.Number, 1, NoOfRows - NoOfRecords);
                            //Fixed Empty blank lines for page
                        END;
                    }
                    DATAITEM(TermCondition; Integer)
                    {
                        DataItemLinkReference = PageLoop;
                        DataItemTableView = SORTING(Number);
                        COLUMN(TermConditionLinNo; TermCondition.Number) { }

                        TRIGGER OnPreDataItem()
                        BEGIN
                            TermCondition.SETRANGE(Number, 1);
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
                    IF ShipmentCode.GET(SalesHeader."Shipment Method Code") THEN;
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