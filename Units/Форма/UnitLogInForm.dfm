object LogInForm: TLogInForm
  Left = 504
  Top = 214
  Width = 506
  Height = 372
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonRegistration: TButton
    Left = 40
    Top = 264
    Width = 169
    Height = 41
    Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
    TabOrder = 6
    OnClick = ButtonRegistrationClick
  end
  object LabeledEditLogin: TLabeledEdit
    Left = 160
    Top = 168
    Width = 169
    Height = 21
    EditLabel.Width = 53
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1072#1096' '#1083#1086#1075#1080#1085
    MaxLength = 20
    TabOrder = 3
  end
  object LabeledEditPassword: TLabeledEdit
    Left = 160
    Top = 216
    Width = 169
    Height = 21
    EditLabel.Width = 60
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1072#1096' '#1087#1072#1088#1086#1083#1100
    MaxLength = 20
    TabOrder = 4
  end
  object ButtonLogIn: TButton
    Left = 280
    Top = 264
    Width = 169
    Height = 41
    Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
    TabOrder = 5
    OnClick = ButtonLogInClick
  end
  object LabeledEditLastName: TLabeledEdit
    Left = 160
    Top = 24
    Width = 169
    Height = 21
    EditLabel.Width = 76
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1072#1096#1072' '#1092#1072#1084#1080#1083#1080#1103
    MaxLength = 20
    TabOrder = 0
  end
  object LabeledEditFirstName: TLabeledEdit
    Left = 160
    Top = 72
    Width = 169
    Height = 21
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1072#1096#1077' '#1080#1084#1103
    MaxLength = 20
    TabOrder = 1
  end
  object LabeledEditPatronymic: TLabeledEdit
    Left = 160
    Top = 120
    Width = 169
    Height = 21
    EditLabel.Width = 75
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1072#1096#1077' '#1086#1090#1095#1077#1089#1090#1074#1086
    MaxLength = 20
    TabOrder = 2
  end
end
