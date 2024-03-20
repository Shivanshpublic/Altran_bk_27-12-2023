tableextension 50031 ItemChargeAssignmentPurch extends "Item Charge Assignment (Purch)"
{
    fields
    {
        field(50000; "Assigned By"; Enum ItemChargeAssnOption)
        {
            Editable = false;
        }
        field(50005; "Total Gross (KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(50006; "Total CBM"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(50007; "Unit Gross (KG)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Unit CBM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

}
