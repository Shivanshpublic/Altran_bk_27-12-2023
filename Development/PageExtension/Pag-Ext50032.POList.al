pageextension 50032 "POList" extends "Purchase Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("Prepmt. Posting Description"; Rec."Prepmt. Posting Description")
            {
                ApplicationArea = all;
                Caption = 'Shipment Description';
            }
            field("VIA"; Rec."VIA")
            {
                ApplicationArea = All;
            }
            field("Sample Order"; Rec."Sample Order")
            {
                ApplicationArea = All;
            }
        }
    }
}
