unit fmuFptrGetData;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrGetData = class(TPage)
    btnGetData: TButton;
    lblDataItem: TLabel;
    edtDataItem: TEdit;
    cbDataItem: TComboBox;
    lblOptArgs: TLabel;
    edtOptArgs: TEdit;
    lblData: TLabel;
    edtData: TEdit;
    lblVatID: TLabel;
    Label1: TLabel;
    lblTotalizerType: TLabel;
    btnGetTotalizer: TButton;
    edtVatID: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    cbTotalizerType: TComboBox;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure btnGetDataClick(Sender: TObject);
    procedure cbDataItemChange(Sender: TObject);
    procedure btnGetTotalizerClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrGetData.FormCreate(Sender: TObject);
begin
  if cbDataItem.Items.Count > 0 then
    cbDataItem.ItemIndex := 0;
end;

procedure TfmFptrGetData.cbDataItemChange(Sender: TObject);
begin
  edtDataItem.Text := IntToStr(cbDataItem.ItemIndex + 1);
end;

procedure TfmFptrGetData.btnGetDataClick(Sender: TObject);
var
  Data: WideString;
  OptArgs: Integer;
begin
  EnableButtons(False);
  try
    OptArgs := StrToInt(edtOptArgs.Text);
    FiscalPrinter.GetData(StrToInt(edtDataItem.Text), OptArgs, Data);
    edtData.Text := Data;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGetData.btnGetTotalizerClick(Sender: TObject);
var
  Data: WideString;
begin
  EnableButtons(False);
  try
    FiscalPrinter.GetTotalizer(StrToInt(edtVatID.Text),
      StrToInt(edtOptArgs.Text), Data);
    edtData.Text := Data;
  finally
    EnableButtons(True);
  end;
end;

end.
