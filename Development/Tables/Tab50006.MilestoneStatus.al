table 50006 "Milestone Status"
{
    Caption = 'Milestone Status';
    DataClassification = ToBeClassified;
    LookupPageId = Milestone;
    DrillDownPageId = Milestone;
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
