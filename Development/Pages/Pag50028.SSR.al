page 50028 SSR
{
    ApplicationArea = All;
    Caption = 'SSR';
    PageType = List;
    SourceTable = SSR;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Control "; Rec."Control ")
                {
                    ToolTip = 'Specifies the value of the Control  field.';
                }
                field(Current; Rec.Current)
                {
                    ToolTip = 'Specifies the value of the Current field.';
                }
                field("Mounting "; Rec."Mounting ")
                {
                    ToolTip = 'Specifies the value of the Mounting  field.';
                }
                field("No of Phases"; Rec."No of Phases")
                {
                    ToolTip = 'Specifies the value of the No of Phases field.';
                }
                field("Output voltage"; Rec."Output voltage")
                {
                    ToolTip = 'Specifies the value of the Output voltage field.';
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
                field("Type "; Rec."Type ")
                {
                    ToolTip = 'Specifies the value of the Type  field.';
                }
            }
        }
    }
}
