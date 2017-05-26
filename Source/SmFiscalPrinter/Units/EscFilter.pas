unit EscFilter;

interface

uses
  // VCL
  Windows,
  // This
  EscPrinter, FiscalPrinterTypes;

type
  { TEscFilter }

  TEscFilter = class
  private
    FEscPrinter: TEscPrinter;
    property EscPrinter: TEscPrinter read FEscPrinter;
  public
    Enabled: Boolean;
    constructor Create(APrinter: ISharedPrinter);
    destructor Destroy; override;

    procedure PrintText(var AText: WideString);
    procedure PrintHeaderText(var AText: WideString);
  end;

implementation

{ TEscFilter }

constructor TEscFilter.Create(APrinter: ISharedPrinter);
begin
  inherited Create;
  FEscPrinter := TEscPrinter.Create(APrinter);
end;

destructor TEscFilter.Destroy;
begin
  FEscPrinter.Free;
  inherited Destroy;
end;

procedure TEscFilter.PrintHeaderText(var AText: WideString);
begin
  if not Enabled then Exit;
  EscPrinter.IsHeaderLine := True;
  EscPrinter.Execute(AText);
end;

procedure TEscFilter.PrintText(var AText: WideString);
begin
  if not Enabled then Exit;
  EscPrinter.IsHeaderLine := False;
  EscPrinter.Execute(AText);
end;

end.
