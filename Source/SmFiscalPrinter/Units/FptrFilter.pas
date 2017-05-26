unit FptrFilter;

interface

Uses
  // VCL
  Classes,
  // This
  CustomReceipt, NonfiscalDoc;

type
  TFptrFilter = class;

  { TFptrFilters }

  TFptrFilters = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TFptrFilter;
    procedure Clear;
    procedure InsertItem(AItem: TFptrFilter);
    procedure RemoveItem(AItem: TFptrFilter);
  public
    constructor Create;
    destructor Destroy; override;

    procedure BeforeZReport;
    procedure AfterZReport;
    procedure BeforeXReport;
    procedure AfterXReport;
    procedure AfterCloseReceipt;
    procedure AfterPrintReceipt;
    procedure BeforeCloseReceipt;
    procedure BeginFiscalReceipt;
    procedure BeginFiscalReceipt2(Doc: TCustomReceipt);
    procedure EndNonFiscal(Doc: TNonfiscalDoc);
    procedure PrintRecTotal;

    procedure PrintRecItemBefore(
      var ADescription: WideString; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency;
      const AUnitName: WideString);

    procedure PrintRecItemAfter(
      const ADescription: WideString; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency;
      const AUnitName: WideString);

    procedure PrintRecItemRefundBefore(
      const Description: WideString;
      Amount: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitAmount: Currency;
      const UnitName: WideString);

    procedure PrintRecItemRefundAfter(
      const Description: WideString;
      Amount: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitAmount: Currency;
      const UnitName: WideString);

    procedure PrintRecRefundBefore(const Description: WideString;
      Amount: Currency; VatInfo: Integer);

    procedure PrintRecRefundAfter(const Description: WideString;
      Amount: Currency; VatInfo: Integer);

    procedure SetDeviceEnabled(Value: Boolean);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFptrFilter read GetItem; default;
  end;

  { TFptrFilter }

  TFptrFilter = class
  private
    FOwner: TFptrFilters;
    procedure SetOwner(AOwner: TFptrFilters);
  public
    constructor Create(AOwner: TFptrFilters);
    destructor Destroy; override;

    procedure BeforeZReport; virtual;
    procedure AfterZReport; virtual;
    procedure BeforeXReport; virtual;
    procedure AfterXReport; virtual;
    procedure AfterCloseReceipt; virtual;
    procedure AfterPrintReceipt; virtual;
    procedure BeforeCloseReceipt; virtual;
    procedure BeginFiscalReceipt; virtual;
    procedure BeginNonFiscal; virtual;
    procedure BeginFiscalReceipt2(ADoc: TCustomReceipt); virtual;
    procedure EndNonFiscal(Doc: TNonfiscalDoc); virtual;
    procedure PrintRecTotal; virtual;

    procedure PrintRecItemBefore(
      var ADescription: WideString; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency;
      const AUnitName: WideString); virtual;

    procedure PrintRecItemAfter(
      const ADescription: WideString; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency;
      const AUnitName: WideString); virtual;

    procedure PrintRecItemRefundBefore(
      const Description: WideString;
      Amount: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitAmount: Currency;
      const UnitName: WideString); virtual;

    procedure PrintRecItemRefundAfter(
      const Description: WideString;
      Amount: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitAmount: Currency;
      const UnitName: WideString); virtual;

    procedure PrintRecRefundBefore(const Description: WideString;
      Amount: Currency; VatInfo: Integer); virtual;

    procedure PrintRecRefundAfter(const Description: WideString;
      Amount: Currency; VatInfo: Integer); virtual;

    procedure SetDeviceEnabled(Value: Boolean); virtual;
  end;

implementation

{ TFptrFilters }

constructor TFptrFilters.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TFptrFilters.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TFptrFilters.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TFptrFilters.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TFptrFilters.GetItem(Index: Integer): TFptrFilter;
begin
  Result := FList[Index];
end;

procedure TFptrFilters.InsertItem(AItem: TFptrFilter);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TFptrFilters.RemoveItem(AItem: TFptrFilter);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

procedure TFptrFilters.BeginFiscalReceipt;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].BeginFiscalReceipt;
end;

procedure TFptrFilters.BeforeCloseReceipt;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].BeforeCloseReceipt;
end;

procedure TFptrFilters.AfterCloseReceipt;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].AfterCloseReceipt;
end;

procedure TFptrFilters.AfterPrintReceipt;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].AfterPrintReceipt;
end;

procedure TFptrFilters.EndNonFiscal(Doc: TNonfiscalDoc);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].EndNonFiscal(Doc);
end;

procedure TFptrFilters.PrintRecTotal;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].PrintRecTotal;
end;

procedure TFptrFilters.BeginFiscalReceipt2(Doc: TCustomReceipt);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].BeginFiscalReceipt2(Doc);
end;

procedure TFptrFilters.PrintRecItemAfter(const ADescription: WideString;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const AUnitName: WideString);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].PrintRecItemAfter(ADescription, Price, Quantity,
    VatInfo, UnitPrice, AUnitName);
end;

procedure TFptrFilters.PrintRecItemBefore(
  var ADescription: WideString; Price: Currency;
  Quantity, VatInfo: Integer; UnitPrice: Currency;
  const AUnitName: WideString);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].PrintRecItemBefore(ADescription, Price, Quantity,
    VatInfo, UnitPrice, AUnitName);
end;

procedure TFptrFilters.PrintRecItemRefundAfter(
  const Description: WideString; Amount: Currency; Quantity,
  VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].PrintRecItemRefundAfter(Description, Amount, Quantity,
    VatInfo, UnitAmount, UnitName);
end;

procedure TFptrFilters.PrintRecItemRefundBefore(
  const Description: WideString; Amount: Currency; Quantity,
  VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].PrintRecItemRefundBefore(Description, Amount, Quantity,
    VatInfo, UnitAmount, UnitName);
end;

procedure TFptrFilters.PrintRecRefundAfter(const Description: WideString;
  Amount: Currency; VatInfo: Integer);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].PrintRecRefundAfter(Description, Amount, VatInfo);
end;

procedure TFptrFilters.PrintRecRefundBefore(const Description: WideString;
  Amount: Currency; VatInfo: Integer);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].PrintRecRefundBefore(Description, Amount, VatInfo);
end;

procedure TFptrFilters.SetDeviceEnabled(Value: Boolean);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].SetDeviceEnabled(Value);
end;

procedure TFptrFilters.AfterZReport;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].AfterZReport;
end;

procedure TFptrFilters.BeforeZReport;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].BeforeZReport;
end;

procedure TFptrFilters.AfterXReport;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].AfterXReport;
end;

procedure TFptrFilters.BeforeXReport;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].BeforeXReport;
end;

{ TFptrFilter }

constructor TFptrFilter.Create(AOwner: TFptrFilters);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TFptrFilter.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TFptrFilter.SetOwner(AOwner: TFptrFilters);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TFptrFilter.AfterCloseReceipt;
begin

end;

procedure TFptrFilter.AfterPrintReceipt;
begin

end;

procedure TFptrFilter.BeforeCloseReceipt;
begin

end;

procedure TFptrFilter.BeginFiscalReceipt;
begin

end;

procedure TFptrFilter.BeginFiscalReceipt2(ADoc: TCustomReceipt);
begin

end;

procedure TFptrFilter.EndNonFiscal(Doc: TNonfiscalDoc);
begin

end;

procedure TFptrFilter.PrintRecTotal;
begin

end;

procedure TFptrFilter.PrintRecItemAfter(const ADescription: WideString;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const AUnitName: WideString);
begin

end;

procedure TFptrFilter.PrintRecItemBefore(
  var ADescription: WideString; Price: Currency;
  Quantity, VatInfo: Integer; UnitPrice: Currency;
  const AUnitName: WideString);
begin

end;

procedure TFptrFilter.PrintRecItemRefundAfter(
  const Description: WideString; Amount: Currency; Quantity,
  VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString);
begin

end;

procedure TFptrFilter.PrintRecItemRefundBefore(
  const Description: WideString; Amount: Currency; Quantity,
  VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString);
begin

end;

procedure TFptrFilter.PrintRecRefundAfter(const Description: WideString;
  Amount: Currency; VatInfo: Integer);
begin

end;

procedure TFptrFilter.PrintRecRefundBefore(const Description: WideString;
  Amount: Currency; VatInfo: Integer);
begin

end;

procedure TFptrFilter.BeginNonFiscal;
begin

end;

procedure TFptrFilter.SetDeviceEnabled(Value: Boolean);
begin

end;

procedure TFptrFilter.AfterZReport;
begin

end;

procedure TFptrFilter.BeforeZReport;
begin

end;

procedure TFptrFilter.AfterXReport;
begin

end;

procedure TFptrFilter.BeforeXReport;
begin

end;

end.
