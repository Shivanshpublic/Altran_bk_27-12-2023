page 50040 "Specification List"
{

    ApplicationArea = All;
    Caption = 'Specification';
    PageType = List;
    SourceTable = Specification;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Specification; Rec.Specification)
                {
                    ToolTip = 'Specifies the Specification value.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action("SpecificationValues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Specification Values';
                Image = ListPage;
                RunObject = Page "Specification Values";
                RunPageLink = "Specification" = FIELD(Specification);
                ToolTip = 'Set up the different specification values.';
            }
        }

    }

}
