object DBEditForm: TDBEditForm
  Left = 371
  Top = 74
  Caption = 'LEGENDM2'#25968#25454#24211#32534#36753#22120'(2019/02/25)'
  ClientHeight = 542
  ClientWidth = 719
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultSizeOnly
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BDPage: TPageControl
    Left = 0
    Top = 0
    Width = 719
    Height = 542
    ActivePage = StdItems
    Align = alClient
    TabOrder = 0
    OnChange = BDPageChange
    object Magic: TTabSheet
      Caption = #39764#27861
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DBMag: TDBGrid
        Left = 0
        Top = 0
        Width = 711
        Height = 514
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
    object Monster: TTabSheet
      Caption = #24618#29289
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DBMon: TDBGrid
        Left = 0
        Top = 0
        Width = 711
        Height = 514
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
    object StdItems: TTabSheet
      Caption = #29289#21697
      ImageIndex = 2
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 711
        Height = 514
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = DBGrid1DrawColumnCell
      end
    end
  end
  object ComboBox1: TComboBox
    Left = 175
    Top = 1
    Width = 145
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 1
    OnChange = ComboBox1Change
    Items.Strings = (
      '0  '#33647#21697
      '1  '#39135#29289
      '3  '#21367#36724
      '4  '#20070#31821
      '5  '#27494#22120
      '6  '#27494#22120'6'
      '7  '#20070#31821'7'
      '10 '#34915#26381'('#30007')'
      '11 '#34915#26381'('#22899')'
      '15 '#22836#30420
      '19 '#39033#38142
      '20 '#39033#38142
      '21 '#39033#38142
      '22 '#25106#25351
      '23 '#25106#25351
      '24 '#25163#38255
      '25 '#31526#12289#27602#33647
      '26 '#25163#38255
      '28 '#32709#33152
      '28 '#39532#29260
      '30 '#29031#26126#29289
      '31 '#25414#35013#29289#21697
      '52 '#38795#23376
      '53 '#23453#30707
      '54 '#33136#24102)
  end
  object Table1: TTable
    AutoRefresh = True
    DatabaseName = 'HeroDB'
    TableName = 'Magic.DB'
    Left = 380
    Top = 48
  end
  object Query1: TQuery
    DatabaseName = 'HeroDB'
    Left = 444
    Top = 48
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 412
    Top = 48
  end
end
