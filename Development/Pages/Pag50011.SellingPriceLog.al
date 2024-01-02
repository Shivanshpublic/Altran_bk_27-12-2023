page 50011 "Selling Price Log"
{
    Caption = 'Selling Price Log';
    PageType = List;
    SourceTable = SellingPriceLog;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
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
                field("Profit Margin %"; Rec."Profit Margin %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Profit Margin % field.';
                }
                field("Profit Margin"; Rec."Profit Margin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Profit Margin field.';
                }
                field("Suggested Selling Price"; Rec."Suggested Selling Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Suggested Selling Price field.';
                }
                field("Total Est. Landed Cost"; Rec."Total Est. Landed Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Est. Landed Cost field.';
                }
            }
        }
    }
}
