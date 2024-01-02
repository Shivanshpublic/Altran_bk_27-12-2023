PAGEEXTENSION 50036 "Ext. Sales Invoice" EXTENDS "Sales Invoice"
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
                field(VIA; Rec.VIA)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}