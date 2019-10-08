unit UnitPortEng;

interface

type
  TString = string;

// ���������� / ������������ ���������� �����
// ������� ��������� �����
function PortEng(Text_str: TString): TString;

// ������������� ����������
procedure InitializationPortEng(Clue_Str1: TString);

implementation

uses
  Dialogs, UnitMainForm;

type
  TSMass = array[0..12] of char;

var
  Clue_Str: TString;

// ������� �������� ���� �������� ����
// �������� ������ � ���������
function ConvertPortEng(const Uppercase_L1,
                        Lowercase_L1: TEngMass;
                        Text_str1: string): string;

var
  I, J: integer;
// Found - ���������� ������������,
// ������ �� ������� �� ��������� �������
  Found: boolean;

begin
  Result := Text_str1;
// ���� �������� ���� �������� ����
// ���������� ������ � ���������
  for I := 1 to length(Result) do
  begin
    Found := false;

// ���� ��������� ��������� �����
// �� ��������� ������� ��������
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

// ������� ����������(������������) ������ Text_Str
function ToEncryptPortEng(const Uppercase_L1: TEngMass;
                          const Clue_Str1, Text_Str1:
                          string): string;

// � ����������(������������) ������� ��������� �����
// ����������� ����������� �� ��� ����� �������. ������
// ����� �� ��������, � ������ ���������� ����������
// ����� �������� ������ ����� ����� � ��������.
// A, B - ��� ������, C, D - ����� �� 1 ...
// Y, Z - ����� �� 12
const

  FirstP: TSMass = ('A','B','C','D','E','F',
                    'G','H','I','J','K','L','M');

  SecondP: TSMass = ('N','O','P','Q','R','S',
                     'T','U','V','W','X','Y','Z');

var
// Ch_Num - ����� ������� ����� � ������ �����,
// �� �������� ���������(�����������) ��������� �����
// N_El - ����� ������� ����� ������-�����
// � ��������
  I, J, Ch_Num, N_El: integer;
// Found - ���������� ������������,
// ������ �� ������� �� ��������� �������
  Found: boolean;

begin

// �������������
  Ch_Num := 1;
  Found := true;
  Result := Text_Str1;
  N_El := 0;

// ���� �������� ���� ����������(������������) ������
  for I := 1 to length(Result) do
  begin

// ���������� ������ ����� ����� ����� � ��������.
// ���� Found = false, �� ���������� ����� ������
// �� ���� ���������� - ������ ����� ���������
// ����� ����� �� ����.
    if Found then
    begin
      N_El := 0;
      while Clue_Str1[Ch_Num] <> Uppercase_L1[N_El] do
        inc(N_El);
    end;

    Found := false;
    J := 0;

// ���� ���������� ������ ������� ����� ������
// ����������(������������) � ��������.
    while (J <= 25) and not(Found) do
      if Text_Str1[I] = Uppercase_L_E[J] then
        Found := true
      else
        inc(J);

// ����������(������������) ����� Text_Str1, ���� ���
// ����� ��������� � ������ ����� ��������.
    if Found and (J <= 12)  then
    begin
      Result[I] := SecondP[(J + 13 - N_El div 2) mod 13];
      Ch_Num := 1 + Ch_Num mod length(Clue_Str1);
    end;

// ����������(������������) ����� Text_Str1, ���� ���
// ����� ��������� �� ������ ����� ��������.
    if Found and (J > 12)  then
    begin
      Result[I] := FirstP[(J + N_El div 2) mod 13];
      Ch_Num := 1 + Ch_Num mod length(Clue_Str1);
    end;

  end;

end;

// ������� �������� ��������� �� ������-�����,
// ������� �� �������� ������� ��������
function DelExCh(const Uppercase_L1: TEngMass; const
                 Clue_Str1: string ): string;

var
  I, J: integer;
// Found - ���������� ������������,
// ������ �� ������� �� ��������� �������
  Found: boolean;

begin
// ������� ��������� ������-�����
  for I := 1 to length(Clue_Str1) do
  begin
    J := 0;
    Found := false;

// ���� ����������� �������� ������-����� � �������
// ��������. ���� ������ �� ������ � �������, �� ��
// ��������� � �������������� ������-����.
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

// ������� ���� �������� ���� ����� � ���������
  Clue_Str := ConvertPortEng(Uppercase_L_E,
                             Lowercase_L_E, Clue_Str1);
// �������� ���� �������, �� �������� � �������,
// �� ������-�����
  Clue_Str := DelExCh(Uppercase_L_E, Clue_str);

  if Clue_str = '' then
    Error := true
end;

function PortEng(Text_str: TString): TString;

begin

// ������� ���� �������� ���� ����� � ���������
  Text_Str := ConvertPortEng(Uppercase_L_E,
                             Lowercase_L_E, Text_str);

  if Clue_str = '' then
  begin
    showmessage('������������ ����');
    Result := Text_Str
  end
  else
  begin

// ����������(������������) Text_Str
    Text_Str := ToEncryptPortEng(Uppercase_L_E,
                                 Clue_Str, Text_str);
    Result := Text_Str;
  end;
end;
end.
