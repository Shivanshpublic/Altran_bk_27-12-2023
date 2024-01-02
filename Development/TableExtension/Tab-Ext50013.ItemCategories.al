tableextension 50013 "Item Categories" extends "Item Category"
{
    fields
    {
        field(50000; Duties; Decimal)
        {
            Caption = 'Duties';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalcTotalDuties();
            end;
        }
        field(50001; "Merchendise Processing fee"; Decimal)
        {
            Caption = 'Merchendise Processing fee';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalcTotalDuties();
            end;
        }
        field(50002; "Harbor Maintenance fee"; Decimal)
        {
            Caption = 'Harbor Maintenance fee';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalcTotalDuties();
            end;
        }
        field(50003; "Total Duties"; Decimal)
        {
            Caption = 'Total Duties';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Tariff"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    local procedure CalcTotalDuties()
    begin
        "Total Duties" := Duties + "Merchendise Processing fee" + "Harbor Maintenance fee";
    end;
}
