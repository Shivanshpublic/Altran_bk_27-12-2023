PAGE 50003 "Shipment Tracking Log"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Tracking Shipment Log";
    //Editable = FALSE;

    LAYOUT
    {
        AREA(Content)
        {
            REPEATER(GroupName)
            {
                FIELD("Tracking Code"; Rec."Tracking Code")
                {
                    ApplicationArea = All;

                }
                FIELD("MMSI Code"; Rec."MMSI Code")
                {
                    ApplicationArea = All;
                }
                FIELD("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                FIELD("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                }
                FIELD("PO Line No."; Rec."PO Line No.")
                {
                    ApplicationArea = All;
                }
                FIELD("Buy From Vendor No."; Rec."Buy From Vendor No.")
                {
                    ApplicationArea = All;

                }
                FIELD("Buy From Vendor Name"; Rec."Buy From Vendor Name")
                {
                    ApplicationArea = All;

                }
                FIELD("Date of Dispatch"; Rec."Date of Dispatch")
                {
                    ApplicationArea = All;
                }
                FIELD("Delivery Lead Time"; Rec."Delivery Lead Time")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                FIELD("Date of Arrival"; Rec."Date of Arrival")
                {
                    ApplicationArea = All;
                }
                FIELD("Delayed by Days"; Rec."Delayed by Days")
                {
                    ApplicationArea = All;
                }
                FIELD("New Arrival Date"; Rec."New Arrival Date")
                {
                    ApplicationArea = All;
                }
                FIELD("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                FIELD("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                }
                FIELD("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                }

                FIELD("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                FIELD("Salesperson Email ID"; Rec."Salesperson Email ID")
                {
                    ApplicationArea = All;
                }
                FIELD("Notification Sent"; Rec."Notification Sent")
                {
                    ApplicationArea = All;
                }
                FIELD("Approved by"; Rec."Approved by")
                {
                    ApplicationArea = All;
                }
                FIELD("Shipment Date Updated on SO"; Rec."Shipment Date Updated on SO")
                {
                    ApplicationArea = All;
                }
                FIELD("Created by API"; Rec."Created by API")
                {
                    ApplicationArea = All;
                }
                FIELD("ETA Date Time"; Rec."ETA Date Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    ACTIONS
    {
        AREA(Processing)
        {
            ACTION(GetAPIData)
            {
                ApplicationArea = All;
                Caption = 'Get Shipment Data';
                trigger OnAction()
                var
                    Client: HttpClient;
                    Response: HttpResponseMessage;
                    json: Text;
                    jsonObj: JsonObject;
                    FunctionURL: Text;
                    YourParameters: Text;
                    InvalidResponseError: Text;
                    userkey: Text;
                    extradata: Text;
                    interval: Text;
                    locode: Text;
                    O: JsonObject;
                    Member: Text;
                    JPathExpr: Text;
                    Ok: Boolean;
                    JsonArray: JsonArray;
                    JsonToken: JsonToken;
                    Result: JsonToken;
                    JMMSIToken: JsonToken;
                    jsonObj1: JsonObject;
                    ShipmentTrackingNo: Text[30];
                    ETA: Text[50];
                    ColonPos: Integer;
                    ShipmentTrackingNoLen: Integer;
                    ETALen: Integer;
                    ShipmentTracking: Record "Tracking Shipment Header";
                    ShipmentTrackingLine: Record "Tracking Shipment Line";
                    CustomSetup: Record "Custom Setup";
                begin
                    CustomSetup.Get();
                    /*
                    FunctionURL := 'https://api.vesselfinder.com/expectedarrivals?';
                    userkey := 'WS-1B37488F-9513D4';
                    extradata := 'voyage,master';
                    interval := '1440';
                    locode := 'BGVAR';
                    */
                    FunctionURL := CustomSetup."Vessel URL";
                    userkey := CustomSetup."Vessel User Key";
                    extradata := CustomSetup."Vessel Extra Data";
                    interval := CustomSetup."Vessel Interval";
                    locode := CustomSetup."Vessel locode";
                    YourParameters := 'userkey=' + userkey + '&extradata=' + extradata + '&interval=' + interval + '&locode=' + locode;
                    if client.Get(FunctionURL + YourParameters, Response) then
                        if Response.IsSuccessStatusCode then begin
                            Response.Content.ReadAs(Json);
                            Ok := JsonArray.ReadFrom(json);

                        end;
                    Member := 'MMSI';
                    foreach JsonToken in JsonArray do begin
                        Clear(ShipmentTrackingNo);
                        Clear(ETA);
                        Clear(ShipmentTrackingNoLen);
                        Clear(ETALen);
                        Clear(ColonPos);

                        jsonObj := JsonToken.AsObject();
                        Ok := jsonObj.WriteTo(json);
                        ShipmentTrackingNo := CopyStr(json, StrPos(json, '"MMSI"'), 17);
                        ColonPos := StrPos(ShipmentTrackingNo, ':');
                        ShipmentTrackingNoLen := StrLen(ShipmentTrackingNo);
                        ShipmentTrackingNo := CopyStr(ShipmentTrackingNo, ColonPos + 1, ShipmentTrackingNoLen - (ColonPos + 1));

                        ETA := CopyStr(json, StrPos(json, '"ETA"'), 28);
                        ColonPos := StrPos(ETA, ':');
                        ETALen := StrLen(ETA);
                        ETA := CopyStr(ETA, StrPos(ETA, ':') + 2, ETALen - (StrPos(ETA, ':') + 2) - 1);
                        //ShipmentTracking.Reset();
                        //ShipmentTracking.SetRange("MMSI Code", ShipmentTrackingNo);
                        //if ShipmentTracking.FindFirst() then
                        Rec.CreateShipmentLog(ShipmentTrackingNo, ETA);
                    end;
                end;
            }
            ACTION(UpdateLinkDoc)
            {
                ApplicationArea = All;
                Caption = 'Update Linked Data';
                trigger OnAction()
                var
                begin
                    Rec.UpdateLinkedDoc(Rec);
                end;
            }
        }
    }

}