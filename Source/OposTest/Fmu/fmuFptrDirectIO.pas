unit fmuFptrDirectIO;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // This
  untPages, OposFiscalPrinter, DirectIOAPI, Opos, DIODescription;

type
  TfmFptrDirectIO = class(TPage)
    lblData: TLabel;
    btnExecute: TButton;
    lblString: TLabel;
    edtInString: TEdit;
    edtData: TEdit;
    lblCommand: TLabel;
    lblOutString: TLabel;
    edtOutString: TEdit;
    memInfo: TMemo;
    cbCommand: TComboBox;
    edtCustomCommand: TEdit;
    lblCustom: TLabel;
    lblDescription: TLabel;
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
    pData := StrToInt(edtData.Text);
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
  S: string;
begin
  cbCommand.Clear;
  for i := Low(DIODescriptions) to High(DIODescriptions) do
  begin
    if DIODescriptions[i].Command = DIO_CUSTOM_COMMAND then
      S := DIODescriptions[i].Description
    else
      S := Format('%d (%s)',
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
