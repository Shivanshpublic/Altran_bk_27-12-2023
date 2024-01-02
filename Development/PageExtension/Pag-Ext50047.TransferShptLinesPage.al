pageextension 50047 "TransferShptLinesPageExt" extends "Posted Transfer Shipment Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Description 21"; Rec."Description 2")
            {
                ApplicationArea = all;
                Caption = 'Model No.';
            }
            field("Shipment Tracking Code"; Rec."Shipment Tracking Code")
            {
                ApplicationArea = all;
            }
        }
    }
    procedure GetSelectedRecords(var TempTranShptLine: Record "Transfer Shipment Line" temporary)
    var
        TranShptLine: Record "Transfer Shipment Line";
    begin
        CurrPage.SetSelectionFilter(TranShptLine);
        if TranShptLine.FindSet() then
            repeat
                TempTranShptLine := TranShptLine;
                TempTranShptLine.Insert();
            until TranShptLine.Next() = 0;
    end;

}
