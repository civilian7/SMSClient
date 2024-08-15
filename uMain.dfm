object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'SMSGateway'
  ClientHeight = 477
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Malgun Gothic'
  Font.Style = []
  TextHeight = 15
  object lbURL: TLabel
    Left = 8
    Top = 27
    Width = 21
    Height = 15
    Caption = 'URL'
  end
  object lbUserID: TLabel
    Left = 8
    Top = 56
    Width = 35
    Height = 15
    Caption = 'UserID'
  end
  object lbNumbers: TLabel
    Left = 8
    Top = 118
    Width = 72
    Height = 15
    Caption = #49688#49888#51204#54868#48264#54840
  end
  object lbMessage: TLabel
    Left = 8
    Top = 147
    Width = 36
    Height = 15
    Caption = #47700#49464#51648
  end
  object lbPassword: TLabel
    Left = 8
    Top = 85
    Width = 50
    Height = 15
    Caption = 'Password'
  end
  object lbResult: TLabel
    Left = 8
    Top = 321
    Width = 24
    Height = 15
    Caption = #44208#44284
  end
  object eURL: TEdit
    Left = 104
    Top = 24
    Width = 512
    Height = 23
    TabOrder = 0
    Text = 'http://192.168.0.158'
  end
  object eUserID: TEdit
    Left = 104
    Top = 53
    Width = 512
    Height = 23
    TabOrder = 1
  end
  object eNumbers: TEdit
    Left = 104
    Top = 115
    Width = 512
    Height = 23
    TabOrder = 3
  end
  object eMessage: TMemo
    Left = 104
    Top = 144
    Width = 512
    Height = 137
    TabOrder = 4
  end
  object btnSend: TButton
    Left = 541
    Top = 287
    Width = 75
    Height = 25
    Caption = #51204#49569
    TabOrder = 5
    OnClick = btnSendClick
  end
  object ePassword: TEdit
    Left = 104
    Top = 82
    Width = 512
    Height = 23
    TabOrder = 2
  end
  object eResult: TMemo
    Left = 104
    Top = 318
    Width = 512
    Height = 137
    TabOrder = 6
  end
end
