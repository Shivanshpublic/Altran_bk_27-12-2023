pageextension 50068 BinContentExt extends "Bin Content"
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
