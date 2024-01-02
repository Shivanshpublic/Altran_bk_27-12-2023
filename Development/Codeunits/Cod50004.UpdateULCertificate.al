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
}
