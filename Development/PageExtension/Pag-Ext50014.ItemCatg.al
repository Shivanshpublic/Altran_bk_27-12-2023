pageextension 50014 ItemCatg extends "Item Categories"
{
    layout
    {
        addafter(Description)
        {
            field(Duties; Rec.Duties)
            {
                ApplicationArea = All;
            }
            field(Tariff; Rec.Tariff)
            {
                ApplicationArea = All;
            }
            field("Merchendise Processing fee"; Rec."Merchendise Processing fee")
            {
                ApplicationArea = All;
            }
            field("Harbor Maintenance fee"; Rec."Harbor Maintenance fee")
            {
                ApplicationArea = All;
            }
            field("Total Duties"; Rec."Total Duties")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("HS Code"; Rec."HS Code")
            {
                ApplicationArea = All;
            }
            field("HTS Code"; Rec."HTS Code")
            {
                ApplicationArea = All;
            }
            field("Item Tracking Code"; Rec."Item Tracking Code")
            {
                ApplicationArea = All;
            }
            field("Lot Nos."; Rec."Lot Nos.")
            {
                ApplicationArea = All;
            }
            field("Expiration Calculation"; Rec."Expiration Calculation")
            {
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        addfirst(processing)
        {
            action("Specifications")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Specification List";
            }
            action("Item Category Specifications")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Item Category Specification";
                RunPageLink = ItemCategory = field(Code);
            }
            action("Apply Item Category Specifications")
            {
                ApplicationArea = All;
                ToolTip = 'Apply Item Category Specification to linked Items';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ItemCategory: Record "Item Category";
                    ItemCatSpec: Record "Item Category Specification";
                    ItemSpec: Record "Item Specification";
                    Item: Record Item;
                begin
                    Item.Reset();
                    Item.SetRange("Item Category Code", Rec.Code);
                    if Item.FindFirst() then
                        repeat
                            ItemCatSpec.Reset();
                            ItemCatSpec.SetRange(ItemCategory, Item."Item Category Code");
                            if ItemCatSpec.FindFirst() then
                                repeat
                                    ItemSpec.Init();
                                    ItemSpec."Item No." := Item."No.";
                                    ItemSpec.Specification := ItemCatSpec.Specification;
                                    if ItemSpec.Insert() then;
                                until ItemCatSpec.Next() = 0;
                        until Item.Next() = 0;
                end;
            }
        }
    }

}

