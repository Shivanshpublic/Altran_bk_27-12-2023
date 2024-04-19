page 50031 "Circuit Breakers"
{
    ApplicationArea = All;
    Caption = 'Circuit Breakers';
    PageType = List;
    SourceTable = "Circuit Breakers";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Number of poles "; Rec."Number of poles ")
                {
                    ToolTip = 'Specifies the value of the Number of poles  field.';
                }
                field("Rated Breaking Capacity"; Rec."Rated Breaking Capacity")
                {
                    ToolTip = 'Specifies the value of the Rated Breaking Capacity field.';
                }
                field("Rated current"; Rec."Rated current")
                {
                    ToolTip = 'Specifies the value of the Rated current field.';
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
                field(Voltage; Rec.Voltage)
                {
                    ToolTip = 'Specifies the value of the Voltage field.';
                }
            }
        }
    }
}
