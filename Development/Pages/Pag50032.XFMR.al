page 50032 XFMR
{
    ApplicationArea = All;
    Caption = 'XFMR';
    PageType = List;
    SourceTable = XFMR;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Core Rating"; Rec."Core Rating")
                {
                    ToolTip = 'Specifies the value of the Core Rating field.';
                }
                field("Core Size"; Rec."Core Size")
                {
                    ToolTip = 'Specifies the value of the Core Size field.';
                }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.';
                }
                field(Mounting; Rec.Mounting)
                {
                    ToolTip = 'Specifies the value of the Mounting field.';
                }
                field(Packaging; Rec.Packaging)
                {
                    ToolTip = 'Specifies the value of the Packaging field.';
                }
                field("Primary/Secondary Voltage"; Rec."Primary/Secondary Voltage")
                {
                    ToolTip = 'Specifies the value of the Primary/Secondary Voltage field.';
                }
                field(Protection; Rec.Protection)
                {
                    ToolTip = 'Specifies the value of the Protection field.';
                }
                field("Special Requests"; Rec."Special Requests")
                {
                    ToolTip = 'Specifies the value of the Special Requests field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field(Termination; Rec.Termination)
                {
                    ToolTip = 'Specifies the value of the Termination field.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}
