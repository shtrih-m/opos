unit fmuFptrDirectIOEndDay;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  untPages, OposFiscalPrinter, DirectIOAPI, Opos;

type
  TfmFptrDirectIOEndDay = class(TPage)
    lblResult: TTntLabel;
    btnExecute: TTntButton;
    edtResult: TTntEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmSetDate }

procedure TfmFptrDirectIOEndDay.btnExecuteClick(Sender: TObject);
var
  Result: Integer;
  pData: Integer;
  pString: WideString;
begin
  EnableButtons(False);
  try
    edtResult.Clear;
    Result := FiscalPrinter.DirectIO(DIO_CHECK_END_DAY, pData, pString);
    if Result = OPOS_SUCCESS then
    begin
      if pData = 1 then edtResult.Text := '24 hours is over'
      else edtResult.Text := '24 hours is not over';
    end;
  finally
    EnableButtons(True);
  end;
end;

end.
