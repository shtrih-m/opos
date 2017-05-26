unit ScaleDIOHandlers;

interface

uses
  // VCL
  SysUtils, Graphics, Extctrls,
  // Opos
  Opos, OposException,
  // This
  DIOHandler, ScaleDirectIO, CommandDef, M5OposDevice,
  CommandParam, BinStream, StringUtils, ScaleParameters;

const
  ValueDelimiters = [';'];

type
  { TM5DIOHandler }

  TM5DIOHandler = class(TDIOHandler)
  private
    FDriver: TM5OposDevice;
    property Driver: TM5OposDevice read FDriver;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ADriver: TM5OposDevice);
  end;

  { TDIOXmlCommand }

  TDIOXmlCommand = class(TM5DIOHandler)
  public
    function GetCommand: Integer; override;
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOHexCommand }

  TDIOHexCommand = class(TM5DIOHandler)
  public
    function GetCommand: Integer; override;
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStrCommand }

  TDIOStrCommand = class(TM5DIOHandler)
  public
    function GetCommand: Integer; override;
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetDriverParameter }

  TDIOGetDriverParameter = class(TM5DIOHandler)
  public
    function GetCommand: Integer; override;
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetDriverParameter }

  TDIOSetDriverParameter = class(TM5DIOHandler)
  public
    function GetCommand: Integer; override;
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

const
  FPTR_ERROR_BASE = 300;

implementation

{ TM5DIOHandler }

constructor TM5DIOHandler.CreateCommand(AOwner: TDIOHandlers;
  ADriver: TM5OposDevice);
begin
  inherited Create(AOwner);
  FDriver := ADriver;
end;

{ TDIOXmlCommand }

function TDIOXmlCommand.GetCommand: Integer;
begin
  Result := DIO_COMMAND_XML;
end;

procedure TDIOXmlCommand.DirectIO(var pData: Integer; var pString: WideString);
var
  Param: TCommandParam;
  Stream: TBinStream;
  Command: TCommandDef;
  ResultCode: Integer;
begin
  Command := Driver.Commands.ItemByCode(pData);
  if Command = nil then
    raise Exception.Create('Invalid command code');

  Stream := TBinStream.Create;
  try
    Command.InParams.AsXml := pString;
    Stream.WriteByte(Command.Code);
    Command.InParams.Write(Stream);
    Command.OutParams.ClearValue;

    ResultCode := Driver.Send(Stream);
    Param := Command.OutParams.FindItem('ResultCode');
    if Param <> nil then
      Param.Value := IntToStr(ResultCode);

    if ResultCode = 0 then
    begin
      Stream.Position := Stream.Position-1;
      Command.OutParams.Read(Stream);
    end else
    begin
      RaiseOPOSException(OPOS_E_FAILURE, FPTR_ERROR_BASE + ResultCode,
        Driver.GetErrorText(ResultCode));
    end;
    pString := Command.OutParams.AsXml;
  finally
    Stream.Free;
  end;
end;

{ TDIOHexCommand }

function TDIOHexCommand.GetCommand: Integer;
begin
  Result := DIO_COMMAND_HEX;
end;

procedure TDIOHexCommand.DirectIO(var pData: Integer; var pString: WideString);
var
  TxData: string;
  RxData: string;
begin
  TxData := HexToStr(pString);
  RxData := Driver.Send(TxData);
  pString := StrToHex(RxData);
end;

{ TDIOStrCommand }

function TDIOStrCommand.GetCommand: Integer;
begin
  Result := DIO_COMMAND_STR;
end;

procedure TDIOStrCommand.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Stream: TBinStream;
  Command: TCommandDef;
  ResultCode: Integer;
begin
  Command := Driver.Commands.ItemByCode(pData);
  if Command = nil then
    raise Exception.Create('Invalid command code');

  Stream := TBinStream.Create;
  try
    Command.InParams.AsText := pString;
    Stream.WriteByte(Command.Code);
    Command.InParams.Write(Stream);
    Command.OutParams.ClearValue;

    ResultCode := Driver.Send(Stream);
    if ResultCode = 0 then
    begin
      Stream.Position := 0;
      Command.OutParams.Read(Stream);
      pString := Command.OutParams.AsText;
    end else
    begin
      pString := Format('%d;%s', [ResultCode, Driver.GetErrorText(ResultCode)]);
    end;
  finally
    Stream.Free;
  end;
end;

{ TDIOGetDriverParameter }

function TDIOGetDriverParameter.GetCommand: Integer;
begin
  Result := DIO_GET_DRIVER_PARAMETER;
end;

procedure TDIOGetDriverParameter.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TScaleParameters;
begin
  P := Driver.Parameters;
  case pData of
    ParamCCOType: pString := IntToStr(P.CCOType);
    ParamPassword: pString := IntToStr(P.Password);
    ParamEncoding: pString := IntToStr(P.Encoding);
    ParamPortNumber: pString := IntToStr(P.PortNumber);
    ParamBaudRate: pString := IntToStr(P.BaudRate);
    ParamByteTimeout: pString := IntToStr(P.ByteTimeout);
    ParamCommandTimeout: pString := IntToStr(P.CommandTimeout);
    ParamMaxRetryCount: pString := IntToStr(P.MaxRetryCount);
    ParamSearchByPortEnabled: pString := BoolToStr(P.SearchByPortEnabled);
    ParamSearchByBaudRateEnabled: pString := BoolToStr(P.SearchByBaudRateEnabled);
    ParamLogFileEnabled: pString := BoolToStr(P.LogFileEnabled);
    ParamLogMaxCount: pString := IntToStr(P.LogMaxCount);
    ParamCapPrice: pString := BoolToStr(P.CapPrice);
    ParamPollPeriod: pString := IntToStr(P.PollPeriod);
  end;
end;

{ TDIOSetDriverParameter }

function TDIOSetDriverParameter.GetCommand: Integer;
begin
  Result := DIO_SET_DRIVER_PARAMETER;
end;

procedure TDIOSetDriverParameter.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TScaleParameters;
begin
  P := FDriver.Parameters;
  case pData of
    ParamCCOType: pString := IntToStr(P.CCOType);
    ParamPassword: pString := IntToStr(P.Password);
    ParamEncoding: pString := IntToStr(P.Encoding);
    ParamPortNumber: pString := IntToStr(P.PortNumber);
    ParamBaudRate: pString := IntToStr(P.BaudRate);
    ParamByteTimeout: pString := IntToStr(P.ByteTimeout);
    ParamCommandTimeout: pString := IntToStr(P.CommandTimeout);
    ParamMaxRetryCount: pString := IntToStr(P.MaxRetryCount);
    ParamSearchByPortEnabled: pString := BoolToStr(P.SearchByPortEnabled);
    ParamSearchByBaudRateEnabled: pString := BoolToStr(P.SearchByBaudRateEnabled);
    ParamLogFileEnabled: pString := BoolToStr(P.LogFileEnabled);
    ParamLogMaxCount: pString := IntToStr(P.LogMaxCount);
    ParamCapPrice: pString := BoolToStr(P.CapPrice);
    ParamPollPeriod: pString := IntToStr(P.PollPeriod);
  end;
end;

end.
