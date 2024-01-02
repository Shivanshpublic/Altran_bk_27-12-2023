PAGE 50001 "Shipment Tracking Card"
{
    PageType = Document;
    SourceTable = "Tracking Shipment Header";
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Navigate,Related';

    LAYOUT
    {
        AREA(Content)
        {
            GROUP(General)
            {
                Editable = PageEditable;
                FIELD("Tracking Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.Validate(Code, Rec.Code);
                        CurrPage.Update();
                    end;
                }
                FIELD(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    //Editable = FALSE;
                    StyleExpr = StyleText;
                }
                FIELD("Sub Status"; Rec."Sub Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin

                    end;
                }
                FIELD("Container No."; Rec."Container No.")
                {
                    ApplicationArea = All;
                }
                FIELD("MMSI Code"; Rec."MMSI Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin

                    end;
                }
                FIELD("Port of Dispatch"; Rec."Port of Dispatch")
                {
                    ApplicationArea = All;
                }
                FIELD("Date of Dispatch"; Rec."Date of Dispatch")
                {
                    ApplicationArea = All;
                }
                FIELD(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                FIELD("Supplier No."; Rec."Supplier No.")
                {
                    ApplicationArea = All;
                }
                FIELD("Supplier Name"; Rec."Supplier Name")
                {
                    ApplicationArea = All;
                }
                FIELD("Freight Details"; Rec."Freight Details")
                {
                    ApplicationArea = All;
                }
                FIELD("MBL"; Rec."MBL")
                {
                    ApplicationArea = All;
                }
                FIELD("HBL"; Rec."HBL")
                {
                    ApplicationArea = All;
                }
                FIELD("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = All;
                }
                FIELD("Pallet Quantity"; Rec."Pallet Quantity")
                {
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = All;
                }
                field("Total Shipment Cost"; Rec."Total Shipment Cost")
                {
                    ApplicationArea = All;
                    //Enabled = SurchargeCalculated;
                }
                field("Surcharge Factor"; Rec."Surcharge Factor")
                {
                    ApplicationArea = All;
                    //Enabled = SurchargeCalculated;
                }
                field("Surcharge Limit"; Rec."Surcharge Limit")
                {
                    ApplicationArea = All;
                    //Enabled = SurchargeCalculated;
                }
                field("Additional Revenue"; Rec."Additional Revenue")
                {
                    ApplicationArea = All;
                    //Enabled = SurchargeCalculated;
                }
                FIELD("Surcharge Allocated to SO"; Rec."Surcharge Allocated to SO")
                {
                    ApplicationArea = All;
                }
                FIELD("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                FIELD("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
            }
            PART(ShipmentTrackingSubform; "Shipment Tracking Subform")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Tracking Code" = FIELD(Code);
                Editable = PageEditable;
            }
        }
    }

    ACTIONS
    {
        AREA(Processing)
        {
            ACTION(Reopen1)
            {
                Image = ReOpen;
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Reopen';
                TRIGGER OnAction()
                VAR
                    WfInitCode: Codeunit "Init Workflow";
                    ErrorWorkflowExist: TextConst ENU = 'Workflow is enabled, Kindly follow same.';
                BEGIN
                    if WfInitCode.CheckWorkflowNotEnabled(Rec) then begin
                        Error(ErrorWorkflowExist);
                    end;

                    IF Rec.Status = Rec.Status::Open THEN
                        ERROR('Document is already Open');
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();
                END;
            }
            ACTION(Release)
            {
                Image = Approve;
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Release';
                TRIGGER OnAction()
                VAR
                    UserSetup: Record "User Setup";
                    WfInitCode: Codeunit "Init Workflow";
                    ErrorWorkflowExist: TextConst ENU = 'Workflow is enabled, Kindly follow same.';
                BEGIN
                    if WfInitCode.CheckWorkflowNotEnabled(Rec) then begin
                        Error(ErrorWorkflowExist);
                    end;
                    IF UserSetup.GET(UserId) THEN BEGIN
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                    END;
                END;
            }

            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Enabled = IsSendRequest;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WfInitCode: Codeunit "Init Workflow";
                        AdvanceWorkflowCUL: Codeunit "Customized Workflow";
                    begin
                        Rec.TestField("Status", Rec."Status"::Open);
                        Rec.TestField("Sub Status", Rec."Sub Status"::" ");
                        if WfInitCode.CheckWorkflowEnabled(Rec) then begin
                            WfInitCode.OnSendApproval_PR(Rec);
                        end;
                        //SetControl();
                    end;
                }

                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Enabled = IsCancel;
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        InitWf: Codeunit "Init Workflow";
                    begin
                        Rec.TestField("Status", Rec."Status"::"Pending For Approval");
                        Rec.TestField("Sub Status", Rec."Sub Status"::" ");
                        InitWf.OnCancelApproval_PR(Rec);
                        //SetControl();
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject to approve the incoming document.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = false;// OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }

                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category6;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RunWorkflowEntriesPage(Rec.RecordId(), DATABASE::"Tracking Shipment Header", Enum::"Approval Document Type"::" ", Rec.Code);
                    end;
                }
            }
            ACTION("Shipment Tracking Log")
            {
                Image = Log;
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;
                RunObject = PAGE "Shipment Tracking Log";
                RunPageLink = "Tracking Code" = FIELD(Code);
            }
            ACTION("Surcharge Sales Order Line")
            {
                Image = Process;
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;
                RunObject = PAGE "Sales Lines";
                RunPageLink = "Shipment Tracking Code" = FIELD(Code);
            }
            ACTION("Create Transfer Order")
            {
                Image = Log;
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TransHead: Record "Transfer Header";
                    TransOrderPage: Page "Transfer Orders";
                begin
                    Clear(TransOrderPage);
                    TransHead.SetRange("Shipment Tracking Code", Rec.Code);
                    TransOrderPage.SetTableView(TransHead);
                    TransOrderPage.SetShipmentTrackingCode(Rec.Code);
                    TransOrderPage.Run();
                end;
            }
            ACTION(Reopen)
            {
                Image = ReOpen;
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::Released;
                TRIGGER OnAction()
                VAR
                    UserSetup: Record "User Setup";
                    WfInitCode: Codeunit "Init Workflow";
                    ErrorWorkflowExist: TextConst ENU = 'Workflow is enabled, Kindly follow same.';

                BEGIN
                    if WfInitCode.CheckWorkflowNotEnabled(Rec) then begin
                        Error(ErrorWorkflowExist);
                    end;

                    IF Rec.Status = Rec.Status::Open THEN
                        ERROR('Document is already Open');

                    Rec.TestField(Status, Rec.Status::Released);

                    IF UserSetup.GET(UserId) THEN BEGIN
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                    END;
                END;
            }
            ACTION("Get Purchase Order Lines")
            {
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;
                Visible = false;
                TRIGGER OnAction()
                var
                    ShipmentTrackingLine: Record "Tracking Shipment Line";
                    PurchaseLine: Record "Purchase Line";
                    PurchaseLinePage: Page "Purchase Lines";
                    LinesNotCopied: Integer;
                    LineNo: Integer;
                    Text5000: TextConst ENU = 'Lines not found.';
                BEGIN
                    //PurchPostedDocLines.SetToPurchHeader(Rec);
                    //PurchPostedDocLines.SETRECORD(Vend);
                    ShipmentTrackingLine.Reset();
                    ShipmentTrackingLine.SetRange("Tracking Code", Rec.Code);
                    if ShipmentTrackingLine.FindLast() then
                        LineNo := ShipmentTrackingLine."Line No."
                    else
                        LineNo := 10000;
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetFilter("Quantity Received", '<>%1', 0);
                    PurchaseLinePage.LOOKUPMODE := TRUE;
                    PurchaseLinePage.SetTableView(PurchaseLine);
                    IF PurchaseLinePage.RUNMODAL = ACTION::LookupOK THEN
                        PurchaseLinePage.SetSelectionFilter(PurchaseLine);
                    if PurchaseLine.FindFirst() then
                        Repeat
                            LinesNotCopied += 1;
                            ShipmentTrackingLine.Init();
                            ShipmentTrackingLine.Validate("Tracking Code", Rec.Code);
                            LineNo += 10000;
                            ShipmentTrackingLine.Validate("Line No.", LineNo);
                            ShipmentTrackingLine.Validate("PO No.", PurchaseLine."Document No.");
                            ShipmentTrackingLine.Validate("PO Line No.", PurchaseLine."Line No.");
                            //ShipmentTrackingLine.Validate("PO Line No.", PurchaseLine."Line No.");
                            ShipmentTrackingLine.Insert(true);
                        Until PurchaseLine.Next() = 0;
                    IF LinesNotCopied = 0 THEN
                        MESSAGE(Text5000);
                    CLEAR(PurchaseLinePage);

                END;
            }
            ACTION("Get Purchase Receipt Lines")
            {
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;

                TRIGGER OnAction()
                var
                    ShipmentTrackingLine: Record "Tracking Shipment Line";
                    PurchRcptHead: Record "Purch. Rcpt. Header";
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    PurchRcptLinePage: Page "Purch. Receipt Lines ST";
                    LinesNotCopied: Integer;
                    LineNo: Integer;
                    Text5000: TextConst ENU = 'Lines not found.';
                BEGIN
                    //PurchPostedDocLines.SetToPurchHeader(Rec);
                    //PurchPostedDocLines.SETRECORD(Vend);
                    ShipmentTrackingLine.Reset();
                    ShipmentTrackingLine.SetRange("Tracking Code", Rec.Code);
                    if ShipmentTrackingLine.FindLast() then
                        LineNo := ShipmentTrackingLine."Line No."
                    else
                        LineNo := 10000;
                    PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
                    //PurchRcptLine.SetFilter("Shipment Tracking Code", '=%1', '');
                    //PurchRcptLine.SetFilter("Shipment Tracking Line No.", '=%1', 0);
                    PurchRcptLinePage.LOOKUPMODE := TRUE;
                    PurchRcptLinePage.SetTableView(PurchRcptLine);
                    IF PurchRcptLinePage.RUNMODAL = ACTION::LookupOK THEN
                        PurchRcptLinePage.SetSelectionFilter(PurchRcptLine);
                    if PurchRcptLine.FindFirst() then
                        Repeat
                            PurchRcptHead.Get(PurchRcptLine."Document No.");
                            LinesNotCopied += 1;
                            ShipmentTrackingLine.Init();
                            ShipmentTrackingLine.Validate("Tracking Code", Rec.Code);
                            LineNo += 10000;
                            ShipmentTrackingLine.Validate("Line No.", LineNo);
                            ShipmentTrackingLine.Validate("PO No.", PurchRcptLine."Order No.");
                            ShipmentTrackingLine.Validate("PO Line No.", PurchRcptLine."Order Line No.");
                            //ShipmentTrackingLine."Buy From Vendor No." := PurchRcptHead."Buy-from Vendor No.";
                            //ShipmentTrackingLine."Buy From Vendor Name" := PurchRcptHead."Buy-from Vendor Name";
                            //ShipmentTrackingLine."Item No." := PurchRcptLine."No.";
                            //ShipmentTrackingLine.Description := PurchRcptLine.Description;
                            //ShipmentTrackingLine."PO Quantity" := PurchRcptLine.Quantity;
                            ShipmentTrackingLine.Validate("Receipt No.", PurchRcptLine."Document No.");
                            ShipmentTrackingLine.Validate("Receipt Line No.", PurchRcptLine."Line No.");
                            ShipmentTrackingLine.Insert(true);
                        Until PurchRcptLine.Next() = 0;
                    IF LinesNotCopied = 0 THEN
                        MESSAGE(Text5000);
                    CLEAR(PurchRcptLinePage);

                END;
            }
            ACTION("Calculate Shipment Cost")
            {
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = All;

                TRIGGER OnAction()
                var
                    SalesSetup: Record "Sales & Receivables Setup";
                    Text50000: TextConst ENU = 'As Total Shipment Cost is less than Surcharge Limit, It will not be allocated to lines.';
                BEGIN
                    SalesSetup.Get();
                    if Rec."Total Shipment Cost" < SalesSetup."Surcharge Limit" then
                        Message(Text50000)
                    else
                        Rec.CalculateSurcharge();
                END;
            }
        }
    }




    trigger OnAfterGetRecord()
    begin
        SetControl();
        Rec.CalcFields("Total Quantity", "Pallet Quantity")
    end;

    trigger OnOpenPage()
    begin
        SetControl();
        Rec.CalcFields("Total Quantity", "Pallet Quantity")
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetControl();
    end;

    local procedure SetControl()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if IsShipmentCompletelyReceived() then
            PageEditable := false
        else
            PageEditable := true;

        //if Rec."Sub Status" <> Rec."Sub Status"::"Surcharge Calculated" then
        //    SurchargeCalculated := true
        //else
        //    SurchargeCalculated := false;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        if Rec."Status" = Rec."Status"::Open then begin
            IsSendRequest := true;
            IsCancel := false;
            //PageEditable := true;
            StyleText := '';
        end else
            if Rec."Status" = Rec."Status"::"Pending For Approval" then begin
                IsSendRequest := false;
                IsCancel := true;
                // PageEditable := false;
                StyleText := 'Ambiguous';
            end else begin
                IsSendRequest := false;
                IsCancel := false;
                // PageEditable := false;
                StyleText := 'Favorable';

            end;
        CurrPage.Update(false);
    end;

    local procedure IsShipmentCompletelyReceived(): Boolean
    var
        RecPurchLine: Record "Purchase Line";
        SLine: Record "Tracking Shipment Line";
        UserSetup: Record "User Setup";
    begin
        Clear(UserSetup);
        if UserSetup.GET(UserId) then begin
            if UserSetup."Edit Shipment Tracking" then
                exit(false);
        end;

        if Rec.Code <> '' then begin
            Clear(SLine);
            SLine.SetRange("Tracking Code", Rec.Code);
            SLine.SetFilter("PO No.", '<>%1', '');
            if SLine.FindSet() then begin
                repeat
                    Clear(RecPurchLine);
                    RecPurchLine.SetRange("Document Type", RecPurchLine."Document Type"::Order);
                    RecPurchLine.SetRange("Document No.", SLine."PO No.");
                    RecPurchLine.SetRange(Type, RecPurchLine.Type::Item);
                    if RecPurchLine.FindSet() then begin
                        repeat
                            if not RecPurchLine."Completely Received" then
                                exit(false);
                        until RecPurchLine.Next() = 0;
                    end;
                until SLine.Next() = 0;
                exit(true);
            end;
        end else
            exit(false);
    end;

    VAR

        PageEditable: Boolean;
        IsSendRequest: Boolean;
        IsCancel: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        StyleText: Text;
        SetEditable: Boolean;
        SurchargeCalculated: Boolean;
}