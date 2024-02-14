pageextension 50050 SQSubform extends "Sales Quote Subform"
{
    layout
    {
        addbefore(Type)
        {
        }
        addlast(Control1)
        {
            field("Assigned CSR"; Rec."Assigned CSR")
            {
                ApplicationArea = All;
            }

        }
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
    }
}
