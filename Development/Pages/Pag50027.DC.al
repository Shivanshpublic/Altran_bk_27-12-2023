page 50027 DC
{
    ApplicationArea = All;
    Caption = 'DC';
    PageType = List;
    SourceTable = DC;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Axuiliary Contact Config."; Rec."Axuiliary Contact Config.")
                {
                }
                field("Coil Power W"; Rec."Coil Power W")
                {
                }
                field("Coil Voltage VDC"; Rec."Coil Voltage VDC")
                {
                }
                field("Contact Configuration"; Rec."Contact Configuration")
                {
                }
                field("Humidity w/o Ice/Dew"; Rec."Humidity w/o Ice/Dew")
                {
                }
                field("Pull in Time M Sec Max"; Rec."Pull in Time M Sec Max")
                {
                }
                field("Pull in Voltage VDC"; Rec."Pull in Voltage VDC")
                {
                }
                field("Release Time M Sec Max"; Rec."Release Time M Sec Max")
                {
                }
                field("Release Voltage VDC"; Rec."Release Voltage VDC")
                {
                }
                field("Storage - C"; Rec."Storage - C")
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
                field("Working - C"; Rec."Working - C")
                {
                }
            }
        }
    }
}
