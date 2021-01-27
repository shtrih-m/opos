unit DIOHandlers;

interface

uses
  // VCL
  Classes, SysUtils, Graphics, Extctrls,
  // 3'd
  TntSysUtils, TntClasses,
  // This
  DIOHandler, DirectIOAPI, PrinterCommand, ShtrihFiscalPrinter,
  FiscalPrinterDevice, CommandDef, CommandParam, XmlParser, BinStream,
  OposException, PrinterTypes, Opos, StringUtils, FiscalPrinterImpl,
  fmuLogo, FiscalPrinterTypes, ZReport, LogFile, PrinterParameters,
  OposUtils, OposFptrUtils, WException, gnugettext;

const
  ValueDelimiters = [';'];

type
  { TDIOCommandDef }

  TDIOCommandDef = class(TDIOHandler)
  private
    FCommands: TCommandDefs;
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOHexCommand }

  TDIOHexCommand = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOCheckEndDay }

  TDIOCheckEndDay = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOLoadLogo }

  TDIOLoadLogo = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintLogo }

  TDIOPrintLogo = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOClearLogo }

  TDIOClearLogo = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOLogoDlg }

  TDIOLogoDlg = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOBarcode }

  TDIOBarcode = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOBarcodeHex }

  TDIOBarcodeHex = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOBarcodeHex2 }

  TDIOBarcodeHex2 = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStrCommand }

  TDIOStrCommand = class(TDIOHandler)
  private
    FCommands: TCommandDefs;
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStrCommand2 }

  TDIOStrCommand2 = class(TDIOHandler)
  private
    FCommands: TCommandDefs;
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintText }

  TDIOPrintText = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTaxName }

  TDIOWriteTaxName = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadTaxName }

  TDIOReadTaxName = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWritePaymentName }

  TDIOWritePaymentName = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWritePaymentName2 }

  TDIOWritePaymentName2 = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadPaymentName }

  TDIOReadPaymentName = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteTable }

  TDIOWriteTable = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadTable }

  TDIOReadTable = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetDepartment }

  TDIOGetDepartment = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOSetDepartment }

  TDIOSetDepartment = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOReadCashRegister }

  TDIOReadCashRegister = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadOperatingRegister }

  TDIOReadOperatingRegister = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintRecRefund }

  TDIOPrintRecRefund = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintJournal }

  TDIOPrintJournal = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadDayNumber }

  TDIOReadDayNumber = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWaitForPrint }

  TDIOWaitForPrint = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintHeader }

  TDIOPrintHeader = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintTrailer }

  TDIOPrintTrailer = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReport }

  TDIOZReport = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReportXML }

  TDIOZReportXML = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOZReportCSV }

  TDIOZReportCSV = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetLastError }

  TDIOGetLastError = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetPrinterStation }

  TDIOGetPrinterStation = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetPrinterStation }

  TDIOSetPrinterStation = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetDriverParameter }

  TDIOGetDriverParameter = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOSetDriverParameter }

  TDIOSetDriverParameter = class(TDIOHandler)
  private
    function GetParameters: TPrinterParameters;
  private
    FPrinter: TFiscalPrinterImpl;
    property Parameters: TPrinterParameters read GetParameters;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintSeparator }

  TDIOPrintSeparator = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOReadEJActivation }

  TDIOReadEJActivation = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOReadFMTotals }

  TDIOReadFMTotals = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);
    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOReadGrandTotals }

  TDIOReadGrandTotals = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOPrintImage }

  TDIOPrintImage = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintImageScale }

  TDIOPrintImageScale = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    property Printer: TFiscalPrinterImpl read FPrinter;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadFSParameter }

  TDIOReadFSParameter = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  end;

  { TDIOReadFPParameter }

  TDIOReadFPParameter = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOWriteFPParameter }

  TDIOWriteFPParameter = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOWriteCustomerAddress }

  TDIOWriteCustomerAddress = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  end;

  { TDIOWriteTlvData }

  TDIOWriteTlvData = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  end;

  { TDIOWriteTlvHex }

  TDIOWriteTlvHex = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOWriteTlvOperation }

  TDIOWriteTlvOperation = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOWriteStringTag }

  TDIOWriteStringTag = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  end;

  { TDIOSetAdjustmentAmount }

  TDIOSetAdjustmentAmount = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  end;

  { TDIODisableNextHeader }

  TDIODisableNextHeader = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  end;

  { TDIOWriteTableFile }

  TDIOWriteTableFile = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSReadDocument }

  TDIOFSReadDocument = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSPrintCalcReport }

  TDIOFSPrintCalcReport = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOOpenCashDrawer }

  TDIOOpenCashDrawer = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadCashDrawerState }

  TDIOReadCashDrawerState = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSFiscalize }

  TDIOFSFiscalize = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOFSReFiscalize }

  TDIOFSReFiscalize = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOGetPrintWidth }

  TDIOGetPrintWidth = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOReadFSDocument }

  TDIOReadFSDocument = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintFSDocument }

  TDIOPrintFSDocument = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintCorrection }

  TDIOPrintCorrection = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOPrintCorrection2 }

  TDIOPrintCorrection2 = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStartOpenDay }

  TDIOStartOpenDay = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOOpenDay }

  TDIOOpenDay = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOCheckItemCode }

  TDIOCheckItemCode = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOStartCorrection }

  TDIOStartCorrection = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
  end;

  { TDIOWriteStringTagOp }

  TDIOWriteStringTagOp = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
    function GetDevice: IFiscalPrinterDevice;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  end;

  { TDIOSTLVBegin }

  TDIOSTLVBegin = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOSTLVAddTag }

  TDIOSTLVAddTag = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOSTLVWrite }

  TDIOSTLVWrite = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOSTLVWriteOp }

  TDIOSTLVWriteOp = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOSTLVGetHex }

  TDIOSTLVGetHex = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

  { TDIOSetReceiptField }

  TDIOSetReceiptField = class(TDIOHandler)
  private
    FPrinter: TFiscalPrinterImpl;
  public
    constructor CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
      APrinter: TFiscalPrinterImpl);

    procedure DirectIO(var pData: Integer; var pString: WideString); override;
    property Printer: TFiscalPrinterImpl read FPrinter;
  end;

implementation

function BoolToStr(Value: Boolean): WideString;
begin
  if Value then Result := '1'
  else Result := '0';
end;

function StrToBool(const Value: WideString): Boolean;
begin
  Result := Value <> '0';
end;

{ TDIOCommandDef }

constructor TDIOCommandDef.CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
  ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FCommands := ACommands;
  FPrinter := APrinter;
end;

procedure TDIOCommandDef.DirectIO(var pData: Integer; var pString: WideString);
var
  Param: TCommandParam;
  Stream: TBinStream;
  Command: TCommandDef;
  ResultCode: Integer;
begin
  Printer.CheckEnabled;

  Command := FCommands.ItemByCode(pData);
  Stream := TBinStream.Create;
  try
    Command.InParams.AsXml := pString;
    Stream.WriteByte(Command.Code);
    Command.InParams.Write(Stream);
    Command.OutParams.ClearValue;

    ResultCode := Device.ExecuteStream(Stream);
    Param := Command.OutParams.FindItem('ResultCode');
    if Param <> nil then
      Param.Value := IntToStr(ResultCode);

    if ResultCode = 0 then
    begin
      Stream.Position := Stream.Position-1;
      Command.OutParams.Read(Stream);
    end else
    begin
      RaiseOPOSException(OPOS_E_FAILURE, FPTR_ERROR_BASE + ResultCode,
        Device.GetErrorText(ResultCode));
    end;
    pString := Command.OutParams.AsXml;
  finally
    Stream.Free;
  end;
end;

function TDIOCommandDef.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

{ TDIOHexCommand }

constructor TDIOHexCommand.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOHexCommand.DirectIO(var pData: Integer; var pString: WideString);
var
  TxData: AnsiString;
  RxData: AnsiString;
begin
  Printer.CheckEnabled;
  TxData := HexToStr(pString);
  Device.Check(Device.ExecuteData(TxData, RxData));
  pString := StrToHex(RxData);
end;

function TDIOHexCommand.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

{ TDIOCheckEndDay }

constructor TDIOCheckEndDay.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOCheckEndDay.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.CheckEnabled;
  if Printer.Device.ReadPrinterStatus.Mode = ECRMODE_24OVER then pData := 1
  else pData := 0;
end;

{ TDIOLoadLogo }

constructor TDIOLoadLogo.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOLoadLogo.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  try
    Printer.LoadLogo(pString);
  except
    on E: Exception do
    begin
      Logger.Error(GetExceptionMessage(E));
      raiseException(_('Íå óäàëîñü çàãðóçèòü ëîãîòèï'));
    end;
  end;
end;

{ TDIOPrintLogo }

constructor TDIOPrintLogo.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintLogo.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintLogo;
end;

{ TDIOLogoDlg }

constructor TDIOLogoDlg.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOLogoDlg.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  ShowLogoDialog(Printer);
end;

{ TDIOBarcode }

constructor TDIOBarcode.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOBarcode.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Barcode: TBarcodeRec;
  Parameters: TPrinterParameters;
begin
  if Pos(';', pString) = 0 then
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := pString;
    Barcode.Text := pString;

    Parameters := Printer.Device.Parameters;
    Barcode.Height := Parameters.BarcodeHeight;
    Barcode.ModuleWidth := Parameters.BarcodeModuleWidth;
    Barcode.Alignment := Parameters.BarcodeAlignment;
    Barcode.Parameter1 := Parameters.BarcodeParameter1;
    Barcode.Parameter2 := Parameters.BarcodeParameter2;
    Barcode.Parameter3 := Parameters.BarcodeParameter3;
  end else
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := GetString(pString, 1, ValueDelimiters);
    Barcode.Text := GetString(pString, 2, ValueDelimiters);
    Barcode.Height := GetInteger(pString, 3, ValueDelimiters);
    Barcode.ModuleWidth := GetInteger(pString, 4, ValueDelimiters);
    Barcode.Alignment := GetInteger(pString, 5, ValueDelimiters);
    Barcode.Parameter1 := GetInteger(pString, 6, ValueDelimiters);
    Barcode.Parameter2 := GetInteger(pString, 7, ValueDelimiters);
    Barcode.Parameter3 := GetInteger(pString, 8, ValueDelimiters);
    Barcode.Parameter4 := GetInteger(pString, 9, ValueDelimiters);
    Barcode.Parameter5 := GetInteger(pString, 10, ValueDelimiters);
  end;
  Printer.PrintBarcode(Barcode);
end;

{ TDIOBarcodeHex }

constructor TDIOBarcodeHex.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOBarcodeHex.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Barcode: TBarcodeRec;
  Parameters: TPrinterParameters;
begin
  if Pos(';', pString) = 0 then
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := HexToStr(pString);
    Barcode.Text := pString;

    Parameters := Printer.Device.Parameters;
    Barcode.Height := Parameters.BarcodeHeight;
    Barcode.ModuleWidth := Parameters.BarcodeModuleWidth;
    Barcode.Alignment := Parameters.BarcodeAlignment;
    Barcode.Parameter1 := Parameters.BarcodeParameter1;
    Barcode.Parameter2 := Parameters.BarcodeParameter2;
    Barcode.Parameter3 := Parameters.BarcodeParameter3;
  end else
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := HexToStr(GetString(pString, 1, ValueDelimiters));
    Barcode.Text := GetString(pString, 2, ValueDelimiters);
    Barcode.Height := GetInteger(pString, 3, ValueDelimiters);
    Barcode.ModuleWidth := GetInteger(pString, 4, ValueDelimiters);
    Barcode.Alignment := GetInteger(pString, 5, ValueDelimiters);
    Barcode.Parameter1 := GetInteger(pString, 6, ValueDelimiters);
    Barcode.Parameter2 := GetInteger(pString, 7, ValueDelimiters);
    Barcode.Parameter3 := GetInteger(pString, 8, ValueDelimiters);
  end;
  Printer.PrintBarcode(Barcode);
end;

{ TDIOBarcodeHex2 }

constructor TDIOBarcodeHex2.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOBarcodeHex2.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Barcode: TBarcodeRec;
  Parameters: TPrinterParameters;
begin
  if Pos(';', pString) = 0 then
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := HexToStr(pString);
    Barcode.Text := pString;

    Parameters := Printer.Device.Parameters;
    Barcode.Height := Parameters.BarcodeHeight;
    Barcode.ModuleWidth := Parameters.BarcodeModuleWidth;
    Barcode.Alignment := Parameters.BarcodeAlignment;
    Barcode.Parameter1 := Parameters.BarcodeParameter1;
    Barcode.Parameter2 := Parameters.BarcodeParameter2;
    Barcode.Parameter3 := Parameters.BarcodeParameter3;
  end else
  begin
    Barcode.BarcodeType := pData;
    Barcode.Data := HexToStr(GetString(pString, 1, ValueDelimiters));
    Barcode.Text := HexToStr(GetString(pString, 2, ValueDelimiters));
    Barcode.Height := GetInteger(pString, 3, ValueDelimiters);
    Barcode.ModuleWidth := GetInteger(pString, 4, ValueDelimiters);
    Barcode.Alignment := GetInteger(pString, 5, ValueDelimiters);
    Barcode.Parameter1 := GetInteger(pString, 6, ValueDelimiters);
    Barcode.Parameter2 := GetInteger(pString, 7, ValueDelimiters);
    Barcode.Parameter3 := GetInteger(pString, 8, ValueDelimiters);
  end;
  Printer.PrintBarcode(Barcode);
end;

{ TDIOStrCommand }

constructor TDIOStrCommand.CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
  ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FCommands := ACommands;
  FPrinter := APrinter;
end;

procedure TDIOStrCommand.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Param: TCommandParam;
  Stream: TBinStream;
  Command: TCommandDef;
  ResultCode: Integer;
  FieldNumber: Integer;
  TableNumber: Integer;
  FieldInfo: TPrinterFieldRec;
begin
  Command := FCommands.ItemByCode(pData);
  Stream := TBinStream.Create;
  try
    Command.InParams.AsText := pString;
    { Read table }
    if Command.Code = $1F then
    begin
      Param := Command.InParams.ItemByType(PARAM_TYPE_TABLE);
      if Param <> nil then
      begin
        TableNumber := StrToInt(Param.Value);
        Param := Command.InParams.ItemByType(PARAM_TYPE_FIELD);
        if Param <> nil then
        begin
          FieldNumber := StrToInt(Param.Value);
          FieldInfo := Device.ReadFieldStructure(TableNumber, FieldNumber);
          Param := Command.OutParams.ItemByType(PARAM_TYPE_FVALUE);
          if Param <> nil then
          begin
            Param.Size := FieldInfo.Size;
          end;
        end;
      end;
    end;
    { Write table }
    if Command.Code = $1E then
    begin
      Param := Command.InParams.ItemByType(PARAM_TYPE_TABLE);
      if Param <> nil then
      begin
        TableNumber := StrToInt(Param.Value);
        Param := Command.InParams.ItemByType(PARAM_TYPE_FIELD);
        if Param <> nil then
        begin
          FieldNumber := StrToInt(Param.Value);
          FieldInfo := Device.ReadFieldStructure(TableNumber, FieldNumber);
          Param := Command.InParams.ItemByType(PARAM_TYPE_FVALUE);
          if Param <> nil then
          begin
            Param.Size := FieldInfo.Size;
            Param.Value := Device.GetFieldValue(FieldInfo, Param.Value);
          end;
        end;
      end;
    end;

    if Command.Code < $FF then
    begin
      Stream.WriteByte(Command.Code);
    end else
    begin
      Stream.WriteWord(Command.Code);
    end;
    Command.InParams.Write(Stream);
    Command.OutParams.ClearValue;

    ResultCode := Device.ExecuteStream2(Stream);
    if ResultCode = 0 then
    begin
      Stream.Position := 0;
      Command.OutParams.Read(Stream);
      { Read table }
      if Command.Code = $1F then
      begin
        Param := Command.OutParams.ItemByType(PARAM_TYPE_FVALUE);
        if Param <> nil then
        begin
          Param.Value := Device.BinToFieldValue(FieldInfo, Param.Value);
        end;
      end;
      pString := Command.OutParams.AsText;
    end else
    begin
      pString := Tnt_WideFormat('%d;%s', [ResultCode, Device.GetErrorText(ResultCode)]);
    end;
  finally
    Stream.Free;
  end;
end;

function TDIOStrCommand.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

{ TDIOStrCommand2 }

constructor TDIOStrCommand2.CreateCommand(AOwner: TDIOHandlers; ACommand: Integer;
  ACommands: TCommandDefs; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FCommands := ACommands;
  FPrinter := APrinter;
end;

procedure TDIOStrCommand2.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Stream: TBinStream;
  Command: TCommandDef;
begin
  Command := FCommands.ItemByCode(pData);
  Stream := TBinStream.Create;
  try
    Command.InParams.AsText := pString;
    if Command.Code < $FF then
    begin
      Stream.WriteByte(Command.Code);
    end else
    begin
      Stream.WriteWord(Command.Code);
    end;
    Command.InParams.Write(Stream);
    Command.OutParams.ClearValue;
    Device.Check(Device.ExecuteStream2(Stream));
    Stream.Position := 0;
    Command.OutParams.Read(Stream);
    pString := Command.OutParams.GetText(1);
  finally
    Stream.Free;
  end;
end;

function TDIOStrCommand2.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

{ TDIOPrintText }

constructor TDIOPrintText.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintText.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Data: TTextRec;
begin
  Data.Text := pString;
  Data.Station := Printer.Printer.Station;
  Data.Font := pData;
  Data.Alignment := taLeft;
  Data.Wrap := Printer.Parameters.WrapText;
  Printer.PrintText(Data);
end;

{ TDIOWriteTaxName }

constructor TDIOWriteTaxName.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOWriteTaxName.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

procedure TDIOWriteTaxName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Device.WriteTable(PRINTER_TABLE_TAX, pData, 2, pString);
end;

{ TDIOReadTaxName }

constructor TDIOReadTaxName.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOReadTaxName.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

procedure TDIOReadTaxName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Device.ReadTableStr(PRINTER_TABLE_TAX, pData, 2);
end;

{ TDIOReadPaymentName }

constructor TDIOReadPaymentName.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadPaymentName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Device.ReadTableStr(PRINTER_TABLE_PAYTYPE, pData, 1);
end;

function TDIOReadPaymentName.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

{ TDIOWritePaymentName }

constructor TDIOWritePaymentName.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWritePaymentName.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  if Printer.Parameters.WritePaymentNameEnabled then
  begin
    Printer.Printer.Device.WriteTable(PRINTER_TABLE_PAYTYPE, pData, 1, pString);
  end;
end;

{ TDIOWritePaymentName2 }

constructor TDIOWritePaymentName2.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWritePaymentName2.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  if Printer.Parameters.WritePaymentNameEnabled then
  begin
    Printer.Printer.Device.WriteTable(PRINTER_TABLE_PAYTYPE, pData, 1, pString);
  end;
end;

{ TDIOReadTable }

constructor TDIOReadTable.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadTable.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Table: Integer;
  Field: Integer;
  Row: Integer;
begin
  Table := GetInteger(pString, 1, ValueDelimiters);
  Row := GetInteger(pString, 2, ValueDelimiters);
  Field := GetInteger(pString, 3, ValueDelimiters);
  pString := Printer.Printer.Device.ReadTableStr(Table, Row, Field);
end;

{ TDIOWriteTable }

constructor TDIOWriteTable.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWriteTable.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Table: Integer;
  Field: Integer;
  Row: Integer;
  FieldValue: WideString;
begin
  Table := GetInteger(pString, 1, ValueDelimiters);
  Row := GetInteger(pString, 2, ValueDelimiters);
  Field := GetInteger(pString, 3, ValueDelimiters);
  FieldValue := GetString(pString, 4, ValueDelimiters);
  Printer.Printer.Device.WriteTable(Table, Row, Field, FieldValue);
end;

{ TDIOGetDepartment }

constructor TDIOGetDepartment.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetDepartment.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.Parameters.Department;
end;

{ TDIOSetDepartment }

constructor TDIOSetDepartment.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSetDepartment.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Parameters.Department := pData;
end;

{ TDIOReadCashRegister }

constructor TDIOReadCashRegister.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadCashRegister.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := IntTostr(Printer.Printer.Device.ReadCashReg2(pData));
end;

{ TDIOReadOperatingRegister }

constructor TDIOReadOperatingRegister.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadOperatingRegister.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := IntTostr(Printer.Printer.Device.ReadOperatingRegister(pData));
end;

constructor TDIOPrintRecRefund.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintRecRefund.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Description: WideString;
  Amount: Currency;
  Quantity: Int64;
  VatInfo: Integer;
begin
  Amount := StrToCurr(GetString(pString, 1, ValueDelimiters));
  Quantity := StrToInt(GetString(pString, 2, ValueDelimiters));
  VatInfo := StrToInt(GetString(pString, 3, ValueDelimiters));
  Description := GetString(pString, 4, ValueDelimiters);
  Printer.PrintRecItemRefund(Description, Amount, Quantity,
    VatInfo, 0, '');
end;

{ TDIOPrintJournal }

constructor TDIOPrintJournal.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintJournal.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.PrintJournal(pData);
  Printer.Device.WaitForPrinting;
end;

{ TDIOReadDayNumber }

constructor TDIOReadDayNumber.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadDayNumber.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.Device.ReadLongStatus.DayNumber;
end;

{ TDIOWaitForPrint }

constructor TDIOWaitForPrint.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWaitForPrint.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.WaitForPrinting;
end;

{ TDIOPrintHeader }

constructor TDIOPrintHeader.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintHeader.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintHeader;
end;

{ TDIOPrintTrailer }

constructor TDIOPrintTrailer.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintTrailer.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintHeader;
end;

{ TDIOZReport }

constructor TDIOZReport.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOZReport.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.SaveZReportFile;
end;

{ TDIOZReportXML }

constructor TDIOZReportXML.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOZReportXML.DirectIO(var pData: Integer;
  var pString: WideString);
var
  FileName: WideString;
  ZReport: TZReport;
begin
  FileName := pString;
  ZReport := TZReport.Create(Printer.Device);
  try
    ZReport.Read;
    ZReport.SaveToXml(FileName);
  except
    on E: Exception do
    begin
      Logger.Error(GetExceptionMessage(E));
    end;
  end;
  ZReport.Free;
end;

{ TDIOZReportCSV }

constructor TDIOZReportCSV.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOZReportCSV.DirectIO(var pData: Integer;
  var pString: WideString);
var
  FileName: WideString;
  ZReport: TZReport;
begin
  FileName := pString;
  ZReport := TZReport.Create(Printer.Device);
  try
    ZReport.Read;
    ZReport.SaveToCSV(FileName);
  except
    on E: Exception do
    begin
      Logger.Error(GetExceptionMessage(E));
    end;
  end;
  ZReport.Free;
end;

{ TDIOGetLastError }

constructor TDIOGetLastError.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetLastError.DirectIO(
  var pData: Integer;
  var pString: WideString);
begin
  pData := Printer.LastErrorCode;
  pString := Printer.LastErrorText;
end;

{ TDIOGetPrinterStation }

constructor TDIOGetPrinterStation.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetPrinterStation.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := FPrinter.Printer.Station;
end;

{ TDIOSetPrinterStation }

constructor TDIOSetPrinterStation.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSetPrinterStation.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Printer.Station := pData;
end;

{ TDIOGetDriverParameter }

constructor TDIOGetDriverParameter.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetDriverParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  case pData of
    DriverParameterStorage: pString := IntToStr(Printer.Parameters.Storage);
    DriverParameterBaudRate: pString := IntToStr(Printer.Parameters.BaudRate);
    DriverParameterPortNumber: pString := IntToStr(Printer.Parameters.PortNumber);
    DriverParameterFontNumber: pString := IntToStr(Printer.Parameters.FontNumber);
    DriverParameterSysPassword: pString := IntToStr(Printer.Parameters.SysPassword);
    DriverParameterUsrPassword: pString := IntToStr(Printer.Parameters.UsrPassword);
    DriverParameterByteTimeout: pString := IntToStr(Printer.Parameters.ByteTimeout);
    DriverParameterStatusInterval: pString := IntToStr(Printer.Parameters.StatusInterval);
    DriverParameterSubtotalText: pString := Printer.Parameters.SubtotalText;
    DriverParameterCloseRecText: pString := Printer.Parameters.CloseRecText;
    DriverParameterVoidRecText: pString := Printer.Parameters.VoidRecText;
    DriverParameterPollInterval: pString := IntToStr(Printer.Parameters.PollIntervalInSeconds);
    DriverParameterMaxRetryCount: pString := IntToStr(Printer.Parameters.MaxRetryCount);
    DriverParameterDeviceByteTimeout: pString := IntToStr(Printer.Parameters.DeviceByteTimeout);
    DriverParameterSearchByPortEnabled: pString := BoolToStr(Printer.Parameters.SearchByPortEnabled);
    DriverParameterSearchByBaudRateEnabled: pString := BoolToStr(Printer.Parameters.SearchByBaudRateEnabled);
    DriverParameterPropertyUpdateMode: pString := IntToStr(Printer.Parameters.PropertyUpdateMode);
    DriverParameterCutType: pString := IntToStr(Printer.Parameters.CutType);
    DriverParameterLogMaxCount: pString := IntToStr(Printer.Parameters.LogMaxCount);
    DriverParameterEncoding: pString := IntToStr(Printer.Parameters.Encoding);
    DriverParameterRemoteHost: pString := Printer.Parameters.RemoteHost;
    DriverParameterRemotePort: pString := IntToStr(Printer.Parameters.RemotePort);
    DriverParameterHeaderType: pString := IntToStr(Printer.Parameters.HeaderType);
    DriverParameterHeaderFont: pString := IntToStr(Printer.Parameters.HeaderFont);
    DriverParameterTrailerFont: pString := IntToStr(Printer.Parameters.TrailerFont);
    DriverParameterTrainModeText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainModeText);
    DriverParameterLogoPosition: pString := IntToStr(Printer.Parameters.LogoPosition);
    DriverParameterTrainSaleText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainSaleText);
    DriverParameterTrainPay2Text: pString := Printer.Parameters.GetPrinterMessage(MsgTrainPay2Text);
    DriverParameterTrainPay3Text: pString := Printer.Parameters.GetPrinterMessage(MsgTrainPay3Text);
    DriverParameterTrainPay4Text: pString := Printer.Parameters.GetPrinterMessage(MsgTrainPay4Text);
    DriverParameterStatusCommand: pString := IntToStr(Printer.Parameters.StatusCommand);
    DriverParameterTrainTotalText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainTotalText);
    DriverParameterConnectionType: pString := IntToStr(Printer.Parameters.ConnectionType);
    DriverParameterLogFileEnabled: pString := BoolToStr(Printer.Parameters.LogFileEnabled);
    DriverParameterNumHeaderLines: pString := IntToStr(Printer.Parameters.NumHeaderLines);
    DriverParameterTrainChangeText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainChangeText);
    DriverParameterTrainStornoText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainStornoText);
    DriverParameterTrainCashInText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainCashInText);
    DriverParameterNumTrailerLines: pString := IntToStr(Printer.Parameters.NumTrailerLines);
    DriverParameterTrainCashOutText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainCashOutText);
    DriverParameterTrainVoidRecText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainVoidRecText);
    DriverParameterTrainCashPayText: pString := Printer.Parameters.GetPrinterMessage(MsgTrainCashPayText);
    DriverParameterBarLinePrintDelay: pString := IntToStr(Printer.Parameters.BarLinePrintDelay);
    DriverParameterCompatLevel: pString := IntToStr(Printer.Parameters.CompatLevel);
    DriverParameterHeader: pString := Printer.Parameters.Header;
    DriverParameterTrailer: pString := Printer.Parameters.Trailer;
    DriverParameterLogoSize: pString := IntToStr(Printer.Parameters.LogoSize);
    DriverParameterLogoCenter: pString := BoolToStr(Printer.Parameters.LogoCenter);
    DriverParameterDepartment: pString := IntToStr(Printer.Parameters.Department);
    DriverParameterLogoEnabled: pString := BoolToStr(True);
    DriverParameterHeaderPrinted: pString := BoolToStr(Printer.Parameters.HeaderPrinted);
    DriverParameterReceiptType: pString := IntToStr(Printer.Parameters.ReceiptType);
    DriverParameterZeroReceiptType: pString := IntToStr(Printer.Parameters.ZeroReceiptType);
    DriverParameterZeroReceiptNumber: pString := IntToStr(Printer.Parameters.ZeroReceiptNumber);
    DriverParameterCCOType: pString := IntToStr(Printer.Parameters.CCOType);
    DriverParameterTableEditEnabled: pString := BoolToStr(Printer.Parameters.TableEditEnabled);
    DriverParameterXmlZReportEnabled: pString := BoolToStr(Printer.Parameters.XmlZReportEnabled);
    DriverParameterCsvZReportEnabled: pString := BoolToStr(Printer.Parameters.CsvZReportEnabled);
    DriverParameterXmlZReportFileName: pString := Printer.Parameters.XmlZReportFileName;
    DriverParameterCsvZReportFileName: pString := Printer.Parameters.CsvZReportFileName;
    DriverParameterVoidReceiptOnMaxItems: pString := BoolToStr(Printer.Parameters.VoidReceiptOnMaxItems);
    DriverParameterMaxReceiptItems: pString := IntToStr(Printer.Parameters.MaxReceiptItems);
    DriverParameterJournalPrintHeader: pString := BoolToStr(Printer.Parameters.JournalPrintHeader);
    DriverParameterJournalPrintTrailer: pString := BoolToStr(Printer.Parameters.JournalPrintTrailer);
    DriverParameterCacheReceiptNumber: pString := BoolToStr(Printer.Parameters.CacheReceiptNumber);
    DriverParameterBarLineByteMode: pString := IntToStr(Printer.Parameters.BarLineByteMode);
    DriverParameterLogFilePath: pString := Printer.Parameters.LogFilePath;
    DriverParameterLogFileName: pString := Logger.FileName;

    DriverParameterParam1: pString := Printer.Parameters.Parameter1;
    DriverParameterParam2: pString := Printer.Parameters.Parameter2;
    DriverParameterParam3: pString := Printer.Parameters.Parameter3;
    DriverParameterParam4: pString := Printer.Parameters.Parameter4;
    DriverParameterParam5: pString := Printer.Parameters.Parameter5;
    DriverParameterParam6: pString := Printer.Parameters.Parameter6;
    DriverParameterParam7: pString := Printer.Parameters.Parameter7;
    DriverParameterParam8: pString := Printer.Parameters.Parameter8;
    DriverParameterParam9: pString := Printer.Parameters.Parameter9;
    DriverParameterParam10: pString := Printer.Parameters.Parameter10;
    DriverParameterBarcode: pString := Printer.Parameters.Barcode;
    DriverParameterMarkType: pString := IntToStr(Printer.Parameters.MarkType);
    DriverParameterCorrectionType: pString := IntToStr(Printer.Parameters.CorrectionType);
    DriverParameterCalculationSign: pString := IntToStr(Printer.Parameters.CalculationSign);
    DriverParameterAmount2: pString := IntToStr(Printer.Parameters.Amount2);
    DriverParameterAmount3: pString := IntToStr(Printer.Parameters.Amount3);
    DriverParameterAmount4: pString := IntToStr(Printer.Parameters.Amount4);
    DriverParameterAmount5: pString := IntToStr(Printer.Parameters.Amount5);
    DriverParameterAmount6: pString := IntToStr(Printer.Parameters.Amount6);
    DriverParameterAmount7: pString := IntToStr(Printer.Parameters.Amount7);
    DriverParameterAmount8: pString := IntToStr(Printer.Parameters.Amount8);
    DriverParameterAmount9: pString := IntToStr(Printer.Parameters.Amount9);
    DriverParameterAmount10: pString := IntToStr(Printer.Parameters.Amount10);
    DriverParameterAmount11: pString := IntToStr(Printer.Parameters.Amount11);
    DriverParameterAmount12: pString := IntToStr(Printer.Parameters.Amount12);
    DriverParameterTaxType: pString := IntToStr(Printer.Parameters.TaxType);
    DriverParameterMessage: pString := _(pString);
    DriverParameterErrorMessage: pString := GetErrorText(StrToInt(pString), True);
    DriverParameterDiscountMode: pString := '0';
    DriverParameterCapFiscalStorage: pString := BoolToStr(Printer.Device.CapFiscalStorage);
    DriverParameterLastDocMac: pString := IntToStr(Printer.Device.LastDocMac);
    DriverParameterLastDocNum: pString := IntToStr(Printer.Device.LastDocNumber);
    DriverParameterLastDocTotal: pString := IntToStr(Printer.Device.LastDocTotal);
    DriverParameterLastDocDateTime: pString := EncodeOposDate(
      PrinterDateTimeToOposDate(Printer.Device.LastDocDate,
      Printer.Device.LastDocTime));
  end;
end;

{ TDIOSetDriverParameter }

constructor TDIOSetDriverParameter.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSetDriverParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  case pData of
    DriverParameterStorage: Parameters.Storage := StrToInt(pString);
    DriverParameterBaudRate: Parameters.BaudRate := StrToInt(pString);
    DriverParameterPortNumber: Parameters.PortNumber := StrToInt(pString);
    DriverParameterFontNumber: Parameters.FontNumber := StrToInt(pString);
    DriverParameterSysPassword: Parameters.SysPassword := StrToInt(pString);
    DriverParameterUsrPassword: Parameters.UsrPassword := StrToInt(pString);
    DriverParameterByteTimeout: Parameters.ByteTimeout := StrToInt(pString);
    DriverParameterStatusInterval: Parameters.StatusInterval := StrToInt(pString);
    DriverParameterSubtotalText: Parameters.SubtotalText := pString;
    DriverParameterCloseRecText: Parameters.CloseRecText := pString;
    DriverParameterVoidRecText: Parameters.VoidRecText := pString;
    DriverParameterPollInterval: Parameters.PollIntervalInSeconds := StrToInt(pString);
    DriverParameterMaxRetryCount: Parameters.MaxRetryCount := StrToInt(pString);
    DriverParameterDeviceByteTimeout: Parameters.DeviceByteTimeout := StrToInt(pString);
    DriverParameterSearchByPortEnabled: Parameters.SearchByPortEnabled := StrToBool(pString);
    DriverParameterSearchByBaudRateEnabled: Parameters.SearchByBaudRateEnabled := StrToBool(pString);
    DriverParameterPropertyUpdateMode: Parameters.PropertyUpdateMode := StrToInt(pString);
    DriverParameterCutType: Parameters.CutType := StrToInt(pString);
    DriverParameterLogMaxCount: Parameters.LogMaxCount := StrToInt(pString);
    DriverParameterEncoding: Parameters.Encoding := StrToInt(pString);
    DriverParameterRemoteHost: Parameters.RemoteHost := pString;
    DriverParameterRemotePort: Parameters.RemotePort := StrToInt(pString);
    DriverParameterHeaderType: Parameters.HeaderType := StrToInt(pString);
    DriverParameterHeaderFont: Parameters.HeaderFont := StrToInt(pString);
    DriverParameterTrailerFont: Parameters.TrailerFont := StrToInt(pString);
    DriverParameterTrainModeText: Parameters.SetPrinterMessage(MsgTrainModeText, pString);
    DriverParameterLogoPosition: Parameters.LogoPosition := StrToInt(pString);
    DriverParameterTrainSaleText: Parameters.SetPrinterMessage(MsgTrainSaleText, pString);
    DriverParameterTrainPay2Text: Parameters.SetPrinterMessage(MsgTrainPay2Text, pString);
    DriverParameterTrainPay3Text: Parameters.SetPrinterMessage(MsgTrainPay3Text, pString);
    DriverParameterTrainPay4Text: Parameters.SetPrinterMessage(MsgTrainPay4Text, pString);
    DriverParameterStatusCommand: Parameters.StatusCommand := StrToInt(pString);
    DriverParameterTrainTotalText: Parameters.SetPrinterMessage(MsgTrainTotalText, pString);
    DriverParameterConnectionType: Parameters.ConnectionType := StrToInt(pString);
    DriverParameterLogFileEnabled: Parameters.LogFileEnabled := StrToBool(pString);
    DriverParameterNumHeaderLines: Parameters.NumHeaderLines := StrToInt(pString);
    DriverParameterTrainChangeText: Parameters.SetPrinterMessage(MsgTrainChangeText, pString);
    DriverParameterTrainStornoText: Parameters.SetPrinterMessage(MsgTrainStornoText, pString);
    DriverParameterTrainCashInText: Parameters.SetPrinterMessage(MsgTrainCashInText, pString);
    DriverParameterNumTrailerLines: Parameters.NumTrailerLines := StrToInt(pString);
    DriverParameterTrainCashOutText: Parameters.SetPrinterMessage(MsgTrainCashOutText, pString);
    DriverParameterTrainVoidRecText: Parameters.SetPrinterMessage(MsgTrainVoidRecText, pString);
    DriverParameterTrainCashPayText: Parameters.SetPrinterMessage(MsgTrainCashPayText, pString);
    DriverParameterBarLinePrintDelay: Parameters.BarLinePrintDelay := StrToInt(pString);
    DriverParameterCompatLevel: Parameters.CompatLevel := StrToInt(pString);
    DriverParameterHeader: Parameters.Header := pString;
    DriverParameterTrailer: Parameters.Trailer := pString;
    DriverParameterLogoSize: Parameters.LogoSize := StrToInt(pString);
    DriverParameterLogoCenter: Parameters.LogoCenter := StrToBool(pString);
    DriverParameterDepartment: Parameters.Department := StrToInt(pString);
    DriverParameterLogoEnabled: ;
    DriverParameterHeaderPrinted: Parameters.HeaderPrinted := StrToBool(pString);
    DriverParameterReceiptType: Parameters.ReceiptType := StrToInt(pString);
    DriverParameterZeroReceiptType: Parameters.ZeroReceiptType := StrToInt(pString);
    DriverParameterZeroReceiptNumber: Parameters.ZeroReceiptNumber := StrToInt(pString);
    DriverParameterCCOType: Parameters.CCOType := StrToInt(pString);

    DriverParameterTableEditEnabled: Parameters.TableEditEnabled := StrToBool(pString);
    DriverParameterXmlZReportEnabled: Parameters.XmlZReportEnabled := StrToBool(pString);
    DriverParameterCsvZReportEnabled: Parameters.CsvZReportEnabled := StrToBool(pString);
    DriverParameterXmlZReportFileName: Parameters.XmlZReportFileName := pString;
    DriverParameterCsvZReportFileName: Parameters.CsvZReportFileName := pString;
    DriverParameterVoidReceiptOnMaxItems: Parameters.VoidReceiptOnMaxItems := StrToBool(pString);
    DriverParameterMaxReceiptItems: Parameters.VoidReceiptOnMaxItems := StrToBool(pString);
    DriverParameterJournalPrintHeader: Parameters.JournalPrintHeader := StrToBool(pString);
    DriverParameterJournalPrintTrailer: Parameters.JournalPrintTrailer := StrToBool(pString);
    DriverParameterCacheReceiptNumber: Parameters.CacheReceiptNumber := StrToBool(pString);
    DriverParameterBarLineByteMode: Parameters.BarLineByteMode := StrToInt(pString);
    DriverParameterLogFilePath: Parameters.LogFilePath := pString;

    DriverParameterParam1: Parameters.Parameter1 := pString;
    DriverParameterParam2: Parameters.Parameter2 := pString;
    DriverParameterParam3: Parameters.Parameter3 := pString;
    DriverParameterParam4: Parameters.Parameter4 := pString;
    DriverParameterParam5: Parameters.Parameter5 := pString;
    DriverParameterParam6: Parameters.Parameter6 := pString;
    DriverParameterParam7: Parameters.Parameter7 := pString;
    DriverParameterParam8: Parameters.Parameter8 := pString;
    DriverParameterParam9: Parameters.Parameter9 := pString;
    DriverParameterParam10: Parameters.Parameter10 := pString;
    DriverParameterBarcode: Parameters.Barcode := pString;
    DriverParameterMarkType: Parameters.MarkType := StrToInt(pString);
    DriverParameterCorrectionType: Parameters.CorrectionType := StrToInt(pString);
    DriverParameterCalculationSign: Parameters.CalculationSign := StrToInt(pString);
    DriverParameterAmount2: Parameters.Amount2 := StrToInt(pString);
    DriverParameterAmount3: Parameters.Amount3 := StrToInt(pString);
    DriverParameterAmount4: Parameters.Amount4 := StrToInt(pString);
    DriverParameterAmount5: Parameters.Amount5 := StrToInt(pString);
    DriverParameterAmount6: Parameters.Amount6 := StrToInt(pString);
    DriverParameterAmount7: Parameters.Amount7 := StrToInt(pString);
    DriverParameterAmount8: Parameters.Amount8 := StrToInt(pString);
    DriverParameterAmount9: Parameters.Amount9 := StrToInt(pString);
    DriverParameterAmount10: Parameters.Amount10 := StrToInt(pString);
    DriverParameterAmount11: Parameters.Amount11 := StrToInt(pString);
    DriverParameterAmount12: Parameters.Amount12 := StrToInt(pString);
    DriverParameterTaxType: Parameters.TaxType := StrToInt(pString);
    DriverParameterDiscountMode: ;
    DriverParameterCapFiscalStorage: FPrinter.Device.CapFiscalStorage := StrToBool(pString);
  end;
end;

function TDIOSetDriverParameter.GetParameters: TPrinterParameters;
begin
  Result := FPrinter.Parameters;
end;

{ TDIOPrintSeparator }

constructor TDIOPrintSeparator.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintSeparator.DirectIO(var pData: Integer;
  var pString: WideString);
var
  V, Code: Integer;
  SeparatorType: Integer;
  SeparatorHeight: Integer;
begin
  if pData <= 0 then Exit;
  SeparatorHeight := pData;
  SeparatorType := DIO_SEPARATOR_BLACK;
  if pString <> '' then
  begin
    Val(pString, V, Code);
    if Code = 0 then
      SeparatorType := V;
  end;
  Printer.Printer.PrintSeparator(SeparatorType, SeparatorHeight);
end;

(*
ØÒÐÈÕ-Ì-ÔÐ-Ê
ÊÊÌ 000012345678 ÈÍÍ 000000012345
ÝÊËÇ 1234560701
ÈÒÎÃ ÀÊÒÈÂÈÇÀÖÈÈ
16/09/13 14:00 ÇÀÊÐÛÒÈÅ ÑÌÅÍÛ 0000
ÐÅÃÈÑÒÐÀÖÈÎÍÍÛÉ ÍÎÌÅÐ       000000123456
00000001 #060344
*)

{ TDIOReadEJActivation }

constructor TDIOReadEJActivation.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function GetParam(const S: WideString; N: Integer): WideString;
var
  i: Integer;
  Tocken: WideString;
  WasSeparator: Boolean;
  TockenNumber: Integer;
begin
  Result := '';
  Tocken := '';
  TockenNumber := 1;
  WasSeparator := False;
  for i := 1 to Length(S) do
  begin
    if S[i] = ' ' then
    begin
      if TockenNumber = N then Break;
      WasSeparator := True;
    end else
    begin
      if WasSeparator then
      begin
        Tocken := '';
        Inc(TockenNumber);
        WasSeparator := False;
      end;
      Tocken := Tocken + S[i];
    end;
  end;
  Result := Tocken;
end;

function ParamsToDate(Params: TTntStrings): WideString;
var
  Date, Time: WideString;
  OposDate: TOposDate;
begin
  Result := '';
  if Params.Count >= 5 then
  begin
    Date := Params[4];
    Time := Params[5];
    OposDate.Day := StrToInt(Copy(Date, 1, 2));
    OposDate.Month := StrToInt(Copy(Date, 4, 2));
    OposDate.Year := 2000 + StrToInt(Copy(Date, 7, 2));
    OposDate.Hour := StrToInt(Copy(Time, 1, 2));
    OposDate.Min := StrToInt(Copy(Time, 4, 2));
    Result := EncodeOposDate(OposDate);
  end;
end;

function ParamsToString(Params: TTntStrings): WideString;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Params.Count-1 do
  begin
    Result := Result + Params[i] + ';';
  end;
end;

procedure TDIOReadEJActivation.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Lines: TTntStrings;
  Params: TTntStrings;
const
  Delimiters: TSetOfChar = [' '];
begin
  pString := '';
  Lines := TTntStringList.Create;
  Params := TTntStringList.Create;
  try
    Lines.Text := Printer.ReadEJActivation;
    if Lines.Count >= 7 then
    begin
      Params.Add(Lines[0]);              // ØÒÐÈÕ-Ì-ÔÐ-Ê
      Params.Add(GetParam(Lines[1], 2)); // 000012345678
      Params.Add(GetParam(Lines[1], 4)); // 000000012345
      Params.Add(GetParam(Lines[2], 2)); // 1234560701
      Params.Add(GetParam(Lines[4], 1)); // 16/09/13
      Params.Add(GetParam(Lines[4], 2)); // 14:00
      Params.Add(GetParam(Lines[4], 5)); // 0000
      Params.Add(GetParam(Lines[5], 3)); // 000000123456
      Params.Add(GetParam(Lines[6], 1)); // 00000001
      Params.Add(GetParam(Lines[6], 2)); // #060344

      case pData of
        ParamReadEJActivationAll: pString := ParamsToString(Params);
        ParamReadEJActivationDate: pString := ParamsToDate(Params);
      else
        pString := ParamsToString(Params);
      end;
    end;
  finally
    Lines.Free;
    Params.Free;
  end;
end;

{ TDIOReadFMTotals }

constructor TDIOReadFMTotals.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadFMTotals.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Totals: TFMTotals;
begin
  pString := '';
  Printer.Device.Check(Printer.Device.ReadFMTotals(pData, Totals));
  pString := Tnt_WideFormat('%d;%d;%d;%d', [Totals.SaleTotal, Totals.BuyTotal,
    Totals.RetSale, Totals.RetBuy]);
end;

{ TDIOReadGrandTotals }

constructor TDIOReadGrandTotals.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadGrandTotals.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Totals: TFMTotals;
begin
  Totals := Printer.Device.ReadFPTotals(pData);
  pString := Tnt_WideFormat('%d;%d;%d;%d', [
    Totals.SaleTotal, Totals.BuyTotal, Totals.RetSale, Totals.RetBuy]);
end;

{ TDIOPrintImage }

constructor TDIOPrintImage.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintImage.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintImage(pString);
end;

{ TDIOPrintImageScale }

constructor TDIOPrintImageScale.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintImageScale.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.PrintImageScale(pString, pData);
end;

{ TDIOReadFSParameter }

constructor TDIOReadFSParameter.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOReadFSParameter.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

procedure TDIOReadFSParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := FPrinter.ReadFSParameter(pData, pString);
end;

{ TDIOReadFPParameter }

constructor TDIOReadFPParameter.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOReadFPParameter.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

procedure TDIOReadFPParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Device.ReadFPParameter(pData);
end;

{ TDIOWriteFPParameter }

constructor TDIOWriteFPParameter.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWriteFPParameter.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.WriteFPParameter(pData, pString);
end;

{ TDIOWriteCustomerAddress }

constructor TDIOWriteCustomerAddress.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOWriteCustomerAddress.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

procedure TDIOWriteCustomerAddress.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.WriteCustomerAddress(pString);
end;

{ TDIOWriteTlvData }

constructor TDIOWriteTlvData.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOWriteTlvData.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

procedure TDIOWriteTlvData.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Device.FSWriteTlv2(pString);
end;

{ TDIOWriteStringTag }

constructor TDIOWriteStringTag.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOWriteStringTag.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

procedure TDIOWriteStringTag.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTag(pData, pString);
end;

{ TDIOSetAdjustmentAmount }

constructor TDIOSetAdjustmentAmount.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOSetAdjustmentAmount.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

procedure TDIOSetAdjustmentAmount.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.SetAdjustmentAmount(pData);
end;

{ TDIODisableNextHeader }

constructor TDIODisableNextHeader.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIODisableNextHeader.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.DisableNextHeader;
end;

function TDIODisableNextHeader.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

{ TDIOWriteTableFile }

constructor TDIOWriteTableFile.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWriteTableFile.DirectIO(var pData: Integer;
  var pString: WideString);
var
  TableFilePath: WideString;
begin
  TableFilePath := pString;
  FPrinter.Device.LoadTables(TableFilePath);
end;

{ TDIOFSReadDocument }

constructor TDIOFSReadDocument.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOFSReadDocument.DirectIO(var pData: Integer;
  var pString: WideString);

  function GetDocMac(const R: TFSDocument): Int64;
  begin
    Result := 0;
    case R.DocType of
      1: Result := R.DocType1.DocMac;
      2: Result := R.DocType2.DocMac;
      3: Result := R.DocType3.DocMac;
      4: Result := R.DocType3.DocMac;
      5: Result := R.DocType2.DocMac;
      6: Result := R.DocType6.DocMac;
      11: Result := R.DocType11.DocMac;
      21: Result := R.DocType21.DocMac;
      31: Result := R.DocType3.DocMac;
    end;
  end;

var
  Ticket: TFSTicket;
  DocNumber: Integer;
  Document: TFSDocument;
begin
  DocNumber := pData;
  FPrinter.Device.Check(FPrinter.Device.FSFindDocument(DocNumber, Document));
  pString := Tnt_WideFormat('%d;%d;%d;', [
    Document.DocType, BoolToInt[Document.TicketReceived], GetDocMac(Document)]);

  if Document.TicketReceived then
  begin
    Ticket.Number := DocNumber;
    FPrinter.Device.Check(FPrinter.Device.FSReadTicket(Ticket));
    pString := pString + TicketToStr(Ticket);
  end;
end;

{ TDIOFSPrintCalcReport }

constructor TDIOFSPrintCalcReport.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOFSPrintCalcReport.DirectIO(var pData: Integer;
  var pString: WideString);
var
  R: TFSCalcReport;
begin
  FPrinter.Device.Check(FPrinter.Device.FSPrintCalcReport(R));
  FPrinter.PrintReportEnd;
end;

(*
  DIO_OPEN_CASH_DRAWER          = 50; // Open cash drawer
  DIO_READ_CASH_DRAWER_STATE    = 51; // Read cash drawer state
*)

{ TDIOOpenCashDrawer }

constructor TDIOOpenCashDrawer.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOOpenCashDrawer.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.OpenDrawer(pData);
end;

{ TDIOReadCashDrawerState }

constructor TDIOReadCashDrawerState.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadCashDrawerState.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pData := BoolToInt[FPrinter.Device.ReadPrinterStatus.Flags.DrawerOpened];
end;

{ TDIOFSFiscalize }

constructor TDIOFSFiscalize.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOFSFiscalize.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TFSFiscalization;
  R: TFDDocument;
begin
  P.TaxID := GetString(pString, 1, ValueDelimiters);
  P.RegID := GetString(pString, 2, ValueDelimiters);
  P.TaxCode := GetInteger(pString, 3, ValueDelimiters);
  P.WorkMode := GetInteger(pString, 4, ValueDelimiters);
  FPrinter.Device.Check(FPrinter.Device.FSFiscalization(P, R));
  pString := Tnt_WideFormat('%s;%s', [IntToStr(R.DocNumber), IntToStr(R.DocMac)]);
end;

{ TDIOFSReFiscalize }

constructor TDIOFSReFiscalize.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOFSReFiscalize.DirectIO(var pData: Integer;
  var pString: WideString);
var
  P: TFSReFiscalization;
  R: TFDDocument;
begin
  P.TaxID := GetString(pString, 1, ValueDelimiters);
  P.RegID := GetString(pString, 2, ValueDelimiters);
  P.TaxCode := GetInteger(pString, 3, ValueDelimiters);
  P.WorkMode := GetInteger(pString, 4, ValueDelimiters);
  P.ReasonCode := GetInteger(pString, 5, ValueDelimiters);
  FPrinter.Device.Check(FPrinter.Device.FSReFiscalization(P, R));
  pString := Tnt_WideFormat('%s;%s', [IntToStr(R.DocNumber), IntToStr(R.DocMac)]);
end;

{ TDIOGetPrintWidth }

constructor TDIOGetPrintWidth.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOGetPrintWidth.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := IntToStr(FPrinter.Device.GetPrintWidth(pData));
end;

{ TDIOReadFSDocument }

constructor TDIOReadFSDocument.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOReadFSDocument.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := FPrinter.ReadFSDocument(pData);
end;

{ TDIOPrintFSDocument }

constructor TDIOPrintFSDocument.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintFSDocument.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.PrintFSDocument(pData);
end;

{ TDIOPrintCorrection }

constructor TDIOPrintCorrection.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintCorrection.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Data: TFSCorrectionReceipt;
begin
  Data.RecType := GetInteger(pString, 1, ValueDelimiters);
  Data.Total := GetInteger(pString, 2, ValueDelimiters);
  FPrinter.Device.Check(FPrinter.FSPrintCorrectionReceipt(Data));
  pString := Tnt_WideFormat('%d;%d;%d;%d', [
    Data.ResultCode, Data.ReceiptNumber,
    Data.DocumentNumber, Data.DocumentMac]);
end;

{ TDIOPrintCorrection2 }

constructor TDIOPrintCorrection2.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOPrintCorrection2.DirectIO(var pData: Integer;
  var pString: WideString);
var
  Data: TFSCorrectionReceipt2;
begin
  Data.CorrectionType := GetInteger(pString, 1, ValueDelimiters);
  Data.CalculationSign := GetInteger(pString, 2, ValueDelimiters);
  Data.Amount1 := GetInteger(pString, 3, ValueDelimiters);
  Data.Amount2 := GetInteger(pString, 4, ValueDelimiters);
  Data.Amount3 := GetInteger(pString, 5, ValueDelimiters);
  Data.Amount4 := GetInteger(pString, 6, ValueDelimiters);
  Data.Amount5 := GetInteger(pString, 7, ValueDelimiters);
  Data.Amount6 := GetInteger(pString, 8, ValueDelimiters);
  Data.Amount7 := GetInteger(pString, 9, ValueDelimiters);
  Data.Amount8 := GetInteger(pString, 10, ValueDelimiters);
  Data.Amount9 := GetInteger(pString, 11, ValueDelimiters);
  Data.Amount10 := GetInteger(pString, 12, ValueDelimiters);
  Data.Amount11 := GetInteger(pString, 13, ValueDelimiters);
  Data.Amount12 := GetInteger(pString, 14, ValueDelimiters);
  Data.TaxType := GetInteger(pString, 15, ValueDelimiters);
  FPrinter.Device.Check(FPrinter.FSPrintCorrectionReceipt2(Data));
  pString := Tnt_WideFormat('%d;%d;%d;%d', [
    Data.ResultCode, Data.ReceiptNumber,
    Data.DocumentNumber, Data.DocumentMac]);
end;

{ TDIOStartOpenDay }

constructor TDIOStartOpenDay.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOStartOpenDay.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.Check(FPrinter.Device.FSStartOpenDay());
end;

{ TDIOOpenDay }

constructor TDIOOpenDay.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOOpenDay.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.OpenFiscalDay;
end;

{ TDIOCheckItemCode }

constructor TDIOCheckItemCode.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOCheckItemCode.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.Check(FPrinter.Device.CheckItemCode(pString));
end;

{ TDIOStartCorrection }

constructor TDIOStartCorrection.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOStartCorrection.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.Check(FPrinter.Device.FSStartCorrectionReceipt);
end;

{ TDIOWriteTlvOperation }

constructor TDIOWriteTlvOperation.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWriteTlvOperation.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTlvOperation(HexToStr(pString));
end;

{ TDIOWriteTlvHex }

constructor TDIOWriteTlvHex.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOWriteTlvHex.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  FPrinter.Device.FSWriteTlv2(HexToStr(pString));
end;

{ TDIOClearLogo }

constructor TDIOClearLogo.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOClearLogo.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Printer.ClearLogo;
end;

{ TDIOWriteStringTagOp }

constructor TDIOWriteStringTagOp.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

function TDIOWriteStringTagOp.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

procedure TDIOWriteStringTagOp.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTagOperation(pData, pString);
end;


{ TDIOSTLVBegin }

constructor TDIOSTLVBegin.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSTLVBegin.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.STLVBegin(pData);
end;

{ TDIOSTLVAddTag }

constructor TDIOSTLVAddTag.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSTLVAddTag.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.STLVAddTag(pData, pString);
end;

{ TDIOSTLVGetHex }

constructor TDIOSTLVGetHex.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSTLVGetHex.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  pString := Printer.Device.STLVGetHex;
end;

{ TDIOSTLVWrite }

constructor TDIOSTLVWrite.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSTLVWrite.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.Device.FSWriteTLV2(HexToStr(Printer.Device.STLVGetHex));
end;


{ TDIOSTLVWriteOp }

constructor TDIOSTLVWriteOp.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSTLVWriteOp.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.FSWriteTLVOperation(HexToStr(Printer.Device.STLVGetHex));
end;

{ TDIOSetReceiptField }

constructor TDIOSetReceiptField.CreateCommand(AOwner: TDIOHandlers;
  ACommand: Integer; APrinter: TFiscalPrinterImpl);
begin
  inherited Create(AOwner, ACommand);
  FPrinter := APrinter;
end;

procedure TDIOSetReceiptField.DirectIO(var pData: Integer;
  var pString: WideString);
begin
  Printer.SetReceiptField(pData, pString);
end;

end.
