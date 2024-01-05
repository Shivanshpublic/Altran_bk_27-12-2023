pageextension 50067 BinContentsExt extends "Bin Contents"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Bin Description"; Rec."Bin Description")
            {
                ApplicationArea = All;
            }
        }
    }

}
