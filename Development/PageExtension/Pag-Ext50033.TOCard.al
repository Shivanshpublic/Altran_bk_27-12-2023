pageextension 50033 "TOCard" extends "Transfer Order"
{
    layout
    {
        addlast(General)
        {
            field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
        }
    }
    actions
    {
        addafter(GetReceiptLines)
        {
            /*  action(GetTransferShipmentLines) // hide by baya
             {
                 Promoted = TRUE;
                 PromotedCategory = Process;
                 ApplicationArea = Location;
                 Caption = 'Get Transfer Shipment Lines';
                 Image = Shipment;
                 ToolTip = 'Add transfer order lines from Transfer shipment lines.';

                 trigger OnAction()
                 begin
                     Rec.GetTransferShipmentLines();
                 end;
             } */
            action(GetTransferReceiptLines)
            {
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = Location;
                Caption = 'Get Transfer Receipt Lines';
                Image = Shipment;
                ToolTip = 'Add transfer order lines from Transfer receipt lines.';

                trigger OnAction()
                begin
                    Rec.GetTransferReceiptLines();
                end;
            }
        }
    }
}
