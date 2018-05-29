unit PrinterParametersX;

interface

uses
  // this
  LogFile,
  PrinterParameters,
  PrinterParametersReg,
  PrinterParametersRegIBT,
  PrinterParametersIni;

function ReadEncoding(const DeviceName: WideString; Logger: ILogFile): Integer;
procedure LoadParameters(Item: TPrinterParameters; const DeviceName: WideString;
  Logger: ILogFile);

procedure SaveParameters(Item: TPrinterParameters; const DeviceName: WideString;
  Logger: ILogFile);

procedure SaveUsrParameters(Item: TPrinterParameters; const DeviceName: WideString;
  Logger: ILogFile);

var
  LoadParametersEnabled: Boolean = True;

implementation

function ReadEncoding(const DeviceName: WideString; Logger: ILogFile): Integer;
var
  Storage: Integer;
begin
  Storage := TPrinterParametersIni.ReadStorage(DeviceName);
  case Storage of
    StorageIni: Result := ReadEncodingIni(DeviceName, Logger);
    StorageReg: Result := ReadEncodingReg(DeviceName, Logger);
    StorageRegIBT: Result := ReadEncodingRegIBT(DeviceName, Logger);
  else
    Result := ReadEncodingReg(DeviceName, Logger);
  end;
end;

procedure LoadParameters(Item: TPrinterParameters; const DeviceName: WideString;
  Logger: ILogFile);
begin
  if not LoadParametersEnabled then Exit;
  Item.Storage := TPrinterParametersIni.ReadStorage(DeviceName);
  case Item.Storage of
    StorageIni    : LoadParametersIni(Item, DeviceName, Logger);
    StorageReg    : LoadParametersReg(Item, DeviceName, Logger);
    StorageRegIBT : LoadParametersRegIBT(Item, DeviceName, Logger);
  else
    LoadParametersReg(Item, DeviceName, Logger);
  end;
end;

procedure SaveParameters(Item: TPrinterParameters; const DeviceName: WideString;
  Logger: ILogFile);
begin
  TPrinterParametersIni.SaveStorage(DeviceName, Item.Storage);
  case Item.Storage of
    StorageIni    : SaveParametersIni(Item, DeviceName, Logger);
    StorageReg    : SaveParametersReg(Item, DeviceName, Logger);
    StorageRegIBT : SaveParametersRegIBT(Item, DeviceName, Logger);
  else
    SaveParametersReg(Item, DeviceName, Logger);
  end;
end;

procedure SaveUsrParameters(Item: TPrinterParameters; const DeviceName: WideString;
  Logger: ILogFile);
begin
  case Item.Storage of
    StorageIni    : SaveUsrParametersIni(Item, DeviceName, Logger);
    StorageReg    : SaveUsrParametersReg(Item, DeviceName, Logger);
    StorageRegIBT : SaveUsrParametersRegIBT(Item, DeviceName, Logger);
  else
    SaveUsrParametersReg(Item, DeviceName, Logger);
  end;
end;

end.
