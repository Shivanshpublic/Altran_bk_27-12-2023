pageextension 50056 WhseWorkerWMSRoleCenter extends "Whse. Worker WMS Role Center"
{
    layout
    {

        addafter(Control1901138408)
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
        }

    }

    actions
    {
    }

    var
        ProdPerLocation: Integer;


}
