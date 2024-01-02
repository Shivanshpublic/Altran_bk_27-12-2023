pageextension 50054 AccountMgrRoleCenter extends "Accounting Manager Role Center"
{
    layout
    {
        addafter(Control1900724808)
        {
            group(Control150029)
            {
                ShowCaption = false;

                part(Control50028; "ST Processor Activities Qty")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = True;
                }
            }
            group(Control150129)
            {
                ShowCaption = false;

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
