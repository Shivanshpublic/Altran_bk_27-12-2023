page 50041 "Specification Values"
{

    ApplicationArea = All;
    Caption = 'Specification Values';
    PageType = List;
    SourceTable = "Specification Values";

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

                field("Code"; Rec."Value")
                {
                    ToolTip = 'Specifies the Specification value.';
                }
            }
        }
    }
}
