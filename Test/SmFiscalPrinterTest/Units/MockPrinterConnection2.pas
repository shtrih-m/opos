unit MockPrinterConnection2;

interface

uses
  // VCL
  Classes,
  // Mock
  PascalMock,
  // This
  PrinterConnection, StringUtils;

type
  { TMockPrinterConnection2 }

  TMockPrinterConnection2 = class(TMock, IPrinterConnection)
  public
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    procedure ReleaseDevice;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
    procedure ClosePort;
    procedure OpenReceipt(Password: Integer);
    procedure CloseReceipt;
    function Send(Timeout: Integer; const Data: string): string;
  end;

implementation

{ TMockPrinterConnection2 }

procedure TMockPrinterConnection2.ClaimDevice(PortNumber, Timeout: Integer);
begin
  AddCall('ClaimDevice').WithParams([PortNumber, Timeout]);
end;

procedure TMockPrinterConnection2.ClosePort;
begin
  AddCall('ClosePort');
end;

procedure TMockPrinterConnection2.CloseReceipt;
begin
  AddCall('CloseReceipt');
end;

procedure TMockPrinterConnection2.OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
begin
  AddCall('OpenPort').WithParams([PortNumber, BaudRate, ByteTimeout]);
end;

procedure TMockPrinterConnection2.OpenReceipt(Password: Integer);
begin
  AddCall('OpenReceipt').WithParams([Password]);
end;

procedure TMockPrinterConnection2.ReleaseDevice;
begin
  AddCall('ReleaseDevice');
end;

function TMockPrinterConnection2.Send(Timeout: Integer; const Data: string): string;
begin
  Result := AddCall('Send').WithParams([Timeout, StrToHex(Data)]).ReturnValue;
  Result := HexToStr(Result);
end;

end.

