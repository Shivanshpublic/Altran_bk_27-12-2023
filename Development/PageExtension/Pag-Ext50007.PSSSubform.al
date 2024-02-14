pageextension 50007 PSSSubform extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addbefore(Type)
        {
            field("Line No.1"; Rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Line No..';
            }
        }
        addlast(Control1)
        {
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order No.';
                Editable = false;
            }
            field("PO Line No."; Rec."PO Line No.")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Line No.';
                Editable = false;
            }
            field("Assigned CSR"; Rec."Assigned CSR")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("HS Code"; Rec."HS Code")
            {
                ApplicationArea = All;
            }
            field("HTS Code"; Rec."HTS Code")
            {
                ApplicationArea = All;
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
            field("Pallet Quantity"; Rec."Pallet Quantity")
            {
                ApplicationArea = All;
            }
            //18-09-2023-start
            field("Origin Criteria"; Rec."Origin Criteria")
            {
                ApplicationArea = All;
            }
            field("Certification Indicator"; Rec."Certification Indicator")
            {
                ApplicationArea = All;
            }
            field("USMCA Qualified Y/N"; Rec."USMCA Qualified Y/N")
            {
                ApplicationArea = All;
            }
            field("Linked SO Line No."; Rec."Linked SO Line No.")
            {
                ApplicationArea = All;
            }
            //18-09-2023-end
            field("UL Certificate Available"; Rec."UL Certificate Available")
            {
                ApplicationArea = All;
            }

        }
        modify("Description 2")
        {
            Visible = true;
            Caption = 'Model No.';
        }
        modify("Item Reference No.")
        {
            Visible = true;
        }
    }
}
