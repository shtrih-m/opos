unit CashDrawerDevice;

interface

uses
  // VCL
  Windows, Forms, Controls,
  // Opos
  OposDevice,
  // This
  untPages, fmuPages, CashDrawerParameters, LogFile;

type
  TCashPage = class;
  TCashPageClass = class of TCashPage;

  { TCashDrawerDevice }

  TCashDrawerDevice = class(TOposDevice)
  private
    FLogger: ILogFile;
    FParameters: TCashDrawerParameters;
    procedure AddPage(Pages: TfmPages; PageClass: TCashPageClass);
  public
    constructor CreateDevice(AOwner: TOposDevices);
    destructor Destroy; override;

    procedure ShowDialog; override;
    procedure SetDefaults; override;
    procedure SaveParams; override;
    property Parameters: TCashDrawerParameters read FParameters;
  end;

  { TCashPage }

  TCashPage = class(TPage)
  private
    FDevice: TCashDrawerDevice;
    function GetDeviceName: WideString;
    function GetParameters: TCashDrawerParameters;
  public
    property DeviceName: WideString read GetDeviceName;
    property Parameters: TCashDrawerParameters read GetParameters;
    property Device: TCashDrawerDevice read FDevice write FDevice;
  end;

implementation

uses
  // This
  fmuCashDrawer;

{ TCashDrawerDevice }

constructor TCashDrawerDevice.CreateDevice(AOwner: TOposDevices);
begin
  inherited Create(AOwner, 'CashDrawer', 'CashDrawer', CashDrawerProgID);
  FLogger := TLogFile.Create;
  FParameters := TCashDrawerParameters.Create(FLogger);
end;

destructor TCashDrawerDevice.Destroy;
begin
  FLogger := nil;
  FParameters.Free;
  inherited Destroy;
end;

procedure TCashDrawerDevice.AddPage(Pages: TfmPages; PageClass: TCashPageClass);
var
  Page: TCashPage;
begin
  Page := PageClass.Create(Pages);
  Page.Device := Self;
  Pages.Add(Page);
end;

procedure TCashDrawerDevice.ShowDialog;
var
  fm: TfmPages;
begin
  fm := TfmPages.Create(nil);
  try
    fm.Device := Self;
    fm.Caption := 'Cash drawer';
    Parameters.Load(DeviceName);
    AddPage(fm, TfmCashDrawer);

    fm.Init;
    fm.UpdatePage;
    fm.btnApply.Enabled := False;
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TCashDrawerDevice.SaveParams;
begin
  Parameters.Save(DeviceName);
end;

procedure TCashDrawerDevice.SetDefaults;
begin
  Parameters.SetDefaults;
end;

{ TCashPage }

function TCashPage.GetDeviceName: WideString;
begin
  Result := FDevice.DeviceName;
end;

function TCashPage.GetParameters: TCashDrawerParameters;
begin
  Result := FDevice.Parameters;
end;

end.
