object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #24494#31471#26356#26032#26381#21153#22120
  ClientHeight = 220
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object plTop: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 201
    Align = alClient
    BevelOuter = bvNone
    Caption = 'plTop'
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 467
      Height = 201
      Align = alClient
      BevelOuter = bvLowered
      Caption = 'Panel2'
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 66
        Height = 12
        Caption = #24050#21457#36865#25968#25454':'
      end
      object LabSendDataSize: TLabel
        Left = 76
        Top = 8
        Width = 84
        Height = 12
        Caption = '(Data: 0.0 MB)'
      end
      object LabSendMapsSize: TLabel
        Left = 204
        Top = 8
        Width = 78
        Height = 12
        Caption = '(Map: 0.0 MB)'
      end
      object LabSendWavsSize: TLabel
        Left = 332
        Top = 8
        Width = 78
        Height = 12
        Caption = '(Wav: 0.0 MB)'
      end
      object LabWaitWavsSize: TLabel
        Left = 332
        Top = 26
        Width = 78
        Height = 12
        Caption = '(Wav: 0.0 MB)'
      end
      object LabWaitMapsSize: TLabel
        Left = 204
        Top = 26
        Width = 78
        Height = 12
        Caption = '(Map: 0.0 MB)'
      end
      object LabWaitDataSize: TLabel
        Left = 76
        Top = 26
        Width = 84
        Height = 12
        Caption = '(Data: 0.0 MB)'
      end
      object Label5: TLabel
        Left = 8
        Top = 26
        Width = 66
        Height = 12
        Caption = #24453#21457#36865#25968#25454':'
      end
      object meRunningLog: TMemo
        Left = 1
        Top = 1
        Width = 465
        Height = 199
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 201
    Width = 467
    Height = 19
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object StatusBar: TStatusBar
      Left = 0
      Top = 0
      Width = 467
      Height = 19
      Align = alClient
      Font.Charset = GB2312_CHARSET
      Font.Color = clBtnText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      Panels = <
        item
          Alignment = taCenter
          Text = '---]    [---'
          Width = 50
        end
        item
          Alignment = taCenter
          Text = #32456#31471#25968#37327':0'
          Width = 100
        end
        item
          Width = 50
        end>
      UseSystemFont = False
    end
  end
  object MainMenu: TMainMenu
    Left = 136
    Top = 64
    object N1: TMenuItem
      Caption = #25511#21046'(&C)'
    end
    object N2: TMenuItem
      Caption = #26597#30475'(&V)'
      object N3: TMenuItem
        Caption = #26597#30475#25991#20214'(&F)'
        OnClick = N3Click
      end
    end
    object O1: TMenuItem
      Caption = #36873#39033'(&P)'
      object G1: TMenuItem
        Caption = #22522#26412#35774#32622'(&G)'
        OnClick = G1Click
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
    end
  end
  object Runtime: TTimer
    Interval = 80
    OnTimer = RuntimeTimer
    Left = 80
    Top = 80
  end
  object RunTimer: TTimer
    Interval = 500
    OnTimer = RunTimerTimer
    Left = 129
    Top = 34
  end
end
