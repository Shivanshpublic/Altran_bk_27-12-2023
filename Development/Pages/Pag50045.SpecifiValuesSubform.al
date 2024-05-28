page 50045 SpecifiValuesSubform
{
    ApplicationArea = All;
    Caption = 'SpecifiValuesSubform';
    PageType = List;
    SourceTable = "Specification Values";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Specification; Rec.Specification)
                {
                    ToolTip = 'Specifies the value of the Specs field.';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the Specification value.';
                }
            }
        }
    }
}
