page 50021 "Attachment"
{
    Caption = 'Attachment';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Line';
    SourceTable = "Custom Setup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Attachment")
            {
                Caption = '&Attachment';
                Image = Attachments;
                action(Attachment)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attachment';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                    begin
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    trigger OnOpenPage()
    begin
    end;


    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        FromPurchRcptLine: Record "Purch. Rcpt. Line";
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;


    procedure InsertAttachment()
    var
        AttachmentRec: Record Attachment;
        FileOutStream: OutStream;
        FileInStream: InStream;
        tempfilename: text;
        DialogTitle: Label 'Please select a File…';
    begin
        if UploadIntoStream(DialogTitle, '', 'All Files (*.*)|*.*', tempfilename, FileInStream) then begin
            AttachmentRec.Init();
            AttachmentRec.Insert(true);
            AttachmentRec."Storage Type" := AttachmentRec."Storage Type"::Embedded;
            AttachmentRec."Storage Pointer" := '';
            AttachmentRec."File Extension" := GetFileType(tempfilename);
            AttachmentRec."Attachment File".CreateOutStream(FileOutStream);
            CopyStream(FileOutStream, FileInStream);
            AttachmentRec.Modify(true);
        end;
    end;

    local procedure GetFileType(pFilename: Text): Text;
    var
        FilenamePos: Integer;
    begin
        FilenamePos := StrLen(pFilename);
        while (pFilename[FilenamePos] <> '.') or (FilenamePos < 1) do
            FilenamePos -= 1;

        if FilenamePos = 0 then
            exit('');

        exit(CopyStr(pFilename, FilenamePos + 1, StrLen(pFilename)));
    end;

    procedure OpenAttachment(pFileAttachmentEntryNo: Integer)
    var
        AttachmentRec: record Attachment;
        ResponseStream: InStream;
        tempfilename: text;
        ErrorAttachment: Label 'No file available.';
    begin
        if AttachmentRec.get(pFileAttachmentEntryNo) then
            if AttachmentRec."Attachment File".HasValue then begin
                AttachmentRec.CalcFields("Attachment File");
                AttachmentRec."Attachment File".CreateInStream(ResponseStream);
                tempfilename := CreateGuid() + '.' + AttachmentRec."File Extension";
                DOWNLOADFROMSTREAM(ResponseStream, 'Export', '', 'All Files (*.*)|*.*', tempfilename);
            end
            else
                Error(ErrorAttachment);
    end;
}

