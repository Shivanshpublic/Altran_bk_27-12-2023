REPORT 50005 "Purchase Invoice Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/PurchaseInvReport.rdl';
    Caption = 'Purchase Invoice Report';
    DATASET
    {
        DATAITEM(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            COLUMN(No_; "No.")
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(SalesRep; '')
            {
            }
            column(SalesManager; '')
            {
            }
            column(PONumber; '')
            {
            }
            column(CustPONumber; '')
            {
            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(IncoTerms; ShipmentCode.Code)
            {
            }
            column(SONo; '')
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
                    COLUMN(LocationCode; PurchaseHeader."Location Code")
                    {
                    }
                    COLUMN(PostingDate; PurchaseHeader."Posting Date")
                    {
                    }
                    COLUMN(CompanyInfoLogo; CompanyInfo.Picture)
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
                    COLUMN(ShiptoName; PurchaseHeader."Ship-to Name")
                    {
                    }
                    COLUMN(ShiptoAddress; PurchaseHeader."Ship-to Address")
                    {
                    }
                    COLUMN(ShiptoAddress2; PurchaseHeader."Ship-to Address 2")
                    {
                    }
                    COLUMN(ShiptoCity; PurchaseHeader."Ship-to City")
                    {
                    }
                    COLUMN(ShiptoPostCode; PurchaseHeader."Ship-to Post Code")
                    {
                    }
                    COLUMN(ShiptoCountryRegionCode; PurchaseHeader."Ship-to Country/Region Code")
                    {
                    }
                    COLUMN(BuyFromVendorName; PurchaseHeader."Buy-from Vendor Name")
                    {
                    }
                    COLUMN(BuyFromAddress; PurchaseHeader."Buy-from Address")
                    {
                    }
                    COLUMN(BuyFromAddress2; PurchaseHeader."Buy-from Address 2")
                    {
                    }
                    COLUMN(BuyFromPhoneNo; PurchaseHeader."Buy-from Contact No.")
                    {
                    }
                    COLUMN(BuyFromPostCode; PurchaseHeader."Buy-from Post Code")
                    {
                    }
                    COLUMN(PaymentTermsCode; PurchaseHeader."Payment Terms Code")
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

                    DATAITEM(PurchaseLine; "Purchase Line")
                    {
                        DataItemLinkReference = PurchaseHeader;
                        DataItemLink = "Document No." = FIELD("No.");
                        COLUMN(ItemNo; "No.")
                        {
                        }
                        column(Item; '')
                        {
                        }
                        COLUMN(Description; Description)
                        {
                        }
                        COLUMN(UnitofMeasureCode; "Unit of Measure Code")
                        {
                        }
                        COLUMN(HSCode; HSCode)
                        {
                        }
                        COLUMN(Quantity; Quantity)
                        {
                        }
                        COLUMN(UnitPrice; "Direct Unit Cost")
                        {
                        }
                        COLUMN(ExtendedPrice; Amount)
                        {
                        }
                        TRIGGER OnPreDataItem()
                        BEGIN
                            NoOfRecords := PurchaseLine.COUNT;
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
                    IF ShipmentCode.GET(PurchaseHeader."Shipment Method Code") THEN;
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