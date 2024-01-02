pageextension 50049 GetPurchRcptLines extends "Get Receipt Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Description21"; Rec."Description 2")
            {
                ApplicationArea = all;
                Caption = 'Model No.';
            }
            field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
            }
            field("Shipment Tracking Line No."; Rec."Shipment Tracking Line No.")
            {
                ApplicationArea = all;
            }
            field("Pallet Quantity"; Rec."Pallet Quantity")
            {
                ApplicationArea = all;
            }
            field("Line Amount"; Rec."Unit Cost" * Rec.Quantity)
            {
                ApplicationArea = All;
            }
            field("Milestone Status"; Rec."Milestone Status")
            {
                ApplicationArea = All;
            }
            field("VIA"; Rec."VIA")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the VIA.';
            }
        }
        addafter("No.")
        {
            field("Cross-Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = All;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shipment Tracking Code")
        {
            field(VendorName; VendorName)
            {
                ApplicationArea = All;
                Caption = 'Vendor Name';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RecVendor: Record Vendor;
    begin
        Clear(RecVendor);
        Clear(VendorName);
        if RecVendor.GET(Rec."Buy-from Vendor No.") then begin
            VendorName := RecVendor.Name;
        end;
    end;

    var
        VendorName: Text;
        PurchOrderNumber: Text;
}
