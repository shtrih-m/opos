unit TextMap;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Registry,
  // Tnt
  TntRegistry, TntClasses, TntSysUtils;

type
  TTextMapItem = class;

  { TTextMap }

  TTextMap = class
  private
    FList: TList;
    function GetCount: Integer;
    procedure InsertItem(AItem: TTextMapItem);
    procedure RemoveItem(AItem: TTextMapItem);
    function GetItem(Index: Integer): TTextMapItem;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function Add: TTextMapItem;
    procedure Assign(Source: TTextMap);
    procedure SaveToRegistry(const KeyName: WideString);
    procedure LoadFromRegistry(const KeyName: WideString);
    function Replace(const Text: WideString): WideString;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTextMapItem read GetItem; default;
  end;

  { TTextMapItem }

  TTextMapItem = class
  private
    FOwner: TTextMap;
    FItem1: WideString;
    FItem2: WideString;
    procedure SetOwner(AOwner: TTextMap);
  public
    constructor Create(AOwner: TTextMap);
    destructor Destroy; override;
    procedure Assign(Source: TTextMapItem);
    function Replace(const Text: WideString): WideString;

    property Item1: WideString read FItem1 write FItem1;
    property Item2: WideString read FItem2 write FItem2;
  end;


implementation

procedure DeleteRegKey(const KeyName: string);
var
  i: Integer;
  Reg: TTntRegistry;
  Strings: TTntStrings;
begin
  Reg := TTntRegistry.Create;
  Strings := TTntStringList.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(KeyName, False) then
    begin
      Reg.GetKeyNames(Strings);
      for i := 0 to Strings.Count-1 do
      begin
        DeleteRegKey(KeyName + '\' + Strings[i]);
      end;
      Reg.CloseKey;
      Reg.DeleteKey(KeyName);
    end;
  finally
    Reg.Free;
    Strings.Free;
  end;
end;

{ TTextMap }

constructor TTextMap.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TTextMap.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TTextMap.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TTextMap.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TTextMap.GetItem(Index: Integer): TTextMapItem;
begin
  Result := FList[Index];
end;

procedure TTextMap.InsertItem(AItem: TTextMapItem);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TTextMap.RemoveItem(AItem: TTextMapItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TTextMap.Add: TTextMapItem;
begin
  Result := TTextMapItem.Create(Self);
end;

procedure TTextMap.Assign(Source: TTextMap);
var
  i: Integer;
  Item: TTextMapItem;
begin
  Clear;
  for i := 0 to Source.Count-1 do
  begin
    Item := Add;
    Item.Item1 := Source[i].Item1;
    Item.Item2 := Source[i].Item2;
  end;
end;

function TTextMap.Replace(const Text: WideString): WideString;
var
  i: Integer;
begin
  Result := Text;
  for i := 0 to Count-1 do
    Result := Items[i].Replace(Result);
end;

procedure TTextMap.LoadFromRegistry(const KeyName: WideString);
var
  i: Integer;
  Text1: WideString;
  Text2: WideString;
  KeyName2: WideString;
  Reg: TTntRegistry;
  KeyNames: TTntStringList;
  TextMapItem: TTextMapItem;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(KeyName, False) then
    begin
      Clear;
      KeyNames := TTntStringList.Create;
      try
        Reg.GetKeyNames(KeyNames);
        for i := 0 to KeyNames.Count-1 do
        begin
          Reg.CloseKey;
          KeyName2 := KeyName + '\' + KeyNames[i];
          if Reg.OpenKey(KeyName2, False) then
          begin
            Text1 := Reg.ReadString('Text1');
            Text2 := Reg.ReadString('Text2');
            TextMapItem := Add;
            TextMapItem.Item1 := Text1;
            TextMapItem.Item2 := Text2;
          end;
        end;
      finally
        KeyNames.Free;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TTextMap.SaveToRegistry(const KeyName: WideString);
var
  i: Integer;
  KeyName2: WideString;
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    DeleteRegKey(KeyName);
    if Reg.OpenKey(KeyName, True) then
    begin
      for i := 0 to Count-1 do
      begin
        Reg.CloseKey;
        KeyName2 := KeyName + '\TextMap' + IntToStr(i);
        if Reg.OpenKey(KeyName2, True) then
        begin
          Reg.WriteString('Text1', Items[i].Item1);
          Reg.WriteString('Text2', Items[i].Item2);
        end;
      end;
    end;
  finally
    Reg.Free;
  end;
end;


{ TTextMapItem }

constructor TTextMapItem.Create(AOwner: TTextMap);
begin
  inherited Create;
  SetOwner(AOwner);
  Item1 := 'Text to replace';
  Item2 := 'Replacement text';
end;

destructor TTextMapItem.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TTextMapItem.SetOwner(AOwner: TTextMap);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TTextMapItem.Assign(Source: TTextMapItem);
begin
  Item1 := Source.Item1;
  Item2 := Source.Item2;
end;

function TTextMapItem.Replace(const Text: WideString): WideString;
begin
  Result := Tnt_WideStringReplace(Text, Item1, Item2, [
    rfReplaceAll, rfIgnoreCase]);
end;

end.
