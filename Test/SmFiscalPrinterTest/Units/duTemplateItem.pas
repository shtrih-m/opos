unit duTemplateItem;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  TemplateItem;

type
  { TTemplateItemTest }

  TTemplateItemTest = class(TTestCase)
  published
    procedure GetNextTag;
  end;


implementation

{ TTemplateItemTest }

procedure TTemplateItemTest.GetNextTag;
var
  S, Tag: string;
  Items: TTemplateItems;
begin
  S := '%51lTITLE%;%8lPRICE% %6lDISCOUNT%  %8lSUM%       %3QUAN%    %=$10TOTAL_TAX%';
  Items := TTemplateItems.Create;
  try
    Check(Items.GetNextTag(S, Tag));
    CheckEquals('51lTITLE', Tag);
    Check(Items.GetNextTag(S, Tag));
    CheckEquals(';', Tag);
    Check(Items.GetNextTag(S, Tag));
    CheckEquals('8lPRICE', Tag);
    Check(Items.GetNextTag(S, Tag));
    CheckEquals(' ', Tag);
  finally
    Items.Free;
  end;
end;

initialization
  RegisterTest('', TTemplateItemTest.Suite);

end.
