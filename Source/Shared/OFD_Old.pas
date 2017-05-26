unit OFD_Old;

interface
uses
  // VCL
  Sysutils,
  // This
  OFDReport, OFDProtocol, TLV, FormatTLV, OFDOpenSessionReport,
  OFDCloseSessionReport, OFDOperatorConfirmReport, OFDReceiptReport,
  OFDReceiptItem, OFDTax, OFDFiscalizationReport, OFDCloseFNReport,
  TlvSender;

type
  { TOFD }

  TOFD = class
  private
    FEnabled: Boolean;
    FProtocol: TOFDProtocol;
    FResponse: TOFDOperatorConfirmReport;
    function ParseTLV(const AData: string; AParent: TTLV): TTLV;
    function GetHost: string;
    function GetPort: Integer;
    procedure SetHost(const Value: string);
    procedure SetPort(const Value: Integer);
    function GetKKMID: string;
    procedure SetKKMID(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure OpenSession(AParams: TOFDOpenSessionReportParams);
    procedure CloseSession(AParams: TOFDCloseSessionReportParams);
    procedure Fiscalization(AParams: TOFDFiscalizationReportParams);
    procedure CloseFN(AParams: TOFDCloseFNReportParams);
    procedure TestReceipt;
    procedure Send(AReport: TOFDReport);
    procedure Send2(AReport: TOFDReport);

    property Host: string read GetHost write SetHost;
    property Port: Integer read GetPort write SetPort;
    property KKMID: string read GetKKMID write SetKKMID;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Response: TOFDOperatorConfirmReport read FResponse;
  end;

implementation

{ TOFD }

constructor TOFD.Create;
begin
  inherited Create;
  FProtocol := TOFDProtocol.Create;
  FResponse := TOFDOperatorConfirmReport.Create;
end;

destructor TOFD.Destroy;
begin
  FResponse.Free;
  FProtocol.Free;
  inherited;
end;

function TOFD.GetHost: string;
begin
  Result := FProtocol.Host;
end;

function TOFD.GetPort: Integer;
begin
  Result := FProtocol.Port;
end;

procedure TOFD.SetHost(const Value: string);
begin
  FProtocol.Host := Value;
end;

procedure TOFD.SetPort(const Value: Integer);
begin
  FProtocol.Port := Value;
end;

function TOFD.GetKKMID: string;
begin
  Result := FProtocol.KKMID;
end;

procedure TOFD.SetKKMID(const Value: string);
begin
  FProtocol.KKMID := Value;
end;


procedure TOFD.CloseFN(AParams: TOFDCloseFNReportParams);
var
  Report: TOFDCloseFNReport;
begin
  Report := TOFDCloseFNReport.Create(AParams);
  try
    Send(Report);
  finally
    Report.Free;
  end;
end;

procedure TOFD.CloseSession(AParams: TOFDCloseSessionReportParams);
var
  Report: TOFDCloseSessionReport;
begin
  Report := TOFDCloseSessionReport.Create(AParams);
  try
    Send(Report);
  finally
    Report.Free;
  end;
end;

procedure TOFD.Fiscalization(AParams: TOFDFiscalizationReportParams);
var
  Report: TOFDFiscalizationReport;
begin
  Report := TOFDFiscalizationReport.Create(AParams);
  try
    Send(Report);
  finally
    Report.Free;
  end;
end;

procedure TOFD.OpenSession(AParams: TOFDOpenSessionReportParams);
var
  Report: TOFDOpenSessionReport;
begin
  Report := TOFDOpenSessionReport.Create(AParams);
  try
    Send(Report);
  finally
    Report.Free;
  end;
end;


function TOFD.ParseTLV(const AData: string; AParent: TTLV): TTLV;
var
  t: Integer;
  i: Integer;
  l: Integer;
  Data: string;
begin
  Result := nil;
  if Length(AData) < 4 then
    raise Exception.Create('TLV length error');

  i := 1;
  while i <= Length(AData) do
  begin
    t := TFormatTLV.ValueTLV2Int(Copy(AData, i, 2));
    Inc(i, 2);
    l := TFormatTLV.ValueTLV2Int(Copy(AData, i, 2));
    Inc(i, 2);
    if (Length(AData) - 4) < l then
      raise Exception.Create('TLV length error');
    Data := Copy(AData, i, l);
    if AParent <> nil then
      Result := TTLV.Create(AParent.Items)
    else
      Result := TTLV.Create(nil);

    Result.Tag := t;
    Result.Len := l;
    Result.Data := Data;
    if  TFormatTLV.GetTypeTLV(t) = tlvSTLV then
      ParseTLV(Data, Result);
    Inc(i, l);
  end;
end;

procedure TOFD.Send2(AReport: TOFDReport);
var
  ResponseStr: string;
  OFDReportTLV: TTLV;
begin
  if not FEnabled then Exit;

  ResponseStr := FProtocol.Send(AReport.Data);
  OFDReportTLV := ParseTLV(ResponseStr, nil);
  Response.Clear;
  try
    Response.Parse(OFDReportTLV);
    if Response.OFDAnswerCode <> 0 then
      raise Exception.Create(OFDErrorToStr(Response.OFDAnswerCode));
  finally
    OFDReportTLV.Free;
  end;
end;

procedure TOFD.Send(AReport: TOFDReport);
var
  Sender: TTlvSender;
begin
  if not FEnabled then Exit;

  Sender := TTlvSender.Create;
  try
    //if not FConnec
    Sender.Init(KKMID);
    Sender.Start(Host, IntToStr(Port));
    Sender.SendPacket(AReport.Data);
    Sender.Stop;
  finally
    Sender.Free;
  end;
end;

procedure TOFD.TestReceipt;
var
  Report: TOFDReceiptReport;
  Params: TOFDReceiptReportParams;
  ItemParams: TOFDReceiptItemRec;
begin
  Params.ReceiptNumber := 1;
  Params.DateTime := Now;
  Params.SessionNumber := 5;
  Params.ReceiptType := 1;
  Params.Cashier := 'Петров';
  Params.KKTNumber := '12000005';
  Params.FNSerial := '1517';
  Params.Total := 800000;
  Params.Cash := 800000;
  Params.ElectronicPay := 0;
  Params.FiscalDocumentNumber := 53;
  Params.DocumentFiscalSign := 1;
  Report := TOFDReceiptReport.Create(Params);

  ItemParams.WareName := 'Товар72';
  ItemParams.Barcode := '12345678';
  ItemParams.Price := 100025;
  ItemParams.Quantity := 1;
  ItemParams.DiscountPercent := 0;
  ItemParams.ChargePercent := 0;
  ItemParams.DiscountAmount := 0;
  ItemParams.ChargeAmount := 0;
  ItemParams.TotalAmount := 100000;
  ItemParams.TaxSystem := 1;
  Report.ReceiptItems.AddSale(ItemParams);

  ItemParams.WareName := 'Товар2';
  ItemParams.Barcode := '12345679';
  ItemParams.Price := 100078;
  ItemParams.Quantity := 1;
  ItemParams.DiscountPercent := 0;
  ItemParams.ChargePercent := 0;
  ItemParams.DiscountAmount := 0;
  ItemParams.ChargeAmount := 0;
  ItemParams.TotalAmount := 100000;
  ItemParams.TaxSystem := 1;
  Report.ReceiptItems.AddSale(ItemParams);
  try
    Send(Report);
  finally
    Report.Free;
  end;
end;

end.
