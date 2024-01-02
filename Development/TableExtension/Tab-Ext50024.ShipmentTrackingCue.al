tableextension 50024 ShipmentTrackingCue extends "Job Cue"
{
    fields
    {
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
}
