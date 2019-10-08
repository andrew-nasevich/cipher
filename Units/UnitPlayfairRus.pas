unit UnitPlayfairRus;

interface

type
  TMass = array[0..35] of char;
  TString = string;

// ������� ���������� ���������� ������
// ������� ������� ����� �������
function PlayfairRus(Text_Str: TString; ToEncrypt:
                     boolean): TString;

// ������������� �����������
procedure InitializationPlayfairRus(Clue_Str: TString);

implementation

const
// ������ ���� ��������� ����(���� ' ', '.', ',', �.�.
// ��� �������� ������� ���������� ������ ���� ���������)
  Uppercase_L: TMass = ('�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�',' ','.',',');
// ������ ���� �������� ����((���� ' ', '.', ',', �.�.
// ��� �������� ������� ���������� ������ ���� ���������)
  Lowercase_L: TMass = ('�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�',' ','.',',');
var
// ������ ����, ������� ������ ���� �������� � �������
// ����������. ���� ������� ����� � ������� ����������,
// ��� ��������� �� ����� ������ - ����� � �������
// ���������� �� �����������
  Char_Mass: TMass;
// Mass - �������� ����������
  Mass: TMass;

procedure InitializationPlayfairRus(Clue_Str: TString);

var
  I, J, K: integer;
// Processed - ���������� ��� ������������
// ��������� ������� �����
  Processed: boolean;

begin
  Char_Mass := Uppercase_L;
  K := 0;

// ������ ����� � ������� ����������
  for I := 1 to length(Clue_str) do
  begin
    J := 0;
    Processed := false;
// ���� ��������: �������� �� ��������� ������ ������
// ��������. ���� �������� � �� ����� ������� ��
// ������������� � � �����, �������� � �������, �����
// ������� � ���������� �������.
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

// ���� ������ � ������� ���� ����, �� ��������� � ����
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
// Processed - ���������� ��� ������������
// ��������� ������� �����
  Processed: boolean;

// ������� ���������� ������ ����������� �����
// (��������� � �������) �� ��������� ������, �������
// � ������� Num. ���� ������� ���������� �������� "36",
// �� � ������, ��� � ������ ������ ���
// ���������� ��������
function Found_El(const Mass2: TMass; var Num: integer;
                  const Text_Str2: string) : integer;

var
// Found - ���������� ��� ������������ ���������� �����
// � ��������
  Found: boolean;

begin
  Found := false;
// ���� �������� ������ ���������� ������
  repeat
    Result := 0;
// ���� ��������� ���������� ����� � ������� ��������
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
// Num1, Num2 - ������ ������� ��������� ���� �
// ��������� ����� I1, I2 - ������ ������� � �������
// ���������� ������ � ������ �����
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
  while (Num1 <= length(Text_Str1)) and
        (Num2 <= length(Text_Str1)) do
  begin
// ���������� ������ ���������� ����� ��
// ��������� ������
    I1 := Found_El(Mass1, Num1, Text_Str1);
    if I1 <> 36 then
    begin
      Num2 := Num1 + 1;
// ���������� ������ ���������� ����� ��
// ��������� ������
      I2 := Found_El(Mass1, Num2, Text_Str1)
    end;
    if (I1 <> 36) and (I2 <> 36) then
    begin
      Ready := false;

// ���� ����� �������, ��� �� ���������
      if I1 = I2 then
        Ready := true;

      if ToEncrypt1 then
      begin
// ���� ����� ��������� � ����� ������,��� �����
// ����������� �� ��������� ����� � ���� ������
// (���� ���� ����� ��������� � ������, �� ���
// ���������� �� ������ ����� � ���� ������)
        if not(Ready) and (I1 div 6 = I2 div 6) then
        begin
          Result[Num1] := Mass1[I1 + 1 - 6 * ((I1 + 1)
                                div 6 - I1 div 6)];
          Result[Num2] := Mass1[I2 + 1 - 6 * ((I2 + 1)
                                div 6 - I2 div 6)];
          Ready := true
        end;

// ���� ����� ��������� � ����� �������, ��� �����
// ����������� �� ��������� ����� � ���� �������
// (���� ���� ����� ��������� � �������, �� ���
// ���������� �� ������ ����� � ���� �������)
        if not(Ready) and (I1 mod 6 = I2 mod 6) then
        begin
          Result[Num1] := Mass1[(I1 + 6) mod 36];
          Result[Num2] := Mass1[(I2 + 6) mod 36];
          Ready := true
        end;
      end
      else
      begin
// ���� ����� ��������� � ����� ������, ��� �����
// ����������� �� ��������� ����� � ���� ������
// (���� ���� ����� ��������� � ������, �� ���
// ���������� �� ������ ����� � ���� ������)
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

// ���� ����� ��������� � ����� �������, ��� �����
// ����������� �� ��������� ����� � ���� �������
// (���� ���� ����� ��������� � �������, �� ���
// ���������� �� ������ ����� � ���� �������)
        if not(Ready) and (I1 mod 6 = I2 mod 6) then
        begin
          Result[Num1] := Mass1[(I1 + 30) mod 36];
          Result[Num2] := Mass1[(I2 + 30) mod 36];
          Ready := true
        end;
      end;

// ���� ����� �� ������� �� ���� ������ ��������, ��
// ��� ���������� �� ����� ������� �� ��������
// ��������������. � ������ ����� ���� ����� ������,
// �� ������� ����� �����, � � ������ ����� ���� �����
// ������, �� ������� ������ ����� (� ������ ���������
// ������� ��������� ����������, ������� ����������
// ���������� �����, �� ��� ������� ����� �� ����������)
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

// ���� �������� ���� �������� ���� ���������� ������
// � ���������
  for I := 1 to length(Text_Str) do
  begin
    Processed := false;

    J := 0;
// ���� ��������� ��������� ����� �� ��������� �������
// �������� ���� ������� �� 32, �.�. ����� ��� �������
// ����� ��������� � �������� ������
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

// ���������� ���������� ������
  Text_Str := Convert(Mass , Text_Str, ToEncrypt);
  Result := Text_Str;
end;

end.
