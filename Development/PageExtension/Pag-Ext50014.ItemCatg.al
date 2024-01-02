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
        }
    }
}
