page 50049 "Item Category Spec Subpage"
{
    ApplicationArea = All;
    Caption = 'Item Category Spec Subpage';
    PageType = ListPart;
    SourceTable = "Item Category Specification";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ItemCategory; Rec.ItemCategory)
                {
                    ToolTip = 'Specifies the value of the ItemCategory field.';
                    Visible = false;
                }
                field(Specification; Rec.Specification)
                {
                    ToolTip = 'Specifies the value of the Specification field.';
                }
            }
        }
    }
}
