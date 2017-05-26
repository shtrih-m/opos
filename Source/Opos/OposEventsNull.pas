unit OposEventsNull;

interface

uses
  // This
  OposEvents;

type
  { TOposEventsNull }

  TOposEventsNull = class(TInterfacedObject, IOposEvents)
  public
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

{ TOposEventsNull }

procedure TOposEventsNull.DataEvent(Status: Integer);
begin

end;

procedure TOposEventsNull.DirectIOEvent(EventNumber: Integer;
  var pData: Integer; var pString: WideString);
begin

end;

procedure TOposEventsNull.ErrorEvent(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer; var pErrorResponse: Integer);
begin

end;

procedure TOposEventsNull.OutputCompleteEvent(OutputID: Integer);
begin

end;

procedure TOposEventsNull.StatusUpdateEvent(Data: Integer);
begin

end;

end.
