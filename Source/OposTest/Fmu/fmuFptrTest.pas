unit fmuFptrTest;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, SyncObjs, ComObj, ActiveX,
  // Tnt
  TntSysUtils, TntClasses, 
  // This
  untPages, OposFptr, OposFiscalPrinter, NotifyThread, TntStdCtrls;


type
  { TfmFptrTest }

  TfmFptrTest = class(TPage)
    btnStart: TTntButton;
    lblReceiptPeriod: TTntLabel;
    spereceiptPeriod: TSpinEdit;
    chbStopOnError: TTntCheckBox;
    btnStop: TTntButton;
    Timer: TTimer;
    lblReceiptsPrinted_: TTntLabel;
    lblReceiptsPrinted: TTntLabel;
    lblErrorCount_: TTntLabel;
    lblErrorCount: TTntLabel;
    memMessages: TTntMemo;
    lblReceiptItemsCount: TTntLabel;
    speReceiptItemsCount: TSpinEdit;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FMessages: TTntStrings;
    FStopFlag: Boolean;
    FErrorCount: Integer;
    FReceiptCount: Integer;
    FStopOnError: Boolean;
    FReceiptPeriod: Integer;
    FThread: TNotifyThread;
    FLock: TCriticalsection;
    FReceiptItemsCount: Integer;
    procedure PrintReceipt;
    procedure ThreadProc(Sender: TObject);
    procedure ThreadTerminated(Sender: TObject);
    procedure AddMessage(const S: WideString);
    procedure Sleep2(PeriodInMs: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdatePage; override;
  end;

var
  fmFptrTest: TfmFptrTest;

implementation

{$R *.dfm}

constructor TfmFptrTest.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMessages := TTntStringList.Create;
  FLock := TCriticalsection.Create;
end;

destructor TfmFptrTest.Destroy;
begin
  FLock.Free;
  FMessages.Free;
  inherited Destroy;
end;

procedure TfmFptrTest.AddMessage(const S: WideString);
begin
  FLock.Enter;
  try
    FMessages.Add(S);
  finally
    FLock.Leave;
  end;
end;

procedure TfmFptrTest.ThreadProc(Sender: TObject);
begin
  try
    OleCheck(CoInitialize(nil));
    repeat
      PrintReceipt;
      Sleep2(FReceiptPeriod);
    until FStopFlag;
  except
    on E: Exception do
    begin
      AddMessage('ERROR: ' + E.Message);
    end;
  end;
  CoUninitialize;
end;

procedure TfmFptrTest.Sleep2(PeriodInMs: Integer);
var
  TickCount: Integer;
begin
  TickCount := GetTickCount;
  while True do
  begin
    if FStopFlag then Break;
    if (Integer(GetTickCount) - TickCount) > PeriodInMs then Break;
    Sleep(50);
 end;
end;

procedure TfmFptrTest.PrintReceipt;
var
  i: Integer;
  ItemName: WideString;
begin
  try
    Check(FiscalPrinter.ResetPrinter);
    FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
    FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
    Check(FiscalPrinter.BeginFiscalReceipt(True));
    for i := 1 to FReceiptItemsCount do
    begin
      ItemName := Tnt_WideFormat('%d. Receipt item %d', [i, i]);
      Check(FiscalPrinter.PrintRecItem(ItemName, 0.01, 1000, 0, 0.01, ''));
    end;
    Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
    Check(FiscalPrinter.EndFiscalReceipt(False));

    Inc(FReceiptCount);
    AddMessage(Format('OK: receipt %d printed', [FReceiptCount]));
  except
    on E: Exception do
    begin
      Inc(FErrorCount);
      if FStopOnError then raise;
      AddMessage('ERROR: ' + E.Message);
    end;
  end;
end;

procedure TfmFptrTest.btnStartClick(Sender: TObject);
begin
  btnStart.Enabled := False;
  btnStop.Enabled := True;
  btnStop.SetFocus;
  FStopFlag := False;
  FErrorCount := 0;
  FReceiptCount := 0;
  FStopOnError := chbStopOnError.Checked;
  FReceiptPeriod := speReceiptPeriod.Value * 1000;
  FReceiptItemsCount := speReceiptItemsCount.Value;
  memMessages.Clear;

  FThread := TNotifyThread.Create(True);
  FThread.OnExecute := ThreadProc;
  FThread.OnTerminate := ThreadTerminated;
  FThread.Resume;
  Timer.Enabled := True;
end;

procedure TfmFptrTest.btnStopClick(Sender: TObject);
begin
  FStopFlag := True;
  Timer.Enabled := False;
  btnStop.Enabled := False;
end;

procedure TfmFptrTest.ThreadTerminated(Sender: TObject);
begin
  UpdatePage;
  btnStop.Enabled := False;
  btnStart.Enabled := True;
  btnStart.SetFocus;
end;

procedure TfmFptrTest.UpdatePage;
begin
  lblErrorCount.Caption := IntToStr(FErrorCount);
  lblReceiptsPrinted.Caption := IntToStr(FReceiptCount);
  FLock.Enter;
  try
    while FMessages.Count > 0 do
    begin
      memMessages.Lines.Add(FMessages[0]);
      FMessages.Delete(0);
    end;
  finally
    FLock.Leave;
  end;
end;

procedure TfmFptrTest.TimerTimer(Sender: TObject);
begin
  try
    UpdatePage;
  except
     Timer.Enabled := False;
  end;
end;

end.
