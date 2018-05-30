unit Semaphore;

interface

uses
  // VCL
  Windows, SysUtils;

type
  { TSemaphore }

  TSemaphore = class
  private
    FHandle: THandle;
  public
    destructor Destroy; override;

    procedure Close;
    procedure Release;
    procedure Open(const AName: WideString);
    function WaitFor(Timeout: Integer): Integer;
  end;

implementation

const
  SEMAPHORE_MODIFY_STATE = $0002;

{ TSemaphore }

destructor TSemaphore.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TSemaphore.Close;
begin
  if FHandle <> 0 then
  begin
    CloseHandle(FHandle);
    FHandle := 0;
  end;
end;

procedure TSemaphore.Open(const AName: WideString);
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

function TSemaphore.WaitFor(Timeout: Integer): Integer;
begin
  Result := WaitForSingleObject(FHandle, Timeout);
end;

procedure TSemaphore.Release;
begin
  if not ReleaseSemaphore(FHandle, 1, nil) then
    RaiseLastOSError;
end;

end.
