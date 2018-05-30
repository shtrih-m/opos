unit OposSemaphore;

interface

uses
  // VCL
  Windows, SysUtils,
  // Opos
  Opos, OposException;

type
  { TOposSemaphore }

  TOposSemaphore = class
  private
    FHandle: THandle;
    FClaimed: Boolean;

    procedure Close;
    procedure Open(const AName: WideString);
    function WaitFor(Timeout: Integer): Integer;
  public
    destructor Destroy; override;

    procedure Release;
    procedure Claim(const Name: WideString; Timeout: Integer);
  end;

implementation

const
  SEMAPHORE_MODIFY_STATE = $0002;

{ TOposSemaphore }

destructor TOposSemaphore.Destroy;
begin
  Release;
  Close;
  inherited Destroy;
end;

procedure TOposSemaphore.Close;
begin
  if FHandle <> 0 then
  begin
    CloseHandle(FHandle);
    FHandle := 0;
  end;
end;

procedure TOposSemaphore.Open(const AName: WideString);
begin
  if FHandle = 0 then
  begin
    FHandle := CreateSemaphoreW(nil, 1, 1, PWideChar(AName));
    if FHandle = 0 then
    begin
      if GetLastError = ERROR_ALREADY_EXISTS then
      begin
        FHandle := OpenSemaphoreW(SEMAPHORE_MODIFY_STATE, False, PWideChar(AName));
        if FHandle = 0 then
          RaiseLastOsError;
      end;
    end;
  end;
end;

function TOposSemaphore.WaitFor(Timeout: Integer): Integer;
begin
  Result := WaitForSingleObject(FHandle, Timeout);
end;

procedure TOposSemaphore.Release;
begin
  if FClaimed then
  begin
    ReleaseSemaphore(FHandle, 1, nil);
    FClaimed := False;
  end;
end;

procedure TOposSemaphore.Claim(const Name: WideString; Timeout: Integer);
begin
  if FClaimed then Exit;

  Open(Name);
  case WaitFor(Timeout) of
    WAIT_OBJECT_0:;
    WAIT_TIMEOUT: RaiseOposException(OPOS_E_TIMEOUT);
  else
    RaiseLastOSError;
  end;
  FClaimed := True;
end;

end.
