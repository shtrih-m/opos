unit MalinaFilter;

interface

uses
  // VCL
  SysUtils,
  // This
  FiscalPrinterImpl, LogFile, MalinaCard, PrinterTypes, FiscalPrinterTypes,
  NonfiscalDoc, FptrFilter, CustomReceipt, MalinaParams, PrinterParameters,
  StringUtils;

type
  { TDepartmentTotals }

  TDepartmentTotals = record
    Sale: Int64;
    Buy: Int64;
    RetSale: Int64;
    RetBuy: Int64;
  end;

  { TMalinaFilter }

  TMalinaFilter = class(TFptrFilter)
  private
    function GetParameters: TPrinterParameters;
    function GetParams: TMalinaParams;
    function GetLogger: ILogFile;
  private
    FCard: TMalinaCard;
    FPrinter: ISharedPrinter;
    FTotals: TDepartmentTotals;
    FItemCount: TDepartmentTotals;

    property Card: TMalinaCard read FCard;
    property Logger: ILogFile read GetLogger;
    property Params: TMalinaParams read GetParams;
    property Printer: ISharedPrinter read FPrinter;
    property Parameters: TPrinterParameters read GetParameters;
    procedure PrintAmount(const Text: string; Count, Totals: Int64);
  public
    constructor Create(AOwner: TFptrFilters; APrinter: ISharedPrinter);
    destructor Destroy; override;

    procedure BeforeCloseReceipt; override;
    procedure BeforeZReport; override;
    procedure AfterZReport; override;
  end;

implementation

constructor TMalinaFilter.Create(AOwner: TFptrFilters; APrinter: ISharedPrinter);
begin
  inherited Create(AOwner);
  FCard := TMalinaCard.Create(APrinter.Device.Context.Logger);
  FPrinter := APrinter;
end;

destructor TMalinaFilter.Destroy;
begin
  FCard.Free;
  inherited Destroy;
end;

procedure TMalinaFilter.BeforeCloseReceipt;
var
  Mode: Integer;
  Text: string;
  Points: Integer;
  Subtotal: Int64;
begin
	Logger.Debug('TMalinaFilter.EndFiscalReceipt');

  Card.Clear;
  Card.Load(Params.MalinaRegistryKey);
  if Card.CardNumber = '' then
  begin
    Logger.Debug('Malina: Card is empty');
    Exit;
  end;

  Mode := Printer.Device.ReadPrinterStatus.Mode;
  if (Mode <> ECRMODE_RECSELL)and(Mode <> ECRMODE_RECRETSELL) then
  begin
    Logger.Debug('Not sale or sale refund receipt');
    Exit;
  end;

  Subtotal := Printer.Device.GetSubtotal;
  if (Subtotal <> Card.Amount) then
  begin
    Text := Format('Malina: Receipt subtotal <> transaction amount, %d <> %d',
      [Subtotal, Card.Amount]);
    Logger.Debug(Text);
    Exit;
  end;
  // Line "Card number:     8274387246"
  Text := Printer.Device.FormatLines(Params.MalinaCardPrefix,
    Card.CardNumber);
  Printer.PrintText(PRINTER_STATION_REC, Text);
  // Line "---------------------------"
  Text := StringOfChar('-', Printer.Device.GetPrintWidth);
  Printer.PrintText(PRINTER_STATION_REC, Text);
  // Line "Subtotal:           1234.45"
  Text := Format('=%.2f', [subtotal/100]);
  Text := Printer.Device.FormatLines(Parameters.subtotalText, Text);
  Printer.PrintText(PRINTER_STATION_REC, Text);
  // Promo text
  Printer.PrintText(PRINTER_STATION_REC, Params.MalinaPromoText);
  // Malina card number
  Text := Printer.Device.FormatLines(Params.MalinaCardPrefix,
    Card.CardNumber);
  Printer.PrintText(PRINTER_STATION_REC, Text);
  // Malina points
  Points := 0;
  if Params.MalinaCoefficient <> 0 then
    Points := Trunc(subtotal/100/Params.MalinaCoefficient)*Params.MalinaPoints;
  Text := Format(Params.MalinaPointsText, [Points]);
  Printer.PrintText(PRINTER_STATION_REC, Text);
  Printer.PrintText(PRINTER_STATION_REC, ' ');

  Card.Clear;
  Card.Save(Params.MalinaRegistryKey);
end;

procedure TMalinaFilter.BeforeZReport;
var
  Number: Integer;
begin
  Number := 121 + (Params.RosneftItemDepartment-1)*4;
  FTotals.Sale := Printer.Device.ReadCashRegister(Number);
  FTotals.Buy := Printer.Device.ReadCashRegister(Number + 1);
  FTotals.RetSale := Printer.Device.ReadCashRegister(Number + 2);
  FTotals.RetBuy := Printer.Device.ReadCashRegister(Number + 3);

  Number := 72 + (Params.RosneftItemDepartment-1)*4;
  FItemCount.Sale := Printer.Device.ReadOperatingRegister(Number);
  FItemCount.Buy := Printer.Device.ReadOperatingRegister(Number + 1);
  FItemCount.RetSale := Printer.Device.ReadOperatingRegister(Number + 2);
  FItemCount.RetBuy := Printer.Device.ReadOperatingRegister(Number + 3);
end;

procedure TMalinaFilter.PrintAmount(const Text: string; Count, Totals: Int64);
var
  Line1: string;
  Line2: string;
begin
  Line1 := Format('%.4d %s', [Count, Text]);
  Line2 := '=' + AmountToStr(Totals/100);
  Printer.PrintLines(Line1, Line2);
end;

procedure TMalinaFilter.AfterZReport;
begin
  if not Params.RosneftAddTextEnabled then Exit;
  Printer.PrintLines('—≈ ÷»ﬂ', IntToStr(Params.RosneftItemDepartment));
  PrintAmount('œ–»’Œƒ¿', FItemCount.Sale, FTotals.Sale);
  PrintAmount('–¿—’Œƒ¿', FItemCount.Buy, FTotals.Buy);
  PrintAmount('¬Œ«¬–.œ–»’Œƒ¿', FItemCount.RetSale, FTotals.RetSale);
  PrintAmount('¬Œ«¬–.–¿—’Œƒ¿', FItemCount.RetBuy, FTotals.RetBuy);
end;

function TMalinaFilter.GetParameters: TPrinterParameters;
begin
  Result := Printer.Parameters;
end;

function TMalinaFilter.GetParams: TMalinaParams;
begin
  Result := FPrinter.Device.Context.MalinaParams;
end;

function TMalinaFilter.GetLogger: ILogFile;
begin
  Result := FPrinter.Device.Context.Logger;
end;

end.
