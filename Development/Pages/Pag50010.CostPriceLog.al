page 50010 "Cost & Price Log"
{
    Caption = 'Cost & Price Log';
    SourceTable = "Cost & Price Log";
    ModifyAllowed = false;
    InsertAllowed = false;
    PageType = List;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UserId field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Description field.';
                }
                field("Product Category"; Rec."Product Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Category field.';
                }
                field("Altran Part #"; Rec."Altran Part #")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Altran Part # field.';
                }
                field("Customer Part #"; Rec."Customer Part #")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Part # field.';
                }
                field("Customer is in USA"; Rec."Customer is in USA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer is in USA field.';
                }
                field("Customer is in USA (Duties)"; Rec."Customer is in USA (Duties)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer is in USA (Duties) field.';
                }
                field(Duties; Rec.Duties)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duties field.';
                }
                field("Duties Apply"; Rec."Duties Apply")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duties Apply field.';
                }
                field("Estimated Annual Usage"; Rec."Estimated Annual Usage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Estimated Annual Usage field.';
                }
                field("No. of items/pallet"; Rec."No. of items/pallet")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of items/pallet field.';
                }
                field("Number of Pallets/Container"; Rec."Number of Pallets/Container")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number of Pallets/Container field.';
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost field.';
                }

                field("Special Taxes"; Rec."Special Taxes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special Taxes field.';
                }
                field(Shipping; Rec.Shipping)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipping field.';
                }
                field("Special taxes/expenses"; Rec."Special taxes/expenses")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special taxes/expenses field.';
                }
                field("Used Shipping Cost/Container"; Rec."Used Shipping Cost/Container")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Used Shipping Cost/Container field.';
                }
                field("Vendor is in China"; Rec."Vendor is in China")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor is in China field.';
                }

                field("Tariff Applies"; Rec."Tariff Applies")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tariff Applies field.';
                }
                field(Tariff; Rec.Tariff)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tariff field.';
                }
                field("Total Estimated Landed cost"; Rec."Total Estimated Landed cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Estimated Landed cost field.';
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Clear Log")
            {
                ApplicationArea = All;
                Image = DeleteAllBreakpoints;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = report "Clear Cost & Price Log";
                trigger OnAction()
                begin
                end;
            }
        }
    }
}
