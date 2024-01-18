pageextension 50067 BinContentsExt extends "Bin Contents"
{
    layout
    {
        addafter("Item No.")
        {
            field("Bin Description"; Rec."Bin Description")
            {
                ApplicationArea = All;
            }
        }
    }

}
