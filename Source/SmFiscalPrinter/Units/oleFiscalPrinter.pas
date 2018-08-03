unit oleFiscalPrinter;

interface

uses
  // VCL
  Windows, ComObj, ComServ, SyncObjs, SysUtils,
  // Opos
  OposFptrUtils,
  // This
  FiscalPrinterImpl, SmFiscalPrinterLib_TLB, LogFile, PrinterEncoding,
  PrinterParameters, TranslationUtil;

type
  { ToleFiscalPrinter }

  ToleFiscalPrinter = class(TAutoObject, IFiscalPrinterService_1_12)
  private
    function GetLogger: ILogFile;
  private
    FLock: TCriticalSection;
    FDriver: TFiscalPrinterImpl;

    procedure Lock;
    procedure Unlock;
    function GetLock: TCriticalSection;
    function GetDriver: TFiscalPrinterImpl;

    property Logger: ILogFile read GetLogger;
    property Driver: TFiscalPrinterImpl read GetDriver;
  public
    constructor Create(ADriver: TFiscalPrinterImpl);
    destructor Destroy; override;

    function EncodeString(const Text: WideString): WideString;
    function DecodeString(const Text: WideString): WideString;
  public
    // IFiscalPrinterService_1_12
    function Get_OpenResult: Integer; safecall;
    function COFreezeEvents(Freeze: WordBool): Integer; safecall;
    function GetPropertyNumber(PropIndex: Integer): Integer; safecall;
    procedure SetPropertyNumber(PropIndex: Integer; Number: Integer); safecall;
    function GetPropertyString(PropIndex: Integer): WideString; safecall;

    procedure SetPropertyString(
      PropIndex: Integer;
      const AText: WideString); safecall;

    function OpenService(
      const DeviceClass: WideString;
      const DeviceName: WideString;
      const pDispatch: IDispatch): Integer; safecall;

    function CloseService: Integer; safecall;

    function CheckHealth(Level: Integer): Integer; safecall;

    function ClaimDevice(Timeout: Integer): Integer; safecall;

    function ClearOutput: Integer; safecall;

    function DirectIO(
      Command: Integer;
      var pData: Integer;
      var pString: WideString): Integer; safecall;

    function ReleaseDevice: Integer; safecall;

    function BeginFiscalDocument(
      DocumentAmount: Integer): Integer; safecall;

    function BeginFiscalReceipt(
      PrintHeader: WordBool): Integer; safecall;

    function BeginFixedOutput(
      Station: Integer;
      DocumentType: Integer): Integer; safecall;

    function BeginInsertion(
      Timeout: Integer): Integer; safecall;

    function BeginItemList(
      VatID: Integer): Integer; safecall;

    function BeginNonFiscal: Integer; safecall;

    function BeginRemoval(
      Timeout: Integer): Integer; safecall;

    function BeginTraining: Integer; safecall;

    function ClearError: Integer; safecall;

    function EndFiscalDocument: Integer; safecall;

    function EndFiscalReceipt(
      PrintHeader: WordBool): Integer; safecall;

    function EndFixedOutput: Integer; safecall;

    function EndInsertion: Integer; safecall;

    function EndItemList: Integer; safecall;

    function EndNonFiscal: Integer; safecall;

    function EndRemoval: Integer; safecall;

    function EndTraining: Integer; safecall;

    function GetData(
      DataItem: Integer;
      out OptArgs: Integer;
      out Data: WideString): Integer; safecall;

    function GetDate(
      out Date: WideString): Integer; safecall;

    function GetTotalizer(
      VatID: Integer;
      OptArgs: Integer;
      out Data: WideString): Integer; safecall;

    function GetVatEntry(
      VatID: Integer;
      OptArgs: Integer;
      out VatRate: Integer): Integer; safecall;

    function PrintDuplicateReceipt: Integer; safecall;

    function PrintFiscalDocumentLine(
      const DocumentLine: WideString): Integer; safecall;

    function PrintFixedOutput(
      DocumentType: Integer;
      LineNumber: Integer;
      const Data: WideString): Integer; safecall;

    function PrintNormal(
      Station: Integer;
      const AData: WideString): Integer; safecall;

    function PrintPeriodicTotalsReport(
      const Date1: WideString;
      const Date2: WideString): Integer; safecall;

    function PrintPowerLossReport: Integer; safecall;

    function PrintRecItem(
      const ADescription: WideString;
      Price: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitPrice: Currency;
      const AUnitName: WideString): Integer; safecall;

    function PrintRecItemAdjustment(
      AdjustmentType: Integer;
      const ADescription: WideString;
      Amount: Currency;
      VatInfo: Integer): Integer; safecall;

    function PrintRecMessage(
      const AMessage: WideString): Integer; safecall;

    function PrintRecNotPaid(
      const ADescription: WideString;
      Amount: Currency): Integer; safecall;

    function PrintRecRefund(
      const ADescription: WideString;
      Amount: Currency;
      VatInfo: Integer): Integer; safecall;

    function PrintRecSubtotal(
      Amount: Currency): Integer; safecall;

    function PrintRecSubtotalAdjustment(
      AdjustmentType: Integer;
      const ADescription: WideString;
      Amount: Currency): Integer; safecall;

    function PrintRecTotal(
      Total: Currency;
      Payment: Currency;
      const ADescription: WideString): Integer; safecall;

    function PrintRecVoid(
      const ADescription: WideString): Integer; safecall;

    function PrintRecVoidItem(
      const ADescription: WideString;
      Amount: Currency;
      Quantity: Integer;
      AdjustmentType: Integer;
      Adjustment: Currency;
      VatInfo: Integer): Integer; safecall;

    function PrintReport(
      ReportType: Integer;
      const AStartNum: WideString;
      const AEndNum: WideString): Integer; safecall;

    function PrintXReport: Integer; safecall;

    function PrintZReport: Integer; safecall;

    function ResetPrinter: Integer; safecall;

    function SetDate(
      const ADate: WideString): Integer; safecall;

    function SetHeaderLine(
      LineNumber: Integer;
      const AText: WideString;
      DoubleWidth: WordBool): Integer; safecall;

    function SetPOSID(
      const APOSID: WideString;
      const ACashierID: WideString): Integer; safecall;

    function SetStoreFiscalID(const ID: WideString): Integer; safecall;

    function SetTrailerLine(
      LineNumber: Integer;
      const AText: WideString;
      DoubleWidth: WordBool): Integer; safecall;

    function SetVatTable: Integer; safecall;

    function SetVatValue(
      VatID: Integer;
      const AVatValue: WideString): Integer; safecall;

    function VerifyItem(
      const AItemName: WideString;
      VatID: Integer): Integer; safecall;

    function PrintRecCash(
      Amount: Currency): Integer; safecall;

    function PrintRecItemFuel(
      const ADescription: WideString;
      Price: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitPrice: Currency;
      const AUnitName: WideString;
      SpecialTax: Currency;
      const ASpecialTaxName: WideString): Integer; safecall;

    function PrintRecItemFuelVoid(
      const ADescription: WideString;
      Price: Currency;
      VatInfo: Integer;
      SpecialTax: Currency): Integer; safecall;

    function PrintRecPackageAdjustment(
      AdjustmentType: Integer;
      const ADescription: WideString;
      const AVatAdjustment: WideString): Integer; safecall;

    function PrintRecPackageAdjustVoid(
      AdjustmentType: Integer;
      const AVatAdjustment: WideString): Integer; safecall;

    function PrintRecRefundVoid(
      const ADescription: WideString;
      Amount: Currency;
      VatInfo: Integer): Integer; safecall;

    function PrintRecSubtotalAdjustVoid(
      AdjustmentType: Integer;
      Amount: Currency): Integer; safecall;

    function PrintRecTaxID(
      const ATaxID: WideString): Integer; safecall;

    function SetCurrency(
      NewCurrency: Integer): Integer; safecall;

    function GetOpenResult: Integer; safecall;

    function Open(
      const DeviceClass: WideString;
      const DeviceName: WideString;
      const pDispatch: IDispatch): Integer; safecall;

    function Close: Integer; safecall;

    function Claim(
      Timeout: Integer): Integer; safecall;

    function Release1: Integer; safecall;

    function ResetStatistics(
      const AStatisticsBuffer: WideString): Integer; safecall;

    function RetrieveStatistics(
      var pStatisticsBuffer: WideString): Integer; safecall;

    function UpdateStatistics(
      const AStatisticsBuffer: WideString): Integer; safecall;

    function CompareFirmwareVersion(
      const AFirmwareFileName: WideString;
      out pResult: Integer): Integer; safecall;

    function UpdateFirmware(
      const AFirmwareFileName: WideString): Integer; safecall;

    function PrintRecItemAdjustmentVoid(
      AdjustmentType: Integer;
      const ADescription: WideString;
      Amount: Currency;
      VatInfo: Integer): Integer; safecall;

    function PrintRecItemVoid(
      const ADescription: WideString;
      Price: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitPrice: Currency;
      const AUnitName: WideString): Integer; safecall;

    function PrintRecItemRefund(
      const ADescription: WideString;
      Amount: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitAmount: Currency;
      const AUnitName: WideString): Integer; safecall;

    function PrintRecItemRefundVoid(
      const ADescription: WideString;
      Amount: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitAmount: Currency;
      const AUnitName: WideString): Integer; safecall;

    property OpenResult: Integer read Get_OpenResult;
  end;

implementation

{ ToleFiscalPrinter }

constructor ToleFiscalPrinter.Create(ADriver: TFiscalPrinterImpl);
begin
  inherited Create;
  FDriver := ADriver;
end;

destructor ToleFiscalPrinter.Destroy;
begin
  FLock.Free;
  FDriver.Free;
  inherited Destroy;
end;

function ToleFiscalPrinter.GetLogger: ILogFile;
begin
  Result := Driver.Logger;
end;

function ToleFiscalPrinter.GetDriver: TFiscalPrinterImpl;
begin
  if FDriver = nil then
    FDriver := TFiscalPrinterImpl.Create(nil);
  Result := FDriver;
end;

function ToleFiscalPrinter.GetLock: TCriticalSection;
begin
  if FLock = nil then
    FLock := TCriticalSection.Create;
  Result := FLock;
end;

procedure ToleFiscalPrinter.Lock;
begin
  GetLock.Enter;
end;

procedure ToleFiscalPrinter.Unlock;
begin
  GetLock.Leave;
end;

function ToleFiscalPrinter.DecodeString(const Text: WideString): WideString;
begin
  Result := Driver.DecodeString(Text);
end;

function ToleFiscalPrinter.EncodeString(const Text: WideString): WideString;
begin
  Result := Driver.EncodeString(Text);
end;


// IFiscalPrinterService_1_12

function ToleFiscalPrinter.Get_OpenResult: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.Get_OpenResult');
  Result := Driver.Get_OpenResult;
  Logger.Debug('ToleFiscalPrinter.Get_OpenResult', [], Result);
  Unlock;
end;

function ToleFiscalPrinter.COFreezeEvents(Freeze: WordBool): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.COFreezeEvents', [Freeze]);
  Result := Driver.COFreezeEvents(Freeze);
  Logger.Debug('ToleFiscalPrinter.COFreezeEvents', [Freeze], Result);
  Unlock;
end;

function ToleFiscalPrinter.GetPropertyNumber(PropIndex: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.GetPropertyNumber', [
    GetFptrPropertyName(PropIndex)]);
  Result := Driver.GetPropertyNumber(PropIndex);
  Logger.Debug('ToleFiscalPrinter.GetPropertyNumber', [
    GetFptrPropertyName(PropIndex)], Result);
  Unlock;
end;

procedure ToleFiscalPrinter.SetPropertyNumber(PropIndex: Integer; Number: Integer);
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.SetPropertyNumber', [
    GetFptrPropertyName(PropIndex), Number]);
  Driver.SetPropertyNumber(PropIndex, Number);
  Logger.Debug('ToleFiscalPrinter.SetPropertyNumber: OK');
  Unlock;
end;

function ToleFiscalPrinter.GetPropertyString(PropIndex: Integer): WideString;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.GetPropertyString', [
    GetFptrPropertyName(PropIndex)]);
  Result := Driver.GetPropertyString(PropIndex);
  Result := EncodeString(Result);
  Logger.Debug('ToleFiscalPrinter.GetPropertyString', [
    GetFptrPropertyName(PropIndex)], Result);
  Unlock;
end;

procedure ToleFiscalPrinter.SetPropertyString(
  PropIndex: Integer;
  const AText: WideString);
var
  Text: WideString;
begin
  Lock;
  Text := DecodeString(AText);
  Logger.Debug('ToleFiscalPrinter.SetPropertyString', [
    GetFptrPropertyName(PropIndex), Text]);
  Driver.SetPropertyString(PropIndex, Text);
  Logger.Debug('ToleFiscalPrinter.SetPropertyString: OK');
  Unlock;
end;

function ToleFiscalPrinter.CloseService: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.CloseService');
  Result := Driver.CloseService;
  Logger.Debug('ToleFiscalPrinter.CloseService', Result);
  Logger.CloseFile;
  Unlock;
end;

function ToleFiscalPrinter.CheckHealth(Level: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.CheckHealth', [Level]);
  Result := Driver.CheckHealth(Level);
  Logger.Debug('ToleFiscalPrinter.CheckHealth', [Level], Result);
  Unlock;
end;

function ToleFiscalPrinter.ClaimDevice(Timeout: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.ClaimDevice', [Timeout]);
  Result := Driver.ClaimDevice(Timeout);
  Logger.Debug('ToleFiscalPrinter.ClaimDevice', [Timeout], Result);
  Unlock;
end;

function ToleFiscalPrinter.ClearOutput: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.ClearOutput');
  Result := Driver.ClearOutput;
  Logger.Debug('ToleFiscalPrinter.ClearOutput', Result);
  Unlock;
end;

function ToleFiscalPrinter.DirectIO(Command: Integer; var pData: Integer;
var pString: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.DirectIO', [Command, pData, pString]);
  Result := Driver.DirectIO(Command, pData, pString);
  Logger.Debug('ToleFiscalPrinter.DirectIO', [Command, pData, pString], Result);
  Unlock;
end;

function ToleFiscalPrinter.ReleaseDevice: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.ReleaseDevice');
  Result := Driver.ReleaseDevice;
  Logger.Debug('ToleFiscalPrinter.ReleaseDevice', Result);
  Unlock;
end;

function ToleFiscalPrinter.BeginFiscalDocument(DocumentAmount: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.BeginFiscalDocument', [DocumentAmount]);
  Result := Driver.BeginFiscalDocument(DocumentAmount);
  Logger.Debug('ToleFiscalPrinter.BeginFiscalDocument', [DocumentAmount], Result);
  Unlock;
end;

function ToleFiscalPrinter.BeginFiscalReceipt(PrintHeader: WordBool): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.BeginFiscalReceipt', [PrintHeader]);
  Result := Driver.BeginFiscalReceipt(PrintHeader);
  Logger.Debug('ToleFiscalPrinter.BeginFiscalReceipt', [PrintHeader], Result);
  Unlock;
end;

function ToleFiscalPrinter.BeginFixedOutput(Station: Integer;
  DocumentType: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.BeginFixedOutput', [Station, DocumentType]);
  Result := Driver.BeginFixedOutput(Station, DocumentType);
  Logger.Debug('ToleFiscalPrinter.BeginFixedOutput', [Station, DocumentType], Result);
  Unlock;
end;

function ToleFiscalPrinter.BeginInsertion(Timeout: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.BeginInsertion', [Timeout]);
  Result := Driver.BeginInsertion(Timeout);
  Logger.Debug('ToleFiscalPrinter.BeginInsertion', [Timeout], Result);
  Unlock;
end;

function ToleFiscalPrinter.BeginItemList(VatID: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.BeginItemList', [VatID]);
  Result := Driver.BeginItemList(VatID);
  Logger.Debug('ToleFiscalPrinter.BeginItemList', [VatID], Result);
  Unlock;
end;

function ToleFiscalPrinter.BeginNonFiscal: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.BeginNonFiscal');
  Result := Driver.BeginNonFiscal;
  Logger.Debug('ToleFiscalPrinter.BeginNonFiscal', Result);
  Unlock;
end;

function ToleFiscalPrinter.BeginRemoval(Timeout: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.BeginRemoval', [Timeout]);
  Result := Driver.BeginRemoval(Timeout);
  Logger.Debug('ToleFiscalPrinter.BeginRemoval', [Timeout], Result);
  Unlock;
end;

function ToleFiscalPrinter.BeginTraining: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.BeginTraining');
  Result := Driver.BeginTraining;
  Logger.Debug('ToleFiscalPrinter.BeginTraining', Result);
  Unlock;
end;

function ToleFiscalPrinter.ClearError: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.ClearError');
  Result := Driver.ClearError;
  Logger.Debug('ToleFiscalPrinter.ClearError', Result);
  Unlock;
end;

function ToleFiscalPrinter.EndFiscalDocument: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.EndFiscalDocument');
  Result := Driver.EndFiscalDocument;
  Logger.Debug('ToleFiscalPrinter.EndFiscalDocument', Result);
  Unlock;
end;

function ToleFiscalPrinter.EndFiscalReceipt(PrintHeader: WordBool): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.EndFiscalReceipt', [PrintHeader]);
  Result := Driver.EndFiscalReceipt(PrintHeader);
  Logger.Debug('ToleFiscalPrinter.EndFiscalReceipt', [PrintHeader], Result);
  Unlock;
end;

function ToleFiscalPrinter.EndFixedOutput: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.EndFixedOutput');
  Result := Driver.EndFixedOutput;
  Logger.Debug('ToleFiscalPrinter.EndFixedOutput', Result);
  Unlock;
end;

function ToleFiscalPrinter.EndInsertion: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.EndInsertion');
  Result := Driver.EndInsertion;
  Logger.Debug('ToleFiscalPrinter.EndInsertion', Result);
  Unlock;
end;

function ToleFiscalPrinter.EndItemList: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.EndItemList');
  Result := Driver.EndItemList;
  Logger.Debug('ToleFiscalPrinter.EndItemList', Result);
  Unlock;
end;

function ToleFiscalPrinter.EndNonFiscal: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.EndNonFiscal');
  Result := Driver.EndNonFiscal;
  Logger.Debug('ToleFiscalPrinter.EndNonFiscal', Result);
  Unlock;
end;

function ToleFiscalPrinter.EndRemoval: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.EndRemoval');
  Result := Driver.EndRemoval;
  Logger.Debug('ToleFiscalPrinter.EndRemoval', Result);
  Unlock;
end;

function ToleFiscalPrinter.EndTraining: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.EndTraining');
  Result := Driver.EndTraining;
  Logger.Debug('ToleFiscalPrinter.EndTraining', Result);
  Unlock;
end;

function ToleFiscalPrinter.GetData(DataItem: Integer; out OptArgs: Integer;
  out Data: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.GetData', [DataItem, OptArgs, Data]);
  Result := Driver.GetData(DataItem, OptArgs, Data);
  Data := EncodeString(Data);
  Logger.Debug('ToleFiscalPrinter.GetData', [DataItem, OptArgs, Data], Result);
  Unlock;
end;

function ToleFiscalPrinter.GetDate(out Date: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.GetDate');
  Result := Driver.GetDate(Date);
  Date := EncodeString(Date);
  Logger.Debug('ToleFiscalPrinter.GetDate', [Date], Result);
  Unlock;
end;

function ToleFiscalPrinter.GetTotalizer(VatID: Integer; OptArgs: Integer;
  out Data: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.GetTotalizer', [VatID, OptArgs]);
  Result := Driver.GetTotalizer(VatID, OptArgs, Data);
  Data := EncodeString(Data);
  Logger.Debug('ToleFiscalPrinter.GetTotalizer', [VatID, OptArgs, Data], Result);
  Unlock;
end;

function ToleFiscalPrinter.GetVatEntry(VatID: Integer; OptArgs: Integer;
  out VatRate: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.GetVatEntry', [VatID, OptArgs]);
  Result := Driver.GetVatEntry(VatID, OptArgs, VatRate);
  Logger.Debug('ToleFiscalPrinter.GetVatEntry', [VatID, OptArgs, VatRate], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintDuplicateReceipt: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintDuplicateReceipt');
  Result := Driver.PrintDuplicateReceipt;
  Logger.Debug('ToleFiscalPrinter.PrintDuplicateReceipt', Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintFiscalDocumentLine(
  const DocumentLine: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintFiscalDocumentLine', [DocumentLine]);
  Result := Driver.PrintFiscalDocumentLine(DocumentLine);
  Logger.Debug('ToleFiscalPrinter.PrintFiscalDocumentLine', [DocumentLine], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintFixedOutput(DocumentType: Integer;
  LineNumber: Integer; const Data: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintFixedOutput', [DocumentType, LineNumber, Data]);
  Result := Driver.PrintFixedOutput(DocumentType, LineNumber, Data);
  Logger.Debug('ToleFiscalPrinter.PrintFixedOutput', [DocumentType, LineNumber, Data], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintNormal(
  Station: Integer;
  const AData: WideString): Integer;
var
  Data: WideString;
begin
  Lock;
  Data := DecodeString(AData);
  Logger.Debug('ToleFiscalPrinter.PrintNormal', [Station, Data]);
  Result := Driver.PrintNormal(Station, Data);
  Logger.Debug('ToleFiscalPrinter.PrintNormal', [Station, Data], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintPeriodicTotalsReport(
  const Date1: WideString; const Date2: WideString): Integer;
var
  ADate1: WideString;
  ADate2: WideString;
begin
  Lock;
  ADate1 := DecodeString(Date1);
  ADate2 := DecodeString(Date2);
  Logger.Debug('ToleFiscalPrinter.PrintPeriodicTotalsReport', [ADate1, ADate2]);
  Result := Driver.PrintPeriodicTotalsReport(ADate1, ADate2);
  Logger.Debug('ToleFiscalPrinter.PrintPeriodicTotalsReport', [ADate1, ADate2], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintPowerLossReport: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintPowerLossReport');
  Result := Driver.PrintPowerLossReport;
  Logger.Debug('ToleFiscalPrinter.PrintPowerLossReport', Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecMessage(const AMessage: WideString): Integer;
var
  Message: WideString;
begin
  Lock;
  Message := DecodeString(AMessage);
  Logger.Debug('ToleFiscalPrinter.PrintRecMessage', [Message]);
  Result := Driver.PrintRecMessage(Message);
  Logger.Debug('ToleFiscalPrinter.PrintRecMessage', [Message], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecNotPaid(const ADescription: WideString;
  Amount: Currency): Integer;
var
  Description: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecNotPaid', [Description, Amount]);
  Result := Driver.PrintRecNotPaid(Description, Amount);
  Logger.Debug('ToleFiscalPrinter.PrintRecNotPaid', [Description, Amount], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecRefund(const ADescription: WideString;
  Amount: Currency; VatInfo: Integer): Integer;
var
  Description: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecRefund', [Description, Amount, VatInfo]);
  Result := Driver.PrintRecRefund(Description, Amount, VatInfo);
  Logger.Debug('ToleFiscalPrinter.PrintRecRefund', [Description, Amount, VatInfo], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecSubtotal(Amount: Currency): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintRecSubtotal', [Amount]);
  Result := Driver.PrintRecSubtotal(Amount);
  Logger.Debug('ToleFiscalPrinter.PrintRecSubtotal', [Amount], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecTotal(Total: Currency;
  Payment: Currency; const ADescription: WideString): Integer;
var
  Description: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecTotal', [Total, Payment, Description]);
  Result := Driver.PrintRecTotal(Total, Payment, Description);
  Logger.Debug('ToleFiscalPrinter.PrintRecTotal', [Total, Payment, Description], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecVoid(const ADescription: WideString): Integer;
var
  Description: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecVoid', [Description]);
  Result := Driver.PrintRecVoid(Description);
  Logger.Debug('ToleFiscalPrinter.PrintRecVoid', [Description], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintReport(ReportType: Integer;
  const AStartNum: WideString; const AEndNum: WideString): Integer;
var
  EndNum: WideString;
  StartNum: WideString;
begin
  Lock;
  EndNum := DecodeString(AEndNum);
  StartNum := DecodeString(AStartNum);
  Logger.Debug('ToleFiscalPrinter.PrintReport', [ReportType, StartNum, EndNum]);
  Result := Driver.PrintReport(ReportType, StartNum, EndNum);
  Logger.Debug('ToleFiscalPrinter.PrintReport', [ReportType, StartNum, EndNum], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintXReport: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintXReport');
  Result := Driver.PrintXReport;
  Logger.Debug('ToleFiscalPrinter.PrintXReport', Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintZReport: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintZReport');
  Result := Driver.PrintZReport;
  Logger.Debug('ToleFiscalPrinter.PrintZReport', Result);
  Unlock;
end;

function ToleFiscalPrinter.ResetPrinter: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.ResetPrinter');
  Result := Driver.ResetPrinter;
  Logger.Debug('ToleFiscalPrinter.ResetPrinter', Result);
  Unlock;
end;

function ToleFiscalPrinter.SetDate(const ADate: WideString): Integer;
var
  Date: WideString;
begin
  Lock;
  Date := DecodeString(ADate);
  Logger.Debug('ToleFiscalPrinter.SetDate', [Date]);
  Result := Driver.SetDate(Date);
  Logger.Debug('ToleFiscalPrinter.SetDate', [Date], Result);
  Unlock;
end;

function ToleFiscalPrinter.SetHeaderLine(
  LineNumber: Integer;
  const AText: WideString;
  DoubleWidth: WordBool): Integer;
var
  Text: WideString;
begin
  Lock;
  Text := DecodeString(AText);
  Logger.Debug('ToleFiscalPrinter.SetHeaderLine', [LineNumber, Text, DoubleWidth]);
  Result := Driver.SetHeaderLine(LineNumber, Text, DoubleWidth);
  Logger.Debug('ToleFiscalPrinter.SetHeaderLine', [LineNumber, Text, DoubleWidth], Result);
  Unlock;
end;

function ToleFiscalPrinter.SetPOSID(
  const APOSID: WideString;
  const ACashierID: WideString): Integer;
var
  POSID: WideString;
  CashierID: WideString;
begin
  Lock;
  POSID := DecodeString(APOSID);
  CashierID := DecodeString(ACashierID);
  Logger.Debug('ToleFiscalPrinter.SetPOSID', [POSID, CashierID]);
  Result := Driver.SetPOSID(POSID, CashierID);
  Logger.Debug('ToleFiscalPrinter.SetPOSID', [POSID, CashierID], Result);
  Unlock;
end;

function ToleFiscalPrinter.SetStoreFiscalID(const ID: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.SetStoreFiscalID', [ID]);
  Result := Driver.SetStoreFiscalID(ID);
  Logger.Debug('ToleFiscalPrinter.SetStoreFiscalID', [ID], Result);
  Unlock;
end;

function ToleFiscalPrinter.SetTrailerLine(
  LineNumber: Integer;
  const AText: WideString;
  DoubleWidth: WordBool): Integer;
var
  Text: WideString;
begin
  Lock;
  Text := DecodeString(AText);
  Logger.Debug('ToleFiscalPrinter.SetTrailerLine', [LineNumber, Text, DoubleWidth]);
  Result := Driver.SetTrailerLine(LineNumber, Text, DoubleWidth);
  Logger.Debug('ToleFiscalPrinter.SetTrailerLine', [LineNumber, Text, DoubleWidth], Result);
  Unlock;
end;

function ToleFiscalPrinter.SetVatTable: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.SetVatTable');
  Result := Driver.SetVatTable;
  Logger.Debug('ToleFiscalPrinter.SetVatTable', Result);
  Unlock;
end;

function ToleFiscalPrinter.SetVatValue(
  VatID: Integer;
  const AVatValue: WideString): Integer;
var
  VatValue: WideString;
begin
  Lock;
  VatValue := DecodeString(AVatValue);
  Logger.Debug('ToleFiscalPrinter.SetVatValue', [VatID, VatValue]);
  Result := Driver.SetVatValue(VatID, VatValue);
  Logger.Debug('ToleFiscalPrinter.SetVatValue', [VatID, VatValue], Result);
  Unlock;
end;

function ToleFiscalPrinter.VerifyItem(
  const AItemName: WideString;
  VatID: Integer): Integer;
var
  ItemName: WideString;
begin
  Lock;
  ItemName := DecodeString(AItemName);
  Logger.Debug('ToleFiscalPrinter.VerifyItem', [ItemName, VatID]);
  Result := Driver.VerifyItem(ItemName, VatID);
  Logger.Debug('ToleFiscalPrinter.VerifyItem', [ItemName, VatID], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecCash(Amount: Currency): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintRecCash', [Amount]);
  Result := Driver.PrintRecCash(Amount);
  Logger.Debug('ToleFiscalPrinter.PrintRecCash', [Amount], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
  const AVatAdjustment: WideString): Integer;
var
  VatAdjustment: WideString;
begin
  Lock;
  VatAdjustment := DecodeString(AVatAdjustment);
  Logger.Debug('ToleFiscalPrinter.PrintRecPackageAdjustVoid', [
    AdjustmentType, VatAdjustment]);
  Result := Driver.PrintRecPackageAdjustVoid(AdjustmentType, VatAdjustment);
  Logger.Debug('ToleFiscalPrinter.PrintRecPackageAdjustVoid', [
    AdjustmentType, VatAdjustment], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecRefundVoid(const ADescription: WideString;
  Amount: Currency; VatInfo: Integer): Integer;
var
  Description: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecRefundVoid', [Description, Amount, VatInfo]);
  Result := Driver.PrintRecRefundVoid(Description, Amount, VatInfo);
  Logger.Debug('ToleFiscalPrinter.PrintRecRefundVoid', [Description, Amount, VatInfo], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecSubtotalAdjustVoid(AdjustmentType: Integer;
  Amount: Currency): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.PrintRecSubtotalAdjustVoid', [AdjustmentType, Amount]);
  Result := Driver.PrintRecSubtotalAdjustVoid(AdjustmentType, Amount);
  Logger.Debug('ToleFiscalPrinter.PrintRecSubtotalAdjustVoid', [AdjustmentType, Amount], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecTaxID(const ATaxID: WideString): Integer;
var
  TaxID: WideString;
begin
  Lock;
  TaxID := DecodeString(ATaxID);
  Logger.Debug('ToleFiscalPrinter.PrintRecTaxID', [TaxID]);
  Result := Driver.PrintRecTaxID(TaxID);
  Logger.Debug('ToleFiscalPrinter.PrintRecTaxID', [TaxID], Result);
  Unlock;
end;

function ToleFiscalPrinter.SetCurrency(NewCurrency: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.SetCurrency', [NewCurrency]);
  Result := Driver.SetCurrency(NewCurrency);
  Logger.Debug('ToleFiscalPrinter.SetCurrency', [NewCurrency], Result);
  Unlock;
end;

function ToleFiscalPrinter.GetOpenResult: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.GetOpenResult');
  Result := Driver.GetOpenResult;
  Logger.Debug('ToleFiscalPrinter.GetOpenResult', Result);
  Unlock;
end;

function ToleFiscalPrinter.Close: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.Close');
  Result := Driver.Close;
  Logger.Debug('ToleFiscalPrinter.Close', Result);
  Unlock;
end;

function ToleFiscalPrinter.Claim(Timeout: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.Claim', [Timeout]);
  Result := Driver.Claim(Timeout);
  Logger.Debug('ToleFiscalPrinter.Claim', [Timeout], Result);
  Unlock;
end;

function ToleFiscalPrinter.Release1: Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.Release1');
  Result := Driver.Release1;
  Logger.Debug('ToleFiscalPrinter.Release1', Result);
  Unlock;
end;

function ToleFiscalPrinter.ResetStatistics(
  const AStatisticsBuffer: WideString): Integer;
var
  StatisticsBuffer: WideString;
begin
  Lock;
  StatisticsBuffer := DecodeString(AStatisticsBuffer);
  Logger.Debug('ToleFiscalPrinter.ResetStatistics', [StatisticsBuffer]);
  Result := Driver.ResetStatistics(StatisticsBuffer);
  Logger.Debug('ToleFiscalPrinter.ResetStatistics', [StatisticsBuffer], Result);
  Unlock;
end;

function ToleFiscalPrinter.RetrieveStatistics(
  var pStatisticsBuffer: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.RetrieveStatistics', [pStatisticsBuffer]);
  Result := Driver.RetrieveStatistics(pStatisticsBuffer);
  pStatisticsBuffer := EncodeString(pStatisticsBuffer);
  Logger.Debug('ToleFiscalPrinter.RetrieveStatistics', [pStatisticsBuffer], Result);
  Unlock;
end;

function ToleFiscalPrinter.UpdateStatistics(
  const AStatisticsBuffer: WideString): Integer;
var
  StatisticsBuffer: WideString;
begin
  Lock;
  StatisticsBuffer := DecodeString(AStatisticsBuffer);
  Logger.Debug('ToleFiscalPrinter.UpdateStatistics', [StatisticsBuffer]);
  Result := Driver.UpdateStatistics(StatisticsBuffer);
  Logger.Debug('ToleFiscalPrinter.UpdateStatistics', [StatisticsBuffer], Result);
  Unlock;
end;

function ToleFiscalPrinter.CompareFirmwareVersion(
  const AFirmwareFileName: WideString;
  out pResult: Integer): Integer;
var
  FirmwareFileName: WideString;
begin
  Lock;
  FirmwareFileName := DecodeString(AFirmwareFileName);
  Logger.Debug('ToleFiscalPrinter.CompareFirmwareVersion', [FirmwareFileName, pResult]);
  Result := Driver.CompareFirmwareVersion(FirmwareFileName, pResult);
  Logger.Debug('ToleFiscalPrinter.CompareFirmwareVersion', [FirmwareFileName, pResult], Result);
  Unlock;
end;

function ToleFiscalPrinter.UpdateFirmware(
  const AFirmwareFileName: WideString): Integer;
var
  FirmwareFileName: WideString;
begin
  Lock;
  FirmwareFileName := DecodeString(AFirmwareFileName);
  Logger.Debug('ToleFiscalPrinter.UpdateFirmware', [FirmwareFileName]);
  Result := Driver.UpdateFirmware(FirmwareFileName);
  Logger.Debug('ToleFiscalPrinter.UpdateFirmware', [FirmwareFileName], Result);
  Unlock;
end;

function ToleFiscalPrinter.Open(const DeviceClass, DeviceName: WideString;
  const pDispatch: IDispatch): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.Open', [DeviceClass, DeviceName]);
  Result := Driver.Open(DeviceClass, DeviceName, pDispatch);
  Logger.Debug('ToleFiscalPrinter.Open', [DeviceClass, DeviceName], Result);
  Unlock;
end;

function ToleFiscalPrinter.OpenService(const DeviceClass,
  DeviceName: WideString; const pDispatch: IDispatch): Integer;
begin
  Lock;
  Logger.Debug('ToleFiscalPrinter.OpenService', [DeviceClass, DeviceName]);
  Result := Driver.OpenService(DeviceClass, DeviceName, pDispatch);
  Logger.Debug('ToleFiscalPrinter.OpenService', [DeviceClass, DeviceName], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecItem(
  const ADescription: WideString;
  Price: Currency;
  Quantity, VatInfo: Integer;
  UnitPrice: Currency;
  const AUnitName: WideString): Integer;
var
  UnitName: WideString;
  Description: WideString;
begin
  Lock;

  UnitName := DecodeString(AUnitName);
  Description := DecodeString(ADescription);

  Logger.Debug('ToleFiscalPrinter.PrintRecItem', [Description, Price,
    Quantity, VatInfo, UnitPrice, UnitName]);
  Result := Driver.PrintRecItem(Description, Price, Quantity, VatInfo,
    UnitPrice, UnitName);
  Logger.Debug('ToleFiscalPrinter.PrintRecItem', [Description, Price,
    Quantity, VatInfo, UnitPrice, UnitName], Result);

  Unlock;
end;

function ToleFiscalPrinter.PrintRecItemAdjustment(AdjustmentType: Integer;
  const ADescription: WideString; Amount: Currency;
  VatInfo: Integer): Integer;
var
  Description: WideString;
begin
  Lock;

  Description := DecodeString(ADescription);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemAdjustment', [
    AdjustmentType, Description, Amount, VatInfo]);

  Result := Driver.PrintRecItemAdjustment(
    AdjustmentType, Description, Amount, VatInfo);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemAdjustment', [
    AdjustmentType, Description, Amount, VatInfo], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecItemAdjustmentVoid(
  AdjustmentType: Integer;
  const ADescription: WideString;
  Amount: Currency;
  VatInfo: Integer): Integer;
var
  Description: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecItemAdjustmentVoid', [
    AdjustmentType, Description, Amount, VatInfo]);

  Result := Driver.PrintRecItemAdjustmentVoid(
    AdjustmentType, Description, Amount, VatInfo);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemAdjustmentVoid', [
    AdjustmentType, Description, Amount, VatInfo], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecItemFuel(
  const ADescription: WideString;
  Price: Currency;
  Quantity, VatInfo: Integer;
  UnitPrice: Currency;
  const AUnitName: WideString;
  SpecialTax: Currency;
  const ASpecialTaxName: WideString): Integer;
var
  UnitName: WideString;
  Description: WideString;
  SpecialTaxName: WideString;
begin
  Lock;

  UnitName := DecodeString(AUnitName);
  Description := DecodeString(ADescription);
  SpecialTaxName := DecodeString(ASpecialTaxName);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemFuel', [Description, Price, Quantity,
    VatInfo, UnitPrice, UnitName, SpecialTax, SpecialTaxName]);

  Result := Driver.PrintRecItemFuel(Description, Price, Quantity,
    VatInfo, UnitPrice, UnitName, SpecialTax, SpecialTaxName);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemFuel', [Description, Price, Quantity,
    VatInfo, UnitPrice, UnitName, SpecialTax, SpecialTaxName], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecItemFuelVoid(
  const ADescription: WideString;
  Price: Currency;
  VatInfo: Integer;
  SpecialTax: Currency): Integer;
var
  Description: WideString;
begin
  Lock;

  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecItemFuelVoid', [
    Description, Price, VatInfo, SpecialTax]);

  Result := Driver.PrintRecItemFuelVoid(
    Description, Price, VatInfo, SpecialTax);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemFuelVoid', [
    Description, Price, VatInfo, SpecialTax], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecItemRefund(
  const ADescription: WideString;
  Amount: Currency;
  Quantity, VatInfo: Integer;
  UnitAmount: Currency;
  const AUnitName: WideString): Integer;
var
  UnitName: WideString;
  Description: WideString;
begin
  Lock;
  UnitName := DecodeString(AUnitName);
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecItemRefund', [
    Description, Amount, Quantity, VatInfo, UnitAmount, UnitName]);

  Result := Driver.PrintRecItemRefund(
    Description, Amount, Quantity, VatInfo, UnitAmount, UnitName);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemRefund', [
    Description, Amount, Quantity, VatInfo, UnitAmount, UnitName], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecItemRefundVoid(
  const ADescription: WideString;
  Amount: Currency;
  Quantity, VatInfo: Integer;
  UnitAmount: Currency;
  const AUnitName: WideString): Integer;
var
  UnitName: WideString;
  Description: WideString;
begin
  Lock;
  UnitName := DecodeString(AUnitName);
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecItemRefundVoid', [
    Description, Amount, Quantity, VatInfo, UnitAmount, UnitName]);

  Result := Driver.PrintRecItemRefundVoid(
    Description, Amount, Quantity, VatInfo, UnitAmount, UnitName);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemRefundVoid', [
    Description, Amount, Quantity, VatInfo, UnitAmount, UnitName], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecItemVoid(
  const ADescription: WideString;
  Price: Currency;
  Quantity, VatInfo: Integer;
  UnitPrice: Currency;
  const AUnitName: WideString): Integer;
var
  UnitName: WideString;
  Description: WideString;
begin
  Lock;
  UnitName := DecodeString(AUnitName);
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecItemVoid', [
    Description, Price, Quantity, VatInfo, UnitPrice, UnitName]);

  Result := Driver.PrintRecItemVoid(
    Description, Price, Quantity, VatInfo, UnitPrice, UnitName);

  Logger.Debug('ToleFiscalPrinter.PrintRecItemVoid', [
    Description, Price, Quantity, VatInfo, UnitPrice, UnitName], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecPackageAdjustment(
  AdjustmentType: Integer;
  const ADescription, AVatAdjustment: WideString): Integer;
var
  Description: WideString;
  VatAdjustment: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  VatAdjustment := DecodeString(AVatAdjustment);

  Logger.Debug('ToleFiscalPrinter.PrintRecPackageAdjustment', [
    AdjustmentType, Description, VatAdjustment]);

  Result := Driver.PrintRecPackageAdjustment(
    AdjustmentType, Description, VatAdjustment);

  Logger.Debug('ToleFiscalPrinter.PrintRecPackageAdjustment', [
    AdjustmentType, Description, VatAdjustment], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecSubtotalAdjustment(
  AdjustmentType: Integer;
  const ADescription: WideString;
  Amount: Currency): Integer;
var
  Description: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecSubtotalAdjustment', [
    AdjustmentType, Description, Amount]);

  Result := Driver.PrintRecSubtotalAdjustment(
    AdjustmentType, Description, Amount);

  Logger.Debug('ToleFiscalPrinter.PrintRecSubtotalAdjustment', [
    AdjustmentType, Description, Amount], Result);
  Unlock;
end;

function ToleFiscalPrinter.PrintRecVoidItem(
  const ADescription: WideString;
  Amount: Currency;
  Quantity, AdjustmentType: Integer;
  Adjustment: Currency;
  VatInfo: Integer): Integer;
var
  Description: WideString;
begin
  Lock;
  Description := DecodeString(ADescription);
  Logger.Debug('ToleFiscalPrinter.PrintRecVoidItem', [Description, Amount, Quantity,
    AdjustmentType, Adjustment, VatInfo]);

  Result := Driver.PrintRecVoidItem(Description, Amount, Quantity,
    AdjustmentType, Adjustment, VatInfo);

  Logger.Debug('ToleFiscalPrinter.PrintRecVoidItem', [Description, Amount, Quantity,
    AdjustmentType, Adjustment, VatInfo], Result);
  Unlock;
end;

initialization
  SetTranslationLanguage;
  DecimalSeparator := '.';
  ComServer.SetServerName('OposShtrih');
  TAutoObjectFactory.Create(ComServer, ToleFiscalPrinter, Class_FiscalPrinter,
    ciMultiInstance, tmApartment);

end.
