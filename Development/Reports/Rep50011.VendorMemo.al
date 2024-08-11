REPORT 50011 "Vendor Memo Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/endorMemoReport.rdl';
    Caption = 'Vendor Memo Report';
    DATASET
    {
        DATAITEM(PurchCrMemoHdr; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            COLUMN(No_; "No.")
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(SaleOrderNo; '')
            {
            }
            column(Currency_Code; "Currency Code")
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
                    COLUMN(LocationCode; PurchCrMemoHdr."Location Code")
                    {
                    }
                    COLUMN(PostingDate; PurchCrMemoHdr."Posting Date")
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
                    COLUMN(ShiptoName; PurchCrMemoHdr."Ship-to Name")
                    {
                    }
                    COLUMN(ShiptoAddress; PurchCrMemoHdr."Ship-to Address")
                    {
                    }
                    COLUMN(ShiptoAddress2; PurchCrMemoHdr."Ship-to Address 2")
                    {
                    }
                    COLUMN(ShiptoCity; PurchCrMemoHdr."Ship-to City")
                    {
                    }
                    COLUMN(ShiptoPostCode; PurchCrMemoHdr."Ship-to Post Code")
                    {
                    }
                    COLUMN(ShiptoCountryRegionCode; PurchCrMemoHdr."Ship-to Country/Region Code")
                    {
                    }
                    COLUMN(BuyFromVendorName; PurchCrMemoHdr."Buy-from Vendor Name")
                    {
                    }
                    COLUMN(BuyFromAddress; PurchCrMemoHdr."Buy-from Address")
                    {
                    }
                    COLUMN(BuyFromAddress2; PurchCrMemoHdr."Buy-from Address 2")
                    {
                    }
                    COLUMN(BuyFromPhoneNo; PurchCrMemoHdr."Buy-from Contact No.")
                    {
                    }
                    COLUMN(BuyFromPostCode; PurchCrMemoHdr."Buy-from Post Code")
                    {
                    }
                    COLUMN(PaymentTermsCode; PurchCrMemoHdr."Payment Terms Code")
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

                    DATAITEM(PurchCrMemoLine; "Purch. Cr. Memo Line")
                    {
                        DataItemLinkReference = PurchCrMemoHdr;
                        DataItemLink = "Document No." = FIELD("No.");
                        COLUMN(ItemNo; "No.")
                        {
                        }
                        column(Item; '')
                        {
                        }
                        column(ShippingMethod; '')
                        {
                        }
                        column(DrawingRev; '')
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
                            NoOfRecords := PurchCrMemoLine.COUNT;
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
}