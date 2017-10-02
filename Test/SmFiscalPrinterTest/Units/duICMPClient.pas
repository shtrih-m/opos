unit duICMPClient;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // Indy
  idICMPClient,
  // This
  ByteUtils;

type
  { TICMPClientTest }

  TICMPClientTest = class(TTestCase)
  published
    procedure CheckPing;
  end;

implementation

{ TICMPClientTest }

procedure TICMPClientTest.CheckPing;
var
  TickCount: Integer;
  Client: TidICMPClient;
begin
  Client := TidICMPClient.Create;
  try
    Client.Host := '127.0.0.1';
    TickCount := GetTickCount;
    Client.Ping();
    TickCount := Integer(GetTickCount) - TickCount;
    Check(TickCount < 100, 'TickCount >= 100 ms');
  finally
    Client.Free;
  end;
end;

initialization
  RegisterTest('', TICMPClientTest.Suite);

end.
