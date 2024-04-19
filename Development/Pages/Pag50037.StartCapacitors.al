page 50037 "Start Capacitors"
{
    ApplicationArea = All;
    Caption = 'Start Capacitors';
    PageType = List;
    SourceTable = "Start Capacitors";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Capacitance; Rec.Capacitance)
                {
                    ToolTip = 'Specifies the value of the Capacitance field.';
                }
                field("Case ID"; Rec."Case ID")
                {
                    ToolTip = 'Specifies the value of the Case ID field.';
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
                field("Terminal Code"; Rec."Terminal Code")
                {
                    ToolTip = 'Specifies the value of the Terminal Code field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Voltage Rating"; Rec."Voltage Rating")
                {
                    ToolTip = 'Specifies the value of the Voltage Rating field.';
                }
            }
        }
    }
}
