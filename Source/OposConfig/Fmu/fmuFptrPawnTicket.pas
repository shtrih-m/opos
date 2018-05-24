unit fmuFptrPawnTicket;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, SysUtils, ComCtrls, ExtCtrls,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  FiscalPrinterDevice, FptrTypes, MalinaParams;

type
  { TfmFptrPawnTicket }

  TfmFptrPawnTicket = class(TFptrPage)
    lblUniposSalesErrorText: TTntLabel;
    memPawnTicketText: TTntMemo;
    rgPawnTicketMode: TRadioGroup;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrPawnTicket }

procedure TfmFptrPawnTicket.UpdatePage;
begin
  rgPawnTicketMode.ItemIndex := GetMalinaParams.PawnTicketMode;
  memPawnTicketText.Text := GetMalinaParams.PawnTicketText;
end;

procedure TfmFptrPawnTicket.UpdateObject;
begin
  GetMalinaParams.PawnTicketMode := rgPawnTicketMode.ItemIndex;
  GetMalinaParams.PawnTicketText := memPawnTicketText.Text;
end;

procedure TfmFptrPawnTicket.PageChange(Sender: TObject);
begin
  Modified;
end;



end.
