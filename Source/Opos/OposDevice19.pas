unit OposDevice19;

interface

uses
  // VCL
  Windows, SysUtils,
  // Opos
  Opos, OposEvents, OposException,
  // This
  Semaphore, NotifyThread, LogFile;

type
  { TOposDevice19 }

  TOposDevice19 = class
  private
    FState: Integer;
    FOpened: Boolean;
    FClaimed: Boolean;
    FDeviceName: string;
    FDeviceClass: string;
    FDispatch: IDispatch;
    FSemaphore: TSemaphore;
    FAutoDisable: Boolean;
    FCapCompareFirmwareVersion: Boolean;
    FCapPowerReporting: Integer;
    FCapStatisticsReporting: Boolean;
    FCapUpdateFirmware: Boolean;
    FCapUpdateStatistics: Boolean;
    FCheckHealthText: string;
    FDataCount: Integer;
    FDataEventEnabled: Boolean;
    FDeviceEnabled: Boolean;
    FFreezeEvents: Boolean;
    FEvents: TOposEvents;
    FEventThread: TNotifyThread;
    FOutputID: Integer;
    FPowerNotify: Integer;
    FPowerState: Integer;

    procedure SetFreezeEvents(const Value: Boolean);

    property Dispatch: IDispatch read FDispatch;
    property Events: TOposEvents read FEvents;
    procedure SetDeviceEnabled(const Value: Boolean);
    procedure EventProc(Sender: TObject);
    procedure SetPowerState(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(const ADeviceClass, ADeviceName: string;
      const pDispatch: IDispatch);
    procedure Close;
    procedure Claim(Timeout: Integer);
    procedure Release;
    procedure BeginOutput;
    procedure EndOutput;

    procedure CheckOpened;
    procedure CheckClaimed;
    procedure CheckEnabled;

    procedure FireEvent(Event: TOposEvent);
    procedure DeliverEvent(Event: TOposEvent);
    procedure StatusUpdateEvent(Data: Integer);


    property State: Integer read FState;
    property Opened: Boolean read FOpened;
    property Claimed: Boolean read FClaimed;
    property DeviceName: string read FDeviceName;
    property DeviceClass: string read FDeviceClass;
    property AutoDisable: Boolean read FAutoDisable;
    property CapCompareFirmwareVersion: Boolean read FCapCompareFirmwareVersion;
    property CapPowerReporting: Integer read FCapPowerReporting;
    property CapStatisticsReporting: Boolean read FCapStatisticsReporting;
    property CapUpdateFirmware: Boolean read FCapUpdateFirmware;
    property CapUpdateStatistics: Boolean read FCapUpdateStatistics;
    property CheckHealthText: string read FCheckHealthText write FCheckHealthText;
    property DataCount: Integer read FDataCount;
    property DataEventEnabled: Boolean read FDataEventEnabled write FDataEventEnabled;
    property DeviceEnabled: Boolean read FDeviceEnabled write SetDeviceEnabled;
    property FreezeEvents: Boolean read FFreezeEvents write SetFreezeEvents;
    property OutputID: Integer read FOutputID;
    property PowerNotify: Integer read FPowerNotify write FPowerNotify;
    property PowerState: Integer read FPowerState write SetPowerState;
  end;

implementation

{ TOposDevice19 }

constructor TOposDevice19.Create;
begin
  inherited Create;
  FEvents := TOposEvents.Create;
  FSemaphore := TSemaphore.Create;

  FState := OPOS_S_CLOSED;
  FOpened := False;
  FClaimed := False;
  FDispatch := nil;
  FDeviceName := '';
  FDeviceClass := '';
  FAutoDisable := False;
  FDeviceEnabled := False;
  FCapCompareFirmwareVersion := False;
  FCapPowerReporting := OPOS_PR_STANDARD;
  FCapStatisticsReporting := True;
  FCapUpdateFirmware := False;
  FCapUpdateStatistics := True;
  SetFreezeEvents(False);
  FPowerNotify := OPOS_PN_DISABLED;
  FPowerState := OPOS_PS_UNKNOWN;
end;

destructor TOposDevice19.Destroy;
begin
  FEvents.Free;
  FSemaphore.Free;
  inherited Destroy;
end;

procedure TOposDevice19.Open(const ADeviceClass, ADeviceName: string;
  const pDispatch: IDispatch);
begin
  if FOpened then
    RaiseOposException(OPOS_OR_ALREADYOPEN);

  FDeviceClass := ADeviceClass;
  FDeviceName := ADeviceName;
  FDispatch := pDispatch;
  // State is changed to S_IDLE when the open method is successfully called.
  FState := OPOS_S_IDLE;

  FOpened := True;
end;

procedure TOposDevice19.Close;
begin
  CheckOpened;
  FOpened := False;
  FState := OPOS_S_CLOSED;
end;

procedure TOposDevice19.Claim(Timeout: Integer);
begin
  FSemaphore.Open(FDeviceName);
  case FSemaphore.WaitFor(Timeout) of
    WAIT_OBJECT_0:;
    WAIT_TIMEOUT: RaiseOposException(OPOS_E_TIMEOUT);
  else
    RaiseLastOSError;
  end;
end;

procedure TOposDevice19.Release;
begin
  CheckClaimed;
  FSemaphore.Release;
  FSemaphore.Close;
end;

procedure TOposDevice19.CheckOpened;
begin
  if not FOpened then
    RaiseOposException(OPOS_E_CLOSED);
end;

procedure TOposDevice19.CheckClaimed;
begin
  CheckOpened;
  if not FClaimed then
    RaiseOposException(OPOS_E_NOTCLAIMED);
end;

// State is set to S_BUSY when the Service is processing output.
// The State is restored to S_IDLE when the output has completed

procedure TOposDevice19.BeginOutput;
begin
  FState := OPOS_S_BUSY;
end;

procedure TOposDevice19.EndOutput;
begin
  FState := OPOS_S_IDLE;
end;

(*

The State is changed to S_ERROR when an asynchronous output encounters
an error condition, or when an error is encountered during the gathering
or processing of event-driven input.

After the Service changes the State property to S_ERROR, it notifies the
application of this error. The properties of this event are the error code and
extended error code, the locus of the error, and a modifiable response to the
error

*)

procedure TOposDevice19.CheckEnabled;
begin
  if not DeviceEnabled then
    RaiseOposException(OPOS_E_DISABLED, 'Device is disabled');
end;

procedure TOposDevice19.SetFreezeEvents(const Value: Boolean);
var
  Event: TOposEvent;
begin
  if Value <> FreezeEvents then
  begin
    if not Value then
    begin
      repeat
        Event := FEvents.Remove(0);
        if Event <> nil then
        begin
          Event.Execute(FDispatch);
          Event.Free;
        end;
      until Event = nil;
    end;
    FFreezeEvents := Value;
  end;
end;

procedure TOposDevice19.DeliverEvent(Event: TOposEvent);
begin
  Event.Execute(FDispatch);
end;

procedure TOposDevice19.FireEvent(Event: TOposEvent);
begin
  if FFreezeEvents then
  begin
    // enqueue event
    Events.Add(Event);
  end else
  begin
    DeliverEvent(Event);
    Event.Free;
  end;
end;

// Execute events from queue
procedure TOposDevice19.EventProc(Sender: TObject);
var
  Event: TOposEvent;
begin
  try
    while not FEventThread.Terminated do
    begin
      if FreezeEvents then
      begin
        Sleep(100);
        Continue;
      end;
      Event := FEvents.Remove(0);
      if Event = nil then
      begin
        Sleep(100);
        Continue;
      end;
      Event.Execute(FDispatch);
      Event.Free;
    end;
  except
    on E: Exception do
      Logger.Error('EventProc: ', E);
  end;

end;

procedure TOposDevice19.SetDeviceEnabled(const Value: Boolean);
begin
  if Value <> DeviceEnabled then
  begin
    if Value then
    begin
      FEventThread := TNotifyThread.Create(True);
      FEventThread.OnExecute := EventProc;
      FEventThread.Resume;
    end else
    begin
      FEventThread.Free;
      FEventThread := nil;
    end;
    FDeviceEnabled := Value;
  end;
end;

procedure TOposDevice19.StatusUpdateEvent(Data: Integer);
begin
  FireEvent(TStatusUpdateEvent.Create(Data));
end;

procedure TOposDevice19.SetPowerState(const Value: Integer);
begin
  if FPowerNotify = OPOS_PN_ENABLED then
  begin
    if Value <> PowerState then
    begin
      case Value of
        OPOS_PS_ONLINE       : StatusUpdateEvent(OPOS_SUE_POWER_ONLINE);
        OPOS_PS_OFF          : StatusUpdateEvent(OPOS_SUE_POWER_OFF);
        OPOS_PS_OFFLINE      : StatusUpdateEvent(OPOS_SUE_POWER_OFFLINE);
        OPOS_PS_OFF_OFFLINE  : StatusUpdateEvent(OPOS_SUE_POWER_OFF_OFFLINE);
      end;
      FPowerState := Value;
    end;
  end;
end;


end.
