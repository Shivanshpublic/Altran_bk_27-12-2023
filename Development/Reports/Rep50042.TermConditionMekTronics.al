REPORT 50042 "TermConditionMekTronics"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    UseRequestPage = false;
    RDLCLayout = 'Layouts/TermConditionMekTronics.rdl';
    Caption = 'Term and Condition';

    dataset
    {
        DATAITEM(TermCondition; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            COLUMN(TermConditionLinNo; TermCondition.Number) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
        }


    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
        end;
    }

    TRIGGER OnPreReport()
    BEGIN
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

    END;

    VAR
        CompanyInfo: Record "Company Information";
        SalesOrderNo: Code[20];
        SalesOrderLineNo: Integer;
        SalesHead: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ExtDocNo: Text[35];
        SalesOrdQty: Decimal;
        AltranPONo: code[20];
        ModelNo: Text[50];

}