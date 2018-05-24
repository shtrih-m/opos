unit duFSSalesReceipt;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Forms,
  // DUnit
  TestFramework,
  // This
  fmuTest, fmuSelect, fmuEMail, fmuPhone, CustomReceipt, RegExpr, LogFile,
  FormUtils;

type
  { TFSSalesReceiptTest }

  TFSSalesReceiptTest = class(TTestCase)
  private
    FTerminated: Boolean;
  public
    procedure StartFormThread;
    procedure ExecuteThreadProc;

    procedure CheckShowEMailDlg;
    procedure CheckDisableWindow;
  published
    procedure TestRegExpr;
  end;

implementation

{ TFSSalesReceiptTest }

function ThreadProc(Item: TFSSalesReceiptTest): Integer;
begin
  Result := 1;
  try
    Item.ExecuteThreadProc;
  finally
    EndThread(Result);
  end;
end;

procedure TFSSalesReceiptTest.ExecuteThreadProc;
begin
  try
    FTerminated := False;
    while not FTerminated do
    begin
      fmTest.Show;
      Sleep(100);
    end;
  except
    on E: Exception do
    begin
      //Logger.Error(E.Message);
    end;
  end;
  fmTest.Free;
end;

procedure TFSSalesReceiptTest.StartFormThread;
var
  Handle, ThreadID: DWORD;
begin
  Handle := BeginThread(nil, 0, @ThreadProc, Pointer(Self), 0, ThreadID);
  if (Handle <> 0) then CloseHandle(Handle);
end;

procedure TFSSalesReceiptTest.CheckShowEMailDlg;
var
  Selection: Integer;
  CustomerPhone: WideString;
  CustomerEMail: WideString;
begin
  Selection := ShowSelectDlg;

  if Selection = SelectNone then Exit;
  if Selection = SelectPhone then
  begin
    CustomerPhone := '+7';
    ShowPhoneDlg(CustomerPhone);
    CheckEquals('+79168191324', CustomerPhone, 'CustomerPhone <> +79168191324');
  end;
  if Selection = SelectEMail then
  begin
    CustomerEMail := '';
    ShowEMailDlg(CustomerEMail);
    CheckEquals('kravtsov@shtrih-m.ru', LowerCase(CustomerEMail), 'CustomerEMail <> kravtsov@shtrih-m.ru');
  end;
end;

procedure TFSSalesReceiptTest.TestRegExpr;
const
  RExpr = '[0-9]+[.,][0-9 ]+[X*][0-9 ]+[.,][0-9]+';
begin
  Check(ExecRegExpr(RExpr, '123,45 X 34,67'), '123,45 X 34,67');
  Check(ExecRegExpr(RExpr, '123.45 X 34.67'), '123.45 X 34.67');
  Check(ExecRegExpr(RExpr, '123.45 * 34.67'), '123.45 * 34.67');
  Check(ExecRegExpr(RExpr, '123.45 *34,67'), '123.45 *34,67');
end;

procedure TFSSalesReceiptTest.CheckDisableWindow;
var
  Form1: TForm;
  Form2: TForm;
begin
  Form1 := TForm.Create(Application);
  Form1.Caption := 'Form1';
  Form1.Height := 300;
  Form1.Width := 300;
  Form1.Left := 100;
  Form1.Top := 100;

  Form2 := TForm.Create(Application);
  Form2.Caption := 'Form2';
  Form2.Height := 300;
  Form2.Width := 300;
  Form2.Left := 200;
  Form2.Top := 200;

  Form1.Show;
  Form2.Show;

  DisableForms(Form1.Handle);
  Form1.SetFocus;
end;

initialization
  RegisterTest('', TFSSalesReceiptTest.Suite);

end.
