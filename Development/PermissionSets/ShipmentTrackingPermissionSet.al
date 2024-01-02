PERMISSIONSET 50002 ShipmentTracking
{
    Assignable = TRUE;
    IncludedPermissionSets = SUPER;
    Permissions = table "Tracking Shipment Header" = X,
        tabledata "Tracking Shipment Header" = RMID,
        table "Tracking Shipment Line" = X,
        tabledata "Tracking Shipment Line" = RMID,
        table "Tracking Shipment Log" = X,
        tabledata "Tracking Shipment Log" = RMID,
        table "Custom Setup" = X,
        tabledata "Custom Setup" = RMID,
        page "Shipment Tracking List" = X,
        page "Shipment Tracking Card" = X,
        page "Shipment Tracking Subform" = X,
        page "Shipment Tracking Log" = X,
        report "Post Surcharge to Earned" = X,
        codeunit CustomEvents = X,
        codeunit "Customized Workflow" = X,
        codeunit "Init Workflow" = X,
        codeunit ShipmentTrackingLog = X,
        page "Custom Setup" = X,
        tabledata "Shipment Tracking Cue" = RIMD,
        table "Shipment Tracking Cue" = X,
        report "Altran Sales - Invoice" = X,
        report "Altran Sales - Order Conf." = X,
        report "Commercial Invoice" = X,
        page "Item Reference" = X,
        page "Posted Sales Invoice Line List" = X,
        page "Purch. Receipt Lines ST" = X,
        page "ST Processor Activities" = X,
        page "ST Processor Activities Qty" = X,
        page "ST Processor Activities Value" = X;

}