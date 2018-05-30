unit fmuFptrFiscalStorage;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, OposFiscalPrinter, DirectIOAPI;

type
  TfmFptrFiscalStorage = class(TPage)
    lblAdditionalHeader: TTntLabel;
    memParameters: TTntMemo;
    btnReadParams: TTntButton;
    procedure btnReadParamsClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrFiscalStorage.btnReadParamsClick(Sender: TObject);

  procedure Add(ParamID: Integer; const P: WideString; const Name: WideString);
  var
    pData: Integer;
    pString: WideString;
  begin
    pData := ParamID;
    pString := P;
    FiscalPrinter.Check(FiscalPrinter.DirectIO(DIO_READ_FS_PARAMETER, pData, pString));
    memParameters.Lines.Add(Format('%-*s: %s', [30, Name, pString]));
  end;

begin
  memParameters.Clear;
  Add(DIO_FS_PARAMETER_SERIAL, '', 'FS serial number');
  Add(DIO_FS_PARAMETER_LAST_DOC_NUM, '', 'FS last document number');
  Add(DIO_FS_PARAMETER_LAST_DOC_MAC, '', 'FS last document MAC');
  Add(DIO_FS_PARAMETER_QUEUE_SIZE, '', 'FS documents count');
  Add(DIO_FS_PARAMETER_FIRST_DOC_NUM, '', 'FS first document number');
  Add(DIO_FS_PARAMETER_FIRST_DOC_DATE, '', 'FS first document date');
  Add(DIO_FS_PARAMETER_FISCAL_DATE, '', 'FS fiscalization date');
  Add(DIO_FS_PARAMETER_EXPIRE_DATE, '', 'FS expiration date');
  Add(DIO_FS_PARAMETER_TICKET_HEX, '1', 'Ticket data in hex');
  Add(DIO_FS_PARAMETER_TICKET_STR, '1', 'Ticket data in text');
end;

end.
