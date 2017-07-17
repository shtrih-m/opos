unit duLocalConnection;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  PrinterConnection, LocalConnection, LogFile;

type
  { TduLocalConnection }

  TduLocalConnection = class(TTestCase)
  private
    FLogger: ILogFile;
    FConnection: IPrinterConnection;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  public
    procedure CheckOpen;
    procedure CheckClose;
    procedure CheckClosePort;
    procedure CheckReleaseDevice;
    procedure CheckClaimDevice;
    procedure CheckSend;
    procedure CheckOpenPort;
    procedure CheckOpenReceipt;
    procedure CheckCloseReceipt;
  end;

implementation

{ TduLocalConnection }

procedure TduLocalConnection.Setup;
begin
  FLogger := TLogFile.Create;
  FConnection := TLocalConnection.Create(FLogger);
end;

procedure TduLocalConnection.TearDown;
begin
  FLogger := nil;
  FConnection := nil;
end;

procedure TduLocalConnection.CheckClaimDevice;
begin
  FConnection.ClaimDevice(1, 0);
end;

procedure TduLocalConnection.CheckClose;
begin

end;

procedure TduLocalConnection.CheckClosePort;
begin

end;

procedure TduLocalConnection.CheckCloseReceipt;
begin

end;

procedure TduLocalConnection.CheckOpen;
begin

end;

procedure TduLocalConnection.CheckOpenPort;
begin

end;

procedure TduLocalConnection.CheckOpenReceipt;
begin

end;

procedure TduLocalConnection.CheckReleaseDevice;
begin

end;

procedure TduLocalConnection.CheckSend;
begin

end;

end.
