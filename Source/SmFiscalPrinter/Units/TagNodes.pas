unit TagNodes;

interface

uses
  // VCL
  SysUtils, Classes, strutils,
  // This
  TLVTags, StringUtils;

type
  TTagNode = class;

  { TTagNodes }

  TTagNodes = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TTagNode;
    procedure InsertItem(AItem: TTagNode);
    procedure RemoveItem(AItem: TTagNode);
  public
    constructor Create;
    destructor Destroy; override;
    function Add: TTagNode;
    procedure Clear;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTagNode read GetItem; default;
  end;

  { TTagNode }

  TTagNode = class
  private
    FNodes: TTagNodes;
    FOwner: TTagNodes;
    FTag: Integer;
    FTagLength: Integer;
    FTagType: TTagType;
    FIntValue: Integer;
    FStrValue: string;
    FTagId: Integer;
    FLastTagID: Integer;
    FParentNode: TTagNode;
    FValueLength: Integer;
    FBinValue: string;
    FDateTimeValue: TDateTime;
    FFVLNValue: Currency;

    procedure SetOwner(AOwner: TTagNodes);
    function GetLength: Integer;
    function GetValue: string;
    function GetStrLength(ATagNumber: Integer): Integer;
  public
    constructor Create(AOwner: TTagNodes);
    destructor Destroy; override;
    function GetTLV: string;
    function GetFreeTagID: Integer;
    function GetLastTagID: Integer;
    function NodeByTagID(ATagID: Integer): TTagNode;
    function AddTag(ATagNumber: Integer; ATagType: TTagType): TTagNode;
    property Tag: Integer read FTag write FTag;
    property TagType: TTagType read FTagType write FTagType;
    property TagLength: Integer read FTagLength write FTagLength;
    property Nodes: TTagNodes read FNodes write FNodes;
    property IntValue: Integer read FIntValue write FIntValue;
    property StrValue: string read FStrValue write FStrValue;
    property TagID: Integer read FTagId write FTagID;
    property LastTagID: Integer read FLastTagID write FLastTagID;
    property ParentNode: TTagNode read FParentNode write FParentNode;
    property ValueLength: Integer read FValueLength write FValueLength;
    property BinValue: string read FBinValue write FBinValue;
    property DateTimeValue: TDateTime read FDateTimeValue write FDateTimeValue;
    property FVLNValue: Currency read FFVLNValue write FFVLNValue;
  end;

implementation

{ TTagNodes }

constructor TTagNodes.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TTagNodes.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TTagNodes.Clear;
begin
  while Count > 0 do
    Items[0].Free;
end;

function TTagNodes.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TTagNodes.GetItem(Index: Integer): TTagNode;
begin
  Result := FList[Index];
end;

procedure TTagNodes.InsertItem(AItem: TTagNode);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TTagNodes.RemoveItem(AItem: TTagNode);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TTagNodes.Add: TTagNode;
begin
  Result := TTagNode.Create(Self);
end;


{ TTagNode }

constructor TTagNode.Create(AOwner: TTagNodes);
begin
  inherited Create;
  SetOwner(AOwner);
  FNodes := TTagNodes.Create;
  if AOwner = nil then
  begin
    FTagId := 0;
    FTagType := ttSTLV;
  end;
  FLastTagID := 0;
  FParentNode := nil;
end;

destructor TTagNode.Destroy;
begin
  SetOwner(nil);
  FNodes.Free;
  inherited Destroy;
end;

function TTagNode.GetLength: Integer;
var
  i: Integer;
begin
  Result := 0;
  if FTagType <> ttSTLV then
  begin
    case FTagType of
      ttByte:
        Result := 1;
      ttString:
        Result := Length(FStrValue);
      ttUint16:
        Result := 2;
      ttUInt32:
        Result := 4;
      ttVLN:
        Result := ValueLength;
      ttFVLN:
        Result := ValueLength;
      ttBitMask:
        Result := ValueLength;
      ttUnixTime:
        Result := 4;
    end;
    Exit;
  end;
  Result := 0;
  for i := 0 to FNodes.Count - 1 do
  begin
    Result := Result + FNodes[i].GetLength + 4;
  end;
end;

function TTagNode.GetValue: string;
var
  i: Integer;
  Len: Integer;
begin
  if FTagType <> ttSTLV then
  begin
    case FTagType of
      ttByte:
        Result := TTLVTag.Int2ValueTLV(IntValue, 1);
      ttUint16:
        Result := TTLVTag.Int2ValueTLV(IntValue, 2);
      ttUInt32:
        Result := TTLVTag.Int2ValueTLV(IntValue, 4);
      ttVLN:
        begin
          Result := TTLVTag.VLN2ValueTLVLen(BinToInt(BinValue, 1, ValueLength), ValueLength);
        end;
      ttFVLN:
        Result := TTLVTag.FVLN2ValueTLVLen(FVLNValue, ValueLength);
      ttBitMask:
        Result := TTLVTag.Int2ValueTLV(BinToInt(BinValue, 1, ValueLength), ValueLength);
      ttUnixTime:
        Result := TTLVTag.UnixTime2ValueTLV(DateTimeValue);
      ttString:
        begin
          Len := GetStrLength(FTag);
          if Len = 0 then
            Result := TTLVTag.ASCII2ValueTLV(StrValue)
          else
            Result := TTLVTag.ASCII2ValueTLV(AddTrailingSpaces(StrValue, Len));
        end;
    end;
    Exit;
  end;
  Result := '';
  for i := 0 to FNodes.Count - 1 do
  begin
    Result := Result + TTLVTag.Int2ValueTLV(FNodes[i].Tag, 2) + TTLVTag.Int2ValueTLV(FNodes[i].GetLength, 2) + FNodes[i].GetValue;
  end;
end;

function TTagNode.GetTLV: string;
begin
  Result := TTLVTag.Int2ValueTLV(Tag, 2) + TTLVTag.Int2ValueTLV(GetLength, 2) + GetValue;
end;

procedure TTagNode.SetOwner(AOwner: TTagNodes);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then
      FOwner.RemoveItem(Self);
    if AOwner <> nil then
      AOwner.InsertItem(Self);
  end;
end;

function TTagNode.AddTag(ATagNumber: Integer; ATagType: TTagType): TTagNode;
begin
  Result := FNodes.Add;
  Result.Tag := ATagNumber;
  Result.TagType := ATagType;
  Result.ParentNode := Self;
  if ATagType = ttSTLV then
  begin
    Result.TagID := GetFreeTagID;
    FLastTagID := Result.TagID;
    Result.LastTagID := FLastTagID;
  end
  else
  begin
    Result.TagID := -1;
//    FLastTagID := 0;
  end;
end;

function TTagNode.GetFreeTagID: Integer;
begin
  Result := GetLastTagID + 1;
end;

function TTagNode.GetLastTagID: Integer;
var
  i: Integer;
  LastID: Integer;
  ID: Integer;
begin
  LastID := LastTagID;
  for i := 0 to Nodes.Count - 1 do
  begin
    if Nodes[i].TagType = ttSTLV then
    begin
      ID := Nodes[i].GetLastTagID;
      if ID > LastID then
        LastID := ID;
    end;
  end;
  Result := LastID;
end;

function TTagNode.NodeByTagID(ATagID: Integer): TTagNode;
var
  i: Integer;
begin
  Result := nil;
  if ATagID = TagID then
  begin
    Result := Self;
    Exit;
  end;
  if TagType <> ttSTLV then
    Exit;
  for i := 0 to FNodes.Count - 1 do
  begin
    Result := FNodes[i].NodeByTagID(ATagID);
    if Result <> nil then
      Exit;
  end;
end;

function TTagNode.GetStrLength(ATagNumber: Integer): Integer;
var
  Tag: TTLVTag;
  TagInfo: TTLVTags;
begin
  TagInfo := TTLVTags.Create;
  try
    Result := 0;
    Tag := TagInfo.Find(ATagNumber);
    if Tag = nil then
      Exit;
    if Tag.FixedLength then
      Result := Tag.Length
    else
      Result := 0;
  finally
    TagInfo.Free;
  end;
end;

end.

