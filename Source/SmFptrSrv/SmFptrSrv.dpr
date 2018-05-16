program SmFptrSrv;



uses
  Forms,
  Windows,
  SysUtils,
  FptrServerLib_TLB in 'FptrServerLib_TLB.pas',
  oleMain in 'Units\oleMain.pas' {FptrServer: CoClass},
  PortConnection in 'Units\PortConnection.pas',
  fmumain in 'FMU\fmumain.pas' {fmMain},
  SrvParams in 'Units\SrvParams.pas',
  TrayIcon in 'Units\TrayIcon.PAS',
  DcomUtils in 'Units\DcomUtils.pas',
  ScktComp in 'Units\ScktComp.pas',
  TCPServer in 'Units\TCPServer.pas',
  fmuAbout in 'FMU\fmuAbout.pas' {fmAbout},
  OposSemaphore in '..\Opos\OposSemaphore.pas',
  OposException in '..\Opos\OposException.pas',
  Opos in '..\Opos\Opos.pas',
  Oposhi in '..\Opos\Oposhi.pas',
  LogFile in '..\Shared\LogFile.pas',
  PrinterProtocol2 in '..\SmFiscalPrinter\Units\PrinterProtocol2.pas',
  VersionInfo in '..\Shared\VersionInfo.pas',
  PrinterFrame in '..\SmFiscalPrinter\Units\PrinterFrame.pas',
  DriverError in '..\Shared\DriverError.pas',
  CommunicationError in '..\Shared\CommunicationError.pas',
  ByteUtils in '..\Shared\ByteUtils.pas',
  PrinterConnection in '..\SmFiscalPrinter\Units\PrinterConnection.pas',
  PrinterCommand in '..\SmFiscalPrinter\Units\PrinterCommand.pas',
  PrinterTypes in '..\SmFiscalPrinter\Units\PrinterTypes.pas',
  PrinterModel in '..\SmFiscalPrinter\Units\PrinterModel.pas',
  BinStream in '..\SmScale\Units\BinStream.pas',
  PrinterTable in '..\SmFiscalPrinter\Units\PrinterTable.pas',
  FiscalPrinterTypes in '..\SmFiscalPrinter\Units\FiscalPrinterTypes.pas',
  DeviceTables in '..\SmFiscalPrinter\Units\DeviceTables.pas',
  DcomFactory in 'Units\DcomFactory.pas',
  OposFptr in '..\Opos\OposFptr.pas',
  DebugUtils in '..\Shared\DebugUtils.pas',
  XmlUtils in '..\SmFiscalPrinter\Units\XmlUtils.pas',
  DefaultModel in '..\SmFiscalPrinter\Units\DefaultModel.pas',
  DriverTypes in '..\SmFiscalPrinter\Units\DriverTypes.pas',
  TableParameter in '..\SmFiscalPrinter\Units\TableParameter.pas',
  ParameterValue in '..\SmFiscalPrinter\Units\ParameterValue.pas',
  XmlModelReader in '..\SmFiscalPrinter\Units\XmlModelReader.pas',
  FileUtils in '..\Shared\FileUtils.pas',
  BaseForm in '..\Shared\BaseForm.pas',
  ClassLogger in '..\Shared\ClassLogger.pas',
  dmuServer in 'FMU\dmuServer.pas' {dmServer: TDataModule},
  Session in 'Units\Session.pas',
  ScaleStatistics in '..\SmScale\Units\ScaleStatistics.pas',
  OposStat in '..\Opos\OposStat.pas',
  OposStatistics in '..\Opos\OposStatistics.pas',
  StatisticItem in '..\SmFiscalPrinter\Units\StatisticItem.pas',
  FiscalPrinterDevice in '..\SmFiscalPrinter\Units\FiscalPrinterDevice.pas',
  SerialPort in '..\Shared\SerialPort.pas',
  StringUtils in '..\Shared\StringUtils.pas',
  FiscalPrinterStatistics in '..\SmFiscalPrinter\Units\FiscalPrinterStatistics.pas',
  EJReportParser in '..\SmFiscalPrinter\Units\EJReportParser.pas',
  PrinterParameters in '..\SmFiscalPrinter\Units\PrinterParameters.pas',
  PayType in '..\SmFiscalPrinter\Units\PayType.pas',
  DeviceNotification in '..\SmFiscalPrinter\Units\DeviceNotification.pas',
  uZintBarcode in '..\SmFiscalPrinter\Units\uZintBarcode.pas',
  uZintInterface in '..\SmFiscalPrinter\Units\uZintInterface.pas',
  OposFptrhi in '..\Opos\OposFptrhi.pas',
  DirectIOAPI in '..\SmFiscalPrinter\Units\DirectIOAPI.pas',
  FixedStrings in '..\SmFiscalPrinter\Units\FixedStrings.pas',
  NotifyLink in '..\SmFiscalPrinter\Units\NotifyLink.pas',
  PrinterDeviceFilter in '..\SmFiscalPrinter\Units\PrinterDeviceFilter.pas',
  PortUtil in '..\Shared\PortUtil.pas',
  TextReport in '..\Shared\TextReport.pas',
  OposUtils in '..\Opos\OposUtils.pas',
  TLV in '..\SmFiscalPrinter\Units\TLV.pas',
  CsvPrinterTableFormat in '..\SmFiscalPrinter\Units\CsvPrinterTableFormat.pas',
  PrinterTableFormat in '..\SmFiscalPrinter\Units\PrinterTableFormat.pas',
  OposFptrUtils in '..\Opos\OposFptrUtils.pas',
  VatCode in '..\SmFiscalPrinter\Units\VatCode.pas',
  MalinaParams in '..\SmFiscalPrinter\Units\MalinaParams.pas',
  TextMap in '..\SmFiscalPrinter\Units\TextMap.pas',
  RegUtils in '..\SmFiscalPrinter\Units\RegUtils.pas',
  DriverContext in '..\SmFiscalPrinter\Units\DriverContext.pas',
  PrinterProtocol1 in '..\SmFiscalPrinter\Units\PrinterProtocol1.pas',
  PrinterPort in '..\SmFiscalPrinter\Units\PrinterPort.pas',
  PrinterFonts in '..\SmFiscalPrinter\Units\PrinterFonts.pas',
  TLVTags in '..\SmFiscalPrinter\Units\TLVTags.pas',
  TLVParser in '..\SmFiscalPrinter\Units\TLVParser.pas',
  GS1Barcode in '..\SmFiscalPrinter\Units\GS1Barcode.pas',
  EkmClient in '..\SmFiscalPrinter\Units\EkmClient.pas',
  WException in '..\Shared\WException.pas';

{$R *.TLB}

{$R *.RES}
{$R WindowsXP.RES}

begin
  try
    Application.Initialize;
    Application.Title := 'OPOS print server';
  Application.ShowMainForm := False;
    Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmServer, dmServer);
  Application.Run;
  except
    on E: Exception do
      MessageBox(GetActiveWindow, PChar(E.Message), PChar(Application.Title), MB_ICONERROR);
  end;
end.
