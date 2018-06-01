unit fmuFptrDirectIO;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // Tnt
  TntSysUtils, TntStdCtrls,
  // This
  untPages, OposFiscalPrinter, DirectIOAPI, Opos, DIODescription;

type
  { TfmFptrDirectIO }

  TfmFptrDirectIO = class(TPage)
    lblData: TTntLabel;
    btnExecute: TTntButton;
    lblString: TTntLabel;
    edtInString: TTntEdit;
    edtData: TTntEdit;
    lblCommand: TTntLabel;
    lblOutString: TTntLabel;
    edtOutString: TTntEdit;
    memInfo: TTntMemo;
    cbCommand: TTntComboBox;
    edtCustomCommand: TTntEdit;
    lblCustom: TTntLabel;
    lblDescription: TTntLabel;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCommandChange(Sender: TObject);
  private
    procedure FillComboBox;
  end;

implementation

{$R *.DFM}

{ TfmSetDate }

procedure TfmFptrDirectIO.btnExecuteClick(Sender: TObject);
var
  Result: Integer;
  pData: Integer;
  pString: WideString;
  Command: Integer;
begin
  EnableButtons(False);
  try
    edtOutString.Text := '';
    Command := Integer(cbCommand.Items.Objects[cbCommand.ItemIndex]);
    if Command = DIO_CUSTOM_COMMAND then
      Command := StrToInt(edtCustomCommand.Text);
    pString := edtInString.Text;
    pData := StrToIntDef(edtData.Text, 0);
    Result := FiscalPrinter.DirectIO(Command, pData, pString);
    if Result = OPOS_SUCCESS then
    begin
      edtOutString.Text := pString;
      edtData.Text := IntToStr(pData);
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDirectIO.FillComboBox;
var
  i: Integer;
  S: WideString;
begin
  cbCommand.Clear;
  for i := Low(DIODescriptions) to High(DIODescriptions) do
  begin
    if DIODescriptions[i].Command = DIO_CUSTOM_COMMAND then
      S := DIODescriptions[i].Description
    else
      S := Tnt_WideFormat('%d (%s)',
      [DIODescriptions[i].Command, DIODescriptions[i].Description]);
    cbCommand.AddItem(S, TObject(DIODescriptions[i].Command));
  end;
  if cbCommand.Items.Count > 0 then
    cbCommand.ItemIndex := 0;
end;

procedure TfmFptrDirectIO.FormCreate(Sender: TObject);
begin
  FillComboBox;
  cbCommandChange(Self);
end;

procedure TfmFptrDirectIO.cbCommandChange(Sender: TObject);
begin
  edtCustomCommand.Enabled := Integer(cbCommand.Items.Objects[cbCommand.ItemIndex]) = DIO_CUSTOM_COMMAND;
  if edtCustomCommand.Enabled then
    edtCustomCommand.Color := clWindow
  else edtCustomCommand.Color := clBtnFace;
  memInfo.Text := GetDIODescription(Integer(cbCommand.Items.Objects[cbCommand.ItemIndex])).DescriptionEx;
end;

end.
