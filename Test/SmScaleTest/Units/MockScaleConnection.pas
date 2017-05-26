unit MockScaleConnection;

interface

uses
  // Shared
  PascalMock,
  // This
  ScaleTypes, SerialPort;

type
  { TMockscaleConnection }

  TMockscaleConnection = class(TMock, IScaleConnection)
  public
    procedure ClosePort;
    procedure ReleaseDevice;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    function Send(Timeout: Integer; const Data: string): string;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
  end;

implementation

{ TMockscaleConnection }

procedure TMockscaleConnection.ClosePort;
begin
  AddCall('ClosePort');
end;

procedure TMockscaleConnection.OpenPort(PortNumber, BaudRate,
  ByteTimeout: Integer);
begin
  AddCall('OpenPort').WithParams([PortNumber, BaudRate, ByteTimeout]);
end;

procedure TMockscaleConnection.ClaimDevice(PortNumber, Timeout: Integer);
begin
  AddCall('ClaimDevice').WithParams([PortNumber, Timeout]);
end;

procedure TMockscaleConnection.ReleaseDevice;
begin
  AddCall('ReleaseDevice');
end;

function TMockscaleConnection.Send(Timeout: Integer;
  const Data: string): string;
begin
  Result := AddCall('Send').WithParams([Timeout, Data]).ReturnValue;
end;

end.
