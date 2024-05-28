page 50029 DP
{
    ApplicationArea = All;
    Caption = 'DP';
    PageType = List;
    SourceTable = DP;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Coil voltage"; Rec."Coil voltage")
                {
                    ToolTip = 'Specifies the value of the Coil voltage field.';
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