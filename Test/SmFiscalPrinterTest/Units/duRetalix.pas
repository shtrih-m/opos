unit duRetalix;

interface

uses
  // VCL
  Windows, SysUtils,
  // DUnit
  TestFramework,
  // This
  FileUtils, Retalix, RegExpr, MalinaParams, DriverContext;

type
  { TRetalixTest }

  TRetalixTest = class(TTestCase)
  private
    Context: TDriverContext;
  protected
    procedure Setup; override;
    procedure Teardown; override;
    function GetDBPath: string;
  published
    procedure CheckOpen;
    procedure CheckReadTaxGroup;
    procedure CheckReadTaxGroup2;
    procedure CheckParseOperator;
    procedure CheckParseItemName;
    procedure CheckParseCashierName;
    procedure CheckReplaceOperator;
  end;

implementation

{ TRetalixTest }

procedure TRetalixTest.Setup;
begin
  Context := TDriverContext.Create;
end;

procedure TRetalixTest.Teardown;
begin
  Context.Free;
end;

function TRetalixTest.GetDBPath: string;
begin
  //Result := 'c:\positive\datapdx\';
  Result := GetModulePath + 'Retalix';
end;

procedure TRetalixTest.CheckReadTaxGroup;
begin
  // DBPath must exists!
  if not DirectoryExists(GetDBPath) then Exit;

  Context.MalinaParams.RetalixSearchCI := False;

  CheckEquals(4, RetalixReadTaxGroup(GetDBPath, 'ТРК  4   : Аи-95-К5           ', Context), 'Аи-95-К5');
  CheckEquals(-1, RetalixReadTaxGroup(GetDBPath, 'ТРК  4   : АИ-95-К5', Context), 'АИ-95-К5');
  CheckEquals(1, RetalixReadTaxGroup(GetDBPath, 'Газ баллон 5кг', Context));
  CheckEquals(2, RetalixReadTaxGroup(GetDBPath, 'Сахар пакетик 5 гр', Context));
  CheckEquals(4, RetalixReadTaxGroup(GetDBPath, 'Чай 120 мл автомат', Context));

  Context.MalinaParams.RetalixSearchCI := True;
  CheckEquals(4, RetalixReadTaxGroup(GetDBPath, 'ТРК  4   : АИ-95-К5', Context), 'АИ-95-К5');
end;

procedure TRetalixTest.CheckReadTaxGroup2;
var
  RetalixDB: TRetalix;
begin
  // DBPath must exists!
  if not DirectoryExists(GetDBPath) then Exit;

  RetalixDB := TRetalix.Create(GetDBPath, Context);
  try
    RetalixDB.Open;
    CheckEquals(1, RetalixDB.ReadTaxGroup('Газ баллон 5кг'));
    CheckEquals(2, RetalixDB.ReadTaxGroup('Сахар пакетик 5 гр'));
    CheckEquals(4, RetalixDB.ReadTaxGroup('Чай 120 мл автомат'));
    CheckEquals(2, RetalixDB.ReadTaxGroup('ERNO''S'));
  finally
    RetalixDB.Free;
  end;
end;

procedure TRetalixTest.CheckParseCashierName;
var
  Cashier: string;
begin
  Check(TRetalix.ParseCashierName('Оператор: ts ID:    3945140', Cashier));
  CheckEquals('ts', Cashier);
  Check(TRetalix.ParseCashierName('Оператор:tS ID:    3945140', Cashier));
  CheckEquals('tS', Cashier);
  Check(TRetalix.ParseCashierName('ОПератор:tS ID:    3945140', Cashier));
  CheckEquals('tS', Cashier);
  Check(TRetalix.ParseCashierName('ОПератор:tS ', Cashier));
  CheckEquals('tS', Cashier);
  Check(TRetalix.ParseCashierName('ОПератор:tS', Cashier));
  CheckEquals('tS', Cashier);
end;

procedure TRetalixTest.CheckParseOperator;
var
  Text: string;
  Cashier: string;
  Retalix: TRetalix;
begin
  // DBPath must exists!
  if not DirectoryExists(GetDBPath) then Exit;

  Retalix := TRetalix.Create(GetDBPath, Context);
  try
    Retalix.Open;

    Text := 'Оператор: Щукина Оль';
    Check(Retalix.ParseOperator(Text, Cashier));
    CheckEquals('Старший смены Щукина Ольга', Cashier);

    Text := 'Оператор:  Щукина Ольга ID: 723645';
    Check(Retalix.ParseOperator(Text, Cashier));
    CheckEquals('Старший смены Щукина Ольга', Cashier);

    Text := 'Оператор:Рыжикова  ';
    Check(Retalix.ParseOperator(Text, Cashier));
    CheckEquals('Управляющий АЗС Евгения Рыжикова', Cashier);

    Text := 'Оператор: Шельпякова И.С.';
    Check(Retalix.ParseOperator(Text, Cashier));
    CheckEquals('Кассир Шельпякова И.С.', Cashier);

    Text := 'Оператор: Шельпякова В.А.';
    Check(Retalix.ParseOperator(Text, Cashier));
    CheckEquals('Кассир Шельпякова В.А.', Cashier);
  finally
    Retalix.Free;
  end;
end;


procedure TRetalixTest.CheckParseItemName;
begin
  CheckEquals('Аи-95-К5', TRetalix.ParseItemName('ТРК  4   : Аи-95-К5           '));
  CheckEquals('Аи-95-К5', TRetalix.ParseItemName('ТРК 4:Аи-95-К5               Трз1449'));
  CheckEquals('АИ-95-К5', TRetalix.ParseItemName('ТРК 4:АИ-95-К5               Трз1449'));
  CheckEquals('Творожок детский', TRetalix.ParseItemName('Творожок детский'));
  CheckEquals('Coca-cola light 0.5л', TRetalix.ParseItemName('Coca-cola light 0.5л'));
end;

procedure TRetalixTest.CheckReplaceOperator;
var
  Line: string;
  Cashier: string;
begin
  Cashier := 'Кассир Иванов';
  Line := 'Оператор:ts ID:    3945140';
  Line := TRetalix.ReplaceOperator(Line, Cashier);
  CheckEquals('Кассир Иванов ID:    3945140', Line);

  Cashier := 'Кассир Иванов';
  Line := 'Оператор:  ts ';
  Line := TRetalix.ReplaceOperator(Line, Cashier);
  CheckEquals('Кассир Иванов', Line);

  Cashier := 'Кассир Иванов';
  Line := 'Оператор:ts';
  Line := TRetalix.ReplaceOperator(Line, Cashier);
  CheckEquals('Кассир Иванов', Line);
end;

procedure TRetalixTest.CheckOpen;
var
  i: Integer;
  Retalix: TRetalix;
begin
  // DBPath must exists!
  if not DirectoryExists(GetDBPath) then Exit;

  Retalix := TRetalix.Create(GetDBPath, Context);
  try
    for i := 1 to 3 do
    begin
      Retalix.Open;
      Retalix.Close;
    end;
  finally
    Retalix.Free;
  end;
end;

{$IFDEF MALINA}
initialization
  RegisterTest('', TRetalixTest.Suite);
{$ENDIF}

end.
