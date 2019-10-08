unit UnitCaesar;
// ����������(������������) ������ ���������� ������

interface

type
  TString = string;

// ������� ����������(������������) ������
// ���������� ������
function Caesar(Text_Str: string; ToEncrypt, EngCiper: boolean): TString;

implementation

uses UnitMainForm;

function Caesar(Text_Str: string; ToEncrypt, EngCiper: boolean): TString;

var
  I, J: integer;
  Processed: boolean;

begin

// ���� �������� ����
  I := 1;
  while I <= length(Text_Str) do
  begin
    Processed := false;
    J := 0;
// ���� ���������� ��������� ����� � �������� � ������������ ��������� �����
// �������� �����, ������� �� 3 ������� ������. ��� ������ �� ��������� �����
// �������� ���������� � ������ ��������
    while not Processed and (J <= 32) do
    begin

// ���������� ��������� ���� ����������� ��������
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
// ���������� �������� ���� ����������� ��������
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
// ���������� ��������� ���� �������� ��������
        if Text_Str[I] = Uppercase_L_R[J] then
        begin
          if ToEncrypt then
            Text_Str[I] := Uppercase_L_R[(J + 3) mod 33]
          else
            Text_Str[I] := Uppercase_L_R[(J + 30) mod 33];
          Processed := true;
        end
        else
// ���������� �������� ���� �������� ��������
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
