page 50020 "ST Processor Activities Qty"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Shipment Tracking Cue";
    Permissions = tabledata "Shipment Tracking Cue" = rm;
    //ShowFilter = false;
    layout
    {
        area(content)
        {
            cuegroup("Quantity of Products")
            {
                Caption = 'Quantity of Products';
                field("Quantity in-Transit"; Rec."Quantity in-Transit")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products in-Transit.';
                }
                field("Quantity In-Production"; Rec."Quantity In-Production")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products In-Production.';
                }
                field("Quantity Pending to Ship"; Rec."Quantity Pending to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Pending to Ship.';
                }
                field("Quantity Needs Action"; Rec."Quantity Needs Action")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Needs Action.';
                }
                field("Quantity Booked"; Rec."Quantity Booked")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Booked.';
                }
                field("Quantity Arrived at Warehouse"; Rec."Quantity Arr. at Warehouse")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Arrived at Warehouse.';
                }
                field("Quantity TLX Released Required"; Rec."Quantity TLX Released Required")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products TLX Released Required.';
                }
                field("Quantity ARRIVED - CUST"; Rec."Quantity ARRIVED - CUST")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products ARRIVED - CUST.';
                }
                field("Quantity ARRIVED - POD"; Rec."Quantity ARRIVED - POD")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products ARRIVED - POD.';
                }
                field("Quantity at Sterling"; Rec."Quantity at Sterling")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                    ToolTip = 'Specifies the value of Products at Sterling.';
                }
                field("Quantity at POL"; Rec."Quantity at POL")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                    ToolTip = 'Specifies the value of Products at POL.';
                }
                field("Quantity Open Sales Orders"; Rec."Quantity of Open Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Lines";
                    ToolTip = 'Specifies the value of Open Sales Orders.';
                }
                field("Open Purchase Orders"; Rec."Qty. of Open Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Open Purchase Orders.';
                }
                field("Posted Sales Invoice"; Rec."Qty. of Posted Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Invoice Lines";
                    ToolTip = 'Specifies the value of Posted Sales Invoice.';
                }
                field("Posted Sales Cr.Memo"; Rec."Qty. of Post. Sales Cr. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Credit Memo Lines";
                    ToolTip = 'Specifies the value of Posted Sales Cr. Memo.';
                }
                field("Posted Purchase Invoice"; Rec."Qty. of Posted Purch. Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Purchase Invoice Lines";
                    ToolTip = 'Specifies the value of Posted Purchase Invoice.';
                }
                field("Posted Purchase Cr.Memo"; Rec."Qty. of Post. Purch. Cr.Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Purchase Cr. Memo Lines";
                    ToolTip = 'Specifies the value of Posted Purchase Cr. Memo.';
                }
                field("Open Sales Quotes"; Rec."Quantity of Open Sales Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Lines";
                    ToolTip = 'Specifies the value of Open Sales Quotes.';
                }

                field("Products Per Location"; Rec."Total Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Quantities Per Location';
                    DrillDownPageID = "Items by Location";
                    ToolTip = 'Specifies the value of Total Quantities Per Location.';

                    trigger OnDrillDown()
                    var
                        PagProdPerLocation: Page "Items by Location";
                    begin
                        Clear(PagProdPerLocation);
                        PagProdPerLocation.RunModal();
                    end;
                }

            }

        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CuesAndKpis.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }



    trigger OnAfterGetCurrRecord()
    begin
        O365GettingStartedMgt.UpdateGettingStartedVisible(TileGettingStartedVisible, ReplayGettingStartedVisible);
    end;

    trigger OnInit()
    var
        JobsSetup: Record "Jobs Setup";
        MyCompName: Text;
    begin
        O365GettingStartedMgt.UpdateGettingStartedVisible(TileGettingStartedVisible, ReplayGettingStartedVisible);

        SetupIsComplete := false;

        MyCompName := CompanyName;

        if JobsSetup.FindFirst() then
            if MyCompName = MyCompanyTxt then
                SetupIsComplete := JobsSetup."Default Job Posting Group" <> ''
            else
                SetupIsComplete := JobsSetup."Job Nos." <> '';

        OnAfterInit(SetupIsComplete);
    end;

    trigger OnOpenPage()
    var
        Expr1: Text[30];
        Expr2: Text[30];
        RefDate: Date;
        StartDate: Date;
        EndDate: Date;
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        RefDate := WorkDate();//19960521D;
        StartDate := DMY2Date(01, Date2DMY(RefDate, 2), Date2DMY(RefDate, 3));
        EndDate := CalcDate('<+1M-1D>', StartDate);
        Rec.SetRange("Date Filter3", StartDate, EndDate);

        //Rec.SetFilter("Date Filter3", '>=%1', WorkDate());
        //Rec.SetFilter("Date Filter4", '<%1&<>%2', WorkDate(), 0D);
        //Rec.SetRange("User ID Filter", UserId());

        ShowIntelligentCloud := not EnvironmentInfo.IsSaaS();
    end;

    var
        CuesAndKpis: Codeunit "Cues And KPIs";
        O365GettingStartedMgt: Codeunit "O365 Getting Started Mgt.";
        ClientTypeManagement: Codeunit "Client Type Management";
        EnvironmentInfo: Codeunit "Environment Information";
        ReplayGettingStartedVisible: Boolean;
        TileGettingStartedVisible: Boolean;
        SetupIsComplete: Boolean;
        MyCompanyTxt: Label 'My Company';
        ShowIntelligentCloud: Boolean;

    procedure RefreshRoleCenter()
    begin
        CurrPage.Update();
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterInit(var SetupIsComplete: Boolean)
    begin
    end;


}

