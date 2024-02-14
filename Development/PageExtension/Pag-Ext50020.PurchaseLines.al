pageextension 50020 "Purchase Lines Ext" extends "Purchase Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("Rev."; Rec."Rev.")
            {
                ApplicationArea = All;
            }
            field("SO No."; Rec."SO No.")
            {
                ApplicationArea = All;
                Caption = 'Sales Order No.';
            }
            field("SO Line No."; Rec."SO Line No.")
            {
                ApplicationArea = All;
                Caption = 'Sales Order Line No.';
            }
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
            field("Pallet Quantity"; Rec."Pallet Quantity")
            {
                ApplicationArea = All;
            }
            field("Milestone Status"; Rec."Milestone Status")
            {
                ApplicationArea = All;
            }

            field("VIA"; Rec."VIA")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
            }
            field("UL Certificate Available"; Rec."UL Certificate Available")
            {
                ApplicationArea = All;
            }
            field("Order Note"; Rec."Order Note")
            {
                ApplicationArea = All;
            }
        }
        modify("Description 2")
        {
            Visible = true;
            Caption = 'Model No.';
        }

    }

}
