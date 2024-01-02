page 50007 "Cost & Selling Price Calc"
{
    Caption = 'Cost & Selling Price Calc';
    PageType = List;
    SourceTable = "Cost & Selling Price Calc";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Editable = false;
                }
                field("Tariff Applies"; Rec."Tariff Applies")
                {
                    ApplicationArea = All;
                }
                field("Customer is in USA"; Rec."Customer is in USA")
                {
                    ApplicationArea = All;
                    Caption = 'Customer is in USA (Tariff)';
                }
                field("Vendor is in China"; Rec."Vendor is in China")
                {
                    ApplicationArea = All;
                }
                field("Duties Apply"; Rec."Duties Apply")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer is in USA (Duties)"; Rec."Customer is in USA (Duties)")
                {
                    ApplicationArea = All;
                    //  Caption = 'Customer is in USA';
                }
                field("Special Taxes"; Rec."Special Taxes")
                {
                    ApplicationArea = All;
                }
                field("Estimated Annual Usage"; Rec."Estimated Annual Usage")
                {
                    ApplicationArea = All;
                }
                field("No. of items/pallet"; Rec."No. of items/pallet")
                {
                    ApplicationArea = All;
                    //Visible = StandardFields;
                    Enabled = StandardFields;
                }
                field("Used Shipping Cost/Container"; Rec."Used Shipping Cost/Container")
                {
                    ApplicationArea = All;
                    // Visible = StandardFields;
                    Enabled = StandardFields;
                }
                field("Number of Pallets/Container"; Rec."Number of Pallets/Container")
                {
                    ApplicationArea = All;
                    // Visible = StandardFields;
                    Enabled = StandardFields;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Shipping Type"; Rec."Shipping Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetControl();
                    end;
                }
                field("Item Volume Code"; Rec."Item Volume Code")
                {
                    ApplicationArea = All;
                    //Visible = LCLFields;
                    Enabled = LCLFields;
                    ToolTip = 'Specifies the value of the Item Volume field.';
                }
                field("Box Volume in CBM"; Rec."Box Volume in CBM")
                {
                    ApplicationArea = All;
                    //Visible = LCLFields;
                    Enabled = LCLFields;
                    ToolTip = 'Specifies the value of the Box Volume in CBM field.';
                }
                field("Items Per Box"; Rec."Items Per Box")
                {
                    ApplicationArea = All;
                    //Visible = LCLFields;
                    Enabled = LCLFields;
                    ToolTip = 'Specifies the value of the Items Per Box field.';
                }

                field("Item Volume in CBM"; Rec."Item Volume in CBM")
                {
                    ApplicationArea = All;
                    //Visible = LCLFields;
                    Enabled = LCLFields;
                    ToolTip = 'Specifies the value of the Item Volume in CBM field.';
                }
                field("LCL Cost per CBM"; Rec."LCL Cost per CBM")
                {
                    ApplicationArea = All;
                    //Visible = LCLFields;
                    Enabled = LCLFields;
                    ToolTip = 'Specifies the value of the LCL Cost per CBM field.';
                }

                field("Item Weight in KG"; Rec."Item Weight in KG")
                {
                    ApplicationArea = All;
                    //Visible = FreightFields;
                    Enabled = FreightFields;
                    ToolTip = 'Specifies the value of the Item Weight in KG field.';
                }
                field("Air Freight Cost per KG"; Rec."Air Freight Cost per KG")
                {
                    ApplicationArea = All;
                    //Visible = FreightFields;
                    Enabled = FreightFields;
                    ToolTip = 'Specifies the value of the Air Freight Cost per KG field.';
                }
            }
            repeater(content02)
            {
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Product Category"; Rec."Product Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Altran Part #"; Rec."Altran Part #")
                {
                    ApplicationArea = All;
                }
                field("Customer Part #"; Rec."Customer Part #")
                {
                    ApplicationArea = All;
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = All;
                }
                field(Tariff; Rec.Tariff)
                {
                    ApplicationArea = All;
                }
                field(Duties; Rec.Duties)
                {
                    ApplicationArea = All;
                }
                field("Special taxes/expenses"; Rec."Special taxes/expenses")
                {
                    ApplicationArea = All;
                }
                field(Shipping; Rec.Shipping)
                {
                    ApplicationArea = All;
                }
                field("Total Estimated Landed cost"; Rec."Total Estimated Landed cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Calcuate")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                begin
                    Rec.CalculateValues();
                end;
            }
            action("Recalcuate")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    Rec.CalculateValues();
                    Rec.CalcLandedCostAndSaveLog();
                end;
            }

            action("Log")
            {
                ApplicationArea = All;
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Cost & Price Log";
                RunPageLink = "Item No." = field("Item No.");
                trigger OnAction()
                begin
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        //Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Item No." := Rec."Item No.";
            if Rec.Insert() then;
        end;

    end;

    trigger OnAfterGetRecord()
    begin
        SetControl();
    end;

    local procedure SetControl()
    begin
        if Rec."Shipping Type" = Rec."Shipping Type"::"Standard Shipping to Sterling" then begin
            StandardFields := true;
            FreightFields := false;
            LCLFields := false;
        end
        else
            if Rec."Shipping Type" = Rec."Shipping Type"::"Less than Container Load (LCL)" then begin
                LCLFields := true;
                FreightFields := false;
                StandardFields := false;
            end
            else
                if Rec."Shipping Type" = Rec."Shipping Type"::"Air Freight" then begin
                    FreightFields := true;
                    StandardFields := false;
                    LCLFields := false;
                end
                else begin
                    FreightFields := false;
                    StandardFields := false;
                    LCLFields := false;
                end;

    end;

    var
        LCLFields, FreightFields, StandardFields : Boolean;
}
