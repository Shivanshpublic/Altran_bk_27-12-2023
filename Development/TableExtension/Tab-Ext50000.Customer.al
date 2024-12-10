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
        field(50080; "Bin Content Exist"; Boolean)
        {
            CalcFormula = Exist("Bin Content" WHERE("Bin Code" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50081; "Bin Exist"; Boolean)
        {
            CalcFormula = Exist("Bin Content" WHERE("Bin Code" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }

    }
    trigger OnInsert()
    begin
        Blocked := Blocked::All;
    end;

    trigger OnModify()
    begin
        if xRec.Blocked <> Rec.Blocked then
            if Blocked <> Blocked::All then
                CheckMandatoryFields();
    end;

    PROCEDURE LookupOnExternalRep()
    VAR
        SalesPersonList: Page "Salespersons/Purchasers";
    BEGIN
        SalesPersonList.LOOKUPMODE(TRUE);
        IF SalesPersonList.RUNMODAL = ACTION::LookupOK THEN
            VALIDATE("External Rep", SalesPersonList.GetSelectionFilter);
    END;

    procedure CheckMandatoryFields()

    BEGIN
        Rec.TestField("Salesperson Code");
        Rec.TestField("Internal Team");
        //Rec.TestField("External Rep");
        Rec.TestField("Address");
        Rec.TestField("City");
        Rec.TestField("Post Code");
        if Rec."Country/Region Code" = 'US' then
            Rec.TestField(Rec.County);
        Rec.TestField(Rec."Country/Region Code");
        Rec.TestField(Rec."Phone No.");
    END;
}