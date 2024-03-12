page 50024 "Update Batch"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Update batch';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,General,Posting,Journal Templates';
    SourceTable = "Inventory Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
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
                action("Update Shipment Tracking Line")
                {
                    ApplicationArea = All;
                    Caption = 'Update Vendor No. & Name';
                    ToolTip = 'Update Vendor No. & Name on shipment tracking line from PO or receipt';

                    trigger OnAction()
                    var
                        i: Integer;
                        PurchLine: Record "Purchase Line";
                        PurchHead: Record "Purchase Header";
                        PurchRcptHead: Record "Purch. Rcpt. Header";
                        ShipmentTrackingLine: Record "Tracking Shipment Line";
                    begin
                        ShipmentTrackingLine.SetFilter("PO No.", '<>%1', '');
                        if ShipmentTrackingLine.FindFirst() then
                            repeat
                                if PurchHead.Get(PurchLine."Document Type"::Order, ShipmentTrackingLine."PO No.") then begin
                                    if ShipmentTrackingLine."Buy From Vendor No." = '' then begin
                                        ShipmentTrackingLine."Buy From Vendor No." := PurchHead."Buy-from Vendor No.";
                                        ShipmentTrackingLine."Buy From Vendor Name" := PurchHead."Buy-from Vendor Name";
                                        ShipmentTrackingLine.Modify();
                                        i += 1;
                                    end;
                                end else
                                    if PurchRcptHead.Get(ShipmentTrackingLine."Receipt No.") then begin
                                        if ShipmentTrackingLine."Buy From Vendor No." = '' then begin
                                            ShipmentTrackingLine."Buy From Vendor No." := PurchRcptHead."Buy-from Vendor No.";
                                            ShipmentTrackingLine."Buy From Vendor Name" := PurchRcptHead."Buy-from Vendor Name";
                                            ShipmentTrackingLine.Modify();
                                            i += 1;
                                        end;
                                    end;
                            until ShipmentTrackingLine.Next() = 0;
                        if i > 0 then
                            Message('%1 recordes updated.', i);
                    end;
                }
                action("Update Item")
                {
                    ApplicationArea = All;
                    Caption = 'Update Vendor No. & Country of Origin';
                    ToolTip = 'Update Vendor Name & Country of Origin from Item based on Vendor No. selected.';

                    trigger OnAction()
                    var
                        i: Integer;
                        Vendor: Record Vendor;
                        Item: Record Item;
                    begin
                        Item.SetFilter("Vendor No.", '<>%1', '');
                        if Item.FindFirst() then
                            repeat
                                if Vendor.Get(Item."Vendor No.") then begin
                                    Item."Vendor Name" := Vendor.Name;
                                    Item."Country of Origin" := Vendor."Country/Region Code";
                                    Item.Modify();
                                    i += 1;
                                end;
                            until Item.Next() = 0;
                        if i > 0 then
                            Message('%1 recordes updated.', i);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
    end;


    var
}

