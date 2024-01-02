pageextension 50051 BSOSubform extends "Blanket Sales Order Subform"
{
    layout
    {
        addbefore(Type)
        {
        }
        addlast(Control1)
        {

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
