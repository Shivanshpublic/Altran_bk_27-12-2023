page 50017 "Item Reference"
{
    ApplicationArea = All;
    Caption = 'Item Reference';
    PageType = List;
    SourceTable = "Item Reference";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number on the item card from which you opened the Item Reference Entries window.';
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the referenced item number. If you enter a reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the reference number on a sales or purchase document.';
                }
                field("Reference Type"; Rec."Reference Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the reference entry.';
                }
                field("Reference Type No."; Rec."Reference Type No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a customer number, a vendor number, or a bar code, depending on what you have selected in the Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the item linked to this reference. It will override the standard description when entered on an order.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an additional description of the item linked to this reference.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                }
            }
        }
    }
}
