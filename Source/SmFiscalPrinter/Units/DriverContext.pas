unit DriverContext;

interface

uses
  // This
  LogFile, MalinaParams, PrinterParameters;

type
  { TDriverContext }

  TDriverContext = class
  private
    FLogger: ILogFile;
    FMalinaParams: TMalinaParams;
    FParameters: TPrinterParameters;
  public
    constructor Create;
    destructor Destroy; override;

    property Logger: ILogFile read FLogger;
    property MalinaParams: TMalinaParams read FMalinaParams;
    property Parameters: TPrinterParameters read FParameters;
  end;

implementation

{ TDriverContext }

constructor TDriverContext.Create;
begin
  inherited Create;
  FLogger := TLogFile.Create;
  FMalinaParams := TMalinaParams.Create(FLogger);
  FParameters := TPrinterParameters.Create(FLogger);
end;

destructor TDriverContext.Destroy;
begin
  FParameters.Free;
  FMalinaParams.Free;
  FLogger := nil;
  inherited Destroy;
end;

end.
