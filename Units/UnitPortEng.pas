unit UnitPortEng;

interface

type
  TString = string;

// Шифрование / дешифрование текстового файла
// методом диаграммы Порта
function PortEng(Text_str: TString): TString;

// инициализация параметров
procedure InitializationPortEng(Clue_Str1: TString);

implementation

uses
  Dialogs, UnitMainForm;

type
  TSMass = array[0..12] of char;

var
  Clue_Str: TString;

// Функция перевода всех строчных букв
// заданной строки в прописные
function ConvertPortEng(const Uppercase_L1,
                        Lowercase_L1: TEngMass;
                        Text_str1: string): string;

var
  I, J: integer;
// Found - переменная показывающая,
// найден ли элемент по заданному условию
  Found: boolean;

begin
  Result := Text_str1;
// Цикл перевода всех строчных букв
// введенного текста в прописные
  for I := 1 to length(Result) do
  begin
    Found := false;

// Цикл сравнения введенной буквы
// со строчными буквами алфавита
    J := 0;
    while not(Found) and(J <= 25) do
    begin
      if Result[I] = Lowercase_L1[J] then
      begin
         Result[I] := Uppercase_L1[J];
         Found := true
      end;
      inc(J)
    end;

  end
end;

// Функция шифрования(дешифрования) строки Text_Str
function ToEncryptPortEng(const Uppercase_L1: TEngMass;
                          const Clue_Str1, Text_Str1:
                          string): string;

// В шифровании(дешифровании) методом диаграммы Порта
// ипользуются разделенный на две части алфавит. Первая
// часть не меняется, а вторая сдвигается циклически
// влево согласно номеру буквы ключа в алфавите.
// A, B - нет сдвига, C, D - сдвиг на 1 ...
// Y, Z - сдвиг на 12
const

  FirstP: TSMass = ('A','B','C','D','E','F',
                    'G','H','I','J','K','L','M');

  SecondP: TSMass = ('N','O','P','Q','R','S',
                     'T','U','V','W','X','Y','Z');

var
// Ch_Num - номер текущей буквы в строке ключа,
// по которому шифруется(дешифруется) следующая буква
// N_El - номер текущей буквы строки-ключа
// в алфавите
  I, J, Ch_Num, N_El: integer;
// Found - переменная показывающая,
// найден ли элемент по заданному условию
  Found: boolean;

begin

// Инициализация
  Ch_Num := 1;
  Found := true;
  Result := Text_Str1;
  N_El := 0;

// Цикл перебора букв шифруемого(дешифруемого) текста
  for I := 1 to length(Result) do
  begin

// Нахождение номера новой буквы ключа в алфавите.
// Если Found = false, то предыдущая буква текста
// не была обработана - значит брать следующую
// букву ключа не надо.
    if Found then
    begin
      N_El := 0;
      while Clue_Str1[Ch_Num] <> Uppercase_L1[N_El] do
        inc(N_El);
    end;

    Found := false;
    J := 0;

// Цикл нахождения номера текущей буквы текста
// шифрования(дешифрования) в алфавите.
    while (J <= 25) and not(Found) do
      if Text_Str1[I] = Uppercase_L_E[J] then
        Found := true
      else
        inc(J);

// Шифрование(дешифрование) буквы Text_Str1, если эта
// буква находится в первой части алфавита.
    if Found and (J <= 12)  then
    begin
      Result[I] := SecondP[(J + 13 - N_El div 2) mod 13];
      Ch_Num := 1 + Ch_Num mod length(Clue_Str1);
    end;

// Шифрование(дешифрование) буквы Text_Str1, если эта
// буква находится во второй части алфавита.
    if Found and (J > 12)  then
    begin
      Result[I] := FirstP[(J + N_El div 2) mod 13];
      Ch_Num := 1 + Ch_Num mod length(Clue_Str1);
    end;

  end;

end;

// Функция удаления элементов из строки-ключа,
// которые не являются буквами алфавита
function DelExCh(const Uppercase_L1: TEngMass; const
                 Clue_Str1: string ): string;

var
  I, J: integer;
// Found - переменная показывающая,
// найден ли элемент по заданному условию
  Found: boolean;

begin
// Перебор элементов строки-ключа
  for I := 1 to length(Clue_Str1) do
  begin
    J := 0;
    Found := false;

// Цикл сравнивания символов строки-ключа с буквами
// алфавита. Если символ не входит в алфавит, он не
// заносится в результитующую строку-ключ.
    repeat
      if Clue_Str1[I] = Uppercase_L1[J] then
      begin
        Found := true;
        Result := Result + Clue_Str1[I]
      end;
      inc(J);
    until Found or (J > 25)

  end
end;

procedure InitializationPortEng(Clue_Str1: TString);
begin

// Перевод всех строчных букв строк в прописные
  Clue_Str := ConvertPortEng(Uppercase_L_E,
                             Lowercase_L_E, Clue_Str1);
// Удаление всех сиволов, не входящих в алфавит,
// из строки-ключа
  Clue_Str := DelExCh(Uppercase_L_E, Clue_str);

  if Clue_str = '' then
    Error := true
end;

function PortEng(Text_str: TString): TString;

begin

// Перевод всех строчных букв строк в прописные
  Text_Str := ConvertPortEng(Uppercase_L_E,
                             Lowercase_L_E, Text_str);

  if Clue_str = '' then
  begin
    showmessage('Некорректный ключ');
    Result := Text_Str
  end
  else
  begin

// Шифрование(дешифрование) Text_Str
    Text_Str := ToEncryptPortEng(Uppercase_L_E,
                                 Clue_Str, Text_str);
    Result := Text_Str;
  end;
end;
end.
