pageextension 50052 ProjectManagerCue extends "Project Manager Activities"
{
    layout
    {
        addbefore(Invoicing)
        {
            cuegroup("Quantity of Products")
            {
                Caption = 'Quantity of Products';
                field("Quantity in-Transit"; Rec."Quantity in-Transit")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products in-Transit.';
                }
                field("Quantity In-Production"; Rec."Quantity In-Production")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products In-Production.';
                }
                field("Quantity Pending to Ship"; Rec."Quantity Pending to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Pending to Ship.';
                }
                field("Quantity Needs Action"; Rec."Quantity Needs Action")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Needs Action.';
                }
                field("Quantity Booked"; Rec."Quantity Booked")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Booked.';
                }
                field("Quantity Arrived at Warehouse"; Rec."Quantity Arr. at Warehouse")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Arrived at Warehouse.';
                }
                field("Quantity TLX Released Required"; Rec."Quantity TLX Released Required")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products TLX Released Required.';
                }
                field("Quantity ARRIVED - CUST"; Rec."Quantity ARRIVED - CUST")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products ARRIVED - CUST.';
                }
                field("Quantity ARRIVED - POD"; Rec."Quantity ARRIVED - POD")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products ARRIVED - POD.';
                }
                field("Quantity at Sterling"; Rec."Quantity at Sterling")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                    ToolTip = 'Specifies the value of Products at Sterling.';
                }
                field("Quantity at POL"; Rec."Quantity at POL")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                    ToolTip = 'Specifies the value of Products at POL.';
                }
                field("Quantity Open Sales Orders"; Rec."Quantity of Open Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Lines";
                    ToolTip = 'Specifies the value of Open Sales Orders.';
                }
                field("Open Purchase Orders"; Rec."Qty. of Open Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Open Purchase Orders.';
                }
                field("Posted Sales Invoice"; Rec."Qty. of Posted Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Invoice Lines";
                    ToolTip = 'Specifies the value of Posted Sales Invoice.';
                }
                field("Posted Sales Cr.Memo"; Rec."Qty. of Post. Sales Cr. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Credit Memo Lines";
                    ToolTip = 'Specifies the value of Posted Sales Cr. Memo.';
                }
                field("Posted Purchase Invoice"; Rec."Qty. of Posted Purch. Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Purchase Invoice Lines";
                    ToolTip = 'Specifies the value of Posted Purchase Invoice.';
                }
                field("Posted Purchase Cr.Memo"; Rec."Qty. of Post. Purch. Cr.Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Purchase Cr. Memo Lines";
                    ToolTip = 'Specifies the value of Posted Purchase Cr. Memo.';
                }
                field("Open Sales Quotes"; Rec."Quantity of Open Sales Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Lines";
                    ToolTip = 'Specifies the value of Open Sales Quotes.';
                }

                field("Products Per Location"; Rec."Total Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Quantities Per Location';
                    DrillDownPageID = "Items by Location";
                    ToolTip = 'Specifies the value of Total Quantities Per Location.';

                    trigger OnDrillDown()
                    var
                        PagProdPerLocation: Page "Items by Location";
                    begin
                        Clear(PagProdPerLocation);
                        PagProdPerLocation.RunModal();
                    end;
                }

            }
            cuegroup("Value of Products")
            {
                Caption = 'Value of Products';
                field("Value in-Transit"; Rec."Value in-Transit")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products in-Transit.';
                }
                field("Value In-Production"; Rec."Value In-Production")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products In-Production.';
                }
                field("Value Pending to Ship"; Rec."Value Pending to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Pending to Ship.';
                }
                field("Value Needs Action"; Rec."Value Needs Action")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Needs Action.';
                }
                field("Value Booked"; Rec."Value Booked")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Booked.';
                }
                field("Value Arrived at Warehouse"; Rec."Value Arrived at Warehouse")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Arrived at Warehouse.';
                }
                field("Value TLX Released Required"; Rec."Value TLX Released Required")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products TLX Released Required.';
                }
                field("Value ARRIVED - CUST"; Rec."Value ARRIVED - CUST")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products ARRIVED - CUST.';
                }
                field("Value ARRIVED - POD"; Rec."Value ARRIVED - POD")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products ARRIVED - POD.';
                }
                field("Value at Sterling"; Rec."Value at Sterling")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Value Entries";
                    ToolTip = 'Specifies the value of Products at Sterling.';
                }
                field("Value at POL"; Rec."Value at POL")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Value Entries";
                    ToolTip = 'Specifies the value of Products at POL.';
                }
                field("Value of Open Sales Orders"; Rec."Value of Open Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Lines";
                    ToolTip = 'Specifies the value of Open Sales Orders.';
                }
                field("Value of Open Purchase Orders"; Rec."Value of Open Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Open Purchase Orders.';
                }
                field("Value of Posted Sales Invoice"; Rec."Value of Posted Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Invoice Lines";
                    ToolTip = 'Specifies the value of Posted Sales Invoice.';
                }
                field("Value of Posted Sales Cr.Memo"; Rec."Value of Posted Sales Cr. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Credit Memo Lines";
                    ToolTip = 'Specifies the value of Posted Sales Cr. Memo.';
                }
                field("Value of Posted Purch. Invoice"; Rec."Value of Posted Purch. Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Purchase Invoice Lines";
                    ToolTip = 'Specifies the value of Posted Purchase Invoice.';
                }
                field("Value of Posted Purch. Cr.Memo"; Rec."Value of Posted Purch. Cr.Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Purchase Cr. Memo Lines";
                    ToolTip = 'Specifies the value of Posted Purchase Cr. Memo.';
                }
                field("Value of Open Sales Quotes"; Rec."Value of Open Sales Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Lines";
                    ToolTip = 'Specifies the value of Open Sales Quotes.';
                }
            }
        }
    }

    actions
    {
        addafter("Set Up Cues")
        {

        }
    }
    trigger OnOpenPage()
    var
        Expr1: Text[30];
        Expr2: Text[30];
        RefDate: Date;
        StartDate: Date;
        EndDate: Date;
    begin
        RefDate := WorkDate();//19960521D;
        StartDate := DMY2Date(01, Date2DMY(RefDate, 2), Date2DMY(RefDate, 3));
        EndDate := CalcDate('<+1M-1D>', StartDate);
        Rec.SetRange("Date Filter3", StartDate, EndDate);
    end;

    var
        ProdPerLocation: Integer;


}
