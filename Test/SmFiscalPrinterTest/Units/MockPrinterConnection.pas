unit MockPrinterConnection;

interface

uses
  PrinterConnection;

type
  { TMockPrinterConnection }

  TMockPrinterConnection = class(TInterfacedObject, IPrinterConnection)
  private
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    procedure ReleaseDevice;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
    procedure ClosePort;
    procedure OpenReceipt(Password: Integer);
    procedure CloseReceipt;
    function Send(Timeout: Integer; const Data: string): string;
  end;

implementation

{ TMockPrinterConnection }

procedure TMockPrinterConnection.ClaimDevice(PortNumber, Timeout: Integer);
begin

end;

procedure TMockPrinterConnection.ClosePort;
begin

end;

procedure TMockPrinterConnection.CloseReceipt;
begin

end;

procedure TMockPrinterConnection.OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
begin

end;

procedure TMockPrinterConnection.OpenReceipt(Password: Integer);
begin

end;

procedure TMockPrinterConnection.ReleaseDevice;
begin

end;

function TMockPrinterConnection.Send(Timeout: Integer; const Data: string): string;
begin
  Result := '';
end;

end.

