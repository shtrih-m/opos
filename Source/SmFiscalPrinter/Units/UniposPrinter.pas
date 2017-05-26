unit UniposPrinter;

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
    function GetLogger: TLogFile;
    function GetParameters: TMalinaParams;
  private
    FThread: TNotifyThread;
    FSemaphore: TOposSemaphore;
    FPrinter: IFiscalPrinterInternal;

    procedure CheckTextFile;
    procedure ThreadProc(Sender: TObject);
    procedure PrintReceipt(const Text: string);
    property Parameters: TMalinaParams read GetParameters;
    function FindTextFile(var FileName: string): Boolean;
    property Logger: TLogFile read GetLogger;
  public
    constructor Create(APrinter: IFiscalPrinterInternal);
    destructor Destroy; override;

    procedure Stop;
    procedure Start;
    property Printer: IFiscalPrinterInternal read FPrinter write FPrinter;
  end;

implementation

{ TUniposPrinter }

constructor TUniposPrinter.Create(APrinter: IFiscalPrinterInternal);
begin
  inherited Create;
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
      Logger.Error('TUniposPrinter.ThreadProc: ' + E.Message);
  end;
end;              

procedure TUniposPrinter.CheckTextFile;
var
  Text: string;
  FileName: string;
begin
  try
    if FindTextFile(FileName) then
    begin
      Text := ReadFileData(FileName);
      PrintReceipt(Text);
      DeleteFile(FileName);
    end;
  except
    on E: Exception do
    begin
      Logger.Error('TUniposPrinter.CheckTextFile: ' + E.Message);
    end;
  end;
end;

function TUniposPrinter.FindTextFile(var FileName: string): Boolean;
var
  Mask: string;
  F: TSearchRec;
begin
  Mask := IncludeTrailingpathDelimiter(Parameters.UniposFilesPath) + '*.*';
  Result := FindFirst(Mask, faReadOnly + faArchive, F) = 0;
  if Result then
  begin
    FileName := ExtractFilePath(Mask) + F.FindData.cFileName;
    FindClose(F);
  end;
end;

procedure TUniposPrinter.PrintReceipt(const Text: string);
var
  Data: TTextRec;
begin
  FSemaphore.Claim(FPrinter.GetPrinterSemaphoreName, 100);
  try
    FPrinter.Device.Lock;
    try
      Data.Text := Text;
      Data.Station := PRINTER_STATION_REC;
      Data.Font := Parameters.UniposTextFont;
      Data.Alignment := taLeft;
      Data.Wrap := True;
      FPrinter.Device.PrintText(Data);
      FPrinter.PrintNonFiscalEnd;
    finally
      FPrinter.Device.Unlock;
    end;
  finally
    FSemaphore.Release;
  end;
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

function TUniposPrinter.GetLogger: TLogFile;
begin
  Result := FPrinter.Device.Context.Logger;
end;

function TUniposPrinter.GetParameters: TMalinaParams;
begin
  Result := FPrinter.Device.Context.MalinaParams;
end;

end.
