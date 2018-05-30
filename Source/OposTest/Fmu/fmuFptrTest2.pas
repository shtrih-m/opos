unit fmuFptrTest2;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, SyncObjs, ComObj, ActiveX, Registry,
  // Tnt
  TntStdCtrls, TntSysUtils, TntClasses, 
  // This
  untPages, Opos, OposFptr, Oposhi, OposUtils,
  OposFiscalPrinter, NotifyThread, SMFiscalPrinter, OposDevice;

type
  { TfmFptrTest2 }

  TfmFptrTest2 = class(TPage)
    btnStart: TTntButton;
    chbStopOnError: TTntCheckBox;
    btnStop: TTntButton;
    Timer: TTimer;
    lblErrorCount_: TTntLabel;
    lblErrorCount: TTntLabel;
    memMessages: TTntMemo;
    cbPrinterDeviceName: TTntComboBox;
    lblDeviceName: TTntLabel;
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
    FPrinterTestCount: Integer;
    FPrinterDevice: WideString;
    FStopOnError: Boolean;
    FThread: TNotifyThread;
    FLock: TCriticalsection;

    procedure TestFiscalPrinter;
    procedure UpdatePrinterDevice;
    procedure ThreadProc1(Sender: TObject);
    procedure ThreadTerminated(Sender: TObject);
    procedure AddMessage(const S: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdatePage; override;
  end;

var
  fmFptrTest2: TfmFptrTest2;

implementation

{$R *.dfm}

{ TfmFptrThreadTest }

constructor TfmFptrTest2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMessages := TTntStringList.Create;
  FLock := TCriticalsection.Create;
end;

destructor TfmFptrTest2.Destroy;
begin
  FLock.Free;
  FThread.Free;
  FMessages.Free;
  inherited Destroy;
end;

procedure TfmFptrTest2.AddMessage(const S: WideString);
begin
  FLock.Enter;
  try
    FMessages.Add(S);
  finally
    FLock.Leave;
  end;
end;

procedure TfmFptrTest2.TestFiscalPrinter;
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
      while not FStopFlag do
      begin
        Check(Driver.ResetPrinter);
        Inc(FPrinterTestCount);
      end;
      Driver.Close;
    finally
      Driver.Free;
    end;
  except
    on E: Exception do
    begin
      Inc(FErrorCount);
      AddMessage('TestFiscalPrinter: ' + E.Message);
      if FStopOnError then raise;
    end;
  end;
end;

procedure TfmFptrTest2.ThreadProc1(Sender: TObject);
begin
  try
    OleCheck(CoInitialize(nil));
    TestFiscalPrinter;
  except
    on E: Exception do
    begin
      AddMessage('ERROR: ' + E.Message);
    end;
  end;
  CoUninitialize;
end;

procedure TfmFptrTest2.btnStartClick(Sender: TObject);
begin
  btnStart.Enabled := False;
  btnStop.Enabled := True;
  btnStop.SetFocus;
  FErrorCount := 0;
  FPrinterTestCount := 0;
  FStopOnError := chbStopOnError.Checked;
  FPrinterDevice := cbPrinterDeviceName.Text;

  memMessages.Clear;

  FStopFlag := True;
  FThread.Free;
  FStopFlag := False;

  FThread := TNotifyThread.Create(True);
  FThread.OnExecute := ThreadProc1;
  FThread.OnTerminate := ThreadTerminated;
  FThread.Resume;

  Timer.Enabled := True;
end;

procedure TfmFptrTest2.btnStopClick(Sender: TObject);
begin
  FStopFlag := True;
  Timer.Enabled := False;
  btnStop.Enabled := False;
end;

procedure TfmFptrTest2.ThreadTerminated(Sender: TObject);
begin
  UpdatePage;
  btnStop.Enabled := False;
  btnStart.Enabled := True;
  btnStart.SetFocus;
end;

procedure TfmFptrTest2.UpdatePage;
begin
  lblErrorCount.Caption := IntToStr(FErrorCount);
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

procedure TfmFptrTest2.TimerTimer(Sender: TObject);
begin
  try
    UpdatePage;
  except
     Timer.Enabled := False;
  end;
end;

procedure TfmFptrTest2.UpdatePrinterDevice;
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

procedure TfmFptrTest2.FormCreate(Sender: TObject);
begin
  UpdatePrinterDevice;
end;

end.
