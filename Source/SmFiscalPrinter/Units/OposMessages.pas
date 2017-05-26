unit OposMessages;

interface

const
  MsgImageHeightIsZero = 'Image height is zero, must be > 0';
  MsgImageWidthIsZero = 'Image width is zero, must be > 0';
  MsgImageHeightMoreThanMaximum = 'Image height more than maximum';
  MsgImageWidthMoreThanMaximum  = 'Image width more than maximum';
  MsgLockedTaxPassword = 'Locked for invalid tax officer password';
  MsgCanNotChangeState = 'Can not change state';
  MsgFiscalMemoryOverflow = 'Fiscal memory overflow';
  MsgInvalidParameterValue = 'Invalid parameter value';
  MsgInvalidPropertyValue = 'Invalid property value';
  MsgDayEndRequired = 'Day end required. Print ZReport and try again';
  MsgCoverOpened = 'Cover opened.';
  MsgRecEmpty = 'The receipt station has run out of paper.';
  MsgRecNearEnd = 'The receipt station paper is near end.';
  MsgRecLeverUp = 'The receipt station lever is up.';
  MsgJrnEmpty = 'The journal station has run out of paper.';
  MsgJrnNearEnd = 'The journal station paper is near end.';
  MsgJrnLeverUp = 'The journal station lever is up.';
  MsgEJournalNearFull = 'EKLZ is almost full.';
  MsgLowFMBattery = 'Fiscal memory battery is low';
  MsgLastFMRecordCorrupted = 'Last fiscal memory record is corrupted.';
  MsgFMDayOver = '24 hours in fiscal memory are over.';
  MsgExternalHCheck = 'External HCheck: ';
  MsgInternalHCheck = 'Internal HCheck: ';
  MsgFiscalPrinterFirmware = 'Printer firmware';
  MsgFiscalMemoryFirmware = 'FM firmware';
  MsgTrainingModeNotSupported = 'Training mode not supported';
  MsgNotImplemented = 'Not implemented';
  MsgTotalizerNotSupported = 'Totalizer not supported';
  MsgRecStationNotPresent = 'Receipt station is not present';
  MsgJrnStationNotPresent = 'Journal station is not present';
  MsgSlpStationNotPresent = 'Slip station is not present';
  MsgNoStationDefined = 'No station defined';
  MsgNotInTrainingMode = 'Training mode is not active';
  MsgNotPaidNotSupported = 'Not paid receipt is nor supported';
  MsgDayOpened = 'Day is opened. Unable to change date';




implementation

end.
