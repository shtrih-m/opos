program FptrAcceptanceTest;

uses
  TestFramework,
  GUITestRunner,
  duFiscalPrinterVar in 'Units\duFiscalPrinterVar.pas',
  OposFiscalPrinter_1_11_Lib_TLB in '..\..\Source\Opos\OposFiscalPrinter_1_11_Lib_TLB.pas',
  duFptrServiceTest in 'Units\duFptrServiceTest.pas',
  OposFptrUtils in '..\..\Source\Opos\OposFptrUtils.pas',
  OposUtils in '..\..\Source\Opos\OposUtils.pas',
  Opos in '..\..\Source\Opos\Opos.pas',
  Oposhi in '..\..\Source\Opos\Oposhi.pas',
  OPOSException in '..\..\Source\Opos\OposException.pas',
  OposFptr in '..\..\Source\Opos\OposFptr.pas',
  OposFptrhi in '..\..\Source\Opos\OposFptrhi.pas',
  duFiscalPrinter in 'Units\duFiscalPrinter.pas',
  DirectIOAPI in '..\..\Source\SmFiscalPrinter\Units\DirectIOAPI.pas';

{$R *.RES}

begin
  TGUITestRunner.RunTest(RegisteredTests);
end.
