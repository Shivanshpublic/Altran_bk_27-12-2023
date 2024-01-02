pageextension 50021 SalespersonExt extends "Salesperson/Purchaser Card"
{
    layout
    {
    }

    actions
    {
        addfirst(processing)
        {
            action("Commission")
            {
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Salesperson Commission";
                RunPageLink = "Salesperson Code" = field("Code");
                trigger OnAction()
                begin

                end;
            }
        }
    }
}
