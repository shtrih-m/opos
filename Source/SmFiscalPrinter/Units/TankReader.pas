unit TankReader;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Registry,
  // Tnt
  TntRegistry, TntClasses, TntSysUtils,
  // This
  UniposTank;

type
  { TTankReader }

  TTankReader = class
  private
    FTanks: TUniposTanks;
    FValues: TTntStrings;
    FDataReady: Boolean;
    FTransactionDate: WideString;

    procedure WriteTank(Tank: TUniposTank);
    procedure ReadStringValues(Reg: TTntRegistry; Values: TTntStrings);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load;
    procedure Save;
    procedure Clear;

    property Tanks: TUniposTanks read FTanks;
    property Values: TTntStrings read FValues;
    property DataReady: Boolean read FDataReady write FDataReady;
    property TransactionDate: WideString read FTransactionDate write FTransactionDate;
  end;

const
  REGSTR_KEY_TANK = 'Software\TNK-BP\TankReadings';
  REGSTR_VAL_DATA_READY = 'IsDataReady';
  REGSTR_VAL_TRANS_DATE = 'AFT_TRANS_DATE';
  REGSTR_VAL_REPORT_DATE = 'REPORT_DATE';

  REGSTR_VAL_TIME_MANUAL = 'TIME_MANUAL';
  REGSTR_VAL_TANK_NAME = 'TANK_NAME';
  REGSTR_VAL_GRADENAME = 'GRADENAME';
  REGSTR_VAL_CLOSE_QTY = 'CLOSE_QTY';
  REGSTR_VAL_DENSITY = 'DENSITY';
  REGSTR_VAL_MANUAL_DENSITY = 'MANUAL_DENSITY';
  REGSTR_VAL_TANK_TEMP = 'TANK_TEMP';
  REGSTR_VAL_MANUAL_TEMP = 'MANUAL_TEMP';
  REGSTR_VAL_NET_STICK = 'NET_STICK';
  REGSTR_VAL_MANUAL_NET = 'MANUAL_NET';
  REGSTR_VAL_WATER_VOLUME = 'WATER_VOLUME';
  REGSTR_VAL_WATER_STICK = 'WATER_STICK';
  REGSTR_VAL_MANUAL_WATER = 'MANUAL_WATER';
  REGSTR_VAL_VOLUME_QTY = 'VOLUME_QTY';
  REGSTR_VAL_EMPTY_VOLUME = 'EMPTY_VOLUME';


implementation

procedure RegDeleteKey(const KeyName: string);
var
  i: Integer;
  Reg: TTntRegistry;
  Strings: TTntStrings;
begin
  Reg := TTntRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Strings := TTntStringList.Create;
  try
    if Reg.OpenKey(KeyName, False) then
    begin
      Reg.GetKeyNames(Strings);
      for i := 0 to Strings.Count-1 do
      begin
        RegDeleteKey(KeyName + '\' + Strings[i]);
      end;
      Reg.CloseKey;
      Reg.DeleteKey(KeyName);
    end;
  finally
    Reg.Free;
    Strings.Free;
  end;
end;

{ TTankReader }

constructor TTankReader.Create;
begin
  inherited Create;
  FTanks := TUniposTanks.Create;
  FValues := TTntStringList.Create;
end;

destructor TTankReader.Destroy;
begin
  FTanks.Free;
  FValues.Free;
  inherited Destroy;
end;

procedure TTankReader.Clear;
begin
  FTanks.Clear;
  FValues.Clear;
  FDataReady := False;
  FTransactionDate := '';
end;

procedure TTankReader.Load;
var
  i: Integer;
  KeyName: WideString;
  Reg: TTntRegistry;
  Tank: TUniposTank;
  KeyNames: TTntStrings;
begin
  Clear;
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_TANK, False) then
    begin
      ReadStringValues(Reg, Values);

      FDataReady := Reg.ReadString(REGSTR_VAL_DATA_READY) = 'true';
      FTransactionDate := Reg.ReadString(REGSTR_VAL_TRANS_DATE);

      KeyNames := TTntStringList.Create;
      try
        Reg.GetKeyNames(KeyNames);
        for i := 0 to KeyNames.Count-1 do
        begin
          KeyName := REGSTR_KEY_TANK + '\' + KeyNames[i];
          Reg.CloseKey;
          if Reg.OpenKey(KeyName, False) then
          begin
            Tank := FTanks.Add(KeyNames[i]);
            ReadStringValues(Reg, Tank.Values);
          end;
        end;
      finally
        KeyNames.Free;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TTankReader.ReadStringValues(Reg: TTntRegistry; Values: TTntStrings);
var
  i: Integer;
  ValueName: WideString;
  DataInfo: TRegDataInfo;
  ValueNames: TTntStrings;
begin
  ValueNames := TTntStringList.Create;
  try
    Reg.GetValueNames(ValueNames);
    for i := 0 to ValueNames.Count-1 do
    begin
      ValueName := ValueNames[i];
      Reg.GetDataInfo(ValueName, DataInfo);
      if DataInfo.RegData = rdString then
      begin
        Values.Values[ValueName] := Reg.ReadString(ValueName);
      end;
    end;
  finally
    ValueNames.Free;
  end;
end;

procedure TTankReader.Save;
var
  i: Integer;
  Reg: TTntRegistry;
const
  BoolToStr: array [Boolean] of WideString = ('false', 'true');
begin
  Reg := TTntRegistry.Create;
  try
    RegDeleteKey(REGSTR_KEY_TANK);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_TANK, True) then
    begin
      Reg.WriteString(REGSTR_VAL_DATA_READY, BoolToStr[FDataReady]);
      Reg.WriteString(REGSTR_VAL_TRANS_DATE, FTransactionDate);

      for i := 0 to FTanks.Count-1 do
      begin
        WriteTank(FTanks[i]);
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TTankReader.WriteTank(Tank: TUniposTank);
var
  i: Integer;
  SName: WideString;
  SValue: WideString;
  Reg: TTntRegistry;
  KeyName: WideString;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := REGSTR_KEY_TANK + '\' + Tank.Name;
    if Reg.OpenKey(KeyName, True) then
    begin
      for i := 0 to Tank.Values.Count-1 do
      begin
        SName := Tank.Values.Names[i];
        SValue := Tank.Values.ValueFromIndex[i];
        Reg.WriteString(SName, SValue);
      end;
    end;
  finally
    Reg.Free;
  end;
end;

end.
