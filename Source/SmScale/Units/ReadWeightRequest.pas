unit ReadWeightRequest;

interface

uses
  // This
  ScaleRequest;

type
  { TReadWeightRequest }

  TReadWeightRequest = class
  private
    FTimeout: Integer;
  public
    constructor Create(ATimeout: Integer);
    property Timeout: Integer read FTimeout;
  end;

implementation

{ TReadWeightRequest }

constructor TReadWeightRequest.Create(ATimeout: Integer);
begin
  inherited Create;
  FTimeout := ATimeout;
end;

end.
