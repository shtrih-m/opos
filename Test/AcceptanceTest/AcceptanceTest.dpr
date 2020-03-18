program AcceptanceTest;

uses
  TestFramework,
  GUITestRunner,
  OposFiscalPrinter_1_11_Lib_TLB in '..\..\Source\Opos\OposFiscalPrinter_1_11_Lib_TLB.pas',
  duFiscalPrinter in 'Units\duFiscalPrinter.pas',
  DirectIOAPI in '..\..\Source\SmFiscalPrinter\Units\DirectIOAPI.pas',
  Opos in '..\..\Source\Opos\Opos.pas',
  OposFptrUtils in '..\..\Source\Opos\OposFptrUtils.pas',
  OposUtils in '..\..\Source\Opos\OposUtils.pas',
  Oposhi in '..\..\Source\Opos\Oposhi.pas',
  OPOSException in '..\..\Source\Opos\OposException.pas',
  WException in '..\..\Source\Shared\WException.pas',
  OposFptr in '..\..\Source\Opos\OposFptr.pas',
  OposFptrhi in '..\..\Source\Opos\OposFptrhi.pas',
  SMFiscalPrinter in '..\..\Source\Opos\SMFiscalPrinter.pas',
  PrinterEncoding in '..\..\Source\Opos\PrinterEncoding.pas',
  StringUtils in '..\..\Source\Shared\StringUtils.pas',
  PrinterTypes in '..\..\Source\SmFiscalPrinter\Units\PrinterTypes.pas',
  PrinterParameters in '..\..\Source\SmFiscalPrinter\Units\PrinterParameters.pas',
  PayType in '..\..\Source\SmFiscalPrinter\Units\PayType.pas',
  LogFile in '..\..\Source\Shared\LogFile.pas',
  FileUtils in '..\..\Source\Shared\FileUtils.pas',
  VatCode in '..\..\Source\SmFiscalPrinter\Units\VatCode.pas',
  PrinterParametersX in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersX.pas',
  PrinterParametersReg in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersReg.pas',
  SmIniFile in '..\..\Source\SmFiscalPrinter\Units\SmIniFile.pas',
  TntIniFiles in '..\..\Source\Shared\TntIniFiles.pas',
  DriverError in '..\..\Source\Shared\DriverError.pas',
  PrinterParametersRegIBT in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersRegIBT.pas',
  PrinterParametersIni in '..\..\Source\SmFiscalPrinter\Units\PrinterParametersIni.pas',
  SmFiscalPrinterLib_TLB in '..\..\Source\SmFiscalPrinter\SmFiscalPrinterLib_TLB.pas',
  OposFiscalPrinter_1_12_Lib_TLB in '..\..\Source\Opos\OposFiscalPrinter_1_12_Lib_TLB.pas',
  OposFiscalPrinter_1_13_Lib_TLB in '..\..\Source\Opos\OposFiscalPrinter_1_13_Lib_TLB.pas',
  RegExpr in '..\..\Source\Shared\RegExpr.pas';

{$R *.RES}

begin
  TGUITestRunner.RunTest(RegisteredTests);
end.
