page 50012 "Item Volumes"
{
    Caption = 'Item Volumes';
    PageType = List;
    SourceTable = "Item Volume";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Volume Code"; Rec."Volume Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Volume Code field.';
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Length field.';
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Width field.';
                }
                field(Height; Rec.Height)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Height field.';
                }
                field(Volume; Rec.Volume)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Volume field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
            }
        }
    }
}
