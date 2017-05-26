unit ReceiptFormat;

interface

uses
  // VCL
  Windows, SysUtils,
  // This
  PrinterTypes;

type
  { TReceiptFormatItem }

  TReceiptFormatItem = record
    Line: Integer;
    Offset: Integer;
    Width: Integer;
    Alignment: Integer;
    Name: string;
  end;

  { TReceiptFormat }

  TReceiptFormat = record
    Enabled: Boolean;
    TextItem: TReceiptFormatItem;            // мюхлемнбюмхе б ноепюжхх
    QuantityItem: TReceiptFormatItem;        // йнкхвеярбн X жемс б ноепюжхх
    DepartmentItem: TReceiptFormatItem;      // яейжхъ б ноепюжхх
    AmountItem: TReceiptFormatItem;          // ярнхлнярэ б ноепюжхх
    StornoItem: TReceiptFormatItem;          // мюдохяэ ярнпмн б ноепюжхх
    DscText: TReceiptFormatItem;             // рейяр б яйхдйе
    DscName: TReceiptFormatItem;             // мюдохяэ яйхдйю
    DscAmount: TReceiptFormatItem;           // ясллю яйхдйх
    CrgText: TReceiptFormatItem;             // рейяр б мюдаюбйе
    CrgName: TReceiptFormatItem;             // мюдохяэ мюдаюбйю
    CrgAmount: TReceiptFormatItem;           // ясллю мюдаюбйх
    DscStornoText: TReceiptFormatItem;       // рейяр б ярнпмн яйхдйх
    DscStornoName: TReceiptFormatItem;       // мюдохяэ ярнпмн яйхдйх
    DscStornoAmount: TReceiptFormatItem;     // ясллю ярнпмн яйхдйх
    CrgStornoText: TReceiptFormatItem;       // рейяр б ярнпмн мюдаюбйх
    CrgStornoName: TReceiptFormatItem;       // мюдохяэ ярнпмн мюдаюбйх
    CrgStornoAmount: TReceiptFormatItem;     // ясллю ярнпмн мюдаюбйх
  end;

implementation

end.
