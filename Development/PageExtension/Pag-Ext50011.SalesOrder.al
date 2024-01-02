PAGEEXTENSION 50011 "Ext. Sales Order" EXTENDS "Sales Order"
{
    LAYOUT
    {
        ADDAFTER("Salesperson Code")
        {
            FIELD("Internal Team"; Rec."Internal Team")
            {
                ApplicationArea = All;
            }
            FIELD("External Rep"; Rec."External Rep")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("Country of Origin"; Rec."Country of Origin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of Origin field.';
            }
            field("Country of provenance"; Rec."Country of provenance")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of provenance field.';
            }
            field("Country of Acquisition"; Rec."Country of Acquisition")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of Acquisition field.';
            }
            field("Milestone Status"; Rec."Milestone Status")
            {
                ApplicationArea = All;
            }
            field("Sample Order"; Rec."Sample Order")
            {
                ApplicationArea = All;
            }
            field(VIA; Rec.VIA)
            {
                ApplicationArea = All;
            }
        }
        addlast(content)
        {
            group("Consignee")
            {
                field("Consignee Type"; Rec."Consignee Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Type field.';
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee No. field.';
                }
                field("Consignee Name"; Rec."Consignee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Name field.';
                }
                field("Consignee Name 2"; Rec."Consignee Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Name 2 field.';
                }
                field("Consignee Address"; Rec."Consignee Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Address field.';
                }
                field("Consignee Address 2"; Rec."Consignee Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Address 2 field.';
                }
                field("Consignee City"; Rec."Consignee City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee City field.';
                }
                field("Consignee Country/Region code"; Rec."Consignee Country/Region code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Country/Region code field.';
                }

            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action("Show PO Line")
            {
                ApplicationArea = All;
                Image = AllLines;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    POLine: Record "Purchase Line";
                    SoLine: Record "Sales Line";
                begin
                    Clear(POLine);
                    Clear(SoLine);
                    SoLine.SetRange("Document Type", Rec."Document Type");
                    SoLine.SetRange("Document No.", Rec."No.");
                    SoLine.SetFilter("PO No.", '<>%1', '');
                    SoLine.SetFilter("PO Line No.", '<>%1', 0);
                    SoLine.FindSet();
                    repeat
                        POLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                        POLine.SetRange("Document Type", POLine."Document Type"::Order);
                        POLine.SetRange("Document No.", SoLine."PO No.");
                        POLine.SetRange("Line No.", SoLine."PO Line No.");
                        if POLine.FindFirst() then
                            POLine.Mark(true);
                    until SoLine.Next() = 0;

                    POLine.SetRange("Document No.");
                    POLine.MarkedOnly(true);
                    if POLine.Count > 0 then
                        Page.Run(0, POLine);
                end;
            }
        }
    }
}