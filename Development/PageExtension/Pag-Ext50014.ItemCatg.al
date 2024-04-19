pageextension 50014 ItemCatg extends "Item Categories"
{
    layout
    {
        addafter(Description)
        {
            field(Duties; Rec.Duties)
            {
                ApplicationArea = All;
            }
            field(Tariff; Rec.Tariff)
            {
                ApplicationArea = All;
            }
            field("Merchendise Processing fee"; Rec."Merchendise Processing fee")
            {
                ApplicationArea = All;
            }
            field("Harbor Maintenance fee"; Rec."Harbor Maintenance fee")
            {
                ApplicationArea = All;
            }
            field("Total Duties"; Rec."Total Duties")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("HS Code"; Rec."HS Code")
            {
                ApplicationArea = All;
            }
            field("HTS Code"; Rec."HTS Code")
            {
                ApplicationArea = All;
            }
            field("Item Tracking Code"; Rec."Item Tracking Code")
            {
                ApplicationArea = All;
            }
            field("Lot Nos."; Rec."Lot Nos.")
            {
                ApplicationArea = All;
            }
            field("Expiration Calculation"; Rec."Expiration Calculation")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action("Motors")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page Motors;
            }
            action("Blowers")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page Blowers;
            }
            action("DC")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page DC;
            }
            action("SSR")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page SSR;
            }
            action("DP")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page DP;
            }
            action("EMI Filters")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "EMI Filters";
            }
            action("Circuit Breakers")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Circuit Breakers";
            }
            action("XFMR")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "XFMR";
            }
            action("Voltage Monitors")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Voltage Monitors";
            }
            action("Relays")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Relays";
            }
            action("IEC Contactors")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "IEC Contactors";
            }
            action("Switch Disconnectors")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Switch Disconnectors";
            }
            action("Start Capacitors")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Start Capacitors";
            }
            action("Run Caps")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Run Caps";
            }
            action("PULLOUT-DSCN-SWITCH ")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "PULLOUT-DSCN-SWITCH ";
            }



        }
    }

}

