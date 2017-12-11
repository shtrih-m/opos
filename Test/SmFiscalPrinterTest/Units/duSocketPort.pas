unit duSocketPort;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  SocketPort, LogFile, PrinterParameters;

type
  { TSocketPortTest }

  TSocketPortTest = class(TTestCase)
  public
    procedure CheckOpen;
  published
  end;

implementation

{ TSocketPortTest }

procedure TSocketPortTest.CheckOpen;
var
  Logger: TLogFile;
  Port: TSocketPort;
  Parameters: TPrinterParameters;
begin
  Logger := TLogFile.Create;
  Parameters := TPrinterParameters.Create(Logger);
  Port := TSocketPort.Create(Parameters, Logger);
  try
    Parameters.RemoteHost := 'http://www.shtrih-m.ru';
    Parameters.RemotePort := 80;
    Port.Open;
  finally
    Parameters.Free;
  end;
end;

initialization
  RegisterTest('', TSocketPortTest.Suite);

end.
