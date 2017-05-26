unit duM5ScaleTest;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // 3'd
  TestFramework, PascalMock, Opos,
  // This
  M5ScaleTypes, M5ScaleDevice, MockScaleConnection, StringUtils,
  LocalConnection, ScaleTypes;

type
  { TM5ScaleTest }

  TM5ScaleTest = class(TTestCase)
  private
    Device: IM5ScaleDevice;
    Connection: IScaleConnection;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckSalesPrice;
    procedure CheckTareWeight;
  end;

implementation

{ TM5ScaleTest }

procedure TM5ScaleTest.Setup;
begin
  Connection := TLocalConnection.Create;
  Device := TM5ScaleDevice.Create(Connection);
  Device.CommandTimeout := 1000;
  Device.Password := 1;
  Connection.OpenPort(4, 9600, 100);
end;

procedure TM5ScaleTest.TearDown;
begin
  Device := nil;
  Connection := nil;
end;

procedure TM5ScaleTest.CheckSalesPrice;
var
  Amount: Integer;
  Status: TM5Status2;
  Ware: TM5WareItem;
begin
  Device.Check(Device.ReadStatus2(Status));
  if Status.Weight <> 0 then
  begin
    Ware.ItemType := 0;
    Ware.Quantity := 0;
    Ware.Price := 12345;
    Amount := Round(12345*Status.Weight/1000);

    Device.Check(Device.WriteWare(Ware));
    Device.Check(Device.ReadStatus2(Status));
    CheckEquals(0, Status.ItemType, 'Status.ItemType');
    CheckEquals(0, Status.Quantity, 'Status.Quantity');
    CheckEquals(Ware.Price, Status.Price, 'Status.Price');
    CheckEquals(Amount, Status.Amount, 'Status.Amount');
  end;
end;

procedure TM5ScaleTest.CheckTareWeight;
var
  Channel: TScaleChannel;
  Channel2: TScaleChannel;
  ChannelNumber: Integer;
const
  TareWeight = 123;
begin
  Device.Check(Device.ReadChannelNumber(ChannelNumber));
  Channel.Number := ChannelNumber;
  Device.Check(Device.ReadChannel(Channel));
  Channel2 := Channel;
  Channel.MaxTare := TareWeight;
  Device.Check(Device.WriteChannel(Channel));
  Device.Check(Device.ReadChannel(Channel));
  // MaxTare not writed
  CheckEquals(Channel2.MaxTare, Channel.MaxTare, 'TareWeight');
end;

initialization
  RegisterTest('', TM5ScaleTest.Suite);

end.
