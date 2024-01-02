pageextension 50016 SalesQuote extends "Sales Quote"
{
    actions
    {
        addfirst(processing)
        {
            action("Calculate Selling Price")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    CalcSellingPrice: Record "Calculate Selling Price";
                    CalcSellingPricePage: Page "Calculate Selling Price";
                    costNSellingPrice: Record "Cost & Selling Price Calc";
                    RecItem: Record Item;
                    SLine: Record "Sales Line";

                begin
                    Clear(SLine);
                    SLine.SetRange("Document Type", Rec."Document Type");
                    SLine.SetRange("Document No.", Rec."No.");
                    SLine.SetRange(Type, SLine.Type::Item);
                    if SLine.FindSet() then;
                    Clear(CalcSellingPrice);
                    CalcSellingPrice.SetRange("Document No.", SLine."Document No.");
                    if CalcSellingPrice.FindSet() then;
                    if SLine.Count <> CalcSellingPrice.Count then
                        CalcSellingPrice.DeleteAll(true);

                    Clear(SLine);
                    SLine.SetRange("Document Type", Rec."Document Type");
                    SLine.SetRange("Document No.", Rec."No.");
                    SLine.SetRange(Type, SLine.Type::Item);
                    if SLine.FindSet() then begin
                        repeat
                            Clear(CalcSellingPrice);
                            CalcSellingPrice.SetRange("Document No.", SLine."Document No.");
                            CalcSellingPrice.SetRange("Line No.", SLine."Line No.");
                            //CalcSellingPrice.SetRange("Item No.", SLine."No.");
                            if not CalcSellingPrice.FindFirst() then begin
                                //CalcSellingPrice.DeleteAll();

                                CalcSellingPrice.Init();
                                CalcSellingPrice."Document No." := SLine."Document No.";
                                CalcSellingPrice."Line No." := SLine."Line No.";
                                CalcSellingPrice."Item No." := SLine."No.";
                                CalcSellingPrice.Description := SLine.Description;

                                Clear(costNSellingPrice);
                                costNSellingPrice.SetRange("Item No.", SLine."No.");
                                if costNSellingPrice.FindFirst() then
                                    CalcSellingPrice."Total Est. Landed Cost" := costNSellingPrice."Total Estimated Landed cost";

                                CalcSellingPrice.Insert();
                            end else begin
                                CalcSellingPrice."Item No." := SLine."No.";
                                CalcSellingPrice.Description := SLine.Description;
                                Clear(costNSellingPrice);
                                costNSellingPrice.SetRange("Item No.", SLine."No.");
                                if costNSellingPrice.FindFirst() then
                                    CalcSellingPrice."Total Est. Landed Cost" := costNSellingPrice."Total Estimated Landed cost";
                                CalcSellingPrice.Validate("Profit Margin %", CalcSellingPrice."Profit Margin %");
                                CalcSellingPrice.Modify();
                            end;
                        until SLine.Next() = 0;
                        Clear(CalcSellingPrice);
                        CalcSellingPrice.SetRange("Document No.", Rec."No.");
                        if CalcSellingPrice.FindSet() then;
                        Clear(CalcSellingPricePage);
                        CalcSellingPricePage.SetTableView(CalcSellingPrice);
                        CalcSellingPricePage.Run();
                    end;
                end;
            }
        }
    }
}
