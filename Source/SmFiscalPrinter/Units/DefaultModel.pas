unit DefaultModel;

interface

uses
  // This
  PrinterTypes, DriverTypes, PrinterModel, TableParameter, ParameterValue;

const
  DefaultModelID = -1;

  PrinterModelDefault: TPrinterModelRec = (
    ID: DefaultModelID;
    Name: 'Default model';
    CapShortEcrStatus: False;
    CapCoverSensor: True;
    CapJrnPresent: False;
    CapJrnEmptySensor: False;
    CapJrnNearEndSensor: False;
    CapRecPresent: True;
    CapRecEmptySensor: True;
    CapRecNearEndSensor: True;
    CapSlpFullSlip: False;
    CapSlpEmptySensor: False;
    CapSlpFiscalDocument: False;
    CapSlpNearEndSensor: False;
    CapSlpPresent: False;
    CapSetHeader: True;
    CapSetTrailer: True;
    CapRecLever: False;
    CapJrnLever: False;
    CapFixedTrailer: False;
    CapDisableTrailer: False;
    NumHeaderLines: 4;
    NumTrailerLines: 3;
    StartHeaderLine: 4;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
    PrintWidth: 36;
    MaxGraphicsWidth: 320;
    MaxGraphicsHeight: 255;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
  );

  { PrinterModelShtrihFRF }

  PrinterModelShtrihFRF: TPrinterModelRec = (
		ID: 0;
    Name: 'SHTRIH_FRF';
    CapShortEcrStatus: False;
		CapCoverSensor: True;
		CapJrnPresent: True;
		CapJrnEmptySensor: True;
		CapJrnNearEndSensor: True;
		CapRecPresent: True;
		CapRecEmptySensor: True;
		CapRecNearEndSensor: True;
		CapSlpFullSlip: False;
		CapSlpEmptySensor: False;
		CapSlpFiscalDocument: False;
		CapSlpNearEndSensor: False;
		CapSlpPresent: False;
		CapSetHeader: True;
		CapSetTrailer: True;
		CapRecLever: True;
		CapJrnLever: True;
		CapFixedTrailer: False;
		CapDisableTrailer: True;
		NumHeaderLines: 4;
		NumTrailerLines: 3;
		StartHeaderLine: 4;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 36;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 200;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
    );

  { PrinterModelShtrihFRK }

  PrinterModelShtrihFRK: TPrinterModelRec = (
	  ID: 4;
    Name: 'SHTRIH_FRK';
		CapShortEcrStatus: True;
		CapCoverSensor: True;
		CapJrnPresent: True;
		CapJrnEmptySensor: True;
		CapJrnNearEndSensor: True;
		CapRecPresent: True;
		CapRecEmptySensor: True;
		CapRecNearEndSensor: True;
		CapSlpFullSlip: False;
		CapSlpEmptySensor: False;
		CapSlpFiscalDocument: False;
		CapSlpNearEndSensor: False;
		CapSlpPresent: False;
		CapSetHeader: True;
		CapSetTrailer: True;
		CapRecLever: True;
		CapJrnLever: True;
		CapFixedTrailer: False;
		CapDisableTrailer: False;
		NumHeaderLines: 4;
		NumTrailerLines: 3;
		StartHeaderLine: 12;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 36;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 200;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
    );

  { PrinterModelShtrihMiniFRK }

  PrinterModelShtrihMiniFRK: TPrinterModelRec = (
	  ID: 7;
    Name: 'SHTRIH_MINI_FRK';
		CapShortEcrStatus: True;
		CapCoverSensor: True;
		CapJrnPresent: False;
		CapJrnEmptySensor: False;
		CapJrnNearEndSensor: False;
		CapRecPresent: True;
		CapRecEmptySensor: True;
		CapRecNearEndSensor: True;
		CapSlpFullSlip: False;
		CapSlpEmptySensor: False;
		CapSlpFiscalDocument: False;
		CapSlpNearEndSensor: False;
		CapSlpPresent: False;
		CapSetHeader: True;
		CapSetTrailer: True;
		CapRecLever: False;
		CapJrnLever: False;
		CapFixedTrailer: False;
		CapDisableTrailer: False;
		NumHeaderLines: 4;
		NumTrailerLines: 3;
		StartHeaderLine: 22;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200';
		PrintWidth: 50;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
   );

  { PrinterModelShtrihMFRK }

  PrinterModelShtrihMFRK: TPrinterModelRec = (
	  ID: 250;
    Name: 'SHTRIH_M_FRK';
		CapShortEcrStatus: True;
		CapCoverSensor: True;
		CapJrnPresent: False;
		CapJrnEmptySensor: False;
		CapJrnNearEndSensor: False;
		CapRecPresent: True;
		CapRecEmptySensor: True;
		CapRecNearEndSensor: True;
		CapSlpFullSlip: False;
		CapSlpEmptySensor: False;
		CapSlpFiscalDocument: False;
		CapSlpNearEndSensor: False;
		CapSlpPresent: False;
		CapSetHeader: True;
		CapSetTrailer: True;
		CapRecLever: False;
		CapJrnLever: False;
		CapFixedTrailer: False;
		CapDisableTrailer: False;
		NumHeaderLines: 4;
		NumTrailerLines: 3;
		StartHeaderLine: 11;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 48;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 0;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
    );

  { PrinterModelShtrihMPTK }

  PrinterModelShtrihMPTK: TPrinterModelRec = (
	  ID: 239;
    Name: 'SHTRIH_M_PTK';
		CapShortEcrStatus: True;
		CapCoverSensor: True;
		CapJrnPresent: False;
		CapJrnEmptySensor: False;
		CapJrnNearEndSensor: False;
		CapRecPresent: True;
		CapRecEmptySensor: True;
		CapRecNearEndSensor: True;
		CapSlpFullSlip: False;
		CapSlpEmptySensor: False;
		CapSlpFiscalDocument: False;
		CapSlpNearEndSensor: False;
		CapSlpPresent: False;
		CapSetHeader: True;
		CapSetTrailer: True;
		CapRecLever: False;
		CapJrnLever: False;
		CapFixedTrailer: False;
		CapDisableTrailer: False;
		NumHeaderLines: 4;
		NumTrailerLines: 3;
		StartHeaderLine: 11;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 48;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 0;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
    );

  { PrinterModelShtrihComboFRK }

  PrinterModelShtrihComboFRK: TPrinterModelRec = (
	  ID: 9;
    Name: 'SHTRIH_COMBO_FRK';
		CapShortEcrStatus: True;
		CapCoverSensor: False;
		CapJrnPresent: False;
		CapJrnEmptySensor: False;
		CapJrnNearEndSensor: False;
		CapRecPresent: True;
		CapRecEmptySensor: True;
		CapRecNearEndSensor: True;
		CapSlpFullSlip: True;
		CapSlpEmptySensor: True;
		CapSlpFiscalDocument: True;
		CapSlpNearEndSensor: True;
		CapSlpPresent: True;
		CapSetHeader: True;
		CapSetTrailer: True;
		CapRecLever: False;
		CapJrnLever: False;
		CapFixedTrailer: False;
		CapDisableTrailer: False;
		NumHeaderLines: 5;
		NumTrailerLines: 3;
		StartHeaderLine: 11;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 48;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
    );

  { PrinterModelShtrihComboFRK2 }

  PrinterModelShtrihComboFRK2: TPrinterModelRec = (
	  ID: 12;
    Name: 'SHTRIH_COMBO_FRK';
		CapShortEcrStatus: True;
		CapCoverSensor: False;
		CapJrnPresent: False;
		CapJrnEmptySensor: False;
		CapJrnNearEndSensor: False;
		CapRecPresent: True;
		CapRecEmptySensor: True;
		CapRecNearEndSensor: True;
		CapSlpFullSlip: True;
		CapSlpEmptySensor: True;
		CapSlpFiscalDocument: True;
		CapSlpNearEndSensor: True;
		CapSlpPresent: True;
		CapSetHeader: True;
		CapSetTrailer: True;
		CapRecLever: False;
		CapJrnLever: False;
		CapFixedTrailer: False;
		CapDisableTrailer: False;
		NumHeaderLines: 5;
		NumTrailerLines: 3;
		StartHeaderLine: 11;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 48;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
    );

  { PrinterModelShtrihLightFRK }

  PrinterModelShtrihLightFRK: TPrinterModelRec = (
	  ID: 252;
    Name: 'SHTRIH_LIGHT_FRK';
		CapShortEcrStatus: True;
		CapCoverSensor: True;
		CapJrnPresent: False;
		CapJrnEmptySensor: False;
		CapJrnNearEndSensor: False;
		CapRecPresent: True;
		CapRecEmptySensor: True;
		CapRecNearEndSensor: True;
		CapSlpFullSlip: False;
		CapSlpEmptySensor: False;
		CapSlpFiscalDocument: False;
		CapSlpNearEndSensor: False;
		CapSlpPresent: False;
		CapSetHeader: True;
		CapSetTrailer: True;
		CapRecLever: False;
		CapJrnLever: False;
		CapFixedTrailer: False;
		CapDisableTrailer: False;
		NumHeaderLines: 3;
		NumTrailerLines: 3;
		StartHeaderLine: 12;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 32;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
    );

  MODEL_SHTRIH_950K: TPrinterModelREc = (
    ID: MODEL_ID_SHTRIH_950K;
    Name: 'SHTRIH-950K';
    CapShortEcrStatus: True;
    CapCoverSensor: True;
    CapJrnPresent: True;
    CapJrnEmptySensor: True;
    CapJrnNearEndSensor: True;
    CapRecPresent: True;
    CapRecEmptySensor: True;
    CapRecNearEndSensor: True;
    CapSlpFullSlip: True;
    CapSlpEmptySensor: True;
    CapSlpFiscalDocument: True;
    CapSlpNearEndSensor: True;
    CapSlpPresent: True;
    CapSetHeader: True;
    CapSetTrailer: True;
    CapRecLever: True;
    CapJrnLever: True;
    CapDisableTrailer: False;
    NumHeaderLines: 9;
    NumTrailerLines: 3;
    StartHeaderLine: 6;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;56000;57600;115200';
		PrintWidth: 36;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: False;
    CapNonfiscalDocument: False;
  );

  MODEL_SHTRIH_950_PTK: TPrinterModelRec = (
    ID: MODEL_ID_SHTRIH_950PTK;
    Name: 'SHTRIH-950PTK';
    CapShortEcrStatus: True;
    CapCoverSensor: True;
    CapJrnPresent: True;
    CapJrnEmptySensor: True;
    CapJrnNearEndSensor: True;
    CapRecPresent: True;
    CapRecEmptySensor: True;
    CapRecNearEndSensor: True;
    CapSlpFullSlip: True;
    CapSlpEmptySensor: True;
    CapSlpFiscalDocument: True;
    CapSlpNearEndSensor: True;
    CapSlpPresent: True;
    CapSetHeader: True;
    CapSetTrailer: True;
    CapRecLever: True;
    CapJrnLever: True;
    CapDisableTrailer: False;
    NumHeaderLines: 10;
    NumTrailerLines: 10;
    StartHeaderLine: 1;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 36;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: True;
    CapJournalReport: False;
    CapNonfiscalDocument: True;
  );

  MODEL_SHTRIH_950_PTK2: TPrinterModelRec = (
    ID: MODEL_ID_SHTRIH_950PTK2;
    Name: 'SHTRIH-950PTK2';
    CapShortEcrStatus: True;
    CapCoverSensor: True;
    CapJrnPresent: True;
    CapJrnEmptySensor: True;
    CapJrnNearEndSensor: True;
    CapRecPresent: True;
    CapRecEmptySensor: True;
    CapRecNearEndSensor: True;
    CapSlpFullSlip: True;
    CapSlpEmptySensor: True;
    CapSlpFiscalDocument: True;
    CapSlpNearEndSensor: True;
    CapSlpPresent: True;
    CapSetHeader: True;
    CapSetTrailer: True;
    CapRecLever: True;
    CapJrnLever: True;
    CapDisableTrailer: False;
    NumHeaderLines: 10;
    NumTrailerLines: 10;
    StartHeaderLine: 1;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 36;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 499;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: True;
    CapJournalReport: False;
    CapNonfiscalDocument: True;
  );

  MODEL_RETAIL_01K: TPrinterModelRec = (
    ID: MODEL_ID_RETAIL_01K;
    Name: 'RETAIL-01K';
    CapShortEcrStatus: True;
    CapCoverSensor: True;
    CapJrnPresent: False;
    CapJrnEmptySensor: False;
    CapJrnNearEndSensor: False;
    CapRecPresent: True;
    CapRecEmptySensor: True;
    CapRecNearEndSensor: True;
    CapSlpFullSlip: False;
    CapSlpEmptySensor: False;
    CapSlpFiscalDocument: False;
    CapSlpNearEndSensor: False;
    CapSlpPresent: False;
    CapSetHeader: True;
    CapSetTrailer: True;
    CapRecLever: True;
    CapJrnLever: False;
    CapDisableTrailer: False;
    NumHeaderLines: 4;
    NumTrailerLines: 4;
    StartHeaderLine: 11;
    StartTrailerLine: 1;
    BaudRates: '2400;4800;9600;19200;38400;57600;115200';
		PrintWidth: 20;
		//PrintWidth: 42;
		MaxGraphicsWidth: 320;
		MaxGraphicsHeight: 1200;
    CapFullCut: True;
    CapPartialCut: True;
    CombLineNumber: 10;
    HeaderTableNumber: 4;
    TrailerTableNumber: 4;
    CapAttributes: False;
    CapJournalReport: True;
    CapNonfiscalDocument: False;
  );

procedure AddDefaultModels(Models: TPrinterModels);

implementation

function AddModel(Models: TPrinterModels; const Model: TPrinterModelRec): TPrinterModel;
begin
  Result := Models.ItemByID(Model.ID);
  if Result = nil then
    Result := Models.Add(Model);
end;

procedure AddDefaultModels(Models: TPrinterModels);
var
  Model: TPrinterModel;
  Parameter: TTableParameter;
  ParameterRec: TTableParameterRec;
begin
  AddModel(Models, PrinterModelDefault);
  Model := AddModel(Models, PrinterModelShtrihFRF);
  // PARAMID_PRINT_TRAILER
  ParameterRec.ID := PARAMID_PRINT_TRAILER;
  ParameterRec.Name := 'Print trailer enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 4;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_CUT_TYPE
  ParameterRec.ID := PARAMID_CUT_TYPE;
  ParameterRec.Name := 'Receipt cut type';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 8;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_CUT_NONE, 0);
  Parameter.Values.AddValue(VALUEID_CUT_FULL, 1);
  Parameter.Values.AddValue(VALUEID_CUT_PARTIAL, 2);
  // PARAMID_RECFORMAT_ENABLED
  ParameterRec.ID := PARAMID_RECFORMAT_ENABLED;
  ParameterRec.Name := 'Receipt format enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 33;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_SHORT_Z_REPORT
  ParameterRec.ID := PARAMID_Z_REPORT_TYPE;
  ParameterRec.Name := 'Short Z report';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 40;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_LONG, 0);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_SHORT, 1);


  Model := AddModel(Models, PrinterModelShtrihFRK);
  // PARAMID_PRINT_TRAILER
  ParameterRec.ID := PARAMID_PRINT_TRAILER;
  ParameterRec.Name := 'Print trailer enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 4;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_CUT_TYPE
  ParameterRec.ID := PARAMID_CUT_TYPE;
  ParameterRec.Name := 'Receipt cut type';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 8;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_CUT_NONE, 0);
  Parameter.Values.AddValue(VALUEID_CUT_FULL, 1);
  Parameter.Values.AddValue(VALUEID_CUT_PARTIAL, 2);
  // PARAMID_RECFORMAT_ENABLED
  ParameterRec.ID := PARAMID_RECFORMAT_ENABLED;
  ParameterRec.Name := 'Receipt format enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 33;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_SHORT_Z_REPORT
  ParameterRec.ID := PARAMID_Z_REPORT_TYPE;
  ParameterRec.Name := 'Short Z report';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 40;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_LONG, 0);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_SHORT, 1);

  Model := AddModel(Models, PrinterModelShtrihMiniFRK);
  // PARAMID_PRINT_TRAILER
  ParameterRec.ID := PARAMID_PRINT_TRAILER;
  ParameterRec.Name := 'Print trailer enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 3;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_CUT_TYPE
  ParameterRec.ID := PARAMID_CUT_TYPE;
  ParameterRec.Name := 'Receipt cut type';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 7;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_CUT_NONE, 0);
  Parameter.Values.AddValue(VALUEID_CUT_FULL, 1);
  Parameter.Values.AddValue(VALUEID_CUT_PARTIAL, 2);
  // PARAMID_RECFORMAT_ENABLED
  ParameterRec.ID := PARAMID_RECFORMAT_ENABLED;
  ParameterRec.Name := 'Receipt format enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 26;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_SHORT_Z_REPORT
  ParameterRec.ID := PARAMID_Z_REPORT_TYPE;
  ParameterRec.Name := 'Short Z report';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 35;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_LONG, 0);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_SHORT, 1);

  Model := AddModel(Models, PrinterModelShtrihMFRK);
  // PARAMID_PRINT_TRAILER
  ParameterRec.ID := PARAMID_PRINT_TRAILER;
  ParameterRec.Name := 'Print trailer enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 3;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_CUT_TYPE
  ParameterRec.ID := PARAMID_CUT_TYPE;
  ParameterRec.Name := 'Receipt cut type';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 7;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_CUT_NONE, 0);
  Parameter.Values.AddValue(VALUEID_CUT_FULL, 1);
  Parameter.Values.AddValue(VALUEID_CUT_PARTIAL, 2);
  // PARAMID_RECFORMAT_ENABLED
  ParameterRec.ID := PARAMID_RECFORMAT_ENABLED;
  ParameterRec.Name := 'Receipt format enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 25;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_SHORT_Z_REPORT
  ParameterRec.ID := PARAMID_Z_REPORT_TYPE;
  ParameterRec.Name := 'Short Z report';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 30;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_LONG, 1);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_SHORT, 0);

  AddModel(Models, PrinterModelShtrihMPTK);

  Model := AddModel(Models, PrinterModelShtrihComboFRK);
  // PARAMID_PRINT_TRAILER
  ParameterRec.ID := PARAMID_PRINT_TRAILER;
  ParameterRec.Name := 'Print trailer enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 3;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_CUT_TYPE
  ParameterRec.ID := PARAMID_CUT_TYPE;
  ParameterRec.Name := 'Receipt cut type';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 7;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_CUT_NONE, 0);
  Parameter.Values.AddValue(VALUEID_CUT_FULL, 1);
  Parameter.Values.AddValue(VALUEID_CUT_PARTIAL, 2);
  // PARAMID_RECFORMAT_ENABLED
  ParameterRec.ID := PARAMID_RECFORMAT_ENABLED;
  ParameterRec.Name := 'Receipt format enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 26;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_SHORT_Z_REPORT
  ParameterRec.ID := PARAMID_Z_REPORT_TYPE;
  ParameterRec.Name := 'Short Z report';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 32;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_LONG, 1);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_SHORT, 0);

  Model := AddModel(Models, PrinterModelShtrihComboFRK2);
  // PARAMID_PRINT_TRAILER
  ParameterRec.ID := PARAMID_PRINT_TRAILER;
  ParameterRec.Name := 'Print trailer enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 3;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_CUT_TYPE
  ParameterRec.ID := PARAMID_CUT_TYPE;
  ParameterRec.Name := 'Receipt cut type';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 7;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_CUT_NONE, 0);
  Parameter.Values.AddValue(VALUEID_CUT_FULL, 1);
  Parameter.Values.AddValue(VALUEID_CUT_PARTIAL, 2);
  // PARAMID_RECFORMAT_ENABLED
  ParameterRec.ID := PARAMID_RECFORMAT_ENABLED;
  ParameterRec.Name := 'Receipt format enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 26;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_SHORT_Z_REPORT
  ParameterRec.ID := PARAMID_Z_REPORT_TYPE;
  ParameterRec.Name := 'Short Z report';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 32;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_LONG, 1);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_SHORT, 0);

  Model := AddModel(Models, PrinterModelShtrihLightFRK);
  // PARAMID_PRINT_TRAILER
  ParameterRec.ID := PARAMID_PRINT_TRAILER;
  ParameterRec.Name := 'Print trailer enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 3;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_CUT_TYPE
  ParameterRec.ID := PARAMID_CUT_TYPE;
  ParameterRec.Name := 'Receipt cut type';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 7;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_CUT_NONE, 0);
  Parameter.Values.AddValue(VALUEID_CUT_FULL, 1);
  Parameter.Values.AddValue(VALUEID_CUT_PARTIAL, 2);
  // PARAMID_RECFORMAT_ENABLED
  ParameterRec.ID := PARAMID_RECFORMAT_ENABLED;
  ParameterRec.Name := 'Receipt format enabled';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 25;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_DISABLED, 0);
  Parameter.Values.AddValue(VALUEID_ENABLED, 1);
  // PARAMID_SHORT_Z_REPORT
  ParameterRec.ID := PARAMID_Z_REPORT_TYPE;
  ParameterRec.Name := 'Short Z report';
  ParameterRec.Table := 1;
  ParameterRec.Row := 1;
  ParameterRec.Field := 30;
  Parameter := Model.Parameters.Add(ParameterRec);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_LONG, 1);
  Parameter.Values.AddValue(VALUEID_ZREPORT_TYPE_SHORT, 0);

  AddModel(Models, MODEL_SHTRIH_950K);
  AddModel(Models, MODEL_SHTRIH_950_PTK);
  AddModel(Models, MODEL_SHTRIH_950_PTK2);
  AddModel(Models, MODEL_RETAIL_01K);
end;

end.
