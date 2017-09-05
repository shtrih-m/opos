unit OPOSException;

interface

uses
  // VCL
  SysUtils,
  // This
  OPOS, OPOShi;

type
  { TOPOSError }
  
  TOPOSError = record
    ResultCode: Integer;
    ResultCodeExtended: Integer;
    ErrorString: string;
  end;

  { EOPOSException }

  EOPOSException = class(Exception)
  private
    FResultCode: Integer;
    FResultCodeExtended: Integer;
  public
    constructor Create(const AMessage: string;
      AResultCode, AResultCodeExtended: Integer);

    class function GetResultCodeText(Value: Integer): string;

    property ResultCode: Integer read FResultCode;
    property ResultCodeExtended: Integer read FResultCodeExtended;
  end;

  { EOPOSDeviceException }

  EOPOSDeviceException = class(Exception)
  private
    FResultCode: Integer;
    FResultCodeExtended: Integer;
    FDeviceErrorCode: Integer;
  public
    constructor Create(const AMessage: string;
      AResultCode, AResultCodeExtended, ADeviceErrorCode: Integer);

    class function GetResultCodeText(Value: Integer): string;

    property ResultCode: Integer read FResultCode;
    property DeviceErrorCode: Integer read FDeviceErrorCode;
    property ResultCodeExtended: Integer read FResultCodeExtended;
  end;

procedure RaiseIllegalError; overload;
procedure RaiseIllegalError(const AMessage: string); overload;
procedure RaiseOPOSException(AResultCode: Integer); overload;
procedure RaiseExtendedError(AResultCodeExtended: Integer); overload;

procedure RaiseOPOSException(
  AResultCode: Integer;
  const AMessage: string); overload;

procedure RaiseOPOSException(
  AResultCode, AResultCodeExtended: Integer;
  const AMessage: string); overload;


procedure RaiseExtendedError(
  AResultCodeExtended: Integer;
  const AMessage: string); overload;

procedure InvalidPropertyValue(const PropName, PropValue: string);
procedure InvalidParameterValue(const ParamName, ParamValue: string);

resourcestring
  MsgInvalidParameterValue = 'Invalid parameter value';
  MsgInvalidPropertyValue = 'Invalid property value';

implementation

procedure InvalidParameterValue(const ParamName, ParamValue: string);
begin
  RaiseOposException(OPOS_E_ILLEGAL, Format('%s, %s=''%s''',
    [MsgInvalidParameterValue, ParamName]));
end;

procedure InvalidPropertyValue(const PropName, PropValue: string);
begin
  RaiseOposException(OPOS_E_ILLEGAL, Format('%s, %s=''%s''',
    [MsgInvalidPropertyValue, PropName, PropValue]));
end;

procedure RaiseOPOSException(AResultCode, AResultCodeExtended: Integer;
  const AMessage: string); overload;
begin
  raise EOPOSException.Create(AMessage, AResultCode, AResultCodeExtended);
end;

procedure RaiseOPOSException(AResultCode: Integer;
  const AMessage: string); overload;
begin
  RaiseOPOSException(AResultCode, OPOS_SUCCESS, AMessage);
end;

procedure RaiseExtendedError(AResultCodeExtended: Integer;
  const AMessage: string); overload;
begin
  RaiseOPOSException(OPOS_E_EXTENDED, AResultCodeExtended, AMessage);
end;

procedure RaiseOPOSException(AResultCode: Integer); overload;
begin
  RaiseOPOSException(AResultCode, OPOS_SUCCESS,
    EOPOSException.GetResultCodeText(AResultCode));
end;

procedure raiseExtendedError(AResultCodeExtended: Integer); overload;
begin
  RaiseOPOSException(OPOS_E_EXTENDED, AResultCodeExtended,
    '');
end;

procedure RaiseIllegalError(const AMessage: string); overload;
begin
  RaiseOposException(OPOS_E_ILLEGAL, AMessage);
end;

procedure RaiseIllegalError; overload;
begin
  RaiseOposException(OPOS_E_ILLEGAL);
end;

{ EOPOSExtendedError }

constructor EOPOSException.Create(const AMessage: string;
  AResultCode, AResultCodeExtended: Integer);
begin
  inherited Create(AMessage);
  FResultCode := AResultCode;
  FResultCodeExtended := AResultCodeExtended;
end;

class function EOPOSException.GetResultCodeText(Value: Integer): string;
begin
  case Value of
    OPOS_SUCCESS          : Result := 'OPOS_SUCCESS';
    OPOS_E_CLOSED         : Result := 'OPOS_E_CLOSED';
    OPOS_E_CLAIMED        : Result := 'OPOS_E_CLAIMED';
    OPOS_E_NOTCLAIMED     : Result := 'OPOS_E_NOTCLAIMED';
    OPOS_E_NOSERVICE      : Result := 'OPOS_E_NOSERVICE';
    OPOS_E_DISABLED       : Result := 'OPOS_E_DISABLED';
    OPOS_E_ILLEGAL        : Result := 'OPOS_E_ILLEGAL';
    OPOS_E_NOHARDWARE     : Result := 'OPOS_E_NOHARDWARE';
    OPOS_E_OFFLINE        : Result := 'OPOS_E_OFFLINE';
    OPOS_E_NOEXIST        : Result := 'OPOS_E_NOEXIST';
    OPOS_E_EXISTS         : Result := 'OPOS_E_EXISTS';
    OPOS_E_FAILURE        : Result := 'OPOS_E_FAILURE';
    OPOS_E_TIMEOUT        : Result := 'OPOS_E_TIMEOUT';
    OPOS_E_BUSY           : Result := 'OPOS_E_BUSY';
    OPOS_E_EXTENDED       : Result := 'OPOS_E_EXTENDED';
    OPOS_OR_ALREADYOPEN   : Result := 'OPOS_OR_ALREADYOPEN';
    OPOS_OR_REGBADNAME    : Result := 'OPOS_OR_REGBADNAME';
    OPOS_OR_REGPROGID     : Result := 'OPOS_OR_REGPROGID';
    OPOS_OR_CREATE        : Result := 'OPOS_OR_CREATE';
    OPOS_OR_BADIF         : Result := 'OPOS_OR_BADIF';
    OPOS_OR_FAILEDOPEN    : Result := 'OPOS_OR_FAILEDOPEN';
    OPOS_OR_BADVERSION    : Result := 'OPOS_OR_BADVERSION';
    OPOS_ORS_NOPORT       : Result := 'OPOS_ORS_NOPORT';
    OPOS_ORS_NOTSUPPORTED : Result := 'OPOS_ORS_NOTSUPPORTED';
    OPOS_ORS_CONFIG       : Result := 'OPOS_ORS_CONFIG';
    OPOS_ORS_SPECIFIC     : Result := 'OPOS_ORS_SPECIFIC';
  else
    Result := 'Unknown error';
  end;
end;

{ EOPOSDeviceException }

constructor EOPOSDeviceException.Create(const AMessage: string;
  AResultCode, AResultCodeExtended, ADeviceErrorCode: Integer);
begin
  inherited Create(AMessage);
  FResultCode := AResultCode;
  FDeviceErrorCode := ADeviceErrorCode;
  FResultCodeExtended := AResultCodeExtended;
end;

class function EOPOSDeviceException.GetResultCodeText(
  Value: Integer): string;
begin
  Result := EOPOSException.GetResultCodeText(Value);
end;

end.
