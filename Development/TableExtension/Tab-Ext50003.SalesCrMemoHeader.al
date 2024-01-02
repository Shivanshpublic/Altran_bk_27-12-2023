TABLEEXTENSION 50003 "Ext Sales Cr.Memo Header" EXTENDS "Sales Cr.Memo Header"
{
    FIELDS
    {
        FIELD(50000; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        FIELD(50001; "External Rep"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}