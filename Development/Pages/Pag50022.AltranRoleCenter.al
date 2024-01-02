page 50022 "Altran Role Center"
{
    Caption = 'Manager';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                /*
                part(Control99; "Finance Performance")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part(Control1902304208; "Account Manager Activities")
                {
                    ApplicationArea = Basic, Suite;
                }
                part("User Tasks Activities"; "User Tasks Activities")
                {
                    ApplicationArea = Suite;
                }
                part(Control1907692008; "My Customers")
                {
                    ApplicationArea = Basic, Suite;
                }
                */
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

}

