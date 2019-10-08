unit UnitMainForm;
// Юнит главной формы.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls,
  ActnList, ExtCtrls, Menus, ImgList;

type
// TEngMass - тип массива англияских букв
  TEngMass = array[0..25] of char;
// TRusMass - тип массива русских букв
  TRusMass = array[0..32] of char;
  TMainForm = class(TForm)
    MemoText: TMemo;
    ComboBoxCipher: TComboBox;
    LabelMothod: TLabel;
    ComboBoxLanguage: TComboBox;
    LabelLanguage: TLabel;
    LabelText: TLabel;
    ButtonToProcess: TButton;
    ComboBoxProcessing: TComboBox;
    EditClue: TEdit;
    EditDataClue: TEdit;
    EditSessionClue: TEdit;
    EditTextClue: TEdit;
    LabelClue: TLabel;
    LabelDataClue: TLabel;
    LabelSessionClue: TLabel;
    LabelTextClue: TLabel;
    MainMenu: TMainMenu;
    ActionList: TActionList;
    OpenFile: TAction;
    SaveFile: TAction;
    SaveFileAs: TAction;
    ImageList: TImageList;
    MenuFile: TMenuItem;
    OpenDialog: TOpenDialog;
    MenuOpenFile: TMenuItem;
    MenuSaveFile: TMenuItem;
    MenuSaveFileAs: TMenuItem;
    SaveDialog: TSaveDialog;
    LabelProcessinMethod: TLabel;
    procedure ButtonToProcessClick(Sender: TObject);
    procedure ComboBoxCipherChange(Sender: TObject);
    procedure OpenFileExecute(Sender: TObject);
    procedure SaveFileAsExecute(Sender: TObject);
    procedure SaveFileExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
// Массив всех прописных русских букв
  Uppercase_L_E: TEngMass = ('A','B','C','D','E','F',
                             'G','H','I','J','K','L',
                             'M','N','O','P','Q','R',
                             'S','T','U','V','W','X',
                             'Y','Z');
// Массив всех строчных русских букв
  Lowercase_L_E: TEngMass = ('a','b','c','d','e','f',
                             'g','h','i','j','k','l',
                             'm','n','o','p','q','r',
                             's','t','u','v','w','x',
                             'y','z');
// Массив всех прописных английских букв
  Uppercase_L_R: TRusMass = ('А','Б','В','Г','Д','Е',
                             'Ё','Ж','З','И','Й','К',
                             'Л','М','Н','О','П','Р',
                             'С','Т','У','Ф','Х','Ц',
                             'Ч','Ш','Щ','Ъ','Ы','Ь',
                             'Э','Ю','Я');
// Массив всех строчных английских букв
  Lowercase_L_R: TRusMass = ('а','б','в','г','д','е',
                             'ё','ж','з','и','й','к',
                             'л','м','н','о','п','р',
                             'с','т','у','ф','х','ц',
                             'ч','ш','щ','ъ','ы','ь',
                             'э','ю','я');

var
  MainForm: TMainForm;
// Error - переменная, в которой хранится
// корректность введенных даннх
  Error: boolean;
// Error_N - номер ошибки в Error_Mass
  Error_N: integer;

implementation

uses UnitCaesar, UnitVigenere, UnitAbelEng, UnitAbelRus,
     UnitPlayfairEng, UnitPlayfairRus, UnitPortEng,
     UnitPortRus, UnitLogInForm;

{$R *.dfm}

procedure TMainForm.ButtonToProcessClick(Sender: TObject);

var
// NumCipher - номер выбранного шифра
// NumLanguage - номер выбранного языка
//(0 - русский, 1 - английский)
  NumCipher, NumLanguage: integer;
// ToEncrypt - переменная, показывающая,
// надо ли шифрованить или дешифровать текст
  ToEncrypt: boolean;

begin

//  Инициализация переменных
  NumCipher := ComboBoxCipher.ItemIndex;
  NumLanguage := ComboBoxLanguage.ItemIndex;
  Error := false;
  Error_N := 0;
  if ComboBoxProcessing.ItemIndex = 0 then
    ToEncrypt := true
  else
    ToEncrypt := false;

// Инициализация перенных для каждого алгоритма.
// Для шифра Цезаря инициализация не требуется
  if NumLanguage = 0 then
  begin
    case NumCipher of
      1: InitializationVigenere(EditClue.Text, False);
      2: InitializationPlayfairRus(EditClue.Text);
      3: InitializationPortRus(EditClue.Text);
      4: InitializationAbelRus(EditClue.Text,
         EditDataClue.Text, EditSessionClue.Text,
         EditTextClue.Text, ToEncrypt);
    end;
  end
  else
  begin
    case NumCipher of
      1: InitializationVigenere(EditClue.Text, True);
      2: InitializationPlayfairEng(EditClue.Text);
      3: InitializationPortEng(EditClue.Text);
      4: InitializationAbelEng(EditClue.Text,
         EditDataClue.Text, EditSessionClue.Text,
         EditTextClue.Text, ToEncrypt);
    end;
  end;

  if NumLanguage = 0 then
// Шифрование русского текста выбранным алгоритмом
  begin
    case NumCipher of
      0: MemoText.Text := Caesar(MemoText.Text, ToEncrypt, False);
      1: MemoText.Text := Vigenere(MemoText.Text, ToEncrypt, False);
      2: MemoText.Text := PlayfairRus(MemoText.Text, ToEncrypt);
      3: MemoText.Text := PortRus(MemoText.Text);
      4: MemoText.Text := AbelRus(MemoText.Text,  ToEncrypt);
    end;
  end
  else
// Шифрование английского текста выбранным алгоритмом
  begin
    case NumCipher of
      0: MemoText.Text := Caesar(MemoText.Text, ToEncrypt, True);
      1: MemoText.Text := Vigenere(MemoText.Text, ToEncrypt, True);
      2: MemoText.Text := PlayfairEng(MemoText.Text, ToEncrypt);
      3: MemoText.Text := PortEng(MemoText.Text);
      4: MemoText.Text := AbelEng(MemoText.Text,  ToEncrypt);
    end;
  end;

  if not Error and (Error_N = 0) then
    showmessage('Готово')
end;

// Обработка доступности полей ключей
procedure TMainForm.ComboBoxCipherChange(Sender: TObject);
begin
// Если выбран шифр Цезаря, ввод ключей
//должен быть недоступен
  if ComboBoxCipher.ItemIndex = 0 then
  begin
    LabelClue.Enabled := false;
    LabelDataClue.Enabled := false;
    LabelSessionClue.Enabled := false;
    LabelTextClue.Enabled := false;
    EditClue.Enabled := false;
    EditDataClue.Enabled := false;
    EditSessionClue.Enabled := false;
    EditTextClue.Enabled := false;
  end
  else
// Иначе ввод ключа должен быть доступен
  begin
    LabelClue.Enabled := true;
    EditClue.Enabled := true;
// Если выбраны шифры, использующие еоды переменной
// длинны, то все остальные поля должны быть доступны
// пользователю, иначе - не доступны
    if ComboBoxCipher.ItemIndex = 4 then
    begin
      LabelDataClue.Enabled := true;
      LabelSessionClue.Enabled := true;
      LabelTextClue.Enabled := true;
      EditDataClue.Enabled := true;
      EditSessionClue.Enabled := true;
      EditTextClue.Enabled := true;
    end
    else
    begin
      LabelDataClue.Enabled := false;
      LabelSessionClue.Enabled := false;
      LabelTextClue.Enabled := false;
      EditDataClue.Enabled := false;
      EditSessionClue.Enabled := false;
      EditTextClue.Enabled := false;
    end;
  end;
end;

// Процедура "Открыть..." текстового файла
procedure TMainForm.OpenFileExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
    MemoText.Lines.LoadFromFile(OpenDialog.FileName);
end;
// Функция "Сохранить Как..." текстового файла
procedure TMainForm.SaveFileAsExecute(Sender: TObject);
begin
  with SaveDialog, MemoText do
    if Execute then
    begin
      Lines.SaveToFile(FileName);
      OpenDialog.FileName := FileName;
    end;
end;

// Функция "Сохранить" текстового файла
procedure TMainForm.SaveFileExecute(Sender: TObject);
begin
  if OpenDialog.FileName <> '.txt' then
    MemoText.Lines.SaveToFile(OpenDialog.FileName)
  else
    with SaveDialog, MemoText do
    if Execute then
    begin
      Lines.SaveToFile(FileName);
      OpenDialog.FileName := FileName;
    end;
end;

end.
