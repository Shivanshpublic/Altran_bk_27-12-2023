page 50038 "Run Caps"
{
    ApplicationArea = All;
    Caption = 'Run Caps';
    PageType = List;
    SourceTable = "Run Caps";

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
                field("Capacitor Shape"; Rec."Capacitor Shape")
                {
                    ToolTip = 'Specifies the value of the Capacitor Shape field.';
                }
                field("Operating Voltage"; Rec."Operating Voltage")
                {
                    ToolTip = 'Specifies the value of the Operating Voltage field.';
                }
                field("Options Code"; Rec."Options Code")
                {
                    ToolTip = 'Specifies the value of the Options Code field.';
                }
                field("Relative Class/Grade"; Rec."Relative Class/Grade")
                {
                    ToolTip = 'Specifies the value of the Relative Class/Grade field.';
                }
                field("Single/Dual"; Rec."Single/Dual")
                {
                    ToolTip = 'Specifies the value of the Single/Dual field.';
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
