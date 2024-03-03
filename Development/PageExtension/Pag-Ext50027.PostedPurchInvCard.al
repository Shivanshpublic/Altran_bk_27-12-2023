pageextension 50027 PostedPurchInvCard extends "Posted Purchase Invoice"
{
    layout
    {
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
}

