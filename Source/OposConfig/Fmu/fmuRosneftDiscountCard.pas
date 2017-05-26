unit fmuRosneftDiscountCard;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, SysUtils, ComCtrls, ExtCtrls,
  // This
  FiscalPrinterDevice, FptrTypes, MalinaParams, RegExpr;

type
  { TfmDiscountCard }

  TfmRosneftDiscountCard = class(TFptrPage)
    chbDiscountCards: TCheckBox;
    lblRosneftCardMask: TLabel;
    edtRosneftCardMask: TEdit;
    lblRosneftCardName: TLabel;
    edtRosneftCardName: TEdit;
    Bevel1: TBevel;
    btnTest: TButton;
    Label1: TLabel;
    edtCardName: TEdit;
    Label2: TLabel;
    edtResultCardName: TEdit;
    procedure PageChange(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmDiscountCard }

procedure TfmRosneftDiscountCard.UpdatePage;
begin
  chbDiscountCards.Checked := GetMalinaParams.RosneftDiscountCards;
  edtRosneftCardMask.Text := GetMalinaParams.RosneftCardMask;
  edtRosneftCardName.Text := GetMalinaParams.RosneftCardName;
end;

procedure TfmRosneftDiscountCard.UpdateObject;
begin
  GetMalinaParams.RosneftDiscountCards := chbDiscountCards.Checked;
  GetMalinaParams.RosneftCardMask := edtRosneftCardMask.Text;
  GetMalinaParams.RosneftCardName := edtRosneftCardName.Text;
end;

procedure TfmRosneftDiscountCard.PageChange(Sender: TObject);
begin
  Modified;
end;

procedure TfmRosneftDiscountCard.btnTestClick(Sender: TObject);
begin
  edtResultCardName.Text := ReplaceRegExpr (edtRosneftCardMask.Text,
    edtCardName.Text, edtRosneftCardName.Text);
end;

end.
