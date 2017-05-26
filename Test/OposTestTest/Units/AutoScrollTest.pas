unit AutoScrollTest;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Forms,
  // This
  TestFramework, PrinterParametersX, PrinterParameters, FileUtils,
  fmuAbout, fmuCashDrawer, fmuCashGeneral, fmuCashWait,
  fmuFiscalPrinter, fmuFptrAddHeaderTrailer, fmuFptrDate,
  fmuFptrDirectIO, fmuFptrDirectIOBarcode, fmuFptrDirectIOEndDay,
  fmuFptrDirectIOHex, fmuFptrDirectIOStr, fmuFptrDriverTest,
  fmuFptrFiscalDocument, fmuFptrFiscalReports, fmuFptrGeneral,
  fmuFptrGetData, fmuFptrInfo, fmuFptrNonFiscal, fmuFptrProperties,
  fmuFptrRecCash, fmuFptrReceipt, fmuFptrReceiptTest, fmuFptrRecItem,
  fmuFptrRecItemAdjust,
  fmuFptrRecItemVoid,
  fmuFptrRecMessage, 
  fmuFptrRecNotPaid, 
  fmuFptrRecPackageAdjustment, 
  fmuFptrRecPackageAdjustVoid, 
  fmuFptrRecRefund, 
  fmuFptrRecRefundVoid,
  fmuFptrRecSubtotal, 
  fmuFptrRecSubtotalAdjustment, 
  fmuFptrRecSubtotalAdjustVoid, 
  fmuFptrRecTaxID, 
  fmuFptrRecTotal, 
  fmuFptrSetHeaderTrailer, 
  fmuFptrSetLine, 
  fmuFptrSetVatTable, 
  fmuFptrSlipInsertion, 
  fmuFptrTraining, 
  fmuFptrWritableProperties, 
  fmuMain, 
  fmuPosPrinter, 
  fmuPrintRecItemRefund, 
  fmuPrintRecItemRefundVoid, 
  fmuPrintRecVoidItem, 
  fmuPtrGeneral;


type
  { TAutoScrollTest }

  TAutoScrollTest = class(TTestCase)
  private
    procedure CheckAutoScroll(FormClass: TFormClass);
  published
    procedure CheckForms;
  end;

implementation

{ TAutoScrollTest }

procedure TAutoScrollTest.CheckAutoScroll(FormClass: TFormClass);
var
  Form: TForm;
begin
  Form := FormClass.Create(nil);
  try
    CheckEquals(False, Form.AutoScroll, 'AutoScroll=True. Form=' + Form.ClassName);
  finally
    Form.Free;
  end;
end;

procedure TAutoScrollTest.CheckForms;
begin
  CheckAutoScroll(TfmAbout);
  CheckAutoScroll(TfmCashDrawer);
  CheckAutoScroll(TfmCashGeneral);
  CheckAutoScroll(TfmCashWait);
  CheckAutoScroll(TfmFiscalPrinter);
  CheckAutoScroll(TfmFptrAddHeaderTrailer);
  CheckAutoScroll(TfmFptrDate);
  CheckAutoScroll(TfmFptrDirectIO);
  CheckAutoScroll(TfmFptrDirectIOBarcode);
  CheckAutoScroll(TfmFptrDirectIOEndDay);
  CheckAutoScroll(TfmFptrDirectIOHex);
  CheckAutoScroll(TfmFptrDirectIOStr);
  CheckAutoScroll(TfmFptrDriverTest);
  CheckAutoScroll(TfmFptrFiscalDocument);
  CheckAutoScroll(TfmFptrFiscalReports);
  CheckAutoScroll(TfmFptrGeneral);
  CheckAutoScroll(TfmFptrGetData);
  CheckAutoScroll(TfmFptrInfo);
  CheckAutoScroll(TfmFptrNonFiscal);
  CheckAutoScroll(TfmFptrProperties);
  CheckAutoScroll(TfmFptrRecCash);
  CheckAutoScroll(TfmFptrReceipt);
  CheckAutoScroll(TfmFptrReceiptTest);
  CheckAutoScroll(TfmFptrRecItem);
  CheckAutoScroll(TfmFptrRecItemAdjust);
  CheckAutoScroll(TfmFptrRecItemVoid);
  CheckAutoScroll(TfmFptrRecMessage);
  CheckAutoScroll(TfmFptrRecNotPaid);
  CheckAutoScroll(TfmFptrRecPackageAdjustment);
  CheckAutoScroll(TfmFptrRecPackageAdjustVoid);
  CheckAutoScroll(TfmFptrRecRefund);
  CheckAutoScroll(TfmFptrRecRefundVoid);
  CheckAutoScroll(TfmFptrRecSubtotal);
  CheckAutoScroll(TfmFptrRecSubtotalAdjustment);
  CheckAutoScroll(TfmFptrRecSubtotalAdjustVoid);
  CheckAutoScroll(TfmFptrRecTaxID);
  CheckAutoScroll(TfmFptrRecTotal);
  CheckAutoScroll(TfmFptrSetHeaderTrailer);
  CheckAutoScroll(TfmFptrSetLine);
  CheckAutoScroll(TfmFptrSetVatTable);
  CheckAutoScroll(TfmFptrSlipInsertion);
  CheckAutoScroll(TfmFptrTraining);
  CheckAutoScroll(TfmFptrWritableProperties);
  CheckAutoScroll(TfmMain);
  CheckAutoScroll(TfmPosPrinter);
  CheckAutoScroll(TfmPrintRecItemRefund);
  CheckAutoScroll(TfmPrintRecItemRefundVoid);
  CheckAutoScroll(TfmPrintRecVoidItem);
  CheckAutoScroll(TfmPtrGeneral);
end;

initialization
  RegisterTest('', TAutoScrollTest.Suite);

end.
