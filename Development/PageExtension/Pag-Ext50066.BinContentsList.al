pageextension 50066 BinContentsListExt extends "Bin Contents List"
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
