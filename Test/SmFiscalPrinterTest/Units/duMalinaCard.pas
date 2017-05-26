unit duMalinaCard;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  MalinaCard;

type
  { TMalinaCardTest }

  TMalinaCardTest = class(TTestCase)
  published
    procedure CheckSave;
  end;

implementation

{ TMalinaCardTest }

const
  REGSTR_UNIPOS_MALINA = 'SOFTWARE\Unipos\Malina';

procedure TMalinaCardTest.CheckSave;
var
  Card: TMalinaCard;
begin
  Card := TMalinaCard.Create(nil);
  try
    Card.Amount := 123;
    Card.DateTime := 'Card.DateTime';
    Card.CardNumber := 'Card.CardNumber';
    Card.OperationType := 234;

    Card.Save(REGSTR_UNIPOS_MALINA);
    Card.Clear;
    Card.Load(REGSTR_UNIPOS_MALINA);

    CheckEquals(123, Card.Amount, 'Card.Amount');
    CheckEquals('Card.DateTime', Card.DateTime, 'Card.DateTime');
    CheckEquals('Card.CardNumber', Card.CardNumber, 'Card.CardNumber');
    CheckEquals(234, Card.OperationType, 'Card.OperationType');
  finally
    Card.Free;
  end;
end;

initialization
  RegisterTest('', TMalinaCardTest.Suite);

end.
