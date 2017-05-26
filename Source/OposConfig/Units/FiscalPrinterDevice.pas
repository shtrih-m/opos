unit FiscalPrinterDevice;

interface

uses
  // Opos
  OposDevice,
  // This
  untPages, FptrTypes, PrinterParameters, PrinterParametersX, fmuPages,
  MalinaParams, DriverContext, LogFile;

type
  TFptrPage = class;
  TFptrPageClass = class of TFptrPage;

  { TFiscalPrinterDevice }

  TFiscalPrinterDevice = class(TOposDevice)
  private
    FContext: TDriverContext;
    procedure AddPage(Pages: TfmPages; PageClass: TFptrPageClass);

    function GetLogger: TLogFile;
    function GetParameters: TPrinterParameters;
    function GetMalinaParams: TMalinaParams;
  public
    constructor CreateDevice(AOwner: TOposDevices);
    destructor Destroy; override;

    procedure SetDefaults; override;
    procedure SaveParams; override;
    procedure ShowDialog; override;

    property Logger: TLogFile read GetLogger;
    property Parameters: TPrinterParameters read GetParameters;
    property MalinaParams: TMalinaParams read GetMalinaParams;
  end;

  { TFptrPage }

  TFptrPage = class(TPage)
  private
    FDevice: TFiscalPrinterDevice;
  public
    function GetParameters: TPrinterParameters;
    function GetDeviceName: WideString;
    function GetLogger: TLogFile;
    function GetMalinaParams: TMalinaParams;
  public
    property Logger: TLogFile read GetLogger;
    property DeviceName: WideString read GetDeviceName;
    property Parameters: TPrinterParameters read GetParameters;
    property Device: TFiscalPrinterDevice read FDevice write FDevice;
    property MalinaParams: TMalinaParams read GetMalinaParams;
  end;

implementation

uses
  fmuFptrConnection, fmuFptrHeader, fmuFptrTrailer, fmuFptrText,
  fmuFptrLog, fmuFptrLogo, fmuFptrPayType, fmuFptrVatCode, fmuFptrBarcode,
  fmuXReport, fmuZReport, fmuMiscParams, fmuFiscalStorage, fmuFptrTables,
  fmuReceiptFormat, 
  {$IFDEF MALINA}
  fmuFptrMalina,
  fmuFptrUnipos,
  fmuFptrFuel,
  fmuFptrReplace,
  fmuCashInProcessing,
  fmuFptrPawnTicket,
  fmuRosneftDiscountCard,
  fmuRosneftAddText,
  fmuFptrRetalix,
  {$ENDIF}
  fmuFptrJournal;

{ TFiscalPrinterDevice }

constructor TFiscalPrinterDevice.CreateDevice(AOwner: TOposDevices);
begin
  inherited Create(AOwner, 'FiscalPrinter', 'FiscalPrinter', FiscalPrinterProgID);
  FContext := TDriverContext.Create;
end;

destructor TFiscalPrinterDevice.Destroy;
begin
  FContext.Free;
  inherited Destroy;
end;

procedure TFiscalPrinterDevice.SetDefaults;
begin
  Parameters.SetDefaults;
  {$IFDEF MALINA}
  GetMalinaParams.SetDefaults;
  {$ENDIF}
end;

procedure TFiscalPrinterDevice.SaveParams;
begin
  SaveParameters(Parameters, DeviceName, Logger);
  {$IFDEF MALINA}
  GetMalinaParams.Save(DeviceName);
  {$ENDIF}
end;

procedure TFiscalPrinterDevice.AddPage(Pages: TfmPages; PageClass: TFptrPageClass);
var
  Page: TFptrPage;
begin
  Page := PageClass.Create(Pages);
  Page.Device := Self;
  Pages.Add(Page);
end;

procedure TFiscalPrinterDevice.ShowDialog;
var
  fm: TfmPages;
begin
  fm := TfmPages.Create(nil);
  try
    fm.Device := Self;
    fm.Caption := 'Fiscal printer';
    LoadParameters(Parameters, DeviceName, Logger);
    {$IFDEF MALINA}
    GetMalinaParams.Load(DeviceName);
    {$ENDIF}
    //
    AddPage(fm, TfmFptrConnection);
    AddPage(fm, TfmFptrTables);
    AddPage(fm, TfmFptrHeader);
    AddPage(fm, TfmFptrTrailer);
    AddPage(fm, TfmFptrText);
    AddPage(fm, TfmFptrLog);
    AddPage(fm, TfmFptrLogo);
    AddPage(fm, TfmFptrPayType);
    AddPage(fm, TfmFptrBarcode);
    AddPage(fm, TfmXReport);
    AddPage(fm, TfmZReport);
    AddPage(fm, TfmFptrJournal);
    AddPage(fm, TfmMiscParams);
    AddPage(fm, TfmFiscalStorage);
    AddPage(fm, TfmReceiptFormat);
    AddPage(fm, TfmFptrVatCode);

    {$IFDEF MALINA}
    AddPage(fm, TfmFptrMalina);
    AddPage(fm, TfmFptrUnipos);
    AddPage(fm, TfmFptrFuel);
    AddPage(fm, TfmFptrReplace);
    AddPage(fm, TfmCashInProcessing);
    AddPage(fm, TfmFptrPawnTicket);
    AddPage(fm, TfmRosneftDiscountCard);
    AddPage(fm, TfmRosneftAddText);
    AddPage(fm, TfmFptrRetalix);
    {$ENDIF MALINA}

    fm.Init;
    fm.UpdatePage;
    fm.btnApply.Enabled := False;
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

function TFiscalPrinterDevice.GetParameters: TPrinterParameters;
begin
  Result := FContext.Parameters;
end;

function TFiscalPrinterDevice.GetLogger: TLogFile;
begin
  Result := FContext.Logger;
end;

function TFiscalPrinterDevice.GetMalinaParams: TMalinaParams;
begin
  Result := FContext.MalinaParams;
end;

{ TFptrPage }

function TFptrPage.GetDeviceName: WideString;
begin
  Result := FDevice.DeviceName;
end;

function TFptrPage.GetLogger: TLogFile;
begin
  Result := FDevice.Logger;
end;

function TFptrPage.GetMalinaParams: TMalinaParams;
begin
  Result := FDevice.MalinaParams;
end;

function TFptrPage.GetParameters: TPrinterParameters;
begin
  Result := FDevice.Parameters;
end;

end.
