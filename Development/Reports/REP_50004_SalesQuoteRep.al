REPORT 50004 "Sales Quote Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/Final/SalesQuoteReport.rdl';
    Caption = 'Sales Quote Report';
    EnableHyperlinks = true;
    DATASET
    {
        DATAITEM(SalesHeader; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            COLUMN(No_; "No.")
            {
            }
            column(Currency_Code; GetCurrencyCode("Currency Code"))
            {
            }
            column(CurSybl; GetCurrencySymbol())
            {

            }
            column(Document_Date; "Document Date")
            {
            }
            column(CustReqDate; "Order Date")
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
            column(Payment_Terms_Code; RecPaymentTerms.Description)//"Payment Terms Code")
            {
            }
            column(IncoTerms; ShipmentCode.Description)
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
                    COLUMN(HomePage; CompanyInfo."Home Page")
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
                    column(FooterText; FooterText)
                    {

                    }
                    column(FooterText2; FooterText2)
                    {

                    }
                    column(UserEmail; 'email:' + UserEmail)
                    {

                    }
                    column(YellowColor; YellowColor)
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
                        column(Ordered; Quantity)
                        {
                        }
                        COLUMN(Description; Description)
                        {
                        }
                        column(CustomerPN; "Item Reference No.")
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

                        trigger OnAfterGetRecord()
                        begin
                            if (Quantity = 0) AND (Type <> Type::" ") then
                                CurrReport.Skip();
                        end;
                    }

                    /*
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
                    */
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
                    IF ShipmentCode.GET(SalesHeader."Shipment Method Code") THEN;
                    Clear(RecPaymentTerms);
                    if RecPaymentTerms.GET(SalesHeader."Payment Terms Code") then;
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
        SaveValues = true;
        LAYOUT
        {
            AREA(Content)
            {
                GROUP(GroupName)
                {
                    FIELD(PrintTermCondition; PrintTermCondition)
                    {
                        ApplicationArea = All;
                        Caption = 'Print with Term & Condition';
                        Visible = false;
                    }

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

    trigger OnPostReport()
    var
        TermConditionRep: Report "Term and Condition";
        CompInfo: Record "Company Information";
    begin
        // if PrintTermCondition then
        //     if NOT CurrReport.Preview then begin
        //         CompInfo.Get();
        //         if CompInfo."Term Condition Report ID" <> 0 then
        //             Report.Run(CompInfo."Term Condition Report ID")
        //         else begin
        //             Clear(TermConditionRep);
        //             TermConditionRep.UseRequestPage(false);
        //             TermConditionRep.Run;
        //         end;
        //     end;P
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
        FooterText: Label '*Once an order is placed and confirmed, it can not be canceled or returned.';
        FooterText2: Label '*All quotes are valid for 60 days';
        UserEmail: Text;
        YellowColor: Boolean;
        PrintTermCondition: Boolean;
}