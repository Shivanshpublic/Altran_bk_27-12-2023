pageextension 50053 CEOPresidentRoleCenter extends "CEO and President Role Center"
{
    layout
    {

        addafter(Control1900724708)
        {
            group(Control50029)
            {
                ShowCaption = false;
                part(Control50028; "ST Processor Activities Qty")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = True;
                }
                part(Control50030; "ST Processor Activities Value")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = True;
                }
            }
        }
    }

    actions
    {
    }

    var
        ProdPerLocation: Integer;


}
