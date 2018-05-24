unit MarkChecker;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Registry,
  // This
  EkmClient, LogFile, DriverError, DriverTypes, GS1Barcode;

type
  { TMarkChecker }

  TMarkChecker = class
  private
    FClient: TEkmClient;
  public
    EkmServerHost: string;
    EkmServerPort: Integer;
    EkmServerTimeout: Integer;
    EkmServerEnabled: Boolean;
    FSMarkCheckEnabled: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadParams;
    procedure SaveParams;
    procedure SetDefaults;
    procedure CheckBarcode(const Barcode: TGS1Barcode);
  end;

procedure MarkCheckerSetDefaults;

implementation

procedure MarkCheckerSetDefaults;
var
  MarkChecker: TMarkChecker;
begin
  MarkChecker := TMarkChecker.Create;
  try
    MarkChecker.SetDefaults;
    MarkChecker.SaveParams;
  finally
    MarkChecker.Free;
  end;
end;

{ TMarkChecker }

constructor TMarkChecker.Create;
begin
  inherited Create;
  FClient := TEkmClient.Create;
  LoadParams;
end;

destructor TMarkChecker.Destroy;
begin
  FClient.Free;
  inherited Destroy;
end;

procedure TMarkChecker.CheckBarcode(const Barcode: TGS1Barcode);
var
  SaleEnabled: Boolean;
resourcestring
  SSaleNotEnabled = 'Продажа товара запрещена';
begin
  FClient.Host := EkmServerHost;
  FClient.Port := EkmServerPort;
  FClient.Timeout := EkmServerTimeout;
  SaleEnabled := FClient.ReadSaleEnabled(Barcode.GTIN, Barcode.Serial);
  if not SaleEnabled then
    raiseError(E_SALE_NOT_ENABLED, GetRes(@SSaleNotEnabled));
end;

procedure TMarkChecker.LoadParams;
var
  Reg: TTntRegistry;
begin
  SetDefaults;
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := GetRegRootKey(GetStorageType);
    if Reg.OpenKey(REGSTR_KEY_MARK_CHEKER, False) then
    begin
      EkmServerHost := Reg.ReadString('EkmServerHost');
      EkmServerPort := Reg.ReadInteger('EkmServerPort');
      EkmServerTimeout := Reg.ReadInteger('EkmServerTimeout');
      EkmServerEnabled := Reg.ReadBool('EkmServerEnabled');
      FSMarkCheckEnabled := Reg.ReadBool('FSMarkCheckEnabled');
    end;
  except
    on E: Exception do
      Logger.Error(SParamsReadError, E);
  end;
  Reg.Free;
end;

procedure TMarkChecker.SaveParams;
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := GetRegRootKey(GetStorageType);
    if Reg.OpenKey(REGSTR_KEY_MARK_CHEKER, True) then
    begin
      Reg.WriteString('EkmServerHost', EkmServerHost);
      Reg.WriteInteger('EkmServerPort', EkmServerPort);
      Reg.WriteInteger('EkmServerTimeout', EkmServerTimeout);
      Reg.WriteBool('EkmServerEnabled', EkmServerEnabled);
      Reg.WriteBool('FSMarkCheckEnabled', FSMarkCheckEnabled);
    end;
  except
    on E: Exception do
      Logger.Error(SParamsWriteError, E);
  end;
  Reg.Free;
end;

procedure TMarkChecker.SetDefaults;
begin
  EkmServerHost := '80.243.2.202';
  EkmServerPort := 2003;
  EkmServerTimeout := 5;
  EkmServerEnabled := False;
  FSMarkCheckEnabled := False;
end;

end.
