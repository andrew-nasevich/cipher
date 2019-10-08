unit UnitAbelRus;

interface

type
  TString = string;

function AbelRus(Text: TString; ToEncrypt: boolean):
                 TString;

procedure InitializationAbelRus(Clue1, Data_Clue1,
          Session_Clue1, Text_Clue1: TString; ToEncrypt:
          boolean);

implementation

uses
  SysUtils,
  Dialogs, UnitMainForm;

type
// Тип матрицы, в которой хванятся буквы алфавита +
// используемые символы(буквы идут до 32-ой позиции,
// а затем - символы)
  TMass = array[0..37] of char;
// Тип фразы-ключа
  TClue_Mass = array[0..9] of integer;
// Тип массива, используемого для получения
// псевдослучайных чисел
  TNum_Mass =  array[0..19] of integer;

const
// Массив всевозможных ошибок ввода
  Error_Mass: array[1..4] of string =
   ('Ошибка. В ключевой дате должно быть 6 цифр',
    'Ошибка. В сеансовом ключе должно быть 5 цифр',
    'Ошибка. В тексте-ключе должно быть не менее 20' +
    ' букв',
    'Ошибка. В ключе должно быть 7 разных букв и 3 ' +
    'пробела');

// Uppercase_L - массив прописных букв русского алфавита
// плюс используемых символов
  Uppercase_L: TMass = ('А','Б','В','Г','Д','Е','Ё','Ж',
                        'З','И','Й','К','Л','М','Н','О',
                        'П','Р','С','Т','У','Ф','Х','Ц',
                        'Ч','Ш','Щ','Ъ','Ы','Ь','Э','Ю',
                        'Я', ' ', '.', ',','/','@');

// Lowercase_L - массив строчных букв русского алфавита
// плюс используемых символов
  Lowercase_L: TMass = ('а','б','в','г','д','е','ё','ж',
                        'з','и','й','к','л','м','н','о',
                        'п','р','с','т','у','ф','х','ц',
                        'ч','ш','щ','ъ','ы','ь','э','ю',
                        'я', ' ', '.', ',','/','@');

var
// Data_Clue_M -  массив, используемый в 1, 3 и 4 этапах
// шифрования(дешифрования) для получения
// псевдослучайных чисел
  Data_Clue_M : TClue_Mass;
// Num_Mass - массив, используемый во 2, 4, 5, 6 и 7
// этапах шифрования(дешифрования) для получения
// псевдослучайных чисел
  Num_Mass: TNum_Mass;
// Space_N - количество пробелов в фразе-ключе.
// Их должно быть строго 3
  Space_N: integer;
// Clue - фраза-ключ. Data_Clue - ключевая дата
// Session_Clue - сеансовый ключ
// Text_Clue - текстовый ключ
  Clue, Data_Clue, Session_Clue, Text_Clue : TString;

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
    while not(Found) and(J <= 32) do
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
// символы в проверку. N = 32 - сравнивать с элементами
// алфавита до 32 символа, N = 37 - ставнивать до 37.
// После 32 элемента алфавита идут знаки
// ( ' ', '.', ',','/','@')
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
// в строке от Start позиции до Finish
function ToNumber(const Num_Mass1: TNum_Mass; const
                  Uppercase_L1: TMass; const Text_Clue1:
                  string; const Start, Finish: integer):
                  TNum_Mass;

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
    while (I <= 32) and not(Found) do
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
function ToSort(Const Num_Mass1:TNum_Mass): TNum_Mass;

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
    if not(Processed) then
      inc(I)
  end
end;

function ToDecryptStr(const Text1, Clue1: string;
                      const Num_Mass1: TNum_Mass):
                      TString;

var
// FSN - first space number, SSN - second space number
// TSN - third space number
  I, J, FSN, SSN, TSN: integer;
// Mass - матрица шифрования(дешифрования)
  Mass: array[0..39] of char;
  UsedMass: array[0..39] of boolean;
  Processed: boolean;

begin
//Инициализация переменных
  FSN := -1;
  SSN := -1;
  TSN := -1;
  Result := '';

  for I := 0 to 39 do
    UsedMass[I] := false;

// Нахождение номеров пробелов в Num_Mass1
  for I := 1 to length(Clue1) do
  begin
      if Clue1[I] = ' ' then
      begin
      if FSN = -1 then
        FSN := Num_Mass1[I - 1]
      else
        if SSN = -1 then
          SSN := Num_Mass1[I - 1]
        else
          if TSN = -1 then
            TSN := Num_Mass1[I - 1]
    end;
  end;

// Запись фразы-ключа в матрицу шифрования(дешифрования)
  for I := 0 to 9 do
  begin
    Mass[I] := Clue1[I + 1];
    Processed := false;
    J := 0;
    while (J <= 37) and not(Processed) do
    begin
      if Clue1[I + 1] = Uppercase_L[J] then
      begin
        UsedMass[J] := true;
        Processed := true;
      end
      else
        inc(J);
    end;
  end;

// Запись всех оставшихся сиволов в матрицу
// шифрования(дешифрования)
  I := 10;
  for J := 0 to 37 do
  begin
    if not(UsedMass[J]) then
    begin
      Mass[I] := Uppercase_L[J];
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
// от 30 до 39
        if strtoint(Text1[I]) = TSN then
        begin
          inc(I);
          Processed := false;
          J := 0;
          while (J <= 9) and not Processed do
          begin
            if Num_Mass1[J] = strtoint(Text1[I]) then
            begin
              Result := Result + Mass[30 + J];
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

// Процедура шифрования текста
function ToEncryptStr(const Text1, Clue1: string;
                      const Num_Mass1: TNum_Mass):
                      TString;

var
// FSN - first space number, SSN - second space number
// TSN - third space number
  I, J, FSN, SSN, TSN: integer;
// Mass - матрица шифрования(дешифрования)
  Mass: array[0..39] of char;
  UsedMass: array[0..39] of boolean;
  Processed: boolean;

begin
//Инициализация переменных
  FSN := -1;
  SSN := -1;
  TSN := -1;
  Result := '';

  for I := 0 to 39 do
    UsedMass[I] := false;

// Нахождение номеров пробелов в Num_Mass1
  for I := 1 to length(Clue1) do
  begin
      if Clue1[I] = ' ' then
      begin
      if FSN = -1 then
        FSN := Num_Mass1[I - 1]
      else
        if SSN = -1 then
          SSN := Num_Mass1[I - 1]
        else
          if TSN = -1 then
            TSN := Num_Mass1[I - 1]
    end;
  end;

// Запись фразы-ключа в матрицу шифрования(дешифрования)
  for I := 0 to 9 do
  begin
    Mass[I] := Clue1[I + 1];
    Processed := false;
    J := 0;
    while (J <= 37) and not(Processed) do
    begin
      if Clue1[I + 1] = Uppercase_L[J] then
      begin
        UsedMass[J] := true;
        Processed := true;
      end
      else
        inc(J);
    end;
  end;

// Запись всех оставшихся сиволов в матрицу
// шифрования(дешифрования)
  I := 10;
  for J := 0 to 37 do
  begin
    if not(UsedMass[J]) then
    begin
      Mass[I] := Uppercase_L[J];
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
    while (J <= 39) and not(Processed) do
    begin
      if Text1[I] = Mass[J] then
      begin
        if Text1[I] <> ' ' then
          case J div 10 of
            0: Result := Result +
                         inttostr(Num_Mass1[J]);
            1: Result := Result + inttostr(FSN) +
                         inttostr(Num_Mass1[J mod 10]);
            2: Result := Result + inttostr(SSN) +
                         inttostr(Num_Mass1[J mod 10]);
            3: Result := Result + inttostr(TSN) +
                         inttostr(Num_Mass1[J mod 10]);
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

procedure InitializationAbelRus(Clue1, Data_Clue1,
          Session_Clue1, Text_Clue1: TString; ToEncrypt:
          boolean );

var
  K: integer;

begin
  // Инициализация
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
    Text_Clue := DelExCh(Uppercase_L, Text_Clue, 32)
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
    Clue := DelExCh(Uppercase_L, Clue, 37);
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
    if Space_N < 3 then
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

function AbelRus(Text: TString; ToEncrypt: boolean):
                 TString;
// Шифры, использующие коды переменной длины

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
      Text := DelExCh(Uppercase_L, Text, 37);
    end
    else
    begin

      K := 1;
      while K <= length(Text) do
      begin
        if not (Text[K] in ['0'..'9']) then
          delete(Text, K, 1)
        else
          inc(k)
      end
    end;

// Шифрование(дешифрование) текста
    if ToEncrypt then
      Result := ToEncryptStr(Text, Clue, Num_Mass)
    else
      Result := ToDecryptStr(Text, Clue, Num_Mass);
  end;
end;
end.
