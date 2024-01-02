pageextension 50018 VendorLedEntry extends "Vendor Ledger Entries"
{
    actions
    {
        addlast(processing)
        {
            action("Print Remittance Advice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Remittance Advice';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RecVendorLed: Record "Vendor Ledger Entry";
                    RemittanceAdvice: Report "Remittance Advice";
                begin
                    Clear(RemittanceAdvice);
                    Clear(RecVendorLed);
                    RecVendorLed.SetRange("Entry No.", Rec."Entry No.");
                    RecVendorLed.SetRange("Vendor No.", Rec."Vendor No.");
                    RecVendorLed.FindFirst();
                    RemittanceAdvice.SetTableView(RecVendorLed);
                    RemittanceAdvice.Run();
                end;
            }

        }
    }
}
