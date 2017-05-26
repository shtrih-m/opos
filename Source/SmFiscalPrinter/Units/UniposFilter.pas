unit UniposFilter;

interface

uses
  // VCL
  SysUtils,
  // This
  UniposReader, FiscalPrinterTypes, PrinterTypes, NonfiscalDoc, FptrFilter,
  CustomReceipt, MalinaParams, UniposPrinter;

type
  { TUniposFilter }

  TUniposFilter = class(TFptrFilter)
  private
    function GetParams: TMalinaParams;
  private
    FUnipos: TUniposReader;
    FPrinter: ISharedPrinter;
    FUniposPrinter: TUniposPrinter;

    function ValidTime(Seconds: Integer): Boolean;
    property Params: TMalinaParams read GetParams;
  public
    constructor Create(AOwner: TFptrFilters; APrinter: IFptrService);
    destructor Destroy; override;

    procedure BeginFiscalReceipt; override;
    procedure BeforeCloseReceipt; override;
    procedure AfterCloseReceipt; override;
    procedure AfterPrintReceipt; override;
    procedure SetDeviceEnabled(Value: Boolean); override;

    property UniposPrinter: TUniposPrinter read FUniposPrinter;
  end;

implementation

{ TUniposFilter }

constructor TUniposFilter.Create(AOwner: TFptrFilters; APrinter: IFptrService);
begin
  inherited Create(AOwner);
  FUnipos := TUniposReader.Create(APrinter.Printer.Device.Context.Logger);
  FPrinter := APrinter.Printer;
  FUniposPrinter := TUniposPrinter.Create(APrinter as IFiscalPrinterInternal);
end;

destructor TUniposFilter.Destroy;
begin
  FUnipos.Free;
  FUniposPrinter.Free;
  inherited Destroy;
end;

(*

ƒл€ обработки ситуации перехода в новые сутки необходимо примен€ть
следующий механизм: если текущее значение времени решени€ выводить информацию
или нет, лежит в диапазоне 00:05:01 - 23:59:59, то оно просто переводитс€ в
секунды и сравниваетс€ со значением в ключе. если текущее значение времени
решени€ находитс€ в диапазоне 00:00:00-00:05:00 и значение ключа больше
86400 (что говорит о его задании в предыдущих сутках и необходимости
продлить актуальность на следующие сутки), то необходимо вычесть из значени€
ключа значение 86400 и получить значение актуальности,
с которым проводить сравнение

*)

function GetDaySeconds: Integer;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Now, Hour, Min, Sec, MSec);
  Result := Hour*3600 + Min*60 + Sec;
end;

function TUniposFilter.ValidTime(Seconds: Integer): Boolean;
begin
  Result := GetDayseconds < (Seconds mod 86400);
end;

procedure TUniposFilter.BeginFiscalReceipt;
var
  Font: Integer;
  Block: TTextBlockRec;
begin
  Block := FUnipos.ReadHeaderBlock;
  if ValidTime(Block.SecondsOfDay) then
  begin
    if Block.Text <> '' then
    begin
      Font := Params.UniposHeaderFont;
      FPrinter.Device.PrintTextFont(PRINTER_STATION_REC, Font, Block.Text);
    end;
  end;

  Block.Text := '';
  FUnipos.WriteHeaderBlock(Block);
end;

procedure TUniposFilter.AfterPrintReceipt;
var
  Font: Integer;
  Block: TTextBlockRec;
begin
  Block := FUnipos.ReadTrailerBlock;
  if ValidTime(Block.SecondsOfDay) then
  begin
    if Block.Text <> '' then
    begin
      Font := Params.UniposTrailerFont;
      FPrinter.Device.PrintTextFont(PRINTER_STATION_REC, Font, Block.Text);
    end;
  end;
  Block.Text := '';
  FUnipos.WriteTrailerBlock(Block);
end;

procedure TUniposFilter.BeforeCloseReceipt;
begin
end;

procedure TUniposFilter.AfterCloseReceipt;
begin
  FUnipos.ReportSuccessfullPrint;
end;

procedure TUniposFilter.SetDeviceEnabled(Value: Boolean);
begin
  inherited SetDeviceEnabled(Value);
  if Value then
    UniposPrinter.Start
  else
    UniposPrinter.Stop;
end;

function TUniposFilter.GetParams: TMalinaParams;
begin
  Result := FPrinter.Device.Context.MalinaParams;
end;

end.
