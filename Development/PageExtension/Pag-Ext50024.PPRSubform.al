pageextension 50024 PPRSubform extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Rev."; Rec."Rev.")
            {
                ApplicationArea = All;
            }
            field("SO No."; Rec."SO No.")
            {
                ApplicationArea = all;
            }
            field("SO Line No."; Rec."SO Line No.")
            {
                ApplicationArea = All;
            }
            field("HS Code"; Rec."HS Code")
            {
                ApplicationArea = All;
            }
            field("HTS Code"; Rec."HTS Code")
            {
                ApplicationArea = All;
            }
            field("No. of Packages"; Rec."No. of Packages")
            {
                ApplicationArea = All;
            }
            field("Total Gross (KG)"; Rec."Total Gross (KG)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Gross (KG) field.';
            }
            field("Total CBM"; Rec."Total CBM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total CBM field.';
            }
            field("Total Net (KG)"; Rec."Total Net (KG)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Net (KG) field.';
            }
            field("Port of Load"; Rec."Port of Load")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Port of Load field.';
            }
            field("Port of Discharge"; Rec."Port of Discharge")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Port of Discharge field.';
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
                ApplicationArea = all;
            }
            field("Milestone Status"; Rec."Milestone Status")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Milestone Status.';
            }
            field("VIA"; Rec."VIA")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the VIA.';
            }
            field("UL Certificate Available"; Rec."UL Certificate Available")
            {
                ApplicationArea = All;
            }

        }
        addlast(Control1)
        {
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
        addafter("No.")
        {
            field("Cross-Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
