object frmUpdateConfig: TfrmUpdateConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmUpdateConfig'
  ClientHeight = 132
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 8
    Width = 453
    Height = 89
    Caption = #22522#26412#35774#32622
    TabOrder = 0
    object Label1: TLabel
      Left = 14
      Top = 18
      Width = 52
      Height = 13
      Caption = #36164#28304#36335#24452':'
    end
    object Label2: TLabel
      Left = 14
      Top = 40
      Width = 52
      Height = 13
      Caption = #26381#21153#22320#22336':'
    end
    object Label3: TLabel
      Left = 14
      Top = 62
      Width = 52
      Height = 13
      Caption = #26381#21153#31471#21475':'
    end
    object EditResourcePath: TEdit
      Left = 72
      Top = 15
      Width = 369
      Height = 21
      TabOrder = 0
      OnChange = EditResourcePathChange
    end
    object btnSelDirectory: TButton
      Left = 421
      Top = 15
      Width = 20
      Height = 20
      Caption = #8230
      TabOrder = 1
      OnClick = btnSelDirectoryClick
    end
    object EditServerAddr: TEdit
      Left = 72
      Top = 36
      Width = 121
      Height = 21
      TabOrder = 2
      OnChange = EditServerAddrChange
    end
    object EditServerPort: TEdit
      Left = 72
      Top = 58
      Width = 121
      Height = 21
      TabOrder = 3
      OnChange = EditServerPortChange
    end
  end
  object btnSaveOK: TButton
    Left = 370
    Top = 99
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 1
    OnClick = btnSaveOKClick
  end
end
