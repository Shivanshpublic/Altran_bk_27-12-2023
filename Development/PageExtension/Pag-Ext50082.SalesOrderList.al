PAGEEXTENSION 50082 "Ext. Sales Order List" EXTENDS "Sales Order List"
{
    LAYOUT
    {


    }
    actions
    {
        modify(Release)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Sample Order (New)" = Rec."Sample Order (New)"::" " then
                    Error('Sample Order Value must not be blank.');
            end;
        }
    }
}