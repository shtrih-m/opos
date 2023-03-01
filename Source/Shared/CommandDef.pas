unit CommandDef;

interface

Uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  XmlParser, CommandParam, LogFile;

type
  TCommandDef = class;

  { TCommandDefs }

  TCommandDefs = class
  private
    FList: TList;
    FLogger: ILogFile;

    function GetCount: Integer;
    function GetItem(Index: Integer): TCommandDef;
    procedure InsertItem(AItem: TCommandDef);
    procedure RemoveItem(AItem: TCommandDef);
    procedure DoLoadFromFile(const FileName: string);
    procedure DoSaveToFile(const FileName: string);
  public
    constructor Create(ALogger: ILogFile);
    destructor Destroy; override;

    procedure Clear;
    procedure SetDefaults;
    function Add: TCommandDef;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    function ItemByCode(Code: Integer): TCommandDef;

    property Logger: ILogFile read FLogger;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCommandDef read GetItem; default;
  end;

  { TCommandDef }

  TCommandDef = class
  private
    FCode: Integer;
    FName: string;
    FTimeout: Integer;
    FOwner: TCommandDefs;
    FInParams: TCommandParams;
    FOutParams: TCommandParams;

    procedure SetOwner(AOwner: TCommandDefs);
    procedure LoadParam(Param: TCommandParam; Root: TXmlItem);
    procedure LoadParams(Params: TCommandParams; Root: TXmlItem);
    procedure SaveParams(Params: TCommandParams; Root: TXmlItem);
    procedure SaveParam(Param: TCommandParam; Root: TXmlItem);
  public
    constructor Create(AOwner: TCommandDefs);
    destructor Destroy; override;

    procedure SaveToXml(Root: TXmlItem);
    procedure LoadFromXml(Root: TXmlItem);

    property InParams: TCommandParams read FInParams;
    property OutParams: TCommandParams read FOutParams;
    property Code: Integer read FCode write FCode;
    property Name: string read FName write FName;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

var
  CommandDefsLoadEnabled: Boolean = True;

implementation

var
  FXmlCommands: TCommandDefs;

function XmlCommands(ALogger: ILogFile): TCommandDefs;
begin
  if FXmlCommands = nil then
    FXmlCommands := TCommandDefs.Create(ALogger);
  Result := FXmlCommands;
end;

{ TCommandDefs }

constructor TCommandDefs.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FList := TList.Create;
  SetDefaults;
end;

destructor TCommandDefs.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TCommandDefs.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TCommandDefs.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCommandDefs.GetItem(Index: Integer): TCommandDef;
begin
  Result := FList[Index];
end;

procedure TCommandDefs.InsertItem(AItem: TCommandDef);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TCommandDefs.RemoveItem(AItem: TCommandDef);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TCommandDefs.Add: TCommandDef;
begin
  Result := TCommandDef.Create(Self);
end;

function TCommandDefs.ItemByCode(Code: Integer): TCommandDef;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.Code = Code then Exit;
  end;
  raise Exception.Create('Command not found');
end;

procedure TCommandDefs.DoLoadFromFile(const FileName: string);
var
  i: Integer;
  Parser: TXmlParser;
  Item: TXmlItem;
  CommandsItem: TXmlItem;
begin
  if not CommandDefsLoadEnabled then Exit;
  Clear;
  Parser := TXmlParser.Create;
  try
    Parser.LoadFromFile(FileName);
    CommandsItem := Parser.Root.FindItem('Commands');
    if CommandsItem <> nil then
    begin
      for i := 0 to CommandsItem.Count-1 do
      begin
        Item := CommandsItem[i];
        if Item.NameIsEqual('Command')  then
        begin
          Add.LoadFromXml(Item);
        end;
      end;
    end;
  finally
    Parser.Free;
  end;
end;

procedure TCommandDefs.DoSaveToFile(const FileName: string);
var
  i: Integer;
  Item: TXmlItem;
  Parser: TXmlParser;
  CommandsItem: TXmlItem;
begin
  Parser := TXmlParser.Create;
  try
    CommandsItem := Parser.Root.Add('Commands');
    for i := 0 to Count-1 do
    begin
      Item := CommandsItem.Add('Command');
      Items[i].SaveToXml(Item);
    end;
    Parser.SaveToFile(FileName);
  finally
    Parser.Free;
  end;
end;

procedure TCommandDefs.SaveToFile(const FileName: string);
begin
  try
    DoSaveToFile(FileName);
  except
    on E: Exception do
      Logger.Error('TCommandDefs.SaveToFile: ', E);
  end;
end;

procedure TCommandDefs.LoadFromFile(const FileName: string);
begin
  try
    DoLoadFromFile(FileName);
  except
    on E: Exception do
      Logger.Error('TCommandDefs.LoadFromFile: ', E);
  end;
end;

procedure TCommandDefs.SetDefaults;

  function AddCommand(Code: Integer; const Name: string): TCommandDef;
  begin
    Result := Add;
    Result.Code := Code;
    Result.Name := Name;
  end;

  function AddParam(
    Params: TCommandParams;
    const ParamName: string;
    ParamSize: Integer;
    ParamType: Integer): TCommandParam;
  begin
    Result := Params.Add;
    Result.Name := ParamName;
    Result.Size := ParamSize;
    Result.ParamType := ParamType;
  end;

var
  Command: TCommandDef;
begin
  Clear;
  // 01h
  Command := AddCommand($01, 'Get dump');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'ECR unit code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Data blocks count', 2, PARAM_TYPE_INT);
  // 02h
  Command := AddCommand($02, 'Get Data block from dump');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Device code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Data block number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Data block', 32, PARAM_TYPE_HEX);
  // 03h
  Command := AddCommand($03, 'Interrupt data stream');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 0Dh
  Command := AddCommand($0D, 'Fiscalization with long ECRRN');
  AddParam(Command.InParams, 'Old password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'New password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'ECRRN', 7, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Taxpayer ID', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Fiscalization number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Refiscalizations left count', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Last closed day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Fiscalization date', 3, PARAM_TYPE_DATE_DMY);
  // 0Eh
  Command := AddCommand($0E, 'Set long serial number');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Serial number', 7, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 0Fh
  Command := AddCommand($0F, 'Get long serial number and long ECRRN');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Serial number', 7, PARAM_TYPE_FINT);
  AddParam(Command.OutParams, 'ECRRN', 7, PARAM_TYPE_FINT);
  // 10h
  Command := AddCommand($10, 'Get short ECR status');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR flags', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR mode', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR submode', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Current receipt operations count (Low byte)', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Battery voltage', 1, PARAM_TYPE_VBAT);
  AddParam(Command.OutParams, 'Power supply voltage', 1, PARAM_TYPE_VSRC);
  AddParam(Command.OutParams, 'FM error code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'EJ error code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Current receipt operations count (Hi byte)', 1, PARAM_TYPE_INT);
  // 11h
  Command := AddCommand($11, 'Get ECR status');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR firmware version', 2, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'ECR firmware build', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR firmware date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'ECR number in checkout line', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Current document transparent number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR flags', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR mode', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR submode', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR port', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'FM firmware version', 2, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'fm firmware build', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'fm firmware date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Time', 3, PARAM_TYPE_TIME_HMS);
  AddParam(Command.OutParams, 'FM flags', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Serial number', 4, PARAM_TYPE_FINT);
  AddParam(Command.OutParams, 'Last closed day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Free FM records count', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Refiscalization count', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Refiscalizations left count', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Taxpayer ID', 6, PARAM_TYPE_FINT);
  // 12h
  Command := AddCommand($12, 'Print bold string');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Flags', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'String of characters to print', 20, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 13h
  Command := AddCommand($13, 'Beep');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 14h
  Command := AddCommand($14, 'Set communication parameters');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Port number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Baud rate code', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Read byte timeout', 1, PARAM_TYPE_TIMEOUT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 15h
  Command := AddCommand($15, 'Read communication parameters');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Port number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Baud rate code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Read byte timeout', 1, PARAM_TYPE_TIMEOUT);
  // 16h
  Command := AddCommand($16, 'Technological reset');
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 17h
  Command := AddCommand($17, 'Print string');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Flags', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'String of characters to print', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 18h
  Command := AddCommand($18, 'Print document header');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Document name', 30, PARAM_TYPE_STR);
  AddParam(Command.InParams, 'Document number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Transparent document number', 2, PARAM_TYPE_INT);
  // 19h
  Command := AddCommand($19, 'Test run');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Test timeout, min.', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 1Ah
  Command := AddCommand($1A, 'Get cash totalizer value');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Cash totalizer number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Cash totalizer value', 6, PARAM_TYPE_INT);
  // 1Bh
  Command := AddCommand($1B, 'Get operation totalizer value');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Operation totalizer number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operation totalizer value', 2, PARAM_TYPE_INT);
  // 1Ch
  Command := AddCommand($1C, 'Write license');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'License', 5, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 1Eh
  Command := AddCommand($1E, 'Write table');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Table', 1, PARAM_TYPE_TABLE);
  AddParam(Command.InParams, 'Row', 2, PARAM_TYPE_ROW);
  AddParam(Command.InParams, 'Field', 1, PARAM_TYPE_FIELD);
  AddParam(Command.InParams, 'Value', 0, PARAM_TYPE_FVALUE);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 1Fh
  Command := AddCommand($1F, 'Read table');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Table', 1, PARAM_TYPE_TABLE);
  AddParam(Command.InParams, 'Row', 2, PARAM_TYPE_ROW);
  AddParam(Command.InParams, 'Field', 1, PARAM_TYPE_FIELD);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Value', 0, PARAM_TYPE_FVALUE);
  // 20h
  Command := AddCommand($20, 'Set decimal point position');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Decimal point position', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 21h
  Command := AddCommand($21, 'Set clock time');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Time', 3, PARAM_TYPE_TIME_HMS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 22h
  Command := AddCommand($22, 'Set calendar date');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 23h
  Command := AddCommand($23, 'Confirm date');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 24h
  Command := AddCommand($24, 'Initialize tables with default values');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 25h
  Command := AddCommand($25, 'Cut receipt');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Cut type', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 26h
  Command := AddCommand($26, 'Get font parameters');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Font number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Print width in dots', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Character width in dots', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Character heigth in dots', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Font count', 1, PARAM_TYPE_INT);
  // 27h
  Command := AddCommand($27, 'Common clear');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 28h
  Command := AddCommand($28, 'Open cash drawer');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Cash drawer number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 29h
  Command := AddCommand($29, 'Feed');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Flags', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Strings to feed count', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 2Ah
  Command := AddCommand($2A, 'Eject slip');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Eject direction', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 2Bh
  Command := AddCommand($2B, 'Interrupt test');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 2Ch
  Command := AddCommand($2C, 'Print operation totalizers report');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 2Dh
  Command := AddCommand($2D, 'Get table structure');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Table number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Table name', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Row count', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Field count', 1, PARAM_TYPE_INT);
  // 2Eh
  Command := AddCommand($2E, 'Get field structure');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Table number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Field number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Field name', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Field type', 1, PARAM_TYPE_FTYPE);
  AddParam(Command.OutParams, 'Byte count', 1, PARAM_TYPE_FSIZE);
  AddParam(Command.OutParams, 'Min field value', 1, PARAM_TYPE_MIN);
  AddParam(Command.OutParams, 'Max field value', 1, PARAM_TYPE_MAX);
  // 2Fh
  Command := AddCommand($2F, 'Print string with font');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Flags', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'String of characters to print', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 40h
  Command := AddCommand($40, 'Daily report without cleaning');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 41h
  Command := AddCommand($41, 'Daily report with cleaning');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 42h
  Command := AddCommand($42, 'Print Department report');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 43h
  Command := AddCommand($43, 'Print tax report');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 50h
  Command := AddCommand($50, 'Cash in');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Sum', 5, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Transparent document number', 2, PARAM_TYPE_INT);
  // 51h
  Command := AddCommand($51, 'Cash out');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Sum', 5, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Transparent document number', 2, PARAM_TYPE_INT);
  // 52h
  Command := AddCommand($52, 'Print fixed document header');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 53h
  Command := AddCommand($53, 'Print document footer');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Parameters', 1, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 54h
  Command := AddCommand($54, 'Print trailer');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 60h
  Command := AddCommand($60, 'Set serial number');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Serial number', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 61h
  Command := AddCommand($61, 'Initialize FM');
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 62h
  Command := AddCommand($62, 'Get FM totals');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.InParams, 'Request type', 1, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Daily sales totals sum', 8, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Daily buys totals sum', 6, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Daily sale returns totals sum', 6, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Daily buy returns totals sum', 6, PARAM_TYPE_INT);
  // 63h
  Command := AddCommand($63, 'Get last FM record date');
  AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_SYS);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Last record type', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Date', 3, PARAM_TYPE_DATE_DMY);
  // 64h
  Command := AddCommand($64, 'Get dates and sessions range');
  AddParam(Command.InParams, 'Tax officer password', 4, PARAM_TYPE_TAX);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'First day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Last day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'First day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Last day number', 2, PARAM_TYPE_INT);
  // 65h
  Command := AddCommand($65, 'Fiscalization');
  AddParam(Command.InParams, 'Old password', 4, PARAM_TYPE_TAX);
  AddParam(Command.InParams, 'New password', 4, PARAM_TYPE_TAX);
  AddParam(Command.InParams, 'RegID', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'TaxID', 6, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Fiscalization number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Fiscalizations left count', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Fiscalization day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Fiscalization data', 3, PARAM_TYPE_DATE_DMY);
  // 66h
  Command := AddCommand($66, 'Fiscal report in dates range');
  AddParam(Command.InParams, 'Tax officer password', 4, PARAM_TYPE_TAX);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.InParams, 'Last day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'First day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Last day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'First day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Last day number', 2, PARAM_TYPE_INT);
  // 67h
  Command := AddCommand($67, 'Fiscal report in days range');
  AddParam(Command.InParams, 'Tax officer password', 4, PARAM_TYPE_TAX);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day number', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Last day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'First day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Last day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'First day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Last day number', 2, PARAM_TYPE_INT);
  // 68h
  Command := AddCommand($68, 'Interrupt full report');
  AddParam(Command.InParams, 'Tax officer password', 4, PARAM_TYPE_TAX);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 69h
  Command := AddCommand($69, 'Get fiscalization parameters');
  AddParam(Command.InParams, 'Tax officer password', 4, PARAM_TYPE_TAX);
  AddParam(Command.InParams, 'Fiscalization number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Password', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECRRN', 5, PARAM_TYPE_FINT);
  AddParam(Command.OutParams, 'Taxpayer ID', 6, PARAM_TYPE_FINT);
  AddParam(Command.OutParams, 'Day number before fiscalization ', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Fiscalization/refiscalization date', 3, PARAM_TYPE_DATE_DMY);
  // 70h
  Command := AddCommand($70, 'Open fiscal slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Document type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Slip duplicates type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Duplicate count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Spacing between original and 1-st duplicate', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Spacing between 1-st and 2-nd duplicate', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Spacing between 2-nd and 3-d duplicate', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Spacing between 3-d and 4-th duplicate', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Spacing between 4-th and 5-th duplicate', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Font number of fixed header', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Font number of document header', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Font number of EJ serial number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Font number of KPK value and KPK number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Vertical position of fixed header', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Vertical position of document header', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Vertical position of EJ serial number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Vertical position of duplicate marker', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Horizontal position of fixed header', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Horizontal position of document header', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Horizontal position of EJ serial number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Horizontal position of KPK value and KPK number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Horizontal position of duplicate marker', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Transparent document number', 2, PARAM_TYPE_INT);
  // 71h
  Command := AddCommand($71, 'Open standard fiscal slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Document type', 1, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Duplicate type', 1, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Duplicate count', 1, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Spacing between original and 1-st duplicate', 1, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Spacing between 1-st and 2-nd duplicate', 1, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Spacing between 2-nd and 3-d duplicate', 1, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Spacing between 3-d and 4-th duplicate', 1, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Spacing between 4-th and 5-th duplicate', 1, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Transparent document number', 2, PARAM_TYPE_INT);
  // 72h
  Command := AddCommand($72, 'Transaction on slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Quantitiy format', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Operation line count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Quantity times price line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Quantity font numter', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Multiplication sign font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Quantity field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Quantity times price field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Vertical position of first transaction string', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Quantity', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 73h
  Command := AddCommand($73, 'Standard transaction on slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Vertical position of first transaction string', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Quantity', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 74h
  Command := AddCommand($74, 'Discount/charge on slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Transaction line count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Transaction name line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Transaction name font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Transaction name field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Operation type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First discount/charge element vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 75h
  Command := AddCommand($75, 'Standard discount/charge on slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Operation type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First discount/charge element vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Sum', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 76h
  Command := AddCommand($76, 'Close fiscal slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Transaction line count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt total vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Cash payment vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 4 vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Change vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 turnover vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 turnover vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 turnover vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 turnover vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 summ vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 sum vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 sum vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 sum vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt subtotal before discount vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Discount sum vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''TOTAL'' font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt total font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''CASH'' font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Cash payment font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 name font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 name font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 4 name font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 4 sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''CHANGE'' font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Change sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 name font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 turnover font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 rate font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 name font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 turnover font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 rate font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 name font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 turnover font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 rate font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 name font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 tunover font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 rate font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 sum font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''SUBTOTAL'' font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt subtotal before discount font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''DISCOUNT XX.XX %'' font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt discount value font number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Total sum field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Cash payment value field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 1 value field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 value field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 value field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Change value field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 name field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 turnover field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 rate field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 sum field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 name field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 turnover field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 rate field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 sum field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 name field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 turnover field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 rate field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 sum field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 name field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 turnover fied character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 rate field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 sum field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt subtotal before discount field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Percent receipt discount field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt discount value field character count', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text string field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''TOTAL'' field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Total sum horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''CASH'' field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Cash sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 name field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 name field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 4 name field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 4 sum fieldhorizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''CHANGE'' field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Change sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 name field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 turnover field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 rate field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1 sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 name field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 turnover field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 rate field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2 sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 name field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 turnover field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 rate field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3 sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 name field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 turnover field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 rate field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4 sum field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''TOTAL'' field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Subtotal before discount field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, '''DISCOUNT XX.XX %'' field horizontal spacing', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Discount sum horizontal spacing ', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First transaction line vertical position', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Cash payment value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 4 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt discount value 0 to 99.99 %', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Change', 5, PARAM_TYPE_INT);
  // 77h
  Command := AddCommand($77, 'Close standard fiscal slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Vertical position of first transaction string', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Cash payment value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 4 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Receipt discount value 0 to 99.99 %', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Change', 5, PARAM_TYPE_INT);
  // 78h
  Command := AddCommand($78, 'Slip configuration');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Slip width in printer steps', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Slip length in printer steps', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Print direction', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Line spacings', 199, PARAM_TYPE_HEX);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 79h
  Command := AddCommand($79, 'Standard slip configuration');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 7Ah
  Command := AddCommand($7A, 'Fill slip buffer with nonfiscal information');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Printing information', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 7Bh
  Command := AddCommand($7B, 'Clear slip buffer string');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Line number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 7Ch
  Command := AddCommand($7C, 'Clear slip buffer');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 7Dh
  Command := AddCommand($7D, 'Print slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Clear nonfiscal info', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Printing information type', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 7Eh
  Command := AddCommand($7E, 'Common slip configuration');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Slip width in printer steps', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Slip length in printer steps', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Printing direction', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Line spacing in printer steps', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 80h
  Command := AddCommand($80, 'Sale');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Quantity', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 81h
  Command := AddCommand($81, 'Buy');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Quantity', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 82h
  Command := AddCommand($82, 'Sale refund');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Quantity', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 83h
  Command := AddCommand($83, 'Buy refund');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Quantity', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 84h
  Command := AddCommand($84, 'Void transaction');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Quantity', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Price', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 85h
  Command := AddCommand($85, 'Close receipt');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Cash payment value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 2 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 3 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Payment type 4 value', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Discount/charge', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Change', 5, PARAM_TYPE_INT);
  // 86h
  Command := AddCommand($86, 'Discount');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Sum', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 87h
  Command := AddCommand($87, 'Charge');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Sum', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 88h
  Command := AddCommand($88, 'Cancel receipt');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 89h
  Command := AddCommand($89, 'Receipt subtotal');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Receipt subtotal', 5, PARAM_TYPE_INT);
  // 8Ah
  Command := AddCommand($8A, 'Void discount');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Sum', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 8Bh
  Command := AddCommand($8B, 'Void charge');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Sum', 5, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 1', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 2', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 3', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Tax 4', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Text', 40, PARAM_TYPE_STR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 8Ch
  Command := AddCommand($8C, 'Print last receipt duplicate');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // 8Dh
  Command := AddCommand($8D, 'Open receipt');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Document type', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // A0h
  Command := AddCommand($A0, 'EJ department report in dates range');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.InParams, 'Last day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A1h
  Command := AddCommand($A1, 'EJ department report in days range');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day number', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Last day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A2h
  Command := AddCommand($A2, 'EJ day report in dates range');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.InParams, 'Last day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A3h
  Command := AddCommand($A3, 'EJ day report in days range');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day number', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Last day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A4h
  Command := AddCommand($A4, 'Print day totals by EJ day number');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A5h
  Command := AddCommand($A5, 'Print pay document from EJ by KPK number');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'KPK number', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A6h
  Command := AddCommand($A6, 'Print EJ journal by day number');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A7h
  Command := AddCommand($A7, 'Interrupt full EJ report');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A8h
  Command := AddCommand($A8, 'Print EJ activization result');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // A9h
  Command := AddCommand($A9, 'EJ activization');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // AAh
  Command := AddCommand($AA, 'Close EJ archive');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // ABh
  Command := AddCommand($AB, 'Get EJ serial number');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'EJ serial number', 5, PARAM_TYPE_INT);
  // ACh
  Command := AddCommand($AC, 'Interrupt EJ');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // ADh
  Command := AddCommand($AD, 'Get EJ status by code 1');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Last KPK document total value', 5, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Last KPK date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Last KPK time', 3, PARAM_TYPE_TIME_HMS);
  AddParam(Command.OutParams, 'Last KPK number', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'EJ number', 5, PARAM_TYPE_TIME_HMS);
  AddParam(Command.OutParams, 'EJ flags', 1, PARAM_TYPE_TIME_HMS);
  // AEh
  Command := AddCommand($AE, 'Get EJ status by code 2');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Sales total', 6, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Buys total', 6, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Sales refund total', 6, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Buys refund total', 6, PARAM_TYPE_INT);
  // AFh
  Command := AddCommand($AF, 'Test EJ integrity');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // B0h
  Command := AddCommand($B0, 'Continue printing');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // B1h
  Command := AddCommand($B1, 'Get EJ version');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'String of characters', 0, PARAM_TYPE_STR);
  // B2h
  Command := AddCommand($B2, 'Initialize EJ');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // B3h
  Command := AddCommand($B3, 'Get EJ report data');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Report string', 0, PARAM_TYPE_STR);
  // B4h
  Command := AddCommand($B4, 'Get EJ journal');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR type', 0, PARAM_TYPE_STR);
  // B5h
  Command := AddCommand($B5, 'Get EJ document');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'KPK number', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR type', 0, PARAM_TYPE_STR);
  // B6h
  Command := AddCommand($B6, 'Get department EJ report in dates range');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.InParams, 'Last day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR type', 0, PARAM_TYPE_STR);
  // B7h
  Command := AddCommand($B7, 'Get EJ department report in days range');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Department number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day number', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Last day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR type', 0, PARAM_TYPE_STR);
  // B8h
  Command := AddCommand($B8, 'Get EJ day report in dates range');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.InParams, 'Last day date', 3, PARAM_TYPE_DATE_DMY);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR type', 0, PARAM_TYPE_STR);
  // B9h
  Command := AddCommand($B9, 'Get EJ day report in days range');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Report type', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'First day number', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Last day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR type', 0, PARAM_TYPE_STR);
  // BAh
  Command := AddCommand($BA, 'Get EJ day totals by day number');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Day number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR type', 0, PARAM_TYPE_STR);
  // BBh
  Command := AddCommand($BB, 'Get EJ activization result');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'ECR type', 0, PARAM_TYPE_STR);
  // BCh
  Command := AddCommand($BC, 'Get EJ error');
  AddParam(Command.InParams, 'Admin password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // C0h
  Command := AddCommand($C0, 'Load graphics');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Line number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Graphical information', 40, PARAM_TYPE_HEX);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // C1h
  Command := AddCommand($C1, 'Print graphics');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Start line', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'End line', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // C2h
  Command := AddCommand($C2, 'Print barcode');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Barcode', 5, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // C3h
  Command := AddCommand($C3, 'Print exteneded graphics');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Start line', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'End line', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // C4h
  Command := AddCommand($C0, 'Load graphics');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Line number', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Graphical information', 40, PARAM_TYPE_HEX);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // C5h
  Command := AddCommand($C5, 'Print line');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Repeat count', 2, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Graphical information', 0, PARAM_TYPE_HEX);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // C8h
  Command := AddCommand($C8, 'Get line count in printing buffer');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Line count in printing buffer', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Printed line count', 2, PARAM_TYPE_INT);
  // C9h
  Command := AddCommand($C9, 'Get line from printing buffer');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Line number', 2, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Line data', 0, PARAM_TYPE_STR);
  // CAh
  Command := AddCommand($CA, 'Clear printing buffer');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // F0h
  Command := AddCommand($F0, 'Change shutter position');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Shutter position', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // F1h
  Command := AddCommand($F1, 'Discharge receipt from presenter');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Discharge type', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // F3h
  Command := AddCommand($F3, 'Set service center password');
  AddParam(Command.InParams, 'Service center password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'New service center  password', 4, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // FCh
  Command := AddCommand($FC, 'Get device type');
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Device type', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Device subtype', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Protocol version', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Protocol subversion', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Device model', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Device language', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Device name', 0, PARAM_TYPE_STR);
  // FDh
  Command := AddCommand($FD, 'Send commands to external device port');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Port number', 1, PARAM_TYPE_INT);
  Addparam(Command.InParams, 'String of commands', 0, PARAM_TYPE_HEX);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // E0h
  Command := AddCommand($FD, 'Open day');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // E1h
  Command := AddCommand($E1, 'Finish slip');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // E3h
  Command := AddCommand($E2, 'Close nonfiscal document');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
  // E4h
  Command := AddCommand($E4, 'Print attribute');
  AddParam(Command.InParams, 'Operator password', 4, PARAM_TYPE_USR);
  AddParam(Command.InParams, 'Atrribute number', 1, PARAM_TYPE_INT);
  AddParam(Command.InParams, 'Attribute value', 0, PARAM_TYPE_HEX);
  AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  AddParam(Command.OutParams, 'Operator number', 1, PARAM_TYPE_INT);
end;


{ TCommandDef }

constructor TCommandDef.Create(AOwner: TCommandDefs);
begin
  inherited Create;
  SetOwner(AOwner);
  FInParams := TCommandParams.Create;
  FOutParams := TCommandParams.Create;
end;

destructor TCommandDef.Destroy;
begin
  FInParams.Free;
  FOutParams.Free;
  SetOwner(nil);
  inherited Destroy;
end;

procedure TCommandDef.SetOwner(AOwner: TCommandDefs);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TCommandDef.LoadParam(Param: TCommandParam; Root: TXmlItem);
var
  ParamType: Integer;
  ParamSize: Integer;
begin
  ParamSize := Root.GetIntDef('Size', 0);
  ParamType := Root.GetInt('Type');
  //ParamSize := GetSizeInBytes(ParamType, ParamSize); !!!

  Param.Size := ParamSize;
  Param.ParamType := ParamType;
  Param.Name := Root.GetText('Name');
  Param.MinValue := Root.GetIntDef('MinValue', 0);
  Param.MaxValue := Root.GetIntDef('MaxValue', 0);
end;

procedure TCommandDef.SaveParam(Param: TCommandParam; Root: TXmlItem);
begin
  Root.AddText('Name', Param.Name);
  Root.AddInt('Size', Param.Size);
  Root.AddInt('Type', Param.ParamType);
  if Param.MaxValue > 0 then
  begin
    Root.AddInt('MinValue', Param.MinValue);
    Root.AddInt('MaxValue', Param.MaxValue);
  end;
end;

procedure TCommandDef.LoadParams(Params: TCommandParams; Root: TXmlItem);
var
  i: Integer;
  Node: TXmlItem;
begin
  Params.Clear;
  if Root = nil then Exit;

  for i := 0 to Root.Count-1 do
  begin
    Node := Root[i];
    if Node.NameIsEqual('Param')  then
    begin
      LoadParam(Params.Add, Node);
    end;
  end;
end;

procedure TCommandDef.SaveParams(Params: TCommandParams; Root: TXmlItem);
var
  i: Integer;
begin
  if Root = nil then Exit;
  for i := 0 to Params.Count-1 do
    SaveParam(Params[i], Root.Add('Param'));
end;

procedure TCommandDef.LoadFromXml(Root: TXmlItem);
begin
  FCode := Root.GetInt('Code');
  FName := Root.GetText('Name');
  FTimeout := Root.GetInt('Timeout');
  LoadParams(InParams, Root.FindItem('InParams'));
  LoadParams(OutParams, Root.FindItem('OutParams'));
end;

procedure TCommandDef.SaveToXml(Root: TXmlItem);
begin
  Root.AddText('Code', Format('0x%.4X', [Code]));
  Root.AddText('Name', Name);
  Root.AddInt('Timeout', Timeout);
  SaveParams(InParams, Root.Add('InParams'));
  SaveParams(OutParams, Root.Add('OutParams'));
end;

end.
