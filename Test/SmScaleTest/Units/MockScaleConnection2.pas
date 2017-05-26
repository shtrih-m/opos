unit MockScaleConnection2;

interface

uses
  // This
  ScaleTypes, SerialPort;

type
  { TMockscaleConnection2 }

  TMockscaleConnection2 = class(TInterfacedObject, IScaleConnection)
  public
    TxData: string;
    RxData: string;
    CommandTimeout: Integer;
    OpenPortFailed: Boolean;
    // IScaleConnection
    procedure ClosePort;
    procedure ReleaseDevice;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    function Send(Timeout: Integer; const Data: string): string;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
  end;

implementation

{ TMockscaleConnection2 }

procedure TMockscaleConnection2.ClosePort;
begin

end;

procedure TMockscaleConnection2.OpenPort(PortNumber, BaudRate,
  ByteTimeout: Integer);
begin
  if OpenPortFailed then
    raise ENoPortError.Create('Cannot open port');
end;

procedure TMockscaleConnection2.ClaimDevice(PortNumber, Timeout: Integer);
begin

end;

procedure TMockscaleConnection2.ReleaseDevice;
begin

end;

function TMockscaleConnection2.Send(Timeout: Integer;
  const Data: string): string;
begin
  CommandTimeout := Timeout;
  TxData := Data;
  Result := RxData;
end;

end.
