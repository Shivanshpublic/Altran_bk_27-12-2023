pageextension 50074 SalesPriceList extends "Sales Price List"
{
    layout
    {
    }
    actions
    {
        addafter(VerifyLines)
        {
            action("Update Model No.")
            {
                ApplicationArea = All;
                ToolTip = 'Update Model No. from Item Master.';
                trigger OnAction()
                var
                    PriceLine: Record "Price List Line";
                    Item: Record Item;
                begin
                    If PriceLine.FindFirst() then
                        repeat
                            if Item.Get(PriceLine."Product No.") then begin
                                PriceLine."Description 2" := item."Description 2";
                                PriceLine.Modify();
                            end;
                        until PriceLine.Next() = 0;
                end;

            }
        }
    }
}