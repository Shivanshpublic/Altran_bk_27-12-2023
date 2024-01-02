page 50019 "ST Processor Activities Value"
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
            cuegroup("Value of Products")
            {
                Caption = 'Value of Products';
                field("Value in-Transit"; Rec."Value in-Transit")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products in-Transit.';
                }
                field("Value In-Production"; Rec."Value In-Production")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products In-Production.';
                }
                field("Value Pending to Ship"; Rec."Value Pending to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Pending to Ship.';
                }
                field("Value Needs Action"; Rec."Value Needs Action")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Needs Action.';
                }
                field("Value Booked"; Rec."Value Booked")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Booked.';
                }
                field("Value Arrived at Warehouse"; Rec."Value Arrived at Warehouse")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products Arrived at Warehouse.';
                }
                field("Value TLX Released Required"; Rec."Value TLX Released Required")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products TLX Released Required.';
                }
                field("Value ARRIVED - CUST"; Rec."Value ARRIVED - CUST")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products ARRIVED - CUST.';
                }
                field("Value ARRIVED - POD"; Rec."Value ARRIVED - POD")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Products ARRIVED - POD.';
                }
                field("Value at Sterling"; Rec."Value at Sterling")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Value Entries";
                    ToolTip = 'Specifies the value of Products at Sterling.';
                }
                field("Value at POL"; Rec."Value at POL")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Value Entries";
                    ToolTip = 'Specifies the value of Products at POL.';
                }
                field("Value of Open Sales Orders"; Rec."Value of Open Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Lines";
                    ToolTip = 'Specifies the value of Open Sales Orders.';
                }
                field("Value of Open Purchase Orders"; Rec."Value of Open Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Lines";
                    ToolTip = 'Specifies the value of Open Purchase Orders.';
                }
                field("Value of Posted Sales Invoice"; Rec."Value of Posted Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Invoice Lines";
                    ToolTip = 'Specifies the value of Posted Sales Invoice.';
                }
                field("Value of Posted Sales Cr.Memo"; Rec."Value of Posted Sales Cr. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Credit Memo Lines";
                    ToolTip = 'Specifies the value of Posted Sales Cr. Memo.';
                }
                field("Value of Posted Purch. Invoice"; Rec."Value of Posted Purch. Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Purchase Invoice Lines";
                    ToolTip = 'Specifies the value of Posted Purchase Invoice.';
                }
                field("Value of Posted Purch. Cr.Memo"; Rec."Value of Posted Purch. Cr.Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Purchase Cr. Memo Lines";
                    ToolTip = 'Specifies the value of Posted Purchase Cr. Memo.';
                }
                field("Value of Open Sales Quotes"; Rec."Value of Open Sales Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Lines";
                    ToolTip = 'Specifies the value of Open Sales Quotes.';
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

