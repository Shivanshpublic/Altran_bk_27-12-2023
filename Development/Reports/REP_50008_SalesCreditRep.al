REPORT 50008 "Sales Credit Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/Final/SalesCreditMemo_Report.rdl';
    Caption = 'Sales Credit Report';
    EnableHyperlinks = true;
    DATASET
    {
        DATAITEM(SalesHeader; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            COLUMN(No_; "No.")
            {
            }
            column(Document_Date; "Due Date")
            {
            }
            column(Currency_Code; GetCurrencyCode("Currency Code"))
            {
            }
            column(CurSybl; GetCurrencySymbolL("Currency Code"))
            {

            }

            column(Applies_to_Doc__No_; "Applies-to Doc. No.")
            {
            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(CustPONumber; '')
            {
            }
            column(Project; '')
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
                    COLUMN(ShiptoName; SalesHeader."Ship-to Name")
                    {
                    }
                    COLUMN(ShiptoAddress; SalesHeader."Ship-to Address")
                    {
                    }
                    COLUMN(ShiptoAddress2; SalesHeader."Ship-to Address 2")
                    {
                    }
                    COLUMN(ShiptoCity; AddSpaceOrComma(SalesHeader."Ship-to City", ', ') + AddSpaceOrComma(SalesHeader."Ship-to County", ', '))
                    {
                    }
                    COLUMN(ShiptoPostCode; SalesHeader."Ship-to Post Code")
                    {
                    }
                    COLUMN(ShiptoCountryRegionCode; GetCountryDesc(SalesHeader."Ship-to Country/Region Code"))
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
                    COLUMN(SelltoCity; AddSpaceOrComma(SalesHeader."Sell-to City", ', ') + AddSpaceOrComma(SalesHeader."Sell-to County", ', '))
                    {
                    }
                    COLUMN(SelltoPostCode; SalesHeader."Sell-to Post Code")
                    {
                    }
                    COLUMN(SelltoCountry; GetCountryDesc(SalesHeader."Sell-to Country/Region Code"))
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
                    COLUMN(HomePage; CompanyInfo."Home Page Custom")
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
                    column(UserEmail; UserEmail)
                    {

                    }
                    column(YellowColor; YellowColor)
                    {

                    }

                    DATAITEM(SalesLine; "Sales Cr.Memo Line")
                    {
                        DataItemLinkReference = SalesHeader;
                        DataItemLink = "Document No." = FIELD("No.");
                        COLUMN(Item; "Description 2")
                        {
                        }
                        COLUMN(Description; Description)
                        {
                        }
                        COLUMN(UnitofMeasureCode; "Unit of Measure Code")
                        {
                        }
                        column(Shipment_Date; "Shipment Date")
                        {

                        }
                        COLUMN(HSCode; HSCode)
                        {
                        }
                        COLUMN(Quantity; Quantity)
                        {
                        }
                        COLUMN(UnitPrice; "Unit Price")
                        {
                        }
                        COLUMN(ExtendedPrice; "Line Amount")
                        {
                        }
                        TRIGGER OnPreDataItem()
                        BEGIN
                            NoOfRecords := SalesLine.COUNT;
                        END;

                        trigger OnAfterGetRecord()
                        begin
                            if (Quantity = 0) AND (Type <> Type::" ") then
                                CurrReport.Skip();
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