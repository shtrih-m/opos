unit fmuFptrMonitoring;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // Indy
  IdTCPClient,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrMonitoring = class(TPage)
    btnReadStatus: TButton;
    btnClear: TButton;
    Memo: TMemo;
    lblHost: TLabel;
    edtHost: TEdit;
    lblPort: TLabel;
    edtPort: TEdit;
    procedure btnReadStatusClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmFptrMonitoring }

procedure TfmFptrMonitoring.btnReadStatusClick(Sender: TObject);
const
  CRLF = #13#10;
  Commands: array [0..11] of String = (
  'STATUS',
  'INFO',
  'ECTP',
  'FN',
  'FN_UNIXTIME',
  'CNT_QUEUE',
  'DATE_LAST',
  'CASH_REG 1',
  'CASH_REG 10',
  'OPER_REG 1',
  'OPER_REG 10',
  'OFD_SETTING');

var
  i: Integer;
  Answer: string;
  Connection: TIdTCPClient;
begin
  Memo.Clear;
  EnableButtons(False);
  Connection := TIdTCPClient.Create(nil);
  try
    Connection.Host := edtHost.Text;
    Connection.Port := StrToInt(edtPort.Text);
    Connection.ReadTimeout := 1000;
    if not Connection.Connected then
    begin
      Connection.ConnectTimeout := 1000;
      Connection.Connect();
    end;
    for i := Low(Commands) to High(Commands) do
    begin
      Connection.Socket.WriteLn(Commands[i]);
      Answer := Trim(Connection.Socket.ReadLn());
      Memo.Lines.Add(Format('%s: %s', [Commands[i], Answer]));
    end;
    Connection.Disconnect;
  finally
    Connection.Free;
    EnableButtons(True);
  end;
end;

procedure TfmFptrMonitoring.btnClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

end.
