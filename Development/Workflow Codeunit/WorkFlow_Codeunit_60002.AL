codeunit 50001 "Customized Workflow"
{
    //Workflow demo created by Krishna Kumar 22 Oct 2020
    Permissions = tabledata "Approval Entry" = RIMD;

    trigger OnRun()
    begin

    end;

    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";



    //**************************Send For Approval Event Start***************************
    procedure RunWorkflowOnSendApproval_PR(): Code[128]
    begin
        exit('RunWorkflowOnSendApproval_PR');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init Workflow", 'OnSendApproval_PR', '', true, true)]
    procedure RunWorkflowOnSendApprovalForTO(var RecAmendmentReq: Record "Tracking Shipment Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendApproval_PR, RecAmendmentReq);
    end;


    //************* To set status pending approval *************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure ChangeAssetStatus(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    VAR
        RecAmendmentReq: Record "Tracking Shipment Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Tracking Shipment Header":
                begin
                    RecRef.SetTable(RecAmendmentReq);
                    RecAmendmentReq.Validate("Status", RecAmendmentReq."Status"::"Pending For Approval");
                    RecAmendmentReq.Modify(true);
                    Variant := RecAmendmentReq;
                    IsHandled := true;
                end;
        end;
    end;
    //****************************************** Send For Approval End ***********************


    //************ After approval *** Set status to Approved**************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    procedure OnReleaseDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        RecAmendmentReq: Record "Tracking Shipment Header";
        Variant: Variant;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Tracking Shipment Header":
                BEGIN
                    RecRef.SetTable(RecAmendmentReq);
                    RecAmendmentReq."Status" := RecAmendmentReq."Status"::Released;
                    RecAmendmentReq.Modify(true);
                    Codeunit.Run(Codeunit::ShipmentTrackingLog, RecAmendmentReq);//on approval.. changing shipment date
                    Variant := RecAmendmentReq;
                    RecRef.GetTable(Variant);
                    Handled := true;
                END;
        end;
    end;


    //*******************On Populate Approval Entry *********************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecAmendmentReq: Record "Tracking Shipment Header";
    begin
        case RecRef.Number of
            database::"Tracking Shipment Header":
                begin
                    RecRef.SetTable(RecAmendmentReq);
                    ApprovalEntryArgument."Table ID" := Database::"Tracking Shipment Header";
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
                    ApprovalEntryArgument."Document No." := RecAmendmentReq.Code;
                    ApprovalEntryArgument."Record ID to Approve" := RecAmendmentReq.RecordId;
                    ApprovalEntryArgument."Due Date" := WorkDate();
                    RecRef.GetTable(RecAmendmentReq);
                end;
        end;
    end;





    //******************To cancel approval in case of 2nd level***************** 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Management", 'OnBeforeHandleEventWithxRec', '', false, false)]
    procedure OnBeforeHandleEventWithxRec(FunctionName: Code[128]; Variant: Variant; xVariant: Variant; VAR IsHandled: Boolean)
    Var
        RecAmendmentReq: Record "Tracking Shipment Header";
        RecRef: RecordRef;
        RecApprovalEntry: Record "Approval Entry";
        ActionableWorkflowStepInstance: Record "Workflow Step Instance";
        WorkFlowMgmt: Codeunit "Workflow Management";
    begin
        RecRef.GetTable(Variant);
        if (RecRef.Number = Database::"Tracking Shipment Header") AND (FunctionName = RunWorkflowOnCancelApproval_PR()) Then begin
            IF NOT WorkFlowMgmt.FindEventWorkflowStepInstance(ActionableWorkflowStepInstance, FunctionName, Variant, xVariant) THEN BEGIN
                RecAmendmentReq := Variant;
                Clear(RecApprovalEntry);
                RecApprovalEntry.SetRange("Table ID", Database::"Tracking Shipment Header");
                RecApprovalEntry.SetRange("Document No.", RecAmendmentReq.Code);
                RecApprovalEntry.SetRange("Record ID to Approve", RecAmendmentReq.RecordId);
                RecApprovalEntry.SetFilter(Status, '%1|%2', RecApprovalEntry.Status::Created, RecApprovalEntry.Status::Open);
                if RecApprovalEntry.FindSet() then
                    RecApprovalEntry.ModifyAll(Status, RecApprovalEntry.Status::Canceled);
                RecAmendmentReq.Validate("Status", RecAmendmentReq."Status"::Open);
                RecAmendmentReq.Modify();
                Variant := RecAmendmentReq;
                Message('Shipment Tracking request has been cancelled.');
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApproval_PR(), Database::"Tracking Shipment Header", 'Tracking Shipment approval required', 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApproval_PR(), Database::"Tracking Shipment Header", 'Tracking Shipment cancel request', 0, false);
    end;

    //****************Reject***************
    procedure RunWorkflowOnReject_PR(): Code[128]
    begin
        exit('RunWorkflowOnReject_PR');
    end;
    //****************Reject End***************



    //***********************Cancel For Approval Event  Start******************
    procedure RunWorkflowOnCancelApproval_PR(): Code[128]
    begin
        exit('RunWorkflowOnCancelApproval_PR');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init Workflow", 'OnCancelApproval_PR', '', true, true)]
    procedure RunWorkflow_OnCancelApproval_PR(var RecAmendmentReq: Record "Tracking Shipment Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelApproval_PR, RecAmendmentReq);
    end;
    //***********************End***********************************


    //*******************************In case of Reject and cancel Approval request**********************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    procedure OnOpenDocument(RecRef: RecordRef; VAR Handled: Boolean)
    VAR
        RecAmendmentReq: Record "Tracking Shipment Header";
        Variant: Variant;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Tracking Shipment Header":
                BEGIN
                    RecRef.SetTable(RecAmendmentReq);
                    RecAmendmentReq."Status" := RecAmendmentReq."Status"::Open;
                    RecAmendmentReq.Modify(true);
                    Variant := RecAmendmentReq;
                    RecRef.GetTable(Variant);
                    Handled := true;
                END;
        end;
    end;

    //Code to Open Record from Request to Appprove page//Krishna
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', false, false)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; VAR CardPageID: Integer)
    begin
        CASE RecordRef.NUMBER OF
            DATABASE::"Tracking Shipment Header":
                CardPageID := Page::"Shipment Tracking Card";
        end;
    end;
}