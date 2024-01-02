pageextension 50064 "TransferShipmentsExt" extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {

        }
    }
    procedure GetSelectedRecords(var TempTranShptHeader: Record "Transfer Shipment Header" temporary)
    var
        TranShptHeader: Record "Transfer Shipment Header";
    begin
        CurrPage.SetSelectionFilter(TranShptHeader);
        if TranShptHeader.FindSet() then
            repeat
                TempTranShptHeader := TranShptHeader;
                TempTranShptHeader.Insert();
            until TranShptHeader.Next() = 0;
    end;

}
