unit UnitLogInForm;
// ���� ����� ����������� � �����������

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TLogInForm = class(TForm)
    ButtonRegistration: TButton;
    LabeledEditLogin: TLabeledEdit;
    LabeledEditPassword: TLabeledEdit;
    ButtonLogIn: TButton;
    LabeledEditLastName: TLabeledEdit;
    LabeledEditFirstName: TLabeledEdit;
    LabeledEditPatronymic: TLabeledEdit;
    procedure ButtonRegistrationClick(Sender: TObject);
    procedure ButtonLogInClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogInForm: TLogInForm;

implementation

uses UnitMainForm, UnitPlayfairEng;

{$R *.dfm}

// ���-������ ��� �������� ������ � ������������
type
  TFRecord = record
    LastName: string[20];
    FirstName: string[20];
    Patronymic: string[20];
    Login: string[20];
    Password: string[20];
  end;

var
// F - ���� �������
  F: file of TFRecord;
  FRecord1, FRecord2: TFRecord;
  Found: boolean;

// ��������� ����������� ������������
procedure TLogInForm.ButtonRegistrationClick(Sender: TObject);
begin
  assignfile(F, 'files\UsersFile.txt');
  {$I-}
  reset(F);
  {$I+}
  if IoResult <> 0 then
    rewrite(F);

  if (LabeledEditLogin.Text = '') or (LabeledEditPassword.Text = '') then
    showmessage('������������� ������')
  else
  begin
    with FRecord1 do
    begin
      LastName := LabeledEditLastName.Text;
      FirstName := LabeledEditFirstName.Text;
      Patronymic := LabeledEditPatronymic.Text;
      Login := LabeledEditLogin.Text;

// ���������� ������
      InitializationPlayfairEng(Login);
      Password := PlayfairEng(LabeledEditPassword.Text, true)

    end;
    Found := false;
    while not (EOF(F) or Found) do
    begin
      read(F, FRecord2);
      if (FRecord2.LastName = FRecord1.LastName) and
         (FRecord2.FirstName = FRecord1.FirstName) and
         (FRecord2.Patronymic = FRecord1.Patronymic) and
         (FRecord2.Login = FRecord1.Login)then
        Found := true;
    end;
    if not Found then
    begin
      ShowMessage('����������� ��������� ��������');
      write(F, FRecord1);
      MainForm.Enabled := true;
      MainForm.Show;
      LogInForm.Close
    end
    else
      showmessage('����� ������������ ��� ����������');
    closefile(F);

  end;
end;

// ��������� ����������� ������������
procedure TLogInForm.ButtonLogInClick(Sender: TObject);
begin
  assignfile(F, 'files\UsersFile.txt');
  {$I-}
  reset(F);
  {$I+}
  if IoResult <> 0 then
    rewrite(F);

  if (LabeledEditLogin.Text = '') or (LabeledEditPassword.Text = '') then
    showmessage('������������� ������')
  else
  begin
    with FRecord1 do
    begin

      LastName := LabeledEditLastName.Text;
      FirstName := LabeledEditFirstName.Text;
      Patronymic := LabeledEditPatronymic.Text;
      Login := LabeledEditLogin.Text;

// ���������� ������
      InitializationPlayfairEng(Login);
      Password := PlayfairEng(LabeledEditPassword.Text, true)

    end;
    Found := false;
    while not (EOF(F) or Found) do
    begin
      read(F, FRecord2);
      if (FRecord2.LastName = FRecord1.LastName) and
         (FRecord2.FirstName = FRecord1.FirstName) and
         (FRecord2.Patronymic = FRecord1.Patronymic) and
         (FRecord2.Login = FRecord1.Login) and
         (FRecord2.Password = FRecord1.Password) then
        Found := true;
    end;
    closefile(F);
    if Found then
    begin
      ShowMessage('����������� ��������� �������');
      MainForm.Show;
      MainForm.Enabled := true;
      LogInForm.Close;
    end
    else
      showmessage('������������ ������');

  end;
end;

// ��������� �������� �����
procedure TLogInForm.FormClose(Sender: TObject;
          var Action: TCloseAction);
begin
  if not MainForm.Enabled then
  MainForm.Close
end;

end.
