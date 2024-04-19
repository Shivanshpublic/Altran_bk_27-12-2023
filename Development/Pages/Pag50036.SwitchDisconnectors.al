page 50036 "Switch Disconnectors"
{
    ApplicationArea = All;
    Caption = 'Switch Disconnectors';
    PageType = List;
    SourceTable = "Switch Disconnectors";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Mounting; Rec.Mounting)
                {
                    ToolTip = 'Specifies the value of the Mounting field.';
                }
                field("Number of poles "; Rec."Number of poles ")
                {
                    ToolTip = 'Specifies the value of the Number of poles  field.';
                }
                field("Rated current"; Rec."Rated current")
                {
                    ToolTip = 'Specifies the value of the Rated current field.';
                }
                field("Special options"; Rec."Special options")
                {
                    ToolTip = 'Specifies the value of the Special options field.';
                }
                field("Switch Color"; Rec."Switch Color")
                {
                    ToolTip = 'Specifies the value of the Switch Color field.';
                }
                field("Switch Type"; Rec."Switch Type")
                {
                    ToolTip = 'Specifies the value of the Switch Type field.';
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
            }
        }
    }
}
