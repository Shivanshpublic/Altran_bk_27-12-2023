reportextension 50103 CustomerItemSalesExt extends "Customer/Item Sales"
{
    RDLCLayout = 'Layouts/Final/CustomerItemSales.rdl';

    dataset
    {
        add(Customer)
        {
            column(Description_2; Item."Description 2") { }
            column(Description_2_Caption; Item_Ledger_Entry__Desc2__CaptionLbl) { }
        }
    }
    var
        Item_Ledger_Entry__Desc2__CaptionLbl: Label 'Model No.';
}