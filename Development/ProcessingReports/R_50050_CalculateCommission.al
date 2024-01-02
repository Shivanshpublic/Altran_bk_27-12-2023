/*
REPORT 50050 "Calculate Commission"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = TRUE;

    TRIGGER OnPreReport()
    BEGIN
        SalesCommissionEntry.DELETEALL;
        SalesInvHeader.RESET;
        SalesInvHeader.SETFILTER("Internal Team", '<>%1', '');
        IF SalesInvHeader.FINDFIRST THEN BEGIN
            REPEAT
                CLE.RESET;
                CLE.SETRANGE("Document Type", CLE."Document Type"::Payment);
                CLE.SETRANGE("Document No.", SalesInvHeader."No.");
                CLE.SETRANGE(Open, FALSE);
                IF CLE.FINDFIRST THEN BEGIN
                    SalesPerson.RESET;
                    SalesPerson.SETFILTER(Code, SalesInvHeader."Internal Team");
                    IF SalesPerson.FINDFIRST THEN BEGIN
                        REPEAT
                            CommissionSetup.RESET;
                            CommissionSetup.SETRANGE("Salesperson Code", SalesPerson.Code);
                            CommissionSetup.SETFILTER("Start Date", '>=%1', SalesInvHeader."Posting Date");
                            CommissionSetup.SETFILTER("End Date", '<=%1', SalesInvHeader."Posting Date");
                            IF CommissionSetup.FINDFIRST THEN BEGIN
                                SalesCommissionEntry.INIT;
                                SalesCommissionEntry."Salesperson Code" := SalesPerson.Code;
                                SalesCommissionEntry."Document Type" := SalesCommissionEntry."Document Type"::Invoice;
                                SalesCommissionEntry."Document No." := SalesInvHeader."No.";
                                SalesCommissionEntry.INSERT;
                                SalesCommissionEntry."Internal Team" := SalesInvHeader."Internal Team";
                                SalesCommissionEntry."External Team" := SalesInvHeader."External Rep";
                                SalesInvHeader.CALCFIELDS(Amount);
                                SalesCommissionEntry."Document Amount" := SalesInvHeader.Amount;
                                SalesCommissionEntry."Posting Date" := SalesInvHeader."Posting Date";
                                SalesCommissionEntry."Gross Margin %" := CommissionSetup."Gross Margin %";
                                SalesCommissionEntry."Commission %" := CommissionSetup."Commission %";
                                SalesCommissionEntry."Commission Amount" := (SalesInvHeader.Amount * CommissionSetup."Commission %") / 100;
                                SalesCommissionEntry.MODIFY;
                            END;
                        UNTIL SalesPerson.NEXT = 0;
                    END;
                END;
            UNTIL SalesInvHeader.NEXT = 0;
        END;

        SalesInvHeader.RESET;
        SalesInvHeader.SETFILTER("External Rep", '<>%1', '');
        IF SalesInvHeader.FINDFIRST THEN BEGIN
            REPEAT
                CLE.RESET;
                CLE.SETRANGE("Document Type", CLE."Document Type"::Payment);
                CLE.SETRANGE("Document No.", SalesInvHeader."No.");
                CLE.SETRANGE(Open, FALSE);
                IF CLE.FINDFIRST THEN BEGIN
                    SalesPerson.RESET;
                    SalesPerson.SETFILTER(Code, SalesInvHeader."External Rep");
                    IF SalesPerson.FINDFIRST THEN BEGIN
                        REPEAT
                            CommissionSetup.RESET;
                            CommissionSetup.SETRANGE("Salesperson Code", SalesPerson.Code);
                            CommissionSetup.SETFILTER("Start Date", '>=%1', SalesInvHeader."Posting Date");
                            CommissionSetup.SETFILTER("End Date", '<=%1', SalesInvHeader."Posting Date");
                            IF CommissionSetup.FINDFIRST THEN BEGIN
                                SalesCommissionEntry.INIT;
                                SalesCommissionEntry."Salesperson Code" := SalesPerson.Code;
                                SalesCommissionEntry."Document Type" := SalesCommissionEntry."Document Type"::Invoice;
                                SalesCommissionEntry."Document No." := SalesInvHeader."No.";
                                SalesCommissionEntry.INSERT;
                                SalesCommissionEntry."Internal Team" := SalesInvHeader."Internal Team";
                                SalesCommissionEntry."External Team" := SalesInvHeader."External Rep";
                                SalesInvHeader.CALCFIELDS(Amount);
                                SalesCommissionEntry."Document Amount" := SalesInvHeader.Amount;
                                SalesCommissionEntry."Posting Date" := SalesInvHeader."Posting Date";
                                SalesCommissionEntry."Gross Margin %" := CommissionSetup."Gross Margin %";
                                SalesCommissionEntry."Commission %" := CommissionSetup."Commission %";
                                SalesCommissionEntry."Commission Amount" := (SalesInvHeader.Amount * CommissionSetup."Commission %") / 100;
                                SalesCommissionEntry.MODIFY;
                            END;
                        UNTIL SalesPerson.NEXT = 0;
                    END;
                END;
            UNTIL SalesInvHeader.NEXT = 0;
        END;
    END;

    TRIGGER OnPostReport()
    BEGIN
        MESSAGE('Commission calcualted');
    END;

    VAR
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCommissionEntry: Record "Sales Commission Entry";
        CommissionSetup: Record "Salesperson Commission Setup";
        SalesPerson: Record "Salesperson/Purchaser";
        CLE: Record "Cust. Ledger Entry";
}
*/