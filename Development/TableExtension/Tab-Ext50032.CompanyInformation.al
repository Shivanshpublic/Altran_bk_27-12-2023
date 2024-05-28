tableextension 50032 CompanyInformation extends "Company Information"
{
    fields
    {
        field(50000; "Term Condition Report ID"; Integer)
        {

        }

        field(50035; "Home Page Custom"; Text[255])
        {
            Caption = 'Home Page Custom';
            ExtendedDatatype = URL;
        }
    }

}
