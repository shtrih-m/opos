unit duFptrControlTest;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ActiveX, ComObj, Registry,
  // DUnit
  TestFramework,
  // PascalMock
  PascalMock,
  // This
  Opos, Oposhi, OposFptrhi, OposFptrUtils, OposFiscalPrinter_1_11_Lib_TLB;

const
  FptrDeviceName = 'MockFiscalPrinter';
  FptrProgID = 'MockOposShtrih.FiscalPrinter';

type
  { TFptrControlTest }

  TFptrControlTest = class(TTestCase)
  published
    procedure CheckOpen;
  end;

implementation


procedure RegisterMockOposShtrih;
var
  Reg: TRegistry;
  KeyName: string;
resourcestring
  MsgKeyOpenError = 'Error opening registry key: %s';
begin
  Reg := TRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    KeyName := OPOS_ROOTKEY + '\' + OPOS_CLASSKEY_FPTR;
    if not Reg.OpenKey(KeyName, True) then
      raise Exception.CreateFmt(MsgKeyOpenError, [KeyName]);

    Reg.CreateKey(FptrDeviceName);
    Reg.CloseKey;
    if Reg.OpenKey(KeyName + '\' + FptrDeviceName, False) then
    begin
      Reg.WriteString('', FptrProgID);
    end;
  finally
    Reg.Free;
  end;
end;

{ TFptrControlTest }

procedure TFptrControlTest.CheckOpen;
var
  Service: IMock;
  Printer: IOPOSFiscalPrinter;
begin
  RegisterMockOposShtrih;
  Printer := TOPOSFiscalPrinter.Create(nil).ControlInterface;
  Service := CoFiscalPrinter.Create as IMock;
  Service.Expects('OpenService').WithParams(['FiscalPrinter', FptrDeviceName]).Returns(0);
  Service.Expects('GetPropertyNumber').WithParams([PIDX_ServiceObjectVersion]).Returns(001012001);
  Service.Expects('Destroy');

  CheckEquals(0, Printer.Open(FptrDeviceName), 'Printer.Open');
  Printer := nil;

  Service.Verify('Service.Verify');
end;

initialization
  RegisterTest('', TFptrControlTest.Suite);

end.
