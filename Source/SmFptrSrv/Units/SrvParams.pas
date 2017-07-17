unit SrvParams;

interface

uses
  // VCL
  Windows, SysUtils, Registry,
  // This
  LogFile;

type
  { TSrvParams }

  TSrvParams = class
  private
    FLogger: ILogFile;
    FTCPPort: Integer; 				    // TCP port number
    FTCPEnabled: Boolean; 			  // TCP connection enabled
    FAutoPortClose: Boolean;	    // Close port on timeout
    FAutoRecCancel: Boolean;		  // Cancel receipt on timeout
    FPortCloseTimeout: Integer;   // Port close timeout
  public
    constructor Create(ALogger: ILogFile);

    procedure LoadParams;
    procedure SetDefaults;
    procedure SaveParams;

    property Logger: ILogFile read FLogger;
    property TCPPort: Integer read FTCPPort write FTCPPort;
    property TCPEnabled: Boolean read FTCPEnabled write FTCPEnabled;
    property AutoPortClose: Boolean read FAutoPortClose write FAutoPortClose;
    property AutoRecCancel: Boolean read FAutoRecCancel write FAutoRecCancel;
    property PortCloseTimeout: Integer read FPortCloseTimeout write FPortCloseTimeout;
  end;

function Params: TSrvParams;

implementation

var
  FParams: TSrvParams;

function Params: TSrvParams;
begin
  if FParams = nil then
    FParams := TSrvParams.Create(nil);
  Result := FParams;
end;

const
  RegRootKey                = HKEY_CURRENT_USER;
  REGSTR_KEY_ROOT           = '\SOFTWARE\ShtrihM\OposDrv';
  REGSTR_KEY_PARAMS 		    = REGSTR_KEY_ROOT + '\SmFptrSrv';
  REGSTR_VAL_TCPPORT        = 'TCPPort';
  REGSTR_VAL_TCPENABLED     = 'TCPEnabled';
  REGSTR_VAL_AUTORECCANCEL  = 'AutoRecCancel';
  REGSTR_VAL_AUTOPORTCLOSE  = 'AutoPortClose';
  REGSTR_VAL_CLOSETIMEOUT   = 'CloseTimeout';

{ TSrvParams }

constructor TSrvParams.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
end;

procedure TSrvParams.SetDefaults;
begin
  FTCPPort := 211;
  FTCPEnabled := False;
  FAutoRecCancel := False;
  FAutoPortClose := False;
  FPortCloseTimeout := 30;
end;

procedure TSrvParams.SaveParams;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RegRootKey;
    if Reg.OpenKey(REGSTR_KEY_PARAMS, True) then
    begin
      // port parameters
      Reg.WriteBool(REGSTR_VAL_AUTORECCANCEL, FAutoRecCancel);
      Reg.WriteBool(REGSTR_VAL_AUTOPORTCLOSE, FAutoPortClose);
      Reg.WriteInteger(REGSTR_VAL_CLOSETIMEOUT, FPortCloseTimeout);
      // TCP parameters
      Reg.WriteInteger(REGSTR_VAL_TCPPORT, FTCPPort);
      Reg.WriteBool(REGSTR_VAL_TCPENABLED, FTCPEnabled);
    end;
  except
    on E: Exception do
      //Logger.Error('SaveParams', E);
  end;
  Reg.Free;
end;

procedure TSrvParams.LoadParams;
var
  Reg: TRegistry;
begin
  SetDefaults;
  Reg := TRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := RegRootKey;
    if Reg.OpenKey(REGSTR_KEY_PARAMS, False) then
    begin
      // port parameters
      if Reg.ValueExists(REGSTR_VAL_AUTORECCANCEL) then
        FAutoRecCancel := Reg.ReadBool(REGSTR_VAL_AUTORECCANCEL);

      if Reg.ValueExists(REGSTR_VAL_AUTOPORTCLOSE) then
        FAutoPortClose := Reg.ReadBool(REGSTR_VAL_AUTOPORTCLOSE);

      if Reg.ValueExists(REGSTR_VAL_CLOSETIMEOUT) then
        FPortCloseTimeout := Reg.ReadInteger(REGSTR_VAL_CLOSETIMEOUT);

      // TCP parameters
      if Reg.ValueExists(REGSTR_VAL_TCPENABLED) then
        FTCPEnabled := Reg.ReadBool(REGSTR_VAL_TCPENABLED);

      if Reg.ValueExists(REGSTR_VAL_TCPPORT) then
        FTCPPort := Reg.ReadInteger(REGSTR_VAL_TCPPORT);
    end;
  except
    on E: Exception do
      //Logger.Error('LoadParams', E);
  end;
  Reg.Free;
end;

initialization

finalization
  FParams.Free;
  FParams := nil;


end.

