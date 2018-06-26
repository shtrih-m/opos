unit fmuFiscalPrinter;

interface

uses
  // VCL
  Windows, StdCtrls, Controls, ExtCtrls, Classes, Forms, SysUtils,
  Registry, ComCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils, TntComCtrls, 
  // Opos
  OposFptrUtils, OposUtils,
  // This
  BaseForm, untPages, OposFiscalPrinter, VersionInfo,
  fmuFptrInfo, fmuFptrGeneral, fmuFptrReceipt, fmuFptrNonFiscal,
  fmuFptrFiscalReports, fmuFptrRecItem, fmuFptrRecItemAdjust,
  fmuFptrRecMessage, fmuFptrRecNotPaid, fmuFptrRecPackageAdjustment,
  fmuFptrRecPackageAdjustVoid, fmuFptrRecRefund, fmuFptrRecRefundVoid,
  fmuFptrRecSubtotalAdjustment, fmuFptrRecSubtotalAdjustVoid, fmuFptrRecTaxID,
  fmuFptrRecTotal, fmuFptrRecSubtotal, fmuFptrFiscalDocument, fmuFptrSetVatTable,
  fmuFptrDate, fmuFptrSlipInsertion, fmuFptrSetLine, fmuFptrProperties,
  fmuFptrAddHeaderTrailer, fmuFptrGetData, fmuFptrRecCash,
  fmuFptrWritableProperties, fmuFptrSetHeadertrailer, fmuFptrDriverTest,
  fmuFptrDirectIOHex, fmuFptrDirectIOStr, fmuFptrDirectIOEndDay, fmuFptrDirectIO,
  fmuFptrDirectIOBarcode, fmuFptrDirectIOFS, fmuFptrTraining, fmuFptrReceiptTest,
  fmuPrintRecVoidItem, fmuPrintRecItemRefund, fmuPrintRecItemRefundVoid,
  fmuFptrStatistics, fmuFptrMonitoring,
  fmuFptrEvents, fmuFptrTest, fmuFptrThreadTest, fmuFptrFiscalStorage,
  fmuFptrTest2,
  {$IFDEF MALINA}
  fmuMalina,
  fmuTextBlock,
  fmuTextReceipt,
  fmuTankReport,
  fmuFptrFroudReceipt,
  {$ENDIF}
  DebugUtils, TntExtCtrls;

type
  { TfmMain }

  TfmFiscalPrinter = class(TBaseForm)
    pnlData: TTntPanel;
    Panel1: TTntPanel;
    lblTime: TTntLabel;
    lblResult: TTntLabel;
    lblExtendedResult: TTntLabel;
    lblPrinterState: TTntLabel;
    lblErrorString: TTntLabel;
    edtTime: TTntEdit;
    edtResult: TTntEdit;
    edtExtendedResult: TTntEdit;
    edtPrinterState: TTntEdit;
    edtErrorString: TTntEdit;
    Panel2: TTntPanel;
    lbPages: TTntListBox;
    procedure lbPagesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    FPages: TPages;
    FLastPage: TForm;
    FStarted: Boolean;
    FTickCount: DWORD;
    procedure CreatePages;
    procedure ShowPage(Page: TPage);
    procedure UpdatePage(Sender: TObject);
    procedure StartCommand(Sender: TObject);
    procedure AddPage(PageClass: TPageClass);
    procedure UpdatePages(ListBox: TTntListBox; Pages: TPages);
  protected
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmFiscalPrinter: TfmFiscalPrinter;

implementation

{$R *.DFM}

{ TfmMain }

constructor TfmFiscalPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TPages.Create;
end;

destructor TfmFiscalPrinter.Destroy;
begin
  ODS('TfmFiscalPrinter.Destroy.0');

  FPages.Free;
  FreeFiscalPrinter;
  inherited Destroy;

  ODS('TfmFiscalPrinter.Destroy.1');
end;

procedure TfmFiscalPrinter.ReadState(Reader: TReader);
var
  Value: Integer;
begin
  DisableAlign;
  try
    inherited ReadState(Reader);
    Value := GetSystemMetrics(SM_CYCAPTION);
    Height := Height + (Value-19);
  finally
    EnableAlign;
  end;
end;

procedure TfmFiscalPrinter.AddPage(PageClass: TPageClass);
var
  Page: TPage;
begin
  Page := PageClass.Create(Self);
  Page.OnUpdate := UpdatePage;
  Page.OnStart := StartCommand;
  Page.BorderStyle := bsNone;
  Page.Parent := pnlData;
  Page.Width := pnlData.ClientHeight;
  Page.Height := pnlData.ClientHeight;
  FPages.InsertItem(Page);
end;

procedure TfmFiscalPrinter.CreatePages;
begin
  // General pages
  AddPage(TfmFptrInfo);
  AddPage(TfmFptrGeneral);
  AddPage(TfmFptrReceiptTest);
  AddPage(TfmFptrEvents);
  AddPage(TfmFptrNonFiscal);
  AddPage(TfmFptrTraining);
  AddPage(TfmFptrFiscalReports);
  AddPage(TfmFptrFiscalStorage);
  // Receipt pages
  AddPage(TfmFptrReceipt);
  AddPage(TfmFptrRecItem);
  //AddPage(TfmFptrRecItemVoid);
  AddPage(TfmPrintRecVoidItem);
  AddPage(TfmFptrRecItemAdjust);
  AddPage(TfmPrintRecItemRefund);
  AddPage(TfmPrintRecItemRefundVoid);
  AddPage(TfmFptrRecMessage);
  AddPage(TfmFptrRecNotPaid);
  AddPage(TfmFptrRecPackageAdjustment);
  AddPage(TfmFptrRecPackageAdjustVoid);
  AddPage(TfmFptrRecRefund);
  AddPage(TfmFptrRecRefundVoid);
  AddPage(TfmFptrRecSubtotalAdjustment);
  AddPage(TfmFptrRecSubtotalAdjustVoid);
  AddPage(TfmFptrRecTaxID);
  AddPage(TfmFptrRecTotal);
  AddPage(TfmFptrRecSubtotal);
  AddPage(TfmFptrRecCash);
  // Others
  AddPage(TfmFptrSlipInsertion);
  AddPage(TfmFptrFiscalDocument);
  AddPage(TfmFptrDate);
  AddPage(TfmFptrSetVatTable);
  AddPage(TfmFptrSetLine);
  AddPage(TfmFptrProperties);
  AddPage(TfmFptrWritableProperties);
  AddPage(TfmFptrGetData);
  AddPage(TfmFptrSetHeaderTrailer);
  AddPage(TfmFptrAddHeaderTrailer);
  // DirectIO
  AddPage(TfmFptrDirectIO);
  AddPage(TfmFptrDirectIOHex);
  AddPage(TfmFptrDirectIOStr);
  AddPage(TfmFptrDirectIOEndDay);
  AddPage(TfmFptrDirectIOBarcode);
  AddPage(TfmFptrDirectIOFS);
  // Driver tests
  AddPage(TfmFptrDriverTest);
  AddPage(TfmFptrStatistics);
  AddPage(TfmFptrMonitoring);
  // Malina
  {$IFDEF MALINA}
  AddPage(TfmMalina);
  AddPage(TfmTextBlock);
  AddPage(TfmTextReceipt);
  AddPage(TfmTankReport);
  AddPage(TfmFptrFroudReceipt);
  {$ENDIF}
  AddPage(TfmFptrTest);
  //AddPage(TfmFptrThreadTest);
  //AddPage(TfmFptrTest2);
end;

procedure TfmFiscalPrinter.UpdatePages(ListBox: TTntListBox; Pages: TPages);
var
  i: Integer;
  PageName: WideString;
begin
  with ListBox do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      for i := 0 to Pages.Count-1 do
      begin
        PageName := Tnt_WideFormat('%.2d. %s', [i+1, Pages[i].Caption]);
        Items.Add(PageName);
      end;
    finally
      Items.EndUpdate;
    end;
  end;
  if Pages.Count > 0 then
  begin
    ListBox.ItemIndex := 0;
    ShowPage(Pages[0]);
  end;
end;

procedure TfmFiscalPrinter.StartCommand(Sender: TObject);
begin
  FStarted := True;
  FTickCount := GetTickCount;
end;

procedure TfmFiscalPrinter.UpdatePage(Sender: TObject);
var
  S: WideString;
begin
  S := FiscalPrinter.ErrorString;
  edtErrorString.Text := FiscalPrinter.ErrorString;
  if FStarted then
  begin
    edtTime.Text := IntToStr(GetTickCount - FTickCount) + ' ms.';
    FStarted := False;
  end else edtTime.Clear;

  edtResult.Text := GetResultCodeText(FiscalPrinter.ResultCode);
  edtExtendedResult.Text := GetResultCodeExtendedText(FiscalPrinter.ResultCodeExtended);
  edtPrinterState.Text := PrinterStateToStr(FiscalPrinter.PrinterState);
end;

procedure TfmFiscalPrinter.ShowPage(Page: TPage);
begin
  if Page <> FLastPage then
  begin
    if Page <> nil then
    begin
      Page.Align := alClient;
      Page.Visible := True;
      Page.Width := pnlData.ClientWidth;
    end;
    if FLastPage <> nil then
      FLastPage.Visible := False;
    FLastPage := Page;
  end;
end;

// Events

procedure TfmFiscalPrinter.lbPagesClick(Sender: TObject);
begin
  ShowPage(FPages[lbPages.ItemIndex]);
end;

procedure TfmFiscalPrinter.FormCreate(Sender: TObject);
begin
  CreatePages;
  UpdatePages(lbPages, FPages);
  ShowPage(FPages[0]);
end;

procedure TfmFiscalPrinter.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
