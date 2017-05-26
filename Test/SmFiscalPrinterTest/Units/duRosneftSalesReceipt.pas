unit duRosneftSalesReceipt;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  RosneftSalesReceipt, RegExpr, MalinaParams, CustomReceipt;

type
  { TCommandDefsTest }

  TRosneftSalesReceiptTest = class(TTestCase)
  published
    procedure IsLoyaltyCard;
    procedure TestRegExpr;
  end;

implementation


{ TRosneftSalesReceiptTest }

procedure TRosneftSalesReceiptTest.IsLoyaltyCard;
var
  Context: TReceiptContext;
  Receipt: TRosneftSalesReceipt;
begin
  Receipt := TRosneftSalesReceipt.CreateReceipt(Context, 0);
  try
    CheckEquals(True, Receipt.IsLoyaltyCard('3% Loyalty 000302992000000040'));
    CheckEquals(False, Receipt.IsLoyaltyCard('3% Loyalty 000302912000000040'));
    CheckEquals(False, Receipt.IsLoyaltyCard('3% Loyalty 000302192000000040'));
  finally
    Receipt.Free;
  end;
end;

procedure TRosneftSalesReceiptTest.TestRegExpr;
var
  S: string;
const
  Card1 = '3% Loyalty 000302992000000040';
  ReplaceStr = ' ¿–“¿  ŒÃ¿Õƒ¿ 700599######';
  RExpression = '^.+Loyalty [0-9]{6}99[0-9]{6}';
begin
  S := ReplaceRegExpr (RExpression, Card1, ReplaceStr);
  CheckEquals(' ¿–“¿  ŒÃ¿Õƒ¿ 700599######0040', S);
end;

//initialization
//  RegisterTest('', TRosneftSalesReceiptTest.Suite);

end.
