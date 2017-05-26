unit fmuFptrReplace;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  // This
  FiscalPrinterDevice, FptrTypes, PrinterParameters, TextMap, MalinaParams;

type
  { TfmFptrReplace }

  TfmFptrReplace = class(TFptrPage)
    ListView: TListView;
    btnAdd: TButton;
    btnDelete: TButton;
    btnClear: TButton;
    memText: TMemo;
    memReplacement: TMemo;
    lblText: TLabel;
    lblReplacement: TLabel;
    chbTextReplacementEnabled: TCheckBox;
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure memTextChange(Sender: TObject);
    procedure memReplacementChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    FReplacements: TTextMap;
    procedure UpdateListView;
    property Replacements: TTextMap read FReplacements;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.dfm}

{ TfmFptrReplace }

constructor TfmFptrReplace.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReplacements := TTextMap.Create;
end;

destructor TfmFptrReplace.Destroy;
begin
  FReplacements.Free;
  inherited Destroy;
end;

procedure TfmFptrReplace.UpdatePage;
begin
  Replacements.Assign(GetMalinaParams.Replacements);

  UpdateListView;
  chbTextReplacementEnabled.Checked := GetMalinaParams.TextReplacementEnabled;
end;

procedure TfmFptrReplace.UpdateListView;
var
  i: Integer;
  Item: TTextMapItem;
  ListItem: TListItem;
begin
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    for i := 0 to Replacements.Count-1 do
    begin
      Item := Replacements[i];
      ListItem := ListView.Items.Add;
      ListItem.Data := Item;
      ListItem.Caption := IntToStr(i+1);
      ListItem.SubItems.Add(Item.Item1);
      ListItem.SubItems.Add(Item.Item2);

      if i = Replacements.Count-1 then
      begin
        ListItem.Focused := True;
        ListItem.Selected := True;
      end;
    end;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TfmFptrReplace.UpdateObject;
begin
  GetMalinaParams.Replacements := Replacements;
  GetMalinaParams.TextReplacementEnabled := chbTextReplacementEnabled.Checked;
end;

procedure TfmFptrReplace.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  TextMapItem: TTextMapItem;
begin
  if Item = nil then Exit;

  TextMapItem := TTextMapItem(Item.Data);
  memText.Text := TextMapItem.Item1;
  memReplaceMent.Text := TextMapItem.Item2;
end;

procedure TfmFptrReplace.memTextChange(Sender: TObject);
var
  Item: TTextMapItem;
  ListItem: TListItem;
begin
  ListItem := ListView.Selected;
  if ListItem = nil then Exit;
  Item := TTextMapItem(ListItem.Data);
  if Item = nil then Exit;

  Item.Item1 := memText.Text;
  ListItem.SubItems[0] := memText.Text;
end;

procedure TfmFptrReplace.memReplacementChange(Sender: TObject);
var
  Item: TTextMapItem;
  ListItem: TListItem;
begin
  ListItem := ListView.Selected;
  if ListItem = nil then Exit;
  Item := TTextMapItem(ListItem.Data);
  if Item = nil then Exit;
  Item.Item2 := memReplacement.Text;
  ListItem.SubItems[1] := memReplacement.Text;
end;

procedure TfmFptrReplace.btnAddClick(Sender: TObject);
var
  Item: TTextMapItem;
begin
  Item := Replacements.Add;
  Item.Item1 := memText.Text;
  Item.Item2 := memReplacement.Text;
  UpdateListView;
end;

procedure TfmFptrReplace.btnDeleteClick(Sender: TObject);
var
  Item: TTextMapItem;
  ListItem: TListItem;
begin
  ListItem := ListView.Selected;
  if ListItem = nil then Exit;
  Item := TTextMapItem(ListItem.Data);
  if Item = nil then Exit;

  ListItem.Delete;
  Item.Free;
  UpdateListView;
end;

procedure TfmFptrReplace.btnClearClick(Sender: TObject);
begin
  ListView.Items.Clear;
  Replacements.Clear;
end;

end.
