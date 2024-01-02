pageextension 50055 WhseBasicRoleCenter extends "Whse. Basic Role Center"
{
    layout
    {

        addafter("WMS Ship and Receive Activities")
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
