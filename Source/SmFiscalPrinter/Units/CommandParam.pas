unit CommandParam;

interface

Uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  PrinterCommand, PrinterTypes, BinStream, XmlParser, StringUtils, BStrUtil,
  WException, TntSysUtils, gnugettext;


const
  PARAM_TYPE_INT        = 0; // Integer
  PARAM_TYPE_STR        = 1; // String
  PARAM_TYPE_HEX        = 2; // Binary byte array in hex format
  PARAM_TYPE_DATE_DMY   = 3; // Date
  PARAM_TYPE_TIME_HMS   = 4; // Time
  PARAM_TYPE_FINT       = 5; // Number, Taxpayer ID, if all $FF - not accepted
  PARAM_TYPE_SYS        = 6; // System administrator password
  PARAM_TYPE_USR        = 7; // Operator password
  PARAM_TYPE_TAX        = 8; // Tax officer password
  PARAM_TYPE_MIN        = 9; // Min field value
  PARAM_TYPE_MAX        = 10; // Max field value
  PARAM_TYPE_FSIZE      = 11; // Field size
  PARAM_TYPE_FTYPE      = 12; // Field type
  PARAM_TYPE_FVALUE     = 13; // Vield value
  PARAM_TYPE_TABLE      = 14; // Table number
  PARAM_TYPE_ROW        = 15; // Row number
  PARAM_TYPE_FIELD      = 16; // Field number
  PARAM_TYPE_VBAT       = 17; // Battery voltage
  PARAM_TYPE_VSRC       = 18; // Power supply voltage
  PARAM_TYPE_TIMEOUT    = 19; // Timeout
  PARAM_TYPE_TIME_HM    = 20; // Time
  PARAM_TYPE_DATE_YMD   = 21; // Date

type
  TCommandParam = class;

  { TCommandParams }

  TCommandParams = class
  private
    FList: TList;
    FPassword: Integer;
    FFieldType: Integer;
    FFieldSize: Integer;
    FTableNumber: Integer;
    FRowNumber: Integer;
    FFieldNumber: Integer;

    function GetAsXml: WideString;
    function GetCount: Integer;
    procedure SetAsXml(const Xml: WideString);
    procedure InsertItem(AItem: TCommandParam);
    procedure RemoveItem(AItem: TCommandParam);
    function GetItem(Index: Integer): TCommandParam;
    function GetAsText: WideString;
    procedure SetAsText(const Value: WideString);
    procedure ReadItem(Item: TCommandParam; Data: TBinStream);
    procedure WriteItem(Item: TCommandParam; Data: TBinStream);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure ClearValue;
    function Add: TCommandParam;
    function GetText(Index: Integer): WideString;
    procedure Read(Stream: TBinStream);
    procedure Write(Stream: TBinStream);
    function FindItem(const Name: WideString): TCommandParam;
    function ItemByName(const Name: WideString): TCommandParam;
    function ItemByType(ParamType: Integer): TCommandParam;

    property Count: Integer read GetCount;
    property AsXml: WideString read GetAsXml write SetAsXml;
    property AsText: WideString read GetAsText write SetAsText;
    property Items[Index: Integer]: TCommandParam read GetItem; default;

    property Password: Integer read FPassword;
    property FieldType: Integer read FFieldType;
    property RowNumber: Integer read FRowNumber;
    property TableNumber: Integer read FTableNumber;
    property FieldNumber: Integer read FFieldNumber;
    property FieldSize: Integer read FFieldSize write FFieldSize;
  end;

  { TCommandParam }

  TCommandParam = class
  private
    FName: WideString;
    FOwner: TCommandParams;
    FSize: Integer;
    FParamType: Integer;
    FMinValue: Integer;
    FMaxValue: Integer;
    FValue: WideString;

    procedure SetOwner(AOwner: TCommandParams);
  public
    constructor Create(AOwner: TCommandParams);
    destructor Destroy; override;
    function IsLastItem: Boolean;

    property Name: WideString read FName write FName;
    property Size: Integer read FSize write FSize;
    property Value: WideString read FValue write FValue;
    property MinValue: Integer read FMinValue write FMinValue;
    property MaxValue: Integer read FMaxValue write FMaxValue;
    property ParamType: Integer read FParamType write FParamType;
  end;

implementation

function ByteToTimeout(Value: Byte): DWORD;
begin
  case Value of
    0..150   : Result := Value;
    151..249 : Result := (Value-149)*150;
  else
    Result := (Value-248)*15000;
  end;
end;

function TimeoutToByte(Value: Integer): Byte;
begin
  case Value of
    0..150        : Result := Value;
    151..15000    : Result := Round(Value/150) + 149;
    15001..105000 : Result := Round(Value/15000) + 248;
  else
    Result := Value;
  end;
end;

function StrToHex(const S: WideString): WideString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    Result := Result + IntToHex(Ord(S[i]), 2);
  end;
end;

{ TCommandParams }

constructor TCommandParams.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TCommandParams.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TCommandParams.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TCommandParams.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCommandParams.GetItem(Index: Integer): TCommandParam;
begin
  Result := FList[Index];
end;

procedure TCommandParams.InsertItem(AItem: TCommandParam);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TCommandParams.RemoveItem(AItem: TCommandParam);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TCommandParams.Add: TCommandParam;
begin
  Result := TCommandParam.Create(Self);
end;

function TCommandParams.FindItem(const Name: WideString): TCommandParam;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if AnsiCompareText(Result.Name, Name) = 0 then Exit;
  end;
  Result := nil;
end;

function TCommandParams.ItemByName(const Name: WideString): TCommandParam;
begin
  Result := FindItem(Name);
  if Result = nil then
    raiseException(_('Параметр не найден'));
end;

function TCommandParams.ItemByType(ParamType: Integer): TCommandParam;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.ParamType = ParamType then Exit;
  end;
  Result := nil;
end;

function TCommandParams.GetAsXml: WideString;
var
  i: Integer;
  Node: TXmlItem;
  Parser: TXmlParser;
  Param: TCommandParam;
begin
  Parser := TXmlParser.Create;
  try
    Parser.SetRootName('Params');
    for i := 0 to Count-1 do
    begin
      Param := Items[i];
      Node := Parser.Root.Add('Param');
      Node.AddText('Name', Param.Name);
      Node.AddText('Value', Param.Value);
    end;
    Result := Parser.Xml;
  finally
    Parser.Free;
  end;
end;

procedure TCommandParams.SetAsXml(const Xml: WideString);
var
  i: Integer;
  Node: TXmlItem;
  Root: TXmlItem;
  Parser: TXmlParser;
  ParamName: WideString;
  ParamValue: WideString;
  Param: TCommandParam;
begin
  Parser := TXmlParser.Create;
  try
    Parser.LoadFromString(Xml);
    Root := Parser.Root.GetItem('Params');
    for i := 0 to Root.Count-1 do
    begin
      Node := Root[i];
      if Node.NameIsEqual('Param') then
      begin
        ParamName := Node.GetText('Name');
        ParamValue := Node.GetText('Value');

        Param := FindItem(ParamName);
        if Param <> nil then
        begin
          Param.Value := ParamValue;
        end;
      end;
    end;
  finally
    Parser.Free;
  end;
end;

procedure TCommandParams.ClearValue;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].Value := '';
end;

procedure TCommandParams.ReadItem(Item: TCommandParam; Data: TBinStream);

  function PrinterDateToStr(Date: TPrinterDate): WideString;
  begin
    Result := Tnt_WideFormat('%.2d.%.2d.%.2d', [Date.Day, Date.Month, Date.Year]);
  end;

  function PrinterTimeToStr(Value: TPrinterTime): WideString;
  begin
    Result := Tnt_WideFormat('%.2d:%.2d:%.2d', [Value.Hour, Value.Min, Value.Sec]);
  end;

  function GetFieldSize: Integer;
  begin
    case FFieldType of
      0: Result := FFieldSize;
    else
      Result := 1;
    end;
  end;

var
  S: WideString;
begin
  case Item.ParamType of
    PARAM_TYPE_INT: Item.Value := IntToStr(Data.ReadInt(Item.Size));
    PARAM_TYPE_STR:
    begin
      if Item.IsLastItem or (Item.Size = 0) then
        Item.Value := Data.ReadString
      else
        Item.Value := Data.ReadString(Item.Size);
    end;
    PARAM_TYPE_HEX: Item.Value := StrToHex(Data.ReadString(Item.Size));
    PARAM_TYPE_SYS: Item.Value := IntToStr(Data.ReadInt(Item.Size));
    PARAM_TYPE_USR: Item.Value := IntToStr(Data.ReadInt(Item.Size));
    PARAM_TYPE_TAX: Item.Value := IntToStr(Data.ReadInt(Item.Size));
    PARAM_TYPE_DATE_DMY: Item.Value := PrinterDateToStr(Data.ReadDateDMY);
    PARAM_TYPE_DATE_YMD: Item.Value := PrinterDateToStr(Data.ReadDateYMD);
    PARAM_TYPE_TIME_HMS: Item.Value := PrinterTimeToStr(Data.ReadTimeHMS);
    PARAM_TYPE_TIME_HM: Item.Value := PrinterTimeToStr(Data.ReadTimeHM);
    PARAM_TYPE_FINT:
    begin
      S := Data.ReadString(Item.Size);
      if S = StringOfChar(#$FF, Item.Size) then
      begin
        Item.Value := StringOfChar('?', Item.Size*2);
      end else
      begin
        Item.Value := IntToStr(BinToInt(S, 1, Item.Size));
      end;
    end;

    PARAM_TYPE_MIN: Item.Value := IntToStr(Data.ReadInt(GetFieldSize));
    PARAM_TYPE_MAX: Item.Value := IntToStr(Data.ReadInt(GetFieldSize));
    PARAM_TYPE_FVALUE: Item.Value := Data.ReadString(Item.Size);
    PARAM_TYPE_TABLE:
    begin
      FTableNumber := Data.ReadInt(Item.Size);
      Item.Value := IntToStr(FTableNumber);
    end;
    PARAM_TYPE_ROW:
    begin
      FRowNumber := Data.ReadInt(Item.Size);
      Item.Value := IntToStr(FRowNumber);
    end;
    PARAM_TYPE_FIELD:
    begin
      FFieldNumber := Data.ReadInt(Item.Size);
      Item.Value := IntToStr(FFieldNumber);
    end;
    PARAM_TYPE_FTYPE:
    begin
      FFieldType := Data.ReadInt(Item.Size);
      Item.Value := IntToStr(FFieldType);
    end;
    PARAM_TYPE_FSIZE:
    begin
      FFieldSize := Data.ReadInt(Item.Size);
      Item.Value := IntToStr(FFieldSize);
    end;
    // Battery voltage
    PARAM_TYPE_VBAT:
    begin
      Item.Value := Tnt_WideFormat('%.2f', [Data.ReadInt(Item.Size)/51]);
    end;
    // Power supply voltage
    PARAM_TYPE_VSRC:
    begin
      Item.Value := Tnt_WideFormat('%.2f', [Data.ReadInt(Item.Size)/9]);
    end;
    PARAM_TYPE_TIMEOUT:
    begin
      Item.Value := IntToStr(ByteToTimeout(Data.ReadInt(Item.Size)));
    end;
  else
    raiseException(_('Invalid parameter type'));
  end;
end;

procedure TCommandParams.Read(Stream: TBinStream);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    ReadItem(Items[i], Stream);
end;

procedure TCommandParams.WriteItem(Item: TCommandParam; Data: TBinStream);

  function StrToPrinterDate(const Value: WideString): TPrinterDate;
  begin
    Result.Day := StrToInt(GetStringK(Value, 1, ['.']));
    Result.Month := StrToInt(GetStringK(Value, 2, ['.']));
    Result.Year := StrToInt(GetStringK(Value, 3, ['.']));
  end;

  function StrToPrinterTime(const Value: WideString): TPrinterTime;
  begin
    Result.Hour := StrToInt(GetStringK(Value, 1, [':']));
    Result.Min := StrToInt(GetStringK(Value, 2, [':']));
    Result.Sec := StrToInt(GetStringK(Value, 3, [':']));
  end;

var
  S: WideString;
  I: Integer;
begin
  case Item.ParamType of
    PARAM_TYPE_INT: Data.WriteInt(StrToInt64(Item.Value), Item.Size);
    PARAM_TYPE_STR:
    begin
      S := Item.Value + StringOfChar(#0, Item.Size - Length(Item.Value));
      Data.WriteString(S);
    end;
    PARAM_TYPE_HEX: Data.WriteString(HexToStr(Item.Value));

    PARAM_TYPE_SYS,
    PARAM_TYPE_USR,
    PARAM_TYPE_TAX:
    begin
      FPassword := StrToInt64(Item.Value);
      Data.WriteInt(FPassword, Item.Size);
    end;
    PARAM_TYPE_DATE_DMY: Data.WriteDateDMY(StrToPrinterDate(Item.Value));
    PARAM_TYPE_DATE_YMD: Data.WriteDateYMD(StrToPrinterDate(Item.Value));
    PARAM_TYPE_TIME_HMS: Data.WriteTimeHMS(StrToPrinterTime(Item.Value));
    PARAM_TYPE_TIME_HM: Data.WriteTimeHM(StrToPrinterTime(Item.Value));
    PARAM_TYPE_FINT: Data.WriteInt(StrToInt64(Item.Value), Item.Size);
    PARAM_TYPE_MIN: ;
    PARAM_TYPE_MAX: ;
    PARAM_TYPE_FVALUE: Data.WriteString(Item.Value);
    PARAM_TYPE_TABLE:
    begin
      FTableNumber := StrToInt64(Item.Value);
      Data.WriteInt(FTableNumber, Item.Size);
    end;
    PARAM_TYPE_ROW:
    begin
      FRowNumber := StrToInt64(Item.Value);
      Data.WriteInt(FRowNumber, Item.Size);
    end;
    PARAM_TYPE_FIELD:
    begin
      FFieldNumber := StrToInt64(Item.Value);
      Data.WriteInt(FFieldNumber, Item.Size);
    end;
    PARAM_TYPE_FTYPE:
    begin
      FFieldType := StrToInt64(Item.Value);
      Data.WriteInt(FFieldType, Item.Size);
    end;
    PARAM_TYPE_FSIZE:
    begin
      FFieldSize := StrToInt64(Item.Value);
      Data.WriteInt(FFieldSize, Item.Size);
    end;
    PARAM_TYPE_TIMEOUT:
    begin
      I := StrToInt64(Item.Value);
      Data.WriteInt(TimeoutToByte(I), Item.Size);
    end;
  else
    raiseException(_('Invalid parameter type'));
  end;
end;

procedure TCommandParams.Write(Stream: TBinStream);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    WriteItem(Items[i], Stream);
end;

function TCommandParams.GetText(Index: Integer): WideString;
var
  i: Integer;
begin
  Result := '';
  for i := Index to Count-1 do
  begin
    if Result <> '' then Result := Result + ';';
    Result := Result + Items[i].Value;
  end;
end;

function TCommandParams.GetAsText: WideString;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count-1 do
  begin
    if Result <> '' then Result := Result + ';';
    Result := Result + Items[i].Value;
  end;
end;

procedure TCommandParams.SetAsText(const Value: WideString);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Items[i].Value := GetStringK(Value, i+1, [';']);
  end;
end;

{ TCommandParam }

constructor TCommandParam.Create(AOwner: TCommandParams);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TCommandParam.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TCommandParam.SetOwner(AOwner: TCommandParams);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

function TCommandParam.IsLastItem: Boolean;
begin
  Result := FOwner.FList.IndexOf(Self) = FOwner.Count-1;
end;

end.
