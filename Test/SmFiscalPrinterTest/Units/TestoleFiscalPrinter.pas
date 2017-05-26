unit TestoleFiscalPrinter;

interface

uses
  // VCL
  ComObj, ComServ,
  // This
  FiscalPrinterImpl, SharedPrinterInterface;

type
  { TTestoleFiscalPrinter }

  TTestoleFiscalPrinter = class(TFiscalPrinterImpl)
  private
    FPrinter: ISharedPrinter;
  protected
     function GetSharedPrinter(const DeviceName: string): ISharedPrinter; override;
  public
     constructor Create(APrinter: ISharedPrinter);
  end;

implementation

{ TTestoleFiscalPrinter }

constructor TTestoleFiscalPrinter.Create(APrinter: ISharedPrinter);
begin
  inherited Create;
  FPrinter := APrinter;
end;

function TTestoleFiscalPrinter.GetSharedPrinter(
  const DeviceName: string): ISharedPrinter;
begin
  Result := FPrinter;
end;

end.
