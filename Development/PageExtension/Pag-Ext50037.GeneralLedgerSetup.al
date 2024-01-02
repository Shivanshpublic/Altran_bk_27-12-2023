pageextension 50037 GeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            field("Shipment Tracking Nos."; Rec."Shipment Tracking Nos.")
            {
                ApplicationArea = All;
            }
        }
    }
}
