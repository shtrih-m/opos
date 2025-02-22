program SmFiscalPrinterTest;

uses
  FastMM4,
  Forms,
  TestFramework,
  GUITestRunner,
  LogFile in '..\..\Source\Shared\LogFile.pas',
  Opos in '..\..\Source\Opos\OPOS.pas',
  OposUtils in '..\..\Source\Opos\OposUtils.pas',
  OposEvents in '..\..\Source\Opos\OposEvents.pas',
  OposFptr in '..\..\Source\Opos\OposFptr.pas',
  OposFptrhi in '..\..\Source\Opos\OposFptrhi.pas',
  Oposhi in '..\..\Source\Opos\Oposhi.pas',
  OposStat in '..\..\Source\Opos\OposStat.pas',
  OposStatistics in '..\..\Source\Opos\OposStatistics.pas',
  OposSemaphore in '..\..\Source\Opos\OposSemaphore.pas',
  OposCash in '..\..\Source\Opos\OposCash.pas',
  OposCashhi in '..\..\Source\Opos\OposCashhi.pas',
  OposCashUtils in '..\..\Source\Opos\OposCashUtils.pas',
  OposPtr in '..\..\Source\Opos\OposPtr.pas',
  OposPtrhi in '..\..\Source\Opos\OposPtrhi.pas',
  OposPtrUtils in '..\..\Source\Opos\OposPtrUtils.pas',
  OposFptrUtils in '..\..\Source\Opos\OposFptrUtils.pas',
  OPOSException in '..\..\Source\Opos\OposException.pas',
  StatisticItem in '..\..\Source\SmFiscalPrinter\Units\StatisticItem.pas',
  FileUtils in '..\..\Source\Shared\FileUtils.pas',
  Semaphore in '..\..\Source\Opos\Semaphore.pas',
  uZintBarcode in '..\..\Source\SmFiscalPrinter\Units\uZintBarcode.pas',
  uZintInterface in '..\..\Source\SmFiscalPrinter\Units\uZintInterface.pas',
  PrinterTypes in '..\..\Source\SmFiscalPrinter\Units\PrinterTypes.pas',
  PrinterCommand in '..\..\Source\SmFiscalPrinter\Units\PrinterCommand.pas',
  BinStream in '..\..\Source\SmFiscalPrinter\Units\BinStream.pas',
  PrinterFrame in '..\..\Source\SmFiscalPrinter\Units\PrinterFrame.pas',
  SerialPorts in '..\..\Source\SmFiscalPrinter\Units\SerialPorts.pas',
  SerialPort in '..\..\Source\Shared\SerialPort.pas',
  DeviceNotification in '..\..\Source\SmFiscalPrinter\Units\DeviceNotification.pas',
  StringUtils in '..\..\Source\Shared\StringUtils.pas',
  ByteUtils in '..\..\Source\Shared\ByteUtils.pas',
  DeviceTables in '..\..\Source\SmFiscalPrinter\Units\DeviceTables.pas',
  PrinterTable in '..\..\Source\SmFiscalPrinter\Units\PrinterTable.pas',
  PrinterConnection in '..\..\Source\SmFiscalPrinter\Units\PrinterConnection.pas',
  DriverTypes in '..\..\Source\SmFiscalPrinter\Units\DriverTypes.pas',
  XmlReceiptWriter in '..\..\Source\SmFiscalPrinter\Units\XmlReceiptWriter.pas',
  XmlUtils in '..\..\Source\SmFiscalPrinter\Units\XmlUtils.pas',
  msxml in '..\..\Source\SmFiscalPrinter\Units\MSXML.pas',
  SmIniFile in '..\..\Source\SmFiscalPrinter\Units\SmIniFile.pas',
  XmlValue in '..\..\Source\SmFiscalPrinter\Units\XmlValue.pas',
  XMLParser in '..\..\Source\Shared\XMLParser.pas',
  BStrUtil in '..\..\Source\Shared\BStrUtil.pas',
  FiscalPrinterTypes in '..\..\Source\SmFiscalPrinter\Units\FiscalPrinterTypes.pas',
  FixedStrings in '..\..\Source\SmFiscalPrinter\Units\FixedStrings.pas',
  VersionInfo in '..\..\Source\Shared\VersionInfo.pas',
  PrinterModel in '..\..\Source\SmFiscalPrinter\Units\PrinterModel.pas',
  NotifyLink in '..\..\Source\SmFiscalPrinter\Units\NotifyLink.pas',
  TableParameter in '..\..\Source\SmFiscalPrinter\Units\TableParameter.pas',
  ParameterValue in '..\..\Source\SmFiscalPrinter\Units\ParameterValue.pas',
  XmlModelReader in '..\..\Source\SmFiscalPrinter\Units\XmlModelReader.pas',
  DefaultModel in '..\..\Source\SmFiscalPrinter\Units\DefaultModel.pas',
  CashDrawerParameters in '..\..\Source\SmFiscalPrinter\Units\CashDrawerParameters.pas',
  PrinterParameters in '..\..\Source\SmFiscalPrinter\Units\PrinterParameters.pas',
  PayType in '..\..\Source\SmFiscalPrinter\Units\PayType.pas',
  SmBarcode in '..\..\Source\SmFiscalPrinter\Units\SmBarcode.pas',
  DirectIOAPI in '..\..\Source\SmFiscalPrinter\Units\DirectIOAPI.pas',
  FiscalPrinterReceipt in '..\..\Source\SmFiscalPrinter\Units\FiscalPrinterReceipt.pas',
  FiscalPrinterState in '..\..\Source\SmFiscalPrinter\Units\FiscalPrinterState.pas',
  ShtrihFiscalPrinter in '..\..\Source\SmFiscalPrinter\Units\ShtrihFiscalPrinter.pas',
  untUtil in '..\..\Source\SmFiscalPrinter\Units\untUtil.pas',
  SmFiscalPrinterLib_TLB in '..\..\Source\SmFiscalPrinter\SmFiscalPrinterLib_TLB.pas',
  DCOMConnection in '..\..\Source\SmFiscalPrinter\Units\DCOMConnection.pas',
  FptrServerLib_TLB in '..\..\Source\SmFptrSrv\FptrServerLib_TLB.pas',
  DriverError in '..\..\Source\Shared\DriverError.pas',
  VSysUtils in '..\..\Source\SmFiscalPrinter\Units\VSysUtils.pas',
  SocketPort in '..\..\Source\SmFiscalPrinter\Units\SocketPort.pas',
  FiscalPrinterStatistics in '..\..\Source\SmFiscalPrinter\Units\FiscalPrinterStatistics.pas',
  ServiceVersion in '..\..\Source\Shared\ServiceVersion.pas',
  DeviceService in '..\..\Source\Shared\DeviceService.pas',
  OposServiceDevice19 in '..\..\Source\Opos\OposServiceDevice19.pas',
  NotifyThread in '..\..\Source\Shared\NotifyThread.pas',
  duSerialPort in 'Units\duSerialPort.pas',
  duXmlReceiptWriter in 'Units\duXmlReceiptWriter.pas',
  duSmIniFile in 'Units\duSmIniFile.pas',
  duIniFile in 'Units\duIniFile.pas',
  PrinterEncoding in '..\..\Source\Opos\PrinterEncoding.pas',
  EscFilter in '..\..\Source\SmFiscalPrinter\Units\EscFilter.pas',
  EscPrinter in '..\..\Source\SmFiscalPrinter\Units\EscPrinter.pas',
  MockSharedPrinter in 'Units\MockSharedPrinter.pas',
  SharedPrinterInterface in '..\..\Source\SmFiscalPrinter\Units\SharedPrinterInterface.pas',
  PrinterProtocol2 in '..\..\Source\SmFiscalPrinter\Units\PrinterProtocol2.pas',
  TextFiscalPrinterDevice in 'Units\TextFiscalPrinterDevice.pas',
  FiscalPrinterDevice in '..\..\Source\SmFiscalPrinter\Units\FiscalPrinterDevice.pas',
  OposEventsRCS in '..\..\Source\Opos\OposEventsRCS.pas',
  OposEventsNull in '..\..\Source\Opos\OposEventsNull.pas',
  AsBarcode in '..\..\Source\SmFiscalPrinter\Units\AsBarcode.pas',
  PrinterParametersIni in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersIni.pas',
  ZReport in '..\..\Source\SmFiscalPrinter\Units\ZReport.pas',
  ClassLogger in '..\..\Source\Shared\ClassLogger.pas',
  PrinterParametersX in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersX.pas',
  PrinterParametersRegIBT in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersRegIBT.pas',
  PrinterParametersReg in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersReg.pas',
  CommunicationError in '..\..\Source\Shared\CommunicationError.pas',
  DebugUtils in '..\..\Source\Shared\DebugUtils.pas',
  DIOHandler in '..\..\Source\Shared\DIOHandler.pas',
  CommandDef in '..\..\Source\Shared\CommandDef.pas',
  CommandParam in '..\..\Source\SmFiscalPrinter\Units\CommandParam.pas',
  ReceiptItem in '..\..\Source\SmFiscalPrinter\Units\ReceiptItem.pas',
  TextItem in '..\..\Source\SmFiscalPrinter\Units\TextItem.pas',
  EJReportParser in '..\..\Source\SmFiscalPrinter\Units\EJReportParser.pas',
  SimpleSocket in '..\..\Source\SmFiscalPrinter\Units\SimpleSocket.pas',
  MonitoringServer in '..\..\Source\SmFiscalPrinter\Units\MonitoringServer.pas',
  RecItem in '..\..\Source\SmFiscalPrinter\Units\RecItem.pas',
  UniposTank in '..\..\Source\SmFiscalPrinter\Units\UniposTank.pas',
  RegUtils in '..\..\Source\SmFiscalPrinter\Units\RegUtils.pas',
  TextMap in '..\..\Source\SmFiscalPrinter\Units\TextMap.pas',
  UniposFilter in '..\..\Source\SmFiscalPrinter\Units\UniposFilter.pas',
  UniposPrinter in '..\..\Source\SmFiscalPrinter\Units\UniposPrinter.pas',
  UniposReader in '..\..\Source\SmFiscalPrinter\Units\UniposReader.pas',
  AntiFroudFilter in '..\..\Source\SmFiscalPrinter\Units\AntiFroudFilter.pas',
  FuelRecFilter in '..\..\Source\SmFiscalPrinter\Units\FuelRecFilter.pas',
  MalinaCard in '..\..\Source\SmFiscalPrinter\Units\MalinaCard.pas',
  MalinaZReportFilter in '..\..\Source\SmFiscalPrinter\Units\MalinaZReportFilter.pas',
  MalinaParams in '..\..\Source\SmFiscalPrinter\Units\MalinaParams.pas',
  PawnTicketFilter in '..\..\Source\SmFiscalPrinter\Units\PawnTicketFilter.pas',
  MalinaPlugin in '..\..\Source\SmFiscalPrinter\Units\MalinaPlugin.pas',
  FptrFilter in '..\..\Source\SmFiscalPrinter\Units\FptrFilter.pas',
  GlobusReceipt in '..\..\Source\SmFiscalPrinter\Units\GlobusReceipt.pas',
  TextReceipt in '..\..\Source\SmFiscalPrinter\Units\TextReceipt.pas',
  DIOHandlers in '..\..\Source\Shared\DIOHandlers.pas',
  CachedSalesReceipt in '..\..\Source\SmFiscalPrinter\Units\CachedSalesReceipt.pas',
  fmuLogo in '..\..\Source\SmFiscalPrinter\Fmu\fmuLogo.pas' {fmLogo},
  TrainingReceiptPrinter in '..\..\Source\SmFiscalPrinter\Units\TrainingReceiptPrinter.pas',
  GlobusTextReceipt in '..\..\Source\SmFiscalPrinter\Units\GlobusTextReceipt.pas',
  oleCashDrawer in '..\..\Source\SmFiscalPrinter\Units\oleCashDrawer.pas',
  oleXmlParams in '..\..\Source\SmFiscalPrinter\Units\oleXmlParams.pas',
  oleFiscalPrinter in '..\..\Source\SmFiscalPrinter\Units\oleFiscalPrinter.pas',
  ElectronicJournal in '..\..\Source\SmFiscalPrinter\Units\ElectronicJournal.pas',
  FiscalPrinterImpl in '..\..\Source\SmFiscalPrinter\Units\FiscalPrinterImpl.pas',
  ReceiptPrinter in '..\..\Source\SmFiscalPrinter\Units\ReceiptPrinter.pas',
  SharedPrinter in '..\..\Source\SmFiscalPrinter\Units\SharedPrinter.pas',
  duFiscalPrinterDevice in 'Units\duFiscalPrinterDevice.pas',
  duEscPrinter in 'Units\duEscPrinter.pas',
  duPrinterParameters in 'Units\duPrinterParameters.pas',
  duPrinterEncoding in 'Units\duPrinterEncoding.pas',
  CustomReceipt in '..\..\Source\SmFiscalPrinter\Units\CustomReceipt.pas',
  CashInReceipt in '..\..\Source\SmFiscalPrinter\Units\CashInReceipt.pas',
  CashOutReceipt in '..\..\Source\SmFiscalPrinter\Units\CashOutReceipt.pas',
  FiscalReceiptPrinter in '..\..\Source\SmFiscalPrinter\Units\FiscalReceiptPrinter.pas',
  GenericReceipt in '..\..\Source\SmFiscalPrinter\Units\GenericReceipt.pas',
  SysUtilsTest in 'Units\SysUtilsTest.pas',
  PrinterDeviceFilter in '..\..\Source\SmFiscalPrinter\Units\PrinterDeviceFilter.pas',
  ReceiptReportFilter in '..\..\Source\SmFiscalPrinter\Units\ReceiptReportFilter.pas',
  MathUtils in '..\..\Source\Shared\MathUtils.pas',
  duRosneftSalesReceipt in 'Units\duRosneftSalesReceipt.pas',
  SettingsParams in '..\..\Source\SmFiscalPrinter\Units\SettingsParams.pas',
  TLV in '..\..\Source\SmFiscalPrinter\Units\TLV.pas',
  duDateTime in 'Units\duDateTime.pas',
  SalesReceipt in '..\..\Source\SmFiscalPrinter\Units\SalesReceipt.pas',
  fmuPhone in '..\..\Source\SmFiscalPrinter\Fmu\fmuPhone.pas' {fmPhone},
  RecDiscount in '..\..\Source\SmFiscalPrinter\Units\RecDiscount.pas',
  RosneftSalesReceipt in '..\..\Source\SmFiscalPrinter\Units\RosneftSalesReceipt.pas',
  duElectronicJournal in 'Units\duElectronicJournal.pas',
  duMalinaCard in 'Units\duMalinaCard.pas',
  duMalinaFilter in 'Units\duMalinaFilter.pas',
  duOposStatistics in 'Units\duOposStatistics.pas',
  duTankReader in 'Units\duTankReader.pas',
  duWideString in 'Units\duWideString.pas',
  TankReader in '..\..\Source\SmFiscalPrinter\Units\TankReader.pas',
  TankFilter in '..\..\Source\SmFiscalPrinter\Units\TankFilter.pas',
  duFSSalesReceipt in 'Units\duFSSalesReceipt.pas',
  TCPConnection in '..\..\Source\SmFiscalPrinter\Units\TCPConnection.pas',
  duDfmFile in 'Units\duDfmFile.pas',
  duReceiptTemplate in 'Units\duReceiptTemplate.pas',
  PortUtil in '..\..\Source\Shared\PortUtil.pas',
  TextReport in '..\..\Source\Shared\TextReport.pas',
  MockPrinterConnection2 in 'Units\MockPrinterConnection2.pas',
  duSemaphore in 'Units\duSemaphore.pas',
  fmuEMail in '..\..\Source\SmFiscalPrinter\Fmu\fmuEMail.pas' {fmEMail},
  fmuSelect in '..\..\Source\SmFiscalPrinter\Fmu\fmuSelect.pas' {fmSelect},
  duFiscalPrinter2 in 'Units\duFiscalPrinter2.pas',
  duICMPClient in 'Units\duICMPClient.pas',
  Retalix in '..\..\Source\SmFiscalPrinter\Units\Retalix.pas',
  MalinaFilter in '..\..\Source\SmFiscalPrinter\Units\MalinaFilter.pas',
  MockFiscalPrinterDevice in 'Units\MockFiscalPrinterDevice.pas',
  FormUtils in '..\..\Source\SmFiscalPrinter\Fmu\FormUtils.pas',
  NonfiscalDoc in '..\..\Source\SmFiscalPrinter\Units\NonfiscalDoc.pas',
  fmuTest in 'Units\fmuTest.pas' {fmTest},
  duUniposReader in 'Units\duUniposReader.pas',
  fmuTimeSync in '..\..\Source\SmFiscalPrinter\Fmu\fmuTimeSync.pas' {fmTimeSync},
  CorrectionReceipt2 in '..\..\Source\SmFiscalPrinter\Units\CorrectionReceipt2.pas',
  CsvPrinterTableFormat in '..\..\Source\SmFiscalPrinter\Units\CsvPrinterTableFormat.pas',
  PrinterTableFormat in '..\..\Source\SmFiscalPrinter\Units\PrinterTableFormat.pas',
  VatCode in '..\..\Source\SmFiscalPrinter\Units\VatCode.pas',
  FSService in '..\..\Source\SmFiscalPrinter\Units\FSService.pas',
  DriverContext in '..\..\Source\SmFiscalPrinter\Units\DriverContext.pas',
  ReceiptTemplate in '..\..\Source\SmFiscalPrinter\Units\ReceiptTemplate.pas',
  duRetalix in 'Units\duRetalix.pas',
  TextParser in '..\..\Source\SmFiscalPrinter\Units\TextParser.pas',
  PrinterPort in '..\..\Source\SmFiscalPrinter\Units\PrinterPort.pas',
  PrinterProtocol1 in '..\..\Source\SmFiscalPrinter\Units\PrinterProtocol1.pas',
  duTankFilter in 'Units\duTankFilter.pas',
  duCommandDefs in 'Units\duCommandDefs.pas',
  PrinterFonts in '..\..\Source\SmFiscalPrinter\Units\PrinterFonts.pas',
  SmResourceStrings in '..\..\Source\SmFiscalPrinter\Units\SmResourceStrings.pas',
  duSocketPort in 'Units\duSocketPort.pas',
  TLVTags in '..\..\Source\SmFiscalPrinter\Units\TLVTags.pas',
  TLVParser in '..\..\Source\SmFiscalPrinter\Units\TLVParser.pas',
  FSSalesReceipt in '..\..\Source\SmFiscalPrinter\Units\FSSalesReceipt.pas',
  GS1Barcode in '..\..\Source\SmFiscalPrinter\Units\GS1Barcode.pas',
  EkmClient in '..\..\Source\SmFiscalPrinter\Units\EkmClient.pas',
  duGS1Barcode in 'Units\duGS1Barcode.pas',
  RegressTests in 'Units\RegressTests.pas',
  duTLV in 'Units\duTLV.pas',
  WException in '..\..\Source\Shared\WException.pas',
  CorrectionReceipt in '..\..\Source\SmFiscalPrinter\Units\CorrectionReceipt.pas',
  TntIniFiles in '..\..\Source\Shared\TntIniFiles.pas',
  BaseForm in '..\..\Source\Shared\BaseForm.pas',
  TranslationUtil in '..\..\Source\SmFiscalPrinter\Units\TranslationUtil.pas',
  LangUtils in '..\..\Source\Shared\LangUtils.pas',
  duBitUtils in 'Units\duBitUtils.pas',
  duLogFile in 'Units\duLogFile.pas',
  RegExpr in '..\..\Source\Shared\RegExpr.pas',
  MockPrinterConnection in 'Units\MockPrinterConnection.pas',
  duFiscalPrinter in 'Units\duFiscalPrinter.pas';

{$R *.RES}
{$R ..\..\Source\SmFiscalPrinter\SmFiscalPrinter.TLB}

begin
  TGUITestRunner.RunTest(RegisteredTests);
end.
