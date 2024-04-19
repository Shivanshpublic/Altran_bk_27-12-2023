page 50030 "EMI Filters"
{
    ApplicationArea = All;
    Caption = 'EMI Filters';
    PageType = List;
    SourceTable = "EMI Filters";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Capacitance (Cx)"; Rec."Capacitance (Cx)")
                {
                    ToolTip = 'Specifies the value of the Capacitance (Cx) field.';
                }
                field("Capacitance (Cy)"; Rec."Capacitance (Cy)")
                {
                    ToolTip = 'Specifies the value of the Capacitance (Cy) field.';
                }
                field(Current; Rec.Current)
                {
                    ToolTip = 'Specifies the value of the Current field.';
                }
                field(Inductance; Rec.Inductance)
                {
                    ToolTip = 'Specifies the value of the Inductance field.';
                }
                field(Leakage; Rec.Leakage)
                {
                    ToolTip = 'Specifies the value of the Leakage field.';
                }
                field(Resistor; Rec.Resistor)
                {
                    ToolTip = 'Specifies the value of the Resistor field.';
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
                field("Type "; Rec."Type ")
                {
                    ToolTip = 'Specifies the value of the Type  field.';
                }
                field(Voltage; Rec.Voltage)
                {
                    ToolTip = 'Specifies the value of the Voltage field.';
                }
            }
        }
    }
}
