unit PrinterTableFormat;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  PrinterTable, WException, gnugettext;

type
  TPrinterTableFormat = class;

  { TPrinterTableFormats }

  TPrinterTableFormats = class
  private
    FList: TList;
    function GetCount: Integer;
    function ValidIndex(Index: Integer): Boolean;
    function GetItem(Index: Integer): TPrinterTableFormat;
    procedure InsertItem(AItem: TPrinterTableFormat);
    procedure RemoveItem(AItem: TPrinterTableFormat);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPrinterTableFormat read GetItem; default;
  end;

  { TPrinterTableFormat }

  TPrinterTableFormat = class
  private
    FOwner: TPrinterTableFormats;
    procedure SetOwner(AOwner: TPrinterTableFormats);
  public
    constructor Create(AOwner: TPrinterTableFormats);
    destructor Destroy; override;

    function Extension: WideString; virtual; abstract;
    function FilterString: WideString; virtual; abstract;
    procedure SaveToFile(const FileName: WideString; Tables: TPrinterTables); virtual; abstract;
    procedure LoadFromFile(const FileName: WideString; Tables: TPrinterTables); virtual; abstract;
  end;

implementation

{ TPrinterTableFormats }

constructor TPrinterTableFormats.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPrinterTableFormats.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TPrinterTableFormats.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TPrinterTableFormats.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPrinterTableFormats.ValidIndex(Index: Integer): Boolean;
begin
  Result := (Index >=0)and(Index < Count);
end;

function TPrinterTableFormats.GetItem(Index: Integer): TPrinterTableFormat;
begin
  if not ValidIndex(Index) then
    raiseException(_('Неверный индекс формата файла'));

  Result := FList[Index];
end;

procedure TPrinterTableFormats.InsertItem(AItem: TPrinterTableFormat);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPrinterTableFormats.RemoveItem(AItem: TPrinterTableFormat);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

{ TPrinterTableFormat }

constructor TPrinterTableFormat.Create(AOwner: TPrinterTableFormats);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TPrinterTableFormat.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TPrinterTableFormat.SetOwner(AOwner: TPrinterTableFormats);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

end.
