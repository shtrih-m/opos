unit FiscalPrinterDevice;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Variants, SyncObjs, Graphics, Math,
  // 3'd
  // to enable loading this image formats
  JvGIF, JvPCX, PngImage, uZintBarcode, uZintInterface,
  // Opos
  OposMessages, OposException, OposFptr, OposFptrHi, OposUtils, OposFptrUtils,
  // This
  PrinterCommand, PrinterFrame, PrinterTypes, BinStream, StringUtils,
  SerialPort, PrinterTable, LogFile, ByteUtils, FiscalPrinterTypes,
  DeviceTables, PrinterModel, XmlModelReader, PrinterConnection,
  CommunicationError, VersionInfo, DefaultModel, DriverTypes,
  TableParameter, DebugUtils, ClassLogger, DriverError,
  FiscalPrinterStatistics, ParameterValue, EJReportParser,
  PrinterParameters, DirectIOAPI, FileUtils,
  PrinterDeviceFilter, TLV, CsvPrinterTableFormat, MalinaParams, DriverContext;

type
  { TFiscalPrinterDevice }

  TFiscalPrinterDevice = class(TInterfacedObject, IFiscalPrinterDevice)
  private
    FContext: TDriverContext;
    FCapBarLine: Boolean;
    FCapDrawScale: Boolean;
    FCapBarcode2D: Boolean;
    FCapGraphics1: Boolean;
    FCapGraphics2: Boolean;
    FCapGraphics3: Boolean;
    FCapFiscalStorage: Boolean;
    FCapOpenReceipt: Boolean;
    FCapReceiptDiscount2: Boolean;
    FCapFontInfo: Boolean;
    FDiscountMode: Integer;
    FIsFiscalized: Boolean;

    FIsOnline: Boolean;
    FResultCode: Integer;
    FResultText: string;
    FLogger: TClassLogger;
    FTaxPassword: DWORD;        // tax officer password
    FSysPassword: DWORD;        // system administrator password
    FUsrPassword: DWORD;        // regular user password
    FModel: TPrinterModel;
    FModelData: TPrinterModelRec;
    FTables: TPrinterTables;
    FFields: TPrinterFields;
    FModels: TPrinterModels;
    FOnCommand: TCommandEvent;
    FDeviceTables: TDeviceTables;
    FConnection: IPrinterConnection;
    FValidDeviceMetrics: Boolean;
    FDeviceMetrics: TDeviceMetrics;
    FLock: TCriticalSection;
    FStatistics: TFiscalPrinterStatistics;
    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FFilter: TFiscalPrinterFilter;
    FAmountDecimalPlaces: Integer;
    FOnProgress: TProgressEvent;
    FLongPrinterStatus: TLongPrinterStatus;
    FFontInfo: array [1..10] of TFontInfo;
    FTaxInfo: array [1..6] of TTaxInfo;

    procedure WriteLogModelParameters(const Model: TPrinterModelRec);
    procedure PrintLineFont(const Data: TTextRec);

    function GetModelsFileName: string;
    function SelectModel: TPrinterModel;
    function GetPrinterModel: TPrinterModel;
    function GetDeviceMetrics: TDeviceMetrics;
    function MinProtocolVersion(V1, V2: Integer): Boolean;
    function CenterLine(const Line: string): string;
    function AlignLine(const Line: string; PrintWidth: Integer;
      Alignment: TTextAlignment = taLeft): string;
    procedure SplitText(const Text: string; Font: Integer;
      Lines: TStrings);
    function ValidFieldValue(const FieldInfo: TPrinterFieldRec;
      const FieldValue: string): Boolean;
    function GetStatistics: TFiscalPrinterStatistics;
    function GetResultCode: Integer;
    function GetResultText: string;
    function ReadEJActivationText(MaxCount: Integer): string;
    function GetIsOnline: Boolean;
    function GetOnConnect: TNotifyEvent;
    function GetOnDisconnect: TNotifyEvent;
    procedure SetOnConnect(const Value: TNotifyEvent);
    procedure SetOnDisconnect(const Value: TNotifyEvent);
    procedure SetIsOnline(Value: Boolean);
    procedure OpenDay;
    procedure UpdateDepartment(var P: TPriceReg);
    procedure CheckGraphicsSize(Line: Word);
    function GetAmountDecimalPlaces: Integer;
    procedure SetAmountDecimalPlaces(const Value: Integer);
    procedure PrintBarcodeZInt(const Barcode: TBarcodeRec);
    function DrawScale(const P: TDrawScale): Integer;
    function Is1DBarcode(Symbology: Integer): Boolean;
    procedure LoadBitmap(StartLine: Integer; Bitmap: TBitmap);
    function GetLineData(Bitmap: TBitmap; Index: Integer): string;
    procedure ProgressEvent(Progress: Integer);
    function Is2DBarcode(Symbology: Integer): Boolean;
    procedure Connect;
    function WaitForPrinting: TPrinterStatus;
    function GetPrinterStatus: TPrinterStatus;
    procedure AlignBitmap(Bitmap: TBitmap; const Barcode: TBarcodeRec;
      HScale: Integer; PrintWidthInDots: Integer);
    function PrintBarcode2D(const Barcode: TBarcode2D): Integer;
    function LoadBarcode2D(const Data: TBarcode2DData): Integer;
    function PrintQRCode2D(const Barcode: TBarcodeRec): Integer;
    function GetMaxGraphicsHeight: Integer;
    function GetMaxGraphicsWidth: Integer;
    procedure LoadBitmap320(StartLine: Integer; Bitmap: TBitmap);
    procedure LoadBitmap512(StartLine: Integer; Bitmap: TBitmap;
      Scale: Integer);
    function TestCommand(Code: Integer): Boolean;
    function ReadEJDocumentText(MACNumber: Integer): string;
    function ReadEJDocument(MACNumber: Integer; var Line: string): Integer;
    function ParseEJDocument(const Text: string): TEJDocument;
    function FSSale(const P: TFSSale): Integer;
    function FSStorno(const P: TFSSale): Integer;
    function ProcessLine(const Line: string): Boolean;
    function FSReadStatus(var R: TFSStatus): Integer;
    function FSFindDocument(DocNumber: Integer; var R: TFSDocument): Integer;
    function FSReadDocMac(var DocMac: Int64): Integer;

    function FSReadBlock(const P: TFSBlockRequest;
      var Block: string): Integer;
    function FSStartWrite(DataSize: Word; var BlockSize: Byte): Integer;
    function FSWriteBlock(const Block: TFSBlock): Integer;
    function FSReadBlockData: string;
    procedure FSWriteBlockData(const BlockData: string);
    function FSReadState(var R: TFSState): Integer;
    function ReadCapFiscalStorage: Boolean;
    function GetErrorText(Code: Integer): string;
    function OpenFiscalDay: Boolean;
    function GetCapFiscalStorage: Boolean;
    function GetCapOpenReceipt: Boolean;
    function GetCapReceiptDiscount2: Boolean;
    procedure PrintCommStatus;
    procedure WriteFPParameter(ParamId: Integer; const Value: string);
    function GetDiscountMode: Integer;
    function GetIsFiscalized: Boolean;
    function ReadDayTotalsByReceiptType(Index: Integer): Int64;
    function ReadFPTotals(Flags: Integer): TFMTotals;
    function ReadDayTotals: TFMTotals;
    function LoadPicture(Picture: TPicture; StartLine: Integer): Integer;

    procedure PrintString(Stations: Byte; const Line: string);
    procedure WriteFields(Table: TPrinterTable);
    function FSReadTicket(var R: TFSTicket): Integer;
    function GetLogger: TLogFile;
    function GetMalinaParams: TMalinaParams;
    function GetMaxGraphicsWidthInBytes: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure Unlock;
    procedure FullCut;
    procedure StopDump;
    procedure PartialCut;
    procedure LoadModels;
    procedure SaveModels;
    procedure ReadModelParameters;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure SetLongSerial(Serial: Int64);
    procedure SetSysPassword(const Value: DWORD);
    procedure SetTaxPassword(const Value: DWORD);
    procedure SetUsrPassword(const Value: DWORD);
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);

    function Beep: Integer;
    function GetDumpBlock: TDumpBlock;
    function GetLongSerial: TGetLongSerial;
    function GetLongStatus: TLongPrinterStatus;
    function GetFMFlags(Flags: Byte): TFMFlags;
    function GetShortStatus: TShortPrinterStatus;
    function StartDump(DeviceCode: Integer): Integer;
    function PrintBoldString(Flags: Byte; const Text: string): Integer;
    function GetPortParams(Port: Byte): TPortParams;
    function SetPortParams(Port: Byte; const PortParams: TPortParams): Integer;
    procedure PrintDocHeader(const DocName: string; DocNumber: Word);
    procedure StartTest(Interval: Byte);
    function ReadCashRegister(ID: Byte): Int64;
    function ReadCashReg(ID: Byte; var R: TCashRegisterRec): Integer;
    function ReadOperatingRegister(ID: Byte): Word;
    function ReadOperatingReg(ID: Byte; var R: TOperRegisterRec): Integer;
    procedure WriteLicense(License: Int64);
    function ReadLicense: Int64;
    function WriteTable(Table, Row, Field: Integer; const FieldValue: string): Integer;
    function WriteTableInt(Table, Row, Field, Value: Integer): Integer;
    function DoWriteTable(Table, Row, Field: Integer;
      const FieldValue: string): Integer;
    function ReadTableBin(Table, Row, Field: Integer): string;
    function ReadTableStr(Table, Row, Field: Integer): string;
    function ReadTableInt(Table, Row, Field: Integer): Integer;
    procedure SetPointPosition(PointPosition: Byte);
    procedure SetTime(const Time: TPrinterTime);
    procedure SetDate(const Date: TPrinterDate);
    procedure ConfirmDate(const Date: TPrinterDate);
    procedure InitializeTables;
    procedure CutPaper(CutType: Byte);
    function ReadFontInfo(FontNumber: Byte): TFontInfo;
    procedure ResetFiscalMemory;
    procedure ResetTotalizers;
    procedure OpenDrawer(DrawerNumber: Byte);
    procedure FeedPaper(Station: Byte; Lines: Byte);
    procedure EjectSlip(Direction: Byte);
    procedure StopTest;
    procedure PrintActnTotalizers;
    procedure PrintXReport;
    procedure PrintZReport;
    procedure PrintDepartmentsReport;
    procedure PrintTaxReport;
    procedure PrintHeader;
    procedure PrintDocTrailer(Flags: Byte);
    procedure PrintTrailer;
    procedure WriteSerial(Serial: DWORD);
    procedure InitFiscalMemory;
    function OpenSlipDoc(Params: TSlipParams): TDocResult;
    function OpenStdSlip(Params: TStdSlipParams): TDocResult;
    function SlipOperation(Params: TSlipOperation; Operation: TPriceReg): Integer;
    function SlipStdOperation(LineNumber: Byte; Operation: TPriceReg): Integer;
    function SlipDiscount(Params: TSlipDiscountParams; Discount: TSlipDiscount): Integer;
    function SlipStdDiscount(Discount: TSlipDiscount): Integer;
    function SlipClose(Params: TCloseReceiptParams): TCloseReceiptResult;
    function ReadFMTotals(Flags: Byte; var R: TFMTotals): Integer;
    function ContinuePrint: Integer;

    function PrintBarcode(const Barcode: string): Integer;
    function PrintGraphics(Line1, Line2: Word): Integer;
    function PrintGraphics1(Line1, Line2: Byte): Integer;
    function PrintGraphics2(Line1, Line2: Word): Integer;
    function PrintGraphics3(Line1, Line2: Word): Integer; overload;
    function PrintGraphics3(const P: TPrintGraphics3): Integer; overload;
    function LoadGraphics(Line: Word; Data: string): Integer;
    function LoadGraphics1(Line: Byte; Data: string): Integer;
    function LoadGraphics2(Line: Word; Data: string): Integer;
    function LoadGraphics3(Line: Word; Data: string): Integer; overload;
    function LoadGraphics3(const P: TLoadGraphics3): Integer; overload;
    function PrintBarLine(Height: Word; Data: string): Integer;
    function PrintBinaryLine(Height: Word; Data: string): Integer;
    function ReadDeviceMetrics: TDeviceMetrics;
    function GetDayDiscountTotal: Int64;
    function GetRecDiscountTotal: Int64;
    function GetDayItemTotal: Int64;
    function GetRecItemTotal: Int64;
    function GetDayItemVoidTotal: Int64;
    function GetRecItemVoidTotal: Int64;
    function ReadTableInfo(Table: Byte; var R: TPrinterTableRec): Integer;
    function ReadTableStructure(Table: Byte; var R: TPrinterTableRec): Integer;
    function ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
    function GetEJSesssionResult(Number: Word; var Text: string): Integer;
    function GetEJReportLine(var Line: string): Integer;
    function ReadEJActivation(var Line: string): Integer;
    function EJReportStop: Integer;
    procedure Check(Code: Integer);
    function GetEJStatus1(var Status: TEJStatus1): Integer;
    procedure PrintStringFont(Station, Font: Byte; const Line: string);
    procedure PrintJournal(DayNumber: Integer);

    function GetSysPassword: DWORD;
    function GetTaxPassword: DWORD;
    function GetUsrPassword: DWORD;
    function GetPrintWidth: Integer; overload;
    function GetPrintWidth(Font: Integer): Integer; overload;
    function Execute(const Data: string): string;
    function ExecuteStream(Stream: TBinStream): Integer;
    function ExecutePrinterCommand(Command: TPrinterCommand): Integer;

    function GetSubtotal: Int64;
    function ReceiptCancel: Integer;
    procedure CancelReceipt;
    function Sale(Operation: TPriceReg): Integer;
    function Buy(Operation: TPriceReg): Integer;
    function RetSale(Operation: TPriceReg): Integer;
    function RetBuy(Operation: TPriceReg): Integer;
    function Storno(Operation: TPriceReg): Integer;
    function ReceiptClose(const P: TCloseReceiptParams;
      var R: TCloseReceiptResult): Integer;
    function ReceiptDiscount(Operation: TAmountOperation): Integer;
    function ReceiptDiscount2(Operation: TReceiptDiscount2): Integer;
    function ReceiptCharge(Operation: TAmountOperation): Integer;
    function ReceiptStornoDiscount(Operation: TAmountOperation): Integer;
    function ReceiptStornoCharge(Operation: TAmountOperation): Integer;
    function PrintReceiptCopy: Integer;
    function OpenReceipt(ReceiptType: Byte): Integer;
    function FormatLines(const Line1, Line2: string): string;
    procedure PrintLines(const Line1, Line2: string);
    function FormatBoldLines(const Line1, Line2: string): string;
    procedure EJTotalsReportDate(const Parameters: TDateReport);
    procedure EJTotalsReportNumber(const Parameters: TNumberReport);
    function ExecuteStream2(Stream: TBinStream): Integer;
    function GetFieldValue(FieldInfo: TPrinterFieldRec; const Value: string): string;
    function FieldToStr(FieldInfo: TPrinterFieldRec; const Value: string): string;
    function BinToFieldValue(FieldInfo: TPrinterFieldRec; const Value: string): string;
    class function ByteToTimeout(Value: Byte): DWORD;
    class function TimeoutToByte(Value: Integer): Byte;
    procedure InterruptReport;
    function ReadDaysRange: TDayRange;
    function ReadFMLastRecordDate: TFMRecordDate;
    function ReadFiscInfo(FiscNumber: Byte): TFiscInfo;
    function LongFisc(NewPassword: DWORD; PrinterID, FiscalID: Int64): TLongFiscResult;
    function Fiscalization(Password, PrinterID, FiscalID: Int64): TFiscalizationResult;
    function ReportOnDateRange(ReportType: Byte; Range: TDayDateRange): TDayRange;
    function ReportOnNumberRange(ReportType: Byte; Range: TDayNumberRange): TDayRange;
    function DecodeEJFlags(Flags: Byte): TEJFlags;
    function GetLine(const Text: string): string; overload;
    function GetLine(const Text: string; MinLength, MaxLength: Integer): string; overload;
    class function BaudRateToCode(BaudRate: Integer): Integer;
    class function CodeToBaudRate(BaudRate: Integer): Integer;
    function FieldToInt(FieldInfo: TPrinterFieldRec; const Value: string): Integer;
    function ReadFieldInfo(Table, Field: Byte; var R: TPrinterFieldRec): Integer;
    function ExecuteData(const TxData: string; var RxData: string): Integer;
    function ExecuteCommand(var Command: TCommandRec): Integer;

    function SendCommand(var Command: TCommandRec): Integer;
    function AlignLines(const Line1, Line2: string;
      LineWidth: Integer): string;
    function GetModel: TPrinterModelRec;
    function GetOnCommand: TCommandEvent;
    procedure SetOnCommand(Value: TCommandEvent);
    procedure PrintText(const Data: TTextRec); overload;
    procedure PrintText(Station: Integer; const Text: string); overload;
    function GetTables: TDeviceTables;
    procedure SetTables(const Value: TDeviceTables);

    procedure ClosePort;
    procedure Close;
    procedure Open(AConnection: IPrinterConnection);
    procedure ReleaseDevice;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    function CapGraphics: Boolean;
    function CapShortEcrStatus: Boolean;
    function CapPrintStringFont: Boolean;
    function CapParameter(ParamID: Integer): Boolean;
    function ReadParameter(ParamID: Integer): Integer;
    function ValidField(Table, Field: Integer): Boolean;
    function ValidParameter(const Parameter: TTableParameter): Boolean;
    function ValidRow(Table, Row: Integer): Boolean;
    procedure WriteParameter(ParamID, ValueID: Integer);
    procedure ReadModelData;
    procedure ReadModelTables;
    function QueryEJActivation: TEJActivation;
    procedure AddFilter(AFilter: IFiscalPrinterFilter);
    procedure RemoveFilter(AFilter: IFiscalPrinterFilter);
    function IsDayOpened(Mode: Integer): Boolean;
    procedure PrintBarcode2(const Barcode: TBarcodeRec);
    function GetStartLine: Integer;
    function LoadImage(const FileName: string; StartLine: Integer): Integer;
    procedure PrintImage(const FileName: string; StartLine: Integer);
    procedure PrintImageScale(const FileName: string; StartLine, Scale: Integer);
    procedure PrintTextFont(Station: Integer; Font: Integer; const Text: string);
    procedure LoadTables(const Path: WideString);

    function FSWriteTLV(const TLVData: string): Integer;
    function FSPrintCalcReport(var R: TFSCalcReport): Integer;
    function FSReadCommStatus(var R: TFSCommStatus): Integer;
    function FSReadExpireDate(var Date: TPrinterDate): Integer;
    function FSReadFiscalResult(var R: TFSFiscalResult): Integer;
    function FSWriteTag(TagID: Integer; const Data: string): Integer;

    function ReadSysOperatorNumber: Integer;
    function ReadUsrOperatorNumber: Integer;
    function readOperatorNumber(Password: Integer): Integer;
    function WriteCustomerAddress(const Value: string): Integer;

    function GetShortStatus2(Password: Integer): TShortPrinterStatus;
    function GetTaxInfo(Tax: Integer): TTaxInfo;
    function ReadDiscountMode: Integer;
    function ReadFPParameter(ParamId: Integer): string;
    function ReadFSParameter(ParamID: Integer; const pString: string): string;
    function FSReadTotals(var R: TFMTotals): Integer;
    function ReadFPDayTotals(Flags: Integer): TFMTotals;
    function ReadTotalsByReceiptType(Index: Integer): Int64;
    function FSPrintCorrectionReceipt(var Command: TFSCorrectionReceipt): Integer;
    function GetParameters: TPrinterParameters;
    function GetContext: TDriverContext;
    function IsRecOpened: Boolean;

    property IsOnline: Boolean read GetIsOnline;
    property Tables: TPrinterTables read FTables;
    property Fields: TPrinterFields read FFields;
    property Model: TPrinterModelRec read GetModel;
    property ResultText: string read GetResultText;
    property ResultCode: Integer read GetResultCode;
    property Connection: IPrinterConnection read FConnection;
    property CapFiscalStorage: Boolean read GetCapFiscalStorage;
    property DiscountMode: Integer read GetDiscountMode;
    property CapReceiptDiscount2: Boolean read GetCapReceiptDiscount2;
    property PrinterModel: TPrinterModel read GetPrinterModel;
    property Statistics: TFiscalPrinterStatistics read GetStatistics;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnConnect: TNotifyEvent read GetOnConnect write SetOnConnect;
    property OnDisconnect: TNotifyEvent read GetOnDisconnect write SetOnDisconnect;
    property AmountDecimalPlaces: Integer read GetAmountDecimalPlaces write SetAmountDecimalPlaces;
    property Parameters: TPrinterParameters read GetParameters;
    property Logger: TLogFile read GetLogger;
    property MalinaParams: TMalinaParams read GetMalinaParams;
  end;

  { EDisabledException }

  EDisabledException = class(Exception);
  EFiscalPrinterException = class(Exception);

const
  PrinterBaudRates: array [0..6] of Integer = (
    CBR_2400,
    CBR_4800,
    CBR_9600,
    CBR_19200,
    CBR_38400,
    CBR_57600,
    CBR_115200);


implementation

{ ѕолучение таймаута выполнени€ команды }
function GetCommandTimeout(Command: Word): Integer;
begin
  case Command of
    $16: Result := 60000; 	// “ехнологическое обнуление
    $B2: Result := 150000; 	// »нициализаци€ архива Ё Ћ«
    $B4: Result := 40000;   // «апрос контрольной ленты Ё Ћ«
    $B5: Result := 40000;   // «апрос документа Ё Ћ«
    $B6: Result := 150000;	// «апрос отчЄта Ё Ћ« по отделам в заданном диапазоне дат
    $B7: Result := 150000;	// «апрос отчЄта Ё Ћ« по отделам в заданном диапазоне номеров смен
    $B8: Result := 100000;	// «апрос отчЄта Ё Ћ« по закрыти€м смен в заданном диапазоне дат
    $B9: Result := 100000;	// «апрос отчЄта Ё Ћ« по закрыти€м смен в заданном диапазоне номеров смен
    $BA: Result := 40000; 	// «апрос в Ё Ћ« итогов смены по номеру смены
    $61: Result := 20000;   // »нициализаци€ ‘ѕ
    $62: Result := 30000;   // «апрос суммы записей в ‘ѕ
    $66: Result := 35000;   // ‘искальный отчет по диапазону дат
    $67: Result := 20000;   // ‘искальный отчет по диапазону смен
    $FE: Result := 500;
    $85: Result := 30000;   // Close receipt
    $40: Result := 30000;   // X report
    $41: Result := 30000;   // Z report
  else
    Result := 30000;	        // ѕо умолчанию
  end;
end;

function CenterGraphicsLine(const Data: string; MaxLen, Scale: Integer): string;
begin
  Result := Data;
  Result := Copy(Result, 1, MaxLen);
  Result := StringOfChar(#0, (MaxLen - Length(Result)*Scale) div (2 * Scale)) + Result;
  Result := Result + StringOfChar(#0, (MaxLen - Length(Result)*Scale) div (2 * Scale));
  Result := Copy(Result, 1, MaxLen);
end;

const
  MinLineWidth = 40;

function PrinterDateToBin(Value: TPrinterDate): string;
begin
  SetLength(Result, Sizeof(Value));
  Move(Value, Result[1], Sizeof(Value));
end;

procedure CheckMinLength(const Data: string; MinLength: Integer);
begin
  if Length(Data) < MinLength then
    raise ECommunicationError.Create('Answer data length is too short');
end;

{ TFiscalPrinterDevice }

constructor TFiscalPrinterDevice.Create;
begin
  inherited Create;
  FContext := TDriverContext.Create;
  FLogger := TClassLogger.Create('TFiscalPrinterDevice', FContext.Logger);
  FLock := TCriticalSection.Create;
  FFields := TPrinterFields.Create;
  FTables := TPrinterTables.Create;
  FModels := TPrinterModels.Create;
  FStatistics := TFiscalPrinterStatistics.Create(Parameters.Logger);
  FFilter := TFiscalPrinterFilter.Create(Parameters.Logger);
  FAmountDecimalPlaces := 2;
  LoadModels;
end;

destructor TFiscalPrinterDevice.Destroy;
begin
  FLock.Free;
  FFields.Free;
  FTables.Free;
  FModels.Free;
  FConnection := nil;
  FLogger.Free;
  FStatistics.Free;
  FFilter.Free;
  FContext.Free;
  inherited Destroy;
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

function TFiscalPrinterDevice.GetCapReceiptDiscount2: Boolean;
begin
  Result := FCapReceiptDiscount2;
end;

procedure TFiscalPrinterDevice.AddFilter(AFilter: IFiscalPrinterFilter);
begin
  FFilter.AddFilter(AFilter);
end;

procedure TFiscalPrinterDevice.RemoveFilter(AFilter: IFiscalPrinterFilter);
begin
  FFilter.RemoveFilter(AFilter);
end;

function TFiscalPrinterDevice.GetResultCode: Integer;
begin
  Result := FResultCode;
end;

function TFiscalPrinterDevice.GetResultText: string;
begin
  Result := FResultText;
end;

function TFiscalPrinterDevice.GetStatistics: TFiscalPrinterStatistics;
begin
  Result := FStatistics;
end;

procedure TFiscalPrinterDevice.Lock;
begin
  FLock.Enter;
end;

procedure TFiscalPrinterDevice.Unlock;
begin
  FLock.Leave;
end;

function TFiscalPrinterDevice.GetModelsFileName: string;
begin
  Result := IncludeTrailingBackSlash(ExtractFilePath(GetDllFileName)) +
      ModelsFileName;
end;

procedure TFiscalPrinterDevice.LoadModels;
var
  Reader: TXmlModelReader;
begin
  Reader := TXmlModelReader.Create(FModels);
  try
    Reader.Load(GetModelsFileName);
  except
    on E: Exception do
      Logger.Error('TFiscalPrinterDevice.LoadModels', E);
  end;
  Reader.Free;
end;

procedure TFiscalPrinterDevice.ReadModelData;
begin
  ReadModelTables;
  ReadModelParameters;
end;

procedure TFiscalPrinterDevice.ReadModelTables;
var
  FieldValue: string;
  RowNumber: Integer;
  FieldNumber: Integer;
  ResultCode: Integer;
  TableNumber: Integer;
  Tables: TPrinterTables;
  Table: TPrinterTable;
  Field: TPrinterField;
  FieldRec: TPrinterFieldRec;
  TableRec: TPrinterTableRec;
begin
  Tables := GetPrinterModel.Tables;

  Tables.Clear;
  TableNumber := 1;
  repeat
    ResultCode := ReadTableStructure(TableNumber, TableRec);
    if ResultCode <> 0 then Break;

    Table := Tables.Add(TableRec);
    for RowNumber := 1 to Table.RowCount do
    begin
      for FieldNumber := 1 to Table.FieldCount do
      begin
        FieldRec := ReadFieldStructure(TableNumber, FieldNumber);
        FieldValue := ReadTableStr(TableNumber, RowNumber, FieldNumber);
        Field := Table.Fields.Add(FieldRec);
        Field.Value := FieldValue;
      end;
    end;
    Inc(TableNumber);
  until ResultCode <> 0;
end;

procedure TFiscalPrinterDevice.ReadModelParameters;
var
  Text: string;
  ParameterID: Integer;
  FieldValue: string;
  RowNumber: Integer;
  FieldNumber: Integer;
  ResultCode: Integer;
  TableNumber: Integer;
  FieldRec: TPrinterFieldRec;
  TableRec: TPrinterTableRec;

  Parameters: TTableParameters;
  ParameterRec: TTableParameterRec;
begin
  ParameterID := 1;
  Parameters := GetPrinterModel.Parameters;

  Parameters.Clear;
  TableNumber := 1;
  repeat
    ResultCode := ReadTableStructure(TableNumber, TableRec);
    if ResultCode <> 0 then Break;


    Text := Format('// %d, %s', [TableRec.Number, TableRec.Name]);
    OutputDebugString(PChar(Text));

    for RowNumber := 1 to TableRec.RowCount do
    begin
      for FieldNumber := 1 to TableRec.FieldCount do
      begin
        FieldRec := ReadFieldStructure(TableNumber, FieldNumber);
        FieldValue := ReadTableStr(TableNumber, RowNumber, FieldNumber);

        ParameterRec.ID := ParameterID;
        ParameterRec.Name := FieldRec.Name;
        ParameterRec.Table := TableNumber;
        ParameterRec.Row := RowNumber;
        ParameterRec.Field := FieldNumber;
        ParameterRec.Size := FieldRec.Size;
        ParameterRec.FieldType := FieldRec.FieldType;
        ParameterRec.MinValue := FieldRec.MinValue;
        ParameterRec.MaxValue := FieldRec.MaxValue;
        ParameterRec.DefValue := FieldValue;
        Parameters.Add(ParameterRec);

        Text := Format('PARAMID_%d = %d; // %d,%d,%d %s, "%s"', [
          ParameterID, ParameterID, TableNumber, RowNumber, FieldNumber,
          FieldRec.Name, FieldValue]);

        OutputDebugString(PChar(Text));
        Inc(ParameterID);
      end;
    end;
    Inc(TableNumber);
  until ResultCode <> 0;
end;

procedure TFiscalPrinterDevice.SaveModels;
var
  Reader: TXmlModelReader;
begin
  Reader := TXmlModelReader.Create(FModels);
  try
    //ReadModelParameters;
    Reader.SetDefaults;
    Reader.Save(GetModelsFileName);
  finally
    Reader.Free;
  end;
end;

function TFiscalPrinterDevice.GetLine(const Text: string): string;
begin
  Result := GetLine(Text, MinLineWidth, GetPrintWidth);
end;

function TFiscalPrinterDevice.GetLine(const Text: string;
  MinLength, MaxLength: Integer): string;
begin
  Result := TrimText(Text, MaxLength);
  Result := Result + StringOfChar(#0, MinLength - Length(Result));
end;

function TFiscalPrinterDevice.GetPrintWidth: Integer;
begin
  Result := GetPrintWidth(Parameters.FontNumber);
end;

function TFiscalPrinterDevice.GetPrintWidth(Font: Integer): Integer;
begin
  Result := 0;
  if (Font >= 1)and(Font < FFontInfo[1].FontCount) then
  begin
    if FFontInfo[Font].CharWidth <> 0 then
      Result := FFontInfo[Font].PrintWidth div FFontInfo[Font].CharWidth;
  end;
  if Result = 0 then Result := 40;
end;

function TFiscalPrinterDevice.GetSysPassword: DWORD;
begin
  Result := FSysPassword;
end;

function TFiscalPrinterDevice.GetTaxPassword: DWORD;
begin
  Result := FTaxPassword;
end;

function TFiscalPrinterDevice.GetUsrPassword: DWORD;
begin
  Result := FUsrPassword;
end;

procedure TFiscalPrinterDevice.SetSysPassword(const Value: DWORD);
begin
  FSysPassword := Value;
end;

procedure TFiscalPrinterDevice.SetTaxPassword(const Value: DWORD);
begin
  FTaxPassword := Value;
end;

procedure TFiscalPrinterDevice.SetUsrPassword(const Value: DWORD);
begin
  FUsrPassword := Value;
end;

function TFiscalPrinterDevice.ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
var
  AField: TPrinterField;
begin
  AField := Fields.Find(Table, Field);
  if AField <> nil then
  begin
    Result := AField.Data;
  end else
  begin
    Check(ReadFieldInfo(Table, Field, Result));
    TPrinterField.Create(Fields, Result);
  end;
end;

function TFiscalPrinterDevice.ValidFieldValue(
  const FieldInfo: TPrinterFieldRec;
  const FieldValue: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  if FieldInfo.FieldType = PRINTER_FIELD_TYPE_INT then
  begin
    I := StrToInt(FieldValue);
    Result := (I >= FieldInfo.MinValue)and(I <= FieldInfo.MaxValue);
  end;
end;


function TFiscalPrinterDevice.ReadTableStructure(Table: Byte;
  var R: TPrinterTableRec): Integer;
var
  ATable: TPrinterTable;
begin
  ATable := Tables.ItemByNumber(Table);
  if ATable <> nil then
  begin
    Result := 0;
    R := ATable.Data;
  end else
  begin
    Result := ReadTableInfo(Table, R);
    if Result = 0 then
      TPrinterTable.Create(Tables, R);
  end;
end;

class function TFiscalPrinterDevice.BaudRateToCode(BaudRate: Integer): Integer;
begin
  case BaudRate of
    CBR_2400    : Result := 0;
    CBR_4800    : Result := 1;
    CBR_9600    : Result := 2;
    CBR_19200   : Result := 3;
    CBR_38400   : Result := 4;
    CBR_57600   : Result := 5;
    CBR_115200  : Result := 6;
  else
    Result := 1;
  end;
end;

class function TFiscalPrinterDevice.CodeToBaudRate(BaudRate: Integer): Integer;
begin
  case BaudRate of
    0: Result := CBR_2400;
    1: Result := CBR_4800;
    2: Result := CBR_9600;
    3: Result := CBR_19200;
    4: Result := CBR_38400;
    5: Result := CBR_57600;
    6: Result := CBR_115200;
  else
    Result := CBR_4800;
  end;
end;

class function TFiscalPrinterDevice.ByteToTimeout(Value: Byte): DWORD;
begin
  case Value of
    0..150   : Result := Value;
    151..249 : Result := (Value-149)*150;
  else
    Result := (Value-248)*15000;
  end;
end;

class function TFiscalPrinterDevice.TimeoutToByte(Value: Integer): Byte;
begin
  case Value of
    0..150        : Result := Value;
    151..15000    : Result := Round(Value/150) + 149;
    15001..105000 : Result := Round(Value/15000) + 248;
  else
    Result := Value;
  end;
end;

procedure TFiscalPrinterDevice.SetIsOnline(Value: Boolean);
begin
  if Value <> IsOnline then
  begin
    FIsOnline := Value;
    if Value then
    begin
      if Assigned(FOnConnect) then FOnConnect(Self); { !!! }
    end else
    begin
      if Assigned(FOnDisconnect) then FOnDisconnect(Self); { !!! }
    end;
  end;
end;

function CanRepeatCommand(Code: Integer): Boolean;
begin
  Result := False;
  case Code of
    $01, // Get dump
    $02, // Get data block from dump
    $03, // Interrupt data stream
    $0F, // Get long serial number and long ECRRN
    $10, // Get short ECR status
    $11, // Get ECR status
    $12, // Print bold string
    $13, // Beep
    $14, // Set communication parameters
    $15, // Read communication parameters
    $16, // Technological reset
    $17, // Print string
    $18, // Print document header
    $19, // Test run
    $1A, // Get cash totalizer value
    $1B, // Get operation totalizer value
    $1C, // Write license
    $1D, // Read license
    $1E, // Write table
    $1F, // Read table
    $20, // Set decimal point position
    $21, // Set clock time
    $22, // Set calendar date
    $23, // Confirm date
    $24, // Initialize tables with default values
    $25, // Cut receipt
    $26, // Get font parameters
    $27, // Common clear
    $28, // Open cash drawer
    $29, // Feed
    $2A, // Eject slip
    $2B, // Interrupt test
    $2C, // Print operation totalizers report
    $2D, // Get table structure
    $2E, // Get field structure
    $2F, // Print string with font
    $40, // Daily report without cleaning
    $41, // Daily report with cleaning
    $42, // Print Department report
    $43, // Print tax report
    $4D, // Print graphics 512
    $4E, // Load graphics 512
    $4F, // Print scaled graphics
    $52, // Print fixed document header
    $53, // Print document footer
    $54, // Print trailer
    $60, // Set serial number
    $61, // Initialize FM
    $62, // Get FM totals
    $63, // Get last FM record date
    $64, // Get dates and sessions range
    $66, // Fiscal report in dates range
    $67, // Fiscal report in days range
    $68, // Interrupt full report
    $69, // Get fiscalization parameters
    $70, // Open fiscal slip
    $71, // Open standard fiscal slip
    $72, // Transaction on slip
    $73, // Standard transaction on slip
    $74, // Discount/charge on slip
    $75, // Standard discount/charge on slip
    $78, // Slip configuration
    $79, // Standard slip configuration
    $7A, // Fill slip buffer with nonfiscal information
    $7B, // Clear slip buffer string
    $7C, // Clear slip buffer
    $7D, // Print slip
    $7E, // Common slip configuration
    $89, // Receipt subtotal
    $8C, // Print last receipt duplicate
    $8D, // Open receipt
    $A0, // EJ department report in dates range
    $A1, // EJ department report in days range
    $A2, // EJ day report in dates range
    $A3, // EJ day report in days range
    $A4, // Print day totals by EJ day number
    $A5, // Print pay document from EJ by KPK number
    $A6, // Print EJ journal by day number
    $A7, // Interrupt full EJ report
    $A8, // Print EJ activization result
    $A9, // EJ activization
    $AA, // Close EJ archive
    $AB, // Get EJ serial number
    $AC, // Interrupt EJ
    $AD, // Get EJ status by code 1
    $AE, // Get EJ status by code 2
    $AF, // Test EJ integrity
    $B0, // Continue printing
    $B1, // Get EJ version
    $B2, // Initialize EJ
    $B3, // Get EJ report data
    $B4, // Get EJ journal
    $B5, // Get EJ document
    $B6, // Get department EJ report in dates range
    $B7, // Get EJ department report in days range
    $B8, // Get EJ day report in dates range
    $B9, // Get EJ day report in days range
    $BA, // Get EJ day totals by day number
    $BB, // Get EJ activization result
    $BC, // Get EJ error
    $C0, // Load graphics
    $C1, // Print graphics
    $C2, // Print barcode
    $C3, // Print exteneded graphics
    $C4, // Load extended graphics
    $C5, // Print line
    $C8, // Get line count in printing buffer
    $C9, // Get line from printing buffer
    $CA, // Clear printing buffer
    $D0, // Get ECR IBM status
    $D1, // Get short ECR IBM status
    $DE, // Print barcode 2D
    $F0, // Change shutter position
    $F1, // Discharge receipt from presenter
    $F3, // Set service center password
    $FC, // Get device type
    $FD, // Send commands to external device port
    $E4, // Print attribute
    $FF01, // FS: Read status
    $FF02, // FS: Read number
    $FF03, // FS: Read expiration time
    $FF04, // FS: Read version
    $FF05, // FS: Start activation
    $FF06, // FS: Do activation
    $FF07, // FS: Clear status
    $FF08, // FS: Void document
    $FF09, // FS: Read activation result
    $FF0A, // FS: Find document by number
    $FF0B, // FS: Open day
    $FF0C, // FS: Send TLV data
    $FF0D, // FS: Registration with discount/charge
    $FF0E, // FS: Storno with discount/charge
    $FF30, // FS: Read data in buffer
    $FF31, // FS: Read data block from buffer
    $FF32, // FS: Start write buffer
    $FF33, // FS: Write daya block in buffer
    $FF34, // FS: Create fiscalization report
    $FF35, // FS: Start correction receipt
    $FF36, // FS: Create correction receipt
    $FF37, // FS: Start report on Calc
    $FF38, // FS: Create report on Calc
    $FF39, // FS: Read data transfer status
    $FF3A, // FS: Read fiscal document in TLV format
    $FF3B, // FS: Read fiscal document TLV
    $FF3C, // FS: Read server ticket on document number
    $FF3D, // FS: Start close fiscal mode
    $FF3E, // FS: Close fiscal mode
    $FF3F, // FS: Read fiscal documents count without server ticket
    $FF40, // FS: Read fiscal day parameters
    $FF41, // FS: Start opening fiscal day
    $FF42, // FS: Start closing fiscal day
    $FF43, // FS: Close day
    $FF44: // FS: Registration with discount/charge 2
      Result := True;
  end;
end;

function TFiscalPrinterDevice.SendCommand(var Command: TCommandRec): Integer;
var
  i: Integer;
  Index: Integer;
  CommandCode: Integer;
const
  MaxRepeatCount = 5;
begin
  for i := 1 to MaxRepeatCount do
  begin
    try
      Logger.Debug(Format('0x%.2X, %s', [Command.Code, GetCommandName(Command.Code)]));
      if (i <> 1) then  Logger.Debug(Format('Retry %d...', [i]));

      Command.RxData := Connection.Send(Command.Timeout, Command.TxData);
      SetIsOnline(True);
      Break;
    except
      on E: Exception do
      begin
        SetIsOnline(False);
        if not CanRepeatCommand(Command.Code) then Break;
        if (i = MaxRepeatCount) then raise;
      end;
    end;
  end;

  Command.RxData := Copy(Command.RxData, 3, Length(Command.RxData)-3);

  if Length(Command.RxData) < 1 then
    raise ECommunicationError.Create('Invalid answer length');

  CommandCode := Ord(Command.RxData[1]);

  Index := 2;
  if CommandCode = $FF then
  begin
    Index := 3;
    CommandCode := $FF00 + Ord(Command.RxData[2]);
    if CommandCode <> Command.Code then
      Result := Ord(Command.RxData[2])
    else
      Result := Ord(Command.RxData[3]);
  end else
  begin
    if CommandCode <> Command.Code then
      raise ECommunicationError.Create('Invalid answer code');
    Result := Ord(Command.RxData[2]);
  end;

  FResultCode := Result;
  FResultText := GetErrorText(Result);
  Command.ResultCode := Result;
  Command.RxData := Copy(Command.RxData, Index + 1, Length(Command.RxData));
  if FResultCode <> 0 then
  begin
    Logger.Error(GetFullErrorText(FResultCode, FCapFiscalStorage));
  end;
end;

function TFiscalPrinterDevice.GetErrorText(Code: Integer): string;
begin
  Result := PrinterTypes.GetErrorText(Code, FCapFiscalStorage);
end;

function TFiscalPrinterDevice.ExecuteCommand(var Command: TCommandRec): Integer;
begin
  Lock;
  try
    repeat
      Command.RepeatFlag := False;
      SendCommand(Command);
      if Assigned(FOnCommand) then FOnCommand(Self, Command);
      Result := Command.ResultCode;

      if not Command.RepeatFlag then Break;
    until false;
  finally
    Unlock;
  end;
end;

function TFiscalPrinterDevice.ExecuteData(const TxData: string;
  var RxData: string): Integer;

function GetCommandCode(const TxData: string): Integer;
begin
  Result := 0;
  if Length(TxData) > 0 then
    Result := Ord(TxData[1]);
  if Result = $FF then
    Result := (Result shl 8) + Ord(TxData[2]);
end;

var
  Command: TCommandRec;
begin
  Command.Code := GetCommandCode(TxData);
  Command.Timeout := GetCommandTimeout(Command.Code);
  Command.TxData := TPrinterFrame.Encode(TxData);
  Result := ExecuteCommand(Command);
  RxData := Command.RxData;
end;

function TFiscalPrinterDevice.ExecuteStream(Stream: TBinStream): Integer;
var
  RxData: string;
  TxData: string;
begin
  RxData := '';
  TxData := Stream.Data;
  Result := ExecuteData(TxData, RxData);
  Stream.Data := RxData;
end;

function TFiscalPrinterDevice.ExecuteStream2(Stream: TBinStream): Integer;
var
  RxData: string;
  TxData: string;
begin
  RxData := '';
  TxData := Stream.Data;
  Result := ExecuteData(TxData, RxData);
  Stream.Data := Chr(Result) + RxData;
end;

function TFiscalPrinterDevice.ExecutePrinterCommand(Command: TPrinterCommand): Integer;
var
  RxData: string;
  TxData: string;
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Command.Encode(Stream);
    TxData := Chr(Command.GetCode) + Stream.Data;
    Result := ExecuteData(TxData, RxData);
    Stream.Data := RxData;
    Command.ResultCode := Result;
    if Command.ResultCode = 0 then
      Command.Decode(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TFiscalPrinterDevice.CashIn(Amount: Int64);
var
  Command: TCashInCommand;
begin
  FLogger.Debug(Format('CashIn(%d)', [Amount]));

  FFilter.BeforeCashIn;
  Command := TCashInCommand.Create;
  try
    Command.Password := GetUsrPassword;
    Command.Amount := Amount;
    Check(ExecutePrinterCommand(Command));

    FFilter.CashIn(Amount);
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterDevice.CashOut(Amount: Int64);
var
  Command: TCashOutCommand;
begin
  FLogger.Debug(Format('CashOut(%d)', [Amount]));

  FFilter.BeforeCashOut;
  Command := TCashOutCommand.Create;
  try
    Command.Password := GetUsrPassword;
    Command.Amount := Amount;
    Check(ExecutePrinterCommand(Command));
    FFilter.CashOut(Amount);
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterDevice.StartDump(DeviceCode: Integer): Integer;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('StartDump(%d)', [DeviceCode]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_START_DUMP);
    Stream.WriteDWORD(GetTaxPassword);
    Stream.WriteByte(DeviceCode);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.GetDumpBlock: TDumpBlock;
var
  Command: TGetDumpBlockCommand;
begin
  Command := TGetDumpBlockCommand.Create;
  try
    Command.Password := GetTaxPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.DumpBlock;
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterDevice.StopDump;
var
  Command: TStopDumpCommand;
begin
  Command := TStopDumpCommand.Create;
  try
    Command.Password := GetTaxPassword;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterDevice.LongFisc(NewPassword: DWORD;
  PrinterID, FiscalID: Int64): TLongFiscResult;
var
  Command: TLongFiscalizationCommand;
begin
  FLogger.Debug(Format('LongFisc(%d,%d,%d)',
    [NewPassword, PrinterID, FiscalID]));

  Command := TLongFiscalizationCommand.Create;
  try
    Command.TaxPassword := GetTaxPassword;
    Command.NewPassword := NewPassword;
    Command.PrinterID := PrinterID;
    Command.FiscalID := FiscalID;
    Check(ExecutePrinterCommand(Command));
    Result := Command.FiscResult;
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterDevice.SetLongSerial(Serial: Int64);
var
  Command: TSetLongSerialCommand;
begin
  FLogger.Debug(Format('SetLongSerial(%d)', [Serial]));

  Command := TSetLongSerialCommand.Create;
  try
    Command.Password := 0;
    Command.Serial := Serial;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Get Long Serial Number And Long ECRRN

  Command:	0FH. Length: 5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		0FH. Length: 16 bytes.
  Ј	Result Code (1 byte)
  Ј	Long Serial Number (7 bytes) 00000000000000Е99999999999999
  Ј	Long ECRRN (7 bytes) 00000000000000Е99999999999999

******************************************************************************)

function TFiscalPrinterDevice.GetLongSerial: TGetLongSerial;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_GET_LONG_SERIAL);
    Stream.WriteDWORD(GetUsrPassword);

    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get Short FP Status

  Command:	10H. Length: 5 bytes.
  Ј	Operator password (4 bytes)

  Answer:		10H. Length: 16 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	FP flags (2 bytes)
  Ј	FP mode (1 byte)
  Ј	FP submode (1 byte)
  Ј	Quantity of operations on the current receipt (1 byte) lower byte of a two-byte digit (see below)
  Ј	Battery voltage (1 byte)
  Ј	Power source voltage (1 byte)
  Ј	Fiscal Memory error code (1 byte)
  Ј	EKLZ error code (1 byte) EKLZ=Electronic Cryptographic Journal
  Ј	Quantity of operations on the current receipt (1 byte) upper byte of a two-byte digit (see below)
  Ј	Reserved (3 bytes)

******************************************************************************)

function TFiscalPrinterDevice.ReadOperatorNumber(Password: Integer): Integer;
begin
  Result := GetShortStatus2(Password).OperatorNumber;
end;

function TFiscalPrinterDevice.ReadUsrOperatorNumber: Integer;
begin
  Result := GetShortStatus2(GetUsrPassword).OperatorNumber;
end;

function TFiscalPrinterDevice.ReadSysOperatorNumber: Integer;
begin
  Result := GetShortStatus2(GetSysPassword).OperatorNumber;
end;

function TFiscalPrinterDevice.GetShortStatus2(Password: Integer): TShortPrinterStatus;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_GET_SHORT_STATUS);
    Stream.WriteDWORD(Password);
    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.GetShortStatus: TShortPrinterStatus;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_GET_SHORT_STATUS);
    Stream.WriteDWORD(GetUsrPassword);

    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get FP Status
  Command:	11H. Length: 5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		11H. Length: 48 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	FP firmware version (2 bytes)
  Ј	FP firmware build (2 bytes)
  Ј	FP firmware date (3 bytes) DD-MM-YY
  Ј	Number of FP in checkout line (1 byte)
  Ј	Current receipt number (2 bytes)
  Ј	FP flags (2 bytes)
  Ј	FP mode (1 byte)
  Ј	FP submode (1 byte)
  Ј	FP port (1 byte)
  Ј	FM firmware version (2 bytes)
  Ј	FM firmware build (2 bytes)
  Ј	FM firmware date (3 bytes) DD-MM-YY
  Ј	Current date (3 bytes) DD-MM-YY
  Ј	Current time (3 bytes) HH-MM-SS
  Ј	FM flags (1 byte)
  Ј	Serial number (4 bytes)
  Ј	Number of last daily totals record in FM (2 bytes) 0000Е2100
  Ј	Quantity of free daily totals records left in FM (2 bytes)
  Ј	Last fiscalization/refiscalization record number in FM (1 byte) 1Е16
  Ј	Quantity of free fiscalization/refiscalization records left in FM (1 byte) 0Е15
  Ј	Taxpayer ID (6 bytes)

******************************************************************************)

function TFiscalPrinterDevice.GetLongStatus: TLongPrinterStatus;
var
  Command: TLongStatusCommand;
begin
  Command := TLongStatusCommand.Create;
  try
    Command.Password := GetUsrPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.Status;
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterDevice.GetFMFlags(Flags: Byte): TFMFlags;
begin
  Result.FM1Present := TestBit(Flags, 0);
  Result.FM2Present := TestBit(Flags, 1);
  Result.LicenseEntered := TestBit(Flags, 2);
  Result.Overflow := TestBit(Flags, 3);
  Result.LowBattery := TestBit(Flags, 4);
  Result.LastRecordCorrupted := TestBit(Flags, 5);
  Result.DayOpened := TestBit(Flags, 6);
  Result.Is24HoursLeft := TestBit(Flags, 7);
end;

(******************************************************************************

  Print String In Bold Type

  Command:	12H. Length: 26 bytes.
  Ј	Operator password (4 bytes)
  Ј	Flags (1 byte) Bit 0 - print on journal station, Bit 1 - print on receipt
    station.
  Ј	String of characters (20 bytes)
  Answer:		12H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.PrintBoldString(Flags: Byte; const Text: string): Integer;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('PrintBoldString(%d,''%s'')',
    [Flags, Text]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_PRINT_BOLD_LINE);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(Flags);
    Stream.WriteString(GetLine(Text, 20, GetPrintWidth div 2));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Beep
  
  Command:	13H. Length: 5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		13H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.Beep: Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_BEEP);
    Stream.WriteDWORD(GetUsrPassword);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Set Communication Parameters
  
  Command:	14H. Length: 8 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Port number (1 byte) 0Е255
  Ј	Baud rate (1 byte) 0Е6
  Ј	Inter-character time out (1 byte) 0Е255
  Answer:		14H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

function TFiscalPrinterDevice.SetPortParams(Port: Byte;
  const PortParams: TPortParams): Integer;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('SetPortParams(%d,%d,%d)',
    [Port, PortParams.BaudRate, PortParams.Timeout]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_SET_PORT_PARAMS);
    Stream.WriteDWORD(GetSysPassword);
    Stream.WriteByte(Port);
    Stream.WriteByte(BaudRateToCode(PortParams.BaudRate));
    Stream.WriteByte(TimeoutToByte(PortParams.Timeout));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get Communication Parameters

  Command:	15H. Length: 6 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Port number (1 byte) 0Е255
  Answer:		15H. Length: 4 bytes.
  Ј	Result Code (1 byte)
  Ј	Baud rate (1 byte) 0Е6
  Ј	Inter-character time out (1 byte) 0Е255

******************************************************************************)
                       
function TFiscalPrinterDevice.GetPortParams(Port: Byte): TPortParams;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('GetPortParams(%d)',  [Port]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_GET_PORT_PARAMS);
    Stream.WriteDWORD(GetSysPassword);
    Stream.WriteByte(Port);
    Check(ExecuteStream(Stream));
    Result.BaudRate := CodeToBaudRate(Stream.ReadByte);
    Result.Timeout := ByteToTimeout(Stream.ReadByte);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Reset FM

  Command:	16H. Length: 1 byte.
  Answer:		16H. Length: 2 bytes.
  Ј	Result Code (1 byte)


******************************************************************************)

procedure TFiscalPrinterDevice.ResetFiscalMemory;
begin
  Execute(Chr(SMFP_COMMAND_RESETFM));
end;

(******************************************************************************

  Print String

  Command:	17H. Length: 46 bytes.
  Ј	Operator password (4 bytes)
  Ј	Flags (1 byte) Bit 0 - print on journal station, Bit 1 - print on receipt station.
  Ј	String of characters to print (40 bytes)
  Answer:		17H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintString(Stations: Byte;
  const Line: string);
var
  Text: string;
begin
  FLogger.Debug(Format('PrintString(%d,''%s'')',
    [Stations, Line]));

  Text := Line;
  if Text = '' then Text := ' ';
  Text := TrimText(Text, GetPrintWidth);

  Execute(#$17 + IntToBin(GetUsrPassword, 4) + Chr(Stations) + GetLine(Text));
end;

(******************************************************************************

  ќткрыть смену

 оманда: E0H. ƒлина сообщени€: 5байт.
ѕароль оператора (4 байта)
ќтвет: E0H. ƒлина сообщени€: 2 байта.
ѕор€дковый номер оператора (1 байт) 1Е30
ѕримечание:  оманда открывает смену в ‘ѕ и переводит ‘– в режим Ђќткрытой
сменыї.

******************************************************************************)

function TFiscalPrinterDevice.OpenFiscalDay: Boolean;
var
  Status: TPrinterStatus;
begin
  Result := False;
  if CapFiscalStorage then
  begin
    Status := WaitForPrinting;
    if not IsDayOpened(Status.Mode) then
    begin
      OpenDay;
      WaitForPrinting;
      Result := True;
    end;
  end;
end;

procedure TFiscalPrinterDevice.OpenDay;
begin
  Execute(#$E0 + IntToBin(GetUsrPassword, 4));
  FFilter.OpenDay;
end;


(******************************************************************************

  Print Receipt Header

  Command:	18H. Length: 37 bytes.
  Ј	Operator password (4 bytes)
  Ј	Receipt title (30 bytes)
  Ј	Receipt number (2 bytes)
  Answer:		18H. Length: 5 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	Current receipt number (2 bytes)

******************************************************************************)

procedure TFiscalPrinterDevice.PrintDocHeader(const DocName: string; DocNumber: Word);
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('PrintDocHeader(''%s'', %d)',
    [DocName, DocNumber]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_PRINT_DOC_HEADER);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteString(GetLine(DocName, 30, 30));
    Stream.WriteInt(DocNumber, 2);

    Check(ExecuteStream(Stream));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Start Test

  Command:	19H. Length: 6 bytes.
  Ј	Operator password (4 bytes)
  Ј	Test time out (1 byte) 1Е99
  Answer:		19H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.StartTest(Interval: Byte);
begin
  FLogger.Debug(Format('StartTest(%d)', [Interval]));

  Execute(#$19 + IntToBin(GetUsrPassword, 4) + Chr(Interval));
end;

(******************************************************************************

  Get Cash Totalizer Value

  Command:	1AH. Length: 6 bytes.
  Ј	Operator password (4 bytes)
  Ј	Cash totalizer number (1 byte) 0Е255
  Answer:		1AH. Length: 9 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	Cash totalizer value (6 bytes)

******************************************************************************)

function TFiscalPrinterDevice.ReadCashReg(ID: Byte; var R: TCashRegisterRec): Integer;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('ReadCashRegister(%d)', [ID]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_READ_CASH_TOTALIZER);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(ID);
    Result := ExecuteStream(Stream);
    if Result = 0 then
    begin
      R.Operator := Stream.ReadByte; // Operator number
      R.Value := Stream.ReadInt(6); // Register value
    end;
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.ReadCashRegister(ID: Byte): Int64;
var
  R: TCashRegisterRec;
begin
  Check(ReadCashReg(ID, R));
  Result := R.Value;
end;

(******************************************************************************

  Get Operation Totalizer Value

  Command:	1BH. Length: 6 bytes.
  Ј	Operator password (4 bytes)
  Ј	Operation totalizer number (1 byte) 0Е255
  Answer:		1BH. Length: 5 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	Operation totalizer value (2 bytes)

******************************************************************************)

function TFiscalPrinterDevice.ReadOperatingReg(ID: Byte;
  var R: TOperRegisterRec): Integer;
var
  Data: string;
  Command: string;
begin
  FLogger.Debug(Format('ReadOperatingRegister(%d)', [ID]));

  Command := #$1B + IntToBin(GetUsrPassword, 4) + Chr(ID);
  Result := ExecuteData(Command, Data);
  if Result = 0 then
  begin
    R.Operator := Ord(Data[1]);
    R.Value := BinToInt(Data, 2, 2);
  end;
end;

function TFiscalPrinterDevice.ReadOperatingRegister(ID: Byte): Word;
var
  R: TOperRegisterRec;
begin
  Check(ReadOperatingReg(ID, R));
  Result := R.Value;
end;

(******************************************************************************

  Set License

  Command:	1CH. Length: 10 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	License (5 bytes) 0000000000Е9999999999
  Answer:		1CH. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.WriteLicense(License: Int64);
var
  Command: TWriteLicenseCommand;
begin
  FLogger.Debug(Format('WriteLicense(%d)', [License]));

  Command := TWriteLicenseCommand.Create;
  try
    Command.SysPassword := GetSysPassword;
    Command.License := License;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Get License

  Command:	1DH. Length: 5 bytes.
  Ј	System Administrator password (4 bytes) 30
  Answer:		1DH. Length: 7 bytes.
  Ј	Result Code (1 byte)
  Ј	License (5 bytes) 0000000000Е9999999999

******************************************************************************)

function TFiscalPrinterDevice.ReadLicense: Int64;
var
  Command: TReadLicenseCommand;
begin
  Command := TReadLicenseCommand.Create;
  try
    Command.SysPassword := GetSysPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.License;
  finally
    Command.Free;
  end;
end;

(******************************************************************************
******************************************************************************)

function TFiscalPrinterDevice.DoWriteTable(
  Table, Row, Field: Integer;
  const FieldValue: string): Integer;
var
  Command: TWriteTableCommand;
begin
  FLogger.Debug(Format('DoWriteTable(%d,%d,%d,%s)',
    [Table, Row, Field, StrToHexText(FieldValue)]));

  Command := TWriteTableCommand.Create;
  try
    Command.SysPassword := GetSysPassword;
    Command.Table := Table;
    Command.Row := Row;
    Command.Field := Field;
    Command.FieldValue := FieldValue;
    Result := ExecutePrinterCommand(Command);
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Get Table Field Value

  Command:	1FH. Length: 9 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Table (1 byte)
  Ј	Row (2 bytes)
  Ј	Field (1 byte)
  Answer:		1FH. Length: (2+X) bytes.
  Ј	Result Code (1 byte)
  Ј	Value (X bytes) up to 40 bytes

******************************************************************************)

function TFiscalPrinterDevice.ReadTableBin(Table, Row,
  Field: Integer): string;
var
  Command: TReadTableCommand;
begin
  FLogger.Debug(Format('ReadTableBin(%d,%d,%d)',
    [Table, Row, Field]));

  Command := TReadTableCommand.Create;
  try
    Command.SysPassword := GetSysPassword;
    Command.Table := Table;
    Command.Row := Row;
    Command.Field := Field;
    Check(ExecutePrinterCommand(Command));
    Result := Command.FieldValue;
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Set Decimal Dot Position
  
  Command:	20H. Length: 6 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Decimal dot position (1 byte) '0' - 0 digits after the dot, '1' - 2 digits after the dot
  Answer:		20H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.SetPointPosition(PointPosition: Byte);
begin
  FLogger.Debug(Format('SetPointPosition(%d)',
    [PointPosition]));

  Execute(#$20 + IntToBin(GetSysPassword, 4) + Chr(PointPosition));
end;

(******************************************************************************

  Set Clock Time

  Command:	21H. Length: 8 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Time (3 bytes) HH-MM-SS
  Answer:		21H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.SetTime(const Time: TPrinterTime);
begin
  FLogger.Debug(Format('SetTime(%s)',
    [PrinterTimeToStr(Time)]));

  Execute(#$21 + IntToBin(GetSysPassword, 4) +
    Chr(Time.Hour) + Chr(Time.Min) + Chr(Time.Sec));
end;

(******************************************************************************

  Set Calendar Date

  Command:	22H. Length: 8 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Date (3 bytes) DD-MM-YY
  Answer:		22H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.SetDate(const Date: TPrinterDate);
begin
  FLogger.Debug(Format('SetDate(%s)',
    [PrinterDateToStr(Date)]));

  Execute(#$22 + IntToBin(GetSysPassword, 4) +
    Chr(Date.Day) + Chr(Date.Month) + Chr(Date.Year));
end;

(******************************************************************************

  Confirm Date

  Command:	23H. Length: 8 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Date (3 bytes) DD-MM-YY
  Answer:		23H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.ConfirmDate(const Date: TPrinterDate);
begin
  FLogger.Debug(Format('ConfirmDate(%.2d.%.2d.%.4d)',
    [Date.Day, Date.Month, Date.Year + 2000]));

  Execute(#$23 + IntToBin(GetSysPassword, 4) +
    Chr(Date.Day) + Chr(Date.Month) + Chr(Date.Year));
end;

(******************************************************************************

  Set Table With Default Values

  Command:	24H. Length: 5 bytes.
  Ј	System Administrator password (4 bytes) 30
  Answer:		24H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.InitializeTables;
begin
  Execute(#$24 + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Cut
  
  Command:	25H. Length: 6 bytes.
  Ј	Operator password (4 bytes)
  Ј	Cut type (1 byte) '0' - complete, '1' - incomplete
  Answer:		25H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.CutPaper(CutType: Byte);
var
  Command: string;
  Answer: string;
begin
  FLogger.Debug(Format('CutPaper(%d)', [CutType]));

  Command := #$25 + IntToBin(GetUsrPassword, 4) + Chr(CutType);
  ExecuteData(Command, Answer);
end;

procedure TFiscalPrinterDevice.FullCut;
begin
  CutPaper(PRINTER_CUTTYPE_FULL);
end;

procedure TFiscalPrinterDevice.PartialCut;
begin
  CutPaper(PRINTER_CUTTYPE_PARTIAL);
end;

(******************************************************************************

  Get Font Parameters
  
  Command:	26H. Length: 6 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Font type (1 byte)
  Answer:		26H. Length: 7 bytes.
  Ј	Result Code (1 byte)
  Ј	Print width in dots (2 bytes)
  Ј	Character width in dots (1 byte) the width is given together with inter-character spacing
  Ј	Character height in dots (1 byte) the height is given together with inter-line spacing
  Ј	Number of fonts in FP (1 byte)

******************************************************************************)

function TFiscalPrinterDevice.ReadFontInfo(FontNumber: Byte): TFontInfo;
var
  Data: string;
begin
  FLogger.Debug(Format('ReadFontInfo(%d)', [FontNumber]));
  Data := Execute(#$26 + IntToBin(GetSysPassword, 4) + Chr(FontNumber));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Clear All Totalizers

  Command:	27H. Length: 5 bytes.
  Ј	System Administrator password (4 bytes) 30
  Answer:		27H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.ResetTotalizers;
begin
  Execute(#$27 + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Open Cash Drawer
  
  Command:	28H. Length: 6 bytes.
  Ј	Operator password (4 bytes)
  Ј	Cash drawer number (1 byte) 0, 1
  Answer:		28H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.OpenDrawer(DrawerNumber: Byte);
begin
  FLogger.Debug(Format('OpenDrawer(%d)', [DrawerNumber]));
  Execute(#$28 + IntToBin(GetUsrPassword, 4) + Chr(DrawerNumber));
end;

(******************************************************************************

  Feed

  Command:	29H. Length: 7 bytes.
  Ј	Operator password (4 bytes)
  Ј	Flags (1 byte) Bit 0 - journal station, Bit 1 - receipt station, Bit 2 - slip station
  Ј	Number of lines to feed (1 byte) 1Е255 - the maximum number of lines to feed is limited by the size of print buffer, but does not exceed 255
  Answer:		29H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.FeedPaper(Station: Byte; Lines: Byte);
begin
  FLogger.Debug(Format('FeedPaper(%d,%d)',
    [Station, Lines]));

  Execute(#$29 + IntToBin(GetUsrPassword, 4) + Chr(Station) + Chr(Lines));
end;

(******************************************************************************

  Eject Slip
  
  Command:	2AH. Length: 6 bytes.
  Ј	Operator password (4 bytes)
  Ј	Slip paper eject direction (1 byte) '0' - down, '1' - up
  Answer:		2AH. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.EjectSlip(Direction: Byte);
begin
  FLogger.Debug(Format('EjectSlip(%d)',
    [Direction]));

  Execute(#$2A + IntToBin(GetUsrPassword, 4) + Chr(Direction));
end;

(******************************************************************************

  Interrupt Test

  Command:	2BH. Length: 5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		2BH. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.StopTest;
begin
  Execute(#$2B + IntToBin(GetUsrPassword, 4));
end;

(******************************************************************************

  Print Operation Totalizers Report

  Command:	2CH. Length: 5 bytes.
  Ј	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		2CH. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintActnTotalizers;
begin
  Execute(#$2C + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Get Table Structure

  Command:	2DH. Length: 6 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Table number (1 byte)
  Answer:		2DH. Length: 45 bytes.
  Ј	Result Code (1 byte)
  Ј	Table name (40 bytes)
  Ј	Number of rows (2 bytes)
  Ј	Number of fields (1 byte)

******************************************************************************)

function TFiscalPrinterDevice.ReadTableInfo(Table: Byte;
  var R: TPrinterTableRec): Integer;
var
  Data: string;
  Command: string;
begin
  FLogger.Debug(Format('ReadTableInfo(%d)', [Table]));
  Command := #$2D + IntToBin(GetSysPassword, 4) + Chr(Table);
  Result := ExecuteData(Command, Data);
  if Result = 0 then
  begin
    CheckMinLength(Data, 43);
    R.Number := Table;
    R.Name := Copy(Data, 1, 40);
    R.RowCount := BinToInt(Data, 41, 2);
    R.FieldCount := BinToInt(Data, 43, 1);
  end;
end;

(******************************************************************************

  Get Field Structure

  Command:	2EH. Length: 7 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Table number (1 byte)
  Ј	Field number (1 byte)
  Answer:		2EH. Length: (44+X+X) bytes.
  Ј	Result Code (1 byte)
  Ј	Field name (40 bytes)
  Ј	Field type (1 byte) '0' - BIN, '1' - CHAR
  Ј	Number of bytes - X (1 byte)
  Ј	Field minimum value (X bytes) for BIN-type fields only
  Ј	Field maximum value (X bytes) for BIN-type fields only


******************************************************************************)

function TFiscalPrinterDevice.ReadFieldInfo(Table, Field: Byte;
  var R: TPrinterFieldRec): Integer;
var
  Data: string;
  Command: string;
begin
  FLogger.Debug(Format('ReadFieldInfo(%d,%d)', [Table, Field]));
  Command := #$2E + IntToBin(GetSysPassword, 4) + Chr(Table) + Chr(Field);
  Result := ExecuteData(Command, Data);
  if Result = 0 then
  begin
    CheckMinLength(Data, 42);
    R.Table := Table;
    R.Field := Field;
    R.Name := TrimRight(Copy(Data, 1, 40));
    R.FieldType := Ord(Data[41]);
    R.Size := Ord(Data[42]);
    if (R.FieldType = 0)and(Length(Data) >= (42 + R.Size*2)) then
    begin
      R.MinValue := 0;
      Move(Data[43], R.MinValue, R.Size);
      R.MaxValue := 0;
      Move(Data[43 + R.Size], R.MaxValue, R.Size);
    end;
  end;
end;

(******************************************************************************

  Print String With Specific Font

  Command:	2FH. Length: 47 bytes.
  Ј	Operator password (4 bytes)
  Ј	Flags (1 byte) Bit 0 - print on journal station, Bit 1 - print on receipt station
  Ј	Font number (1 byte) 0Е255
  Ј	String of characters to print (40 bytes)
  Answer:		2FH. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintStringFont(Station, Font: Byte;
  const Line: string);
var
  Text: string;
begin
  Text := Line;

  if Text = '' then Text := ' ';
  FLogger.Debug(Format('PrintStringFont(%d,%d, ''%s'')',
    [Station, Font, Text]));

  Execute(#$2F + IntToBin(GetUsrPassword, 4) + Chr(Station) + Chr(Font) +
    GetLine(Text));
end;

(******************************************************************************

  Print X-Report

  Command:	40H. Length: 5 bytes.
  Ј	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		40H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintXReport;
begin
  Execute(#$40 + IntToBin(GetSysPassword, 4));
  PrintCommStatus;
end;

procedure TFiscalPrinterDevice.PrintLines(const Line1, Line2: string);
begin
  PrintStringFont(PRINTER_STATION_REC, Parameters.FontNumber,
    FormatLines(Line1, Line2));
end;

procedure TFiscalPrinterDevice.PrintCommStatus;
var
  R: TFSCommStatus;
begin
  if not CapFiscalStorage then Exit;

  WaitForPrinting;
  Check(FSReadCommStatus(R));
  PrintText(PRINTER_STATION_REC, StringOfChar('-', GetPrintWidth));
  PrintLines(' ќЋ»„≈—“¬ќ —ќќЅў≈Ќ»… ƒЋя ќ‘ƒ:', IntToStr(R.DocumentCount));
  PrintLines('Ќќћ≈– ѕ≈–¬ќ√ќ ƒќ ”ћ≈Ќ“ј ƒЋя ќ‘ƒ:', IntToStr(R.DocumentNumber));
  PrintLines('ƒј“ј ѕ≈–¬ќ√ќ ƒќ ”ћ≈Ќ“ј:', PrinterDateTimeToStr2(R.DocumentDate));
end;

(******************************************************************************

  Print Z-Report

  Command:	41H. Length: 5 bytes.
  Ј	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		41H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintZReport;
begin
  Execute(#$41 + IntToBin(GetSysPassword, 4));
  PrintCommStatus;
  FFilter.PrintZReport;
end;

(******************************************************************************

  Print Department Report
  
  Command:	42H. Length: 5 bytes.
  Ј	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		42H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintDepartmentsReport;
begin
  Execute(#$42 + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Print Taxes Report
  
  Command:	43H. Length: 5 bytes.
  Ј	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		43H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintTaxReport;
begin
  Execute(#$43 + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Print Fixed Header
  
  Command:	52H. Length: 5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		52H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintHeader;
begin
  Execute(#$52 + IntToBin(GetUsrPassword, 4));
end;

(******************************************************************************

  End document

  Command:	53H. Length: 6 bytes
  Ј	Operator password (4 bytes)
  Ј	Parameter (1 bytes)
  Ј	0 - Without trailer
  Ј	1 - With trailer
  Answer:		53H. Length: 3 bytes.
  Ј	Result code (1 bytes)
  Ј	Operator index number (1 bytes) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintDocTrailer(Flags: Byte);
begin
  FLogger.Debug(Format('PrintDocTrailer(%d)', [Flags]));
  Execute(#$53 + IntToBin(GetUsrPassword, 4) + Chr(Flags));
end;

(******************************************************************************

  Print trailer
  Command:	54H. Length:5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		54H. Length: 3 bytes.
  Ј	Result code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintTrailer;
begin
  Execute(#$54 + IntToBin(GetUsrPassword, 4));
end;

(******************************************************************************

  Set Serial Number

  Command:	60H. Length: 9 bytes.
  Ј	Password (4 bytes) (default value is '0')
  Ј	Serial number (4 bytes) 00000000Е99999999
  Answer:		60H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.WriteSerial(Serial: DWORD);
begin
  FLogger.Debug(Format('WriteSerial(%d)', [Serial]));
  Execute(#$60 + IntToBin(0, 4) + IntToBin(Serial, 4));
end;

(******************************************************************************

  Initialize FM

  Command:	61H. Length: 1 byte.
  Answer:		61H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.InitFiscalMemory;
begin
  Execute(#$61);
end;

(******************************************************************************

  Get FM Totals

  Command:	62H. Length: 6 bytes.
  Ј	Administrator or System Administrator password (4 bytes) 29, 30
  Ј	Report type (1 byte) '0' - grand totals, '1' - grand totals after the last
    refiscalization
  Answer:		62H. Length: 29 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 29, 30
  Ј	Grand totals of sales (8 bytes)
  Ј	Grand totals of buys (6 bytes) If there is no FM2, the value is
    FFh FFh FFh FFh FFh FFh
  Ј	Grand totals of sale refunds (6 bytes) If there is no FM2, the value is
    FFh FFh FFh FFh FFh FFh
  Ј	Grand totals of buy refunds (6 bytes) If there is no FM2, the value is
    FFh FFh FFh FFh FFh FFh

******************************************************************************)

function BinToInt2(const Data: string; Index, Size: Integer): Int64;
begin
  Result := 0;
  if Copy(Data, Index, Size) <> StringOfChar(#$FF, Size) then
    Result := BinToInt(Data, Index, Size);
end;

function TFiscalPrinterDevice.ReadFMTotals(Flags: Byte; var R: TFMTotals): Integer;
var
  Command: string;
  Answer: string;
begin
  FLogger.Debug(Format('ReadFMTotals(%d)', [Flags]));
  Command := #$62 + IntToBin(GetSysPassword, 4) + Chr(Flags);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 27);
    R.OperatorNumber := Ord(Answer[1]);
    R.SaleTotal := BinToInt2(Answer, 2, 8);
    R.BuyTotal := BinToInt2(Answer, 10, 6);
    R.RetSale := BinToInt2(Answer, 16, 6);
    R.RetBuy := BinToInt2(Answer, 22, 6);
  end;
end;

(******************************************************************************

  Get Date of Last Record In FM

  Command:	63H. Length: 5 bytes.
  Ј	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		63H. Length: 7 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 29, 30
  Ј	Type of last record in FM (1 byte) '0' - fiscalization/refiscalization,
    '1' - daily totals
  Ј	Date (3 bytes) DD-MM-YY


******************************************************************************)

function TFiscalPrinterDevice.ReadFMLastRecordDate: TFMRecordDate;
var
  Data: string;
begin
  Data := Execute(#$63 + IntToBin(GetTaxPassword, 4));
  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Get Dates And Days Ranges In FM

  Command:	64H. Length: 5 bytes.
  Ј	Tax Officer password (4 bytes)
  Answer:		64H. Length: 12 bytes.
  Ј	Result Code (1 byte)
  Ј	Date of first daily totals record in FM (3 bytes) DD-MM-YY
  Ј	Date of last daily totals record in FM (3 bytes) DD-MM-YY
  Ј	Number of first daily totals record in FM (2 bytes) 0000Е2100
  Ј	Number of last daily totals record in FM (2 bytes) 0000Е2100

******************************************************************************)

function TFiscalPrinterDevice.ReadDaysRange: TDayRange;
var
  Data: string;
begin
  Data := Execute(#$64 + IntToBin(GetTaxPassword, 4));
  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Fiscalize/Refiscalize Printer

  Command:	65H. Length: 20 bytes.
  Ј	Tax Officer old password (4 bytes)
  Ј	Tax Officer new password (4 bytes)
  Ј	ECRRN (5 bytes) 0000000000Е9999999999
  Ј	Taxpayer ID (6 bytes) 000000000000Е999999999999
  Answer:		65H. Length: 9 bytes.
  Ј	Result Code (1 byte)
  Ј	Fiscalization/Refiscalization number (1 byte) 1Е16
  Ј	Quantity of free fiscalization/refiscalization records left in FM (1 byte) 0Е15
  Ј	Number of last daily totals record in FM (2 bytes) 0000Е2100
  Ј	Fiscalization/Refiscalization date (3 bytes) DD-MM-YY

******************************************************************************)

function TFiscalPrinterDevice.Fiscalization(Password, PrinterID,
  FiscalID: Int64): TFiscalizationResult;
var
  Data: string;
begin
  FLogger.Debug(Format('Fiscalization(%d,%d,%d)',
    [Password, PrinterID, FiscalID]));

  Data := Execute(#$65 +
    IntToBin(GetTaxPassword, 4) +
    IntToBin(Password, 4) +
    IntToBin(PrinterID, 4) +
    IntToBin(FiscalID, 4));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Periodic Daily Totals Fiscal Report

  Command:	66H. Length: 12 bytes.
  Ј	Tax Officer password (4 bytes)
  Ј	Report type (1 byte) '0' - short, '1' - full
  Ј	Date of first daily totals record in FM (3 bytes) DD-MM-YY
  Ј	Date of last daily totals record in FM (3 bytes) DD-MM-YY
  Answer:		66H. Length: 12 bytes.
  Ј	Result Code (1 byte)
  Ј	Date of first daily totals record in FM (3 bytes) DD-MM-YY
  Ј	Date of last daily totals record in FM (3 bytes) DD-MM-YY
  Ј	Number of first daily totals record in FM (2 bytes) 0000Е2100
  Ј	Number of last daily totals record in FM (2 bytes) 0000Е2100

******************************************************************************)

function TFiscalPrinterDevice.ReportOnDateRange(ReportType: Byte;
  Range: TDayDateRange): TDayRange;
var
  Data: string;
begin
  FLogger.Debug(Format('ReportOnDateRange(%d,%s,%s)',
    [ReportType, PrinterDateToStr(Range.Date1), PrinterDateToStr(Range.Date2)]));

  Data := Execute(#$66 +
    IntToBin(GetTaxPassword, 4) +
    Chr(ReportType) +
    PrinterDateToBin(Range.Date1) +
    PrinterDateToBin(Range.Date2));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Fiscal Report For Daily Totals Numbers Range

  Command:	67H. Length: 10 bytes.
  Ј	Tax Officer password (4 bytes)
  Ј	Report type (1 byte) '0' - short, '1' - full
  Ј	Day number of first daily totals record in FM (2 bytes) 0000Е2100
  Ј	Day number of last daily totals record in FM (2 bytes) 0000Е2100
  Answer:		67H. Length: 12 bytes.
  Ј	Result Code (1 byte)
  Ј	Date of first daily totals record in FM (3 bytes) DD-MM-YY
  Ј	Date of last daily totals record in FM (3 bytes) DD-MM-YY
  Ј	Number of first daily totals record in FM (2 bytes) 0000Е2100
  Ј	Number of last daily totals record in FM (2 bytes) 0000Е2100

******************************************************************************)

function TFiscalPrinterDevice.ReportOnNumberRange(ReportType: Byte;
  Range: TDayNumberRange): TDayRange;
var
  Data: string;
begin
  FLogger.Debug(Format('ReportOnDateRange(%d,%d,%d)',
    [ReportType, Range.Number1, Range.Number2]));

  Data := Execute(#$67 +
    IntToBin(GetTaxPassword, 4) +
    Chr(ReportType) +
    IntToBin(Range.Number1, 2) +
    IntToBin(Range.Number2, 2));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Interrupt Full Report

  Command:	68H. Length: 5 bytes.
  Ј	Tax Officer password (4 bytes)
  Answer:		68H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.InterruptReport;
begin
  Execute(#$68 + IntToBin(GetTaxPassword, 4));
end;

(******************************************************************************

  Get Fiscalization/Refiscalization Parameters

  Command:	69H. Length: 6 bytes.
  Ј	Tax Officer password (4 bytes) password of Tax Officer who fiscalized the printer
  Ј	Fiscalization/Refiscalization number (1 byte) 1Е16
  Answer:		69H. Length: 22 bytes.
  Ј	Result Code (1 byte)
  Ј	Password (4 bytes)
  Ј	ECRRN (5 bytes) 0000000000Е9999999999
  Ј	Taxpayer ID (6 bytes) 000000000000Е999999999999
  Ј	Number of the last daily totals record in FM before fiscalization/refiscalization (2 bytes) 0000Е2100
  Ј	Fiscalization/Refiscalization date (3 bytes) DD-MM-YY

******************************************************************************)

function TFiscalPrinterDevice.ReadFiscInfo(FiscNumber: Byte): TFiscInfo;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('ReadFiscInfo((%d)',
    [FiscNumber]));

  Stream := TBinStream.Create;
  try
    Stream.Data := Execute(#$69 + IntToBin(GetTaxPassword, 4) + Chr(FiscNumber));

    Result.Password := Stream.ReadInt(4);
    Result.PrinterID := Stream.ReadInt(5);
    Result.FiscalID := Stream.ReadInt(6);
    Result.DayNumber := Stream.ReadInt(2);
    Stream.Read(Result.Date, Sizeof(Result.Date));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Open Fiscal Slip

  Command:	70H. Length: 26 bytes.
  Ј	Operator password (4 bytes)
  Ј	Slip type (1 byte) '0' - Sale, '1' - Buy, '2' - Sale Refund, '3' - Buy Refund
  Ј	Slip duplicates type (1 byte) '0' - duplicates as columns, '1' - duplicates as line blocks
  Ј	Number of duplicates (1 byte) 0Е5
  Ј	Spacing between Original and Duplicate 1 (1 byte) *
  Ј	Spacing between Duplicate 1 and Duplicate 2 (1 byte) *
  Ј	Spacing between Duplicate 2 and Duplicate 3 (1 byte) *
  Ј	Spacing between Duplicate 3 and Duplicate 4 (1 byte) *
  Ј	Spacing between Duplicate 4 and Duplicate 5 (1 byte) *
  Ј	Font number of fixed header (1 byte)
  Ј	Font number of header (1 byte)
  Ј	Font number of EKLZ serial number (1 byte)
  Ј	Font number of KPK value and KPK number (1 byte)
  Ј	Vertical position of the first line of fixed header (1 byte)
  Ј	Vertical position of the first line of header (1 byte)
  Ј	Vertical position of line with EKLZ number (1 byte)
  Ј	Vertical position of line with duplicate marker (1 byte)
  Ј	Horizontal position of fixed header in line (1 byte)
  Ј	Horizontal position of header in line (1 byte)
  Ј	Horizontal position of EKLZ number in line (1 byte)
  Ј	Horizontal position of KPK value and KPK number in line (1 byte)
  Ј	Horizontal position of duplicate marker in line (1 byte)
  Answer:		70H. Length: 5 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	Current receipt number (2 bytes)

******************************************************************************)

function TFiscalPrinterDevice.OpenSlipDoc(Params: TSlipParams): TDocResult;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($70);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Open Standard Fiscal Slip

  Command:	71H. Length: 13 bytes.
  Ј	Operator password (4 bytes)
  Ј	Slip type (1 byte) '0' - Sale, '1' - Buy, '2' - Sale Refund, '3' - Buy Refund
  Ј	Slip duplicates type (1 byte) '0' - duplicates as columns, '1' - duplicates as line blocks
  Ј	Number of duplicates (1 byte) 0Е5
  Ј	Spacing between Original and Duplicate 1 (1 byte) *
  Ј	Spacing between Duplicate 1 and Duplicate 2 (1 byte) *
  Ј	Spacing between Duplicate 2 and Duplicate 3 (1 byte) *
  Ј	Spacing between Duplicate 3 and Duplicate 4 (1 byte) *
  Ј	Spacing between Duplicate 4 and Duplicate 5 (1 byte) *
  Answer:		71H. Length: 5 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	Current receipt number (2 bytes)

******************************************************************************)

function TFiscalPrinterDevice.OpenStdSlip(Params: TStdSlipParams): TDocResult;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($71);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Transaction On Slip

  Command:	72H. Length: 82 bytes.
  Ј	Operator password (4 bytes)
  Ј	Quantity format (1 byte) '0' - no digits after decimal dot, '1' - digits after decimal dot
  Ј	Number of lines in transaction block (1 byte) 1Е3
  Ј	Line number of Text element in transaction block (1 byte) 0Е3, '0' - do not print
  Ј	Line number of Quantity Times Unit Price element in transaction block (1 byte) 0Е3, '0' - do not print
  Ј	Line number of Transaction Sum element in transaction block (1 byte) 1Е3
  Ј	Line number of Department element in transaction block (1 byte) 1Е3
  Ј	Font type of Text element (1 byte)
  Ј	Font type of Quantity element (1 byte)
  Ј	Font type of Multiplication sign element (1 byte)
  Ј	Font type of Unit Price element (1 byte)
  Ј	Font type of Transaction Sum element (1 byte)
  Ј	Font type of Department element (1 byte)
  Ј	Length of Text element in characters (1 byte)
  Ј	Length of Quantity element in characters (1 byte)
  Ј	Length of Unit Price element in characters (1 byte)
  Ј	Length of Transaction Sum element in characters (1 byte)
  Ј	Length of Department element in characters (1 byte)
  Ј	Position in line of Text element (1 byte)
  Ј	Position in line of Quantity Times Unit Price element (1 byte)
  Ј	Position in line of Transaction Sum element (1 byte)
  Ј	Position in line of Department element (1 byte)
  Ј	Slip line number with the first line of transaction block (1 byte)
  Ј	Quantity (5 bytes)
  Ј	Unit Price (5 bytes)
  Ј	Department (1 byte) 0Е16
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		72H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.SlipOperation(Params: TSlipOperation;
  Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($72);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Standard Transaction On Slip
  
  Command:	73H. Length: 61 bytes.
  Ј	Operator password (4 bytes)
  Ј	Slip line number with the first line of transaction block (1 byte)
  Ј	Quantity (5 bytes)
  Ј	Unit Price (5 bytes)
  Ј	Department (1 byte) 0Е16
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		73H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.SlipStdOperation(LineNumber: Byte;
  Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($73);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(LineNumber);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Discount/Surcharge On Slip
  
  Command:	74H. Length: 68 bytes.
  Ј	Operator password (4 bytes)
  Ј	Number of lines in transaction block (1 byte) 1Е2
  Ј	Line number of Text element in transaction block (1 byte) 0Е2, '0' - do not print
  Ј	Line number of Transaction Name element in transaction block (1 byte) 1Е2
  Ј	Line number of Transaction Sum element in transaction block (1 byte) 1Е2
  Ј	Font type of Text element (1 byte)
  Ј	Font type of Transaction Name element (1 byte)
  Ј	Font type of Transaction Sum element (1 byte)
  Ј	Length of Text element in characters (1 byte)
  Ј	Length of Transaction Sum element in characters (1 byte)
  Ј	Position in line of Text element (1 byte)
  Ј	Position in line of Transaction Name element (1 byte)
  Ј	Position in line of Transaction Sum element (1 byte)
  Ј	Transaction type (1 byte) '0' - Discount, '1' - Surcharge
  Ј	Slip line number with the first line of Discount/Surcharge block (1 byte)
  Ј	Transaction Sum (5 bytes)
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		74H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.SlipDiscount(Params: TSlipDiscountParams;
  Discount: TSlipDiscount): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($74);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(GetLine(Discount.Text));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Standard Discount/Surcharge On Slip

  Command:	75H. Length: 56 bytes.
  Ј	Operator password (4 bytes)
  Ј	Transaction type (1 byte) '0' - Discount, '1' - Surcharge
  Ј	Slip line number with the first line of Discount/Surcharge block (1 byte)
  Ј	Transaction Sum (5 bytes)
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		75H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.SlipStdDiscount(Discount: TSlipDiscount): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($75);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(GetLine(Discount.Text));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Close Fiscal Slip
  
  Command:	76H. Length: 182 bytes.
  Ј	Operator password (4 bytes)
  Ј	Number of lines in transaction block (1 byte) 1Е17
  Ј	Line number of Receipt Total element in transaction block (1 byte) 1Е17
  Ј	Line number of Text element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Cash Payment element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Payment Type 2 element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Payment Type 3 element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Payment Type 4 element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Change element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Tax 1 Turnover element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Tax 2 Turnover element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Tax 3 Turnover element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Tax 4 Turnover element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Tax 1 Sum element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Tax 2 Sum element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Tax 3 Sum element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Tax 4 Sum element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Receipt Subtotal Before Discount/Surcharge element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Line number of Discount/Surcharge Value element in transaction block (1 byte) 0Е17, '0' - do not print
  Ј	Font type of Text element (1 byte)
  Ј	Font type of 'TOTAL' element (1 byte)
  Ј	Font type of Receipt Total Value element (1 byte)
  Ј	Font type of 'CASH' element (1 byte)
  Ј	Font type of Cash Payment Value element (1 byte)
  Ј	Font type of Payment Type 2 Name element (1 byte)
  Ј	Font type of Payment Type 2 Value element (1 byte)
  Ј	Font type of Payment Type 3 Name element (1 byte)
  Ј	Font type of Payment Type 3 Value element (1 byte)
  Ј	Font type of Payment Type 4Name element (1 byte)
  Ј	Font type of Payment Type 4Value element (1 byte)
  Ј	Font type of 'CHANGE' element (1 byte)
  Ј	Font type of Change Value element (1 byte)
  Ј	Font type of Tax 1 Name element (1 byte)
  Ј	Font type of Tax 1 Turnover Value element (1 byte)
  Ј	Font type of Tax 1 Rate element (1 byte)
  Ј	Font type of Tax 1 Value element (1 byte)
  Ј	Font type of Tax 2 Name element (1 byte)
  Ј	Font type of Tax 2 Turnover Value element (1 byte)
  Ј	Font type of Tax 2 Rate element (1 byte)
  Ј	Font type of Tax 2 Value element (1 byte)
  Ј	Font type of Tax 3 Name element (1 byte)
  Ј	Font type of Tax 3 Turnover Value element (1 byte)
  Ј	Font type of Tax 3 Rate element (1 byte)
  Ј	Font type of Tax 3 Value element (1 byte)
  Ј	Font type of Tax 4 Name element (1 byte)
  Ј	Font type of Tax 4 Turnover Value element (1 byte)
  Ј	Font type of Tax 4 Rate element (1 byte)
  Ј	Font type of Tax 4 Value element (1 byte)
  Ј	Font type of 'SUBTOTAL' element (1 byte)
  Ј	Font type of Receipt Subtotal Before Discount/Surcharge Value element (1 byte)
  Ј	Font type of 'DISCOUNT XX.XX%' element (1 byte)
  Ј	Font type of Receipt Discount Value element (1 byte)
  Ј	Length of Text element in characters (1 byte)
  Ј	Length of Receipt Total Value element in characters (1 byte)
  Ј	Length of Cash Payment Value element in characters (1 byte)
  Ј	Length of Payment Type 2 Value element in characters (1 byte)
  Ј	Length of Payment Type 3 Value element in characters (1 byte)
  Ј	Length of Payment Type 4Value element in characters (1 byte)
  Ј	Length of Change Value element in characters (1 byte)
  Ј	Length of Tax 1 Name element in characters (1 byte)
  Ј	Length of Tax 1 Turnover element in characters (1 byte)
  Ј	Length of Tax 1 Rate element in characters (1 byte)
  Ј	Length of Tax 1 Value element in characters (1 byte)
  Ј	Length of Tax 2 Name element in characters (1 byte)
  Ј	Length of Tax 2 Turnover element in characters (1 byte)
  Ј	Length of Tax 2 Rate element in characters (1 byte)
  Ј	Length of Tax 2 Value element in characters (1 byte)
  Ј	Length of Tax 3 Name element in characters (1 byte)
  Ј	Length of Tax 3 Turnover element in characters (1 byte)
  Ј	Length of Tax 3 Rate element in characters (1 byte)
  Ј	Length of Tax 3 Value element in characters (1 byte)
  Ј	Length of Tax 4 Name element in characters (1 byte)
  Ј	Length of Tax 4 Turnover element in characters (1 byte)
  Ј	Length of Tax 4 Rate element in characters (1 byte)
  Ј	Length of Tax 4 Value element in characters (1 byte)
  Ј	Length of Receipt Subtotal Before Discount/Surcharge Value element in characters (1 byte)
  Ј	Length of 'DISCOUNT XX.XX%' element in characters (1 byte)
  Ј	Length of Receipt Discount Value element in characters (1 byte)
  Ј	Position in line of Text element (1 byte)
  Ј	Position in line of 'TOTAL' element (1 byte)
  Ј	Position in line of Receipt Total Value element (1 byte)
  Ј	Position in line of 'CASH' element (1 byte)
  Ј	Position in line of Cash Payment Value element (1 byte)
  Ј	Position in line of Payment Type 2 Name element (1 byte)
  Ј	Position in line of Payment Type 2 Value element (1 byte)
  Ј	Position in line of Payment Type 3 Name element (1 byte)
  Ј	Position in line of Payment Type 3 Value element (1 byte)
  Ј	Position in line of Payment Type 4 Name element (1 byte)
  Ј	Position in line of Payment Type 4 Value element (1 byte)
  Ј	Position in line of 'CHANGE' element (1 byte)
  Ј	Position in line of Change Value element (1 byte)
  Ј	Position in line of Tax 1 Name element (1 byte)
  Ј	Position in line of Tax 1 Turnover Value element (1 byte)
  Ј	Position in line of Tax 1 Rate element (1 byte)
  Ј	Position in line of Tax 1 Value element (1 byte)
  Ј	Position in line of Tax 2 Name element (1 byte)
  Ј	Position in line of Tax 2 Turnover Value element (1 byte)
  Ј	Position in line of Tax 2 Rate element (1 byte)
  Ј	Position in line of Tax 2 Value element (1 byte)
  Ј	Position in line of Tax 3 Name element (1 byte)
  Ј	Position in line of Tax 3 Turnover Value element (1 byte)
  Ј	Position in line of Tax 3 Rate element (1 byte)
  Ј	Position in line of Tax 3 Value element (1 byte)
  Ј	Position in line of Tax 4 Name element (1 byte)
  Ј	Position in line of Tax 4 Turnover Value element (1 byte)
  Ј	Position in line of Tax 4 Rate element (1 byte)
  Ј	Position in line of Tax 4 Value element (1 byte)
  Ј	Position in line of 'SUBTOTAL' element (1 byte)
  Ј	Position in line of Receipt Subtotal Before Discount/Surcharge Value element (1 byte)
  Ј	Position in line of 'DISCOUNT XX.XX%' element (1 byte)
  Ј	Position in line of Receipt Discount Value element (1 byte)
  Ј	Slip line number with the first line of Close Fiscal Slip block (1 byte)
  Ј	Cash Payment value (5 bytes)
  Ј	Payment Type 2 value (5 bytes)
  Ј	Payment Type 3 value (5 bytes)
  Ј	Payment Type 4 value (5 bytes)
  Ј	Receipt Discount Value 0 to 99,99 % (2 bytes) 0000Е9999
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		76H. Length: 8 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	Change value (5 bytes) 0000000000Е9999999999

******************************************************************************)

function TFiscalPrinterDevice.SlipClose(Params: TCloseReceiptParams): TCloseReceiptResult;
begin
(*
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($76);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, sizeof(Params));

    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(Discount.Text, PrintWidth);

    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
  *)
end;


(******************************************************************************

  Sale

  Command:	80H. Length: 60 bytes.
  Ј	Operator password (4 bytes)
  Ј	Quantity (5 bytes) 0000000000Е9999999999
  Ј	Unit Price (5 bytes) 0000000000Е9999999999
  Ј	Department (1 byte) 0Е16
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		80H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

procedure TFiscalPrinterDevice.UpdateDepartment(var P: TPriceReg);
var
  S: string;
  V, Code: Integer;
begin
  if Parameters.DepartmentInText then
  begin
    S := Copy(P.Text, 1, 2);
    Val(S, V, Code);
    if (Code = 0)and(V in [1..16]) then
    begin
      P.Department := V;
      P.Text := Copy(P.Text, 3, Length(P.Text));
    end;
  end;
end;

function TFiscalPrinterDevice.Sale(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  UpdateDepartment(Operation);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($80);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.Sale(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Buy

  Command:	81H. Length: 60 bytes.
  Ј	Operator password (4 bytes)
  Ј	Quantity (5 bytes) 0000000000Е9999999999
  Ј	Unit Price (5 bytes) 0000000000Е9999999999
  Ј	Department (1 byte) 0Е16
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		81H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.Buy(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  UpdateDepartment(Operation);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($81);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.Buy(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Sale Refund

  Command:	82H. Length: 60 bytes.
  Ј	Operator password (4 bytes)
  Ј	Quantity (5 bytes) 0000000000Е9999999999
  Ј	Unit Price (5 bytes) 0000000000Е9999999999
  Ј	Department (1 byte) 0Е16
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		82H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.RetSale(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  UpdateDepartment(Operation);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($82);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.RetSale(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Buy Refund

  Command:	83H. Length: 60 bytes.
  Ј	Operator password (4 bytes)
  Ј	Quantity (5 bytes) 0000000000Е9999999999
  Ј	Unit Price (5 bytes) 0000000000Е9999999999
  Ј	Department (1 byte) 0Е16
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		83H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.RetBuy(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  UpdateDepartment(Operation);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($83);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.RetBuy(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Void Transaction
  
  Command:	84H. Length: 60 bytes.
  Ј	Operator password (4 bytes)
  Ј	Quantity (5 bytes) 0000000000Е9999999999
  Ј	Unit Price (5 bytes) 0000000000Е9999999999
  Ј	Department (1 byte) 0Е16
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		84H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.Storno(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($84);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.Storno(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Close Receipt
  
  Command:	85H. Length: 71 bytes.
  Ј	Operator password (4 bytes)
  Ј	Cash Payment value (5 bytes) 0000000000Е9999999999
  Ј	Payment Type 2 value (5 bytes) 0000000000Е9999999999
  Ј	Payment Type 3 value (5 bytes) 0000000000Е9999999999
  Ј	Payment Type 4 value (5 bytes) 0000000000Е9999999999
  Ј	Receipt Percentage Discount/Surcharge Value 0 to 99,99 % (2 bytes with sign) -9999Е9999, surcharge if value is negative
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		85H. Length: 8 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	Change value (5 bytes) 0000000000Е9999999999

******************************************************************************)

function TFiscalPrinterDevice.ReceiptClose(const P: TCloseReceiptParams;
  var R: TCloseReceiptResult): Integer;
var
  Stream: TBinStream;
begin
  FFilter.BeforeCloseReceipt;
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($85);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(P.CashAmount, 5);
    Stream.WriteInt(P.Amount2, 5);
    Stream.WriteInt(P.Amount3, 5);
    Stream.WriteInt(P.Amount4, 5);
    Stream.WriteInt(P.PercentDiscount, 2);
    Stream.WriteInt(P.Tax1, 1);
    Stream.WriteInt(P.Tax2, 1);
    Stream.WriteInt(P.Tax3, 1);
    Stream.WriteInt(P.Tax4, 1);
    Stream.WriteString(GetLine(P.Text));
    Result := ExecuteStream(Stream);
    if Result = 0 then
    begin
      Stream.Read(R, sizeof(R));
      FFilter.CloseReceipt(P, R);
    end;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Discount

  Command:	86H. Length: 54 bytes.
  Ј	Operator password (4 bytes)
  Ј	Discount value (5 bytes) 0000000000Е9999999999
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		86H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptDiscount(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($86);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.ReceiptDiscount(Operation);
  finally
    Stream.Free;
  end;
end;

(*
—кидка, надбавка  на чек дл€ –оснефти FF4BH
   од команды FF4Bh . ƒлина сообщени€:  145 байт.
  ѕароль системного администратора: 4 байта
  —кидка:         5 байт
  Ќадбавка:    5 байт
  Ќалог:  1 байт
  ќписание скидки или надбавки: 128 байт ASCII
ќтвет:    FF4Bh ƒлина сообщени€: 1 байт.
   од ошибки: 1 байт

*)

function TFiscalPrinterDevice.ReceiptDiscount2(
  Operation: TReceiptDiscount2): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$4B +
    IntToBin(GetUsrPassword, 4) +
    IntToBin(Operation.Discount, 5) +
    IntToBin(Operation.Charge, 5) +
    IntToBin(Operation.Tax, 1) +
    GetLine(Operation.Text);
  Result := ExecuteData(Command, Answer);
end;

(******************************************************************************

  Surcharge

  Command:	87H. Length: 54 bytes.
  Ј	Operator password (4 bytes)
  Ј	Surcharge value (5 bytes) 0000000000Е9999999999
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		87H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptCharge(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($87);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.ReceiptDiscount(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Cancel Receipt

  Command:	88H. Length: 5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		88H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptCancel: Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($88);
    Stream.WriteDWORD(GetUsrPassword);
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.CancelReceipt;
  finally
    Stream.Free;
  end;
end;

procedure TFiscalPrinterDevice.CancelReceipt;
begin
  if IsRecOpened then
  begin
    ReceiptCancel;
    WaitForPrinting;
  end;
end;

(******************************************************************************

  Get Receipt Subtotal

  Command:	89H. Length: 5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		89H. Length: 8 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30
  Ј	Receipt Subtotal (5 bytes) 0000000000Е9999999999

******************************************************************************)

function TFiscalPrinterDevice.GetSubtotal: Int64;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($89);
    Stream.WriteDWORD(GetUsrPassword);
    Check(ExecuteStream(Stream));
    Stream.ReadByte;
    Result := Stream.ReadInt(5);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Void Discount

  Command:	8AH. Length: 54 bytes.
  Ј	Operator password (4 bytes)
  Ј	Void Discount value (5 bytes) 0000000000Е9999999999
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		8AH. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptStornoDiscount(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8A);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Void Surcharge

  Command:	8BH. Length: 54 bytes.
  Ј	Operator password (4 bytes)
  Ј	Void Surcharge value (5 bytes) 0000000000Е9999999999
  Ј	Tax 1 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 2 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 3 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Tax 4 (1 byte) '0' - no tax, '1'Е'4' - tax ID
  Ј	Text (40 bytes)
  Answer:		8BH. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptStornoCharge(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8B);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetLine(Operation.Text));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Last Receipt Duplicate

  Command:	8CH. Length: 5 bytes.
  Ј	Operator password (4 bytes)
  Answer:		8CH. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.PrintReceiptCopy: Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8C);
    Stream.WriteDWORD(GetUsrPassword);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Open Receipt

  Command:	8DH. Length: 6 bytes.
  Ј	Operator password (4 bytes)
  Ј	Receipt type (1 byte):		0 - Sale;
  1 - Buy;
  2 - Sale Refund;
  3 - Buy Refund.
  Answer:		8DH. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.OpenReceipt(ReceiptType: Byte): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8D);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(ReceiptType);
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.OpenReceipt(ReceiptType);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Continue Printing

  Command:	B0H. Length: 5 bytes.
  Ј	Operator, Administrator or System Administrator password (4 bytes)
  Answer:		B0H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.ContinuePrint: Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($B0);
    Stream.WriteDWORD(GetUsrPassword);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Load Graphics In FP

  Command: 	C0H. Length: 46 bytes.
  Ј	Operator password (4 bytes)
  Ј	Graphics line number (1 byte) 0Е199
  Ј	Graphical data (40 bytes)
  Answer:		C0H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.LoadGraphics1(Line: Byte; Data: string): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C0);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(Line);
    Stream.WriteString(GetLine(Data, 40, 40));
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
      FModelData.CapGraphics := False;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Graphics

  Command:	C1H. Length: 7 bytes.
  Ј	Operator password (4 bytes)
  Ј	Number of first line of preloaded graphics to be printed (1 byte) 1Е200
  Ј	Number of last line of preloaded graphics to be printed (1 byte) 1Е200
  Answer:		C1H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.PrintGraphics1(Line1, Line2: Byte): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C1);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(Line1);
    Stream.WriteByte(Line2);
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
      FModelData.CapGraphics := False;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Bar Code

  Command:	C2H. Length: 10 bytes.
  Ј	Operator password (4 bytes)
  Ј	Bar code (5 bytes) 000000000000Е999999999999
  Answer:		C2H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.PrintBarcode(const Barcode: string): Integer;
var
  IBarcode: Int64;
  Stream: TBinStream;
begin
  IBarcode := StrToInt64(Copy(Barcode, 1, 12));
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C2);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(IBarcode, 5);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Extended Graphics Load In FP

  Command: 	C3H. Length: 47 bytes.
  Ј	Operator password (4 bytes)
  Ј	Graphics line number (2 bytes) 0Е1199
  Ј	Graphical data (40 bytes)
  Answer:		C3H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.PrintGraphics2(Line1, Line2: Word): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C3);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Line1, 2);
    Stream.WriteInt(Line2, 2);
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
      FModelData.CapGraphicsEx := False;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Extended Graphics

  Command:	C4H. Length: 9 bytes.
  Ј	Operator password (4 bytes)
  Ј	Number of first line of preloaded graphics to be printed (1 byte) 1Е1200
  Ј	Number of last line of preloaded graphics to be printed (1 byte) 1Е1200
  Answer:		C4H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.LoadGraphics2(Line: Word; Data: string): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C4);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Line, 2);
    Stream.WriteString(GetLine(Data, 40, 40));
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
      FModelData.CapGraphicsEx := False;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Graphical Line

  Command: 	C5H. Length: X + 7 bytes.
  Ј	Operator password (4 bytes)
  Ј	Number of repetitions (2 bytes)
  Ј	Graphical data (X bytes)
  Answer:		C5H. Length: 3 bytes.
  Ј	Result Code (1 byte)
  Ј	Operator index number (1 byte) 1Е30

******************************************************************************)

function TFiscalPrinterDevice.PrintBinaryLine(Height: Word; Data: string): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C5);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Height, 2);
    Stream.WriteString(Data);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get Device Type

  Command:	FCH. Length: 1 byte.
  Answer:		FCH. Length: (8+X) bytes.
  Ј	Result Code (1 byte)
  Ј	Device type (1 byte) 0Е255
  Ј	Device subtype (1 byte) 0Е255
  Ј	Protocol version supported by device (1 byte) 0Е255
  Ј	Subprotocol version supported by device (1 byte) 0Е255
  Ј	Device model (1 byte) 0Е255
  Ј	Language (1 byte) 0Е255, '0' - Russian, '1' - English
  Ј	Device name (X bytes) string of WIN1251 code page characters;
    string length in bytes depends on device model

******************************************************************************)

function TFiscalPrinterDevice.ReadDeviceMetrics: TDeviceMetrics;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($FC);
    Check(ExecuteStream(Stream));
    Result.DeviceType := Stream.ReadByte;
    Result.DeviceSubType := Stream.ReadByte;
    Result.ProtocolVersion := Stream.ReadByte;
    Result.ProtocolSubVersion := Stream.ReadByte;
    Result.Model := Stream.ReadByte;
    Result.Language := Stream.ReadByte;
    Result.DeviceName := Stream.ReadString;
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.FieldToInt(FieldInfo: TPrinterFieldRec;
  const Value: string): Integer;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := BinToInt(Value, 1, FieldInfo.Size);
    PRINTER_FIELD_TYPE_STR: raise Exception.Create('Field type is not integer');
  else
    raise Exception.Create('Invalid field type');
  end;
end;

function TFiscalPrinterDevice.FieldToStr(FieldInfo: TPrinterFieldRec;
  const Value: string): string;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := IntToStr(BinToInt(Value, 1, FieldInfo.Size));
    PRINTER_FIELD_TYPE_STR: Result := PChar(Value);
  else
    raise Exception.Create('Invalid field type');
  end;
end;

function TFiscalPrinterDevice.BinToFieldValue(
  FieldInfo: TPrinterFieldRec;
  const Value: string): string;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := IntToStr(BinToInt(Value, 1, FieldInfo.Size));
    PRINTER_FIELD_TYPE_STR: Result := Value;
  else
    raise Exception.Create('Invalid field type');
  end;
end;

function TFiscalPrinterDevice.GetFieldValue(FieldInfo: TPrinterFieldRec; const Value: string): string;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := IntToBin(StrToInt(Value), FieldInfo.Size);
    PRINTER_FIELD_TYPE_STR: Result := GetLine(Value, FieldInfo.Size, FieldInfo.Size);
  else
    raise Exception.Create('Invalid field type');
  end;
end;

function TFiscalPrinterDevice.WriteTable(
  Table, Row, Field: Integer;
  const FieldValue: string): Integer;
var
  Data: string;
  FieldInfo: TPrinterFieldRec;
begin
  Result := 0;
  //if ReadTableStr(Table, Row, Field) = FieldValue then Exit; { !!! }

  FieldInfo := ReadFieldStructure(Table, Field);
  if ValidFieldValue(FieldInfo, FieldValue) then
  begin
    Data := GetFieldValue(FieldInfo, FieldValue);
    Result := DoWriteTable(Table, Row, Field, Data);
  end else
  begin
    Logger.Error(Format('Invalid field value, "%s"', [FieldValue]));
  end;
end;

function TFiscalPrinterDevice.WriteTableInt(
  Table, Row, Field, Value: Integer): Integer;
begin
  Result := WriteTable(Table, Row, Field, IntToStr(Value));
end;

function TFiscalPrinterDevice.ReadTableInt(Table, Row, Field: Integer): Integer;
var
  Data: string;
  FieldInfo: TPrinterFieldRec;
begin
  FieldInfo := ReadFieldStructure(Table, Field);
  Data := ReadTableBin(Table, Row, Field);
  Result := FieldToInt(FieldInfo, Data);
end;

function TFiscalPrinterDevice.ReadTableStr(Table, Row, Field: Integer): string;
var
  Data: string;
  FieldInfo: TPrinterFieldRec;
begin
  FieldInfo := ReadFieldStructure(Table, Field);
  Data := ReadTableBin(Table, Row, Field);
  Result := FieldToStr(FieldInfo, Data);
end;

(*******************************************************************************

  Read discount totals in day

  185, Discounts accumulation on sales in day
  186, Discounts accumulation on buys in day
  187, Discounts accumulation on sale refunds in day
  188, Discounts accumulation on buy refunds in day

*******************************************************************************)

function TFiscalPrinterDevice.GetDayDiscountTotal: Int64;
begin
  Result :=
    ReadCashRegister(185) +
    ReadCashRegister(188) -
    ReadCashRegister(186) -
    ReadCashRegister(187);
end;

(*******************************************************************************

  Discounts accumulation in receipt

  64, Discounts accumulation from sales in receipt
  65, Discounts accumulation from buys in receipt
  66, Discounts accumulation from sale refunds in receipt
  67, Discounts accumulation from buy refunds in receipt

*******************************************************************************)

function TFiscalPrinterDevice.GetRecDiscountTotal: Int64;
begin
  Result :=
    ReadCashRegister(64) +
    ReadCashRegister(67) -
    ReadCashRegister(65) -
    ReadCashRegister(66);
end;

(*******************************************************************************

  Sales accumulation in day

    121, Sales accumulation in 1 department in day
    125, Sales accumulation in 2 department in day
    129, Sales accumulation in 3 department in day
    133, Sales accumulation in 4 department in day
    137, Sales accumulation in 5 department in day
    141, Sales accumulation in 6 department in day
    145, Sales accumulation in 7 department in day
    149, Sales accumulation in 8 department in day
    153, Sales accumulation in 9 department in day
    157, Sales accumulation in 10 department in day
    161, Sales accumulation in 11 department in day
    165, Sales accumulation in 12 department in day
    169, Sales accumulation in 13 department in day
    173, Sales accumulation in 14 department in day
    177, Sales accumulation in 15 department in day
    181, Sales accumulation in 16 department in day

*******************************************************************************)

function TFiscalPrinterDevice.GetDayItemTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashRegister(121 + 4*i);
end;

(*******************************************************************************

  Sales accumulation in receipt

    0, Sales accumulation in 1 department in receipt
    4, Sales accumulation in 2 department in receipt
    8, Sales accumulation in 3 department in receipt
    12, Sales accumulation in 4 department in receipt
    16, Sales accumulation in 5 department in receipt
    20, Sales accumulation in 6 department in receipt
    24, Sales accumulation in 7 department in receipt
    28, Sales accumulation in 8 department in receipt
    32, Sales accumulation in 9 department in receipt
    36, Sales accumulation in 10 department in receipt
    40, Sales accumulation in 11 department in receipt
    44, Sales accumulation in 12 department in receipt
    48, Sales accumulation in 13 department in receipt
    52, Sales accumulation in 14 department in receipt
    56, Sales accumulation in 15 department in receipt
    60, Sales accumulation in 16 department in receipt

*******************************************************************************)

function TFiscalPrinterDevice.GetRecItemTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashRegister(4*i);
end;

(*******************************************************************************

  Sales refund accumulation in day

    123, Sales refund accumulation in 1 department in day
    127, Sales refund accumulation in 2 department in day
    131, Sales refund accumulation in 3 department in day
    135, Sales refund accumulation in 4 department in day
    139, Sales refund accumulation in 5 department in day
    143, Sales refund accumulation in 6 department in day
    147, Sales refund accumulation in 7 department in day
    151, Sales refund accumulation in 8 department in day
    155, Sales refund accumulation in 9 department in day
    159, Sales refund accumulation in 10 department in day
    163, Sales refund accumulation in 11 department in day
    167, Sales refund accumulation in 12 department in day
    171, Sales refund accumulation in 13 department in day
    175, Sales refund accumulation in 14 department in day
    179, Sales refund accumulation in 15 department in day
    183, Sales refund accumulation in 16 department in day

*******************************************************************************)

function TFiscalPrinterDevice.GetDayItemVoidTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashRegister(123 + 4*i);
end;

(*******************************************************************************

  Sales refund accumulation in receipt

    2, Sales refund accumulation in 1 department in receipt
    6, Sales refund accumulation in 2 department in receipt
    10, Sales refund accumulation in 3 department in receipt
    14, Sales refund accumulation in 4 department in receipt
    18, Sales refund accumulation in 5 department in receipt
    22, Sales refund accumulation in 6 department in receipt
    26, Sales refund accumulation in 7 department in receipt
    30, Sales refund accumulation in 8 department in receipt
    34, Sales refund accumulation in 9 department in receipt
    38, Sales refund accumulation in 10 department in receipt
    42, Sales refund accumulation in 11 department in receipt
    46, Sales refund accumulation in 12 department in receipt
    50, Sales refund accumulation in 13 department in receipt
    54, Sales refund accumulation in 14 department in receipt
    58, Sales refund accumulation in 15 department in receipt
    62, Sales refund accumulation in 16 department in receipt

*******************************************************************************)

function TFiscalPrinterDevice.GetRecItemVoidTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashRegister(2 + 4*i);
end;

(*******************************************************************************

  Get Data Of EKLZ Daily Totals Report

  Command:	BAH. Length: 7 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Number of daily totals (2 bytes) 0000Е2100
  Answer:		BAH. Length: 18 bytes.
  Ј	Result Code (1 byte)
  Ј	ECR model (16 bytes) string of WIN1251 code page characters

*******************************************************************************)

function TFiscalPrinterDevice.GetEJSesssionResult(Number: Word;
  var Text: string): Integer;
var
  Data: string;
begin
  Data := #$BA + IntToBin(GetSysPassword, 4) + IntToBin(Number, 2);
  Result := ExecuteData(Data, Text);
end;

(*******************************************************************************

«апрос итога активизации Ё Ћ«
 оманда: BBH. ƒлина сообщени€: 5 байт.
ѕароль системного администратора (4 байта)
ќтвет: BBH. ƒлина сообщени€: 18 байт.
 од ошибки (1 байт)
“ип   ћ Ц строка символов в кодировке WIN1251 (16 байт)

*******************************************************************************)

function TFiscalPrinterDevice.ReadEJActivation(var Line: string): Integer;
begin
  Result := ExecuteData(#$BB + IntToBin(GetSysPassword, 4), Line);
  Line := TrimRight(PChar(Line));
end;

(*******************************************************************************

  Get Data Of EKLZ Report

  Command:	B3H. Length: 5 bytes.
  Ј	System Administrator password (4 bytes) 30
  Answer:		B3H. Length: (2+X) bytes.
  Ј	Result Code (1 byte)
  Ј	Report part or line (X bytes)

*******************************************************************************)

function TFiscalPrinterDevice.GetEJReportLine(var Line: string): Integer;
begin
  Result := ExecuteData(#$B3 + IntToBin(GetSysPassword, 4), Line);
  Line := TrimRight(PChar(Line));
end;

(*******************************************************************************

  Cancel Active EKLZ Operation

  Command:	ACH. Length: 5 bytes.
  Ј	System Administrator password (4 bytes) 30
  Answer:		ACH. Length: 2 bytes.
  Ј	Result Code (1 byte)

*******************************************************************************)

function TFiscalPrinterDevice.EJReportStop: Integer;
var
  RxData: string;
begin
  Result := ExecuteData(#$AC + IntToBin(GetSysPassword, 4), RxData);
end;

function TFiscalPrinterDevice.DecodeEJFlags(Flags: Byte): TEJFlags;
begin
  Result.DocType := Flags and $03;      // bits 0,1
  Result.ArcOpened := TestBit(Flags, 2);
  Result.Activated := TestBit(Flags, 3);
  Result.ReportMode := TestBit(Flags, 4);
  Result.DocOpened := TestBit(Flags, 5);
  Result.DayOpened := TestBit(Flags, 6);
  Result.ErrorFlag := TestBit(Flags, 7);
end;

(*******************************************************************************

  Get EKLZ Status 1

  Command:	ADH. Length: 5 bytes.
  Ј	System Administrator password (4 bytes) 30
  Answer:		ADH. Length: 22 bytes.
  Ј	Result Code (1 byte)
  Ј	KPK value of last fiscal receipt (5 bytes) 0000000000Е9999999999
  Ј	Date of last KPK (3 bytes) DD-MM-YY
  Ј	Time of last KPK (2 bytes) HH-MM
  Ј	Number of last KPK (4 bytes) 00000000Е99999999
  Ј	EKLZ serial number (5 bytes) 0000000000Е9999999999
  Ј	EKLZ flags (1 byte)

*******************************************************************************)

function TFiscalPrinterDevice.GetEJStatus1(var Status: TEJStatus1): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($AD);
    Stream.WriteDWORD(GetSysPassword);
    Result := ExecuteStream(Stream);
    if Result = 0 then
    begin
      Status.DocAmount := Stream.ReadInt(5);
      Stream.Read(Status.DocDate, sizeof(Status.DocDate));
      Stream.Read(Status.DocTime, sizeof(Status.DocTime));
      Stream.Read(Status.DocNumber, sizeof(Status.DocNumber));
      Status.EJNumber := Stream.ReadInt(5);
      Status.Flags := DecodeEJFlags(Stream.ReadByte);
    end;
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.AlignLines(const Line1, Line2: string;
  LineWidth: Integer): string;
var
  S: string;
begin
  Result := Copy(Line2, 1, LineWidth);
  if Length(Result) < LineWidth then
  begin
    S := Copy(Line1, 1, LineWidth - Length(Result)-1);
    Result := S + StringOfChar(' ', LineWidth - Length(Result) - Length(S)) + Result;
  end;
end;

function TFiscalPrinterDevice.FormatLines(const Line1, Line2: string): string;
begin
  Result := AlignLines(Line1, Line2, GetPrintWidth);
end;

function TFiscalPrinterDevice.FormatBoldLines(const Line1, Line2: string): string;
begin
  Result := AlignLines(Line1, Line2, GetPrintWidth div 2);
end;

(******************************************************************************

  Print Daily Totals Report In Dates Range From EKLZ

  Command:	A2H. Length: 12 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Report type (1 byte) '0' - short, '1' - full
  Ј	Date of first daily totals in range (3 bytes) DD-MM-YY
  Ј	Date of last daily totals in range (3 bytes) DD-MM-YY
  Answer:		A2H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.EJTotalsReportDate(
  const Parameters: TDateReport);
begin
  Execute(#$A2 +
    IntToBin(GetSysPassword, 4) +
    Chr(Parameters.ReportType) +
    PrinterDateToBin(Parameters.Date1) +
    PrinterDateToBin(Parameters.Date2));
end;

(******************************************************************************

  Print Daily Totals Report In Daily Totals Numbers Range From EKLZ

  Command:	A3H. Length: 10 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Report type (1 byte) '0' - short, '1' - full
  Ј	Number of first daily totals in range (2 bytes) 0000Е2100
  Ј	Number of last daily totals in range (2 bytes) 0000Е2100
  Answer:		A3H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.EJTotalsReportNumber(
  const Parameters: TNumberReport);
begin
  Execute(#$A3 +
    IntToBin(GetSysPassword, 4) +
    Chr(Parameters.ReportType) +
    IntToBin(Parameters.Number1, 2) +
    IntToBin(Parameters.Number2, 2));
end;

function TFiscalPrinterDevice.GetModel: TPrinterModelRec;
begin
  Result := FModelData;
end;

function TFiscalPrinterDevice.GetPrinterModel: TPrinterModel;
begin
  if FModel = nil then
  begin
    FModel := SelectModel;
  end;
  Result := FModel;
end;

function TFiscalPrinterDevice.SelectModel: TPrinterModel;
var
  ModelID: Integer;
begin
  ModelID := GetDeviceMetrics.Model;
  Result := FModels.ItemByID(ModelID);
  if Result = nil then
  begin
    ModelID := DefaultModelID;
    Result := FModels.ItemByID(ModelID);
  end;

  if Result = nil then
    raise Exception.CreateFmt('Device model ID=%d not found', [ModelID]);

  FModelData := Result.Data;
  FModelData.CapGraphics := True;
  FModelData.CapGraphicsEx := True;

  WriteLogModelParameters(FModelData);
end;

function TFiscalPrinterDevice.GetOnCommand: TCommandEvent;
begin
  Result := FOnCommand;
end;

procedure TFiscalPrinterDevice.SetOnCommand(Value: TCommandEvent);
begin
  FOnCommand := Value;
end;

function TFiscalPrinterDevice.AlignLine(const Line: string;
  PrintWidth: Integer; Alignment: TTextAlignment = taLeft): string;
var
  L: Integer;
  L1: Integer;
  L2: Integer;
begin
  Result := TrimText(Line, PrintWidth);
  L := Length(Result);
  case Alignment of
    taCenter:
    begin
      L1 := (PrintWidth - L) div 2;
      L2 := PrintWidth - L -L1;
      Result := StringOfChar(' ', L1) + Result + StringOfChar(' ', L2);
    end;
    taRight:
    begin
      Result := StringOfChar(' ', PrintWidth-L) + Result;
    end;
  end;
end;

function TFiscalPrinterDevice.CenterLine(const Line: string): string;
var
  L: Integer;
  L1: Integer;
  L2: Integer;
begin
  Result := Trim(Line);
  Result := Copy(Result, 1, GetPrintWidth);
  L := Length(Result);
  L1 := (GetPrintWidth - L) div 2;
  L2 := GetPrintWidth - L -L1;
  Result := StringOfChar(' ', L1) + Result + StringOfChar(' ', L2);
end;

function TFiscalPrinterDevice.ProcessLine(const Line: string): Boolean;
var
  Barcode: TBarcodeRec;
begin
  Result := (Parameters.BarcodePrefix <> '')and(Pos(Parameters.BarcodePrefix, Line) = 1);
  if not Result then Exit;
  Barcode.Data := Copy(Line, Length(Parameters.BarcodePrefix) + 1, Length(Line));
  Barcode.Text := Barcode.Data;
  Barcode.Height := Parameters.BarcodeHeight;
  Barcode.BarcodeType := Parameters.BarcodeType;
  Barcode.ModuleWidth := Parameters.BarcodeModuleWidth;
  Barcode.Alignment := Parameters.BarcodeAlignment;
  Barcode.Parameter1 := Parameters.BarcodeParameter1;
  Barcode.Parameter2 := Parameters.BarcodeParameter2;
  Barcode.Parameter3 := Parameters.BarcodeParameter3;
  PrintBarcode2(Barcode);
end;

procedure TFiscalPrinterDevice.PrintLineFont(const Data: TTextRec);
var
  i: Integer;
  Line: string;
  Lines: TStrings;
  PrintWidth: Integer;
begin
  PrintWidth := GetPrintWidth(Data.Font);
  Lines := TStringList.Create;
  try
    if ProcessLine(Data.Text) then Exit;

    if Data.Wrap then
    begin
      SplitText(Data.Text, Data.Font, Lines);
    end else
    begin
      Lines.Add(Data.Text);
    end;

    for i := 0 to Lines.Count-1 do
    begin
      Line := Lines[i];
      Line := AlignLine(Line, PrintWidth, Data.Alignment);
      if CapPrintStringFont then
        PrintStringFont(Data.Station, Data.Font, Line)
      else
        PrintStringFont(Data.Station, Parameters.FontNumber, Line);
    end;
  finally
    Lines.Free;
  end;
end;

procedure TFiscalPrinterDevice.SplitText(const Text: string; Font: Integer;
  Lines: TStrings);
var
  Line: string;
  AText: string;
  PrintWidth: Integer;
begin
  Lines.Clear;
  PrintWidth := GetPrintWidth;
  AText := Text;
  Line := Copy(AText, 1, PrintWidth);
  AText := Copy(AText, PrintWidth + 1, Length(AText));
  repeat
    Lines.Add(Line);
    Line := Copy(AText, 1, PrintWidth);
    AText := Copy(AText, PrintWidth + 1, Length(AText));
  until Line = '';
end;

procedure TFiscalPrinterDevice.PrintTextFont(Station: Integer;
  Font: Integer; const Text: string);
var
  Data: TTextRec;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := Font;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;
  PrintText(Data);
end;

procedure TFiscalPrinterDevice.PrintText(Station: Integer; const Text: string);
var
  Data: TTextRec;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := Parameters.FontNumber;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;
  PrintText(Data);
end;

procedure TFiscalPrinterDevice.PrintText(const Data: TTextRec);
var
  i: Integer;
  Text: string;
  Line: TTextRec;
  Lines: TStrings;
begin
  Line := Data;
  Text := Data.Text;
  if Text = '' then Text := ' ';

  Lines := TStringList.Create;
  try
    Lines.Text := Text;
    for i := 0 to Lines.Count-1 do
    begin
      Line.Text := Lines[i];
      PrintLineFont(Line);
    end;
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterDevice.GetTables: TDeviceTables;
begin
  Result := FDeviceTables;
end;

procedure TFiscalPrinterDevice.SetTables(const Value: TDeviceTables);
begin
  FDeviceTables := Value;
end;

procedure TFiscalPrinterDevice.OpenPort(
  PortNumber, BaudRate, ByteTimeout: Integer);
begin
  Connection.OpenPort(PortNumber, BaudRate, ByteTimeout);
end;

procedure TFiscalPrinterDevice.ClaimDevice(PortNumber, Timeout: Integer);
begin
  Connection.ClaimDevice(PortNumber, Timeout);
end;

procedure TFiscalPrinterDevice.ReleaseDevice;
begin
  Connection.ReleaseDevice;
end;

procedure TFiscalPrinterDevice.Close;
begin
  ClosePort;
  FConnection := nil;
end;

procedure TFiscalPrinterDevice.Open(AConnection: IPrinterConnection);
begin
  FConnection := AConnection;
end;

procedure TFiscalPrinterDevice.ClosePort;
begin
  Connection.ClosePort;
  FIsOnline := False;
end;

procedure TFiscalPrinterDevice.WriteLogModelParameters(const Model: TPrinterModelRec);
begin
  Logger.Debug(Logger.Separator);
  Logger.LogParam('Model.ID', Model.ID);
  Logger.LogParam('Model.Name', Model.Name);
  Logger.LogParam('Model.CapShortEcrStatus', Model.CapShortEcrStatus);
  Logger.LogParam('Model.CapCoverSensor', Model.CapCoverSensor);
  Logger.LogParam('Model.CapJrnPresent', Model.CapJrnPresent);
  Logger.LogParam('Model.CapJrnEmptySensor', Model.CapJrnEmptySensor);
  Logger.LogParam('Model.CapJrnNearEndSensor', Model.CapJrnNearEndSensor);
  Logger.LogParam('Model.CapRecPresent', Model.CapRecPresent);
  Logger.LogParam('Model.CapRecEmptySensor', Model.CapRecEmptySensor);
  Logger.LogParam('Model.CapRecNearEndSensor', Model.CapRecNearEndSensor);
  Logger.LogParam('Model.CapSlpFullSlip', Model.CapSlpFullSlip);
  Logger.LogParam('Model.CapSlpEmptySensor', Model.CapSlpEmptySensor);
  Logger.LogParam('Model.CapSlpFiscalDocument', Model.CapSlpFiscalDocument);
  Logger.LogParam('Model.CapSlpNearEndSensor', Model.CapSlpNearEndSensor);
  Logger.LogParam('Model.CapSlpPresent', Model.CapSlpPresent);
  Logger.LogParam('Model.CapSetHeader', Model.CapSetHeader);
  Logger.LogParam('Model.CapSetTrailer', Model.CapSetTrailer);
  Logger.LogParam('Model.CapRecLever', Model.CapRecLever);
  Logger.LogParam('Model.CapJrnLever', Model.CapJrnLever);
  Logger.LogParam('Model.CapFixedTrailer', Model.CapFixedTrailer);
  Logger.LogParam('Model.CapDisableTrailer', Model.CapDisableTrailer);
  Logger.LogParam('Model.NumHeaderLines', Model.NumHeaderLines);
  Logger.LogParam('Model.NumTrailerLines', Model.NumTrailerLines);
  Logger.LogParam('Model.StartHeaderLine', Model.StartHeaderLine);
  Logger.LogParam('Model.StartTrailerLine', Model.StartTrailerLine);
  Logger.LogParam('Model.BaudRates', Model.BaudRates);
  Logger.LogParam('Model.PrintWidth', Model.PrintWidth);
  Logger.LogParam('Model.MaxGraphicsWidth', Model.MaxGraphicsWidth);
  Logger.LogParam('Model.MaxGraphicsHeight', Model.MaxGraphicsHeight);
  Logger.LogParam('Model.CapFullCut', Model.CapFullCut);
  Logger.LogParam('Model.CapPartialCut', Model.CapPartialCut);
  Logger.Debug(Logger.Separator);
end;

procedure TFiscalPrinterDevice.Check(Code: Integer);
begin
  if Code = 0 then Exit;
  RaiseError(Code, GetErrorText(Code));
end;

function TFiscalPrinterDevice.Execute(const Data: string): string;
begin
  Check(ExecuteData(Data, Result));
end;

function TFiscalPrinterDevice.GetDeviceMetrics: TDeviceMetrics;
begin
  if not FValidDeviceMetrics then
  begin
    FDeviceMetrics := ReadDeviceMetrics;
    FValidDeviceMetrics := True;
  end;
  Result := FDeviceMetrics;
end;

function TFiscalPrinterDevice.MinProtocolVersion(V1, V2: Integer): Boolean;
begin
  Result := (GetDeviceMetrics.ProtocolVersion >= V1)and
    (GetDeviceMetrics.ProtocolSubVersion >= V2);
end;

function TFiscalPrinterDevice.CapShortEcrStatus: Boolean;
begin
  Result := MinProtocolVersion(1, 1);
end;

function TFiscalPrinterDevice.CapPrintStringFont: Boolean;
begin
  Result := MinProtocolVersion(1, 1);
end;

function TFiscalPrinterDevice.CapGraphics: Boolean;
begin
  Result := MinProtocolVersion(1, 3);
end;

(******************************************************************************

  Print Daily Log Report For Daily Totals Number From EKLZ

  Command:	A6H. Length: 7 bytes.
  Ј	System Administrator password (4 bytes) 30
  Ј	Day number (2 bytes) 0000Е2100

  Answer:		A6H. Length: 2 bytes.
  Ј	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.PrintJournal(DayNumber: Integer);
begin
  Execute(#$A6 + IntToBin(GetSysPassword, 4) + IntToBin(DayNumber, 2));
end;

function TFiscalPrinterDevice.ValidRow(Table, Row: Integer): Boolean;
var
  TableInfo: TPrinterTableRec;
begin
  Check(ReadTableStructure(Table, TableInfo));
  Result := (Row >= 1)and(Row <= TableInfo.RowCount);
end;

function TFiscalPrinterDevice.ValidField(Table, Field: Integer): Boolean;
var
  TableInfo: TPrinterTableRec;
begin
  Check(ReadTableStructure(Table, TableInfo));
  Result := (Field >= 1)and(Field <= TableInfo.FieldCount);
end;

function TFiscalPrinterDevice.CapParameter(ParamID: Integer): Boolean;
begin
  Result := PrinterModel.Parameters.ItemByID(ParamID) <> nil;
end;

function TFiscalPrinterDevice.ValidParameter(const Parameter: TTableParameter): Boolean;
begin
  Result := ValidRow(Parameter.Table, Parameter.Row) and
    ValidField(Parameter.Table, Parameter.Field);
end;

procedure TFiscalPrinterDevice.WriteParameter(ParamID, ValueID: Integer);
var
  Parameter: TTableParameter;
  ParameterValue: TParameterValue;
begin
  Parameter := PrinterModel.Parameters.ItemByID(ParamID);
  if Parameter <> nil then
  begin
    if ValidParameter(Parameter) then
    begin
      ParameterValue := Parameter.Values.ItemByID(ValueID);
      if ParameterValue <> nil then
      begin
        WriteTableInt(Parameter.Table, Parameter.Row, Parameter.Field,
        ParameterValue.Value);
      end;
    end;
  end;
end;

function TFiscalPrinterDevice.ReadParameter(ParamID: Integer): Integer;
var
  Parameter: TTableParameter;
begin
  Result := 0;
  Parameter := PrinterModel.Parameters.ItemByID(ParamID);
  if Parameter <> nil then
  begin
    if ValidParameter(Parameter) then
      Result := ReadTableInt(Parameter.Table, Parameter.Row, Parameter.Field);
  end;
end;

function TFiscalPrinterDevice.ReadEJDocument(MACNumber: Integer;
  var Line: string): Integer;
var
  Command: string;
begin
  Command := #$B5 + IntToBin(GetSysPassword, 4) + IntToBin(MACNumber, 4);
  Result := ExecuteData(Command, Line);
end;


function TFiscalPrinterDevice.ReadEJDocumentText(MACNumber: Integer): string;
var
  Line: string;
  Lines: TStrings;
begin
  Result := '';
  Lines := TStringList.Create;
  try
    if EJReportStop <> 0 then Exit;
    if ReadEJDocument(MACNumber, Line) <> 0 then Exit;
    Lines.Add(Line);

    while GetEJReportLine(Line) = 0 do
    begin
      Lines.Add(Line);
    end;
    EJReportStop;
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

// 00000068 #049021
function TFiscalPrinterDevice.ParseEJDocument(const Text: string): TEJDocument;
var
  Line: string;
  Lines: TStrings;
begin
  Result.Text := Text;
  Result.MACValue := 0;
  Result.MACNumber := 0;

  Lines := TStringList.Create;
  try
    Lines.Text := Text;
    if Lines.Count > 0 then
    begin
      Line := Trim(Lines[Lines.Count-1]);
      Result.MACNumber := StrToInt64(Copy(Line, 1, 8));
      Result.MACValue := StrToInt64(Copy(Line, 11, 6));
    end;
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterDevice.ReadEJActivationText(MaxCount: Integer): string;
var
  i: Integer;
  Line: string;
  Lines: TStrings;
begin
  Lines := TStringList.Create;
  try
    if EJReportStop <> 0 then Exit;
    if ReadEJActivation(Line) <> 0 then Exit;
    Lines.Add(Line);

    for i := 1 to MaxCount do
    begin
      if GetEJReportLine(Line) <> 0 then Break;
      Lines.Add(Line);
    end;
    EJReportStop;
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterDevice.QueryEJActivation: TEJActivation;
begin
  Result := TEJReportParser.ParseActivation(ReadEJActivationText(6));
end;

function TFiscalPrinterDevice.GetIsOnline: Boolean;
begin
  Result := FIsOnline;
end;

function TFiscalPrinterDevice.GetOnConnect: TNotifyEvent;
begin
  Result := FOnConnect;
end;

function TFiscalPrinterDevice.GetOnDisconnect: TNotifyEvent;
begin
  Result := FOnDisconnect;
end;

procedure TFiscalPrinterDevice.SetOnConnect(const Value: TNotifyEvent);
begin
  FOnConnect := Value;
end;

procedure TFiscalPrinterDevice.SetOnDisconnect(const Value: TNotifyEvent);
begin
  FOnDisconnect := Value;
end;

function TFiscalPrinterDevice.LoadGraphics(Line: Word;
  Data: string): Integer;
begin
  if Parameters.LogoCenter then
    Data := CenterGraphicsLine(Data, GetMaxGraphicsWidthInBytes, 1);

  if FCapGraphics2 then
  begin
    Result := LoadGraphics2(Line, Data);
    Exit;
  end;
  if FCapGraphics1 then
  begin
    Result := LoadGraphics1(Line, Data);
    Exit;
  end;
  raise Exception.Create('Graphics is not supported');
end;

function TFiscalPrinterDevice.PrintGraphics(Line1, Line2: Word): Integer;
begin
  CheckGraphicsSize(Line1);
  CheckGraphicsSize(Line2);

(*
  if FModel.Data.ID in [0, 4] then
  begin
    Line1 := Line1 + 1;
    Line2 := Line2 + 2;
  end;
  if FModel.Data.ID = 250 then
  begin
    Line1 := Line1 + 1;
    Line2 := Line2 + 1;
  end;
  if FModel.Data.ID in [7, 14] then
  begin
    Line2 := Line2 + 1;
  end;
*)
  if FCapGraphics3 then
  begin
    Result := PrintGraphics3(Line1, Line2);
    Exit;
  end;
  if FCapGraphics2 then
  begin
    Result := PrintGraphics2(Line1, Line2);
    Exit;
  end;
  if FCapGraphics1 then
  begin
    Result := PrintGraphics1(Line1, Line2);
    Exit;
  end;
  raise Exception.Create('Graphics is not supported');
end;

function TFiscalPrinterDevice.IsDayOpened(Mode: Integer): Boolean;
begin
  Result := (Mode and $0F) in [MODE_24NOTOVER, MODE_24OVER, MODE_REC, MODE_SLP];
end;


function TFiscalPrinterDevice.GetAmountDecimalPlaces: Integer;
begin
  Result := FAmountDecimalPlaces;
end;

procedure TFiscalPrinterDevice.SetAmountDecimalPlaces(
  const Value: Integer);
begin
  FAmountDecimalPlaces := Value;
end;

procedure TFiscalPrinterDevice.PrintBarcode2(const Barcode: TBarcodeRec);
var
  Line: string;
  TickCount: Integer;
  ABarcode: TBarcodeRec;
begin
  ABarcode := Barcode;
  Logger.Debug('PrintBarcode2');
  TickCount := GetTickCount;
  if ABarcode.BarcodeType = DIO_BARCODE_EAN13_INT then
  begin
    ABarcode.Height := 80;
    ABarcode.Data := Copy(ABarcode.Data, 1, 12);
    ABarcode.Text := ABarcode.Data;
    ABarcode.Alignment := BARCODE_ALIGNMENT_CENTER;
    ABarcode.BarcodeType := DIO_BARCODE_EAN13;
    PrintBarcodeZInt(ABarcode);
    WaitForPrinting;
    Line := AlignLine(ABarcode.Data, GetPrintWidth, taCenter);
    PrintStringFont(PRINTER_STATION_REC, Parameters.FontNumber, Line);
  end else
  begin
    if (ABarcode.BarcodeType = DIO_BARCODE_QRCODE)and FCapBarcode2D then
    begin
      Check(PrintQRCode2D(ABarcode))
    end else
    begin
      PrintBarcodeZInt(ABarcode);
    end;
  end;
  Logger.Debug('PrintBarcode2.OK');
  Logger.Debug(Format('Barcode printed in %d ms', [Integer(GetTickCount) - TickCount]));

  WaitForPrinting;
end;

function TFiscalPrinterDevice.PrintQRCode2D(const Barcode: TBarcodeRec): Integer;

  // 0	ѕо левому краю
  // 1	ѕо центру
  // 2	ѕо правому краю
  function IntToAlignment(Alignment: Integer): Integer;
  begin
    Result := 1;
    case Alignment of
      BARCODE_ALIGNMENT_CENTER: Result := 1;
      BARCODE_ALIGNMENT_LEFT: Result := 0;
      BARCODE_ALIGNMENT_RIGHT: Result := 2;
    end;
  end;

const
  DATA_BLOCK_SIZE = 64;
var
  i: Integer;
  Count: Integer;
  Barcode2D: TBarcode2D;
  Block: TBarcode2DData;
begin
  Count := (Length(Barcode.Data) + DATA_BLOCK_SIZE -1) div DATA_BLOCK_SIZE;
  for i := 0 to Count-1 do
  begin
    Block.BlockType := 0;
    Block.BlockNumber := i;
    Block.BlockData := Copy(Barcode.Data, 1 + i * DATA_BLOCK_SIZE, DATA_BLOCK_SIZE);
    Result := LoadBarcode2D(Block);
    if Result <> 0 then Exit;
  end;
  Barcode2D.BarcodeType := 3;
  Barcode2D.DataLength := Length(Barcode.Data);
  Barcode2D.BlockNumber := 0;
  Barcode2D.Parameter1 := Barcode.Parameter1;
  Barcode2D.Parameter2 := Barcode.Parameter2;
  Barcode2D.Parameter3 := Barcode.ModuleWidth;
  Barcode2D.Parameter4 := 0;
  Barcode2D.Parameter5 := Barcode.Parameter3;
  Barcode2D.Alignment := IntToAlignment(Barcode.Alignment);
  Result := PrintBarcode2D(Barcode2D);
end;

function TFiscalPrinterDevice.DrawScale(const P: TDrawScale): Integer;
var
  Command: string;
  Answer: string;
  LastLine: Integer;
begin
  LastLine := P.LastLine;
  if GetPrinterModel.Data.ID in [7, 14] then
  begin
    LastLine := LastLine - 1;
  end;

  Command := #$4F +
    IntToBin(GetUsrPassword, 4) +
    Chr(P.FirstLine) +
    Chr(LastLine) +
    Chr(P.VScale) +
    Chr(P.HScale);
  Result := ExecuteData(Command, Answer);
end;

function TFiscalPrinterDevice.GetStartLine: Integer;
begin
  Result := 1;
  if Parameters.LogoEnabled and Parameters.IsLogoLoaded and
    (Parameters.LogoSize > 0) then
  begin
    Result := Parameters.LogoSize + 1;
  end;
end;

function TFiscalPrinterDevice.Is1DBarcode(Symbology: Integer): Boolean;
begin
  Result := not Is2DBarcode(Symbology);
end;

function TFiscalPrinterDevice.Is2DBarcode(Symbology: Integer): Boolean;
begin
  Result := Symbology in [
    DIO_BARCODE_QRCODE,
    DIO_BARCODE_AZTEC,
    DIO_BARCODE_MICROQR,
    DIO_BARCODE_AZRUNE,
    DIO_BARCODE_PDF417,
    DIO_BARCODE_PDF417TRUNC,
    DIO_BARCODE_MICROPDF417,
    DIO_BARCODE_MAXICODE,
    DIO_BARCODE_DATAMATRIX
  ];
end;

function GetZIntBarcodeType(DIOBarcodeType: Integer): TZBType;
begin
  case DIOBarcodeType of
    DIO_BARCODE_EAN13_INT           : Result := tBARCODE_EANX;
    DIO_BARCODE_CODE128A            : Result := tBARCODE_CODE128;
    DIO_BARCODE_CODE128B            : Result := tBARCODE_CODE128B;
    DIO_BARCODE_CODE128C            : Result := tBARCODE_CODE128;
    DIO_BARCODE_CODE39              : Result := tBARCODE_CODE39;
    DIO_BARCODE_CODE25INTERLEAVED   : Result := tBARCODE_C25INTER;
    DIO_BARCODE_CODE25INDUSTRIAL    : Result := tBARCODE_C25IND;
    DIO_BARCODE_CODE25MATRIX        : Result := tBARCODE_C25MATRIX;
    DIO_BARCODE_CODE39EXTENDED      : Result := tBARCODE_EXCODE39;
    DIO_BARCODE_CODE93              : Result := tBARCODE_CODE93;
    DIO_BARCODE_CODE93EXTENDED      : Result := tBARCODE_CODE93;
    DIO_BARCODE_MSI                 : Result := tBARCODE_MSI_PLESSEY;
    DIO_BARCODE_POSTNET             : Result := tBARCODE_POSTNET;
    DIO_BARCODE_CODABAR             : Result := tBARCODE_CODABAR;
    DIO_BARCODE_EAN8                : Result := tBARCODE_EANX;
    DIO_BARCODE_EAN13               : Result := tBARCODE_EANX;
    DIO_BARCODE_UPC_A               : Result := tBARCODE_UPCA;
    DIO_BARCODE_UPC_E0              : Result := tBARCODE_UPCE;
    DIO_BARCODE_UPC_E1              : Result := tBARCODE_UPCE;
    DIO_BARCODE_UPC_S2              : Result := tBARCODE_UPCE;
    DIO_BARCODE_UPC_S5              : Result := tBARCODE_UPCE;
    DIO_BARCODE_EAN128A             : Result := tBARCODE_EAN128;
    DIO_BARCODE_EAN128B             : Result := tBARCODE_EAN128;
    DIO_BARCODE_EAN128C             : Result := tBARCODE_EAN128;

    DIO_BARCODE_CODE11              : Result := tBARCODE_CODE11;
    DIO_BARCODE_C25IATA             : Result := tBARCODE_C25IATA;
    DIO_BARCODE_C25LOGIC            : Result := tBARCODE_C25LOGIC;
    DIO_BARCODE_DPLEIT              : Result := tBARCODE_DPLEIT;
    DIO_BARCODE_DPIDENT             : Result := tBARCODE_DPIDENT;
    DIO_BARCODE_CODE16K             : Result := tBARCODE_CODE16K;
    DIO_BARCODE_CODE49              : Result := tBARCODE_CODE49;
    DIO_BARCODE_FLAT                : Result := tBARCODE_FLAT;
    DIO_BARCODE_RSS14               : Result := tBARCODE_RSS14;
    DIO_BARCODE_RSS_LTD             : Result := tBARCODE_RSS_LTD;
    DIO_BARCODE_RSS_EXP             : Result := tBARCODE_RSS_EXP;
    DIO_BARCODE_TELEPEN             : Result := tBARCODE_TELEPEN;
    DIO_BARCODE_FIM                 : Result := tBARCODE_FIM;
    DIO_BARCODE_LOGMARS             : Result := tBARCODE_LOGMARS;
    DIO_BARCODE_PHARMA              : Result := tBARCODE_PHARMA;
    DIO_BARCODE_PZN                 : Result := tBARCODE_PZN;
    DIO_BARCODE_PHARMA_TWO          : Result := tBARCODE_PHARMA_TWO;
    DIO_BARCODE_PDF417              : Result := tBARCODE_PDF417;
    DIO_BARCODE_PDF417TRUNC         : Result := tBARCODE_PDF417TRUNC;
    DIO_BARCODE_MAXICODE            : Result := tBARCODE_MAXICODE;
    DIO_BARCODE_QRCODE              : Result := tBARCODE_QRCODE;
    DIO_BARCODE_AUSPOST             : Result := tBARCODE_AUSPOST;
    DIO_BARCODE_AUSREPLY            : Result := tBARCODE_AUSREPLY;
    DIO_BARCODE_AUSROUTE            : Result := tBARCODE_AUSROUTE;
    DIO_BARCODE_AUSREDIRECT         : Result := tBARCODE_AUSREDIRECT;
    DIO_BARCODE_ISBNX               : Result := tBARCODE_ISBNX;
    DIO_BARCODE_RM4SCC              : Result := tBARCODE_RM4SCC;
    DIO_BARCODE_DATAMATRIX          : Result := tBARCODE_DATAMATRIX;
    DIO_BARCODE_EAN14               : Result := tBARCODE_EAN14;
    DIO_BARCODE_CODABLOCKF          : Result := tBARCODE_CODABLOCKF;
    DIO_BARCODE_NVE18               : Result := tBARCODE_NVE18;
    DIO_BARCODE_JAPANPOST           : Result := tBARCODE_JAPANPOST;
    DIO_BARCODE_KOREAPOST           : Result := tBARCODE_KOREAPOST;
    DIO_BARCODE_RSS14STACK          : Result := tBARCODE_RSS14STACK;
    DIO_BARCODE_RSS14STACK_OMNI     : Result := tBARCODE_RSS14STACK_OMNI;
    DIO_BARCODE_RSS_EXPSTACK        : Result := tBARCODE_RSS_EXPSTACK;
    DIO_BARCODE_PLANET              : Result := tBARCODE_PLANET;
    DIO_BARCODE_MICROPDF417         : Result := tBARCODE_MICROPDF417;
    DIO_BARCODE_ONECODE             : Result := tBARCODE_ONECODE;
    DIO_BARCODE_PLESSEY             : Result := tBARCODE_PLESSEY;
    DIO_BARCODE_TELEPEN_NUM         : Result := tBARCODE_TELEPEN_NUM;
    DIO_BARCODE_ITF14               : Result := tBARCODE_ITF14;
    DIO_BARCODE_KIX                 : Result := tBARCODE_KIX;
    DIO_BARCODE_AZTEC               : Result := tBARCODE_AZTEC;
    DIO_BARCODE_DAFT                : Result := tBARCODE_DAFT;
    DIO_BARCODE_MICROQR             : Result := tBARCODE_MICROQR;
    DIO_BARCODE_HIBC_128            : Result := tBARCODE_HIBC_128;
    DIO_BARCODE_HIBC_39             : Result := tBARCODE_HIBC_39;
    DIO_BARCODE_HIBC_DM             : Result := tBARCODE_HIBC_DM;
    DIO_BARCODE_HIBC_QR             : Result := tBARCODE_HIBC_QR;
    DIO_BARCODE_HIBC_PDF            : Result := tBARCODE_HIBC_PDF;
    DIO_BARCODE_HIBC_MICPDF         : Result := tBARCODE_HIBC_MICPDF;
    DIO_BARCODE_HIBC_BLOCKF         : Result := tBARCODE_HIBC_BLOCKF;
    DIO_BARCODE_HIBC_AZTEC          : Result := tBARCODE_HIBC_AZTEC;
    DIO_BARCODE_AZRUNE              : Result := tBARCODE_AZRUNE;
    DIO_BARCODE_CODE32              : Result := tBARCODE_CODE32;
    DIO_BARCODE_EANX_CC             : Result := tBARCODE_EANX_CC;
    DIO_BARCODE_EAN128_CC           : Result := tBARCODE_EAN128_CC;
    DIO_BARCODE_RSS14_CC            : Result := tBARCODE_RSS14_CC;
    DIO_BARCODE_RSS_LTD_CC          : Result := tBARCODE_RSS_LTD_CC;
    DIO_BARCODE_RSS_EXP_CC          : Result := tBARCODE_RSS_EXP_CC;
    DIO_BARCODE_UPCA_CC             : Result := tBARCODE_UPCA_CC;
    DIO_BARCODE_UPCE_CC             : Result := tBARCODE_UPCE_CC;
    DIO_BARCODE_RSS14STACK_CC       : Result := tBARCODE_RSS14STACK_CC;
    DIO_BARCODE_RSS14_OMNI_CC       : Result := tBARCODE_RSS14_OMNI_CC;
    DIO_BARCODE_RSS_EXPSTACK_CC     : Result := tBARCODE_RSS_EXPSTACK_CC;
    DIO_BARCODE_CHANNEL             : Result := tBARCODE_CHANNEL;
    DIO_BARCODE_CODEONE             : Result := tBARCODE_CODEONE;
    DIO_BARCODE_GRIDMATRIX          : Result := tBARCODE_GRIDMATRIX;
  else
    Raise Exception.CreateFmt('Invalid barcode type, %d', [DIOBarcodeType]);
  end;
end;

function IsPDF417(BarcodeType: Integer): Boolean;
begin
  Result := BarcodeType in [DIO_BARCODE_PDF417,
    DIO_BARCODE_PDF417TRUNC, DIO_BARCODE_MICROPDF417];
end;

procedure RenderBarcode(Bitmap: TBitmap; Symbol: PZSymbol; Is1D: Boolean);
var
  B: Byte;
  X, Y: Integer;
begin
  Bitmap.Monochrome := True;
  Bitmap.PixelFormat := pf1Bit;
  Bitmap.Width := Symbol.width;
  if Is1D then
    Bitmap.Height := Symbol.Height
  else
    Bitmap.Height := Symbol.rows;

  for X := 0 to Symbol.width-1 do
  for Y := 0 to Symbol.Height-1 do
  begin
    Bitmap.Canvas.Pixels[X, Y] := clWhite;
    if Is1D then
      B := Byte(Symbol.encoded_data[0][X div 7])
    else
      B := Byte(Symbol.encoded_data[Y][X div 7]);

    if (B and (1 shl (X mod 7))) <> 0 then
      Bitmap.Canvas.Pixels[X, Y] := clBlack;
  end;
end;

procedure ScaleBitmap(Bitmap: TBitmap; Xscale, YSCale: Integer);
var
  P: TPoint;
  DstBitmap: TBitmap;
begin
  DstBitmap := TBitmap.Create;
  try
    DstBitmap.Monochrome := True;
    DstBitmap.PixelFormat := pf1Bit;
    P.X := Bitmap.Width * XScale;
    P.Y := Bitmap.Height * YScale;
    DstBitmap.Width := P.X;
    DstBitmap.Height := P.Y;
    DstBitmap.Canvas.StretchDraw(Rect(0, 0, P.X, P.Y), Bitmap);
    Bitmap.Assign(DstBitmap);
  finally
    DstBitmap.Free;
  end;
end;

procedure TFiscalPrinterDevice.AlignBitmap(Bitmap: TBitmap;
  const Barcode: TBarcodeRec; HScale: Integer; PrintWidthInDots: Integer);
var
  Bmp: TBitmap;
  XOffset: Integer;
begin
  if Barcode.Alignment = BARCODE_ALIGNMENT_LEFT then Exit;
  PrintWidthInDots := PrintWidthInDots div HScale;

  XOffset := 0;
  case Barcode.Alignment of
    BARCODE_ALIGNMENT_CENTER:
    begin
      XOffset := (PrintWidthInDots - Bitmap.Width) div 2;
    end;
    BARCODE_ALIGNMENT_RIGHT:
    begin
      XOffset := PrintWidthInDots - Bitmap.Width;
    end;
  end;
  Bmp := TBitmap.Create;
  try
    Bmp.Monochrome := True;
    Bmp.PixelFormat := pf1Bit;
    Bmp.Width := Bitmap.Width + XOffset;
    Bmp.Height := Bitmap.Height;
    Bmp.Canvas.Draw(XOffset, 0, Bitmap);
    Bitmap.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

function TFiscalPrinterDevice.GetMaxGraphicsHeight: Integer;
begin
  Result := 0;
  if FCapGraphics1 then
    Result := 200;
  if FCapGraphics2 then
    Result := 1200;
  if FCapGraphics3 then
    Result := 600;
end;

function TFiscalPrinterDevice.GetMaxGraphicsWidth: Integer;
begin
  Result := FFontInfo[1].PrintWidth;
end;

function TFiscalPrinterDevice.GetMaxGraphicsWidthInBytes: Integer;
begin
  Result := GetMaxGraphicsWidth div 8;
end;

procedure TFiscalPrinterDevice.PrintBarcodeZInt(const Barcode: TBarcodeRec);
var
  P: TDrawScale;
  Bitmap: TBitmap;
  StartLine: Integer;
  ModuleWidth: Integer;
  Render: TZintBarcode;
  VScale, HScale: Integer;
  MaxGraphicsWidth: Integer;
  MaxGraphicsHeight: Integer;
  Graphics3: TPrintGraphics3;
begin
  MaxGraphicsHeight := GetMaxGraphicsHeight;
  MaxGraphicsWidth := GetMaxGraphicsWidth;
  if Is2DBarcode(Barcode.BarcodeType) or (not FCapBarLine) then
  begin
    if FCapGraphics3 then
    begin
      MaxGraphicsWidth := Min(512, MaxGraphicsWidth);
    end else
    begin
      if not FCapDrawScale then
      begin
        MaxGraphicsWidth := 320;
      end;
    end;
  end;

  ModuleWidth := Barcode.ModuleWidth;
  StartLine := GetStartLine;

  Bitmap := TBitmap.Create;
  Render := TZintBarcode.Create;
  try
    Render.BorderWidth := 0;
    Render.FGColor := clBlack;
    Render.BGColor := clWhite;
    Render.Scale := 1;
    Render.Height := Barcode.Height;
    Render.BarcodeType := GetZIntBarcodeType(Barcode.BarcodeType);
    Render.Data := Barcode.Data;
    Render.ShowHumanReadableText := False;
    Render.EncodeNow;
    RenderBarcode(Bitmap, Render.Symbol, Is1DBarcode(Barcode.BarcodeType));

    VScale := 1;
    HScale := ModuleWidth;
    if Is2DBarcode(Barcode.BarcodeType) then
    begin
      if IsPDF417(Barcode.BarcodeType) then
        VScale := ModuleWidth*3
      else
        VScale := ModuleWidth;
    end;

    if Is1DBarcode(Barcode.BarcodeType)and FCapBarLine then
    begin
      ScaleBitmap(Bitmap, HScale, 1);
      HScale := 1;
    end else
    begin
      if not FCapGraphics3 then
      begin
        if FCapDrawScale then
        begin
          ScaleBitmap(Bitmap, HScale, 1);
        end else
        begin
          ScaleBitmap(Bitmap, HScale, VScale);
          VScale := 1;
        end;
        HScale := 1;
      end;
    end;

    if Bitmap.Width > MaxGraphicsWidth then
      raise Exception.CreateFmt('Bitmap width more than maximum, %d > %d', [
        Bitmap.Width, MaxGraphicsWidth]);

    if Bitmap.Height > MaxGraphicsHeight then
      raise Exception.CreateFmt('Bitmap height more than maximum, %d > %d', [
        Bitmap.Height, MaxGraphicsHeight]);

    AlignBitmap(Bitmap, Barcode, HScale, MaxGraphicsWidth);


    if Is1DBarcode(Barcode.BarcodeType) then
    begin
      if FCapBarLine then
      begin
        PrintBarLine(Barcode.Height, GetLineData(Bitmap, 0));
      end else
      begin
        LoadBitmap(StartLine, Bitmap);
        Check(PrintGraphics(StartLine, Bitmap.Height + StartLine));
      end;
    end else
    begin
      LoadBitmap(StartLine, Bitmap);
      if FCapGraphics3 then
      begin
        Graphics3.FirstLine := StartLine;
        Graphics3.LastLine := StartLine + Bitmap.Height -1;
        Graphics3.VScale := VScale;
        Graphics3.HScale := HScale;
        Graphics3.Flags := PRINTER_STATION_REC;
        Check(PrintGraphics3(Graphics3));
      end else
      begin
        if FCapDrawScale then
        begin
          P.FirstLine := StartLine;
          P.LastLine := StartLine + Bitmap.Height;
          P.VScale := VScale;
          P.HScale := 0;
          Check(DrawScale(P));
        end else
        begin
          Check(PrintGraphics(StartLine, Bitmap.Height + StartLine));
        end;
      end;
    end;
  finally
    Render.Free;
    Bitmap.Free;
  end;
end;

procedure TFiscalPrinterDevice.PrintImage(const FileName: string;
  StartLine: Integer);
var
  ImageHeight: Integer;
begin
  ImageHeight := LoadImage(FileName, StartLine);
  Check(PrintGraphics(StartLine, StartLine + ImageHeight - 1));
end;

procedure TFiscalPrinterDevice.PrintImageScale(const FileName: string;
  StartLine, Scale: Integer);
var
  Bitmap: TBitmap;
  Picture: TPicture;
  P: TPrintGraphics3;
begin
  if not(Scale in [1..10]) then
    Scale := 1;

  Bitmap := TBitmap.Create;
  Picture := TPicture.Create;
  try
    Picture.LoadFromFile(FileName);

    Bitmap.PixelFormat := pf1Bit;
    Bitmap.Monochrome := True;
    Bitmap.Width := Picture.Width;
    Bitmap.Height := Picture.Height;
    Bitmap.Canvas.Draw(0, 0, Picture.Graphic);

    if FCapGraphics3 then
    begin
      LoadBitmap512(StartLine, Bitmap, Scale);
    end else
    begin
      LoadBitmap320(StartLine, Bitmap);
    end;

    if FCapGraphics3 then
    begin
      P.FirstLine := StartLine;
      P.LastLine := StartLine + Bitmap.Height-1;
      P.VScale := Scale;
      P.HScale := Scale;
      P.Flags := PRINTER_STATION_REC;
      Check(PrintGraphics3(P));
    end else
    begin
      Check(PrintGraphics(StartLine, StartLine + Bitmap.Height-1));
    end;
  finally
    Bitmap.Free;
    Picture.Free;
  end;
end;

procedure AlignBitmapWidth(Bitmap: TBitmap; const NewWidth: Integer);
var
  NewHeight: Integer;
begin
  if Bitmap.Width = 0 then
    raise Exception.Create('Bitmap.Width = 0');

  NewHeight := Trunc(Bitmap.Height*(NewWidth/Bitmap.Width));
  Bitmap.Canvas.StretchDraw(
    Rect(0, 0, NewWidth, NewHeight),
    Bitmap);
  Bitmap.Width := NewWidth;
  Bitmap.Height := NewHeight;
end;

function IsInversedPalette(Bitmap: TBitmap): Boolean;
var
  PaletteSize: Integer;
  PalEntry: TPaletteEntry;
begin
  Result := False;
  if Bitmap.Palette <> 0 then
  begin
    PaletteSize := 0;
    if GetObject(Bitmap.Palette, SizeOf(PaletteSize), @PaletteSize) = 0 then Exit;
    if PaletteSize = 0 then Exit;
    GetPaletteEntries(Bitmap.Palette, 0, 1, PalEntry);
    Result := (PalEntry.peRed = $FF)and(PalEntry.peGreen = $FF)and(PalEntry.peBlue = $FF);
  end;
end;

function Inverse(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + Chr(Ord(S[i]) xor $FF);
end;

function TFiscalPrinterDevice.GetLineData(Bitmap: TBitmap; Index: Integer): string;
var
  B: Byte;
  i: Integer;
  Len: Integer;
const
  Mask: array [0..7] of Byte = ($FF, $80, $C0, $E0, $F0, $F8, $FC, $FE);
begin
  Result := '';
  Len := (Bitmap.Width + 7 )div 8;
  for i := 0 to Len-1 do
  begin
    B := $FF - PByteArray(Bitmap.ScanLine[Index])[i];
    if i = (Len-1) then
      B := B and Mask[Bitmap.Width mod 8];
    Result := Result + Chr(SwapByte(B));
  end;

  // If palette is inverse
  if IsInversedPalette(Bitmap) then
    Result := Inverse(Result);

  Result := GetLine(Result, 40, 40);
end;

procedure TFiscalPrinterDevice.ProgressEvent(Progress: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Progress);
end;

procedure TFiscalPrinterDevice.LoadBitmap(StartLine: Integer; Bitmap: TBitmap);
begin
  Bitmap.Monochrome := True;
  Bitmap.PixelFormat := pf1Bit;

  if Bitmap.Height = 0 then
    raise Exception.Create(MsgImageHeightIsZero);

  if Bitmap.Width = 0 then
    raise Exception.Create(MsgImageWidthIsZero);

  if Bitmap.Width > GetMaxGraphicsWidth then
    AlignBitmapWidth(Bitmap, GetMaxGraphicsWidth);

  Bitmap.Height := Min(Bitmap.Height, GetMaxGraphicsHeight);
  if FCapGraphics3 then
  begin
    LoadBitmap512(StartLine, Bitmap, 1);
  end else
  begin
    LoadBitmap320(StartLine, Bitmap);
  end;
end;

procedure TFiscalPrinterDevice.LoadBitmap320(StartLine: Integer; Bitmap: TBitmap);
var
  i: Integer;
  Count: Integer;
  Progress: Integer;
  NewProgress: Integer;
  ProgressStep: Double;
begin
  Progress := 0;
  Count := Bitmap.Height;
  ProgressStep := Bitmap.Height/100;
  for i := 0 to Count-1 do
  begin
    Check(LoadGraphics(i+ StartLine, GetLineData(Bitmap, i)));
    NewProgress := 0;
    if ProgressStep <> 0 then
      NewProgress := Round(i/ProgressStep);

    if (NewProgress <> Progress)and(NewProgress <= 100) then
    begin
      Progress := NewProgress;
      ProgressEvent(NewProgress);
    end;
  end;
  ProgressEvent(100);
end;

procedure TFiscalPrinterDevice.LoadBitmap512(StartLine: Integer;
  Bitmap: TBitmap; Scale: Integer);
var
  i, j: Integer;
  Line: string;
  Row: Integer;
  Answer: string;
  Command: string;
  Progress: Integer;
  NewProgress: Integer;
  ProgressStep: Double;
  CommandCount: Integer;
  RowsPerCommand: Integer;
  LineLength: Integer;
  RowCount: Integer;
  GraphicsWidthInBytes: Integer;
const
  BytesPerCommand = 240;
begin
  Progress := 0;

  GraphicsWidthInBytes := GetMaxGraphicsWidthInBytes;
  LineLength := Length(CenterGraphicsLine(GetLineData(Bitmap, 1), GraphicsWidthInBytes, Scale));
  RowsPerCommand := BytesPerCommand div LineLength;
  CommandCount := (Bitmap.Height + RowsPerCommand -1) div RowsPerCommand;
  ProgressStep := CommandCount/100;
  Row := 0;
  for i := 0 to CommandCount-1 do
  begin
    Line := '';
    RowCount := 0;
    for j := 0 to RowsPerCommand-1 do
    begin
      Line := Line + CenterGraphicsLine(GetLineData(Bitmap, Row), GraphicsWidthInBytes, Scale);
      Inc(Row);
      Inc(RowCount);
      if Row >= Bitmap.Height then Break;
    end;
    Command := #$4E + IntToBin(GetUsrPassword, 4) + Chr(LineLength) +
      IntToBin(StartLine, 2) + IntToBin(RowCount, 2) + #1 + Line;
    Check(ExecuteData(Command, Answer));
    Inc(StartLine, RowsPerCommand);
    NewProgress := 0;
    if ProgressStep <> 0 then
      NewProgress := Round(i/ProgressStep);
    if (NewProgress <> Progress)and(NewProgress <= 100) then
    begin
      Progress := NewProgress;
      ProgressEvent(NewProgress);
    end;
  end;
  ProgressEvent(100);
end;

function TFiscalPrinterDevice.LoadImage(const FileName: string;
  StartLine: Integer): Integer;
var
  Picture: TPicture;
begin
  Picture := TPicture.Create;
  try
    Picture.LoadFromFile(FileName);
    Result := LoadPicture(Picture, StartLine);
  finally
    Picture.Free;
  end;
end;

function TFiscalPrinterDevice.LoadPicture(Picture: TPicture;
  StartLine: Integer): Integer;
var
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.PixelFormat := pf1Bit;
    Bitmap.Monochrome := True;
    Bitmap.Width := Picture.Width;
    Bitmap.Height := Picture.Height;
    Bitmap.Canvas.Draw(0, 0, Picture.Graphic);
    LoadBitmap(StartLine, Bitmap);
    Result := Bitmap.Height;
  finally
    Bitmap.Free;
  end;
end;

procedure TFiscalPrinterDevice.Connect;
var
  i: Integer;
  Table: TPrinterTableRec;
begin
  GetPrinterModel;
  FLongPrinterStatus := GetLongStatus;
  FCapBarLine := TestCommand($C5);
  FCapDrawScale := TestCommand($4F);
  FCapBarcode2D := TestCommand($DE);
  FCapGraphics1 := TestCommand($C0);
  FCapGraphics2 := TestCommand($C4);
  FCapGraphics3 := TestCommand($4E);
  FCapFiscalStorage := ReadCapFiscalStorage;
  FCapOpenReceipt := FCapFiscalStorage or TestCommand($8D);

  FCapReceiptDiscount2 := TestCommand($FF4B);
  FCapFontInfo := TestCommand($26);
  if FCapFontInfo then
  begin
    FFontInfo[1] := ReadFontInfo(1);
    for i := 2 to FFontInfo[1].FontCount do
    begin
      FFontInfo[i] := ReadFontInfo(i);
    end;
  end;
  // Read tax Info
  Check(ReadTableStructure(PRINTER_TABLE_TAX, Table));
  for i := 1 to Table.RowCount do
  begin
    FTaxInfo[i].Rate := ReadTableInt(PRINTER_TABLE_TAX, i, 1);
    FTaxInfo[i].Name := ReadTableStr(PRINTER_TABLE_TAX, i, 2);
  end;
  if FCapFiscalStorage then
  begin
    FDiscountMode := ReadDiscountMode;
  end;
  FIsFiscalized := FCapFiscalStorage or (FLongPrinterStatus.RegistrationNumber <> 0);
end;

function TFiscalPrinterDevice.GetTaxInfo(Tax: Integer): TTaxInfo;
begin
  Result.Rate := 0;
  Result.Name := '';
  if Tax in [1..6] then
    Result := FTaxInfo[Tax];
end;

function TFiscalPrinterDevice.ReadCapFiscalStorage: Boolean;
var
  R: TFSState;
begin
  Result := FSReadState(R) = 0;
end;

function TFiscalPrinterDevice.TestCommand(Code: Integer): Boolean;
var
  RxData: string;
begin
  if Code > $FF then
  begin
    Result := ExecuteData(Chr(Hi(Code)) + Chr(Lo(Code)), RxData) <> 55;
  end else
  begin
    Result := ExecuteData(Chr(Code), RxData) <> 55;
  end;
end;

function TFiscalPrinterDevice.WaitForPrinting: TPrinterStatus;
var
  Mode: Byte;
  TryCount: Integer;
  TickCount: Integer;
const
  MaxTryCount = 3;
begin
  Logger.Debug('TSharedPrinter.WaitForPrinting');
  TryCount := 0;
  TickCount := GetTickCount;
  repeat
    if Integer(GetTickCount) > (TickCount + Parameters.StatusTimeout*1000) then
      raise Exception.Create(SStatusWaitTimeout);

    Result := GetPrinterStatus;
    Mode := Result.Mode and $0F;
    case Result.AdvancedMode of
      AMODE_IDLE:
      begin
        case Mode of
          MODE_FULLREPORT,
          MODE_EKLZREPORT,
          MODE_SLPPRINT:
            Sleep(Parameters.StatusInterval);
        else
          Exit;
        end;
      end;

      AMODE_PASSIVE,
      AMODE_ACTIVE:
      begin
        // No receipt paper
        if GetModel.CapRecPresent and Result.Flags.RecEmpty then
          raiseExtendedError(OPOS_EFPTR_REC_EMPTY, 'Receipt station is empty');
        // No control paper
        if GetModel.CapJrnPresent and Result.Flags.JrnEmpty then
          raiseExtendedError(OPOS_EFPTR_JRN_EMPTY, 'Journal station is empty');
        // Cover is opened
        if GetModel.CapCoverSensor and Result.Flags.CoverOpened then
          raiseExtendedError(OPOS_EFPTR_COVER_OPEN, 'Cover is opened');

        raiseExtendedError(OPOS_EFPTR_REC_EMPTY, 'Receipt station is empty');
      end;

      AMODE_AFTER:
      begin
        if TryCount > MaxTryCount then
          raise Exception.Create('Failed to continue print');
        ContinuePrint;
        Inc(TryCount);
      end;

      AMODE_REPORT,
      AMODE_PRINT:
        Sleep(Parameters.StatusInterval);
    else
      Sleep(Parameters.StatusInterval);
    end;
  until False;
end;

function TFiscalPrinterDevice.GetPrinterStatus: TPrinterStatus;
var
  ShortStatus: TShortPrinterStatus;
begin
  Logger.Debug('TSharedPrinter.GetPrinterStatus');
  case Parameters.StatusCommand of
    // Driver will select command to read printer status
    StatusCommandDriver:
    begin
      if CapShortEcrStatus then
      begin
        ShortStatus := GetShortStatus;
        Result.Mode := ShortStatus.Mode;
        Result.AdvancedMode := ShortStatus.AdvancedMode;
        Result.OperatorNumber := ShortStatus.OperatorNumber;
        Result.Flags := DecodePrinterFlags(ShortStatus.Flags);
      end else
      begin
        FLongPrinterStatus := GetLongStatus;
        Result.Mode := FLongPrinterStatus.Mode;
        Result.AdvancedMode := FLongPrinterStatus.AdvancedMode;
        Result.OperatorNumber := FLongPrinterStatus.OperatorNumber;
        Result.Flags := DecodePrinterFlags(FLongPrinterStatus.Flags);
      end;
    end;

    // Short status command
    StatusCommandShort:
    begin
      ShortStatus := GetShortStatus;
      Result.Mode := ShortStatus.Mode;
      Result.AdvancedMode := ShortStatus.AdvancedMode;
      Result.OperatorNumber := ShortStatus.OperatorNumber;
      Result.Flags := DecodePrinterFlags(ShortStatus.Flags);
    end;
  else
    // Long status command
    FLongPrinterStatus := GetLongStatus;
    Result.Mode := FLongPrinterStatus.Mode;
    Result.AdvancedMode := FLongPrinterStatus.AdvancedMode;
    Result.OperatorNumber := FLongPrinterStatus.OperatorNumber;
    Result.Flags := DecodePrinterFlags(FLongPrinterStatus.Flags);
  end;
  Logger.Debug(Format('Mode: 0x%.2x, amode: 0x%.2x, Flags: 0x%.4x',
    [Result.Mode, Result.AdvancedMode, Result.Flags.Value]));
end;

function TFiscalPrinterDevice.PrintBarLine(Height: Word; Data: string): Integer;
var
  ReverseBytes: Boolean;
begin
  case Parameters.BarLineByteMode of
    BarLineByteModeAuto: ReverseBytes := Model.BarcodeSwapBytes;
    BarLineByteModeStraight: ReverseBytes := False;
    BarLineByteModeReverse: ReverseBytes := True;
  else
    ReverseBytes := False;
  end;
  if ReverseBytes then
    Data := SwapBytes(Data);
  Result := PrintBinaryLine(Height, Data);
  if Result = 0 then
  begin
    Sleep(Parameters.BarLinePrintDelay);
  end;
end;

function TFiscalPrinterDevice.LoadBarcode2D(const Data: TBarcode2DData): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$DD +
      IntToBin(GetUsrPassword, 4) +
      Chr(Data.BlockType) +
      Chr(Data.BlockNumber) +
      Data.BlockData;
  Result := ExecuteData(Command, Answer);
end;

(*
ѕечать многомерного штрих-кода
 оманда: DEH. ƒлина сообщени€: 15 байт.
"	ѕароль (4 байта)
"	“ип штрих-кода (1 байт)
"	ƒлина данных штрих-кода (2 байта) 1...70891
"	Ќомер начального блока данных (1 байт) 0...127
"	ѕараметр 1 (1 байт)
"	ѕараметр 2 (1 байт)
"	ѕараметр 3 (1 байт)
"	ѕараметр 4 (1 байт)
"	ѕараметр 5 (1 байт)
"	¬ыравнивание (1 байт)
	ќтвет:		DEH. ƒлина сообщени€: 3 байт или 122 байт.
"	 од ошибки (1 байт)
"	ѕор€дковый номер оператора (1 байт) 1Е30
"	ѕараметр 1 (1 байт) 2
"	ѕараметр 2 (1 байт) 2
"	ѕараметр 3 (1 байт) 2
"	ѕараметр 4 (1 байт) 2
"	ѕараметр 5 (1 байт) 2
"	–азмер штрих-кода (горизонтальный) в точках (2 байта) 2
"	–азмер штрих-кода (вертикальный) в точках (2 байта) 2

“ип штрих-кода	Ўтрих-код
0	PDF 417
1	DATAMATRIX
2	AZTEC
3	QR code
1312	QR code2

Ќомер параметра	PDF 417	DATAMATRIX	AZTEC	QR Code
1	Number of columns	Encoding scheme	Encoding scheme	Version, 0=auto; 40 (max)
2	Number of rows	Rotate	-	Mask; 8 (max)
3	Width of module	Dot size	Dot size	Dot size; 3...8
4	Module height	Symbol size	Symbol size	-
5	Error correction level	-	Error correction level	Error correction level; 0...3=L,M,Q,H

¬ыравнивание	“ип выравнивани€
0	ѕо левому краю
1	ѕо центру
2	ѕо правому краю
ѕримечани€:
1 - в зависимости от версии печатаемого QR кода и типа данных;
2 - дл€ типа штрих-кода (QR код).
*)

function TFiscalPrinterDevice.PrintBarcode2D(const Barcode: TBarcode2D): Integer;
var
  Command: string;
  Answer: string;
begin
  Command := #$DE +
    IntToBin(GetUsrPassword, 4) +
    Chr(Barcode.BarcodeType) +
    IntToBin(Barcode.DataLength, 2) +
    Chr(Barcode.BlockNumber) +
    Chr(Barcode.Parameter1) +
    Chr(Barcode.Parameter2) +
    Chr(Barcode.Parameter3) +
    Chr(Barcode.Parameter4) +
    Chr(Barcode.Parameter5) +
    Chr(Barcode.Alignment);
  Result := ExecuteData(Command, Answer);
end;

(*
«агрузка графики-512
 оманда: 	4EH. ƒлина сообщени€: 11+X2 байт.
ѕароль оператора (4 байта)
ƒлина линии L (1 байт) 1Е40 дл€ T = 0; 1Е643 дл€ T = 1
Ќомер начальной линии (2 байта) 1Е12004 дл€ T = 0; 1Е6005 дл€ T = 1
 оличество последующих линий N6 (2 байта) 1Е12004 дл€ T = 0; 1Е6005 дл€ T = 1
“ип графического буфера T (1 байт) 0 - дл€ команд [расширенной] графики; 1 - дл€ команд графики-512
√рафическа€ информаци€ (X2 = N * L байт)
ќтвет:		4EH. ƒлина сообщени€: 3 байта.
 од ошибки (1 байт)
ѕор€дковый номер оператора (1 байт) 1Е30
*)

function TFiscalPrinterDevice.LoadGraphics3(Line: Word; Data: string): Integer;
var
  Answer: string;
  Command: string;
begin
  if Length(Data) > 64 then
    raise Exception.Create('Image data length > 64 bytes');

  Command := #$4E + IntToBin(GetUsrPassword, 4) + Chr(Length(Data)) +
    IntToBin(Line, 2) + IntToBin(1, 2) + #1 + Data;
  Result := ExecuteData(Command, Answer);
end;

function TFiscalPrinterDevice.LoadGraphics3(const P: TLoadGraphics3): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$4E + IntToBin(GetUsrPassword, 4) + Chr(Length(P.Data)) +
    IntToBin(P.FirstLineNum, 2) + IntToBin(P.NextLinesNum, 2) +
    #1 + P.Data;
  Result := ExecuteData(Command, Answer);
end;

(*
ѕечать графики-512 с масштабированием1
 оманда:	4DH. ƒлина сообщени€: 12 байт.
ѕароль оператора (4 байта)
Ќачальна€ лини€ (2 байта) 1Е600
 онечна€ лини€ (2 байта) 1Е600
 оэффициент масштабировани€ точки по вертикали (1 байт) 1Е255
 оэффициент масштабировани€ точки по горизонтали (1 байт) 1Е6
‘лаги (1 байт) Ѕит 0 - контрольна€ лента2, Ѕит 1 - чекова€ лента, Ѕит 23 - подкладной документ, Ѕит 34 - слип чек; Ѕит 75 - отложенна€ печать графики
ќтвет:		4DH. ƒлина сообщени€: 3 байта.
 од ошибки (1 байт)
ѕор€дковый номер оператора (1 байт) 1Е30
ѕримечани€:
1 - в зависимости от модели   “ (дл€ параметра модели Ѕит 42, см. команду F7H);
2 - в зависимости от модели   “ (дл€ параметра модели Ѕит 20, см. команду F7H);
3 - в зависимости от модели   “ (дл€ параметра модели Ѕит 21, см. команду F7H);
4 - в зависимости от модели   “ (дл€ параметра модели Ѕит 34, см. команду F7H); если Ѕит 7 установлен и фискальный чек открыт и установлена настройка "ѕ≈„ј“№ „≈ ј ѕќ «ј –џ“»ё" в таблице 1, то графика будет распечатана перед фискальным чеком; если не установлен Ѕит 7, то графика печатаетс€ немедленно; результат печати можно проверить командой 10H;
*)

function TFiscalPrinterDevice.PrintGraphics3(Line1, Line2: Word): Integer;
var
  P: TPrintGraphics3;
begin
  P.FirstLine := Line1;
  P.LastLine := Line2;
  P.VScale := 1;
  P.HScale := 1;
  P.Flags := PRINTER_STATION_REC;
  Result := PrintGraphics3(P);
end;

function TFiscalPrinterDevice.PrintGraphics3(const P: TPrintGraphics3): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$4D + IntToBin(GetUsrPassword, 4) +
    IntToBin(P.FirstLine, 2) +
    IntToBin(P.LastLine, 2) +
    Chr(P.VScale) + Chr(P.HScale) + Chr(P.Flags);
  Result := ExecuteData(Command, Answer);
end;

procedure TFiscalPrinterDevice.CheckGraphicsSize(Line: Word);
begin

end;

function TFiscalPrinterDevice.FSWriteTLV(const TLVData: string): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$0C + IntToBin(GetSysPassword, 4) + Copy(TLVData, 1, 250);
  Result := ExecuteData(Command, Answer);
end;

function GetFSTaxBits(Value: Integer): Integer;
begin
  Result := 0;
  if Value > 0 then
    Result := 1 shl (Value-1);
end;


(******************************************************************************
ќпераци€ со скидками и надбавками FF0DH
 од команды FF0Dh . ƒлина сообщени€:  254 байт.
  ѕароль системного администратора: 4 байта
  “ип операции: 1 байт
  1 Ц ѕриход,
  2 Ц ¬озврат прихода,
  3 Ц –асход,
  4 Ц ¬озврат расхода
   оличество: 5 байт 0000000000Е9999999999
  ÷ена:             5 байт 0000000000Е9999999999
  —кидка:         5 байт 0000000000Е9999999999
  Ќадбавка:    5 байт 0000000000Е9999999999
  Ќомер отдела: 1 байт
  0Е16 Ц режим свободной продажи, 255 Ц режим продажи по коду товара
  Ќалог:  1 байт
  Ѕит 1 Ђ0ї Ц нет, Ђ1ї Ц 1 налогова€ группа
  Ѕит 2 Ђ0ї Ц нет, Ђ1ї Ц 2 налогова€ группа
  Ѕит 3 Ђ0ї Ц нет, Ђ1ї Ц 3 налогова€ группа
  Ѕит 4 Ђ0ї Ц нет, Ђ1ї Ц 4 налогова€ группа
  Ўтрих-код: 5 байт  000000000000Е999999999999
  “екст: 220 байта строка - название товара и скидки
  ѕримечание: если строка начинаетс€ символами, то она передаЄтс€ на сервер
    ќ‘ƒ но не печатаетс€ на кассе. Ќазвани€ товара и скидки должны
    заканчиватьс€ нулЄм (Ќуль терминированные строки).
ќтвет:    FF0Dh ƒлина сообщени€: 1 байт.
   од ошибки: 1 байт
******************************************************************************)

function TFiscalPrinterDevice.FSSale(const P: TFSSale): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$0D + IntToBin(GetUsrPassword, 4) +
    Chr(Abs(P.RecType)) +
    IntToBin(Abs(P.Quantity), 5) +
    IntToBin(Abs(P.Price), 5) +
    IntToBin(Abs(P.Discount), 5) +
    IntToBin(Abs(P.Charge), 5) +
    Chr(Abs(P.Department)) +
    Chr(GetFSTaxBits(Abs(P.Tax))) +
    IntToBin(P.Barcode, 5) +
    Copy(P.Text, 1, 109) + #0 +
    Copy(P.AdjText, 1, 109) + #0;

  Result := ExecuteData(Command, Answer);
end;

function TFiscalPrinterDevice.FSStorno(const P: TFSSale): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$0E + IntToBin(GetUsrPassword, 4) +
    Chr(Abs(P.RecType)) +
    IntToBin(Abs(P.Quantity), 5) +
    IntToBin(Abs(P.Price), 5) +
    IntToBin(Abs(P.Discount), 5) +
    IntToBin(Abs(P.Charge), 5) +
    Chr(Abs(P.Department)) +
    Chr(GetFSTaxBits(Abs(P.Tax))) +
    IntToBin(P.Barcode, 5) +
    Copy(P.Text, 1, 109) + #0 +
    Copy(P.AdjText, 1, 109) + #0;

  Result := ExecuteData(Command, Answer);
end;

(*
—осто€ние фазы жизни: 1 байт
Ѕит 0 Ц проведена настройка ‘Ќ 
Ѕит 1 Ц открыт фискальный режим 
Ѕит 2 Ц закрыт фискальный режим 
Ѕит 3 Ц закончена передача фискальных данных в ќ‘ƒ 
“екущий документ: 1 байт
00h Ц нет открытого документа 
01h Ц отчет о фискализации 
02h Ц отчет об открытии смены 
04h Ц кассовый чек 
08h Ц отчет о закрытии смены 
10h Ц отчет о закрытии фискального режима 
11h Ц Ѕланк строкой отчетности
12h - ќтчет об изменении параметров регистрации   “ в св€зи с заменой ‘Ќ
13h Ц ќтчет об изменении параметров регистрации   “
14h Ц  ассовый чек коррекции
15h Ц Ѕ—ќ коррекции
17h Ц ќтчет о текущем состо€нии расчетов
ƒанные документа:  1 байт
00 Ц нет данных документа 
01 Ц получены данные документа 
—осто€ние смены: 1 байт
00 Ц смена закрыта 
01 Ц смена открыта 
‘лаги предупреждени€: 1 байт
ƒата и врем€: 5 байт
Ќомер ‘Ќ: 16 байт ASCII
Ќомер последнего ‘ƒ: 4 байта

*)

function TFiscalPrinterDevice.FSReadState(var R: TFSState): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$01 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    R.State := BinToInt(Answer, 1, 1);
    R.Document := BinToInt(Answer, 2, 1);
    R.DocReceived := BinToInt(Answer, 3, 1);
    R.DayOpened := BinToInt(Answer, 4, 1);
    R.WarningFlags := BinToInt(Answer, 5, 1);
    R.Date.Year := BinToInt(Answer, 6, 1);
    R.Date.Month := BinToInt(Answer, 7, 1);
    R.Date.Day := BinToInt(Answer, 8, 1);
    R.Time.Hour := BinToInt(Answer, 9, 1);
    R.Time.Min := BinToInt(Answer, 10, 1);
    R.Time.Sec := 0;
    R.FSNumber := Copy(Answer, 11, 16);
    R.DocNumber := BinToInt(Answer, 27, 4);
  end;
end;

(*

«апросить наличие данных в буфере
 од команды FF30h . ƒлина сообщени€: 6 байт.
ѕароль системного администратора: 4 байта
ќтвет:	    FF30h ƒлина сообщени€: 4 байта.
 од ошибки (1 байт)
 оличество байт в буфере ( 2 байта )  0 Ц нет данных
ћаксимальный размер блока данных ( 1 байт)

*)

function TFiscalPrinterDevice.FSReadStatus(var R: TFSStatus): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$30 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 3);
    R.DataSize := BinToInt(Answer, 1, 2);
    R.BlockSize := BinToInt(Answer, 3, 1);
  end;
end;

(*

Ќайти фискальный документ по номеру
 од команды FF0Ah . ƒлина сообщени€: 10 байт.
ѕароль системного администратора: 4 байта
Ќомер фискального документа: 4 байта
ќтвет: FF0јh ƒлина сообщени€ 3+N байт.
 од ошибки: 1 байт
“ип фискального документа: 1 байт
ѕолучена ли квитанци€ из ќ‘ƒ: 1 байт
1- да
0 -нет
ƒанные фискального документа в зависимости от типа документ: N байт

*)

function TFiscalPrinterDevice.FSFindDocument(DocNumber: Integer;
  var R: TFSDocument): Integer;

  (*
  //SDocType1 = 'ќтчЄт о регистрации';

  ƒата и врем€	DATE_TIME	5
  Ќомер ‘ƒ	Uint32, LE	4
  ‘искальный признак	Uint32, LE	4
  »ЌЌ	ASCII	12
  –егистрационный номер   “	ASCII	20
   од налогообложени€	Byte	1
  –ежим работы	Byte	1}
  *)

  procedure DecodeDocType1(const Data: string; var R: TFSDocument1);
  begin
    CheckMinLength(Data, 47);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.TaxID := TrimRight(Copy(Data, 14, 12));
    R.EcrRegNum := TrimRight(Copy(Data, 26, 20));
    R.TaxType := Ord(Data[46]);
    R.WorkMode := Ord(Data[47]);
  end;

  (*
  //SDocType2 = 'ќтчЄт об открытии смены';
  ƒата и врем€	DATE_TIME	5
  Ќомер ‘ƒ	Uint32, LE	4
  ‘искальный признак	Uint32, LE	4
  Ќомер смены	Uint16, LE	2}
  *)

  procedure DecodeDocType2(const Data: string; var R: TFSDocument2);
  begin
    CheckMinLength(Data, 15);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.DayNum := BinToInt(Data, 14, 2);
  end;

  (*
  SDocType3 = ' ассовый чек';
  ƒата и врем€	DATE_TIME	5
  Ќомер ‘ƒ	Uint32, LE	4
  ‘искальный признак	Uint32, LE	4
  “ип операции	Byte	1
  —умма операции	Uint40, LE	5
  *)

  procedure DecodeDocType3(const Data: string; var R: TFSDocument3);
  begin
    CheckMinLength(Data, 19);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.OperationType := Ord(Data[14]);
    R.Amount := BinToInt(Data, 15, 5);
  end;

  (*6 ќтчЄт о закрытии фискального накопител€
  ƒата и врем€	DATE_TIME	5
  Ќомер ‘ƒ	Uint32, LE	4
  ‘искальный признак	Uint32, LE	4
  »ЌЌ	ASCII	12
  –егистрационный номер   “	ASCII	20 *)

  procedure DecodeDocType6(const Data: string; var R: TFSDocument6);
  begin
    CheckMinLength(Data, 45);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.TaxID := Copy(Data, 14, 12);
    R.EcrRegNum := Copy(Data, 26, 20);
  end;

  //11 ќтчЄт об изменении параметров регистрации
  {ƒата и врем€	DATE_TIME	5
  Ќомер ‘ƒ	Uint32, LE	4
  ‘искальный признак	Uint32, LE	4
  »ЌЌ	ASCII	12
  –егистрационный номер   “	ASCII	20
   од налогообложени€	Byte	1
  –ежим работы	Byte	1
   од причины перерегистрации	Byte	1}

  procedure DecodeDocType11(const Data: string; var R: TFSDocument11);
  begin
    CheckMinLength(Data, 48);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.TaxID := Copy(Data, 14, 12);
    R.EcrRegNum := Copy(Data, 26, 20);
    R.TaxType := Ord(Data[46]);
    R.WorkMode := Ord(Data[47]);
    R.ReasonCode := Ord(Data[48]);
  end;

  //21 ќтчет о состо€нии расчетов
  {ƒата и врем€	DATE_TIME	5
  Ќомер ‘ƒ	Uint32, LE	4
  ‘искальный признак	Uint32, LE	4
   ол-во неподтвержденных документов	Uint32, LE	4
  ƒата первого неподтвержденного документа	DATE_TIME	5}

  procedure DecodeDocType21(const Data: string; var R: TFSDocument21);
  begin
    CheckMinLength(Data, 20);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.DocCount := BinToInt(Data, 14, 2);
    R.DocDate := BinToPrinterDateTime2(Copy(Data, 16, 5));
  end;

var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$0A + IntToBin(GetSysPassword, 4) + IntToBin(DocNumber, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    R.DocType := Ord(Answer[1]);
    R.TicketReceived := Ord(Answer[2]) = 1;
    R.TlvData := Copy(Answer, 3, Length(Answer));
    case R.DocType of
      1: DecodeDocType1(R.TlvData, R.DocType1);
      2: DecodeDocType2(R.TlvData, R.DocType2);
      3: DecodeDocType3(R.TlvData, R.DocType3);
      4: DecodeDocType3(R.TlvData, R.DocType3);
      5: DecodeDocType2(R.TlvData, R.DocType2);
      6: DecodeDocType6(R.TlvData, R.DocType6);
      11: DecodeDocType11(R.TlvData, R.DocType11);
      21: DecodeDocType21(R.TlvData, R.DocType21);
      31: DecodeDocType3(R.TlvData, R.DocType3);
    end;
  end;
end;

function TFiscalPrinterDevice.FSReadDocMac(var DocMac: Int64): Integer;
var
  FSState: TFSState;
  FSDocument: TFSDocument;
begin
  Result := FSReadState(FSState);
  if Result <> 0 then Exit;

  Result := FSFindDocument(FSState.DocNumber, FSDocument);
  DocMac := 0;
  case FSDocument.DocType of
    1: DocMac := FSDocument.DocType1.DocMac;
    2: DocMac := FSDocument.DocType2.DocMac;
    3: DocMac := FSDocument.DocType3.DocMac;
    4: DocMac := FSDocument.DocType3.DocMac;
    5: DocMac := FSDocument.DocType2.DocMac;
    6: DocMac := FSDocument.DocType6.DocMac;
    11: DocMac := FSDocument.DocType11.DocMac;
    21: DocMac := FSDocument.DocType21.DocMac;
    31: DocMac := FSDocument.DocType3.DocMac;
  end;
end;

(*
ѕрочитать блок данных данных из буфера
 од команды FF31h . ƒлина сообщени€: 6 байт.
ѕароль системного администратора: (4 байта)
Ќачальное смещение: 2 байта
 оличество запрашиваемых данных (1 байт)
        ќтвет:	    FF31h ƒлина сообщени€: 1+N байт.
 од ошибки (1 байт)
ƒанные (N байт)
*)

function TFiscalPrinterDevice.FSReadBlock(const P: TFSBlockRequest;
  var Block: string): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$31 + IntToBin(GetSysPassword, 4) +
    IntToBin(P.Offset, 2) + Chr(P.Size);

  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    Block := Answer;
  end;
end;

(*
Ќачать запись данных в буфер
 од команды FF32h . ƒлина сообщени€: 8 байт.
ѕароль системного администратора: (4 байта)
–азмер данных ( 2 байта)
        ќтвет:	    FF32h ƒлина сообщени€: 2 байта.
 од ошибки (1 байт)
ћаксимальный размер блок данных (1 байт)
*)

function TFiscalPrinterDevice.FSStartWrite(DataSize: Word;
  var BlockSize: Byte): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$32 + IntToBin(GetSysPassword, 4) + IntToBin(DataSize, 2);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 1);
    BlockSize := Ord(Answer[1]);
  end;
end;

(*

«аписать блок данных в буфер
 од команды FF33h . ƒлина сообщени€: 9+N байт.
ѕароль системного администратора: (4 байта)
Ќачальное смещение: (2 байта)
–азмер данных  (1 байт)
ƒанные дл€ записи ( N байт)
         ќтвет:	    FF33h ƒлина сообщени€: 1 байт.
 од ошибки (1 байт)

*)

function TFiscalPrinterDevice.FSWriteBlock(const Block: TFSBlock): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$33 + IntToBin(GetSysPassword, 4) +
    IntToBin(Block.Offset, 2) + IntToBin(Length(Block.Data), 1) +
    Block.Data;

  Result := ExecuteData(Command, Answer);
end;

function TFiscalPrinterDevice.FSReadBlockData: string;
var
  i: Integer;
  Count: Integer;
  Block: string;
  BlockData: string;
  Status: TFSStatus;
  DataSize: Integer;
  BlockSize: Integer;
  BlockRequest: TFSBlockRequest;
begin
  BlockData := '';
  BlockRequest.Offset := 0;
  Check(FSReadStatus(Status));
  if Status.DataSize = 0 then Exit;
  if Status.BlockSize = 0 then Exit;

  Count := (Status.DataSize + Status.BlockSize-1) div Status.BlockSize;
  DataSize := Status.DataSize;
  for i := 0 to Count-1 do
  begin
    BlockSize := Min(Status.BlockSize, DataSize);
    BlockRequest.Offset := i*Status.BlockSize;
    BlockRequest.Size := BlockSize;
    Check(FSReadBlock(BlockRequest, Block));
    BlockData := BlockData + Block;
    DataSize := DataSize - BlockSize;
  end;
  BlockData := Copy(BlockData, 1, Status.DataSize);
  Result := BlockData;
end;

procedure TFiscalPrinterDevice.FSWriteBlockData(const BlockData: string);
var
  i: Integer;
  Count: Integer;
  BlockSize: Byte;
  Block: TFSBlock;
begin
  Check(FSStartWrite(Length(BlockData), BlockSize));
  if BlockSize = 0 then
    raise Exception.Create('BlockSize = 0');

  Count := (Length(BlockData)+ BlockSize-1) div BlockSize;
  for i := 0 to Count-1 do
  begin
    Block.Offset := BlockSize*i;
    Block.Size := BlockSize;
    Block.Data := Copy(BlockData, BlockSize*i + 1, BlockSize);
    Check(FSWriteBlock(Block));
  end;
end;

{******************************************************************************
—формировать отчЄт о состо€нии расчЄтов FF38H
 од команды FF38h . ƒлина сообщени€: 6 байт.
  ѕароль системного администратора: 4 байта
ќтвет:	    FF38h ƒлина сообщени€: 16 байт.
   од ошибки: 1 байт
  Ќомер ‘ƒ: 4 байта
  ‘искальный признак: 4 байта
   оличество неподтверждЄнных документов: 4 байта
  ƒата первого неподтверждЄнного документа: 3 байта √√,ћћ,ƒƒ
******************************************************************************}

function TFiscalPrinterDevice.FSPrintCalcReport(var R: TFSCalcReport): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$38 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 15);

    R.DocNumber := BinToInt(Answer, 1, 4);
    R.FiscalSign := BinToInt(Answer, 5, 4);
    R.OutstandDocCount := BinToInt(Answer, 9, 4);
    R.OutstandDocDate.Year := Ord(Answer[13]);
    R.OutstandDocDate.Month := Ord(Answer[14]);
    R.OutstandDocDate.Day := Ord(Answer[15]);
  end;
end;

(*
ѕолучить статус информационного обмена
 од команды FF39h . ƒлина сообщени€: 6 байт.
  ѕароль системного администратора: 4 байта
ќтвет: FF39h ƒлина сообщени€: 14 байт.
   од ошибки: 1 байт
  —татус информационного обмена: 1 байт
  (0 Ц нет, 1 Ц да)
  Ѕит 0 Ц транспортное соединение установлено
  Ѕит 1 Ц есть сообщение дл€ передачи в ќ‘ƒ
  Ѕит 2 Ц ожидание ответного сообщени€ (квитанции) от ќ‘ƒ
  Ѕит 3 Ц есть команда от ќ‘ƒ
  Ѕит 4 Ц изменились настройки соединени€ с ќ‘ƒ
  Ѕит 5 Ц ожидание ответа на команду от ќ‘ƒ
  —осто€ние чтени€ сообщени€: 1 байт 1 Ц да, 0 -нет
   оличество сообщений дл€ ќ‘ƒ: 2 байта
  Ќомер документа дл€ ќ‘ƒ первого в очереди: 4 байта
  ƒата и врем€ документа дл€ ќ‘ƒ первого в очереди: 5 байт

*)

function TFiscalPrinterDevice.FSReadCommStatus(
  var R: TFSCommStatus): Integer;

  function DecodeFSWriteStatus(Value: Integer): TFSWriteStatus;
  begin
    Result.IsConnected := TestBit(Value, 0);
    Result.HasMessageToSend := TestBit(Value, 1);
    Result.IsWaitForTicket := TestBit(Value, 2);
    Result.IsServerCommand := TestBit(Value, 3);
    Result.ConnParamsChanged := TestBit(Value, 4);
    Result.IsWaitForAnswer := TestBit(Value, 5);
  end;

var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$39 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 11);
    R.WriteStatus := BinToInt(Answer, 1, 1);
    R.FSWriteStatus := DecodeFSWriteStatus(R.WriteStatus);
    R.ReadStatus := BinToInt(Answer, 2, 1);
    R.DocumentCount := BinToInt(Answer, 3, 2);
    R.DocumentNumber := BinToInt(Answer, 5, 4);
    R.DocumentDate := BinToPrinterDateTime2(Copy(Answer, 9, Length(Answer)));
  end;
end;

(*
«апрос срока действи€ ‘Ќ
 од команды FF03h . ƒлина сообщени€: 6 байт.
ѕароль системного администратора: 4 байта
ќтвет: FF03h ƒлина сообщени€: 4 байт.
 од ошибки: 1 байт
—рок действи€: 3 байта √√,ћћ,ƒƒ
*)

function TFiscalPrinterDevice.FSReadExpireDate(var Date: TPrinterDate): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$03 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    Date := BinToPrinterDate(Answer);
  end;
end;

(*
  «апрос итогов фискализации

   од команды FF09h . ƒлина сообщени€: 6 байт.
    ѕароль системного администратора: 4 байта

  ќтвет: FF09h ƒлина сообщени€: 48 байт.
     од ошибки : 1 байт
    ƒата и врем€: 5 байт DATE_TIME
    »ЌЌ : 12 байт ASCII
    –егистрационный номер   T: 20 байт ASCII
     од налогообложени€: 1 байт
    –ежим работы: 1 байт
    Ќомер ‘ƒ: 4 байта
    ‘искальный признак: 4 байта
*)

function TFiscalPrinterDevice.FSReadFiscalResult(var R: TFSFiscalResult): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$09 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    R.Date := BinToPrinterDateTime2(Answer);
    R.TaxID := TrimRight(Copy(Answer, 6, 12));
    R.EcrRegNum := TrimRight(Copy(Answer, 18, 20));
    R.TaxType := BinToInt(Answer, 38, 1);
    R.WorkMode := BinToInt(Answer, 39, 1);
    R.DocNum := BinToInt(Answer, 40, 4);
    R.DocMac := BinToInt(Answer, 44, 4);
  end;
end;

(*
«апрос квитанции о получении данных в ќ‘ƒ по номеру
документа
 од команды FF3—h . ƒлина сообщени€: 11 байт.
ѕароль системного администратора: 4 байта
Ќомер фискального документа: 4 байта
ќтвет: FF3—h ƒлина сообщени€: 1+N байт.
 од ошибки: 1 байт
 витанци€: N байт
*)

function TFiscalPrinterDevice.FSReadTicket(var R: TFSTicket): Integer;
var
  Answer: string;
  Command: string;
begin
  Command := #$FF#$3C + IntToBin(GetSysPassword, 4) + IntToBin(R.Number, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    R.Data := Answer;
    if Length(Answer) >= 27 then
    begin
      R.Date := BinToPrinterDateTime2(R.Data);
      R.DocumentMac := Copy(R.Data, 6, 18);
      R.DocumentNum := BinToInt(R.Data, 24, 4);
    end;
  end;
end;


function TFiscalPrinterDevice.GetCapFiscalStorage: Boolean;
begin
  Result := FCapFiscalStorage;
end;

function TFiscalPrinterDevice.GetCapOpenReceipt: Boolean;
begin
  Result := FCapOpenReceipt;
end;

function TFiscalPrinterDevice.WriteCustomerAddress(const Value: string): Integer;
begin
  Result := FSWriteTag(1008, Value);
end;

function TFiscalPrinterDevice.FSWriteTag(TagID: Integer; const Data: string): Integer;
var
  Values: TTLVList;
begin
  Values := TTLVList.Create;
  try
    Values.AddStr(TagID, Data, 0);
    Result := FSWriteTLV(Values.GetRawData);
  finally
    Values.Free;
  end;
end;

function TFiscalPrinterDevice.ReadFPParameter(ParamId: Integer): string;
begin
  case ParamId of
    DIO_FPTR_PARAMETER_QRCODE_ENABLED:
    begin
      // 1,1,41,1,0,0,1,' одирование реквизитов чека','1'
      Result := ReadTableStr(1, 1, 41);
    end;
    DIO_FPTR_PARAMETER_OFD_ADDRESS:
    begin
      Result := ReadTableStr(19, 1, 1);
    end;

    DIO_FPTR_PARAMETER_OFD_PORT:
    begin
      Result := ReadTableStr(19, 1, 2);
    end;

    DIO_FPTR_PARAMETER_OFD_TIMEOUT:
    begin
      Result := ReadTableStr(19, 1, 3);
    end;

    DIO_FPTR_PARAMETER_RNM:
    begin
      Result := ReadTableStr(18, 1, 3);
    end;
  else
    raise Exception.CreateFmt('Invalid parameter ID value, %d', [ParamId]);
  end;
end;

function TFiscalPrinterDevice.ReadFSParameter(ParamID: Integer;
  const pString: string): string;

  (*
  7.1.8 ‘ормат квитанции, при выдаче из јрхива ‘Ќ
  ------------------------------------------------
  ѕоле                        “ип            ƒлина
  ------------------------------------------------
  ƒата и врем€                DATE_TIME      5
  ‘искальный признак ќ‘ƒ      DATA           18
  Ќомер ‘ƒ                    Uint32, LE     4
  ------------------------------------------------
  *)

var
  DocMac: Int64;
  Ticket: TFSTicket;
  FSState: TFSState;
  OposDate: TOposDate;
  ExpireDate: TPrinterDate;
  FSCommStatus: TFSCommStatus;
  FSFiscalResult: TFSFiscalResult;
begin
  case ParamID of
    DIO_FS_PARAMETER_SERIAL:
    begin
      Check(FSReadState(FSState));
      Result := String(FSState.FSNumber);
    end;

    DIO_FS_PARAMETER_LAST_DOC_NUM:
    begin
      Check(FSReadState(FSState));
      Result := IntToStr(FSState.DocNumber);
    end;

    DIO_FS_PARAMETER_LAST_DOC_MAC:
    begin
      Check(FSReadDocMac(DocMac));
      Result := IntToStr(DocMac);
    end;

    DIO_FS_PARAMETER_QUEUE_SIZE:
    begin
      Check(FSReadCommStatus(FSCommStatus));
      Result := IntToStr(FSCommStatus.DocumentCount);
    end;

    DIO_FS_PARAMETER_EXPIRE_DATE:
    begin
      Check(FSReadExpireDate(ExpireDate));
      OposDate := PrinterDateToOposDate(ExpireDate);
      Result := EncodeOposDate(OposDate);
    end;

    DIO_FS_PARAMETER_FIRST_DOC_NUM:
    begin
      Check(FSReadCommStatus(FSCommStatus));
      Result := IntToStr(FSCommStatus.DocumentNumber);
    end;

    DIO_FS_PARAMETER_FIRST_DOC_DATE:
    begin
      Check(FSReadCommStatus(FSCommStatus));
      OposDate := PrinterDateTimeToOposDate(FSCommStatus.DocumentDate);
      Result := EncodeOposDate(OposDate);
    end;

    DIO_FS_PARAMETER_FISCAL_DATE:
    begin
      Check(FSReadFiscalResult(FSFiscalResult));
      OposDate := PrinterDateTimeToOposDate(FSFiscalResult.Date);
      Result := EncodeOposDate(OposDate);
    end;

    DIO_FS_PARAMETER_OFD_ONLINE:
    begin
      Check(FSReadCommStatus(FSCommStatus));
      Result := BoolToStr(FSCommStatus.FSWriteStatus.IsConnected);
    end;

    DIO_FS_PARAMETER_TICKET_HEX:
    begin
      Ticket.Number := StrToInt(pString);
      Check(FSReadTicket(Ticket));
      Result := StrToHexText(Ticket.Data);
    end;

    DIO_FS_PARAMETER_TICKET_STR:
    begin
      Ticket.Number := StrToInt(pString);
      Check(FSReadTicket(Ticket));
      Result := TicketToStr(Ticket);
    end;

  else
    raise Exception.Create('Invalid pData parameter value');
  end;
end;

procedure TFiscalPrinterDevice.WriteFPParameter(ParamId: Integer;
  const Value: string);
begin
  case ParamId of
    DIO_FPTR_PARAMETER_QRCODE_ENABLED:
    begin
      WriteTable(1, 1, 41, Value);
    end;
    DIO_FPTR_PARAMETER_OFD_ADDRESS:
    begin
      WriteTable(19, 1, 1, Value);
    end;

    DIO_FPTR_PARAMETER_OFD_PORT:
    begin
      WriteTable(19, 1, 2, Value);
    end;

    DIO_FPTR_PARAMETER_OFD_TIMEOUT:
    begin
      WriteTable(19, 1, 3, Value);
    end;
  else
    raise Exception.CreateFmt('Invalid parameter ID value, %d', [ParamId]);
  end;
end;


function TFiscalPrinterDevice.ReadDiscountMode: Integer;
var
  R: TPrinterTableRec;
begin
  Result := 0;
  try
    if ReadTableStructure(17, R) = 0 then
    begin
      Result := ReadTableInt(17, 1, 3);
    end;
  except
    on E: Exception do
    begin
      Result := 0;
    end;
  end;
end;

function TFiscalPrinterDevice.GetDiscountMode: Integer;
begin
  Result := FDiscountMode;
end;

function TFiscalPrinterDevice.GetIsFiscalized: Boolean;
begin
  Result := FIsFiscalized;
end;

///////////////////////////////////////////////////////////////////////////////
//  ƒобавлен запрос необнул€емых сумм через сервисную команду 1
// (FE F4 00 00 00 00), возвращает 4 8-ми байтных числа.

function TFiscalPrinterDevice.FSReadTotals(var R: TFMTotals): Integer;
var
  Command: string;
  Answer: string;
begin
  FLogger.Debug('FSReadTotals');
  Command := #$FE#$F4#$00#$00#$00#$00;
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 32);
    R.OperatorNumber := 0;
    R.SaleTotal := BinToInt2(Answer, 1, 8);
    R.RetSale := BinToInt2(Answer, 9, 8);
    R.BuyTotal := BinToInt2(Answer, 17, 8);
    R.RetBuy := BinToInt2(Answer, 25, 8);
  end;
end;

(*

Ќакоплени€ по видам оплаты по 4 типам торговых операций (продажа, покупка,
возврат продажи, возврат покупки) за смену:
193Е196 Ц наличными;
197Е200 Ц видом оплаты 2;
201Е204 Ц видом оплаты 3;
205Е208 Ц видом оплаты 4;

*)

function TFiscalPrinterDevice.ReadDayTotalsByReceiptType(Index: Integer): Int64;
begin
  Result := ReadCashRegister(193 + Index) +
    ReadCashRegister(197 + Index) +
    ReadCashRegister(201 + Index) +
    ReadCashRegister(205 + Index);
end;

(*
Ќакоплени€ по видам оплаты по 4 типам торговых операций (продажа, покупка,
возврат продажи, возврат покупки) в чеке:
72Е75 Ц наличными;
76Е79 Ц видом оплаты 2;
80Е83 Ц видом оплаты 3;
84Е87 Ц видом оплаты 4;
*)

function TFiscalPrinterDevice.ReadTotalsByReceiptType(Index: Integer): Int64;
begin
  Result :=
    ReadCashRegister(72 + Index) +
    ReadCashRegister(76 + Index) +
    ReadCashRegister(80 + Index) +
    ReadCashRegister(84 + Index);
end;

function TFiscalPrinterDevice.ReadDayTotals: TFMTotals;
begin
  Result.SaleTotal := 0;
  Result.BuyTotal := 0;
  Result.RetSale := 0;
  Result.RetBuy := 0;
  if GetIsFiscalized then
  begin
    Result.SaleTotal := ReadDayTotalsByReceiptType(0);
    Result.BuyTotal := ReadDayTotalsByReceiptType(1);
    Result.RetSale := ReadDayTotalsByReceiptType(2);
    Result.RetBuy := ReadDayTotalsByReceiptType(3);
  end else
  begin
    Result.SaleTotal := ReadDayTotalsByReceiptType(0);
    Result.BuyTotal := 0;
    Result.RetSale := 0;
    Result.RetBuy := 0;
  end;
end;

function TFiscalPrinterDevice.ReadFPTotals(Flags: Integer): TFMTotals;
begin
  Result.SaleTotal := 0;
  Result.BuyTotal := 0;
  Result.RetSale := 0;
  Result.RetBuy := 0;
  if CapFiscalStorage then
  begin
    Check(FSReadTotals(Result));
  end else
  begin
    if GetIsFiscalized then
    begin
      Check(ReadFMTotals(Flags, Result));
    end else
    begin
      Result.SaleTotal := ReadCashRegister(244);
    end;
  end;
end;

function TFiscalPrinterDevice.ReadFPDayTotals(Flags: Integer): TFMTotals;
var
  FPTotals: TFMTotals;
  DayTotals: TFMTotals;
begin
  FPTotals := ReadFPTotals(Flags);
  DayTotals := ReadDayTotals;
  Result.SaleTotal := FPTotals.SaleTotal + DayTotals.SaleTotal;
  Result.BuyTotal := FPTotals.BuyTotal + DayTotals.BuyTotal;
  Result.RetSale := FPTotals.RetSale + DayTotals.RetSale;
  Result.RetBuy := FPTotals.RetBuy + DayTotals.RetBuy;
end;

(*

—формировать чек коррекции FF36H
 од команды FF36h . ƒлина сообщени€: 12 байт.
ѕароль системного администратора: 4 байта
»тог чека: 5 байт 0000000000Е9999999999
“ип операции 1 байт

ќтвет: FF36h ƒлина сообщени€: 11 байт.
 од ошибки: 1 байт
Ќомер чека: 2 байта
Ќомер ‘ƒ: 4 байта
‘искальный признак: 4 байт

*)

function TFiscalPrinterDevice.FSPrintCorrectionReceipt(
  var Command: TFSCorrectionReceipt): Integer;
var
  Cmd: string;
  Data: string;
begin
  Cmd := #$FF#$36 +
    IntToBin(GetSysPassword, 4) +
    IntToBin(Command.Total, 5) +
    IntToBin(Command.RecType, 1);
  Result := ExecuteData(Cmd, Data);
  if Result = 0 then
  begin
    CheckMinLength(Data, 10);
    Command.ResultCode := Result;
    Command.ReceiptNumber := BinToInt(Data, 1, 2);
    Command.DocumentNumber := BinToInt(Data, 3, 4);
    Command.DocumentMac := BinToInt(Data, 7, 4);
  end;
end;

procedure TFiscalPrinterDevice.LoadTables(const Path: WideString);
var
  i: Integer;
  j: Integer;
  Mask: string;
  F: TSearchRec;
  DeviceName: string;
  FileName: string;
  ResultCode: Integer;
  FileNames: TStrings;
  Tables: TPrinterTables;
  Reader: TCsvPrinterTableFormat;
begin
  Logger.Debug('LoadTables("' + Path + '")');

  DeviceName := GetDeviceMetrics.DeviceName;
  FileNames := TStringList.Create;
  Reader := TCsvPrinterTableFormat.Create(nil);
  Tables := TPrinterTables.Create;
  try
    Mask := IncludeTrailingpathDelimiter(Path) + '*.csv';
    ResultCode := FindFirst(Mask, faAnyFile, F);
    if ResultCode = 0 then
    begin
      while ResultCode = 0 do
      begin
        FileName := ExtractFilePath(Mask) + F.FindData.cFileName;
        FileNames.Add(FileName);
        ResultCode := FindNext(F);
      end;
      FindClose(F);
    end;

    for i := 0 to FileNames.Count-1 do
    begin
      Reader.LoadFromFile(FileNames[i], Tables);
      if Tables.DeviceName = DeviceName then
      begin
        Logger.Debug('Tables file name: ' + FileNames[i]);
        Logger.Debug('Tables count = ' + IntToStr(Tables.Count));
        for j := 0 to Tables.Count - 1 do
        begin
          WriteFields(Tables[j]);
        end;
        Break;
      end;
    end;
  except
    on E: Exception do
    begin
      Logger.Error('LoadTables: ' + E.Message);
    end;
  end;
  Tables.Free;
  Reader.Free;
  FileNames.Free;
end;

procedure TFiscalPrinterDevice.WriteFields(Table: TPrinterTable);
var
  i: Integer;
  Data: string;
  Field: TPrinterField;
  FieldValue: WideString;
begin
  for i := 0 to Table.Fields.Count-1 do
  begin
    Field := Table.Fields[i];
    Data := ReadTableBin(Field.Table, Field.Row, Field.Field);
    FieldValue := FieldToStr(Field.Data, Data);
    if FieldValue <> Field.Value then
    begin
      WriteTable(Field.Table, Field.Row, Field.Field, Field.Value);
    end;
  end;
end;

function TFiscalPrinterDevice.GetContext: TDriverContext;
begin
  Result := FContext;
end;

function TFiscalPrinterDevice.IsRecOpened: Boolean;
begin
  Result := (GetPrinterStatus.Mode and $0F) = MODE_REC;
end;


end.
