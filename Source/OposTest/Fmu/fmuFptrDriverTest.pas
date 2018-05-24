unit fmuFptrDriverTest;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, ActiveX, ComObj,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, OposUtils, AlignStrings, DriverTest, PrinterTest;

type
  { TfmDriverTest }

  TfmFptrDriverTest = class(TPage)
    Memo: TTntMemo;
    ListBox: TTntListBox;
    btnDayOpenedTest: TTntButton;
    procedure btnDayOpenedTestClick(Sender: TObject);
  private
    FTests: TDriverTests;
    procedure AddTest(TestClass: TDriverTestClass);

    property Tests: TDriverTests read FTests;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.DFM}

{ TfmDriverTest }

constructor TfmFptrDriverTest.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTests := TDriverTests.Create;
  AddTest(TDayOpenedTest);
  AddTest(TSetPOSIDTest);
  AddTest(TAdditionalHeaderTest);
  AddTest(TTenderNameTest);
  AddTest(TZReportTest);
  AddTest(TChangeTest);
  AddTest(THeaderTrailerTest);
  AddTest(TFrameLengthTest);
  AddTest(TCashInTest);
  AddTest(TCashOutTest);
  AddTest(TDirectIOTest1);
  AddTest(TDirectIOTest2);
  AddTest(TDateTest);
  AddTest(TX5Test);
  AddTest(TGlobusReceiptTest);
  AddTest(TCancelReceiptTest);
  AddTest(TStornoReceiptTest);
  AddTest(TReadEJACtivationResultTest);
  AddTest(TReadEJACtivationResultTest2);
  AddTest(TReadEJACtivationResultTest3);
  AddTest(TReadEJACtivationResultTest4);
  AddTest(TBoldTextTest);
  AddTest(TPrint10Test);
  AddTest(TPrint20Test);
  AddTest(TPrintNormalTest);
  //AddTest(TRecNearEndTest); { !!! }
end;

destructor TfmFptrDriverTest.Destroy;
begin
  FTests.Free;
  inherited Destroy;
end;

procedure TfmFptrDriverTest.AddTest(TestClass: TDriverTestClass);
var
  Test: TDriverTest;
begin
  Test := TestClass.Create(FTests, Memo);
  ListBox.Items.Add(Format('%2d. %s', [FTests.Count, Test.GetDisplayText]));
end;

procedure TfmFptrDriverTest.btnDayOpenedTestClick(Sender: TObject);
var
  Test: TDriverTest;
begin
  EnableButtons(False);
  try
    Test := Tests[ListBox.ItemIndex];
    Test.Memo.Clear;
    Test.Execute;
  finally
    EnableButtons(True);
  end;
end;

end.
