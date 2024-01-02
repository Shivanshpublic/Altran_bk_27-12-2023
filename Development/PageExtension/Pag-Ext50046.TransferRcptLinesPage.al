pageextension 50046 "TransferRcptLinesPageExt" extends "Posted Transfer Receipt Lines"
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
    procedure GetSelectedRecords(var TempTranRcptLine: Record "Transfer Receipt Line" temporary)
    var
        TranRcptLine: Record "Transfer Receipt Line";
    begin
        CurrPage.SetSelectionFilter(TranRcptLine);
        if TranRcptLine.FindSet() then
            repeat
                TempTranRcptLine := TranRcptLine;
                TempTranRcptLine.Insert();
            until TranRcptLine.Next() = 0;
    end;
}
