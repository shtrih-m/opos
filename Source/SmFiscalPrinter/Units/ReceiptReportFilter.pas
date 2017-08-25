unit ReceiptReportFilter;

interface

uses
  // VCL
  SysUtils,
  // This
  FiscalPrinterTypes, PrinterTypes, PrinterParameters,
  OmniXmlUtils, XmlReceiptWriter;

type
  { TReceiptReportFilter }

  TReceiptReportFilter = class(TInterfacedObject, IFiscalPrinterFilter)
  private
    FReceipt: TReceiptRec;
    FParams: TPrinterParameters;
    FPrinter: IFiscalPrinterDevice;
    function ReadReg(RegID: Integer): Integer;
    procedure AddReceipt(const Receipt: TReceiptRec);
    procedure ReadReceiptDate;
  public
    constructor Create(APrinter: IFiscalPrinterDevice; const AParams: TPrinterParameters);

    procedure BeforeCashIn;
    procedure BeforeCashOut;
    procedure BeforeCloseReceipt;
    procedure CancelReceipt;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure CloseReceipt(const P: TCloseReceiptParams; const R: TCloseReceiptResult);
    procedure Sale(var Operation: TPriceReg);
    procedure Buy(var Operation: TPriceReg);
    procedure RetSale(var Operation: TPriceReg);
    procedure RetBuy(var Operation: TPriceReg);
    procedure Storno(var Operation: TPriceReg);
    procedure ReceiptDiscount(var Operation: TAmountOperation);
    procedure ReceiptCharge(var Operation: TAmountOperation);
    procedure OpenReceipt(var ReceiptType: Byte);
    procedure OpenDay;
    procedure PrintZReport;
  end;

implementation

{ TReceiptReportFilter }

constructor TReceiptReportFilter.Create(APrinter: IFiscalPrinterDevice;
  const AParams: TPrinterParameters);
begin
  inherited Create;
  FPrinter := APrinter;
  FParams := AParams;
end;

procedure TReceiptReportFilter.AddReceipt(const Receipt: TReceiptRec);
begin
  TXmlReceiptWriter.AddReceipt(Receipt, FParams.ReceiptReportFileName);
end;

procedure TReceiptReportFilter.CancelReceipt;
begin
end;

procedure TReceiptReportFilter.CloseReceipt(const P: TCloseReceiptParams;
  const R: TCloseReceiptResult);
var
  Amount: Int64;
begin
  Amount := P.CashAmount + P.Amount2 + P.Amount3 + P.Amount4 - R.Change;
  FReceipt.State := 0;
  FReceipt.Amount := Amount;
  FReceipt.Payments[0] := P.CashAmount;
  FReceipt.Payments[1] := P.Amount2;
  FReceipt.Payments[2] := P.Amount3;
  FReceipt.Payments[3] := P.Amount4;
  AddReceipt(FReceipt);
end;

procedure TReceiptReportFilter.CashIn(Amount: Int64);
begin
  FReceipt.State := 0;
  FReceipt.Amount := Amount;
  FReceipt.Payments[0] := 0;
  FReceipt.Payments[1] := 0;
  FReceipt.Payments[2] := 0;
  FReceipt.Payments[3] := 0;
  AddReceipt(FReceipt);
end;

procedure TReceiptReportFilter.CashOut(Amount: Int64);
begin
  FReceipt.State := 0;
  FReceipt.Amount := Amount;
  FReceipt.Payments[0] := 0;
  FReceipt.Payments[1] := 0;
  FReceipt.Payments[2] := 0;
  FReceipt.Payments[3] := 0;
  AddReceipt(FReceipt);
end;

function TReceiptReportFilter.ReadReg(RegID: Integer): Integer;
begin
  Result := (FPrinter.ReadOperatingRegister(RegID) + 1) mod 9999;
end;

procedure TReceiptReportFilter.ReadReceiptDate;
var
  Status: TLongPrinterStatus;
begin
  Status := FPrinter.ReadLongStatus;
  FReceipt.DocID := (Status.DocumentNumber + 1) mod 9999;
  FReceipt.Date := Status.Date;
  FReceipt.Time := Status.Time;
end;

procedure TReceiptReportFilter.BeforeCashIn;
begin
  ReadReceiptDate;
  FReceipt.ID := ReadReg($9B);
  FReceipt.RecType := XML_RT_CASH_IN;
end;

procedure TReceiptReportFilter.BeforeCashOut;
begin
  ReadReceiptDate;
  FReceipt.ID := ReadReg($9C);
  FReceipt.RecType := XML_RT_CASH_OUT;
end;

procedure TReceiptReportFilter.BeforeCloseReceipt;
var
  Mode: Integer;
begin
  Mode := FPrinter.ReadPrinterStatus.Mode;
  case Mode of
    ECRMODE_RECSELL		 : FReceipt.RecType := XML_RT_SALE;
    ECRMODE_RECBUY		 : FReceipt.RecType := XML_RT_BUY;
    ECRMODE_RECRETSELL : FReceipt.RecType := XML_RT_RETSALE;
    ECRMODE_RECRETBUY	 : FReceipt.RecType := XML_RT_RETBUY;
  else
    Exit;
  end;
  case Mode of
    ECRMODE_RECSELL		 : FReceipt.ID := ReadReg($94);
    ECRMODE_RECBUY		 : FReceipt.ID := ReadReg($95);
    ECRMODE_RECRETSELL : FReceipt.ID := ReadReg($96);
    ECRMODE_RECRETBUY	 : FReceipt.ID := ReadReg($97);
  else
    Exit;
  end;
  ReadReceiptDate;
end;

procedure TReceiptReportFilter.Buy(var Operation: TPriceReg);
begin

end;

procedure TReceiptReportFilter.OpenReceipt(var ReceiptType: Byte);
begin

end;

procedure TReceiptReportFilter.ReceiptCharge(
  var Operation: TAmountOperation);
begin

end;

procedure TReceiptReportFilter.ReceiptDiscount(
  var Operation: TAmountOperation);
begin

end;

procedure TReceiptReportFilter.RetBuy(var Operation: TPriceReg);
begin

end;

procedure TReceiptReportFilter.RetSale(var Operation: TPriceReg);
begin

end;

procedure TReceiptReportFilter.Sale(var Operation: TPriceReg);
begin

end;

procedure TReceiptReportFilter.Storno(var Operation: TPriceReg);
begin

end;

procedure TReceiptReportFilter.OpenDay;
begin

end;

procedure TReceiptReportFilter.PrintZReport;
begin

end;

end.
