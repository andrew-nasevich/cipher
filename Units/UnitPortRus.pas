unit UnitPortRus;

interface

type
  TString = string;

function PortRus(Text_Str: TString): TString;

// Инициализация
procedure InitializationPortRus(Clue_Str1: TString);

implementation

uses
  Dialogs, UnitMainForm;

type
  TMass = array[0..31] of char;
  TSMass = array[0..15] of char;

const

// Uppercase_L - массив прописных букв
// английского алфавита
  Uppercase_L: TMass = ('А','Б','В','Г','Д','Е','Ж','З',
                        'И','Й','К','Л','М','Н','О','П',
                        'Р','С','Т','У','Ф','Х','Ц','Ч',
                        'Ш','Щ','Ъ','Ы','Ь','Э','Ю','Я');


// Lowercase_L - массив строчных букв
// английского алфавита
  Lowercase_L: TMass = ('а','б','в','г','д','е','ж','з',
                        'и','й','к','л','м','н','о','п',
                        'р','с','т','у','ф','х','ц','ч',
                        'ш','щ','ъ','ы','ь','э','ю','я');

var
  Clue_Str: TString;

// Функция перевода всех строчных букв в прописные
function ConvertPortRus(const Uppercase_L1,
         Lowercase_L1: TMass;Text_str1: Tstring):
         Tstring;

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

// Исключительный случай: буква 'ё' всегда заменяется
// на 'Е' т.к. диаграмма Порта должна иметь четное
// количество символов
    if Result[I] in ['ё', 'Ё'] then
    begin
      Found := true;
      Result[I] := 'Е'
    end;

// Цикл сравнения введенной буквы
// со строчными буквами алфавита
    J := 0;
    while not(Found) and (J <= 31) do
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
function ToEncryptPortRus(const Uppercase_L1: TMass;
                          const Clue_Str1, Text_Str1:
                          Tstring): Tstring;

// В шифровании(дешифровании) методом диаграммы Порта
// ипользуются разделенный на две части алфавит. Первая
// часть не меняется, а вторая сдвигается циклически
// влево согласно номеру буквы ключа в алфавите.
// А, Б - нет сдвига, В, Г - сдвиг на 1 ...
// Ю, Я - сдвиг на 15
const

  FirstP: TSMass = ('А','Б','В','Г','Д','Е','Ж','З',
                    'И','Й','К','Л','М','Н','О','П');

  SecondP: TSMass = ('Р','С','Т','У','Ф','Х','Ц','Ч',
                     'Ш','Щ','Ъ','Ы','Ь','Э','Ю','Я');

var
// Ch_Num - номер текущей буквы в строке-ключе,
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
    while (J <= 31) and not(Found) do
      if Text_Str1[I] = Uppercase_L[J] then
        Found := true
      else
        inc(J);

// Шифрование(дешифрование) буквы Text_Str1, если эта
// буква находится в первой части алфавита.
    if Found and (J <= 15)  then
    begin
      Result[I] := SecondP[(J + 16 - N_El div 2) mod 16];
      Ch_Num := 1 + Ch_Num mod length(Clue_Str1);
    end;

// Шифрование(дешифрование) буквы Text_Str1, если эта
// буква находится во второй части алфавита.
    if Found and (J > 15)  then
    begin
      Result[I] := FirstP[(J + N_El div 2) mod 16];
      Ch_Num := 1 + Ch_Num mod length(Clue_Str1);
    end;

  end;

end;

// Функция удаления элементов из строки-ключа,
// которые не являются буквами алфавита
function DelExCh(const Uppercase_L1: TMass; const
                 Clue_Str1: TString ): TString;

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
    until Found or (J > 32)

  end
end;

procedure InitializationPortRus(Clue_Str1: TString);
begin

// Перевод всех строчных букв строк в прописные
  Clue_Str := ConvertPortRus(Uppercase_L, Lowercase_L,
                             Clue_Str1);
// Удаление всех сиволов, не входящих в алфавит,
// из строки-ключа
  Clue_str := DelExCh(Uppercase_L, Clue_str);

  if Clue_str = '' then
  begin
    showmessage('Некорректный ключ');
    Error := true;
  end
end;

function PortRus(Text_Str: TString): TString;

// Функция перевода всех строчных букв
// заданной строки в прописные

begin

// Перевод всех строчных букв строк в прописные
  Text_Str := ConvertPortRus(Uppercase_L, Lowercase_L,
                             Text_str);

  if not Error then
  begin

// Шифрование(дешифрование) Text_Str
    Text_Str := ToEncryptPortRus(Uppercase_L, Clue_Str,
                                 Text_str);
    Result := Text_str;

  end
  else
    Result := Text_str;
end;

end.
