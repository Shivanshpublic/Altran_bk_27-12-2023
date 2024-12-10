
REPORT 50050 "Update Assigned By"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = TRUE;

    dataset
    {
        dataitem("Item Category"; "Item Category")
        {
            DataItemTableView = SORTING(Code) order(ascending);
            RequestFilterFields = Code;

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
            begin

                Item.Setrange("Item Category Code", Code);
                if Item.FindFirst() then
                    repeat
                        Item."Assigned By" := "Assigned User ID";
                        Item.Modify();
                    until Item.Next() = 0;
                i += 1;
            end;
        }
    }

    TRIGGER OnPreReport()
    BEGIN
    END;

    TRIGGER OnPostReport()
    BEGIN
        if i > 0 then
            Message('%1 recordes updated.', i);

    END;

    VAR
        Item: Record Item;
        i: Integer;
}
