report 50014 "Clear Cost & Price Log"
{
    ApplicationArea = All;
    Caption = 'Clear Cost & Price Log';
    UsageCategory = ReportsAndAnalysis;
    UseRequestPage = true;
    ProcessingOnly = true;
    dataset
    {
        dataitem(CostPriceLog; "Cost & Price Log")
        {
            RequestFilterFields = "Creation Date", "Created By", "Entry No.";

            trigger OnPostDataItem()
            begin
                CostPriceLog.DeleteAll();
            end;
        }
    }
}
