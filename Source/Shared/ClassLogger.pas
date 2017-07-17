unit ClassLogger;

interface

uses
  // VCL
  SysUtils,
  // This
  LogFile;

type
  { TClassLogger }

  TClassLogger = class
  private
    FClassName: string;
    FLogger: ILogFile;

    function GetData(const Data: string): string;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(AClassName: string; ALogger: ILogFile);

    procedure Info(const Data: string); overload;
    procedure Debug(const Data: string); overload;
    procedure Trace(const Data: string); overload;
    procedure Error(const Data: string); overload;
    procedure Error(const Data: string; E: Exception); overload;
    procedure Debug(const Data: string; Result: Variant); overload;
    procedure Info(const Data: string; Params: array of const); overload;
    procedure Debug(const Data: string; Params: array of const); overload;
    procedure Trace(const Data: string; Params: array of const); overload;
    procedure Error(const Data: string; Params: array of const); overload;
    procedure Debug(const Data: string; Params: array of const; Result: Variant); overload;
  end;

implementation

{ TClassLogger }

constructor TClassLogger.Create(AClassName: string; ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FClassName := AClassName;
end;

function TClassLogger.GetData(const Data: string): string;
begin
  Result := FClassName + '.' + Data;
end;

procedure TClassLogger.Debug(const Data: string; Result: Variant);
begin
  Logger.Debug(GetData(Data), Result);
end;

procedure TClassLogger.Debug(const Data: string);
begin
  Logger.Debug(GetData(Data));
end;

procedure TClassLogger.Debug(const Data: string; Params: array of const;
  Result: Variant);
begin
  Logger.Debug(GetData(Data), Params, Result);
end;

procedure TClassLogger.Debug(const Data: string; Params: array of const);
begin
  Logger.Debug(GetData(Data), Params);
end;

procedure TClassLogger.Error(const Data: string; Params: array of const);
begin
  Logger.Error(GetData(Data), Params);
end;

procedure TClassLogger.Error(const Data: string; E: Exception);
begin
  Logger.Error(GetData(Data), E);
end;

procedure TClassLogger.Error(const Data: string);
begin
  Logger.Error(GetData(Data));
end;

procedure TClassLogger.Info(const Data: string);
begin
  Logger.Info(GetData(Data));
end;

procedure TClassLogger.Info(const Data: string; Params: array of const);
begin
  Logger.Info(GetData(Data), Params);
end;

procedure TClassLogger.Trace(const Data: string; Params: array of const);
begin
  Logger.Trace(GetData(Data), Params);
end;

procedure TClassLogger.Trace(const Data: string);
begin
  Logger.Trace(GetData(Data));
end;

end.
