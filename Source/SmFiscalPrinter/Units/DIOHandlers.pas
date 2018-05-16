unit DIOHandlers;

interface

uses
  // VCL
  SysUtils, Graphics, Extctrls,
  // This
  DIOHandler, DirectIOAPI, PrinterCommand, ShtrihFiscalPrinter,
  FiscalPrinterDevice, CommandDef, CommandParam, XmlParser, BinStream,
  OposException, PrinterTypes, Opos, StringUtils, FiscalPrinterImpl,
  fmuLogo, AsBarcode, FiscalPrinterTypes, ZReport, LogFile, PrinterParameters;

const
  ValueDelimiters = [';'];

type
  { TBarcodeParamsRec }

  TBarcodeParamsRec = record
    Data: string;
    Height: Integer;
  end;

  { TDIOCommandDef }

  TDIOCommandDef = class(TDIOHandler)
  private
    FCommands: TCommandDefs;
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOHexCommand }

  TDIOHexCommand = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOCheckEndDay }

  TDIOCheckEndDay = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOLoadLogo }

  TDIOLoadLogo = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintLogo }

  TDIOPrintLogo = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOLogoDlg }

  TDIOLogoDlg = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOBarcode }

  TDIOBarcode = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;

    procedure PrintEan13(const Data: string);
    procedure PrintBarCode(const Data: string; BarcodeType: TAsBarcodeType);

    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStrCommand }

  TDIOStrCommand = class(TDIOHandler)
  private
    FCommands: TCommandDefs;
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintText }

  TDIOPrintText = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTaxName }

  TDIOWriteTaxName = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadTaxName }

  TDIOReadTaxName = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWritePaymentName }

  TDIOWritePaymentName = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWritePaymentName2 }

  TDIOWritePaymentName2 = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadPaymentName }

  TDIOReadPaymentName = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTable }

  TDIOWriteTable = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadTable }

  TDIOReadTable = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetDepartment }

  TDIOGetDepartment = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetDepartment }

  TDIOSetDepartment = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadCashRegister }

  TDIOReadCashRegister = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadOperatingRegister }

  TDIOReadOperatingRegister = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintRecRefund }

  TDIOPrintRecRefund = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintJournal }

  TDIOPrintJournal = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadDayNumber }

  TDIOReadDayNumber = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWaitForPrint }

  TDIOWaitForPrint = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintHeader }

  TDIOPrintHeader = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintTrailer }

  TDIOPrintTrailer = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReport }

  TDIOZReport = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReportXML }

  TDIOZReportXML = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReportCSV }

  TDIOZReportCSV = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetLastError }

  TDIOGetLastError = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetPrinterStation }

  TDIOGetPrinterStation = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetPrinterStation }

  TDIOSetPrinterStation = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetDriverParameter }

  TDIOGetDriverParameter = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetDriverParameter }

  TDIOSetDriverParameter = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

const
  FPTR_ERROR_BASE = 300;

implementation

function BoolToStr(Value: Boolean): string;
begin
  if Value then Result := '1'
  else Result := '0';
end;

function StrToBool(const Value: string): Boolean;
begin
  Result := Value <> '0';
end;

{ TDIOCommandDef }

constructor TDIOCommandDef.CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
  ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FCommands := ACommands;
  FPrinter := APrinter;
end;

procedure TDIOCommandDef.DirectIO(var pData: Integer; var pString: WideString);
var
  Param: TCommandParam;
  Stream: TBinStream;
  Command: TCommandDef;
  ResultCode: Integer;
begin
  Printer.CheckEnabled;

  Command := FCommands.ItemByCode(pData);
  if Command = nil then
    raiseException('Invalid command code');

  Stream := TBinStream.Create;
  try
    Command.InParams.AsXml := pString;
    Stream.WriteByte(Command.Code);
    Command.InParams.Write(Stream);
    Command.OutParams.ClearValue;

    ResultCode := Device.ExecuteStream(Stream);
    Param := Command.OutParams.FindItem('ResultCode');
    if Param <> nil then
      Param.Value := IntToStr(ResultCode);

    if ResultCode = 0 then
    begin
      Stream.Position := Stream.Position-1;
      Command.OutParams.Read(Stream);
    end else
    begin
      RaiseOPOSException(OPOS_E_FAILURE, FPTR_ERROR_BASE + ResultCode,
        GetErrorText(ResultCode));
    end;
    pString := Command.OutParams.AsXml;
  finally
    Stream.Free;
  end;
end;

function TDIOCommandDef.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

{ TDIOHexCommand }

constructor TDIOHexCommand.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOHexCommand.DirectIO(var pData: Integer; var pString: WideString);
var
  TxData: string;
  RxData: string;
begin
  Printer.CheckEnabled;
  TxData := HexToStr(pString);
  Printer.Printer.Device.Check(
    Printer.Printer.Device.ExecuteData(TxData, RxData));
  pString := StrToHex(RxData);
end;

{ TDIOCheckEndDay }

constructor TDIOCheckEndDay.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOCheckEndDay.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.CheckEnabled;
  if Printer.Printer.GetPrinterStatus.Mode = ECRMODE_24OVER then pData := 1
  else pData := 0;
end;

{ TDIOLoadLogo }

constructor TDIOLoadLogo.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOLoadLogo.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.LoadLogo(pString);
end;

{ TDIOPrintLogo }

constructor TDIOPrintLogo.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintLogo.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintLogo;
end;

{ TDIOLogoDlg }

constructor TDIOLogoDlg.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOLogoDlg.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  ShowLogoDialog(Printer);
end;

{ TDIOBarcode }

constructor TDIOBarcode.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOBarcode.PrintBarCode(const Data: string;
  BarcodeType: TAsBarcodeType);
var
  Barcode: TAsBarcode;
begin
  Barcode := TAsBarcode.Create;
  try
    Barcode.Text := Data;
    Barcode.ModuleWidth := 2;
    Barcode.Alignment := baCenter;
    Barcode.BarcodeType := BarcodeType;
    Barcode.PrintWidthInDots := Printer.Printer.GetPrintWidthInDots;
    Barcode.CreateBarcode;
    Printer.Printer.PrintBarLine(100, Barcode.LineData);
    Sleep(Printer.Parameters.BarcodePrintDelay);
    Printer.Statistics.BarcodePrinted;
  finally
    Barcode.Free;
  end;
end;

procedure TDIOBarcode.PrintEan13(const Data: string);
begin
  Printer.Printer.Device.PrintBarcode(StrToInt64(Data));
  Printer.Statistics.BarcodePrinted;
end;

procedure TDIOBarcode.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Barcode: TBarcodeParamsRec;
begin
  Barcode.Data := pString;
  Barcode.Height := 100;

  case pData of
    DIO_BARCODE_EAN13_INT         : PrintEan13(pString);
    DIO_BARCODE_CODE128A          : PrintBarCode(pString, btCode128A);
    DIO_BARCODE_CODE128B          : PrintBarCode(pString, btCode128B);
    DIO_BARCODE_CODE128C          : PrintBarCode(pString, btCode128C);
    DIO_BARCODE_CODE39            : PrintBarCode(pString, btCode39);
    DIO_BARCODE_CODE25INTERLEAVED : PrintBarCode(pString, btCode_2_5_interleaved);
    DIO_BARCODE_CODE25INDUSTRIAL  : PrintBarCode(pString, btCode_2_5_industrial);
    DIO_BARCODE_CODE25MATRIX      : PrintBarCode(pString, btCode_2_5_matrix);
    DIO_BARCODE_CODE39EXTENDED    : PrintBarCode(pString, btCode39Extended);
    DIO_BARCODE_CODE93            : PrintBarCode(pString, btCode93);
    DIO_BARCODE_CODE93EXTENDED    : PrintBarCode(pString, btCode93Extended);
    DIO_BARCODE_MSI               : PrintBarCode(pString, btCodeMSI);
    DIO_BARCODE_POSTNET           : PrintBarCode(pString, btCodePostNet);
    DIO_BARCODE_CODABAR           : PrintBarCode(pString, btCodeCodabar);
    DIO_BARCODE_EAN8              : PrintBarCode(pString, btCodeEAN8);
    DIO_BARCODE_EAN13             : PrintBarCode(pString, btCodeEAN13);
    DIO_BARCODE_UPC_A             : PrintBarCode(pString, btCodeUPC_A);
    DIO_BARCODE_UPC_E0            : PrintBarCode(pString, btCodeUPC_E0);
    DIO_BARCODE_UPC_E1            : PrintBarCode(pString, btCodeUPC_E1);
    DIO_BARCODE_UPC_S2            : PrintBarCode(pString, btCodeUPC_Supp2);
    DIO_BARCODE_UPC_S5            : PrintBarCode(pString, btCodeUPC_Supp5);
    DIO_BARCODE_EAN128A           : PrintBarCode(pString, btCodeEAN128A);
    DIO_BARCODE_EAN128B           : PrintBarCode(pString, btCodeEAN128B);
    DIO_BARCODE_EAN128C           : PrintBarCode(pString, btCodeEAN128C);
  else
    RaiseOposException(OPOS_E_ILLEGAL, 'Barcode type is not supported');
  end;
end;

{ TDIOStrCommand }

constructor TDIOStrCommand.CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
  ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FCommands := ACommands;
  FPrinter := APrinter;
end;

procedure TDIOStrCommand.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Param: TCommandParam;
  Stream: TBinStream;
  Command: TCommandDef;
  ResultCode: Integer;
  FieldNumber: Integer;
  TableNumber: Integer;
  FieldInfo: TPrinterFieldRec;
begin
  Command := FCommands.ItemByCode(pData);
  if Command = nil then
    raiseException('Invalid command code');

  Stream := TBinStream.Create;
  try
    Command.InParams.AsText := pString;
    { Read table }
    if Command.Code = $1F then
    begin
      Param := Command.InParams.ItemByType(PARAM_TYPE_TABLE);
      if Param <> nil then
      begin
        TableNumber := StrToInt(Param.Value);
        Param := Command.InParams.ItemByType(PARAM_TYPE_FIELD);
        if Param <> nil then
        begin
          FieldNumber := StrToInt(Param.Value);
          FieldInfo := Device.ReadFieldStructure(TableNumber, FieldNumber);
          Param := Command.OutParams.ItemByType(PARAM_TYPE_FVALUE);
          if Param <> nil then
          begin
            Param.Size := FieldInfo.Size;
          end;
        end;
      end;
    end;
    { Write table }
    if Command.Code = $1E then
    begin
      Param := Command.InParams.ItemByType(PARAM_TYPE_TABLE);
      if Param <> nil then
      begin
        TableNumber := StrToInt(Param.Value);
        Param := Command.InParams.ItemByType(PARAM_TYPE_FIELD);
        if Param <> nil then
        begin
          FieldNumber := StrToInt(Param.Value);
          FieldInfo := Device.ReadFieldStructure(TableNumber, FieldNumber);
          Param := Command.InParams.ItemByType(PARAM_TYPE_FVALUE);
          if Param <> nil then
          begin
            Param.Size := FieldInfo.Size;
            Param.Value := Device.GetFieldValue(FieldInfo, Param.Value);
          end;
        end;
      end;
    end;

    Stream.WriteByte(Command.Code);
    Command.InParams.Write(Stream);
    Command.OutParams.ClearValue;

    ResultCode := Device.ExecuteStream2(Stream);
    if ResultCode = 0 then
    begin
      Stream.Position := 0;
      Command.OutParams.Read(Stream);
      { Read table }
      if Command.Code = $1F then
      begin
        Param := Command.OutParams.ItemByType(PARAM_TYPE_FVALUE);
        if Param <> nil then
        begin
          Param.Value := Device.BinToFieldValue(FieldInfo, Param.Value);
        end;
      end;
      pString := Command.OutParams.AsText;
    end else
    begin
      pString := Format('%d;%s', [ResultCode, GetErrorText(ResultCode)]);
    end;
  finally
    Stream.Free;
  end;
end;

function TDIOStrCommand.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

{ TDIOPrintText }

constructor TDIOPrintText.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOPrintText.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

procedure TDIOPrintText.DirectIO(var pData: Integer;
  var pString: WideString);
var
  FontNumber: Integer;
begin
  FontNumber := pData;
  Device.PrintText(pString, Printer.Printer.Station, FontNumber);
end;

{ TDIOWriteTaxName }

constructor TDIOWriteTaxName.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOWriteTaxName.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

procedure TDIOWriteTaxName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Device.WriteTable(PRINTER_TABLE_TAX, pData, 2, pString);
end;

{ TDIOReadTaxName }

constructor TDIOReadTaxName.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOReadTaxName.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

procedure TDIOReadTaxName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Device.ReadTableStr(PRINTER_TABLE_TAX, pData, 2);
end;

{ TDIOReadPaymentName }

constructor TDIOReadPaymentName.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadPaymentName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Printer.Printer.Device.ReadTableStr(PRINTER_TABLE_PAYTYPE, pData, 1);
end;

{ TDIOWritePaymentName }

constructor TDIOWritePaymentName.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWritePaymentName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Printer.Device.WriteTable(PRINTER_TABLE_PAYTYPE, pData, 1, pString);
end;

{ TDIOWritePaymentName2 }

constructor TDIOWritePaymentName2.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWritePaymentName2.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Printer.Device.WriteTable(PRINTER_TABLE_PAYTYPE, pData+1, 1, pString);
end;

{ TDIOReadTable }

constructor TDIOReadTable.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadTable.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Table: Integer;
  Field: Integer;
  Row: Integer;
begin
  Table := GetInteger(pString, 1, ValueDelimiters);
  Row := GetInteger(pString, 2, ValueDelimiters);
  Field := GetInteger(pString, 3, ValueDelimiters);
  pString := Printer.Printer.Device.ReadTableStr(Table, Row, Field);
end;

{ TDIOWriteTable }

constructor TDIOWriteTable.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWriteTable.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Table: Integer;
  Field: Integer;
  Row: Integer;
  FieldValue: string;
begin
  Table := GetInteger(pString, 1, ValueDelimiters);
  Row := GetInteger(pString, 2, ValueDelimiters);
  Field := GetInteger(pString, 3, ValueDelimiters);
  FieldValue := GetString(pString, 4, ValueDelimiters);
  Printer.Printer.Device.WriteTable(Table, Row, Field, FieldValue);
end;

{ TDIOGetDepartment }

constructor TDIOGetDepartment.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetDepartment.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.Parameters.Department;
end;

{ TDIOSetDepartment }

constructor TDIOSetDepartment.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSetDepartment.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Parameters.Department := pData;
end;

{ TDIOReadCashRegister }

constructor TDIOReadCashRegister.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadCashRegister.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := IntTostr(Printer.Printer.Device.ReadCashRegister(pData));
end;

{ TDIOReadOperatingRegister }

constructor TDIOReadOperatingRegister.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadOperatingRegister.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := IntTostr(Printer.Printer.Device.ReadOperatingRegister(pData));
end;

constructor TDIOPrintRecRefund.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintRecRefund.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Description: WideString;
  Amount: Currency;
  Quantity: Int64;
  VatInfo: Integer;
begin
  Amount := StrToCurr(GetString(pString, 1, ValueDelimiters));
  Quantity := StrToInt(GetString(pString, 2, ValueDelimiters));
  VatInfo := StrToInt(GetString(pString, 3, ValueDelimiters));
  Description := GetString(pString, 4, ValueDelimiters);
  Printer.PrintRecItemRefund(Description, Amount, Quantity,
    VatInfo, 0, '');
end;

{ TDIOPrintJournal }

constructor TDIOPrintJournal.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintJournal.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.PrintJournal(pData);
  Printer.Printer.WaitForPrinting;
end;

{ TDIOReadDayNumber }

constructor TDIOReadDayNumber.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadDayNumber.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.Device.GetLongStatus.DayNumber;
end;

{ TDIOWaitForPrint }

constructor TDIOWaitForPrint.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWaitForPrint.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Printer.WaitForPrinting;
end;

{ TDIOPrintHeader }

constructor TDIOPrintHeader.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintHeader.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintHeader;
end;

{ TDIOPrintTrailer }

constructor TDIOPrintTrailer.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintTrailer.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintHeader;
end;

{ TDIOZReport }

constructor TDIOZReport.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOZReport.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.SaveZReportFile;
end;

{ TDIOZReportXML }

constructor TDIOZReportXML.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOZReportXML.DirectIO(var pData: Integer;
  var pString: WideString);
var
  FileName: string;
  ZReport: TZReport;
begin
  FileName := pString;
  ZReport := TZReport.Create(Printer.Device);
  try
    ZReport.Read;
    ZReport.SaveToXml(FileName);
  except
    on E: Exception do
    begin
      Logger.Error(GetExceptionMessage(E));
    end;
  end;
  ZReport.Free;
end;

{ TDIOZReportCSV }

constructor TDIOZReportCSV.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOZReportCSV.DirectIO(var pData: Integer;
  var pString: WideString);
var
  FileName: string;
  ZReport: TZReport;
begin
  FileName := pString;
  ZReport := TZReport.Create(Printer.Device);
  try
    ZReport.Read;
    ZReport.SaveToCSV(FileName);
  except
    on E: Exception do
    begin
      Logger.Error(GetExceptionMessage(E));
    end;
  end;
  ZReport.Free;
end;

{ TDIOGetLastError }

constructor TDIOGetLastError.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetLastError.DirectIO(
  var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.OposDevice.LastErrorCode;
  pString := Printer.OposDevice.LastErrorText;
end;

{ TDIOGetPrinterStation }

constructor TDIOGetPrinterStation.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetPrinterStation.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := FPrinter.Printer.Station;
end;

{ TDIOSetPrinterStation }

constructor TDIOSetPrinterStation.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSetPrinterStation.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Printer.Station := pData;
end;

{ TDIOGetDriverParameter }

constructor TDIOGetDriverParameter.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetDriverParameter.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TPrinterParameters;
begin
  P := FPrinter.Parameters;
  case pData of
    DriverParameterStorage: pString := IntToStr(P.Storage);
    DriverParameterBaudRate: pString := IntToStr(P.BaudRate);
    DriverParameterPortNumber: pString := IntToStr(P.PortNumber);
    DriverParameterFontNumber: pString := IntToStr(P.FontNumber);
    DriverParameterSysPassword: pString := IntToStr(P.SysPassword);
    DriverParameterUsrPassword: pString := IntToStr(P.UsrPassword);
    DriverParameterByteTimeout: pString := IntToStr(P.ByteTimeout);
    DriverParameterStatusInterval: pString := IntToStr(P.StatusInterval);
    DriverParameterSubtotalText: pString := P.SubtotalText;
    DriverParameterCloseRecText: pString := P.CloseRecText;
    DriverParameterVoidRecText: pString := P.VoidRecText;
    DriverParameterPollInterval: pString := IntToStr(P.PollInterval);
    DriverParameterMaxRetryCount: pString := IntToStr(P.MaxRetryCount);
    DriverParameterDeviceByteTimeout: pString := IntToStr(P.DeviceByteTimeout);
    DriverParameterSearchByPortEnabled: pString := BoolToStr(P.SearchByPortEnabled);
    DriverParameterSearchByBaudRateEnabled: pString := BoolToStr(P.SearchByBaudRateEnabled);
    DriverParameterMonitoringEnabled: pString := BoolToStr(P.MonitoringEnabled);
    DriverParameterCutType: pString := IntToStr(P.CutType);
    DriverParameterLogMaxCount: pString := IntToStr(P.LogMaxCount);
    DriverParameterEncoding: pString := IntToStr(P.Encoding);
    DriverParameterRemoteHost: pString := P.RemoteHost;
    DriverParameterRemotePort: pString := IntToStr(P.RemotePort);
    DriverParameterHeaderType: pString := IntToStr(P.HeaderType);
    DriverParameterHeaderFont: pString := IntToStr(P.HeaderFont);
    DriverParameterTrailerFont: pString := IntToStr(P.TrailerFont);
    DriverParameterTrainModeText: pString := P.TrainModeText;
    DriverParameterLogoPosition: pString := IntToStr(P.LogoPosition);
    DriverParameterTrainSaleText: pString := P.TrainSaleText;
    DriverParameterTrainPay2Text: pString := P.TrainPay2Text;
    DriverParameterTrainPay3Text: pString := P.TrainPay3Text;
    DriverParameterTrainPay4Text: pString := P.TrainPay4Text;
    DriverParameterStatusCommand: pString := IntToStr(P.StatusCommand);
    DriverParameterTrainTotalText: pString := P.TrainTotalText;
    DriverParameterConnectionType: pString := IntToStr(P.ConnectionType);
    DriverParameterLogFileEnabled: pString := BoolToStr(P.LogFileEnabled);
    DriverParameterNumHeaderLines: pString := IntToStr(P.NumHeaderLines);
    DriverParameterTrainChangeText: pString := P.TrainChangeText;
    DriverParameterTrainStornoText: pString := P.TrainStornoText;
    DriverParameterTrainCashInText: pString := P.TrainCashInText;
    DriverParameterNumTrailerLines: pString := IntToStr(P.NumTrailerLines);
    DriverParameterTrainCashOutText: pString := P.TrainCashOutText;
    DriverParameterTrainVoidRecText: pString := P.TrainVoidRecText;
    DriverParameterTrainCashPayText: pString := P.TrainCashPayText;
    DriverParameterBarcodePrintDelay: pString := IntToStr(P.BarcodePrintDelay);
    DriverParameterCompatLevel: pString := IntToStr(P.CompatLevel);
    DriverParameterHeader: pString := P.Header;
    DriverParameterTrailer: pString := P.Trailer;
    DriverParameterLogoSize: pString := IntToStr(P.LogoSize);
    DriverParameterLogoCenter: pString := BoolToStr(P.LogoCenter);
    DriverParameterDepartment: pString := IntToStr(P.Department);
    DriverParameterLogoEnabled: pString := BoolToStr(P.LogoEnabled);
    DriverParameterHeaderPrinted: pString := BoolToStr(P.HeaderPrinted);
    DriverParameterReceiptType: pString := IntToStr(P.ReceiptType);
    DriverParameterZeroReceiptType: pString := IntToStr(P.ZeroReceiptType);
    DriverParameterZeroReceiptNumber: pString := IntToStr(P.ZeroReceiptNumber);
    DriverParameterCCOType: pString := IntToStr(P.CCOType);
    DriverParameterTableEditEnabled: pString := BoolToStr(P.TableEditEnabled);
    DriverParameterXmlZReportEnabled: pString := BoolToStr(P.XmlZReportEnabled);
    DriverParameterCsvZReportEnabled: pString := BoolToStr(P.CsvZReportEnabled);
    DriverParameterXmlZReportFileName: pString := P.XmlZReportFileName;
    DriverParameterCsvZReportFileName: pString := P.CsvZReportFileName;
    DriverParameterVoidReceiptOnMaxItems: pString := BoolToStr(P.VoidReceiptOnMaxItems);
    DriverParameterMaxReceiptItems: pString := IntToStr(P.MaxReceiptItems);
    DriverParameterJournalPrintHeader: pString := BoolToStr(P.JournalPrintHeader);
    DriverParameterJournalPrintTrailer: pString := BoolToStr(P.JournalPrintTrailer);
    DriverParameterCacheReceiptNumber: pString := BoolToStr(P.CacheReceiptNumber);
    DriverParameterBarcodeByteMode: pString := IntToStr(P.BarcodeByteMode);
  end;
end;

{ TDIOSetDriverParameter }

constructor TDIOSetDriverParameter.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSetDriverParameter.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TPrinterParameters;
begin
  P := FPrinter.Parameters;
  case pData of
    DriverParameterStorage: P.Storage := StrToInt(pString);
    DriverParameterBaudRate: P.BaudRate := StrToInt(pString);
    DriverParameterPortNumber: P.PortNumber := StrToInt(pString);
    DriverParameterFontNumber: P.FontNumber := StrToInt(pString);
    DriverParameterSysPassword: P.SysPassword := StrToInt(pString);
    DriverParameterUsrPassword: P.UsrPassword := StrToInt(pString);
    DriverParameterByteTimeout: P.ByteTimeout := StrToInt(pString);
    DriverParameterStatusInterval: P.StatusInterval := StrToInt(pString);
    DriverParameterSubtotalText: P.SubtotalText := pString;
    DriverParameterCloseRecText: P.CloseRecText := pString;
    DriverParameterVoidRecText: P.VoidRecText := pString;
    DriverParameterPollInterval: P.PollInterval := StrToINt(pString);
    DriverParameterMaxRetryCount: P.MaxRetryCount := StrToInt(pString);
    DriverParameterDeviceByteTimeout: P.DeviceByteTimeout := StrToInt(pString);
    DriverParameterSearchByPortEnabled: P.SearchByPortEnabled := StrToBool(pString);
    DriverParameterSearchByBaudRateEnabled: P.SearchByBaudRateEnabled := StrToBool(pString);
    DriverParameterMonitoringEnabled: P.MonitoringEnabled := StrToBool(pString);
    DriverParameterCutType: P.CutType := StrToInt(pString);
    DriverParameterLogMaxCount: P.LogMaxCount := StrToInt(pString);
    DriverParameterEncoding: P.Encoding := StrToInt(pString);
    DriverParameterRemoteHost: P.RemoteHost := pString;
    DriverParameterRemotePort: P.RemotePort := StrToInt(pString);
    DriverParameterHeaderType: P.HeaderType := StrToInt(pString);
    DriverParameterHeaderFont: P.HeaderFont := StrToInt(pString);
    DriverParameterTrailerFont: P.TrailerFont := StrToInt(pString);
    DriverParameterTrainModeText: P.TrainModeText := pString;
    DriverParameterLogoPosition: P.LogoPosition := StrToInt(pString);
    DriverParameterTrainSaleText: P.TrainSaleText := pString;
    DriverParameterTrainPay2Text: P.TrainPay2Text := pString;
    DriverParameterTrainPay3Text: P.TrainPay3Text := pString;
    DriverParameterTrainPay4Text: P.TrainPay4Text := pString;
    DriverParameterStatusCommand: P.StatusCommand := StrToInt(pString);
    DriverParameterTrainTotalText: P.TrainTotalText := pString;
    DriverParameterConnectionType: P.ConnectionType := StrToInt(pString);
    DriverParameterLogFileEnabled: P.LogFileEnabled := StrToBool(pString);
    DriverParameterNumHeaderLines: P.NumHeaderLines := StrToInt(pString);
    DriverParameterTrainChangeText: P.TrainChangeText := pString;
    DriverParameterTrainStornoText: P.TrainStornoText := pString;
    DriverParameterTrainCashInText: P.TrainCashInText := pString;
    DriverParameterNumTrailerLines: P.NumTrailerLines := StrToInt(pString);
    DriverParameterTrainCashOutText: P.TrainCashOutText := pString;
    DriverParameterTrainVoidRecText: P.TrainVoidRecText := pString;
    DriverParameterTrainCashPayText: P.TrainCashPayText := pString;
    DriverParameterBarcodePrintDelay: P.BarcodePrintDelay := StrToInt(pString);
    DriverParameterCompatLevel: P.CompatLevel := StrToInt(pString);
    DriverParameterHeader: P.Header := pString;
    DriverParameterTrailer: P.Trailer := pString;
    DriverParameterLogoSize: P.LogoSize := StrToInt(pString);
    DriverParameterLogoCenter: P.LogoCenter := StrToBool(pString);
    DriverParameterDepartment: P.Department := StrToInt(pString);
    DriverParameterLogoEnabled: P.LogoEnabled := StrToBool(pString);
    DriverParameterHeaderPrinted: P.HeaderPrinted := StrToBool(pString);
    DriverParameterReceiptType: P.ReceiptType := StrToInt(pString);
    DriverParameterZeroReceiptType: P.ZeroReceiptType := StrToInt(pString);
    DriverParameterZeroReceiptNumber: P.ZeroReceiptNumber := StrToInt(pString);
    DriverParameterCCOType: P.CCOType := StrToInt(pString);

    DriverParameterTableEditEnabled: P.TableEditEnabled := StrToBool(pString);
    DriverParameterXmlZReportEnabled: P.XmlZReportEnabled := StrToBool(pString);
    DriverParameterCsvZReportEnabled: P.CsvZReportEnabled := StrToBool(pString);
    DriverParameterXmlZReportFileName: P.XmlZReportFileName := pString;
    DriverParameterCsvZReportFileName: P.CsvZReportFileName := pString;
    DriverParameterVoidReceiptOnMaxItems: P.VoidReceiptOnMaxItems := StrToBool(pString);
    DriverParameterMaxReceiptItems: P.VoidReceiptOnMaxItems := StrToBool(pString);
    DriverParameterJournalPrintHeader: P.JournalPrintHeader := StrToBool(pString);
    DriverParameterJournalPrintTrailer: P.JournalPrintTrailer := StrToBool(pString);
    DriverParameterCacheReceiptNumber: P.CacheReceiptNumber := StrToBool(pString);
    DriverParameterBarcodeByteMode: P.BarcodeByteMode := StrToInt(pString);
  end;
end;

end.
