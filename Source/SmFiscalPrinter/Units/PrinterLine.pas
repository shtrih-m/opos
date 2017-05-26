unit PrinterLine;

interface

Uses
  // VCL
  Classes;

type
  TPrinterLine = class;

  { TPrinterLines }

  TPrinterLines = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TPrinterLine;
    procedure InsertItem(AItem: TPrinterLine);
    procedure RemoveItem(AItem: TPrinterLine);
    function GetText: WideString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(Station: Integer; const Line: WideString): TPrinterLine;

    property Text: WideString read GetText;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPrinterLine read GetItem; default;
  end;

  { TPrinterLineRec }

  TPrinterLineRec = record
    Line: WideString;
    Station: Integer;
  end;

  { TPrinterLine }

  TPrinterLine = class
  private
    FOwner: TPrinterLines;
    FData: TPrinterLineRec;
    procedure SetOwner(AOwner: TPrinterLines);
  public
    constructor Create(AOwner: TPrinterLines; const AData: TPrinterLineRec);
    destructor Destroy; override;
    property Line: WideString read FData.Line;
    property Station: Integer read FData.Station;
  end;

implementation

{ TPrinterLines }

constructor TPrinterLines.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPrinterLines.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TPrinterLines.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TPrinterLines.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPrinterLines.GetItem(Index: Integer): TPrinterLine;
begin
  Result := FList[Index];
end;

procedure TPrinterLines.InsertItem(AItem: TPrinterLine);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPrinterLines.RemoveItem(AItem: TPrinterLine);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TPrinterLines.Add(Station: Integer;
  const Line: WideString): TPrinterLine;
var
  Data: TPrinterLineRec;
begin
  Data.Line := Line;
  Data.Station := Station;
  Result := TPrinterLine.Create(Self, Data);
end;

function TPrinterLines.GetText: WideString;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count-1 do
  begin
    Result := Result + Items[i].Line + #13#10;
  end;
end;

{ TPrinterLine }

constructor TPrinterLine.Create(AOwner: TPrinterLines;
  const AData: TPrinterLineRec);
begin
  inherited Create;
  SetOwner(AOwner);
  FData := AData;
end;

destructor TPrinterLine.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TPrinterLine.SetOwner(AOwner: TPrinterLines);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
