tableextension 50034 PriceListLine extends "Price List Line"
{
    fields
    {
        field(50000; "Description 2"; Text[50])
        {
            Caption = 'Model No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        modify("Product No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                If Item.Get("Product No.") then
                    "Description 2" := Item."Description 2"
                else
                    "Description 2" := '';
            end;
        }
    }
}
