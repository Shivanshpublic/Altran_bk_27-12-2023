page 50034 Relays
{
    ApplicationArea = All;
    Caption = 'Relays';
    PageType = List;
    SourceTable = Relays;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Coil Voltage"; Rec."Coil Voltage")
                {
                    ToolTip = 'Specifies the value of the Coil Voltage field.';
                }
                field("Contact Form"; Rec."Contact Form")
                {
                    ToolTip = 'Specifies the value of the Contact Form field.';
                }
                field("Contact Material"; Rec."Contact Material")
                {
                    ToolTip = 'Specifies the value of the Contact Material field.';
                }
                field("Contact Ratings"; Rec."Contact Ratings")
                {
                    ToolTip = 'Specifies the value of the Contact Ratings field.';
                }
                field("Insulation Class"; Rec."Insulation Class")
                {
                    ToolTip = 'Specifies the value of the Insulation Class field.';
                }
                field(Mounting; Rec.Mounting)
                {
                    ToolTip = 'Specifies the value of the Mounting field.';
                }
                field(Packaging; Rec.Packaging)
                {
                    ToolTip = 'Specifies the value of the Packaging field.';
                }
                field(Sealing; Rec.Sealing)
                {
                    ToolTip = 'Specifies the value of the Sealing field.';
                }
                field(Series; Rec.Series)
                {
                    ToolTip = 'Specifies the value of the Series field.';
                }
                field("Special Functions"; Rec."Special Functions")
                {
                    ToolTip = 'Specifies the value of the Special Functions field.';
                }
                field("Special Requests"; Rec."Special Requests")
                {
                    ToolTip = 'Specifies the value of the Special Requests field.';
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
