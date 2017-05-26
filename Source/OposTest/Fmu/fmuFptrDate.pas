unit fmuFptrDate;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrDate = class(TPage)
    lblDateType: TLabel;
    cbDateType: TComboBox;
    btnSetDate: TButton;
    lblDate: TLabel;
    edtDate: TEdit;
    btnGetDate: TButton;
    btnCurrentDateTime: TButton;
    procedure btnSetDateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGetDateClick(Sender: TObject);
    procedure btnCurrentDateTimeClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmSetDate }

procedure TfmFptrDate.btnSetDateClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.DateType := cbDateType.ItemIndex + 1;
    FiscalPrinter.SetDate(edtDate.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDate.FormCreate(Sender: TObject);
begin
  if cbDateType.Items.Count > 0 then
    cbDateType.ItemIndex := 0;
  edtDate.Text := DateTime2Str(Now);
end;

procedure TfmFptrDate.btnGetDateClick(Sender: TObject);
var
  S: WideString;
begin
  EnableButtons(False);
  try
    FiscalPrinter.DateType := cbDateType.ItemIndex + 1;
    FiscalPrinter.GetDate(S);
    edtDate.Text := S;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDate.btnCurrentDateTimeClick(Sender: TObject);
begin
  edtDate.Text := DateTime2Str(Now);
end;

end.
