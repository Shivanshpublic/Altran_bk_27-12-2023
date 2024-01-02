REPORT 50010 "Account Statement"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/Final/AccountStatement.rdl';
    Caption = 'Customer Account Statement';
    EnableHyperlinks = true;

    DATASET
    {
        DATAITEM(Customer; Customer)
        {
            PrintOnlyIfDetail = TRUE;
            RequestFilterFields = "No.";
            COLUMN(CustNo; Customer."No.") { }
            COLUMN(CustName; Customer.Name) { }
            COLUMN(CustName2; Customer."Name 2") { }
            COLUMN(CustAddress; Customer.Address) { }
            COLUMN(CustAddress2; Customer."Address 2") { }
            COLUMN(CustCity; AddSpaceOrComma(Customer.City, ', ') + AddSpaceOrComma(Customer.County, ', ')) { }
            COLUMN(CustContact; Customer.Contact) { }
            COLUMN(CustPhNo; Customer."Phone No.") { }
            COLUMN(CustPostCode; Customer."Post Code") { }
            COLUMN(CustCountry; GetCountryDesc(Customer."Country/Region Code"))
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
            COLUMN(HomePage; CompanyInfo."Home Page")
            {
            }
            column(YellowColor; YellowColor)
            {

            }
            column(DocumentDate; Today())
            {

            }

            COLUMN(CompanyPostCode; CompanyInfo."Post Code")
            {
            }
            COLUMN(CompanyCountry; GetCountryDesc(CompanyInfo."Country/Region Code"))
            {
            }
            COLUMN(AgedDates1; AgedDates[1]) { }
            COLUMN(AgedDates2; AgedDates[2]) { }
            COLUMN(AgedDates3; AgedDates[3]) { }
            COLUMN(AgedDates4; AgedDates[4]) { }
            COLUMN(AgedDates5; AgedDates[5]) { }
            COLUMN(AgedAmount1; AgedAmount[1]) { }
            COLUMN(AgedAmount2; AgedAmount[2]) { }
            COLUMN(AgedAmount3; AgedAmount[3]) { }
            COLUMN(AgedAmount4; AgedAmount[4]) { }
            COLUMN(AgedAmount5; AgedAmount[5]) { }
            COLUMN(TotalDue; TotalDue) { }

            DATAITEM("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemTableView = WHERE(Open = CONST(TRUE));
                DataItemLink = "Customer No." = FIELD("No.");
                COLUMN(CLEDate; "Cust. Ledger Entry"."Posting Date") { }
                COLUMN(CLEDocType; "Cust. Ledger Entry"."Document Type") { }
                COLUMN(CLEDocNo; "Cust. Ledger Entry"."Document No.") { }
                COLUMN(CLEDesc; "Cust. Ledger Entry".Description) { }
                COLUMN(CLEAmount; "Cust. Ledger Entry".Amount) { }
                COLUMN(CLEBalance; "Cust. Ledger Entry"."Remaining Amount") { }
                COLUMN(StartBalance; StartBalance) { }
                COLUMN(CustBalance; CustBalance) { }
                COLUMN(ExtDocNo; "Cust. Ledger Entry"."External Document No.") { }
                COLUMN(YourRef; "Cust. Ledger Entry"."Your Reference") { }

                TRIGGER OnPreDataItem()
                BEGIN
                    IF (FromDate <> 0D) AND (ToDate <> 0D) THEN
                        "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Posting Date", FromDate, ToDate);
                END;

                TRIGGER OnAfterGetRecord()
                BEGIN
                    DetLedgAmount := 0;
                    DetailedCustLedgEntry.SETRANGE("Customer No.", Customer."No.");
                    DetailedCustLedgEntry.SETRANGE("Posting Date", FromDate, ToDate);
                    DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", "Cust. Ledger Entry"."Entry No.");
                    IF DetailedCustLedgEntry.FINDFIRST THEN
                        REPEAT
                            DetLedgAmount += DetailedCustLedgEntry.Amount;
                        UNTIL DetailedCustLedgEntry.NEXT = 0;

                    CustBalance := CustBalance + DetLedgAmount;
                END;
            }

            TRIGGER OnPreDataItem()
            VAR
                i: Integer;
            BEGIN
                VerifyDates();

                IF ToDate <> 0D THEN BEGIN
                    FOR i := 1 TO 5 DO BEGIN
                        IF i = 1 THEN
                            AgedDates[i] := ToDate
                        ELSE
                            AgedDates[i] := ToDate - ((i - 1) * 30);
                    END;
                END;
            END;

            TRIGGER OnAfterGetRecord()
            VAR
                _DetLedgAmount: Decimal;
                i: Integer;
            BEGIN
                StartBalance := 0;
                CustBalance := 0;
                CLEAR(AgedAmount);
                CLEAR(TotalDue);
                Customer.CALCFIELDS("Net Change");
                StartBalance := Customer."Net Change";
                //CustBalance := Customer."Net Change";

                _DetLedgAmount := 0;
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
                IF (FromDate <> 0D) AND (ToDate <> 0D) THEN
                    CustLedgerEntry.SETRANGE("Posting Date", FromDate, ToDate);
                CustLedgerEntry.SETRANGE(Open, TRUE);
                IF CustLedgerEntry.FINDSET THEN
                    REPEAT
                        _DetLedgAmount := 0;
                        DetailedCustLedgEntry.SETRANGE("Customer No.", Customer."No.");
                        DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        DetailedCustLedgEntry.SETRANGE("Posting Date", FromDate, ToDate);
                        IF DetailedCustLedgEntry.FINDFIRST THEN
                            REPEAT
                                _DetLedgAmount += DetailedCustLedgEntry.Amount;
                            UNTIL DetailedCustLedgEntry.NEXT = 0;

                        FOR i := 1 TO 5 DO BEGIN
                            IF i = 1 THEN BEGIN
                                IF (CustLedgerEntry."Posting Date" >= AgedDates[i]) THEN BEGIN
                                    AgedAmount[i] += _DetLedgAmount;
                                    TotalDue += _DetLedgAmount;
                                END;
                            END
                            ELSE
                                IF i = 5 THEN BEGIN
                                    IF (CustLedgerEntry."Posting Date" < AgedDates[i - 1]) THEN BEGIN
                                        AgedAmount[i] += _DetLedgAmount;
                                        TotalDue += _DetLedgAmount;
                                    END;
                                END
                                ELSE BEGIN
                                    IF (CustLedgerEntry."Posting Date" < AgedDates[i - 1]) AND (CustLedgerEntry."Posting Date" >= AgedDates[i]) THEN BEGIN
                                        AgedAmount[i] += _DetLedgAmount;
                                        TotalDue += _DetLedgAmount;
                                    END;
                                END;

                        END;
                    UNTIL CustLedgerEntry.NEXT = 0;
            END;
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
                    FIELD("From Date"; FromDate)
                    {
                        ApplicationArea = All;
                    }
                    FIELD("To Date"; ToDate)
                    {
                        ApplicationArea = All;
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

    PROCEDURE VerifyDates()
    BEGIN
        IF FromDate = 0D THEN
            FromDate := 19900101D;
        IF ToDate = 0D THEN
            ToDate := WORKDATE;
    END;

    VAR
        FromDate: Date;
        ToDate: Date;
        CompanyInfo: Record "Company Information";
        Transaction: Text;
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        StartBalance: Decimal;
        CustBalance: Decimal;
        RemainingAmount: Decimal;
        DetLedgAmount: Decimal;
        AgedAmount: Array[5] OF Decimal;
        AgedDates: Array[5] OF Date;
        TotalDue: Decimal;
        UserEmail: Text;
        YellowColor: Boolean;
}