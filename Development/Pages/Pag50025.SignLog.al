page 50025 "Sign Log"
{
    ApplicationArea = All;
    Caption = 'Sales Order Sign Log';
    PageType = List;
    SourceTable = "Sign Log";
    UsageCategory = History;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Date Time"; Rec."Date Time")
                {
                    ToolTip = 'Specifies the value of the Date Time field.', Comment = '%';
                }
                field("User Id1"; Rec."User Id")
                {
                    ToolTip = 'Specifies the value of the User Id field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Sales Order Status field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Date Time field.', Comment = '%';
                }
                field("Ref. Doc. No."; Rec."Ref. Doc. No.")
                {
                    ToolTip = 'Specifies the value of the Reference Document No. field.', Comment = '%';
                }
                field("Sign Status"; Rec."Sign Status")
                {
                    ToolTip = 'Specifies the value of the Sign Status field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field("User Id"; Rec."User Id")
                {
                    ToolTip = 'Specifies the value of the User Id field.', Comment = '%';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
            }
        }
    }
}
