unit fmuFptrVatCode;

interface

uses
  // VCL
  StdCtrls, Controls, ComCtrls, Classes, SysUtils,
  // This
  FiscalPrinterDevice, PrinterParameters, FptrTypes, DirectIOAPI, Spin;

type
  { TfmFptrVatCode }

  TfmFptrVatCode = class(TFptrPage)
    lblAppVatCode: TLabel;
    lblFptrVATCode: TLabel;
    lvVatCodes: TListView;
    btnDelete: TButton;
    btnAdd: TButton;
    seAppVatCode: TSpinEdit;
    seFptrVatCode: TSpinEdit;
    chbVatCodeEnabled: TCheckBox;
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure PageChange(Sender: TObject);
  private
    procedure UpdateItems;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrVatCode }

procedure TfmFptrVatCode.UpdateItems;
var
  i: Integer;
  Item: TListItem;
begin
  with lvVatCodes do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
		  for i := 0 to Parameters.VatCodes.Count-1 do
      begin
        Item := Items.Add;
        Item.Caption := IntToStr(Parameters.VatCodes[i].AppVatCode);
        Item.SubItems.Add(IntToStr(Parameters.VatCodes[i].FptrVatCode));
        if i = 0 then
        begin
          Item.Focused := True;
          Item.Selected := True;
        end;
      end;
      btnDelete.Enabled := Parameters.VatCodes.Count > 0;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TfmFptrVatCode.UpdatePage;
begin
  UpdateItems;
  chbVatCodeEnabled.Checked := Parameters.VatCodeEnabled;
end;

procedure TfmFptrVatCode.UpdateObject;
begin
  Parameters.VatCodeEnabled := chbVatCodeEnabled.Checked;
end;

procedure TfmFptrVatCode.btnAddClick(Sender: TObject);
var
  Item: TListItem;
begin
  Parameters.VatCodes.Add(seAppVatCode.Value, seFptrVatCode.Value);

  Item := lvVatCodes.Items.Add;
  Item.Caption := IntToStr(seAppVatCode.Value);
  Item.SubItems.Add(IntToStr(seFptrVatCode.Value));

  Item.Focused := True;
  Item.Selected := True;
  btnDelete.Enabled := True;
  Modified;
end;

procedure TfmFptrVatCode.btnDeleteClick(Sender: TObject);
var
  Index: Integer;
  Item: TListItem;
begin
  Item := lvVatCodes.Selected;
  if Item <> nil then
  begin
    Index := Item.Index;
  	Parameters.VatCodes[Index].Free;
    Item.Delete;
    if Index >= lvVatCodes.Items.Count then
      Index := lvVatCodes.Items.Count-1;
    if Index >= 0 then
    begin
      Item := lvVatCodes.Items[Index];
      Item.Focused := True;
      Item.Selected := True;
	  	Modified;
    end;
    btnDelete.Enabled := lvVatCodes.Items.Count > 0;
  end;
end;

procedure TfmFptrVatCode.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
