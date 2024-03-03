reportextension 50100 AvailabilityStatusExt extends "Availability Status"
{
    RDLCLayout = 'Layouts/Final/AvailabilityStatus.rdl';

    dataset
    {
        add(Item)
        {
            column(Description_2; Item."Description 2") { }
            column(Description_2_Caption; FieldCaption(Item."Description 2")) { }
            column(ReOrder_Qty; Item."Reorder Quantity") { }
            column(ReOrderQty_Caption; FieldCaption(Item."Reorder Quantity")) { }
            column(ItemCategory; Item."Item Category Code") { }
            column(ItemCategory_Caption; FieldCaption(Item."Item Category Code")) { }
            column(MinimumOQ; Item."Minimum Order Quantity") { }
            column(MinimumOQ_Caption; FieldCaption(Item."Minimum Order Quantity")) { }
            column(MaximumOQ; Item."Maximum Order Quantity") { }
            column(MaximumOQ_Caption; FieldCaption(Item."Maximum Order Quantity")) { }
        }
    }
}