unit duReceiptTemplate;

interface

uses
  // VCL
  Windows, SysUtils,
  // DUnit
  TestFramework,
  // This
  FileUtils, ReceiptTemplate, ReceiptItem, PrinterParameters;

type
  { TReceiptTemplateTest }

  TReceiptTemplateTest = class(TTestCase)
  private
    Template: TReceiptTemplate;
  protected
    procedure Setup; override;
    procedure Teardown; override;
  published
    procedure CheckGetText;
    procedure CheckParseField;
    procedure CheckParseField2;
    procedure CheckGetTextDiscountNone;
  end;

implementation

{ TReceiptTemplateTest }

procedure TReceiptTemplateTest.Setup;
var
  Data: TReceiptTemplateRec;
begin
  Data.PrintWidth := 42;
  Template := TReceiptTemplate.Create(Data);
end;

procedure TReceiptTemplateTest.Teardown;
begin
  Template.Free;
end;

(*
  'POS'
  'UNITPRICE'
  'PRICE'
  'QUAN'
  'SUM'
  'DISCOUNT'
  'TOTAL'
  'TOTAL_TAX'
  'TAX_LETTER'
  'MULT_NE_ONE'
*)

procedure TReceiptTemplateTest.CheckGetText;
var
  Text: string;
  Item: TFSSaleItem;
begin
  Item := TFSSaleItem.Create(nil);
  try
    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%TITLE%', Item);
    CheckEquals(Item.Text, Text, 'Item.Text');

    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%TITLE%', Item);
    CheckEquals('ajdshgjasghd86876234', Text, 'Item.Text');

    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%lTITLE%', Item);
    CheckEquals('ajdshgjasghd86876234', Text, 'Item.Text');

    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%30lTITLE%', Item);
    CheckEquals('ajdshgjasghd86876234          ', Text, 'Item.Text');

    Item.Pos := 234;
    Text := Template.getText('%POS%', Item);
    CheckEquals('234', Text, 'POS');

    Item.UnitPrice := 123456;
    Text := Template.getText('%UNITPRICE%', Item);
    CheckEquals('1234.56', Text, 'UNITPRICE');

    Item.Price := 123456;
    Text := Template.getText('%PRICE%', Item);
    CheckEquals('1234.56', Text, 'PRICE');

    Item.Data.Quantity := 123.456;
    Text := Template.getText('%QUAN%', Item);
    CheckEquals('123.456', Text, 'QUAN');

    Item.Data.Quantity := 12.000;
    Text := Template.getText('%10lQUAN%', Item);
    CheckEquals('12.000    ', Text, 'QUAN');

    Item.Data.Quantity := 12.000;
    Text := Template.getText('%10QUAN%', Item);
    CheckEquals('    12.000', Text, 'QUAN');

    Item.Quantity := 12.000;
    Text := Template.getText('%5lQUAN%', Item);
    CheckEquals('12.00', Text, 'QUAN');

    Item.Price := 123456;
    Item.UpdatePrice;
    Text := Template.getText('%SUM%', Item);
    CheckEquals('1234.56', Text, 'SUM');

    Item.Price := 123456;
    Item.PriceWithDiscount := 0;
    Text := Template.getText('%DISCOUNT%', Item);
    CheckEquals('1234.56', Text, 'DISCOUNT');

    Item.Price := 123456;
    Item.Quantity := 1;
    Item.Data.Discount := 12345;
    Text := Template.getText('%TOTAL%', Item);
    CheckEquals('1111.11', Text, 'TOTAL');

    Item.Tax := 1;
    Item.Price := 123456;
    Item.Quantity := 1;
    Item.Data.Discount := 12345;
    Item.PriceWithDiscount := 111111;
    Text := Template.getText('ABC_%TOTAL_TAX%', Item);
    CheckEquals('ABC_1111.11_À', Text, 'TOTAL_TAX');

    Item.Tax := 2;
    Text := Template.getText('%TAX_LETTER%', Item);
    CheckEquals('Á', Text, 'TAX_LETTER');

    Item.Quantity := 0.123;
    Text := Template.getText('%MULT_NE_ONE%', Item);
    CheckEquals('*', Text, 'MULT_NE_ONE');

    Item.Text := 'hg345hg34';
    Text := Template.getText('123 %TITLE% sdfd8', Item);
    CheckEquals('123 hg345hg34 sdfd8', Text, 'Item.Text');


    Item.Pos := 1;
    Item.Data.Amount := 500;
    Item.UnitPrice := 100;
    Item.Quantity := 5;
    Item.Price := 100;
    Item.Department := 2;
    Item.Tax := 3;
    Item.Discount := 0;
    Item.Charge := 0;
    Item.PriceWithDiscount := 100;
    Item.Text := 'Receipt item 2';
    Item.UpdatePrice;
    Text := '%42lTITLE%'#13#10 +
      '               %8PRICE% X %5QUAN% %=10TOTAL_TAX%';
    Text := Template.getText(Text, Item);
    CheckEquals(
      'Receipt item 2                            '#$D#$A +
      '                   1.00 X 5.000    =5.00_Â', Text, 'Item.Text');

    Item.Pos := 1;
    Item.Data.Amount := 1524064;
    Item.UnitPrice := 12345;
    Item.Quantity := 123.456;
    Item.Price := 12345;
    Item.Department := 2;
    Item.Tax := 3;
    Item.PriceWithDiscount := 12345;
    Item.Text := 'Receipt item 2';
    Item.Data.Discount := 0;
    Text := '%51lTITLE%'#13#10'%10QUAN% X %8lPRICE% %=10TOTAL%';
    Text := Template.getText(Text, Item);
    CheckEquals('Receipt item 2                                     '#$D#$A +
      '   123.456 X 123.45    =15240.64', Text, 'Item.Text');
  finally
    Item.Free;
  end;
end;

procedure TReceiptTemplateTest.CheckGetTextDiscountNone;
var
  Text: string;
  Item: TFSSaleItem;
begin
  Item := TFSSaleItem.Create(nil);
  try
    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%TITLE%', Item);
    CheckEquals(Item.Text, Text, 'Item.Text');

    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%TITLE%', Item);
    CheckEquals('ajdshgjasghd86876234', Text, 'Item.Text');

    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%lTITLE%', Item);
    CheckEquals('ajdshgjasghd86876234', Text, 'Item.Text');

    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%30lTITLE%', Item);
    CheckEquals('ajdshgjasghd86876234          ', Text, 'Item.Text');

    Item.Pos := 234;
    Text := Template.getText('%POS%', Item);
    CheckEquals('234', Text, 'POS');

    Item.UnitPrice := 123456;
    Text := Template.getText('%UNITPRICE%', Item);
    CheckEquals('1234.56', Text, 'UNITPRICE');

    Item.Price := 123456;
    Text := Template.getText('%PRICE%', Item);
    CheckEquals('1234.56', Text, 'PRICE');

    Item.Data.Quantity := 123.456;
    Text := Template.getText('%QUAN%', Item);
    CheckEquals('123.456', Text, 'QUAN');

    Item.Data.Quantity := 12.000;
    Text := Template.getText('%10lQUAN%', Item);
    CheckEquals('12.000    ', Text, 'QUAN');

    Item.Data.Quantity := 12.000;
    Text := Template.getText('%10QUAN%', Item);
    CheckEquals('    12.000', Text, 'QUAN');

    Item.Quantity := 12.000;
    Text := Template.getText('%5lQUAN%', Item);
    CheckEquals('12.00', Text, 'QUAN');

    Item.Price := 123456;
    Item.PriceWithDiscount := 0;
    Text := Template.getText('%DISCOUNT%', Item);
    CheckEquals('1234.56', Text, 'DISCOUNT');

    Item.Price := 123456;
    Item.Quantity := 1;
    Item.Data.Discount := 12345;
    Text := Template.getText('%TOTAL%', Item);
    CheckEquals('1111.11', Text, 'TOTAL');

    Item.Tax := 1;
    Item.Price := 123456;
    Item.Quantity := 1;
    Item.Data.Discount := 12345;
    Item.PriceWithDiscount := 111111;
    Text := Template.getText('ABC_%TOTAL_TAX%', Item);
    CheckEquals('ABC_1111.11_À', Text, 'TOTAL_TAX');

    Item.Tax := 2;
    Text := Template.getText('%TAX_LETTER%', Item);
    CheckEquals('Á', Text, 'TAX_LETTER');

    Item.Quantity := 0.123;
    Text := Template.getText('%MULT_NE_ONE%', Item);
    CheckEquals('*', Text, 'MULT_NE_ONE');

    Item.Text := 'hg345hg34';
    Text := Template.getText('123 %TITLE% sdfd8', Item);
    CheckEquals('123 hg345hg34 sdfd8', Text, 'Item.Text');

    Item.Pos := 1;
    Item.UnitPrice := 12345;
    Item.Quantity := 123.456;
    Item.Price := 12345;
    Item.Department := 2;
    Item.Tax := 3;
    Item.PriceWithDiscount := 12345;
    Item.Text := 'Receipt item 2';
    Item.Data.Discount := 0;
    Item.Discount := 0;
    Item.Charge := 0;
    Item.Data.Amount := 1524064;
    Text := '%51lTITLE%'#13#10'%10QUAN% X %8lPRICE% %=10TOTAL%';
    Text := Template.getText(Text, Item);
    CheckEquals('Receipt item 2                                     '#$D#$A +
      '   123.456 X 123.45    =15240.64', Text, 'Item.Text');
  finally
    Item.Free;
  end;
end;

(*
                   1.00 X 5.000    =5.00_Â
                   1.00 X 5.000       =5.00_Â
*)

procedure TReceiptTemplateTest.CheckParseField;
var
  Field: TTemplateFieldRec;
begin
  Field := Template.ParseField('TITLE');
  CheckEquals('TITLE', Field.Name, 'Field.Name');
  CheckEquals(0, Field.Length, 'Field.Length');
  CheckEquals(Ord(faRight), Ord(Field.Alignment), 'Field.Alignment');

  Field := Template.ParseField('51TITLE');
  CheckEquals('TITLE', Field.Name, 'Field.Name');
  CheckEquals(51, Field.Length, 'Field.Length');
  CheckEquals(Ord(faRight), Ord(Field.Alignment), 'Field.Alignment');

  Field := Template.ParseField('lTITLE');
  CheckEquals('TITLE', Field.Name, 'Field.Name');
  CheckEquals(0, Field.Length, 'Field.Length');
  CheckEquals(Ord(faLeft), Ord(Field.Alignment), 'Field.Alignment');

  Field := Template.ParseField('51lTITLE');
  CheckEquals('TITLE', Field.Name, 'Field.Name');
  CheckEquals(51, Field.Length, 'Field.Length');
  CheckEquals(Ord(faLeft), Ord(Field.Alignment), 'Field.Alignment');
end;

procedure TReceiptTemplateTest.CheckParseField2;
var
  Field: TTemplateFieldRec;
begin
  Field := Template.ParseField2('TITLE');
  CheckEquals('TITLE', Field.Name, 'Field.Name');
  CheckEquals(0, Field.Length, 'Field.Length');
  CheckEquals(Ord(faRight), Ord(Field.Alignment), 'Field.Alignment');

  Field := Template.ParseField2('51TITLE');
  CheckEquals('TITLE', Field.Name, 'Field.Name');
  CheckEquals(51, Field.Length, 'Field.Length');
  CheckEquals(Ord(faRight), Ord(Field.Alignment), 'Field.Alignment');

  Field := Template.ParseField2('lTITLE');
  CheckEquals('TITLE', Field.Name, 'Field.Name');
  CheckEquals(0, Field.Length, 'Field.Length');
  CheckEquals(Ord(faLeft), Ord(Field.Alignment), 'Field.Alignment');

  Field := Template.ParseField2('51lTITLE');
  CheckEquals('TITLE', Field.Name, 'Field.Name');
  CheckEquals(51, Field.Length, 'Field.Length');
  CheckEquals(Ord(faLeft), Ord(Field.Alignment), 'Field.Alignment');
end;

initialization
  RegisterTest('', TReceiptTemplateTest.Suite);

end.
