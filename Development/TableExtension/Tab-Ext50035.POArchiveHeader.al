tableextension 50035 POArchiveHeader extends "Purchase Header Archive"
{
    fields
    {
        field(50010; "Country of Origin"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50011; "Country of provenance"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50012; "Country of Acquisition"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50013; "Milestone Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Milestone Status";
            Caption = 'Order Status';
        }
        field(50014; "VIA"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(61120; "PO Exists"; Boolean)
        {
            CalcFormula = exist("Purchase Header" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;

        }
        field(61121; "Latest Version"; Integer)
        {
            CalcFormula = max("Purchase Header Archive"."Version No." WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(61122; "Old Version"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
 
}
