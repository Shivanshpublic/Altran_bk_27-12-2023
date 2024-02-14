pageextension 50062 PostedPurchReceiptLines extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter("Description 2")
        {
            field("Rev."; Rec."Rev.")
            {
                ApplicationArea = All;
            }
            field("Shipment Tracking Code"; rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
            }
            field("Milestone Status"; rec."Milestone Status")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Order Note"; Rec."Order Note")
            {
                ApplicationArea = All;
            }
        }
    }

}
