tableextension 50025 ItemLedgerEntryExt extends "Item Ledger Entry"
{
    fields
    {
        field(50014; "Item Type"; Enum "Item Type")
        {
            CalcFormula = lookup(Item.Type WHERE("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
