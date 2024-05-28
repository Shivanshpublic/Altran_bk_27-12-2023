page 50042 "Item Category Specification"
{

    ApplicationArea = All;
    Caption = 'Item Category Specification';
    PageType = List;
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
                    TableRelation = "Item Category";
                }
                field(Specification; Rec.Specification)
                {
                    ToolTip = 'Specifies the value of the Specification field.';
                    TableRelation = Specification;
                }
            }
        }
    }
}
