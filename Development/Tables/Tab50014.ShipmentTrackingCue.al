table 50014 "Shipment Tracking Cue"
{
    Caption = 'Shipment Tracking Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(50002; "Quantity In-Transit"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'IN TRANSIT'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'In-Transit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Quantity In-Production"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'IN PRODUCTION'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'In-Production';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Quantity Pending to Ship"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'PENDING TO SHIP'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Pending to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Quantity Needs Action"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'NEED ACTION'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Needs Action';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Quantity Booked"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'BOOKED'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Booked';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Quantity Arr. at Warehouse"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'ARRIVED WAREHOUSE'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Arrived at Warehouse';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Quantity TLX Released Required"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'TLX RELEASED REQ'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'TLX Released Required';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Quantity ARRIVED - CUST"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'ARRIVED - CUST'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'ARRIVED - CUST';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Quantity ARRIVED - POD"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'ARRIVED - POD'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'ARRIVED - POD';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Quantity at Sterling"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Location Code" = FILTER(= 'STERLING'), "Item Category Code" = FILTER(<> 'SERVICE'), "Item Type" = filter(= Inventory)));
            Caption = 'At Sterling';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50020; "Date Filter3"; Date)
        {
            Caption = 'Date Filter3';
            FieldClass = FlowFilter;
        }
        field(50021; "Date Filter4"; Date)
        {
            Caption = 'Date Filter 4';
            FieldClass = FlowFilter;
        }
        field(50022; "Quantity at POL"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Location Code" = FILTER(= 'POL'), "Item Category Code" = FILTER(<> 'SERVICE'), "Item Type" = filter(= Inventory)));
            Caption = 'At POL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50023; "Quantity of Open Sales Orders"; Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Posting Date" = FIELD("Date Filter3"), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Total Quantities on Open Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "Qty. of Open Purchase Orders"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Order Date" = FIELD("Date Filter3"), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Total Quantities on Open Purchase Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "Qty. of Posted Sales Invoice"; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line".Quantity WHERE("Posting Date" = FIELD("Date Filter3"), Type = filter(Item), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Total Quantities on Posted Sales Invoice';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50026; "Qty. of Posted Purch. Invoice"; Decimal)
        {
            CalcFormula = Sum("Purch. Inv. Line".Quantity WHERE("Posting Date" = FIELD("Date Filter3"), Type = filter(Item), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Total Quantities on Posted Purchase Invoice';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "Quantity of Open Sales Quotes"; Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document Type" = const(Quote), Type = filter(Item),
                                                      "Posting Date" = FIELD("Date Filter3"), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Total Quantities on Open Sales Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50029; "Location Code Filter"; Code[20])
        {
            Caption = 'Location Code Filter';
            FieldClass = FlowFilter;
        }
        field(50030; "Value In-Transit"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'IN TRANSIT'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'In-Transit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50031; "Value In-Production"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'IN PRODUCTION'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'In-Production';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50032; "Value Pending to Ship"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'PENDING TO SHIP'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Pending to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50033; "Value Needs Action"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'NEED ACTION'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Needs Action';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50034; "Value Booked"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = CONST('BOOKED'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Booked';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50035; "Value Arrived at Warehouse"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'ARRIVED WAREHOUSE'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Arrived at Warehouse';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50036; "Value TLX Released Required"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'TLX RELEASED REQ'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'TLX Released Required';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50037; "Value ARRIVED - CUST"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'ARRIVED - CUST'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'ARRIVED - CUST';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50038; "Value ARRIVED - POD"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Milestone Status" = FILTER(= 'ARRIVED - POD'), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'ARRIVED - POD';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50039; "Value at Sterling"; Decimal)
        {
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FILTER(= 'STERLING'), Inventoriable = filter(true), "Item Charge No." = filter(= '')));
            Caption = 'Total Cost Value at Sterling';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50040; "Value at POL"; Decimal)
        {
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FILTER(= 'POL'),
                               Inventoriable = filter(true), "Item Charge No." = filter(= ''),
                               "Document Type" = filter(= "Purchase Invoice" | "Sales Credit Memo" | "Purchase Credit Memo")));
            Caption = 'Total Cost Value at POL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50041; "Value of Open Sales Orders"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Posting Date" = FIELD("Date Filter3"), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Expected Revenue on Open Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50042; "Value of Open Purchase Orders"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = const(Order), Type = filter(Item),
                                                      "Order Date" = FIELD("Date Filter3"), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Expected Cost on Open Purchase Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50043; "Value of Posted Sales Invoice"; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line"."Amount Including VAT" WHERE("Posting Date" = FIELD("Date Filter3"), Type = filter(Item), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Total Revenue on Posted Sales Invoice';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "Value of Posted Purch. Invoice"; Decimal)
        {
            CalcFormula = Sum("Purch. Inv. Line"."Amount Including VAT" WHERE("Posting Date" = FIELD("Date Filter3"), Type = filter(Item), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Total Cost on Posted Purchase Invoice';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50045; "Value of Open Sales Quotes"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Amount Including VAT" WHERE("Document Type" = const(Quote), Type = filter(Item),
                                                      "Posting Date" = FIELD("Date Filter3"), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Open Sales Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50046; "Total Quantity"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Posting Date" = FIELD("Date Filter3"), "Item Category Code" = FILTER(<> 'SERVICE')));
            Caption = 'Total Quantities Per Location';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50047; "Qty. of Post. Sales Cr. Memo"; Decimal)
        {
            CalcFormula = Sum("Sales Cr.Memo Line".Quantity WHERE("Posting Date" = FIELD("Date Filter3"), Type = filter(Item), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Total Quantities on Post. Sales Cr.Memo';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50048; "Qty. of Post. Purch. Cr.Memo"; Decimal)
        {
            CalcFormula = Sum("Purch. Cr. Memo Line".Quantity WHERE("Posting Date" = FIELD("Date Filter3"), Type = filter(Item), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));
            Caption = 'Total Quantities on Posted Purchase Cr.Memo';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50049; "Value of Posted Sales Cr. Memo"; Decimal)
        {
            CalcFormula = Sum("Sales Cr.Memo Line"."Amount Including VAT" WHERE("Posting Date" = FIELD("Date Filter3"), Type = filter(Item), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Total Revenue on Posted Sales Cr.Memo';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "Value of Posted Purch. Cr.Memo"; Decimal)
        {
            CalcFormula = Sum("Purch. Cr. Memo Line"."Amount Including VAT" WHERE("Posting Date" = FIELD("Date Filter3"), Type = filter(Item), "Item Category Code" = FILTER(<> 'SERVICE'), "Posting Group" = FILTER(<> '')));

            Caption = 'Total Cost on Posted Purchase Cr.Memo';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure SetLocationFilter()
    var
        UserSetupMgt: Codeunit "User Setup Management";
        LocationCode: Code[10];
    begin
        LocationCode := UserSetupMgt.GetSalesFilter;
        if LocationCode <> '' then begin
            FilterGroup(2);
            SetRange("Location Code Filter", LocationCode);
            FilterGroup(0);
        end;
    end;

    procedure CalculateAverageDaysDelayed() AverageDays: Decimal
    var
        SalesHeader: Record "Sales Header";
        SumDelayDays: Integer;
        CountDelayedInvoices: Integer;
    begin
        //FilterOrders(SalesHeader, FieldNo(Delayed));
        //SalesHeader.SetRange("Responsibility Center");
        //SalesHeader.SetLoadFields("Document Type", "No.");
        //if SalesHeader.FindSet() then begin
        //    repeat
        //        SummarizeDelayedData(SalesHeader, SumDelayDays, CountDelayedInvoices);
        //    until SalesHeader.Next() = 0;
        //    AverageDays := SumDelayDays / CountDelayedInvoices;
        //end;
    end;

    local procedure MaximumDelayAmongLines(var SalesHeader: Record "Sales Header") MaxDelay: Integer
    var
        SalesLine: Record "Sales Line";
    begin
        MaxDelay := 0;
        SalesLine.SetCurrentKey("Document Type", "Document No.", "Shipment Date");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("Shipment Date", '<%1&<>%2', WorkDate, 0D);
        SalesLine.SetLoadFields("Document Type", "Document No.", "Shipment Date");
        if SalesLine.FindFirst() then
            if WorkDate - SalesLine."Shipment Date" > MaxDelay then
                MaxDelay := WorkDate - SalesLine."Shipment Date";
    end;

    procedure CountOrders(FieldNumber: Integer) Result: Integer
    var
        SalesHeader: Record "Sales Header";
        CountSalesOrders: Query "Count Sales Orders";
        IsHandled: Boolean;
    begin
        /*
        IsHandled := false;
        OnBeforeCountOrders(Rec, FieldNumber, Result, IsHandled);
        if IsHandled then
            exit(Result);

        CountSalesOrders.SetRange(Status, SalesHeader.Status::Released);
        CountSalesOrders.SetRange(Completely_Shipped, false);
        FilterGroup(2);
        CountSalesOrders.SetFilter(Responsibility_Center, GetFilter("Responsibility Center Filter"));
        OnCountOrdersOnAfterCountPurchOrdersSetFilters(CountSalesOrders);
        FilterGroup(0);

        case FieldNumber of
            FieldNo("Ready to Ship"):
                begin
                    CountSalesOrders.SetRange(Ship);
                    CountSalesOrders.SetFilter(Shipment_Date, GetFilter("Date Filter2"));
                end;
            FieldNo("Partially Shipped"):
                begin
                    CountSalesOrders.SetRange(Shipped, true);
                    CountSalesOrders.SetFilter(Shipment_Date, GetFilter("Date Filter2"));
                end;
            FieldNo(Delayed):
                begin
                    CountSalesOrders.SetRange(Ship);
                    CountSalesOrders.SetFilter(Date_Filter, GetFilter("Date Filter"));
                    CountSalesOrders.SetRange(Late_Order_Shipping, true);
                end;
        end;
        CountSalesOrders.Open;
        CountSalesOrders.Read;
        exit(CountSalesOrders.Count_Orders);
        */
    end;

    local procedure FilterOrders(var SalesHeader: Record "Sales Header"; FieldNumber: Integer)
    begin
        /*
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        SalesHeader.SetRange("Completely Shipped", false);
        case FieldNumber of
            FieldNo("Ready to Ship"):
                begin
                    SalesHeader.SetRange(Ship);
                    SalesHeader.SetFilter("Shipment Date", GetFilter("Date Filter2"));
                end;
            FieldNo("Partially Shipped"):
                begin
                    SalesHeader.SetRange(Shipped, true);
                    SalesHeader.SetFilter("Shipment Date", GetFilter("Date Filter2"));
                end;
            FieldNo(Delayed):
                begin
                    SalesHeader.SetRange(Ship);
                    SalesHeader.SetFilter("Date Filter", GetFilter("Date Filter"));
                    SalesHeader.SetRange("Late Order Shipping", true);
                end;
        end;
        FilterGroup(2);
        SalesHeader.SetFilter("Responsibility Center", GetFilter("Responsibility Center Filter"));
        OnFilterOrdersOnAfterSalesHeaderSetFilters(SalesHeader);
        FilterGroup(0);
        */
    end;

    procedure ShowOrders(FieldNumber: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        FilterOrders(SalesHeader, FieldNumber);
        PAGE.Run(PAGE::"Sales Order List", SalesHeader);
    end;

    local procedure SummarizeDelayedData(var SalesHeader: Record "Sales Header"; var SumDelayDays: Integer; var CountDelayedInvoices: Integer)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSummarizeDelayedData(SalesHeader, SumDelayDays, CountDelayedInvoices, IsHandled);
        if IsHandled then
            exit;

        SumDelayDays += MaximumDelayAmongLines(SalesHeader);
        CountDelayedInvoices += 1;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetRespCenterFilter(var SalesCue: Record "Sales Cue"; RespCenterCode: Code[10])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCountOrders(var SalesCue: Record "Sales Cue"; FieldNumber: Integer; var Result: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCountOrdersOnAfterCountPurchOrdersSetFilters(var CountSalesOrders: Query "Count Sales Orders")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFilterOrdersOnAfterSalesHeaderSetFilters(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSummarizeDelayedData(var SalesHeader: Record "Sales Header"; var SumDelayDays: Integer; var CountDelayedInvoices: Integer; var IsHandled: Boolean)
    begin
    end;
}

