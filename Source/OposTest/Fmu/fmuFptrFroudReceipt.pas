unit fmuFptrFroudReceipt;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // 3's
  PngImage,
  // This
  untPages, Opos, OposUtils, OposFiscalPrinter, OposFptr, OposFptrUtils,
  TankReader, UniposTank, UniposReader;

type
  TfmFptrFroudReceipt = class(TPage)
    btnInvalidSalesReceipt: TTntButton;
    Memo: TTntMemo;
    btnInvalidRefundReceipt: TTntButton;
    btnValidSalesReceipt: TTntButton;
    btnInvalidRefundReceipt2: TTntButton;
    btnValidRefundReceipt: TTntButton;
    btnInvalidSalesReceipt2: TTntButton;
    procedure btnInvalidSalesReceiptClick(Sender: TObject);
    procedure btnInvalidRefundReceiptClick(Sender: TObject);
    procedure btnValidSalesReceiptClick(Sender: TObject);
    procedure btnInvalidRefundReceipt2Click(Sender: TObject);
    procedure btnValidRefundReceiptClick(Sender: TObject);
    procedure btnInvalidSalesReceipt2Click(Sender: TObject);
  private
    procedure AddLine(const Line: WideString);
    procedure WriteReceiptFlags;
  end;

var
  fmFptrFroudReceipt: TfmFptrFroudReceipt;

implementation

{$R *.dfm}

function GetDaySeconds: Integer;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Now, Hour, Min, Sec, MSec);
  Result := Hour*3600 + Min*60 + Sec;
end;

{ TfmTankReport }

procedure TfmFptrFroudReceipt.AddLine(const Line: WideString);
begin
  Memo.Lines.Add(Line);
end;

procedure TfmFptrFroudReceipt.btnInvalidSalesReceiptClick(Sender: TObject);
begin
  Memo.Clear;
  EnableButtons(False);
  try
    AddLine('ResetPrinter');
    Check(FiscalPrinter.ResetPrinter);
    // BeginFiscalReceipt
    AddLine('BeginFiscalReceipt');
    FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
    FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
    Check(FiscalPrinter.BeginFiscalReceipt(False));
    // PrintRecItem
    AddLine('PrintRecItem1');
    Check(FiscalPrinter.PrintRecItem('+++¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecItem2
    AddLine('PrintRecItem2');
    Check(FiscalPrinter.PrintRecItem('+++¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecItem
    AddLine('PrintRecItem');
    Check(FiscalPrinter.PrintRecItem('¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecTotal
    AddLine('PrintRecTotal');
    Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
    // EndFiscalReceipt
    AddLine('EndFiscalReceipt');
    Check(FiscalPrinter.EndFiscalReceipt(False));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFroudReceipt.btnInvalidRefundReceiptClick(Sender: TObject);
begin
  Memo.Clear;
  EnableButtons(False);
  try
    WriteReceiptFlags;

    AddLine('ResetPrinter');
    Check(FiscalPrinter.ResetPrinter);
    // BeginFiscalReceipt
    AddLine('BeginFiscalReceipt');
    FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
    FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
    Check(FiscalPrinter.BeginFiscalReceipt(False));
    // PrintRecItem
    AddLine('PrintRecItem1');
    Check(FiscalPrinter.PrintRecItemRefund('¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecItem
    AddLine('PrintRecItem1');
    Check(FiscalPrinter.PrintRecItemRefund('+++¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecTotal
    AddLine('PrintRecTotal');
    Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
    // EndFiscalReceipt
    AddLine('EndFiscalReceipt');
    Check(FiscalPrinter.EndFiscalReceipt(False));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFroudReceipt.WriteReceiptFlags;
var
  Reader: TUniposReader;
  Data: TReceiptFlagsRec;
begin
  Reader := TUniposReader.Create(FiscalPrinter.Logger);
  try
    Data.Enabled := True;
    Data.Seconds := GetDaySeconds + 100;
    Reader.WriteReceiptFlags(Data);
  finally
    Reader.Free;
  end;
end;

procedure TfmFptrFroudReceipt.btnValidSalesReceiptClick(Sender: TObject);
begin
  WriteReceiptFlags;

  Memo.Clear;
  EnableButtons(False);
  try
    AddLine('ResetPrinter');
    Check(FiscalPrinter.ResetPrinter);
    // BeginFiscalReceipt
    AddLine('BeginFiscalReceipt');
    FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
    FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
    Check(FiscalPrinter.BeginFiscalReceipt(False));
    // PrintRecItem
    AddLine('PrintRecItem1');
    Check(FiscalPrinter.PrintRecItem('+++¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecTotal
    AddLine('PrintRecTotal');
    Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
    // EndFiscalReceipt
    AddLine('EndFiscalReceipt');
    Check(FiscalPrinter.EndFiscalReceipt(False));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFroudReceipt.btnInvalidRefundReceipt2Click(Sender: TObject);
begin
  Memo.Clear;
  EnableButtons(False);
  try
    WriteReceiptFlags;
    AddLine('ResetPrinter');
    Check(FiscalPrinter.ResetPrinter);
    // BeginFiscalReceipt
    AddLine('BeginFiscalReceipt');
    FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
    FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
    Check(FiscalPrinter.BeginFiscalReceipt(False));
    // PrintRecItem
    AddLine('PrintRecItem1');
    Check(FiscalPrinter.PrintRecRefund('+++¿»-92', 100, 0));
    // PrintRecTotal
    AddLine('PrintRecTotal');
    Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
    // EndFiscalReceipt
    AddLine('EndFiscalReceipt');
    Check(FiscalPrinter.EndFiscalReceipt(False));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFroudReceipt.btnValidRefundReceiptClick(Sender: TObject);
begin
  Memo.Clear;
  EnableButtons(False);
  try
    AddLine('ResetPrinter');
    Check(FiscalPrinter.ResetPrinter);
    // BeginFiscalReceipt
    AddLine('BeginFiscalReceipt');
    FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
    FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
    Check(FiscalPrinter.BeginFiscalReceipt(False));
    // PrintRecItem
    AddLine('PrintRecItem1');
    Check(FiscalPrinter.PrintRecRefund('¿»-92', 100, 0));
    // PrintRecTotal
    AddLine('PrintRecTotal');
    Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
    // EndFiscalReceipt
    AddLine('EndFiscalReceipt');
    Check(FiscalPrinter.EndFiscalReceipt(False));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFroudReceipt.btnInvalidSalesReceipt2Click(
  Sender: TObject);
begin
  Memo.Clear;
  EnableButtons(False);
  try
    AddLine('ResetPrinter');
    Check(FiscalPrinter.ResetPrinter);
    // BeginFiscalReceipt
    AddLine('BeginFiscalReceipt');
    FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
    FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
    Check(FiscalPrinter.BeginFiscalReceipt(False));
    // PrintRecItem
    AddLine('PrintRecItem');
    Check(FiscalPrinter.PrintRecItem('¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecItem
    AddLine('PrintRecItem1');
    Check(FiscalPrinter.PrintRecItem('+++¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecItem2
    AddLine('PrintRecItem2');
    Check(FiscalPrinter.PrintRecItem('+++¿»-92', 0, 1000, 0, 100, ''));
    // PrintRecTotal
    AddLine('PrintRecTotal');
    Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
    // EndFiscalReceipt
    AddLine('EndFiscalReceipt');
    Check(FiscalPrinter.EndFiscalReceipt(False));
  finally
    EnableButtons(True);
  end;
end;

end.
