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
    Permissions = TableData "Purch. Cr. Memo Line" = rm, TableData "Purch. Inv. Line" = rm,
TableData "Return Shipment Line" = rm, TableData "Purch. Rcpt. Line" = rm,
TableData "Sales Cr.Memo Line" = rm, TableData "Sales Shipment Line" = rm,
TableData "Return Receipt Line" = rm, TableData "Sales Invoice Line" = rm;

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
                action("Update Purchase PO/Rcpt")
                {
                    ApplicationArea = All;
                    Caption = 'Update PO No., PO Line No., Rcpt No., Rcpt Line No.';
                    ToolTip = 'Update PO No., PO Line No., Rcpt No., Rcpt Line No. from Shipment Tracking.';

                    trigger OnAction()
                    var
                        i: Integer;
                        PurchHeaderArchive: Record "Purchase Header Archive";
                        PurchLineArchive: Record "Purchase Line Archive";
                        PRH: Record "Purch. Rcpt. Header";
                        PRL: Record "Purch. Rcpt. Line";
                        PHA: Record "Purchase Header Archive";
                        PLA: Record "Purchase Line Archive";
                        PH: Record "Purchase Header";
                        PL: Record "Purchase Line";
                        ShipmentTrackingHeader: Record "Tracking Shipment Header";
                        ShipmentTrackingLine: Record "Tracking Shipment Line";
                    begin
                        if ShipmentTrackingLine.FindFirst() then
                            repeat
                                PRL.SetRange("Document No.", ShipmentTrackingLine."Receipt No.");
                                PRL.SetRange("Line No.", ShipmentTrackingLine."Receipt Line No.");
                                if PRL.FindFirst() then
                                    repeat
                                        if PRL."Shipment Tracking Code" = '' then
                                            PRL."Shipment Tracking Code" := ShipmentTrackingLine."Tracking Code";
                                        if PRL."Shipment Tracking Line No." = 0 then
                                            PRL."Shipment Tracking Line No." := ShipmentTrackingLine."Line No.";
                                        PRL.Modify();
                                        i += 1;
                                    until PRL.Next() = 0;

                                PLA.SetRange("Document Type", PLA."Document Type"::Order);
                                PLA.SetRange("Document No.", ShipmentTrackingLine."PO No.");
                                PLA.SetRange("Line No.", ShipmentTrackingLine."PO Line No.");
                                if PLA.FindFirst() then
                                    repeat
                                        if PLA."Shipment Tracking Code" = '' then
                                            PLA."Shipment Tracking Code" := ShipmentTrackingLine."Tracking Code";
                                        if PLA."Shipment Tracking Line No." = 0 then
                                            PLA."Shipment Tracking Line No." := ShipmentTrackingLine."Line No.";
                                        PLA.Modify();
                                        i += 1;
                                    until PLA.Next() = 0;

                                PL.SetRange("Document Type", PL."Document Type"::Order);
                                PL.SetRange("Document No.", ShipmentTrackingLine."PO No.");
                                PL.SetRange("Line No.", ShipmentTrackingLine."PO Line No.");
                                if PL.FindFirst() then
                                    repeat
                                        if PL."Shipment Tracking Code" = '' then
                                            PL."Shipment Tracking Code" := ShipmentTrackingLine."Tracking Code";
                                        if PL."Shipment Tracking Line No." = 0 then
                                            PL."Shipment Tracking Line No." := ShipmentTrackingLine."Line No.";
                                        PL.Modify();
                                        i += 1;
                                    until PL.Next() = 0;
                                if ShipmentTrackingLine."Item No." = '' then begin
                                    if PRL.Get(ShipmentTrackingLine."Receipt No.", ShipmentTrackingLine."Receipt Line No.") then begin
                                        ShipmentTrackingLine."Item No." := PRL."No.";
                                        ShipmentTrackingLine.Description := PRL.Description;
                                        ShipmentTrackingLine."Total CBM" := PRL."Total CBM";
                                        ShipmentTrackingLine."Total Gross (KG)" := PRL."Total Gross (KG)";
                                        ShipmentTrackingLine."Pallet Quantity" := PRL."Gross Weight";
                                        //"Pallet Quantity" := PurchRcptLine."Pallet Quantity";
                                        ShipmentTrackingLine."Total Net (KG)" := PRL."Total Net (KG)";
                                        ShipmentTrackingLine."Buy From Vendor No." := PRL."Buy-from Vendor No.";
                                        ShipmentTrackingLine."Buy From Vendor Name" := PRL."Buy-from Vendor Name";
                                        if ShipmentTrackingHeader.Get(ShipmentTrackingLine."Tracking Code") then begin
                                            PRL."Milestone Status" := ShipmentTrackingHeader."Milestone Status";
                                        end;
                                        ShipmentTrackingLine."PO Quantity" := PRL.Quantity;
                                        PRL.Modify();
                                    end;
                                end;
                                if ShipmentTrackingLine."PO Line No." <> 0 then
                                    if ShipmentTrackingLine."Receipt Line No." = 0 then
                                        ShipmentTrackingLine."Receipt Line No." := ShipmentTrackingLine."PO Line No.";
                                ShipmentTrackingLine.Modify();
                            until ShipmentTrackingLine.Next() = 0;

                        if i > 0 then
                            Message('%1 recordes updated.', i);
                    end;
                }
                action("Update Purchase Archive")
                {
                    ApplicationArea = All;
                    Caption = 'Update Purchase Archive';
                    ToolTip = 'Update Purchase Archive Data from Purchase Receipt Line.';

                    trigger OnAction()
                    var
                        i: Integer;
                        PurchHeaderArchive: Record "Purchase Header Archive";
                        PurchLineArchive: Record "Purchase Line Archive";
                        PRH: Record "Purch. Rcpt. Header";
                        PRL: Record "Purch. Rcpt. Line";
                        ShipmentTrackingHeader: Record "Tracking Shipment Header";
                        ShipmentTrackingLine: Record "Tracking Shipment Line";
                    begin
                        PurchHeaderArchive.Reset();
                        PurchHeaderArchive.SetRange("Document Type", PurchHeaderArchive."Document Type"::Order);
                        If PurchHeaderArchive.FindFirst() then
                            repeat
                                PRH.SetRange("Order No.", PurchHeaderArchive."No.");
                                If PRH.FindFirst() then
                                    Repeat
                                        if PurchHeaderArchive."Country of Origin" = '' then
                                            PurchHeaderArchive."Country of Origin" := PRH."Country of Origin";
                                        if PurchHeaderArchive."Country of provenance" = '' then
                                            PurchHeaderArchive."Country of provenance" := PRH."Country of provenance";
                                        if PurchHeaderArchive."Country of Acquisition" = '' then
                                            PurchHeaderArchive."Country of Acquisition" := PRH."Country of Acquisition";
                                        if PurchHeaderArchive."Milestone Status" = '' then
                                            PurchHeaderArchive."Milestone Status" := PRH."Milestone Status";
                                        if PurchHeaderArchive.VIA = '' then
                                            PurchHeaderArchive.VIA := PRH.VIA;
                                        if PurchHeaderArchive."Creation Date" = 0D then
                                            PurchHeaderArchive."Creation Date" := PRH."Order Date";
                                        //Shipment Tracking
                                        ShipmentTrackingHeader.Reset();
                                        ShipmentTrackingLine.SetRange("Receipt No.", PRH."No.");
                                        if ShipmentTrackingLine.FindFirst() then begin
                                            ShipmentTrackingHeader.Get(ShipmentTrackingLine."Tracking Code");
                                            PurchLineArchive."Milestone Status" := ShipmentTrackingHeader."Milestone Status";
                                        end;

                                        PurchHeaderArchive.Modify();
                                        i += 1;

                                    until PRH.Next() = 0;
                            until PurchHeaderArchive.Next() = 0;

                        PurchLineArchive.Reset();
                        PurchLineArchive.SetRange("Document Type", PurchLineArchive."Document Type"::Order);
                        If PurchLineArchive.FindFirst() then
                            repeat
                                PRL.SetRange("Order No.", PurchLineArchive."Document No.");
                                PRL.SetRange("Line No.", PurchLineArchive."Line No.");
                                If PRL.FindFirst() then
                                    Repeat
                                        if PurchLineArchive."SO No." = '' then
                                            PurchLineArchive."SO No." := PRL."SO No.";
                                        if PurchLineArchive."SO Line No." = 0 then
                                            PurchLineArchive."SO Line No." := PRL."SO Line No.";
                                        if PurchLineArchive."HS Code" = '' then
                                            PurchLineArchive."HS Code" := PRL."HS Code";
                                        if PurchLineArchive."HTS Code" = '' then
                                            PurchLineArchive."HTS Code" := PRL."HTS Code";
                                        if PurchLineArchive."No. of Packages" = 0 then
                                            PurchLineArchive."No. of Packages" := PRL."No. of Packages";
                                        if PurchLineArchive."Total Gross (KG)" = 0 then
                                            PurchLineArchive."Total Gross (KG)" := PRL."Total Gross (KG)";
                                        if PurchLineArchive."Total CBM" = 0 then
                                            PurchLineArchive."Total CBM" := PRL."Total CBM";
                                        if PurchLineArchive."Total Net (KG)" = 0 then
                                            PurchLineArchive."Total Net (KG)" := PRL."Total Net (KG)";
                                        if PurchLineArchive."Port of Load" = '' then
                                            PurchLineArchive."Port of Load" := PRL."Port of Load";
                                        if PurchLineArchive."Port of Discharge" = '' then
                                            PurchLineArchive."Port of Discharge" := PRL."Port of Discharge";
                                        if PurchLineArchive."Country of Origin" = '' then
                                            PurchLineArchive."Country of Origin" := PRL."Country of Origin";
                                        if PurchLineArchive."Pallet Quantity" = 0 then
                                            PurchLineArchive."Pallet Quantity" := PRL."Pallet Quantity";
                                        if PurchLineArchive."Shipment Tracking Code" = '' then
                                            PurchLineArchive."Shipment Tracking Code" := PRL."Shipment Tracking Code";
                                        if PurchLineArchive."Shipment Tracking Line No." = 0 then
                                            PurchLineArchive."Shipment Tracking Line No." := PRL."Shipment Tracking Line No.";
                                        if PurchLineArchive."Rev." = '' then
                                            PurchLineArchive."Rev." := PRL."Rev.";
                                        if PurchLineArchive."Buy-from Vendor Name" = '' then
                                            PurchLineArchive."Buy-from Vendor Name" := PRL."Buy-from Vendor Name";
                                        if PurchLineArchive."Expected Receipt Date1" = 0D then
                                            PurchLineArchive."Expected Receipt Date1" := PRL."Expected Receipt Date";
                                        if PurchLineArchive."UL Certificate Available" = false then
                                            PurchLineArchive."UL Certificate Available" := PRL."UL Certificate Available";
                                        if PurchLineArchive."Order Note" = '' then
                                            PurchLineArchive."Order Note" := PRL."Order Note";
                                        if PurchLineArchive."Country of Origin" = '' then
                                            PurchLineArchive."Country of Origin" := PRL."Country of Origin";
                                        if PurchLineArchive."Country of provenance" = '' then
                                            PurchLineArchive."Country of provenance" := PRL."Country of provenance";
                                        if PurchLineArchive."Country of Acquisition" = '' then
                                            PurchLineArchive."Country of Acquisition" := PRL."Country of Acquisition";
                                        if PurchLineArchive."Milestone Status" = '' then
                                            PurchLineArchive."Milestone Status" := PRL."Milestone Status";
                                        if PurchLineArchive.VIA = '' then
                                            PurchLineArchive.VIA := PRL.VIA;
                                        if PurchLineArchive."Creation Date" = 0D then
                                            PurchLineArchive."Creation Date" := PRL."Order Date";

                                        //Shipment Tracking
                                        ShipmentTrackingHeader.Reset();
                                        ShipmentTrackingLine.Reset();
                                        ShipmentTrackingLine.SetRange("Receipt No.", PRL."Document No.");
                                        ShipmentTrackingLine.SetRange("Receipt Line No.", PRL."Line No.");
                                        ShipmentTrackingLine.SetRange("Item No.", PRL."No.");
                                        if ShipmentTrackingLine.FindFirst() then begin
                                            ShipmentTrackingHeader.Get(ShipmentTrackingLine."Tracking Code");
                                            PurchLineArchive."Milestone Status" := ShipmentTrackingHeader."Milestone Status";
                                        end;
                                        PurchLineArchive.Modify();
                                        i += 1;

                                    until PRL.Next() = 0;
                            until PurchLineArchive.Next() = 0;

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

