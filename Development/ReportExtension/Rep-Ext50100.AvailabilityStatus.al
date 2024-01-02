reportextension 50100 AvailabilityStatusExt extends "Availability Status"
{
    RDLCLayout = 'Layouts/Final/AvailabilityStatus.rdl';

    dataset
    {
        add(Item)
        {
            column(Description_2; Item."Description 2") { }
            column(Description_2_Caption; FieldCaption(Item."Description 2")) { }
        }
    }
}