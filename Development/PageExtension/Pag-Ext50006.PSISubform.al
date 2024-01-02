pageextension 50006 PSISubform extends "Posted Sales Invoice Subform"
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
        }
        addlast(Control1)
        {
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
            field("Location Code1"; rec."Location Code")
            {
                ApplicationArea = all;
                Caption = 'Location Code';

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
        addlast("&Line")
        {
            action("Update Linked Sales Order No.")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                trigger OnAction()
                var
                    RecLine: Record "Sales Invoice Line";
                    UpdateInvoiceLine: Page "Update Sales Inv Line";
                begin
                    Clear(RecLine);
                    RecLine.SetRange("Document No.", Rec."Document No.");
                    RecLine.SetRange("Line No.", Rec."Line No.");
                    RecLine.FindFirst();
                    Clear(UpdateInvoiceLine);
                    UpdateInvoiceLine.SetTableView(RecLine);
                    UpdateInvoiceLine.RunModal();
                end;
            }
        }
    }
}
