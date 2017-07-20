unit OposMessages;

interface

const
  MsgErrorReadingAnswer = 'Ошибка чтения ответа';
  MsgDeviceNotConnected = 'Нет связи';
  MsgCommandNotFound = 'Команда не найдена';
  MsgCashierNameEmpty = 'Имя кассира не может быть пустым';
  MsgRegistryKeyOpenError = 'Ошибка открытия ключа реестра';
  MsgWrongPrinterState = 'Неверное состояние принтера';
  MsgImageHeightIsZero = 'Высота изображения должен быть больше 0';
  MsgImageWidthIsZero = 'Ширина изображения должен быть больше 0';
  MsgImageHeightMoreThanMaximum = 'Высота изображения больше максимальной';
  MsgImageWidthMoreThanMaximum  = 'Ширина изображения больше максимальной';
  MsgLockedTaxPassword = 'Блокировка по неправильному паролю налогового инспектора';
  MsgCanNotChangeState = 'Невозможно изменить состояние ФР';
  MsgFiscalMemoryOverflow = 'Переполнение фискальной памяти';
  MsgInvalidParameterValue = 'Неверное значение параметра';
  MsgInvalidPropertyValue = 'Неверное значение свойства';
  MsgDayEndRequired = '24 часа истекли. Необходимо снять Z отчет';
  MsgCoverOpened = 'Открыта крышка.';
  MsgRecEmpty = 'Нет чековой ленты.';
  MsgRecNearEnd = 'Чековая лента заканчивается.';
  MsgRecLeverUp = 'Поднят рычаг чековой ленты.';
  MsgJrnEmpty = 'Нет контрольной ленты.';
  MsgJrnNearEnd = 'Контрольная лента заканчивается.';
  MsgJrnLeverUp = 'Поднят рычаг контрольной ленты.';
  MsgEJournalNearFull = 'ЭКЛЗ почти заполнена.';
  MsgLowFMBattery = 'Низкое напряжение батареи ФП';
  MsgLastFMRecordCorrupted = 'Повреждена последняя запись ФП.';
  MsgFMDayOver = 'Истекли 24 часа в ФП.';
  MsgExternalHCheck = 'External HCheck: ';
  MsgInternalHCheck = 'Internal HCheck: ';
  MsgFiscalPrinterFirmware = 'ПО ФР';
  MsgFiscalMemoryFirmware = 'ПО ФП';
  MsgNotSupported = 'Не поддерживается';
  MsgTrainingModeNotSupported = 'Режим тренировки не поддерживается';
  MsgNotImplemented = 'Не реализовано';
  MsgTotalizerNotSupported = 'Счетчик не поддерживается';
  MsgRecStationNotPresent = 'Нет чековой станции';
  MsgJrnStationNotPresent = 'Контрольная лента не поддерживается';
  MsgSlpStationNotPresent = 'Подкладной документ не поддерживается';
  MsgNoStationDefined = 'Не задана станция';
  MsgNotInTrainingMode = 'Режим тренировки не включен';
  MsgNotPaidNotSupported = 'Не оплаченные чеки не поддерживаются';
  MsgDayOpened = 'Нельзя установить дату в открытой смене';
  MsgInvalidPrinterState = 'Неверное состояние принтера';
  MsgInvalidConnectionType = 'Неверный тип подключения';


(*
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

*)


implementation

end.
