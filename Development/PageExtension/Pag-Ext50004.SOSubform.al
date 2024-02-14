pageextension 50004 SOSubform extends "Sales Order Subform"
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
            field("Parent Line No."; Rec."Parent Line No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Parent Line No..';
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
        }
        addlast(Control1)
        {
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order No.';
            }
            field("PO Line No."; Rec."PO Line No.")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Line No.';
            }
            field("No. of Packages"; Rec."No. of Packages")
            {
                ApplicationArea = All;
            }
            field("Pallet Quantity"; Rec."Pallet Quantity")
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
            field("Country of Origin"; Rec."Country of Origin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of Origin field.';
            }
            field("Country of provenance"; Rec."Country of provenance")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of provenance field.';
            }
            field("Country of Acquisition"; Rec."Country of Acquisition")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of Acquisition field.';
            }
            field("Surcharge Per Qty."; Rec."Surcharge Per Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Surcharge Per Qty. field.';
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
    actions
    {
        addlast(processing)
        {
            action("Remove Item Tracking")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    Recitem: Record Item;
                begin
                    Recitem.GET('ITEM00017');
                    Recitem."Item Tracking Code" := '';
                    Recitem.Modify();
                end;
            }
        }
    }
}
