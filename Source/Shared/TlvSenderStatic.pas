unit TlvSenderStatic;

interface

(**
 * @brief Инициализация библиотеки
 * @param fnSerial Серийный номер фискального накопителя
 * @param sz - длина строки fn. Если номер менее 10 символов, дополняется слева пустыми символами (\0)
 * @return 0 при успешном выполнении, или код ошибки
 *)

function tlvSenderInit(const fn: PAnsiChar; size: Integer): Integer; cdecl;


(**
 * @brief Начать посылку сообщений
 * @param host Хост ОФД. Если указан NULL, используется значение по уполчанию "k-server.test-naofd.ru"
 * @param port Порт ОФД. Если указан NULL, используется значение по уполчанию "7777"
 * @return 0 при успешном выполнении, или код ошибки
 *)
function tlvSenderStart(const host: PAnsiChar; const port: PAnsiChar): Integer; cdecl;

(**
 * @brief Завершение работы библиотеки. Необходимо вызвать перед выгрузкой
 *)
procedure tlvSenderStop; cdecl;

(**
 * @brief Послать пакет в ОФД
 * @param container Контейнер с корректно сформированными данными P-протокола
 * @param sz - размер контейнера
 * @return 0 при успешном выполнении, или код ошибки
 *)
function tlvSenderSendPacket(const container: PAnsiChar; size: Integer): Integer; cdecl;


implementation

const
  tlvapi32 = '';

function tlvSenderInit; external tlvapi32 name 'tlvSenderInit';
function tlvSenderStart; external tlvapi32 name 'tlvSenderStart';
procedure tlvSenderStop; external tlvapi32 name 'tlvSenderStop';
function tlvSenderSendPacket; external tlvapi32 name 'tlvSenderSendPacket';

end.
