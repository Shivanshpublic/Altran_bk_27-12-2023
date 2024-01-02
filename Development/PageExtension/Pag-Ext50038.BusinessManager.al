pageextension 50038 BusinessManager extends "Business Manager Role Center"
{
    layout
    {
        addafter(Control16)
        {
            group(Control50029)
            {
                ShowCaption = false;

                part(Control50028; "ST Processor Activities Qty")
                {
                    ApplicationArea = Suite;
                    Visible = True;
                }
                part(Control50030; "ST Processor Activities Value")
                {
                    ApplicationArea = Suite;
                    Visible = True;
                }
            }
        }
    }
    actions
    {
        addafter(Action41)
        {
            group(Altran)
            {
                Caption = 'Altran';
                action("Commision Calculator")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commision Calculator';
                    Image = Report;
                    RunObject = Report "Commision Calculator Report";
                    ToolTip = 'Assign Starting & Ending Date filter.';
                }
                action("Daily Import Report CSR")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Daily Import Report CSR';
                    Image = Report;
                    RunObject = Report "Daily Import Report CSR";
                    ToolTip = 'Assign Starting & Ending Date filter.';
                }
                action("Post Surcharge to Earned")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Surcharge to Earned';
                    Image = Report;
                    RunObject = Report "Post Surcharge to Earned";
                    ToolTip = 'Assign Invoice No. or Posting Date filter if want to run for specific data.';
                }
                action("Posted Sales Invoice Line List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoice Line List';
                    Image = ListPage;
                    RunObject = Page "Posted Sales Invoice Line List";
                    ToolTip = 'Shows list of Sales Invoice Lines.';
                }
                action("Custom Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Custom Setup';
                    Image = ListPage;
                    RunObject = Page "Custom Setup";
                    ToolTip = 'Shows Custom Setup for Altran.';
                }
                action("Salesperson Commission")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salesperson Commission';
                    Image = ListPage;
                    RunObject = Page "Salesperson Commission";
                    ToolTip = 'Salesperson Commission List.';
                }
                action("Item Volume")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Volume';
                    Image = ListPage;
                    RunObject = Page "Item Volumes";
                    ToolTip = 'Item Volume List.';
                }
            }
        }
    }
}
