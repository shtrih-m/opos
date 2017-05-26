unit ReceiptTemplate;

interface

uses
  // This
  Classes,
  // This
  ReceiptItem, TemplateItem, PrinterParameters;

type
  { TReceiptTemplate }

  TReceiptTemplate = class
  private
    FItemTags: TTemplateItems;
  public
    constructor Create(const ReceiptItemFormat: string);
    destructor Destroy; override;

    procedure getItemLines(const Item: TFSSaleItem; Lines: TStrings);
  end;

implementation

{ TReceiptTemplate }

constructor TReceiptTemplate.Create(const ReceiptItemFormat: string);
begin
  inherited Create;
  FItemTags := TTemplateItems.Create;
  FItemTags.Parse(ReceiptItemFormat);
end;

destructor TReceiptTemplate.Destroy;
begin
  FItemTags.Free;
  inherited Destroy;
end;

procedure TReceiptTemplate.getItemLines(const Item: TFSSaleItem;
  Lines: TStrings);
begin
  if Item.PreLine <> '' then
    Lines.Add(Item.PreLine);

  if Item.Quantity < 0 then
  begin
    Lines.Add('ÑÒÎÐÍÎ');
    Item.Quantity := Abs(Item.Quantity);
  end;
  Lines.add(FItemTags.GetText(Item));
end;

end.
