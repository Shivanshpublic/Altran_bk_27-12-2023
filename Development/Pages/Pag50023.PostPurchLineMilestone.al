page 50023 "Posted Purch. Milestone Update"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purch. Inv. Line";
    Permissions = tabledata 123 = rm;
    Caption = 'Posted Purchase Invoice Milestone Status Update';
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Milestone Status"; rec."Milestone Status")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("PO No."; Rec."Order No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Model No."; Rec."Description 2")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Update Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Update Vendor Name';
                    ToolTip = 'Update Vendor Name for old entries.';

                    trigger OnAction()
                    var
                        RecVendor: Record Vendor;
                        i: Integer;
                        PurchInvLine: Record "Purch. Inv. line";
                    begin
                        PurchInvLine.SetFilter("Buy-from Vendor Name", '%1', '');
                        if PurchInvLine.FindFirst() then
                            repeat
                                if RecVendor.Get(PurchInvLine."Buy-from Vendor No.") then begin
                                    PurchInvLine."Buy-from Vendor Name" := RecVendor.Name;
                                    PurchInvLine.Modify();
                                    i += 1;
                                end;
                            until PurchInvLine.Next() = 0;
                        if i > 0 then
                            Message('%1 recordes updated.', i);
                    end;
                }
            }
        }
    }

}
