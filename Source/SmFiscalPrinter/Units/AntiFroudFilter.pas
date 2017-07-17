unit AntiFroudFilter;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Registry,
  // Opos
  Opos, OposHi, OposFptr, OposFptrHi, OposException,
  // This
  FptrFilter, FiscalPrinterTypes, NonfiscalDoc, CustomReceipt,
  PrinterTypes, LogFile, UniposReader, MalinaParams;

type

  { TAntiFroudFilter }

  TAntiFroudFilter = class(TFptrFilter)
  private
    function GetParams: TMalinaParams;
    function GetLogger: ILogFile;
  private
    FReader: TUniposReader;
    function ValidReceiptFlags: Boolean;
    function GetPrinter: ISharedPrinter;
    function IsSpecialItem(const Description: string): Boolean;
    function ExcludePrefix(const Description: string): string;

    procedure PrintInfoReceipt;
    procedure Check(ResultCode: Integer);
    procedure CheckRefundReceipt(const Description: WideString);
    procedure CancelReceipt2;

    property Logger: ILogFile read GetLogger;
    property Params: TMalinaParams read GetParams;
  private
    FItemCount: Integer;
    FService: IFptrService;
    FHasSpecialItem: Boolean;
  public
    procedure CheckSpecialItem(const ADescription: WideString);
    property Printer: ISharedPrinter read GetPrinter;
  public
    constructor Create(AOwner: TFptrFilters; AService: IFptrService);
    destructor Destroy; override;

    procedure BeginFiscalReceipt; override;

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

    procedure PrintRecRefundBefore(
      const Description: WideString;
      Amount: Currency; VatInfo: Integer); override;

  end;

implementation

function GetDaySeconds: Integer;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Now, Hour, Min, Sec, MSec);
  Result := Hour*3600 + Min*60 + Sec;
end;

function ValidTime(Seconds: Integer): Boolean;
begin
  Result := GetDayseconds < (Seconds mod 86400);
end;

{ TAntiFroudFilter }

constructor TAntiFroudFilter.Create(AOwner: TFptrFilters;
  AService: IFptrService);
begin
  inherited Create(AOwner);
  FReader := TUniposReader.Create(AService.Printer.Device.Context.Logger);
  FService := AService;
end;

destructor TAntiFroudFilter.Destroy;
begin
  FReader.Free;
  inherited Destroy;
end;

function TAntiFroudFilter.GetParams: TMalinaParams;
begin
  Result := FService.Printer.Device.Context.MalinaParams;
end;


function TAntiFroudFilter.GetPrinter: ISharedPrinter;
begin
  Result := FService.Printer;
end;

(*

  ¬ чеке продажи специальные товары должны идти единственной позицией
  (нельз€ смешивать с продажей других специальных или обычных товаров,
  а также с топливом). ѕри несоблюдении данного правила POS'ом, драйвер
  должен предотвратить продажу (вернуть POS признак ошибки дл€ блокировки
  такой продажи и распечатать нефискальный чек, по€сн€ющий причину -
  "ѕополнение или перевод денег в составе смешанной продажи");

*)

procedure TAntiFroudFilter.PrintRecItemBefore(
  var ADescription: WideString; Price: Currency;
  Quantity, VatInfo: Integer; UnitPrice: Currency;
  const AUnitName: WideString);
begin
  CheckSpecialItem(ADescription);
  ADescription := ExcludePrefix(ADescription);
end;

function TAntiFroudFilter.ExcludePrefix(const Description: string): string;
var
  Prefix: string;
begin
  Prefix := Params.UniposUniqueItemPrefix;
  Result := StringReplace(Description, Prefix, '', [rfIgnoreCase]);
end;

function TAntiFroudFilter.IsSpecialItem(const Description: string): Boolean;
var
  Prefix: string;
begin
  Prefix := Params.UniposUniqueItemPrefix;
  Result := Pos(Prefix, TrimLeft(Description)) = 1;
end;

function TAntiFroudFilter.ValidReceiptFlags: Boolean;
var
  Flags: TReceiptFlagsRec;
begin
  Flags := FReader.ReadReceiptFlags;
  Result := Flags.Enabled and ValidTime(Flags.Seconds);
end;

procedure TAntiFroudFilter.CheckSpecialItem(const ADescription: WideString);
begin
  if FHasSpecialItem then
  begin
    CancelReceipt2;
  end;

  if IsSpecialItem(ADescription) then
  begin
    if FItemCount > 0 then
    begin
      Logger.Debug('TAntiFroudFilter.CheckSpecialItem: ItemCount > 0');
    end;

    if not ValidReceiptFlags then
    begin
      Logger.Debug('TAntiFroudFilter.CheckSpecialItem: not ValidReceiptFlags');
    end;

    if (FItemCount > 0)or(not ValidReceiptFlags) then
    begin
      CancelReceipt2;
    end;
    FReader.ClearReceiptFlags;
    FHasSpecialItem := True;
  end;
end;

procedure TAntiFroudFilter.CancelReceipt2;
begin
  FService.CancelReceipt2;
  FService.SetPrinterState(FPTR_PS_MONITOR);
  PrintInfoReceipt;

  raise Exception.Create(Params.UniposSalesErrorText);
end;

procedure TAntiFroudFilter.Check(ResultCode: Integer);
var
  ErrorString: WideString;
  ResultCodeExtended: Integer;
begin
  if ResultCode <> OPOS_SUCCESS then
  begin
    ErrorString := FService.GetPropertyString(PIDXFptr_ErrorString);
    ResultCodeExtended := FService.GetPropertyNumber(PIDX_ResultCodeExtended);
    raiseOposException(ResultCode, ResultCodeExtended, ErrorString);
  end;
end;

procedure TAntiFroudFilter.PrintInfoReceipt;
var
  Text: string;
begin
  Text := Params.UniposSalesErrorText;
  Check(FService.BeginNonFiscal);
  Check(FService.PrintNormal(FPTR_S_RECEIPT, Text));
  Check(FService.EndNonFiscal);
end;

procedure TAntiFroudFilter.PrintRecItemAfter(
  const ADescription: WideString; Price: Currency; Quantity,
  VatInfo: Integer; UnitPrice: Currency; const AUnitName: WideString);
begin
  Inc(FItemCount);
end;

procedure TAntiFroudFilter.BeginFiscalReceipt;
begin
  FItemCount := 0;
  FHasSpecialItem := False;
end;

(*******************************************************************************

  ƒрайвер ‘– ведет контроль наименовани€ товаров в чеке возвратов.
  ≈сли наименование товара содержит вышеописанный префикс - то печать
  такого чека возврата необходимо запретить, вернуть кассе ошибку,
  ведущую к невозможности закрыти€ такого чека.

  ‘искальный регистратор печатает информационное сообщение
  .

*******************************************************************************)

procedure TAntiFroudFilter.PrintRecItemRefundBefore(
  const Description: WideString; Amount: Currency; Quantity,
  VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString);
begin
  CheckRefundReceipt(Description);
end;

procedure TAntiFroudFilter.PrintRecRefundBefore(
  const Description: WideString; Amount: Currency; VatInfo: Integer);
begin
  CheckRefundReceipt(Description);
end;

procedure TAntiFroudFilter.CheckRefundReceipt(const Description: WideString);
var
  Text: string;
begin
  if IsSpecialItem(Description) then
  begin
    Logger.Debug('Special item prohibited in refund receipt');

    FService.CancelReceipt2;
    FService.SetPrinterState(FPTR_PS_MONITOR);

    Text := Params.UniposRefundErrorText;
    Check(FService.BeginNonFiscal);
    Check(FService.PrintNormal(FPTR_S_RECEIPT, Text));
    Check(FService.EndNonFiscal);

    raise Exception.Create(Params.UniposRefundErrorText);
  end;
end;

function TAntiFroudFilter.GetLogger: ILogFile;
begin
  Result := FService.Printer.Device.Context.Logger;
end;

end.
