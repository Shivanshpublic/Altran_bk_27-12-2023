PAGE 50002 "Shipment Tracking Subform"
{
    PageType = ListPart;
    SourceTable = "Tracking Shipment Line";
    DelayedInsert = TRUE;
    MultipleNewLines = TRUE;
    AutoSplitKey = TRUE;
    LinksAllowed = FALSE;

    LAYOUT
    {
        AREA(Content)
        {
            REPEATER(GroupName)
            {
                FIELD("Tracking Code"; Rec."Tracking Code")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                FIELD("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                }
                field("PO Line No."; Rec."PO Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO Line No. field.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                }
                field("Receipt Line No."; Rec."Receipt Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Line No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("PO Quantity"; Rec."PO Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Order Quantity field.';
                }
                field("Shipped Quantity"; Rec."Shipped Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipped Quantity field.';
                }
                field("Pallet Quantity"; Rec."Pallet Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pallet Quantity field.';
                }
                FIELD("Total CBM"; Rec."Total CBM")
                {
                    ApplicationArea = All;
                }
                FIELD("Total Gross (KG)"; Rec."Total Gross (KG)")
                {
                    ApplicationArea = All;
                }
                FIELD("Buy From Vendor No."; Rec."Buy From Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                FIELD("Buy From Vendor Name"; Rec."Buy From Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                FIELD("Date of Dispatch"; Rec."Date of Dispatch")
                {
                    ApplicationArea = All;
                }
                FIELD("Delivery Lead Time"; Rec."Delivery Lead Time")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                FIELD("Date of Arrival"; Rec."Date of Arrival")
                {
                    ApplicationArea = All;
                }
                FIELD("Delayed by Days"; Rec."Delayed by Days")
                {
                    ApplicationArea = All;
                }
                FIELD("Allocate Surcharge"; Rec."Allocate Surcharge")
                {
                    ApplicationArea = All;
                }
                FIELD("Shipment Cost"; Rec."Shipment Cost")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}