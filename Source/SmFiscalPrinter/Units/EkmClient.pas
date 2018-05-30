unit EkmClient;

interface

uses
  // VCL
  Windows, SysUtils,
  // Tnt
  TntSysUtils,
  // Indy
  IdTcpClient, IdGlobal,
  // This
  LogFile, StringUtils, DriverError;

const
  /////////////////////////////////////////////////////////////////////////////
  // EKM server error codes

  EKMSRV_OK                   = 0;
  EKMSRV_UNSUPPORTED_TYPE     = 1;
  EKMSRV_UNSUPPORTED_VERSION  = 2;
  EKMSRV_GENERIC_ERROR        = 3;
  EKMSRV_NOT_IMPLEMENTED      =  $FFFFFFFE;

  /////////////////////////////////////////////////////////////////////////////
  //
  E_UNKNOWN                   = 200;
  E_KMSRV_GENERIC_ERROR       = 201; // Сервер ЭКМ, общая ошибка
  E_KMSRV_NOT_IMPLEMENTED     = 202; // Сервер ЭКМ, не реализовано
  E_KMSRV_UNSUPPORTED_TYPE    = 203; // Сервер ЭКМ, неподдерживаемый тип
  E_KMSRV_UNSUPPORTED_VERSION = 204; // Сервер ЭКМ, неподдерживаемая версия
  E_SALE_NOT_ENABLED          = 205; // Продажа запрещена
  E_TAG_NOT_FOUND             = 206; // Не найден обязательный тег


const
  SEKMSRV_GENERIC_ERROR       = 'Общая ошибка';
  SEKMSRV_NOT_IMPLEMENTED     = 'Не реализовано';
  SEKMSRV_UNSUPPORTED_TYPE    = 'Неподдерживаемый тип';
  SEKMSRV_UNSUPPORTED_VERSION = 'Неподдерживаемая версия';
  SEKMSRV_UNKNOWN_ERROR       = 'Неизвестная ошибка';

type
  { TEkmServerRequest }

  TEkmServerRequest = record
    Magic: string[4];
    Version: string[4];
    Context: Int64;
    Reserved: Int64;
    MessageSize: Word;
    Message: AnsiString;
  end;

  { TEkmServerResponse }

  TEkmServerResponse = record
    Magic: string[4];
    Version: string[4];
    Context: Int64;
    Status: DWORD;
    SaleEnabled: Byte;
    Reserved: Byte;
    MessageSize: Word;
    Message: AnsiString;
  end;

  { TEkmClient }

  TEkmClient = class
  public
    Host: AnsiString;
    Port: Integer;
    Timeout: Integer;
  public
    constructor Create;
    function ReadSaleEnabled(const GTIN, Serial: AnsiString): Boolean;
  end;

function StrToIdBytes(const Data: AnsiString): TIdBytes;
function IdBytesToStr(const Data: TIdBytes): AnsiString;

implementation

function StrToIdBytes(const Data: AnsiString): TIdBytes;
var
  i: Integer;
begin
  SetLength(Result, Length(Data));
  for i := 1 to Length(Data) do
    Result[i-1] := Ord(Data[i]);
end;

function IdBytesToStr(const Data: TIdBytes): AnsiString;
var
  i: Integer;
begin
  SetLength(Result, Length(Data));
  for i := 1 to Length(Data) do
    Result[i] := Chr(Data[i-1]);
end;

{ TEkmServer }

constructor TEkmClient.Create;
begin
  inherited Create;
  Host := '80.243.2.202';
  Port := 2003;
  Timeout := 5;
end;

function TEkmClient.ReadSaleEnabled(const GTIN, Serial: AnsiString): Boolean;
var
  TxData: AnsiString;
  RxData: AnsiString;
  Buffer: TIdBytes;
  Connection: TIdTcpClient;
  Request: TEkmServerRequest;
  Response: TEkmServerResponse;
begin
  Result := False;
  Connection := TIdTcpClient.Create(nil);
  try
    Connection.Host := Host;
    Connection.Port := Port;
    Connection.ConnectTimeout := Timeout * 1000;
    Connection.ReadTimeout := Timeout * 1000;
    Connection.Connect;

    FillChar(Request, Sizeof(Request), 0);
    Request.Magic := 'CHRQ';
    Request.Version := #0#0#0#1;
    Request.Context := 0;
    Request.Message := Tnt_WideFormat('(01)%s(21)%s'#0, [GTIN, Serial]);
    Request.MessageSize := Length(Request.Message);

    TxData :=
      Request.Magic + Request.Version +
      IntToBin(Request.Context, 8) +
      IntToBin(Request.Reserved, 6) +
      IntToBin(Request.MessageSize, 2) +
      Request.Message + StringOfChar(#0, 256-Length(Request.Message));

    Connection.Socket.Write(StrToIdBytes(TxData));
    Connection.Socket.ReadBytes(Buffer, 24, False);
    RxData := IdBytesToStr(Buffer);

    Response.Magic := Copy(RxData, 1, 4);
    Response.Version := Copy(RxData, 5, 4);
    Response.Context := BinToInt(RxData, 9, 8);
    Response.Status := BinToInt(RxData, 17, 4);
    Response.SaleEnabled := BinToInt(RxData, 21, 1);
    Response.Reserved := BinToInt(RxData, 22, 1);
    Response.MessageSize := BinToInt(RxData, 23, 2);

    SetLength(Buffer, 0);
    Connection.Socket.ReadBytes(Buffer, Response.MessageSize-1, False);
    RxData := IdBytesToStr(Buffer);
    Response.Message := RxData;

    if Uppercase(Response.Magic) = 'PERR' then
    begin
      case Response.Status of
        EKMSRV_GENERIC_ERROR:
          raiseError(E_KMSRV_GENERIC_ERROR, Tnt_WideFormat('%s %s', ['EKMSRV:' + SEKMSRV_GENERIC_ERROR]));
        EKMSRV_NOT_IMPLEMENTED:
          raiseError(E_KMSRV_NOT_IMPLEMENTED, Tnt_WideFormat('%s %s', ['EKMSRV: ' + SEKMSRV_NOT_IMPLEMENTED]));
        EKMSRV_UNSUPPORTED_TYPE:
          raiseError(E_KMSRV_UNSUPPORTED_TYPE, Tnt_WideFormat('%s %s', ['EKMSRV: ' + SEKMSRV_UNSUPPORTED_TYPE]));
        EKMSRV_UNSUPPORTED_VERSION:
          raiseError(E_KMSRV_UNSUPPORTED_VERSION, Tnt_WideFormat('%s %s', ['EKMSRV: ' + SEKMSRV_UNSUPPORTED_VERSION]))
      else
        raiseError(E_UNKNOWN, Tnt_WideFormat('EKMSRV: %d, %d', [Response.Status,
          SEKMSRV_UNKNOWN_ERROR]));
      end;
    end;

    if Uppercase(Response.Magic) = Request.Magic then
    begin
      Result := Response.SaleEnabled = 0;
    end;
  finally
    Connection.Free;
  end;
end;

end.
