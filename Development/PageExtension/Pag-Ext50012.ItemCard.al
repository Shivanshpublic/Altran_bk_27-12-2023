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
