pageextension 50008 PostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            FIELD("Internal Team"; Rec."Internal Team")
            {
                ApplicationArea = All;
            }
            FIELD("External Rep"; Rec."External Rep")
            {
                ApplicationArea = All;
            }
            field("Country of Origin"; Rec."Country of Origin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of Origin field.';
            }
            field("Country of provenance"; Rec."Country of provenance")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of provenance field.';
            }
            field("Country of Acquisition"; Rec."Country of Acquisition")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country of Acquisition field.';
            }
            field("Earned Surcharge Posted"; Rec."Earned Surcharge Posted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Earned Surcharge Posted field.';
            }
            field("Sample Order"; Rec."Sample Order")
            {
                ApplicationArea = All;
            }
            field(VIA; Rec.VIA)
            {
                ApplicationArea = All;
            }

        }
        addlast(content)
        {
            group("Consignee")
            {
                field("Consignee Type"; Rec."Consignee Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Type field.';
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee No. field.';
                }
                field("Consignee Name"; Rec."Consignee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Name field.';
                }
                field("Consignee Name 2"; Rec."Consignee Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Name 2 field.';
                }
                field("Consignee Address"; Rec."Consignee Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Address field.';
                }
                field("Consignee Address 2"; Rec."Consignee Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Address 2 field.';
                }
                field("Consignee City"; Rec."Consignee City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee City field.';
                }
                field("Consignee Country/Region code"; Rec."Consignee Country/Region code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consignee Country/Region code field.';
                }

            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action("Show PO Line")
            {
                ApplicationArea = All;
                Image = AllLines;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    POLine: Record "Purchase Line";
                    SoLine: Record "Sales Invoice Line";
                begin
                    Clear(POLine);
                    Clear(SoLine);
                    //SoLine.SetRange("Document Type", Rec."Document Type");
                    SoLine.SetRange("Document No.", Rec."No.");
                    SoLine.SetFilter("PO No.", '<>%1', '');
                    SoLine.SetFilter("PO Line No.", '<>%1', 0);
                    SoLine.FindSet();
                    repeat
                        POLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                        POLine.SetRange("Document Type", POLine."Document Type"::Order);
                        POLine.SetRange("Document No.", SoLine."PO No.");
                        POLine.SetRange("Line No.", SoLine."PO Line No.");
                        if POLine.FindFirst() then
                            POLine.Mark(true);
                    until SoLine.Next() = 0;

                    POLine.MarkedOnly(true);
                    if POLine.Count > 0 then
                        Page.Run(0, POLine);
                end;
            }
        }


        addafter(Print)
        {
            group("Prin&t")
            {
                Caption = 'Print';

                action(SaveSalesInvAsPdf)
                {
                    Caption = 'Sales Invoice As Pdf';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileManagement: Codeunit "File Management";
                        OStream: OutStream;
                        RecRef: RecordRef;
                    begin
                        Clear(OStream);
                        CurrPage.SetSelectionFilter(Rec);
                        RecRef.GetTable(Rec);
                        TempBlob.CreateOutStream(OStream);
                        Report.SaveAs(Report::"Sales Invoice", '', ReportFormat::Pdf, OStream, RecRef);
                        FileManagement.BLOBExport(TempBlob, 'Sales Invoice-' + Rec."No." + '-Customer ' + Rec."Sell-to Customer No." + '.pdf', true);
                    end;
                }
                action("Print COO")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print COO';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category6;
                    trigger OnAction()
                    var
                        SalesInvHeader: Record "Sales Invoice Header";
                        COOReport: Report "Certificate of Origin";
                    begin
                        Clear(COOReport);
                        Clear(SalesInvHeader);
                        SalesInvHeader.SetRange("No.", Rec."No.");
                        SalesInvHeader.FindFirst();
                        COOReport.SetTableView(SalesInvHeader);
                        COOReport.Run();
                    end;
                }
                action("Print COO INT")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print COO International';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category6;
                    trigger OnAction()
                    var
                        SalesInvHeader: Record "Sales Invoice Header";
                        COOReport: Report "Certificate of Origin INT";
                    begin
                        Clear(COOReport);
                        Clear(SalesInvHeader);
                        SalesInvHeader.SetRange("No.", Rec."No.");
                        SalesInvHeader.FindFirst();
                        COOReport.SetTableView(SalesInvHeader);
                        COOReport.Run();
                    end;
                }
                action("Print COO US")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print COO (US & Canada)';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category6;
                    trigger OnAction()
                    var
                        SalesInvHeader: Record "Sales Invoice Header";
                        COOReport: Report "Certificate of Origin US";
                    begin
                        Clear(COOReport);
                        Clear(SalesInvHeader);
                        SalesInvHeader.SetRange("No.", Rec."No.");
                        SalesInvHeader.FindFirst();
                        COOReport.SetTableView(SalesInvHeader);
                        COOReport.Run();
                    end;
                }
                action("Print PackingList_D")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Packing List (Domestic)';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category6;
                    trigger OnAction()
                    var
                        SalesInvHeader: Record "Sales Invoice Header";
                        PackingList: Report "Packing List Report";
                    begin
                        Clear(PackingList);
                        Clear(SalesInvHeader);
                        SalesInvHeader.SetRange("No.", Rec."No.");
                        SalesInvHeader.FindFirst();
                        PackingList.SetTableView(SalesInvHeader);
                        PackingList.Run();
                    end;
                }
                action(SavePackListDomAsPdf)
                {
                    Caption = 'Packing List (Domestic) As Pdf';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileManagement: Codeunit "File Management";
                        OStream: OutStream;
                        RecRef: RecordRef;
                    begin
                        Clear(OStream);
                        CurrPage.SetSelectionFilter(Rec);
                        RecRef.GetTable(Rec);
                        TempBlob.CreateOutStream(OStream);
                        Report.SaveAs(Report::"Packing List Report", '', ReportFormat::Pdf, OStream, RecRef);
                        FileManagement.BLOBExport(TempBlob, 'Packing List (Domestic)-' + Rec."No." + '-Customer ' + Rec."Sell-to Customer No." + '.pdf', true);
                    end;
                }
                action("Print PackingList_INT")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Packing List (International)';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category6;
                    trigger OnAction()
                    var
                        SalesInvHeader: Record "Sales Invoice Header";
                        PackingList: Report "Packing List";
                    begin
                        Clear(PackingList);
                        Clear(SalesInvHeader);
                        SalesInvHeader.SetRange("No.", Rec."No.");
                        SalesInvHeader.FindFirst();
                        PackingList.SetTableView(SalesInvHeader);
                        PackingList.Run();
                    end;
                }
                action(SavePackListIntAsPdf)
                {
                    Caption = 'Packing List (International) As Pdf';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileManagement: Codeunit "File Management";
                        OStream: OutStream;
                        RecRef: RecordRef;
                    begin
                        Clear(OStream);
                        CurrPage.SetSelectionFilter(Rec);
                        RecRef.GetTable(Rec);
                        TempBlob.CreateOutStream(OStream);
                        Report.SaveAs(Report::"Packing List", '', ReportFormat::Pdf, OStream, RecRef);
                        FileManagement.BLOBExport(TempBlob, 'Packing List (International)-' + Rec."No." + '-Customer ' + Rec."Sell-to Customer No." + '.pdf', true);
                    end;
                }
                action(SaveCommInvAsPdf)
                {
                    Caption = 'Commercial Invoice As Pdf';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileManagement: Codeunit "File Management";
                        OStream: OutStream;
                        RecRef: RecordRef;
                    begin
                        Clear(OStream);
                        CurrPage.SetSelectionFilter(Rec);
                        RecRef.GetTable(Rec);
                        TempBlob.CreateOutStream(OStream);
                        Report.SaveAs(Report::"Commercial Invoice", '', ReportFormat::Pdf, OStream, RecRef);
                        FileManagement.BLOBExport(TempBlob, 'Commercial Invoice-' + Rec."No." + '-Customer ' + Rec."Sell-to Customer No." + '.pdf', true);
                    end;
                }
            }
        }
    }
}
