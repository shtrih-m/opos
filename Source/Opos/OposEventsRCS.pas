unit OposEventsRCS;

interface

uses
  // VCL
  Variants,
  // This
  LogFile, OposEvents, DebugUtils;

type
  { TOposEventsRCS }

  TOposEventsRCS = class(TInterfacedObject, IOposEvents)
  private
    FDispatch: OleVariant;
    function Enabled: Boolean;
  public
    constructor Create(ADispatch: IDispatch);
    destructor Destroy; override;

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

implementation

{ TOposEventsRCS }

constructor TOposEventsRCS.Create(ADispatch: IDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
end;

destructor TOposEventsRCS.Destroy;
begin
  VarClear(FDispatch);
  inherited Destroy;
end;

function TOposEventsRCS.Enabled: Boolean;
begin
  Result := IUnknown(FDispatch) <> nil;
end;

procedure TOposEventsRCS.DataEvent(Status: Integer);
begin
  if Enabled then
    FDispatch.SOData(Status);
end;

procedure TOposEventsRCS.DirectIOEvent(EventNumber: Integer;
  var pData: Integer; var pString: WideString);
begin
  if Enabled then
    FDispatch.SODirectIO(EventNumber, pData, pString);
end;

procedure TOposEventsRCS.ErrorEvent(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  if Enabled then
    FDispatch.SOError(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

procedure TOposEventsRCS.OutputCompleteEvent(OutputID: Integer);
begin
  if Enabled then
    FDispatch.SOOutputComplete(OutputID);
end;

procedure TOposEventsRCS.StatusUpdateEvent(Data: Integer);
begin
  if Enabled then
    FDispatch.SOStatusUpdate(Data);
end;

end.
