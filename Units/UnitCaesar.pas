unit UnitCaesar;
// Шифрование(дешифрование) текста алгоритмом Цезаря

interface

type
  TString = string;

// Функция шифрования(дешифрования) текста
// алгоритмом Цезаря
function Caesar(Text_Str: string; ToEncrypt, EngCiper: boolean): TString;

implementation

uses UnitMainForm;

function Caesar(Text_Str: string; ToEncrypt, EngCiper: boolean): TString;

var
  I, J: integer;
  Processed: boolean;

begin

// Цикл перебора букв
  I := 1;
  while I <= length(Text_Str) do
  begin
    Processed := false;
    J := 0;
// Цикл нахождения введенной буквы в алфавите и присваивания введенной букве
// значения буквы, стоящей на 3 позиции правее. При сдвиге за последнюю букву
// алфавита продолжать с начала алфавита
    while not Processed and (J <= 32) do
    begin

// Шифрование прописных букв английского алфавита
      if EngCiper then
      begin
        if (Text_Str[I] = Uppercase_L_E[J]) and (J <= 25) then
        begin
          if ToEncrypt then
            Text_Str[I] := Uppercase_L_E[(J + 3) mod 26]
          else
            Text_Str[I] := Uppercase_L_E[(J + 23) mod 26];
          Processed := true;
        end
        else
// Шифрование строчных букв английского алфавита
          if (Text_Str[I] = Lowercase_L_E[J]) and (J <= 25) then
          begin
            if ToEncrypt then
              Text_Str[I] := Lowercase_L_E[(J + 3) mod 26]
            else
              Text_Str[I] := Lowercase_L_E[(J + 23) mod 26];
            Processed := true;
          end
      end
      else
      begin
// Шифрование прописных букв русского алфавита
        if Text_Str[I] = Uppercase_L_R[J] then
        begin
          if ToEncrypt then
            Text_Str[I] := Uppercase_L_R[(J + 3) mod 33]
          else
            Text_Str[I] := Uppercase_L_R[(J + 30) mod 33];
          Processed := true;
        end
        else
// Шифрование строчных букв русского алфавита
          if Text_Str[I] = Lowercase_L_R[J] then
          begin
            if ToEncrypt then
              Text_Str[I] := Lowercase_L_R[(J + 3) mod 33]
            else
              Text_Str[I] := Lowercase_L_R[(J + 30) mod 33];
            Processed := true;
          end;
      end;
      inc(J)
    end;
    inc(I)
  end;
  Result := Text_Str;
end;
end.
