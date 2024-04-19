pageextension 50079 PurchArchiveList extends "Purchase List Archive"
{
    layout
    {
        addlast(Control1)
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
            field("PO Exists"; Rec."PO Exists")
            {
                ApplicationArea = All;
            }
            field("Latest Version"; Rec."Latest Version")
            {
                ApplicationArea = All;
            }
            field("Old Version"; Rec."Old Version")
            {
                ApplicationArea = All;
            }
        }
    }

}
