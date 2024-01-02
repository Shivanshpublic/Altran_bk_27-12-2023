pageextension 50060 CustomerListExt extends "Customer List"
{
    actions
    {
        addafter("Sent Emails")
        {
            action(ImportZipFile)
            {
                Caption = 'Import File';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;
                ToolTip = 'Import Attachments from Zip';
                Visible = false;
                trigger OnAction()
                begin
                    ImportAttachmentsFromZip();
                end;
            }
            action(ImportFileLink)
            {
                Caption = 'Import File Link';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;
                ToolTip = 'Import Linkss from Zip';
                trigger OnAction()
                begin
                    ImportLinkAttachmentsFromZip();
                end;
            }
        }
    }
    local procedure ImportAttachmentsFromZip()
    var
        FileMgt: Codeunit "File Management";
        DataCompression: Codeunit "Data Compression";
        TempBlob: Codeunit "Temp Blob";
        EntryList: List of [Text];
        EntryListKey: Text;
        ZipFileName: Text;
        FileName: Text;
        FileExtension: Text;
        InStream: InStream;
        EntryOutStream: OutStream;
        EntryInStream: InStream;
        Length: Integer;
        SelectZIPFileMsg: Label 'Select ZIP File';
        FileCount: Integer;
        Cust: Record Customer;
        DocAttach: Record "Document Attachment";
        NoCustError: Label 'Customer %1 does not exist.';
        ImportedMsg: Label '%1 attachments Imported successfully.';
        LineNo: Integer;
    begin
        //Upload zip file
        if not UploadIntoStream(SelectZIPFileMsg, '', 'Zip Files|*.zip', ZipFileName, InStream) then
            Error('');
        //Extract zip file and store files to list type
        DataCompression.OpenZipArchive(InStream, false);
        DataCompression.GetEntryList(EntryList);
        FileCount := 0;
        DocAttach.Reset();
        DocAttach.SetRange("Table ID", Database::Customer);
        if DocAttach.FindLast() then
            LineNo := DocAttach."Line No."
        else
            LineNo := 0;

        //Loop files from the list type
        foreach EntryListKey in EntryList do begin
            FileName := CopyStr(FileMgt.GetFileNameWithoutExtension(EntryListKey), 1, MaxStrLen(FileName));
            FileName := CopyStr(FileName, 1, StrPos(FileName, '-') - 1);
            FileExtension := CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen(FileExtension));
            TempBlob.CreateOutStream(EntryOutStream);
            DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length);
            TempBlob.CreateInStream(EntryInStream);
            //Import each file where you want
            if not Cust.Get(FileName) then
                Error(NoCustError, FileName);
            DocAttach.Init();
            DocAttach.Validate("Table ID", Database::Customer);
            DocAttach.Validate("No.", FileName);
            DocAttach.Validate("File Name", FileName);
            DocAttach.Validate("File Extension", FileExtension);
            DocAttach."Document Reference ID".ImportStream(EntryInStream, FileName);
            LineNo := LineNo + 1;
            DocAttach.Validate("Line No.", LineNo);
            DocAttach.Insert(true);
            FileCount += 1;

        end;
        //Close the zip file
        DataCompression.CloseZipArchive();
        if FileCount > 0 then
            Message(ImportedMsg, FileCount);
    end;

    local procedure ImportLinkAttachmentsFromZip()
    var
        FileMgt: Codeunit "File Management";
        DataCompression: Codeunit "Data Compression";
        TempBlob: Codeunit "Temp Blob";
        EntryList: List of [Text];
        EntryListKey: Text;
        ZipFileName: Text;
        FileName: Text;
        FileExtension: Text;
        InStream: InStream;
        EntryOutStream: OutStream;
        EntryInStream: InStream;
        Length: Integer;
        SelectZIPFileMsg: Label 'Select ZIP File';
        FileCount: Integer;
        Cust: Record Customer;
        RecordLink: Record "Record Link";
        RecordLinkID: Integer;
        NoCustError: Label 'Customer %1 does not exist.';
        ImportedMsg: Label '%1 attachments Linked successfully.';
        BaseURL1: text[250];
        BaseURL2: text[250];
    begin
        BaseURL1 := 'https://businesscentral.dynamics.com/27d4164d-4756-4199-891c-7ec9eb05372b/Sandbox?company=AM%20-%20Testing&page=21&dc=0&bookmark=15_EgAAAAJ7BTEAMAAwADAAMA';
        BaseURL2 := 'https://businesscentral.dynamics.com/27d4164d-4756-4199-891c-7ec9eb05372b/Sandbox?company=AM%20-%20Testing&page=21&dc=0&bookmark=15_EgAAAAJ7BTQAMAAwADAAMA';
        //Upload zip file
        if not UploadIntoStream(SelectZIPFileMsg, '', 'Zip Files|*.zip', ZipFileName, InStream) then
            Error('');
        //Extract zip file and store files to list type
        DataCompression.OpenZipArchive(InStream, false);
        DataCompression.GetEntryList(EntryList);
        FileCount := 0;

        RecordLink.Reset();
        if RecordLink.FindLast() then
            RecordLinkID := RecordLink."Link ID"
        else
            RecordLinkID := 0;

        //Loop files from the list type
        foreach EntryListKey in EntryList do begin
            FileName := CopyStr(FileMgt.GetFileNameWithoutExtension(EntryListKey), 1, MaxStrLen(FileName));
            FileName := CopyStr(FileName, 1, StrPos(FileName, '-') - 1);
            FileExtension := CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen(FileExtension));
            TempBlob.CreateOutStream(EntryOutStream);
            DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length);
            TempBlob.CreateInStream(EntryInStream);
            //Import each file where you want
            if not Cust.Get(FileName) then
                Error(NoCustError, FileName);
            FileCount += 1;

            RecordLinkID := RecordLinkID + 1;
            RecordLink.Init();
            RecordLink.Validate("Link ID", RecordLinkID);
            RecordLink.Validate(Company, CompanyName);
            RecordLink.Validate(Type, RecordLink.Type::Link);
            RecordLink.Validate(Created, CurrentDateTime);
            RecordLink.Validate("User Id", UserId);
            RecordLink.Validate("Record ID", Cust.RecordId);
            Evaluate(RecordLink.URL1, BaseURL1 + '/' + FileName + FileExtension);
            Evaluate(RecordLink.Description, FileName + FileExtension);
            RecordLink.Insert();
        end;
        //Close the zip file
        DataCompression.CloseZipArchive();
        if FileCount > 0 then
            Message(ImportedMsg, FileCount);
    end;
}