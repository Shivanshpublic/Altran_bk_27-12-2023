pageextension 50051 BSOSubform extends "Blanket Sales Order Subform"
{
    layout
    {
        addbefore(Type)
        {
        }
        addlast(Control1)
        {
            field("Planned Delivery Date"; Rec."Planned Delivery Date")
            {
                ApplicationArea = All;
            }
            field("Planned Shipment Date"; Rec."Planned Shipment Date")
            {
                ApplicationArea = All;
            }
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
