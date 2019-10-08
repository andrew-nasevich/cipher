unit UnitAbelEng;

interface

type
  TString = string;

// Функция шифрование(дешифрование)
function AbelEng(Text: TString; ToEncrypt: boolean):
                 TString;

// Процедура инициализации переменных перед
// шифрованием(дешифрованием)
procedure InitializationAbelEng(Clue1, Data_Clue1,
          Session_Clue1, Text_Clue1: TString; ToEncrypt:
          boolean);

implementation

uses
  SysUtils, Dialogs, UnitMainForm;

type
// Тип матрицы, в которой хванятся буквы алфавита +
// используемые символы( буквы идут до 25-ой позиции,
// а затем - символы)
  TMass = array[0..28] of char;
// Тип фразы-ключа
  TClue_Mass = array[0..9] of integer;
// Тип массива, используемого для получения
// псевдослучайных чисел
  TNumMass =  array[0..19] of integer;

const

// Массив всевозможных ошибок ввода
  Error_Mass: array[1..4] of string =
   ('Ошибка. В ключевой дате должно быть 6 цифр',
    'Ошибка. В сеансовом ключе должно быть 5 цифр',
    'Ошибка. В тексте-ключе должно быть не менее 20 '+
    'букв',
    'Ошибка. В ключе должно быть 8 разных букв и 2 '+
    'пробела');

// Uppercase_L - массив прописных букв английского
// алфавита плюс используемых символов
  Uppercase_L: TMass = ('A','B','C','D','E','F','G','H',
                        'I','J','K','L','M','N','O','P',
                        'Q','R','S','T','U','V','W','X',
                        'Y','Z', ' ', '.', ',');

// Lowercase_L - массив строчных букв английского
// алфавита плюс используемых символов
  Lowercase_L: TMass = ('a','b','c','d','e','f','g','h',
                        'i','j','k','l','m','n','o','p',
                        'q','r','s','t','u','v','w','x',
                        'y','z', ' ', '.', ',');

var
// Data_Clue_M -  массив, используемый в 1, 3 и 4 этапах
// шифрования(дешифрования) для получения
// псевдослучайных чисел
  Data_Clue_M : TClue_Mass;
// Space_N - количество пробелов в фразе-ключе.
// Их должно быть строго 2
  Space_N: integer;
// Num_Mass - массив, используемый во 2, 4, 5, 6 и 7
// этапах шифрования(дешифрования) для получения
// псевдослучайных чисел
  Num_Mass: TNumMass;
// Clue - фраза-ключ. Data_Clue - ключевая дата
// Session_Clue - сеансовый ключ
// Text_Clue - текстовый ключ
  Clue, Data_Clue, Session_Clue, Text_Clue: TString;




// Функция перевода всех строчных букв в прописные
function Convert(const Uppercase1, Lowercase_L1: TMass;
                 C_string: string): string;

var
  I, J: integer;
// Found - переменная показывающая,
// найден ли элемент по заданному условию
  Found: boolean;

begin
  Result := C_string;
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
         Result[I] := Uppercase1[J];
         Found := true
      end;
      inc(J)
    end;

  end
end;



// Функция удаления элементов из строки,
// которые не являются буквами алфавита
// N - переменная, обозначающая включать или не включать
// символы в проверку. N = 25 - сравнить с элементами
// алфавита до 25 смвола, N = 28 - ставнить до 28.
// После 25 элемента алфавита идут знаки(' ', ',', '.')
function DelExCh(const Uppercase1: TMass; const
                 Str: string; N: integer): string;

var
  I, J: integer;
// Found - переменная показывающая,
// найден ли элемент по заданному условию
  Found: boolean;

begin
// Перебор элементов строки
  for I := 1 to length(Str) do
  begin
    J := 0;
    Found := false;

// Цикл сравнения символов строки с символами
// алфавита. Если символ не входит в алфавит, он не
// заносится в результитующую строку.
    repeat
      if Str[I] = Uppercase1[J] then
      begin
        Found := true;
        Result := Result + Str[I]
      end;
      inc(J);
    until Found or (J > N)

  end
end;

// Функция нумерации букв от 1 до 10(10 эквивалентно 0)
// в строке от Start позици до Finish
function ToNumber(const Num_Mass1: TNumMass; const
                  Uppercase_L1: TMass; const Text_Clue1:
                  string; const Start, Finish: integer):
                  TNumMass;

var
// Position - номер буквы
  I, J, Position: integer;
// Found - переменная показывающая,
// найден ли элемент по заданному условию
  Found: boolean;

begin
// Инициализация параметров
  Result := Num_Mass1;
  Position := 1;
  for I := Start to Finish do
    Result[I] := -1;

// Цикл нумерации букв
  while Position <= 10 do
  begin
    I := 0;
    Found := false;
// Цикл перебора букв алфавита
    while (I <= 25) and not(Found) do
    begin
      J := Start + 1;
      Found := false;
// Цикл перебора букв в указанной области
      while not(Found) and (J <= Finish + 1) do
        if (Text_Clue1[J] = Uppercase_L1[I]) and
           (Result[J - 1] = -1) then
        begin
          Result[J - 1] := Position mod 10;
          inc(Position);
          Found := true;
        end
        else
          inc(J);
      inc(I)
    end
  end
end;

// Функция нумерации цифр Num_Mass1
// по возрастанию от 1 до 10(0)
function ToSort(const Num_Mass1:TNumMass): TNumMass;

var
// Num - текущий номер
  I, J, Num: integer;
// Mass_Of_Ready - массив обработки чисел
  Mass_Of_Ready: array[0..9] of boolean;
  Processed: boolean;

begin
// Инициализация переменных
  for I := 0 to 9 do
    Mass_Of_Ready[I] := false;
  Result := Num_Mass1;
  I := 1;
  Num := 1;

// Цикл нумерации
  while I <= 10 do
  begin
    Processed := false;
    J := 0;
// Цикл нахождения минимального необработанного цисла
    while (J <= 9) and not(Processed) do
    begin
      if (Num_Mass1[J] = I mod 10) and
          not(Mass_Of_Ready[J]) then
      begin
        Result[J] := Num mod 10;
        inc(Num);
        Mass_Of_Ready[J] := true;
        Processed := true;
      end
      else
      inc(J)

    end;
    if not Processed then
      inc(I)
  end
end;

// Функция дешифрования
function ToDecryptStr(const Text1, Clue1: string;
                    const Num_Mass1: TNumMass;
                    const Uppercase_L1: TMass): TString;

var
// FSN - First spase number, SSN - Second string number
  I, J, FSN, SSN: integer;
// Mass - матрица шифрования(дешифрования)
  Mass: array[0..29] of char;
  UsedMass: array[0..29] of boolean;
  Processed: boolean;

begin

//Инициализация переменных
  FSN := -1;
  SSN := -1;
  Result := '';

  for I := 0 to 29 do
    UsedMass[I] := false;

// Нахождение номеров пробелов в Num_Mass1
  for I := 1 to length(Clue1) do
  begin
    if (FSN = -1) and (Clue1[I] = ' ') then
      FSN := Num_Mass1[I - 1]
    else
      if (SSN = -1) and (Clue1[I] = ' ') then
        SSN := Num_Mass1[I - 1]
  end;

// Запись фразы-ключа в матрицу шифрования(дешифрования)
  for I := 0 to 9 do
  begin
    Mass[I] := Clue1[I + 1];
    Processed := false;
    J := 0;
    while (J <= 28) and not(Processed) do
    begin
      if Clue1[I + 1] = Uppercase_L1[J] then
      begin
        UsedMass[J] := true;
        Processed := true;
      end
      else
        inc(J);
    end;
  end;

// Запись всех оставшихся сиволов в матрицу шифрования
// (дешифрования)
  I := 10;
  for J := 0 to 28 do
  begin
    if not(UsedMass[J]) then
    begin
      Mass[I] := Uppercase_L1[J];
      inc(I);
    end;
  end;

// Цикл перебора букв Text1
// Если зашифрованная буква в матрице-шифрования
// находилась на отрезке от 0 до 9, она представляется
// одно цифрой, иначе - двумя
  I := 1;
  while I <= length(Text1) do
  begin
// Дешифрования буквы, если она находилась на отрезке
// от 10 до 19
    if strtoint(Text1[I]) = FSN then
    begin
      inc(I);
      Processed := false;
      J := 0;
      while (J <= 9) and not Processed do
      begin
        if (Num_Mass1[J]) = strtoint(Text1[I]) then
        begin
          Result := Result + Mass[10 + J];
          Processed := true
        end
        else
          inc(J)
      end
    end
    else
// Дешифрования буквы, если она находилась на отрезке
// от 20 до 29
      if strtoint(Text1[I]) = SSN then
      begin
        inc(I);
        Processed := false;
        J := 0;
        while (J <= 9) and not Processed do
        begin
          if Num_Mass1[J] = strtoint(Text1[I]) then
          begin
            Result := Result + Mass[20 + J];
            Processed := true
          end
          else
            inc(J)
        end
      end
      else
// Дешифрования буквы, если она находилась на отрезке
// от 0 до 9
      begin
        Processed := false;
        J := 0;
        while (J <= 9) and not Processed do
        begin
          if Num_Mass1[J] = strtoint(Text1[I]) then
          begin
            Result := Result + Mass[J];
            Processed := true
          end
          else
            inc(J)
          end
      end;
    inc(I)
  end
end;

// Функция шифрования текста
function ToEncryptStr(const Text1, Clue1: string;
                   const Num_Mass1: TNumMass;
                   const Uppercase_L1: TMass): TString;

var
// FSN - First string number, SSN - Second string number
  I, J, FSN, SSN: integer;
// Mass - матрица шифрования
  Mass: array[0..29] of char;
  UsedMass: array[0..29] of boolean;
  Processed: boolean;

begin
//Инициализация переменных
  FSN := -1;
  SSN := -1;
  Result := '';
  for I := 0 to 29 do
    UsedMass[I] := false;

// Нахождение номеров пробелов в Num_Mass1
  for I := 1 to length(Clue1) do
  begin
    if (FSN = -1) and (Clue1[I] = ' ') then
      FSN := Num_Mass1[I - 1]
    else
      if (SSN = -1) and (Clue1[I] = ' ') then
        SSN := Num_Mass1[I - 1]
  end;

// Запись фразы-ключа в матрицу шифрования
  for I := 0 to 9 do
  begin
    Mass[I] := Clue1[I + 1];
    Processed := false;
    J := 0;
    while (J <= 28) and not(Processed) do
    begin
      if Clue1[I + 1] = Uppercase_L1[J] then
      begin
        UsedMass[J] := true;
        Processed := true;
      end
      else
        inc(J);
    end;
  end;

// Запись всех оставшихся сиволов в матрицу шифрования
  I := 10;
  for J := 0 to 28 do
  begin
    if not(UsedMass[J]) then
    begin
      Mass[I] := Uppercase_L1[J];
      inc(I);
    end;
  end;

// Цикл перебора букв Text1
  for I := 1 to length(Text1) do
  begin
    Processed := false;
    J := 0;
// Цикл нахождения буквы в Text1
// и вывода соответствующего кода
    while (J <= 29) and not(Processed) do
    begin
      if Text1[I] = Mass[J] then
      begin
        if Text1[I] <> ' ' then
          case J div 10 of
            0: Result := Result + inttostr
                        (Num_Mass1[J]);
            1: Result := Result + inttostr(FSN) +
                         inttostr(Num_Mass1[J mod 10]);
            2: Result := Result + inttostr(SSN) +
                         inttostr((Num_Mass1
                         [J mod 10]));
          end;
        Processed := true
      end
      else
        inc(J)
    end
  end
end;

// Функция удаления одинаховых символов из строки Str
function DelSame(Const Str:string): string;

var
  I, J: integer;
// Same - переменная для обозначения дублирующейся буквы
  Same: boolean;
begin
  Result := Result + Str[1];
// Цикл перебора букв  Str
  for I := 2 to length(Str) do
  begin
    Same := false;
    J := length(Result) ;
// Цикл сравнения буквы со всеми предыдущими буквами
    while not(Same) and (J >= 1)  do
    begin
      if Result[J] = Str[I] then
        Same := true
      else
        dec(J)
    end;
// Символ не дублировался или является
// пробелом - вставить в результат
    if not(Same) or (Str[i] = ' ') then
      Result := Result + Str[I]
  end
end;

// Инициализация
procedure InitializationAbelEng(Clue1, Data_Clue1,
          Session_Clue1, Text_Clue1: TString; ToEncrypt:
          boolean);

var
  K: integer;

begin

// Инициализация переменных
  Clue := Clue1;
  Data_Clue := Data_Clue1;
  Session_Clue := Session_Clue1;
  Text_Clue := Text_Clue1;

// Проверка ключевой даты на корректность
  if length(Data_Clue) <> 6 then
    Error_N := 1;
  if Error_N = 0 then
    for K := 1 to 6 do
      if not(Data_Clue[K] in ['0'..'9']) then
        Error_N := 1;

// Проверка сеансового ключа на корректность
  if length(Session_Clue) <> 5 then
    Error_N := 2;
  if Error_N = 0 then
    for K := 1 to 5 do
      if not(Session_Clue[K] in ['0'..'9']) then
        Error_N := 2;

// Преобразование всех строчных букв текстого ключа в
// прописные и удаление всех символов, которые не
// являтся буквами
  if Error_N = 0 then
  begin
    Text_Clue := Convert(Uppercase_L, Lowercase_L,
                         Text_Clue);
    Text_Clue := DelExCh(Uppercase_L, Text_Clue, 25)
  end;

// После всех обработок текстовый ключ
// должен быть длинне 20 букв
  if length(Text_Clue) < 20 then
    Error_N := 3;

// Преобразование всех строчных букв фразы-ключа в
// прописные и удаление всехповторяющихся символов и
// символов, которые не являтся буквами
  if Error_N = 0 then
  begin
    Clue := Convert(Uppercase_L, Lowercase_L, Clue);
    Clue := DelExCh(Uppercase_L, Clue, 28);
    Clue := DelSame(Clue)
  end;

// После всех обработок фраза-ключ
// должена быть длиннее 10 букв
  if  length(Clue) <> 10 then
    Error_N := 4;

// Подсчет пробелов в фразе ключе: их должно быть 2
  Space_N := 0;
  if Error_N = 0 then
  begin
    for K := 0 to length(Clue) do
      if Clue[K] = ' ' then
        inc(Space_N);
    if Space_N <> 2 then
      Error_N := 4;
  end;

  if Error_N <> 0 then
    showmessage(Error_Mass[Error_N])
  else
  begin

// Первый шаг получения псевдослучайных чисел
    for K := 1 to 5 do
    begin
      Data_Clue_M[K - 1] := (strtoint(Session_Clue[K]) -
                             strtoint(Data_Clue[K]))
                             mod 10;
      if Data_Clue_M[K - 1] < 0 then
        Data_Clue_M[K - 1] := Data_Clue_M[K - 1] + 10
    end;

// Второй шаг получения псевдослучайных чисел
    Num_Mass := ToNumber(Num_Mass, Uppercase_L,
                         Text_Clue, 0, 9);
    Num_Mass := ToNumber(Num_Mass, Uppercase_L,
                         Text_Clue, 10, 19);

// Третий шаг получения псевдослучайных чисел
    for K := 5 to 9 do
      Data_Clue_M[K] := (Data_Clue_M[K - 5] +
                         Data_Clue_M[K - 4]) mod 10;

// Четвертый шаг получения псевдослучайных чисел
    for K := 0 to 9 do
      Num_Mass[K] := (Num_Mass[K] + Data_Clue_M[K])
                      mod 10;

// Пятый шаг получения псевдослучайных чисел
    for K := 0 to 9 do
      Num_Mass[K] := Num_Mass[Num_Mass[K] + 10 - 1];

// Шестой шаг получения псевдослучайных чисел
    for K := 0 to 49 do
      Num_Mass[K mod 10] := (Num_Mass[K mod 10] +
                             Num_Mass[(K + 1) mod 10])
                             mod 10;

// Седьмой шаг получения псевдослучайных чисел
    Num_Mass := ToSort(Num_Mass);
end;
end;

function AbelEng(Text: TString; ToEncrypt: boolean):
                 TString;

var
  K: integer;

begin

  if Error_N <> 0 then
    Result := Text
  else
  begin
    Result := '';
// Преобразование всех строчных букв текста в прописные
// и удаление всех символов, которые не входят в алфавит
    if ToEncrypt then
    begin
      Text := Convert(Uppercase_L, Lowercase_L, Text);
      Text := DelExCh(Uppercase_L, Text, 28);
    end
    else
    begin
      K := 1;
      while K <= length(Text) do
      begin
        if not (Text[K] in ['0'..'9']) then
          delete(Text, K, 1)
        else
          inc(K)
      end
    end;

// Шифрование(дешифрование) текста
    if ToEncrypt then
        Result := ToEncryptStr(Text, Clue, Num_Mass,
                               Uppercase_L)
    else
      Result := ToDecryptStr(Text, Clue, Num_Mass,
                             Uppercase_L)
  end;
end;

end.
