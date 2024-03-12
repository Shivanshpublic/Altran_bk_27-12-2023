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
        field(50005; "HS Code"; Code[50])
        {
            Caption = 'HS Code';
            DataClassification = ToBeClassified;
        }
        field(50006; "HTS Code"; Code[50])
        {
            Caption = 'HTS Code';
            DataClassification = ToBeClassified;
        }
        field(50007; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";
        }
        field(50008; "Lot Nos."; Code[20])
        {
            Caption = 'Lot Nos.';
            TableRelation = "No. Series";

        }
        field(50009; "Expiration Calculation"; DateFormula)
        {
            Caption = 'Expiration Calculation';
        }
    }
    local procedure CalcTotalDuties()
    begin
        "Total Duties" := Duties + "Merchendise Processing fee" + "Harbor Maintenance fee";
    end;
}
