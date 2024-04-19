page 50025 "Motors"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Motors';
    PageType = List;
    SourceTable = Motors;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Size(mm)"; Rec."Size(mm)")
                {
                    ApplicationArea = All;
                }
                field("Voltage 1"; Rec."Voltage 1")
                {
                    ApplicationArea = All;
                }
                field("Voltage 2"; Rec."Voltage 2")
                {
                    ApplicationArea = All;
                }
                field("Voltage 3"; Rec."Voltage 3")
                {
                    ApplicationArea = All;

                }
                field("HP 1"; Rec."HP 1")
                {
                    ApplicationArea = All;
                }
                field("HP 2"; Rec."HP 2")
                {
                    ApplicationArea = All;
                }
                field("HP 3"; Rec."HP 3")
                {
                    ApplicationArea = All;
                }
                field("Frequency 1 (Hz)"; Rec."Frequency 1 (Hz)")
                {
                    ApplicationArea = All;
                }
                field("Frequency 2 (Hz)"; Rec."Frequency 2 (Hz)")
                {
                    ApplicationArea = All;
                }
                field("RPM 1"; Rec."RPM 1")
                {
                    ApplicationArea = All;
                }
                field("RPM 2"; Rec."RPM 2")
                {
                    ApplicationArea = All;
                }
                field("RPM 3"; Rec."RPM 3")
                {
                    ApplicationArea = All;
                }
                field("RPM 4"; Rec."RPM 4")
                {
                    ApplicationArea = All;
                }
                field("Amps 1"; Rec."Amps 1")
                {
                    ApplicationArea = All;
                }
                field("Amps 2"; Rec."Amps 2")
                {
                    ApplicationArea = All;
                }
                field("Amps 3"; Rec."Amps 3")
                {
                    ApplicationArea = All;
                }
                field("Watts 1"; Rec."Watts 1")
                {
                    ApplicationArea = All;
                }
                field("Watts 2"; Rec."Watts 2")
                {
                    ApplicationArea = All;
                }
                field(Pole; Rec.Pole)
                {
                    ApplicationArea = All;
                }
                field(ph; rec.ph)
                {
                    ApplicationArea = All;
                }
                field(Insulation; Rec.Insulation)
                {
                    ApplicationArea = All;
                }
                field(Bracket; Rec.Bracket)
                {
                    ApplicationArea = All;
                }
                field(Enclosure; Rec.Enclosure)
                {
                    ApplicationArea = All;
                }
                field(Protection; Rec.Protection)
                {
                    ApplicationArea = All;
                }
                field("Start Cap (MFD)"; Rec."Start Cap (MFD)")
                {
                    ApplicationArea = All;
                }
                field("Run Cap (MFD)"; Rec."Run Cap (MFD)")
                {
                    ApplicationArea = All;
                }
                field(Rotation; Rec.Rotation)
                {
                    ApplicationArea = All;
                }

                field("Torque (Nm)"; Rec."Torque (Nm)")
                {
                    ApplicationArea = All;
                }
                field(IP; Rec.IP)
                {
                    ApplicationArea = All;
                }
                field("Shaft Di X Length (mm)"; Rec."Shaft Di X Length (mm)")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}

