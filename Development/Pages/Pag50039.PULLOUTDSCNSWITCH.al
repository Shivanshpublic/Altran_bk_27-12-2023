page 50039 "PULLOUT-DSCN-SWITCH "
{
    ApplicationArea = All;
    Caption = 'PULLOUT-DSCN-SWITCH ';
    PageType = List;
    SourceTable = "PULLOUT-DSCN-SWITCH ";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Fuse; Rec.Fuse)
                {
                    ToolTip = 'Specifies the value of the Fuse field.';
                }
                field(Material; Rec.Material)
                {
                    ToolTip = 'Specifies the value of the Material field.';
                }
                field("Rated Current"; Rec."Rated Current")
                {
                    ToolTip = 'Specifies the value of the Rated Current field.';
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
