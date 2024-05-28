pageextension 50058 CompanyInformationExt extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("Term Condition Report ID"; Rec."Term Condition Report ID")
            {
                ApplicationArea = All;
            }
            field("Home Page Custom"; Rec."Home Page Custom")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

}
