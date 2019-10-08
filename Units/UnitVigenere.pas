unit UnitVigenere;

interface

type
  TString = string;

// ������� ���������� ������
function Vigenere(Text_Str: Tstring; ToEncrypt, EngCipher: boolean): Tstring;

// ��������� ������������� ����������
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

// ��������� �������� �������� ������
procedure DelListEl(var El: TAdr);

var
  A: TAdr;

begin
  A := El;
  El := El^.AdrNext;
  Dispose(A)
end;

// ��������� �������� �������� ������
procedure CreateListEl(var AdrEl1: TAdr);

begin
  New (AdrEl1^.AdrNext);
  AdrEl1 := AdrEl1^.AdrNext;
  AdrEl1^.AdrNext := nil;
end;

// ��������� ������������� ����������
procedure InitializationVigenere(Clue_Str: TString; EngCipher: boolean);

var
  I, J: integer;
// Processed - ���������� �� �����
  Processed: boolean;

begin

  AdrEl := Adr1;
  AdrEl.ShiftNum := -1;
  AdrEl^.AdrNext := nil;

  Error := true;
  I := 0;

// ���� ������ ������� ���� ������-�����
// � ������ �������

  while I <= length(Clue_Str) - 1 do
  begin
    Processed := false;
    J := 0;
    if EngCipher then
    begin
// ���� �������� ���� �������� � ����������� ���������
      while (J <= 25) and not Processed do
      begin

// ��������� ���� ����������� ��������
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

// ��������� ���� �������� ��������
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

// ��������������� ������
  AdrEl^.AdrNext := Adr1;
  AdrEl := Adr1;

end;

// ������� ���������� ����� ���������� ��������
function ToCipher(Text_Char: Char; ToEncrypt1, EngCipher1: boolean): Char;

var
  J: integer;
// Processed - ���������� �� �����
  Processed: boolean;

begin
  Result := Text_Char;
  J := 0;
      Processed := false;

      if EngCipher1 then
      begin
// ���� �������� ���� �������� � ����������� ���������
        while (J <= 32) and not Processed do
        begin

// ����������(������������) ��������� ���� ����������� ��������
          if (Text_Char = Uppercase_L_E[J]) and (J <= 25) then
          begin
            if ToEncrypt1 then
              Result := Uppercase_L_E[(J + AdrEl^.ShiftNum) mod 26]
            else
              Result := Uppercase_L_E[(J + 26 - AdrEl^.ShiftNum) mod 26];
            AdrEl := AdrEl^.AdrNext;
            Processed := true
          end;
// ����������(������������) �������� ���� ����������� ��������
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

// ����������(������������) ��������� ���� �������� ��������
          if Text_Char = Uppercase_L_R[J] then
           begin
            if ToEncrypt1 then
              Result := Uppercase_L_R[(J + AdrEl^.ShiftNum) mod 33]
            else
              Result := Uppercase_L_R[(J + 33 - AdrEl^.ShiftNum) mod 33];
            AdrEl := AdrEl^.AdrNext;
            Processed := true
          end;
// ����������(������������) �������� ���� �������� ��������
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

// ������� ���������� ������
function Vigenere(Text_Str: Tstring; ToEncrypt, EngCipher: boolean): TString;

var
  I: integer;

begin

  if Error then
    showmessage('������������ ����')
  else
  begin
    I := 1;
// ���� �������� ���� ����������(������������) ������
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
