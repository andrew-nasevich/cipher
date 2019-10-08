unit UnitPlayfairEng;

interface

type
  TMass = array[0..24] of char;
  TString = string;

function PlayfairEng(Text_Str: TString; ToEncrypt: boolean): TString;

// Процедура инициализации
procedure InitializationPlayfairEng(Clue_Str: TString);

implementation

const
// Массив всех прописных букв(кроме 'J', т.к. в
// биграммном шифре Плейфера эта буква заменяется на 'I')
  Uppercase_L: TMass = ('A','B','C','D','E','F','G','H',
                        'I','K','L','M','N','O','P','Q',
                        'R','S','T','U','V','W','X','Y','Z');
// Массив всех строчных букв(кроме 'j', т.к. в
// биграммном шифре Плейфера эта буква заменяется на 'I')
  Lowercase_L: TMass = ('a','b','c','d','e','f','g','h',
                        'i','k','l','m','n','o','p','q',
                        'r','s','t','u','v','w','x','y',
                        'z');
var
// Массив букв, который должны быть занесены в матрицу шифрования
// (Если занести букву в матрицу шифрования, она удаляется из
// этого массива - буквы в матрице шифрования не повторяются)
  Char_Mass: TMass ;
// Mass - матртица шифрования
  Mass: TMass;

procedure InitializationPlayfairEng(Clue_Str: TString);

var
  I, J, K: integer;
// Processed - переменная для отслеживания обработки
// текущей буквы
  Processed: boolean;

begin
  Char_Mass := Uppercase_L;
  K := 0;

// Запись ключа в матрицу шифрования
  for I := 1 to length(Clue_str) do
  begin
// Исключительный случай: каждая J меняется на I
    if (Clue_Str[I] = 'J') or (Clue_Str[I] = 'j') then
        Clue_Str[I] := 'I';
    Processed := false;
    J := 0;
// Цикл проверки: является ли введенный символ буквой алфавита.
// Если является и до этого момента не присутствовал в ключе,
// записать в матрицу, иначе перейти к следующему символу.
    repeat
      if (Clue_Str[I] = Lowercase_L[J]) or (Clue_Str[I] = Uppercase_L[J]) then
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
    until (J > 24) or Processed ;
  end;

// Цикл записи в матрицу всех букв(без J), не входивших в ключ
  for I := 0 to 24 do
    if Char_Mass[I] <> '*' then
    begin
      Mass[K] := Char_Mass[I];
      Char_Mass[I] := '*';
      inc(K)
    end;
end;



// Функция нахождения номера подходящего знака(входящего в алфавит)
// из введенной строки, начиная с позиции Num
// Если функция возвращает значение "25", то в значит, что в строке
// больше нет подходящих символов
function Found_El(const Mass2: TMass; var Num: integer; const Text_Str2: string) : integer;

var
// Found - переменная для отслеживания нахождения знака в алфавите
  Found: boolean;

begin
  Found := false;
// Цицл перебора знаков введенного текста
  repeat
    Result := 0;
// Цикл сравнения введенного знака с буквами алфавита
    while (Result <= 24) and not(Found) do
      if Text_Str2[Num] = Mass2[Result] then
        Found := true
      else
        inc(Result);
    if not(Found) and (Num <= length(Text_str2)) then
      inc(Num)
  until Found or (Num > length(Text_str2));
end;

// Функция шифрования введенного текста
// Функция шифрует буквы попарно
function Convert(const Mass1: TMass; const Text_Str1: string; ToEncrypt1: boolean): string;

var
// Num1, Num2 - номера позиций шифруемых букв в введенном тексте
// I1, I2 - номера позиций в матрице шифрования первой и второй буквы
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
  while (Num1 <= length(Text_Str1)) and (Num2 <= length(Text_Str1)) do
  begin
// Нахождение первой подходящей буквы во введенном тексте
    I1 := Found_El(Mass1, Num1, Text_Str1);
    if I1 <> 25 then
    begin
      Num2 := Num1 + 1;
// Нахождение второй подходящей буквы во введенном тексте
      I2 := Found_El(Mass1, Num2, Text_Str1)
    end;
    if (I1 <> 25) and (I2 <> 25) then
    begin
      Ready := false;

// Если буквы совпали, они не шифруются
      if I1 = I2 then
        Ready := true;

      if ToEncrypt1 then
      begin
// Если буквы находятся в одной строке, эти буквы заменяются
// на следующие буквы в этой строке(если одна буква последняя
// в строке, то она заменяется на первую букву в этой строке)
        if not(Ready) and (I1 div 5 = I2 div 5) then
        begin
          Result[Num1] := Mass1[I1 + 1 - 5 * ((I1 + 1) div 5 - I1 div 5)];
          Result[Num2] := Mass1[I2 + 1 - 5 * ((I2 + 1) div 5 - I2 div 5)];
          Ready := true
        end;

// Если буквы находятся в одном столбце, эти буквы заменяются
// на следующие буквы в этом столбце(если одна буква последняя
// в столбце, то она заменяется на первую букву в этом столбце)
        if not(Ready) and (I1 mod 5 = I2 mod 5) then
        begin
          Result[Num1] := Mass1[(I1 + 5) mod 25];
          Result[Num2] := Mass1[(I2 + 5) mod 25];
          Ready := true
        end;
      end
      else
      begin
// Если буквы находятся в одной строке, эти буквы заменаяются
// на следующие буквы в этой строке(если одна буква последняя
// в строке, то она заменяется на первую букву в этой строке)
        if not(Ready) and (I1 div 5 = I2 div 5) then
        begin
          if (I1 = 0) or (I2 = 0) then
          begin
            if I1 = 0 then
            begin
              Result[Num1] := Mass1[4];
              Result[Num2] := Mass1[I2 - 1]
            end
            else
            begin
              Result[Num1] := Mass1[I1 - 1];
              Result[Num2] := Mass1[4]
            end;
          end
          else
          begin
            Result[Num1] := Mass1[I1 - 1 + 5 * (I1 div 5 - (I1 - 1) div 5)];
            Result[Num2] := Mass1[I2 - 1 + 5 * (I2 div 5 - (I2 - 1) div 5)];
          end;
          Ready := true
        end;

// Если буквы находятся в одном столбце, эти буквы заменаяются
// на следующие буквы в этом столбце(если одна буква последняя
// в столбце, то она заменяется на первую букву в этом столбце)
        if not(Ready) and (I1 mod 5 = I2 mod 5) then
        begin
          Result[Num1] := Mass1[(I1 + 20) mod 25];
          Result[Num2] := Mass1[(I2 + 20) mod 25];
          Ready := true
        end;
      end;
// Если буквы не подошли по всем другим условиям, то
// она заменяются на буквы стоящие по принципу прямоугольника.
// У первой буквы свой номер строки, но столбец втрой буквы,
// а у второй буквы свой номер строки, но столбец первой буквы
// (в данной программе матрица шифования одномерная, поэтому
// вычисления происходят иначе, но сам принцин ничем не отличается)
      if not(Ready) then
      begin
        Result[Num1] := Mass1[5 *(I1 div 5) + I2 mod 5];
        Result[Num2] := Mass1[5 *(I2 div 5) + I1 mod 5];
      end;

      Num1 := Num2 + 1
    end
  end;
end;

function PlayfairEng(Text_Str: TString; ToEncrypt: boolean): TString;

var
  I, J: integer;
// Processed - переменная для отслеживания обработки
// текущей буквы
  Processed: boolean;
  
begin

// Цикл перевода всех строчных букв введенного текста в прописные
  I := 1;
  while I <= length(Text_Str) do
  begin
    Processed := false;

// Исключительный случай: буква 'j' всегда в биграммном шифре
// Плейфера заменяется на 'I'
    if Text_Str[I] in ['j', 'J'] then
    begin
      Text_Str[I] := 'I';
      Processed := true;
    end;

    J := 0;
// Цикл сравнения введенной буквы со строчными буквами алфавита
    while (J <= 24) and not(Processed) do
    begin
      if Text_Str[I] = Lowercase_L[J] then
      begin
         Text_Str[I] := Uppercase_L[J];
         Processed := true
      end;
      inc(J)
    end;
    inc(I)
  end;

// Шифрование введенного текста
  Text_Str := Convert(Mass , Text_Str, ToEncrypt);
  Result := Text_Str;
end;

end.
