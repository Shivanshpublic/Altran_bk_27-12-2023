pageextension 50040 PurchRcptLines extends "Purch. Receipt Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Rev."; Rec."Rev.")
            {
                ApplicationArea = All;
            }
            field("Description21"; Rec."Description 2")
            {
                ApplicationArea = all;
                Caption = 'Model No.';
            }
            field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
            }
            field("Shipment Tracking Line No."; Rec."Shipment Tracking Line No.")
            {
                ApplicationArea = all;
            }
            field("Pallet Quantity"; Rec."Pallet Quantity")
            {
                ApplicationArea = all;
            }
            field("Total CBM"; Rec."Total CBM")
            {
                ApplicationArea = all;
            }
            field("Total Gross (KG)"; Rec."Total Gross (KG)")
            {
                ApplicationArea = all;
            }
            field("Line Amount"; Rec."Unit Cost" * Rec.Quantity)
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
                ToolTip = 'Specifies the VIA.';
            }
            field("Prepmt. Posting Description"; Rec."Prepmt. Posting Description")
            {
                ApplicationArea = Basic, Suite;

            }
        }
        addafter("No.")
        {
            field("Item Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = All;
            }
            field("UL Certificate Available"; Rec."UL Certificate Available")
            {
                ApplicationArea = All;
            }
            field("FAI Receipt"; Rec."FAI Receipt")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the FAI Receipt.';
            }
            field("FAI Approval"; Rec."FAI Approval")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the FAI Approval.';
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
