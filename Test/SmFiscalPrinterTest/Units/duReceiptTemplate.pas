unit duReceiptTemplate;

interface

uses
  // VCL
  Windows, SysUtils,
  // DUnit
  TestFramework,
  // This
  FileUtils, ReceiptTemplate, ReceiptItem;

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
  end;

implementation

{ TReceiptTemplateTest }

procedure TReceiptTemplateTest.Setup;
begin
  Template := TReceiptTemplate.Create;
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
  Discount: TDiscountReceiptItem;
begin
  Item := TFSSaleItem.Create(nil);
  try
    Item.Text := 'ajdshgjasghd86876234';
    Text := Template.getText('%TITLE%', Item);
    CheckEquals(Item.Text, Text, 'Item.Text');

    Item.Pos := 234;
    Text := Template.getText('%POS%', Item);
    CheckEquals('234', Text, 'POS');

    Item.UnitPrice := 123456;
    Text := Template.getText('%UNITPRICE%', Item);
    CheckEquals('1234.56', Text, 'UNITPRICE');

    Item.Price := 123456;
    Text := Template.getText('%PRICE%', Item);
    CheckEquals('1234.56', Text, 'PRICE');

    Item.Quantity := 123456;
    Text := Template.getText('%QUAN%', Item);
    CheckEquals('123.456', Text, 'QUAN');

    Item.Price := 123456;
    Item.Quantity := 1000;
    Text := Template.getText('%SUM%', Item);
    CheckEquals('1234.56', Text, 'SUM');

    Discount := TDiscountReceiptItem.Create(Item.Discounts);
    Discount.Data.Amount := 123456;
    Text := Template.getText('%DISCOUNT%', Item);
    CheckEquals('1234.56', Text, 'DISCOUNT');

    Item.Price := 123456;
    Item.Quantity := 1000;
    Item.Data.Discount := 12345;
    Text := Template.getText('%TOTAL%', Item);
    CheckEquals('1111.11', Text, 'TOTAL');

    Item.Tax := 1;
    Item.Price := 123456;
    Item.Quantity := 1000;
    Item.Data.Discount := 12345;
    Text := Template.getText('%TOTAL_TAX%', Item);
    CheckEquals('1111.11_À', Text, 'TOTAL_TAX');

    Item.Tax := 2;
    Text := Template.getText('%TAX_LETTER%', Item);
    CheckEquals('Á', Text, 'TAX_LETTER');

    Item.Quantity := 123;
    Text := Template.getText('%MULT_NE_ONE%', Item);
    CheckEquals('*', Text, 'MULT_NE_ONE');

    Item.Text := 'hg345hg34';
    Text := Template.getText('123 %TITLE% sdfd8', Item);
    CheckEquals('123 hg345hg34 sdfd8', Text, 'Item.Text');
  finally
    Item.Free;
  end;
end;

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
