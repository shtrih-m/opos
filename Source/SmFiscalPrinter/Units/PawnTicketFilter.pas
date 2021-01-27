unit PawnTicketFilter;

interface

uses
  // VCL
  SysUtils,
  // This
  FptrFilter, FiscalPrinterTypes, NonfiscalDoc, LogFile, PrinterParameters,
  MalinaParams;

type
  { TPawnTicketFilter }

  TPawnTicketFilter = class(TFptrFilter)
  private
    FDocCount: Integer;
    FPrinter: ISharedPrinter;
    function IsPawnTicket(Doc: TNonfiscalDoc): Boolean;
    function GetParams: TMalinaParams;
    function GetLogger: ILogFile;
  public
    constructor Create(AOwner: TFptrFilters; APrinter: ISharedPrinter);
    destructor Destroy; override;

    procedure BeginFiscalReceipt; override;
    procedure EndNonFiscal(Doc: TNonfiscalDoc); override;

    property Logger: ILogFile read GetLogger;
    property Params: TMalinaParams read GetParams;
  end;

implementation

{ TPawnTicketFilter }

constructor TPawnTicketFilter.Create(AOwner: TFptrFilters;
  APrinter: ISharedPrinter);
begin
  inherited Create(AOwner);
  FPrinter := APrinter;
end;

destructor TPawnTicketFilter.Destroy;
begin
  FPrinter := nil;
  inherited Destroy;
end;

procedure TPawnTicketFilter.BeginFiscalReceipt;
begin
  FDocCount := 0;
end;

function TPawnTicketFilter.IsPawnTicket(Doc: TNonfiscalDoc): Boolean;
begin
  Result := Pos(Params.PawnTicketText, Doc.Text) <> 0;
end;

procedure TPawnTicketFilter.EndNonFiscal(Doc: TNonfiscalDoc);
begin
  if not IsPawnTicket(Doc) then
  begin
    FDocCount := 0;
    Exit;
  end;

  case Params.PawnTicketMode of
    PawnTicketModeNone:
    begin
      Doc.Cancelled := True;
    end;
    PawnTicketModeFirst:
      if FDocCount > 0 then
        Doc.Cancelled := True;
  end;
  if Doc.Cancelled then
  begin
    Logger.Debug('TPawnTicketFilter.EndNonFiscal: cancelled document');
  end;
  Inc(FDocCount);
end;

function TPawnTicketFilter.GetParams: TMalinaParams;
begin
  Result := FPrinter.Device.Context.MalinaParams;
end;

function TPawnTicketFilter.GetLogger: ILogFile;
begin
  Result := FPrinter.Device.Context.Logger;
end;

end.
