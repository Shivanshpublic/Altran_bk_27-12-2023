tableextension 50022 RequisitionLineExt extends "Requisition Line"
{
    fields
    {
        field(50000; "SO No."; code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(50001; "SO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Sales Line"."Line No." where("Document Type" = const(Order), "Document No." = field("SO No."));
        }

    }
}
