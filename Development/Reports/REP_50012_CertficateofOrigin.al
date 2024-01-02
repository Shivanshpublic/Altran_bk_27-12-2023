REPORT 50012 "Certificate of Origin"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/Final/CertificateofOrigin.rdl';
    Caption = 'Certificate of Origin';
    EnableHyperlinks = true;
    DATASET
    {
        DATAITEM(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            COLUMN(SalesInvoiceHeaderNo; SalesInvoiceHeader."No.") { }
            column(Currency_Code; GetCurrencyCode("Currency Code"))
            {
            }
            column(CurSybl; GetCurrencySymbol())
            {

            }
            COLUMN(Payment_Terms_Code; RecPaymentTerms.Description) { }
            COLUMN(Shipment_Method_Code; ShipmentMethod.Description) { }
            COLUMN(CountryOfProvenance; "Country Of Provenance") { }
            COLUMN(CountryOfAcquisition; "Country Of Acquisition") { }
            COLUMN(CustomerPO; "External Document No.") { }
            // COLUMN(Via; Via) { }

            DATAITEM(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                COLUMN(OutPutNo; OutPutNo) { }
                DATAITEM(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    COLUMN(LocationCode; SalesInvoiceHeader."Location Code") { }
                    COLUMN(PostingDate; Format(SalesInvoiceHeader."Posting Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
                    column(DocumentDate; Format(SalesInvoiceHeader."Document Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
                    COLUMN(CompanyInfoLogo; CompanyInfo.Picture) { }
                    COLUMN(ProformaInvoiceNo; SalesInvoiceHeader."External Document No.") { }
                    COLUMN(CompanyName; CompanyInfo.Name) { }
                    COLUMN(CompanyAddress; CompanyInfo.Address) { }
                    COLUMN(CompanyAddress2; CompanyInfo."Address 2") { }
                    COLUMN(CompanyCity; AddSpaceOrComma(CompanyInfo.City, ', ') + AddSpaceOrComma(CompanyInfo.County, ', ')) { }
                    COLUMN(CompanyPhoneNo; 'Phone: ' + CompanyInfo."Phone No.")
                    {
                    }
                    COLUMN(CompanyFax; 'Fax: ' + CompanyInfo."Fax No.")
                    {
                    }
                    COLUMN(CompanyPostCode; CompanyInfo."Post Code") { }
                    COLUMN(HomePage; CompanyInfo."Home Page")
                    {
                    }
                    COLUMN(CompanyCountry; GetCountryDesc(CompanyInfo."Country/Region Code")) { }
                    COLUMN(ShiptoName; SalesInvoiceHeader."Ship-to Name") { }
                    COLUMN(ShiptoAddress; SalesInvoiceHeader."Ship-to Address") { }
                    COLUMN(ShiptoAddress2; SalesInvoiceHeader."Ship-to Address 2") { }
                    COLUMN(ShiptoCity; AddSpaceOrComma(SalesInvoiceHeader."Ship-to City", ', ') + AddSpaceOrComma(SalesInvoiceHeader."Ship-to County", ', ')) { }
                    COLUMN(ShiptoPostCode; SalesInvoiceHeader."Ship-to Post Code") { }
                    COLUMN(ShiptoCountryRegionCode; GetCountryDesc(SalesInvoiceHeader."Ship-to Country/Region Code")) { }
                    COLUMN(SelltoCustomerName; SalesInvoiceHeader."Sell-to Customer Name") { }
                    COLUMN(SelltoAddress; SalesInvoiceHeader."Sell-to Address") { }
                    COLUMN(SelltoAddress2; SalesInvoiceHeader."Sell-to Address 2") { }
                    COLUMN(SelltoPhoneNo; SalesInvoiceHeader."Sell-to Phone No.") { }
                    COLUMN(SellToCity; AddSpaceOrComma(SalesInvoiceHeader."Sell-to City", ', ') + AddSpaceOrComma(SalesInvoiceHeader."Sell-to County", ', ')) { }
                    COLUMN(SelltoPostCode; SalesInvoiceHeader."Sell-to Post Code") { }
                    COLUMN(SellToCountry; GetCountryDesc(SalesInvoiceHeader."Sell-to Country/Region Code")) { }
                    COLUMN(SelltoEMail; SalesInvoiceHeader."Sell-to E-Mail") { }

                    COLUMN(ConCustomerName; SalesInvoiceHeader."Consignee Name") { }
                    COLUMN(ConAddress; SalesInvoiceHeader."Consignee Address") { }
                    COLUMN(ConAddress2; SalesInvoiceHeader."Consignee Address 2") { }
                    COLUMN(ConPhoneNo; SalesInvoiceHeader."Sell-to Phone No.") { }
                    COLUMN(ConCity; AddSpaceOrComma(SalesInvoiceHeader."Consignee City", ', ')) { }
                    COLUMN(ConPostCode; SalesInvoiceHeader."Consignee Post Code") { }
                    COLUMN(ConCountry; GetCountryDesc(SalesInvoiceHeader."Consignee Country/Region code")) { }

                    COLUMN(BankAccountNo; CompanyInfo."Bank Account No.") { }
                    COLUMN(BankName; CompanyInfo."Bank Name") { }
                    COLUMN(BankBranchNo; CompanyInfo."Bank Branch No.") { }

                    COLUMN(TotalNetKG; TotalNetKG) { }
                    column(FooterText; StrSubstNo(FooterText, CompanyName))
                    {

                    }
                    column(UserEmail; UserEmail)
                    {

                    }
                    column(YellowColor; YellowColor)
                    {

                    }

                    DATAITEM(SalesInvoiceLine; "Sales Invoice Line")
                    {
                        DataItemLinkReference = SalesInvoiceHeader;
                        DataItemLink = "Document No." = FIELD("No.");
                        COLUMN(ItemNo; "No.") { }
                        COLUMN(Description; Description) { }
                        COLUMN(Description2; "Description 2") { }
                        COLUMN(UnitofMeasureCode; "Unit of Measure Code") { }
                        COLUMN(HSCode; "HS Code") { }
                        column(VIA; VIA)
                        {

                        }
                        COLUMN(HTSCode; "HTS Code") { }
                        COLUMN(Quantity; Quantity) { }
                        COLUMN(UnitPrice; "Unit Price") { }
                        COLUMN(ExtendedPrice; Amount) { }
                        COLUMN(Line_Amount; "Line Amount") { }
                        COLUMN(Line_Discount_Amount; "Line Discount Amount") { }
                        COLUMN(LineAmountAfterDisc; "Line Discount Amount" - "Line Amount") { }
                        COLUMN(AmountIncVAT; "Amount Including VAT") { }
                        COLUMN(NoOfPackages; "No. of Packages") { }
                        COLUMN(TotalCBM; "Total CBM") { }
                        column(Country_of_Origin; GetCountryDesc("Country of Origin"))
                        {

                        }
                        COLUMN(TotalGrossKG; "Total Gross (KG)") { }
                        trigger OnAfterGetRecord()
                        var
                            myInt: Integer;
                        begin
                            if (Quantity = 0) AND (Type <> Type::" ") then
                                CurrReport.Skip();
                        end;

                        TRIGGER OnPreDataItem()
                        BEGIN
                            NoOfRecords := SalesInvoiceLine.COUNT;
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
                    //SETRANGE(Number, 1);
                    OutPutNo := 1;
                END;

                TRIGGER OnAfterGetRecord()
                BEGIN
                    OutPutNo += 1;
                END;
            }
            TRIGGER OnAfterGetRecord()
            var
                UserSetup: Record "User Setup";
            BEGIN
                if ShipmentMethod.Get("Shipment Method Code") then;
                Clear(RecPaymentTerms);
                if RecPaymentTerms.GET("Payment Terms Code") then;
                Clear(UserSetup);
                Clear(UserEmail);
                if UserSetup.GET(UserId) then
                    UserEmail := UserSetup."E-Mail";
            END;
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
        ShipmentMethod: Record "Shipment Method";
        RecPaymentTerms: Record "Payment Terms";
        FooterText: Label 'Export Control: The goods sold by %1 may be subject to U.S. export control regulations and may not be exported, re-exported, or transferred to any country or entity subject to U.S. trade restrictions, including but not limited to Cuba, Iran, North Korea, Syria, Russia, the Crimea Region of Ukraine, and Venezuela. You agree that you will not directly or indirectly export, re-export, or transfer the goods sold by our company to any of these countries orentities, or to any person or entity known or have reason to know will use the goods in a manner that violates U.S. export control regulations. This agreement confirms goods sold by %1 will not be used in any way that violates U.S. export control regulations';
        UserEmail: Text;
        YellowColor: Boolean;
}