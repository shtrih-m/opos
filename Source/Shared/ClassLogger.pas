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
    FClassName: WideString;
    FLogger: ILogFile;

    function GetData(const Data: WideString): WideString;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(AClassName: WideString; ALogger: ILogFile);

    procedure Info(const Data: WideString); overload;
    procedure Debug(const Data: WideString); overload;
    procedure Trace(const Data: WideString); overload;
    procedure Error(const Data: WideString); overload;
    procedure Error(const Data: WideString; E: Exception); overload;
    procedure Debug(const Data: WideString; Result: Variant); overload;
    procedure Info(const Data: WideString; Params: array of const); overload;
    procedure Debug(const Data: WideString; Params: array of const); overload;
    procedure Trace(const Data: WideString; Params: array of const); overload;
    procedure Error(const Data: WideString; Params: array of const); overload;
    procedure Debug(const Data: WideString; Params: array of const; Result: Variant); overload;
  end;

implementation

{ TClassLogger }

constructor TClassLogger.Create(AClassName: WideString; ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FClassName := AClassName;
end;

function TClassLogger.GetData(const Data: WideString): WideString;
begin
  Result := FClassName + '.' + Data;
end;

procedure TClassLogger.Debug(const Data: WideString; Result: Variant);
begin
  Logger.Debug(GetData(Data), Result);
end;

procedure TClassLogger.Debug(const Data: WideString);
begin
  Logger.Debug(GetData(Data));
end;

procedure TClassLogger.Debug(const Data: WideString; Params: array of const;
  Result: Variant);
begin
  Logger.Debug(GetData(Data), Params, Result);
end;

procedure TClassLogger.Debug(const Data: WideString; Params: array of const);
begin
  Logger.Debug(GetData(Data), Params);
end;

procedure TClassLogger.Error(const Data: WideString; Params: array of const);
begin
  Logger.Error(GetData(Data), Params);
end;

procedure TClassLogger.Error(const Data: WideString; E: Exception);
begin
  Logger.Error(GetData(Data), E);
end;

procedure TClassLogger.Error(const Data: WideString);
begin
  Logger.Error(GetData(Data));
end;

procedure TClassLogger.Info(const Data: WideString);
begin
  Logger.Info(GetData(Data));
end;

procedure TClassLogger.Info(const Data: WideString; Params: array of const);
begin
  Logger.Info(GetData(Data), Params);
end;

procedure TClassLogger.Trace(const Data: WideString; Params: array of const);
begin
  Logger.Trace(GetData(Data), Params);
end;

procedure TClassLogger.Trace(const Data: WideString);
begin
  Logger.Trace(GetData(Data));
end;

end.
