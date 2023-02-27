unit DIOHandlers;

interface

uses
  // VCL
  Classes, SysUtils, Graphics, Extctrls,
  // 3'd
  TntSysUtils, TntClasses,
  // This
  DIOHandler, DirectIOAPI, PrinterCommand, ShtrihFiscalPrinter,
  FiscalPrinterDevice, CommandDef, CommandParam, XmlParser, BinStream,
  OposException, PrinterTypes, Opos, StringUtils, FiscalPrinterImpl,
  fmuLogo, FiscalPrinterTypes, ZReport, LogFile, PrinterParameters,
  OposUtils, OposFptrUtils, WException, gnugettext;

const
  ValueDelimiters = [';'];

type
  { TDIOHandler2 }

  TDIOHandler2 = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
    function GetParameters: TPrinterParameters;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
    property Parameters: TPrinterParameters read GetParameters;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
  end;

  { TDIOCommandDef }

  TDIOCommandDef = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOHexCommand }

  TDIOHexCommand = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOCheckEndDay }

  TDIOCheckEndDay = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOLoadLogo }

  TDIOLoadLogo = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintLogo }

  TDIOPrintLogo = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOClearLogo }

  TDIOClearLogo = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOLogoDlg }

  TDIOLogoDlg = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOBarcode }

  TDIOBarcode = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOBarcodeHex }

  TDIOBarcodeHex = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOBarcodeHex2 }

  TDIOBarcodeHex2 = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStrCommand }

  TDIOStrCommand = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStrCommand2 }

  TDIOStrCommand2 = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintText }

  TDIOPrintText = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTaxName }

  TDIOWriteTaxName = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadTaxName }

  TDIOReadTaxName = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWritePaymentName }

  TDIOWritePaymentName = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWritePaymentName2 }

  TDIOWritePaymentName2 = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadPaymentName }

  TDIOReadPaymentName = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTable }

  TDIOWriteTable = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadTable }

  TDIOReadTable = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetDepartment }

  TDIOGetDepartment = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetDepartment }

  TDIOSetDepartment = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadCashRegister }

  TDIOReadCashRegister = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadOperatingRegister }

  TDIOReadOperatingRegister = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintRecRefund }

  TDIOPrintRecRefund = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintJournal }

  TDIOPrintJournal = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadDayNumber }

  TDIOReadDayNumber = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWaitForPrint }

  TDIOWaitForPrint = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintHeader }

  TDIOPrintHeader = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintTrailer }

  TDIOPrintTrailer = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReport }

  TDIOZReport = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReportXML }

  TDIOZReportXML = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReportCSV }

  TDIOZReportCSV = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetLastError }

  TDIOGetLastError = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetPrinterStation }

  TDIOGetPrinterStation = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetPrinterStation }

  TDIOSetPrinterStation = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetDriverParameter }

  TDIOGetDriverParameter = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetDriverParameter }

  TDIOSetDriverParameter = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintSeparator }

  TDIOPrintSeparator = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadEJActivation }

  TDIOReadEJActivation = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadFMTotals }

  TDIOReadFMTotals = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadGrandTotals }

  TDIOReadGrandTotals = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintImage }

  TDIOPrintImage = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintImageScale }

  TDIOPrintImageScale = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadFSParameter }

  TDIOReadFSParameter = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadFPParameter }

  TDIOReadFPParameter = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteFPParameter }

  TDIOWriteFPParameter = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteCustomerAddress }

  TDIOWriteCustomerAddress = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTlvData }

  TDIOWriteTlvData = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTlvHex }

  TDIOWriteTlvHex = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTlvOperation }

  TDIOWriteTlvOperation = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteStringTag }

  TDIOWriteStringTag = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetAdjustmentAmount }

  TDIOSetAdjustmentAmount = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIODisableNextHeader }

  TDIODisableNextHeader = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTableFile }

  TDIOWriteTableFile = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSReadDocument }

  TDIOFSReadDocument = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSPrintCalcReport }

  TDIOFSPrintCalcReport = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOOpenCashDrawer }

  TDIOOpenCashDrawer = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadCashDrawerState }

  TDIOReadCashDrawerState = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSFiscalize }

  TDIOFSFiscalize = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSReFiscalize }

  TDIOFSReFiscalize = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetPrintWidth }

  TDIOGetPrintWidth = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadFSDocument }

  TDIOReadFSDocument = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintFSDocument }

  TDIOPrintFSDocument = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintCorrection }

  TDIOPrintCorrection = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintCorrection2 }

  TDIOPrintCorrection2 = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStartOpenDay }

  TDIOStartOpenDay = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOOpenDay }

  TDIOOpenDay = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOCheckItemCode }

  TDIOCheckItemCode = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOCheckItemCode2 }

  TDIOCheckItemCode2 = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStartCorrection }

  TDIOStartCorrection = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteStringTagOp }

  TDIOWriteStringTagOp = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSTLVBegin }

  TDIOSTLVBegin = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSTLVAddTag }

  TDIOSTLVAddTag = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSTLVWrite }

  TDIOSTLVWrite = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSTLVWriteOp }

  TDIOSTLVWriteOp = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSTLVGetHex }

  TDIOSTLVGetHex = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetReceiptField }

  TDIOSetReceiptField = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOAddItemCode }

  TDIOAddItemCode = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

 { TDIOFSSyncRegisters }

  TDIOFSSyncRegisters = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

 { TDIOFSReadMemStatus }

  TDIOFSReadMemStatus = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSWriteTLVBuffer }

  TDIOFSWriteTLVBuffer = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSGenerateRandomData }

  TDIOFSGenerateRandomData = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSAuthorize }

  TDIOFSAuthorize = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSReadTicketStatus }

  TDIOFSReadTicketStatus = class(TDIOHandler2)
  public
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

implementation

function BoolToStr(Value: Boolean): WideString;
begin
  if Value then Result := '1'
  else Result := '0';
end;

function StrToBool(const Value: WideString): Boolean;
begin
  Result := Value <> '0';
end;

{ TDIOHandler2 }

constructor TDIOHandler2.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOHandler2.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

function TDIOHandler2.GetParameters: TPrinterParameters;
begin
  Result := Printer.Parameters;
end;

{ TDIOCommandDef }

procedure TDIOCommandDef.DirectIO(var pData: Integer; var pString: WideString);
var
  Param: TCommandParam;
  Stream: TBinStream;
  Command: TCommandDef;
  ResultCode: Integer;
begin
  Printer.CheckEnabled;

  Command := Printer.CommandDefs.ItemByCode(pData);
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
        Device.GetErrorText(ResultCode));
    end;
    pString := Command.OutParams.AsXml;
  finally
    Stream.Free;
  end;
end;

{ TDIOHexCommand }

procedure TDIOHexCommand.DirectIO(var pData: Integer; var pString: WideString);
var
  TxData: AnsiString;
  RxData: AnsiString;
begin
  Printer.CheckEnabled;
  TxData := HexToStr(pString);
  Device.Check(Device.ExecuteData(TxData, RxData));
  pString := StrToHex(RxData);
end;

{ TDIOCheckEndDay }

procedure TDIOCheckEndDay.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.CheckEnabled;
  if Printer.Device.ReadPrinterStatus.Mode = ECRMODE_24OVER then pData := 1
  else pData := 0;
end;

{ TDIOLoadLogo }

procedure TDIOLoadLogo.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  try
    Printer.LoadLogo(pString);
  except
    on E: Exception do
    begin
      Logger.Error(GetExceptionMessage(E));
      raiseException(_('Íå óäàëîñü çàãðóçèòü ëîãîòèï'));
    end;
  end;
end;

{ TDIOPrintLogo }

procedure TDIOPrintLogo.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintLogo;
end;

{ TDIOLogoDlg }

procedure TDIOLogoDlg.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  ShowLogoDialog(Printer);
end;

{ TDIOBarcode }

procedure TDIOBarcode.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Barcode: TBarcodeRec;
  Parameters: TPrinterParameters;
begin
  if Pos(';', pString) = 0 then
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := pString;
    Barcode.Text := pString;

    Parameters := Printer.Device.Parameters;
    Barcode.Height := Parameters.BarcodeHeight;
    Barcode.ModuleWidth := Parameters.BarcodeModuleWidth;
    Barcode.Alignment := Parameters.BarcodeAlignment;
    Barcode.Parameter1 := Parameters.BarcodeParameter1;
    Barcode.Parameter2 := Parameters.BarcodeParameter2;
    Barcode.Parameter3 := Parameters.BarcodeParameter3;
    Barcode.Parameter4 := Parameters.BarcodeParameter4;
    Barcode.Parameter5 := Parameters.BarcodeParameter5;
  end else
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := GetString(pString, 1, ValueDelimiters);
    Barcode.Text := GetString(pString, 2, ValueDelimiters);
    Barcode.Height := GetInteger(pString, 3, ValueDelimiters);
    Barcode.ModuleWidth := GetInteger(pString, 4, ValueDelimiters);
    Barcode.Alignment := GetInteger(pString, 5, ValueDelimiters);
    Barcode.Parameter1 := GetInteger(pString, 6, ValueDelimiters);
    Barcode.Parameter2 := GetInteger(pString, 7, ValueDelimiters);
    Barcode.Parameter3 := GetInteger(pString, 8, ValueDelimiters);
    Barcode.Parameter4 := GetInteger(pString, 9, ValueDelimiters);
    Barcode.Parameter5 := GetInteger(pString, 10, ValueDelimiters);
  end;
  Printer.PrintBarcode(Barcode);
end;

{ TDIOBarcodeHex }

procedure TDIOBarcodeHex.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Barcode: TBarcodeRec;
  Parameters: TPrinterParameters;
begin
  if Pos(';', pString) = 0 then
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := HexToStr(pString);
    Barcode.Text := pString;

    Parameters := Printer.Device.Parameters;
    Barcode.Height := Parameters.BarcodeHeight;
    Barcode.ModuleWidth := Parameters.BarcodeModuleWidth;
    Barcode.Alignment := Parameters.BarcodeAlignment;
    Barcode.Parameter1 := Parameters.BarcodeParameter1;
    Barcode.Parameter2 := Parameters.BarcodeParameter2;
    Barcode.Parameter3 := Parameters.BarcodeParameter3;
  end else
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := HexToStr(GetString(pString, 1, ValueDelimiters));
    Barcode.Text := GetString(pString, 2, ValueDelimiters);
    Barcode.Height := GetInteger(pString, 3, ValueDelimiters);
    Barcode.ModuleWidth := GetInteger(pString, 4, ValueDelimiters);
    Barcode.Alignment := GetInteger(pString, 5, ValueDelimiters);
    Barcode.Parameter1 := GetInteger(pString, 6, ValueDelimiters);
    Barcode.Parameter2 := GetInteger(pString, 7, ValueDelimiters);
    Barcode.Parameter3 := GetInteger(pString, 8, ValueDelimiters);
  end;
  Printer.PrintBarcode(Barcode);
end;

{ TDIOBarcodeHex2 }

procedure TDIOBarcodeHex2.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Barcode: TBarcodeRec;
  Parameters: TPrinterParameters;
begin
  if Pos(';', pString) = 0 then
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := HexToStr(pString);
    Barcode.Text := pString;

    Parameters := Printer.Device.Parameters;
    Barcode.Height := Parameters.BarcodeHeight;
    Barcode.ModuleWidth := Parameters.BarcodeModuleWidth;
    Barcode.Alignment := Parameters.BarcodeAlignment;
    Barcode.Parameter1 := Parameters.BarcodeParameter1;
    Barcode.Parameter2 := Parameters.BarcodeParameter2;
    Barcode.Parameter3 := Parameters.BarcodeParameter3;
    Barcode.Parameter4 := Parameters.BarcodeParameter4;
    Barcode.Parameter5 := Parameters.BarcodeParameter5;
  end else
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := HexToStr(GetString(pString, 1, ValueDelimiters));
    Barcode.Text := HexToStr(GetString(pString, 2, ValueDelimiters));
    Barcode.Height := GetInteger(pString, 3, ValueDelimiters);
    Barcode.ModuleWidth := GetInteger(pString, 4, ValueDelimiters);
    Barcode.Alignment := GetInteger(pString, 5, ValueDelimiters);
    Barcode.Parameter1 := GetInteger(pString, 6, ValueDelimiters);
    Barcode.Parameter2 := GetInteger(pString, 7, ValueDelimiters);
    Barcode.Parameter3 := GetInteger(pString, 8, ValueDelimiters);
    Barcode.Parameter4 := GetInteger(pString, 9, ValueDelimiters);
    Barcode.Parameter5 := GetInteger(pString, 10, ValueDelimiters);
  end;
  Printer.PrintBarcode(Barcode);
end;

{ TDIOStrCommand }

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
  Command := Printer.CommandDefs.ItemByCode(pData);
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

    if Command.Code < $FF then
    begin
      Stream.WriteByte(Command.Code);
    end else
    begin
      Stream.WriteWord(Command.Code);
    end;
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
      pString := Tnt_WideFormat('%d;%s', [ResultCode, Device.GetErrorText(ResultCode)]);
    end;
  finally
    Stream.Free;
  end;
end;

{ TDIOStrCommand2 }

procedure TDIOStrCommand2.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Stream: TBinStream;
  Command: TCommandDef;
begin
  Command := Printer.CommandDefs.ItemByCode(pData);
  Stream := TBinStream.Create;
  try
    Command.InParams.AsText := pString;
    if Command.Code < $FF then
    begin
      Stream.WriteByte(Command.Code);
    end else
    begin
      Stream.WriteWord(Command.Code);
    end;
    Command.InParams.Write(Stream);
    Command.OutParams.ClearValue;
    Device.Check(Device.ExecuteStream2(Stream));
    Stream.Position := 0;
    Command.OutParams.Read(Stream);
    pString := Command.OutParams.GetText(1);
  finally
    Stream.Free;
  end;
end;

{ TDIOPrintText }

procedure TDIOPrintText.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Data: TTextRec;
begin
  Data.Text := pString;
  Data.Station := Printer.Printer.Station;
  Data.Font := pData;
  Data.Alignment := taLeft;
  Data.Wrap := Printer.Parameters.WrapText;
  Printer.PrintText(Data);
end;

{ TDIOWriteTaxName }

procedure TDIOWriteTaxName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Device.WriteTable(PRINTER_TABLE_TAX, pData, 2, pString);
end;

{ TDIOReadTaxName }

procedure TDIOReadTaxName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Device.ReadTableStr(PRINTER_TABLE_TAX, pData, 2);
end;

{ TDIOReadPaymentName }

procedure TDIOReadPaymentName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Device.ReadTableStr(PRINTER_TABLE_PAYTYPE, pData, 1);
end;

{ TDIOWritePaymentName }

procedure TDIOWritePaymentName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  if Printer.Parameters.WritePaymentNameEnabled then
  begin
    Printer.Printer.Device.WriteTable(PRINTER_TABLE_PAYTYPE, pData, 1, pString);
  end;
end;

{ TDIOWritePaymentName2 }

procedure TDIOWritePaymentName2.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  if Printer.Parameters.WritePaymentNameEnabled then
  begin
    Printer.Printer.Device.WriteTable(PRINTER_TABLE_PAYTYPE, pData, 1, pString);
  end;
end;

{ TDIOReadTable }

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

procedure TDIOWriteTable.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Table: Integer;
  Field: Integer;
  Row: Integer;
  FieldValue: WideString;
begin
  Table := GetInteger(pString, 1, ValueDelimiters);
  Row := GetInteger(pString, 2, ValueDelimiters);
  Field := GetInteger(pString, 3, ValueDelimiters);
  FieldValue := GetString(pString, 4, ValueDelimiters);
  Printer.Printer.Device.WriteTable(Table, Row, Field, FieldValue);
end;

{ TDIOGetDepartment }

procedure TDIOGetDepartment.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.Parameters.Department;
end;

{ TDIOSetDepartment }

procedure TDIOSetDepartment.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Parameters.Department := pData;
end;

{ TDIOReadCashRegister }

procedure TDIOReadCashRegister.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := IntTostr(Printer.Printer.Device.ReadCashReg2(pData));
end;

{ TDIOReadOperatingRegister }

procedure TDIOReadOperatingRegister.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := IntTostr(Printer.Printer.Device.ReadOperatingRegister(pData));
end;

{ TDIOPrintRecRefund }

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

procedure TDIOPrintJournal.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.PrintJournal(pData);
  Printer.Device.WaitForPrinting;
end;

{ TDIOReadDayNumber }

procedure TDIOReadDayNumber.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.Device.ReadLongStatus.DayNumber;
end;

{ TDIOWaitForPrint }

procedure TDIOWaitForPrint.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.WaitForPrinting;
end;

{ TDIOPrintHeader }

procedure TDIOPrintHeader.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintHeader;
end;

{ TDIOPrintTrailer }

procedure TDIOPrintTrailer.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintHeader;
end;

{ TDIOZReport }

procedure TDIOZReport.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.SaveZReportFile;
end;

{ TDIOZReportXML }

procedure TDIOZReportXML.DirectIO(var pData: Integer;
  var pString: WideString);
var
  FileName: WideString;
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

procedure TDIOZReportCSV.DirectIO(var pData: Integer;
  var pString: WideString);
var
  FileName: WideString;
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

procedure TDIOGetLastError.DirectIO(
  var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.LastErrorCode;
  pString := Printer.LastErrorText;
end;

{ TDIOGetPrinterStation }

procedure TDIOGetPrinterStation.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := FPrinter.Printer.Station;
end;

{ TDIOSetPrinterStation }

procedure TDIOSetPrinterStation.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Printer.Station := pData;
end;

{ TDIOGetDriverParameter }

procedure TDIOGetDriverParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  case pData of
    DriverParameterStorage: pString := IntToStr(Printer.Parameters.Storage);
    DriverParameterBaudRate: pString := IntToStr(Printer.Parameters.BaudRate);
    DriverParameterPortNumber: pString := IntToStr(Printer.Parameters.PortNumber);
    DriverParameterFontNumber: pString := IntToStr(Printer.Parameters.FontNumber);
    DriverParameterSysPassword: pString := IntToStr(Printer.Parameters.SysPassword);
    DriverParameterUsrPassword: pString := IntToStr(Printer.Parameters.UsrPassword);
    DriverParameterByteTimeout: pString := IntToStr(Printer.Parameters.ByteTimeout);
    DriverParameterStatusInterval: pString := IntToStr(Printer.Parameters.StatusInterval);
    DriverParameterSubtotalText: pString := Printer.Parameters.SubtotalText;
    DriverParameterCloseRecText: pString := Printer.Parameters.CloseRecText;
    DriverParameterVoidRecText: pString := Printer.Parameters.VoidRecText;
    DriverParameterPollInterval: pString := IntToStr(Printer.Parameters.PollIntervalInSeconds);
    DriverParameterMaxRetryCount: pString := IntToStr(Printer.Parameters.MaxRetryCount);
    DriverParameterDeviceByteTimeout: pString := IntToStr(Printer.Parameters.DeviceByteTimeout);
    DriverParameterSearchByPortEnabled: pString := BoolToStr(Printer.Parameters.SearchByPortEnabled);
    DriverParameterSearchByBaudRateEnabled: pString := BoolToStr(Printer.Parameters.SearchByBaudRateEnabled);
    DriverParameterPropertyUpdateMode: pString := IntToStr(Printer.Parameters.PropertyUpdateMode);
    DriverParameterCutType: pString := IntToStr(Printer.Parameters.CutType);
    DriverParameterLogMaxCount: pString := IntToStr(Printer.Parameters.LogMaxCount);
    DriverParameterEncoding: pString := IntToStr(Printer.Parameters.Encoding);
    DriverParameterRemoteHost: pString := Printer.Parameters.RemoteHost;
    DriverParameterRemotePort: pString := IntToStr(Printer.Parameters.RemotePort);
    DriverParameterHeaderType: pString := IntToStr(Printer.Parameters.HeaderType);
    DriverParameterHeaderFont: pString := IntToStr(Printer.Parameters.HeaderFont);
    DriverParameterTrailerFont: pString := IntToStr(Printer.Parameters.TrailerFont);
    DriverParameterTrainModeText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainModeText);
    DriverParameterLogoPosition: pString := IntToStr(Printer.Parameters.LogoPosition);
    DriverParameterTrainSaleText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainSaleText);
    DriverParameterTrainPay2Text: pString := Printer.Parameters.GetPrinterMessage(MsgTrainPay2Text);
    DriverParameterTrainPay3Text: pString := Printer.Parameters.GetPrinterMessage(MsgTrainPay3Text);
    DriverParameterTrainPay4Text: pString := Printer.Parameters.GetPrinterMessage(MsgTrainPay4Text);
    DriverParameterStatusCommand: pString := IntToStr(Printer.Parameters.StatusCommand);
    DriverParameterTrainTotalText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainTotalText);
    DriverParameterConnectionType: pString := IntToStr(Printer.Parameters.ConnectionType);
    DriverParameterLogFileEnabled: pString := BoolToStr(Printer.Parameters.LogFileEnabled);
    DriverParameterNumHeaderLines: pString := IntToStr(Printer.Parameters.NumHeaderLines);
    DriverParameterTrainChangeText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainChangeText);
    DriverParameterTrainStornoText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainStornoText);
    DriverParameterTrainCashInText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainCashInText);
    DriverParameterNumTrailerLines: pString := IntToStr(Printer.Parameters.NumTrailerLines);
    DriverParameterTrainCashOutText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainCashOutText);
    DriverParameterTrainVoidRecText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainVoidRecText);
    DriverParameterTrainCashPayText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainCashPayText);
    DriverParameterBarLinePrintDelay: pString := IntToStr(Printer.Parameters.BarLinePrintDelay);
    DriverParameterCompatLevel: pString := IntToStr(Printer.Parameters.CompatLevel);
    DriverParameterHeader: pString := Printer.Parameters.Header;
    DriverParameterTrailer: pString := Printer.Parameters.Trailer;
    DriverParameterLogoSize: pString := IntToStr(Printer.Parameters.LogoSize);
    DriverParameterLogoCenter: pString := BoolToStr(Printer.Parameters.LogoCenter);
    DriverParameterDepartment: pString := IntToStr(Printer.Parameters.Department);
    DriverParameterLogoEnabled: pString := BoolToStr(True);
    DriverParameterHeaderPrinted: pString := BoolToStr(Printer.Parameters.HeaderPrinted);
    DriverParameterReceiptType: pString := IntToStr(Printer.Parameters.ReceiptType);
    DriverParameterZeroReceiptType: pString := IntToStr(Printer.Parameters.ZeroReceiptType);
    DriverParameterZeroReceiptNumber: pString := IntToStr(Printer.Parameters.ZeroReceiptNumber);
    DriverParameterCCOType: pString := IntToStr(Printer.Parameters.CCOType);
    DriverParameterTableEditEnabled: pString := BoolToStr(Printer.Parameters.TableEditEnabled);
    DriverParameterXmlZReportEnabled: pString := BoolToStr(Printer.Parameters.XmlZReportEnabled);
    DriverParameterCsvZReportEnabled: pString := BoolToStr(Printer.Parameters.CsvZReportEnabled);
    DriverParameterXmlZReportFileName: pString := Printer.Parameters.XmlZReportFileName;
    DriverParameterCsvZReportFileName: pString := Printer.Parameters.CsvZReportFileName;
    DriverParameterVoidReceiptOnMaxItems: pString := BoolToStr(Printer.Parameters.VoidReceiptOnMaxItems);
    DriverParameterMaxReceiptItems: pString := IntToStr(Printer.Parameters.MaxReceiptItems);
    DriverParameterJournalPrintHeader: pString := BoolToStr(Printer.Parameters.JournalPrintHeader);
    DriverParameterJournalPrintTrailer: pString := BoolToStr(Printer.Parameters.JournalPrintTrailer);
    DriverParameterCacheReceiptNumber: pString := BoolToStr(Printer.Parameters.CacheReceiptNumber);
    DriverParameterBarLineByteMode: pString := IntToStr(Printer.Parameters.BarLineByteMode);
    DriverParameterLogFilePath: pString := Printer.Parameters.LogFilePath;
    DriverParameterLogFileName: pString := Logger.FileName;

    DriverParameterParam1: pString := Printer.Parameters.Parameter1;
    DriverParameterParam2: pString := Printer.Parameters.Parameter2;
    DriverParameterParam3: pString := Printer.Parameters.Parameter3;
    DriverParameterParam4: pString := Printer.Parameters.Parameter4;
    DriverParameterParam5: pString := Printer.Parameters.Parameter5;
    DriverParameterParam6: pString := Printer.Parameters.Parameter6;
    DriverParameterParam7: pString := Printer.Parameters.Parameter7;
    DriverParameterParam8: pString := Printer.Parameters.Parameter8;
    DriverParameterParam9: pString := Printer.Parameters.Parameter9;
    DriverParameterParam10: pString := Printer.Parameters.Parameter10;
    DriverParameterBarcode: pString := Printer.Parameters.Barcode;
    DriverParameterMarkType: pString := IntToStr(Printer.Parameters.MarkType);
    DriverParameterCorrectionType: pString := IntToStr(Printer.Parameters.CorrectionType);
    DriverParameterCalculationSign: pString := IntToStr(Printer.Parameters.CalculationSign);
    DriverParameterAmount2: pString := IntToStr(Printer.Parameters.Amount2);
    DriverParameterAmount3: pString := IntToStr(Printer.Parameters.Amount3);
    DriverParameterAmount4: pString := IntToStr(Printer.Parameters.Amount4);
    DriverParameterAmount5: pString := IntToStr(Printer.Parameters.Amount5);
    DriverParameterAmount6: pString := IntToStr(Printer.Parameters.Amount6);
    DriverParameterAmount7: pString := IntToStr(Printer.Parameters.Amount7);
    DriverParameterAmount8: pString := IntToStr(Printer.Parameters.Amount8);
    DriverParameterAmount9: pString := IntToStr(Printer.Parameters.Amount9);
    DriverParameterAmount10: pString := IntToStr(Printer.Parameters.Amount10);
    DriverParameterAmount11: pString := IntToStr(Printer.Parameters.Amount11);
    DriverParameterAmount12: pString := IntToStr(Printer.Parameters.Amount12);
    DriverParameterTaxType: pString := IntToStr(Printer.Parameters.TaxType);
    DriverParameterMessage: pString := _(pString);
    DriverParameterErrorMessage: pString := GetErrorText(StrToInt(pString), True);
    DriverParameterDiscountMode: pString := '0';
    DriverParameterCapFiscalStorage: pString := BoolToStr(Printer.Device.CapFiscalStorage);
    DriverParameterLastDocMac: pString := IntToStr(Printer.Device.LastDocMac);
    DriverParameterLastDocNum: pString := IntToStr(Printer.Device.LastDocNumber);
    DriverParameterLastDocTotal: pString := IntToStr(Printer.Device.LastDocTotal);
    DriverParameterLastDocDateTime: pString := EncodeOposDate(
      Printer.Device.LastDocDate, Printer.Device.LastDocTime);
  end;
end;

{ TDIOSetDriverParameter }

procedure TDIOSetDriverParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  case pData of
    DriverParameterStorage: Parameters.Storage := StrToInt(pString);
    DriverParameterBaudRate: Parameters.BaudRate := StrToInt(pString);
    DriverParameterPortNumber: Parameters.PortNumber := StrToInt(pString);
    DriverParameterFontNumber: Parameters.FontNumber := StrToInt(pString);
    DriverParameterSysPassword: Parameters.SysPassword := StrToInt(pString);
    DriverParameterUsrPassword: Parameters.UsrPassword := StrToInt(pString);
    DriverParameterByteTimeout: Parameters.ByteTimeout := StrToInt(pString);
    DriverParameterStatusInterval: Parameters.StatusInterval := StrToInt(pString);
    DriverParameterSubtotalText: Parameters.SubtotalText := pString;
    DriverParameterCloseRecText: Parameters.CloseRecText := pString;
    DriverParameterVoidRecText: Parameters.VoidRecText := pString;
    DriverParameterPollInterval: Parameters.PollIntervalInSeconds := StrToInt(pString);
    DriverParameterMaxRetryCount: Parameters.MaxRetryCount := StrToInt(pString);
    DriverParameterDeviceByteTimeout: Parameters.DeviceByteTimeout := StrToInt(pString);
    DriverParameterSearchByPortEnabled: Parameters.SearchByPortEnabled := StrToBool(pString);
    DriverParameterSearchByBaudRateEnabled: Parameters.SearchByBaudRateEnabled := StrToBool(pString);
    DriverParameterPropertyUpdateMode: Parameters.PropertyUpdateMode := StrToInt(pString);
    DriverParameterCutType: Parameters.CutType := StrToInt(pString);
    DriverParameterLogMaxCount: Parameters.LogMaxCount := StrToInt(pString);
    DriverParameterEncoding: Parameters.Encoding := StrToInt(pString);
    DriverParameterRemoteHost: Parameters.RemoteHost := pString;
    DriverParameterRemotePort: Parameters.RemotePort := StrToInt(pString);
    DriverParameterHeaderType: Parameters.HeaderType := StrToInt(pString);
    DriverParameterHeaderFont: Parameters.HeaderFont := StrToInt(pString);
    DriverParameterTrailerFont: Parameters.TrailerFont := StrToInt(pString);
    DriverParameterTrainModeText: Parameters.SetPrinterMessage(MsgTrainModeText, pString);
    DriverParameterLogoPosition: Parameters.LogoPosition := StrToInt(pString);
    DriverParameterTrainSaleText: Parameters.SetPrinterMessage(MsgTrainSaleText, pString);
    DriverParameterTrainPay2Text: Parameters.SetPrinterMessage(MsgTrainPay2Text, pString);
    DriverParameterTrainPay3Text: Parameters.SetPrinterMessage(MsgTrainPay3Text, pString);
    DriverParameterTrainPay4Text: Parameters.SetPrinterMessage(MsgTrainPay4Text, pString);
    DriverParameterStatusCommand: Parameters.StatusCommand := StrToInt(pString);
    DriverParameterTrainTotalText: Parameters.SetPrinterMessage(MsgTrainTotalText, pString);
    DriverParameterConnectionType: Parameters.ConnectionType := StrToInt(pString);
    DriverParameterLogFileEnabled: Parameters.LogFileEnabled := StrToBool(pString);
    DriverParameterNumHeaderLines: Parameters.NumHeaderLines := StrToInt(pString);
    DriverParameterTrainChangeText: Parameters.SetPrinterMessage(MsgTrainChangeText, pString);
    DriverParameterTrainStornoText: Parameters.SetPrinterMessage(MsgTrainStornoText, pString);
    DriverParameterTrainCashInText: Parameters.SetPrinterMessage(MsgTrainCashInText, pString);
    DriverParameterNumTrailerLines: Parameters.NumTrailerLines := StrToInt(pString);
    DriverParameterTrainCashOutText: Parameters.SetPrinterMessage(MsgTrainCashOutText, pString);
    DriverParameterTrainVoidRecText: Parameters.SetPrinterMessage(MsgTrainVoidRecText, pString);
    DriverParameterTrainCashPayText: Parameters.SetPrinterMessage(MsgTrainCashPayText, pString);
    DriverParameterBarLinePrintDelay: Parameters.BarLinePrintDelay := StrToInt(pString);
    DriverParameterCompatLevel: Parameters.CompatLevel := StrToInt(pString);
    DriverParameterHeader: Parameters.Header := pString;
    DriverParameterTrailer: Parameters.Trailer := pString;
    DriverParameterLogoSize: Parameters.LogoSize := StrToInt(pString);
    DriverParameterLogoCenter: Parameters.LogoCenter := StrToBool(pString);
    DriverParameterDepartment: Parameters.Department := StrToInt(pString);
    DriverParameterLogoEnabled: ;
    DriverParameterHeaderPrinted: Parameters.HeaderPrinted := StrToBool(pString);
    DriverParameterReceiptType: Parameters.ReceiptType := StrToInt(pString);
    DriverParameterZeroReceiptType: Parameters.ZeroReceiptType := StrToInt(pString);
    DriverParameterZeroReceiptNumber: Parameters.ZeroReceiptNumber := StrToInt(pString);
    DriverParameterCCOType: Parameters.CCOType := StrToInt(pString);

    DriverParameterTableEditEnabled: Parameters.TableEditEnabled := StrToBool(pString);
    DriverParameterXmlZReportEnabled: Parameters.XmlZReportEnabled := StrToBool(pString);
    DriverParameterCsvZReportEnabled: Parameters.CsvZReportEnabled := StrToBool(pString);
    DriverParameterXmlZReportFileName: Parameters.XmlZReportFileName := pString;
    DriverParameterCsvZReportFileName: Parameters.CsvZReportFileName := pString;
    DriverParameterVoidReceiptOnMaxItems: Parameters.VoidReceiptOnMaxItems := StrToBool(pString);
    DriverParameterMaxReceiptItems: Parameters.VoidReceiptOnMaxItems := StrToBool(pString);
    DriverParameterJournalPrintHeader: Parameters.JournalPrintHeader := StrToBool(pString);
    DriverParameterJournalPrintTrailer: Parameters.JournalPrintTrailer := StrToBool(pString);
    DriverParameterCacheReceiptNumber: Parameters.CacheReceiptNumber := StrToBool(pString);
    DriverParameterBarLineByteMode: Parameters.BarLineByteMode := StrToInt(pString);
    DriverParameterLogFilePath: Parameters.LogFilePath := pString;

    DriverParameterParam1: Parameters.Parameter1 := pString;
    DriverParameterParam2: Parameters.Parameter2 := pString;
    DriverParameterParam3: Parameters.Parameter3 := pString;
    DriverParameterParam4: Parameters.Parameter4 := pString;
    DriverParameterParam5: Parameters.Parameter5 := pString;
    DriverParameterParam6: Parameters.Parameter6 := pString;
    DriverParameterParam7: Parameters.Parameter7 := pString;
    DriverParameterParam8: Parameters.Parameter8 := pString;
    DriverParameterParam9: Parameters.Parameter9 := pString;
    DriverParameterParam10: Parameters.Parameter10 := pString;
    DriverParameterBarcode: Parameters.Barcode := pString;
    DriverParameterMarkType: Parameters.MarkType := StrToInt(pString);
    DriverParameterCorrectionType: Parameters.CorrectionType := StrToInt(pString);
    DriverParameterCalculationSign: Parameters.CalculationSign := StrToInt(pString);
    DriverParameterAmount2: Parameters.Amount2 := StrToInt(pString);
    DriverParameterAmount3: Parameters.Amount3 := StrToInt(pString);
    DriverParameterAmount4: Parameters.Amount4 := StrToInt(pString);
    DriverParameterAmount5: Parameters.Amount5 := StrToInt(pString);
    DriverParameterAmount6: Parameters.Amount6 := StrToInt(pString);
    DriverParameterAmount7: Parameters.Amount7 := StrToInt(pString);
    DriverParameterAmount8: Parameters.Amount8 := StrToInt(pString);
    DriverParameterAmount9: Parameters.Amount9 := StrToInt(pString);
    DriverParameterAmount10: Parameters.Amount10 := StrToInt(pString);
    DriverParameterAmount11: Parameters.Amount11 := StrToInt(pString);
    DriverParameterAmount12: Parameters.Amount12 := StrToInt(pString);
    DriverParameterTaxType: Parameters.TaxType := StrToInt(pString);
    DriverParameterDiscountMode: ;
    DriverParameterCapFiscalStorage: FPrinter.Device.CapFiscalStorage := StrToBool(pString);
  end;
end;

{ TDIOPrintSeparator }

procedure TDIOPrintSeparator.DirectIO(var pData: Integer;
  var pString: WideString);
var
  V, Code: Integer;
  SeparatorType: Integer;
  SeparatorHeight: Integer;
begin
  if pData <= 0 then Exit;
  SeparatorHeight := pData;
  SeparatorType := DIO_SEPARATOR_BLACK;
  if pString <> '' then
  begin
    Val(pString, V, Code);
    if Code = 0 then
      SeparatorType := V;
  end;
  Printer.Printer.PrintSeparator(SeparatorType, SeparatorHeight);
end;

(*
ØÒÐÈÕ-Ì-ÔÐ-Ê
ÊÊÌ 000012345678 ÈÍÍ 000000012345
ÝÊËÇ 1234560701
ÈÒÎÃ ÀÊÒÈÂÈÇÀÖÈÈ
16/09/13 14:00 ÇÀÊÐÛÒÈÅ ÑÌÅÍÛ 0000
ÐÅÃÈÑÒÐÀÖÈÎÍÍÛÉ ÍÎÌÅÐ       000000123456
00000001 #060344
*)

{ TDIOReadEJActivation }

function GetParam(const S: WideString; N: Integer): WideString;
var
  i: Integer;
  Tocken: WideString;
  WasSeparator: Boolean;
  TockenNumber: Integer;
begin
  Result := '';
  Tocken := '';
  TockenNumber := 1;
  WasSeparator := False;
  for i := 1 to Length(S) do
  begin
    if S[i] = ' ' then
    begin
      if TockenNumber = N then Break;
      WasSeparator := True;
    end else
    begin
      if WasSeparator then
      begin
        Tocken := '';
        Inc(TockenNumber);
        WasSeparator := False;
      end;
      Tocken := Tocken + S[i];
    end;
  end;
  Result := Tocken;
end;

function ParamsToDate(Params: TTntStrings): WideString;
var
  Date, Time: WideString;
  OposDate: TPrinterDateTime;
begin
  Result := '';
  if Params.Count >= 5 then
  begin
    Date := Params[4];
    Time := Params[5];
    OposDate.Day := StrToInt(Copy(Date, 1, 2));
    OposDate.Month := StrToInt(Copy(Date, 4, 2));
    OposDate.Year := StrToInt(Copy(Date, 7, 2));
    OposDate.Hour := StrToInt(Copy(Time, 1, 2));
    OposDate.Min := StrToInt(Copy(Time, 4, 2));
    Result := EncodeOposDate(OposDate);
  end;
end;

function ParamsToString(Params: TTntStrings): WideString;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Params.Count-1 do
  begin
    Result := Result + Params[i] + ';';
  end;
end;

procedure TDIOReadEJActivation.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Lines: TTntStrings;
  Params: TTntStrings;
const
  Delimiters: TSetOfChar = [' '];
begin
  pString := '';
  Lines := TTntStringList.Create;
  Params := TTntStringList.Create;
  try
    Lines.Text := Printer.ReadEJActivation;
    if Lines.Count >= 7 then
    begin
      Params.Add(Lines[0]);              // ØÒÐÈÕ-Ì-ÔÐ-Ê
      Params.Add(GetParam(Lines[1], 2)); // 000012345678
      Params.Add(GetParam(Lines[1], 4)); // 000000012345
      Params.Add(GetParam(Lines[2], 2)); // 1234560701
      Params.Add(GetParam(Lines[4], 1)); // 16/09/13
      Params.Add(GetParam(Lines[4], 2)); // 14:00
      Params.Add(GetParam(Lines[4], 5)); // 0000
      Params.Add(GetParam(Lines[5], 3)); // 000000123456
      Params.Add(GetParam(Lines[6], 1)); // 00000001
      Params.Add(GetParam(Lines[6], 2)); // #060344

      case pData of
        ParamReadEJActivationAll: pString := ParamsToString(Params);
        ParamReadEJActivationDate: pString := ParamsToDate(Params);
      else
        pString := ParamsToString(Params);
      end;
    end;
  finally
    Lines.Free;
    Params.Free;
  end;
end;

{ TDIOReadFMTotals }

procedure TDIOReadFMTotals.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Totals: TFMTotals;
begin
  pString := '';
  Printer.Device.Check(Printer.Device.ReadFMTotals(pData, Totals));
  pString := Tnt_WideFormat('%d;%d;%d;%d', [Totals.SaleTotal, Totals.BuyTotal,
    Totals.RetSale, Totals.RetBuy]);
end;

{ TDIOReadGrandTotals }

procedure TDIOReadGrandTotals.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Totals: TFMTotals;
begin
  Totals := Printer.Device.ReadFPTotals(pData);
  pString := Tnt_WideFormat('%d;%d;%d;%d', [
    Totals.SaleTotal, Totals.BuyTotal, Totals.RetSale, Totals.RetBuy]);
end;

{ TDIOPrintImage }

procedure TDIOPrintImage.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintImage(pString);
end;

{ TDIOPrintImageScale }

procedure TDIOPrintImageScale.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintImageScale(pString, pData);
end;

{ TDIOReadFSParameter }

procedure TDIOReadFSParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := FPrinter.ReadFSParameter(pData, pString);
end;

{ TDIOReadFPParameter }

procedure TDIOReadFPParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Device.ReadFPParameter(pData);
end;

{ TDIOWriteFPParameter }

procedure TDIOWriteFPParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.WriteFPParameter(pData, pString);
end;

{ TDIOWriteCustomerAddress }

procedure TDIOWriteCustomerAddress.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.WriteCustomerAddress(pString);
end;

{ TDIOWriteTlvData }

procedure TDIOWriteTlvData.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Device.FSWriteTlv2(pString);
end;

{ TDIOWriteStringTag }

procedure TDIOWriteStringTag.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTag(pData, pString);
end;

{ TDIOSetAdjustmentAmount }

procedure TDIOSetAdjustmentAmount.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.SetAdjustmentAmount(pData);
end;

{ TDIODisableNextHeader }

procedure TDIODisableNextHeader.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.DisableNextHeader;
end;

{ TDIOWriteTableFile }

procedure TDIOWriteTableFile.DirectIO(var pData: Integer;
  var pString: WideString);
var
  TableFilePath: WideString;
begin
  TableFilePath := pString;
  FPrinter.Device.LoadTables(TableFilePath);
end;

{ TDIOFSReadDocument }

procedure TDIOFSReadDocument.DirectIO(var pData: Integer;
  var pString: WideString);

  function GetDocMac(const R: TFSDocument): Int64;
  begin
    Result := 0;
    case R.DocType of
      1: Result := R.DocType1.DocMac;
      2: Result := R.DocType2.DocMac;
      3: Result := R.DocType3.DocMac;
      4: Result := R.DocType3.DocMac;
      5: Result := R.DocType2.DocMac;
      6: Result := R.DocType6.DocMac;
      11: Result := R.DocType11.DocMac;
      21: Result := R.DocType21.DocMac;
      31: Result := R.DocType3.DocMac;
    end;
  end;

var
  Ticket: TFSTicket;
  DocNumber: Integer;
  Document: TFSDocument;
begin
  DocNumber := pData;
  FPrinter.Device.Check(FPrinter.Device.FSFindDocument(DocNumber, Document));
  pString := Tnt_WideFormat('%d;%d;%d;', [
    Document.DocType, BoolToInt[Document.TicketReceived], GetDocMac(Document)]);

  if Document.TicketReceived then
  begin
    Ticket.Number := DocNumber;
    FPrinter.Device.Check(FPrinter.Device.FSReadTicket(Ticket));
    pString := pString + TicketToStr(Ticket);
  end;
end;

{ TDIOFSPrintCalcReport }

procedure TDIOFSPrintCalcReport.DirectIO(var pData: Integer;
  var pString: WideString);
var
  R: TFSCalcReport;
begin
  FPrinter.Device.Check(FPrinter.Device.FSPrintCalcReport(R));
  FPrinter.PrintReportEnd;
end;

{ TDIOOpenCashDrawer }

procedure TDIOOpenCashDrawer.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.OpenDrawer(pData);
end;

{ TDIOReadCashDrawerState }

procedure TDIOReadCashDrawerState.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := BoolToInt[FPrinter.Device.ReadPrinterStatus.Flags.DrawerOpened];
end;

{ TDIOFSFiscalize }

procedure TDIOFSFiscalize.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TFSFiscalization;
  R: TFDDocument;
begin
  P.TaxID := GetString(pString, 1, ValueDelimiters);
  P.RegID := GetString(pString, 2, ValueDelimiters);
  P.TaxCode := GetInteger(pString, 3, ValueDelimiters);
  P.WorkMode := GetInteger(pString, 4, ValueDelimiters);
  FPrinter.Device.Check(FPrinter.Device.FSFiscalization(P, R));
  pString := Tnt_WideFormat('%s;%s', [IntToStr(R.DocNumber), IntToStr(R.DocMac)]);
end;

{ TDIOFSReFiscalize }

procedure TDIOFSReFiscalize.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TFSReFiscalization;
  R: TFDDocument;
begin
  P.TaxID := GetString(pString, 1, ValueDelimiters);
  P.RegID := GetString(pString, 2, ValueDelimiters);
  P.TaxCode := GetInteger(pString, 3, ValueDelimiters);
  P.WorkMode := GetInteger(pString, 4, ValueDelimiters);
  P.ReasonCode := GetInteger(pString, 5, ValueDelimiters);
  FPrinter.Device.Check(FPrinter.Device.FSReFiscalization(P, R));
  pString := Tnt_WideFormat('%s;%s', [IntToStr(R.DocNumber), IntToStr(R.DocMac)]);
end;

{ TDIOGetPrintWidth }

procedure TDIOGetPrintWidth.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := IntToStr(FPrinter.Device.GetPrintWidth(pData));
end;

{ TDIOReadFSDocument }

procedure TDIOReadFSDocument.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := FPrinter.ReadFSDocument(pData);
end;

{ TDIOPrintFSDocument }

procedure TDIOPrintFSDocument.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.PrintFSDocument(pData);
end;

{ TDIOPrintCorrection }

procedure TDIOPrintCorrection.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Data: TFSCorrectionReceipt;
begin
  Data.RecType := GetInteger(pString, 1, ValueDelimiters);
  Data.Total := GetInteger(pString, 2, ValueDelimiters);
  FPrinter.Device.Check(FPrinter.FSPrintCorrectionReceipt(Data));
  pString := Tnt_WideFormat('%d;%d;%d;%d', [
    Data.ResultCode, Data.ReceiptNumber,
    Data.DocumentNumber, Data.DocumentMac]);
end;

{ TDIOPrintCorrection2 }

procedure TDIOPrintCorrection2.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Data: TFSCorrectionReceipt2;
begin
  Data.CorrectionType := GetInteger(pString, 1, ValueDelimiters);
  Data.CalculationSign := GetInteger(pString, 2, ValueDelimiters);
  Data.Amount1 := GetInteger(pString, 3, ValueDelimiters);
  Data.Amount2 := GetInteger(pString, 4, ValueDelimiters);
  Data.Amount3 := GetInteger(pString, 5, ValueDelimiters);
  Data.Amount4 := GetInteger(pString, 6, ValueDelimiters);
  Data.Amount5 := GetInteger(pString, 7, ValueDelimiters);
  Data.Amount6 := GetInteger(pString, 8, ValueDelimiters);
  Data.Amount7 := GetInteger(pString, 9, ValueDelimiters);
  Data.Amount8 := GetInteger(pString, 10, ValueDelimiters);
  Data.Amount9 := GetInteger(pString, 11, ValueDelimiters);
  Data.Amount10 := GetInteger(pString, 12, ValueDelimiters);
  Data.Amount11 := GetInteger(pString, 13, ValueDelimiters);
  Data.Amount12 := GetInteger(pString, 14, ValueDelimiters);
  Data.TaxType := GetInteger(pString, 15, ValueDelimiters);
  FPrinter.Device.Check(FPrinter.FSPrintCorrectionReceipt2(Data));
  pString := Tnt_WideFormat('%d;%d;%d;%d', [
    Data.ResultCode, Data.ReceiptNumber,
    Data.DocumentNumber, Data.DocumentMac]);
end;

{ TDIOStartOpenDay }

procedure TDIOStartOpenDay.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.Check(FPrinter.Device.FSStartOpenDay());
end;

{ TDIOOpenDay }

procedure TDIOOpenDay.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.OpenFiscalDay;
end;

{ TDIOCheckItemCode }

procedure TDIOCheckItemCode.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.Check(FPrinter.Device.CheckItemCode(pString));
end;

{ TDIOCheckItemCode2 }

procedure TDIOCheckItemCode2.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TFSCheckItemCode;
  R: TFSCheckItemResult;
begin
  P.ItemStatus := GetInteger(pString, 1, ValueDelimiters);
  P.ProcessMode := GetInteger(pString, 2, ValueDelimiters);
  P.CMData := HexToStr(GetString(pString, 3, ValueDelimiters));
  P.TLVData := HexToStr(GetString(pString, 4, ValueDelimiters));
  FPrinter.Device.Check(FPrinter.Device.FSCheckItemCode(P, R));
  pString := Format('%d;%d;%d;%d;%d;%d;%s;', [
    R.LocalCheckResult,
    R.LocalCheckError,
    R.SymbolicType,
    R.DataLength,
    R.FSResultCode,
    R.ServerCheckStatus,
    StrToHex(R.ServerTLVData)]);
end;

{ TDIOStartCorrection }

procedure TDIOStartCorrection.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.Check(FPrinter.Device.FSStartCorrectionReceipt);
end;

{ TDIOWriteTlvOperation }

procedure TDIOWriteTlvOperation.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTlvOperation(HexToStr(pString));
end;

{ TDIOWriteTlvHex }

procedure TDIOWriteTlvHex.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.FSWriteTlv2(HexToStr(pString));
end;

{ TDIOClearLogo }

procedure TDIOClearLogo.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Printer.ClearLogo;
end;

{ TDIOWriteStringTagOp }

procedure TDIOWriteStringTagOp.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTagOperation(pData, pString);
end;

{ TDIOSTLVBegin }

procedure TDIOSTLVBegin.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.STLVBegin(pData);
end;

{ TDIOSTLVAddTag }

procedure TDIOSTLVAddTag.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.STLVAddTag(pData, pString);
end;

{ TDIOSTLVGetHex }

procedure TDIOSTLVGetHex.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Printer.Device.STLVGetHex;
end;

{ TDIOSTLVWrite }

procedure TDIOSTLVWrite.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTLV(HexToStr(Printer.Device.STLVGetHex));
end;

{ TDIOSTLVWriteOp }

procedure TDIOSTLVWriteOp.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTLVOperation(HexToStr(Printer.Device.STLVGetHex));
end;

{ TDIOSetReceiptField }

procedure TDIOSetReceiptField.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.SetReceiptField(pData, pString);
end;

{ TDIOAddItemCode }

procedure TDIOAddItemCode.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.AddItemCode(pString);
end;

{ TDIOFSSyncRegisters }

procedure TDIOFSSyncRegisters.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.Check(FPrinter.Device.FSSyncRegisters);
end;

{ TDIOFSReadMemStatus }

procedure TDIOFSReadMemStatus.DirectIO(var pData: Integer;
  var pString: WideString);
var
  R: TFSReadMemoryResult;
begin
  FPrinter.Device.Check(FPrinter.Device.FSReadMemory(R));
  pString := Format('%d;%d;%d', [
    R.FreeDocCount, R.FreeMemorySizeInKB, R.UsedMCTicketStorageInPercents]);
end;

{ TDIOFSWriteTLVBuffer }

procedure TDIOFSWriteTLVBuffer.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.Check(FPrinter.Device.FSWriteTLVFromBuffer);
end;

{ TDIOFSGenerateRandomData }

procedure TDIOFSGenerateRandomData.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Data: string;
begin
  FPrinter.Device.Check(FPrinter.Device.FSRandomData(Data));
  pString := StrToHex(Data);
end;

{ TDIOFSAuthorize }

procedure TDIOFSAuthorize.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Data: AnsiString;
begin
  Data := HexToStr(pString);
  FPrinter.Device.Check(FPrinter.Device.FSAuthorize(Data));
end;

{ TDIOFSReadTicketStatus }

procedure TDIOFSReadTicketStatus.DirectIO(var pData: Integer;
  var pString: WideString);
var
  R: TFSTicketStatus;
begin
  FPrinter.Device.Check(FPrinter.Device.FSReadTicketStatus(R));
  pString := Format('%d;%d;%d;%s;%d', [
    R.TicketStatus,
    R.TicketCount,
    R.TicketNumber,
    EncodeOposDate(R.TicketDate),
    R.TicketStorageUsageInPercents]);
end;

end.
