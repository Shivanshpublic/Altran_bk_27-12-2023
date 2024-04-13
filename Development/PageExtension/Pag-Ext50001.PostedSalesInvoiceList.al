pageextension 50001 PostedSalesInvoiceList extends "Posted Sales Invoices"
{
    actions
    {
        addlast("&Electronic Document")
        {
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
        addlast(Category_Category7)
        {
            actionref("Print COO_Prom"; "Print COO")
            {

            }
            actionref("Print COO INT_Prom"; "Print COO INT")
            {

            }
            actionref("Print COO US_Prom"; "Print COO US")
            {

            }
            actionref("Print PackingListD_Prom"; "Print PackingList_D")
            {

            }
            actionref("Print PackingListINT_Prom"; "Print PackingList_INT")
            {

            }
        }
    }
}
