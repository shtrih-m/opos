unit DeviceTables;

interface

uses
  PrinterTypes;

type
  { TRecFormatItem }

  TRecFormatItem = record
    Line: Byte;
    Offset: Byte;
    Size: Byte;
    Align: Byte;
    Name: string;
  end;

  { TRecFormatTable }

  TRecFormatTable = record
    ItemText: TRecFormatItem;           // NAME IN OPERATION
    Quantity: TRecFormatItem;           // QUANTITY X PRICE IN OPERATION
    Department: TRecFormatItem;         // DEPARTMENT IN OPERATION
    SaleAmount: TRecFormatItem;         // COST VALUE IN OPERATION
    StornoText: TRecFormatItem;         // VOID TEXT IN OPERATION
    DiscountText: TRecFormatItem;       // TEXT IN DISCOUNT
    DiscountName: TRecFormatItem;       // DISCOUNT NAME
    DiscountAmount: TRecFormatItem;     // DISCOUNT SUM
    ChargeText: TRecFormatItem;         // TEXT IN CHARGE
    ChargeName: TRecFormatItem;         // CHARGE NAME
    ChargeAmount: TRecFormatItem;       // CHARGE SUM
    DscStornoText: TRecFormatItem;      // TEXT IN DISCOUNT VOID
    DscStornoName: TRecFormatItem;      // DISCOUNT VOID NAME
    DscStornoAmount: TRecFormatItem;    // DISCOUNT VOID AMOUNT
    ChrStornoText: TRecFormatItem;      // TEXT IN CHARGE VOID
    ChrStornoName: TRecFormatItem;      // CHARGE VOID NAME
    ChrStornoAmount: TRecFormatItem;    // CHARGE VOID SUM
  end;

  { TParamTable }

  TParamTable = record
    RecFormatEnabled: Boolean; // Receipt format enabled
  end;

  { TDeviceTables }

  TDeviceTables = record
    Params: TParamTable;
    RecFormat: TRecFormatTable; // Receipt format table
    TaxInfo: TTaxInfoList;
  end;

implementation

end.
