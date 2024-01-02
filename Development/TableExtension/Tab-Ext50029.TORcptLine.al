tableextension 50029 TORcptLine extends "Transfer Receipt Line"
{
    fields
    {
        field(50014; "Shipment Tracking Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tracking Shipment Header";
            Editable = false;
        }
        field(57300; "Transfer-from Bin Code"; Code[20])
        {
            Caption = 'Transfer-from Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-from Code"),
                                            "Item Filter" = FIELD("Item No."),
                                            "Variant Filter" = FIELD("Variant Code"));
        }
    }
    procedure FilterPstdDocLnItemLedgEntries(var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Document No.");
        ItemLedgEntry.SetRange("Document No.", Rec."Document No.");
        ItemLedgEntry.SetRange("Document Type", ItemLedgEntry."Document Type"::"Transfer Receipt");
        ItemLedgEntry.SetRange("Document Line No.", Rec."Line No.");
        ItemLedgEntry.SetRange("Location Code", Rec."Transfer-to Code");
    end;

}
