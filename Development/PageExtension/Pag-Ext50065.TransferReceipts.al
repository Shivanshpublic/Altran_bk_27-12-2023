pageextension 50065 "TransferReceiptsExt" extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {

        }
    }
    procedure GetSelectedRecords(var TempTranRcptHeader: Record "Transfer Receipt Header" temporary)
    var
        TranRcptHeader: Record "Transfer Receipt Header";
    begin
        CurrPage.SetSelectionFilter(TranRcptHeader);
        if TranRcptHeader.FindSet() then
            repeat
                TempTranRcptHeader := TranRcptHeader;
                TempTranRcptHeader.Insert();
            until TranRcptHeader.Next() = 0;
    end;

}
