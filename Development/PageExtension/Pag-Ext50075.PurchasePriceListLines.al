pageextension 50075 PurchasePriceListLines extends "Purchase Price List Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                Caption = 'Model No.';
                ApplicationArea = All;
            }
        }
    }
}