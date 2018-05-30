unit PrinterPort;

interface

uses
  // VCL
  Windows;

type
  { IPrinterPort }

  IPrinterPort = interface
    procedure Lock;
    procedure Unlock;
    procedure Purge;
    procedure Close;
    procedure Open;
    procedure Write(const Data: AnsiString);
    procedure SetTimeout(Value: DWORD);
    procedure SetBaudRate(Value: DWORD);
    procedure SetCmdTimeout(Value: DWORD);

    function ReadChar(var C: Char): Boolean;
    function Read(Count: DWORD): AnsiString;
    function GetTimeout: DWORD;
    function GetPortName: AnsiString;
    function GetBaudRate: DWORD;

    property PortName: AnsiString read GetPortName;
    property Timeout: DWORD read GetTimeout write SetTimeout;
    property BaudRate: DWORD read GetBaudRate write SetBaudRate;
  end;

implementation

end.
