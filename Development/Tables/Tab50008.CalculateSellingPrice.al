table 50008 "Calculate Selling Price"
{
    Caption = 'Calculate Selling Price';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Total Est. Landed Cost"; Decimal)
        {
            Caption = 'Total Est. Landed Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Profit Margin %"; Decimal)
        {
            Caption = 'Profit Margin %';
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
            trigger OnValidate()
            begin
                CalcMargin();
            end;
        }
        field(5; "Profit Margin"; Decimal)
        {
            Caption = 'Profit Margin';
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger OnValidate()
            begin
                Validate("Suggested Selling Price", "Total Est. Landed Cost" + "Profit Margin");
                //if "Suggested Selling Price" <> 0 then
                //Validate("Profit Margin", ("Suggested Selling Price" -"Total Est. Landed Cost")/"Suggested Selling Price");
            end;
        }
        field(6; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Suggested Selling Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            // Editable = false;
            trigger OnValidate()
            begin
                CalcProfitPercentage();
            end;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure CalcMargin()
    begin
        if "Profit Margin %" <> 0 then begin
            "Suggested Selling Price" := Round("Total Est. Landed Cost" / ((1 - "Profit Margin %" / 100)), 0.01, '=');
            "Profit Margin" := Round("Suggested Selling Price" * ("Profit Margin %" / 100), 0.01, '=');
        end else begin
            "Suggested Selling Price" := 0;
            "Profit Margin %" := 0;
        end;
    end;

    procedure CalcProfitPercentage()
    begin

        if "Suggested Selling Price" <> 0 then begin
            "Profit Margin %" := ROUND(("Suggested Selling Price" - "Total Est. Landed Cost") / "Suggested Selling Price" * 100, 0.1, '=');
            "Profit Margin" := Round("Suggested Selling Price" * ("Profit Margin %" / 100), 0.01, '=');
        end else begin
            "Profit Margin %" := 0;
            "Profit Margin" := 0;
        end;
    end;

    procedure CreateLogEntries()
    var
        CostNPriceLog: Record SellingPriceLog;
    begin
        CostNPriceLog.Init();
        CostNPriceLog."Entry No." := 0;
        CostNPriceLog.Insert(true);
        CostNPriceLog.TransferFields(Rec);
        CostNPriceLog.Modify();
    end;
}
