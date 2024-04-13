TABLEEXTENSION 50003 "Ext Sales Cr.Memo Header" EXTENDS "Sales Cr.Memo Header"
{
    FIELDS
    {
        modify("Salesperson Code")
        {
            Caption = 'Sales Director';
        }
        FIELD(50000; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Regional Manager';
            TableRelation = "Salesperson/Purchaser";
        }
        FIELD(50001; "External Rep"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}