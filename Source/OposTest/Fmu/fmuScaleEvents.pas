unit fmuScaleEvents;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposScale, OposUtils, OposScalUtils;

type
  TfmScaleEvents = class(TPage)
    memEvents: TTntMemo;
    btnClear: TTntButton;
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure DirectIOEvent(Sender: TObject; EventNumber: Integer;
      var pData: Integer; var pString: WideString);
    procedure ErrorEvent(Sender: TObject; ResultCode: Integer;
      ResultCodeExtended: Integer; ErrorLocus: Integer; var pErrorResponse: Integer);
    procedure StatusUpdateEvent(Sender: TObject; Data: Integer);
    procedure DataEvent(ASender: TObject; Status: Integer);
  end;

implementation

{$R *.DFM}

procedure TfmScaleEvents.btnClearClick(Sender: TObject);
begin
  memEvents.Clear;
end;

// IOPOSScaleEvents

procedure TfmScaleEvents.FormCreate(Sender: TObject);
begin
  Scale.OnDataEvent := DataEvent;
  Scale.OnErrorEvent := ErrorEvent;
  Scale.OnDirectIOEvent := DirectIOEvent;
  Scale.OnStatusUpdateEvent := StatusUpdateEvent;
end;

procedure TfmScaleEvents.DataEvent(ASender: TObject; Status: Integer);
var
  S: string;
begin
  S := Tnt_WideFormat('DataEvent(Weight: %d)', [Status]);
  memEvents.Lines.Add(S);
end;

procedure TfmScaleEvents.DirectIOEvent(Sender: TObject; EventNumber: Integer;
  var pData: Integer; var pString: WideString);
var
  S: string;
begin
  S := Tnt_WideFormat('DirectIOEvent(%d, %d, %s)', [EventNumber, pData, pString]);
  memEvents.Lines.Add(S);
end;

procedure TfmScaleEvents.ErrorEvent(Sender: TObject; ResultCode,
  ResultCodeExtended, ErrorLocus: Integer; var pErrorResponse: Integer);
var
  S: string;
begin
  S := Tnt_WideFormat('ErrorEvent: %s, %s, %s, %s)', [
    GetResultCodeText(ResultCode),
    GetResultCodeExtendedText(ResultCodeExtended),
    GetErrorLocusText(ErrorLocus),
    GetErrorResponseText(pErrorResponse)]);
  memEvents.Lines.Add(S);
end;

procedure TfmScaleEvents.StatusUpdateEvent(Sender: TObject; Data: Integer);
var
  S: string;
begin
  S := Tnt_WideFormat('StatusUpdateEvent(%s)', [GetScaleStatusUpdateEventText(Data)]);
  memEvents.Lines.Add(S);
end;

end.
