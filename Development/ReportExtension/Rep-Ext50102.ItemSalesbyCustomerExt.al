reportextension 50102 ItemSalesbyCustomerExt extends "Item Sales by Customer"
{
    RDLCLayout = 'Layouts/Final/ItemSalesbyCustomer.rdl';

    dataset
    {
        add(Item)
        {
            column(Description_2; Item."Description 2") { }
            column(Description_2_Caption; FieldCaption(Item."Description 2")) { }
        }
    }
}