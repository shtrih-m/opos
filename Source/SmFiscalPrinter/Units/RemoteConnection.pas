unit RemoteConnection;

interface

uses
  // VCL
  Windows, Messages, MConnect, ComObj, SysUtils, {$IFDEF VER150} Variants, {$ENDIF}
  SConnect,
  // This
  PrinterConnection, FptrServerLib_TLB, SysPrinterParameters;

type
  { TDCOMConnection }

  TDCOMConnection = class(TInterfacedObject, IPrinterConnection)
  private
    FDriver: IFptrServer;

    procedure Connect;
    procedure Disconnect;
    function Connected: Boolean;
    function GetDriver: IFptrServer;

    property Driver: IFptrServer read GetDriver;
  public
    destructor Destroy; override;

    procedure Open(Params: TSysPrinterParameters);
    procedure Close;
    procedure ClosePort;
    procedure ReleaseDevice;
    procedure CloseReceipt;
    procedure ClaimDevice(Timeout: Integer);
    procedure OpenReceipt(Password: Integer);
    function Send(Timeout: Integer; const Data: string): string;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
  end;

implementation

{ TDCOMConnection }

destructor TDCOMConnection.Destroy;
begin
  Disconnect;
  inherited Destroy;
end;

function TDCOMConnection.Connected: Boolean;
begin
  Result := not VarIsEmpty(FDriver);
end;

procedure TDCOMConnection.Connect;
begin
(*
  if ComputerName = '' then FDriver := CoFptrServer.Create
  else FDriver := CoFptrServer.CreateRemote(ComputerName);
*)
end;

procedure TDCOMConnection.Disconnect;
begin
  FDriver := nil;
end;

function TDCOMConnection.GetDriver: IFptrServer;
begin
  if not Connected then Connect;
  Result := FDriver;
end;

procedure TDCOMConnection.ClaimDevice(Timeout: Integer);
begin

end;

procedure TDCOMConnection.Close;
begin

end;

procedure TDCOMConnection.ClosePort;
begin

end;

procedure TDCOMConnection.CloseReceipt;
begin

end;

procedure TDCOMConnection.Open(Params: TSysPrinterParameters);
begin

end;

procedure TDCOMConnection.OpenPort(PortNumber, BaudRate,
  ByteTimeout: Integer);
begin

end;

procedure TDCOMConnection.OpenReceipt(Password: Integer);
begin

end;

procedure TDCOMConnection.ReleaseDevice;
begin

end;

function TDCOMConnection.Send(Timeout: Integer;
  const Data: string): string;
begin

end;

(*

  Check(Driver.LockPort(PortNumber));
  PortLocked := True;

  Check(Driver.UnlockPort);
  PortLocked := False;

  procedure TTCPConnection.AdminUnlockPort(ComNumber: Integer);
begin
  Check(Driver.AdminUnlockPort(ComNumber));
  PortLocked := False;
end;

procedure TTCPConnection.AdminUnlockPorts;
begin
  Check(Driver.AdminUnlockPorts);
  PortLocked := False;
end;



*)

end.
