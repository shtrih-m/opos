unit untTimer;

interface

uses
  // VCL
  Windows, Messages, Classes, Consts, SyncObjs, SysUtils, Forms,
  // This
  untTypes;

const
  WM_CREATETIMER = WM_USER + 1;
  WM_DELETETIMER = WM_USER + 2;

type
  TTimer = class;

  { TTimers }

  TTimers = class
  private
    FList: TList;
    FWindowHandle: HWND;
    FCS: TCriticalSection;
    procedure Lock;
    procedure Unlock;
    function GetCount: Integer;
    procedure Insert(AItem: TTimer);
    procedure Remove(AItem: TTimer);
    procedure WndProc(var Msg: TMessage);
	  procedure DoCreateTimer(ID: Integer);
	  procedure DoDeleteTimer(ID: Integer);
    function GetItem(Index: Integer): TTimer;
  public
    constructor Create;
    destructor Destroy; override;
    function ItemByID(ID: Integer): TTimer;
    function ItemByTimerID(TimerID: Integer): TTimer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTimer read GetItem; default;
  end;

  { TTimer }

  TTimer = class
  private
    FID: Integer;
    FTimerID: Integer;
    FEnabled: Boolean;
    FInterval: Cardinal;
    FOnTimer: TNotifyEvent;
    procedure UpdateTimer;
    procedure CreateTimer;
    procedure DeleteTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
  protected
    procedure Timer; dynamic;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;

implementation

var
  Timers: TTimers;

procedure TimerProc(Wnd: HWnd; Msg, TimerID, SysTime: Longint); stdcall;
var
  Timer: TTimer;
begin
  Timer := Timers.ItemByTimerID(TimerID);
  if Timer <> nil then Timer.Timer;
end;

{ TTimers }

constructor TTimers.Create;
begin
  inherited Create;
  FCS := TCriticalSection.Create;
  FWindowHandle := AllocateHWnd(WndProc);
end;

destructor TTimers.Destroy;
begin
  FCS.Free;
  DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TTimers.DoCreateTimer(ID: Integer);
var
  Timer: TTimer;
begin
  Lock;
  try
    Timer := ItemByID(ID);
    if Timer <> nil then
      Timer.CreateTimer;
  finally
    Unlock;
  end;
end;

procedure TTimers.DoDeleteTimer(ID: Integer);
var
  Timer: TTimer;
begin
  Lock;
  try
    Timer := ItemByID(ID);
    if Timer <> nil then
      Timer.DeleteTimer;
  finally
    Unlock;
  end;
end;

procedure TTimers.WndProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_CREATETIMER: DoCreateTimer(Msg.wParam);
    WM_DELETETIMER: DoDeleteTimer(Msg.wParam);
  else
    Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.wParam, Msg.lParam);
  end;
end;

procedure TTimers.Lock;
begin
  FCS.Enter;
end;

procedure TTimers.Unlock;
begin
  FCS.Leave;
end;

function TTimers.GetCount: Integer;
begin
  if FList = nil then
    Result := 0
  else
    Result := FList.Count;
end;

function TTimers.GetItem(Index: Integer): TTimer;
begin
  Result := FList[Index];
end;

procedure TTimers.Insert(AItem: TTimer);
begin
  Lock;
  try
    if FList = nil then FList := TList.Create;
    FList.Add(AItem);
  finally
    Unlock;
  end;
end;

procedure TTimers.Remove(AItem: TTimer);
begin
  Lock;
  try
    FList.Remove(AItem);
    if FList.Count = 0 then
    begin
      FList.Free;
      FList := nil;
    end;
  finally
    Unlock;
  end;
end;

function TTimers.ItemByID(ID: Integer): TTimer;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.FID = ID then Exit;
  end;
  Result := nil;
end;

function TTimers.ItemByTimerID(TimerID: Integer): TTimer;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.FTimerID = TimerID then Exit;
  end;
  Result := nil;
end;

{ TTimer }

constructor TTimer.Create;
const
  LastID: Integer = 0;
begin
  inherited Create;
  FInterval := 1000;
  Timers.Insert(Self);
  Inc(LastID); FID := LastID;
end;

destructor TTimer.Destroy;
begin
  Timers.Remove(Self);
  FEnabled := False;
  UpdateTimer;
  inherited Destroy;
end;

procedure TTimer.CreateTimer;
begin
  FTimerID := SetTimer(Timers.FWindowHandle, FID, FInterval, @TimerProc);
end;

procedure TTimer.DeleteTimer;
begin
  KillTimer(Timers.FWindowHandle, FID);
  FTimerID := 0;
end;

procedure TTimer.UpdateTimer;
var
  NeedToCreate: Boolean;
begin
  NeedToCreate := (FInterval <> 0) and FEnabled and Assigned(FOnTimer);
  if NeedToCreate then
  begin
    repeat
    until PostMessage(Timers.FWindowHandle, WM_CREATETIMER, FID, 0);
  end else
  begin
    if FTimerID <> 0 then
    begin
      repeat
      until PostMessage(Timers.FWindowHandle, WM_DELETETIMER, FID, 0);
    end;
  end;
end;

procedure TTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TTimer.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure TTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;

initialization
  Timers := TTimers.Create;

finalization
  Timers.Free;

end.
