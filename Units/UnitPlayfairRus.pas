unit UnitPlayfairRus;

interface

type
  TMass = array[0..35] of char;
  TString = string;

// Функция шифрования введенного текста
// Функция шифрует буквы попарно
function PlayfairRus(Text_Str: TString; ToEncrypt:
                     boolean): TString;

// Инициализация пвараметров
procedure InitializationPlayfairRus(Clue_Str: TString);

implementation

const
// Массив всех прописных букв(плюс ' ', '.', ',', т.к.
// все элементы матрицы шифрования должны быть заполнены)
  Uppercase_L: TMass = ('А','Б','В','Г','Д','Е','Ё','Ж',
                        'З','И','Й','К','Л','М','Н','О',
                        'П','Р','С','Т','У','Ф','Х','Ц',
                        'Ч','Ш','Щ','Ъ','Ы','Ь','Э','Ю',
                        'Я',' ','.',',');
// Массив всех строчных букв((плюс ' ', '.', ',', т.к.
// все элементы матрицы шифрования должны быть заполнены)
  Lowercase_L: TMass = ('а','б','в','г','д','е','ё','ж',
                        'з','и','й','к','л','м','н','о',
                        'п','р','с','т','у','ф','х','ц',
                        'ч','ш','щ','ъ','ы','ь','э','ю',
                        'я',' ','.',',');
var
// Массив букв, который должны быть занесены в матрицу
// шифрования. Если занести букву в матрицу шифрования,
// она удаляется из этого масива - буквы в матрице
// шифрования не повторяются
  Char_Mass: TMass;
// Mass - матртица шифрования
  Mass: TMass;

procedure InitializationPlayfairRus(Clue_Str: TString);

var
  I, J, K: integer;
// Processed - переменная для отслеживания
// обработки текущей буквы
  Processed: boolean;

begin
  Char_Mass := Uppercase_L;
  K := 0;

// Запись ключа в матрицу шифрования
  for I := 1 to length(Clue_str) do
  begin
    J := 0;
    Processed := false;
// Цикл проверки: является ли введенный символ буквой
// алфавита. Если является и до этого момента не
// присутствавал в в ключе, записать в матрицу, иначе
// перейти к следуюшему символу.
    repeat
      if (Clue_Str[I] = Lowercase_L[J]) or
         (Clue_Str[I] = Uppercase_L[J]) then
      begin
        if Char_Mass[J] <> '*' then
        begin
          Mass[K] := Char_Mass[J];
          Char_Mass[J] := '*';
          inc(K);
        end;
        Processed := true
      end;
      inc(J);
    until (J > 35) or Processed ;
  end;

// Цикл записи в матрицу всех букв, не входивших в ключ
  for I := 0 to 35 do
    if Char_Mass[I] <> '*' then
    begin
      Mass[K] := Char_Mass[I];
      Char_Mass[I] := '*';
      inc(K)
    end;
end;

function PlayfairRus(Text_Str: TString;
                     ToEncrypt: boolean): TString;

var
  I, J: integer;
// Processed - переменная для отслеживания
// обработки текущей буквы
  Processed: boolean;

// Функция нахождения номера подходящего знака
// (входящего в алфавит) из введенной строки, начиная
// с позиции Num. Есди функция возвращает значение "36",
// то в значит, что в строке больше нет
// подходящих символов
function Found_El(const Mass2: TMass; var Num: integer;
                  const Text_Str2: string) : integer;

var
// Found - переменная для отслеживания нахождения знака
// в алфавите
  Found: boolean;

begin
  Found := false;
// Цицл перебора знаков введенного текста
  repeat
    Result := 0;
// Цикл сравнения введенного знака с буквами алфавита
    while (Result <= 35) and not(Found) do
      if Text_Str2[Num] = Mass2[Result] then
        Found := true
      else
        inc(Result);
    if not(Found) and (Num <= length(Text_str2)) then
      inc(Num)
  until Found or (Num > length(Text_str2));
end;

function Convert(const Mass1: TMass; const Text_Str1:
                 string; ToEncrypt1: boolean): string;

var
// Num1, Num2 - номера позиций шифруемых букв в
// введенном тесте I1, I2 - номера позиций в матрице
// шифрования первой и второй буквы
  Num1, Num2, I1, I2: integer;
// Ready - переменная для отслеживания обработки пары букв
  Ready: boolean;


begin

// Инициализация переменных
  Result := Text_str1;
  Num1 := 1;
  Num2 := 1;
  I2 := 0;

// Цикл шифрования введенного текста
  while (Num1 <= length(Text_Str1)) and
        (Num2 <= length(Text_Str1)) do
  begin
// Нахождение первой подходящей буквы во
// введенном тексте
    I1 := Found_El(Mass1, Num1, Text_Str1);
    if I1 <> 36 then
    begin
      Num2 := Num1 + 1;
// Нахождение второй подходящей буквы во
// введенном тексте
      I2 := Found_El(Mass1, Num2, Text_Str1)
    end;
    if (I1 <> 36) and (I2 <> 36) then
    begin
      Ready := false;

// Если буквы совпали, они не шифруются
      if I1 = I2 then
        Ready := true;

      if ToEncrypt1 then
      begin
// Если буквы находятся в одной строке,эти буквы
// заменаяются на следующие буквы в этой строке
// (если одна буква последняя в строке, то она
// заменяется на первую букву в этой строке)
        if not(Ready) and (I1 div 6 = I2 div 6) then
        begin
          Result[Num1] := Mass1[I1 + 1 - 6 * ((I1 + 1)
                                div 6 - I1 div 6)];
          Result[Num2] := Mass1[I2 + 1 - 6 * ((I2 + 1)
                                div 6 - I2 div 6)];
          Ready := true
        end;

// Если буквы находятся в одном столбце, эти буквы
// заменаяются на следующие буквы в этом столбце
// (если одна буква последняя в столбце, то она
// заменяется на первую букву в этом столбце)
        if not(Ready) and (I1 mod 6 = I2 mod 6) then
        begin
          Result[Num1] := Mass1[(I1 + 6) mod 36];
          Result[Num2] := Mass1[(I2 + 6) mod 36];
          Ready := true
        end;
      end
      else
      begin
// Если буквы находятся в одной строке, эти буквы
// заменаяются на следующие буквы в этой строке
// (если одна буква последняя в строке, то она
// заменяется на первую букву в этой строке)
        if not(Ready) and (I1 div 6 = I2 div 6) then
        begin
          if (I1 = 0) or (I2 = 0) then
          begin
            if I1 = 0 then
            begin
              Result[Num1] := Mass1[5];
              Result[Num2] := Mass1[I2 - 1]
            end
            else
            begin
              Result[Num1] := Mass1[I1 - 1];
              Result[Num2] := Mass1[5]
            end;
          end
          else
          begin
            Result[Num1] := Mass1[I1 - 1 + 6*(I1 div 6 -
                                 (I1 - 1) div 6)];
            Result[Num2] := Mass1[I2 - 1 + 6*(I2 div 6 -
                                 (I2 - 1) div 6)];
          end;
          Ready := true
        end;

// Если буквы находятся в одном столбце, эти буквы
// заменаяются на следующие буквы в этом столбце
// (если одна буква последняя в столбце, то она
// заменяется на первую букву в этом столбце)
        if not(Ready) and (I1 mod 6 = I2 mod 6) then
        begin
          Result[Num1] := Mass1[(I1 + 30) mod 36];
          Result[Num2] := Mass1[(I2 + 30) mod 36];
          Ready := true
        end;
      end;

// Если буквы не подошли по всем другим условиям, то
// она заменяются на буквы стоящие по принципу
// прямоугольника. У первой буквы свой номер строки,
// но столбец втрой буквы, а у второй буквы свой номер
// строки, но столбец первой буквы (в данной программе
// матрица шифования одномерная, поэтому вычисления
// происходят иначе, но сам принцин ничем не отличается)
      if not(Ready) then
      begin
        Result[Num1] := Mass1[6 *(I1 div 6) + I2 mod 6];
        Result[Num2] := Mass1[6 *(I2 div 6) + I1 mod 6];
      end;

      Num1 := Num2 + 1
    end
  end;
end;

begin

// Цикл перевода всех строчных букв введенного текста
// в прописные
  for I := 1 to length(Text_Str) do
  begin
    Processed := false;

    J := 0;
// Цикл сравнения введенной буквы со строчными буквами
// алфавита счет ведется до 32, т.к. потом нет разницы
// между прописной и строчной буквой
    while (J <= 32) and not(Processed) do
    begin
      if Text_Str[I] = Lowercase_L[J] then
      begin
         Text_Str[I] := Uppercase_L[J];
         Processed := true
      end;
      inc(J)
    end
  end;

// Шифрование введенного текста
  Text_Str := Convert(Mass , Text_Str, ToEncrypt);
  Result := Text_Str;
end;

end.
