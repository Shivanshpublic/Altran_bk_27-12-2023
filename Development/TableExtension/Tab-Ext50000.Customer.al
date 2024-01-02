TABLEEXTENSION 50000 "Ext Customer" EXTENDS Customer
{
    FIELDS
    {
        FIELD(50000; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        FIELD(50001; "External Rep"; Text[250])
        {
            DataClassification = ToBeClassified;

            TRIGGER OnValidate()
            VAR
                SalesPerson: Record "Salesperson/Purchaser";
            BEGIN
                IF "External Rep" <> '' THEN BEGIN
                    SalesPerson.RESET;
                    SalesPerson.SETFILTER(Code, "External Rep");
                    IF NOT SalesPerson.FINDFIRST THEN
                        ERROR('The selected External Rep is not valid');
                END;
            END;

            TRIGGER OnLookup()
            BEGIN
                LookupOnExternalRep();
            END;
        }
    }

    PROCEDURE LookupOnExternalRep()
    VAR
        SalesPersonList: Page "Salespersons/Purchasers";
    BEGIN
        SalesPersonList.LOOKUPMODE(TRUE);
        IF SalesPersonList.RUNMODAL = ACTION::LookupOK THEN
            VALIDATE("External Rep", SalesPersonList.GetSelectionFilter);
    END;
}