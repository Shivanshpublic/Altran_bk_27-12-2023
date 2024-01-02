REPORT 50009 "Packing List Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/Final/PackingListReport.rdl';
    Caption = 'Packing List Domestic';
    EnableHyperlinks = true;
    DATASET
    {
        DATAITEM(SalesShipmentHeader; "Sales Invoice Header")
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
            column(PONumber; '')
            {
            }
            column(CustPONumber; "External Document No.")
            {
            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(IncoTerms; ShipmentCode.Description)
            {
            }
            column(ModeOfShip; '')
            {
            }
            COLUMN(CountryOfOrigin; "Country Of Origin")
            {
            }
            COLUMN(CountryOfProvenance; "Country Of Provenance")
            {
            }
            COLUMN(CountryOfAcquisition; "Country Of Acquisition")
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
                    COLUMN(LocationCode; SalesShipmentHeader."Location Code")
                    {
                    }
                    COLUMN(PostingDate; SalesShipmentHeader."Posting Date")
                    {
                    }
                    COLUMN(CompanyInfoLogo; CompanyInfo.Picture)
                    {
                    }
                    COLUMN(ProformaInvoiceNo; SalesShipmentHeader."External Document No.")
                    {
                    }
                    COLUMN(CompanyName; CompanyInfo.Name)
                    {
                    }
                    COLUMN(CompanyAddress; CompanyInfo.Address)
                    {
                    }
                    COLUMN(CompanyAddress2; CompanyInfo."Address 2")//AddSpaceOrComma(CompanyInfo."Address 2", ', '))
                    {
                    }
                    COLUMN(CompanyCity; AddSpaceOrComma(CompanyInfo.City, ', ') + AddSpaceOrComma(CompanyInfo.County, ', '))
                    {
                    }
                    COLUMN(CompanyPhoneNo; 'Phone: ' + CompanyInfo."Phone No.")
                    {
                    }
                    COLUMN(CompanyFax; 'Fax: ' + CompanyInfo."Fax No.")
                    {
                    }
                    COLUMN(CompanyPostCode; CompanyInfo."Post Code")
                    {
                    }
                    COLUMN(CompanyCountry; GetCountryDesc(CompanyInfo."Country/Region Code"))
                    {
                    }
                    COLUMN(ShiptoName; SalesShipmentHeader."Ship-to Name")
                    {
                    }
                    COLUMN(ShiptoAddress; SalesShipmentHeader."Ship-to Address")
                    {
                    }
                    COLUMN(ShiptoAddress2; SalesShipmentHeader."Ship-to Address 2")
                    {
                    }
                    COLUMN(ShiptoCity; AddSpaceOrComma(SalesShipmentHeader."Ship-to City", ', ') + AddSpaceOrComma(SalesShipmentHeader."Ship-to County", ', '))
                    {
                    }
                    COLUMN(ShiptoPostCode; SalesShipmentHeader."Ship-to Post Code")
                    {
                    }
                    COLUMN(ShiptoCountryRegionCode; GetCountryDesc(SalesShipmentHeader."Ship-to Country/Region Code"))
                    {
                    }
                    COLUMN(SelltoCustomerName; SalesShipmentHeader."Sell-to Customer Name")
                    {
                    }
                    COLUMN(SelltoAddress; SalesShipmentHeader."Sell-to Address")
                    {
                    }
                    COLUMN(SelltoAddress2; SalesShipmentHeader."Sell-to Address 2")
                    {
                    }
                    COLUMN(SelltoPhoneNo; SalesShipmentHeader."Sell-to Phone No.")
                    {
                    }
                    COLUMN(SellToCity; AddSpaceOrComma(SalesShipmentHeader."Sell-to City", ', ') + AddSpaceOrComma(SalesShipmentHeader."Ship-to County", ', '))
                    {
                    }
                    COLUMN(SelltoPostCode; SalesShipmentHeader."Sell-to Post Code")
                    {
                    }
                    COLUMN(SellToCountry; GetCountryDesc(SalesShipmentHeader."Sell-to Country/Region Code"))
                    {
                    }
                    COLUMN(SelltoEMail; SalesShipmentHeader."Sell-to E-Mail")
                    {
                    }
                    COLUMN(PaymentTermsCode; RecPaymentTerms.Description)
                    {
                    }
                    COLUMN(BankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    COLUMN(BankName; CompanyInfo."Bank Name")
                    {
                    }
                    COLUMN(HomePage; CompanyInfo."Home Page")
                    {
                    }

                    COLUMN(BankBranchNo; CompanyInfo."Bank Branch No.")
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
                    column(FooterText; StrSubstNo(FooterText, CompanyName))
                    {

                    }
                    column(UserEmail; 'email: ' + UserEmail)
                    {

                    }
                    column(YellowColor; YellowColor)
                    {

                    }

                    DATAITEM(SalesShipmentLine; "Sales Invoice Line")
                    {
                        DataItemLinkReference = SalesShipmentHeader;
                        DataItemLink = "Document No." = FIELD("No.");
                        COLUMN(Type; Type)
                        {
                        }

                        COLUMN(ItemNo; "No.")
                        {
                        }
                        column(Item; "Description 2")
                        {
                        }
                        COLUMN(Description; Description)
                        {
                        }
                        column(Item_Reference_No_; "Item Reference No.")
                        {

                        }
                        column(VIA; VIA)
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
                        column(ordered; '')
                        {
                        }
                        COLUMN(PalletQuantity; "Pallet Quantity")
                        {
                        }
                        COLUMN(NoOfPackages; "No. of Packages")
                        {
                        }
                        COLUMN(Quantity; Quantity)
                        {
                        }
                        COLUMN(ShipMethod; VIA)
                        {
                        }
                        COLUMN(UnitPrice; "Unit Price")
                        {
                        }
                        COLUMN(ExtendedPrice; SalesShipmentLine."VAT Base Amount")
                        {
                        }
                        column(Country_of_Origin; "Country of Origin")
                        {

                        }
                        column(Total_CBM; "Total CBM")
                        {

                        }

                        TRIGGER OnPreDataItem()
                        BEGIN
                            NoOfRecords := SalesShipmentLine.COUNT;
                        END;

                        trigger OnAfterGetRecord()
                        begin
                            // if (TotalCBM = 0) AND (Type <> Type::" ") then
                            //     CurrReport.Skip();
                            if Quantity = 0 then begin
                                "No. of Packages" := 0;
                                "Gross Weight" := 0;
                                "Net Weight" := 0;
                                "Total CBM" := 0;
                                "HTS Code" := '';
                                "Pallet Quantity" := 0;
                            end;
                        end;
                    }

                    /*DATAITEM(FixedLength; Integer)
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
                    }*/
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
                var
                    UserSetup: Record "User Setup";
                BEGIN
                    OutPutNo += 1;
                    CLEAR(ShipmentCode);
                    IF ShipmentCode.GET(SalesShipmentHeader."Shipment Method Code") THEN;
                    Clear(RecPaymentTerms);
                    if RecPaymentTerms.GET(SalesShipmentHeader."Payment Terms Code") then;
                    Clear(UserSetup);
                    Clear(UserEmail);
                    if UserSetup.GET(UserId) then
                        UserEmail := UserSetup."E-Mail";
                END;
            }
        }
    }




    TRIGGER OnPreReport()
    BEGIN
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        if CompanyName.Contains('Altran') then
            YellowColor := true
        else
            YellowColor := false;
    END;

    procedure GetCurrencySymbolL(CurrCode: Code[10]): Text[10]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        Currency: Record Currency;
    begin
        if GeneralLedgerSetup.Get() then
            if (CurrCode = '') or (CurrCode = GeneralLedgerSetup."LCY Code") then
                exit(GeneralLedgerSetup.GetCurrencySymbol());

        if Currency.Get(CurrCode) then
            exit(Currency.GetCurrencySymbol());

        exit(CurrCode);
    end;

    local procedure GetCountryDesc(CountryCode: code[20]): Text[100]
    var
        RecCountry: Record "Country/Region";
    begin
        if CountryCode <> '' then begin
            RecCountry.GET(CountryCode);
            exit(RecCountry.Name);
        end else
            exit('');
    end;

    local procedure AddSpaceOrComma(AddressText: Text; AppendText: Text): Text
    begin
        if AddressText <> '' then
            exit(AddressText + AppendText)
        else
            exit(AddressText);
    end;

    local procedure GetCurrencyCode(currcode: code[10]): Code[10]
    var
        GenLedSetup: Record "General Ledger Setup";
    begin
        if currcode <> '' then
            exit(currcode)
        else begin
            GenLedSetup.GET;
            exit(GenLedSetup."LCY Code");
        end;
    end;

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
        RecPaymentTerms: Record "Payment Terms";
        FooterText: Label 'Cancellation Policy: Customer reserves the right to cancel an order within five (5) business days from the date of acknowledgement by [%1], If you wish to cancel an order, written notification must be received to the contact information below within the five-day period. Order cancellation request received outside of this period will be considered invalid. If the order is cancelled within this period, any payment received by [%1] will be refunded within thirty (30) days.';
        UserEmail: Text;
        YellowColor: Boolean;
}