unit duFptrServiceTest;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ActiveX, ComObj,
  // DUnit
  TestFramework,
  // This
  Opos, OposHi, OposFptrHi, OposFptrUtils, OposUtils,
  OposFiscalPrinter_1_11_Lib_TLB;

type
  { TFptrServiceTest }

  TFptrServiceTest = class(TTestCase)
  private
    Printer: TOPOSFiscalPrinter;
    procedure DrvCheck(AResultCode: Integer);
  published
    procedure CheckOpenMulti;
  end;

implementation

{ TFptrServiceTest }

procedure TFptrServiceTest.DrvCheck(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then
  begin
    raise Exception.CreateFmt('%d, %s, %s', [
      AResultCode, GetResultCodeText(AResultCode), Printer.ErrorString]);
  end;
end;

procedure TFptrServiceTest.CheckOpenMulti;
begin
  Printer := TOPOSFiscalPrinter.Create(nil);
  try
    Printer.Close;
    DrvCheck(Printer.Open('SHTRIH-M-OPOS-1'));
    DrvCheck(Printer.OpenResult);
    DrvCheck(Printer.ClaimDevice(0));
    Check(Printer.Claimed, 'Printer.Claimed');
    Printer.ServiceObjectVersion;
    Printer.ServiceObjectDescription;
    Printer.ServiceObjectVersion;
    Printer.DeviceDescription;
    Printer.DeviceName;
    Printer.PowerNotify := 1;
    Printer.DeviceEnabled := True;
    Printer.DeviceEnabled;
    Printer.DescriptionLength;
    Printer.CapPredefinedPaymentLines;
    Printer.PredefinedPaymentLines;
    Printer.DeviceName;
    Printer.Claimed;
    Printer.AsyncMode := False;
    Printer.CheckHealth(1);

    DrvCheck(Printer.BeginFiscalReceipt(True));
    Printer.PreLine := 'ÒÐÊ 3:                       Òðç 0                ';
    DrvCheck(Printer.PrintRecItem('ÀÈ-92-3in', 50.11, 2610, 4, 19.2, ''));
    DrvCheck(Printer.PrintRecSubtotal(0));
    DrvCheck(Printer.PrintRecTotal(50.11, 50.11, '0'));
    DrvCheck(Printer.PrintRecMessage('ÍÄÑ 18%                                       7.64'));
    DrvCheck(Printer.PrintRecMessage('Îïåðàòîð: ts'));
    DrvCheck(Printer.PrintRecMessage('Òðàíç.:      32114 '));
    DrvCheck(Printer.EndFiscalReceipt(False));
  finally
    Printer.Free;
  end;
end;

initialization
  RegisterTest('', TFptrServiceTest.Suite);


end.
