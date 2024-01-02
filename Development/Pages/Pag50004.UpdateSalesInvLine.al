page 50004 "Update Sales Inv Line"
{
    Caption = 'Sales Invoice Line';
    PageType = Card;
    SourceTable = "Sales Invoice Line";
    Permissions = tabledata "Sales Invoice Line" = RM;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Linked SO Line No."; Rec."Linked SO Line No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
