unit FiscalPrinterEvents;

interface

Uses
  // VCL
  Windows, Classes, SyncObjs;

type
  TOposEvent = class;

(*
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer;
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function  SOProcessID: Integer; dispid 9;
*)
  { TOposEvents }

  TOposEvents = class
  private
    FList: TList;
    FEvent: TEvent;
    FLock: TCriticalSection;

    procedure Lock;
    procedure Unlock;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Wait;

    procedure Clear;
    procedure Add(Event: TOposEvent);
    function Remove(Index: Integer): TOposEvent;
  end;

  { TOposEvent }

  TOposEvent = class
  public
    procedure Execute(EventInterface: IDispatch); virtual; abstract;
  end;

  { TDataEvent }

  TDataEvent = class(TOposEvent)
  private
    FStatus: Integer;
  public
    constructor Create(AStatus: Integer);
    procedure Execute(EventInterface: IDispatch); override;
  end;

  { TDirectIOEvent }

  TDirectIOEvent = class(TOposEvent)
  private
    FEventNumber: Integer;
    FData: Integer;
    FString: WideString;
  public
    constructor Create(EventNumber: Integer;
      const pData: Integer;
      const pString: WideString);

    procedure Execute(EventInterface: IDispatch); override;
  end;

  { TErrorEvent }

  TErrorEvent = class(TOposEvent)
  private
    FResultCode: Integer;
    FResultCodeExtended: Integer;
    FErrorLocus: Integer;
    FErrorResponse: Integer;
  public
    constructor Create(ResultCode: Integer;
      ResultCodeExtended: Integer;
      ErrorLocus: Integer;
      var pErrorResponse: Integer);

    procedure Execute(EventInterface: IDispatch); override;
  end;

  { TOutputCompleteEvent }

  TOutputCompleteEvent = class(TOposEvent)
  private
    FOutputID: Integer;
  public
    constructor Create(OutputID: Integer);

    procedure Execute(EventInterface: IDispatch); override;
  end;

  { TStatusUpdateEvent }

  TStatusUpdateEvent = class(TOposEvent)
  private
    FData: Integer;
  public
    constructor Create(Data: Integer);

    procedure Execute(EventInterface: IDispatch); override;
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

{ TDataEvent }

constructor TDataEvent.Create(AStatus: Integer);
begin
  inherited Create;
  FStatus := AStatus;
end;

procedure TDataEvent.Execute(EventInterface: IDispatch);
begin
  if EventInterface <> nil then
  begin
    // Set up and call the SO's get property number method.
    //OposVariant Var, VarResult;
    //Var.SetLONG( nIndex );
    //DISPPARAMS Disp = { &Var, NULL, 1, 0 };

    OleCheck(EventInterface.Invoke(1, IID_NULL, LOCALE_USER_DEFAULT,
      DISPATCH_METHOD, &Disp, &VarResult, nil, nil));
  end;
end;

{ TDirectIOEvent }

constructor TDirectIOEvent.Create(EventNumber: Integer;
  const pData: Integer; const pString: WideString);
begin
  inherited Create;
  FEventNumber := EventNumber;
  FData := pData;
  FString := pString;
end;

procedure TDirectIOEvent.Execute(
  EventInterface: IDispatch);
begin
  if EventInterface <> nil then
    Variant(EventInterface).SODirectIO(FEventNumber, FData, FString);
end;

{ TErrorEvent }

constructor TErrorEvent.Create(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  inherited Create;
  FResultCode := ResultCode;
  FResultCodeExtended := ResultCodeExtended;
  FErrorLocus := ErrorLocus;
  FErrorResponse := pErrorResponse;
end;

procedure TErrorEvent.Execute(EventInterface: IDispatch);
begin
  if EventInterface <> nil then
    Variant(EventInterface).SOError(FResultCode, FResultCodeExtended,
    FErrorLocus, FErrorResponse);
end;

{ TOutputCompleteEvent }

constructor TOutputCompleteEvent.Create(OutputID: Integer);
begin
  inherited Create;
  FOutputID := OutputID;
end;

procedure TOutputCompleteEvent.Execute(
  EventInterface: IDispatch);
begin
  if EventInterface <> nil then
    Variant(EventInterface).SOOutputComplete(FOutputID);
end;

{ TStatusUpdateEvent }

constructor TStatusUpdateEvent.Create(Data: Integer);
begin
  inherited Create;
  FData := Data;
end;

procedure TStatusUpdateEvent.Execute(
  EventInterface: IDispatch);
begin
  if EventInterface <> nil then
    Variant(EventInterface).SOStatusUpdate(FData);
end;

end.
