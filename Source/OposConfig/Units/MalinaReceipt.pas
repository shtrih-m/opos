unit MalinaReceipt;

interface

uses
  // VCL
  Classes, SysUtils,
  // Tnt
  TntSysUtils, TntClasses;

type
  { TMalinaParamsRec }

  TMalinaParamsRec = record
    SaleText: WideString;         // Перечислено Малина
    CardPrefix: WideString;       // Номер карты:
    MalinaCoeff: Double;      // Коэффициент
    MalinaPoints: Integer;    // Количество баллов
  end;

  { TMalinaReceipt }

  TMalinaReceipt = class
  public
    class function CreateReceipt(const Params: TMalinaParamsRec): WideString;
  end;

implementation

{ TMalinaReceipt }

class function TMalinaReceipt.CreateReceipt(const Params: TMalinaParamsRec): WideString;
var
  Line: WideString;
  Points: Integer;
  Lines: TTntStrings;
begin
  Lines := TTntStringList.Create;
  try
    Lines.Add('     ВР ГРАЖДАНСКИЙ (АЗК 009)       ');
    Lines.Add('  ООО "ТНК-ВР Северная столица"     ');
    Lines.Add('  Северная пл., 2, тел. 332-72-56   ');
    Lines.Add('                                    ');
    Lines.Add('ККМ 00019976 ИНН 007802411512  #8552');
    Lines.Add('22.08.10 23:14                      ');
    Lines.Add('ПРОДАЖА                        №1283');
    Lines.Add('ТРК 4: Бензин 95          Трз  41457');
    Lines.Add('                      23.59 X 51.710');
    Lines.Add('1                           =1219.84');

    Line := Copy(Params.CardPrefix, 1, 20);
    Line := Line + StringOfChar(' ', 20 - Length(Line));
    Lines.Add(Line + '6393000039070330');

    Lines.Add('------------------------------------');
    Lines.Add('Подитог:                     1219.84');

    Line := Copy(Params.SaleText, 1, 36);
    Lines.Add(Line);
    Lines.Add('№ карты малина:     6393000039070330');

    Points := 0;
    if Params.MalinaCoeff <> 0 then
      Points := Trunc(1219.84/Params.MalinaCoeff)*Params.MalinaPoints;

    Line := Tnt_WideFormat('Начислено %d баллов', [Points]);
    Lines.Add(Line);
    Lines.Add('                                    ');
    Lines.Add('Оператор: Иванова Т.И. ID: 254889   ');
    Lines.Add('ИТОГ                        =1219.84');
    Lines.Add('НАЛИЧНЫМИ                   =1500.00');
    Lines.Add('СДАЧА                        =280.16');
    Lines.Add('------------ ФП --------------------');
    Lines.Add('                     ЭКЛЗ 0670467138');
    Lines.Add('                    00102672 #056284');
    Lines.Add('       Клиенту правила              ');
    Lines.Add('     оказания услуг ясны            ');

    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

(*
     ВР ГРАЖДАНСКИЙ (АЗК 009)
  ООО "ТНК-ВР Северная столица"
  Северная пл., 2, тел. 332-72-56

ККМ 00019976 ИНН 007802411512  #8552
22.08.10 23:14
ПРОДАЖА                        №1283
ТРК 4: Бензин 95          Трз  41457
                      23.59 X 51.710
1                           =1219.84
Номер карты:        6393000039070330
------------------------------------
Подитог:                     1219.84
- 1.5%
СКИДКА                        =18.30
Перечислено Малина
1                             =18.30

Оператор: Иванова Т.И. ID: 254889
ИТОГ                        =1219.84
НАЛИЧНЫМИ                   =1500.00
СДАЧА                        =280.16
------------ ФП --------------------
                     ЭКЛЗ 0670467138
                    00102672 #056284
       Клиенту правила
     оказания услуг ясны

*)

end.

