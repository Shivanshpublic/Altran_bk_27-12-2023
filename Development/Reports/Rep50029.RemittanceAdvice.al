REPORT 50029 "Remittance Advice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/Final/RemittanceAdvice_Report.rdl';
    Caption = 'Remittance Advice';
    EnableHyperlinks = true;
    DATASET
    {
        DATAITEM("VendorLedgerEntry"; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.");// order(ascending) where("Document Type" = const(Payment));
            RequestFilterFields = "Vendor No.";
            CalcFields = Amount;
            COLUMN(No_; "Document No.")
            {
            }

            column(DocumentDate; Format(VendorLedgerEntry."Posting Date", 0, '<Month,2>/<Day,2>/<Year4>'))
            {
            }
            column(SaleOrderNo; '')
            {
            }
            column(Currency_Code; GetCurrencyCodeL("Currency Code"))
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
                    COLUMN(HomePage; CompanyInfo."Home Page Custom")
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
                    column(CompanyHomePage; CompanyInfo."Home Page Custom")
                    {
                    }

                    COLUMN(BuyFromVendorName; RecVendor."Name")
                    {
                    }
                    COLUMN(BuyFromAddress; RecVendor."Address")
                    {
                    }
                    COLUMN(BuyFromAddress2; RecVendor."Address 2")
                    {
                    }
                    COLUMN(BuyFromPhoneNo; 'Phone No.:' + RecVendor."Mobile Phone No.")
                    {
                    }
                    column(BuyFromCity; AddSpaceOrComma(RecVendor."City", ', ') + AddSpaceOrComma(RecVendor.County, ', '))
                    {

                    }
                    column(ByFromCOuntry; GetCountryDesc(RecVendor."Country/Region Code"))
                    {

                    }
                    COLUMN(BuyFromPostCode; RecVendor."Post Code")
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
                    COLUMN(TotPaidAmount; VendorLedgerEntry.Amount)
                    {
                    }
                    DATAITEM("DetailedVendorLedgEntry"; "Detailed Vendor Ledg. Entry")
                    {
                        DataItemLinkReference = VendorLedgerEntry;
                        DataItemLink = "Applied Vend. Ledger Entry No." = FIELD("Entry No.");
                        //DataItemTableView = sorting("Vendor Ledger Entry No.", "Posting Date") order(ascending) where("Initial Document Type" = filter(Invoice), "Entry Type" = filter(Application), "Unapplied" = filter(false));
                        DataItemTableView = sorting("Vendor Ledger Entry No.", "Posting Date") order(ascending) where("Initial Document Type" = filter(<> Payment), "Entry Type" = filter(Application), "Unapplied" = filter(false));

                        column(PaidInvoiceNo; PaidInvoiceNo)
                        {

                        }
                        column(External_Document_No; ExtDocNo)
                        {

                        }
                        column(Vendor_Invoice_No; VendorInvoiceNo)
                        {

                        }
                        column(Document_Type; "Initial Document Type")
                        {

                        }
                        column(VLEDescription; VLEDesc)
                        {

                        }
                        column(VLEAmount; ABS(DetailedVendorLedgEntry.Amount))
                        {

                        }
                        column(PaidAmount; PaidAmount)
                        {

                        }

                        DATAITEM(PurchaseLine; "Purch. Inv. Line")
                        {
                            DataItemLinkReference = DetailedVendorLedgEntry;
                            //DataItemLink = "Document No." = FIELD("Document No.");
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

                                AutoFormatExpression = '1,' + FORMAT(GetCurrencyCodeL(DetailedVendorLedgEntry."Currency Code"));
                                ////AutoFormatType = 10;
                            }
                            COLUMN(ExtendedPrice; Amount)
                            {
                                AutoFormatExpression = '1,' + FORMAT(GetCurrencyCodeL(DetailedVendorLedgEntry."Currency Code"));
                                // //AutoFormatType = 10;
                            }
                            TRIGGER OnPreDataItem()
                            BEGIN
                                SetRange("Document No.", PaidInvoiceNo);
                                SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
                                SetFilter(Quantity, '<>%1', 0);
                                NoOfRecords := PurchaseLine.COUNT;

                            END;

                            trigger OnAfterGetRecord()
                            begin
                                //message('Purchase Invoice');
                                if (PrevPaidInvoiceNo = PaidInvoiceNo) then
                                    PaidAmount := 0
                                else Begin
                                    // if DetailedVendorLedgEntry."Initial Document Type" = DetailedVendorLedgEntry."Initial Document Type"::Invoice then
                                    //     TotPaidAmount := PaidAmount;
                                End;
                                PrevPaidInvoiceNo := PaidInvoiceNo;

                                if (Quantity = 0) AND (Type <> Type::" ") then
                                    CurrReport.Skip();
                            end;
                        }
                        TRIGGER OnAfterGetRecord()
                        var
                            PurchInvHeader: Record "Purch. Inv. Header";
                        BEGIN
                            //message('Child VLE');
                            //message('Payment Amount %1', DetailedVendorLedgEntry.Amount);
                            Clear(VendorInvoiceNo);
                            Clear(ExtDocNo);
                            Clear(VLEDesc);
                            Clear(PaidInvoiceNo);
                            Clear(PrevPaidInvoiceNo);
                            Clear(PaidAmount);
                            PaidAmount := DetailedVendorLedgEntry.Amount;

                            TotPaidAmount += PaidAmount;
                            if VLE.Get(DetailedVendorLedgEntry."Vendor Ledger Entry No.") then begin
                                ExtDocNo := VLE."External Document No.";
                                VLEDesc := VLE.Description;
                                PaidInvoiceNo := VLE."Document No.";
                            end;
                            PurchInvHeader.Reset();
                            If PurchInvHeader.Get(PaidInvoiceNo) then begin
                                VendorInvoiceNo := PurchInvHeader."Vendor Invoice No.";
                            end;
                        END;

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
                    //message('Parent VLE');
                    OutPutNo += 1;
                    Clear(RecVendor);
                    if RecVendor.GET(VendorLedgerEntry."Vendor No.") then;
                    Clear(UserSetup);
                    Clear(UserEmail);
                    if UserSetup.GET(UserId) then
                        UserEmail := UserSetup."E-Mail";


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

    local procedure GetCurrencyCodeL(currcode: code[10]): Code[10]
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
        ShiptoCity: Text[30];
        ShiptoPostCode: Text[20];
        ShiptoCountryRegionCode: Text[10];
        CurrCode: Text[10];
        CurrSymbol: Text[10];
        RecPaymentTerms: Record "Payment Terms";
        FooterText: Label 'Cancellation Policy: Customer reserves the right to cancel an order within five (5) business days from the date of acknowledgment by %1. If you wish to cancel an order, written notification must be received to the contact information below within the five-day period. Order cancellation requests received outside of this period will be considered invalid. If the order is cancelled within this period, any payment received by %1 will be refunded within thirty (30) days';
        UserEmail: Text;
        YellowColor: Boolean;
        RecSalesperson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        RecVendor: Record Vendor;
        VendorInvoiceNo: Code[35];
        ExtDocNo: Code[35];
        VLE: Record "Vendor Ledger Entry";
        VLEDesc: Text[100];
        PaidInvoiceNo: code[20];
        PrevPaidInvoiceNo: Code[20];
        PaidAmount: Decimal;
        TotPaidAmount: Decimal;

}