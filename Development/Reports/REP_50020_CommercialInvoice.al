REPORT 50020 "Commercial Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/Final/CommercialInv.rdl';
    Caption = 'Commercial Invoice';
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
            COLUMN(CountryOfOrigin; "Country of Origin") { }
            COLUMN(CountryOfProvenance; "Country Of Provenance") { }
            COLUMN(CountryOfAcquisition; "Country Of Acquisition") { }
            COLUMN(CustomerPO; "External Document No.") { }
            COLUMN(Via; Via) { }

            DATAITEM(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                COLUMN(OutPutNo; OutPutNo) { }
                DATAITEM(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    COLUMN(LocationCode; SalesInvoiceHeader."Location Code") { }
                    COLUMN(PostingDate; SalesInvoiceHeader."Posting Date") { }
                    column(DocumentDate; Format(SalesInvoiceHeader."Posting Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
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
                    COLUMN(HomePage; CompanyInfo."Home Page Custom")
                    {
                    }
                    COLUMN(CompanyCountry; GetCountryDesc(CompanyInfo."Country/Region Code")) { }
                    COLUMN(ShiptoName; SalesInvoiceHeader."Ship-to Name") { }
                    COLUMN(ShiptoAddress; SalesInvoiceHeader."Ship-to Address") { }
                    COLUMN(ShiptoAddress2; SalesInvoiceHeader."Ship-to Address 2") { }
                    COLUMN(ShiptoCity; AddSpaceOrComma(SalesInvoiceHeader."Ship-to City", ', ') + AddSpaceOrComma(SalesInvoiceHeader."Ship-to County", ', ')) { }
                    COLUMN(ShiptoPostCode; SalesInvoiceHeader."Ship-to Post Code") { }
                    COLUMN(ShiptoCountryRegionCode; GetCountryDesc(SalesInvoiceHeader."Ship-to Country/Region Code")) { }
                    COLUMN(ShiptoContact; ShiptoContact) { }
                    COLUMN(ShiptoMobileNo; ShiptoContactNo) { }
                    COLUMN(SelltoCustomerName; SalesInvoiceHeader."Sell-to Customer Name") { }
                    COLUMN(SelltoAddress; SalesInvoiceHeader."Sell-to Address") { }
                    COLUMN(SelltoAddress2; SalesInvoiceHeader."Sell-to Address 2") { }
                    COLUMN(SelltoPhoneNo; SalesInvoiceHeader."Sell-to Phone No.") { }
                    COLUMN(SellToCity; AddSpaceOrComma(SalesInvoiceHeader."Sell-to City", ', ') + AddSpaceOrComma(SalesInvoiceHeader."Sell-to County", ', ')) { }
                    COLUMN(SelltoPostCode; SalesInvoiceHeader."Sell-to Post Code") { }
                    COLUMN(SellToCountry; GetCountryDesc(SalesInvoiceHeader."Sell-to Country/Region Code")) { }
                    COLUMN(SelltoEMail; SalesInvoiceHeader."Sell-to E-Mail") { }

                    COLUMN(ConCustomerName; ConCustomerName) { }
                    COLUMN(ConAddress; ConAddress) { }
                    COLUMN(ConAddress2; ConAddress2) { }
                    COLUMN(ConPhoneNo; ConPhoneNo) { }
                    COLUMN(ConCity; ConCity) { }
                    COLUMN(ConPostCode; ConPostCode) { }
                    COLUMN(ConCountry; ConCountry) { }
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
                        DataItemTableView = SORTING("No.") WHERE("Parent Line No." = FILTER(= 0));
                        COLUMN(ItemNo; "No.") { }
                        COLUMN(ItemReferenceNo; "Item Reference No.") { }
                        COLUMN(Description; Description) { }
                        COLUMN(Description2; "Description 2") { }
                        COLUMN(UnitofMeasureCode; "Unit of Measure Code") { }
                        COLUMN(HSCode; "HS Code") { }
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
                        COLUMN(TotalGrossKG; "Total Gross (KG)") { }

                        TRIGGER OnPreDataItem()
                        BEGIN
                            NoOfRecords := SalesInvoiceLine.COUNT;
                        END;

                        trigger OnAfterGetRecord()
                        begin
                            if (Quantity = 0) AND (Type <> Type::" ") then
                                CurrReport.Skip();
                        end;
                    }
                    DATAITEM(ParentSalesInvoiceLine; "Sales Invoice Line")
                    {
                        DataItemLinkReference = SalesInvoiceHeader;
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemTableView = SORTING("No.") WHERE("Parent Line No." = FILTER(<> 0));
                        COLUMN(PItemNo; "No.") { }
                        COLUMN(PItemReferenceNo; "Item Reference No.") { }
                        COLUMN(PDescription; Description) { }
                        COLUMN(PDescription2; "Description 2") { }
                        COLUMN(PUnitofMeasureCode; "Unit of Measure Code") { }
                        COLUMN(PHSCode; "HS Code") { }
                        COLUMN(PHTSCode; "HTS Code") { }
                        COLUMN(PQuantity; Quantity) { }
                        COLUMN(PUnitPrice; "Unit Price") { }
                        COLUMN(PExtendedPrice; Amount) { }
                        COLUMN(PLine_Amount; "Line Amount") { }
                        COLUMN(PLine_Discount_Amount; "Line Discount Amount") { }
                        COLUMN(PLineAmountAfterDisc; "Line Discount Amount" - "Line Amount") { }
                        COLUMN(PAmountIncVAT; "Amount Including VAT") { }
                        COLUMN(PPNoOfPackages; "No. of Packages") { }
                        COLUMN(PTotalCBM; "Total CBM") { }
                        COLUMN(PTotalGrossKG; "Total Gross (KG)") { }

                        TRIGGER OnPreDataItem()
                        BEGIN
                            NoOfRecords := SalesInvoiceLine.COUNT;
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
                            IF NoOfRecords <= 14 THEN BEGIN
                                NoOfRows := 14;
                            END
                            ELSE
                                IF (NoOfRecords > 14) AND (NoOfRecords <= 28) THEN BEGIN
                                    NoOfRows := 28;
                                END
                                ELSE
                                    IF (NoOfRecords > 28) AND (NoOfRecords <= 42) THEN BEGIN
                                        NoOfRows := 42;
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
                    //SETRANGE(Number, 1);
                    OutPutNo := 1;
                END;

                TRIGGER OnAfterGetRecord()
                BEGIN
                    OutPutNo += 1;

                    if SalesInvoiceHeader."Consignee No." <> '' then begin
                        ConCustomerName := SalesInvoiceHeader."Consignee Name";
                        ConAddress := SalesInvoiceHeader."Consignee Address";
                        ConAddress2 := SalesInvoiceHeader."Consignee Address 2";
                        ConPhoneNo := SalesInvoiceHeader."Sell-to Phone No.";
                        ConCity := AddSpaceOrComma(SalesInvoiceHeader."Consignee City", ', ');
                        ConPostCode := SalesInvoiceHeader."Consignee Post Code";
                        ConCountry := GetCountryDesc(SalesInvoiceHeader."Consignee Country/Region code");
                    end else begin
                        ConCustomerName := SalesInvoiceHeader."Bill-to Name";
                        ConAddress := SalesInvoiceHeader."Bill-to Address";
                        ConAddress2 := SalesInvoiceHeader."Bill-to Address 2";
                        ConPhoneNo := SalesInvoiceHeader."Bill-to Contact No.";
                        ConCity := AddSpaceOrComma(SalesInvoiceHeader."Bill-to City", ', ');
                        ConPostCode := SalesInvoiceHeader."Bill-to Post Code";
                        ConCountry := GetCountryDesc(SalesInvoiceHeader."Bill-to Country/Region Code");
                    end;
                    if Contact.Get(SalesInvoiceHeader."Sell-to Contact No.") then
                        ShipToContact := Contact.Name;
                    ShipToContactNo := SalesInvoiceHeader."Sell-to Phone No.";
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
        ShipmentMethod: Record "Shipment Method";
        RecPaymentTerms: Record "Payment Terms";
        FooterText: Label 'Export Control: The goods sold by %1 may be subject to U.S. export control regulations and may not be exported, re-exported, or transferred to any country or entity subject to U.S. trade restrictions, including but not limited to Cuba, Iran, North Korea, Syria, Russia, the Crimea Region of Ukraine, and Venezuela. You agree that you will not directly or indirectly export, re-export, or transfer the goods sold by our company to any of these countries orentities, or to any person or entity known or have reason to know will use the goods in a manner that violates U.S. export control regulations. This agreement confirms goods sold by %1 will not be used in any way that violates U.S. export control regulations';
        UserEmail: Text;
        YellowColor: Boolean;

        ConCustomerName: Text[100];
        ConAddress: Text[100];
        ConAddress2: Text[50];
        ConPhoneNo: Text[30];
        ConCity: Text[100];
        ConPostCode: Code[20];
        ConCountry: Code[100];
        ShipToAdd: Record "Ship-to Address";
        ShipToContact: Text[100];
        ShipToContactNo: Text[30];
        Contact: Record Contact;
}