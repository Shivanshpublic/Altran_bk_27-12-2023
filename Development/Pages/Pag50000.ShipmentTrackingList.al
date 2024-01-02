PAGE 50000 "Shipment Tracking List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tracking Shipment Header";
    CardPageId = "Shipment Tracking Card";

    LAYOUT
    {
        AREA(Content)
        {
            REPEATER(GroupName)
            {
                FIELD("Tracking Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                FIELD(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                FIELD("Sub Status"; Rec."Sub Status")
                {
                    ApplicationArea = All;
                }
                FIELD("Surcharge Allocated to SO"; Rec."Surcharge Allocated to SO")
                {
                    ApplicationArea = All;
                }
                FIELD("Container No."; Rec."Container No.")
                {
                    ApplicationArea = All;
                }
                FIELD("Port of Dispatch"; Rec."Port of Dispatch")
                {
                    ApplicationArea = All;
                }
                FIELD("Date of Dispatch"; Rec."Date of Dispatch")
                {
                    ApplicationArea = All;
                }
                FIELD("Freight Details"; Rec."Freight Details")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    ACTIONS
    {
        AREA(Processing)
        {
            ACTION("Shipment Tracking Log")
            {
                Image = Log;
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;
                RunObject = PAGE "Shipment Tracking Log";
                RunPageLink = "Tracking Code" = FIELD(Code);
            }
        }
    }
}