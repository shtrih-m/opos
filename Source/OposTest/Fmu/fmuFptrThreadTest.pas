unit fmuFptrThreadTest;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, SyncObjs, ComObj, ActiveX, Registry,
  // Tnt
  TntStdCtrls, TntSysUtils, TntClasses, TntRegistry, 
  // This
  untPages, Opos, OposFptr, Oposhi, OposUtils,
  OposFiscalPrinter, NotifyThread, SMCashDrawer, SMFiscalPrinter, OposDevice;


type
  { TfmFptrThreadTest }

  TfmFptrThreadTest = class(TPage)
    btnStart: TTntButton;
    chbStopOnError: TTntCheckBox;
    btnStop: TTntButton;
    Timer: TTimer;
    lblDrawerTestCount_: TTntLabel;
    lblDrawerTestCount: TTntLabel;
    lblErrorCount_: TTntLabel;
    lblErrorCount: TTntLabel;
    memMessages: TTntMemo;
    cbPrinterDeviceName: TTntComboBox;
    lblDeviceName: TTntLabel;
    cbCashDeviceName: TTntComboBox;
    lblCashDeviceName: TTntLabel;
    lblPrinterTestCount_: TTntLabel;
    lblPrinterTestCount: TTntLabel;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FMessages: TTntStrings;
    FStopFlag: Boolean;
    FErrorCount: Integer;
    FDrawerTestCount: Integer;
    FPrinterTestCount: Integer;
    FPrinterDevice: WideString;
    FDrawerDevice: WideString;
    FStopOnError: Boolean;
    FThread1: TNotifyThread;
    FThread2: TNotifyThread;
    FLock: TCriticalsection;

    procedure TestCashDrawer;
    procedure TestFiscalPrinter;
    procedure UpdateDrawerDevice;
    procedure UpdatePrinterDevice;
    procedure ThreadProc1(Sender: TObject);
    procedure ThreadProc2(Sender: TObject);
    procedure ThreadTerminated(Sender: TObject);
    procedure AddMessage(const S: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdatePage; override;
  end;

var
  fmFptrThreadTest: TfmFptrThreadTest;

implementation

{$R *.dfm}

{ TfmFptrThreadTest }

constructor TfmFptrThreadTest.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMessages := TTntStringList.Create;
  FLock := TCriticalsection.Create;
end;

destructor TfmFptrThreadTest.Destroy;
begin
  FLock.Free;
  FThread1.Free;
  FThread2.Free;
  FMessages.Free;
  inherited Destroy;
end;

procedure TfmFptrThreadTest.AddMessage(const S: WideString);
begin
  FLock.Enter;
  try
    FMessages.Add(S);
  finally
    FLock.Leave;
  end;
end;

procedure TfmFptrThreadTest.TestFiscalPrinter;
var
  Driver: TSMFiscalPrinter;

  procedure Check(AResultCode: Integer);
  begin
    if AResultCode <> OPOS_SUCCESS then
    begin
      raise Exception.CreateFmt('%d, %s, %d, %s', [
        AResultCode, GetResultCodeText(AResultCode),
        Driver.ResultCodeExtended, Driver.ErrorString]);
    end;
  end;

begin
  try
    Driver := TSMFiscalPrinter.Create;
    try
      Check(Driver.Open(FPrinterDevice));
      Check(Driver.ClaimDevice(0));
      Driver.DeviceEnabled := True;
      Check(Driver.ResetPrinter);
      Driver.Close;
    finally
      Driver.Free;
    end;
    Inc(FPrinterTestCount);
  except
    on E: Exception do
    begin
      Inc(FErrorCount);
      AddMessage('TestFiscalPrinter: ' + E.Message);
      if FStopOnError then raise;
    end;
  end;
end;

procedure TfmFptrThreadTest.ThreadProc1(Sender: TObject);
begin
  try
    OleCheck(CoInitialize(nil));
    repeat
      TestFiscalPrinter;
    until FStopFlag;
  except
    on E: Exception do
    begin
      AddMessage('ERROR: ' + E.Message);
    end;
  end;
  CoUninitialize;
end;

procedure TfmFptrThreadTest.TestCashDrawer;
var
  Driver: TSMCashDrawer;

  procedure Check(AResultCode: Integer);
  begin
    if AResultCode <> OPOS_SUCCESS then
    begin
      raise Exception.CreateFmt('%d, %s, %d', [
        AResultCode, GetResultCodeText(AResultCode),
        Driver.ResultCodeExtended]);
    end;
  end;

begin
  try
    Driver := TSMCashDrawer.Create;
    try
      Check(Driver.Open(FDrawerDevice));
      Check(Driver.ClaimDevice(0));
      Driver.DeviceEnabled := True;
      Driver.Close;
    finally
      Driver.Free;
    end;
    Inc(FDrawerTestCount);
  except
    on E: Exception do
    begin
      Inc(FErrorCount);
      AddMessage('TestCashDrawer: ' + E.Message);
    end;
  end;
end;

procedure TfmFptrThreadTest.ThreadProc2(Sender: TObject);
begin
  try
    OleCheck(CoInitialize(nil));
    repeat
      TestCashDrawer;
    until FStopFlag;
  except
    on E: Exception do
    begin
      AddMessage('ERROR: ' + E.Message);
    end;
  end;
  CoUninitialize;
end;

procedure TfmFptrThreadTest.btnStartClick(Sender: TObject);
begin
  btnStart.Enabled := False;
  btnStop.Enabled := True;
  btnStop.SetFocus;
  FErrorCount := 0;
  FDrawerTestCount := 0;
  FPrinterTestCount := 0;
  FStopOnError := chbStopOnError.Checked;
  FPrinterDevice := cbPrinterDeviceName.Text;
  FDrawerDevice := cbCashDeviceName.Text;

  memMessages.Clear;

  FStopFlag := True;
  FThread1.Free;
  FThread2.Free;
  FStopFlag := False;

  FThread1 := TNotifyThread.Create(True);
  FThread1.OnExecute := ThreadProc1;
  FThread1.OnTerminate := ThreadTerminated;
  FThread1.Resume;

  FThread2 := TNotifyThread.Create(True);
  FThread2.OnExecute := ThreadProc2;
  FThread2.OnTerminate := ThreadTerminated;
  FThread2.Resume;

  Timer.Enabled := True;
end;

procedure TfmFptrThreadTest.btnStopClick(Sender: TObject);
begin
  FStopFlag := True;
  Timer.Enabled := False;
  btnStop.Enabled := False;
end;

procedure TfmFptrThreadTest.ThreadTerminated(Sender: TObject);
begin
  UpdatePage;
  btnStop.Enabled := False;
  btnStart.Enabled := True;
  btnStart.SetFocus;
end;

procedure TfmFptrThreadTest.UpdatePage;
begin
  lblErrorCount.Caption := IntToStr(FErrorCount);
  lblDrawerTestCount.Caption := IntToStr(FDrawerTestCount);
  lblPrinterTestCount.Caption := IntToStr(FPrinterTestCount);

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

procedure TfmFptrThreadTest.TimerTimer(Sender: TObject);
begin
  try
    UpdatePage;
  except
     Timer.Enabled := False;
  end;
end;

procedure TfmFptrThreadTest.UpdatePrinterDevice;
var
  Device: TOposDevice;
begin
  Device := TOposDevice.Create(nil, OPOS_CLASSKEY_FPTR, OPOS_CLASSKEY_FPTR,
    FiscalPrinterProgID);
  try
    Device.GetDeviceNames(cbPrinterDeviceName.Items);
    if cbPrinterDeviceName.Items.Count > 0 then
      cbPrinterDeviceName.ItemIndex := 0;
  finally
    Device.Free;
  end;
end;

procedure TfmFptrThreadTest.UpdateDrawerDevice;
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access := KEY_QUERY_VALUE + KEY_ENUMERATE_SUB_KEYS;
    if Reg.OpenKey('SOFTWARE\OLEforRetail\ServiceOPOS\CashDrawer', False) then
      Reg.GetKeyNames(cbCashDeviceName.Items);
    if cbCashDeviceName.Items.Count > 0 then
      cbCashDeviceName.ItemIndex := 0;
  finally
    Reg.Free;
  end;
end;

procedure TfmFptrThreadTest.FormCreate(Sender: TObject);
begin
  UpdateDrawerDevice;
  UpdatePrinterDevice;
end;

end.
