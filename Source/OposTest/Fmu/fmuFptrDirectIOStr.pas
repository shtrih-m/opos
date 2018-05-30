unit fmuFptrDirectIOStr;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils, TntClasses, 
  // This
  untPages, OposFiscalPrinter, DirectIOAPI, Opos, CommandDef,
  CommandParam, BStrUtil, LogFile;

type
  TfmFptrDirectIOStr = class(TPage)
    lblTxData: TTntLabel;
    btnExecute: TTntButton;
    lblRxData: TTntLabel;
    edtRxData: TTntEdit;
    edtTxData: TTntEdit;
    lblCommand: TTntLabel;
    cbCommand: TTntComboBox;
    memCommand: TTntMemo;
    lblDescription: TTntLabel;
    Label1: TTntLabel;
    memAnswer: TTntMemo;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCommandChange(Sender: TObject);
  private
    function GetCommands: TCommandDefs;
    procedure UpdateCommandText(const S: WideString);
  private
    FCommands: TCommandDefs;
    procedure UpdateCommandHint;

    property Commands: TCommandDefs read GetCommands;
  public
    destructor Destroy; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrDirectIOStr }

destructor TfmFptrDirectIOStr.Destroy;
begin
  FCommands.Free;
  inherited Destroy;
end;

function TfmFptrDirectIOStr.GetCommands: TCommandDefs;
begin
  if FCommands = nil then
    FCommands := TCommandDefs.Create(FiscalPrinter.Logger);
  Result := FCommands;
end;

procedure TfmFptrDirectIOStr.UpdateCommandHint;
var
  i: Integer;
  Strings: TTntStrings;
  Param: TCommandParam;
  Command: TCommandDef;
begin
  if cbCommand.ItemIndex = -1 then Exit;

  Strings := TTntStringList.Create;
  try
    Command := Commands[cbCommand.ItemIndex];
    Strings.Add(Command.Name);
    // Command
    Strings.Add(Format('Command : 0x%.2xh', [Command.Code]));
    for i := 0 to Command.InParams.Count-1 do
    begin
      Param := Command.InParams[i];
      Strings.Add(Format('          - %s (%d bytes)', [Param.Name, Param.Size]));
    end;
    // Answer
    Strings.Add(Format('Answer  : 0x%.2xh', [Command.Code]));
    for i := 0 to Command.OutParams.Count-1 do
    begin
      Param := Command.OutParams[i];
      Strings.Add(Format('          - %s (%d bytes)', [Param.Name, Param.Size]));
    end;
    memCommand.Text := Strings.Text;
  finally
    Strings.Free;
  end;
end;

procedure TfmFptrDirectIOStr.UpdateCommandText(const S: WideString);
var
  i: Integer;
  Strings: TTntStrings;
  Param: TCommandParam;
  Command: TCommandDef;
begin
  Strings := TTntStringList.Create;
  try
    Command := Commands[cbCommand.ItemIndex];
    Strings.Add(Command.Name);
    for i := 0 to Command.OutParams.Count-1 do
    begin
      Param := Command.OutParams[i];
      Strings.Add(Format('%s: %s', [Param.Name, GetStringK(S, i+1, [';'])]));
    end;
    memAnswer.Text := Strings.Text;
  finally
    Strings.Free;
  end;
end;

procedure TfmFptrDirectIOStr.btnExecuteClick(Sender: TObject);
var
  Result: Integer;
  pString: WideString;
  CommandCode: Integer;
begin
  EnableButtons(False);
  try
    edtRxData.Clear;
    pString := edtTxData.Text;
    CommandCode := Integer(cbCommand.Items.Objects[cbCommand.ItemIndex]);
    Result := FiscalPrinter.DirectIO(DIO_COMMAND_PRINTER_STR, CommandCode, pString);
    if Result = OPOS_SUCCESS then
    begin
      edtRxData.Text := pString;
      UpdateCommandText(pString);
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDirectIOStr.FormCreate(Sender: TObject);
var
  i: Integer;
  S: WideString;
  Command: TCommandDef;
begin
  cbCommand.Items.BeginUpdate;
  try
    cbCommand.Items.Clear;
    for i := 0 to Commands.Count-1 do
    begin
      Command := Commands[i];
      S := Tnt_WideFormat('0x%.2xh, %s', [Command.Code, Command.Name]);
      cbCommand.Items.AddObject(S, Pointer(Command.Code));
    end;
  finally
    cbCommand.Items.EndUpdate;
  end;
  if cbCommand.Items.Count > 0 then
    cbCommand.ItemIndex := 0;

  UpdateCommandHint;
end;

procedure TfmFptrDirectIOStr.cbCommandChange(Sender: TObject);
begin
  UpdateCommandHint;
end;

end.
