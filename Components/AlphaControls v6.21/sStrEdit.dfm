object StrEditDlg: TStrEditDlg
  Left = 403
  Top = 399
  BorderStyle = bsDialog
  Caption = 'String list editor'
  ClientHeight = 278
  ClientWidth = 442
  Color = clBtnFace
  Constraints.MinHeight = 305
  Constraints.MinWidth = 450
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TsPanel
    Left = 8
    Top = 8
    Width = 428
    Height = 229
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 5
    SkinData.SkinSection = 'PANEL_LOW'
    object LineCount: TsLabel
      Left = 4
      Top = 5
      Width = 169
      Height = 17
      AutoSize = False
      Caption = '0 lines'
    end
    object Memo: TsMemo
      Left = 8
      Top = 21
      Width = 412
      Height = 201
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = UpdateStatus
      OnKeyDown = MemoKeyDown
      BoundLabel.Indent = 0
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
  end
  object OKBtn: TsButton
    Left = 187
    Top = 245
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    SkinData.SkinSection = 'BUTTON'
  end
  object CancelBtn: TsButton
    Left = 267
    Top = 245
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    SkinData.SkinSection = 'BUTTON'
  end
  object HelpBtn: TsButton
    Left = 347
    Top = 245
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Help'
    TabOrder = 4
    OnClick = HelpBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object LoadBtn: TsButton
    Left = 8
    Top = 245
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Load...'
    TabOrder = 0
    OnClick = FileOpen
    SkinData.SkinSection = 'BUTTON'
  end
  object SaveBtn: TsButton
    Left = 92
    Top = 245
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Save...'
    TabOrder = 1
    OnClick = FileSave
    SkinData.SkinSection = 'BUTTON'
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'TXT'
    Filter = 
      'Text files (*.TXT)|*.TXT|Config files (*.SYS;*.INI)|*.SYS;*.INI|' +
      'Batch files (*.BAT)|*.BAT|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofFileMustExist]
    Title = 'Load string list'
    Left = 364
  end
  object SaveDialog: TSaveDialog
    Filter = 
      'Text files (*.TXT)|*.TXT|Config files (*.SYS;*.INI)|*.SYS;*.INI|' +
      'Batch files (*.BAT)|*.BAT|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofShowHelp, ofPathMustExist]
    Title = 'Save string list'
    Left = 392
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    GripMode = gmRightBottom
    TitleButtons = <>
    Left = 236
  end
end
