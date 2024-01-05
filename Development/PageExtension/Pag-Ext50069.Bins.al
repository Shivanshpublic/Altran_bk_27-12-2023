pageextension 50069 BinsExt extends Bins
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
