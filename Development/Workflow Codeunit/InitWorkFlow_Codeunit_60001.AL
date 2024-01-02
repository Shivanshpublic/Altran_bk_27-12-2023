codeunit 50000 "Init Workflow"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendApproval_PR(var RecAmendmentReq: Record "Tracking Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelApproval_PR(var RecAmendmentReq: Record "Tracking Shipment Header")
    begin
    end;
    //Event Creation End

    local procedure IsWFEnabled_PR(Var RecAmendmentHeader: Record "Tracking Shipment Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "Customized Workflow";
    begin
        exit(WFMngt.CanExecuteWorkflow(RecAmendmentHeader, WFCode.RunWorkflowOnSendApproval_PR))
    end;

    procedure CheckWorkflowEnabled(var RecAmendmentHeader: Record "Tracking Shipment Header"): Boolean
    var
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsWFEnabled_PR(RecAmendmentHeader) then
            Error(NoWorkflowEnb);
        exit(true);
    end;

    procedure CheckWorkflowNotEnabled(var RecAmendmentHeader: Record "Tracking Shipment Header"): Boolean
    var
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsWFEnabled_PR(RecAmendmentHeader) then
            exit(false)
        else
            exit(true);
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        Text001: TextConst ENU = 'No Workflows Enabled';

}