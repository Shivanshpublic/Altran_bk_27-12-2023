page 50048 "Item Specification Subpage"
{
    ApplicationArea = All;
    Caption = 'Item Specification Subpage';
    PageType = ListPart;
    SourceTable = "Item Specification";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Visible = false;
                }
                field(Specification; Rec.Specification)
                {
                    ToolTip = 'Specifies the value of the Specification field.';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the Specification Value.';
                }
            }
        }
    }
}
