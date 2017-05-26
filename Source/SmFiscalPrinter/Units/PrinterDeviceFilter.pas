unit PrinterDeviceFilter;

interface

uses
  // VCL
  Classes, SysUtils,
  // This
  LogFile, PrinterTypes, FiscalPrinterTypes;

type
  { TFiscalPrinterFilter }

  TFiscalPrinterFilter = class
  private
    FLogger: TLogFile;
    FList: TInterfaceList;
    property Logger: TLogFile read FLogger;
  public
    procedure AddFilter(AFilter: IFiscalPrinterFilter);
    procedure RemoveFilter(AFilter: IFiscalPrinterFilter);
  public
    constructor Create(ALogger: TLogFile);
    destructor Destroy; override;

    procedure BeforeCashIn;
    procedure BeforeCashOut;
    procedure BeforeCloseReceipt;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure Sale(var Operation: TPriceReg);
    procedure Buy(var Operation: TPriceReg);
    procedure RetSale(var Operation: TPriceReg);
    procedure RetBuy(var Operation: TPriceReg);
    procedure Storno(var Operation: TPriceReg);
    procedure ReceiptDiscount(var Operation: TAmountOperation);
    procedure ReceiptCharge(var Operation: TAmountOperation);
    procedure OpenReceipt(var ReceiptType: Byte);
    procedure CloseReceipt(const P: TCloseReceiptParams; const R: TCloseReceiptResult);
    procedure CancelReceipt;
    procedure OpenDay;
    procedure PrintZReport;
  end;

implementation

{ TFiscalPrinterFilter }

constructor TFiscalPrinterFilter.Create(ALogger: TLogFile);
begin
  inherited Create;
  FList := TInterfaceList.Create;
  FLogger := ALogger;
end;

destructor TFiscalPrinterFilter.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TFiscalPrinterFilter.AddFilter(AFilter: IFiscalPrinterFilter);
begin
  FList.Add(AFilter);
end;

procedure TFiscalPrinterFilter.RemoveFilter(AFilter: IFiscalPrinterFilter);
begin
  FList.Remove(AFilter);
end;

procedure TFiscalPrinterFilter.CancelReceipt;
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).CancelReceipt;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.CloseReceipt(const P: TCloseReceiptParams;
  const R: TCloseReceiptResult);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).CloseReceipt(P, R);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.CashIn(Amount: Int64);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).CashIn(Amount);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.CashOut(Amount: Int64);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).CashOut(Amount);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.BeforeCashIn;
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).BeforeCashIn;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.BeforeCashOut;
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).BeforeCashOut;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.BeforeCloseReceipt;
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).BeforeCloseReceipt;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.Buy(var Operation: TPriceReg);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).Buy(Operation);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.OpenDay;
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).OpenDay;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.OpenReceipt(var ReceiptType: Byte);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).OpenReceipt(ReceiptType);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.PrintZReport;
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).PrintZReport;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.ReceiptCharge(
  var Operation: TAmountOperation);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).ReceiptCharge(Operation);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.ReceiptDiscount(
  var Operation: TAmountOperation);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).ReceiptDiscount(Operation);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.RetBuy(var Operation: TPriceReg);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).RetBuy(Operation);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.RetSale(var Operation: TPriceReg);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).RetSale(Operation);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.Sale(var Operation: TPriceReg);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).Sale(Operation);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFiscalPrinterFilter.Storno(var Operation: TPriceReg);
var
  i: Integer;
begin
  try
    for i := 0 to FList.Count-1 do
      IFiscalPrinterFilter(FList[i]).Storno(Operation);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

end.
