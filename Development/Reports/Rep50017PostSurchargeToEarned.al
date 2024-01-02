report 50017 "Post Surcharge to Earned"
{
    ProcessingOnly = true;
    Caption = 'Post Surcharge to Earned';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Permissions = TableData "Sales Invoice Header" = imd,
                  TableData "Sales Invoice Line" = imd,
                  TableData "Sales Cr.Memo Header" = imd,
                  TableData "Sales Cr.Memo Line" = imd,
                  TableData "Return Receipt Header" = imd,
                  TableData "Return Receipt Line" = imd;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Posting Date";
            trigger OnPreDataItem()
            begin
                SetRange("Earned Surcharge Posted", false);
            end;

            trigger OnAfterGetRecord()
            begin
                PostEarnedSurcharge("Sales Invoice Header");
            end;


        }
    }


    trigger OnPostReport()
    begin
        if GuiAllowed then
            Message('Posted Successfully');
    end;

    trigger OnPreReport()
    begin

    end;

    var

        i: Integer;


    local procedure PostEarnedSurcharge(SalesInvHeader: Record "Sales Invoice Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SrcCode: Code[10];
        GenJnlLineDocType: Enum "Gen. Journal Document Type";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesInvLine: Record "Sales Invoice Line";
    begin
        SalesSetup.Get();
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetFilter("Quantity", '<>%1', 0);
        SalesInvLine.SetFilter("Surcharge Per Qty.", '<>%1', 0);
        if SalesInvLine.FindFirst() then
            repeat
                GenJnlLine.Init();
                GenJnlLine.Validate("Posting Date", SalesInvHeader."Posting Date");
                //GenJnlLine."Document Date" := SalesInvHeader."Document Date";
                GenJnlLine.Description := SalesInvHeader."Posting Description";
                GenJnlLine."Reason Code" := SalesInvHeader."Reason Code";
                //GenJnlLine."Document Type" := GenJnlLineDocType;
                GenJnlLine.Validate("Document No.", SalesInvHeader."No.");
                GenJnlLine.Validate("External Document No.", SalesInvHeader."External Document No.");
                GenJnlLine.Validate("Gen. Posting Type", GenJnlLine."Gen. Posting Type"::Sale);
                GenJnlLine.Validate("Shortcut Dimension 1 Code", SalesInvLine."Shortcut Dimension 1 Code");
                GenJnlLine.Validate("Shortcut Dimension 2 Code", SalesInvLine."Shortcut Dimension 2 Code");
                GenJnlLine.Validate("Dimension Set ID", SalesInvLine."Dimension Set ID");
                //GenJnlLine."Source Code" := SrcCode;
                GenJnlLine.Validate("Bill-to/Pay-to No.", SalesInvHeader."Sell-to Customer No.");
                GenJnlLine.Validate("Source Type", GenJnlLine."Source Type"::Customer);
                GenJnlLine.Validate("Source No.", SalesInvHeader."Bill-to Customer No.");
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.Validate("Account No.", SalesSetup."Earned surcharge account");
                GenJnlLine.validate(Quantity, SalesInvLine.Quantity);
                GenJnlLine.Validate(Amount, -1 * SalesInvLine.Quantity * SalesInvLine."Surcharge Per Qty.");
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.Validate("Bal. Account No.", SalesSetup."Un earned surcharge account");
                GenJnlLine.Description := 'Item:: ' + SalesInvLine."No." + ' Quantity:: ' + FORMAT(SalesInvLine.Quantity) + ' Surcharge Per Qty:: ' + Format(SalesInvLine."Surcharge Per Qty.");
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                SalesInvLine."Earned Surcharge Posted" := true;
                SalesInvLine.Modify();
            until SalesInvLine.Next() = 0;
        SalesInvHeader."Earned Surcharge Posted" := true;
        SalesInvHeader.Modify();
    end;


}

