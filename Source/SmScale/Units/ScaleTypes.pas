unit ScaleTypes;

interface

type
  { IScaleConnection }

  IScaleConnection = interface
  ['{67A0D852-4A9D-4E30-8DC2-7A1E6ED23C86}']
    procedure ClosePort;
    procedure ReleaseDevice;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    function Send(Timeout: Integer; const Data: AnsiString): AnsiString;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
  end;

const
  EncodingWindows       = 0;
  Encoding866           = 1;

function BaudRateToInt(Value: Integer): Integer;
function IntToBaudRate(Value: Integer): Integer;

implementation

function BaudRateToInt(Value: Integer): Integer;
begin
  case Value of
    2400   : Result := 0;
    4800   : Result := 1;
    9600   : Result := 2;
    19200  : Result := 3;
    38400  : Result := 4;
    57600  : Result := 5;
    115200 : Result := 6;
  else
    Result := 1;
  end;
end;

function IntToBaudRate(Value: Integer): Integer;
begin
  case Value of
    0: Result := 2400;
    1: Result := 4800;
    2: Result := 9600;
    3: Result := 19200;
    4: Result := 38400;
    5: Result := 57600;
    6: Result := 115200;
  else
    Result := 1;
  end;
end;

end.
