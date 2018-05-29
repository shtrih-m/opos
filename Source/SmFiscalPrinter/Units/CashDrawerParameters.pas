unit CashDrawerParameters;

interface

uses
  // VCL
  Windows, Registry, SysUtils,
  // Tnt
  TntSysUtils, TntClasses, TntStdCtrls, TntRegistry,
  // This
  Oposhi, WException, PrinterTypes, LogFile,
  PrinterParameters, gnugettext;

const
  /////////////////////////////////////////////////////////////////////////////
  // "CCOType" constants

  CCOTYPE_RCS   = 0;
  CCOTYPE_NCR   = 1;
  CCOTYPE_NONE  = 2;

type
  { TCashDrawerParameters }

  TCashDrawerParameters = class
  private
    FLogger: ILogFile;
    FCCOType: Integer;
    FEncoding: Integer;
    FDrawerNumber: Integer;
    FFptrDeviceName: WideString;

    function GetKeyName(const DeviceName: WideString): WideString;
    procedure WriteLogParameters;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(ALogger: ILogFile);
    procedure SetDefaults;
    procedure Load(const DeviceName: WideString);
    procedure Save(const DeviceName: WideString);

    property CCOType: Integer read FCCOType write FCCOType;
    property Encoding: Integer read FEncoding write FEncoding;
    property DrawerNumber: Integer read FDrawerNumber write FDrawerNumber;
    property FptrDeviceName: WideString read FFptrDeviceName write FFptrDeviceName;
  end;

const
  CashDrawerProgID = 'OposShtrih.CashDrawer';

implementation

{ TCashDrawerParameters }

procedure TCashDrawerParameters.SetDefaults;
begin
  Logger.Debug('TCashDrawerParameters.SetDefaults');

  FptrDeviceName := '';
  FCCOType := CCOTYPE_RCS;
  FEncoding := EncodingWindows;
end;

procedure TCashDrawerParameters.WriteLogParameters;
begin
  Logger.Debug('TCashDrawerParameters.WriteLogParameters');
  Logger.Debug('FptrDeviceName: ' + FptrDeviceName);
  Logger.Debug('DrawerNumber: ' + IntToStr(DrawerNumber));
  Logger.Debug('Encoding: ' + IntToStr(Encoding));
  Logger.Debug('CCOType: ' + IntToStr(CCOType));
end;

function TCashDrawerParameters.GetKeyName(const DeviceName: WideString): WideString;
begin
  Result := Tnt_WideFormat('%s\%s\%s', [OPOS_ROOTKEY, OPOS_CLASSKEY_CASH, DeviceName]);
end;

procedure TCashDrawerParameters.Load(const DeviceName: WideString);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TCashDrawerParameters.Load', DeviceName);

  SetDefaults;
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(GetKeyName(DeviceName), False) then
    begin
      if Reg.ValueExists('FptrDeviceName') then
        FFptrDeviceName := Reg.ReadString('FptrDeviceName');

      if Reg.ValueExists('DrawerNumber') then
        FDrawerNumber := Reg.ReadInteger('DrawerNumber');

      if Reg.ValueExists('Encoding') then
        FEncoding := Reg.ReadInteger('Encoding');

      if Reg.ValueExists('CCOType') then
        CCOType := Reg.ReadInteger('CCOType');

    end else
    begin
      raiseException(_('Registry key open error'));
    end;
  finally
    Reg.Free;
  end;
  WriteLogParameters;
end;

procedure TCashDrawerParameters.Save(const DeviceName: WideString);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TCashDrawerParameters.Save', DeviceName);

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(GetKeyName(DeviceName), True) then
    begin
      Reg.WriteString('', CashDrawerProgID);

      Reg.WriteString('FptrDeviceName', FptrDeviceName);
      Reg.WriteInteger('DrawerNumber', DrawerNumber);
      Reg.WriteInteger('Encoding', Encoding);
      Reg.WriteInteger('CCOType', CCOType);
    end else
    begin
      raiseException(_('Registry key open error'));
    end;
  finally
    Reg.Free;
  end;
end;

constructor TCashDrawerParameters.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
end;

end.
