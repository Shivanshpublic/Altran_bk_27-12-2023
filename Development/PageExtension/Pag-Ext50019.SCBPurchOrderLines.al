pageextension 50063 SCBPurchOrderLines extends "SCB Purchase Order Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            // field("Vendor Name"; Rec."Vendor Name")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Description 2")
        {

            // field("Posting Description"; Rec."Posting Description")
            // {
            //     ApplicationArea = All;
            // }
            // field("Prepmt. Posting Description"; Rec."Prepmt. Posting Description")
            // {
            //     ApplicationArea = All;
            // }
        }
    }
}
