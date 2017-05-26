unit RCSEvents;

interface

uses
  // VCL
  Windows, ActiveX, ComObj,
  // This
  RCSEvents_TLB, OposEvents, FileUtils;

type
  { TRCSEvents }

  TRCSEvents = class(TAutoIntfObject, IRCSEvents)
  private
    FEvents: IOposEvents;
  public
    constructor Create(AEvents: IOposEvents);
    destructor Destroy; override;

    procedure SOData(Status: Integer); safecall;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); safecall;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer;
                      var pErrorResponse: Integer); safecall;
    procedure SOOutputCompleteDummy(OutputID: Integer); safecall;
    procedure SOStatusUpdate(Data: Integer); safecall;
    function SOProcessID: Integer; safecall;

  end;

implementation

{$R *.TLB}

{ TRCSEvents }

constructor TRCSEvents.Create(AEvents: IOposEvents);
var
  TypeLib: ITypeLib;
begin
  OleCheck(LoadTypeLib(PWideChar(WideString(GetModuleFileName)), TypeLib));
  inherited Create(TypeLib, IRCSEvents);
  FEvents := AEvents;
end;

destructor TRCSEvents.Destroy;
begin
  FEvents := nil;
  inherited Destroy;
end;

procedure TRCSEvents.SOData(Status: Integer);
begin
  FEvents.DataEvent(Status);
end;

procedure TRCSEvents.SODirectIO(EventNumber: Integer; var pData: Integer;
  var pString: WideString);
begin
  FEvents.DirectIOEvent(EventNumber, pData, pString);
end;

procedure TRCSEvents.SOError(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  FEvents.ErrorEvent(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

procedure TRCSEvents.SOOutputCompleteDummy(OutputID: Integer);
begin
  FEvents.OutputCompleteEvent(OutputID);
end;

procedure TRCSEvents.SOStatusUpdate(Data: Integer);
begin
  FEvents.StatusUpdateEvent(Data);
end;

function TRCSEvents.SOProcessID: Integer;
begin
  Result := GetCurrentProcessID;
end;

end.
