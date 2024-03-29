pageextension 50041 ItemSurchargePurch extends "Item Charge Assignment (Purch)"
{
    layout
    {
        modify("<Gross Weight>")
        {
            Caption = 'Pallet Quantity';
            Visible = PalletQtyVisible;
        }
        modify("<Unit Volume>")
        {
            Caption = 'Quantity Per Pallet';
            Visible = PalletQtyVisible;
        }
        addafter("<Gross Weight>")
        {
            field("Assigned By"; Rec."Assigned By")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Total CBM"; Rec."Total CBM")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = CBMVisible;
            }
            field("Total Gross (KG)"; Rec."Total Gross (KG)")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = GrossKGVisible;
            }
        }
    }
    var
        PalletQtyVisible: Boolean;
        CBMVisible: Boolean;
        GrossKGVisible: Boolean;

    trigger OnAfterGetRecord()
    begin
        CBMVisible := true;
        GrossKGVisible := true;
        PalletQtyVisible := true;

        if Rec."Assigned By" = Rec."Assigned By"::"Total CBM" then begin
            CBMVisible := true;
            GrossKGVisible := false;
            PalletQtyVisible := false;
        end;
        if Rec."Assigned By" = Rec."Assigned By"::"Total Gross (KG)" then begin
            CBMVisible := false;
            GrossKGVisible := true;
            PalletQtyVisible := false;
        end;
        if Rec."Assigned By" = Rec."Assigned By"::" " then begin
            CBMVisible := false;
            GrossKGVisible := false;
            PalletQtyVisible := true;
        end;

    end;


}
