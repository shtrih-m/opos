unit NotifyThread;

interface

uses
  // VCL
  Windows, Classes, SyncObjs;

type
  { TNotifyThread }

  TNotifyThread = class(TThread)
  private
    FOnExecute: TNotifyEvent;
  public
    procedure Execute; override;
    procedure Sleep(Timeout: Integer);
  published
    property Terminated;
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
  end;

implementation


{ TNotifyThread }

procedure TNotifyThread.Execute;
begin
  if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

procedure TNotifyThread.Sleep(Timeout: Integer);
var
  TickCount: Integer;
begin
  if Timeout <= 0 then Exit;
  TickCount := Integer(GetTickCount) + Timeout;
  repeat
    if Terminated then Break;
    Windows.Sleep(10);
  until Integer(GetTickCount) > TickCount;
end;

end.
