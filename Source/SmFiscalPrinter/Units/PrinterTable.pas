unit PrinterTable;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // 3'd
  TntClasses, TntSysUtils,
  // This
  PrinterTypes, VersionInfo, WException, gnugettext;


const
  FIELD_TYPE_INT = 0;
  FIELD_TYPE_STR = 1;

type
  TPrinterTable = class;
  TPrinterField = class;
  TPrinterFields = class;

  { TPrinterTables }

  TPrinterTables = class
  private
    FList: TList;
    FHeader: TTntStringList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TPrinterTable;
    procedure InsertItem(AItem: TPrinterTable);
    procedure RemoveItem(AItem: TPrinterTable);
  public
    DeviceName: WideString;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function ItemByNumber(Value: Integer): TPrinterTable;
    function Add(const AData: TPrinterTableRec): TPrinterTable;

    property Count: Integer read GetCount;
    property Header: TTntStringList read FHeader;
    property Items[Index: Integer]: TPrinterTable read GetItem; default;
  end;

  { TPrinterTable }

  TPrinterTable = class
  private
    FID: Integer;
    FFields: TPrinterFields;
    FOwner: TPrinterTables;
    FData: TPrinterTableRec;
    procedure SetOwner(AOwner: TPrinterTables);
  public
    constructor Create(AOwner: TPrinterTables; const AData: TPrinterTableRec);
    destructor Destroy; override;

    procedure Assign(Src: TPrinterTable);
    procedure SetFieldValue(Field: TPrinterField; const S: WideString);

    property ID: Integer read FID;
    property Data: TPrinterTableRec read FData;
    property Fields: TPrinterFields read FFields;
    property Name: WideString read FData.Name;
    property Number: Integer read FData.Number;
    property RowCount: Integer read FData.RowCount;
    property FieldCount: Integer read FData.FieldCount;
  end;

  { TPrinterFields }

  TPrinterFields = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TPrinterField;
    procedure InsertItem(AItem: TPrinterField);
    procedure RemoveItem(AItem: TPrinterField);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Src: TPrinterFields);
    function ItemByID(ID: Integer): TPrinterField;
    function Find(Table, Field: Integer): TPrinterField;
    function Add(const AData: TPrinterFieldRec): TPrinterField;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPrinterField read GetItem; default;
  end;

  { TPrinterField }

  TPrinterField = class
  private
    FID: Integer;
    FValue: WideString;
    FOwner: TPrinterFields;
    FData: TPrinterFieldRec;
    function Getindex: Integer;
    procedure SetOwner(AOwner: TPrinterFields);
  public
    constructor Create(AOwner: TPrinterFields; const AData: TPrinterFieldRec);
    constructor Create2(AOwner: TPrinterFields; Field: TPrinterField);
    destructor Destroy; override;

    function Range: WideString;
    function MaxLen: WideString;
    function IsString: Boolean;
    function IsInteger: Boolean;
    function FieldTypeText: WideString;

    procedure Assign(Src: TPrinterField);

    property ID: Integer read FID;
    property Data: TPrinterFieldRec read FData;
    property Row: Integer read FData.Row;
    property Index: Integer read GetIndex;
    property Field: Integer read FData.Field;
    property Table: Integer read FData.Table;
    property Name: WideString read FData.Name;
    property Size: Integer read FData.Size;
    property MinValue: Integer read FData.MinValue;
    property MaxValue: Integer read FData.MaxValue;
    property FieldType: Integer read FData.FieldType;
    property Value: WideString read FValue write FValue;
  end;

const
  BoolFieldTypeToInt: array [Boolean] of Integer = (FIELD_TYPE_INT, FIELD_TYPE_STR);

implementation

procedure CheckIntRange(Field: TPrinterField; Value: Integer);
begin
  if (Value < Field.MinValue)or(Value > Field.MaxValue) then
  begin
    raiseExceptionFmt('%s "%s" (%d).'#13#10'%s %d..%d.', [
      _('Неверное значение поля'), Field.Name, Value, _('Допустимые значения'),
      Field.MinValue, Field.MaxValue]);
  end;
end;

procedure CheckIntValue(const FieldName, Value: WideString;
  var IntValue: Integer);
var
  Code: Integer;
begin
  Val(Value, IntValue, Code);
  if Code <> 0 then
  begin
    raiseExceptionFmt('%s "%s"'#13#10'"%s" %s', [
      _('Неверное значение поля'), FieldName, Value, _('не является целым числом')]);
  end;
end;

{ TPrinterTables }

constructor TPrinterTables.Create;
begin
  inherited Create;
  FList := TList.Create;
  FHeader := TTntStringList.Create;
end;

destructor TPrinterTables.Destroy;
begin
  Clear;
  FList.Free;
  FHeader.Free;
  inherited Destroy;
end;

procedure TPrinterTables.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TablesSort(Item1, Item2: Pointer): Integer;
var
  Num1, Num2: Integer;
begin
  Num1 := TPrinterTable(Item1).Number;
  Num2 := TPrinterTable(Item2).Number;
  if Num1 < Num2 then Result := -1 else
  if Num1 > Num2 then Result := 1 else Result := 0;
end;

function TPrinterTables.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPrinterTables.GetItem(Index: Integer): TPrinterTable;
begin
  Result := FList[Index];
end;

procedure TPrinterTables.InsertItem(AItem: TPrinterTable);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPrinterTables.RemoveItem(AItem: TPrinterTable);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TPrinterTables.ItemByNumber(Value: Integer): TPrinterTable;
var
  i: Integer;
begin
   for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.Number = Value then Exit;
  end;
  Result := nil;
end;

function TPrinterTables.Add(const AData: TPrinterTableRec): TPrinterTable;
begin
  Result := TPrinterTable.Create(Self, AData);
end;

{ TPrinterTable }

constructor TPrinterTable.Create(AOwner: TPrinterTables; const AData: TPrinterTableRec);
const
  LastID: Integer = 0;
begin
  inherited Create;
  FData := AData;
  Inc(LastID); FID := LastID;
  FFields := TPrinterFields.Create;

  SetOwner(AOwner);
end;

destructor TPrinterTable.Destroy;
begin
  SetOwner(nil);
  FFields.Free;
  inherited Destroy;
end;

procedure TPrinterTable.Assign(Src: TPrinterTable);
begin
  FID := Src.ID;
  FData := Src.Data;
  Fields.Assign(Src.Fields);
end;

procedure TPrinterTable.SetOwner(AOwner: TPrinterTables);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TPrinterTable.SetFieldValue(Field: TPrinterField; const S: WideString);
var
  V: Integer;
begin
  if S <> Field.Value then
  begin
    if Field.FieldType = FIELD_TYPE_INT then
    begin
      CheckIntValue(Name, S, V);
      CheckIntRange(Field, V);
    end;
    Field.Value := S;
  end;
end;

{ TPrinterFields }

constructor TPrinterFields.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPrinterFields.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TPrinterFields.Assign(Src: TPrinterFields);
var
  i: Integer;
begin
  Clear;
  for i := 0 to Src.Count-1 do
    TPrinterField.Create2(Self, Src[i]);
end;

procedure TPrinterFields.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TPrinterFields.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPrinterFields.GetItem(Index: Integer): TPrinterField;
begin
  Result := FList[Index];
end;

procedure TPrinterFields.InsertItem(AItem: TPrinterField);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPrinterFields.RemoveItem(AItem: TPrinterField);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function FieldsSort(Item1, Item2: Pointer): Integer;
var
  Num1, Num2: Integer;
begin
  Num1 := TPrinterField(Item1).Field;
  Num2 := TPrinterField(Item2).Field;
  if Num1 < Num2 then Result := -1 else
  if Num1 > Num2 then Result := 1 else Result := 0;
end;

function TPrinterFields.ItemByID(ID: Integer): TPrinterField;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.ID = ID then Exit;
  end;
  Result := nil;
end;

function TPrinterFields.Find(Table, Field: Integer): TPrinterField;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if (Result.Field = Field)and(Result.Table = Table) then Exit;
  end;
  Result := nil;
end;

function TPrinterFields.Add(const AData: TPrinterFieldRec): TPrinterField;
begin
  Result := TPrinterField.Create(Self, AData);
end;

{ TPrinterField }

const
  LastID: Integer = 0;

constructor TPrinterField.Create(AOwner: TPrinterFields; const AData: TPrinterFieldRec);
begin
  inherited Create;
  Inc(LastID);
  FID := LastID;
  FData := AData;
  SetOwner(AOwner);
end;

constructor TPrinterField.Create2(AOwner: TPrinterFields; Field: TPrinterField);
begin
  inherited Create;
  Assign(Field);
  SetOwner(AOwner);
end;

destructor TPrinterField.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TPrinterField.SetOwner(AOwner: TPrinterFields);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TPrinterField.Assign(Src: TPrinterField);
begin
  FID := Src.ID;
  FValue := Src.Value;
  FData := Src.Data;
end;

function TPrinterField.GetIndex: Integer;
begin
  Result := FOwner.FList.IndexOf(Self);
end;

function TPrinterField.MaxLen: WideString;
begin
  if FieldType = FIELD_TYPE_STR then
  begin
    Result := Tnt_WideFormat('%s: %d', [_('Максимальная длина'), Size]);
  end else
  begin
    Result := Tnt_WideFormat('%s: %d', [_('Размер, байт'), Size]);
  end;
end;

function GetFieldType(Value: Integer): WideString;
begin
  case Value of
    FIELD_TYPE_INT: Result := _('число');
    FIELD_TYPE_STR: Result := _('строка');
  else
    Result := '';
  end;
end;

function TPrinterField.FieldTypeText: WideString;
begin
  Result := Tnt_WideFormat('%s: %s', [_('Тип'), GetFieldType(FieldType)]);
end;

function TPrinterField.Range: WideString;
begin
  if FieldType = FIELD_TYPE_INT then
    Result := Tnt_WideFormat('%s: %d..%d', [_('Диапазон'), MinValue, MaxValue])
  else
    Result := '';
end;

function TPrinterField.IsString: Boolean;
begin
  Result := FieldType = FIELD_TYPE_STR;
end;

function TPrinterField.IsInteger: Boolean;
begin
  Result := FieldType = FIELD_TYPE_INT;
end;


end.
