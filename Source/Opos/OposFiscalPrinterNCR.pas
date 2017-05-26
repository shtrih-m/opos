unit OposFiscalPrinterNCR;

interface

uses
  // This
  OposEvents;

type
  { TOposEventsNull }

  TOposFiscalPrinterNCR = class(TInterfacedObject, IOposEvents)
  public
    constructor Create(ADispatch: IDispatch);

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

{ TOposFiscalPrinterNCR }

constructor TOposFiscalPrinterNCR.Create(ADispatch: IDispatch);
begin

end;

procedure TOposFiscalPrinterNCR.DataEvent(Status: Integer);
begin

end;

procedure TOposFiscalPrinterNCR.DirectIOEvent(EventNumber: Integer;
  var pData: Integer; var pString: WideString);
begin

end;

procedure TOposFiscalPrinterNCR.ErrorEvent(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer; var pErrorResponse: Integer);
begin

end;

procedure TOposFiscalPrinterNCR.OutputCompleteEvent(OutputID: Integer);
begin

end;

procedure TOposFiscalPrinterNCR.StatusUpdateEvent(Data: Integer);
begin

end;

end.
