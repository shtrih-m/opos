unit ScaleDevice;

interface
uses
  // Opos
  OposDevice,
  // This
  untPages, fmuPages, ScaleParameters, LogFile;

type
  { TScaleDevice }

  TScaleDevice = class(TOposDevice)
  private
    FLogger: ILogFile;
    FParameters: TScaleParameters;
    property Parameters: TScaleParameters read FParameters;
  public
    constructor CreateDevice(AOwner: TOposDevices);
    destructor Destroy; override;

    procedure SetDefaults; override;
    procedure SaveParams; override;
    procedure ShowDialog; override;
    property Logger: ILogFile read FLogger;
  end;

  { TScalePage }

  TScalePage = class(TPage)
  private
    FDevice: TScaleDevice;
    function GetDeviceName: WideString;
    function GetParameters: TScaleParameters;
  public
    property DeviceName: WideString read GetDeviceName;
    property Parameters: TScaleParameters read GetParameters;
    property Device: TScaleDevice read FDevice write FDevice;
  end;
  TScalePageClass = class of TScalePage;

implementation

uses
  // This
  fmuScaleGeneral, fmuScaleLog;

{ TScaleDevice }

constructor TScaleDevice.CreateDevice(AOwner: TOposDevices);
begin
  inherited Create(AOwner, 'Scale', 'Scale', ScaleProgID);
  FLogger := TLogFile.Create;
  FParameters := TScaleParameters.Create(FLogger);
end;

destructor TScaleDevice.Destroy;
begin
  FLogger := nil;
  FParameters.Free;
  inherited Destroy;
end;

procedure TScaleDevice.SetDefaults;
begin
  Parameters.SetDefaults;
end;

procedure TScaleDevice.SaveParams;
begin
  Parameters.Save(DeviceName);
end;

procedure TScaleDevice.ShowDialog;

  procedure AddPage(Pages: TfmPages; PageClass: TScalePageClass);
  var
    Page: TScalePage;
  begin
    Page := PageClass.Create(Pages);
    Page.Device := Self;
    Pages.Add(Page);
  end;

var
  fm: TfmPages;
begin
  fm := TfmPages.Create(nil);
  try
    fm.Device := Self;
    fm.Caption := 'Scale';
    Parameters.Load(DeviceName);
    // Pages
    AddPage(fm, TfmScaleGeneral);
    AddPage(fm, TfmScaleLog);

    fm.Init;
    fm.UpdatePage;
    fm.btnApply.Enabled := False;
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

{ TScalePage }

function TScalePage.GetDeviceName: WideString;
begin
  Result := FDevice.DeviceName;
end;

function TScalePage.GetParameters: TScaleParameters;
begin
  Result := FDevice.Parameters;
end;

end.
