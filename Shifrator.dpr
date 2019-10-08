program Shifrator;

uses
  Forms,
  UnitMainForm in 'Units\Форма\UnitMainForm.pas' {MainForm},
  UnitAbelEng in 'Units\UnitAbelEng.pas',
  UnitAbelRus in 'Units\UnitAbelRus.pas',
  UnitCaesar in 'Units\UnitCaesar.pas',
  UnitPlayfairEng in 'Units\UnitPlayfairEng.pas',
  UnitPlayfairRus in 'Units\UnitPlayfairRus.pas',
  UnitPortEng in 'Units\UnitPortEng.pas',
  UnitPortRus in 'Units\UnitPortRus.pas',
  UnitVigenere in 'Units\UnitVigenere.pas',
  UnitLogInForm in 'Units\Форма\UnitLogInForm.pas' {LogInForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TLogInForm, LogInForm);
  Application.Run;
end.
