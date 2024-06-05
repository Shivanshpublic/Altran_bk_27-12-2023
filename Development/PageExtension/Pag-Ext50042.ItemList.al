pageextension 50042 ItemList extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field("Description 21"; Rec."Description 2")
            {
                ApplicationArea = All;
                Caption = 'Model No.';
            }
            field("UL Certificate Available"; Rec."UL Certificate Available")
            {
                ApplicationArea = All;
            }
            field("Item Status"; Rec."Item Status")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("HS Code"; Rec."HS Code")
            {
                ApplicationArea = All;
            }
            field("HTS Code"; Rec."HTS Code")
            {
                ApplicationArea = All;
            }
            field("No. of items/pallet"; Rec."No. of items/pallet")
            {
                ApplicationArea = All;
            }
            field("Estimated Annual Usage"; Rec."Estimated Annual Usage")
            {
                ApplicationArea = All;
            }
            field("LCL Cost per CBM"; Rec."LCL Cost per CBM")
            {
                ApplicationArea = All;
            }
            field("Item Weight in KG"; Rec."Item Weight in KG")
            {
                ApplicationArea = All;
            }
            field("Air Freight Cost per KG"; Rec."Air Freight Cost per KG")
            {
                ApplicationArea = All;
            }
            field("Item Volume1"; Rec."Item Volume")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action("Cost & Selling Price Calc.")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Cost & Selling Price Calc";
                RunPageLink = "Item No." = field("No.");
                trigger OnAction()
                begin

                end;
            }
        }
        addafter("&Units of Measure")
        {
            action("Item Volume")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Volume';
                Image = Item;
                RunObject = Page "Item Volumes";
                RunPageLink = "Item No." = FIELD("No.");
                ToolTip = 'Set up the different volumes that the item can be traded in.';
            }
        }
        addafter(RequestApproval)
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
        Item: Record Item;
        DocAttach: Record "Document Attachment";
        NoItemError: Label 'Item %1 does not exist.';
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
            //DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length);
            DataCompression.ExtractEntry(EntryListKey, EntryOutStream);
            TempBlob.CreateInStream(EntryInStream);
            //Import each file where you want
            Item.SetRange("Description 2", FileName);
            if not Item.FindFirst() then
                Error(NoItemError, FileName);
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
        FileName1: Text;
        FileExtension: Text;
        InStream: InStream;
        EntryOutStream: OutStream;
        EntryInStream: InStream;
        Length: Integer;
        SelectZIPFileMsg: Label 'Select ZIP File';
        FileCount: Integer;
        Item: Record Item;
        RecordLink: Record "Record Link";
        RecordLinkID: Integer;
        NoItemError: Label 'Item %1 does not exist.';
        ImportedMsg: Label '%1 attachments Linked successfully.';
        InventorySetup: Record "Inventory Setup";
        BaseURL1: text[2000];
        BaseURL2: text[2000];
    begin
        InventorySetup.Get();
        //BaseURL1 := 'https://businesscentral.dynamics.com/27d4164d-4756-4199-891c-7ec9eb05372b/Sandbox?company=AM%20-%20Testing&page=21&dc=0&bookmark=15_EgAAAAJ7BTEAMAAwADAAMA';
        BaseURL1 := InventorySetup."Sharepoint Item URL 1";
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
            FileName1 := FileName;
            FileName := CopyStr(FileName, 1, StrPos(FileName, ' ') - 1);
            FileExtension := CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen(FileExtension));
            TempBlob.CreateOutStream(EntryOutStream);
            //DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length);
            DataCompression.ExtractEntry(EntryListKey, EntryOutStream);
            TempBlob.CreateInStream(EntryInStream);
            //Import each file where you want
            Item.SetRange("Description 2", UpperCase(FileName));
            if not Item.FindFirst() then
                Error(NoItemError, FileName1);
            FileCount += 1;

            RecordLinkID := RecordLinkID + 1;
            RecordLink.Init();
            RecordLink.Validate("Link ID", RecordLinkID);
            RecordLink.Validate(Company, CompanyName);
            RecordLink.Validate(Type, RecordLink.Type::Link);
            RecordLink.Validate(Created, CurrentDateTime);
            RecordLink.Validate("User Id", UserId);
            RecordLink.Validate("Record ID", Item.RecordId);
            //older one
            //Evaluate(RecordLink.URL1, BaseURL1 + FileName1 + '.' + FileExtension);
            //New URL building
            Evaluate(RecordLink.URL1, StrSubstNo(BaseURL1, FileName1 + '.' + FileExtension));
            Evaluate(RecordLink.Description, FileName1 + '.' + FileExtension);
            RecordLink.Insert();
        end;
        //Close the zip file
        DataCompression.CloseZipArchive();
        if FileCount > 0 then
            Message(ImportedMsg, FileCount);
    end;
}
