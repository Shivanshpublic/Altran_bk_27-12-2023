page 50009 "Calculate Selling Price"
{
    Caption = 'Calculate Selling Price';
    PageType = List;
    SourceTable = "Calculate Selling Price";
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                    Editable = false;
                }
                field("Total Est. Landed Cost"; Rec."Total Est. Landed Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Est. Landed Cost field.';
                    Editable = false;
                }
                field("Profit Margin %"; Rec."Profit Margin %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Profit Margin % field.';
                }
                field("Profit Margin"; Rec."Profit Margin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Profit Margin field.';
                }
                field("Suggested Selling Price"; Rec."Suggested Selling Price")
                {
                    ApplicationArea = All;
                    //Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Update Selling Price")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Price;
                trigger OnAction()
                var
                    Sline: Record "Sales Line";
                    calcSellingPrice: Record "Calculate Selling Price";
                begin
                    if not Confirm('Do you want to update Unit Price of Sales Quote ' + Rec."Document No.", false) then exit;
                    Clear(calcSellingPrice);
                    calcSellingPrice.SetRange("Document No.", Rec."Document No.");
                    if calcSellingPrice.FindSet() then begin
                        repeat
                            Clear(Sline);
                            Sline.SetRange("Document Type", Sline."Document Type"::Quote);
                            Sline.SetRange("Document No.", Rec."Document No.");
                            Sline.SetRange("Line No.", Rec."Line No.");
                            Sline.SetRange("No.", Rec."Item No.");
                            if Sline.FindFirst() then begin
                                Sline.Validate("Unit Price", calcSellingPrice."Suggested Selling Price");
                                Sline.Modify(true);
                            end;
                        until calcSellingPrice.Next() = 0;
                        Rec.CreateLogEntries();
                        Message('Suggested Selling Price has been updated in Sales Quote %1', Rec."Document No.");
                    end;
                end;
            }

            action("Log")
            {
                ApplicationArea = All;
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Selling Price Log";
                RunPageLink = "Document No." = field("Document No.");
                trigger OnAction()
                begin
                end;
            }
        }
    }
}
