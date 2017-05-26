unit fmuFptrPayType;

interface

uses
  // VCL
  StdCtrls, Controls, ComCtrls, Classes, SysUtils,
  // This
  FiscalPrinterDevice, PrinterParameters, FptrTypes, DirectIOAPI;

type
  { TfmFptrPayType }

  TfmFptrPayType = class(TFptrPage)
    lblDescription: TLabel;
    edtDescription: TEdit;
    cbValue: TComboBox;
    lblValue: TLabel;
    lvPayTypes: TListView;
    btnDelete: TButton;
    btnAdd: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure PageChange(Sender: TObject);
  private
    procedure UpdatePayTypes;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

function PayTypeToStr(Value: Integer): WideString;
begin
  case Value of
    0: Result := 'Cash';
    1: Result := 'Payment type 2';
    2: Result := 'Payment type 3';
    3: Result := 'Payment type 4';
  else
    Result := 'Cash';
  end;
end;


{ TfmFiscalPrinter }

procedure TfmFptrPayType.UpdatePayTypes;
var
  i: Integer;
  Item: TListItem;
begin
  cbValue.ItemIndex := 0;
  with lvPayTypes do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
		  for i := 0 to Parameters.PayTypes.Count-1 do
      begin
        Item := Items.Add;
        Item.Caption := IntToStr(i+1);
        Item.SubItems.Add(Parameters.PayTypes[i].Text);
        Item.SubItems.Add(PayTypeToStr(Integer(Parameters.PayTypes[i].Code)));
        if i = 0 then
        begin
          Item.Focused := True;
          Item.Selected := True;
        end;
      end;
      btnDelete.Enabled := Parameters.PayTypes.Count > 0;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TfmFptrPayType.UpdatePage;
begin
  UpdatePayTypes;
end;

procedure TfmFptrPayType.UpdateObject;
begin
end;

procedure TfmFptrPayType.btnAddClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := lvPayTypes.Items.Add;
  Item.Caption := IntToStr(lvPayTypes.Items.Count);
  Item.SubItems.Add(edtDescription.Text);
  Item.SubItems.Add(PayTypeToStr(cbValue.ItemIndex));
  Parameters.PayTypes.Add(cbValue.ItemIndex, edtDescription.Text);
  Item.Focused := True;
  Item.Selected := True;
  btnDelete.Enabled := True;
  Modified;
end;

procedure TfmFptrPayType.btnDeleteClick(Sender: TObject);
var
  Index: Integer;
  Item: TListItem;
begin
  Item := lvPayTypes.Selected;
  if Item <> nil then
  begin
    Index := Item.Index;
  	Parameters.PayTypes[Index].Free;
    Item.Delete;
    if Index >= lvPayTypes.Items.Count then Index := lvPayTypes.Items.Count-1;
    if Index >= 0 then
    begin
      Item := lvPayTypes.Items[Index];
      Item.Focused := True;
      Item.Selected := True;
	  	Modified;
    end;
    btnDelete.Enabled := lvPayTypes.Items.Count > 0;
  end;
end;

procedure TfmFptrPayType.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
