unit UnitVigenere;

interface

type
  TString = string;

// Функция широфвания строки
function Vigenere(Text_Str: Tstring; ToEncrypt, EngCipher: boolean): Tstring;

// Процедура инициализации переменных
procedure InitializationVigenere(Clue_Str: Tstring; EngCipher: boolean);

implementation

uses Dialogs, UnitMainForm;

type
  TAdr = ^TList;
  TList =  record
    ShiftNum: integer;
    AdrNext: TAdr;
  end;


var
  Adr1, AdrEl: TAdr;

// Процедура удаления элемента списка
procedure DelListEl(var El: TAdr);

var
  A: TAdr;

begin
  A := El;
  El := El^.AdrNext;
  Dispose(A)
end;

// Процедура создания элемента списка
procedure CreateListEl(var AdrEl1: TAdr);

begin
  New (AdrEl1^.AdrNext);
  AdrEl1 := AdrEl1^.AdrNext;
  AdrEl1^.AdrNext := nil;
end;

// Процедура инициализации переменных
procedure InitializationVigenere(Clue_Str: TString; EngCipher: boolean);

var
  I, J: integer;
// Processed - обработана ли буква
  Processed: boolean;

begin

  AdrEl := Adr1;
  AdrEl.ShiftNum := -1;
  AdrEl^.AdrNext := nil;

  Error := true;
  I := 0;

// Цикл записи номеров букв строки-ключа
// в массив сдвигов

  while I <= length(Clue_Str) - 1 do
  begin
    Processed := false;
    J := 0;
    if EngCipher then
    begin
// Цикл перебора букв русского и английского алфавитов
      while (J <= 25) and not Processed do
      begin

// Обратобка букв английского алфавита
        if (Clue_Str[I + 1] = Uppercase_L_E[J]) and (J <= 25) then
        begin
          if  AdrEl^.ShiftNum <> -1 then
            CreateListEl(AdrEl);
          AdrEl^.ShiftNum := J;
          Processed := true;
          Error := false
        end;
        if (Clue_Str[I + 1] = Lowercase_L_E[J]) and (J <= 25) then
        begin
          if  AdrEl^.ShiftNum <> -1 then
            CreateListEl(AdrEl);
          AdrEl^.ShiftNum := J;
          Processed := true;
          Error := false
        end;
        inc(J)
      end
    end
    else
    begin
      while (J <= 32) and not Processed do
      begin

// Обработка букв русского алфавита
        if Clue_Str[I + 1] = Uppercase_L_R[J] then
        begin
          if  AdrEl^.ShiftNum <> -1 then
            CreateListEl(AdrEl);
          AdrEl^.ShiftNum := J;
          Processed := true;
          Error := false
        end;
        if Clue_Str[I + 1] = Lowercase_L_R[J] then
        begin
          if  AdrEl^.ShiftNum <> -1 then
            CreateListEl(AdrEl);
          AdrEl^.ShiftNum := J;
          Processed := true;
          Error := false
        end;
        inc(J)
      end;
    end;

    inc(I)
  end;

// Закольцовывание списка
  AdrEl^.AdrNext := Adr1;
  AdrEl := Adr1;

end;

// Функция шифрования буквы шифратором Виженера
function ToCipher(Text_Char: Char; ToEncrypt1, EngCipher1: boolean): Char;

var
  J: integer;
// Processed - обработана ли буква
  Processed: boolean;

begin
  Result := Text_Char;
  J := 0;
      Processed := false;

      if EngCipher1 then
      begin
// Цикл перебора букв русского и английского алфавитов
        while (J <= 32) and not Processed do
        begin

// Шифрование(дешифрование) прописных букв английского алфавита
          if (Text_Char = Uppercase_L_E[J]) and (J <= 25) then
          begin
            if ToEncrypt1 then
              Result := Uppercase_L_E[(J + AdrEl^.ShiftNum) mod 26]
            else
              Result := Uppercase_L_E[(J + 26 - AdrEl^.ShiftNum) mod 26];
            AdrEl := AdrEl^.AdrNext;
            Processed := true
          end;
// Шифрование(дешифрование) строчных букв английского алфавита
          if (Text_Char = Lowercase_L_E[J]) and (J <= 25) then
          begin
            if ToEncrypt1 then
              Result := Lowercase_L_E[(J + AdrEl^.ShiftNum) mod 26]
            else
              Result := Lowercase_L_E[(J + 26 - AdrEl^.ShiftNum) mod 26];
            AdrEl := AdrEl^.AdrNext;
            Processed := true
          end;
          inc(J)
        end
      end
      else
      begin
        while (J <= 32) and not Processed do
        begin

// Шифрование(дешифрование) прописных букв русского алфавита
          if Text_Char = Uppercase_L_R[J] then
           begin
            if ToEncrypt1 then
              Result := Uppercase_L_R[(J + AdrEl^.ShiftNum) mod 33]
            else
              Result := Uppercase_L_R[(J + 33 - AdrEl^.ShiftNum) mod 33];
            AdrEl := AdrEl^.AdrNext;
            Processed := true
          end;
// Шифрование(дешифрование) строчных букв русского алфавита
          if Text_Char = Lowercase_L_R[J] then
          begin
            if ToEncrypt1 then
              Result := Lowercase_L_R[(J + AdrEl^.ShiftNum) mod 33]
            else
              Result := Lowercase_L_R[(J + 33 - AdrEl^.ShiftNum) mod 33];
            AdrEl := AdrEl^.AdrNext;
            Processed := true;
          end;
          inc(J)
        end;
      end;

end;

// Функция широфвания строки
function Vigenere(Text_Str: Tstring; ToEncrypt, EngCipher: boolean): TString;

var
  I: integer;

begin

  if Error then
    showmessage('Некорректный ключ')
  else
  begin
    I := 1;
// Цикл перебора букв шифруемого(дешифруемого) текста
    while I <= length(Text_Str) do
    begin
      Text_Str[I] := ToCipher(Text_Str[I], ToEncrypt, EngCipher);

      inc(I)
    end;
  end;

  Result := Text_Str;
end;

initialization

  New(Adr1);
  Adr1.AdrNext := Adr1

finalization

  AdrEl := Adr1;
  while AdrEl^.AdrNext <> adr1 do
    DelListEl(AdrEl);
  DelListEl(AdrEl);

end.
