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
// ��� �������, � ������� �������� ����� �������� +
// ������������ �������(����� ���� �� 32-�� �������,
// � ����� - �������)
  TMass = array[0..37] of char;
// ��� �����-�����
  TClue_Mass = array[0..9] of integer;
// ��� �������, ������������� ��� ���������
// ��������������� �����
  TNum_Mass =  array[0..19] of integer;

const
// ������ ������������ ������ �����
  Error_Mass: array[1..4] of string =
   ('������. � �������� ���� ������ ���� 6 ����',
    '������. � ��������� ����� ������ ���� 5 ����',
    '������. � ������-����� ������ ���� �� ����� 20' +
    ' ����',
    '������. � ����� ������ ���� 7 ������ ���� � 3 ' +
    '�������');

// Uppercase_L - ������ ��������� ���� �������� ��������
// ���� ������������ ��������
  Uppercase_L: TMass = ('�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�', ' ', '.', ',','/','@');

// Lowercase_L - ������ �������� ���� �������� ��������
// ���� ������������ ��������
  Lowercase_L: TMass = ('�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�','�','�','�','�','�','�','�',
                        '�', ' ', '.', ',','/','@');

var
// Data_Clue_M -  ������, ������������ � 1, 3 � 4 ������
// ����������(������������) ��� ���������
// ��������������� �����
  Data_Clue_M : TClue_Mass;
// Num_Mass - ������, ������������ �� 2, 4, 5, 6 � 7
// ������ ����������(������������) ��� ���������
// ��������������� �����
  Num_Mass: TNum_Mass;
// Space_N - ���������� �������� � �����-�����.
// �� ������ ���� ������ 3
  Space_N: integer;
// Clue - �����-����. Data_Clue - �������� ����
// Session_Clue - ��������� ����
// Text_Clue - ��������� ����
  Clue, Data_Clue, Session_Clue, Text_Clue : TString;

// ������� �������� ���� �������� ���� � ���������
function Convert(const Uppercase1, Lowercase_L1: TMass;
                 C_string: string): string;

var
  I, J: integer;
// Found - ���������� ������������,
// ������ �� ������� �� ��������� �������
  Found: boolean;

begin
  Result := C_string;
// ���� �������� ���� �������� ����
// ���������� ������ � ���������
  for I := 1 to length(Result) do
  begin
    Found := false;

// ���� ��������� ��������� �����
// �� ��������� ������� ��������
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



// ������� �������� ��������� �� ������,
// ������� �� �������� ������� ��������
// N - ����������, ������������ �������� ��� �� ��������
// ������� � ��������. N = 32 - ���������� � ����������
// �������� �� 32 �������, N = 37 - ���������� �� 37.
// ����� 32 �������� �������� ���� �����
// ( ' ', '.', ',','/','@')
function DelExCh(const Uppercase1: TMass; const
                 Str: string; N: integer): string;

var
  I, J: integer;
// Found - ���������� ������������,
// ������ �� ������� �� ��������� �������
  Found: boolean;

begin
// ������� ��������� ������
  for I := 1 to length(Str) do
  begin
    J := 0;
    Found := false;

// ���� ��������� �������� ������ � ���������
// ��������. ���� ������ �� ������ � �������, �� ��
// ��������� � �������������� ������.
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

// ������� ��������� ���� �� 1 �� 10(10 ������������ 0)
// � ������ �� Start ������� �� Finish
function ToNumber(const Num_Mass1: TNum_Mass; const
                  Uppercase_L1: TMass; const Text_Clue1:
                  string; const Start, Finish: integer):
                  TNum_Mass;

var
// Position - ����� �����
  I, J, Position: integer;
// Found - ���������� ������������,
// ������ �� ������� �� ��������� �������
  Found: boolean;

begin
// ������������� ����������
  Result := Num_Mass1;
  Position := 1;
  for I := Start to Finish do
    Result[I] := -1;

// ���� ��������� ����
  while Position <= 10 do
  begin
    I := 0;
    Found := false;
// ���� �������� ���� ��������
    while (I <= 32) and not(Found) do
    begin
      J := Start + 1;
      Found := false;
// ���� �������� ���� � ��������� �������
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

// ������� ��������� ���� Num_Mass1
// �� ����������� �� 1 �� 10(0)
function ToSort(Const Num_Mass1:TNum_Mass): TNum_Mass;

var
// Num - ������� �����
  I, J, Num: integer;
// Mass_Of_Ready - ������ ��������� �����
  Mass_Of_Ready: array[0..9] of boolean;
  Processed: boolean;

begin
// ������������� ����������
  for I := 0 to 9 do
    Mass_Of_Ready[I] := false;
  Result := Num_Mass1;
  I := 1;
  Num := 1;

// ���� ���������
  while I <= 10 do
  begin
    Processed := false;
    J := 0;
// ���� ���������� ������������ ��������������� �����
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
// Mass - ������� ����������(������������)
  Mass: array[0..39] of char;
  UsedMass: array[0..39] of boolean;
  Processed: boolean;

begin
//������������� ����������
  FSN := -1;
  SSN := -1;
  TSN := -1;
  Result := '';

  for I := 0 to 39 do
    UsedMass[I] := false;

// ���������� ������� �������� � Num_Mass1
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

// ������ �����-����� � ������� ����������(������������)
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

// ������ ���� ���������� ������� � �������
// ����������(������������)
  I := 10;
  for J := 0 to 37 do
  begin
    if not(UsedMass[J]) then
    begin
      Mass[I] := Uppercase_L[J];
      inc(I);
    end;
  end;

// ���� �������� ���� Text1
// ���� ������������� ����� � �������-����������
// ���������� �� ������� �� 0 �� 9, ��� ��������������
// ���� ������, ����� - �����
  I := 1;
  while I <= length(Text1) do
  begin
// ������������ �����, ���� ��� ���������� �� �������
// �� 10 �� 19
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
// ������������ �����, ���� ��� ���������� �� �������
// �� 20 �� 29
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
// ������������ �����, ���� ��� ���������� �� �������
// �� 30 �� 39
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
// ������������ �����, ���� ��� ���������� �� �������
// �� 0 �� 9
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

// ��������� ���������� ������
function ToEncryptStr(const Text1, Clue1: string;
                      const Num_Mass1: TNum_Mass):
                      TString;

var
// FSN - first space number, SSN - second space number
// TSN - third space number
  I, J, FSN, SSN, TSN: integer;
// Mass - ������� ����������(������������)
  Mass: array[0..39] of char;
  UsedMass: array[0..39] of boolean;
  Processed: boolean;

begin
//������������� ����������
  FSN := -1;
  SSN := -1;
  TSN := -1;
  Result := '';

  for I := 0 to 39 do
    UsedMass[I] := false;

// ���������� ������� �������� � Num_Mass1
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

// ������ �����-����� � ������� ����������(������������)
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

// ������ ���� ���������� ������� � �������
// ����������(������������)
  I := 10;
  for J := 0 to 37 do
  begin
    if not(UsedMass[J]) then
    begin
      Mass[I] := Uppercase_L[J];
      inc(I);
    end;
  end;

// ���� �������� ���� Text1
  for I := 1 to length(Text1) do
  begin
    Processed := false;
    J := 0;
// ���� ���������� ����� � Text1
// � ������ ���������������� ����
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

// ������� �������� ���������� �������� �� ������ Str
function DelSame(Const Str:string): string;

var
  I, J: integer;
// Same - ���������� ��� ����������� ������������� �����
  Same: boolean;
begin
  Result := Result + Str[1];
// ���� �������� ����  Str
  for I := 2 to length(Str) do
  begin
    Same := false;
    J := length(Result) ;
// ���� ��������� ����� �� ����� ����������� �������
    while not(Same) and (J >= 1)  do
    begin
      if Result[J] = Str[I] then
        Same := true
      else
        dec(J)
    end;
// ������ �� ������������ ��� ��������
// �������� - �������� � ���������
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
  // �������������
  Clue := Clue1;
  Data_Clue := Data_Clue1;
  Session_Clue := Session_Clue1;
  Text_Clue := Text_Clue1;

// �������� �������� ���� �� ������������
  if length(Data_Clue) <> 6 then
    Error_N := 1;
  if Error_N = 0 then
    for K := 1 to 6 do
      if not(Data_Clue[K] in ['0'..'9']) then
        Error_N := 1;

// �������� ���������� ����� �� ������������
  if length(Session_Clue) <> 5 then
    Error_N := 2;
  if Error_N = 0 then
    for K := 1 to 5 do
      if not(Session_Clue[K] in ['0'..'9']) then
        Error_N := 2;

// �������������� ���� �������� ���� �������� ����� �
// ��������� � �������� ���� ��������, ������� ��
// ������� �������
  if Error_N = 0 then
  begin
    Text_Clue := Convert(Uppercase_L, Lowercase_L,
    Text_Clue);
    Text_Clue := DelExCh(Uppercase_L, Text_Clue, 32)
  end;

// ����� ���� ��������� ��������� ����
// ������ ���� ������ 20 ����
  if length(Text_Clue) < 20 then
    Error_N := 3;

// �������������� ���� �������� ���� �����-����� �
// ��������� � �������� ����������������� �������� �
// ��������, ������� �� ������� �������
  if Error_N = 0 then
  begin
    Clue := Convert(Uppercase_L, Lowercase_L, Clue);
    Clue := DelExCh(Uppercase_L, Clue, 37);
    Clue := DelSame(Clue)
  end;
// ����� ���� ��������� �����-����
// ������� ���� ������� 10 ����
  if  length(Clue) <> 10 then
    Error_N := 4;

// ������� �������� � ����� �����: �� ������ ���� 2
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

// ������ ��� ��������� ��������������� �����
    for K := 1 to 5 do
    begin
      Data_Clue_M[K - 1] := (strtoint(Session_Clue[K]) -
                             strtoint(Data_Clue[K]))
                             mod 10;
      if Data_Clue_M[K - 1] < 0 then
        Data_Clue_M[K - 1] := Data_Clue_M[K - 1] + 10
    end;

// ������ ��� ��������� ��������������� �����
    Num_Mass := ToNumber(Num_Mass, Uppercase_L,
                         Text_Clue, 0, 9);
    Num_Mass := ToNumber(Num_Mass, Uppercase_L,
                         Text_Clue, 10, 19);

// ������ ��� ��������� ��������������� �����
    for K := 5 to 9 do
      Data_Clue_M[K] := (Data_Clue_M[K - 5] +
                         Data_Clue_M[K - 4]) mod 10;

// ��������� ��� ��������� ��������������� �����
    for K := 0 to 9 do
      Num_Mass[K] := (Num_Mass[K] + Data_Clue_M[K])
                      mod 10;

// ����� ��� ��������� ��������������� �����
    for K := 0 to 9 do
      Num_Mass[K] := Num_Mass[Num_Mass[K] + 10 - 1];

// ������ ��� ��������� ��������������� �����
    for K := 0 to 49 do
      Num_Mass[K mod 10] := (Num_Mass[K mod 10] +
                             Num_Mass[(K + 1) mod 10])
                             mod 10;

// ������� ��� ��������� ��������������� �����
    Num_Mass := ToSort(Num_Mass);
  end;
end;

function AbelRus(Text: TString; ToEncrypt: boolean):
                 TString;
// �����, ������������ ���� ���������� �����

var
  K: integer;

begin

  if Error_N <> 0 then
    Result := Text
  else
  begin
    Result := '';
// �������������� ���� �������� ���� ������ � ���������
// � �������� ���� ��������, ������� �� ������ � �������
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

// ����������(������������) ������
    if ToEncrypt then
      Result := ToEncryptStr(Text, Clue, Num_Mass)
    else
      Result := ToDecryptStr(Text, Clue, Num_Mass);
  end;
end;
end.
