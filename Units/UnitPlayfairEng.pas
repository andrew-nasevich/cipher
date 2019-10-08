unit UnitPlayfairEng;

interface

type
  TMass = array[0..24] of char;
  TString = string;

function PlayfairEng(Text_Str: TString; ToEncrypt: boolean): TString;

// ��������� �������������
procedure InitializationPlayfairEng(Clue_Str: TString);

implementation

const
// ������ ���� ��������� ����(����� 'J', �.�. �
// ���������� ����� �������� ��� ����� ���������� �� 'I')
  Uppercase_L: TMass = ('A','B','C','D','E','F','G','H',
                        'I','K','L','M','N','O','P','Q',
                        'R','S','T','U','V','W','X','Y','Z');
// ������ ���� �������� ����(����� 'j', �.�. �
// ���������� ����� �������� ��� ����� ���������� �� 'I')
  Lowercase_L: TMass = ('a','b','c','d','e','f','g','h',
                        'i','k','l','m','n','o','p','q',
                        'r','s','t','u','v','w','x','y',
                        'z');
var
// ������ ����, ������� ������ ���� �������� � ������� ����������
// (���� ������� ����� � ������� ����������, ��� ��������� ��
// ����� ������� - ����� � ������� ���������� �� �����������)
  Char_Mass: TMass ;
// Mass - �������� ����������
  Mass: TMass;

procedure InitializationPlayfairEng(Clue_Str: TString);

var
  I, J, K: integer;
// Processed - ���������� ��� ������������ ���������
// ������� �����
  Processed: boolean;

begin
  Char_Mass := Uppercase_L;
  K := 0;

// ������ ����� � ������� ����������
  for I := 1 to length(Clue_str) do
  begin
// �������������� ������: ������ J �������� �� I
    if (Clue_Str[I] = 'J') or (Clue_Str[I] = 'j') then
        Clue_Str[I] := 'I';
    Processed := false;
    J := 0;
// ���� ��������: �������� �� ��������� ������ ������ ��������.
// ���� �������� � �� ����� ������� �� ������������� � �����,
// �������� � �������, ����� ������� � ���������� �������.
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

// ���� ������ � ������� ���� ����(��� J), �� ��������� � ����
  for I := 0 to 24 do
    if Char_Mass[I] <> '*' then
    begin
      Mass[K] := Char_Mass[I];
      Char_Mass[I] := '*';
      inc(K)
    end;
end;



// ������� ���������� ������ ����������� �����(��������� � �������)
// �� ��������� ������, ������� � ������� Num
// ���� ������� ���������� �������� "25", �� � ������, ��� � ������
// ������ ��� ���������� ��������
function Found_El(const Mass2: TMass; var Num: integer; const Text_Str2: string) : integer;

var
// Found - ���������� ��� ������������ ���������� ����� � ��������
  Found: boolean;

begin
  Found := false;
// ���� �������� ������ ���������� ������
  repeat
    Result := 0;
// ���� ��������� ���������� ����� � ������� ��������
    while (Result <= 24) and not(Found) do
      if Text_Str2[Num] = Mass2[Result] then
        Found := true
      else
        inc(Result);
    if not(Found) and (Num <= length(Text_str2)) then
      inc(Num)
  until Found or (Num > length(Text_str2));
end;

// ������� ���������� ���������� ������
// ������� ������� ����� �������
function Convert(const Mass1: TMass; const Text_Str1: string; ToEncrypt1: boolean): string;

var
// Num1, Num2 - ������ ������� ��������� ���� � ��������� ������
// I1, I2 - ������ ������� � ������� ���������� ������ � ������ �����
  Num1, Num2, I1, I2: integer;
// Ready - ���������� ��� ������������ ��������� ���� ����
  Ready: boolean;

begin

// ������������� ����������
  Result := Text_str1;
  Num1 := 1;
  Num2 := 1;
  I2 := 0;

// ���� ���������� ���������� ������
  while (Num1 <= length(Text_Str1)) and (Num2 <= length(Text_Str1)) do
  begin
// ���������� ������ ���������� ����� �� ��������� ������
    I1 := Found_El(Mass1, Num1, Text_Str1);
    if I1 <> 25 then
    begin
      Num2 := Num1 + 1;
// ���������� ������ ���������� ����� �� ��������� ������
      I2 := Found_El(Mass1, Num2, Text_Str1)
    end;
    if (I1 <> 25) and (I2 <> 25) then
    begin
      Ready := false;

// ���� ����� �������, ��� �� ���������
      if I1 = I2 then
        Ready := true;

      if ToEncrypt1 then
      begin
// ���� ����� ��������� � ����� ������, ��� ����� ����������
// �� ��������� ����� � ���� ������(���� ���� ����� ���������
// � ������, �� ��� ���������� �� ������ ����� � ���� ������)
        if not(Ready) and (I1 div 5 = I2 div 5) then
        begin
          Result[Num1] := Mass1[I1 + 1 - 5 * ((I1 + 1) div 5 - I1 div 5)];
          Result[Num2] := Mass1[I2 + 1 - 5 * ((I2 + 1) div 5 - I2 div 5)];
          Ready := true
        end;

// ���� ����� ��������� � ����� �������, ��� ����� ����������
// �� ��������� ����� � ���� �������(���� ���� ����� ���������
// � �������, �� ��� ���������� �� ������ ����� � ���� �������)
        if not(Ready) and (I1 mod 5 = I2 mod 5) then
        begin
          Result[Num1] := Mass1[(I1 + 5) mod 25];
          Result[Num2] := Mass1[(I2 + 5) mod 25];
          Ready := true
        end;
      end
      else
      begin
// ���� ����� ��������� � ����� ������, ��� ����� �����������
// �� ��������� ����� � ���� ������(���� ���� ����� ���������
// � ������, �� ��� ���������� �� ������ ����� � ���� ������)
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

// ���� ����� ��������� � ����� �������, ��� ����� �����������
// �� ��������� ����� � ���� �������(���� ���� ����� ���������
// � �������, �� ��� ���������� �� ������ ����� � ���� �������)
        if not(Ready) and (I1 mod 5 = I2 mod 5) then
        begin
          Result[Num1] := Mass1[(I1 + 20) mod 25];
          Result[Num2] := Mass1[(I2 + 20) mod 25];
          Ready := true
        end;
      end;
// ���� ����� �� ������� �� ���� ������ ��������, ��
// ��� ���������� �� ����� ������� �� �������� ��������������.
// � ������ ����� ���� ����� ������, �� ������� ����� �����,
// � � ������ ����� ���� ����� ������, �� ������� ������ �����
// (� ������ ��������� ������� ��������� ����������, �������
// ���������� ���������� �����, �� ��� ������� ����� �� ����������)
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
// Processed - ���������� ��� ������������ ���������
// ������� �����
  Processed: boolean;
  
begin

// ���� �������� ���� �������� ���� ���������� ������ � ���������
  I := 1;
  while I <= length(Text_Str) do
  begin
    Processed := false;

// �������������� ������: ����� 'j' ������ � ���������� �����
// �������� ���������� �� 'I'
    if Text_Str[I] in ['j', 'J'] then
    begin
      Text_Str[I] := 'I';
      Processed := true;
    end;

    J := 0;
// ���� ��������� ��������� ����� �� ��������� ������� ��������
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

// ���������� ���������� ������
  Text_Str := Convert(Mass , Text_Str, ToEncrypt);
  Result := Text_Str;
end;

end.
