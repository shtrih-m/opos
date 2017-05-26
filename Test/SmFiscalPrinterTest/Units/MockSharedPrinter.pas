unit MockSharedPrinter;

interface

uses
  // This
  SharedPrinterInterface, PrinterTypes, FiscalPrinterTypes, PrinterParameters,
  FixedStrings, NotifyLink, PrinterConnection;

type
  { TMockSharedPrinter }

  TMockSharedPrinter = class(TInterfacedObject, ISharedPrinter)
  private
    FDevice: IFiscalPrinterDevice;
  public
    constructor Create(ADevice: IFiscalPrinterDevice);

    procedure Close;
    procedure Open(const DeviceName: string);
    procedure ReleaseDevice;
    procedure ClaimDevice(Timeout: Integer);
    procedure SetDevice(Value: IFiscalPrinterDevice);

    procedure Connect;
    procedure CutPaper;
    procedure Disconnect;
    procedure CheckEnabled;
    procedure PrintDocHeaderEnd;
    procedure SaveParameters;
    procedure ReadTables;
    function GetPrintWidth: Integer;
    function GetPrintWidthInDots: Integer;
    function WaitForPrinting: TPrinterStatus;
    procedure PrintCancelReceipt;
    procedure PrintCurrency(const Line: string; Value: Currency);
    procedure PrintDocHeader(const DocName: string; DocNumber: Word);
    procedure PrintFakeReceipt;
    procedure PrintLine(Stations: Integer; const Line: string);
    procedure PrintLines(const Line1, Line2: string);
    procedure PrintRecText(const Text: string);

    procedure PrintText(const Text: string); overload;
    procedure PrintText(Station: Integer; const Text: string); overload;
    procedure PrintText(const Text: string; Station: Integer;
      Font: Integer; Alignment: TTextAlignment); overload;

    procedure Check(Value: Integer);
    function FormatBoldLines(const Line1, Line2: string): string;
    procedure PrintBoldString(Flags: Byte; const Text: string);
    procedure PrintZReport;
    procedure ReceiptCancel;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure Sale(Operation: TPriceReg);
    procedure Buy(Operation: TPriceReg);
    procedure RetBuy(Operation: TPriceReg);
    procedure Storno(Operation: TPriceReg);
    procedure RetSale(Operation: TPriceReg);
    procedure ReceiptClose(Params: TCloseReceiptParams);
    procedure ReceiptDiscount(Operation: TAmountOperation);
    procedure ReceiptCharge(Operation: TAmountOperation);
    procedure ReceiptStornoDiscount(Operation: TAmountOperation);
    procedure ReceiptStornoCharge(Operation: TAmountOperation);
    procedure PrintSubtotal(Value: Int64);
    procedure WriteLogParameters;
    function GetDeviceName: string;
    function GetDevice: IFiscalPrinterDevice;
    function GetParameters: TPrinterParameters;
    function GetCheckTotal: Boolean;
    procedure SetCheckTotal(const Value: Boolean);
    function GetHeader: TFixedStrings;
    function GetTrailer: TFixedStrings;
    function GetAdditionalTrailer: string;
    function GetPrinterStatus: TPrinterStatus;
    procedure SetAdditionalTrailer(const Value: string);
    function IsReceiptOpened: Boolean;
    procedure LoadLogo(const FileName: string);
    procedure SetOnProgress(const Value: TProgressEvent);
    function GetOnProgress: TProgressEvent;
    function GetPollEnabled: Boolean;
    procedure SetPollEnabled(const Value: Boolean);
    function GetStatus: TPrinterStatus;
    procedure AddStatusLink(Link: TNotifyLink);
    procedure AddConnectLink(Link: TNotifyLink);
    procedure RemoveStatusLink(Link: TNotifyLink);
    function GetIsOnline: Boolean;
    function GetStation: Integer;
    procedure SetStation(Value: Integer);
    function GetPostLine: string;
    function GetPreLine: string;
    procedure SetPostLine(const Value: string);
    procedure SetPreLine(const Value: string);
    function PrintBarLine(Height: Word; Data: string): Integer;
    procedure PrintLogo;
    procedure PrintSeparator(SeparatorType, SeparatorHeight: Integer);
    function GetNumHeaderLines: Integer;
    function GetNumTrailerLines: Integer;
    procedure UpdateParams;
    function GetDeviceMetrics: TDeviceMetrics;
    function GetLongPrinterStatus: TLongPrinterStatus;
    function GetEJStatus1: TEJStatus1;
    function GetEJActivation: TEJActivation;
    procedure UpdateStatus;
    function IsDecimalPoint: Boolean;
    function IntToCurrency(Value: Int64): Currency;
    function CurrencyToInt(Value: Currency): Int64;
    function CurrencyToStr(Value: Currency): string;
    procedure PrintImage(const FileName: string);
    procedure PrintImageScale(const FileName: string; Scale: Integer);

    procedure ReleasePrinter;
    procedure ClaimPrinter(Timeout: Integer);
    function GetPrinterSemaphoreName: string;
    function GetConnection: IPrinterConnection;
    procedure SetConnection(const Value: IPrinterConnection);
    procedure SetDeviceName(const Value: string);

    property DeviceName: string read GetDeviceName;
    property Header: TFixedStrings read GetHeader;
    property Trailer: TFixedStrings read GetTrailer;
    property PrintWidth: Integer read GetPrintWidth;
    property Device: IFiscalPrinterDevice read GetDevice;
    property Parameters: TPrinterParameters read GetParameters;
    property CheckTotal: Boolean read GetCheckTotal write SetCheckTotal;
    property AdditionalTrailer: string read GetAdditionalTrailer write SetAdditionalTrailer;
  end;

implementation

{ TMockSharedPrinter }

constructor TMockSharedPrinter.Create(ADevice: IFiscalPrinterDevice);
begin
  inherited Create;
  FDevice := ADevice;
end;

procedure TMockSharedPrinter.CashIn(Amount: Int64);
begin

end;

procedure TMockSharedPrinter.CashOut(Amount: Int64);
begin

end;

procedure TMockSharedPrinter.Check(Value: Integer);
begin

end;

procedure TMockSharedPrinter.CheckEnabled;
begin

end;

procedure TMockSharedPrinter.ClaimDevice(Timeout: Integer);
begin

end;

procedure TMockSharedPrinter.Connect;
begin

end;

procedure TMockSharedPrinter.CutPaper;
begin

end;

procedure TMockSharedPrinter.Disconnect;
begin

end;

function TMockSharedPrinter.FormatBoldLines(const Line1,
  Line2: string): string;
begin

end;

function TMockSharedPrinter.GetAdditionalTrailer: string;
begin

end;

function TMockSharedPrinter.GetCheckTotal: Boolean;
begin
  result := False;
end;

function TMockSharedPrinter.GetDevice: IFiscalPrinterDevice;
begin
  Result := FDevice;
end;

function TMockSharedPrinter.GetDeviceName: string;
begin

end;

function TMockSharedPrinter.GetHeader: TFixedStrings;
begin
  Result := nil;
end;

function TMockSharedPrinter.GetPrinterStatus: TPrinterStatus;
begin

end;

function TMockSharedPrinter.GetPrintWidth: Integer;
begin
  Result := 0;
end;

function TMockSharedPrinter.GetPrintWidthInDots: Integer;
begin
  Result := 0;
end;

function TMockSharedPrinter.GetParameters: TPrinterParameters;
begin
  Result := nil;
end;

function TMockSharedPrinter.GetTrailer: TFixedStrings;
begin
  Result := nil;
end;

function TMockSharedPrinter.IsReceiptOpened: Boolean;
begin
  Result := False;
end;

procedure TMockSharedPrinter.Open(const DeviceName: string);
begin

end;

procedure TMockSharedPrinter.PrintBoldString(Flags: Byte;
  const Text: string);
begin

end;

procedure TMockSharedPrinter.PrintCancelReceipt;
begin

end;

procedure TMockSharedPrinter.PrintCurrency(const Line: string;
  Value: Currency);
begin

end;

procedure TMockSharedPrinter.PrintDocHeader(const DocName: string;
  DocNumber: Word);
begin

end;

procedure TMockSharedPrinter.PrintDocHeaderEnd;
begin

end;

procedure TMockSharedPrinter.PrintFakeReceipt;
begin

end;

procedure TMockSharedPrinter.PrintLine(Stations: Integer;
  const Line: string);
begin

end;

procedure TMockSharedPrinter.PrintLines(const Line1, Line2: string);
begin

end;

procedure TMockSharedPrinter.PrintRecText(const Text: string);
begin

end;

procedure TMockSharedPrinter.PrintSubtotal(Value: Int64);
begin

end;

procedure TMockSharedPrinter.PrintText(const Text: string);
begin

end;

procedure TMockSharedPrinter.PrintText(const Text: string;
  Station, Font: Integer; Alignment: TTextAlignment);
begin

end;

procedure TMockSharedPrinter.PrintZReport;
begin

end;

procedure TMockSharedPrinter.ReceiptCancel;
begin

end;

procedure TMockSharedPrinter.ReceiptCharge(Operation: TAmountOperation);
begin

end;

procedure TMockSharedPrinter.ReceiptClose(Params: TCloseReceiptParams);
begin

end;

procedure TMockSharedPrinter.ReceiptDiscount(Operation: TAmountOperation);
begin

end;

procedure TMockSharedPrinter.ReceiptStornoCharge(
  Operation: TAmountOperation);
begin

end;

procedure TMockSharedPrinter.ReceiptStornoDiscount(
  Operation: TAmountOperation);
begin

end;

procedure TMockSharedPrinter.ReleaseDevice;
begin

end;

procedure TMockSharedPrinter.RetSale(Operation: TPriceReg);
begin

end;

procedure TMockSharedPrinter.Sale(Operation: TPriceReg);
begin

end;

procedure TMockSharedPrinter.SetAdditionalTrailer(const Value: string);
begin

end;

procedure TMockSharedPrinter.SetCheckTotal(const Value: Boolean);
begin

end;

procedure TMockSharedPrinter.Storno(Operation: TPriceReg);
begin

end;

function TMockSharedPrinter.WaitForPrinting: TPrinterStatus;
begin

end;

procedure TMockSharedPrinter.WriteLogParameters;
begin

end;

procedure TMockSharedPrinter.Buy(Operation: TPriceReg);
begin

end;

procedure TMockSharedPrinter.RetBuy(Operation: TPriceReg);
begin

end;

procedure TMockSharedPrinter.SaveParameters;
begin

end;

function TMockSharedPrinter.GetOnProgress: TProgressEvent;
begin

end;

procedure TMockSharedPrinter.LoadLogo(const FileName: string);
begin

end;

procedure TMockSharedPrinter.SetOnProgress(const Value: TProgressEvent);
begin

end;

procedure TMockSharedPrinter.ReadTables;
begin
  { !!! }
end;

procedure TMockSharedPrinter.AddStatusLink(Link: TNotifyLink);
begin

end;

function TMockSharedPrinter.GetPollEnabled: Boolean;
begin
  Result := True;
end;

function TMockSharedPrinter.GetIsOnline: Boolean;
begin
  Result := True;
end;

function TMockSharedPrinter.GetStatus: TPrinterStatus;
begin

end;

procedure TMockSharedPrinter.RemoveStatusLink(Link: TNotifyLink);
begin

end;

procedure TMockSharedPrinter.SetPollEnabled(const Value: Boolean);
begin

end;

function TMockSharedPrinter.GetStation: Integer;
begin
  Result := 0;
end;

function TMockSharedPrinter.GetPostLine: string;
begin

end;

function TMockSharedPrinter.GetPreLine: string;
begin

end;

procedure TMockSharedPrinter.SetPostLine(const Value: string);
begin

end;

procedure TMockSharedPrinter.SetPreLine(const Value: string);
begin

end;

procedure TMockSharedPrinter.SetStation(Value: Integer);
begin

end;

function TMockSharedPrinter.PrintBarLine(Height: Word;
  Data: string): Integer;
begin
  Result := 0;
end;

procedure TMockSharedPrinter.PrintLogo;
begin

end;

procedure TMockSharedPrinter.PrintSeparator(SeparatorType,
  SeparatorHeight: Integer);
begin

end;

function TMockSharedPrinter.GetNumHeaderLines: Integer;
begin
  Result := 4;
end;

function TMockSharedPrinter.GetNumTrailerLines: Integer;
begin
  Result := 4;
end;

procedure TMockSharedPrinter.UpdateParams;
begin

end;

function TMockSharedPrinter.GetDeviceMetrics: TDeviceMetrics;
begin

  end;

function TMockSharedPrinter.GetEJActivation: TEJActivation;
begin

end;

function TMockSharedPrinter.GetEJStatus1: TEJStatus1;
begin

end;

function TMockSharedPrinter.GetLongPrinterStatus: TLongPrinterStatus;
begin

end;

procedure TMockSharedPrinter.UpdateStatus;
begin

end;

procedure TMockSharedPrinter.AddConnectLink(Link: TNotifyLink);
begin

end;

function TMockSharedPrinter.CurrencyToInt(Value: Currency): Int64;
begin
  Result := 0;
end;

function TMockSharedPrinter.CurrencyToStr(Value: Currency): string;
begin
  Result := '';
end;

function TMockSharedPrinter.IntToCurrency(Value: Int64): Currency;
begin
  Result := 0;
end;

function TMockSharedPrinter.IsDecimalPoint: Boolean;
begin
  Result := False;
end;

procedure TMockSharedPrinter.PrintImage(const FileName: string);
begin

end;

procedure TMockSharedPrinter.PrintText(Station: Integer;
  const Text: string);
begin

end;

procedure TMockSharedPrinter.ClaimPrinter(Timeout: Integer);
begin

end;

function TMockSharedPrinter.GetPrinterSemaphoreName: string;
begin

end;

procedure TMockSharedPrinter.ReleasePrinter;
begin

end;

procedure TMockSharedPrinter.SetDevice(Value: IFiscalPrinterDevice);
begin

end;

procedure TMockSharedPrinter.PrintImageScale(const FileName: string;
  Scale: Integer);
begin

end;

function TMockSharedPrinter.GetConnection: IPrinterConnection;
begin

end;

procedure TMockSharedPrinter.SetConnection(
  const Value: IPrinterConnection);
begin

end;

procedure TMockSharedPrinter.SetDeviceName(const Value: string);
begin

end;

procedure TMockSharedPrinter.Close;
begin

end;

end.
