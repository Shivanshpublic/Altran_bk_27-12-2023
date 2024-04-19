page 50035 "IEC Contactors"
{
    ApplicationArea = All;
    Caption = 'IEC Contactors';
    PageType = List;
    SourceTable = "IEC Contactors";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Auxiliary contacts"; Rec."Auxiliary contacts")
                {
                    ToolTip = 'Specifies the value of the Auxiliary contacts field.';
                }
                field("Coil voltage"; Rec."Coil voltage")
                {
                    ToolTip = 'Specifies the value of the Coil voltage field.';
                }
                field("Number of poles"; Rec."Number of poles")
                {
                    ToolTip = 'Specifies the value of the Number of poles field.';
                }
                field(Polarity; Rec.Polarity)
                {
                    ToolTip = 'Specifies the value of the Polarity field.';
                }
                field("Rated current"; Rec."Rated current")
                {
                    ToolTip = 'Specifies the value of the Rated current field.';
                }
                field("Special options"; Rec."Special options")
                {
                    ToolTip = 'Specifies the value of the Special options field.';
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
            }
        }
    }
}
