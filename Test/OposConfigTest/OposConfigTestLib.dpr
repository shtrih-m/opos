library OposConfigTestLib;

uses
  FastMM4,
  TestFramework,
  GUITestRunner,
  TextDfmTest in 'Units\TextDfmTest.pas',
  FileUtils in '..\..\Source\Shared\FileUtils.pas',
  AutoScrollTest in 'Units\AutoScrollTest.pas',
  fmuScaleGeneral in '..\..\Source\OposConfig\Fmu\fmuScaleGeneral.pas' {fmScaleGeneral},
  fmuDevice in '..\..\Source\OposConfig\Fmu\fmuDevice.pas' {fmDevice},
  fmuPages in '..\..\Source\OposConfig\Fmu\fmuPages.pas' {fmPages},
  fmuMain in '..\..\Source\OposConfig\Fmu\fmuMain.pas' {fmMain},
  Opos in '..\..\Source\Opos\Opos.pas',
  Oposhi in '..\..\Source\Opos\Oposhi.pas',
  OposUtils in '..\..\Source\Opos\OposUtils.pas',
  OPOSException in '..\..\Source\Opos\OposException.pas',
  untUtil in '..\..\Source\OposConfig\Units\untUtil.pas',
  SmFiscalPrinterLib_TLB in '..\..\Source\SmFiscalPrinter\SmFiscalPrinterLib_TLB.pas',
  CashDrawerParameters in '..\..\Source\SmFiscalPrinter\Units\CashDrawerParameters.pas',
  PrinterTypes in '..\..\Source\SmFiscalPrinter\Units\PrinterTypes.pas',
  PrinterModel in '..\..\Source\SmFiscalPrinter\Units\PrinterModel.pas',
  PayType in '..\..\Source\SmFiscalPrinter\Units\PayType.pas',
  LogFile in '..\..\Source\Shared\LogFile.pas',
  StringUtils in '..\..\Source\Shared\StringUtils.pas',
  DebugUtils in '..\..\Source\Shared\DebugUtils.pas',
  OposDevice in '..\..\Source\Opos\OposDevice.pas',
  VersionInfo in '..\..\Source\Shared\VersionInfo.pas',
  DirectIOAPI in '..\..\Source\SmFiscalPrinter\Units\DirectIOAPI.pas',
  OposFptrUtils in '..\..\Source\Opos\OposFptrUtils.pas',
  OposFptr in '..\..\Source\Opos\OposFptr.pas',
  OposFptrhi in '..\..\Source\Opos\OposFptrhi.pas',
  TableParameter in '..\..\Source\SmFiscalPrinter\Units\TableParameter.pas',
  ParameterValue in '..\..\Source\SmFiscalPrinter\Units\ParameterValue.pas',
  DriverTypes in '..\..\Source\SmFiscalPrinter\Units\DriverTypes.pas',
  BaseForm in '..\..\Source\Shared\BaseForm.pas',
  untPages in '..\..\Source\OposConfig\Units\untPages.pas',
  FptrTypes in '..\..\Source\OposConfig\Units\FptrTypes.pas',
  fmuFptrBarcode in '..\..\Source\OposConfig\Fmu\fmuFptrBarcode.pas' {fmFptrBarcode},
  fmuFptrReceipt in '..\..\Source\OposConfig\Fmu\fmuFptrReceipt.pas' {fmFptrReceipt},
  fmuFptrDate in '..\..\Source\OposConfig\Fmu\fmuFptrDate.pas' {fmFptrDate},
  fmuFptrJournal in '..\..\Source\OposConfig\Fmu\fmuFptrJournal.pas' {fmFptrJournal},
  fmuFptrLogo in '..\..\Source\OposConfig\Fmu\fmuFptrLogo.pas' {fmFptrLogo},
  fmuFptrVatCode in '..\..\Source\OposConfig\Fmu\fmuFptrVatCode.pas' {fmFptrVatCode},
  fmuFptrTrailer in '..\..\Source\OposConfig\Fmu\fmuFptrTrailer.pas' {fmFptrTrailer},
  PrinterTable in '..\..\Source\SmFiscalPrinter\Units\PrinterTable.pas',
  PrinterParameters in '..\..\Source\SmFiscalPrinter\Units\PrinterParameters.pas',
  PrinterParametersIni in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersIni.pas',
  SmIniFile in '..\..\Source\SmFiscalPrinter\Units\SmIniFile.pas',
  fmuReceiptFormat in '..\..\Source\OposTest\Fmu\fmuReceiptFormat.pas' {fmReceiptFormat},
  PrinterParametersX in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersX.pas',
  PrinterParametersRegIBT in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersRegIBT.pas',
  fmuXReport in '..\..\Source\OposConfig\Fmu\fmuXReport.pas' {fmXReport},
  fmuScaleLog in '..\..\Source\OposConfig\Fmu\fmuScaleLog.pas' {fmScaleLog},
  PrinterParametersReg in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersReg.pas',
  fmuCashDrawer in '..\..\Source\OposConfig\Fmu\fmuCashDrawer.pas' {fmCashDrawer},
  ScaleParameters in '..\..\Source\SmScale\Units\ScaleParameters.pas',
  ScaleTypes in '..\..\Source\SmScale\Units\ScaleTypes.pas',
  CashDrawerDevice in '..\..\Source\OposConfig\Units\CashDrawerDevice.pas',
  FiscalPrinterDevice in '..\..\Source\OposConfig\Units\FiscalPrinterDevice.pas',
  ScaleDevice in '..\..\Source\OposConfig\Units\ScaleDevice.pas',
  fmuFptrDirectIO in '..\..\Source\OposConfig\Fmu\fmuFptrDirectIO.pas' {fmFptrDirectIO},
  fmuFptrText in '..\..\Source\OposConfig\Fmu\fmuFptrText.pas' {fmFptrText},
  MalinaParams in '..\..\Source\SmFiscalPrinter\Units\MalinaParams.pas',
  TextMap in '..\..\Source\SmFiscalPrinter\Units\TextMap.pas',
  RegUtils in '..\..\Source\SmFiscalPrinter\Units\RegUtils.pas',
  fmuFptrRetalix in '..\..\Source\OposConfig\Fmu\fmuFptrRetalix.pas' {fmFptrRetalix},
  fmuFptrUnipos in '..\..\Source\OposConfig\Fmu\fmuFptrUnipos.pas' {fmFptrUnipos},
  fmuFptrFuel in '..\..\Source\OposConfig\Fmu\fmuFptrFuel.pas' {fmFptrFuel},
  fmuFptrReplace in '..\..\Source\OposConfig\Fmu\fmuFptrReplace.pas' {fmFptrReplace},
  fmuCashInProcessing in '..\..\Source\OposConfig\Fmu\fmuCashInProcessing.pas' {fmCashInProcessing},
  fmuRosneftDiscountCard in '..\..\Source\OposConfig\Fmu\fmuRosneftDiscountCard.pas' {fmRosneftDiscountCard},
  MalinaReceipt in '..\..\Source\OposConfig\Units\MalinaReceipt.pas',
  fmuFptrHeader in '..\..\Source\OposConfig\Fmu\fmuFptrHeader.pas' {fmFptrHeader},
  SettingsParams in '..\..\Source\SmFiscalPrinter\Units\SettingsParams.pas',
  TLV in '..\..\Source\SmFiscalPrinter\Units\TLV.pas',
  fmuFptrPawnTicket in '..\..\Source\OposConfig\Fmu\fmuFptrPawnTicket.pas' {fmFptrPawnTicket},
  fmuRosneftAddText in '..\..\Source\OposConfig\Fmu\fmuRosneftAddText.pas' {fmRosneftAddText},
  fmuZReport in '..\..\Source\OposConfig\Fmu\fmuZReport.pas' {fmZReport},
  fmuFptrMalina in '..\..\Source\OposConfig\Fmu\fmuFptrMalina.pas' {fmFptrMalina},
  fmuFptrTables in '..\..\Source\OposConfig\Fmu\fmuFptrTables.pas' {fmFptrTables},
  fmuMiscParams in '..\..\Source\OposConfig\Fmu\fmuMiscParams.pas' {fmMiscParams},
  VatCode in '..\..\Source\SmFiscalPrinter\Units\VatCode.pas',
  fmuFptrPayType in '..\..\Source\OposConfig\Fmu\fmuFptrPayType.pas' {fmFptrPayType},
  DriverContext in '..\..\Source\SmFiscalPrinter\Units\DriverContext.pas',
  TLVTags in '..\..\Source\SmFiscalPrinter\Units\TLVTags.pas',
  ByteUtils in '..\..\Source\Shared\ByteUtils.pas',
  fmuFptrConnection in '..\..\Source\OposConfig\Fmu\fmuFptrConnection.pas' {fmFptrConnection},
  fmuMarkChecker in '..\..\Source\OposConfig\Fmu\fmuMarkChecker.pas' {fmMarkChecker},
  WException in '..\..\Source\Shared\WException.pas',
  TntIniFiles in '..\..\Source\Shared\TntIniFiles.pas',
  DriverError in '..\..\Source\Shared\DriverError.pas',
  fmuFptrLog in '..\..\Source\OposConfig\Fmu\fmuFptrLog.pas' {fmFptrLog},
  XmlModelReader in '..\..\Source\SmFiscalPrinter\Units\XmlModelReader.pas',
  XmlUtils in '..\..\Source\SmFiscalPrinter\Units\XmlUtils.pas',
  DefaultModel in '..\..\Source\SmFiscalPrinter\Units\DefaultModel.pas',
  RegExpr in '..\..\Source\Shared\RegExpr.pas',
  fmuFiscalStorage in '..\..\Source\OposConfig\Fmu\fmuFiscalStorage.pas' {fmFiscalStorage};

{$R *.RES}

exports
  RegisteredTests name 'Test';
end.
