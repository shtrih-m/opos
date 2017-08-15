unit DIODescription;

interface

uses

  // VCL
  SysUtils,
  // This
  DirectIOAPI;

type
  TDirectIODescription = record
    Command: Integer;
    Description: string;
    DescriptionEx: string;
  end;

const
  CRLF = #13#10;
  DIO_CUSTOM_COMMAND = $FFFF;

  DIODescriptions: array[1..33] of TDirectIODescription = (
    (Command: DIO_COMMAND_PRINTER_XML;
     Description: 'XML command';
     DescriptionEx:  'Data: Printer command code' + #13#10 +
                     'String: XML parameters list. Example:' + #13#10 +
                     '<?xml version="1.0" encoding="windows-1251"?>' + #13#10 +
                     '<Params>' + #13#10 +
                     '  <Param>' + #13#10 +
                     '    <Name>Password</Name>' + #13#10 +
                     '    <Value>30</Value>' + #13#10 +
                     '  </Param>' + #13#10 +
                     '</Params>';),

    (Command: DIO_COMMAND_PRINTER_HEX;
      Description: 'HEX command';
      DescriptionEx: 'Data is not used;' + #13#10 +
                     'String: Printer command bytes in HEX format separated with space';),

    (Command: DIO_CHECK_END_DAY;
     Description: 'Check end day';
     DescriptionEx: 'Data and String parameters are not used' + #13#10 +
                    'Result: Data = 1 (Day is over) or Data = 0 (Day is not over)';),

    (Command: DIO_LOAD_LOGO;
     Description: 'Load logo';
     DescriptionEx: 'Data is not used; ' + #13#10 +
                    'String: Image file name'),

    (Command: DIO_PRINT_LOGO;
     Description: 'Print logo';
     DescriptionEx: 'Data and String parameters are not used';),

    (Command: DIO_LOGO_DLG;
      Description: 'Show logo dialog';
      DescriptionEx: 'Data and String parameters are not used';),

    (Command: DIO_PRINT_BARCODE;
     Description: 'Print barcode';
     DescriptionEx: 'Data: Barcode type:(0 - EAN 13; 1 - CODE 128A; 2 - CODE 128B; 3 - CODE 128C)' + #13#10 +
                    'String: Barcode data'),

    (Command: DIO_COMMAND_PRINTER_STR;
     Description: 'String command';
     DescriptionEx: 'Data: Printer command code' + #13#10 +
                    'String: Printer command parameters separated with ";"' ;),

    (Command: DIO_PRINT_TEXT;
     Description: 'Print text';
     DescriptionEx: 'Data: Font number' + #13#10 + 'String: text string';),

    (Command: DIO_WRITE_TAX_NAME;
     Description: 'Write tax name';
     DescriptionEx: 'Data: Tax number';),

    (Command: DIO_READ_TAX_NAME;
     Description: 'Read tax name';
     DescriptionEx: 'Data: Tax number';),

    (Command: DIO_WRITE_PAYMENT_NAME;
     Description: 'Write payment name';
     DescriptionEx: 'Data: Payment number';),

    (Command: DIO_READ_PAYMENT_NAME;
     Description: 'Read payment name';
     DescriptionEx: 'Data: Payment number';),

    (Command: DIO_WRITE_TABLE;
     Description: 'Write table';
     DescriptionEx: 'Data is not used;' + #13#10 +
                    'String: [Table number; Row number; Field number; Field value]';),

    (Command: DIO_READ_TABLE;
     Description: 'Read table';
     DescriptionEx: 'Data is not used;' + #13#10 +
                    'String: [Table number;Row number;Field number]';),

    (Command: DIO_GET_DEPARTMENT;
     Description: 'Get department';
     DescriptionEx: 'Data returns department value;'),

    (Command: DIO_SET_DEPARTMENT;
     Description: 'Set department';
     DescriptionEx: 'Data is department value;'),

    (Command: DIO_READ_CASH_REG;
     Description: 'Read cash register';
     DescriptionEx: 'Data is register number;' + CRLF +
                    'String: register value'),

    (Command: DIO_READ_OPER_REG;
     Description: 'Read operating register';
     DescriptionEx: 'Data is register number;' + CRLF +
                    'String: register value'),

    (Command: DIO_CUSTOM_COMMAND;
     Description: 'Custom command';
     DescriptionEx: '';),

    (Command: DIO_GET_LAST_ERROR;
     Description: 'Read last error code';
     DescriptionEx: 'Data: error code;' + CRLF +
                    'String: error text';),

    (Command: DIO_READ_FM_TOTALS;
     Description: 'Read fiscal memory totals';
     DescriptionEx: 'Data: flags (0- all records, 1- since last fiscalization);' + CRLF +
                    'String: 4 registers values';),

    (Command: DIO_READ_GRAND_TOTALS;
     Description: 'Read GRAND totals';
     DescriptionEx: 'Data: not used;' + CRLF +
                    'String: 4 integer values for 4 receipt types';),

    (Command: DIO_PRINT_IMAGE;
     Description: 'Print image';
     DescriptionEx: 'Data: not used;' + CRLF +
                    'String: image file name';),

    (Command: DIO_PRINT_IMAGE_SCALE;
     Description: 'Print image with scale';
     DescriptionEx: 'Data: image scale;' + CRLF +
                    'String: image file name';),

    (Command: DIO_READ_FPTR_PARAMETER;
     Description: 'Read fiscal printer parameter';
     DescriptionEx: 'Data: parameter identifier;' + CRLF +
     'DIO_FPTR_PARAMETER_QRCODE_ENABLED = 0' + CRLF +
     'DIO_FPTR_PARAMETER_OFD_ADDRESS    = 1' + CRLF +
     'DIO_FPTR_PARAMETER_OFD_PORT       = 2' + CRLF +
     'DIO_FPTR_PARAMETER_OFD_TIMEOUT    = 3' + CRLF +
     'DIO_FPTR_PARAMETER_RNM            = 4' + CRLF +
                    'String: returns parameter value';),

    (Command: DIO_FS_READ_DOCUMENT;
     Description: 'FS: Read fiscal document';
     DescriptionEx: 'Data: fiscal document number;' + CRLF +
     'String: DocType;Ticket;DocData;' + CRLF +
     '  DocType - document type' + CRLF +
     '  TicketReceived - Ticket received flag, 0 or 1' + CRLF +
     '  DocMAC - Document message authentication code' + CRLF +
     '  TicketDate - Ticket date and time' + CRLF +
     '  TicketMAC - Ticket message authentication code' + CRLF +
     '  DocumentNum - Document number' + CRLF +
     '  TicketData - Ticket data in hex format'
     ;),

    (Command: DIO_FS_PRINT_CALC_REPORT;
     Description: 'FS: Print calculation report';
     DescriptionEx: 'Data: not used' + CRLF +
     'String: not used';),

    (Command: DIO_OPEN_CASH_DRAWER;
     Description: 'Open cash drawer';
     DescriptionEx: 'Data: drawer number (usually 0)' + CRLF +
     'String: not used';),

    (Command: DIO_READ_CASH_DRAWER_STATE;
     Description: 'Read cash drawer state';
     DescriptionEx: 'Data: return state (0 - closed, 1 - opened)' + CRLF +
     'String: not used';),

    (Command: DIO_FS_FISCALIZE;
     Description: 'FS fiscalization';
     DescriptionEx: 'Data: not used' + CRLF +
     '[in] String: ' + CRLF +
     'taxID - string 12 chars' + CRLF +
     'regID - string 20 chars' + CRLF +
     'TaxCode - byte' + CRLF +
     'WorkMode - byte' + CRLF +
     '[out] String: ' + CRLF +
     'DocNumber - document number' + CRLF +
     'DocMac - document authentication code';),

    (Command: DIO_FS_REFISCALIZE;
     Description: 'FS refiscalization';
     DescriptionEx: 'Data: not used' + CRLF +
     '[in] String: ' + CRLF +
     'taxID - string 12 chars' + CRLF +
     'regID - string 20 chars' + CRLF +
     'TaxCode - byte' + CRLF +
     'WorkMode - byte' + CRLF +
     'code - refiscalization code' + CRLF +
     '[out] String: ' + CRLF +
     'DocNumber - document number' + CRLF +
     'DocMac - document authentication code';),

    (Command: DIO_GET_PRINT_WIDTH;
     Description: 'Get print width';
     DescriptionEx: 'Data: font number 1..7' + CRLF +
     '[out] String: print width';)
  );

function GetDIODescription(ADIOCommand: Integer): TDirectIODescription;

implementation

function GetDIODescription(ADIOCommand: Integer): TDirectIODescription;
var
  i : Integer;
begin
  for i := Low(DIODescriptions) to High(DIODescriptions) do
  begin
    if DIODescriptions[i].Command = ADIOCommand then
    begin
      Result := DIODescriptions[i];
      Exit;
    end;
  end;
  raise Exception.Create('Invalid DirectIO command parameter');
end;

end.
