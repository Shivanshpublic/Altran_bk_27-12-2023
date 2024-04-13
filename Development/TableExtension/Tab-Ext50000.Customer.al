TABLEEXTENSION 50000 "Ext Customer" EXTENDS Customer
{
    FIELDS
    {
        modify("Salesperson Code")
        {
            Caption = 'Sales Director';
        }

        FIELD(50000; "Internal Team"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Regional Manager';
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
        field(50002; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup";

            trigger OnValidate()
            var
                UserSetupMgt: Codeunit "User Setup Management";
                RespCenter: Record "Responsibility Center";
                Text061: Label '%1 is set up to process from %2 %3 only.';
            begin
                if not UserSetupMgt.CheckRespCenter(0, "Responsibility Center", "Assigned User ID") then
                    Error(
                      Text061, "Assigned User ID",
                      RespCenter.TableCaption(), UserSetupMgt.GetSalesFilter("Assigned User ID"));
            end;
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