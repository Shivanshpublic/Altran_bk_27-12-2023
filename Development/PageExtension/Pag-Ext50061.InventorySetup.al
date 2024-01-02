pageextension 50061 InventorySetupExt extends "Inventory Setup"
{
    layout
    {
        addafter("Package Nos.")
        {
            field("Sharepoint Item URL 1"; rec."Sharepoint Item URL 1")
            {
                ApplicationArea = All;
            }
        }
    }

}
