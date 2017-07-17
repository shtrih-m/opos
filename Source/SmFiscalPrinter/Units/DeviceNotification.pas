unit DeviceNotification;

interface

uses
  // VCL
  SysUtils, Windows, Classes, Messages,
  // JVCL
  DBT,
  // This
  LogFile;

type
  TIntNotifyEvent = procedure (Sender: TObject; dbt: Integer) of object;

  { TDeviceNotification }

  TDeviceNotification = class
  private
    FWnd: HWND;
    FNotification: HDEVNOTIFY;
    FDev: DEV_BROADCAST_HANDLE;
    FOnDeviceChange: TIntNotifyEvent;
    FLogger: ILogFile;

    procedure WndProc(var Msg: TMessage);
    property Logger: ILogFile read FLogger;
  public
    constructor Create(ALogger: ILogFile);
    destructor Destroy; override;

    procedure Uninstall;
    procedure Install(Handle: THandle);
    property OnDeviceChange: TIntNotifyEvent read FOnDeviceChange write FOnDeviceChange;
  end;

implementation

destructor TDeviceNotification.Destroy;
begin
  Uninstall;
  Classes.DeallocateHWND(FWnd);
  inherited Destroy;
end;

procedure TDeviceNotification.WndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DEVICECHANGE then
  begin
    if Assigned(FOnDeviceChange) then
      FOnDeviceChange(Self, Msg.WParam);
  end else
  begin
    DefWindowProc(FWnd, Msg.Msg, Msg.wParam, Msg.lParam);
  end;
end;

procedure TDeviceNotification.Install(Handle: THandle);
var
  LastError: Integer;
begin
  ZeroMemory(@FDev, SizeOf(FDev));
  FDev.dbch_size := sizeof(FDev);
  FDev.dbch_devicetype := DBT_DEVTYP_HANDLE;
  FDev.dbch_handle := Handle;

  FNotification := RegisterDeviceNotification(FWnd, @FDev, DEVICE_NOTIFY_WINDOW_HANDLE);
  if not Assigned(FNotification) then
  begin
    LastError := GetLastError;
    Logger.Error(Format('Device Notification not assigned: %d, %s', [LastError, SysErrorMessage(LastError)]));
  end;
end;

procedure TDeviceNotification.Uninstall;
begin
  if FNotification <> nil then
  begin
    UnregisterDeviceNotification(FNotification);
    FNotification := nil;
  end;
end;

constructor TDeviceNotification.Create(ALogger: ILogFile);
begin
  inherited Create;
  FWnd := Classes.AllocateHWND(WndProc);
  FLogger := ALogger;
end;

end.
