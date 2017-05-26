unit SharedPrinterInterface;

interface

uses
  // This
  PrinterTypes, FiscalPrinterDevice, FiscalPrinterTypes, PrinterParameters,
  FixedStrings, NotifyLink;

type
  { ISharedPrinter }

  ISharedPrinter = interface
    ['{91F29940-3969-474C-B6E5-6237FE2FC34C}']

    procedure Open(const DeviceName: string);
    procedure ReleaseDevice;
    procedure ClaimDevice(Timeout: Integer);

    procedure Connect;
    procedure CutPaper;
    procedure Disconnect;
    procedure ReadTables;
    procedure UpdateStatus;
    procedure SaveParameters;
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
    procedure SetCheckTotal(const Value: Boolean);
    procedure LoadLogo(const FileName: string);
    procedure PrintImage(const FileName: string);
    procedure SetOnProgress(const Value: TProgressEvent);
    procedure PrintSeparator(SeparatorType, SeparatorHeight: Integer);

    function GetHeader: TFixedStrings;
    function GetTrailer: TFixedStrings;
    function GetPrinterStatus: TPrinterStatus;
    function IsReceiptOpened: Boolean;
    function GetDeviceName: string;
    function GetDevice: IFiscalPrinterDevice;
    function GetCheckTotal: Boolean;
    function GetOnProgress: TProgressEvent;
    function GetPollEnabled: Boolean;
    procedure SetPollEnabled(const Value: Boolean);
    function GetStatus: TPrinterStatus;
    procedure AddStatusLink(Link: TNotifyLink);
    procedure AddConnectLink(Link: TNotifyLink);
    procedure RemoveStatusLink(Link: TNotifyLink);
    function GetStation: Integer;
    procedure SetStation(Value: Integer);
    function GetPostLine: string;
    function GetPreLine: string;
    procedure SetPostLine(const Value: string);
    procedure SetPreLine(const Value: string);
    procedure PrintLogo;
    function GetNumHeaderLines: Integer;
    function GetNumTrailerLines: Integer;
    function GetDeviceMetrics: TDeviceMetrics;
    function GetLongPrinterStatus: TLongPrinterStatus;
    function GetEJStatus1: TEJStatus1;
    function GetEJActivation: TEJActivation;
    function CurrencyToInt(Value: Currency): Int64;
    function IntToCurrency(Value: Int64): Currency;
    function IsDecimalPoint: Boolean;
    function CurrencyToStr(Value: Currency): string;
    procedure UpdateParams;

    property DeviceName: string read GetDeviceName;
    property Header: TFixedStrings read GetHeader;
    property Trailer: TFixedStrings read GetTrailer;
    property PrintWidth: Integer read GetPrintWidth;
    property Device: IFiscalPrinterDevice read GetDevice;
    property PrintWidthInDots: Integer read GetPrintWidthInDots;
    property CheckTotal: Boolean read GetCheckTotal write SetCheckTotal;
    property OnProgress: TProgressEvent read GetOnProgress write SetOnProgress;
    property PollEnabled: Boolean read GetPollEnabled write SetPollEnabled;
    property Status: TPrinterStatus read GetStatus;
    property Station: Integer read GetStation write SetStation;
    property PreLine: string read GetPreLine write SetPreLine;
    property PostLine: string read GetPostLine write SetPostLine;
    property NumHeaderLines: Integer read GetNumHeaderLines;
    property NumTrailerLines: Integer read GetNumTrailerLines;
    property DeviceMetrics: TDeviceMetrics read GetDeviceMetrics;
    property LongPrinterStatus: TLongPrinterStatus read GetLongPrinterStatus;
    property EJStatus1: TEJStatus1 read GetEJStatus1;
    property EJActivation: TEJActivation read GetEJActivation;
  end;

  { ISharedPrinterFactory }

  ISharedPrinterFactory = interface
    function CreateObject: ISharedPrinter;
  end;

implementation

end.
