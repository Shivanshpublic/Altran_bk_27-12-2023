reportextension 50103 CustomerItemSalesExt extends "Customer/Item Sales"
{
    RDLCLayout = 'Layouts/Final/CustomerItemSales.rdl';

    dataset
    {
        add(Item)
        {
            column(Description_2; Item."Description 2") { }
            column(Description_2_Caption; FieldCaption(Item."Description 2")) { }
        }
    }
}