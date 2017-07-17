unit duUniposReader;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  UniposReader, LogFile;

type
  { TUniposReaderTest }

  TUniposReaderTest = class(TTestCase)
  published
    procedure CheckReadHeader;
  end;

implementation

{ TUniposReaderTest }

procedure TUniposReaderTest.CheckReadHeader;
var
  Logger: ILogFile;
  Reader: TUniposReader;
  Data: TTextReceiptRec;
  Data2: TTextReceiptRec;
begin
  Data.NewChequeFlag := True;
  Data.NewChequeText := '123123';
  Data.NewChequeText1 := '234234';

  Logger := TLogFile.Create;
  Reader := TUniposReader.Create(Logger);
  try
    Check(Reader.WriteTextReceipt(Data), 'WriteTextReceipt');
    Data2 := Reader.ReadTextReceipt;
    CheckEquals(Data2.NewChequeFlag, Data.NewChequeFlag, 'NewChequeFlag');
    CheckEquals(Data2.NewChequeText, Data.NewChequeText, 'NewChequeText');
    CheckEquals(Data2.NewChequeText1, Data.NewChequeText1, 'NewChequeText1');
  finally
    Reader.Free;
    Logger := nil;
  end;
end;

initialization
  RegisterTest('', TUniposReaderTest.Suite);

end.
