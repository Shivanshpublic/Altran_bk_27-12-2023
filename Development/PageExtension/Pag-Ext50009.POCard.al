pageextension 50009 POCard extends "Purchase Order"
{
    layout
    {
        modify("Promised Receipt Date")
        {
            Visible = true;
        }
        addlast(General)
        {
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
            field("Milestone Status"; Rec."Milestone Status")
            {
                ApplicationArea = All;
            }
            field("VIA"; Rec."VIA")
            {
                ApplicationArea = All;
            }
            field("Prepmt. Posting Description"; Rec."Prepmt. Posting Description")
            {
                ApplicationArea = all;
                Caption = 'Shipment Description';
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action("Assign Lot No.")
            {
                ApplicationArea = ItemTracking;
                Caption = 'Assign &Lot No.';
                Image = Lot;
                ToolTip = 'Automatically assign the required lot numbers.';

                trigger OnAction()
                begin
                    //if InsertIsBlocked then
                    //    exit;
                    Rec.AssignLotNo(Rec, 0, '');
                end;
            }
            action("Unassign Lot No.")
            {
                ApplicationArea = ItemTracking;
                Caption = 'Unassign &Lot No.';
                Image = Lot;
                ToolTip = 'Automatically unassign the required lot numbers.';

                trigger OnAction()
                begin
                    //if InsertIsBlocked then
                    //    exit;
                    Rec.DeleteReservationEntry(Rec, 0);
                end;
            }
            action("Show Related Sales Orders")
            {
                ApplicationArea = All;
                Image = AllLines;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    SoLine: Record "Sales Line";
                    PSLine: Record "Sales Invoice Line";
                begin
                    Clear(SoLine);
                    SoLine.SetRange("Document Type", SoLine."Document Type"::Order);
                    SoLine.SetFilter("PO No.", Rec."No.");
                    if SoLine.FindSet() then
                        Page.Run(0, SoLine);

                    Clear(PSLine);
                    PSLine.SetFilter("PO No.", Rec."No.");
                    if PSLine.FindSet() then
                        Page.Run(0, PSLine);
                end;
            }
        }
    }


}
