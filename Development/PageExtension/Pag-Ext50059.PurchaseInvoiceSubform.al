pageextension 50059 "PurchaseInvoiceSubform" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter(Description)
        {

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
        addafter("Line Amount")
        {
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

            field("Assigned By"; Rec."Assigned By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value based on which gross weight will be assigned, if its blank it will consider gross weight field .';
            }
        }
    }
}
