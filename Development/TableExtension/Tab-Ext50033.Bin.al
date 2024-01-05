tableextension 50033 BinExt extends Bin
{
    fields
    {
        field(50000; "Bin Description"; Text[100])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatType = 1;
            CalcFormula = lookup(Customer.Name WHERE("No." = FIELD("Code")));
            Caption = 'Bin Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Bin Description") { }
    }
}
