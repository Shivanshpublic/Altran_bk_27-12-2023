pageextension 50031 "Sales Lines Ext" extends "Sales Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Shipment Tracking Line No."; Rec."Shipment Tracking Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Surcharge Per Qty."; Rec."Surcharge Per Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("UL Certificate Available"; Rec."UL Certificate Available")
            {
                ApplicationArea = All;
            }

        }
        addafter("No.")
        {
            field("Item Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
