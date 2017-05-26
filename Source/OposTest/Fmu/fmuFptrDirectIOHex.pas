unit fmuFptrDirectIOHex;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // This
  untPages, OposFiscalPrinter, DirectIOAPI, Opos;

type
  TfmFptrDirectIOHex = class(TPage)
    lblTxData: TLabel;
    btnExecute: TButton;      
    lblRxData: TLabel;
    edtRxData: TEdit;
    edtTxData: TEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmSetDate }

procedure TfmFptrDirectIOHex.btnExecuteClick(Sender: TObject);
var
  Result: Integer;
  pData: Integer;
  pString: WideString;
begin
  EnableButtons(False);
  try
    edtRxData.Clear;
    pString := edtTxData.Text;
    Result := FiscalPrinter.DirectIO(DIO_COMMAND_PRINTER_HEX, pData, pString);
    if Result = OPOS_SUCCESS then
      edtRxData.Text := pString;
  finally
    EnableButtons(True);
  end;
end;

end.
