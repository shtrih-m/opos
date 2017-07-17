unit duSerialPort;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  SerialPort, LogFile;

type
  { TduSerialPort }

  TduSerialPort = class(TTestCase)
  public
    procedure CheckTimeout2;
    procedure CheckTimeout;
  end;

implementation

{ TduSerialPort }

procedure TduSerialPort.CheckTimeout;
var
  C: Char;
  Port: TSerialPort;
  TickCount: Integer;
  Logger: ILogFile;
const
  TickStep = 20;
begin
  Logger := TLogFile.Create;
  Port := TSerialPort.Create(Logger);
  try
    Port.PortNumber := 2;
    Port.BaudRate := CBR_115200;
    Port.Timeout := 0;
    Port.Open;
    Port.SetCmdTimeout(10000);
    TickCount := GetTickCount;
    CheckEquals(False, Port.ReadChar(C));
    TickCount := Integer(GetTickCount) - TickCount;
    Check((TickCount + TickStep) >= 100);
  finally
    Port.Free;
    Logger := nil;
  end;
end;

procedure TduSerialPort.CheckTimeout2;
var
  i: Integer;
begin
  for i := 1 to 100 do
  begin
    CheckTimeout;
  end;
end;

initialization
  RegisterTest('', TduSerialPort.Suite);

end.
