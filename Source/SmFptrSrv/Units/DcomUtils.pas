unit DcomUtils;

interface

uses
  // VCL
  Windows, ActiveX, ComObj, Registry, SysConst, SysUtils;

const
  // begin_ntddk begin_ntifs
  // This is the *current* ACL revision

  ACL_REVISION     = 2;
  ACL_REVISION_DS  = 4;

  // This is the history of ACL revisions.  Add a new one whenever
  // ACL_REVISION is updated

  ACL_REVISION1    = 1;
  ACL_REVISION2    = 2;
  ACL_REVISION3    = 3;
  ACL_REVISION4    = 4;
  MIN_ACL_REVISION = ACL_REVISION2;
  MAX_ACL_REVISION = ACL_REVISION4;

  //  The following are the predefined ace types that go into the AceType
  //  field of an Ace header.

  ACCESS_MIN_MS_ACE_TYPE              = $0;
  ACCESS_ALLOWED_ACE_TYPE             = $0;
  ACCESS_DENIED_ACE_TYPE              = $1;
  SYSTEM_AUDIT_ACE_TYPE               = $2;
  SYSTEM_ALARM_ACE_TYPE               = $3;
  ACCESS_MAX_MS_V2_ACE_TYPE           = $3;

  ACCESS_ALLOWED_COMPOUND_ACE_TYPE    = $4;
  ACCESS_MAX_MS_V3_ACE_TYPE           = $4;

  ACCESS_MIN_MS_OBJECT_ACE_TYPE       = $5;
  ACCESS_ALLOWED_OBJECT_ACE_TYPE      = $5;
  ACCESS_DENIED_OBJECT_ACE_TYPE       = $6;
  SYSTEM_AUDIT_OBJECT_ACE_TYPE        = $7;
  SYSTEM_ALARM_OBJECT_ACE_TYPE        = $8;
  ACCESS_MAX_MS_OBJECT_ACE_TYPE       = $8;

  ACCESS_MAX_MS_V4_ACE_TYPE           = $8;
  ACCESS_MAX_MS_ACE_TYPE              = $8;

  // Current security descriptor revision value
  SECURITY_DESCRIPTOR_REVISION        = 1;
  SECURITY_DESCRIPTOR_REVISION1       = 1;

  RPC_C_AUTHN_NONE                 = 0;
  RPC_C_AUTHN_DCE_PRIVATE          = 1;
  RPC_C_AUTHN_DCE_PUBLIC           = 2;
  RPC_C_AUTHN_DEC_PUBLIC           = 4;
  RPC_C_AUTHN_GSS_NEGOTIATE        = 9;
  RPC_C_AUTHN_WINNT                = 10;
  RPC_C_AUTHN_GSS_KERBEROS         = 16;
  RPC_C_AUTHN_MSN                  = 17;
  RPC_C_AUTHN_DPA                  = 18;
  RPC_C_AUTHN_MQ                   = 100;
  RPC_C_AUTHN_DEFAULT              = $FFFFFFFF;

  // Legacy Authentication Level
  RPC_C_AUTHN_LEVEL_DEFAULT        = 0;
  RPC_C_AUTHN_LEVEL_NONE           = 1;
  RPC_C_AUTHN_LEVEL_CONNECT        = 2;
  RPC_C_AUTHN_LEVEL_CALL           = 3;
  RPC_C_AUTHN_LEVEL_PKT            = 4;
  RPC_C_AUTHN_LEVEL_PKT_INTEGRITY  = 5;
  RPC_C_AUTHN_LEVEL_PKT_PRIVACY    = 6;

  RPC_C_AUTHZ_NONE                 = 0;
  RPC_C_AUTHZ_NAME                 = 1;
  RPC_C_AUTHZ_DCE                  = 2;
  RPC_C_AUTHZ_DEFAULT              = $ffffffff;

  // Legacy Impersonation Level
  RPC_C_IMP_LEVEL_DEFAULT          = 0;
  RPC_C_IMP_LEVEL_ANONYMOUS        = 1;
  RPC_C_IMP_LEVEL_IDENTIFY         = 2;
  RPC_C_IMP_LEVEL_IMPERSONATE      = 3;
  RPC_C_IMP_LEVEL_DELEGATE         = 4;

  EOAC_NONE                        = $0;
  EOAC_DEFAULT                     = $800;
  EOAC_MUTUAL_AUTH                 = $1;
  EOAC_STATIC_CLOAKING             = $20;
  EOAC_DYNAMIC_CLOAKING            = $40;
  // These are only valid for CoInitializeSecurity
  EOAC_SECURE_REFS                 = $2;
  EOAC_ACCESS_CONTROL              = $4;
  EOAC_APPID                       = $8;
  EOAC_NO_CUSTOM_MARSHAL           = $2000;
  EOAC_DISABLE_AAA                 = $1000;

  // HKEY_CLASSES_ROOT
  REGSTR_KEY_APPID = 'AppID';
  REGSTR_KEY_CLSID = 'CLSID';

  // HKEY_LOCAL_MACHINE
  REGSTR_KEY_OLE = 'Software\Microsoft\OLE';
  REGSTR_KEY_LOCAL_APPID = 'Software\Classes\AppID';
  REGSTR_KEY_RPC = 'Software\Microsoft\Rpc';

  REGSTR_VAL_RUNAS = 'RunAs';
  REGSTR_VAL_ENABLEDCOM = 'EnableDCOM';
  REGSTR_VAL_ENABLEREMOTECONNECT = 'EnableRemoteConnect';
  REGSTR_VAL_DCOMPROTOCOLS = 'DCOM Protocols';
  REGSTR_VAL_APPID = 'AppID';
  REGSTR_VAL_LEGACYSECUREREFERENCES = 'LegacySecureReferences';
  REGSTR_VAL_LEGACYAUTHENTICATIONLEVEL = 'LegacyAuthenticationLevel';
  REGSTR_VAL_IMPERSONATIONLEVEL = 'LegacyImpersonationLevel';
  REGSTR_VAL_DEFAULTLAUNCHPERMISSION = 'DefaultLaunchPermission';
  REGSTR_VAL_DEFAULTACCESSPERMISSION = 'DefaultAccessPermission';
  REGSTR_VAL_ACCESSPERMISSION = 'AccessPermission';
  REGSTR_VAL_LAUNCHPERMISSION = 'LaunchPermission';

  YesNoToChar: array[Boolean] of Char = ('N', 'Y');
  InteractiveUserValue = 'Interactive User';

  STR_DCOM_DOWNLOAD = 'http://www.microsoft.com/com/resources/downloads.asp';
  STR_NO_DCOM       = 'DCOM support s not installed.'+
   ' To install DCOM support follow the link:'#13#10 +
  STR_DCOM_DOWNLOAD;

  STR_NO_DCOMPROTOCOL = 'There is no enabled DCOM protocols.'+
      ' To enable protocols run DCOMCNFG.EXE utility';


type
  {$ifdef ver100}
  PSIDAndAttributes = ^TSIDAndAttributes;
  _SID_AND_ATTRIBUTES = record
    Sid: PSID;
    Attributes: DWORD;
  end;
  TSIDAndAttributes = _SID_AND_ATTRIBUTES;
  SID_AND_ATTRIBUTES = _SID_AND_ATTRIBUTES;
  {$endif}

  { TTokenUser }

  _TOKEN_USER = record
    User: SID_AND_ATTRIBUTES;
  end;
  TTOKEN_USER = _TOKEN_USER;
  TTokenUser = TTOKEN_USER;
  PTokenUser = ^TTokenUser;

  { TAceHeader }

  _ACE_HEADER = record
    AceType: Byte;
    AceFlags: Byte;
    AceSize: WORD;
  end;
  ACE_HEADER = _ACE_HEADER;
  TAceHeader = ACE_HEADER;
  PAceHeader = ^TAceHeader;

  { TAccessAllowedAce }

  _ACCESS_ALLOWED_ACE = record
    Header: ACE_HEADER;
    Mask: ACCESS_MASK;
    SidStart: DWORD;
  end;
  ACCESS_ALLOWED_ACE = _ACCESS_ALLOWED_ACE;
  TAccessAllowedAce = ACCESS_ALLOWED_ACE;
  PAccessAllowedAce = ^TAccessAllowedAce;

  { TAccessDeniedAce }
  _ACCESS_DENIED_ACE = record
    Header: ACE_HEADER;
    Mask: ACCESS_MASK;
    SidStart: DWORD;
  end;
  ACCESS_DENIED_ACE = _ACCESS_DENIED_ACE;
  TAccessDeniedAce = ACCESS_DENIED_ACE;
  PAccessDeniedAce = ^TAccessDeniedAce;

  { TSystemAuditAce }

  _SYSTEM_AUDIT_ACE = record
    Header: ACE_HEADER;
    Mask: ACCESS_MASK;
    SidStart: DWORD;
  end;
  SYSTEM_AUDIT_ACE = _SYSTEM_AUDIT_ACE;
  TSystemAuditAce = SYSTEM_AUDIT_ACE;
  PSystemAuditAce = ^TSystemAuditAce;

  { TAclSizeInformation }

  _ACL_SIZE_INFORMATION = record
    AceCount: DWORD;
    AclBytesInUse: DWORD;
    AclBytesFree: DWORD;
  end;
  ACL_SIZE_INFORMATION = _ACL_SIZE_INFORMATION;
  TAclSizeInformation = ACL_SIZE_INFORMATION;

  { TAclRevisionInformation }

  _ACL_REVISION_INFORMATION = record
    AclRevision: DWORD;
  end;
  ACL_REVISION_INFORMATION = _ACL_REVISION_INFORMATION;
  TAclRevisionInformation = ACL_REVISION_INFORMATION;

  { TCoInitializeSecurity }

  TCoInitializeSecurityProc =  function (pSecDesc: PSecurityDescriptor;
    cAuthSvc: Longint;
    asAuthSvc: PSOleAuthenticationService;
    pReserved1: Pointer;
    dwAuthnLevel, dImpLevel: Longint;
    pReserved2: Pointer;
    dwCapabilities: Longint;
    pReserved3: Pointer): HResult; stdcall;

  PCoAuthInfo = ^TCoAuthInfo;
  TCoAuthInfo = record
    dwAuthnSvc: DWORD;
    dwAuthzSvc: DWORD;
    pwszServerPrincName: LPWSTR;
    dwAuthnLevel: DWORD;
    dwImpersonationLevel: DWORD;
    pAuthIdentityData: Pointer; //COAUTHIDENTITY
    dwCapabilities: DWORD;
  end;

  PCoServerInfo = ^TCoServerInfo;
  TCoServerInfo = record
    dwReserved1: Longint;
    pwszName: LPWSTR;
    pAuthInfo: PCoAuthInfo;
    dwReserved2: Longint;
  end;

  { TCoCreateInstanceEx }

  TCoCreateInstanceExProc = function (const clsid: TCLSID;
    unkOuter: IUnknown; dwClsCtx: Longint; ServerInfo: PCoServerInfo;
    dwCount: Longint; rgmqResults: PMultiQIArray): HResult stdcall;

function IsEnabledDCOM: Boolean;
procedure InitializeDefaultSecurity;
procedure AllowLaunch(const ClassID: TGUID);
procedure AllowAccess(const ClassID: TGUID);

implementation

var
  CoInitializeSecurity: TCoInitializeSecurityProc = nil;
  CoCreateInstanceEx: TCoCreateInstanceExProc = nil;

procedure RaiseWin32Error(ErrorCode: DWORD);
var
  Error: EWin32Error;
begin
  if ErrorCode <> ERROR_SUCCESS then
    Error := EWin32Error.CreateFmt(SWin32Error, [ErrorCode, SysErrorMessage(ErrorCode)])
  else
    Error := EWin32Error.Create(SUnkWin32Error);
  Error.ErrorCode := ErrorCode;
  raise Error;
end;

procedure InitializeDefaultSecurity;
begin
  if Assigned(CoInitializeSecurity) then
  begin
    OleCheck(CoInitializeSecurity(
           nil,                        //Points to security descriptor
           -1,                          //Count of entries in asAuthSvc
           nil,                         //Array of names to register
           nil,                         //Reserved for future use
           RPC_C_AUTHN_LEVEL_NONE,      //Default authentication level
                                        // for proxies
           RPC_C_IMP_LEVEL_IMPERSONATE, //Default impersonation level
                                        // for proxies
           nil,                         //Reserved; must be set to NULL
           EOAC_NONE,                  //Additional client or
                                        // server-side capabilities
           nil));                       //Reserved for future use
  end;
end;

function IsEnabledDCOM: Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey(REGSTR_KEY_OLE, False) then Exit;

    if not Reg.ValueExists(REGSTR_VAL_ENABLEDCOM) then Exit;
    try
      if Reg.ReadString(REGSTR_VAL_ENABLEDCOM) <> YesNoToChar[True] then Exit;
    except
      Exit;
    end;

    if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
    begin
      if not Reg.ValueExists(REGSTR_VAL_ENABLEREMOTECONNECT) then Exit;
      try
        if Reg.ReadString(REGSTR_VAL_ENABLEREMOTECONNECT) <> YesNoToChar[True] then Exit;
      except
        Exit;
      end;
    end;
  finally
    Reg.Free;
  end;
  Result := True;
end;

procedure SetEnableDCOM(const Value: Boolean);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if Reg.OpenKey(REGSTR_KEY_OLE, False) then
    begin
      if not Reg.ValueExists(REGSTR_VAL_ENABLEDCOM)
        or (Reg.ReadString(REGSTR_VAL_ENABLEDCOM) <> YesNoToChar[Value]) then
      begin
        Reg.WriteString(REGSTR_VAL_ENABLEDCOM, YesNoToChar[Value]);
      end;
      if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
      begin
        if not Reg.ValueExists(REGSTR_VAL_ENABLEREMOTECONNECT)
          or (Reg.ReadString(REGSTR_VAL_ENABLEREMOTECONNECT) <> YesNoToChar[Value]) then
        begin
          Reg.WriteString(REGSTR_VAL_ENABLEREMOTECONNECT, YesNoToChar[Value]);
        end;
      end;
    end
  finally
    Reg.Free;
  end;
end;

function IsInteractiveUser(const ClassID: TGUID): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Result := Reg.OpenKey(REGSTR_KEY_APPID + '\' + GUIDToString(ClassID), False)
       and Reg.ValueExists(REGSTR_VAL_RUNAS)
       and (Reg.ReadString(REGSTR_VAL_RUNAS) = InteractiveUserValue);
  finally
    Reg.Free;
  end;
end;

function HInstanceToModuleName: String; 
var
  ModuleName: array[0..MAX_PATH] of Char;
begin
  SetString(Result, ModuleName,
    Windows.GetModuleFileName(HInstance, ModuleName, SizeOf(ModuleName)));
end;

procedure SetInteractiveUser(const ClassID: TGUID; const Value: Boolean);
var
  Reg: TRegistry;
  strClassID: String;
  keyAppID: String;
  keyClassID: String;
  keyModuleName: String;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    strClassID := GUIDToString(ClassID);
    keyAppID := REGSTR_KEY_APPID + '\' + strClassID;
    keyClassID := REGSTR_KEY_CLSID + '\' + strClassID;
    keyModuleName := REGSTR_KEY_APPID + '\' + ExtractFileName(HInstanceToModuleName);
    if Value then
    begin
      if Reg.OpenKey(keyAppID, True) then
      begin
        Reg.WriteString(REGSTR_VAL_RUNAS, InteractiveUserValue);
        Reg.CloseKey;
      end;
      if Reg.OpenKey(keyModuleName, True) then
      begin
        Reg.WriteString(REGSTR_VAL_APPID, strClassID);
        Reg.CloseKey;
      end;
      if Reg.OpenKey(keyClassID, False) then
      begin
        Reg.WriteString(REGSTR_VAL_APPID, strClassID);
        Reg.CloseKey;
      end;
    end
    else
    begin
      if Reg.OpenKey(keyAppID, False) then
      begin
        Reg.DeleteValue(REGSTR_VAL_RUNAS);
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure RemoveLaunchAccess(const ClassID: TGUID);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    if Reg.OpenKey(REGSTR_KEY_APPID + '\' + GUIDToString(ClassID), False) then
      Reg.DeleteValue(REGSTR_VAL_LAUNCHPERMISSION);
  finally
    Reg.Free;
  end;
end;

function IsDCOMProtocolsEnabled: Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Result := Reg.OpenKey(REGSTR_KEY_RPC, False)
       and Reg.ValueExists(REGSTR_VAL_DCOMPROTOCOLS)
       and (Reg.GetDataSize(REGSTR_VAL_DCOMPROTOCOLS) > 2);
  finally
    Reg.Free;
  end;
end;

procedure RemoveLegacySecureReferences;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_OLE, False) then
    begin
      if Reg.ValueExists(REGSTR_VAL_LEGACYSECUREREFERENCES)
         and (Reg.ReadString(REGSTR_VAL_LEGACYSECUREREFERENCES) <> YesNoToChar[False]) then
        Reg.DeleteValue(REGSTR_VAL_LEGACYSECUREREFERENCES);
    end;
  finally
    Reg.Free;
  end;
end;

procedure SetDefaultDCOMCommunicationProperties;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if Reg.OpenKey(REGSTR_KEY_OLE, False) then
    begin
      if not Reg.ValueExists(REGSTR_VAL_LEGACYAUTHENTICATIONLEVEL)
        or (Reg.ReadInteger(REGSTR_VAL_LEGACYAUTHENTICATIONLEVEL) <> RPC_C_AUTHN_LEVEL_NONE) then
      begin
        Reg.WriteInteger(REGSTR_VAL_LEGACYAUTHENTICATIONLEVEL,
          RPC_C_AUTHN_LEVEL_NONE);
      end;
      if not Reg.ValueExists(REGSTR_VAL_IMPERSONATIONLEVEL)
        or (Reg.ReadInteger(REGSTR_VAL_IMPERSONATIONLEVEL) <> RPC_C_IMP_LEVEL_IMPERSONATE) then
      begin
        Reg.WriteInteger(REGSTR_VAL_IMPERSONATIONLEVEL,
          RPC_C_IMP_LEVEL_IMPERSONATE);
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure MakeAppIDKeyName(KeyName, AppID: PChar);
begin
  StrCopy(keyName, 'AppID\');
  StrCopy(PChar(@keyName[6]), AppID);
end;

function GetNamedValueSD(RootKey: HKEY; KeyName, ValueName: PChar;
  var pSD: PSecurityDescriptor): DWORD;
var
  registryKey: HKEY;
  valueType: DWORD;
  valueSize: DWORD;
  newSD: PSecurityDescriptor;
begin
  Result := RegOpenKeyEx(RootKey, KeyName, 0, KEY_ALL_ACCESS, registryKey);
  if Result = ERROR_SUCCESS then
  try
    Result := RegQueryValueEx(registryKey, ValueName, nil, @valueType, nil, @valueSize);
    if Result = ERROR_SUCCESS then
    begin
      GetMem(newSD, valueSize);
      try
        Result := RegQueryValueEx(registryKey, ValueName, nil,
          @valueType, PByte(newSD), @valueSize);
        if Result = ERROR_SUCCESS then
          pSD := newSD
        else
          FreeMem(newSD);
      except
        FreeMem(newSD);
        raise;
      end;
    end
  finally
    RegCloseKey(registryKey);
  end;
end;

function GetCurrentUserSID: PSID;
var
  ptknUser: PTokenUser;
  tknHandle: THandle;
  tknSize: DWORD;
  sidLength: DWORD;
begin
  if not OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, tknHandle) then
    RaiseLastWin32Error;
  ptknUser := nil;
  tknSize := 0;
  try
    GetTokenInformation(tknHandle, TokenUser, ptknUser, 0, tknSize);
    GetMem(ptknUser, tknSize);
    try
      if not GetTokenInformation(tknHandle, TokenUser, ptknUser, tknSize, tknSize) then
        RaiseLastWin32Error;
      sidLength := GetLengthSid(ptknUser.User.Sid);
      GetMem(Result, sidLength);
      move(ptknUser.User.Sid^, Result^, sidLength);
    finally
      FreeMem(ptknUser);
    end;
  finally
    CloseHandle(tknHandle);
  end;
end;


function CreateNewSD: PSecurityDescriptor;
var
  pdacl: PACL;
  sidLength: DWORD;
  sid: PSID;
  groupSID: PSID;
  ownerSID: PSID;
  sdSize: Integer;
  daclSize: Integer;
begin
  sid := GetCurrentUserSID;
  try
    sidLength := GetLengthSid(sid);
    sdSize := SizeOf(TSecurityDescriptor) +
       (2 * sidLength) +
       SizeOf(TACL) +
       SizeOf(TAccessAllowedACE) +
       sidLength;

    GetMem(Result, sdSize);
    try
      groupSID := PSID(Integer(Result) + SizeOf(TSecurityDescriptor));
      ownerSID := PSID(DWORD(groupSID) + sidLength);
      pdacl := PACL(DWORD(ownerSID) + sidLength);
      if not InitializeSecurityDescriptor(Result, SECURITY_DESCRIPTOR_REVISION) then
        RaiseLastWin32Error;
      daclSize := SizeOf(TACL) + SizeOf(TAccessAllowedAce) + sidLength;
      if not InitializeAcl(pdacl^, daclSize, ACL_REVISION2) and not IsValidACL(pdacl^) then
        RaiseLastWin32Error;
      if not AddAccessAllowedAce(pdacl^, ACL_REVISION2, COM_RIGHTS_EXECUTE, sid) then
        RaiseLastWin32Error;
      if not SetSecurityDescriptorDacl(Result, True, pdacl, False) then
        RaiseLastWin32Error;
      Move(sid^, groupSID^, sidLength);
      if not SetSecurityDescriptorGroup(Result, groupSID, False) then
        RaiseLastWin32Error;
      Move(sid^, ownerSID^, sidLength);
      if not SetSecurityDescriptorOwner(Result, ownerSID, False) then
        RaiseLastWin32Error;
      if not IsValidSecurityDescriptor(Result) then
        RaiseLastWin32Error;
    except
      FreeMem(Result);
      raise;
    end;
  finally
    FreeMem(Sid);
  end;
end;

procedure CopyACL(OldACL, NewACL: PACL);
var
  aclSizeInfo: ACL_SIZE_INFORMATION;
  ace: Pointer;
  aceHeader: PAceHeader;
  I: Integer;
begin
  if not GetAclInformation(OldACL^, @aclSizeInfo,
    SizeOf(aclSizeInfo), AclSizeInformation) then RaiseLastWin32Error;
  for I := 0 to aclSizeInfo.AceCount - 1 do
  begin
    if not GetAce(OldACL^, I, ace) then RaiseLastWin32Error;
    aceHeader := PAceHeader(ace);
    if not AddAce(NewACL^, ACL_REVISION, $FFFFFFFF, ace, aceHeader.AceSize) then
      RaiseLastWin32Error;
  end;
end;

function CreateWorldSID: PSID;
var
  sia: TSIDIdentifierAuthority;
begin
  // SECURITY_WORLD_SID_AUTHORITY {0,0,0,0,0,1}
  ZeroMemory(@sia.Value, SizeOf(sia.Value));
  sia.Value[5] := 1;
  GetMem(Result, GetSidLengthRequired(1));
  if not InitializeSid(Result, sia, 1) then
  begin
    FreeMem(Result);
    RaiseLastWin32Error();
  end;
  GetSidSubAuthority(Result, 0)^ := 0;
end;

procedure AclAddAccessAllowed(OldAcl: PACL; var NewAcl: PACL; PermissionMask: DWORD);
var
  aclSizeInfo: ACL_SIZE_INFORMATION;
  aclSize: Integer;
  principalSID: PSID;
begin
  principalSID := CreateWorldSID;
  try
    if not GetAclInformation(oldACL^, @aclSizeInfo, SizeOf(ACL_SIZE_INFORMATION),
      AclSizeInformation) then RaiseLastWin32Error;
    aclSize := aclSizeInfo.AclBytesInUse +
               SizeOf(TACL) + SizeOf(ACCESS_ALLOWED_ACE) +
               GetLengthSid(principalSID) - SizeOf(DWORD);
    GetMem(newACL, aclSize);
    try
      if not InitializeAcl(newACL^, aclSize, ACL_REVISION) then
        RaiseLastWin32Error;
      CopyACL(oldACL, newACL);
      if not AddAccessAllowedAce(newACL^, ACL_REVISION2, PermissionMask, principalSID) then
        RaiseLastWin32Error;
    except
      FreeMem(newACL);
      raise;
    end;
  finally
    FreeMem(principalSID);
  end;
end;


function MakeSDAbsolute(OldSD: PSecurityDescriptor): PSecurityDescriptor;
var
  descriptorSize: DWORD;
  daclSize: DWORD;
  saclSize: DWORD;
  ownerSIDSize: DWORD;
  groupSIDSize: DWORD;
  dacl: PACL;
  sacl: PACL;
  ownerSID: PSID;
  groupSID: PSID;
  present: BOOL;
  systemDefault: BOOL;
begin
  if not GetSecurityDescriptorSacl(OldSD, present, sacl, systemDefault) then
    RaiseLastWin32Error;
  if present and (sacl <> nil) then
    saclSize := sacl.AclSize
  else
    saclSize := 0;

  if not GetSecurityDescriptorDacl(OldSD, present, dacl, systemDefault) then
    RaiseLastWin32Error;
  if present and (dacl <> nil) then
    daclSize := dacl.AclSize
  else
    daclSize := 0;

  if not GetSecurityDescriptorOwner(OldSD, ownerSID, systemDefault) then
    RaiseLastWin32Error;
  ownerSIDSize := GetLengthSid(ownerSID);

  if not GetSecurityDescriptorGroup(OldSD, groupSID, systemDefault) then
    RaiseLastWin32Error;
  groupSIDSize := GetLengthSid(groupSID);

  descriptorSize := 0;

  Result := nil;
  if not MakeAbsoluteSD(OldSD, Result, descriptorSize, dacl^, daclSize, sacl^,
     saclSize, ownerSID, ownerSIDSize, groupSID, groupSIDSize) then
  begin
    if GetLastError <> ERROR_INSUFFICIENT_BUFFER then
      RaiseLastWin32Error;
  end;

  GetMem(Result, SECURITY_DESCRIPTOR_MIN_LENGTH);
  try
    if not InitializeSecurityDescriptor(Result, SECURITY_DESCRIPTOR_REVISION) then
      RaiseLastWin32Error;

    if not MakeAbsoluteSD(OldSD, Result, descriptorSize, dacl^, daclSize, sacl^,
       saclSize, ownerSID, ownerSIDSize, groupSID, groupSIDSize) then
       RaiseLastWin32Error;
  except
    FreeMem(Result);
    raise;
  end;
end;

procedure SetNamedValueSD(RootKey: HKEY; KeyName, ValueName: PChar;
  pSD: PSecurityDescriptor);
var
  Key: HKEY;
  Res: DWORD;
begin
  Res := RegOpenKeyEx(RootKey, KeyName, 0, KEY_ALL_ACCESS, Key);
  if Res <> ERROR_SUCCESS then RaiseLastWin32Error;
  try
    Res := RegSetValueEx(Key, ValueName, 0, REG_BINARY, pSD,
        GetSecurityDescriptorLength(pSD));
    if Res <> ERROR_SUCCESS then RaiseLastWin32Error;
  finally
    RegCloseKey(Key);
  end;;
end;

procedure AddPrincipalToNamedValueSD(KeyName, ValueName: PChar);
var
  pSD: PSecurityDescriptor;
  sdSelfRelative: PSecurityDescriptor;
  sdAbsolute: PSecurityDescriptor;
  secDescSize: DWORD;
  present: BOOL;
  defaultDACL: BOOL;
  dacl: PACL;
  newSD: BOOL;
  newACL: PACL;
  saveACL: PACL;
begin
  newSD := False;
  pSD := nil;
  if GetNamedValueSD(HKEY_CLASSES_ROOT, KeyName, ValueName, pSD) <> ERROR_SUCCESS then
  begin
    pSD := CreateNewSD;
    newSD := True;
  end;
  try
    if not GetSecurityDescriptorDacl(pSD, present, dacl, defaultDACL) then
      RaiseLastWin32Error;

    newACL := nil;
    if newSD then
    begin
      AclAddAccessAllowed(dacl, newACL, COM_RIGHTS_EXECUTE);
      saveACL := newACL;
      try
        AclAddAccessAllowed(saveACL, newACL, COM_RIGHTS_EXECUTE);
      finally
        FreeMem(saveACL);
      end;
    end;

    if newACL <> nil then
    begin
      saveACL := newACL;
      try
        AclAddAccessAllowed(saveACL, newACL, COM_RIGHTS_EXECUTE);
      finally
        FreeMem(saveACL);
      end;
    end
    else
      AclAddAccessAllowed(dacl, newACL, COM_RIGHTS_EXECUTE);

    try
      if not newSD then
         sdAbsolute := MakeSDAbsolute(pSD)
       else
         sdAbsolute := pSD;
      try
        if not SetSecurityDescriptorDacl(sdAbsolute, True, newACL, False) then
          RaiseLastWin32Error;

        secDescSize := 0;
        sdSelfRelative := nil;
        MakeSelfRelativeSD(sdAbsolute, sdSelfRelative, secDescSize);
        GetMem(sdSelfRelative, secDescSize);
        try
          if not MakeSelfRelativeSD(sdAbsolute, sdSelfRelative, secDescSize) then
            RaiseLastWin32Error;
          SetNamedValueSD(HKEY_CLASSES_ROOT, KeyName, ValueName, sdSelfRelative);
        finally
          FreeMem(sdSelfRelative);
        end;
      finally
        if pSD <> sdAbsolute then FreeMem(sdAbsolute);
      end;
    finally
      FreeMem(newACL);
    end;
  finally
    FreeMem(pSD);
  end;
end;

function GetErrorMessage(ErrorCode: DWORD): String;
begin
  Result := Format(SWin32Error, [ErrorCode, SysErrorMessage(ErrorCode)])
end;

function GetLastWin32ErrorMessage: String;
var
  LastError: DWORD;
begin
  LastError := GetLastError;
  if LastError <> ERROR_SUCCESS then
    Result := Format(SWin32Error, [LastError, SysErrorMessage(LastError)])
  else
    Result := SUnkWin32Error;
end;

procedure AllowLaunch(const ClassID: TGUID);
var
  KeyName: array [0..255] of Char;
begin
  MakeAppIDKeyName(KeyName, PChar(GUIDToString(ClassID)));
  AddPrincipalToNamedValueSD(KeyName,  REGSTR_VAL_LAUNCHPERMISSION);
end;

procedure AllowAccess(const ClassID: TGUID);
var
  KeyName: array [0..255] of Char;
begin
  MakeAppIDKeyName(KeyName, PChar(GUIDToString(ClassID)));
  AddPrincipalToNamedValueSD(KeyName,  REGSTR_VAL_ACCESSPERMISSION);
end;

procedure LoadComExProcs;
var
  Ole32: HModule;
begin
  Ole32 := GetModuleHandle('ole32.dll');
  if Ole32 <> 0 then
  begin
    @CoInitializeSecurity := GetProcAddress(Ole32, 'CoInitializeSecurity');
    @CoCreateInstanceEx := GetProcAddress(Ole32, 'CoCreateInstanceEx');
  end;
end;

initialization
  LoadComExProcs;
end.


