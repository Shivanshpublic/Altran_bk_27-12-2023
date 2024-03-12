pageextension 50031 "Sales Lines Ext" extends "Sales Lines"
{

    layout
    {
        addlast(Control1)
        {
            field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Shipment Tracking Line No."; Rec."Shipment Tracking Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Surcharge Per Qty."; Rec."Surcharge Per Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("UL Certificate Available"; Rec."UL Certificate Available")
            {
                ApplicationArea = All;
            }
            field("Assigned CSR"; Rec."Assigned CSR")
            {
                ApplicationArea = All;
            }
        }
        addafter("No.")
        {
            field("Item Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Outstanding Quantity")
        {
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }
            field("Quantity Shipped"; Rec."Quantity Shipped")
            {
                ApplicationArea = All;
            }
            field("QtyReceived$"; Rec."Quantity Shipped" * Rec."Unit Price")
            {
                ApplicationArea = All;
                Caption = 'Quantity Shipped ($)';
            }
        }
        addafter("Sell-to Customer No.")
        {
            field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
            {
                ApplicationArea = All;
            }
            field("Salesperson Name"; Rec."Salesperson Name")
            {
                ApplicationArea = All;
            }
            field("Internal Team Name"; Rec."Internal Team Name")
            {
                ApplicationArea = All;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action("Update Data")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    SalesHeader: Record "Sales Header";
                    Salesline: Record "Sales Line";
                    Salesperson: Record "Salesperson/Purchaser";
                    UpdateCL: Codeunit UpdateULCertificate;
                begin
                    if PurchHeader.FindFirst() then
                        repeat
                            PurchHeader."Creation Date" := DT2Date(PurchHeader.SystemCreatedAt);
                            PurchHeader.Modify();
                        until PurchHeader.Next() = 0;
                    if SalesHeader.FindFirst() then
                        repeat
                            Salesline.SetRange("Document Type", SalesHeader."Document Type");
                            Salesline.SetRange("Document No.", SalesHeader."No.");
                            if Salesline.FindFirst() then
                                repeat
                                    Salesline."Sell-to Customer Name" := SalesHeader."Sell-to Customer Name";
                                    Salesline."External Document No." := SalesHeader."External Document No.";
                                    if Salesperson.Get(SalesHeader."Internal Team") then
                                        Salesline."Internal Team Name" := Salesperson.Name
                                    else
                                        Salesline."Internal Team Name" := '';
                                    if Salesperson.Get(SalesHeader."Salesperson Code") then
                                        Salesline."Salesperson Name" := Salesperson.Name
                                    else
                                        Salesline."Salesperson Name" := '';
                                    Salesline.Modify();
                                until Salesline.Next() = 0;
                        until SalesHeader.Next() = 0;
                    UpdateCL.UpdateSalesInvoiceLine();
                end;
            }
        }
    }
}