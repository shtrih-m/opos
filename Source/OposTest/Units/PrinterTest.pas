unit PrinterTest;

interface

uses
  // VCL
  Windows, Forms, Classes, SysUtils, Math,
  // Tnt
  TntSysUtils, TntStdCtrls, TntRegistry, TntClasses,
  // This
  DriverTest, Opos, OposUtils, OposFiscalPrinter, OPOSDate, OposFptr,
  StringUtils, DirectIOAPI, FileUtils, PrinterParameters, SMFiscalPrinter;

const
  AdditionalTrailer =
    '**** AdditionalTrailer Line1 ****' + #13#10 +
    '**** AdditionalTrailer Line2 ****';

  AdditionalHeader =      
    '****  AdditionalHeader Line 1  ****' + #13#10 +
    '****  AdditionalHeader Line 2  ****';

type
  { TDayOpenedTest }

  TDayOpenedTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSetPOSIDTest }

  TSetPOSIDTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TAdditionalHeaderTest }

  TAdditionalHeaderTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTenderNameTest }

  TTenderNameTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TZReportTest }

  TZReportTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TChangeTest }

  TChangeTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { THeaderTrailerTest }

  THeaderTrailerTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TFrameLengthTest }

  TFrameLengthTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TCashInTest }

  TCashInTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TCashOutTest }

  TCashOutTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDirectIOTest1 }

  TDirectIOTest1 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDirectIOTest2 }

  TDirectIOTest2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDateTest }

  TDateTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TX5Test }

  TX5Test = class(TDriverTest)
  private
    procedure SetHeaderText(const Text: WideString);
    procedure SetTrailerText(const Text: WideString);
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TX5Test2 }

  TX5Test2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TNonFiscalReceiptTest }

  TNonFiscalReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TGenericReceiptTest }

  TGenericReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest }

  TSalesReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest2 }

  TSalesReceiptTest2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest3 }

  TSalesReceiptTest3 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest4 }

  TSalesReceiptTest4 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest5 }

  TSalesReceiptTest5 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest6 }

  TSalesReceiptTest6 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest7 }

  TSalesReceiptTest7 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest8 }

  TSalesReceiptTest8 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest9 }

  TSalesReceiptTest9 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest10 }

  TSalesReceiptTest10 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest11 }

  TSalesReceiptTest11 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TSalesReceiptTest12 }

  TSalesReceiptTest12 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TRefundReceiptTest }

  TRefundReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TRefundReceiptTest2 }

  TRefundReceiptTest2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TEmptySalesReceipt }

  TEmptySalesReceipt = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TEmptySalesReceipt2 }

  TEmptySalesReceipt2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TEmptyRefundReceipt }

  TEmptyRefundReceipt = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TEmptyRefundReceipt2 }

  TEmptyRefundReceipt2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceipt2 }

  TReceipt2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TZeroReceipt }

  TZeroReceipt = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TRoundTest }

  TRoundTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptDiscountTest }

  TReceiptDiscountTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptDiscountTest2 }

  TReceiptDiscountTest2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TGlobusReceiptTest }

  TGlobusReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TCancelReceiptTest }

  TCancelReceiptTest = class(TDriverTest)
  private
    procedure PrintSeparator;
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TStornoReceiptTest }

  TStornoReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReadEJACtivationResultTest }

  TReadEJACtivationResultTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReadEJACtivationResultTest2 }

  TReadEJACtivationResultTest2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReadEJACtivationResultTest3 }

  TReadEJACtivationResultTest3 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReadEJACtivationResultTest4 }

  TReadEJACtivationResultTest4 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TBoldTextTest }

  TBoldTextTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TPrint10Test }

  TPrint10Test = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TPrint20Test }

  TPrint20Test = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TPrintNormalTest }

  TPrintNormalTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TRecNearEndTest }

  TRecNearEndTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountCardTest }

  TDiscountCardTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountCardTest2 }

  TDiscountCardTest2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TQRCodeTest }

  TQRCodeTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt2 }

  TTestReceipt2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt3 }

  TTestReceipt3 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt4 }

  TTestReceipt4 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt5 }

  TTestReceipt5 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt6 }

  TTestReceipt6 = class(TDriverTest)
  private
    procedure PrintReceipt;
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt7 }

  TTestReceipt7 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt8 }

  TTestReceipt8 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt9 }

  TTestReceipt9 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt10 }

  TTestReceipt10 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestReceipt11 }

  TTestReceipt11 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTestDiscountReceipt }

  TTestDiscountReceipt = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountReceipt2 }

  TDiscountReceipt2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountReceipt3 }

  TDiscountReceipt3 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountReceipt4 }

  TDiscountReceipt4 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountReceipt5 }

  TDiscountReceipt5 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountReceipt6 }

  TDiscountReceipt6 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountReceipt7 }

  TDiscountReceipt7 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountReceipt8 }

  TDiscountReceipt8 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TRetalixReceipt }

  TRetalixReceipt = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { THangReceiptTest }

  THangReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TRosneftReceiptTest }

  TRosneftReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TAdjustmentReceiptTest }

  TAdjustmentReceiptTest = class(TDriverTest)
  private
    procedure PrintQRCode;
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TCorrectionReceiptTest }

  TCorrectionReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TTLVReceiptTest }

  TTLVReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TPreLineReceiptTest }

  TPreLineReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TZeroReceiptTest }

  TZeroReceiptTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TZeroReceiptTest2 }

  TZeroReceiptTest2 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest8 }

  TReceiptTest8 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest9 }

  TReceiptTest9 = class(TDriverTest)
  private
    procedure PrintQRCode;
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest10 }

  TReceiptTest10 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest11 }

  TReceiptTest11 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest12 }

  TReceiptTest12 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest13 }

  TReceiptTest13 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest14 }

  TReceiptTest14 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest15 }

  TReceiptTest15 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest16 }

  TReceiptTest16 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest17 }

  TReceiptTest17 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest18 }

  TReceiptTest18 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest19 }

  TReceiptTest19 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest20 }

  TReceiptTest20 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest21 }

  TReceiptTest21 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TCorrectionReceipt2Test }

  TCorrectionReceipt2Test = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { T6DigitsQuantityTest }

  T6DigitsQuantityTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TDiscountModeTest }

  TDiscountModeTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TLongItemTextTest }

  TLongItemTextTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TWriteTagTest }

  TWriteTagTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TWriteSTLVTest }

  TWriteSTLVTest = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest22 }

  TReceiptTest22 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest23 }

  TReceiptTest23 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest24 }

  TReceiptTest24 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest25 }

  TReceiptTest25 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest26 }

  TReceiptTest26 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest27 }

  TReceiptTest27 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest28 }

  TReceiptTest28 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest29 }

  TReceiptTest29 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest30 }

  TReceiptTest30 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest31 }

  TReceiptTest31 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest32 }

  TReceiptTest32 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest33 }

  TReceiptTest33 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest34 }

  TReceiptTest34 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

  { TReceiptTest35 }

  TReceiptTest35 = class(TDriverTest)
  public
    procedure Execute; override;
    function GetDisplayText: WideString; override;
  end;

implementation

const
  Separator = '--------------------------';

procedure CheckBool(Value: Boolean);
begin
  if not Value then
    raise Exception.Create('Test failed');
end;

{ TDayOpenedTest }

procedure TDayOpenedTest.Execute;
begin
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;

  AddLine(Separator);
  AddLine('DayOpened = ' + BoolToStr(FiscalPrinter.DayOpened));
  AddLine(Separator);
  if not FiscalPrinter.DayOpened then
  begin
    PrintTestReceipt;
    // Check DayOpened property
    AddLine(Separator);
    AddLine('DayOpened = ' + BoolToStr(FiscalPrinter.DayOpened));
    AddLine(Separator);

    if not FiscalPrinter.DayOpened then
    begin
      AddLine('Day not opened after receipt printed. Error!!!');
      Exit;
    end;
  end;
  // PrintZReport
  AddLine('PrintZReport');
  Check(FiscalPrinter.PrintZReport);
  AddLine(Separator);
  AddLine('DayOpened = ' + BoolToStr(FiscalPrinter.DayOpened));
  AddLine(Separator);
  // Check DayOpened property
  if FiscalPrinter.DayOpened then
  begin
    AddLine('Day opened after ZReport printed. Error!!!');
    Abort;
  end;
  AddLine('Test successfully completed!');
end;

function TDayOpenedTest.GetDisplayText: WideString;
begin
  Result := 'Day opened test';
end;

{ TSetPOSIDTest }

function TSetPOSIDTest.GetDisplayText: WideString;
begin
  Result := 'Set POSID test';
end;

procedure TSetPOSIDTest.Execute;
begin
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;

  AddLine('CapSetPOSID = ' + BoolToStr(FiscalPrinter.CapSetPOSID));
  if not FiscalPrinter.CapSetPOSID then
  begin
    AddLine('CapSetPOSID = FALSE, Error!');
    Exit;
  end;
  // Cashier1
  AddLine(Separator);
  AddLine('SetPOSID('''', ''Cashier1'')');
  Check(FiscalPrinter.SetPOSID('Касса: 7', 'КАССИР: Кравцов В.В.'));
  AddLine('Print test receipt');
  PrintTestReceipt;
  // Cashier2
  AddLine(Separator);
  AddLine('SetPOSID('''', ''Cashier2'')');
  Check(FiscalPrinter.SetPOSID('Касса: 7', 'КАССИР: Иванов И. И.'));
  AddLine('Print test receipt');
  PrintTestReceipt;
  // Some text
  AddLine(Separator);
  AddLine('Test successfully completed');
  AddLine('Check the receipts !');
end;

{ TAdditionalHeaderTest }

function TAdditionalHeaderTest.GetDisplayText: WideString;
begin
  Result := 'Additional header test';
end;

procedure TAdditionalHeaderTest.Execute;
begin
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;

  AddLine(Separator);
  AddLine('CapAdditionalHeader = ' +
    BoolToStr(FiscalPrinter.CapAdditionalHeader));

  AddLine(Separator);
  if not FiscalPrinter.CapAdditionalHeader then
  begin
    AddLine('CapAdditionalHeader = FALSE, Error!');
    Exit;
  end;

  FiscalPrinter.AdditionalHeader :=
    'Additional Header, line 1' + #13#10+
    'Additional Header, line 2';

  PrintTestReceipt;
end;

{ TTenderNameTest }

function TTenderNameTest.GetDisplayText: WideString;
begin
  Result := 'Tender name test';
end;

procedure TTenderNameTest.Execute;
var
  i: Integer;
  TenderIndex: Integer;
  TenderName: WideString;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  // Set tender names
  AddLine(Separator);
  // Tender name for tender 0 cannot be changed
  // Fiscal printer will return error
  for i := 1 to 3 do
  begin
    TenderIndex := i;
    TenderName := Tnt_WideFormat('Tender %d', [i]);
    AddLine(Format('DirectIO(0x4A, %d, %s)', [i, TenderName]));
    Check(FiscalPrinter.DirectIO($4a, TenderIndex, TenderName));
  end;
  AddLine(Separator);
  // Print test receipt with all tenders
  PrintTenderReceipt;
  // Set different tender names
  AddLine(Separator);
  // Tender name for tender 0 cannot be changed
  // Fiscal printer will return error
  for i := 1 to 3 do
  begin
    TenderIndex := i;
    TenderName := Tnt_WideFormat('Tender name %d', [i]);
    AddLine(Format('DirectIO(0x4A, %d, %s)', [i, TenderName]));
    Check(FiscalPrinter.DirectIO($4a, TenderIndex, TenderName));
  end;
  AddLine(Separator);
  // Print test receipt with all tenders
  PrintTenderReceipt;
  //
  AddLine(Separator);
  AddLine('Test completed !');
  AddLine('Check tender names on the receipts');
end;

{ TZReportTest }

function TZReportTest.GetDisplayText: WideString;
begin
  Result := 'ZReport test';
end;

procedure TZReportTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // Print test receipt
  PrintTestReceipt;
  // Print Z report
  AddLine('PrintZReport');
  Check(FiscalPrinter.printZReport);
  // Test completed
  AddLine(Separator);
  AddLine('OK. Test completed');
end;

{ TChangeTest }

function TChangeTest.GetDisplayText: WideString;
begin
  Result := 'Change test';
end;

procedure TChangeTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;

  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // PrintRecItem
  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Item 1', 100, 1000, 0, 100, ''));
  // PrintRecTotal - cash
  AddLine('PrintRecTotal - cash');
  FiscalPrinter.PreLine := StringOfChar('-', Integer(FiscalPrinter.MessageLength));
  FiscalPrinter.ChangeDue := 'Change due text';
  Check(FiscalPrinter.PrintRecTotal(90, 90, '0'));
  // PrintRecTotal - payment card
  AddLine('PrintRecTotal - payment card');
  FiscalPrinter.PostLine := StringOfChar('-', Integer(FiscalPrinter.MessageLength));
  FiscalPrinter.ChangeDue := 'Change due text';
  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '3'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));
  // Test completed
  AddLine(Separator);
  AddLine('OK. Test completed');
end;

{ THeaderTrailerTest }

function THeaderTrailerTest.GetDisplayText: WideString;
begin
  Result := 'Header trailer test';
end;

procedure THeaderTrailerTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;
  // Set header lines
  SetHeaderLines;
  // Set trailer lines
  SetTrailerLines;
  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // PrintRecItem
  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Item 1', 100, 1000, 0, 100, ''));
  // PrintRecTotal - cash
  AddLine('PrintRecTotal - cash');
  FiscalPrinter.PreLine := StringOfChar('-', Integer(FiscalPrinter.MessageLength));
  FiscalPrinter.ChangeDue := 'Change due text';
  Check(FiscalPrinter.PrintRecTotal(90, 90, '0'));
  // PrintRecTotal - payment card
  AddLine('PrintRecTotal - payment card');
  FiscalPrinter.PostLine := StringOfChar('-', Integer(FiscalPrinter.MessageLength));
  FiscalPrinter.ChangeDue := 'Change due text';
  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '3'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));
  // Test completed
  AddLine(Separator);
  AddLine('OK. Test completed');
end;

{ TFrameLengthTest }

function TFrameLengthTest.GetDisplayText: WideString;
begin
  Result := 'Frame length test';
end;

procedure TFrameLengthTest.Execute;
var
  i: Integer;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;
  // BeginNonFiscal
  AddLine('BeginNonFiscal');
  Check(FiscalPrinter.BeginNonFiscal);
  // PrintNormal
  for i := 0 to 10 do
    Check(FiscalPrinter.PrintNormal(2, StringOfChar('*', 100)));
  // EndNonFiscal
  AddLine('EndNonFiscal');
  Check(FiscalPrinter.EndNonFiscal);
  // Test completed
  AddLine(Separator);
  AddLine('OK. Test completed');
end;

{ TCashInTest }

function TCashInTest.GetDisplayText: WideString;
begin
  Result := 'Cash in test';
end;

procedure TCashInTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;
  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_CASH_IN;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // PrintRecCash
  AddLine('PrintRecCash(1.23)');
  Check(FiscalPrinter.PrintRecCash(1.23));
  // PrintRecCash
  AddLine('PrintRecCash(2.34)');
  Check(FiscalPrinter.PrintRecCash(2.34));
  // PrintRecTotal
  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(100, 100, '0'));
  // PrintNormal
  AddLine('PrintNormal');
  Check(FiscalPrinter.PrintNormal(2, 'PrintNormal'));
  // PrintRecMessage
  AddLine('PrintRecMessage');
  Check(FiscalPrinter.PrintRecMessage('PrintRecMessage'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:       8199'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));
  // Test completed
  AddLine(Separator);
  AddLine('OK. Test completed');
end;

{ TCashOutTest }

function TCashOutTest.GetDisplayText: WideString;
begin
  Result := 'Cash out test';
end;

procedure TCashOutTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;
  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_CASH_OUT;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // PrintRecCash
  AddLine('PrintRecCash(1.23)');
  Check(FiscalPrinter.PrintRecCash(1.23));
  // PrintRecCash
  AddLine('PrintRecCash(2.34)');
  Check(FiscalPrinter.PrintRecCash(2.34));
  // PrintRecTotal
  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(100, 100, '0'));
  // PrintNormal
  AddLine('PrintNormal');
  Check(FiscalPrinter.PrintNormal(2, 'PrintNormal'));
  // PrintRecMessage
  AddLine('PrintRecMessage');
  Check(FiscalPrinter.PrintRecMessage('PrintRecMessage'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));
  // Test completed
  AddLine(Separator);
  AddLine('OK. Test completed');
end;

{ TDirectIOTest1 }

function TDirectIOTest1.GetDisplayText: WideString;
begin
  Result := 'DirectIO test 1';
end;

procedure TDirectIOTest1.Execute;
var
  pData: Integer;
  pString: WideString;
begin
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;
  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // DirectIO
  AddLine('DirectIO');
  pData := 0;
  pString := FloatToStr(10.2) + ';1234;0;Item №1000          ';
  Check(FiscalPrinter.DirectIO(1, pData, pString));
  // PrintRecTotal
  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(10000, 10000, '0'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TDirectIOTest2 }

procedure TDirectIOTest2.Execute;
var
  pData: Integer;
  pString: WideString;
begin
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;
  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  // 1. Empty WideString
  pData := 0;
  pString := '';
  CheckBool(FiscalPrinter.DirectIO(1, pData, pString) = OPOS_E_ILLEGAL);
  // 2. Incorrect parameters
  pData := 0;
  pString := ';';
  CheckBool(FiscalPrinter.DirectIO(1, pData, pString) = OPOS_E_ILLEGAL);
  // 3. Incorrect parameters
  pData := 0;
  pString := 'a;a;a;a;a';
  CheckBool(FiscalPrinter.DirectIO(1, pData, pString) = OPOS_E_ILLEGAL);
  // 4. Incorrect parameters
  pData := 0;
  pString := '1;a;a;a;a';
  CheckBool(FiscalPrinter.DirectIO(1, pData, pString) = OPOS_E_ILLEGAL);
  // 5. Incorrect parameters
  pData := 0;
  pString := FloatToStr(1.20) + ';2;a;a;a';
  CheckBool(FiscalPrinter.DirectIO(1, pData, pString) = OPOS_E_ILLEGAL);
end;

function TDirectIOTest2.GetDisplayText: WideString;
begin
  Result := 'DirectIO test 2';
end;

{ TDateTest }

procedure TDateTest.Execute;
var
  DeviceDate: TOPOSDate;
  sDeviceDate: WideString;
begin
  DeviceDate := TOPOSDate.Create;
  try
    // Get fiscal printer date
    AddLine('Get fiscal printer date');
    Check(FiscalPrinter.GetDate(sDeviceDate));
    AddLine('Fiscal printer date: ' + sDeviceDate);
    DeviceDate.AsDate := Now;
    if DeviceDate.AsString <> sDeviceDate then
    begin
      Check(FiscalPrinter.SetDate(DeviceDate.AsString));
    end;
  finally
    DeviceDate.Free;
  end;
end;

function TDateTest.GetDisplayText: WideString;
begin
  Result := 'Check date test';
end;

{ TX5Test }

function TX5Test.GetDisplayText: WideString;
begin
  Result := 'X5 test';
end;

procedure TX5Test.SetHeaderText(const Text: WideString);
var
  i: Integer;
  Line: WideString;
  Count: Integer;
  Lines: TTntStrings;
begin
  Lines := TTntStringList.Create;
  try
    Lines.Text := Text;
    Count := FiscalPrinter.NumHeaderLines;
    for i := 0 to Count-1 do
    begin
      Line := '';
      if i < Lines.Count then Line := Lines[i];
      Check(FiscalPrinter.SetHeaderLine(i+1, Line, False));
    end;
  finally
    Lines.Free;
  end;
end;

procedure TX5Test.SetTrailerText(const Text: WideString);
var
  i: Integer;
  Line: WideString;
  Count: Integer;
  Lines: TTntStrings;
begin
  Lines := TTntStringList.Create;
  try
    Lines.Text := Text;
    Count := FiscalPrinter.NumTrailerLines;
    for i := 0 to Count-1 do
    begin
      Line := '';
      if i < Lines.Count then Line := Lines[i];
      Check(FiscalPrinter.SetTrailerLine(i+1, Line, False));
    end;
  finally
    Lines.Free;
  end;
end;

procedure TX5Test.Execute;
const
  CRLF = #13#10;
  Header =
    CRLF +
    CRLF +
    CRLF +
    CRLF +
    '**************************************************' + CRLF +
    '*           WELCOME TO OUR STORE                 *' + CRLF +
    '*               INN 7728029110                   *' + CRLF +
    '*             STORE PERVOMAYSKY                  *' + CRLF +
    '*         Moscow, 9th Parkovaya, b.62            *' + CRLF +
    '**************************************************';

  Trailer =
    '--------------------------------------------------' + CRLF +
    '                Thank you!                        ' + CRLF +
    '          You are always welcome.                 ';

var
  i: Integer;
  Line: WideString;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;
  // Header
  SetHeaderText(Header);
  SetTrailerText(Trailer);

  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // PrintRecItem
  for i := 1 to 10 do
  begin
    AddLine('PrintRecItem');
    Line := Tnt_WideFormat('%d: 76319 PEPSI-Light', [i]);
    Check(FiscalPrinter.PrintRecItem(Line, 24.59, 1000, 0, 24.59, ''));
  end;
  // PrintRecTotal
  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(245.9, 500, '0'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));
  //
  AddLine(Separator);
  AddLine('Test completed !');
  AddLine('Check tender names on the receipts');
end;

{ TX5Test2 }

function TX5Test2.GetDisplayText: WideString;
begin
  Result := 'X5 test';
end;

procedure TX5Test2.Execute;
var
  i: Integer;
  Line: WideString;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;
  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // PrintRecItem
  for i := 1 to 10 do
  begin
    AddLine('PrintRecItem');
    Line := Tnt_WideFormat('%d: 76319 PEPSI-LIGHT', [i]);
    Check(FiscalPrinter.PrintRecItem(Line, 24.59, 1000, 0, 24.59, ''));
  end;
  // PrintRecTotal
  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(245.9, 500, '0'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));
  //
  AddLine(Separator);
  AddLine('Test completed !');
  AddLine('Check tender names on the receipts');
end;

{ TNonFiscalReceiptTest }

procedure TNonFiscalReceiptTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  Check(FiscalPrinter.BeginNonFiscal);
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, '        Nonfiscal receipt line 1'));
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, '    Nonfiscal receipt line 2'));
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Nonfiscal receipt line 3'));
  Check(FiscalPrinter.PrintText('        Nonfiscal receipt line 4', 5));
  Check(FiscalPrinter.PrintText('    Nonfiscal receipt line 5', 5));
  Check(FiscalPrinter.PrintText('Nonfiscal receipt line 6', 5));

  Check(FiscalPrinter.EndNonFiscal);
  //
  AddLine(Separator);
  AddLine('Test completed !');
end;

function TNonFiscalReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Non fiscal receipt';
end;

{ TGenericReceiptTest }

procedure TGenericReceiptTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_GENERIC;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintNormal');
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, '************************************'));

  AddLine('PrintNormal');
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Generic receipt line 1'));

  AddLine('PrintNormal');
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Generic receipt line 2'));

  AddLine('PrintNormal');
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Generic receipt line 3'));

  AddLine('PrintNormal');
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, '************************************'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TGenericReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Generic receipt';
end;

{ TSalesReceiptTest }

procedure TSalesReceiptTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Булка вкусная и свежая', 123.45, 123, 1, 0, ''));
  Check(FiscalPrinter.PrintRecItem('Булка вкусная и свежая', 123.45, 123, 2, 0, ''));
  Check(FiscalPrinter.PrintRecItem('Булка вкусная и свежая', 123.45, 123, 3, 0, ''));
  Check(FiscalPrinter.PrintRecItem('Булка вкусная и свежая', 123.45, 123, 4, 0, ''));
  Check(FiscalPrinter.PrintRecTotal(999, 999, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TSalesReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test';
end;

{ TRefundReceiptTest }

procedure TRefundReceiptTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItemRefund');
  FiscalPrinter.PreLine := 'PreLine';
  Check(FiscalPrinter.PrintRecItemRefund('Item 1', 15.18, 123, 0, 123.45, ''));

  AddLine('PrintRecItemRefundVoid');
  Check(FiscalPrinter.PrintRecItemRefundVoid('Item 1', 15.18, 123, 0, 123.45, ''));

  AddLine('PrintRecItemRefund');
  Check(FiscalPrinter.PrintRecItemRefund('Item 2', 15.18, 123, 0, 123.45, ''));

  AddLine('PrintRecItemVoid');
  Check(FiscalPrinter.PrintRecItemVoid('Item 2', 15.18, 123, 0, 123.45, ''));

  AddLine('PrintRecItemRefund');
  Check(FiscalPrinter.PrintRecItemRefund('Item 3', 15.18, 123, 0, 123.45, ''));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(999, 999, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TRefundReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Refund receipt test';
end;

{ TRefundReceiptTest2 }

procedure TRefundReceiptTest2.Execute;
var
  RecTotal: Currency;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  RecTotal := 999;
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_REFUND;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Булка вкусная и свежая', 123.45, 123, 0, 0, ''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT, 'Скидка 14.50', 14.50, 0));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE, 'Надбавка 20.50', 20.50, 0));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Булка вкусная и свежая', 123.45, 123, 0, 0, ''));

  AddLine('PrintRecItemVoid');
  Check(FiscalPrinter.PrintRecItemVoid('Картофель молодой', 123.45, 123, 0, 0, ''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Конь в яблоках', 123.45, 123, 0, 0, ''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT, 'Скидка 12.34', 12.34, 0));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE, 'Надбавка 23.45', 23.45, 0));

  AddLine('PrintRecSubtotalAdjustment');
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_AMOUNT_DISCOUNT, 'Скидка 10%', 10.00));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(RecTotal, RecTotal, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TRefundReceiptTest2.GetDisplayText: WideString;
begin
  Result := 'Refund receipt test 2';
end;

{ TEmptySalesReceipt }

function TEmptySalesReceipt.GetDisplayText: WideString;
begin
  Result := 'Empty sales receipt';
end;

procedure TEmptySalesReceipt.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(999, 999, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TEmptySalesReceipt2 }

function TEmptySalesReceipt2.GetDisplayText: WideString;
begin
  Result := 'Empty sales receipt 2';
end;

procedure TEmptySalesReceipt2.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Epty item', 0, 0, 0, 0, ''));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(999, 999, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TEmptyRefundReceipt }

function TEmptyRefundReceipt.GetDisplayText: WideString;
begin
  Result := 'Empty refund receipt';
end;

procedure TEmptyRefundReceipt.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_REFUND;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(999, 999, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TEmptyRefundReceipt2 }

function TEmptyRefundReceipt2.GetDisplayText: WideString;
begin
  Result := 'Empty refund receipt 2';
end;

procedure TEmptyRefundReceipt2.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_REFUND;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecRefund');
  Check(FiscalPrinter.PrintRecRefund('Empty item', 0, 0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(999, 999, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TReceipt2 }

function TReceipt2.GetDisplayText: WideString;
begin
  Result := 'Sales receipt 2';
end;

procedure TReceipt2.Execute;
var
  RecTotal: Currency;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  RecTotal := 999;
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('2--44863 Fried chikens   ',
    350.51, 354, 0,350.51,'0'));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('2--44863 Fried chikens   ',
    350.51, 354, 0,350.51,'0'));

  AddLine('PrintRecItemVoid');
  Check(FiscalPrinter.PrintRecItemVoid('2--44863 Fried chikens   ',
    350.51, 354, 0,350.51, '0'));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(RecTotal, RecTotal, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TSalesReceiptTest }

procedure TSalesReceiptTest2.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Костюм               2000013553010',799,0,1,0,''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Костюм               2000013553010',799,0,1,0,''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Носки                2000013552693',139,0,1,0,''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(1,'',14.50,0));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Носки                2000013552693',139,0,1,0,''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(1,'',14.50,0));

  AddLine('PrintRecSubtotal');
  Check(FiscalPrinter.PrintRecSubtotal(0));

  AddLine('PrintRecSubtotalAdjustment');
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1,'Empl Discount',554.10));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(1000000, 1000000, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TSalesReceiptTest2.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 2';
end;

{ TSalesReceiptTest3 }

procedure TSalesReceiptTest3.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Spade', 100, 0, 1, 0, ''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Shovel', 200, 0, 2, 0, ''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Bricket', 300, 0, 3, 0, ''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Super Bricket', 400, 0, 4, 0, ''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Antenna', 500, 0, 0, 0, ''));

  AddLine('PrintRecSubtotal');
  Check(FiscalPrinter.PrintRecSubtotal(0));

  AddLine('PrintRecSubtotalAdjustment');
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'Empl Discount', 700));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(1000000, 1000000, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TSalesReceiptTest3.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 3';
end;

{ TSalesReceiptTest4 }

procedure TSalesReceiptTest4.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  AddLine('Receipt #1');
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Spade', 270, 0, 1, 0, ''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Shovel', 268.65, 0, 2, 0, ''));

  AddLine('PrintRecSubtotal');
  Check(FiscalPrinter.PrintRecSubtotal(0));

  AddLine('PrintRecSubtotalAdjustment');
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'Empl Discount', 100));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(538.65, 538.65, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);

  AddLine('Receipt #2');
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Spade', 270, 0, 1, 0, ''));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Shovel', 268.33, 0, 2, 0, ''));

  AddLine('PrintRecSubtotal');
  Check(FiscalPrinter.PrintRecSubtotal(0));

  AddLine('PrintRecSubtotalAdjustment');
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'Empl Discount', 100));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(538.33, 538.33, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);

  AddLine('Test completed !');
end;

function TSalesReceiptTest4.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 4';
end;

{ TSalesReceiptTest5 }

function TSalesReceiptTest5.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 5';
end;

procedure TSalesReceiptTest5.Execute;
var
  i: Integer;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItem', [i]));
    Check(FiscalPrinter.PrintRecItem('Item 1', 100, 5000, i, 100, ''));
  end;

  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemVoid', [i]));
    Check(FiscalPrinter.PrintRecItemVoid('Item 1', 100, 1000, i, 100, ''));
  end;
  // Amount discount
  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemAdjustment', [i]));
    Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
      'Скидка суммой 100 руб', 100, i));
  end;
  // Amount charge
  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemAdjustment', [i]));
    Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE,
      'Надбавка суммой 100', 100, i));
  end;
  // Percent discount
  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemAdjustment', [i]));
    Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_PERCENTAGE_DISCOUNT,
      'Процентная скидка 10%', 10, i));
  end;
  // Percent charge
  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemAdjustment', [i]));
    Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_PERCENTAGE_SURCHARGE,
      'Процентная надбавка 10%', 10, i));
  end;

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  for i := 1 to 4 do
  begin
    AddLine('PrintRecTotal');
    Check(FiscalPrinter.PrintRecTotal(500, 500, IntToStr(i)));
  end;

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TSalesReceiptTest6 }

function TSalesReceiptTest6.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 6';
end;

procedure TSalesReceiptTest6.Execute;
var
  i: Integer;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemRefund', [i]));
    Check(FiscalPrinter.PrintRecItemRefund('Item 1', 100, 5000, i, 100, ''));
  end;

  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemRefundVoid', [i]));
    Check(FiscalPrinter.PrintRecItemRefundVoid('Item 1', 100, 1000, i, 100, ''));
  end;
  // Amount discount
  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemAdjustment', [i]));
    Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
      'Скидка суммой 100 руб', 100, i));
  end;
  // Amount charge
  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemAdjustment', [i]));
    Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE,
      'Надбавка суммой 100', 100, i));
  end;
  // Percent discount
  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemAdjustment', [i]));
    Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_PERCENTAGE_DISCOUNT,
      'Процентная скидка 10%', 10, i));
  end;
  // Percent charge
  for i := 0 to 4 do
  begin
    AddLine(Format('%d. PrintRecItemAdjustment', [i]));
    Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_PERCENTAGE_SURCHARGE,
      'Процентная надбавка 10%', 10, i));
  end;

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  for i := 1 to 4 do
  begin
    AddLine('PrintRecTotal');
    Check(FiscalPrinter.PrintRecTotal(500, 500, IntToStr(i)));
  end;

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TSalesReceiptTest7 }

function TSalesReceiptTest7.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 7';
end;

procedure TSalesReceiptTest7.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  Check(FiscalPrinter.PrintRecItem('Item1', 141.40, 1000, 1, 141.40, 'ив'));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'Discount1', 42.42));
  Check(FiscalPrinter.PrintRecItem('Item2', 141.40, 1000, 1, 141.40, 'ив'));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'Discount2', 42.42));
  Check(FiscalPrinter.PrintRecItem('Item3', 146.60, 1000, 1, 146.60, 'ив'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Discount3', 36.65, 1));
  Check(FiscalPrinter.PrintRecItem('Item4', 146.60, 1000, 1, 146.60, 'ив'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Discount4', 36.65, 1));
  Check(FiscalPrinter.PrintRecItem('Item5', 22.20, 1000, 2, 22.20, 'ив'));
  Check(FiscalPrinter.PrintRecItem('Item6', 106.20, 1000, 1, 106.20, 'ив'));
  Check(FiscalPrinter.PrintRecItem('Item7', 11.10, 1000, 2, 11.10, 'ив'));
  Check(FiscalPrinter.PrintRecItem('Item8', 32.26, 770, 1, 41.9, ''));
  Check(FiscalPrinter.PrintRecTotal(589.62, 600, '1'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TSalesReceiptTest8 }

function TSalesReceiptTest8.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 8';
end;

procedure TSalesReceiptTest8.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  Check(FiscalPrinter.PrintRecItem('Item1', 141.40, 1000, 1, 141.40, '2'));
  Check(FiscalPrinter.PrintRecItem('Item1', 141.40, 1000, 2, 141.40, '2'));
  Check(FiscalPrinter.PrintRecItem('Item1', 141.40, 1000, 3, 141.40, '2'));

  // PrintRecSubtotalAdjustment
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
    'Amount discount 10.00', 10));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_AMOUNT_SURCHARGE,
    'Amount surcharge 10.00', 10));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_PERCENTAGE_DISCOUNT,
    'Percentage discount 10%', 10));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_PERCENTAGE_SURCHARGE,
    'Percentage surcharge 10%', 10));

  // PrintRecSubtotalAdjustVoid
  Check(FiscalPrinter.PrintRecSubtotalAdjustVoid(FPTR_AT_AMOUNT_DISCOUNT, 10));
  Check(FiscalPrinter.PrintRecSubtotalAdjustVoid(FPTR_AT_AMOUNT_SURCHARGE, 10));
  Check(FiscalPrinter.PrintRecSubtotalAdjustVoid(FPTR_AT_PERCENTAGE_DISCOUNT, 10));
  Check(FiscalPrinter.PrintRecSubtotalAdjustVoid(FPTR_AT_PERCENTAGE_SURCHARGE, 10));

  // PrintRecItemAdjustment
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
    'Amount discount 10.00', 10, 1));
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE,
    'Amount surcharge 10.00', 10, 1));
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_PERCENTAGE_DISCOUNT,
    'Percentage discount 10%', 10, 1));
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_PERCENTAGE_SURCHARGE,
    'Percentage surcharge 10%', 10, 1));

  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '1'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TSalesReceiptTest9 }

function TSalesReceiptTest9.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 9';
end;

procedure TSalesReceiptTest9.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  Check(FiscalPrinter.PrintRecItem('Item1', 141.40, 1000, 1, 141.40, '2'));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
    'Amount discount 141.40', 141.40));

  Check(FiscalPrinter.PrintRecTotal(141.40, 141.40, '1'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TSalesReceiptTest10 }

function TSalesReceiptTest10.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 10';
end;

procedure TSalesReceiptTest10.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  Check(FiscalPrinter.PrintRecItem('КОЛБАСКИ НЮРНБЕРГСКИ', 212.91, 852, 2, 249.9, 'кг'));
  Check(FiscalPrinter.PrintRecVoidItem('КОЛБАСКИ НЮРНБЕРГСКИ', 249.9, 476, 0, 0, 2));

  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '1'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TSalesReceiptTest11 }

function TSalesReceiptTest11.GetDisplayText: WideString;
begin
  Result := 'Sales receipt test 11';
end;

procedure TSalesReceiptTest11.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  Check(FiscalPrinter.PrintRecItem('МАНДАРИНЫ МАРОККО', 71.6, 1075, 1, 66.6, 'м '));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Скидки покуп', 7.16, 1));
  Check(FiscalPrinter.PrintRecItem('ГОРБУ?А П/К Б/Г', 184.93, 740, 2, 249.9, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Скидки покуп', 36.99, 2));
  Check(FiscalPrinter.PrintRecItem('ВОДКА РЯБЧИК 40% 0.5', 147, 1000, 1, 147, 'шт'));
  Check(FiscalPrinter.PrintRecSubtotal(359.38));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'ВОДКА РЯБЧИК 40% 0.5', 44.1));
  Check(FiscalPrinter.PrintRecItem('СЕЛЬДЬ В КРАСНОМ ВИН', 53.2, 1000, 2, 53.2, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Скидки покуп', 13.3, 2));
  Check(FiscalPrinter.PrintRecTotal(355.18, 355.18, '1'));
  Check(FiscalPrinter.PrintRecMessage('PrintRecMessage 1'));
  Check(FiscalPrinter.PrintRecMessage('PrintRecMessage 2'));
  Check(FiscalPrinter.PrintRecMessage('PrintRecMessage 3'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TSalesReceiptTest12 }

function TSalesReceiptTest12.GetDisplayText: WideString;
begin
  Result := 'Department test';
end;

procedure TSalesReceiptTest12.Execute;
var
  pData: Integer;
  pString: WideString;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  pData := 2;
  pString := '';
  Check(FiscalPrinter.DirectIO(DIO_SET_DEPARTMENT, pData, pString));
  Check(FiscalPrinter.PrintRecItem('МАНДАРИНЫ МАРОККО', 71.6, 1075, 1, 66.6, 'м '));

  pData := 3;
  pString := '';
  Check(FiscalPrinter.DirectIO(DIO_SET_DEPARTMENT, pData, pString));
  Check(FiscalPrinter.PrintRecItem('МАНДАРИНЫ МАРОККО', 71.6, 1075, 1, 66.6, 'м '));

  Check(FiscalPrinter.PrintRecTotal(355.18, 355.18, '1'));
  Check(FiscalPrinter.PrintRecMessage('PrintRecMessage 1'));
  Check(FiscalPrinter.PrintRecMessage('PrintRecMessage 2'));
  Check(FiscalPrinter.PrintRecMessage('PrintRecMessage 3'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TZeroReceipt }

function TZeroReceipt.GetDisplayText: WideString;
begin
  Result := 'Zero receipt';
end;

procedure TZeroReceipt.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(999, 999, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TRoundTest }

function TRoundTest.GetDisplayText: WideString;
begin
  Result := 'Round test';
end;

procedure TRoundTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('ПИВО ОКСКОЕ ЖИВОЕ 4', 69.10, 1000, 1, 69.10, 'шт'));
  Check(FiscalPrinter.PrintRecItem('МОЙВА КРУПНАЯ С/М РО', 36.93, 740, 2, 49.90, 'кг'));
  Check(FiscalPrinter.PrintRecItem('МОЛОКО ТОПЛ. 4% 1/45', 25.30, 1000, 2, 25.30, 'шт'));
  Check(FiscalPrinter.PrintRecItem('МАНДАРИНЫ МАРОККО', 41.93, 700, 1, 59.90, 'м '));
  Check(FiscalPrinter.PrintRecItem('СЫРКИ НЕЖНЫЕ ИЗЮМ 1/', 19.90, 1000, 2, 19.90, 'шт'));
  Check(FiscalPrinter.PrintRecItem('ПРОДУКТ ТВОРОЖНЫЙ С', 22.50, 1000, 2, 22.50, 'шт'));
  Check(FiscalPrinter.PrintRecItem('БАНАНЫ', 12.03, 325, 1, 37, 'м '));
  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TReceiptDiscountTest }

function TReceiptDiscountTest.GetDisplayText: WideString;
begin
  Result := 'Receipt discount test';
end;

procedure TReceiptDiscountTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Item1', 10, 1000, 1, 10, 'шт'));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_AMOUNT_DISCOUNT, '', 10));
  Check(FiscalPrinter.PrintRecTotal(0,0,'PrintRecTotal'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TReceiptDiscountTest2 }

function TReceiptDiscountTest2.GetDisplayText: WideString;
begin
  Result := 'Receipt discount test 2';
end;

procedure TReceiptDiscountTest2.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('МАНДАРИНЫ', 98.34, 1775, 1, 55.4, 'м '));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Скидки покуп', 9.83, 1));
  Check(FiscalPrinter.PrintRecItem('ТОМАТЫ', 52.43, 750, 2, 69.9, 'м '));
  Check(FiscalPrinter.PrintRecItem('РУЛЕТ АРОМАТНЫЙ', 209.52, 900, 2, 232.8,'кг'));
  Check(FiscalPrinter.PrintRecItem('ЗЕФИР ВАНИЛЬНЫЙ', 33.96, 238, 1, 142.7,'кг'));
  Check(FiscalPrinter.PrintRecSubtotal(384.42));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'ЗЕФИР ВАНИЛЬНЫЙ', 10.19));
  Check(FiscalPrinter.PrintRecItem('СЫР ОРИЧЕТТИ КОПЧЕНЫ', 69.9, 1000, 2, 69.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('РИС КРАСНОДАРСКИЙ 1/', 42.4, 1000, 2, 42.4, 'шт'));
  Check(FiscalPrinter.PrintRecSubtotal(486.53));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'СКИДКА 7 %', 26.2));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'КУПОН', 460.33));
  Check(FiscalPrinter.PrintRecTotal(0, 0, '20'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TGlobusReceiptTest }

function TGlobusReceiptTest.GetDisplayText: WideString;
begin
  Result := 'GLOBUS receipt test';
end;

procedure TGlobusReceiptTest.Execute;

  function getImageCommand(const fileName: WideString): WideString;
  begin
    Result := #$1B#$62 + fileName + #$0A;
  end;

begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Set header
  Check(FiscalPrinter.SetHeaderLine(1, getImageCommand('Logo.bmp') + 'ООО "ГИПЕРГЛОБУС"', False));
  Check(FiscalPrinter.SetHeaderLine(2, 'г.Влaдимир Суздaльский проспект 28', False));
  Check(FiscalPrinter.SetHeaderLine(3, 'т(4922)37-68-66', False));
  Check(FiscalPrinter.SetHeaderLine(4, 'www.globus.ru', False));
  // Begin fiscal receipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  FiscalPrinter.PreLine := '4607085440095';
  Check(FiscalPrinter.printRecItem('НЕСКАФЕ КЛАССИК 120Г', 108.90, 1000, 1, 108.90, ''));
  Check(FiscalPrinter.printRecItem('Receipt item 2', 0.10, 1000, 1, 0.10, ''));
  Check(FiscalPrinter.printRecSubtotal(10890));
  Check(FiscalPrinter.printRecTotal(108.90, 40.00, '39'));
  Check(FiscalPrinter.printRecTotal(108.90, 20000.00, '1'));
  Check(FiscalPrinter.printRecMessage(getImageCommand('Logo.bmp')));
  Check(FiscalPrinter.printRecMessage('*****     Спaсибо зa покупку!      *****'));
  Check(FiscalPrinter.printRecMessage('****************************************'));
  Check(FiscalPrinter.printRecMessage('"Глобус" г.Владимир приглашает на работу'));
  Check(FiscalPrinter.printRecMessage(' Продавец-кассир(Напитки)); Повар;'));
  Check(FiscalPrinter.printRecMessage(' Помошник повара(ресторан));'));
  Check(FiscalPrinter.printRecMessage(' Продавец-консультант(обувь)); Водитель'));
  Check(FiscalPrinter.printRecMessage(' погрузчика; Продавец(отдел продаж)'));
  Check(FiscalPrinter.printRecMessage('          Тел. (4922) 37-68-54'));
  Check(FiscalPrinter.printRecMessage('        Найди работу уже сегодня!'));
  Check(FiscalPrinter.endFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

{ TCancelReceiptTest }

function TCancelReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Cancel receipt test';
end;

procedure TCancelReceiptTest.PrintSeparator;
begin
  Check(FiscalPrinter.PrintSeparator(1, DIO_SEPARATOR_WHITE));
  Check(FiscalPrinter.PrintSeparator(3, DIO_SEPARATOR_BLACK));
  Check(FiscalPrinter.PrintSeparator(1, DIO_SEPARATOR_WHITE));
end;

procedure TCancelReceiptTest.Execute;
begin
  // Begin fiscal receipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // Item 1
  FiscalPrinter.FontNumber := 3;
  Check(FiscalPrinter.PrintNormal(2, '  4605246004278'));
  FiscalPrinter.FontNumber := 1;
  Check(FiscalPrinter.PrintRecItem('Чай чер. бергам. 2*25п', 10002.90, 1, 0, 0, ''));
  // Print separator line
  PrintSeparator;
  // Subtotal
  Check(FiscalPrinter.PrintRecSubtotal(10700));
  Check(FiscalPrinter.PrintRecTotal(107, 107, ''));
  Check(FiscalPrinter.PrintRecVoid('0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;


{ TStornoReceiptTest }

function TStornoReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Storno receipt test';
end;

procedure TStornoReceiptTest.Execute;
begin
  // Begin fiscal receipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // Item 1
  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Receipt item 1', 123, 1, 1, 0, ''));
  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
      'Скидка суммой 10 руб', 10, 1));
  // Item 2
  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Receipt item 2', 178.98, 1, 2, 0, ''));
  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
      'Скидка суммой 20 руб', 20, 2));
  // Storno item 1
  AddLine('PrintRecItemVoid');
  Check(FiscalPrinter.PrintRecItemVoid('Receipt item 1', 123, 1, 1, 0, ''));
  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE,
      'Сторно скидки суммой 10 руб', 10, 1));
  // Storno item 2
  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItemVoid('Receipt item 2', 178.98, 1, 2, 0, ''));
  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE,
      'Скидка суммой 20 руб', 20, 2));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(100, 100, ''));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TReadEJACtivationResultTest }

function TReadEJACtivationResultTest.GetDisplayText: WideString;
begin
  Result := 'Read EJ activation';
end;

procedure TReadEJACtivationResultTest.Execute;
var
  Count: Integer;
  IsFiscal: Boolean;
  OutParams: WideString;
begin
  Memo.Lines.Clear;
  Check(FiscalPrinter.ResetPrinter);
  // Read full status, 11h
  Check(FiscalPrinter.CommandStr2($11, '30', OutParams));
  IsFiscal := GetInteger(OutParams, 20, [';']) <> 0;
  if not IsFiscal then
  begin
    AddLine('Fiscal printer is not fiscalized');
    Exit;
  end;
  Check(FiscalPrinter.CommandStr($BB, '30', OutParams));
  AddLine(OutParams);
  Count := 0;
  while FiscalPrinter.CommandStr($B3, '30', OutParams) = 0 do
  begin
    AddLine(OutParams);
    Inc(Count);
    if Count = 20 then Break;
  end;
end;

{ TReadEJACtivationResultTest2 }

function TReadEJACtivationResultTest2.GetDisplayText: WideString;
begin
  Result := 'Read EJ activation 2';
end;

procedure TReadEJACtivationResultTest2.Execute;
var
  Count: Integer;
  IsFiscal: Boolean;
  OutParams: WideString;
begin
  Memo.Lines.Clear;
  Check(FiscalPrinter.ResetPrinter);
  // Read full status, 11h
  Check(FiscalPrinter.CommandStr2($11, '30', OutParams));
  IsFiscal := GetInteger(OutParams, 20, [';']) <> 0;
  if not IsFiscal then
  begin
    AddLine('Fiscal printer is not fiscalized');
    Exit;
  end;

  Check(FiscalPrinter.CommandStr2($BB, '30', OutParams));
  AddLine(OutParams);
  Count := 0;
  while FiscalPrinter.CommandStr2($B3, '30', OutParams) = 0 do
  begin
    AddLine(OutParams);
    Inc(Count);
    if Count = 20 then Break;
  end;
end;

{ TReadEJACtivationResultTest3 }

function TReadEJACtivationResultTest3.GetDisplayText: WideString;
begin
  Result := 'Read EJ activation 3';
end;

procedure TReadEJACtivationResultTest3.Execute;
var
  pData: Integer;
  Params: WideString;
begin
  Memo.Lines.Clear;
  Check(FiscalPrinter.ResetPrinter);
  pData := ParamReadEJActivationAll;
  Check(FiscalPrinter.DirectIO(DIO_READ_EJ_ACTIVATION, pData, Params));
  AddLine('Название          : ' + GetString(Params, 1, [';']));
  AddLine('Номер ККМ         : ' + GetString(Params, 2, [';']));
  AddLine('Номер ИНН         : ' + GetString(Params, 3, [';']));
  AddLine('Номер ЭКЛЗ        : ' + GetString(Params, 4, [';']));
  AddLine('Дата активизации  : ' + GetString(Params, 5, [';']));
  AddLine('Время активизации : ' + GetString(Params, 6, [';']));
  AddLine('Номер смены       : ' + GetString(Params, 7, [';']));
  AddLine('Регистрационный № : ' + GetString(Params, 8, [';']));
  AddLine('Номер КПК         : ' + GetString(Params, 9, [';']));
  AddLine('Значение КПК      : ' + GetString(Params, 10, [';']));
end;

{ TReadEJACtivationResultTest4 }

function TReadEJACtivationResultTest4.GetDisplayText: WideString;
begin
  Result := 'Read EJ activation 4';
end;

procedure TReadEJACtivationResultTest4.Execute;
var
  pData: Integer;
  Params: WideString;
begin
  Memo.Lines.Clear;
  Check(FiscalPrinter.ResetPrinter);
  pData := ParamReadEJActivationDate;
  Check(FiscalPrinter.DirectIO(DIO_READ_EJ_ACTIVATION, pData, Params));
  AddLine('Дата активизации ЭКЛЗ: ' + Params);
end;

{ TBoldTextTest }

function TBoldTextTest.GetDisplayText: WideString;
begin
  Result := 'Bold text test';
end;

procedure TBoldTextTest.Execute;
begin
  Memo.Lines.Clear;
  Check(FiscalPrinter.ResetPrinter);
  // BeginNonFiscal
  AddLine('BeginNonFiscal');
  Check(FiscalPrinter.BeginNonFiscal);
  // PrintNormal
  FiscalPrinter.Set_FontNumber(1);
  Check(FiscalPrinter.PrintNormal(2, 'Font 1 line'));
  FiscalPrinter.Set_FontNumber(2);
  Check(FiscalPrinter.PrintNormal(2, 'Font 2 line'));
  FiscalPrinter.Set_FontNumber(3);
  Check(FiscalPrinter.PrintNormal(2, 'Font 3 line'));
  FiscalPrinter.Set_FontNumber(4);
  Check(FiscalPrinter.PrintNormal(2, 'Font 4 line'));
  FiscalPrinter.Set_FontNumber(5);
  Check(FiscalPrinter.PrintNormal(2, 'Font 5 line'));
  FiscalPrinter.Set_FontNumber(6);
  Check(FiscalPrinter.PrintNormal(2, 'Font 6 line'));
  // EndNonFiscal
  AddLine('EndNonFiscal');
  Check(FiscalPrinter.EndNonFiscal);
end;

{ TPrint10Test }

procedure TPrint10Test.Execute;
var
  i: Integer;
  TickCount: Integer;
begin
  Memo.Lines.Clear;
  TickCount := GetTickCount;
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  for i := 1 to 10 do
  begin
    Check(FiscalPrinter.PrintRecItem('Продажа ' + IntToStr(i), 1, 1000, 0, 0, ''));
  end;
  Check(FiscalPrinter.PrintRecTotal(100, 100, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
  TickCount := Integer(GetTickCount) - TickCount;
  AddLine('Время выполнения: ' + IntToStr(TickCount));
end;

function TPrint10Test.GetDisplayText: WideString;
begin
  Result := 'Print 10 items receipts';
end;

{ TPrint20Test }

procedure TPrint20Test.Execute;
var
  i: Integer;
  TickCount: Integer;
begin
  Memo.Lines.Clear;
  TickCount := GetTickCount;
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  for i := 1 to 20 do
  begin
    Check(FiscalPrinter.PrintRecItem('Продажа ' + IntToStr(i), 0, 1000, 0, 0, ''));
  end;
  Check(FiscalPrinter.PrintRecTotal(0, 0, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
  TickCount := Integer(GetTickCount) - TickCount;
  AddLine('Время выполнения: ' + IntToStr(TickCount));
end;

function TPrint20Test.GetDisplayText: WideString;
begin
  Result := 'Print 20 items receipts';
end;

{ TPrintNormalTest }

procedure TPrintNormalTest.Execute;
var
  i: Integer;
  TickCount: Integer;
begin
  Memo.Lines.Clear;
  TickCount := GetTickCount;
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.AdditionalHeader := '';
  FiscalPrinter.AdditionalTrailer := '';
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  for i := 1 to 3 do
  begin
    Check(FiscalPrinter.PrintNormal(2, Tnt_WideFormat('PrintNormal %d', [i])));
    Check(FiscalPrinter.PrintRecItem(Format('Продажа %d', [i]), 0, 1000, 0, 0, ''));
  end;
  Check(FiscalPrinter.PrintNormal(2, 'PrintNormal before PrintRecTotal'));
  Check(FiscalPrinter.PrintRecTotal(0, 0, '0'));
  Check(FiscalPrinter.PrintNormal(2, 'PrintNormal after PrintRecTotal'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
  TickCount := Integer(GetTickCount) - TickCount;
  AddLine('Время выполнения: ' + IntToStr(TickCount));
end;

function TPrintNormalTest.GetDisplayText: WideString;
begin
  Result := 'PrintNormal before receipt items';
end;

{ TRecNearEndTest }

procedure TRecNearEndTest.Execute;
begin
  FiscalPrinter.CheckHealth(1);
  FiscalPrinter.Get_Claimed;
  FiscalPrinter.Get_State;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_State;
  FiscalPrinter.Get_Claimed;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_State;
  FiscalPrinter.Get_Claimed;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_State;
  FiscalPrinter.Get_Claimed;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_State;
  FiscalPrinter.Get_Claimed;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_State;
  FiscalPrinter.Get_Claimed;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_DeviceEnabled;
  FiscalPrinter.Get_CapPowerReporting;
  FiscalPrinter.Get_PowerState;
  FiscalPrinter.Get_Claimed;
  FiscalPrinter.CapRecNearEndSensor;
  FiscalPrinter.RecNearEnd;
end;

function TRecNearEndTest.GetDisplayText: WideString;
begin
  Result := 'RecNearEnd test';
end;

{ TDiscountCardTest }

(*

АО "РН-Москва"
MJ019 Вельяминово
МО, г. Домодедово, мкр. Барыбино,
69 км Каширского ш., стр.1
 
 
ККМ 00013801              ИНН ???????????? #6998
18.02.16 14:13
ПРОДАЖА                                    №3930
Coca-cola пл.бут. 1л
01                                        ?95.00
3% Loyalty 000302992000000040
СКИДКА                                     ?2.85
Бабаевск/помад-слив
01                                        ?37.90
3% Loyalty 000302992000000040
СКИДКА                                     ?1.14

Слойка с сарделькой
01                                        ?49.90

3% Loyalty 000302992000000040
СКИДКА                                     ?1.50

ТРК 4:Аи-95-К5                              Трз0
01                                       ?199.82
   5,430    *36,80
3% Loyalty 000302992000000040
СКИДКА                                     ?5.98
ПОДИТОГ                                  ?371.15
ИТОГ                ?371.15
 НАЛИЧНЫМИ                               ?371.15
 
Оператор: ts ID:          7714
Счастливого пути!
Горячая линия "НК Роснефть"
8-800-200-10-70

*)

procedure TDiscountCardTest.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Coca-cola пл.бут. 1л', 95.00, 1000, 0, 0, ''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(1,'3% Loyalty 000302992000000040', 2.85, 0));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Бабаевск/помад-слив', 37.90, 1000, 0, 0, ''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(1,'3% Loyalty 000302992000000040', 1.14, 0));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Слойка с сарделькой', 49.90, 1000, 0, 0, ''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(1,'3% Loyalty 000302992000000040', 1.50, 0));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('ТРК 4:Аи-95-К5', 199.82, 5430, 0, 36.80, ''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(1,'3% Loyalty 000302992000000040', 5.98, 0));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(10000, 10000, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TDiscountCardTest.GetDisplayText: WideString;
begin
  Result := 'Discount card test';
end;

{ TDiscountCardTest2 }

procedure TDiscountCardTest2.Execute;
begin
  // Clear memo
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // Read receipt number
  ReadRecNumber;

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.AdditionalHeader := AdditionalHeader;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Coca-cola пл.бут. 1л', 95.00, 1000, 0, 0, ''));

  AddLine('PrintRecItemAdjustment');
  Check(FiscalPrinter.PrintRecItemAdjustment(1,'3% Loyalty 000302992000000040', 10, 0));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(85.00, 85.00, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TDiscountCardTest2.GetDisplayText: WideString;
begin
  Result := 'Discount card test 2';
end;

{ TQRCodeTest }

procedure TQRCodeTest.Execute;
var
  i: Integer;
  pData: Integer;
  pString: WideString;
  BarcodeData: WideString;
begin
  Check(FiscalPrinter.ResetPrinter);

  Check(FiscalPrinter.BeginNonFiscal);
  // PrintNormal
  for i := 1 to 5 do
  begin
    Check(FiscalPrinter.PrintNormal(2, 'LIne ' + IntToStr(i)));
  end;

  pData := 44;
  pString := 'http://check.egais.ru?id=38d02af6-bfd2-409f-8041-b011d8160700&dt=2311161430&cn=030000290346;***;4;4;0';
  Check(FiscalPrinter.DirectIO(7, pData, pString));

  for i := 6 to 10 do
  begin
    Check(FiscalPrinter.PrintNormal(2, 'LIne ' + IntToStr(i)));
  end;

  BarcodeData := '#*~*#http://check.egais.ru?id=38d02af6-bfd2-409f-8041-b011d8160700&dt=2311161430&cn=030000290346';
  Check(FiscalPrinter.PrintNormal(2, BarcodeData));


  Check(FiscalPrinter.EndNonFiscal);
end;

function TQRCodeTest.GetDisplayText: WideString;
begin
  Result := 'QR Code Test';
end;

{ TTestReceipt2 }

function TTestReceipt2.GetDisplayText: WideString;
begin
  Result := 'Discount receipt';
end;

procedure TTestReceipt2.Execute;
begin
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Item 1', 99, 1000, 0, 99, ''));
  Check(FiscalPrinter.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT, '100% Loyalty 005202991000000307', 98.99, 0));
  Check(FiscalPrinter.PrintRecTotal(0.01, 0.01, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TTestReceipt3 }

function TTestReceipt3.GetDisplayText: WideString;
begin
  Result := 'Discount receipt 2';
end;

procedure TTestReceipt3.Execute;
begin
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('****  4627087921934 ТУАЛЕТНАЯ БУМАГА LU', 44.9, 1000, 1, 44.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  2334257000000 ПИРОГ ПЕЧЕНЫЙ С КАПУ', 66.74, 284, 2, 235, 'кг'));
  Check(FiscalPrinter.PrintRecItem('****  4607016245485 КРУПА ГРЕЧ. ЯДРИЦА 1', 77, 1000, 2, 77, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4627116240333 ТВОРОЖНИКИ С МАЛИНОЙ', 149, 1000, 2, 149, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4690228004575 МОЛОКО ПИТ. ДВД УЛЬТ', 71, 1000, 2, 71, 'шт'));
  Check(FiscalPrinter.PrintRecItem('**02  4607012937421 МОЛОКО ЧУДО ШОКОЛАД', 79.9, 1000, 2, 79.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, ' ckugka', 19.98, 2));
  Check(FiscalPrinter.PrintRecItem('****            322 БАНАНЫ', 66.45, 970, 1, 68.5, 'кг'));
  Check(FiscalPrinter.PrintRecItem('****  4605246006289 КОФЕ ЖАРДИН КЕНИЯ 1/', 249.9, 1000, 1, 249.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4650001683571 ВАТНЫЕ ПАЛОЧКИ 100ШТ', 18.9, 1000, 1, 18.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4650001683571 ВАТНЫЕ ПАЛОЧКИ 100ШТ', 18.9, 1000, 1, 18.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  2413343000008 ХЛЕБ СЕРГЕЕВСКИЙ 1/5', 27, 1000, 2, 27, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  2411271000008 РОЛЛ ФИЛАДЕЛЬФИЯ С О', 194, 1000, 2, 194, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****             82 ДОМАШНЯЯ КУХНЯ', 277.86, 753, 1, 369, 'кг'));
  Check(FiscalPrinter.PrintRecItem('****  4601713006240 ТУЛЬСКИЙ ПРЯНИК С ВА', 27.4, 1000, 1, 27.4, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4601713006240 ТУЛЬСКИЙ ПРЯНИК С ВА', 27.4, 1000, 1, 27.4, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4607068628410 ЖИДКОЕ МЫЛО AURA АНТ', 50, 1000, 1, 50, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  7622210459299 ПЕЧЕНЬЕ ЮБИЛЕЙНОЕ КА', 38.5, 1000, 1, 38.5, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  7622210453853 ПЕЧЕНЬЕ ЮБИЛЕЙНОЕ  М', 38.5, 1000, 1, 38.5, 'шт'));
  Check(FiscalPrinter.PrintRecSubtotal(1503.37));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'МАРКИ', 1503.37));
  Check(FiscalPrinter.PrintRecTotal(100, 100, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TTestReceipt4 }

function TTestReceipt4.GetDisplayText: WideString;
begin
  Result := 'Discount receipt 3';
end;

procedure TTestReceipt4.Execute;
begin
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('КУРАГА', 71.6, 180, 1, 399.2, 'кг'));
  Check(FiscalPrinter.PrintRecTotal(71.6, 71.6, '1'));
  Check(FiscalPrinter.PrintRecMessage(''));
  Check(FiscalPrinter.PrintRecMessage('                                                '));
  Check(FiscalPrinter.PrintRecMessage(' ****************************************       '));
  Check(FiscalPrinter.PrintRecMessage('           Уважаемый покупатель!                '));
  Check(FiscalPrinter.PrintRecMessage('      На товары, участвующие в акции,           '));
  Check(FiscalPrinter.PrintRecMessage('          скидка на сумму покупки               '));
  Check(FiscalPrinter.PrintRecMessage('           не распространяется!                 '));
  Check(FiscalPrinter.PrintRecMessage('     ****** СПАСИБО ЗА ПОКУПКУ ******           '));
  Check(FiscalPrinter.PrintRecMessage('*2451 0209/002/007          06.06.16 10:01 AC-00'));
  Check(FiscalPrinter.PrintRecTotal(100, 100, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TTestReceipt5 }

function TTestReceipt5.GetDisplayText: WideString;
begin
  Result := 'Barcode test receipt 1';
end;

// 'Barcode;Text;Height;ModuleWidth;Alignment;Parameter1;Parameter2;Parameter3;Parameter4;Parameter5'),

procedure TTestReceipt5.Execute;
var
  pData: Integer;
  Line: WideString;
  pString: WideString;
  ResultCode: Integer;
const
  Separator = '------------------------------------------';
begin
  // DIO_BARCODE_DEVICE_PDF417
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Separator);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'DIO_BARCODE_DEVICE_PDF417');
  pData := DIO_BARCODE_DEVICE_PDF417;
  pString := '299935000000;;10;3;0;0;0;3;0;2;';
  ResultCode := FiscalPrinter.DirectIO(DIO_PRINT_BARCODE, pData, pString);
  Line := Format('Result: %d, %s', [ResultCode, FiscalPrinter.ErrorString]);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Line);


  // DIO_BARCODE_DEVICE_DATAMATRIX
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Separator);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'DIO_BARCODE_DEVICE_DATAMATRIX');
  pData := DIO_BARCODE_DEVICE_DATAMATRIX;
  pString := '299935000000;;10;3;0;0;0;3;0;2;';
  ResultCode := FiscalPrinter.DirectIO(DIO_PRINT_BARCODE, pData, pString);
  Line := Format('Result: %d, %s', [ResultCode, FiscalPrinter.ErrorString]);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Line);

  // DIO_BARCODE_DEVICE_AZTEC
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Separator);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'DIO_BARCODE_DEVICE_AZTEC');
  pData := DIO_BARCODE_DEVICE_AZTEC;
  pString := '299935000000;;10;3;0;0;0;3;0;2;';
  ResultCode := FiscalPrinter.DirectIO(DIO_PRINT_BARCODE, pData, pString);
  Line := Format('Result: %d, %s', [ResultCode, FiscalPrinter.ErrorString]);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Line);

  // DIO_BARCODE_DEVICE_QR
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Separator);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'DIO_BARCODE_DEVICE_QR');
  pData := DIO_BARCODE_DEVICE_QR;
  pString := '299935000000;;10;3;0;0;0;3;0;2;';
  ResultCode := FiscalPrinter.DirectIO(DIO_PRINT_BARCODE, pData, pString);
  Line := Format('Result: %d, %s', [ResultCode, FiscalPrinter.ErrorString]);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Line);


  // DIO_BARCODE_DEVICE_EGAIS
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Separator);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'DIO_BARCODE_DEVICE_EGAIS');
  pData := DIO_BARCODE_DEVICE_EGAIS;
  pString := '299935000000;;10;3;0;0;0;3;0;2;';
  ResultCode := FiscalPrinter.DirectIO(DIO_PRINT_BARCODE, pData, pString);
  Line := Format('Result: %d, %s', [ResultCode, FiscalPrinter.ErrorString]);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Line);
end;

{ TTestReceipt6 }

procedure TTestReceipt6.Execute;
begin
  PrintReceipt;
end;

procedure TTestReceipt6.PrintReceipt;
var
  pData: Integer;
  pString: WideString;
begin
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('1: 3299852 Продукт АЛЬПИЙСКАЯ КОРОВКА 50', 0, 1000, 0, 45.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.08, 0));
  Check(FiscalPrinter.PrintRecItem('2: 3020921 Огурцы среднеплодные 1кг     ', 0, 1226, 0, 75.5, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.17, 0));
  Check(FiscalPrinter.PrintRecItem('3: 3255319 Капуста КИТАЙСКАЯ 1кг        ', 0, 1272, 0, 127.36, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.3, 0));

  pData := 0;
  pString := '299935000000';
  Check(FiscalPrinter.DirectIO(7, pData, pString));

  pData := 1;
  pString := #$0D#$0A'Получи скидку 15% на всю продукцию ПРОСТОКВАШИНО с 23 июня по 29 июня';
  Check(FiscalPrinter.DirectIO(9, pData, pString));

  Check(FiscalPrinter.PrintRecVoid('CancelReceipt'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TTestReceipt6.GetDisplayText: WideString;
begin
  Result := 'Barcode test receipt 2';
end;

{ TTestReceipt7 }

procedure TTestReceipt7.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  Check(FiscalPrinter.PrintRecItem('****  4627087921934 ТУАЛЕТНАЯ БУМАГА LU', 44.9, 1000, 1, 44.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  2334257000000 ПИРОГ ПЕЧЕНЫЙ С КАПУ', 66.74, 284, 2, 235, 'кг'));
  Check(FiscalPrinter.PrintRecItem('****  4607016245485 КРУПА ГРЕЧ. ЯДРИЦА 1', 77, 1000, 2, 77, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4627116240333 ТВОРОЖНИКИ С МАЛИНОЙ', 149, 1000, 2, 149, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4690228004575 МОЛОКО ПИТ. ДВД УЛЬТ', 71, 1000, 2, 71, 'шт'));
  Check(FiscalPrinter.PrintRecItem('**02  4607012937421 МОЛОКО ЧУДО ШОКОЛАД', 79.9, 1000, 2, 79.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, ' ckugka', 19.98, 2));
  Check(FiscalPrinter.PrintRecItem('****            322 БАНАНЫ', 66.45, 970, 1, 68.5, 'кг'));
  Check(FiscalPrinter.PrintRecItem('****  4605246006289 КОФЕ ЖАРДИН КЕНИЯ 1/', 249.9, 1000, 1, 249.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4650001683571 ВАТНЫЕ ПАЛОЧКИ 100ШТ', 18.9, 1000, 1, 18.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4650001683571 ВАТНЫЕ ПАЛОЧКИ 100ШТ', 18.9, 1000, 1, 18.9, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  2413343000008 ХЛЕБ СЕРГЕЕВСКИЙ 1/5', 27, 1000, 2, 27, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  2411271000008 РОЛЛ ФИЛАДЕЛЬФИЯ С О', 194, 1000, 2, 194, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****             82 ДОМАШНЯЯ КУХНЯ', 277.86, 753, 1, 369, 'кг'));
  Check(FiscalPrinter.PrintRecItem('****  4601713006240 ТУЛЬСКИЙ ПРЯНИК С ВА', 27.4, 1000, 1, 27.4, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4601713006240 ТУЛЬСКИЙ ПРЯНИК С ВА', 27.4, 1000, 1, 27.4, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  4607068628410 ЖИДКОЕ МЫЛО AURA АНТ', 50, 1000, 1, 50, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  7622210459299 ПЕЧЕНЬЕ ЮБИЛЕЙНОЕ КА', 38.5, 1000, 1, 38.5, 'шт'));
  Check(FiscalPrinter.PrintRecItem('****  7622210453853 ПЕЧЕНЬЕ ЮБИЛЕЙНОЕ  М', 38.5, 1000, 1, 38.5, 'шт'));
  Check(FiscalPrinter.PrintRecSubtotal(1503.37));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'МАРКИ', 1503.37));
  Check(FiscalPrinter.PrintRecTotal(0, 0, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TTestReceipt7.GetDisplayText: WideString;
begin
  Result := 'Discount receipt test';
end;

{ TTestReceipt8 }

function TTestReceipt8.GetDisplayText: WideString;
begin
  Result := 'Discount receipt test 2';
end;

procedure TTestReceipt8.Execute;
begin
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Пончик с  какао глаз', 49.9, 1000, 0, 49.9, ''));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Скидка за хорошее поведение', 29.94, 0));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Скидка за хорошее поведение', 10, 0));
  Check(FiscalPrinter.PrintRecItem('Donut с белой глазур', 49.9, 1000, 0, 49.9, ''));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, 'Скидка за хорошее поведение', 29.94, 0));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(39.92, 39.92, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TTestReceipt9 }

procedure TTestReceipt9.Execute;
begin
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('ЛИМОНАД САРОВА ЛИМОН', 57, 1000, 1, 57, 'шт'));
  Check(FiscalPrinter.PrintRecItem('ТВОРОГ 12% 200Г', 79.8, 2000, 2, 39.9, 'шт'));
  Check(FiscalPrinter.PrintRecSubtotal(136.8));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'Округл.сдачи', 0.3));
  Check(FiscalPrinter.PrintRecTotal(200, 200, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TTestReceipt9.GetDisplayText: WideString;
begin
  Result := 'Discount receipt test 3';
end;

{ TTestReceipt10 }

procedure TTestReceipt10.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  FiscalPrinter.PreLine := '                                    5,88 X 34,00';
  Check(FiscalPrinter.PrintRecRefund('ТРК 1:Аи-92-К4              Трз23652', 199.2, 0));
  FiscalPrinter.PreLine := '                                    2,00 X 49,90';
  Check(FiscalPrinter.PrintRecRefund('Батончик Пикник Грец', 99.80, 0));
  FiscalPrinter.PreLine := '                                    4,00 X 39,90';
  Check(FiscalPrinter.PrintRecRefund('Печ.Твикс мол.шок.55', 159.60, 0));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(459.32, 459.32, '0'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:       8200'));
  Check(FiscalPrinter.PrintRecMessage('ID продажи: 8199 (459,32 руб)'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TTestReceipt10.GetDisplayText: WideString;
begin
  Result := 'Refund receipt 10';
end;

{ TTestReceipt11 }

procedure TTestReceipt11.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  FiscalPrinter.PreLine := '                                    5,88 X 34,00';
  Check(FiscalPrinter.PrintRecItem('ТРК 1:Аи-92-К4              Трз23652', 199.2, 0, 0, 0, ''));
  FiscalPrinter.PreLine := '                                    2,00 X 49,90';
  Check(FiscalPrinter.PrintRecItem('Батончик Пикник Грец', 99.80, 0, 0, 0, ''));
  FiscalPrinter.PreLine := '                                    4,00 X 39,90';
  Check(FiscalPrinter.PrintRecItem('Печ.Твикс мол.шок.55', 159.60, 0, 0, 0, ''));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(459.32, 459.32, '0'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:       8200'));
  Check(FiscalPrinter.PrintRecMessage('ID продажи: 8199 (459,32 руб)'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TTestReceipt11.GetDisplayText: WideString;
begin
  Result := 'Sales receipt 11';
end;

{ TTestDiscountReceipt }

function TTestDiscountReceipt.GetDisplayText: WideString;
begin
  Result := 'Test discount receipt';
end;

procedure TTestDiscountReceipt.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('1. Item1', 100, 1000, 0, 0, ''));
  Check(FiscalPrinter.PrintRecItem('2. Item2', 200, 1000, 0, 0, ''));
  Check(FiscalPrinter.PrintRecItem('3. Item3', 300, 1000, 0, 0, ''));

  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_AMOUNT_DISCOUNT, 'Скидка 1', 0.99));

  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TDiscountReceipt2 }

function TDiscountReceipt2.GetDisplayText: WideString;
begin
  Result := 'Discount receipt 2';
end;

procedure TDiscountReceipt2.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Coca-cola пл.бут. 1л', 99, 1000, 0, 99, ''));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '10.1% Loyalty 005202991002739241', 10, 0));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(89, 89, '0'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:    3946640'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TDiscountReceipt3 }

function TDiscountReceipt3.GetDisplayText: WideString;
begin
  Result := 'Discount receipt 3';
end;

procedure TDiscountReceipt3.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  FiscalPrinter.PostLine := '  13.580    *36.80';
  FiscalPrinter.PreLine := '';
  Check(FiscalPrinter.PrintRecRefund('ТРК 3:Аи-95-К5               Трз1390', 499.74, 0));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(499.74, 499.74, '0'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:    3944628'));
  Check(FiscalPrinter.PrintRecMessage('ID продажи: 3944627 (499.74 руб)'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TDiscountReceipt4 }

function TDiscountReceipt4.GetDisplayText: WideString;
begin
  Result := 'Discount receipt 4';
end;

procedure TDiscountReceipt4.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  Check(FiscalPrinter.BeginNonFiscal);
  Check(FiscalPrinter.PrintNormal(2, 'Залоговая квитанция'));
  Check(FiscalPrinter.PrintNormal(2, 'ТРК  4   : Аи-95-К5           '));
  Check(FiscalPrinter.PrintNormal(2, 'Получено : 23.5 liter x 36.80р. = 864.80р.'));
  Check(FiscalPrinter.PrintNormal(2, '11.10.16 13:18:46       '));
  Check(FiscalPrinter.PrintNormal(2, ''));
  Check(FiscalPrinter.EndNonFiscal);
end;

{ TRetalixReceipt }

function TRetalixReceipt.GetDisplayText: WideString;
begin
  Result := 'Retalix test receipt';
end;

procedure TRetalixReceipt.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  Check(FiscalPrinter.PrintRecMessage('Before receipt 1'));
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Before receipt 2'));

  Check(FiscalPrinter.PrintRecItem('Пополнение банковско', 100, 1000, 0, 0, ''));
  Check(FiscalPrinter.PrintRecItem('Газ баллон 5кг', 100, 1000, 0, 0, ''));
  Check(FiscalPrinter.PrintRecItem('Сахар пакетик 5 гр', 200, 1000, 0, 0, ''));
  Check(FiscalPrinter.PrintRecItem('Чай 120 мл автомат', 300, 1000, 0, 0, ''));
  Check(FiscalPrinter.PrintRecMessage('Оператор: Рыжикова Ан. ID: 273657254'));

  FiscalPrinter.PostLine := 'Банк.Карта        N#XXXXXX4058                                                =55.00';
  FiscalPrinter.PrintRecSubtotal(700);
  Check(FiscalPrinter.PrintRecTotal(700, 1000, '0'));

  Check(FiscalPrinter.PrintRecMessage('After receipt 1'));
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'After receipt 2'));

  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ THangReceiptTest }

procedure THangReceiptTest.Execute;
begin
  Check(FiscalPrinter.BeginNonFiscal);
  Check(FiscalPrinter.PrintNormal(2, '17.10.16 16:16:35'));
  Check(FiscalPrinter.PrintNormal(2, 'Номер кассы: 1'));
  Check(FiscalPrinter.PrintNormal(2, 'Оператор:ts'));
  Check(FiscalPrinter.PrintNormal(2, 'Номер транзакции:     22377'));
  Check(FiscalPrinter.PrintNormal(2, '------------------------------------'));
  Check(FiscalPrinter.PrintNormal(2, 'Отмена транзакции'));
  Check(FiscalPrinter.PrintNormal(2, 'Утвердил:  ts'));
  Check(FiscalPrinter.PrintNormal(2, 'Причина:  Hеправильная ТРК'));
  Check(FiscalPrinter.PrintNormal(2, ''));
  Check(FiscalPrinter.PrintNormal(2, 'Кол-во Название Цена  Операция'));
  Check(FiscalPrinter.PrintNormal(2, ''));
  Check(FiscalPrinter.PrintNormal(2, '1 Автомобильный бензин Пульсар АИ-92-5       0.000    Отмена'));
  Check(FiscalPrinter.PrintNormal(2, 'Банк.Карта        N#XXXXXX4058                                                =55.00'));
  Check(FiscalPrinter.EndNonFiscal);
end;

function THangReceiptTest.GetDisplayText: WideString;
begin
  Result := 'THangReceiptTest';
end;

{ TRosneftReceiptTest }

procedure TRosneftReceiptTest.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  FiscalPrinter.PostLine := '  40.000    *36.80';
  FiscalPrinter.PreLine := '                                   40.00 X 36.80';
  Check(FiscalPrinter.PrintRecRefund('ТРК 3:АИ-92', 1472, 0));
  Check(FiscalPrinter.PrintRecSubtotal(1472));
  Check(FiscalPrinter.PrintRecTotal(1472, 1472, '0'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:    3945836'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TRosneftReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Rosneft receipt test';
end;

{ TDiscountReceipt5 }

procedure TDiscountReceipt5.Execute;
begin
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Coca-cola пл.бут. 1л', 297, 3000, 0, 99, ''));
  FiscalPrinter.PostLine := '  17.480    *36.80';
  Check(FiscalPrinter.PrintRecItem('ТРК 4:Аи-95-К5               Трз1818', 643.26, 1000, 0, 643.26, ''));
  FiscalPrinter.PostLine := 'Банк.Карта        N#XXXXXX4058             =640.26';
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(940.26, 640.26, '1'));
  Check(FiscalPrinter.PrintRecTotal(940.26, 300, '0'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:    3946653'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TDiscountReceipt5.GetDisplayText: WideString;
begin
  Result := 'Discount receipt 5';
end;

{ TDiscountReceipt6 }

procedure TDiscountReceipt6.Execute;
begin
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Coca-cola пл. 0.5л', 75, 1000, 0, 75, ''));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '13.3% Loyalty 005202991002739241', 10, 0));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(65, 65, '0'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:    3946670'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TDiscountReceipt6.GetDisplayText: WideString;
begin
  Result := 'Discount receipt 6';
end;


{ TDiscountReceipt7 }

function TDiscountReceipt7.GetDisplayText: WideString;
begin
  Result := 'Discount receipt 7';
end;

procedure TDiscountReceipt7.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Шоколад Российский т', 95, 1000, 0, 95, ''));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '5% Loyalty  000302000400292392', 4.75, 0));
  FiscalPrinter.PostLine := 'Банк.Карта        N#XXXXXX0489      ';
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(90.25, 90.25, '1'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: Бурченкова ID:     295117'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TDiscountReceipt8 }

procedure TDiscountReceipt8.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Item1', 4, 1000, 0, 3.99, ''));
  Check(FiscalPrinter.PrintRecTotal(4, 4, '1'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TDiscountReceipt8.GetDisplayText: WideString;
begin
  Result := 'Test receipt 8';
end;

{ TAdjustmentReceiptTest }

procedure TAdjustmentReceiptTest.PrintQRCode;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 44;
  pString := 'http://check.egais.ru?id=38d02af6-bfd2-409f-8041-b011d8160700&dt=2311161430&cn=030000290346;***;4;4;0';
  Check(FiscalPrinter.DirectIO(7, pData, pString));
end;

procedure TAdjustmentReceiptTest.Execute;
var
  i: Integer;
  N: Integer;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  N := 0;
  for i := 1 to 30 do
  begin
    Inc(N);
    Check(FiscalPrinter.PrintRecItem(Format('%d. Receipt item', [N]) +
      StringOfChar('*', i), 0, 1234, 0, 23.45, ''));
  end;

  printQRCode;
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(FPTR_AT_AMOUNT_DISCOUNT, 'Скидка 0.99', 0.99));
  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
  // Nonfiscal 1
  FiscalPrinter.DisableNextHeader;
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  Check(FiscalPrinter.BeginNonFiscal);
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Nonfiscal receipt line 1'));
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Nonfiscal receipt line 2'));
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Nonfiscal receipt line 3'));
  Check(FiscalPrinter.EndNonFiscal);
  // Nonfiscal 2
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  Check(FiscalPrinter.BeginNonFiscal);
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Nonfiscal receipt line 1'));
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Nonfiscal receipt line 2'));
  Check(FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, 'Nonfiscal receipt line 3'));
  Check(FiscalPrinter.EndNonFiscal);
end;

function TAdjustmentReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Adjustment receipt test';
end;

{ TCorrectionReceiptTest }

procedure TCorrectionReceiptTest.Execute;
begin
  // Sale
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_CORRECTION_SALE;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.DirectIO2(40, 1173, '0'));
  Check(FiscalPrinter.DirectIO2(40, 1177, '77'));
  Check(FiscalPrinter.DirectIO2(40, 1178, '11.05.2018'));
  Check(FiscalPrinter.DirectIO2(40, 1179, '99'));
  Check(FiscalPrinter.PrintRecCash(100));
  Check(FiscalPrinter.PrintRecTotal(100, 100, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
  // Buy
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_CORRECTION_BUY;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.DirectIO2(40, 1177, '77'));
  Check(FiscalPrinter.DirectIO2(40, 1178, '11.05.2018'));
  Check(FiscalPrinter.DirectIO2(40, 1179, '99'));
  Check(FiscalPrinter.PrintRecCash(100));
  Check(FiscalPrinter.PrintRecTotal(100, 100, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TCorrectionReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Correction receipt test';
end;

{ TTLVReceiptTest }

function TTLVReceiptTest.GetDisplayText: WideString;
begin
  Result := 'TLV receipt test';
end;

procedure TTLVReceiptTest.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  FiscalPrinter.WriteCustomerAddress('+79168191324');
  Check(FiscalPrinter.PrintRecItem('Шоколад Российский т', 95, 1000, 0, 95, ''));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '5% Loyalty  000302000400292392', 4.75, 0));
  FiscalPrinter.PostLine := 'Банк.Карта        N#XXXXXX0489      ';
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(90.25, 90.25, '1'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: Бурченкова ID:     295117'));
  FiscalPrinter.WriteCustomerAddress('vitalykravtsov@mail.ru');
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TPreLineReceiptTest }

function TPreLineReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Pre Line Receipt Test';
end;

(*
procedure TPreLineReceiptTest.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  FiscalPrinter.PreLine := 'ТРК 3:                       Трз 0                ';
  Check(FiscalPrinter.PrintRecItem('АИ-92-3in', 50.11, 2610, 4, 19.2, ''));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(50.11, 50.11, '0'));
  Check(FiscalPrinter.PrintRecMessage('НДС 18%                                       7.64'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts'));
  Check(FiscalPrinter.PrintRecMessage('Транз.:      32114 '));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;
*)

procedure TPreLineReceiptTest.Execute;
begin
  FiscalPrinter.DeviceEnabled;
  FiscalPrinter.DescriptionLength;
  FiscalPrinter.CapPredefinedPaymentLines;
  FiscalPrinter.PredefinedPaymentLines;
  FiscalPrinter.DeviceName;
  FiscalPrinter.Claimed;
  FiscalPrinter.AsyncMode := False;
  FiscalPrinter.CheckHealth(1);

  Check(FiscalPrinter.BeginFiscalReceipt(True));
  FiscalPrinter.PreLine := 'ТРК 3:                       Трз 0                ';
  Check(FiscalPrinter.PrintRecItem('АИ-92-3in', 0, 10000, 4, 0, ''));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(50.11, 50.11, '0'));
  Check(FiscalPrinter.PrintRecMessage('НДС 18%                                       7.64'));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts'));
  Check(FiscalPrinter.PrintRecMessage('Транз.:      32114 '));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

{ TZeroReceiptTest }

procedure TZeroReceiptTest.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('АИ-92-3in', 0, 2610, 4, 0, ''));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(0, 0, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TZeroReceiptTest.GetDisplayText: WideString;
begin
  Result := 'Zero receipt test';
end;

{ TZeroReceiptTest2 }

procedure TZeroReceiptTest2.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItemRefund('АИ-92-3in', 0, 2610, 4, 0, ''));
  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(0, 0, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TZeroReceiptTest2.GetDisplayText: WideString;
begin
  Result := 'Zero refund receipt test';
end;

{ TReceiptTest8 }

function TReceiptTest8.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest8';
end;

procedure TReceiptTest8.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  check(FiscalPrinter.PrintRecItem('1:95 Оливки ITLV зеленые 300г', 124, 1000, 1, 124, 'шт'));
  check(FiscalPrinter.PrintRecItem('2:29665 Молоко ПИСКАРЕВСКОЕ 1л', 53.99, 1000, 2, 53.99, 'шт'));
  check(FiscalPrinter.PrintRecItem('3:3246577 Огурцы короткоплодные 1кг', 67.8, 1384, 2, 48.99, 'кг'));
  check(FiscalPrinter.PrintRecItem('4*3248766 Яблоки ГЛОСТЕР 1кг', 166.19, 2080, 1, 79.9, 'кг'));
  check(FiscalPrinter.PrintRecItem('5*3255455 Перец ДОЛМА 1кг', 23.82, 136, 2, 175.18, 'кг'));
  check(FiscalPrinter.PrintRecItem('6:2050923 Средство САНОКС чистящее 750г', 44.59, 1000, 1, 44.59, 'шт'));
  check(FiscalPrinter.PrintRecItem('7*3501031 Средство FAIRY 450мл', 49.9, 1000, 1, 49.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('8*2038357 Зуб.паста COLGATE 100мл', 58.8, 1000, 1, 58.8, 'шт'));
  check(FiscalPrinter.PrintRecItem('9:3631647 Диски КРУГЛЫЙ ГОД 80шт', 19.39, 1000, 1, 19.39, 'шт'));
  check(FiscalPrinter.PrintRecItem('10*3620583 Изд.мак.AIDA 450г', 29.9, 1000, 2, 29.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('11*3448338 Чай LIPTON черный 100х2г', 159, 1000, 1, 159, 'шт'));
  check(FiscalPrinter.PrintRecItem('12*3500750 Средство FAIRY 450мл', 49.9, 1000, 1, 49.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('13*3620583 Изд.мак.AIDA 450г', 29.9, 1000, 2, 29.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('14*3620583 Изд.мак.AIDA 450г', 29.9, 1000, 2, 29.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('15:3420638 Дезодорант LADY карандаш 45г', 144, 1000, 3, 144, 'шт'));
  check(FiscalPrinter.PrintRecItem('16*3618920 СМС LOSK СЕНСИТИВ 4,5кг', 299, 1000, 1, 299, 'шт'));
  check(FiscalPrinter.PrintRecItem('17*18898 Грейпфрут отборный 1кг', 147.62, 1642, 1, 89.9, 'кг'));
  check(FiscalPrinter.PrintRecItem('18:3231971 Томаты 1кг', 239.34, 2522, 2, 94.9, 'кг'));
  check(FiscalPrinter.PrintRecItem('19*3757 Бананы 1кг', 113.17, 2268, 1, 49.9, 'кг'));
  check(FiscalPrinter.PrintRecItem('20*88 Маслины ITLV СУПЕР черные 350г', 99.9, 1000, 1, 99.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('21:18077 Петрушка пакет 100г', 24.9, 1000, 2, 24.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('22:18074 Укроп пакет 100г', 24.9, 1000, 2, 24.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('23*88 Маслины ITLV СУПЕР черные 350г', 99.9, 1000, 1, 99.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('24*3445023 Авокадо 1шт', 29.9, 1000, 1, 29.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('25*3445023 Авокадо 1шт', 29.9, 1000, 1, 29.9, 'шт'));
  check(FiscalPrinter.PrintRecItem('26:3300463 Пакет КАРУСЕЛЬ 40х65', 6.04, 1000, 1, 6.04, 'шт'));
  check(FiscalPrinter.PrintRecItem('27:3300463 Пакет КАРУСЕЛЬ 40х65', 6.04, 1000, 1, 6.04, 'шт'));
  check(FiscalPrinter.PrintRecItem('28:3300463 Пакет КАРУСЕЛЬ 40х65', 6.04, 1000, 1, 6.04, 'шт'));
  check(FiscalPrinter.PrintRecSubtotal(2177.73));
  check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'ОКРУГЛЕНИЕ', 0.73));
  check(FiscalPrinter.PrintRecTotal(2177, 2177, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

{ TReceiptTest9 }

procedure TReceiptTest9.PrintQRCode;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 44;
  pString := 'http://check.egais.ru?id=38d02af6-bfd2-409f-8041-b011d8160700&dt=2311161430&cn=030000290346;***;4;4;0';
  Check(FiscalPrinter.DirectIO(7, pData, pString));
end;

procedure TReceiptTest9.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('Конь в яблоках, варено-копченый 01234567890123456789012345678901234567890123456789',
    124.56, 1789, 1, 124.56, 'кг'));

  FiscalPrinter.SetIntParameter(DriverParameterParam1, 1);
  FiscalPrinter.SetIntParameter(DriverParameterParam2, 2);
  FiscalPrinter.SetIntParameter(DriverParameterParam3, 3);
  FiscalPrinter.SetIntParameter(DriverParameterParam4, 4);
  FiscalPrinter.SetIntParameter(DriverParameterParam5, 5);
  FiscalPrinter.SetIntParameter(DriverParameterParam6, 6);
  FiscalPrinter.SetIntParameter(DriverParameterParam7, 0);
  Check(FiscalPrinter.PrintRecTotal(100000, 100000, '0'));
  PrintQRCode;
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TReceiptTest9.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest9';
end;

{ TReceiptTest10 }

procedure TReceiptTest10.Execute;
begin
  Check(FiscalPrinter.resetPrinter());
  FiscalPrinter.set_FiscalReceiptType(4);
  Check(FiscalPrinter.beginFiscalReceipt(true));

  Check(FiscalPrinter.PrintRecItem('Item 1', 99, 1000000, 4, 99, ''));
  Check(FiscalPrinter.PrintRecTotal(99, 99, '0'));

  Check(FiscalPrinter.endFiscalReceipt(false));
end;

function TReceiptTest10.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest10';
end;

{ TReceiptTest11 }

function TReceiptTest11.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest11';
end;

procedure TReceiptTest11.Execute;

  procedure printCode128;
  var
    Barcode: TBarcodeRec;
  begin
    Barcode.Data := '8236482763482736482';
    Barcode.Text := Barcode.Data;
    Barcode.Height := 100;
    Barcode.BarcodeType := DIO_BARCODE_CODE128A;
    Barcode.ModuleWidth := 2;
    Barcode.Alignment := BARCODE_ALIGNMENT_CENTER;
    Check(FiscalPrinter.PrintBarcode2(Barcode));
  end;

  procedure printQRCode;
  const
    BarcodeData =
      'http://check.egais.ru?id=38d02af6-bfd2-409f-8041-b011d8160700&dt=2311161430&cn=030000290346 ' +
      '0123456789012345678901234567890123456789012345678901234567890123456789' +
      '0123456789012345678901234567890123456789012345678901234567890123456789' +
      '01234567';
  var
    Line: WideString;
    OptArgs: Integer;
    Data: WideString;
    TextLength: Integer;
    Barcode: TBarcodeRec;
  begin
    // в формате <ссылка><ПРОБЕЛ><подпись 128 символов><0x00>
    Barcode.Data := BarcodeData;
    Barcode.Text := '';
    Barcode.Height := 100;
    Barcode.BarcodeType := DIO_BARCODE_QRCODE2;
    Barcode.ModuleWidth := 4;
    Barcode.Alignment := BARCODE_ALIGNMENT_CENTER;
    Check(FiscalPrinter.PrintBarcode2(Barcode));


    OptArgs := 5;
    Check(FiscalPrinter.getData(FPTR_GD_DESCRIPTION_LENGTH, OptArgs, Data));
    TextLength := StrToInt(Data);
    if TextLength <= 0 then
      raise Exception.Create('TextLength <= 0');
    if TextLength > 100 then
      raise Exception.Create('TextLength > 100');

    FiscalPrinter.PrintText(BarcodeData, 5);

    Line := BarcodeData;
    while Length(Line) > 0 do
    begin
      FiscalPrinter.PrintText(Copy(Line, 1, TextLength), 5);
      Line := Copy(Line, TextLength + 1, Length(Line));
    end;
  end;

  procedure printAztecCode;
  var
    Barcode: TBarcodeRec;
  begin
    Barcode.Data := '87686787687687687687687030000290346';
    Barcode.Text := '';
    Barcode.Height := 100;
    Barcode.BarcodeType := DIO_BARCODE_AZTEC;
    Barcode.ModuleWidth := 5;
    Barcode.Alignment := BARCODE_ALIGNMENT_CENTER;
    Check(FiscalPrinter.PrintBarcode2(Barcode));
  end;

  procedure printEndingItems;
  begin
    PrintCode128;
    printQRCode;
    //printAztecCode;
    Check(FiscalPrinter.PrintRecMessage('Оператор: ts ID:    3944628'));
    Check(FiscalPrinter.PrintRecMessage('ID продажи: 3944627 (499.74 руб)'));
  end;

begin
  Check(FiscalPrinter.resetPrinter());
  FiscalPrinter.set_FiscalReceiptType(4);
  Check(FiscalPrinter.beginFiscalReceipt(true));

  Check(FiscalPrinter.PrintRecItem('АИ-92-3', 1000.43, 55090, 4, 18.16, ''));
  //Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'Округление', 0.43));

  printEndingItems;

  Check(FiscalPrinter.PrintRecTotal(1100, 1100, '0'));

  printEndingItems;
  Check(FiscalPrinter.endFiscalReceipt(false));
end;

{ TReceiptTest12 }

procedure TReceiptTest12.Execute;
var
  EgaisQRCode: WideString;
  Barcode: TBarcodeRec;
begin
  EgaisQRCode := 'https://check.egais.ru?id=a9e56cb9-21d6-4404-9f24-668020fadf6a&dt=0910141104&cn=Magazin2014 ' +
  '418E6A105B60250CEB20F9F9A556FA4A9575B0C07EC536DE89CA868C884E296E5' +
  '6BA7EC7762C9BEC285CB4D8CD90EEE9F9FC16F92CCF324829E70862F0DFEC1B41' +
  '8E6A105B60250CEB20F9F9A556FA4A9575B0C07EC536DE89CA868C884E296E56B' +
  'A7EC7762C9BEC285CB4D8CD90EEE9F9FC16F92CCF324829E70862F0DFEC1B';

  Check(FiscalPrinter.resetPrinter());
  FiscalPrinter.set_FiscalReceiptType(4);
  FiscalPrinter.BeginFiscalReceipt(True);
  FiscalPrinter.PrintRecItem('3757 Бананы 1кг', 62.9, 15000, 1, 62.9, 'кг');;
  FiscalPrinter.PrintRecTotal(0, 100000, '0');

  Barcode.Data :=
    'https://check.egais.ru?id=a9e56cb9-21d6-4404-9f24-668020fadf6a&dt=0910141104&cn=Magazin2014';
  Barcode.Text :=
    '418E6A105B60250CEB20F9F9A556FA4A9575B0C07EC536DE89CA868C884E296E5' +
    '6BA7EC7762C9BEC285CB4D8CD90EEE9F9FC16F92CCF324829E70862F0DFEC1B41' +
    '8E6A105B60250CEB20F9F9A556FA4A9575B0C07EC536DE89CA868C884E296E56B' +
    'A7EC7762C9BEC285CB4D8CD90EEE9F9FC16F92CCF324829E70862F0DFEC1B';

  Barcode.Height := 100;
  Barcode.BarcodeType := DIO_BARCODE_QRCODE2;
  Barcode.ModuleWidth := 4;
  Barcode.Alignment := BARCODE_ALIGNMENT_CENTER;
  Check(FiscalPrinter.PrintBarcodeHex2(Barcode));

  FiscalPrinter.EndFiscalReceipt(True);
end;

function TReceiptTest12.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest12';
end;

{ TReceiptTest13 }

procedure TReceiptTest13.Execute;
begin
  Check(FiscalPrinter.resetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  FiscalPrinter.PreLine := 'ТРК 3:                      Трз179';
  Check(FiscalPrinter.PrintRecItemRefund('АИ-92', 485, 15290, 4, 31.72, ''));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'Округление', 0.02));
  Check(FiscalPrinter.PrintRecTotal(2035.98, 2035.98, '0'));
  Check(FiscalPrinter.PrintRecMessage('Транз.:      39728 '));
  Check(FiscalPrinter.PrintRecMessage('Транз. продажи: 39727 (2035.98 руб)'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TReceiptTest13.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest13';
end;

{ TReceiptTest14 }

function TReceiptTest14.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest14';
end;

procedure TReceiptTest14.Execute;
begin
  FiscalPrinter.FiscalReceiptType := 4;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('1: 3246505 Морковь 1кг', 0, 1088, 2, 19.9, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 2.92, 0));
  Check(FiscalPrinter.PrintRecItem('2: 3226436 Свекла 1кг', 0, 938, 2, 11.88, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 1.5, 0));
  Check(FiscalPrinter.PrintRecItem('3: 14301 Крупа АГРО-АЛЬЯНС ЭКСТРА 900г', 0, 1000, 2, 59.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 8.1, 0));
  Check(FiscalPrinter.PrintRecItem('4* 2159 СПм Печень говяжья 1кг', 0, 1006, 2, 279.9, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 81.39, 0));
  Check(FiscalPrinter.PrintRecItem('5: 3445579 Лук зеленый пакет 100г', 0, 1000, 2, 33.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 4.58, 0));
  Check(FiscalPrinter.PrintRecItem('6* 1913 Вода СВЯТОЙ ИСТОЧНИК 1.5л', 0, 2000, 1, 29.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 20, 0));
  Check(FiscalPrinter.PrintRecItem('7* 2160076 Филе ПЕРВАЯ СВЕЖЕСТЬ 1кг', 0, 816, 2, 279, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 44.88, 0));
  Check(FiscalPrinter.PrintRecItem('8* 2160076 Филе ПЕРВАЯ СВЕЖЕСТЬ 1кг', 0, 764, 2, 279, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 42.02, 0));
  Check(FiscalPrinter.PrintRecItem('9: 3502731 Паштет КРУГЛЫЙ ГОД 100г', 0, 3000, 2, 15.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 6.48, 0));
  Check(FiscalPrinter.PrintRecItem('10: 3416473 Сметана ТУЛЬСКАЯ 400г', 0, 2000, 2, 62.6, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 16.9, 0));
  Check(FiscalPrinter.PrintRecItem('11: 3490394 Полотенце махровое 35х60', 0, 2000, 1, 69.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 18.88, 0));
  Check(FiscalPrinter.PrintRecItem('12: 3490395 Полотенце махровое 35х60', 0, 3000, 1, 69.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 28.32, 0));
  Check(FiscalPrinter.PrintRecItem('13: 3603169 Крупа УВЕЛКА РИС 400г', 0, 2000, 2, 59.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 16.2, 0));
  Check(FiscalPrinter.PrintRecItem('14: 3024158 Колбаса ДУБКИ вареная 100г', 0, 1008, 2, 424, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 57.72, 0));
  Check(FiscalPrinter.PrintRecItem('15: 3374533 Батон ТХК НАРЕЗНОЙ в/с 350г', 0, 2000, 2, 23.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 6.48, 0));
  Check(FiscalPrinter.PrintRecItem('16: 2163136 Губки РУСАЛОЧКА МАКСИ 10шт', 0, 3000, 1, 35.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 14.58, 0));
  Check(FiscalPrinter.PrintRecItem('17* 3484315 Яйцо КРУГЛЫЙ ГОД 10шт', 0, 1000, 2, 41.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0, 0));
  Check(FiscalPrinter.PrintRecItem('18* 3471166 Печенье ЮБИЛЕЙНОЕ 112г', 0, 4000, 1, 23.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 32.36, 0));
  Check(FiscalPrinter.PrintRecItem('19: 3498263 Зуб.паста COLGATE 75мл', 0, 1000, 1, 129, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 17.42, 0));

  Check(FiscalPrinter.PrintRecSubtotal(1981));
  Check(FiscalPrinter.PrintRecTotal(0, 2000, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TReceiptTest15 }

function TReceiptTest15.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest15';
end;

procedure TReceiptTest15.Execute;
begin
  Check(FiscalPrinter.resetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));

  Check(FiscalPrinter.PrintRecItem('1: 3300463 Пакет КАРУСЕЛЬ 40х65           ', 0, 1000, 1, 6.04, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.02, 0));
  Check(FiscalPrinter.PrintRecItem('2* 3449118 Бумага PAPIA туалетная 8рул    ', 0, 1000, 1, 144, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 44.1, 0));
  Check(FiscalPrinter.PrintRecItem('3* 3635415 Биопродукт АКТИВИА 130г        ', 0, 2000, 2, 41.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 30.18, 0));
  Check(FiscalPrinter.PrintRecItem('4* 3247821 Йогурт VALIO 330г              ', 0, 1000, 2, 59.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 18.09, 0));
  Check(FiscalPrinter.PrintRecItem('5* 3431625 Йогурт VALIO питьевой 330г     ', 0, 1000, 2, 59.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 18.09, 0));
  Check(FiscalPrinter.PrintRecItem('6* 3437101 Йогурт VALIO питьевой 0,4% 330г', 0, 1000, 2, 59.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 18.09, 0));
  Check(FiscalPrinter.PrintRecItem('7* 3624931 Вино ШАТО ТАМАНЬ 0.75л         ', 0, 1000, 1, 179, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0, 0));
  Check(FiscalPrinter.PrintRecItem('8* 3635414 Биопродукт АКТИВИА 130г        ', 0, 2000, 2, 41.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 30.18, 0));
  Check(FiscalPrinter.PrintRecItem('9* 3226440 Лук РЕПЧАТЫЙ 1кг               ', 0, 850, 2, 29.9, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 8.5, 0));
  Check(FiscalPrinter.PrintRecItem('10* 3445023 Авокадо 1шт                   ', 0, 1000, 1, 79.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 30, 0));
  Check(FiscalPrinter.PrintRecItem('11: 3379319 Колбаса ЕГОРЬЕВСКАЯ 100г      ', 0, 254, 1, 1159, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.88, 0));
  Check(FiscalPrinter.PrintRecItem('12: 3471553 Хлеб СТОЛИЧНЫЙ 550г           ', 0, 1000, 2, 25.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.08, 0));
  Check(FiscalPrinter.PrintRecItem('13* 32721 Колбаса МДБ ДОКТОРСКАЯ 100г     ', 0, 856, 2, 749, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 428, 0));
  Check(FiscalPrinter.PrintRecItem('14* 53981 Шейка ЧЕРКИЗОВО свиная 1кг      ', 0, 1050, 2, 389, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 94.5, 0));
  Check(FiscalPrinter.PrintRecItem('15* 53981 Шейка ЧЕРКИЗОВО свиная 1кг      ', 0, 1035, 2, 389, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 93.15, 0));
  Check(FiscalPrinter.PrintRecItem('16* 53981 Шейка ЧЕРКИЗОВО свиная 1кг      ', 0, 1020, 2, 389, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 91.8, 0));
  Check(FiscalPrinter.PrintRecItem('17* 3484315 Яйцо КРУГЛЫЙ ГОД 10шт         ', 0, 1000, 2, 41.9, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0, 0));
  Check(FiscalPrinter.PrintRecItem('18* 79718 Колбаса ВЕЛКОМ 100г             ', 0, 632, 2, 1429, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 492.96, 0));
  Check(FiscalPrinter.PrintRecItem('19* 79718 Колбаса ВЕЛКОМ 100г             ', 0, 632, 2, 1429, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 492.96, 0));
  Check(FiscalPrinter.PrintRecItem('20* 3229648 Лимоны 1кг                    ', 0, 546, 1, 109.9, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 38.22, 0));
  Check(FiscalPrinter.PrintRecItem('21* 3502314 Пиво ZATECKY GUS 0.45л        ', 0, 1000, 1, 55.99, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 21.09, 0));
  Check(FiscalPrinter.PrintRecItem('22у 3433426 Кефир АСЕНЬЕВСКАЯ ФЕРМА 900мл ', 0, 1000, 2, 57.2, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0, 0));
  Check(FiscalPrinter.PrintRecItem('23у 3433426 Кефир АСЕНЬЕВСКАЯ ФЕРМА 900мл ', 0, 1000, 2, 57.2, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0, 0));
  Check(FiscalPrinter.PrintRecItem('24у 3388979 Продукт VELLE 175г            ', 0, 1000, 1, 37.7, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0, 0));
  Check(FiscalPrinter.PrintRecItem('25* 2120341 Масло ПРОСТОКВАШИНО 180г      ', 0, 2000, 2, 139, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 128.2, 0));
  Check(FiscalPrinter.PrintRecItem('26* 3330958 Сок ФРУКТОВЫЙ САД 1,93л       ', 0, 1000, 2, 139, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 69.1, 0));
  Check(FiscalPrinter.PrintRecItem('27* 3255414 Киви 1кг                      ', 0, 1350, 1, 119, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 93.29, 0));

  Check(FiscalPrinter.PrintRecSubtotal(0));
  Check(FiscalPrinter.PrintRecTotal(0, 100000, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TReceiptTest16 }

function TReceiptTest16.GetDisplayText: WideString;
begin
  Result := 'Test multiline text in printRecItem method';
end;

procedure TReceiptTest16.Execute;
var
  Text: WideString;
begin
  Text :=
    '01234567890123456789012345678901234567890123456789' +
    '01234567890123456789012345678901234567890123456789' +
    '0123456789012345678901234567';

  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  FiscalPrinter.PreLine := 'PreLIne 1';
  FiscalPrinter.PostLine := 'PostLIne 1';
  Check(FiscalPrinter.PrintRecItem(Text, 101, 3088, 4, 32.7, ''));
  Check(FiscalPrinter.PrintRecTotal(101, 101, '2'));
  Check(FiscalPrinter.PrintRecMessage('Транз.:      41895 '));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TReceiptTest17 }

function TReceiptTest17.GetDisplayText: WideString;
begin
  Result := 'Open fiscal day test';
end;

procedure TReceiptTest17.Execute;
var
  pData: Integer;
  pString: WideString;
begin
  Check(FiscalPrinter.ResetPrinter());
(*
  pData := 0;
  pString := '';
  Check(FiscalPrinter.DirectIO(DIO_START_OPEN_DAY, pData, pString));
*)  

  pData := 1203;
  pString := '505303696069';
  Check(FiscalPrinter.DirectIO(DIO_WRITE_FS_STRING_TAG, pData, pString));

  pData := 0;
  pString := '';
  Check(FiscalPrinter.DirectIO(DIO_OPEN_DAY, pData, pString));
end;

{ TReceiptTest18 }

function TReceiptTest18.GetDisplayText: WideString;
begin
  Result := 'Check item marking';
end;

procedure TReceiptTest18.Execute;
var
  pData: Integer;
  pString: WideString;
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));

  pString := '5';
  pData := DriverParameterMarkType;
  Check(FiscalPrinter.DirectIO(DIO_SET_DRIVER_PARAMETER, pData, pString));

  pData := DriverParameterBarcode;
  pString :=
    '(01)18901148006025(21)5L1DNSVZD716T(10)DEMO(17)201231' +
    '(240)1111(91)1129(92)mUfZBFCQmjupbDczH0kCErEiLNCktMzv' +
    '+tWG24jDtHwRbPARdskMHHxuHE3h2fGRFX6wtXeQo11QXzLMGWqNcg==';
  Check(FiscalPrinter.DirectIO(DIO_SET_DRIVER_PARAMETER, pData, pString));

  Check(FiscalPrinter.PrintRecItem('Item 1', 101, 1000, 4, 101, ''));
  Check(FiscalPrinter.PrintRecTotal(101, 101, '2'));
  Check(FiscalPrinter.PrintRecMessage('Транз.:      41895 '));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

{ TReceiptTest19 }

function TReceiptTest19.GetDisplayText: WideString;
begin
  Result := 'TReceiptTest19';
end;

procedure TReceiptTest19.Execute;
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.BeginFiscalReceipt(True);
  FiscalPrinter.DirectIO2(9, 5, '                   КАССОВЫЙ ЧЕК                    ');
  FiscalPrinter.DirectIO2(9, 5, 'Касса:281                                     Док:8');
  FiscalPrinter.DirectIO2(30, 72, '4');
  FiscalPrinter.DirectIO2(30, 73, '1');
  FiscalPrinter.PrintRecItem('1861 Напиток SPRITE 2.0л', 4.3, 1000, 1, 4.3, 'шт');
  FiscalPrinter.DirectIO2(9, 5, 'Ваша скидка составила:                         0,70');
  FiscalPrinter.DirectIO2(30, 72, '4');
  FiscalPrinter.DirectIO2(30, 73, '1');
  FiscalPrinter.PrintRecItem('1896 Средство FROSCH ЛИМОН 750мл', 196.94, 1000, 1, 196.94, 'шт');
  FiscalPrinter.DirectIO2(9, 5, 'Ваша скидка составила:                        32,06');
  FiscalPrinter.DirectIO2(30, 72, '4');
  FiscalPrinter.DirectIO2(30, 73, '1');
  FiscalPrinter.PrintRecItem('3757 Бананы 1кг', 430, 1000, 1, 430, 'кг');
  FiscalPrinter.DirectIO2(9, 5, 'Ваша скидка составила:                        70,00');
  FiscalPrinter.DirectIO2(30, 72, '4');
  FiscalPrinter.DirectIO2(30, 73, '1');
  FiscalPrinter.PrintRecItem('9654 Колбаса ЮБИЛЕЙНАЯ в специях 1кг ', 435.15, 1000, 3, 435.15, 'кг');
  FiscalPrinter.DirectIO2(9, 5, 'Ваша скидка составила:                        70,85');
  FiscalPrinter.PrintRecSubtotal(1066.39);
  FiscalPrinter.DirectIO2(9, 5, 'ВАША СУММАРНАЯ СКИДКА:                       173,61');
  FiscalPrinter.DirectIO2(9, 5, '                                                   ');
  FiscalPrinter.DirectIO2(9, 2, 'ИТОГ: 1066,39');
  FiscalPrinter.DirectIO2(9, 5, '                                                   ');
  FiscalPrinter.PrintRecTotal(0, 1066.39, '1');
  FiscalPrinter.DirectIO2(41, 2, '                                                                                                                                                                                                                                                              ');
  FiscalPrinter.DirectIO2(41, 1, '                                                                                                                                                                                                                                                              ');
  FiscalPrinter.DirectIO2(9, 5, '---------------------------------------------------');
  FiscalPrinter.DirectIO2(9, 5, 'Карта Клуба:                           7789****7517');
  FiscalPrinter.DirectIO2(9, 5, 'Начислено, баллов:                              106');
  FiscalPrinter.DirectIO2(9, 5, 'Списано, баллов:                               1236');
  FiscalPrinter.DirectIO2(9, 5, 'Оплачено баллами:                        123,60 руб');
  FiscalPrinter.DirectIO2(9, 5, 'Остаток, баллов:                             195517');
  FiscalPrinter.DirectIO2(9, 5, '---------------------------------------------------');
  FiscalPrinter.DirectIO2(9, 5, 'Магазин "Пятёрочка"                                ');
  FiscalPrinter.DirectIO2(9, 5, 'Москва,ул.Вавилова,д.19,                           ');
  FiscalPrinter.DirectIO2(9, 5, 'тел. 123-4567                                      ');
  FiscalPrinter.DirectIO2(9, 5, '13.02.18                           17:35           ');
  FiscalPrinter.DirectIO2(9, 5, '                  ЧЕК                              ');
  FiscalPrinter.DirectIO2(9, 5, '                 Оплата                            ');
  FiscalPrinter.DirectIO2(9, 5, 'Номер операции:                     0002           ');
  FiscalPrinter.DirectIO2(9, 5, 'Терминал:                       00749970           ');
  FiscalPrinter.DirectIO2(9, 5, 'Пункт обслуживания:         744444445555           ');
  FiscalPrinter.DirectIO2(9, 5, '                   Visa   A0000000031010           ');
  FiscalPrinter.DirectIO2(9, 5, 'Карта:(E);               ************8943           ');
  FiscalPrinter.DirectIO2(9, 5, 'Клиент:                                            ');
  FiscalPrinter.DirectIO2(9, 5, 'Сумма (Руб);:                                       ');
  FiscalPrinter.DirectIO2(9, 5, '             1066.39                               ');
  FiscalPrinter.DirectIO2(9, 5, 'Комиссия за операцию - 0 Руб.                      ');
  FiscalPrinter.DirectIO2(9, 5, '                ОДОБРЕНО                           ');
  FiscalPrinter.DirectIO2(9, 5, 'Код авторизации:                  45Q861           ');
  FiscalPrinter.DirectIO2(9, 5, 'Номер ссылки:               151853253561           ');
  FiscalPrinter.DirectIO2(9, 5, '             Введен ПИН-код                        ');
  FiscalPrinter.DirectIO2(9, 5, '   _________________________________               ');
  FiscalPrinter.DirectIO2(9, 5, '      подпись кассира(контролера);                  ');
  FiscalPrinter.DirectIO2(9, 5, 'BF65AE814907799992E9E345DD9BC2084034FFD3           ');
  FiscalPrinter.DirectIO2(9, 5, '========================================           ');
  FiscalPrinter.DirectIO2(9, 5, '                                                   ');
  FiscalPrinter.DirectIO2(9, 5, '---------------------------------------------------');
  FiscalPrinter.EndFiscalReceipt(True);
end;

{ TReceiptTest20 }

procedure TReceiptTest20.Execute;
const
  Barcode1 = '018123456789123421000000000005M'#$1D'2401234'#$1D'100123456789ABCDEF1234'#$1D'17170911911129'#$1D'92uZoDVpzZRuXoSs79Q54WhebeXNJa1oZ9kTyi09N4vW5E31B7vM3uwo17FIx9fd2T5g9tbVxhR1Wlmt9r3ivSvg==';
  Barcode2 = '000000462000685gk=IYQAQC5pN/f';
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES_SALE;
  FiscalPrinter.BeginFiscalReceipt(True);

  FiscalPrinter.SetParameter(DriverParameterBarcode, Barcode1);
  FiscalPrinter.PrintRecItem('Item 1', 100, 1000, 1, 100, 'шт');

  FiscalPrinter.SetParameter(DriverParameterBarcode, Barcode2);
  FiscalPrinter.PrintRecItem('Item 2', 100, 1000, 1, 100, 'шт');

  FiscalPrinter.PrintRecTotal(200, 200, '0');
  FiscalPrinter.EndFiscalReceipt(True);
end;

function TReceiptTest20.GetDisplayText: WideString;
begin
  Result := 'TReceiptTest20';
end;

{ TReceiptTest21 }

function TReceiptTest21.GetDisplayText: WideString;
begin
  Result := 'TReceiptTest21';
end;

procedure TReceiptTest21.Execute;
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES_SALE;
  FiscalPrinter.BeginFiscalReceipt(True);
  FiscalPrinter.PrintRecItem('Item 1', 100, 1000, 1, 100, 'шт');
  FiscalPrinter.PreLine := 'FiscalPrinter.PreLine';
  FiscalPrinter.PostLine := 'FiscalPrinter.PostLine';
  FiscalPrinter.PrintRecTotal(100, 100, '0');
  FiscalPrinter.EndFiscalReceipt(True);

  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES_RETSALE;
  FiscalPrinter.BeginFiscalReceipt(True);
  FiscalPrinter.PrintRecItem('Item 1', 100, 1000, 1, 100, 'шт');
  FiscalPrinter.PreLine := 'FiscalPrinter.PreLine';
  FiscalPrinter.PostLine := 'FiscalPrinter.PostLine';
  FiscalPrinter.PrintRecTotal(100, 100, '0');
  FiscalPrinter.EndFiscalReceipt(True);

  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES_BUY;
  FiscalPrinter.BeginFiscalReceipt(True);
  FiscalPrinter.PrintRecItem('Item 1', 100, 1000, 1, 100, 'шт');
  FiscalPrinter.PreLine := 'FiscalPrinter.PreLine';
  FiscalPrinter.PostLine := 'FiscalPrinter.PostLine';
  FiscalPrinter.PrintRecTotal(100, 100, '0');
  FiscalPrinter.EndFiscalReceipt(True);

  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES_RETBUY;
  FiscalPrinter.BeginFiscalReceipt(True);
  FiscalPrinter.PrintRecItem('Item 1', 100, 1000, 1, 100, 'шт');
  FiscalPrinter.PreLine := 'FiscalPrinter.PreLine';
  FiscalPrinter.PostLine := 'FiscalPrinter.PostLine';
  FiscalPrinter.PrintRecTotal(100, 100, '0');
  FiscalPrinter.EndFiscalReceipt(True);
end;

{ TCorrectionReceipt2Test }

procedure TCorrectionReceipt2Test.Execute;
begin
  // Sale
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_CORRECTION2_SALE;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.DirectIO2(40, 1177, '77'));
  Check(FiscalPrinter.DirectIO2(40, 1178, '11.05.2018'));
  Check(FiscalPrinter.DirectIO2(40, 1179, '99'));
  Check(FiscalPrinter.PrintRecCash(1.23));
  Check(FiscalPrinter.SetParameter(DriverParameterCorrectionType, 0));
  Check(FiscalPrinter.SetParameter(DriverParameterCalculationSign, 1));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount2, 2));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount3, 3));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount4, 4));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount5, 5));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount6, 6));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount7, 7));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount8, 8));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount9, 9));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount10, 10));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount11, 11));
  Check(FiscalPrinter.SetParameter(DriverParameterAmount12, 12));
  Check(FiscalPrinter.SetParameter(DriverParameterTaxType, 0));
  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TCorrectionReceipt2Test.GetDisplayText: WideString;
begin
  Result := 'Correction receipt 2 test';
end;

{ T6DigitsQuantityTest }

procedure T6DigitsQuantityTest.Execute;
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;

  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('Item 1', 100, 1234567, 0, 100, ''));
  Check(FiscalPrinter.PrintRecTotal(200, 200, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function T6DigitsQuantityTest.GetDisplayText: WideString;
begin
  Result := '6 digits quantity test';
end;

{ TDiscountModeTest }

procedure TDiscountModeTest.Execute;
begin
  Check(FiscalPrinter.ResetPrinter());

  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('1:1861 Напиток SPRITE 2.0л', 5, 1000, 1, 0, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 5, 1));
  Check(FiscalPrinter.PrintRecItem('2*1862 Напиток FANTA 2.0л', 500, 1000, 1, 0.98, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 499.02, 1));
  Check(FiscalPrinter.PrintRecItem('3:1862 Напиток FANTA 2.0л', 500, 1000, 1, 4.89, 'шт'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 495.11, 1));
  Check(FiscalPrinter.PrintRecItem('4:3757 Бананы 1кг', 0.5, 1, 1, 0, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.5, 1));
  Check(FiscalPrinter.PrintRecItem('5:1488 Карамель МОСКОВСКАЯ 1кг', 0.01, 1, 1, 0, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.01, 1));
  Check(FiscalPrinter.PrintRecItem('6:261 Перец оранжевый сладкий 1кг', 0.03, 1, 2, 0, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.03, 1));
  Check(FiscalPrinter.PrintRecItem('7:200 Груши АНЖУ 1кг', 0.15, 1, 1, 0, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 0.15, 1));
  Check(FiscalPrinter.PrintRecItem('8:1488 Карамель МОСКОВСКАЯ 1кг', 15.92, 1234, 1, 0, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 15.92, 1));
  Check(FiscalPrinter.PrintRecItem('9:911 СПм Корейка б/к свиная 1кг', 654.26, 2345, 2, 0, 'кг'));
  Check(FiscalPrinter.PrintRecItemAdjustment(1, '', 654.26, 1));
  Check(FiscalPrinter.PrintRecTotal(100000, 100000, ''));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TDiscountModeTest.GetDisplayText: WideString;
begin
  Result := 'Discount mode test';
end;

{ TLongItemTextTest }

procedure TLongItemTextTest.Execute;
begin
  Check(FiscalPrinter.ResetPrinter());

  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem(StringOfChar('1', 200), 1, 1000, 1, 0, ''));
  Check(FiscalPrinter.PrintRecTotal(100000, 100000, ''));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TLongItemTextTest.GetDisplayText: WideString;
begin
  Result := 'Long item text test';
end;

{ TWriteTagTest }

procedure TWriteTagTest.Execute;
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.FSWriteTag(1171, '+79191234567'));
  //Check(FiscalPrinter.DirectIO(65, 1226, '641300178119')); !!!

  Check(FiscalPrinter.PrintRecItem(StringOfChar('1', 200), 1, 1000, 1, 0, ''));
  Check(FiscalPrinter.PrintRecTotal(100000, 100000, ''));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TWriteTagTest.GetDisplayText: WideString;
begin
  Result := 'Write tag test';
end;

{ TWriteSTLVTest }

procedure TWriteSTLVTest.Execute;
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem(StringOfChar('1', 200), 1, 1000, 1, 0, ''));

  Check(FiscalPrinter.STLVBegin(1059));
  Check(FiscalPrinter.STLVAddTag(1226, '641300178119'));
  Check(FiscalPrinter.STLVWriteOp);

  Check(FiscalPrinter.PrintRecTotal(100000, 100000, ''));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TWriteSTLVTest.GetDisplayText: WideString;
begin
  Result := 'Write TLV test';
end;

{ TReceiptTest22 }

procedure TReceiptTest22.Execute;
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('ТРК 7:Аи-92-К5', 1500, 9804, 4, 153, 'л'));
  Check(FiscalPrinter.PrintRecTotal(1500, 1500, '1'));
  Check(FiscalPrinter.PrintRecMessage('Visa              №                '));
  Check(FiscalPrinter.PrintRecMessage('Оператор: ts'));
  Check(FiscalPrinter.PrintRecMessage('Транз.:       1676 '));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TReceiptTest22.GetDisplayText: WideString;
begin
  Result := 'Receipt test 22';
end;

{ TReceiptTest23 }

procedure TReceiptTest23.Execute;
begin
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('1:3757 Бананы 1кг', 0.01, 1, 1, 10, 'кг'));

  Check(FiscalPrinter.FSWriteTagOperation(1222, '5'));
  Check(FiscalPrinter.FSWriteTagOperation(1226, '641300178119'));


  Check(FiscalPrinter.STLVBegin(1224));
  Check(FiscalPrinter.STLVAddTag(1225, 'ООО "ТПМ групп"'));
  Check(FiscalPrinter.STLVAddTag(1171, '8-926-123-45-67'));
  Check(FiscalPrinter.STLVWriteOp);


  Check(FiscalPrinter.PrintRecItem('2:148 Сыр ПОСАД 30% 1кг ', 0, 1, 3, 0, 'кг'));
  Check(FiscalPrinter.PrintRecItem('3:1488 Карамель МОСКОВСКАЯ 1кг', 0, 1, 1, 2.9, 'кг'));
  Check(FiscalPrinter.PrintRecItem('4:3757 Бананы 1кг', 0.03, 3, 1, 10, 'кг'));
  Check(FiscalPrinter.PrintRecItem('5:902 СПм Антрек.из внут/верх.зад.1кг', 0.06, 7, 2, 8.58, 'кг'));
  Check(FiscalPrinter.PrintRecItem('6:448 Кумкват 1кг ', 0.02, 11, 3, 1.82, 'кг'));
  Check(FiscalPrinter.PrintRecItem('7:888 СПм Внутр.и верх.задняя 1кг', 0.27, 157, 2, 1.72, 'кг'));
  Check(FiscalPrinter.PrintRecSubtotal(0.39));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'ОКРУГЛЕНИЕ', 0.38));
  Check(FiscalPrinter.PrintRecTotal(0, 0.01, '0'));
  FiscalPrinter.EndFiscalReceipt(True);
end;

function TReceiptTest23.GetDisplayText: WideString;
begin
  Result := 'Receipt test 23';
end;

{ TReceiptTest24 }

procedure TReceiptTest24.Execute;
var
  pData: Integer;
  pString: WideString;
begin
  Check(FiscalPrinter.ResetPrinter);

  pData := 1203;
  pString := '505303696069';
  Check(FiscalPrinter.DirectIO(DIO_WRITE_FS_STRING_TAG, pData, pString));

  Check(FiscalPrinter.PrintZReport);


  pData := 1203;
  pString := '505303696069';
  Check(FiscalPrinter.DirectIO(DIO_WRITE_FS_STRING_TAG, pData, pString));

  pData := 0;
  pString := '';
  Check(FiscalPrinter.DirectIO(DIO_OPEN_DAY, pData, pString));
end;

function TReceiptTest24.GetDisplayText: WideString;
begin
  Result := 'Receipt test 24';
end;

{ TReceiptTest25 }

procedure TReceiptTest25.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  // 100% prepaid
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  FiscalPrinter.SetIntParameter(DriverParameterParam3, 1);
  FiscalPrinter.SetIntParameter(DriverParameterParam4, 10);
  Check(FiscalPrinter.PrintRecItem('Item 1', 1200, 48980, 1, 24.50, 'кг'));
  Check(FiscalPrinter.PrintRecTotal(1200, 1200, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
  // Refund
  FiscalPrinter.FiscalReceiptType := FPTR_RT_REFUND;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  FiscalPrinter.SetIntParameter(DriverParameterParam3, 1);
  FiscalPrinter.SetIntParameter(DriverParameterParam4, 10);
  Check(FiscalPrinter.PrintRecItem('Item 1', 141.11, 5760, 1, 24.50, 'кг'));
  Check(FiscalPrinter.PrintRecTotal(141.11, 141.11, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
  // Sale
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  FiscalPrinter.SetIntParameter(DriverParameterParam3, 1);
  FiscalPrinter.SetIntParameter(DriverParameterParam4, 4);
  Check(FiscalPrinter.PrintRecItem('Item 1', 1058.89, 43220, 1, 24.50, 'кг'));
  Check(FiscalPrinter.PrintRecTotal(1058.89, 1058.89, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TReceiptTest25.GetDisplayText: WideString;
begin
  Result := 'Receipt test 25';
end;

{ TReceiptTest26 }

procedure TReceiptTest26.Execute;
var
  DeviceName: WideString;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.GetData2(3, 0, ''));
  Check(FiscalPrinter.GetData2(7, 0, ''));
  Check(FiscalPrinter.GetData2(9, 0, ''));
  DeviceName := FiscalPrinter.DeviceName;
  Check(FiscalPrinter.DirectIO2(18, 193, ''));
  Check(FiscalPrinter.DirectIO2(18, 197, '15500'));
  Check(FiscalPrinter.DirectIO2(18, 201, '96190'));
  Check(FiscalPrinter.DirectIO2(18, 205, '0'));
  Check(FiscalPrinter.DirectIO2(41, 2, '                                                                                                                                                                                                                                                              '));
  Check(FiscalPrinter.DirectIO2(41, 1, '                                                                                                                                                                                                                                                              '));
  FiscalPrinter.PrinterState;
  Check(FiscalPrinter.GetData2(3, 0, ''));
  Check(FiscalPrinter.DirectIO2(9, 5, '                   КАССОВЫЙ ЧЕК                    '));
  Check(FiscalPrinter.DirectIO2(9, 5, 'Касса:5                                    Док:5944'));
  Check(FiscalPrinter.DirectIO2(30, 72, '4'));
  Check(FiscalPrinter.DirectIO2(30, 73, '1'));
  Check(FiscalPrinter.PrintRecItem('1:3661449 Напиток JACOBS 3в1 15г', 33.8, 2000, 1, 16.9, 'шт'));
  Check(FiscalPrinter.DirectIO2(30, 72, '4'));
  Check(FiscalPrinter.DirectIO2(30, 73, '1'));
  Check(FiscalPrinter.PrintRecItem('2*2144975 Вафли МАДАМ НУАР 145г', 29.9, 1000, 1, 29.9, 'шт'));
  Check(FiscalPrinter.DirectIO2(30, 72, '4'));
  Check(FiscalPrinter.DirectIO2(30, 73, '1'));
  Check(FiscalPrinter.PrintRecItem('3*3635413 Биопродукт АКТИВИА 130г', 29.9, 1000, 2, 29.9, 'шт'));
  Check(FiscalPrinter.DirectIO2(30, 72, '4'));
  Check(FiscalPrinter.DirectIO2(30, 73, '1'));
  Check(FiscalPrinter.PrintRecItem('4*3327913 Биопродукт твор.АКТИВИА 130г', 29.9, 1000, 2, 29.9, 'шт'));
  Check(FiscalPrinter.GetData2(1, 0, ''));
  Check(FiscalPrinter.PrintRecSubtotal(123.5));
  Check(FiscalPrinter.PrintRecSubtotalAdjustment(1, 'ОКРУГЛЕНИЕ', 0.5));
  Check(FiscalPrinter.PrintRecTotal(0, 123, '0'));
  FiscalPrinter.PrinterState;
  Check(FiscalPrinter.DirectIO2(9, 5, '* - товар участвует в акции.                       '));
  Check(FiscalPrinter.DirectIO2(9, 5, '---------------------------------------------------'));
  Check(FiscalPrinter.DirectIO2(9, 5, 'Карта Клуба:                           7789****2535'));
  Check(FiscalPrinter.DirectIO2(9, 5, 'Начислено баллов:                                12'));
  Check(FiscalPrinter.DirectIO2(9, 5, 'Остаток баллов:                                 515'));
  Check(FiscalPrinter.DirectIO2(9, 5, '---------------------------------------------------'));
  Check(FiscalPrinter.DirectIO2(40, 1203, '621302598317'));
  Check(FiscalPrinter.DirectIO2(40, 1008, ''));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TReceiptTest26.GetDisplayText: WideString;
begin
  Result := 'Receipt test 26';
end;

{ TReceiptTest27 }

procedure TReceiptTest27.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('1. Item 1', 33.8, 2000, 1, 16.9, 'шт'));
  Check(FiscalPrinter.FSWriteTagOperation(1162, StrToHex('DM'#$02'?'#$14'!1u,*8qbAA68')));
  FiscalPrinter.Check(FiscalPrinter.PrintRecTotal(8000, 8000, '0'));
  Check(FiscalPrinter.PrintRecMessage('Транз.:     280593 '));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TReceiptTest27.GetDisplayText: WideString;
begin
  Result := 'Receipt test 27';
end;

{ TReceiptTest28 }

procedure TReceiptTest28.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('Антифриз Felix Energy 5кг', 160, 1000, 4, 160, 'шт'));
  Check(FiscalPrinter.PrintRecItem('Тосол  5л TATNEFT', 16, 1000, 4, 16, 'шт'));
  Check(FiscalPrinter.PrintRecTotal(176, 176, '0'));
  Check(FiscalPrinter.PrintRecMessage('Транз.:      56330 '));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TReceiptTest28.GetDisplayText: WideString;
begin
  Result := 'Receipt test 28';
end;

{ TReceiptTest29 }

procedure TReceiptTest29.Execute;
const
  Barcode1 = '018123456789123421000000000005M'#$1D'2401234'#$1D+
  '100123456789ABCDEF1234'#$1D'17170911911129'#$1D +
  '92uZoDVpzZRuXoSs79Q54WhebeXNJa1oZ9kTyi09N4vW5E31B7vM3uwo17FIx9fd2T5g9tbVxhR1Wlmt9r3ivSvg==';
  Barcode2 = '8236482763482736482';
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));

  FiscalPrinter.AddItemBarcode(Barcode1);
  //FiscalPrinter.AddItemBarcode(Barcode2);
  Check(FiscalPrinter.PrintRecItem('3689061 Гренки ВОЛНИСТЫЕ 75г', 89.90, 1000, 2, 89.90, ''));

  Check(FiscalPrinter.PrintRecTotal(1000, 1000, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TReceiptTest29.GetDisplayText: WideString;
begin
  Result := 'Receipt test 29';
end;

{ TReceiptTest30 }

procedure TReceiptTest30.Execute;
var
  i: Integer;
  pData: Integer;
  Separator: string;
  pString: WideString;
const
  CashRegisters: array [0..7] of Integer = (
    SMFPTR_CASHREG_GRAND_TOTAL_SALE,
    SMFPTR_CASHREG_GRAND_TOTAL_RETSALE,
    SMFPTR_CASHREG_GRAND_TOTAL_BUY,
    SMFPTR_CASHREG_GRAND_TOTAL_RETBUY,
    SMFPTR_CASHREG_CORRECTION_TOTAL_SALE,
    SMFPTR_CASHREG_CORRECTION_TOTAL_RETSALE,
    SMFPTR_CASHREG_CORRECTION_TOTAL_BUY,
    SMFPTR_CASHREG_CORRECTION_TOTAL_RETBUY);
  CashRegisterNames: array [0..7] of String = (
    'SMFPTR_CASHREG_GRAND_TOTAL_SALE',
    'SMFPTR_CASHREG_GRAND_TOTAL_RETSALE',
    'SMFPTR_CASHREG_GRAND_TOTAL_BUY',
    'SMFPTR_CASHREG_GRAND_TOTAL_RETBUY',
    'SMFPTR_CASHREG_CORRECTION_TOTAL_SALE',
    'SMFPTR_CASHREG_CORRECTION_TOTAL_RETSALE',
    'SMFPTR_CASHREG_CORRECTION_TOTAL_BUY',
    'SMFPTR_CASHREG_CORRECTION_TOTAL_RETBUY');
begin
  Separator := StringOfChar('-', 50);
  AddLine(Separator);
  Check(FiscalPrinter.ResetPrinter);
  //
  for i := Low(CashRegisters) to High(CashRegisters) do
  begin
    pData := CashRegisters[i];
    Check(FiscalPrinter.DirectIO(DIO_READ_CASH_REG, pData, pString));
    AddLine(Format('%-40s: %s', [CashRegisterNames[i], pString]));
  end;
  AddLine(Separator);
end;

function TReceiptTest30.GetDisplayText: WideString;
begin
  Result := 'Receipt grand totals';
end;

{ TReceiptTest31 }

procedure TReceiptTest31.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('2:3026155 СИГАРЕТЫ CHESTERFIELD BLUE 1ПАЧ', 95, 1000, 1, 95, 'шт'));
  Check(FiscalPrinter.DirectIO2(DIO_WRITE_FS_STRING_TAG_OP, 1228, '126356125387'));
  Check(FiscalPrinter.PrintRecTotal(1000, 1000, ''));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TReceiptTest31.GetDisplayText: WideString;
begin
  Result := 'Tag 1197 test';
end;

{ TReceiptTest32 }

procedure TReceiptTest32.Execute;
begin
  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  Check(FiscalPrinter.PrintRecItem('Tax=0', 100, 1000, 0, 100, ''));
  Check(FiscalPrinter.PrintRecItem('Tax=1', 100, 1000, 1, 100, ''));
  Check(FiscalPrinter.PrintRecItem('Tax=2', 100, 1000, 2, 100, ''));
  Check(FiscalPrinter.PrintRecItem('Tax=3', 100, 1000, 3, 100, ''));
  Check(FiscalPrinter.PrintRecItem('Tax=4', 100, 1000, 4, 100, ''));
  Check(FiscalPrinter.PrintRecItem('Tax=5', 100, 1000, 5, 100, ''));
  Check(FiscalPrinter.PrintRecTotal(1000, 1000, ''));
  Check(FiscalPrinter.EndFiscalReceipt(True));
end;

function TReceiptTest32.GetDisplayText: WideString;
begin
  Result := 'Tax amount test';
end;

{ TReceiptTest33 }

procedure TReceiptTest33.Execute;
begin
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;

  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));
  Check(FiscalPrinter.PrintRecItem('Item 1', 1.00, 1000, 1, 1.00, ''));
  Check(FiscalPrinter.PrintRecTotal(1.00, 1.00, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));

  AddLine(Separator);
  AddLine('ФД    : ' + FiscalPrinter.GetParameter(DriverParameterLastDocNum));
  AddLine('ФПД   : ' + FiscalPrinter.GetParameter(DriverParameterLastDocMac));
  AddLine('Дата  : ' + FiscalPrinter.GetParameter(DriverParameterLastDocDateTime));
  AddLine('Сумма : ' + FiscalPrinter.GetParameter(DriverParameterLastDocTotal));
  AddLine(Separator);
end;

function TReceiptTest33.GetDisplayText: WideString;
begin
  Result := 'ReceiptTest33';
end;

{ TReceiptTest34 }

procedure TReceiptTest34.Execute;
begin
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;

  Check(FiscalPrinter.ResetPrinter);
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(True));

  Check(FiscalPrinter.STLVBegin(1256));
  Check(FiscalPrinter.STLVAddTag(1227, 'Иванов Иван Иванович'));
  Check(FiscalPrinter.STLVAddTag(1228, '505303696069'));
  Check(FiscalPrinter.STLVWrite);

  Check(FiscalPrinter.PrintRecItem('Item 1', 1.00, 1000, 1, 1.00, ''));
  Check(FiscalPrinter.PrintRecTotal(1.00, 1.00, '0'));
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

function TReceiptTest34.GetDisplayText: WideString;
begin
  Result := 'Tag 1256 test';
end;


{ TReceiptTest35 }

procedure TReceiptTest35.Execute;
begin
  Memo.Lines.Clear;
  Memo.Update;
  Application.ProcessMessages;
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);

  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));

  AddLine('DirectIO2(71, 0, 1005239)');
  Check(FiscalPrinter.DirectIO2(71, 0, '1005239'));

  AddLine('PrintRecItemRefund');
  Check(FiscalPrinter.PrintRecItemRefund('Сахар', 63.83, 555000, 2, 115, ''));

  AddLine('DirectIO2(65, 2108, 0)');
  Check(FiscalPrinter.DirectIO2(65, 2108, '0'));

  AddLine('PrintRecSubTotal');
  Check(FiscalPrinter.PrintRecSubTotal(0));

  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(63.83, 63.83, '0'));

  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(True));

  AddLine(Separator);
  AddLine('Test completed !');
end;

function TReceiptTest35.GetDisplayText: WideString;
begin
  Result := 'Refund receipt test 35';
end;

end.
