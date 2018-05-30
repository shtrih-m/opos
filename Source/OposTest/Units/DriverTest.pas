unit DriverTest;

interface

Uses
  // VCL
  Classes, SysUtils, StdCtrls,
  // Tnt
  TntSysUtils, TntStdCtrls, TntRegistry,
  // This
  Opos, OposFptr, OposUtils, AlignStrings,
  OposFiscalPrinter, OposFptrUtils;

type
  TDriverTest = class;

  { TDriverTests }

  TDriverTests = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TDriverTest;
    procedure Clear;
    procedure InsertItem(AItem: TDriverTest);
    procedure RemoveItem(AItem: TDriverTest);
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDriverTest read GetItem; default;
  end;

  { TDriverTest }

  TDriverTest = class
  private
    FMemo: TTntMemo;
    FOwner: TDriverTests;
    procedure SetOwner(AOwner: TDriverTests);
  protected
    procedure SetHeaderLines;
    procedure SetTrailerLines;
    procedure PrintTestReceipt;
    procedure PrintTenderReceipt;
    procedure AddLine(const S: WideString);
    procedure Check(AResultCode: Integer);
  public
    constructor Create(AOwner: TDriverTests; AMemo: TTntMemo);
    destructor Destroy; override;

    procedure Execute; virtual; abstract;
    function ReadRecNumber: Integer;
    function GetDisplayText: WideString; virtual; abstract;

    property Memo: TTntMemo read FMemo;
  end;

  { TDriverTestClass }

  TDriverTestClass = class of TDriverTest;

implementation

{ TDriverTests }

constructor TDriverTests.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TDriverTests.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TDriverTests.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TDriverTests.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TDriverTests.GetItem(Index: Integer): TDriverTest;
begin
  Result := FList[Index];
end;

procedure TDriverTests.InsertItem(AItem: TDriverTest);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TDriverTests.RemoveItem(AItem: TDriverTest);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

{ TDriverTest }

constructor TDriverTest.Create(AOwner: TDriverTests; AMemo: TTntMemo);
begin
  inherited Create;
  SetOwner(AOwner);
  FMemo := AMemo;
end;

destructor TDriverTest.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TDriverTest.SetOwner(AOwner: TDriverTests);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TDriverTest.AddLine(const S: WideString);
begin
  Memo.Lines.Add(S);
end;

function TDriverTest.ReadRecNumber: Integer;
var
  Data: WideString;
  DataItem: Integer;
begin
  Data := '';
  DataItem := 0;
  Check(FiscalPrinter.GetData(FPTR_GD_RECEIPT_NUMBER, DataItem, Data));
  Result := StrToInt(Data);
end;

procedure TDriverTest.Check(AResultCode: Integer);
var
  ErrorString: WideString;
  ResultCodeExtended: Integer;
begin
  if AResultCode <> OPOS_SUCCESS then
  begin
    ErrorString := FiscalPrinter.ErrorString;
    ResultCodeExtended := FiscalPrinter.ResultCodeExtended;

    AddLine(Format('%d, %s', [AResultCode, GetResultCodeText(AResultCode)]));
    AddLine(Format('ResultCodeExtended: %d', [ResultCodeExtended]));
    AddLine(Format('ErrorString: %s', [ErrorString]));
    AddLine(Format('PrinterState: %s', [PrinterStateToStr(FiscalPrinter.PrinterState)]));

    raise Exception.CreateFmt('%d, %s', [
      AResultCode, GetResultCodeText(AResultCode)]);
  end;
end;

procedure TDriverTest.PrintTestReceipt;
begin
  // ResetPrinter
  AddLine('ResetPrinter');
  Check(FiscalPrinter.ResetPrinter);
  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // PrintRecItem
  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Item 1', 100, 1, 0, 100, ''));
  // PrintRecTotal
  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(100, 100, '0'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

procedure TDriverTest.PrintTenderReceipt;
begin
  // BeginFiscalReceipt
  AddLine('BeginFiscalReceipt');
  FiscalPrinter.FiscalReceiptStation := FPTR_RS_RECEIPT;
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  Check(FiscalPrinter.BeginFiscalReceipt(False));
  // PrintRecItem
  AddLine('PrintRecItem');
  Check(FiscalPrinter.PrintRecItem('Item 1', 100, 1000, 0, 100, ''));
  // PrintRecTotal
  AddLine('PrintRecTotal');
  Check(FiscalPrinter.PrintRecTotal(10, 10, '1'));
  Check(FiscalPrinter.PrintRecTotal(10, 10, '2'));
  Check(FiscalPrinter.PrintRecTotal(10, 10, '3'));
  Check(FiscalPrinter.PrintRecTotal(70, 70, '0'));
  // EndFiscalReceipt
  AddLine('EndFiscalReceipt');
  Check(FiscalPrinter.EndFiscalReceipt(False));
end;

procedure TDriverTest.SetHeaderLines;
var
  S: WideString;
  i: Integer;
begin
  for i := 1 to FiscalPrinter.NumHeaderLines do
  begin
    S := Tnt_WideFormat('Header line %d', [i]);
    S := AlignString(S, FiscalPrinter.DescriptionLength, atCenter);
    Check(FiscalPrinter.SetHeaderLine(i, S, False));
  end;
end;

// Set trailer lines

procedure TDriverTest.SetTrailerLines;
var
  i: Integer;
  S: WideString;
begin
  for i := 1 to FiscalPrinter.NumTrailerLines do
  begin
    S := Tnt_WideFormat('Trailer line %d', [i]);
    S := AlignString(S, FiscalPrinter.DescriptionLength, atCenter);
    Check(FiscalPrinter.SetTrailerLine(i, S, False));
  end;
end;

end.
