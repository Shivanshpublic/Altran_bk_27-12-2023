REPORT 50013 "Pallet Label"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/PalletLabel.rdlc';
    Caption = 'Pallet Label';

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING("Document No.") where("Document Type" = filter(Order), Type = filter(Item));
            RequestFilterFields = "Document No.", "Line No.";
            COLUMN(No_; "Sales Line"."Sell-to Customer No.") { }
            COLUMN(DocumentType; "Sales Line"."Document Type") { }
            COLUMN(OrderNo; "Sales Line"."Document No.") { }
            COLUMN(OrderLineNo; "Sales Line"."Line No.") { }
            column(Document_No_; ExtDocNo)
            {
            }
            column(Qty; FORMAT(SalesOrdQty))
            {
            }
            column(AltranPO; AltranPONo)
            {
            }
            column(Customer_PartNo_; ModelNo)
            {
            }
            column(palletNo; '')
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Name; SalesHead."Sell-to Customer Name")
            {
            }
            column(Address; SalesHead."Sell-to Address")
            {
            }
            column(Address_2; SalesHead."Sell-to Address 2")
            {
            }
            column(City; SalesHead."Sell-to City" + ' ' + SalesHead."Sell-to Country/Region Code" + ' ' + SalesHead."Sell-to Post Code")
            {
            }
            column(Phone_No_; SalesHead."Sell-to Phone No.")
            {
            }
            TRIGGER OnAfterGetRecord()
            BEGIN
                SalesHead.Get("Sales Line"."Document Type", "Sales Line"."Document No.");
                ExtDocNo := SalesHead."External Document No.";
                SalesOrdQty := "Sales Line".Quantity;
                AltranPONo := "Sales Line"."PO No.";
                ModelNo := "Sales Line"."Description 2";
            END;
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    /*
                                        field(SalesOrderNo; SalesOrderNo)
                                        {
                                            Caption = 'Sales Order No.';
                                            ApplicationArea = All;
                                            TableRelation = "Sales Header"."No." where("Document Type" = filter(Order));
                                            trigger OnValidate()
                                            begin
                                                SalesOrderLineNo := 0;
                                            end;
                                        }
                                        field(SalesOrderLineNo; SalesOrderLineNo)
                                        {
                                            Caption = 'Sales Order Line No.';
                                            ApplicationArea = All;
                                            trigger OnLookup(var Text: Text): Boolean
                                            begin
                                                if SalesOrderNo <> '' then begin
                                                    SalesLine.Reset();
                                                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                                                    SalesLine.SetRange("Document No.", SalesOrderNo);
                                                    if Page.RunModal(516, SalesLine) = Action::LookupOK then begin
                                                        SalesOrderLineNo := SalesLine."Line No.";
                                                    end;
                                                end;
                                            end;
                                        }
                    */
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
        end;
    }

    TRIGGER OnPreReport()
    BEGIN
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

    END;

    VAR
        CompanyInfo: Record "Company Information";
        SalesOrderNo: Code[20];
        SalesOrderLineNo: Integer;
        SalesHead: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ExtDocNo: Text[35];
        SalesOrdQty: Decimal;
        AltranPONo: code[20];
        ModelNo: Text[50];

}