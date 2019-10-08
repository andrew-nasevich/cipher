unit UnitLogInForm;
// Юнит формы регистрации и авторизации

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

// Тип-запись для хранения данных о пользователе
type
  TFRecord = record
    LastName: string[20];
    FirstName: string[20];
    Patronymic: string[20];
    Login: string[20];
    Password: string[20];
  end;

var
// F - файл записей
  F: file of TFRecord;
  FRecord1, FRecord2: TFRecord;
  Found: boolean;

// Процедура регистрации пользователя
procedure TLogInForm.ButtonRegistrationClick(Sender: TObject);
begin
  assignfile(F, 'files\UsersFile.txt');
  {$I-}
  reset(F);
  {$I+}
  if IoResult <> 0 then
    rewrite(F);

  if (LabeledEditLogin.Text = '') or (LabeledEditPassword.Text = '') then
    showmessage('Некорректныйе данные')
  else
  begin
    with FRecord1 do
    begin
      LastName := LabeledEditLastName.Text;
      FirstName := LabeledEditFirstName.Text;
      Patronymic := LabeledEditPatronymic.Text;
      Login := LabeledEditLogin.Text;

// Шифрование пароля
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
      ShowMessage('Регистрация завершена успешнно');
      write(F, FRecord1);
      MainForm.Enabled := true;
      MainForm.Show;
      LogInForm.Close
    end
    else
      showmessage('Такой пользователь уже существует');
    closefile(F);

  end;
end;

// Процедура авторизации пользователя
procedure TLogInForm.ButtonLogInClick(Sender: TObject);
begin
  assignfile(F, 'files\UsersFile.txt');
  {$I-}
  reset(F);
  {$I+}
  if IoResult <> 0 then
    rewrite(F);

  if (LabeledEditLogin.Text = '') or (LabeledEditPassword.Text = '') then
    showmessage('Некорректныйе данные')
  else
  begin
    with FRecord1 do
    begin

      LastName := LabeledEditLastName.Text;
      FirstName := LabeledEditFirstName.Text;
      Patronymic := LabeledEditPatronymic.Text;
      Login := LabeledEditLogin.Text;

// Шифрование пароля
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
      ShowMessage('Авторизация завершена успешно');
      MainForm.Show;
      MainForm.Enabled := true;
      LogInForm.Close;
    end
    else
      showmessage('Некорректные данные');

  end;
end;

// Процедура закрытия формы
procedure TLogInForm.FormClose(Sender: TObject;
          var Action: TCloseAction);
begin
  if not MainForm.Enabled then
  MainForm.Close
end;

end.
