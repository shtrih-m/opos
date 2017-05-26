unit QueueThread;

interface

uses
  // VCL
  Windows, Classes, SyncObjs;

type
  { TQueueThread }

  TQueueThread = class(TThread)
  private
    FEvent: TEvent;
    FOnExecute: TNotifyEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  published
    procedure WakeUp;
    property Terminated;
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
  end;

implementation

{ TQueueThread }

constructor TQueueThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FEvent := TEvent.Create(nil, False, False,'');
end;

destructor TQueueThread.Destroy;
begin
  Terminate;
  WakeUp;
  inherited Destroy;
  FEvent.Free;
end;

procedure TQueueThread.Execute;
begin
  while not Terminated do
  begin
    FEvent.WaitFor(INFINITE);
    if Terminated then Exit;

    if Assigned(FOnExecute) then
      FOnExecute(Self);
  end;
end;

procedure TQueueThread.WakeUp;
begin
  FEvent.SetEvent;
end;

end.
