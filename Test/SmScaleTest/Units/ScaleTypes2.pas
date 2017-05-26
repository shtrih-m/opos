unit ScaleTypes2;

interface

type
  { TOposScaleState }

  TOposScaleState = record
    State: Integer;
    Claimed: Integer;
    DeviceName: string;
    DeviceClass: string;
    AutoDisable: Integer;
    CapCompareFirmwareVersion: Integer;
    CapPowerReporting: Integer;
    CapStatisticsReporting: Integer;
    CapUpdateFirmware: Integer;
    CapUpdateStatistics: Integer;
    CheckHealthText: string;
    DataCount: Integer;
    DataEventEnabled: Integer;
    DeviceEnabled: Integer;
    FreezeEvents: Integer;
    OutputID: Integer;
    PowerNotify: Integer;
    PowerState: Integer;
    ServiceObjectDescription: string;
    ServiceObjectVersion: Integer;
    PhysicalDeviceDescription: string;
    PhysicalDeviceName: string;
    BinaryConversion: Integer;
    ResultCode: Integer;
    ErrorString: string;
    ResultCodeExtended: Integer;
    OpenResult: Integer;
    CapDisplay: Integer;
    CapZeroScale: Integer;
    CapTareWeight: Integer;
    CapDisplayText: Integer;
    CapStatusUpdate: Integer;
    CapPriceCalculating: Integer;
    MaximumWeight: Integer;
    WeightUnits: Integer;
    AsyncMode: Integer;
    MaxDisplayTextChars: Integer;
    TareWeight: Integer;
    ScaleLiveWeight: Integer;
    StatusNotify: Integer;
    ZeroValid: Integer;
    SalesPrice: Currency;
    UnitPrice: Currency;
  end;

implementation

end.
