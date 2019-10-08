unit UnitPortRus;

interface

type
  TString = string;

function PortRus(Text_Str: TString): TString;

// �������������
procedure InitializationPortRus(Clue_Str1: TString);

implementation

uses
  Dialogs, UnitMainForm;

type
  TMass = array[0..31] of char;
  TSMass = array[0..15] of char;

const

// Uppercase_L - ������ ��������� ����
// ����������� ��������
  Uppercase_L: TMass = ('�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�');


// Lowercase_L - ������ �������� ����
// ����������� ��������
  Lowercase_L: TMass = ('�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�');

var
  Clue_Str: TString;

// ������� �������� ���� �������� ���� � ���������
function ConvertPortRus(const Uppercase_L1,
         Lowercase_L1: TMass;Text_str1: Tstring):
         Tstring;

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

// �������������� ������: ����� '�' ������ ����������
// �� '�' �.�. ��������� ����� ������ ����� ������
// ���������� ��������
    if Result[I] in ['�', '�'] then
    begin
      Found := true;
      Result[I] := '�'
    end;

// ���� ��������� ��������� �����
// �� ��������� ������� ��������
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

// ������� ����������(������������) ������ Text_Str
function ToEncryptPortRus(const Uppercase_L1: TMass;
                          const Clue_Str1, Text_Str1:
                          Tstring): Tstring;

// � ����������(������������) ������� ��������� �����
// ����������� ����������� �� ��� ����� �������. ������
// ����� �� ��������, � ������ ���������� ����������
// ����� �������� ������ ����� ����� � ��������.
// �, � - ��� ������, �, � - ����� �� 1 ...
// �, � - ����� �� 15
const

  FirstP: TSMass = ('�','�','�','�','�','�','�','�',
                    '�','�','�','�','�','�','�','�');

  SecondP: TSMass = ('�','�','�','�','�','�','�','�',
                     '�','�','�','�','�','�','�','�');

var
// Ch_Num - ����� ������� ����� � ������-�����,
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
    while (J <= 31) and not(Found) do
      if Text_Str1[I] = Uppercase_L[J] then
        Found := true
      else
        inc(J);

// ����������(������������) ����� Text_Str1, ���� ���
// ����� ��������� � ������ ����� ��������.
    if Found and (J <= 15)  then
    begin
      Result[I] := SecondP[(J + 16 - N_El div 2) mod 16];
      Ch_Num := 1 + Ch_Num mod length(Clue_Str1);
    end;

// ����������(������������) ����� Text_Str1, ���� ���
// ����� ��������� �� ������ ����� ��������.
    if Found and (J > 15)  then
    begin
      Result[I] := FirstP[(J + N_El div 2) mod 16];
      Ch_Num := 1 + Ch_Num mod length(Clue_Str1);
    end;

  end;

end;

// ������� �������� ��������� �� ������-�����,
// ������� �� �������� ������� ��������
function DelExCh(const Uppercase_L1: TMass; const
                 Clue_Str1: TString ): TString;

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
    until Found or (J > 32)

  end
end;

procedure InitializationPortRus(Clue_Str1: TString);
begin

// ������� ���� �������� ���� ����� � ���������
  Clue_Str := ConvertPortRus(Uppercase_L, Lowercase_L,
                             Clue_Str1);
// �������� ���� �������, �� �������� � �������,
// �� ������-�����
  Clue_str := DelExCh(Uppercase_L, Clue_str);

  if Clue_str = '' then
  begin
    showmessage('������������ ����');
    Error := true;
  end
end;

function PortRus(Text_Str: TString): TString;

// ������� �������� ���� �������� ����
// �������� ������ � ���������

begin

// ������� ���� �������� ���� ����� � ���������
  Text_Str := ConvertPortRus(Uppercase_L, Lowercase_L,
                             Text_str);

  if not Error then
  begin

// ����������(������������) Text_Str
    Text_Str := ToEncryptPortRus(Uppercase_L, Clue_Str,
                                 Text_str);
    Result := Text_str;

  end
  else
    Result := Text_str;
end;

end.
