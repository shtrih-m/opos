unit DriverError;

interface

uses
  // VCL
  SysUtils;

type
  { EDriverError }

  EDriverError = class(Exception)
  private
   FErrorCode: Integer;
  public
    property ErrorCode: Integer read fErrorCode;
    constructor Create2(Code: Integer; const Msg: string);
  end;

const
  // ECR errors are used in driver
  E_ECR_FMOVERFLOW    = $14; // FM day totals area overflow
  E_ECR_PASSWORD      = $4F; // Incorrect password

  // Driver error codes
  E_NOERROR           =  0;
  E_NOHARDWARE        = -1;     // Not connected
  E_NOPORT            = -2;     // COM port is not available
  E_PORTBUSY          = -3;     // COM port is busy by another application
  E_ANSWERLENGTH      = -7;     // Incorrect answer length
  E_UNKNOWN           = -8;
  E_INVALIDPARAM      = -9;     // Parameter is out of range
  E_NOTSUPPORTED      = -12;    // Not supported in current driver version
  E_NOTLOADED         = -16;    // Unable to connect to server
  E_PORTLOCKED        = -18;    // Port is blocked
  E_REMOTECONNECTION  = -19;    // Remote connection is not permissed

  E_USERBREAK	      = -30;      // Break by user
  E_MP_SALEERROR      = -31;    // Payment succesful
  E_MP_CHECKOPENED    = -32;    // Receipt is opened. Payment is impossible
  E_MP_PAYERROR       = -33;
  E_NOPAPER           = -34;    // No paper
  E_RESET             = -35;    // Reset failure

resourcestring
  S_NOERROR             = 'No error';
  S_NOHARDWARE	        = 'No connection';
  S_NOPORT              = 'COM port is not available';
  S_PORTBUSY            = 'COM is busy by another application';
  S_NOTLOADED           = 'Connection error';
  S_USERBREAK           = 'Break by user';
  S_ANSWERLENGTH        = 'Incorrect answer length';
  S_NOTSUPPORTED        = 'Not supported in current driver version';
  S_UNKNOWN		          = 'Unknown error';
  S_REMOTECONNECTION    = 'Remote connection is not permissed';
  S_MP_SALEERROR        = 'Sale operation succesful';
  S_MP_CHECKOPENED      = 'Receipt is opened. Payment is impossible';
  S_RESET               = 'ECR reset failure';

function DRV_SUCCESS(Value: Integer): Boolean;
procedure RaiseError(Code: Integer; const Message: string);

implementation

function DRV_SUCCESS(Value: Integer): Boolean;
begin
  Result := Value = E_NOERROR;
end;

{ EDriverError }

constructor EDriverError.Create2(Code: Integer; const Msg: string);
begin
  inherited Create(Msg);
  FErrorCode := Code;
end;

procedure RaiseError(Code: Integer; const Message: string);
begin
  raise EDriverError.Create2(Code, Message);
end;

end.
