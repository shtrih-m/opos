unit MalinaPlugin;

interface

uses
  // This
  FptrFilter, MalinaParams, MalinaFilter, UniposFilter, FuelRecFilter,
  AntiFroudFilter, FiscalPrinterTypes, PawnTicketFilter, CustomReceipt,
  NonfiscalDoc, MalinaZReportFilter;

type
  { TMalinaPlugin }

  TMalinaPlugin = class(TFptrFilter)
  private
    FParams: TMalinaParams;
    FFilters: TFptrFilters;
  public
    property Params: TMalinaParams read FParams;
    property Filters: TFptrFilters read FFilters;
  public
    constructor Create(AOwner: TFptrFilters; AParams: TMalinaParams);
    destructor Destroy; override;

    procedure Init(Service: IFptrService; const DeviceName: WideString);

    procedure BeforeZReport; override;
    procedure AfterZReport; override;
    procedure AfterCloseReceipt; override;
    procedure AfterPrintReceipt; override;
    procedure BeforeCloseReceipt; override;
    procedure BeginFiscalReceipt; override;
    procedure BeginFiscalReceipt2(Doc: TCustomReceipt); override;
    procedure EndNonFiscal(Doc: TNonfiscalDoc); override;
    procedure PrintRecTotal; override;

    procedure PrintRecItemBefore(
      var ADescription: WideString; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency;
      const AUnitName: WideString); override;

    procedure PrintRecItemAfter(
      const ADescription: WideString; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency;
      const AUnitName: WideString); override;

    procedure PrintRecItemRefundBefore(
      const Description: WideString;
      Amount: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitAmount: Currency;
      const UnitName: WideString); override;

    procedure PrintRecItemRefundAfter(
      const Description: WideString;
      Amount: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitAmount: Currency;
      const UnitName: WideString); override;

    procedure PrintRecRefundBefore(const Description: WideString;
      Amount: Currency; VatInfo: Integer); override;

    procedure PrintRecRefundAfter(const Description: WideString;
      Amount: Currency; VatInfo: Integer); override;

    procedure SetDeviceEnabled(Value: Boolean); override;
  end;

implementation

{ TMalinaPlugin }

constructor TMalinaPlugin.Create(AOwner: TFptrFilters; AParams: TMalinaParams);
begin
  inherited Create(AOwner);
  FParams := AParams;
  FFilters := TFptrFilters.Create;
end;

destructor TMalinaPlugin.Destroy;
begin
  FFilters.Free;
  inherited Destroy;
end;

procedure TMalinaPlugin.Init(Service: IFptrService; const DeviceName: WideString);
begin
  Params.Load(DeviceName);
  if Params.MalinaFilterEnabled then
    TMalinaFilter.Create(FFilters, Service.Printer);

  if Params.UniposFilterEnabled then
    TUniposFilter.Create(FFilters, Service);

  if Params.FuelRoundEnabled then
    TFuelRecFilter.Create(FFilters, Service.Printer);

  if Params.AntiFroudFilterEnabled then
    TAntiFroudFilter.Create(FFilters, Service);

  TPawnTicketFilter.Create(FFilters, Service.Printer);
  TMalinaZReportFilter.Create(FFilters, Service.Printer, FParams);
end;

procedure TMalinaPlugin.AfterCloseReceipt;
begin
  FFilters.AfterCloseReceipt;
end;

procedure TMalinaPlugin.AfterPrintReceipt;
begin
  FFilters.AfterPrintReceipt;
end;

procedure TMalinaPlugin.BeforeCloseReceipt;
begin
  FFilters.BeforeCloseReceipt;
end;

procedure TMalinaPlugin.BeginFiscalReceipt;
begin
  FFilters.BeginFiscalReceipt;
end;

procedure TMalinaPlugin.BeginFiscalReceipt2(Doc: TCustomReceipt);
begin
  FFilters.BeginFiscalReceipt2(Doc);
end;

procedure TMalinaPlugin.EndNonFiscal(Doc: TNonfiscalDoc);
begin
  FFilters.EndNonFiscal(Doc);
end;

procedure TMalinaPlugin.PrintRecItemAfter(const ADescription: WideString;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const AUnitName: WideString);
begin
  FFilters.PrintRecItemAfter(ADescription, Price, Quantity,
    VatInfo, UnitPrice, AUnitName);
end;

procedure TMalinaPlugin.PrintRecItemBefore(var ADescription: WideString;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const AUnitName: WideString);
begin
  FFilters.PrintRecItemBefore(ADescription, Price, Quantity,
    VatInfo, UnitPrice, AUnitName);
end;

procedure TMalinaPlugin.PrintRecItemRefundAfter(
  const Description: WideString; Amount: Currency; Quantity,
  VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString);
begin
  FFilters.PrintRecItemRefundAfter(Description, Amount, Quantity,
    VatInfo, UnitAmount, UnitName);
end;

procedure TMalinaPlugin.PrintRecItemRefundBefore(
  const Description: WideString; Amount: Currency; Quantity,
  VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString);
begin
  FFilters.PrintRecItemRefundBefore(Description, Amount, Quantity,
    VatInfo, UnitAmount, UnitName);
end;

procedure TMalinaPlugin.PrintRecRefundAfter(const Description: WideString;
  Amount: Currency; VatInfo: Integer);
begin
  FFilters.PrintRecRefundAfter(Description, Amount, VatInfo);
end;

procedure TMalinaPlugin.PrintRecRefundBefore(const Description: WideString;
  Amount: Currency; VatInfo: Integer);
begin
  FFilters.PrintRecRefundBefore(Description, Amount, VatInfo);
end;

procedure TMalinaPlugin.PrintRecTotal;
begin
  FFilters.PrintRecTotal;
end;

procedure TMalinaPlugin.SetDeviceEnabled(Value: Boolean);
begin
  FFilters.SetDeviceEnabled(Value);
end;

procedure TMalinaPlugin.AfterZReport;
begin
  FFilters.AfterZReport;
end;

procedure TMalinaPlugin.BeforeZReport;
begin
  FFilters.BeforeZReport;
end;

end.
