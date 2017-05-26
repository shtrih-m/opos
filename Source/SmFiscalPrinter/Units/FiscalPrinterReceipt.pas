unit FiscalPrinterReceipt;

interface

uses
  // This
  Opos, OposException;

type
  { TFiscalPrinterReceipt }

  TFiscalPrinterReceipt = class
  private
    FTotal: Int64;
    FIsOpened: Boolean;
    FIsCancelled: Boolean;
    FIsSaleReceipt: Boolean;
    FPayments: array [0..3] of Int64;

    procedure CheckPaymentCode(Code: Integer);
  public
    procedure Open;
    procedure Clear;
    procedure Cancel;
    function IsPaid: Boolean;
    function PaymentTotal: Int64;
    function CashlessTotal: Int64;
    procedure AddAmount(Amount: Int64);
    function GetPayment(Code: Integer): Int64;
    procedure Payment(Code: Integer; Value: Int64);


    property Total: Int64 read FTotal;
    property IsOpened: Boolean read FIsOpened;
    property IsCancelled: Boolean read FIsCancelled;
    property IsSaleReceipt: Boolean read FIsSaleReceipt;
  end;

implementation

{ TFiscalPrinterReceipt }

procedure TFiscalPrinterReceipt.Cancel;
begin
  FIsCancelled := True;
end;

procedure TFiscalPrinterReceipt.Clear;
begin
  FTotal := 0;
  FPayments[0] := 0;
  FPayments[1] := 0;
  FPayments[2] := 0;
  FPayments[3] := 0;
  FIsCancelled := False;
  FIsOpened := False;
  FIsSaleReceipt := False;
end;

function TFiscalPrinterReceipt.IsPaid: Boolean;
begin
  Result := PaymentTotal >= FTotal;
end;

procedure TFiscalPrinterReceipt.CheckPaymentCode(Code: Integer);
begin
  if not (Code in [0..3]) then
    raiseOposException(OPOS_E_ILLEGAL, 'Invalid payment code');
end;

procedure TFiscalPrinterReceipt.Payment(Code: Integer; Value: Int64);
begin
  CheckPaymentCode(Code);
  FPayments[Code] := FPayments[Code] + Value;
end;

function TFiscalPrinterReceipt.CashlessTotal: Int64;
begin
  Result := FPayments[1] + FPayments[2] + FPayments[3];
end;

function TFiscalPrinterReceipt.PaymentTotal: Int64;
begin
  Result := FPayments[0] + FPayments[1] + FPayments[2] + FPayments[3];
end;

procedure TFiscalPrinterReceipt.AddAmount(Amount: Int64);
begin
  FTotal := FTotal + Amount;
end;

function TFiscalPrinterReceipt.GetPayment(Code: Integer): Int64;
begin
  CheckPaymentCode(Code);
  Result := FPayments[Code];
end;

procedure TFiscalPrinterReceipt.Open;
begin
  FIsOpened := True;
end;

(*

  case 0x58: if (!ContinuePrint()) return FALSE;
  case 0x79:  TechInit();

   OPOS_EFPTR_COVER_OPEN                 = 201;
   OPOS_EFPTR_JRN_EMPTY                  = 202;
   OPOS_EFPTR_REC_EMPTY                  = 203;
   OPOS_EFPTR_SLP_EMPTY                  = 204;
   OPOS_EFPTR_SLP_FORM                   = 205;
   OPOS_EFPTR_MISSING_DEVICES            = 206;
   OPOS_EFPTR_WRONG_STATE                = 207;
   OPOS_EFPTR_TECHNICAL_ASSISTANCE       = 208;
   OPOS_EFPTR_CLOCK_ERROR                = 209;
   OPOS_EFPTR_FISCAL_MEMORY_FULL         = 210;
   OPOS_EFPTR_FISCAL_MEMORY_DISCONNECTED = 211;
   OPOS_EFPTR_FISCAL_TOTALS_ERROR        = 212;
   OPOS_EFPTR_BAD_ITEM_QUANTITY          = 213;
   OPOS_EFPTR_BAD_ITEM_AMOUNT            = 214;
   OPOS_EFPTR_BAD_ITEM_DESCRIPTION       = 215;
   OPOS_EFPTR_RECEIPT_TOTAL_OVERFLOW     = 216;
   OPOS_EFPTR_BAD_VAT                    = 217;
   OPOS_EFPTR_BAD_PRICE                  = 218;
   OPOS_EFPTR_BAD_DATE                   = 219;
   OPOS_EFPTR_NEGATIVE_TOTAL             = 220;
   OPOS_EFPTR_WORD_NOT_ALLOWED           = 221;
   OPOS_EFPTR_BAD_LENGTH                 = 222;
   OPOS_EFPTR_MISSING_SET_CURRENCY       = 223;
   OPOS_EFPTR_DAY_END_REQUIRED           = 224; // (added in 1.11)

*)

end.
