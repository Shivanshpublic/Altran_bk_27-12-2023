pageextension 50070 BinListExt extends "Bin List"
{
    layout
    {
        addafter(Description)
        {
            field("Bin Description"; Rec."Bin Description")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

}
