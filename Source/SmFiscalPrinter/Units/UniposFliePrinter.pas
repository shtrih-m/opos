UniposFliePrinter;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Registry, ActiveX, ComObj,
  // This
  UniposReader, NotifyThread, LogFile, PrinterTypes, DebugUtils,
  FiscalPrinterTypes, OposSemaphore, MalinaParams, FileUtils;

type
  { TUniposPrinter }

  TUniposPrinter = class
  private
    FThread: TNotifyThread;
    FSemaphore: TOposSemaphore;
    FParameters: TMalinaParams;
    FPrinter: IFiscalPrinterInternal;

    procedure CheckTextFile;
    procedure ThreadProc(Sender: TObject);
    procedure PrintReceipt(const Text: string);
    property Parameters: TMalinaParams read FParameters;
  public
    constructor Create(APrinter: IFiscalPrinterInternal;
      AParameters: TMalinaParams);
    destructor Destroy; override;

    procedure Stop;
    procedure Start;
    property Printer: IFiscalPrinterInternal read FPrinter write FPrinter;
  end;

implementation

{ TUniposPrinter }

constructor TUniposPrinter.Create(APrinter: IFiscalPrinterInternal;
  AParameters: TMalinaParams);
begin
  inherited Create;
  FParameters := AParameters;
  FSemaphore := TOposSemaphore.Create;
  FPrinter := APrinter;
end;

destructor TUniposPrinter.Destroy;
begin
  Stop;
  FSemaphore.Free;
  FPrinter := nil;
  inherited Destroy;
end;

procedure TUniposPrinter.ThreadProc(Sender: TObject);
begin
  try
    while not FThread.Terminated do
    begin
      CheckTextFile;
      Sleep(20);
    end;
  except
    On E: Exception do
      Logger.Error('TUniposPrinter.ThreadProc: ' + GetExceptionMessage(E));
  end;
end;

procedure TUniposPrinter.CheckTextFile;
var
  Text: string;
  FileName: string;
begin
  try
    //if FindTextFile(FileName) then
    begin
      Text := ReadFileData(FileName);
      PrintReceipt(Text);
      DeleteFile(FileName);
    end;
  except
    on E: Exception do
    begin
      Logger.Error('TUniposPrinter.CheckTextFile: ' + GetExceptionMessage(E));
    end;
  end;
end;

procedure TUniposPrinter.PrintReceipt(const Text: string);
var
  Font: Integer;
begin
  Logger.Debug('TUniposPrinter.PrintReceipt.Begin');
  FSemaphore.Claim(FPrinter.GetPrinterSemaphoreName, 100);
  try
    FPrinter.Device.Lock;
    try
      Font := Parameters.UniposTextFont;
      FPrinter.PrintTextFont(PRINTER_STATION_REC, Font, Text);
      FPrinter.PrintNonFiscalEnd;
    finally
      FPrinter.Device.Unlock;
    end;
  finally
    FSemaphore.Release;
  end;
  Logger.Debug('TUniposPrinter.PrintReceipt.End');
end;

procedure TUniposPrinter.Stop;
begin
  FThread.Free;
  FThread := nil;
end;

procedure TUniposPrinter.Start;
begin
  Stop;
  FThread := TNotifyThread.Create(True);
  FThread.OnExecute := ThreadProc;
  FThread.Resume;
end;

end.
