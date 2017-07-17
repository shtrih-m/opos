unit OposEvents;

interface

Uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs, ComObj,
  // This
  LogFile;

const
  /////////////////////////////////////////////////////////////////////////////
  // EventType constants

  EVENT_TYPE_INPUT    = 0;
  EVENT_TYPE_OUTPUT   = 1;

  /////////////////////////////////////////////////////////////////////////////
  // ID constants

  EVENT_ID_DATA       = 0;
  EVENT_ID_STATUS     = 1;
  EVENT_ID_OUTPUT     = 2;
  EVENT_ID_DIRECTIO   = 3;
  EVENT_ID_ERROR      = 4;

type
  { IOposEvents }

  IOposEvents = interface
  ['{41115F44-8A3D-4EFD-BAA0-69DAFE5134D8}']

    procedure DataEvent(Status: Integer);
    procedure StatusUpdateEvent(Data: Integer);
    procedure OutputCompleteEvent(OutputID: Integer);

    procedure DirectIOEvent(
      EventNumber: Integer;
      var pData: Integer;
      var pString: WideString);

    procedure ErrorEvent(
      ResultCode: Integer;
      ResultCodeExtended: Integer;
      ErrorLocus: Integer;
      var pErrorResponse: Integer);
  end;

  TOposEvent = class;

  { TOposEvents }

  TOposEvents = class
  private
    FList: TList;
    FEvent: TEvent;
    FLock: TCriticalSection;
    procedure Lock;
    procedure Unlock;
    function GetCount: Integer;
    function GetItem(Index: Integer): TOposEvent;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Wait;
    procedure Clear;
    procedure ClearInput;
    procedure ClearOutput;
    function DataCount: Integer;
    procedure Add(Event: TOposEvent);
    function Remove(Index: Integer): TOposEvent;
    procedure Execute(EventInterface: IOposEvents);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TOposEvent read GetItem; default;
  end;

  { TOposEvent }

  TOposEvent = class
  private
    FEventType: Integer;
  public
    function GetID: Integer; virtual; abstract;
    procedure Execute(EventInterface: IOposEvents); virtual; abstract;

    property ID: Integer read GetID;
    property EventType: Integer read FEventType;
  end;

  { TDataEvent }

  TDataEvent = class(TOposEvent)
  private
    FStatus: Integer;
    FLogger: ILogFile;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(AStatus: Integer; AEventType: Integer; ALogger: ILogFile);
    function GetID: Integer; override;
    procedure Execute(EventInterface: IOposEvents); override;
    property Status: Integer read FStatus;
  end;

  { TDirectIOEvent }

  TDirectIOEvent = class(TOposEvent)
  private
    FEventNumber: Integer;
    FData: Integer;
    FString: WideString;
    FLogger: ILogFile;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(EventNumber: Integer;
      const pData: Integer;
      const pString: WideString; ALogger: ILogFile);

    function GetID: Integer; override;
    procedure Execute(EventInterface: IOposEvents); override;
  end;

  { TErrorEvent }

  TErrorEvent = class(TOposEvent)
  private
    FResultCode: Integer;
    FResultCodeExtended: Integer;
    FErrorLocus: Integer;
    FErrorResponse: Integer;
    FLogger: ILogFile;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(ResultCode: Integer;
      ResultCodeExtended: Integer;
      ErrorLocus: Integer; ALogger: ILogFile);

    function GetID: Integer; override;
    procedure Execute(EventInterface: IOposEvents); override;
  end;

  { TOutputCompleteEvent }

  TOutputCompleteEvent = class(TOposEvent)
  private
    FOutputID: Integer;
    FLogger: ILogFile;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(OutputID: Integer; ALogger: ILogFile);

    function GetID: Integer; override;
    procedure Execute(EventInterface: IOposEvents); override;
  end;

  { TStatusUpdateEvent }

  TStatusUpdateEvent = class(TOposEvent)
  private
    FData: Integer;
    FLogger: ILogFile;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(Data: Integer; ALogger: ILogFile);
    function GetID: Integer; override;
    procedure Execute(EventInterface: IOposEvents); override;
    property Data: Integer read FData;
  end;

implementation

{ TOposEvents }

constructor TOposEvents.Create;
begin
  inherited Create;
  FList := TList.Create;
  FEvent := TSimpleEvent.Create;
  FLock := TCriticalSection.Create;
end;

destructor TOposEvents.Destroy;
begin
  Clear;
  FList.Free;
  FLock.Free;
  FEvent.Free;
  inherited Destroy;
end;

procedure TOposEvents.Clear;
begin
  Lock;
  try
    while FList.Count > 0 do
    begin
      TObject(FList[0]).Free;
      FList.Delete(0);
    end;
  finally
    Unlock;
  end;
end;

procedure TOposEvents.Lock;
begin
  Flock.Enter;
end;

procedure TOposEvents.Unlock;
begin
  Flock.Leave;
end;

function TOposEvents.Remove(Index: Integer): TOposEvent;
begin
  Result := nil;

  Lock;
  try
    if FList.Count > 0 then
    begin
      Result := FList[Index];
      FList.Delete(Index);
    end;
  finally
    Unlock;
  end;
end;

procedure TOposEvents.Wait;
begin
  if FEvent.WaitFor(100) = wrSignaled then
    FEvent.ResetEvent;
end;

procedure TOposEvents.Add(Event: TOposEvent);
begin
  Lock;
  try
    FList.Add(Event);
    FEvent.SetEvent;
  finally
    Unlock;
  end;
end;

function TOposEvents.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TOposEvents.GetItem(Index: Integer): TOposEvent;
begin
  Result := FList[Index];
end;

procedure TOposEvents.Execute(EventInterface: IOposEvents);
var
  Event: TOposEvent;
begin
  repeat
    Event := Remove(0);
    if Event <> nil then
    begin
      Event.Execute(EventInterface);
      Event.Free;
    end;
  until Event = nil;
end;

function TOposEvents.DataCount: Integer;
var
  i: Integer;
  Event: TOposEvent;
begin
  Result := 0;
  Lock;
  try
    for i := Count-1 downto 0 do
    begin
      Event := Items[i];
      if Event.EventType = EVENT_TYPE_INPUT then
      begin
        if Event.ID = EVENT_ID_DATA then
        begin
          Inc(Result);
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TOposEvents.ClearInput;
var
  i: Integer;
  Event: TOposEvent;
begin
  Lock;
  try
    for i := Count-1 downto 0 do
    begin
      Event := Items[i];
      if Event.EventType = EVENT_TYPE_INPUT then
      begin
        if (Event is TDataEvent) or (Event is TErrorEvent) then
        begin
          Event.Free;
          FList.Delete(i);
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TOposEvents.ClearOutput;
var
  i: Integer;
  Event: TOposEvent;
begin
  Lock;
  try
    for i := Count-1 downto 0 do
    begin
      Event := Items[i];
      if Event.EventType = EVENT_TYPE_OUTPUT then
      begin
        if (Event is TDataEvent) or (Event is TErrorEvent) then
        begin
          Event.Free;
          FList.Delete(i);
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

{ TDataEvent }

constructor TDataEvent.Create(AStatus: Integer; AEventType: Integer;
  ALogger: ILogFile);
begin
  inherited Create;
  FStatus := AStatus;
  FEventType := AEventType;
  FLogger := ALogger;
end;

procedure TDataEvent.Execute(EventInterface: IOposEvents);
begin
  Logger.Debug('TDataEvent.Execute', [FStatus]);
  try
    if EventInterface <> nil then
      EventInterface.DataEvent(FStatus)
    else
      Logger.Debug('EventInterface = nil');

    Logger.Debug('TDataEvent.Execute: OK');
  except
    on E: Exception do
      Logger.Error('TDataEvent.Execute', E);
  end;
end;

function TDataEvent.GetID: Integer;
begin
  Result := EVENT_ID_DATA;
end;

{ TDirectIOEvent }

constructor TDirectIOEvent.Create(EventNumber: Integer;
  const pData: Integer; const pString: WideString; ALogger: ILogFile);
begin
  inherited Create;
  FEventNumber := EventNumber;
  FData := pData;
  FString := pString;
  FLogger := ALogger;
end;

procedure TDirectIOEvent.Execute(
  EventInterface: IOposEvents);
begin
  Logger.Debug('TDirectIOEvent.Execute', [FEventNumber, FData, FString]);
  try
    if EventInterface <> nil then
      EventInterface.DirectIOEvent(FEventNumber, FData, FString)
    else
      Logger.Debug('EventInterface = nil');

    Logger.Debug('TDirectIOEvent.Execute: OK');
  except
    on E: Exception do
      Logger.Error('TDirectIOEvent.Execute', E);
  end;
end;

function TDirectIOEvent.GetID: Integer;
begin
  Result := EVENT_ID_DIRECTIO;
end;

{ TErrorEvent }

constructor TErrorEvent.Create(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer; ALogger: ILogFile);
begin
  inherited Create;
  FResultCode := ResultCode;
  FResultCodeExtended := ResultCodeExtended;
  FErrorLocus := ErrorLocus;
  FLogger := ALogger;
end;

procedure TErrorEvent.Execute(EventInterface: IOposEvents);
begin
  Logger.Debug('TErrorEvent.Execute', [
    FResultCode, FResultCodeExtended, FErrorLocus, FErrorResponse]);
  try
    if EventInterface <> nil then
      EventInterface.ErrorEvent(FResultCode, FResultCodeExtended,
        FErrorLocus, FErrorResponse)
    else
      Logger.Debug('EventInterface = nil');

    Logger.Debug('TErrorEvent.Execute: OK');
  except
    on E: Exception do
      Logger.Error('TErrorEvent.Execute', E);
  end;
end;

function TErrorEvent.GetID: Integer;
begin
  Result := EVENT_ID_ERROR;
end;

{ TOutputCompleteEvent }

constructor TOutputCompleteEvent.Create(OutputID: Integer; ALogger: ILogFile);
begin
  inherited Create;
  FOutputID := OutputID;
  FLogger := ALogger;
end;

procedure TOutputCompleteEvent.Execute(
  EventInterface: IOposEvents);
begin
  Logger.Debug('TOutputCompleteEvent.Execute', [FOutputID]);
  try
    if EventInterface <> nil then
      EventInterface.OutputCompleteEvent(FOutputID)
    else
      Logger.Debug('EventInterface = nil');

    Logger.Debug('TOutputCompleteEvent.Execute: OK');
  except
    on E: Exception do
      Logger.Error('TOutputCompleteEvent.Execute', E);
  end;
end;

function TOutputCompleteEvent.GetID: Integer;
begin
  Result := EVENT_ID_OUTPUT;
end;

{ TStatusUpdateEvent }

constructor TStatusUpdateEvent.Create(Data: Integer; ALogger: ILogFile);
begin
  inherited Create;
  FData := Data;
  FLogger := ALogger;
end;

procedure TStatusUpdateEvent.Execute(
  EventInterface: IOposEvents);
begin
  try
    if EventInterface <> nil then
      EventInterface.StatusUpdateEvent(FData)
    else
      Logger.Debug('EventInterface = nil');
  except
    on E: Exception do
      Logger.Error('TStatusUpdateEvent.Execute', E);
  end;
end;

function TStatusUpdateEvent.GetID: Integer;
begin
  Result := EVENT_ID_STATUS;
end;

end.
