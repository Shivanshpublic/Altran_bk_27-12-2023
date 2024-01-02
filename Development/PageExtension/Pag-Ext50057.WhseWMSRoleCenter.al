pageextension 50057 WhseWMSRoleCenter extends "Whse. WMS Role Center"
{
    layout
    {

        addafter(Control1903327208)
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
