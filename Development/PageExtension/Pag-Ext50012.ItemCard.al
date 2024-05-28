pageextension 50012 ItemCard extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Description 21"; Rec."Description 2")
            {
                ApplicationArea = All;
                Caption = 'Model No.';
            }
            field("UL Certificate Available"; Rec."UL Certificate Available")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Country of Origin"; Rec."Country of Origin")
            {
                ApplicationArea = All;
            }
        }
        addlast(Item)
        {
            field("HS Code"; Rec."HS Code")
            {
                ApplicationArea = All;
            }
            field("HTS Code"; Rec."HTS Code")
            {
                ApplicationArea = All;
            }
            field("No. of items/pallet"; Rec."No. of items/pallet")
            {
                ApplicationArea = All;
            }
            field("Estimated Annual Usage"; Rec."Estimated Annual Usage")
            {
                ApplicationArea = All;
            }
            field("LCL Cost per CBM"; Rec."LCL Cost per CBM")
            {
                ApplicationArea = All;
            }
            field("Item Weight in KG"; Rec."Item Weight in KG")
            {
                ApplicationArea = All;
            }
            field("Air Freight Cost per KG"; Rec."Air Freight Cost per KG")
            {
                ApplicationArea = All;
            }
            field("Item Volume1"; Rec."Item Volume")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("UL"; Rec."UL")
            {
                ApplicationArea = All;
            }
            field("CUL"; Rec."CUL")
            {
                ApplicationArea = All;
            }
            field("TUV"; Rec."TUV")
            {
                ApplicationArea = All;
            }
            field("VDE"; Rec."VDE")
            {
                ApplicationArea = All;
            }
            field("SEMKO"; Rec."SEMKO")
            {
                ApplicationArea = All;
            }
            field("DEMKO"; Rec."DEMKO")
            {
                ApplicationArea = All;
            }
            field("ENEC"; Rec."ENEC")
            {
                ApplicationArea = All;
            }
            field("CSA"; Rec."CSA")
            {
                ApplicationArea = All;
            }
            field("CE"; Rec."CE")
            {
                ApplicationArea = All;
            }
            field("No of items/box"; Rec."No of items/box")
            {
                ApplicationArea = All;
            }
        }
        modify("Unit Cost")
        {
            Visible = EnableCost;
            Editable = EnableCost;
        }
        modify("Last Direct Cost")
        {
            Visible = EnableCost;
            Editable = EnableCost;
        }
        addlast(content)
        {
            part(ItemSpecLines; "Item Specification Subpage")
            {
                ApplicationArea = Suite;
                SubPageLink = "Item No." = FIELD("No.");
                SubPageView = SORTING("Item No.", Specification);
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action("Cost & Selling Price Calc.")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Cost & Selling Price Calc";
                RunPageLink = "Item No." = field("No.");
                trigger OnAction()
                begin

                end;
            }
            action("Item Specifications")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Item Specification";
                RunPageLink = "Item No." = field("No.");
            }
            action("Update UL Certificate")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Codeunit "UpdateULCertificate";
                trigger OnAction()
                begin

                end;
            }
        }
        addafter("&Units of Measure")
        {
            action("Item Volume")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Volume';
                Image = Item;
                RunObject = Page "Item Volumes";
                RunPageLink = "Item No." = FIELD("No.");
                ToolTip = 'Set up the different volumes that the item can be traded in.';
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        EnableCost := false;
        if Usersetup.Get(UserId) then begin
            if UserSetup."View Cost" then
                EnableCost := true;
        end;
    end;

    var
        EnableCost: Boolean;
}
