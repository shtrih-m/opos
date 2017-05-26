unit LogoLoader;

interface

uses
  // VCL
  SysUtils, ExtCtrls, Graphics, Classes, Forms,
  // VCL
  NotifyThread, FiscalPrinterImpl, PrinterParameters, FiscalPrinterTypes;

const
  NOTIFY_CODE_PROGRESS  = 0;
  NOTIFY_CODE_STOP      = 1;

type
  { TLogoLoader }

  TLogoLoader = class
  private
    FData: string;
    FProgress: Integer;
    FStarted: Boolean;
    FThread: TNotifyThread;
    FOnChange: TNotifyEvent;
    FPrinter: TFiscalPrinterImpl;

    procedure DoChanged;
    procedure SetStarted(Value: Boolean);
    procedure SetProgress(Value: Integer);
    procedure ThreadProc(Sender: TObject);

    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    procedure Stop;
    procedure Start(const Data: string; APrinter: TFiscalPrinterImpl);

    property Progress: Integer read FProgress;
    property Started: Boolean read FStarted;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TLogoLoader }

procedure TLogoLoader.Start(Picture: TPicture; APrinter: TFiscalPrinterImpl);
begin
  FData := Data;
  FPrinter := APrinter;

  FThread.Free;
  FThread := TNotifyThread.Create(True);
  FThread.OnExecute := ThreadProc;
  FThread.Resume;
end;

procedure TLogoLoader.Stop;
begin
  FThread.Free;
  FThread := nil;
end;

procedure TLogoLoader.DoChanged;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TLogoLoader.SetStarted(Value: Boolean);
begin
  if Value <> Started then
  begin
    FStarted := Value;
    DoChanged;
  end;
end;

procedure TLogoLoader.SetProgress(Value: Integer);
begin
  if Value <> FProgress then
  begin
    FProgress := Value;
    DoChanged;
  end;
end;

procedure TLogoLoader.ThreadProc(Sender: TObject);
var
  i: Integer;
  ImageHeight: Integer;
  Device: IFiscalPrinterDevice;
begin
  SetStarted(True);
  try
    ImageHeight := Length(FData) div 40;
    Device := Printer.Printer.Device;
    Device.CheckGraphicsSize(ImageHeight);
    for i := 0 to ImageHeight-1 do
    begin
      if FThread.Terminated then Abort;
      Device.Check(Device.LoadGraphics(i+1, Copy(FData, i*40 + 1, 40)));
      SetProgress(i*100 div ImageHeight);
    end;
    SetProgress(100);

    Parameters.LogoSize := ImageHeight;
    Printer.SaveParameters;
  except
    on E: Exception do
    begin
      Application.HandleException(E);
    end;
  end;
  SetStarted(False);
end;


end.
