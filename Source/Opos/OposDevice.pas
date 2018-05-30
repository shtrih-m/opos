unit OposDevice;

interface

Uses
  // VCL
  Windows, Classes, Registry, SysUtils, ComObj,
  // Tnt
  TntSysUtils, TntClasses, TntRegistry,
  // Opos
  Oposhi, VersionInfo, GNUGetText, DriverError;

type
  TOposDevice = class;

  { TOposDevices }

  TOposDevices = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TOposDevice;
    procedure Clear;
    procedure InsertItem(AItem: TOposDevice);
    procedure RemoveItem(AItem: TOposDevice);
  public
    constructor Create;
    destructor Destroy; override;

    function ValidIndex(Index: Integer): Boolean;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TOposDevice read GetItem; default;
  end;

  { TOposDevice }

  TOposDevice = class
  private
    FText: WideString;
    FRegKey: WideString;
    FProgID: WideString;
    FOwner: TOposDevices;
    FDeviceName: WideString;

    function GetRegKeyName: WideString;
    procedure SetOwner(AOwner: TOposDevices);
  public
    constructor Create(AOwner: TOposDevices;
      const ARegKey, AText, AProgID: WideString);
    destructor Destroy; override;

    procedure SetDefaults; virtual;
    procedure SaveParams; virtual;
    procedure ShowDialog; virtual;

    procedure Add(const DeviceName: WideString);
    procedure Delete(const DeviceName: WideString);
    procedure GetDeviceNames(DeviceNames: TTntStrings);
    procedure GetDeviceNames2(DeviceNames: TTntStrings);
    function ReadServiceName(const DeviceName: WideString): WideString;
    function ReadServiceVersion(const ProgID: WideString): WideString;
    class function ProgIDToFileVersion(const ProgID: WideString): WideString;

    property Text: WideString read FText;
    property RegKey: WideString read FRegKey;
    property ProgID: WideString read FProgID;
    property DeviceName: WideString read FDeviceName write FDeviceName;
  end;

function CLSIDToFileName(const CLSID: TGUID): WideString;
function ProgIDToFileName(const ProgID: WideString): WideString;

implementation

function ExtractQuotedStr(const Src: WideString): WideString;
begin
  Result := Src;
  if Src[1] = '"' then Delete(Result, 1, 1);;
  if Result[Length(Result)] = '"' then SetLength(Result, Length(Result) - 1);
end;

function CLSIDToFileName(const CLSID: TGUID): WideString;
var
  Reg: TTntRegistry;
  strCLSID: WideString;
begin
  Result := '';
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey:= HKEY_CLASSES_ROOT;
    strCLSID := GUIDToString(CLSID);
    if Reg.OpenKey(Format('CLSID\%s\InProcServer32', [strCLSID]), False)
       or Reg.OpenKey(Format('CLSID\%s\LocalServer32', [strCLSID]), False) then
    begin
      try
        Result := ExtractQuotedStr(Reg.ReadString(''));
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

function ProgIDToFileName(const ProgID: WideString): WideString;
begin
  Result := CLSIDToFileName(ProgIDToClassID(ProgID));
end;

{ TOposDevices }

constructor TOposDevices.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TOposDevices.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TOposDevices.Clear;
begin
  while Count > 0 do
    Items[0].Free;
end;

function TOposDevices.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TOposDevices.GetItem(Index: Integer): TOposDevice;
begin
  Result := FList[Index];
end;

procedure TOposDevices.InsertItem(AItem: TOposDevice);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TOposDevices.RemoveItem(AItem: TOposDevice);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TOposDevices.ValidIndex(Index: Integer): Boolean;
begin
  Result := (Index >= 0)and(Index < Count);
end;

{ TOposDevice }

constructor TOposDevice.Create(AOwner: TOposDevices;
  const ARegKey, AText, AProgID: WideString);
begin
  inherited Create;
  FRegKey := ARegKey;
  FText := AText;
  FProgID := AProgID;

  SetOwner(AOwner);
end;

destructor TOposDevice.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TOposDevice.SetOwner(AOwner: TOposDevices);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

function TOposDevice.GetRegKeyName: WideString;
begin
  Result := OPOS_ROOTKEY + '\' + RegKey;
end;

procedure TOposDevice.Add(const DeviceName: WideString);
var
  Reg: TTntRegistry;
  KeyName: WideString;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    KeyName := GetRegKeyName;
    if not Reg.OpenKey(KeyName, True) then
      raiseOpenKeyError(KeyName);

    Reg.CreateKey(DeviceName);
    Reg.CloseKey;
    if Reg.OpenKey(KeyName + '\' + DeviceName, False) then
    begin
      Reg.WriteString('', ProgID);
    end;
  finally
    Reg.Free;
  end;
end;

procedure TOposDevice.Delete(const DeviceName: WideString);
var
  Reg: TTntRegistry;
  KeyName: WideString;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := GetRegKeyName;
    if not Reg.OpenKey(KeyName, False) then
      raiseOpenKeyError(KeyName);

    Reg.DeleteKey(DeviceName);
  finally
    Reg.Free;
  end;
end;

procedure TOposDevice.GetDeviceNames(DeviceNames: TTntStrings);
var
  Reg: TTntRegistry;
  KeyName: WideString;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := GetRegKeyName;
    if Reg.OpenKey(KeyName, False) then
      Reg.GetKeyNames(DeviceNames);
  finally
    Reg.Free;
  end;
end;

function TOposDevice.ReadServiceName(const DeviceName: WideString): WideString;
var
  Reg: TTntRegistry;
  KeyName: WideString;
begin
  Result := '';
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    KeyName := OPOS_ROOTKEY + '\' + RegKey + '\' + DeviceName;
    if Reg.OpenKey(KeyName, False) then
    begin
      Result := Reg.ReadString('');
    end;
  finally
    Reg.Free;
  end;
end;

function TOposDevice.ReadServiceVersion(const ProgID: WideString): WideString;
var
  Service: OleVariant;
begin
  Result := '';
  try
    Service := CreateOleObject(ProgID);
    Result := Service.GetPropertyNumber(PIDX_ServiceObjectVersion);
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

class function TOposDevice.ProgIDToFileVersion(const ProgID: WideString): WideString;
begin
  Result := '';
  try
    Result := VersionInfoToStr(ReadFileVersion(ProgIDToFileName(ProgID)));
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

procedure TOposDevice.GetDeviceNames2(DeviceNames: TTntStrings);
var
  i: Integer;
  Reg: TTntRegistry;
  KeyName: WideString;
  DeviceName: WideString;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := GetRegKeyName;
    if not Reg.OpenKey(KeyName, False) then
      raiseOpenKeyError(KeyName);

    Reg.GetKeyNames(DeviceNames);
    Reg.CloseKey;

    for i := 0 to DeviceNames.Count-1 do
    begin
      DeviceName := DeviceNames[i];
      DeviceNames[i] := Tnt_WideFormat('%s, %s', [DeviceName,
        ReadServiceVersion(DeviceName)]);
    end;
  finally
    Reg.Free;
  end;
end;

procedure TOposDevice.ShowDialog;
begin

end;

procedure TOposDevice.SaveParams;
begin

end;

procedure TOposDevice.SetDefaults;
begin

end;

end.
