object Form1: TForm1
  Left = 192
  Top = 113
  Caption = 'LEGENDM2'#33050#26412#21152#35299#23494#24037#20855'(2019/02/03)'
  ClientHeight = 348
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 530
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Button5: TButton
      Left = 8
      Top = 7
      Width = 105
      Height = 25
      Caption = #28165#31354#25991#20214#21015#34920'(&A)'
      TabOrder = 0
      OnClick = Button5Click
    end
    object CheckBox1: TCheckBox
      Left = 123
      Top = 12
      Width = 97
      Height = 17
      Caption = #33258#21160#22791#20221#25991#20214
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object Button6: TButton
      Left = 219
      Top = 7
      Width = 105
      Height = 25
      Caption = #22791#20221#24674#22797'(&B)'
      TabOrder = 2
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 331
      Top = 7
      Width = 105
      Height = 25
      Caption = #21024#38500#22791#20221#25991#20214'(&D)'
      TabOrder = 3
      OnClick = Button7Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 302
    Width = 530
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 193
      Top = 16
      Width = 30
      Height = 12
      Caption = #23494#30721':'
    end
    object Button4: TButton
      Left = 438
      Top = 10
      Width = 75
      Height = 25
      Caption = #35299#23494'(&D)'
      TabOrder = 0
      OnClick = Button4Click
    end
    object Button3: TButton
      Left = 350
      Top = 10
      Width = 75
      Height = 25
      Caption = #21152#23494'(&E)'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Edit2: TEdit
      Left = 224
      Top = 13
      Width = 119
      Height = 20
      TabOrder = 2
      Text = 'legendm2'
    end
    object Button1: TButton
      Left = 101
      Top = 10
      Width = 85
      Height = 25
      Caption = #21024#38500#25991#20214'(&D)'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 10
      Width = 85
      Height = 25
      Caption = #28155#21152#25991#20214'(&A)'
      TabOrder = 4
      OnClick = Button2Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 38
    Width = 8
    Height = 264
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
  end
  object ListBox1: TListBox
    Left = 8
    Top = 38
    Width = 514
    Height = 264
    Hint = #21452#20987#21487#20197#26597#30475#25991#20214#20869#23481#12290
    Align = alClient
    ItemHeight = 12
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnDblClick = ListBox1DblClick
  end
  object Panel4: TPanel
    Left = 522
    Top = 38
    Width = 8
    Height = 264
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
  end
  object Button8: TButton
    Left = 444
    Top = 7
    Width = 79
    Height = 25
    Hint = #21487#20197#20445#23384#24403#21069#25152#26377#25991#20214#36335#24452#65292#26041#20415#19979#27425#20462#25913#12290
    Caption = #20445#23384#36335#24452'(&S)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = Button8Click
  end
  object OpenDialog1: TOpenDialog
    Filter = #25991#26412#25991#20214'|*.txt|'#25152#26377#25991#20214'|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 8
    Top = 272
  end
end
