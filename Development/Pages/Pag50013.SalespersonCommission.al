page 50013 "Salesperson Commission"
{
    Caption = 'Salesperson Commission';
    PageType = List;
    SourceTable = "Salesperson Commission";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salesperson Code field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field based on Type, for All to be kept blank.';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field("From Margin %"; Rec."From Margin %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Margin % field.';
                }
                field("To Margin %"; Rec."To Margin %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Margin % field.';
                }
                field("Commission %"; Rec."Commission %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Commission % field.';
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
