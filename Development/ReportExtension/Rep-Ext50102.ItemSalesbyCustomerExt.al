reportextension 50102 ItemSalesbyCustomerExt extends "Item Sales by Customer"
{
    RDLCLayout = 'Layouts/Final/ItemSalesbyCustomer.rdl';

    dataset
    {
        add("Item Ledger Entry")
        {
            column(Description_2; Item."Description 2") { }
            column(Description_2_Caption; Item_Ledger_Entry__Desc2__CaptionLbl) { }
        }
    }
    var
        Item_Ledger_Entry__Desc2__CaptionLbl: Label 'Model No.';
}