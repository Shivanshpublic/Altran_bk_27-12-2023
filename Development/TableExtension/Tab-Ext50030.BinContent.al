tableextension 50030 BinContent extends "Bin Content"
{
    fields
    {
        field(50000; "Bin Description"; Text[100])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatType = 1;
            CalcFormula = lookup(Customer.Name WHERE("No." = FIELD("Bin Code")));
            Caption = 'Bin Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

}
