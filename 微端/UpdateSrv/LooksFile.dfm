object frmLooksFile: TfrmLooksFile
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25152#26377#25991#20214
  ClientHeight = 342
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object tabData: TPageControl
    Left = 0
    Top = 0
    Width = 500
    Height = 340
    ActivePage = Wzl
    TabOrder = 0
    object Wzl: TTabSheet
      Caption = 'Wzl'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object meWzlRunLog: TMemo
        Left = 0
        Top = 0
        Width = 489
        Height = 309
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object Map: TTabSheet
      Caption = 'Map'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MeMapRunLog: TMemo
        Left = 0
        Top = 0
        Width = 489
        Height = 309
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object Wav: TTabSheet
      Caption = 'Wav'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object meWavRunLog: TMemo
        Left = 0
        Top = 0
        Width = 489
        Height = 309
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
end
