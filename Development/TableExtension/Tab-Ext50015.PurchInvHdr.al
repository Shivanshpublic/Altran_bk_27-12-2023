tableextension 50015 PurchInvHdr extends "Purch. Inv. Header"
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
        field(50139; "Prepmt. Posting Description"; Text[100])
        {
            Caption = 'Prepmt. Posting Description';
        }
        modify("Expected Receipt Date")
        {
            Caption = 'Expected To Arrive';
        }
    }
}
