/////////////////////////////////////////////////////////////////////////////
// DriverParameterxxx constants

var DriverParameterStorage                  = 0;
var DriverParameterBaudRate                 = 1;
var DriverParameterPortNumber               = 2;
var DriverParameterFontNumber               = 3;
var DriverParameterSysPassword              = 4;
var DriverParameterUsrPassword              = 5;
var DriverParameterByteTimeout              = 6;
var DriverParameterStatusInterval           = 7;
var DriverParameterSubtotalText             = 8;
var DriverParameterCloseRecText             = 9;
var DriverParameterVoidRecText              = 10;
var DriverParameterPollInterval             = 11;
var DriverParameterMaxRetryCount            = 12;
var DriverParameterDeviceByteTimeout        = 13;
var DriverParameterSearchByPortEnabled      = 14;
var DriverParameterSearchByBaudRateEnabled  = 15;
var DriverParameterPropertyUpdateMode       = 16;
var DriverParameterCutType                  = 17;
var DriverParameterLogMaxCount              = 18;
var DriverParameterPayTypes                 = 19;
var DriverParameterEncoding                 = 20;
var DriverParameterRemoteHost               = 21;
var DriverParameterRemotePort               = 22;
var DriverParameterHeaderType               = 23;
var DriverParameterHeaderFont               = 24;
var DriverParameterTrailerFont              = 25;
var DriverParameterTrainModeText            = 26;
var DriverParameterLogoPosition             = 27;
var DriverParameterTrainSaleText            = 28;
var DriverParameterTrainPay2Text            = 29;
var DriverParameterTrainPay3Text            = 30;
var DriverParameterTrainPay4Text            = 31;
var DriverParameterStatusCommand            = 32;
var DriverParameterTrainTotalText           = 33;
var DriverParameterConnectionType           = 34;
var DriverParameterLogFileEnabled           = 35;
var DriverParameterNumHeaderLines           = 36;
var DriverParameterTrainChangeText          = 37;
var DriverParameterTrainStornoText          = 38;
var DriverParameterTrainCashInText          = 39;
var DriverParameterNumTrailerLines          = 40;
var DriverParameterTrainCashOutText         = 41;
var DriverParameterTrainVoidRecText         = 42;
var DriverParameterTrainCashPayText         = 43;
var DriverParameterBarLinePrintDelay        = 44;
var DriverParameterCompatLevel              = 45;
var DriverParameterHeader                   = 46;
var DriverParameterTrailer                  = 47;
var DriverParameterLogoSize                 = 48;
var DriverParameterLogoCenter               = 49;
var DriverParameterDepartment               = 50;
var DriverParameterLogoEnabled              = 51;
var DriverParameterHeaderPrinted            = 52;
var DriverParameterReceiptType              = 53;
var DriverParameterZeroReceiptType          = 54;
var DriverParameterZeroReceiptNumber        = 55;
var DriverParameterCCOType                  = 56;
var DriverParameterTableEditEnabled         = 57;
var DriverParameterXmlZReportEnabled        = 58;
var DriverParameterCsvZReportEnabled        = 59;
var DriverParameterXmlZReportFileName       = 60;
var DriverParameterCsvZReportFileName       = 61;
var DriverParameterVoidReceiptOnMaxItems    = 62;
var DriverParameterMaxReceiptItems          = 63;
var DriverParameterJournalPrintHeader       = 64;
var DriverParameterJournalPrintTrailer      = 65;
var DriverParameterCacheReceiptNumber       = 66;
var DriverParameterBarLineByteMode          = 67;
var DriverParameterLogFilePath              = 68;

/////////////////////////////////////////////////////////////////////////////
// Выполнение

var FilePath = "." // имя папки файлов таблиц
var DIO_SET_DRIVER_PARAMETER  = 30; // write internal driver parameter
var DIO_WRITE_TABLE_FILE      = 47; // write table file


var ResultString = "";
var FSO = new ActiveXObject("Scripting.FileSystemObject");
var AddressFile = FSO.OpenTextFile("IPAddress.txt", 1);
var ResultFile = FSO.CreateTextFile("Result.txt", true);

function LoadTable(IPAddress)
{
	var Driver = new ActiveXObject ("OPOS.FiscalPrinter");
	var rc = 0;
	while (true)
	{
		rc = Driver.open("SHTRIH-M-OPOS-1");
		if (rc != 0) break;
		
		
		rc = Driver.DirectIO(DIO_SET_DRIVER_PARAMETER, DriverParameterPropertyUpdateMode, "0");
		if (rc != 0) break;
		
		rc = Driver.DirectIO(DIO_SET_DRIVER_PARAMETER, DriverParameterConnectionType, "3");
		if (rc != 0) break;
		
		rc = Driver.DirectIO(DIO_SET_DRIVER_PARAMETER, DriverParameterRemoteHost, IPAddress);
		if (rc != 0) break;
		
		rc = Driver.DirectIO(DIO_SET_DRIVER_PARAMETER, DriverParameterRemotePort, "7778");
		if (rc != 0) break;
		
		rc = Driver.ClaimDevice(3000);
		if (rc != 0) break;
		
		Driver.DeviceEnabled = true;
		if (!Driver.DeviceEnabled) {
			rc = Driver.ResultCode;
			break;
		}
		
		rc = Driver.DirectIO(DIO_WRITE_TABLE_FILE, 0, FilePath);
		if (rc != 0) break;
		break;
	}
	if (rc != 0)
	{
		ResultString = rc + ", " + Driver.ErrorString;
	} else
	{
		ResultString = "OK";
	}
	Driver.close();
	return (rc == 0);
}

while (AddressFile.AtEndOfStream == false)
{
    var IPAddress = AddressFile.ReadLine();
	
    LoadTable(IPAddress);
	ResultFile.writeLine(IPAddress + " " + ResultString);
}
AddressFile.close();
WScript.Echo ("СКРИПТ ЗАКОНЧЕН");



