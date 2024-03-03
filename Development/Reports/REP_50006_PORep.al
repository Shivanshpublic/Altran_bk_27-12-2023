REPORT 50006 "Purchase Order Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/Final/PurchaseOrder_Report.rdl';
    Caption = 'Purchase Order Report';
    EnableHyperlinks = true;
    DATASET
    {
        DATAITEM(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            COLUMN(No_; "No.")
            {
            }

            column(DocumentDate; Format(PurchaseHeader."Posting Date", 0, '<Month,2>/<Day,2>/<Year4>'))
            {
            }
            column(SaleOrderNo; '')
            {
            }
            column(Requested_Receipt_Date; Format(PurchaseHeader."Expected Receipt Date", 0, '<Month,2>/<Day,2>/<Year4>'))
            {
            }
            column(Currency_Code; GetCurrencyCode("Currency Code"))
            {
            }
            column(CurSybl; GetCurrencySymbolL("Currency Code"))
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
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
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
                    column(CompanyHomePage; CompanyInfo."Home Page")
                    {
                    }
                    COLUMN(ShiptoName; ShiptoName)
                    {
                    }
                    COLUMN(ShiptoAddress; ShiptoAddress)
                    {
                    }
                    COLUMN(ShiptoAddress2; ShiptoAddress2)
                    {
                    }
                    COLUMN(ShiptoCity; ShiptoCity)
                    {
                    }
                    COLUMN(ShiptoPostCode; ShiptoPostCode)
                    {
                    }
                    COLUMN(ShiptoCountryRegionCode; ShiptoCountryRegionCode)
                    {
                    }
                    column(ShipToPhone; ShipToPhone)
                    {

                    }
                    column(ShipToFax; ShipToFax)
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
                    COLUMN(BuyFromPhoneNo; 'Phone No.:' + PurchaseHeader."Buy-from Contact No.")
                    {
                    }
                    column(BuyFromCity; AddSpaceOrComma(PurchaseHeader."Buy-From City", ', ') + AddSpaceOrComma(PurchaseHeader."Buy-from County", ', '))
                    {

                    }
                    column(ByFromCOuntry; GetCountryDesc(PurchaseHeader."Buy-from Country/Region Code"))
                    {

                    }
                    COLUMN(BuyFromPostCode; PurchaseHeader."Buy-from Post Code")
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
                        column(Description2; "Description 2")
                        {
                        }
                        column(ShippingMethod; VIA)
                        {
                        }
                        column(DrawingRev; '')
                        {
                        }
                        column(VIA; VIA)
                        {

                        }
                        column(Rev_; "Rev.")
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
                    Clear(RecPaymentTerms);
                    if RecPaymentTerms.GET(PurchaseHeader."Payment Terms Code") then;
                    Clear(ShipmentMethod);
                    if ShipmentMethod.Get(PurchaseHeader."Shipment Method Code") then;
                    Clear(UserSetup);
                    Clear(UserEmail);
                    if UserSetup.GET(UserId) then
                        UserEmail := UserSetup."E-Mail";
                    if PurchaseHeader."Ship-to Name" = '' then begin
                        ShiptoName := CompanyInfo.Name;
                        ShiptoAddress := CompanyInfo.Address;
                        ShiptoAddress2 := CompanyInfo."Address 2";
                        ShiptoCity := AddSpaceOrComma(CompanyInfo.City, ', ') + AddSpaceOrComma(CompanyInfo.County, ', ');
                        ShiptoPostCode := CompanyInfo."Post Code";
                        ShiptoCountryRegionCode := GetCountryDesc(CompanyInfo."Country/Region Code");
                        ShipToPhone := 'Phone: ' + CompanyInfo."Phone No.";
                        ShipToFax := 'Fax: ' + CompanyInfo."Fax No.";
                    end else begin
                        ShiptoName := PurchaseHeader."Ship-to Name";
                        ShiptoAddress := PurchaseHeader."Ship-to Address";
                        ShiptoAddress2 := PurchaseHeader."Ship-to Address 2";
                        ShiptoCity := AddSpaceOrComma(PurchaseHeader."Ship-to City", ', ') + AddSpaceOrComma(PurchaseHeader."Ship-to County", ', ');
                        ShiptoPostCode := PurchaseHeader."Ship-to Post Code";
                        ShiptoCountryRegionCode := GetCountryDesc(PurchaseHeader."Ship-to Country/Region Code");
                        //ShipToPhone := 'Phone: ' + PurchaseHeader.contact."Phone No.";
                    end;

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
        ShiptoName: Text[100];
        ShiptoAddress: Text[100];
        ShiptoAddress2: Text[50];
        ShiptoCity: Text[100];
        ShiptoPostCode: Text[20];
        ShiptoCountryRegionCode: Text[100];
        ShipToPhone, ShipToFax : Text[100];
        CurrCode: Text[10];
        CurrSymbol: Text[10];
        RecPaymentTerms: Record "Payment Terms";
        FooterText: Label 'Cancellation Policy: Customer reserves the right to cancel an order within five (5) business days from the date of acknowledgment by %1. If you wish to cancel an order, written notification must be received to the contact information below within the five-day period. Order cancellation requests received outside of this period will be considered invalid. If the order is cancelled within this period, any payment received by %1 will be refunded within thirty (30) days';
        UserEmail: Text;
        YellowColor: Boolean;
        RecSalesperson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
}