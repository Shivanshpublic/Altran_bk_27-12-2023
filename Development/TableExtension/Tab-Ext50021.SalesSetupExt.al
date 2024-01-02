tableextension 50021 SalesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Surcharge Limit"; Decimal)
        {
            Caption = 'Surcharge Limit';
            DataClassification = CustomerContent;
        }
        field(50001; "Un earned surcharge account"; Code[20])
        {
            Caption = 'Un earned surcharge account';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where("Direct Posting" = filter(true));
        }
        field(50002; "Earned surcharge account"; Code[20])
        {
            Caption = 'Earned surcharge account';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where("Direct Posting" = filter(true));
        }

    }
}
