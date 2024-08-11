TABLEEXTENSION 50039 "Ext Location" EXTENDS Location
{
    FIELDS
    {
        field(50080; "Bin Content Exist"; Boolean)
        {
            CalcFormula = Exist("Bin Content" WHERE("Location Code" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

}