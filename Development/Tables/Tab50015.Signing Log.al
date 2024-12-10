table 50015 "Sign Log"
{
    Caption = 'Sign Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Sign Status"; Boolean)
        {
            Caption = 'Sign Status';
        }
        field(11; "User Id"; Code[50])
        {
            Caption = 'User Id';
        }
        field(12; "Date Time"; DateTime)
        {
            Caption = 'Date Time';
        }
        field(13; "Document No."; Code[20])
        {
            Caption = 'Date Time';
        }
        field(14; "Ref. Doc. No."; Code[20])
        {
            Caption = 'Reference Document No.';
        }
        field(120; Status; Enum "Sales Document Status")
        {
            Caption = 'Status';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    procedure SignOrderDocument(SalesHeader: Record "Sales Header")
    var
        Question: Text;
        Answer: Boolean;
        Text000Lbl: Label 'Have you verified the order?';
    begin
        SalesHeader.TestField(Status, SalesHeader.Status::Released);
        Question := Text000Lbl;
        Answer := Dialog.Confirm(Question, false);
        if Answer = false then
            Error('Action Cancelled');
        SalesHeader."Order Signed" := true;
        SalesHeader.Modify();
        InsertSignLog(SalesHeader."No.", '', SalesHeader."Order Signed", SalesHeader.Status);
    end;

    procedure InsertSignLog(DocNo: Code[20]; RefDocNo: Code[20]; SignStatus: Boolean; OrderStatus: Enum "Sales Document Status")
    var
        SignLog: Record "Sign Log";
    begin
        SignLog.Init();
        SignLog."Date Time" := CurrentDateTime;
        SignLog."User Id" := UserId;
        SignLog."Ref. Doc. No." := RefDocNo;
        SignLog."Document No." := DocNo;
        SignLog."Sign Status" := SignStatus;
        SignLog."Status" := OrderStatus;
        SignLog.Insert(true);
    end;
}
