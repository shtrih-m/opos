unit oleXmlParams;

interface

uses
  // VCL
  Windows, ComObj, ActiveX, StdVcl, ComServ, SysUtils, Classes,
  // This
  SmFiscalPrinterLib_TLB, LogFile, XmlValue;

type
  { TDirectIOCommand }

  TXmlParams = class(TAutoObject, IXmlParams)
  private
    FLogger: TLogFile;
    FParams: TXmlValues;
    property Logger: TLogFile read FLogger;
  protected
    procedure SetParam(const ParamName: WideString; const ParamValue: WideString); safecall;
    function  GetParam(const ParamName: WideString): WideString; safecall;
    function  Get_AsXml: WideString; safecall;
    procedure Set_AsXml(const Value: WideString); safecall;
    property AsXml: WideString read Get_AsXml write Set_AsXml;
    procedure AddParam(const ParamName, ParamValue: WideString); safecall;
    procedure Clear; safecall;
  public
    constructor Create(ALogger: TLogFile);
    destructor Destroy; override;
    procedure Initialize; override;
  end;

implementation

{ TDirectIOCommand }

constructor TXmlParams.Create(ALogger: TLogFile);
begin
  inherited Create;
  FLogger := ALogger;
end;

destructor TXmlParams.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

procedure TXmlParams.Initialize;
begin
  FParams := TXmlValues.Create;
end;

function TXmlParams.GetParam(
  const ParamName: WideString): WideString;
begin
  try
    Result := FParams.ItemByName(ParamName).Value;
  except
    on E: Exception do
    begin
      Logger.Error('TDirectIOCommand.GetParam', E);
      Result := '';
    end;
  end;
end;

procedure TXmlParams.SetParam(const ParamName,
  ParamValue: WideString);
begin
  try
    FParams.ItemByName(ParamName).Value := ParamValue;
  except
    on E: Exception do
    begin
      Logger.Error('TDirectIOCommand.SetParam', E);
    end;
  end;
end;

function TXmlParams.Get_AsXml: WideString;
begin
  try
    Result := FParams.AsXml;
  except
    on E: Exception do
    begin
      Logger.Error('TDirectIOCommand.Get_AsXml', E);
      Result := '';
    end;
  end;
end;

procedure TXmlParams.Set_AsXml(const Value: WideString);
begin
  try
    FParams.AsXml := Value;
  except
    on E: Exception do
    begin
      Logger.Error('TDirectIOCommand.Set_AsXml', E);
    end;
  end;
end;

procedure TXmlParams.AddParam(const ParamName,
  ParamValue: WideString);
var
  Param: TXmlValue;
begin
  try
    Param := FParams.FindItem(ParamName);
    if Param = nil then Param := FParams.Add;

    Param.Name := ParamName;
    Param.Value := ParamValue;
  except
    on E: Exception do
    begin
      Logger.Error('TDirectIOCommand.AddParam', E);
    end;
  end;
end;

procedure TXmlParams.Clear;
begin
  FParams.Clear;
end;

initialization
  ComServer.SetServerName('OposShtrih');
  TAutoObjectFactory.Create(ComServer, TXmlParams, Class_XmlParams,
    ciMultiInstance, tmApartment);

end.
