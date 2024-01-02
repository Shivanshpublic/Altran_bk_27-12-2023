query 50000 "ItemLotLocationCombination"
{
    Caption = 'Item Lot Location Combination';
    OrderBy = Ascending(Item_No);

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Lot_No; "Lot No.")
            {
            }
            // column(Sum_Qty_Base; Quantity)
            // {
            //     Method = Sum;
            // }
            column(Sum_Of_RemQty; "Remaining Quantity")
            {
                Method = Sum;
            }
        }
    }
}

