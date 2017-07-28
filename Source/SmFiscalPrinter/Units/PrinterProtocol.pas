unit PrinterProtocol;

interface

type
  { IPrinterConnection }

  IPrinterConnection = interface
  ['{81688FC8-17A2-4529-ACC9-9FA61B85081A}']

    procedure ClaimDevice(PortNumber, Timeout: Integer);
    procedure ReleaseDevice;

    procedure OpenPort;
    procedure ClosePort;

    procedure OpenReceipt(Password: Integer);
    procedure CloseReceipt;

    function Send(Timeout: Integer; const Data: string): string;
  end;

implementation

end.
