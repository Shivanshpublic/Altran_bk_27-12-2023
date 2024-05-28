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
                    Visible = false;
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
                    Visible = false;
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
                    Visible = false;
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
                    Visible = false;
                    trigger OnAction()
                    var
                        i: Integer;
                        PurchHeaderArchive: Record "Purchase Header Archive";
                        PurchLineArchive: Record "Purchase Line Archive";
                        PRH: Record "Purch. Rcpt. Header";
                        PRL: Record "Purch. Rcpt. Line";
                        ShipmentTrackingHeader: Record "Tracking Shipment Header";
                        ShipmentTrackingLine: Record "Tracking Shipment Line";
                        SH: Record "Sales Header";
                        SL: Record "Sales Line";
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
                action("Update Sales Archive")
                {
                    ApplicationArea = All;
                    Caption = 'Update Sales Archive';
                    ToolTip = 'Update Sales Archive Data from Sales Invoice Line.';
                    Visible = false;
                    trigger OnAction()
                    var
                        i: Integer;
                        SalesHeaderArchive: Record "Sales Header Archive";
                        SalesLineArchive: Record "Sales Line Archive";
                        SSH: Record "Sales Shipment Header";
                        SSL: Record "Sales Shipment Line";
                        ShipmentTrackingHeader: Record "Tracking Shipment Header";
                        ShipmentTrackingLine: Record "Tracking Shipment Line";
                        SH: Record "Sales Header";
                        SL: Record "Sales Line";
                    begin
                        SalesHeaderArchive.Reset();
                        SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
                        If SalesHeaderArchive.FindFirst() then
                            repeat
                                SSH.SetRange("Order No.", SalesHeaderArchive."No.");
                                If SSH.FindFirst() then
                                    Repeat
                                        if SalesHeaderArchive."Country of Origin" = '' then
                                            SalesHeaderArchive."Country of Origin" := SSH."Country of Origin";
                                        if SalesHeaderArchive."Country of provenance" = '' then
                                            SalesHeaderArchive."Country of provenance" := SSH."Country of provenance";
                                        if SalesHeaderArchive."Country of Acquisition" = '' then
                                            SalesHeaderArchive."Country of Acquisition" := SSH."Country of Acquisition";
                                        if SalesHeaderArchive."Milestone Status" = '' then
                                            SalesHeaderArchive."Milestone Status" := SSH."Milestone Status";
                                        if SalesHeaderArchive.VIA = '' then
                                            SalesHeaderArchive.VIA := SSH.VIA;


                                        SalesHeaderArchive.Modify();
                                        i += 1;

                                    until SSH.Next() = 0;
                            until SalesHeaderArchive.Next() = 0;

                        SalesLineArchive.Reset();
                        SalesLineArchive.SetRange("Document Type", SalesLineArchive."Document Type"::Order);
                        If SalesLineArchive.FindFirst() then
                            repeat
                                SSL.SetRange("Order No.", SalesLineArchive."Document No.");
                                SSL.SetRange("Line No.", SalesLineArchive."Line No.");
                                If SSL.FindFirst() then
                                    Repeat
                                        if SalesLineArchive."PO No." = '' then
                                            SalesLineArchive."PO No." := SSL."PO No.";
                                        if SalesLineArchive."PO Line No." = 0 then
                                            SalesLineArchive."PO Line No." := SSL."PO Line No.";
                                        if SalesLineArchive."HS Code" = '' then
                                            SalesLineArchive."HS Code" := SSL."HS Code";
                                        if SalesLineArchive."HTS Code" = '' then
                                            SalesLineArchive."HTS Code" := SSL."HTS Code";
                                        if SalesLineArchive."No. of Packages" = 0 then
                                            SalesLineArchive."No. of Packages" := SSL."No. of Packages";
                                        if SalesLineArchive."Total Gross (KG)" = 0 then
                                            SalesLineArchive."Total Gross (KG)" := SSL."Total Gross (KG)";
                                        if SalesLineArchive."Total CBM" = 0 then
                                            SalesLineArchive."Total CBM" := SSL."Total CBM";
                                        if SalesLineArchive."Total Net (KG)" = 0 then
                                            SalesLineArchive."Total Net (KG)" := SSL."Total Net (KG)";
                                        if SalesLineArchive."Port of Load" = '' then
                                            SalesLineArchive."Port of Load" := SSL."Port of Load";
                                        if SalesLineArchive."Port of Discharge" = '' then
                                            SalesLineArchive."Port of Discharge" := SSL."Port of Discharge";
                                        if SalesLineArchive."Country of Origin" = '' then
                                            SalesLineArchive."Country of Origin" := SSL."Country of Origin";
                                        if SalesLineArchive."Pallet Quantity" = 0 then
                                            SalesLineArchive."Pallet Quantity" := SSL."Pallet Quantity";
                                        if SalesLineArchive."Shipment Tracking Code" = '' then
                                            SalesLineArchive."Shipment Tracking Code" := SSL."Shipment Tracking Code";
                                        if SalesLineArchive."Shipment Tracking Line No." = 0 then
                                            SalesLineArchive."Shipment Tracking Line No." := SSL."Shipment Tracking Line No.";
                                        if SalesLineArchive."UL Certificate Available" = false then
                                            SalesLineArchive."UL Certificate Available" := SSL."UL Certificate Available";
                                        if SalesLineArchive."Country of Origin" = '' then
                                            SalesLineArchive."Country of Origin" := SSL."Country of Origin";
                                        if SalesLineArchive."Country of provenance" = '' then
                                            SalesLineArchive."Country of provenance" := SSL."Country of provenance";
                                        if SalesLineArchive."Country of Acquisition" = '' then
                                            SalesLineArchive."Country of Acquisition" := SSL."Country of Acquisition";
                                        if SalesLineArchive."Milestone Status" = '' then
                                            SalesLineArchive."Milestone Status" := SSL."Milestone Status";
                                        if SalesLineArchive.VIA = '' then
                                            SalesLineArchive.VIA := SSL.VIA;

                                        SalesLineArchive.Modify();
                                        i += 1;

                                    until SSL.Next() = 0;
                            until SalesLineArchive.Next() = 0;

                        if i > 0 then
                            Message('%1 recordes updated.', i);
                    end;
                }
                action("Update SO No.")
                {
                    ApplicationArea = All;
                    Caption = 'Update SO No.';
                    ToolTip = 'Update SO No. on linked purchase document.';
                    Visible = false;
                    trigger OnAction()
                    var
                        i: Integer;
                        PH: Record "Purchase Header";
                        PL: Record "Purchase Line";
                        PHA: Record "Purchase Header Archive";
                        PHL: Record "Purchase Line Archive";
                        PRcptH: Record "Purch. Rcpt. Header";
                        PRcptL: Record "Purch. Rcpt. Line";
                        PInvH: Record "Purch. Inv. Header";
                        PInvL: Record "Purch. Inv. Line";
                        SH: Record "Sales Header";
                        SL: Record "Sales Line";
                        SInvH: Record "Sales Invoice Header";
                        SInvL: Record "Sales Invoice Line";
                        STH: Record "Tracking Shipment Header";
                        STL: Record "Tracking Shipment Line";
                    begin
                        SInvL.SetFilter("PO No.", '<>%1', '');
                        SInvL.SetFilter("PO Line No.", '<>%1', 0);
                        SInvL.SetRange(Type, SInvL.Type::Item);
                        if SInvL.FindFirst() then
                            repeat
                                PL.Reset();
                                PL.SetRange("Document No.", SInvL."PO No.");
                                PL.SetRange("Line No.", SInvL."PO Line No.");
                                if PL.FindFirst() then begin
                                    if PL."SO No." = '' then
                                        PL."SO No." := SInvL."Order No.";
                                    if PL."SO Line No." = 0 then
                                        PL."SO Line No." := SInvL."Order Line No.";
                                    PL.Modify();
                                    i += 1;
                                end;

                                PHL.Reset();
                                PHL.SetRange("Document No.", SInvL."PO No.");
                                PHL.SetRange("Line No.", SInvL."PO Line No.");
                                if PHL.FindFirst() then
                                    Repeat
                                        if PHL."SO No." = '' then
                                            PHL."SO No." := SInvL."Order No.";
                                        if PHL."SO Line No." = 0 then
                                            PHL."SO Line No." := SInvL."Order Line No.";
                                        PHL.Modify();
                                        i += 1;
                                    Until PHL.Next() = 0;

                                PRcptL.Reset();
                                PRcptL.SetRange("Order No.", SInvL."PO No.");
                                PRcptL.SetRange("Order Line No.", SInvL."PO Line No.");
                                if PRcptL.FindFirst() then begin
                                    if PRcptL."SO No." = '' then
                                        PRcptL."SO No." := SInvL."Order No.";
                                    if PRcptL."SO Line No." = 0 then
                                        PRcptL."SO Line No." := SInvL."Order Line No.";
                                    PRcptL.Modify();
                                    i += 1;
                                end;

                                PInvL.Reset();
                                PInvL.SetRange("Order No.", SInvL."PO No.");
                                PInvL.SetRange("Order Line No.", SInvL."PO Line No.");
                                if PInvL.FindFirst() then begin
                                    if PInvL."SO No." = '' then
                                        PInvL."SO No." := SInvL."Order No.";
                                    if PInvL."SO Line No." = 0 then
                                        PInvL."SO Line No." := SInvL."Order Line No.";
                                    PInvL.Modify();
                                    i += 1;
                                end;

                            until SInvL.Next() = 0;

                        SL.SetFilter("PO No.", '<>%1', '');
                        SL.SetFilter("PO Line No.", '<>%1', 0);
                        SL.SetRange(Type, SL.Type::Item);
                        if SL.FindFirst() then
                            repeat
                                PL.Reset();
                                PL.SetRange("Document No.", SL."PO No.");
                                PL.SetRange("Line No.", SL."PO Line No.");
                                if PL.FindFirst() then begin
                                    if PL."SO No." = '' then
                                        PL."SO No." := SL."Document No.";
                                    if PL."SO Line No." = 0 then
                                        PL."SO Line No." := SL."Line No.";
                                    PL.Modify();
                                    i += 1;
                                end;

                                PHL.Reset();
                                PHL.SetRange("Document No.", SL."PO No.");
                                PHL.SetRange("Line No.", SL."PO Line No.");
                                if PHL.FindFirst() then
                                    Repeat
                                        if PHL."SO No." = '' then
                                            PHL."SO No." := SL."Document No.";
                                        if PHL."SO Line No." = 0 then
                                            PHL."SO Line No." := SL."Line No.";
                                        PHL.Modify();
                                        i += 1;
                                    Until PHL.Next() = 0;

                                PRcptL.Reset();
                                PRcptL.SetRange("Order No.", SL."PO No.");
                                PRcptL.SetRange("Order Line No.", SL."PO Line No.");
                                if PRcptL.FindFirst() then begin
                                    if PRcptL."SO No." = '' then
                                        PRcptL."SO No." := SL."Document No.";
                                    if PRcptL."SO Line No." = 0 then
                                        PRcptL."SO Line No." := SL."Line No.";
                                    PRcptL.Modify();
                                    i += 1;
                                end;

                                PInvL.Reset();
                                PInvL.SetRange("Order No.", SL."PO No.");
                                PInvL.SetRange("Order Line No.", SL."PO Line No.");
                                if PInvL.FindFirst() then begin
                                    if PInvL."SO No." = '' then
                                        PInvL."SO No." := SL."Document No.";
                                    if PInvL."SO Line No." = 0 then
                                        PInvL."SO Line No." := SL."Line No.";
                                    PInvL.Modify();
                                    i += 1;
                                end;

                            until SL.Next() = 0;

                        if i > 0 then
                            Message('%1 recordes updated.', i);
                    end;
                }
                action("Update PO No.")
                {
                    ApplicationArea = All;
                    Caption = 'Update PO No.';
                    ToolTip = 'Update PO No. on linked sales document.';

                    trigger OnAction()
                    var
                        i: Integer;
                        PH: Record "Purchase Header";
                        PL: Record "Purchase Line";
                        PLA: Record "Purchase Line Archive";
                        PHA: Record "Purchase Header Archive";
                        PHL: Record "Purchase Line Archive";
                        PRcptH: Record "Purch. Rcpt. Header";
                        PRcptL: Record "Purch. Rcpt. Line";
                        PInvH: Record "Purch. Inv. Header";
                        PInvL: Record "Purch. Inv. Line";
                        SH: Record "Sales Header";
                        SL: Record "Sales Line";
                        SLA: Record "Sales Line Archive";
                        SHA: Record "SAles Header Archive";
                        SHL: Record "Sales Line Archive";
                        SShptH: Record "Sales Shipment Header";
                        SShptL: Record "Sales Shipment Line";
                        SInvH: Record "Sales Invoice Header";
                        SInvL: Record "Sales Invoice Line";
                        STH: Record "Tracking Shipment Header";
                        STL: Record "Tracking Shipment Line";
                    begin
                        PInvL.SetFilter("SO No.", '<>%1', '');
                        PInvL.SetFilter("SO Line No.", '<>%1', 0);
                        PInvL.SetRange(Type, SInvL.Type::Item);
                        if PInvL.FindFirst() then
                            repeat
                                SL.Reset();
                                SL.SetRange("Document No.", PInvL."SO No.");
                                SL.SetRange("Line No.", PInvL."SO Line No.");
                                if SL.FindFirst() then begin
                                    //if SL."PO No." = '' then
                                    SL."PO No." := PInvL."Order No.";
                                    //if SL."PO Line No." = 0 then
                                    SL."PO Line No." := PInvL."Order Line No.";
                                    SL."No. of Packages" := PInvL."No. of Packages";
                                    SL."Total CBM" := PInvL."Total CBM";
                                    SL."Total Gross (KG)" := PInvL."Total Gross (KG)";
                                    SL."Total Net (KG)" := PInvL."Total Net (KG)";
                                    SL.Modify();
                                    i += 1;
                                end;

                                SHL.Reset();
                                SHL.SetRange("Document No.", PInvL."SO No.");
                                SHL.SetRange("Line No.", PInvL."SO Line No.");
                                if SHL.FindFirst() then
                                    Repeat
                                        //if SHL."PO No." = '' then
                                        SHL."PO No." := PInvL."Order No.";
                                        //if SHL."PO Line No." = 0 then
                                        SHL."PO Line No." := PInvL."Order Line No.";
                                        SHL."No. of Packages" := PInvL."No. of Packages";
                                        SHL."Total CBM" := PInvL."Total CBM";
                                        SHL."Total Gross (KG)" := PInvL."Total Gross (KG)";
                                        SHL."Total Net (KG)" := PInvL."Total Net (KG)";
                                        SHL.Modify();
                                        i += 1;
                                    Until PHL.Next() = 0;

                                SShptL.Reset();
                                SShptL.SetRange("Order No.", PInvL."SO No.");
                                SShptL.SetRange("Order Line No.", PInvL."SO Line No.");
                                if SShptL.FindFirst() then begin
                                    //if SShptL."PO No." = '' then
                                    SShptL."PO No." := PInvL."Order No.";
                                    //if SShptL."PO Line No." = 0 then
                                    SShptL."PO Line No." := PInvL."Order Line No.";
                                    SShptL."No. of Packages" := PInvL."No. of Packages";
                                    SShptL."Total CBM" := PInvL."Total CBM";
                                    SShptL."Total Gross (KG)" := PInvL."Total Gross (KG)";
                                    SShptL."Total Net (KG)" := PInvL."Total Net (KG)";
                                    SShptL.Modify();
                                    i += 1;
                                end;

                                SInvL.Reset();
                                SInvL.SetRange("Order No.", PInvL."SO No.");
                                SInvL.SetRange("Order Line No.", PInvL."SO Line No.");
                                if SInvL.FindFirst() then begin
                                    //if SInvL."PO No." = '' then
                                    SInvL."PO No." := PInvL."Order No.";
                                    //if SInvL."PO Line No." = 0 then
                                    SInvL."PO Line No." := PInvL."Order Line No.";
                                    SInvL."No. of Packages" := PInvL."No. of Packages";
                                    SInvL."Total CBM" := PInvL."Total CBM";
                                    SInvL."Total Gross (KG)" := PInvL."Total Gross (KG)";
                                    SInvL."Total Net (KG)" := PInvL."Total Net (KG)";
                                    SInvL.Modify();
                                    i += 1;
                                end;

                            until PInvL.Next() = 0;

                        PL.SetFilter("SO No.", '<>%1', '');
                        PL.SetFilter("SO Line No.", '<>%1', 0);
                        PL.SetRange(Type, PL.Type::Item);
                        if PL.FindFirst() then
                            repeat
                                SL.Reset();
                                SL.SetRange("Document No.", PL."SO No.");
                                SL.SetRange("Line No.", PL."SO Line No.");
                                if SL.FindFirst() then begin
                                    //if SL."PO No." = '' then
                                    SL."PO No." := PL."Document No.";
                                    //if SL."PO Line No." = 0 then
                                    SL."PO Line No." := PL."Line No.";
                                    SL."No. of Packages" := PL."No. of Packages";
                                    SL."Total CBM" := PL."Total CBM";
                                    SL."Total Gross (KG)" := PL."Total Gross (KG)";
                                    SL."Total Net (KG)" := PL."Total Net (KG)";
                                    SL.Modify();
                                    i += 1;
                                end;

                                SHL.Reset();
                                SHL.SetRange("Document No.", PL."SO No.");
                                SHL.SetRange("Line No.", PL."SO Line No.");
                                if SHL.FindFirst() then
                                    Repeat
                                        //if SHL."PO No." = '' then
                                        SHL."PO No." := PL."Document No.";
                                        //if SHL."PO Line No." = 0 then
                                        SHL."PO Line No." := PL."Line No.";
                                        SHL."No. of Packages" := PL."No. of Packages";
                                        SHL."Total CBM" := PL."Total CBM";
                                        SHL."Total Gross (KG)" := PL."Total Gross (KG)";
                                        SHL."Total Net (KG)" := PL."Total Net (KG)";
                                        SHL.Modify();
                                        i += 1;
                                    Until SHL.Next() = 0;

                                SshptL.Reset();
                                SshptL.SetRange("Order No.", PL."SO No.");
                                SshptL.SetRange("Order Line No.", PL."SO Line No.");
                                if SshptL.FindFirst() then begin
                                    //if SshptL."PO No." = '' then
                                    SshptL."PO No." := PL."Document No.";
                                    //if SshptL."PO Line No." = 0 then
                                    SshptL."PO Line No." := PL."Line No.";
                                    SShptL."No. of Packages" := PL."No. of Packages";
                                    SShptL."Total CBM" := PL."Total CBM";
                                    SShptL."Total Gross (KG)" := PL."Total Gross (KG)";
                                    SShptL."Total Net (KG)" := PL."Total Net (KG)";
                                    SshptL.Modify();
                                    i += 1;
                                end;

                                SInvL.Reset();
                                SInvL.SetRange("Order No.", PL."SO No.");
                                SInvL.SetRange("Order Line No.", PL."SO Line No.");
                                if SInvL.FindFirst() then begin
                                    //if SInvL."PO No." = '' then
                                    SInvL."PO No." := PL."Document No.";
                                    //if SInvL."PO Line No." = 0 then
                                    SInvL."PO Line No." := PL."Line No.";
                                    SInvL."No. of Packages" := PL."No. of Packages";
                                    SInvL."Total CBM" := PL."Total CBM";
                                    SInvL."Total Gross (KG)" := PL."Total Gross (KG)";
                                    SInvL."Total Net (KG)" := PL."Total Net (KG)";
                                    SInvL.Modify();
                                    i += 1;
                                end;

                            until PL.Next() = 0;

                        PLA.SetFilter("SO No.", '<>%1', '');
                        PLA.SetFilter("SO Line No.", '<>%1', 0);
                        PLA.SetRange(Type, PL.Type::Item);
                        if PLA.FindFirst() then
                            repeat
                                SL.Reset();
                                SL.SetRange("Document No.", PLA."SO No.");
                                SL.SetRange("Line No.", PLA."SO Line No.");
                                if SL.FindFirst() then begin
                                    //if SL."PO No." = '' then
                                    SL."PO No." := PLA."Document No.";
                                    //if SL."PO Line No." = 0 then
                                    SL."PO Line No." := PLA."Line No.";
                                    SL."No. of Packages" := PLA."No. of Packages";
                                    SL."Total CBM" := PLA."Total CBM";
                                    SL."Total Gross (KG)" := PLA."Total Gross (KG)";
                                    SL."Total Net (KG)" := PLA."Total Net (KG)";
                                    SL.Modify();
                                    i += 1;
                                end;

                                SLA.Reset();
                                SLA.SetRange("Document No.", PLA."SO No.");
                                SLA.SetRange("Line No.", PLA."SO Line No.");
                                if SLA.FindLast() then begin
                                    //if SLA."PO No." = '' then
                                    SLA."PO No." := PLA."Document No.";
                                    //if SLA."PO Line No." = 0 then
                                    SLA."PO Line No." := PLA."Line No.";
                                    SLA."No. of Packages" := PLA."No. of Packages";
                                    SLA."Total CBM" := PLA."Total CBM";
                                    SLA."Total Gross (KG)" := PLA."Total Gross (KG)";
                                    SLA."Total Net (KG)" := PLA."Total Net (KG)";
                                    SLA.Modify();
                                    i += 1;
                                end;
                                SHL.Reset();
                                SHL.SetRange("Document No.", PLA."SO No.");
                                SHL.SetRange("Line No.", PLA."SO Line No.");
                                if SHL.FindFirst() then
                                    Repeat
                                        //if SHL."PO No." = '' then
                                        SHL."PO No." := PLA."Document No.";
                                        //if SHL."PO Line No." = 0 then
                                        SHL."PO Line No." := PLA."Line No.";
                                        SHL."No. of Packages" := PLA."No. of Packages";
                                        SHL."Total CBM" := PLA."Total CBM";
                                        SHL."Total Gross (KG)" := PLA."Total Gross (KG)";
                                        SHL."Total Net (KG)" := PLA."Total Net (KG)";
                                        SHL.Modify();
                                        i += 1;
                                    Until SHL.Next() = 0;

                                SshptL.Reset();
                                SshptL.SetRange("Order No.", PLA."SO No.");
                                SshptL.SetRange("Order Line No.", PLA."SO Line No.");
                                if SshptL.FindFirst() then begin
                                    //if SshptL."PO No." = '' then
                                    SshptL."PO No." := PLA."Document No.";
                                    //if SshptL."PO Line No." = 0 then
                                    SshptL."PO Line No." := PLA."Line No.";
                                    SShptL."No. of Packages" := PLA."No. of Packages";
                                    SShptL."Total CBM" := PLA."Total CBM";
                                    SShptL."Total Gross (KG)" := PLA."Total Gross (KG)";
                                    SShptL."Total Net (KG)" := PLA."Total Net (KG)";
                                    SshptL.Modify();
                                    i += 1;
                                end;

                                SInvL.Reset();
                                SInvL.SetRange("Order No.", PLA."SO No.");
                                SInvL.SetRange("Order Line No.", PLA."SO Line No.");
                                if SInvL.FindFirst() then begin
                                    //if SInvL."PO No." = '' then
                                    SInvL."PO No." := PLA."Document No.";
                                    //if SInvL."PO Line No." = 0 then
                                    SInvL."PO Line No." := PLA."Line No.";
                                    SInvL."No. of Packages" := PLA."No. of Packages";
                                    SInvL."Total CBM" := PLA."Total CBM";
                                    SInvL."Total Gross (KG)" := PLA."Total Gross (KG)";
                                    SInvL."Total Net (KG)" := PLA."Total Net (KG)";
                                    SInvL.Modify();
                                    i += 1;
                                end;

                            until PLA.Next() = 0;

                        if i > 0 then
                            Message('%1 recordes updated.', i);
                    end;
                }
                action("Remove Wrong PO No.")
                {
                    ApplicationArea = All;
                    Caption = 'Remove Wrong PO No.';
                    ToolTip = 'Remove PO No. on linked sales document if its wrong.';

                    trigger OnAction()
                    var
                        i: Integer;
                        PH: Record "Purchase Header";
                        PL: Record "Purchase Line";
                        PLA: Record "Purchase Line Archive";
                        PHA: Record "Purchase Header Archive";
                        PHL: Record "Purchase Line Archive";
                        PRcptH: Record "Purch. Rcpt. Header";
                        PRcptL: Record "Purch. Rcpt. Line";
                        PInvH: Record "Purch. Inv. Header";
                        PInvL: Record "Purch. Inv. Line";
                        SH: Record "Sales Header";
                        SL: Record "Sales Line";
                        SLA: Record "Sales Line Archive";
                        SHA: Record "Sales Header Archive";
                        SHL: Record "Sales Line Archive";
                        SShptH: Record "Sales Shipment Header";
                        SShptL: Record "Sales Shipment Line";
                        SInvH: Record "Sales Invoice Header";
                        SInvL: Record "Sales Invoice Line";
                        STH: Record "Tracking Shipment Header";
                        STL: Record "Tracking Shipment Line";
                        EntryFound: Boolean;
                    begin

                        SL.Reset();
                        SL.SetFilter("PO No.", '<>%1', '');
                        SL.SetFilter("PO Line No.", '<>%1', 0);
                        if SL.FindFirst() then
                            Repeat
                                EntryFound := false;
                                PL.Reset();
                                PL.SetRange("SO No.", SL."Document No.");
                                PL.SetRange("SO Line No.", SL."Line No.");
                                if PL.FindFirst() then
                                    EntryFound := true;

                                PLA.Reset();
                                PLA.SetRange("SO No.", SL."Document No.");
                                PLA.SetRange("SO Line No.", SL."Line No.");
                                if PLA.FindFirst() then
                                    EntryFound := true;

                                if EntryFound = false then begin
                                    SL."PO No." := '';
                                    SL."PO Line No." := 0;
                                    SL.Modify();
                                    i += 1;
                                end;
                            Until SL.Next() = 0;

                        SLA.Reset();
                        SLA.SetFilter("PO No.", '<>%1', '');
                        SLA.SetFilter("PO Line No.", '<>%1', 0);
                        if SLA.FindFirst() then
                            Repeat
                                EntryFound := false;
                                PL.Reset();
                                PL.SetRange("SO No.", SLA."Document No.");
                                PL.SetRange("SO Line No.", SLA."Line No.");
                                if PL.FindFirst() then
                                    EntryFound := true;

                                PLA.Reset();
                                PLA.SetRange("SO No.", SLA."Document No.");
                                PLA.SetRange("SO Line No.", SLA."Line No.");
                                if PLA.FindFirst() then
                                    EntryFound := true;

                                if EntryFound = false then begin
                                    SLA."PO No." := '';
                                    SLA."PO Line No." := 0;
                                    SLA.Modify();
                                    i += 1;
                                end;
                            Until SLA.Next() = 0;

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

