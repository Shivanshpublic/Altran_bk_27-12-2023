codeunit 50004 UpdateULCertificate
{
    Permissions = TableData "Purch. Cr. Memo Line" = rm, TableData "Purch. Inv. Line" = rm,
TableData "Return Shipment Line" = rm, TableData "Purch. Rcpt. Line" = rm,
TableData "Sales Cr.Memo Line" = rm, TableData "Sales Shipment Line" = rm,
TableData "Return Receipt Line" = rm, TableData "Sales Invoice Line" = rm;
    trigger OnRun()
    begin
        UpdateULCertificate();
    end;

    procedure UpdateULCertificate()
    var
        Item: Record Item;
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchRetShptLine: Record "Return Shipment Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesRetRcptLine: Record "Return Receipt Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";

    begin
        if Item.FindFirst() then
            repeat
                PurchLine.SetRange(Type, PurchLine.Type::Item);
                PurchLine.SetRange("No.", Item."No.");
                PurchLine.ModifyAll("UL Certificate Available", Item."UL Certificate Available");

                PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
                PurchRcptLine.SetRange("No.", Item."No.");
                PurchRcptLine.ModifyAll("UL Certificate Available", Item."UL Certificate Available");

                PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
                PurchInvLine.SetRange("No.", Item."No.");
                PurchInvLine.ModifyAll("UL Certificate Available", Item."UL Certificate Available");

                PurchCrMemoLine.SetRange(Type, PurchCrMemoLine.Type::Item);
                PurchCrMemoLine.SetRange("No.", Item."No.");
                PurchCrMemoLine.ModifyAll("UL Certificate Available", Item."UL Certificate Available");

                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("No.", Item."No.");
                SalesLine.ModifyAll("UL Certificate Available", Item."UL Certificate Available");

                SalesShptLine.SetRange(Type, SalesShptLine.Type::Item);
                SalesShptLine.SetRange("No.", Item."No.");
                SalesShptLine.ModifyAll("UL Certificate Available", Item."UL Certificate Available");

                SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                SalesInvLine.SetRange("No.", Item."No.");
                SalesInvLine.ModifyAll("UL Certificate Available", Item."UL Certificate Available");

            // SalesRetRcptLine.SetRange(Type, SalesRetRcptLine.Type::Item);
            // SalesRetRcptLine.SetRange("No.", "No.");
            // SalesRetRcptLine.ModifyAll("UL Certificate Available", "UL Certificate Available");

            // SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);
            // SalesCrMemoLine.SetRange("No.", "No.");
            // SalesCrMemoLine.ModifyAll("UL Certificate Available", "UL Certificate Available");
            Until Item.Next() = 0;
        Message('Update Successfully');
    end;

    procedure UpdateSalesInvoiceLine()
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvline: Record "Sales Invoice Line";
        Salesperson: Record "Salesperson/Purchaser";
    begin
        if SalesInvHeader.FindFirst() then
            repeat
                SalesInvline.SetRange("Document No.", SalesInvHeader."No.");
                if SalesInvline.FindFirst() then
                    repeat
                        SalesInvline."Sell-to Customer Name" := SalesInvHeader."Sell-to Customer Name";
                        SalesInvline."External Document No." := SalesInvHeader."External Document No.";
                        if Salesperson.Get(SalesInvHeader."Internal Team") then
                            if SalesInvline."Internal Team Name" = '' then begin
                                SalesInvline."Internal Team" := SalesInvHeader."Internal Team";
                                SalesInvline."Internal Team Name" := Salesperson.Name;
                            end;
                        if Salesperson.Get(SalesInvHeader."Salesperson Code") then
                            if SalesInvline."Salesperson Name" = '' then begin
                                SalesInvline."Salesperson Code" := SalesInvHeader."Salesperson Code";
                                SalesInvline."Salesperson Name" := Salesperson.Name;
                            end;

                        if Salesperson.Get(SalesInvHeader."External Rep") then
                            if SalesInvline."External Team Name" = '' then begin
                                SalesInvline."External Rep" := SalesInvHeader."External Rep";
                                SalesInvline."External Team Name" := Salesperson.Name;
                            end;
                        SalesInvline.Modify();
                    until SalesInvline.Next() = 0;
            until SalesInvHeader.Next() = 0;

    end;
}
