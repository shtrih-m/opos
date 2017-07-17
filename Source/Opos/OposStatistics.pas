unit OposStatistics;

interface

uses
  // VCL
  Windows, Classes, SysUtils, IniFiles,
  // This
  StatisticItem, OposStat, MSXML, LogFile, FileUtils;

type
  { TOposStatistics }

  TOposStatistics = class
  private
    FItems: TStatisticItems;
    FDeviceCategory: string;
    FUnifiedPOSVersion: string;
    FManufacturerName: string;
    FModelName: string;
    FSerialNumber: string;
    FFirmwareRevision: string;
    FInterfaceName: string;
    FInstallationDate: string;
    FLogger: ILogFile;

    function SaveToXml: string;
    function GetIniFileName: string;
    procedure SetItems(const Value: TStatisticItems);
    procedure ParseNames(const Names: string; Strings: TStrings);
    function ValidItem(Item: TStatisticItem; const StatName: string): Boolean;

    property Logger: ILogFile read FLogger;
    property Items: TStatisticItems read FItems write SetItems;
  protected
    procedure Add(const StatisticName: string);
    procedure IncItem(const StatisticName: string); overload;
    procedure IncItem(const StatisticName: string; Count: Integer); overload;
  public
    constructor Create(ALogger: ILogFile); virtual;
    destructor Destroy; override;

    procedure Assign(Source: TOposStatistics);
    procedure IniLoad(const DeviceName: string); virtual;
    procedure IniSave(const DeviceName: string); virtual;
    procedure Reset(const StatisticsBuffer: WideString); virtual;
    procedure Update(const StatisticsBuffer: WideString); virtual;
    procedure Retrieve(var StatisticsBuffer: WideString); virtual;
    function GetCounter(const ItemName: WideString): Integer;

    procedure CommunicationError;
    procedure ReportHoursPowered(Count: Integer);

    property DeviceCategory: string read FDeviceCategory write FDeviceCategory;
    property UnifiedPOSVersion: string read FUnifiedPOSVersion write FUnifiedPOSVersion;
    property ManufacturerName: string read FManufacturerName write FManufacturerName;
    property ModelName: string read FModelName write FModelName;
    property SerialNumber: string read FSerialNumber write FSerialNumber;
    property FirmwareRevision: string read FFirmwareRevision write FFirmwareRevision;
    property InterfaceName: string read FInterfaceName write FInterfaceName;
    property InstallationDate: string read FInstallationDate write FInstallationDate;
  end;

implementation

{ TOposStatistics }

constructor TOposStatistics.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FItems := TStatisticItems.Create;
  // Common Statistics for all Device Categories.
  Add(OPOS_STAT_HoursPoweredCount);
  Add(OPOS_STAT_CommunicationErrorCount);
end;

destructor TOposStatistics.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TOposStatistics.SetItems(const Value: TStatisticItems);
begin
  Items.Assign(Value);
end;

procedure TOposStatistics.Add(const StatisticName: string);
begin
  Items.Add(StatisticName, stOpos);
end;

procedure TOposStatistics.ParseNames(const Names: string; Strings: TStrings);
var
  S: string;
  P: Integer;
begin
  if Names = '' then
  begin
    Strings.Add(Names);
    Exit;
  end;

  S := Names;
  Strings.Clear;
  repeat
    P := Pos(',', S);
    if P = 0 then
    begin
      if S <> '' then Strings.Add(S);
      Exit;
    end;

    Strings.Add(Trim(Copy(S, 1, P-1)));
    S := Copy(S, P+1, Length(S));
  until false;
end;

(*******************************************************************************

  This is a comma-separated list of name(s), where an empty string (“”) means ALL
  resettable statistics are to be reset, “U_” means all UnifiedPOS defined resettable
  statistics are to be reset, “M_” means all manufacturer defined resettable statistics
  are to be reset, and “actual_name1, actual_name2” (from the XML file definitions)
  means that the specifically defined resettable statistic(s) are to be reset.

*******************************************************************************)

procedure TOposStatistics.Reset(const StatisticsBuffer: WideString);
var
  i, j: Integer;
  StatNames: TStrings;
  Item: TStatisticItem;
begin
  StatNames := TStringList.Create;
  try
    ParseNames(StatisticsBuffer, StatNames);
    for i := 0 to StatNames.Count-1 do
    begin
      for j := 0 to Items.Count-1 do
      begin
        Item := Items[j];
        if ValidItem(Item, StatNames[i]) then
        begin
          Item.Reset;
        end;
      end;
    end;
  finally
    StatNames.Free;
  end;
end;

(*******************************************************************************

  retrieveStatistics
  Method Added in Release 1.8

  This is a comma-separated list of name(s), where an empty string (“”) means ALL
  statistics are to be retrieved, “U_” means all UnifiedPOS defined statistics are to
  be retrieved, “M_” means all manufacturer defined statistics are to be retrieved,
  and “actual_name1, actual_name2” (from the XML file definitions) means that the
  specifically defined statistic(s) are to be retrieved.
  Remarks Retrieves the requested statistics from a device.
  CapStatisticsReporting must be true in order to successfully use this method.
  This method is always executed synchronously.
  All calls to retrieveStatistics will return the following XML as a minimum


  <?xml version=’1.0’ ?>
  <UPOSStat
    version=”1.12.0”
    xmlns:xsi=”http://www.w3.org/2001/XMLSchema-instance”
    xmlns=”http://www.nrf-arts.org/UnifiedPOS/namespace/”
    xsi:schemaLocation=”http://www.nrf-arts.org/UnifiedPOS/namespace/ UPOSStat.xsd”
  >
    <Event>
      <Parameter>
        <Name>RequestedStatistic</Name>
        <Value>1234</Value>
      </Parameter>
    </Event>
    <Equipment>
      <UnifiedPOSVersion>1.12</UnifiedPOSVersion>
      <DeviceCategory UPOS=”CashDrawer”/>
      <ManufacturerName>Cashdrawers R Us</ManufacturerName>
      <ModelName>CD-123</ModelName>
      <SerialNumber>12345</SerialNumber>
      <FirmwareRevision>1.0 Rev. B</FirmwareRevision>
      <Interface>RS232</Interface>
      <InstallationDate>2000-03-01</InstallationDate>
    </Equipment>
  </UPOSStat>

  If the application requests a statistic name that the device does not support, the
  <Parameter> entry will be returned with an empty <Value>. e.g.,

    <Parameter>
      <Name>RequestedStatistic</Name>
      <Value></Value>
    </Parameter>

  All statistics that the device collects that are manufacturer specific (not defined in the
  schema) will be returned in a <ManufacturerSpecific> tag instead of a <Parameter>
  tag. e.g.,

    <ManufacturerSpecific>
      <Name>TheAnswer</Name>
      <Value>42</Value>
    </ManufacturerSpecific>

  When an application requests all statistics from the device, the device will return a
  <Parameter> entry for every defined statistic for the device category as defined by the
  XML schema version specified by the version attribute in the <UPOSStat> tag. If the
  device does not record any of the statistics, the <Value> tag will be empty.

*******************************************************************************)

procedure TOposStatistics.Retrieve(var StatisticsBuffer: WideString);
var
  i, j: Integer;
  StatName: string;
  StatNames: TStrings;
  Item: TStatisticItem;
  Statistics: TOposStatistics;
begin
  StatNames := TStringList.Create;
  Statistics := TOposStatistics.Create(Logger);
  try
    Statistics.Assign(Self);
    Statistics.Items.Clear;
    ParseNames(StatisticsBuffer, StatNames);
    for i := 0 to StatNames.Count-1 do
    begin
      StatName := StatNames[i];
      for j := 0 to Items.Count-1 do
      begin
        Item := Items[j];
        if ValidItem(Item, StatName) then
          Statistics.Items.AddItem(Item);
      end;
    end;
    StatisticsBuffer := Statistics.SaveToXml;
  finally
    StatNames.Free;
    Statistics.Free;
  end;
end;

function TOposStatistics.ValidItem(Item: TStatisticItem;
  const StatName: string): Boolean;
begin
  // All
  if StatName = '' then
  begin
    Result := True;
    Exit;
  end;
  if StatName = '“”' then
  begin
    Result := True;
    Exit;
  end;
  if StatName = '""' then
  begin
    Result := True;
    Exit;
  end;
  // U_
  if StatName = 'U_' then
  begin
    Result := Item.IsOpos;
    Exit;
  end;
  // M_
  if StatName = 'M_' then
  begin
    Result := Item.IsManufacturer;
    Exit;
  end;
  // Other
  Result := AnsiCompareText(Item.Name, StatName) = 0;
end;

procedure TOposStatistics.Update(const StatisticsBuffer: WideString);
var
  i, j: Integer;
  P: Integer;
  StatPair: string;
  StatName: string;
  StatValue: string;
  Strings: TStrings;
  Item: TStatisticItem;
begin
  Strings := TStringList.Create;
  try
    ParseNames(StatisticsBuffer, Strings);
    for i := 0 to Strings.Count-1 do
    begin
      StatPair := Strings[i];
      P := Pos('=', StatPair);
      StatName := Copy(StatPair, 1, P-1);
      StatValue := Copy(StatPair, P+1, Length(StatPair));
      for j := 0 to Items.Count-1 do
      begin
        Item := Items[j];
        if ValidItem(Item, StatName) then
          Item.SetValue(StatValue);
      end;
    end;
  finally
    Strings.Free;
  end;
end;

procedure TOposStatistics.IncItem(const StatisticName: string);
begin
  IncItem(StatisticName, 1);
end;

procedure TOposStatistics.IncItem(const StatisticName: string;
  Count: Integer);
var
  Item: TStatisticItem;
begin
  Item := Items.ItemByName(StatisticName);
  if Item <> nil then Item.IncCounter(Count);
end;

(*******************************************************************************

  <?xml version=’1.0’ ?>
  <UPOSStat
    version=”1.12.0”
    xmlns:xsi=”http://www.w3.org/2001/XMLSchema-instance”
    xmlns=”http://www.nrf-arts.org/UnifiedPOS/namespace/”
    xsi:schemaLocation=”http://www.nrf-arts.org/UnifiedPOS/namespace/ UPOSStat.xsd”
  >
    <Event>
      <Parameter>
        <Name>RequestedStatistic</Name>
        <Value>1234</Value>
      </Parameter>
    </Event>
    <Equipment>
      <UnifiedPOSVersion>1.12</UnifiedPOSVersion>
      <DeviceCategory UPOS=”CashDrawer”/>
      <ManufacturerName>Cashdrawers R Us</ManufacturerName>
      <ModelName>CD-123</ModelName>
      <SerialNumber>12345</SerialNumber>
      <FirmwareRevision>1.0 Rev. B</FirmwareRevision>
      <Interface>RS232</Interface>
      <InstallationDate>2000-03-01</InstallationDate>
    </Equipment>
  </UPOSStat>

*******************************************************************************)

function TOposStatistics.SaveToXml: string;

  procedure AddCRLF(node: IXMLDOMElement);
  begin
    node.appendChild(node.ownerDocument.createTextNode(#13#10));
  end;

  procedure AddTabs(node: IXMLDOMElement; Count: Integer);
  begin
    node.appendChild(node.ownerDocument.createTextNode(
      StringOfChar(Chr(VK_TAB), Count)));
  end;

  function addNode(node: IXMLDOMElement; const nodeName: string;
    Level: Integer): IXMLDOMElement;
  begin
    AddTabs(node, Level);
    Result := node.ownerDocument.createElement(nodeName);
    node.appendChild(Result);
    AddCRLF(node);
  end;

  procedure addNodeText(node: IXMLDOMElement; const nodeName, nodeText: string;
    Level: Integer);
  begin
    addNode(node, nodeName, Level).text := nodeText;
  end;

  procedure addAttribute(node: IXMLDOMElement;
    const attName, attText: string);
  var
    att: IXMLDOMAttribute;
  begin
    att := node.ownerDocument.createAttribute(attName);
    node.attributes.setNamedItem(att);
    att.text := attText;
  end;

var
  i: Integer;
  Item: TStatisticItem;
  doc: IXMLDOMDocument;
  node: IXMLDOMElement;
  element: IXMLDOMElement;
  paramNode: IXMLDOMElement;
begin
  doc := CoDOMDocument.Create;
  doc.async := False;
  doc.appendChild(doc.createProcessingInstruction('xml', 'version=''1.0'''));
  doc.documentElement := doc.createElement('UPOSStat');
  element := doc.documentElement;
  element.setAttribute('version', '1.13.0');
  element.setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
  element.setAttribute('xmlns', 'http://www.nrf-arts.org/UnifiedPOS/namespace/');
  element.setAttribute('xsi:schemaLocation', 'http://www.nrf-arts.org/UnifiedPOS/namespace/ UPOSStat.xsd');
  AddCRLF(element);
  // Events
  node := addNode(element, 'Event', 1);
  AddCRLF(node);
  // Opos statistics
  for i := 0 to Items.Count-1 do
  begin
    Item := Items[i];
    if Item.IsOpos then
    begin
      paramNode := addNode(node, 'Parameter', 2);
      AddCRLF(paramNode);
      addNodeText(paramNode, 'Name', Item.Name, 3);
      addNodeText(paramNode, 'Value', Item.Text, 3);
      AddTabs(paramNode, 2);
    end;
  end;
  // Manufacturer defined statistics
  for i := 0 to Items.Count-1 do
  begin
    Item := Items[i];
    if Item.IsManufacturer then
    begin
      paramNode := addNode(node, 'ManufacturerSpecific', 2);
      AddCRLF(paramNode);
      addNodeText(paramNode, 'Name', Item.Name, 3);
      addNodeText(paramNode, 'Value', Item.Text, 3);
      AddTabs(paramNode, 2);
    end;
  end;
  AddTabs(node, 1);
  // Equipment
  node := addNode(element, 'Equipment', 1);
  AddCRLF(node);
  addNodeText(node, 'UnifiedPOSVersion', UnifiedPOSVersion, 2);
  addAttribute(addNode(node, 'DeviceCategory', 2), 'UPOS', DeviceCategory);
  addNodeText(node, 'ManufacturerName', ManufacturerName, 2);
  addNodeText(node, 'ModelName', ModelName, 2);
  addNodeText(node, 'SerialNumber', SerialNumber, 2);
  addNodeText(node, 'FirmwareRevision', FirmwareRevision, 2);
  addNodeText(node, 'Interface', InterfaceName, 2);
  addNodeText(node, 'InstallationDate', InstallationDate, 2);
  AddTabs(node, 1);

  Result := doc.xml;
end;

procedure TOposStatistics.Assign(Source: TOposStatistics);
begin
  DeviceCategory := Source.DeviceCategory;
  UnifiedPOSVersion := Source.UnifiedPOSVersion;
  ManufacturerName := Source.ManufacturerName;
  ModelName := Source.ModelName;
  SerialNumber := Source.SerialNumber;
  FirmwareRevision := Source.FirmwareRevision;
  InterfaceName := Source.InterfaceName;
  InstallationDate := Source.InstallationDate;
end;

procedure TOposStatistics.CommunicationError;
begin
  IncItem(OPOS_STAT_CommunicationErrorCount);
end;

procedure TOposStatistics.ReportHoursPowered(Count: Integer);
begin
  IncItem(OPOS_STAT_HoursPoweredCount, Count);
end;

function TOposStatistics.GetIniFileName: string;
begin
  Result := IncludeTrailingBackSlash(ExtractFilePath(FileUtils.GetModuleFileName)) +
    'OposStatistics.ini'
end;

procedure TOposStatistics.IniLoad(const DeviceName: string);
var
  i: Integer;
  ItemText: string;
  IniFile: TIniFile;
  Item: TStatisticItem;
begin
  try
    IniFile := TIniFile.Create(GetIniFileName);
    try
      for i := 0 to Items.Count-1 do
      begin
        Item := Items[i];
        ItemText := IniFile.ReadString(DeviceName, Item.Name, '0');
        try
          Item.SetValue(ItemText);
        except
          on E: Exception do
            Logger.Error('TOposStatistics.IniLoad: ' + Item.Name, E);
        end;
      end;
    finally
      IniFile.Free;
    end;
  except
    on E:Exception do
      Logger.Error('TOposStatistics.IniLoad', E);
  end;
end;

procedure TOposStatistics.IniSave(const DeviceName: string);
var
  i: Integer;
  IniFile: TIniFile;
  Item: TStatisticItem;
begin
  try
    IniFile := TIniFile.Create(GetIniFileName);
    try
      for i := 0 to Items.Count-1 do
      begin
        Item := Items[i];
        IniFile.WriteString(DeviceName, Item.Name, Item.Text);
      end;
    finally
      IniFile.Free;
    end;
  except
    on E:Exception do
      Logger.Error('TOposStatistics.IniSave', E);
  end;
end;

function TOposStatistics.GetCounter(const ItemName: WideString): Integer;
var
  Item: TStatisticItem;
begin
  Result := 0;
  Item := Items.ItemByName(ItemName);
  if Item <> nil then
    Result := Item.Counter;
end;

end.
