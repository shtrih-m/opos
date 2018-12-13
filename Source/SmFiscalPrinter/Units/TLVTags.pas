unit TLVTags;

interface

Uses
  // VCL
  Windows, SysUtils, Classes, ActiveX, StrUtils, DateUtils,
  // Tnt
  TntSysUtils,
  // This
  WException, ByteUtils, StringUtils, gnugettext;

type
  TTagType = (ttByte, ttUint16, ttUInt32, ttVLN, ttFVLN, ttBitMask,
    ttUnixTime, ttString, ttSTLV, ttByteArray);
  TTLVTag = class;

  { TTLVTags }

  TTLVTags = class
  private
    FList: TList;
    procedure CreateTags;
    procedure InsertItem(AItem: TTLVTag);
    procedure RemoveItem(AItem: TTLVTag);
    function GetItem(Index: Integer): TTLVTag;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add: TTLVTag;
    procedure AddTag(ANumber: Integer; const ADescription: AnsiString;
      const AShortDescription: AnsiString; AType: TTagType;
      ALength: Integer; AFixedLength: Boolean = False);
    procedure Clear;
    function Find(ANumber: Integer): TTLVTag;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTLVTag read GetItem; default;
  end;

  { TTLVTag }

  TTLVTag = class
  private
    FOwner: TTLVTags;
    FTag: Integer;
    FLength: Integer;
    FTagType: TTagType;
    FDescription: AnsiString;
    FShortDescription: AnsiString;
    FFixedLength: Boolean;

    procedure SetOwner(AOwner: TTLVTags);
  public
    constructor Create(AOwner: TTLVTags);
    destructor Destroy; override;

    function GetStrValue(AData: AnsiString): AnsiString;
    class function Format(t: TTagType; v: Variant): AnsiString;
    class function Int2ValueTLV(aValue: Int64; aSizeInBytes: Integer): AnsiString;
    class function VLN2ValueTLV(aValue: Int64): AnsiString;
    class function VLN2ValueTLVLen(aValue: Int64; ALen: Integer): AnsiString;
    class function FVLN2ValueTLV(aValue: Currency): AnsiString;
    class function FVLN2ValueTLVLen(aValue: Currency; ALength: Integer): AnsiString;
    class function ValueTLV2FVLNstr(s: AnsiString): AnsiString;
    class function UnixTime2ValueTLV(d: TDateTime): AnsiString;
    class function ASCII2ValueTLV(aValue: WideString): AnsiString;

    class function ValueTLV2UnixTime(s: AnsiString): TDateTime;
    class function ValueTLV2Int(s: AnsiString): Int64;
    class function ValueTLV2VLN(s: AnsiString): Int64;
    class function ValueTLV2FVLN(s: AnsiString): Currency;
    class function ValueTLV2ASCII(s: AnsiString): WideString;
    class function Int2Bytes(Value: UInt64; SizeInBytes: Integer): AnsiString;

    function ValueToBin(const Data: AnsiString): AnsiString;

    property Tag: Integer read FTag write FTag;
    property Length: Integer read FLength write FLength;
    property TagType: TTagType read FTagType write FTagType;
    property Description: AnsiString read FDescription write FDescription;
    property FixedLength: Boolean read FFixedLength write FFixedLength;
    property ShortDescription: AnsiString read FShortDescription write FShortDescription;
  end;

function TLVDocTypeToStr(ATag: Integer): WideString;

implementation

function TLVDocTypeToStr(ATag: Integer): WideString;
begin
  case ATag of
    1: Result := _('ОТЧЕТ О РЕГИСТРАЦИИ');
    11: Result := _('ОТЧЕТ ОБ ИЗМЕНЕНИИ ПАРАМЕТРОВ РЕГИСТРАЦИИ');
    2: Result := _('ОТЧЕТ ОБ ОТКРЫТИИ СМЕНЫ');
    21: Result := _('ОТЧЕТ О ТЕКУЩЕМ СОСТОЯНИИ РАСЧЕТОВ');
    3: Result := _('КАССОВЫЙ ЧЕК');
    31: Result := _('КАССОВЫЙ ЧЕК КОРРЕКЦИИ');
    4: Result := _('БЛАНК СТРОГОЙ ОТЧЕТНОСТИ');
    41: Result := _('БЛАНК СТРОГОЙ ОТЧЕТНОСТИ КОРРЕКЦИИ');
    5: Result := _('ОТЧЕТ О ЗАКРЫТИИ СМЕНЫ');
    6: Result := _('ОТЧЕТ О ЗАКРЫТИИ ФН');
    7: Result := _('ПОДТВЕРЖДЕНИЕ ОПЕРАТОРА');
  else
    Result := Tnt_WideFormat('%s: %d', [_('Неизвестный тип документа'), ATag]);
  end;
end;

function CalcTypeToStr(AType: Integer): AnsiString;
begin
  case AType of
    1: Result := _('Приход');
    2: Result := _('Возврат прихода');
    3: Result := _('Расход');
    4: Result := _('Возврат расхода');
  else
    Result := _('Неизв. тип: ')  + IntToStr(AType);
  end;
end;

//
{
0 Общая
1 Упрощенная Доход
2 Упрощенная Доход минус Расход
3 Единый налог на вмененный доход
4 Единый сельскохозяйственный налог
5 Патентная система налогообложения}

function TaxSystemToStr(AType: Integer): AnsiString;
begin
  If AType = 0 then
  begin
    Result := 'Нет';
    Exit;
  end;
  if TestBit(AType, 0) then
    Result := _('ОБЩ.');

  if TestBit(AType, 1) then
    Result := Result + _('+УД');

  if TestBit(AType, 2) then
    Result := Result + _('+УДМР');

  if TestBit(AType, 3) then
    Result := Result + _('+ЕНВД');

  if TestBit(AType, 4) then
    Result := Result + _('+ЕНВД');

  if TestBit(AType, 5) then
    Result := Result + _('+ПСН');
end;

{ TTLVTags }

constructor TTLVTags.Create;
begin
  inherited Create;
  FList := TList.Create;
  CreateTags;
end;

destructor TTLVTags.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TTLVTags.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TTLVTags.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TTLVTags.GetItem(Index: Integer): TTLVTag;
begin
  Result := FList[Index];
end;

procedure TTLVTags.InsertItem(AItem: TTLVTag);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TTLVTags.RemoveItem(AItem: TTLVTag);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TTLVTags.Add: TTLVTag;
begin
  Result := TTLVTag.Create(Self);
end;

procedure TTLVTags.AddTag(ANumber: Integer; const ADescription: AnsiString;
  const AShortDescription: AnsiString; AType: TTagType; ALength: Integer;
  AFixedLength: Boolean = False);
var
  T: TTLVTag;
begin
  T := Add;
  T.FTag := ANumber;
  T.FLength := ALength;
  T.FDescription := ADescription;
  T.FShortDescription := AShortDescription;
  T.FixedLength := AFixedLength;
  T.FTagType := AType;

  if T.FTagType <> ttString then
  begin
    T.FixedLength := True;
  end;
end;

procedure TTLVTags.CreateTags;
begin
  AddTag(1000, 'наименование документа', 'НАИМ. ДОК.',	ttString, 0);
  AddTag(1001, 'признак автоматического режима', 'ПРИЗН. АВТОМ. РЕЖ.', ttByte, 1);
  AddTag(1002, 'признак автономного режима', 'ПРИЗН. АВТОНОМН. РЕЖ.', ttByte, 1);
  AddTag(1005, 'адрес оператора перевода', 'АДР. ОПЕР. ПЕРЕВОДА', ttString, 256);
  AddTag(1008, 'телефон или электронный адрес покупателя', 'ТЕЛ. ИЛИ EMAIL ПОКУПАТЕЛЯ', ttString, 64);
  AddTag(1009, 'адрес расчетов', 'АДР.РАСЧЕТОВ', ttString, 256);
  // Старые теги
  AddTag(1010, 'размер вознаграждения банковского агента', 'РАЗМЕР ВОЗНАГР. БАНК. АГЕНТА', ttVLN, 8);
  AddTag(1011, 'размер вознаграждения платежного агента', 'РАЗМЕР ВОЗНАГР. ПЛАТ. АГЕНТА', ttVLN, 8);

  AddTag(1012, 'дата, время', 'ДАТА, ВРЕМЯ', ttUnixTime, 4);
  AddTag(1013, 'заводской номер ККТ', 'ЗАВ. НОМЕР ККТ', ttString, 20);
  AddTag(1016, 'ИНН оператора перевода', 'ИНН ОПЕРАТОРА ПЕРЕВОДА', ttString, 12, True);
  AddTag(1017, 'ИНН ОФД', 'ИНН ОФД', ttString, 12, True);
  AddTag(1018, 'ИНН пользователя', 'ИНН ПОЛЬЗ.', ttString, 12, True);
  AddTag(1020, 'сумма расчета, указанного в чеке (БСО)', 'СУММА РАСЧЕТА В ЧЕКЕ(БСО)', ttVLN, 6);
  AddTag(1021, 'кассир', 'КАССИР', ttString, 64);
  AddTag(1022, 'код ответа ОФД', 'КОД ОТВЕРА ОФД', ttByte, 1);
  AddTag(1023, 'количество предмета расчета', 'КОЛ-ВО ПРЕДМ. РАСЧЕТА', ttFVLN, 8);
  AddTag(1026, 'наименование оператора перевода', 'НАИМЕН. ОПЕР. ПЕРЕВОДА', ttString, 64);
  AddTag(1030, 'наименование предмета расчета', 'НАИМЕН. ПРЕДМ. РАСЧЕТА', ttString, 128);
  AddTag(1031, 'сумма по чеку (БСО) наличными', 'СУММА ПО ЧЕКУ НАЛ (БСО)', ttVLN, 6);
  AddTag(1036, 'номер автомата', 'НОМЕР АВТОМАТА', ttString, 20);
  AddTag(1037, 'регистрационный номер ККТ', 'РЕГ. НОМЕР ККТ', ttString, 20, True);
  AddTag(1038, 'номер смены', 'НОМЕР СМЕНЫ', ttUInt32, 4);
  AddTag(1040, 'номер ФД', 'НОМЕР ФД', ttUInt32, 4);
  AddTag(1041, 'номер ФН', 'НОМЕР ФН', ttString, 16, True);
  AddTag(1042, 'номер чека за смену', 'НОМЕР ЧЕКА ЗА СМЕНУ', ttUInt32, 4);
  AddTag(1043, 'стоимость предмета расчета', 'СТОИМ. ПРЕДМ. РАСЧЕТА', ttVLN, 6);
  AddTag(1044, 'операция платежного агента', 'ОПЕРАЦИЯ ПЛАТ. АГЕНТА', ttString, 24);
  // Старый тег
  AddTag(1045, 'операция банковского субагента', 'ОПЕРАЦИЯ БАНК. СУБАГЕНТА', ttString, 24);

  AddTag(1046, 'наименование ОФД', 'НАИМЕН. ОФД', ttString, 256);
  AddTag(1048, 'наименование пользователя', 'НАИМЕН. ПОЛЬЗ.', ttString, 256);
  AddTag(1050, 'признак исчерпания ресурса ФН', 'ПРИЗН. ИСЧЕРП. РЕСУРСА ФН', ttByte, 1);
  AddTag(1051, 'признак необходимости срочной замены ФН', 'ПРИЗН. НЕОБХ. СРОЧН. ЗАМЕНЫ ФН', ttByte, 1);
  AddTag(1052, 'признак переполнения памяти ФН', 'ПРИЗН. ПЕРЕПОЛН. ПАМЯТИ ФН', ttByte, 1);
  AddTag(1053, 'признак превышения времени ожидания ответа ОФД', 'ПРИЗН ПРЕВЫШ. ВРЕМЕНИ ОЖИД. ОТВ. ОФД', ttByte, 1);
  AddTag(1054, 'признак расчета', 'ПРИЗН. РАСЧЕТА', ttByte, 1);
  AddTag(1055, 'применяемая система налогообложения', 'ПРИМЕН. СИСТ. НАЛОГООБЛОЖЕНИЯ', ttByte, 1);
  AddTag(1056, 'признак шифрования', 'ПРИЗН. ШИФРОВАНИЯ', ttByte, 1);
  AddTag(1057, 'признак платежного агента', 'ПРИЗН. ПЛАТ. АГЕНТА', ttByte, 1);
  AddTag(1059, 'предмет расчета', 'ПРЕДМ. РАСЧЕТА', ttSTLV, 1024);
  AddTag(1060, 'адрес сайта ФНС', 'АДР. САЙТА ФНС', ttString, 256);
  AddTag(1062, 'системы налогообложения', 'СИСТЕМЫ НАЛОГООБЛ.', ttByte, 1);
  AddTag(1068, 'сообщение оператора для ФН', 'СООБЩ. ОПЕРАТОРА ДЛЯ ФН', ttSTLV, 9);
  AddTag(1073, 'телефон платежного агента', 'ТЕЛ. ПЛАТ. АГЕНТА', ttString, 19);
  AddTag(1074, 'телефон оператора по приему платежей', 'ТЕЛ ОПЕР. ПО ПРИЕМУ ПЛАТЕЖЕЙ', ttString, 19);
  AddTag(1075, 'телефон оператора перевода', 'ТЕЛ. ОПЕР. ПЕРЕВОДА', ttString, 19);
  AddTag(1077, 'ФП документа', 'ФП ДОКУМЕНТА', ttByteArray, 6);
  AddTag(1078, 'ФП оператора', 'ФП ОПЕРАТОРА', ttByteArray, 16);
  AddTag(1079, 'цена за единицу предмета расчета', 'ЦЕНА ЗА ЕД. ПРЕДМ. РАСЧ.', ttVLN, 6);
  AddTag(1080, 'штриховой код EAN 13', 'ШК EAN 13', ttString, 16);
  AddTag(1081, 'сумма по чеку (БСО) электронными', 'СУММА ПО ЧЕКУ ЭЛЕКТРОННЫМИ(БСО)', ttVLN, 6);
  // Старые теги
  AddTag(1082, 'телефон банковского субагента', 'ТЕЛ. БАНК. СУБАГЕНТА', ttString, 19);
  AddTag(1083, 'телефон платежного субагента', 'ТЕЛ. ПЛАТ. СУБАГЕНТА', ttString, 19);


  AddTag(1084, 'дополнительный реквизит пользователя', 'ДОП. РЕКВИЗИТ ПОЛЬЗОВ.', ttSTLV, 320);
  AddTag(1085, 'наименование дополнительного реквизита пользователя', 'НАИМЕН. ДОП. РЕКВИЗИТ. ПОЛЬЗОВ.', ttString, 64);
  AddTag(1086, 'значение дополнительного реквизита пользователя', 'ЗНАЧ. ДОП. РЕКВИЗИТ. ПОЛЬЗОВ.', ttString, 256);
  AddTag(1097, 'количество непереданных ФД', 'КОЛ-ВО НЕПЕРЕДАННЫХ ФД', ttUInt32, 4);
  AddTag(1098, 'дата и время первого из непереданных ФД', 'ДАТА И ВРЕМЯ ПЕРВОГО НЕПЕРЕДАНН. ФД', ttUnixTime, 4);
  AddTag(1101, 'код причины перерегистрации', 'КОД ПРИЧИНЫ ПЕРЕРЕГИСТР.', ttByte, 1);
  AddTag(1102, 'сумма НДС чека по ставке 18%', 'СУММА НДС ЧЕКА 18%', ttVLN, 6);
  AddTag(1103, 'сумма НДС чека по ставке 10%', 'СУММА НДС ЧЕКА 10%', ttVLN, 6);
  AddTag(1104, 'сумма расчета по чеку с НДС по ставке 0%', 'СУММА РАСЧ. ПО ЧЕКУ 0%', ttVLN, 6);
  AddTag(1105, 'сумма расчета по чеку без НДС', 'СУММА РАСЧ. ПО ЧЕКУ БЕЗ НДС', ttVLN, 6);
  AddTag(1106, 'сумма НДС чека по расч. ставке 18/118', 'СУММА НДС ЧЕКА ПО РАСЧ. СТАВКЕ 18/118', ttVLN, 6);
  AddTag(1107, 'сумма НДС чека по расч. ставке 10/110', 'СУММА НДС ЧЕКА ПО РАСЧ. СТАВКЕ 10/110', ttVLN, 6);
  AddTag(1108, 'признак ККТ для расчетов только в Интернет', 'ПРИЗН. ККТ ДЛЯ РАСЧ. ТОЛЬКО В ИНТЕРНЕТ', ttByte, 1);
  AddTag(1109, 'признак расчетов за услуги', 'ПРИЗН. РАСЧ. ЗА УСЛУГИ', ttByte, 1);
  AddTag(1110, 'признак АС БСО', 'ПРИЗН. АС БСО', ttByte, 1);
  AddTag(1111, 'общее количество ФД за смену', 'ОБЩ. КЛ-ВО ФД ЗА СМЕНУ', ttUInt32, 4);
  AddTag(1116, 'номер первого непереданного документа', 'НОМЕР ПЕРВОГО НЕПЕРЕДАНН. ДОК-ТА', ttUInt32, 4);
  AddTag(1117, 'адрес электронной почты отправителя чека', 'АДР. ЭЛ. ПОЧТЫ ОТПРАВ. ЧЕКА', ttString, 64);
  AddTag(1118, 'количество кассовых чеков (БСО) за смену', 'КОЛ-ВО КАССОВЫХ ЧЕКОВ ЗА СМЕНУ(БСО)', ttUInt32, 4);
  // старый тег
  AddTag(1119, 'телефон оператора по приему платежей', 'ТЕЛ. ОПЕР. ПО ПРИЕМУ ПЛАТ.', ttString, 19);

  AddTag(1126, 'признак проведения лотереи', 'ПРИЗН. ПРОВЕДЕНИЯ ЛОТЕРЕИ', ttByte, 1);
  AddTag(1129, 'счетчики операций «приход»', 'СЧЕТЧИКИ ОПЕР. "ПРИХОД"', ttSTLV, 116);
  AddTag(1130, 'счетчики операций «возврат прихода»', 'СЧЕТЧИКИ ОПЕР. "ВОЗВР. ПРИХОДА"', ttSTLV, 116);
  AddTag(1131, 'счетчики операций «расход»', 'СЧЕТЧИКИ ОПЕР. "РАСХОД"', ttSTLV, 116);
  AddTag(1132, 'счетчики операций «возврат расхода»', 'СЧЕТЧИКИ ОПЕР. "ВОЗВР. РАСХОДА"', ttSTLV, 116);
  AddTag(1133, 'счетчики операций по чекам коррекции', 'СЧЕТЧИКИ ОПЕР ПО ЧЕКАМ КОРР.', ttSTLV, 216);
  AddTag(1134, 'количество чеков (БСО) со всеми признаками расчетов', 'КОЛ-ВО ЧЕКОВ БСО СО ВСЕМИ ПРИЗН. РАСЧ.', ttUInt32, 4);
  AddTag(1135, 'количество чеков по признаку расчетов', 'КОЛ-ВО ЧЕКОВ ПО ПРИЗН. РАСЧ.', ttUInt32, 4);
  AddTag(1136, 'итоговая сумма в чеках (БСО) наличными', 'ИТОГ. СУММ. В ЧЕКАХ БСО НАЛ.', ttVLN, 8);
  AddTag(1138, 'итоговая сумма в чеках (БСО) электронными', 'ИТОГ СУММА В ЧЕКАХ БСО ЭЛЕКТР.', ttVLN, 8);
  AddTag(1139, 'сумма НДС по ставке 18%', 'СУММА НДС 18%', ttVLN, 8);
  AddTag(1140, 'сумма НДС по ставке 10%', 'СУММА НДС 10%', ttVLN, 8);
  AddTag(1141, 'сумма НДС по расч. ставке 18/118', 'СУММА НДС ПО РАСЧ. СТАВКЕ 18/118', ttVLN, 8);
  AddTag(1142, 'сумма НДС по расч. ставке 10/110', 'СУММА НДС ПО РАСЧ. СТАВКЕ 10/110', ttVLN, 8);
  AddTag(1143, 'сумма расчетов с НДС по ставке 0%', 'СУММА РАСЧ. С НДС 0%', ttVLN, 8);
  AddTag(1144, 'количество чеков коррекции', 'КОЛ-ВО ЧЕКОВ ОПЕРАЦИИ', ttUInt32, 4);
  AddTag(1145, 'счетчики коррекций «приход»', 'СЧЕТЧ. КОРРЕКЦИЙ "ПРИХОД"', ttSTLV, 100);
  AddTag(1146, 'счетчики коррекций «расход»', 'СЧЕТЧ. КОРРЕКЦИЙ "РАСХОД"', ttSTLV, 100);
  AddTag(1148, 'количество самостоятельных корректировок', 'КОЛ-ВО САМОСТ. КОРРЕКТИРОВОК', ttUInt32, 4);
  AddTag(1149, 'количество корректировок по предписанию', 'КОЛ-ВО КОРРЕКТИРОВОК ПО ПРЕДПИС.', ttUInt32, 4);
  AddTag(1151, 'сумма коррекций НДС по ставке 18%', 'СУММА КОРРЕКЦИЙ НДС 18%', ttVLN, 8);
  AddTag(1152, 'сумма коррекций НДС по ставке 10%', 'СУММА КОРРЕКЦИЙ НДС 10%', ttVLN, 8);
  AddTag(1153, 'сумма коррекций НДС по расч. ставке 18/118', 'СУММА КОРРЕКЦИЙ НДС ПО РАСЧ. СТ. 18/110', ttVLN, 8);
  AddTag(1154, 'сумма коррекций НДС расч. ставке 10/110', 'СУММА КОРРЕКЦИЙ НДС ПО РАС. СТ. 10/110', ttVLN, 8);
  AddTag(1155, 'сумма коррекций с НДС по ставке 0%', 'СУММА КОРРЕКЦИЙ НДС 0%', ttVLN, 8);
  AddTag(1157, 'счетчики итогов ФН', 'СЧЕТЧИКИ ИТОГОВ ФН', ttSTLV, 708);
  AddTag(1158, 'счетчики итогов непереданных ФД', 'СЧЕТЧ ИТОГОВ НЕПЕРЕД. ФД', ttSTLV, 708);
  AddTag(1162, 'код товарной номенклатуры', 'КОД ТОВАРН. НОМЕНКЛ.', ttByteArray, 32);
  AddTag(1171, 'телефон поставщика', 'ТЕЛ. ПОСТАВЩИКА', ttString, 19);
  AddTag(1173, 'тип коррекции', 'ТИП КОРРЕКЦИИ', ttByte, 1);
  AddTag(1174, 'основание для коррекции', 'ОСНОВАНИЕ ДЛЯ КОРРЕКЦИИ', ttSTLV, 292);
  AddTag(1177, 'наименование основания для коррекции', 'НАИМЕН. ОСН. ДЛЯ КОРРЕКЦ', ttString, 256);
  AddTag(1178, 'дата документа основания для коррекции', 'ДАТА ДОК-ТА ОСН. ДЛЯ КОРРЕКЦ', ttUnixTime, 4);
  AddTag(1179, 'номер документа основания для коррекции', 'НОМЕР ДОК-ТА ОСН. ДЛЯ КОРРЕКЦ', ttString, 32);
  AddTag(1183, 'сумма расчетов без НДС', 'СУММА РАСЧ. БЕЗ НДС', ttVLN, 8);
  AddTag(1184, 'сумма коррекций без НДС', 'СУММА КОРРЕКЦ. БЕЗ НДС', ttVLN, 8);
  AddTag(1187, 'место расчетов', 'МЕСТО РАСЧЕТОВ', ttString, 256);
  AddTag(1188, 'версия ККТ', 'ВЕРСИЯ ККТ', ttString, 8);
  AddTag(1189, 'версия ФФД ККТ', 'ВЕРСИЯ ФФД ККТ', ttByte, 1);
  AddTag(1190, 'версия ФФД ФН', 'ВЕРСИЯ ФФД ФН', ttByte, 1);
  AddTag(1191, 'дополнительный реквизит предмета расчета', 'ДОП. РЕКВ. ПРЕДМ. РАСЧЕТА', ttString, 64);
  AddTag(1192, 'дополнительный реквизит чека (БСО)', 'ДОП. РЕКВ. ЧЕКА БСО', ttString, 16);
  AddTag(1193, 'признак проведения азартных игр', 'ПРИЗН. ПРОВЕД. АЗАРТН. ИГР', ttByte, 1);
  AddTag(1194, 'счетчики итогов смены', 'СЧЕТЧИКИ ИТОГОВ СМЕНЫ', ttSTLV, 708);
  AddTag(1196, 'QR-код', 'QR-КОД', ttString, 0);
  AddTag(1197, 'единица измерения предмета расчета', 'ЕД. ИЗМЕР. ПРЕДМЕТА РАСЧ.', ttString, 16);
  AddTag(1198, 'размер НДС за единицу предмета расчета', 'РАЗМ. НДС ЗА ЕД. ПРЕДМ. РАСЧ.', ttVLN, 6);
  AddTag(1199, 'ставка НДС ', 'СТАВКА НДС', ttByte, 1);
  AddTag(1200, 'сумма НДС за предмет расчета', 'СУММА НДС ЗА ПРЕДМ. РАСЧ.', ttVLN, 6);
  AddTag(1201, 'общая итоговая сумма в чеках (БСО)', 'ОБЩ. ИТОГ. СУММА В ЧЕКАХ БСО', ttVLN, 8);
  AddTag(1203, 'ИНН кассира', 'ИНН КАССИРА', ttString, 12, True);
  AddTag(1205, 'коды причин изменения сведений о ККТ', 'КОДЫ ПРИЧИНЫ ИЗМ. СВЕД. О ККТ', ttBitMask, 4);
  AddTag(1206, 'сообщение оператора', 'СООБЩ. ОПЕР.', ttBitMask, 1);
  AddTag(1207, 'признак торговли подакцизными товарами', 'ПРИЗН. ТОРГОВЛИ ПОДАКЦИЗН. ТОВАРАМИ', ttByte, 1);
  AddTag(1208, 'сайт чеков', 'САЙТ ЧЕКОВ', ttString, 256);
  AddTag(1209, 'версия ФФД', 'ВЕРСИЯ ФФД', ttByte, 1);
  AddTag(1212, 'признак предмета расчета', 'ПРИЗН. ПРЕДМЕТА РАСЧ.', ttByte, 1);
  AddTag(1213, 'ресурс ключей ФП', 'РЕСУРС КЛЮЧЕЙ ФП', ttUInt16, 2);
  AddTag(1214, 'признак способа расчета', 'ПРИЗН. СПОСОБА РАСЧ.', ttByte, 1);
  AddTag(1215, 'сумма по чеку (БСО) предоплатой (зачетом аванса))', 'СУММА ПО ЧЕКУ БСО ПРЕДОПЛ.', ttVLN, 6);
  AddTag(1216, 'сумма по чеку (БСО) постоплатой (в кредит)', 'СУММА ПО ЧЕКУ БСО ПОСТОПЛ.', ttVLN, 6);
  AddTag(1217, 'сумма по чеку (БСО) встречным предоставлением', 'СУММА ПО ЧЕКУ БСО ВСТРЕЧН. ПРЕДОСТ.', ttVLN, 6);
  AddTag(1218, 'итоговая сумма в чеках (БСО) предоплатами (авансами)', 'ИТОГ. СУММА В ЧЕКАХ БСО ПРЕДОПЛ.', ttVLN, 8);
  AddTag(1219, 'итоговая сумма в чеках (БСО) постоплатами (кредитами)', 'ИТОГ. СУММА В ЧЕКАХ БСО ПОСТОПЛ.', ttVLN, 8);
  AddTag(1220, 'итоговая сумма в чеках (БСО) встречными предоставлениями', 'ИТОГ. СУММА В ЧЕКАХ БСО ВСТРЕЧН. ПРЕДОСТ.', ttVLN, 8);
  AddTag(1221, 'признак установки принтера в автомате', 'ПРИЗН. УСТАНОВКИ ПРИНТЕРА В АВТОМАТЕ', ttByte, 1);
  AddTag(1222, 'признак агента по предмету расчета', 'ПРИЗН. АГ. ПО ПРЕДМ. РАСЧ', ttByte, 1);
  AddTag(1223, 'данные агента', 'ДАННЫЕ АГЕНТА', ttSTLV, 512);
  AddTag(1224, 'данные поставщика', 'ДАННЫЕ ПОСТАВЩИКА', ttSTLV, 512);
  AddTag(1225, 'наименование поставщика', 'НАИМЕН. ПОСТАВЩИКА', ttString, 256);
  AddTag(1226, 'ИНН поставщика', 'ИНН ПОСТАВЩИКА', ttString, 12, True);
end;

function TTLVTags.Find(ANumber: Integer): TTLVTag;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if Items[i].Tag = ANumber then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

{ TTLVTag }

constructor TTLVTag.Create(AOwner: TTLVTags);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TTLVTag.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

function TTLVTag.GetStrValue(AData: AnsiString): AnsiString;
var
  saveSeparator: Char;
begin
  Result := '';
  saveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    case TagType of
      ttByte: begin
                case Tag of
                  1054: Result := CalcTypeToStr(TTLVTag.ValueTLV2Int(AData));
                  1055, 1062: Result := TaxSystemToStr(TTLVTag.ValueTLV2Int(AData));
                else
                  Result := IntToStr(TTLVTag.ValueTLV2Int(AData));
                end;
              end;
      ttByteArray: begin
                     case Tag of
                       1077: Result := IntToStr(Cardinal(TTLVTag.ValueTLV2Int(ReverseString(Copy(AData, 3, 4)))));
                     else
                       Result := StrToHex(AData);
                     end;
                   end;
      ttUInt32: Result := IntToStr(Cardinal(TTLVTag.ValueTLV2Int(AData)));
      ttUInt16: Result := IntToStr(Cardinal(TTLVTag.ValueTLV2Int(AData)));
      ttUnixTime: Result := DateTimeToStr(TTLVTag.ValueTLV2UnixTime(AData));
      ttVLN: Result := SysUtils.Format('%.2f', [TTLVTag.ValueTLV2VLN(AData) / 100]);
      ttFVLN: Result := TTLVTag.ValueTLV2FVLNstr(AData);
      ttString: Result := TrimRight(TTLVTag.ValueTLV2ASCII(AData));
    end;
  finally
    DecimalSeparator := saveSeparator;
  end;
end;

procedure TTLVTag.SetOwner(AOwner: TTLVTags);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

class function TTLVTag.Int2ValueTLV(aValue: Int64; aSizeInBytes: Integer): AnsiString;
var
  d: Int64;
  i, c: Integer;
begin
  if (aSizeInBytes > 8) or (aSizeInBytes < 1) then
    raiseException(_('Too large data'));

  SetLength(Result, aSizeInBytes);

  c := 0;
  d := $FF;

  for i := 1 to aSizeInBytes do
  begin
    Result[i] := Char((aValue and d) shr c);
    c := c + 8;
    d := d shl 8;
  end;
end;

class function TTLVTag.VLN2ValueTLV(aValue: Int64): AnsiString;
var
  d: Int64;
  i, c: Integer;
begin
  Result := '';

  c := 0;
  d := $FF;

  for i := 1 to 8 do
  begin
    Result := Result + Char((aValue and d) shr c);
    c := c + 8;
    d := d shl 8;
    if (aValue shr c) = 0 then
      Break;
  end;
end;

class function TTLVTag.FVLN2ValueTLV(aValue: Currency): AnsiString;
var
  i: Int64;
  k: Byte;
  c: Currency;
begin
  i := Round(aValue);
  c := aValue;

  for k := 0 to 4 do
  begin
    if i = c then
      Break;

    c := c * 10;
    i := Round(c)
  end;

  Result := Char(k) + VLN2ValueTLV(i);
end;

class function TTLVTag.UnixTime2ValueTLV(d: TDateTime): AnsiString;
var
  c: Int64;
begin
  //c := Round((d - EncodeDateTime(1970, 1, 1, 3, 0, 0, 0)) * 86400);
//  c := Round((d - 25569) * 86400);

  c := Round((d - EncodeDateTime(1970, 1, 1, 0, 0, 0, 0)) * 86400);
  SetLength(Result, 4);
  Result[4] := Char((c and $FF000000) shr 24);
  Result[3] := Char((c and $FF0000) shr 16);
  Result[2] := Char((c and $FF00) shr 8);
  Result[1] := Char((c and $FF));
end;

class function TTLVTag.ValueTLV2UnixTime(s: AnsiString): TDateTime;
begin
  Result := 0;
  if System.Length(s) <> 4 then
    Exit;

  Result := (((Byte(s[4]) shl 24) or (Byte(s[3]) shl 16) or (Byte(s[2]) shl 8) or Byte(s[1])) / 86400) + EncodeDateTime(1970, 1, 1, 0, 0, 0, 0);
end;

class function TTLVTag.ASCII2ValueTLV(aValue: WideString): AnsiString;
var
  l: Integer;
  P: PChar;
begin
  Result := '';
  if aValue = '' Then
    Exit;

  l := WideCharToMultiByte(CP_OEMCP, WC_COMPOSITECHECK Or WC_DISCARDNS Or WC_SEPCHARS Or WC_DEFAULTCHAR, @aValue[1], -1, Nil, 0, Nil, Nil);
  if l > 1 then
  begin
    GetMem(P, l);
    SetLength(Result, l);
    WideCharToMultiByte(CP_OEMCP, WC_COMPOSITECHECK Or WC_DISCARDNS Or WC_SEPCHARS Or WC_DEFAULTCHAR, @aValue[1], -1, P, l - 1, Nil, Nil);
    P[l - 1] := #0;
    Result := Copy(P, 1, l - 1);
    FreeMem(P, l);
  end;
end;

class function TTLVTag.ValueTLV2ASCII(s: AnsiString): WideString;
var
  l: Integer;
begin
  l := MultiByteToWideChar(CP_OEMCP, MB_PRECOMPOSED, PChar(@s[1]), -1, nil, 0);
  SetLength(Result, l - 1);
  if l > 1 then
    MultiByteToWideChar(CP_OEMCP, MB_PRECOMPOSED, PChar(@s[1]), -1, PWideChar(@Result[1]), l - 1);
end;

class function TTLVTag.ValueTLV2Int(s: AnsiString): Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := System.Length(s) downto 1 do
  begin
    Result := Result * $100 + Byte(s[i]);
  end;
end;

class function TTLVTag.ValueTLV2VLN(s: AnsiString): Int64;
begin
  Result := ValueTLV2Int(s);
end;

class function TTLVTag.ValueTLV2FVLN(s: AnsiString): Currency;
var
  i: Byte;
begin
  if Byte(s[1]) > 8 then
    raiseException(_('Неверная длина FVLN'));

  if System.Length(s) < 2 then
    raiseException(_('Неверная длина FVLN'));

  Result := ValueTLV2Int(Copy(s, 2, System.Length(s) - 1));
  for i := 1 to Byte(s[1]) do
    Result := Result / 10;
end;

class function TTLVTag.VLN2ValueTLVLen(aValue: Int64;
  ALen: Integer): AnsiString;
var
  d: Int64;
  i, c: Integer;
begin
  Result := '';

  c := 0;
  d := $FF;

  for i := 1 to ALen do
  begin
    Result := Result + Char((aValue and d) shr c);
    c := c + 8;
    d := d shl 8;
//    if (aValue shr c) = 0 then
//      Break;
  end;
end;

class function TTLVTag.FVLN2ValueTLVLen(aValue: Currency; ALength: Integer): AnsiString;
var
  i: Int64;
  k: Byte;
  c: Currency;
begin
  i := Round(aValue);
  c := aValue;

  for k := 0 to 4 do
  begin
    if i = c then
      Break;

    c := c * 10;
    i := Round(c)
  end;

  Result := Char(k) + VLN2ValueTLVLen(i, Alength - 1);
end;

class function TTLVTag.ValueTLV2FVLNstr(s: AnsiString): AnsiString;
var
  i: Byte;
  R: Double;
  saveSeparator: Char;
begin
  Result := '';
  if System.Length(S) < 1 then Exit;
  if Byte(s[1]) > 8 then
    raiseException(_('Неверная длина FVLN'));

  if System.Length(s) < 2 then
    raiseException(_('Неверная длина FVLN'));

  R := ValueTLV2Int(Copy(s, 2, System.Length(s) - 1));
  for i := 1 to Byte(s[1]) do
    R := R / 10;

  saveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Result := sysutils.Format('%.*f', [Byte(s[1]), R]);
  finally
    DecimalSeparator := saveSeparator;
  end;
end;

class function TTLVTag.Int2Bytes(Value: UInt64; SizeInBytes: Integer): AnsiString;
var
  V: Int64;
  i: Integer;
begin
  Result := '';
  if not (SizeInBytes in [1..8]) then Exit;

  for i := 0 to SizeInBytes-1 do
  begin
    V := Value shr (i*8);
    if V = 0 then Break;
    Result := Chr(V and $FF) + Result;
  end;
  Result := StringOfChar(#0, SizeInBytes - System.Length(Result)) + Result;
end;

class function TTLVTag.Format(t: TTagType; v: Variant): AnsiString;
begin
  case t of
    ttByte      : Result := Int2ValueTLV(v, 1);
    ttUInt32    : Result := Int2ValueTLV(v, 4);
    ttUInt16    : Result := Int2ValueTLV(v, 2);
    ttSTLV      : Result := '';
    ttUnixTime  : Result := UnixTime2ValueTLV(v);
    ttVLN       : Result := VLN2ValueTLV(v);
    ttFVLN      : Result := FVLN2ValueTLV(v);
    ttString    : Result := ASCII2ValueTLV(v);
  end;
end;

function TTLVTag.ValueToBin(const Data: AnsiString): AnsiString;
var
  S: AnsiString;
begin
  case TagType of
    ttByte: Result := Int2ValueTLV(Tag, 2) +
      Int2ValueTLV(1, 2) + Int2ValueTLV(StrToInt(Data), 1);

    ttUint16: Result := Int2ValueTLV(Tag, 2) +
      Int2ValueTLV(2, 2) + Int2ValueTLV(StrToInt(Data), 2);

    ttUInt32: Result := Int2ValueTLV(Tag, 2) +
      Int2ValueTLV(4, 2) + Int2ValueTLV(StrToInt(Data), 4);

    ttVLN: Result := Int2ValueTLV(Tag, 2) + Int2ValueTLV(Length, 2) +
      VLN2ValueTLVLen(StrToInt(Data), Length);

    ttFVLN: Result := Int2ValueTLV(Tag, 2) +
      Int2ValueTLV(Length, 2) + FVLN2ValueTLVLen(StrToDouble(Data), Length);

    ttBitMask: Result := Int2ValueTLV(Tag, 2) +
      Int2ValueTLV(Length, 2) + Int2ValueTLV(StrToInt(Data), Length);

    ttUnixTime: Result := Int2ValueTLV(Tag, 2) +
      Int2ValueTLV(4, 2) + UnixTime2ValueTLV(StrToDateTime(Data));

    ttByteArray:
    begin
      S := HexToStr(Data);
      Result := Int2ValueTLV(Tag, 2) + Int2ValueTLV(System.Length(S), 2) + S;
    end;

    ttString:
    begin
      if FixedLength then
        Result := Int2ValueTLV(Tag, 2) +
          Int2ValueTLV(Length, 2) + ASCII2ValueTLV(AddTrailingSpaces(Data, Length))
      else
        Result := Int2ValueTLV(Tag, 2) +
          Int2ValueTLV(System.Length(Data), 2) + ASCII2ValueTLV(Data);
    end
    else
      Result := Data;
  end;
end;

end.
