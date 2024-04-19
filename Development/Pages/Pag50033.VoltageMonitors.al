page 50033 "Voltage Monitors"
{
    ApplicationArea = All;
    Caption = 'Voltage Monitors';
    PageType = List;
    SourceTable = "Voltage Monitors";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Delay Type (ON/OFF)"; Rec."Delay Type (ON/OFF)")
                {
                    ToolTip = 'Specifies the value of the Delay Type (ON/OFF) field.';
                }
                field("Delay from Phase Fault"; Rec."Delay from Phase Fault")
                {
                    ToolTip = 'Specifies the value of the Delay from Phase Fault field.';
                }
                field("Over Voltage"; Rec."Over Voltage")
                {
                    ToolTip = 'Specifies the value of the Over Voltage field.';
                }
                field("Phase Asymmetry"; Rec."Phase Asymmetry")
                {
                    ToolTip = 'Specifies the value of the Phase Asymmetry field.';
                }
                field("Power (ON/OFF) Delay"; Rec."Power (ON/OFF) Delay")
                {
                    ToolTip = 'Specifies the value of the Power (ON/OFF) Delay field.';
                }
                field("Special Requests"; Rec."Special Requests")
                {
                    ToolTip = 'Specifies the value of the Special Requests field.';
                }
                field("Supply Voltage"; Rec."Supply Voltage")
                {
                    ToolTip = 'Specifies the value of the Supply Voltage field.';
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
                field("Under Voltage"; Rec."Under Voltage")
                {
                    ToolTip = 'Specifies the value of the Under Voltage field.';
                }
            }
        }
    }
}
