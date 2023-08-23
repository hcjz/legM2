object Form1: TForm1
  Left = 198
  Top = 110
  BorderIcons = []
  Caption = 'LEGENDM2'#25968#25454#31649#29702#24037#20855' -  By: Development QQ:8302775'
  ClientHeight = 566
  ClientWidth = 902
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000010000000100000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000001111100000000000000000000000000011111000000000000000
    00000000000011111000000000000000000000000353B7800000000000000000
    000000000353B7800000000000000800000000000353B7800000000000008B30
    000088000353B78080000000000008B3000330460353B786008000000000008B
    3000B6660353B7866608000000000008B306BB760353B7866660800000000000
    8B86BBB70353B786666608000000000088BBBBBB0353B7866666600000000000
    08BBBBBB0353B7866666660000000000066BBB7B0353B7866666660000000000
    6666BB760353B786666666080000008066666B660353B7866666666000000080
    666666660353B7866B76666000000006666666660353B7866BB6666000000006
    666666660353B78B6BB7666000000080666666660353B78BBBBB766000000080
    666666660353B78BBBBBB76000000000666666660353B787BBB7BB0800000000
    666666010353B7887BB67B3800000008066660011333B811177666B300000000
    06666660011383310676603B30000000806666666001110666660083B8000000
    0806666666600666666000083B80000000806666666666666600000003B80000
    0008006666666666600000000000000000000800466666000800000000080000
    000000080000008800000000000000000000000000000000000000000000FFC0
    07FFFFC007FFFFC007FFFFF01FFFFFF01FFF3FF01FFF1E0007FF8E0001FFC600
    00FFE000007FF000003FF000003FF000001FE000001FE000000FC000000FC000
    000FC000000FC000000FC000000FC000000FE000000FE000000FE000000FF000
    0007F0000003F8000061FC0000F8FE0001FCFF8003FEFFE00FFFFFFFFFFF}
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object bsSkinStatusBar1: TbsSkinStatusBar
    Left = 0
    Top = 545
    Width = 902
    Height = 21
    HintImageIndex = 0
    TabOrder = 0
    SkinData = bsSkinData1
    SkinDataName = 'statusbar'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 21
    UseSkinFont = True
    RibbonStyle = False
    ImagePosition = bsipDefault
    TransparentMode = False
    CaptionImageIndex = -1
    RealHeight = -1
    AutoEnabledControls = True
    CheckedMode = False
    Checked = False
    DefaultAlignment = taLeftJustify
    DefaultCaptionHeight = 22
    BorderStyle = bvNone
    CaptionMode = False
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Caption = 'bsSkinStatusBar1'
    Align = alBottom
    SizeGrip = False
    object Gauge1: TGauge
      Left = 251
      Top = 0
      Width = 651
      Height = 21
      Align = alClient
      ForeColor = clBlue
      Progress = 0
    end
    object stStatus: TbsSkinStatusPanel
      Left = 0
      Top = 0
      Width = 251
      Height = 21
      HintImageIndex = 0
      TabOrder = 0
      SkinData = bsSkinData1
      SkinDataName = 'statuspanel'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      ShadowEffect = False
      ShadowColor = clBlack
      ShadowOffset = 0
      ShadowSize = 3
      ReflectionEffect = False
      ReflectionOffset = -5
      EllipsType = bsetNoneEllips
      UseSkinSize = True
      UseSkinFontColor = True
      BorderStyle = bvFrame
      Align = alLeft
      Caption = #23601#32490
      AutoSize = False
      ImageIndex = -1
      NumGlyphs = 1
    end
  end
  object bsSkinPageControl1: TbsSkinPageControl
    Left = 0
    Top = 0
    Width = 902
    Height = 545
    ActivePage = bsSkinTabSheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    MouseWheelSupport = False
    TabExtededDraw = False
    ButtonTabSkinDataName = 'resizetoolbutton'
    TabsOffset = 0
    TabSpacing = 1
    TextInHorizontal = False
    TabsInCenter = False
    FreeOnClose = False
    ShowCloseButtons = False
    TabsBGTransparent = False
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clBtnText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    UseSkinFont = True
    DefaultItemHeight = 20
    SkinData = bsSkinData1
    SkinDataName = 'tab'
    object bsSkinTabSheet1: TbsSkinTabSheet
      Caption = #22522#26412#35774#32622
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object bsSkinGroupBox1: TbsSkinGroupBox
        Left = 8
        Top = 8
        Width = 577
        Height = 129
        HintImageIndex = 0
        TabOrder = 0
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #26381#21153#22120#23433#35013#30446#24405
        UseSkinSize = True
        object Label1: TLabel
          Left = 16
          Top = 24
          Width = 81
          Height = 13
          AutoSize = False
          Caption = #20027#23433#35013#30446#24405#65306
          Transparent = True
        end
        object Label2: TLabel
          Left = 16
          Top = 48
          Width = 113
          Height = 13
          AutoSize = False
          Caption = #25968#25454#24211#26381#21153#22120#30446#24405#65306
          Transparent = True
        end
        object Label3: TLabel
          Left = 16
          Top = 72
          Width = 105
          Height = 13
          AutoSize = False
          Caption = #24080#21495#26381#21153#22120#30446#24405#65306
          Transparent = True
        end
        object Label4: TLabel
          Left = 16
          Top = 96
          Width = 97
          Height = 13
          AutoSize = False
          Caption = #25968#25454#24341#25806#30446#24405#65306
          Transparent = True
        end
        object edtMainDir: TbsSkinEdit
          Left = 128
          Top = 24
          Width = 441
          Height = 20
          Text = 'D:\MirServer\'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainGuildBaseButtonClick
        end
        object edtDBSPath: TbsSkinEdit
          Left = 128
          Top = 48
          Width = 441
          Height = 20
          Text = 'D:\MirServer\DBServer\'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainGuildBaseButtonClick
        end
        object bsSkinEdit2: TbsSkinEdit
          Left = 128
          Top = 72
          Width = 441
          Height = 20
          Text = 'D:\MirServer\LoginSrv\'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainGuildBaseButtonClick
        end
        object bsSkinEdit3: TbsSkinEdit
          Left = 128
          Top = 96
          Width = 441
          Height = 20
          Text = 'D:\MirServer\Mir200\'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainGuildBaseButtonClick
        end
      end
      object bsSkinGroupBox2: TbsSkinGroupBox
        Left = 8
        Top = 144
        Width = 577
        Height = 65
        HintImageIndex = 0
        TabOrder = 1
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #29289#21697#12289#25216#33021#12289#24618#29289#23450#20041#25968#25454#24211
        UseSkinSize = True
        object Label5: TLabel
          Left = 16
          Top = 35
          Width = 81
          Height = 22
          AutoSize = False
          Caption = #25968#25454#24211#21035#21517#65306
          Transparent = True
        end
        object bsSkinSpeedButton3: TbsSkinSpeedButton
          Left = 264
          Top = 31
          Width = 81
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #35774#32622
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = bsSkinSpeedButton3Click
        end
        object Edit1: TbsSkinEdit
          Left = 128
          Top = 32
          Width = 121
          Height = 20
          Text = 'HeroDB'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 20
          ButtonMode = False
          SkinData = bsSkinData1
          SkinDataName = 'edit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
        end
      end
    end
    object bsSkinTabSheet2: TbsSkinTabSheet
      Caption = #25968#25454#21512#24182
      object bsSkinGroupBox3: TbsSkinGroupBox
        Left = 0
        Top = 0
        Width = 569
        Height = 121
        HintImageIndex = 0
        TabOrder = 0
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #20027#25968#25454#24211
        UseSkinSize = True
        object Label6: TLabel
          Left = 16
          Top = 24
          Width = 49
          Height = 13
          AutoSize = False
          Caption = 'ID.DB'
          Transparent = True
        end
        object Label7: TLabel
          Left = 16
          Top = 48
          Width = 49
          Height = 13
          AutoSize = False
          Caption = 'Hun.DB'
          Transparent = True
        end
        object Label8: TLabel
          Left = 16
          Top = 72
          Width = 49
          Height = 13
          AutoSize = False
          Caption = 'Mir.DB'
          Transparent = True
        end
        object Label9: TLabel
          Left = 16
          Top = 96
          Width = 57
          Height = 13
          AutoSize = False
          Caption = 'GuildBase'
          Transparent = True
        end
        object edtMainIDDB: TbsSkinFileEdit
          Left = 72
          Top = 24
          Width = 481
          Height = 20
          Text = 'D:\MirServer\LoginSrv\IDDB\Id.DB'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainIDDBButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
        object edtMainHumDB: TbsSkinFileEdit
          Left = 72
          Top = 48
          Width = 481
          Height = 20
          Text = 'D:\MirServer\DBServer\FDB\Hum.DB'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainIDDBButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
        object edtMainMirDB: TbsSkinFileEdit
          Left = 72
          Top = 72
          Width = 481
          Height = 20
          Text = 'D:\MirServer\DBServer\FDB\mir.db'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainIDDBButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
        object edtMainGuildBase: TbsSkinFileEdit
          Left = 72
          Top = 96
          Width = 481
          Height = 20
          Text = 'D:\MirServer\Mir200\GuildBase\'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainGuildBaseButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
      end
      object bsSkinGroupBox4: TbsSkinGroupBox
        Left = 0
        Top = 121
        Width = 569
        Height = 120
        HintImageIndex = 0
        TabOrder = 1
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #20174#25968#25454#24211
        UseSkinSize = True
        object Label10: TLabel
          Left = 16
          Top = 24
          Width = 49
          Height = 13
          AutoSize = False
          Caption = 'ID.DB'
          Transparent = True
        end
        object Label11: TLabel
          Left = 16
          Top = 48
          Width = 49
          Height = 13
          AutoSize = False
          Caption = 'Hun.DB'
          Transparent = True
        end
        object Label12: TLabel
          Left = 16
          Top = 72
          Width = 49
          Height = 13
          AutoSize = False
          Caption = 'Mir.DB'
          Transparent = True
        end
        object Label13: TLabel
          Left = 16
          Top = 96
          Width = 57
          Height = 13
          AutoSize = False
          Caption = 'GuildBase'
          Transparent = True
        end
        object edtIDDB2: TbsSkinFileEdit
          Left = 72
          Top = 24
          Width = 481
          Height = 20
          Text = 'D:\MirServer2\LoginSrv\IDDB\Id.DB'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainIDDBButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
        object edtHumDB2: TbsSkinFileEdit
          Left = 72
          Top = 48
          Width = 481
          Height = 20
          Text = 'D:\MirServer2\DBServer\FDB\Hum.DB'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainIDDBButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
        object edtMirDB2: TbsSkinFileEdit
          Left = 72
          Top = 72
          Width = 481
          Height = 20
          Text = 'D:\MirServer2\DBServer\FDB\mir.db'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainIDDBButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
        object edtGuildBase2: TbsSkinFileEdit
          Left = 72
          Top = 96
          Width = 481
          Height = 20
          Text = 'D:\MirServer2\Mir200\GuildBase\'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainGuildBaseButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
      end
      object bsSkinGroupBox5: TbsSkinGroupBox
        Left = 0
        Top = 241
        Width = 569
        Height = 184
        HintImageIndex = 0
        TabOrder = 2
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taRightJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #21512#24182#35774#32622
        UseSkinSize = True
        object Label14: TLabel
          Left = 16
          Top = 24
          Width = 49
          Height = 13
          AutoSize = False
          Caption = #20445#23384#30446#24405
          Transparent = True
        end
        object Label20: TLabel
          Left = 16
          Top = 56
          Width = 177
          Height = 13
          AutoSize = False
          Caption = #37325#21517#35268#21017#65306#21518#38754#21152#65306
          Transparent = True
        end
        object Label24: TLabel
          Left = 16
          Top = 80
          Width = 97
          Height = 13
          AutoSize = False
          Caption = #20174#21306#31561#32423#35843#25972#65306
          Transparent = True
        end
        object Label25: TLabel
          Left = 149
          Top = 83
          Width = 180
          Height = 13
          AutoSize = False
          Caption = #32423#65292#20294#35843#25972#21518#26368#39640#19981#36229#36807#31561#32423#65306
          Transparent = True
        end
        object Label21: TLabel
          Left = 200
          Top = 59
          Width = 329
          Height = 13
          AutoSize = False
          Caption = #33509#36824#37325#21517#65292#21017#26368#21518#19968#20010#23383#31526#33258#21160#20351#29992'A..Z'#23581#35797#12290
          Transparent = True
        end
        object bsSkinEdit4: TbsSkinEdit
          Left = 72
          Top = 24
          Width = 481
          Height = 20
          Text = 'D:\'#26032#21306#25968#25454'\'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainGuildBaseButtonClick
        end
        object bsSkinNumericEdit1: TbsSkinNumericEdit
          Left = 104
          Top = 80
          Width = 41
          Height = 20
          Text = '0'
          Increment = 1.000000000000000000
          SupportUpDownKeys = False
          UseSkinFont = True
          ValueType = vtInteger
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 20
          ButtonMode = False
          SkinData = bsSkinData1
          SkinDataName = 'edit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
        end
        object Edit2: TEdit
          Left = 144
          Top = 56
          Width = 41
          Height = 22
          MaxLength = 4
          TabOrder = 2
          Text = 'a'
        end
        object bsSkinNumericEdit2: TbsSkinNumericEdit
          Left = 320
          Top = 80
          Width = 41
          Height = 20
          Text = '50'
          Increment = 1.000000000000000000
          SupportUpDownKeys = False
          UseSkinFont = True
          ValueType = vtInteger
          Value = 50.000000000000000000
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 20
          ButtonMode = False
          SkinData = bsSkinData1
          SkinDataName = 'edit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
        end
        object bsSkinPanel6: TbsSkinPanel
          Left = 8
          Top = 104
          Width = 553
          Height = 73
          HintImageIndex = 0
          TabOrder = 4
          SkinData = bsSkinData1
          SkinDataName = 'panel'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          RibbonStyle = False
          ImagePosition = bsipDefault
          TransparentMode = False
          CaptionImageIndex = -1
          RealHeight = -1
          AutoEnabledControls = True
          CheckedMode = False
          Checked = False
          DefaultAlignment = taLeftJustify
          DefaultCaptionHeight = 22
          BorderStyle = bvFrame
          CaptionMode = False
          RollUpMode = False
          RollUpState = False
          NumGlyphs = 1
          Spacing = 2
          object Label36: TLabel
            Left = 8
            Top = 24
            Width = 281
            Height = 13
            AutoSize = False
            Caption = 'GM'#21047#20986#29289#21697#32534#21495': '#21512#21306#21069#20174'                              '#21040
            Transparent = True
          end
          object Label37: TLabel
            Left = 8
            Top = 48
            Width = 297
            Height = 13
            AutoSize = False
            Caption = #26222#36890#29289#21697#32534#21495':      '#21512#21306#21069#20174'                              '#21040
            Transparent = True
          end
          object Label38: TLabel
            Left = 344
            Top = 24
            Width = 185
            Height = 13
            AutoSize = False
            Caption = #21512#21306#21518#20174'                            '#24320#22987#32534#21495
            Transparent = True
          end
          object Label39: TLabel
            Left = 344
            Top = 48
            Width = 185
            Height = 13
            AutoSize = False
            Caption = #21512#21306#21518#20174'                            '#24320#22987#32534#21495
            Transparent = True
          end
          object bsSkinNumericEdit4: TbsSkinNumericEdit
            Left = 256
            Top = 21
            Width = 81
            Height = 20
            Text = '10000000'
            Increment = 1.000000000000000000
            SupportUpDownKeys = False
            UseSkinFont = True
            ValueType = vtInteger
            Value = 10000000.000000000000000000
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 20
            ButtonMode = False
            SkinData = bsSkinData1
            SkinDataName = 'edit'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 14
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            ButtonImageIndex = -1
            LeftImageIndex = -1
            LeftImageHotIndex = -1
            LeftImageDownIndex = -1
            RightImageIndex = -1
            RightImageHotIndex = -1
            RightImageDownIndex = -1
          end
          object bsSkinNumericEdit3: TbsSkinNumericEdit
            Left = 152
            Top = 21
            Width = 81
            Height = 20
            Text = '0'
            Increment = 1.000000000000000000
            SupportUpDownKeys = False
            UseSkinFont = True
            ValueType = vtInteger
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 20
            ButtonMode = False
            SkinData = bsSkinData1
            SkinDataName = 'edit'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 14
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            ButtonImageIndex = -1
            LeftImageIndex = -1
            LeftImageHotIndex = -1
            LeftImageDownIndex = -1
            RightImageIndex = -1
            RightImageHotIndex = -1
            RightImageDownIndex = -1
          end
          object bsSkinNumericEdit5: TbsSkinNumericEdit
            Left = 152
            Top = 45
            Width = 81
            Height = 20
            Text = '10000001'
            Increment = 1.000000000000000000
            SupportUpDownKeys = False
            UseSkinFont = True
            ValueType = vtInteger
            Value = 10000001.000000000000000000
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 20
            ButtonMode = False
            SkinData = bsSkinData1
            SkinDataName = 'edit'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 14
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            ButtonImageIndex = -1
            LeftImageIndex = -1
            LeftImageHotIndex = -1
            LeftImageDownIndex = -1
            RightImageIndex = -1
            RightImageHotIndex = -1
            RightImageDownIndex = -1
          end
          object bsSkinNumericEdit6: TbsSkinNumericEdit
            Left = 256
            Top = 45
            Width = 81
            Height = 20
            Text = '2100000000'
            Increment = 1.000000000000000000
            SupportUpDownKeys = False
            UseSkinFont = True
            ValueType = vtInteger
            Value = 2100000000.000000000000000000
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 20
            ButtonMode = False
            SkinData = bsSkinData1
            SkinDataName = 'edit'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 14
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            ButtonImageIndex = -1
            LeftImageIndex = -1
            LeftImageHotIndex = -1
            LeftImageDownIndex = -1
            RightImageIndex = -1
            RightImageHotIndex = -1
            RightImageDownIndex = -1
          end
          object bsSkinNumericEdit7: TbsSkinNumericEdit
            Left = 392
            Top = 21
            Width = 81
            Height = 20
            Text = '10000'
            Increment = 1.000000000000000000
            SupportUpDownKeys = False
            UseSkinFont = True
            ValueType = vtInteger
            Value = 10000.000000000000000000
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 20
            ButtonMode = False
            SkinData = bsSkinData1
            SkinDataName = 'edit'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 14
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            ButtonImageIndex = -1
            LeftImageIndex = -1
            LeftImageHotIndex = -1
            LeftImageDownIndex = -1
            RightImageIndex = -1
            RightImageHotIndex = -1
            RightImageDownIndex = -1
          end
          object bsSkinNumericEdit8: TbsSkinNumericEdit
            Left = 392
            Top = 45
            Width = 81
            Height = 20
            Text = '10000000'
            Increment = 1.000000000000000000
            SupportUpDownKeys = False
            UseSkinFont = True
            ValueType = vtInteger
            Value = 10000000.000000000000000000
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 20
            ButtonMode = False
            SkinData = bsSkinData1
            SkinDataName = 'edit'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 14
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            ButtonImageIndex = -1
            LeftImageIndex = -1
            LeftImageHotIndex = -1
            LeftImageDownIndex = -1
            RightImageIndex = -1
            RightImageHotIndex = -1
            RightImageDownIndex = -1
          end
          object bsSkinCheckRadioBox9: TbsSkinCheckRadioBox
            Left = 8
            Top = -1
            Width = 121
            Height = 25
            HintImageIndex = 0
            TabOrder = 6
            SkinData = bsSkinData1
            SkinDataName = 'checkbox'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            WordWrap = False
            AllowGrayed = False
            State = cbChecked
            ImageIndex = 0
            Flat = True
            UseSkinFontColor = True
            TabStop = True
            CanFocused = True
            Radio = False
            Checked = True
            GroupIndex = 0
            Caption = #29289#21697#20174#26032#32534#21495
            OnClick = bsSkinCheckRadioBox9Click
          end
        end
      end
      object bsSkinPanel1: TbsSkinPanel
        Left = 0
        Top = 425
        Width = 569
        Height = 80
        HintImageIndex = 0
        TabOrder = 3
        SkinData = bsSkinData1
        SkinDataName = 'panel'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = False
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = 'bsSkinPanel1'
        object bitbtn1: TbsSkinSpeedButton
          Left = 16
          Top = 8
          Width = 89
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #25191#34892#21512#24182
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = BitBtn1Click
        end
        object bitbtn2: TbsSkinSpeedButton
          Left = 112
          Top = 8
          Width = 89
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #37325#21517#35760#24405
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = bitbtn2Click
        end
        object Label15: TLabel
          Left = 10
          Top = 42
          Width = 431
          Height = 31
          AutoSize = False
          Caption = #21512#24182#32467#26524#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
      end
    end
    object bsSkinTabSheet3: TbsSkinTabSheet
      Caption = #25968#25454#24211#31649#29702
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object bsSkinGroupBox6: TbsSkinGroupBox
        Left = 8
        Top = 8
        Width = 481
        Height = 113
        HintImageIndex = 0
        TabOrder = 0
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #26681#25454'Mir.DB'#37325#25972'Hum.DB'
        UseSkinSize = True
        object Label22: TLabel
          Left = 16
          Top = 24
          Width = 89
          Height = 13
          AutoSize = False
          Caption = 'Mir.DB'#35835#21462
          Transparent = True
        end
        object Label23: TLabel
          Left = 16
          Top = 48
          Width = 73
          Height = 13
          AutoSize = False
          Caption = 'Hun.DB'#20889#20837
          Transparent = True
        end
        object button8: TbsSkinSpeedButton
          Left = 120
          Top = 74
          Width = 97
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #25972#29702#25968#25454#24211
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = Button8Click
        end
        object bsSkinFileEdit1: TbsSkinFileEdit
          Left = 120
          Top = 24
          Width = 353
          Height = 20
          Text = 'E:\MirServer\DBServer\FDB\mir.db'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = edtMainIDDBButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
        object bsSkinFileEdit2: TbsSkinFileEdit
          Left = 120
          Top = 48
          Width = 353
          Height = 20
          Text = 'E:\MirServer\DBServer\FDB\hum.db'
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clBlack
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 0
          ButtonMode = True
          SkinData = bsSkinData1
          SkinDataName = 'buttonedit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
          OnButtonClick = bsSkinFileEdit2ButtonClick
          Filter = 'All files|*.*'
          LVHeaderSkinDataName = 'resizebutton'
        end
      end
      object bsSkinGroupBox7: TbsSkinGroupBox
        Left = 8
        Top = 128
        Width = 481
        Height = 105
        HintImageIndex = 0
        TabOrder = 1
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #25968#25454#24211#25972#29702
        UseSkinSize = True
      end
      object bsSkinGroupBox8: TbsSkinGroupBox
        Left = 496
        Top = 8
        Width = 257
        Height = 113
        HintImageIndex = 0
        TabOrder = 2
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #33258#21160#22791#20221
        UseSkinSize = True
        object Label27: TLabel
          Left = 20
          Top = 52
          Width = 113
          Height = 13
          AutoSize = False
          Caption = #38388#38548#26102#38388'('#20998#38047')'#65306
          Transparent = True
        end
        object bsSkinCheckRadioBox2: TbsSkinCheckRadioBox
          Left = 16
          Top = 20
          Width = 177
          Height = 25
          HintImageIndex = 0
          TabOrder = 0
          SkinData = bsSkinData1
          SkinDataName = 'checkbox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          WordWrap = False
          AllowGrayed = False
          State = cbUnchecked
          ImageIndex = 0
          Flat = True
          UseSkinFontColor = True
          TabStop = True
          CanFocused = True
          Radio = False
          Checked = False
          GroupIndex = 0
          Caption = #24320#21551#25968#25454#24211#33258#21160#22791#20221
        end
        object bsSkinSpinEdit2: TbsSkinSpinEdit
          Left = 120
          Top = 48
          Width = 65
          Height = 20
          HintImageIndex = 0
          TabOrder = 1
          SkinData = bsSkinData1
          SkinDataName = 'spinedit'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          DefaultColor = clWindow
          UseSkinSize = True
          ValueType = vtInteger
          MinValue = 1.000000000000000000
          MaxValue = 38400.000000000000000000
          Value = 180.000000000000000000
          Increment = 1.000000000000000000
          EditorEnabled = True
          MaxLength = 0
        end
      end
    end
    object bsSkinTabSheet4: TbsSkinTabSheet
      Caption = #29289#21697#26597#25214
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object bsSkinPanel2: TbsSkinPanel
        Left = 0
        Top = 0
        Width = 257
        Height = 523
        HintImageIndex = 0
        TabOrder = 0
        SkinData = bsSkinData1
        SkinDataName = 'panel'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = False
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = 'bsSkinPanel2'
        Align = alLeft
        ExplicitHeight = 524
        object bsSkinGroupBox9: TbsSkinGroupBox
          Left = 1
          Top = 1
          Width = 255
          Height = 112
          HintImageIndex = 0
          TabOrder = 0
          SkinData = bsSkinData1
          SkinDataName = 'groupbox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          RibbonStyle = False
          ImagePosition = bsipDefault
          TransparentMode = False
          CaptionImageIndex = -1
          RealHeight = -1
          AutoEnabledControls = True
          CheckedMode = False
          Checked = False
          DefaultAlignment = taLeftJustify
          DefaultCaptionHeight = 22
          BorderStyle = bvFrame
          CaptionMode = True
          RollUpMode = False
          RollUpState = False
          NumGlyphs = 1
          Spacing = 2
          Align = alTop
          UseSkinSize = True
          object Label16: TLabel
            Left = 8
            Top = 24
            Width = 49
            Height = 13
            AutoSize = False
            Caption = #20998#31867#65306
            Transparent = True
          end
          object Label17: TLabel
            Left = 8
            Top = 48
            Width = 49
            Height = 13
            AutoSize = False
            Caption = #21517#31216#65306
            Transparent = True
          end
          object bsSkinSpeedButton4: TbsSkinSpeedButton
            Left = 8
            Top = 80
            Width = 49
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #28155#21152
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
            OnClick = bsSkinSpeedButton4Click
          end
          object bsSkinSpeedButton5: TbsSkinSpeedButton
            Left = 64
            Top = 80
            Width = 57
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #28155#21152#26412#31867
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
            OnClick = bsSkinSpeedButton5Click
          end
          object bsSkinSpeedButton6: TbsSkinSpeedButton
            Left = 128
            Top = 80
            Width = 49
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #21024#38500
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
            OnClick = bsSkinSpeedButton6Click
          end
          object bsSkinSpeedButton7: TbsSkinSpeedButton
            Left = 184
            Top = 80
            Width = 57
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #20840#37096#21024#38500
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
            OnClick = bsSkinSpeedButton7Click
          end
          object ComboBox1: TbsSkinComboBox
            Left = 56
            Top = 24
            Width = 185
            Height = 20
            HintImageIndex = 0
            TabOrder = 0
            SkinData = bsSkinData1
            SkinDataName = 'combobox'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            UseSkinSize = True
            ToolButtonStyle = False
            AlphaBlend = False
            AlphaBlendValue = 0
            AlphaBlendAnimation = False
            ListBoxCaptionMode = False
            ListBoxDefaultFont.Charset = DEFAULT_CHARSET
            ListBoxDefaultFont.Color = clWindowText
            ListBoxDefaultFont.Height = 14
            ListBoxDefaultFont.Name = 'Arial'
            ListBoxDefaultFont.Style = []
            ListBoxDefaultCaptionFont.Charset = DEFAULT_CHARSET
            ListBoxDefaultCaptionFont.Color = clWindowText
            ListBoxDefaultCaptionFont.Height = 14
            ListBoxDefaultCaptionFont.Name = 'Arial'
            ListBoxDefaultCaptionFont.Style = []
            ListBoxDefaultItemHeight = 20
            ListBoxCaptionAlignment = taLeftJustify
            ListBoxUseSkinFont = True
            ListBoxUseSkinItemHeight = True
            ListBoxWidth = 0
            HideSelection = True
            AutoComplete = False
            ImageIndex = -1
            CharCase = ecNormal
            DefaultColor = clWindow
            Items.Strings = (
              '0-'#33647
              '1-'#24178#32905
              '2-'#25216#33021#21367#36724
              '3-'#21367#36724#12289#27833#12289#27700#12289#30707
              '4-'#20070#31821
              '5-'#27494#22120'1'
              '6-'#27494#22120'2'
              '7-'#24184#36816#39764#30418
              '8-'#20803#31070#25216#33021#20070
              '10-'#30007#34915
              '11-'#22899#34915
              '15-'#22836#30420
              '18-'#36229#32423#25216#33021#39033#38142
              '19-'#39033#38142#65288#25720#27861#36530#36991#65289
              '20-'#39033#38142
              '21-'#39033#38142#65288#25915#20987#21152#36895#65289
              '22-'#25106#25351
              '23-'#25106#25351#65288#29305#27530#65289
              '24-'#25163#38255
              '25-'#27602#12289#31526
              '26-'#25163#38255#12289#25163#22871
              '29-'#29305#27530#36947#20855
              '30-'#21195#31456#12289#31070#39280#12289#29031#26126#29289
              '31-'#25414#32465#29289#21697#12289#21367#36724
              '32-'#31354#39532#29260
              '33-'#39532#29260
              '34-'#36947#31526
              '35-'#21367#21253
              '36-'#22825#27668#21367#36724#12289#23553#21360
              '37-'#29305#27530#36947#20855
              '38-'#20445#30041
              '40-'#32905
              '41-'#34880#21073#30862#29255
              '42-'#37197#33647#21407#26009
              '43-'#30719#30707
              '44-'#29305#27530#29289#21697
              '45-'#32418#32511#34013#23453#30707
              '46-'#26143#29664#20196#29260
              '47-'#37329#26465#12289#37329#30742#12289#23453#30418#31561
              '48-'#26408#26448
              '49-'#25259#39118#12289#39764#27861#39068#26009#31561
              '50-'#20171#32461#20449#12289#23453#30418
              '51-'#38829#28846
              '52-'#28895#33457
              '54-'#29190#39592
              '55-'#22870#21048#12289#31192#31496
              '56-'#25171#22352
              '57-'#38468#36523
              '58-'#33136#24102
              '59-'#23453#30707
              '61-'#22825#22320#23453#30707
              '62-'#37492#23450#21367#36724
              '70-'#33521#38596
              '81-'#38795#23376
              '82-'#26410#37492#23450#38772#23376
              '83-'#26410#37492#23450#33136#24102
              '')
            ItemIndex = -1
            DropDownCount = 15
            HorizontalExtent = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 14
            Font.Name = 'Arial'
            Font.Style = []
            Sorted = False
            Style = bscbFixedStyle
            OnChange = ComboBox1Change
            OnDropDown = ComboBox1DropDown
          end
          object combobox2: TbsSkinComboBox
            Left = 56
            Top = 48
            Width = 185
            Height = 20
            HintImageIndex = 0
            TabOrder = 1
            SkinData = bsSkinData1
            SkinDataName = 'combobox'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            UseSkinSize = True
            ToolButtonStyle = False
            AlphaBlend = False
            AlphaBlendValue = 0
            AlphaBlendAnimation = False
            ListBoxCaptionMode = False
            ListBoxDefaultFont.Charset = DEFAULT_CHARSET
            ListBoxDefaultFont.Color = clWindowText
            ListBoxDefaultFont.Height = 14
            ListBoxDefaultFont.Name = 'Arial'
            ListBoxDefaultFont.Style = []
            ListBoxDefaultCaptionFont.Charset = DEFAULT_CHARSET
            ListBoxDefaultCaptionFont.Color = clWindowText
            ListBoxDefaultCaptionFont.Height = 14
            ListBoxDefaultCaptionFont.Name = 'Arial'
            ListBoxDefaultCaptionFont.Style = []
            ListBoxDefaultItemHeight = 20
            ListBoxCaptionAlignment = taLeftJustify
            ListBoxUseSkinFont = True
            ListBoxUseSkinItemHeight = True
            ListBoxWidth = 0
            HideSelection = True
            AutoComplete = False
            ImageIndex = -1
            CharCase = ecNormal
            DefaultColor = clWindow
            ItemIndex = -1
            DropDownCount = 15
            HorizontalExtent = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = 14
            Font.Name = 'Arial'
            Font.Style = []
            Sorted = False
            Style = bscbFixedStyle
          end
        end
        object ListView1: TListView
          Left = 1
          Top = 113
          Width = 255
          Height = 410
          Align = alClient
          Columns = <
            item
              Caption = #29289#21697#32534#21495
              Width = 80
            end
            item
              Caption = #29289#21697#21517#31216
              Width = 160
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 1
          ViewStyle = vsReport
        end
      end
      object bsSkinPanel3: TbsSkinPanel
        Left = 257
        Top = 0
        Width = 643
        Height = 524
        HintImageIndex = 0
        TabOrder = 1
        SkinData = bsSkinData1
        SkinDataName = 'panel'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = False
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = 'bsSkinPanel3'
        Align = alClient
        object Label18: TLabel
          Left = 1
          Top = 57
          Width = 72
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #29289#21697#25152#23646#21015#34920
          Transparent = True
        end
        object Label19: TLabel
          Left = 1
          Top = 255
          Width = 84
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #22797#21046#21697#25152#23646#21015#34920
          Transparent = True
        end
        object bsSkinSplitter1: TbsSkinSplitter
          Left = 1
          Top = 245
          Width = 641
          Height = 10
          Cursor = crVSplit
          Align = alTop
          MinSize = 10
          Transparent = False
          DefaultSize = 10
          SkinDataName = 'hsplitter'
          SkinData = bsSkinData1
        end
        object bsSkinGroupBox10: TbsSkinGroupBox
          Left = 1
          Top = 1
          Width = 641
          Height = 56
          HintImageIndex = 0
          TabOrder = 0
          SkinData = bsSkinData1
          SkinDataName = 'groupbox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          RibbonStyle = False
          ImagePosition = bsipDefault
          TransparentMode = False
          CaptionImageIndex = -1
          RealHeight = -1
          AutoEnabledControls = True
          CheckedMode = False
          Checked = False
          DefaultAlignment = taLeftJustify
          DefaultCaptionHeight = 22
          BorderStyle = bvFrame
          CaptionMode = True
          RollUpMode = False
          RollUpState = False
          NumGlyphs = 1
          Spacing = 2
          Align = alTop
          UseSkinSize = True
          object bsSkinSpeedButton8: TbsSkinSpeedButton
            Left = 8
            Top = 23
            Width = 65
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #21015#34920#26597#25214
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
            OnClick = bsSkinSpeedButton8Click
          end
          object bsSkinSpeedButton9: TbsSkinSpeedButton
            Left = 80
            Top = 23
            Width = 81
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #21046#36896#32534#30721#26597#25214
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
            OnClick = bsSkinSpeedButton9Click
          end
          object bsSkinSpeedButton10: TbsSkinSpeedButton
            Left = 168
            Top = 23
            Width = 65
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #28165#22797#21046#21697
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
            OnClick = bsSkinSpeedButton10Click
          end
          object bsSkinSpeedButton11: TbsSkinSpeedButton
            Left = 240
            Top = 23
            Width = 65
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #28165#38500#26085#24535
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
          end
          object bsSkinSpeedButton12: TbsSkinSpeedButton
            Left = 312
            Top = 23
            Width = 81
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #23548#20986#29289#21697#25152#23646
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
          end
          object bsSkinSpeedButton13: TbsSkinSpeedButton
            Left = 400
            Top = 23
            Width = 73
            Height = 25
            HintImageIndex = 0
            SkinData = bsSkinData1
            SkinDataName = 'toolbutton'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            CheckedMode = False
            UseSkinSize = True
            UseSkinFontColor = True
            WidthWithCaption = 0
            WidthWithoutCaption = 0
            ImageIndex = 0
            RepeatMode = False
            RepeatInterval = 100
            Transparent = False
            Flat = False
            AllowAllUp = False
            Down = False
            GroupIndex = 0
            Caption = #23548#20986#22797#21046#21697
            ShowCaption = True
            NumGlyphs = 1
            Spacing = 1
            OnClick = bsSkinSpeedButton13Click
          end
        end
        object ListView3: TListView
          Left = 1
          Top = 71
          Width = 641
          Height = 174
          Align = alTop
          Columns = <
            item
              Caption = #27880#20876'ID'
              Width = 80
            end
            item
              Caption = #35282#33394#21517#31216
              Width = 160
            end
            item
              Caption = #29289#21697#21517#31216
              Width = 120
            end
            item
              Caption = #29289#21697'ID'
              Width = 80
            end
            item
              Caption = #21046#36896#32534#30721
              Width = 80
            end
            item
              Caption = #20301#32622
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          SortType = stData
          TabOrder = 1
          ViewStyle = vsReport
          OnCompare = ListView3Compare
        end
        object ListView2: TListView
          Left = 1
          Top = 269
          Width = 641
          Height = 254
          Hint = #35831#28857#20987#40736#26631#28216#38190#26597#30475#21487#25191#34892#30340#20219#21153
          Align = alClient
          Columns = <
            item
              Caption = #27880#20876'ID'
              Width = 80
            end
            item
              Caption = #35282#33394#21517#31216
              Width = 160
            end
            item
              Caption = #29289#21697#21517#31216
              Width = 120
            end
            item
              Caption = #29289#21697'ID'
              Width = 80
            end
            item
              Caption = #21046#36896#32534#30721
              Width = 80
            end
            item
              Caption = #20301#32622
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          PopupMenu = bsSkinPopupMenu1
          ShowHint = True
          SortType = stData
          TabOrder = 2
          ViewStyle = vsReport
          OnCompare = ListView3Compare
        end
      end
    end
    object bsSkinTabSheet5: TbsSkinTabSheet
      Caption = #24080#21495#36164#26009
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object bsSkinExPanel1: TbsSkinExPanel
        Left = 0
        Top = 0
        Width = 900
        Height = 57
        HintImageIndex = 0
        TabOrder = 0
        SkinData = bsSkinData1
        SkinDataName = 'expanel'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        UseSkinSize = True
        CaptionImageIndex = -1
        NumGlyphs = 1
        Spacing = 2
        RealWidth = 0
        RealHeight = 0
        ShowRollButton = True
        ShowCloseButton = False
        DefaultCaptionHeight = 21
        RollState = False
        RollKind = rkRollVertical
        Moveable = False
        Sizeable = False
        Align = alTop
        Caption = #24080#21495#31649#29702
        object Label28: TLabel
          Left = 8
          Top = 24
          Width = 49
          Height = 13
          AutoSize = False
          Caption = #24080#21495#65306
          Transparent = True
        end
        object bsSkinSpeedButton14: TbsSkinSpeedButton
          Left = 168
          Top = 24
          Width = 57
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #25628#32034'(&S)'
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = bsSkinSpeedButton14Click
        end
        object bsSkinSpeedButton15: TbsSkinSpeedButton
          Left = 232
          Top = 24
          Width = 57
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #32534#36753'(&E)'
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = bsSkinSpeedButton15Click
        end
        object bsSkinSpeedButton17: TbsSkinSpeedButton
          Left = 368
          Top = 24
          Width = 65
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #19978#19968#39029'(&P)'
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = bsSkinSpeedButton17Click
        end
        object bsSkinSpeedButton18: TbsSkinSpeedButton
          Left = 440
          Top = 24
          Width = 65
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #19979#19968#39029'(&N)'
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = bsSkinSpeedButton18Click
        end
        object bsSkinSpeedButton19: TbsSkinSpeedButton
          Left = 512
          Top = 24
          Width = 65
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #36339#36716#21040'(&G)'
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = bsSkinSpeedButton19Click
        end
        object Label29: TLabel
          Left = 584
          Top = 29
          Width = 209
          Height = 13
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EdFindId: TbsSkinEdit
          Left = 56
          Top = 24
          Width = 97
          Height = 20
          DefaultColor = clWindow
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          DefaultWidth = 0
          DefaultHeight = 20
          ButtonMode = False
          SkinData = bsSkinData1
          SkinDataName = 'edit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ButtonImageIndex = -1
          LeftImageIndex = -1
          LeftImageHotIndex = -1
          LeftImageDownIndex = -1
          RightImageIndex = -1
          RightImageHotIndex = -1
          RightImageDownIndex = -1
        end
      end
      object ListView5: TListView
        Left = 0
        Top = 57
        Width = 900
        Height = 466
        Align = alClient
        Columns = <
          item
            Caption = #24207#21495
          end
          item
            Caption = #24080#21495
            Width = 80
          end
          item
            Caption = #23494#30721
            Width = 80
          end
          item
            Caption = #22995#21517
            Width = 80
          end
          item
            Caption = #36523#20221#35777
            Width = 120
          end
          item
            Caption = #29983#26085
            Width = 80
          end
          item
            Caption = #38382#39064#19968
            Width = 120
          end
          item
            Caption = #31572#26696#19968
            Width = 100
          end
          item
            Caption = #38382#39064#20108
            Width = 120
          end
          item
            Caption = #31572#26696#20108
            Width = 100
          end
          item
            Caption = #30005#35805
            Width = 100
          end
          item
            Caption = #31227#21160#30005#35805
            Width = 100
          end
          item
            Caption = #22791#27880#19968
            Width = 120
          end
          item
            Caption = #22791#27880#20108
            Width = 120
          end
          item
            Caption = #21019#24314#26102#38388
            Width = 120
          end
          item
            Caption = #26368#21518#30331#24405#26102#38388
            Width = 120
          end
          item
            Caption = #30005#23376#37038#31665
            Width = 120
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        SortType = stData
        TabOrder = 1
        ViewStyle = vsReport
        OnDblClick = ListView5DblClick
        ExplicitHeight = 467
      end
    end
    object bsSkinTabSheet6: TbsSkinTabSheet
      Caption = #35282#33394#36164#26009
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object bsSkinTabSheet7: TbsSkinTabSheet
      Caption = #29289#21697#36716#31227
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object bsSkinTabSheet8: TbsSkinTabSheet
      Caption = #29305#27530#22788#29702
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object bsSkinTabSheet9: TbsSkinTabSheet
      Caption = #26085#24535#20998#26512
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object bsSkinPageControl2: TbsSkinPageControl
        Left = 0
        Top = 0
        Width = 900
        Height = 523
        ActivePage = bsSkinTabSheet12
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        MouseWheelSupport = False
        TabExtededDraw = False
        ButtonTabSkinDataName = 'resizetoolbutton'
        TabsOffset = 0
        TabSpacing = 1
        TextInHorizontal = False
        TabsInCenter = False
        FreeOnClose = False
        ShowCloseButtons = False
        TabsBGTransparent = False
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clBtnText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        DefaultItemHeight = 20
        SkinData = bsSkinData1
        SkinDataName = 'tab'
        object bsSkinTabSheet12: TbsSkinTabSheet
          Caption = #28216#25103#26085#24535
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object bsSkinPanel4: TbsSkinPanel
            Left = 201
            Top = 0
            Width = 697
            Height = 501
            HintImageIndex = 0
            TabOrder = 0
            SkinData = bsSkinData1
            SkinDataName = 'panel'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            RibbonStyle = False
            ImagePosition = bsipDefault
            TransparentMode = False
            CaptionImageIndex = -1
            RealHeight = -1
            AutoEnabledControls = True
            CheckedMode = False
            Checked = False
            DefaultAlignment = taLeftJustify
            DefaultCaptionHeight = 22
            BorderStyle = bvFrame
            CaptionMode = False
            RollUpMode = False
            RollUpState = False
            NumGlyphs = 1
            Spacing = 2
            Caption = 'bsSkinPanel4'
            Align = alClient
            ExplicitHeight = 503
            object bsSkinHeaderControl1: TbsSkinHeaderControl
              Left = 1
              Top = 1
              Width = 695
              Height = 22
              Sections = <
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = #26085#24535#31867#22411
                  Width = 80
                end
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = #22320#22270
                  Width = 50
                end
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = 'X/'#31561#32423
                  Width = 50
                end
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = 'Y/'#32463#39564#20540
                  Width = 80
                end
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = #35282#33394
                  Width = 100
                end
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = #29289#21697
                  Width = 100
                end
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = #32534#21495'/'#25968#37327
                  Width = 70
                end
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = #35282#33394#31867#22411
                  Width = 60
                end
                item
                  ImageIndex = -1
                  Style = hsOwnerDraw
                  Text = #23545#26041#21517#31216
                  Width = 100
                end>
              DefaultFont.Charset = DEFAULT_CHARSET
              DefaultFont.Color = clWindowText
              DefaultFont.Height = 14
              DefaultFont.Name = 'Arial'
              DefaultFont.Style = []
              DefaultHeight = 0
              UseSkinFont = True
              SkinData = bsSkinData1
              SkinDataName = 'resizebutton'
            end
            object Memo2: TMemo
              Left = 1
              Top = 23
              Width = 695
              Height = 479
              Align = alClient
              ScrollBars = ssBoth
              TabOrder = 1
              WordWrap = False
            end
          end
          object bsSkinPanel5: TbsSkinPanel
            Left = 0
            Top = 0
            Width = 201
            Height = 501
            HintImageIndex = 0
            TabOrder = 1
            SkinData = bsSkinData1
            SkinDataName = 'panel'
            DefaultFont.Charset = DEFAULT_CHARSET
            DefaultFont.Color = clWindowText
            DefaultFont.Height = 14
            DefaultFont.Name = 'Arial'
            DefaultFont.Style = []
            DefaultWidth = 0
            DefaultHeight = 0
            UseSkinFont = True
            RibbonStyle = False
            ImagePosition = bsipDefault
            TransparentMode = False
            CaptionImageIndex = -1
            RealHeight = -1
            AutoEnabledControls = True
            CheckedMode = False
            Checked = False
            DefaultAlignment = taLeftJustify
            DefaultCaptionHeight = 22
            BorderStyle = bvFrame
            CaptionMode = False
            RollUpMode = False
            RollUpState = False
            NumGlyphs = 1
            Spacing = 2
            Caption = 'bsSkinPanel5'
            Align = alLeft
            ExplicitHeight = 503
            object Label31: TLabel
              Left = 1
              Top = 1
              Width = 199
              Height = 11
              Align = alTop
              AutoSize = False
              Transparent = True
            end
            object Label32: TLabel
              Left = 1
              Top = 12
              Width = 199
              Height = 19
              Align = alTop
              AutoSize = False
              Caption = #26085#24535#30446#24405#65306
              Transparent = True
            end
            object Label30: TLabel
              Left = 1
              Top = 51
              Width = 199
              Height = 19
              Align = alTop
              AutoSize = False
              Caption = #26174#31034#19979#21015#26085#24535#65306
              Transparent = True
              ExplicitTop = 49
            end
            object bsSkinSpeedButton20: TbsSkinSpeedButton
              Left = 104
              Top = 3
              Width = 89
              Height = 25
              HintImageIndex = 0
              SkinData = bsSkinData1
              SkinDataName = 'toolbutton'
              DefaultFont.Charset = DEFAULT_CHARSET
              DefaultFont.Color = clWindowText
              DefaultFont.Height = 14
              DefaultFont.Name = 'Arial'
              DefaultFont.Style = []
              DefaultWidth = 0
              DefaultHeight = 0
              UseSkinFont = True
              CheckedMode = False
              UseSkinSize = True
              UseSkinFontColor = True
              WidthWithCaption = 0
              WidthWithoutCaption = 0
              ImageIndex = 0
              RepeatMode = False
              RepeatInterval = 100
              Transparent = False
              Flat = False
              AllowAllUp = False
              Down = False
              GroupIndex = 0
              Caption = #26174#31034#26085#24535#21015#34920
              ShowCaption = True
              NumGlyphs = 1
              Spacing = 1
              OnClick = bsSkinSpeedButton20Click
            end
            object Label33: TLabel
              Left = 1
              Top = 203
              Width = 199
              Height = 11
              Align = alTop
              AutoSize = False
              Transparent = True
              ExplicitTop = 201
            end
            object Label34: TLabel
              Left = 1
              Top = 214
              Width = 199
              Height = 19
              Align = alTop
              AutoSize = False
              Caption = ' '#25628#32034#65306
              Transparent = True
              ExplicitTop = 212
            end
            object Label35: TLabel
              Left = 1
              Top = 233
              Width = 199
              Height = 34
              Align = alTop
              AutoSize = False
              Transparent = True
              ExplicitTop = 231
            end
            object bsSkinSpeedButton21: TbsSkinSpeedButton
              Left = 16
              Top = 235
              Width = 73
              Height = 25
              HintImageIndex = 0
              SkinData = bsSkinData1
              SkinDataName = 'toolbutton'
              DefaultFont.Charset = DEFAULT_CHARSET
              DefaultFont.Color = clWindowText
              DefaultFont.Height = 14
              DefaultFont.Name = 'Arial'
              DefaultFont.Style = []
              DefaultWidth = 0
              DefaultHeight = 0
              UseSkinFont = True
              CheckedMode = False
              UseSkinSize = True
              UseSkinFontColor = True
              WidthWithCaption = 0
              WidthWithoutCaption = 0
              ImageIndex = 0
              RepeatMode = False
              RepeatInterval = 100
              Transparent = False
              Flat = False
              AllowAllUp = False
              Down = False
              GroupIndex = 0
              Caption = #24320#22987#25628#32034
              ShowCaption = True
              NumGlyphs = 1
              Spacing = 1
            end
            object bsSkinSpeedButton22: TbsSkinSpeedButton
              Left = 112
              Top = 235
              Width = 73
              Height = 25
              HintImageIndex = 0
              SkinData = bsSkinData1
              SkinDataName = 'toolbutton'
              DefaultFont.Charset = DEFAULT_CHARSET
              DefaultFont.Color = clWindowText
              DefaultFont.Height = 14
              DefaultFont.Name = 'Arial'
              DefaultFont.Style = []
              DefaultWidth = 0
              DefaultHeight = 0
              UseSkinFont = True
              CheckedMode = False
              UseSkinSize = True
              UseSkinFontColor = True
              WidthWithCaption = 0
              WidthWithoutCaption = 0
              ImageIndex = 0
              RepeatMode = False
              RepeatInterval = 100
              Transparent = False
              Flat = False
              AllowAllUp = False
              Down = False
              GroupIndex = 0
              Caption = #20572#27490#25628#32034
              ShowCaption = True
              NumGlyphs = 1
              Spacing = 1
            end
            object edtLogBaseDir: TbsSkinFileEdit
              Left = 1
              Top = 31
              Width = 199
              Height = 20
              Text = 'D:\mirserver\LogServer\BaseDir\'
              DefaultColor = clWindow
              DefaultFont.Charset = DEFAULT_CHARSET
              DefaultFont.Color = clBlack
              DefaultFont.Height = 14
              DefaultFont.Name = 'Arial'
              DefaultFont.Style = []
              UseSkinFont = True
              DefaultWidth = 0
              DefaultHeight = 0
              ButtonMode = True
              SkinData = bsSkinData1
              SkinDataName = 'buttonedit'
              Align = alTop
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = 14
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              ButtonImageIndex = -1
              LeftImageIndex = -1
              LeftImageHotIndex = -1
              LeftImageDownIndex = -1
              RightImageIndex = -1
              RightImageHotIndex = -1
              RightImageDownIndex = -1
              OnButtonClick = edtMainGuildBaseButtonClick
              Filter = 'All files|*.*'
              LVHeaderSkinDataName = 'resizebutton'
            end
            object CheckListBox1: TCheckListBox
              Left = 1
              Top = 70
              Width = 199
              Height = 133
              Align = alTop
              Columns = 2
              ItemHeight = 14
              Items.Strings = (
                #21462#20986#29289#21697
                #23384#36827#29289#21697
                #28860#21046#33647#21697
                #35013#22791#25481#25345#20037
                #25315#21040#29289#21697
                #21046#36896#29289#21697
                #20002#24323#29289#21697
                #20132#26131#21334#20986
                #20132#26131#36141#20080
                #20986#21806'/'#27809#25910
                #20351#29992#29289#21697
                #21319#32423'/'#32463#39564
                #37329#24065#20943#23569
                #37329#24065#22686#21152
                #27515#20129#25481#29289#21697
                #25481#35013#22791
                #20803#23453
                #28216#25103#28857
                #20154#29289#27515#20129
                #27494#22120#21319#32423
                #27494#22120#30772#30862
                #27494#22120#21319#32423#23436#25104
                #27494#22120#21319#32423#24320#22987
                #25481#21253#35065#29289#21697
                #27801#22478#20027#25913#21464
                #21462#20986#23456#29289#21253#35065
                #23384#20837#33521#38596#21253#35065
                #21462#20986#33521#38596#21253#35065)
              TabOrder = 1
            end
            object bsSkinEdit1: TbsSkinEdit
              Left = 64
              Top = 208
              Width = 129
              Height = 20
              DefaultColor = clWindow
              DefaultFont.Charset = DEFAULT_CHARSET
              DefaultFont.Color = clWindowText
              DefaultFont.Height = 14
              DefaultFont.Name = 'Arial'
              DefaultFont.Style = []
              UseSkinFont = True
              DefaultWidth = 0
              DefaultHeight = 20
              ButtonMode = False
              SkinData = bsSkinData1
              SkinDataName = 'edit'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = 14
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              ButtonImageIndex = -1
              LeftImageIndex = -1
              LeftImageHotIndex = -1
              LeftImageDownIndex = -1
              RightImageIndex = -1
              RightImageHotIndex = -1
              RightImageDownIndex = -1
            end
            object bsSkinCheckRadioBox8: TbsSkinCheckRadioBox
              Left = 1
              Top = 267
              Width = 199
              Height = 25
              HintImageIndex = 0
              TabOrder = 3
              SkinDataName = 'checkbox'
              DefaultFont.Charset = DEFAULT_CHARSET
              DefaultFont.Color = clWindowText
              DefaultFont.Height = 14
              DefaultFont.Name = 'Arial'
              DefaultFont.Style = []
              DefaultWidth = 0
              DefaultHeight = 0
              UseSkinFont = True
              WordWrap = False
              AllowGrayed = False
              State = cbUnchecked
              ImageIndex = 0
              Flat = True
              UseSkinFontColor = True
              TabStop = True
              CanFocused = True
              Radio = False
              Checked = False
              GroupIndex = 0
              Caption = #28857#21462#19979#38754#26085#24535#21363#26174#31034#20869#23481
              Align = alTop
              ExplicitTop = 265
            end
            object lbLogDirList: TbsSkinListBox
              Left = 1
              Top = 292
              Width = 199
              Height = 210
              HintImageIndex = 0
              TabOrder = 4
              SkinData = bsSkinData1
              SkinDataName = 'listbox'
              DefaultFont.Charset = DEFAULT_CHARSET
              DefaultFont.Color = clWindowText
              DefaultFont.Height = 14
              DefaultFont.Name = 'Arial'
              DefaultFont.Style = []
              DefaultWidth = 0
              DefaultHeight = 0
              UseSkinFont = True
              AutoComplete = True
              UseSkinItemHeight = True
              HorizontalExtent = True
              Columns = 0
              RowCount = 0
              ImageIndex = -1
              NumGlyphs = 1
              Spacing = 2
              CaptionMode = False
              DefaultCaptionHeight = 20
              DefaultCaptionFont.Charset = DEFAULT_CHARSET
              DefaultCaptionFont.Color = clWindowText
              DefaultCaptionFont.Height = 14
              DefaultCaptionFont.Name = 'Arial'
              DefaultCaptionFont.Style = []
              DefaultItemHeight = 20
              ItemIndex = -1
              MultiSelect = True
              ListBoxFont.Charset = DEFAULT_CHARSET
              ListBoxFont.Color = clWindowText
              ListBoxFont.Height = 14
              ListBoxFont.Name = 'Arial'
              ListBoxFont.Style = []
              ListBoxTabOrder = 0
              ListBoxTabStop = True
              ListBoxDragMode = dmManual
              ListBoxDragKind = dkDrag
              ListBoxDragCursor = crDrag
              ExtandedSelect = True
              Sorted = False
              ShowCaptionButtons = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = 14
              Font.Name = 'Arial'
              Font.Style = []
              Align = alClient
            end
          end
        end
        object bsSkinTabSheet13: TbsSkinTabSheet
          Caption = #25511#21046#21488#26085#24535
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
      end
    end
    object bsSkinTabSheet10: TbsSkinTabSheet
      Caption = #25968#25454#25490#34892
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object bsSkinGroupBox11: TbsSkinGroupBox
        Left = 0
        Top = 0
        Width = 900
        Height = 53
        HintImageIndex = 0
        TabOrder = 0
        SkinData = bsSkinData1
        SkinDataName = 'groupbox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        RibbonStyle = False
        ImagePosition = bsipDefault
        TransparentMode = False
        CaptionImageIndex = -1
        RealHeight = -1
        AutoEnabledControls = True
        CheckedMode = False
        Checked = False
        DefaultAlignment = taLeftJustify
        DefaultCaptionHeight = 22
        BorderStyle = bvFrame
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = #25968#25454#25490#34892#21442#25968
        Align = alTop
        UseSkinSize = True
        object Label26: TLabel
          Left = 336
          Top = 29
          Width = 113
          Height = 13
          AutoSize = False
          Caption = #21015#20986#25968#25454#26465#25968#65306
          Transparent = True
        end
        object bsSkinSpeedButton1: TbsSkinSpeedButton
          Left = 560
          Top = 23
          Width = 81
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #26597#35810
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
          OnClick = bsSkinSpeedButton1Click
        end
        object bsSkinSpeedButton2: TbsSkinSpeedButton
          Left = 648
          Top = 23
          Width = 81
          Height = 25
          HintImageIndex = 0
          SkinData = bsSkinData1
          SkinDataName = 'toolbutton'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          CheckedMode = False
          UseSkinSize = True
          UseSkinFontColor = True
          WidthWithCaption = 0
          WidthWithoutCaption = 0
          ImageIndex = 0
          RepeatMode = False
          RepeatInterval = 100
          Transparent = False
          Flat = False
          AllowAllUp = False
          Down = False
          GroupIndex = 0
          Caption = #32534#36753
          ShowCaption = True
          NumGlyphs = 1
          Spacing = 1
        end
        object bsSkinCheckRadioBox3: TbsSkinCheckRadioBox
          Left = 16
          Top = 23
          Width = 65
          Height = 25
          HintImageIndex = 0
          TabOrder = 0
          SkinData = bsSkinData1
          SkinDataName = 'radiobox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          WordWrap = False
          AllowGrayed = False
          State = cbChecked
          ImageIndex = 0
          Flat = True
          UseSkinFontColor = True
          TabStop = True
          CanFocused = True
          Radio = True
          Checked = True
          GroupIndex = 1
          Caption = #31561#32423
        end
        object bsSkinCheckRadioBox4: TbsSkinCheckRadioBox
          Left = 80
          Top = 23
          Width = 57
          Height = 25
          HintImageIndex = 0
          TabOrder = 1
          SkinData = bsSkinData1
          SkinDataName = 'radiobox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          WordWrap = False
          AllowGrayed = False
          State = cbUnchecked
          ImageIndex = 0
          Flat = True
          UseSkinFontColor = True
          TabStop = True
          CanFocused = True
          Radio = True
          Checked = False
          GroupIndex = 1
          Caption = #37329#24065
        end
        object bsSkinCheckRadioBox5: TbsSkinCheckRadioBox
          Left = 136
          Top = 23
          Width = 57
          Height = 25
          HintImageIndex = 0
          TabOrder = 2
          SkinData = bsSkinData1
          SkinDataName = 'radiobox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          WordWrap = False
          AllowGrayed = False
          State = cbUnchecked
          ImageIndex = 0
          Flat = True
          UseSkinFontColor = True
          TabStop = True
          CanFocused = True
          Radio = True
          Checked = False
          GroupIndex = 1
          Caption = #20803#23453
        end
        object bsSkinCheckRadioBox6: TbsSkinCheckRadioBox
          Left = 192
          Top = 23
          Width = 65
          Height = 25
          HintImageIndex = 0
          TabOrder = 3
          SkinData = bsSkinData1
          SkinDataName = 'radiobox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          WordWrap = False
          AllowGrayed = False
          State = cbUnchecked
          ImageIndex = 0
          Flat = True
          UseSkinFontColor = True
          TabStop = True
          CanFocused = True
          Radio = True
          Checked = False
          GroupIndex = 1
          Caption = #28216#25103#28857
        end
        object bsSkinCheckRadioBox7: TbsSkinCheckRadioBox
          Left = 264
          Top = 23
          Width = 57
          Height = 25
          HintImageIndex = 0
          TabOrder = 4
          SkinData = bsSkinData1
          SkinDataName = 'radiobox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          WordWrap = False
          AllowGrayed = False
          State = cbUnchecked
          ImageIndex = 0
          Flat = True
          UseSkinFontColor = True
          TabStop = True
          CanFocused = True
          Radio = True
          Checked = False
          GroupIndex = 1
          Caption = #22768#26395
        end
        object bsSkinCheckRadioBox1: TbsSkinCheckRadioBox
          Left = 480
          Top = 23
          Width = 73
          Height = 25
          HintImageIndex = 0
          TabOrder = 5
          SkinData = bsSkinData1
          SkinDataName = 'checkbox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          WordWrap = False
          AllowGrayed = False
          State = cbChecked
          ImageIndex = 0
          Flat = True
          UseSkinFontColor = True
          TabStop = True
          CanFocused = True
          Radio = False
          Checked = True
          GroupIndex = 0
          Caption = #21253#21547#33521#38596
        end
        object bsSkinSpinEdit1: TbsSkinSpinEdit
          Left = 424
          Top = 25
          Width = 49
          Height = 20
          HintImageIndex = 0
          TabOrder = 6
          SkinData = bsSkinData1
          SkinDataName = 'spinedit'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          DefaultColor = clWindow
          UseSkinSize = True
          ValueType = vtInteger
          MinValue = 1.000000000000000000
          MaxValue = 100.000000000000000000
          Value = 50.000000000000000000
          Increment = 1.000000000000000000
          EditorEnabled = True
          MaxLength = 0
        end
      end
      object ListView4: TListView
        Left = 0
        Top = 53
        Width = 900
        Height = 471
        Align = alClient
        Columns = <
          item
            Caption = #24207#21495
          end
          item
            Caption = #35282#33394#21517
            Width = 120
          end
          item
            Caption = #24080#21495
            Width = 80
          end
          item
            Caption = #32844#19994
            Width = 40
          end
          item
            Caption = #24615#21035
            Width = 40
          end
          item
            Alignment = taRightJustify
            Caption = #31561#32423
          end
          item
            Alignment = taRightJustify
            Caption = #32463#39564#20540
            Width = 100
          end
          item
            Alignment = taRightJustify
            Caption = #37329#24065
            Width = 120
          end
          item
            Alignment = taRightJustify
            Caption = #20803#23453
            Width = 100
          end
          item
            Alignment = taRightJustify
            Caption = #28216#25103#28857
            Width = 80
          end
          item
            Alignment = taRightJustify
            Caption = #22768#26395
          end
          item
            Alignment = taRightJustify
            Caption = #32034#24341
            Width = 60
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        SortType = stData
        TabOrder = 1
        ViewStyle = vsReport
        OnCompare = ListView4Compare
      end
    end
    object bsSkinTabSheet11: TbsSkinTabSheet
      Caption = #25805#20316#26085#24535
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 900
        Height = 524
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object opendirdialog: TbsSkinSelectDirectoryDialog
    TreeShowLines = True
    TreeButtonExpandImageIndex = 0
    TreeButtonNoExpandImageIndex = 1
    ToolButtonImageIndex = 0
    ToolButtonsTransparent = False
    DialogWidth = 0
    DialogHeight = 0
    DialogMinWidth = 0
    DialogMinHeight = 0
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    SkinData = bsSkinData1
    CtrlSkinData = bsSkinData1
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = #23435#20307
    DefaultFont.Style = []
    Title = #36873#25321#25991#20214#22841
    ShowToolBar = False
    Left = 540
    Top = 9
  end
  object bsSkinData1: TbsSkinData
    DlgTreeViewDrawSkin = True
    DlgTreeViewItemSkinDataName = 'listbox'
    DlgListViewDrawSkin = True
    DlgListViewItemSkinDataName = 'listbox'
    SkinnableForm = True
    AnimationForAllWindows = False
    EnableSkinEffects = True
    ShowButtonGlowFrames = True
    ShowCaptionButtonGlowFrames = True
    ShowLayeredBorders = True
    AeroBlurEnabled = True
    CompressedStoredSkin = bsCompressedStoredSkin1
    SkinIndex = 0
    Left = 172
    Top = 25
  end
  object bsCompressedStoredSkin1: TbsCompressedStoredSkin
    FileName = 'skin.ini'
    Left = 268
    Top = 25
    CompressedData = {
      78DAED5D09805C45D1AE24C00E8124A0E081A8C87D4C60E6CDB5933004421208
      21072117D984B057B29BEC95DDD9CD2680190EDD55C09553E5D2FF0741C49343
      14B41F220222228A271041F417231EE0F1677FFF1FF2F7F18EAEEE373BC7CEEC
      CE24EFC16467BADFF155775575755575BF49408FD90B9FDD00FC786222C0F1F4
      EF4FE8671BFD4C80002F0F34037C6FAAF8DC09E2C38EDDBB77C36513002EA3D7
      65E8EF0CFD7EF924FAD907E0CAFD26C015FB4E808FEE3F013E12A01FFAF7CA9A
      09307000FD1C48CB27D30FFD3E78E044189C32113E7ED044F8D854FA99467FD3
      BF57BF937E0E990857BD83D61D3C11AE3974120CBD67127CE25DF4F36EFAA1DF
      AFA1DFAF3D7C127CF230FA791FAD7FEF24B8EEFD93E08623F6811B3EB40F5CFF
      41FAA1DFAFFBC03E70D3D1F473CC3E70E391F473D43EF0A963F6854F1DBB2F7C
      E6847DE1D3C7D1CFF1F437FD7B4B907EA6EF0B379F44EB4EDC176E3B653FB8F5
      64FAA17F3F1BD90F6E0FD38FB11FDC16A21FFAFD73315A1EDD0FFEB3B606FE23
      4E3F891AF8FCA9F493AA813B67D20FFD7E47927E66D4C05DA705E0F3A7D5C03D
      6706E00BB30370F7E9F4734600EE9A15802FCEA59F7901B8674E00BE74F6FE70
      EF3CFA398B7EE8F7AF2EDC1FBE72EEFEF0E573E867C1FEF0A5F9B46CD1FE70FF
      F993E1BEA5F443FF7E7D09FD9C3719BEB678323CB09C7E564C86FB97D10FFDFE
      D0EA03E01B171C000FAEA49F5507C0B7D6D2CF85F4B3EE00F8E61AFAA1BF1FAA
      3B001E5E77203C7CD18140D61F08DF69A29FE603E1DB8D07C223F5F4D340CB37
      1C088FB54D81C7DAA7C07737D10FFDFE682BFD6C9C0266CB14F85E07FD74D27A
      FAF7899EA9F0447A2A7CBF7B2A3CDE453F9BA7C2537DF4B3857EFAA7C20F2F9E
      064FF64E852769D9D35BA7C1D3DBE88796FDA09F7EE8EF1F6D9F06CF5C4A3F1F
      9E063FBC641A3C77C541F0E3CB0F826733F47319FD4E7F3FFAE8A390C964381F
      EE89C77FFCE79E75709A26FCC79E74F834F934F934F934F934F934F934F934F9
      34F934F934F934F934F934F934F934F934F934F934F934F934F934F934F934F9
      34F934F934F934F934F934F934F934F934F934F934F934F934F934F934F934F9
      34F934F934F934F934F934F934F934F934F934F934F934F934F934F934F934F9
      34F934F934F934F934F934F934F934F934F934F934F934F934F934F934F934F9
      34F934F934F934F934F934F93455394DFBEC3B71D27EFBD5ECBF7F60CA94030E
      9C7CD0C153A7BDE39DEF3EF45D871CF2BEC30E7BCF7BDF7BF8873EF0C123DE7F
      CC51471D7DE491C79E74D209271E77FCF1279F724A707A281C8B440D23595B1B
      4F24669E3AE3F4334E9B954A9D397BF6DC79F3E6CC5970EEB9F3CF39EBEC450B
      CF3FEFBCA54B962C5EB162D9F25517AC5EB96EEDDA0BD7ACA9ABBB68FDFAA6E6
      E686C6FAD68D1B5ADADB3BDADA36A5D3DD3D9D5D9B7BFB2EBEF8926DDBFAFBB7
      6ED972E995575E7EC51599CB3EBC7DE0231FBDEAAAAB3FFEF1C18F7DECDAEBAE
      F9C4D04D9FBAFE861B3F79CB673E73F3A73F7DFB673F7BDBE76EF569F269F269
      F269F269F269F269F269F269F269F269F269F269F269F2FD115542D31E75089A
      F6B003C4EB7C4E6B15AF0F89EF93FB753EB4D03968B3C0C4891361D2A449B0CF
      3EFBC0BEFBEE0BFBEDB71FD4D4D440201080FDF7DF1F264F9E0C071C70001C78
      E0813065CA14983A752A4C9B360D0E3AE82038F8E083E11DEF7807BCF39DEF84
      430E39040E3DF45078D7BBDE05EF7EF7BBE13DEF790FBCF7BDEF85C30E3B0CDE
      F7BEF7C1E1871F0EEF7FFFFBE1031FF8007CF0831F84238E38023EF4A10FC191
      471E09471D75141C7DF4D170CC31C7C0B1C71E0BC71D771C1C7FFCF170C20927
      C089279E08279D7412048341983E7D3A9C7CF2C970CA29A74028148270380C86
      614024128168340AB1580CE2F138241209A8ADAD856432093366CC80993367C2
      A9A79E0AA9540A4E3BED3498356B169C7EFAE970C61967C0ECD9B3E1CC33CF84
      3973E6C0DCB97361DEBC7970D65967C1D9679F0DF3E7CF8773CE3907162C5800
      E79E7B2E2C5CB810162D5A048B172F86254B96C079E79D074B972E85F3CF3F1F
      962D5B06CB972F87152B56C0CA952B61D5AA5570C10517C0EAD5ABA1AEAE0ED6
      AC59036BD7AE850B2FBC10D6AD5B07175D7411D4D7D743434303343636425353
      13343737C3FAF5EB61C3860DD0D2D202ADADADB071E346D8B46913B4B5B5417B
      7B3B74747440676727747575C1E6CD9BA1BBBB1B7A7A7A209D4E436F6F2FF4F5
      F5C1962D5BA0BFBF1FB66EDD0ADBB66D838B2FBE182EB9E412B8F4D24BE1C31F
      FE306CDFBE9DBF46E7B2CB2E83CB2FBF1CAEB8E20AB8F2CA2BE1231FF9087CF4
      A31F85818101181C1C848F7DEC63F0F18F7F1CAEBAEA2AB8FAEAABE19A6BAE81
      4F7CE213303434049FFCE427E1DA6BAF85EBAEBB0EAEBFFE7AB8E1861BE0C61B
      6F849B6EBA093EF5A94FC1A73FFD69F8CC673E0337DF7C33DC72CB2D70EBADB7
      C26DB7DD06B7DF7E3B7CF6B39F85CF7DEE734C1C81BD25E68E3BEE803BEFBC13
      3EFFF9CFC35D77DD0577DF7D377CE10B5F807BEEB907BEF8C52FC2BDF7DE0B5F
      FAD297E0CB5FFE327CE52B5F81AF7EF5ABF0B5AF7D0DBEFEF5AFC37DF7DD07F7
      DF7F3F3CF0C003F0E0830FC237BEF10D78E8A187E09BDFFC267CEB5BDF82871F
      7E181E79E411F8F6B7BF0DDFF9CE77801002A669F257097DF7BBDF85C71E7B0C
      BEF7BDEFC1E38F3F0EDFFFFEF7E189279E80279F7C129E7AEA29F8C10F7E004F
      3FFD34FCF0873F84679E79067EF4A31FC1B3CF3E0B3FFEF18FE1B9E79E839FFC
      E427F0D39FFE149E7FFE79F8D9CF7E063FFFF9CFE117BFF805FCF297BF845FFD
      EA57F0EB5FFF1A5E78E10578F1C517E1A5975E821D3B76C06F7EF31B78F9E597
      E195575E81DFFEF6B7F0EAABAFC2EF7EF73BF8FDEF7F0FFFF55FFF057FF8C31F
      E0B5D75E833FFEF18FB073E74EF8D39FFE04AFBFFE3AFCF9CF7F86BFFCE52FF0
      D7BFFE15FEF6B7BFC11B6FBC016FBEF926FCFDEF7F877FFCE31FF0CF7FFE13FE
      F5AF7FC17FFFF77FC3AE5DBB60787818FEE77FFE07FEFDEF7FC3FFFEEFFFC2FF
      FDDFFFC15B6FBD056FBFFDF61EFBFA2473BB747C78FB288F0F8FA2B6340F6334
      91DD84507E25F43F9310FB1FF720A246FC23BE385FD977E2FC1627DB7FAC93AD
      13AD3BB81F223DC6BE997B09712A885B613F524022D61F0B1CB19EC569327713
      E77944C668FD701E2A6E4A880BCDBDD005E13E9A58870CD2268638B722327936
      48532649AD9588B1AAED3B9A2E4D366AB7B1DCB34DE25EE63496FD60E28277EF
      21F7A2DC336E93BB00E45BE2BE7438C4621D93C89C62379DFD608BBB588DC57B
      36329932FB3AAB414D441C62379B1324FE94A835DD9E90DADB6122975C899194
      C671A1D8143ADCE28A8AC37E763FC90F212E5422311D21188A2B49A62C0444EA
      639BA988C3FEA84B096E30F7429320B626125BB8A28AA5DB7404CCB475845365
      A206711BD6E51A09B2C55E4E93C96A421219A779DD2E315D9132259D614A6CE9
      4A09C17D86781CF188F86DEB08226B26D3E52ED3B92F4172E18AA9CA6C2E66A4
      089DE637892B8992EAC47C2B2933B71B89A467A5DB20D5C94E90794FE63697AD
      88DB1A0ECF9B12BF11134176E92158FFABDC6B620E93F487CBFD92101057E310
      A2B09FD415AC52D27B5893B9F429D05C1955159C44A2AB3B2499235213E3A691
      61C93A11290BD4E8D2704314DE94E449517B922C13B5C5F170E86227A63C604B
      631B410A08331926C9943404C10C4A086261C746903BD294FAC9656C57C62501
      4083A1AC1E0952812ECB3A239B290F642E16D7FE20B2AA955482328211955D89
      DB9092ADC04FC334A93C4090C164CA7246907A23CAB8894643599DC85D61A2D1
      1F0DCE040D3FB2C637513F4B7CE9AA497BCC95F5221A0C24AAA4662604A91399
      B389223644B12390E2910718134B0831B59E508C3222B3AE2436687CF2B059D1
      DD251D8EA498B89A84E001C7C42A8C28024450DFCA8A0D0F3DB25EC125A66C29
      5B08915DAE693B130DB9124748A28C4D34579231F1B2C5AF19C5AE6A45E61422
      40360891C92A31B5D517C83692A49E20BD2541C74328524412AB107968964C08
      449164CDEA9315348F40171089ED64EBC469286CEFB9DC85CD7959BB129D194C
      45BC146D29718A6262136CE44B76B8AC4E883C2F932997C648E24E5CA4F993AC
      8B94099B62FAB896A6A4C9F05848345C443E4BA21ECF1C94A694D02A2388A49E
      A527992EEF91DD926620924DAD8C9C92918F2C7F57F369B33ACD6E977523D685
      B2024203A06C04E089A7A971A6698FB9C28E20C4C3D2449C61A2C193480F462C
      85BA138DF1CA3C50637853997512653497BB9D600B5B1ABA91BD67222B51D2BE
      A6EC8550BB40362F903545D4D391F2F5B06E2503449635CDA4915850999FB8F3
      2736D750A682B879746692190CA935A43E644208B6014DA2982A261E5A15AF83
      6C4EA2BE770C00D7F7E1D244DC091EB6FE91FB041978F2004A900F09CD5A5CE3
      D59DF763B3441ED008515C358ADCD8D05583DA15694747102F8F976912EC7391
      0751E4E83091FCE32183202F97EC3B90A518CF2A5D6D2AF5273155E79A0A8FDF
      42B2614D22373E21CA1C491FF46599C2861DBE8B629D10134D1989E264204412
      6ADD4E70758A325F7595B6A2F74C79EA8566BB44A1014F9E4CD55C2678A22F4F
      0A8997930ED92E0A4BAB060BC1660532CB645F189EBA4850893CD535155F229E
      2F214E737A1C358932927B4C330956B6B2B6934D78977C5996050AC786451339
      0903B2B1345F3176A578F49564D6BB63391E0790E522BB55B0CB9720652FFF56
      3DBCB22E579A4D71F8E2FEC3A46208266E598D4F559F2E523CB2730DCDF8642F
      0672AE612F92A4F7F05C44F55C13ACBF88696A8E28794042069AAC34A4711B3B
      D8D0344C724923C692A6ACD85D255F405C3F2CB64C89322C60C720B6CE649D28
      BB58151A9C7907B64888E6A793C5174913C16A428D3DB8C3B2EBB3449E02539D
      3B12CD2A312537A9ACC9B1FF891075AC55A7AB985391DEC546249ADD4A728622
      43D29C90487304823C479A7B52B2C5A561599DD8C81E00C9D38322082E8B7A9C
      AA8C7A26B6844C2D8620DD42B12388AE5FB1CDAF066388668899D8CB8327B932
      13CB2E01D9E852C747953F65FB0E71935D8DFDB0449E4369FE65C5A2C03260A2
      F816D1DCE7A6E66FC72E4B454608363E71CF285E698266C3C8B72CCF1824678E
      EC8C47DE1FA2DE0EB9802476532722C8983411233B9C85C279B27234E5911E79
      989DDBB83135A20F4044F1FFABEE7AE4EC300951948CE2A330D54007BE2B8AE1
      999ABF9FE0B01F32DD08F64139F69EA40CF1C44E57062651988810DDD0969C92
      9A678BA8514453731D7AEA6FD94C5266CE727B39BC87402357BBEC3D356563C9
      24AA5F1BC59D9491DEC32DA8B4009AB1A326401374CD634C4C1CC5767D614473
      A322CFBC2AE72882696AE2821C806AC280622FC96621868CABD4D8971C5995C6
      2D1C5353E6ACA6120243528D3C5184E0199CA9FC92BDF4D860C2115025AAE24E
      9988E2A2576C66C96328F9C264E386A83E087D5A85039F6E1369B16035CC8304
      86A0883C512C0AA287BE5DE9450261CA1113C98635912D4FA4A8029AC3BA4E6F
      E914C549861885988ABE209AF964A248A21AED404E3325B283C60A8760C936C2
      091A722A024A19313D5CE772AC9720F79C9ADAA3B887080E3C61E645A39F3C5C
      A21901B666247F84EAED256AB41C9999448E082B3E364918F1BC484D5450FCD6
      C46B92434CEC1037D55426641AD954393A8228A93028FF43355F11C3A1A0BFA9
      E433682E0A53B65DB5809D6A6F22358D8771D36BB044B11A134F4D4C5331B915
      E7031A5C90F357F5BF12254489B35F50A2000E5B10EC74507C441E51744D4748
      66064E5B922C3B1CD8C7D115E4FFC79131241404E71710E29977454C357CEAA5
      2B50785E3229E439A1A939F2B588A784164DD6B03463EB5F8D9F13E261409A4A
      FA00D1A30F44F64A98EA645F6232C9DE93AD502D0E6E6A0949A61AF791867685
      20E4AC56133D08F66B999AC74D1E0095FEC2D37F13CF09F1F41B69209C70276B
      600F9D843CF3EA8C9CE02C4953933AA2261768591E6A9A9DC21CE20E8A6D24E7
      20604F0B325EF1AC9860EF8D8982A228D14A72A029C61FD1B35A886CEE6B19A6
      D865234F7F71EC93E0E7AAA15739C9496D60641E2809720499117A9C5D1A3388
      16CF422DA5740D8E3F38142BBE3014A395ED0382AFD5B2F1BCB8504D72D1855E
      32A68996B883C67E1C1150FDB5269A96CBBE65257516BB26E42194988A030EF5
      13EE4EA2B8D7B05F1719AE8A4BD754123E4D3D37C4C4DE3FD3C47996EE4CC0F4
      0884E1790572C3A9C1332CB6B275478832C07AE4832A5E59C5FC456CABC4BC5C
      D192C627AC33916F434E0EC66A4C495390A71AD80B627A780D098EDCA3EC2624
      DB482A08F2C4209702417E23E4A2C15365EC2757DC92782AA1C480913D24FD2F
      676CA922AB849C95BC548997B0B74ECEFB96FB098F0E8A94E0E928C1568ED28C
      D8C2C4F91F28FE49B0694594A8A72CA4265E4D20CFDED40C0194E38B2704A62A
      004489111242D4BC742588ADCC804D13E79A233DA086CE500E134A9F31915354
      5D5B8169C2B97F6A2C9098AABF57CD867355819A07E02D80C4331101E79F69D9
      311E8B11B08A56ED082DC28D7D13DA1A0565B451636ED8E183277E7A1C46C950
      90D23CE4FC45BC32C5445105EB3FC9BF8786268FBC746419A8011739ED8C68BE
      1F3922805C2344CBA63295B9989AFF8BAD7EE9B62E53EAF9B004991B59D23F51
      7A9E3A8D357172B92C7A6A12AC9280ADF8B7702FE3A19778A4055965EEDC1DFB
      7970FC43D67892BCA188899AF2264FC714F6D5DC4A5AD809A5C12B19ACC424AA
      EF1BFF54F36109D1D3CBF01A067944C2C33BC13A16BBA24C35534EB34789CA73
      C8DED3D3753D96BF603BC23BD90C67F2AA9982921A954369F8A14AFA0E5E1644
      94E52A9EDE6582F21A55971891ED4A690D0ACFF12544718113A2A4DCE300A489
      67497A12B23A27249A674BC911F7323FE4AC4D2D35477DA6BE4E0D191EDAF4C5
      53B529D905C4637C5316CF99CA8A3B947B8B527F88E2AE22A66A52A99E699B70
      3937474D5E46C92672F8550FBC112C0E38842E272998DA9A0B9C4A2E2F405453
      3395144953E113E7A9C80FAB2EE5411E017DB842E2AE2750EA94E9E39D1A1326
      4AF22AB27295D58968A9A59C402CE7BAE9EA07CD59BCF235D0022E6CA7E28530
      5A32191EED088EF6A8B93FCA6208A2CCBE94D52F68CC5563686875AB92668196
      6E98B2249AB225ADADDF30957C1FB48C8AE04C1DA2D83268758B922129F5265A
      FF84F2EB89E209268A5BCF2352A00836F1E8139CC1AC787154B3C354D6179A6A
      C2A7E25F9273E6C96EC52BA00B384EB7411305220F2F44F1E7A32592448F6079
      C5AE89BA6CD5540C3E2D591FAF4341F2E4B56C585963833C1E8AB14534FFAAEC
      15539D19B29D453CC318445D4D8E132AF12A25492FE17E22440B3C124DC4D535
      3E289B0A8DADDA048AE8E93DA6DA66448915E85139D3D41324E4F9278A3F29AA
      D2C41133795DA96CB22B9145793E21F93E098A44A8EB62D02A22537D809CA349
      886A19CA0E2DB4AEC654D6F328AB86D01216396B8D78388214E34C9D2A1335EA
      8D5AD0D45C05A8B7F0F244BC68CD862DF553169319E5AEE1A57B0ACF994A9C5B
      71F7C92152A2267329C32B5127681EEBFBD4009EC394AE8EC06BE8514A9E96DF
      A6C896A737C3D4969CC91088B6E212E5F3298E4365D12631D5E54148534B6B85
      D4B926412BC23C4C51BC7280E0EEC379BCA677B6ADA9F88C90B81014B3D45695
      9AF23A2D6414E05C021CAA573497646313D5C444C38E92A0E2B19D81CCBEA6B2
      D655B56E91570ACFC4709E8F0314FBC24C352D5A89632227A3A29250C4CB5417
      A3E86B060832582577BD120D565355709EAEBC028AE0F149D97F435B4FA32C67
      56032988AB893A47567595B2941D4F5C89B64B0A0A4A29F9351E1BC098A6EADF
      C36B3EB56439EC3525C42B4665E23697E6446A662451B2F0E4C671FDB89A1546
      B0916CAAEE658926A2AE35552619A6B63851F10C281BA9686135ECF43371EA83
      B6B808C73D344DA527B43B3797D67479E461C9EE5D42B095AEAD96214AD0CA54
      AC40652184B6C05FD787729850DDAD01ADE6C7A99E922F4C8D322B1BC22829AD
      EAFA75DC17CA5C57CBD7204AB042DD508328E962CA261B28F0A3985472FE1E6E
      0353CDF1524D76E2910CE9B19C4D9E96AAEB4E94B81BC1691D281917AFDF57BC
      6DCA961872CEBC89D7B32AABF8D43D5D88EE1BC9D2C378A1235E022AAFFB40E9
      F6785E8C369A20CA841CDF15C509B5253FC4D45DE15AFA8F476A3E5182B2EAF2
      24BC204A4DE347A91D38B248F0295A1E8B4DBBE48735D505EBBADBCBF4580545
      B0CF43CD9641534BFC0C0F578249B48031767DA0B455653E48945C37B4BB064E
      8A43B16E350A840D5DDD5D8A5394D034581EFC499669A8472448D9FF450D2B99
      C86789E7D51E5E512D55DEC4B10553F1321375EF02D354BC214AE68FB27B0C32
      86B0D98912D151EA1A5E7BA7EDCEA3858F09C1EE076DB92DDAE44389D6CBA63A
      DEC10CADB1F3302E4D53C9235456B8A82BFA513FE11E410B2B949D12340FB6A9
      459088A6FE8847E81DB383BA2B801A42D4FC68044D0570FE1E566A2A97118F40
      913C3820BB56095F9BCA864444597FAF2CD7D3521CD5F93E51C6347D7C7479EF
      E8A38F3EE698A38F39F6D8638F3BF6B8E38E67C709279C70223B4E3AE9A46070
      FAC9D3A79F7C0A3D42A150381C3622F48846A3B1782C1E8F276A6B6B93C9E48C
      99A7CE9C796A2A953AEDB4D34E9F75FA1967CC9E3DFBCC33CF9C3B67EEBC7967
      9D75D6D9679F3D7FC1390BCE3D77E1C2858B162F5ABC64C992F3CE5BBAF4FC65
      CB962F5FBE62E5CA9517ACBA60F5EAD5756BD6AC597BE185EB2EBAE8A2FA8686
      86C6C6A6A6A6F5EB37D0A3A575E3C68D9B36B5B577B47776767675756DEEEEE9
      E949F7F6F66EE9DBD2DFBF75EBB68B2FBE58B2618FE2441D732CA7CA218A1344
      8FE9C1E9F438F9E49343364D86C1898AC5284D098BA699332849A79E4A499A35
      CBA569CE9C3973E7CEE314CD3FE79C731650A2CEA5342DA6349DB784D144895A
      C1685A4569A244D5D5319AD659443572A29A9B29512D2DADAD9B366E6A6B6B6F
      6FEFA0346DDEDCDDDDDD93A6476F9FA0891125C993208912C5FBE9B8E38FE3FD
      6411150CB28E6207EDA7B0E8278BA6B8D44D3366709252A959A7CD3AFD744AD3
      19AC9B3849ACA3284DF3394D0BCF651DC5FB69E9F9763FAD58B96A95E8A7BA35
      6B693F099AEA6D92184DADADB4A3044D763FD18E9268DAC66822324DBC9F2C9A
      8E3BDEA6E9449926C17C562F896EB2FA89B31EE53DCE7A94A659A29F184D7339
      51679D6DD174EE02C67B9CA6F304EF9DBF6CB9DD4F8C2497A67A8726DE4FAD2D
      1B793F51E663FD244862BCD7C768DA62F5933BE6CA345902658993254F54A038
      4DB49F42723FC51209D651C919942626509C264692C37B73E75AF224788FB11E
      A36989C37BE773DE5BB152F0DE1A469325500D4CA0EC7EDAC0FA6993C57B1D94
      F7BA6C9A443FF56FDBE6C97BC71E2BE4C9EEA71338459C262E4F8CA6B02D4F4C
      47F06E72FAC9A2E9B4D36609D63B63B6CC7BB4A7783F9DEBF6D3524193E8A755
      AB6C716224ADE33AA291F7D3FA66A622A840319AA8926817FD243ACAA649E808
      49971F7514D21176479D80794FC853C810FD14E58A2F2EFAC995A7D3784739FD
      C4889A37CF551282F72CBDB794EBBD65549C983C5D60E93D499E1A1B5CBDA7C8
      D3E6CD9B59375181B2F4DEB6AD5CEF7DD8E927A1F8EC6E123451924EA2447192
      443785848EB0E5897754C2D27B94262A4FA75AFD34CBE927479723795A64C9D3
      F95CEF519256D8F244695A4369BA681DE33D4E13653D5B476CD2E5299DA6DDB4
      650BA509EB082E4F47F37E7235B9ABF7A607836C7C3A59A888904B93D07B0E4D
      42EF39F244A99A23C9D3D996DE73E58993C4159F3B3EAD59A3E90841548B189F
      284D1D962E67FD44E5C9E927499E4C4BEF1DEDE87297A6934EB4E5E964AB9FB8
      DE0B475C7972689A69293EA6F7443F893117EB08419350E596DE13BA9CEB880B
      EA2C1DB14ED0D4D8E0A1CB3BDA513F3171623A82E9F24B247F844B933DE69E70
      BC2D4E5CA02C1571CA29CE881B89C6A282245B9E66CE9C39F35455EFD18E9AC7
      C65CC17B9C244AD4E2454B16BBBCC7E4890A141F72D7205D6ECB931873155D6E
      8D4FB68E10F2E4EA72AE238440D9D224EC0847970B3B82751427CA88462231B7
      9F6CBDC7998F8D4F9A2EB7596F81D07B8B1CBDB76C99D7F824CC88FA062C4F8C
      2647EF75093BA2376D8D4FDBB66EBBE46229BF9CEA08CB8E90D49EA5CB453709
      790A9D22EC0843B5F766701D61D911B66D7486634770557EB66547709216F37E
      3ADFA569E5AA558EDE5BBBCEA249F493651BB558F69EE827611B8941778BE8A7
      6D9EBADC3523B80D7BC2498E6D641B124C9EDCF149D611DCDE13E3D369C28E10
      E3D39C79763F51DEB389B2C7A7F35D3B62159727797CAA17636E53B3C57B8E2E
      E734D9B691B02304EF5D42B0DE1376B9CB7C82F74E9275B94B5344B2616B259A
      B80D6BD97B563F715DCEE4498CB9E7BA342DB16C23AECBB9DEBB40D87B6B9D31
      B741B28D249A2C3BA2DBB223B6B8F69ECB7B47B986C4718E363FF104611BC944
      8574DE73E4698665F071BD27DB7B687C12738DC5CE5C8376D30A57972379AAAF
      17930DBB9F38EF6D12BABCD3B5F73C788FE9F2A31CC35CE872C72E77697275B9
      343E49730D363E5963EE2C61C30ABB7C2EB6CB996DB448D611627CB2ED08A6F7
      D638B6913B3E71E3C81A9F2C9224BD276892E64F9CF71C3BC216A813846D7492
      6C47087B8F8FB9864353822973C736B2EC72C17BB31DDE9B7736EAA7858B25BD
      276CD8952BDDE993ADCB1DBDC7ED3D777CE23475091DE18C4F8226B43E97680E
      2E251986A81B31128F6DEAF00A73253F176F78E1919AEA95158D528F94F429A2
      ED942EE77C28EB20F17625CAB219E21175440BCAD545C4720E95828FA8B94578
      5F3EA26FBFA8F8F155F7B3D34F7BD421FA09ED524BB2EC2A8FB6DE50FCBF3861
      4859F2A12EBC9733FC758E206A76B41AA8F25A6E2387BE4C93BF03693FFE0AA5
      3F1D245E21D207E2154AF5F4731E7F5BD23EBC3C4DEB1F9F2A3E07A1978E64F8
      FF90C9883FEC3F5644FF61AF9801D8CDFF87DDBBC51FF61F2BA2FF648A78C5C9
      D096C20E7ECD6041C7807F8D7F8D7F8D7F8D7F8D7F8D7F8D7F8D7F8D7F8D7F8D
      7F8D7F8D7F8D7F4D99AE29D01FC3AE192CF0C8704F47DF54ECE9080B1F86E3E9
      80A9A5F77464A3E20D7E7A9175C323D4EDF2A27FC8AFDB23EABCFC5CFD79F08B
      A783CCBACE5330FDBA3DA2CEEB18CE835F3C95A85FB737D795611C1B69B42EB6
      6EA4E7658B147495098B5FE7D7F9757B56DD9C2CC7E97E9D5FE751377BE191EF
      1273C8F83E62D67903FD7C90CF3A03BCFCCF07BBB34E5AE81C6CF6C866972C94
      5D3329002FBEF00A5CB0623D3D65124C3DE010F8DB5FFE01D77EF27A587CCE0A
      F8C3EF7642BAB30F3634B6C08A452BE97C761FB870F58570EC31C7C2AF7FF96B
      B8E9C69BE0E2EE6DD0DEB0096EBDFE66F8FD4BBF85377EFF3AFCEC473F81BFFC
      7E271CB0FF64B870E92A685ED7004F3EF2287CE3ABF7C1EBBF7F0D6A26EE03DB
      DABBE1CE9B6F877BEFB80B7EF4E40FE0A9C71E07F39B0FC36F7EF12BB8FF9E7B
      E1A74F3D0D175DB01A363535C3B599CB21DDBA111EB9FF7ED8D2DB0BBD3D3D70
      D9F6ED70E92597C0E0C0005C79C515F0E2733F861BAFBE0ABEF0D9DBE19C3367
      430DA5F988C3DE0B87EC3709B6A67B605FFAFBC04913E0B507BE00F56BD7C0EF
      5EFC357C759101E9158BE0E9CE657073FB3AF8E57D77C1A60B57C36DA77F005E
      EC590CEBA247C3F6B30CF859FF4AF84EFB62782CBD0A9ECB34C1DD1B97C195FD
      69B863CEE170D739C7C0E5A923E1EBCBC270ED5927C28D4B1370E7DAD9F0CC96
      65F0D0C58DF0C34FF4C2551B56C16D0B8E8507564E87CF2F9D0E677CE81D70C4
      41FBC32D4BA6C37FAE8CC30FDAE7C0F3DDF3E12BEB4E85475A66C3A6D4F170EB
      AA9970F7860570E5D253E19B7D2BE16B9B97C1B56BE7C12BB75C0CADE79C0AF7
      5DDE0ECDC183E0967987C3E2E0FBE0FBBD0B61E7635F85C30F980891C30E8407
      BB16C0DA55CBE1D2FE5E98659C0017CC3C06A2C71C0613693B6CEDDE043B7EFD
      73F8E6430FC2EA150B61DA0113E0074F3E06EF3CB8066AF603F8DDAB2FC13557
      7F04D6AE59069326012C58700EAC58B11C5E7FFD4FF0DA6B7F80EF7EF751F8FA
      D7BF065FFECA5DF0B39F3F0B1735AC86471F7B189E7EE609B8E9E621F8D071EF
      86279E7E146EFCF475F08B5FFE1C26EC0B50B76E35FCF1CFAFC1F2D5CB00260A
      9E9C409FBB5F603F38F45D87C2DDF7DC0DB77FEE76B860F505F0D22B3BE08147
      BE01CFFEE4C7D0BDB51702071F0840FBF1F537FF0AEB5B36C075375C0F0F7DFB
      61F8E8B5D7004C9A085FBAEF6BF08B975E80C79FFD21244E9D09A79E35179E7F
      E537F09E0F7E00BEF09D4760795D1DDC78FBEDF0E8934FC2E7EFBD17BAD36938
      6FE95268EFE880C6A626587BE185F0C0830FC2C34F3E053F79E555E8BDE452B8
      FDAEBBE1D99FFD1C5E7DF39F70E03B0F85C68D6DB0EDCA01D8D4B70D328357C1
      E00D9F81E99138BCF8BBD7605D7D035CF729CAFF7F7C1D9E7CE639A85BB316FE
      FEAF7F43EBA6CDB0ED922BE0CEBBBE0CF7DCFB00FCE18F6F424FFA62B8F5B63B
      29F1FBC37DF73F421B82D206FBC2B265ABE1F4D3CF80C71FFF3E1062C2F0F030
      BCF9E69BF0EAABAFC2CB2FBF0C2FBDF412BCF0C20BF0FCF3CFC333CF3C034F3D
      F5143CF6D863F0C8238FC0BD94A63BEEB8036EB9E516B8FAEAABA1AFAF0FD294
      C6CD9B37C3C68D1B61E2C4895CF6778EE131011DD9EB77BE3D413DB56C25CACF
      ACF53BDF8E63AC3BCB57A262CA569FED5E6FF3432F618556897B8A8CE0ED6230
      89BBE21A716BF6AF83C0B93F2AE17F47C2E481B2484C1C0EBF5B0198BC7A4A6B
      5D8469A274E4C6B453EB2987E882307995BC9D1B53167E52DADCEA981260727B
      7302381D9717266F8E2E0126A9372740C46EA47C3069FCE4725456B92B9C9F28
      26AEACF3C2A4CB9D2B5605611A59EE583B0183955FDF79DEFD6D8CB2308ECE82
      89B754B198CAA0C7F36F2774F07B95A944E327B5DEC1A41C3BCB57A2CA9D569F
      D56228A3AD0211EBE03A73045B652CDBC939466EA709B85799A095AB44195BF4
      7A07136ABEB810FEF294A898B4FA11314966082AE185A2443A4546F0F68898A4
      CECB85C955E33602F7F67289281C09934289D64E3693234C36A5B89D9CE12E7F
      4C9E3DE5E0CC82C9EEBD7C30ED54EEE55A4F8561F22A791B61123A332F4C3BBD
      B86767293049BDC9DB898F2D11C883C7D5762A1926B93745DFC1C4FC30A9FC24
      715436B92B969FF26D274DEE246D5010A65C72E7CD4FF9E9271D53E11C9DBFDC
      E58BA93C7ADC9923E4C0848FB77796AF441D5BB4FAF1B055F2F4ABCC5E189F35
      01E5256DA53FEF99E0E6253D7ADA8492E7250D56F191292203CCC7EFE3DFB3F0
      6FCF9528395CA253CA84BF3FD769C3A33BC54AEEA84CFC2293AF7FA45304F081
      CAC42F505535FE409EF8AFCC16DE2D1F7EC61BB9F067A062F1B32CF0815CF801
      02558D3F1FFE0F542C7E4BB7E766B10AC59F97883316AB50FCF9E87FFE98AAE6
      7F5FFF14879FC96615EBFFAA1F7F4B6AFF5424FE3CF4BF38655765E22FE09472
      E1CFB9014D7F694E29177E7FFEEEE3DF9BF18F99BBA33CF807BCD5C5B06B3F54
      387ECF96E6A503960D37827554604FCDC9798C1DFE2D4538A62A09FFF66AC73F
      58B863CAC7EFE3AF22FCDCB2AC5EFC231F3E7E1F7F49F0E7BDF1C8B08FDFC7EF
      E31F23FCB9E66505E1DF41C7C1B7C614FFC040D6795931F8BB760F8F317ECFF2
      3D12FF8E1DCFED60C7941D3BAA14FF2E0A7DC7CB5D3B76BCB5433A5ED6F08FE1
      FCBD10FC2F0F52E83B8607A6E46AFFDCBB8317D24525C33F3C48A1BF3C48A9D8
      E5E5A170F1EFCAE5E5ED1A0FFC1439854E6B06A6EC9A2635BA8E3F27078D0B7E
      3ED799C61FEFE31F67FC68A7FE2AC42F0BE3F6EAC39F43FFFBF875FCDE3AB948
      FC39C6AF316B7F8ADF13C7AE5CED6FCB2E35289EB3BFD39E1807FCDE03E4600E
      FC766F5283E265FB9A29E381BF80F9978CDFBE4E181416A82AC4CF403BCA604A
      15E2A7A05D5455889F8276B5F1B42AC4FF968B7FA80ADB7FC8E57F4A4A95E0CF
      B8F8DF72F10F55B8FEE1239B309C1DFC7452FCB244CA8E2E08BC95CDA7246F0F
      391EF82593E72D1BC85B92F9C3C65F3A8C8DE5FC7D4B79FC873E7E1D7F2E3B2D
      2B7E27772FEF875947C07295E00584ACA218FCB9ECB46C47FE670A8176EF1DD8
      255C25AEE5DE256A03D2EC3993BBCBC6347FC90D240F048685AA94C6EA215151
      E39E9EE1915B1FBF8FDFC7EFE3AF64FCB95FE219A868FCB95F283A4EF83379E2
      CFF5E881D2E3CFE8F8031A7EDAEF958A9F4253F06740C54FE1552A7E064DC14F
      A5AC58FECF13BF9760E72FEC6594DF3CF17B09B6D7FB823DCCF18AC03FEC51E1
      5106FD9E6DEFE3F7F1FBF87DFC3EFEBD14BF3B9A052C57A7E4F614B5811A37F6
      9DC9BDB8634CF1E77514E6D1AA3CFC45F8DF7CFCF9E15766A9832598A18EADFC
      2A7962386D41F67CE6EDA91E27FDA92A4F4573E6549B3EFE0AC39F337052D9F8
      F33D7CFC3E7E1F7FF9F1672A1DBFE2FC543C9F39DD9EE38E5F717E2A9ECF9C6E
      4F8CBF86FBC732DBB9D5316DA41D074A855F757E2A9ECF02F9BF86DF9BCFD686
      AD1F5525BFF4C200C3CFA5A6263398A93AFC19D1FE01DEFE8140D5E10F08FC19
      8E3F33E8B7BFCFFF7B93FEE1393C19B18B55CD483B0E54267EE10DC8082780F8
      B187DA6F5E13338F32F0CEE61A7FFC057865B45581EA2CF50DA53524CF67FE7B
      DA6434CEC9942ADBA1E0A31877969BBF1718144EA5C152653B8CC9C1F10F0907
      C93067CAA1C11245DBC7147F80E1E7938A213A7E65C3EFC9D7F9C7DF3359A3F7
      5E37C92B1FD4C29F11ED1FE0ED1F0864C33FE0B5DAD52B263FCD33F376205BF4
      DEEB265D03596F25E5855AF803027F86E3CF64E51F8F71B9CB734CA8F11C3A86
      B28D1E5E37D1E3490E0A29AE5458FB572CFE3CF9BF72F1E7A77F2A153FCB360F
      F0E1B04B0C92D5853FEFC3C7EFE3DF03F1E7ED7FAB54FCF9CE7F7DFC65C22FFC
      3F81C100C30F81AAC31F10FE1FE17FAB3EFCDC65E5F8DFAAB0FD8BE4FF80C7A3
      335E0FCD8C803F931D7F202BFE4C29F0B3F72E688F06AF878A7890377E251423
      E157A232327E3BC05498FF6D487518E88F669115EDA1563CC813BF1A8A91F07B
      44652CFC4E80A930FF9B6F3FF8F83DF0E7ED7FABD4F697FD6F0323F8DFFCF9AF
      8FDF133F045CFF4F35FA4F04FE4CA65AFD57023FB59FABD47FE8CBEF78FBDF76
      CBFEB75DBEFFCDC7EFE3DFF3F07BED36E41593AFF17A3F98D7E581AC37D1D7F3
      3847C6BE61D9F61F28E10600234726FDF7675526FE322CB51953FC65586A33B6
      F8475292C5A5EA940FFF80AEEBAA0ABFF6FCF1C2BF6BA497FD5401FEE13C5E05
      EA857FA87F978FDFC7EFE3F7F1EFD1F833396CEA8A6F7F65CF9DAAC33F2CCF1A
      7537938FDFC79F137FC08E5A5727FE8C853F60E197664655811F2CFC60E1772F
      1EC80F7F4656BE638E3FE3E00F14897F5056BE55D8FE83B2F08FF1FCC583FFAB
      0DBFAA7F4A80DF2357BF0C4B6DB2E87F798BBE22F18FD62919180D7EF9C8CF97
      34CC13A74685BFC8C3EAD55D01FB6F9156B623FCE3E4FF0C287F0BC50FB6F2E5
      F8736F7E5B59DECF61E17473F0E7DEFCB6F45BE18E729686E4B7C0ADA9067CFC
      7B0AFE2CDB0E550DFE016FAA725C252BDF71C62FC7411C3598279E4AC33FE4BC
      48A240FBBF68FCB977CD2A08BF6D2C0E0D4E1B3130A5DAFF45E31FC8299F45E2
      AF19D1B02D99FC0E4CCBD1FC3E7E1F7F05E257EDB7AA6B7F6C3F9719FF95D95F
      CE5D2C7E3C7FA93EFC78FE5885F8077DFC3EFE3D0DBF93B897037FC9ECFFD2E2
      97ACBE9A7C1C7B9580DFD33F333498BFA7669CF17BFA67B61700667CF18FFEF0
      F1FBF8AB0E7FBEAF16CDC33F302EF8FB47185673BBB7907F605CF077E1DDA02C
      5D3F3CF2F4C6FBFEE332FFC2F82DBF5560789AEA33AA12FCD65D876B549F51D5
      E0CFD8F83315883F17FF0FD931F91AFEA50AF18B3D0B28FE8CB518B0DADABFA2
      F93F277E2BA63F5CA35A9FD5817FD0D6FF9ACD5F25ED5FE1FA7F8FE7FFEAD73F
      55AEFFAB7EFCF5F5FF78EA7F7BFEE26E145DE9F83DB38A2A75FEA2E3F74E2BAA
      1EFC45A517F8F84B36FF9A33D27176A0CAF1D7B8FB5D57277EC71D5419F88734
      6DEFE3F7F1FBF847C21FA86EFC2C3FA39AF183D8DEB35AF1DB8B5A7CF9F5F1FB
      F87DFCA5C63FF251E3EC97559DF8DD1756951D7FAE954A45E11FC3F963AE954A
      DBBDF1EFCEEF283BFE628FFCD6580F552CFEAE1141B9CC579DF8079C6524D589
      DF82C3F00772C857A5E39F9603898F7F4CF1BB9B378AD7CED9F87717768C1BFE
      01E7B57201F186B9A1F159BF9C137FC61BFFF0A0B5ADA958805EB9F85910BE00
      FCC3A561F8AEC1A13CCEC9033F0B037BE2CF007FAD07C3CFF60A2F08FFD0D8E1
      E75910D9F1B3FDD9F95EED958A3F9BFC0AFC7C7F7CBE577ED5E11F0DFFFBF847
      8D5FACCED86D6F805175F8B3D80F95865FFCA95AFCD69999DCF6FFAEF1C29FD7
      362543F9F807C6057F7EDB946CCFC73F302EF84B78F8F87DFCA3C69F6BC38BC1
      0AC79FC3A1375CF1F8F373E75537FEDCBBD405F23B67BCF0E77453E4794EE9F1
      E7351CF60F8EFDB13D57730CE7A33F0B717A97F6C8F9CCBD09BF70DC65C67207
      BB92E2178EBB81B1DCC1AEA4F8C5C47968700C77802B07FE81DDBBAB1BFFE050
      E5E1CFE9331FAE6CFC798C5E158DBFDAF9C7C7EFE3F7F1E7877FCBF6AAC65F94
      FD3050DC04264FFC79457DFB85E37DA4D7A38E803FFF597411F8CB7F14893FF7
      B05AD9F84B3A7FAF76FCD7EC18E1F895DBD755825FB84ADEB2FEFCCA51620315
      8C7FF76E0E9DFF11BAE12DEB4F55E0A7CA9B21177F78106BF82DEB4F35E0FF25
      1D2806DFDA61FD71F0BFE1E2DF5ED9F8A731A43BAC3F0E7E985625F839E2210A
      FC8D69FC8FC0FF0640C1F8F349BE2D237E8A58C23F0DA61588DF898B0E6BC71B
      56CDB4B1C3BFFB0D2814BF93A2AA1DF630326DCCF88765FC168ADF4E7118F638
      C4F9D3C64E7E77EF7EA358FC1EED5F4EFC409B9AE2177FBCF47F65B7FF8E2D00
      5BE8F825FEF02486C05BD69FC2F167B2B57FA66CF8776CD9C2ED07FE47C8D935
      E24F11F8215BFBF337539507FF48F66781F83390B5FDA13CF8734DE50AC30FD9
      DB9FEDA653F1F8ABBDFDC79EFF4B8C7FCCF54F89F18FB9FE2F03FE311D7F4B89
      DF4A91F4687E2BB3B0B2F1DB0FF7687FEBA86CFCA5CBB6282BFE5D0E982AF0BF
      79E01F76DCB07B38FE8CF36DA87CF3DF12E20FA828B6DBA0BBCA37FF2D21FE1A
      65C7ED4CBF5DD95FBEF96F29F1E37A197F258D5F15853FD776EB05E20F8C35FE
      7E0FBCA3C00F2AFE8C8E3FF7C2CC02E25FCAA289E1D1E20F28F8C5D6A5FDD6CB
      8DA6E5374E8F237EC0F8ADAD63FBE5F9D740AEC0EE40E5B43FF3C208FCE0CC7F
      2B1A7F36F9152F57AB78FCF9E89F4AC63FE8E3AF20FC4EE8B84AF02B932CF795
      ACFDF2FCB762F183B6D5B03ACA5736FE11AC14DB0D51A5F8B7CB8E888AC51FA8
      F2F6AFC9F6C6A32A69FF1A6F13BC7ADA3F2BFEEA69FFCC58B77F8EEDD60BC50F
      63DCFEB9B65B2F107F06C6B8FD4BEC7F80B16EFFFCF1DBD64CB5B6BF9D5D5259
      FC9F3F7E3B3A5401FA6720CF2DB186117EEEB719EEAA00FD3F907FE34BF8F955
      C5E12FAAFD77658DE28C39FEA2DA3FEB6965C39F35C85554FB971C3F07D755CC
      FCAB22DA3FA7FE29F1FCABD4F8ADE8F498CDBF4A8CBFF0F9A3CB4F95D0FE85E3
      7746EC8A68FFDCF68F7A38125311ED9FDBFEC98EBF3AF54F65B5FF68F0FBEDBF
      37B7FF6095B7FFA0DFFEC5B47FF669D5407E5BCD314BD8D9D4CFB57FDCD9D9C0
      88ABF346DBFEE37E8CB2FD2B087F31ED9FC9B99562004A724A76FC36C715D5FE
      4339D93B00B937E51E0D7EEBC814D7FE3973020702902B1F7328302D57237405
      F2E0A4A2DABF34F8733AB0032335BCE2E516F1C781BCF2672A00BF937F88F2F7
      72B67FC5E02F327FC0C7EFE3DF43F03BF96385E45F55107E377FAF80FCB74AE2
      1F277FB280FCC34AC2EFE6AF067CF9F5F1FBF8AB09BF9B7F5850FE5EC5E077F3
      0FAD12813FD7A4A952F04B2D2AAF5FCB337FBE92F0177AF8F8AB037FCE37398C
      27FE92384772BD2B70F71BE5C29FC76965F65F8D0EFFEC856FEF239E10A79FE3
      E9E73DF47330FD4CE0DF009EA2F58F4F159F321CBFDDBD7B94FFFBF7F1EFE3DF
      676FBB4F498ED90B6F3A447CEBB3B4DF46FA59C3B59F508B471CE26ABF83D0B5
      1911BCC864C41FF61F2BA2FF3CFAE8A3B46437FF9FED17C5FFB0FF5811FD674B
      3107BD877F9D7F9D7F9D7F9D7F9D7F9D7F9D7F9D7F9D7F9D7F9D7F9D7F9D7F9D
      7F9D7F9D7F9D7F9D7F5DF55F57B762EED2F3E72F5EB476CAE4BEE6EE5478CAE4
      9E4DAD1D1DF5EDCDA995AD1DC955E2777D6FBAA5B33B75465B7B73536B7D5373
      DF94C9A2A8B9BDBEB52DD5D3DBD5D5D99D3EBDBEAD9DD69DDCD8D96ED7F776B7
      A5E8834E966BD80DE997F6E68E744F6ACAE4BA25F3CF5CB67CE9DCF32984AED6
      C6746F77738ADEB5E3E486F6AE2993E9B31BD3AD7DCD728D5D26CE68AFEFD944
      6F834EEB69ECECED48A7E2532687525D5BC479E1147D626F6BBAB9BD47141829
      F9369154636747BABBB3CDAA8DA65AAC0B63A9F6A6D6860DE247DDBCC54B17CE
      5F346F3145DBD6BC3E9DEEA4A4B7B267058DD894C9DDAD1B5ADC322364048DA8
      38B1A19396B7DBE786C371EB64B9DC0845454D635B2B6D9DEEE6C6742A1234E8
      FF21764972CAE4860D1685AD1D4DCDFDA9E9B4BF3838541A134FECA1374837B6
      A442D693A4DF14A1FD8BDE414090AAADAFCDEBD733046E417A6B5773AA27BDBE
      B7ADCD7AAE76A65C8A4FA7DDC408AAEF6EAE4F4583114A6932110CC729512DAD
      E974734F1A35672C18752AD446A557A38BE426640D98C057E2168E88166EE8A5
      851D3DBC894341FE1F6DF6FAAE746B67072F8C07698F8658D33B2777AE5FDFD3
      CCA9B40A5A3BD8E339D9942D197B757576F5D2FFF8399DDD4DCDDD5B5A9BD22D
      2983CB031517DA3FDDAD1D1B6C0E6E6DAFDFD0CC4EB60BAC866C6DDED05DBFB5
      A7B1BEAD79CAE4F59DDDEDEDAD1DE24EA289D3F50D94B8FA8E9E2EDA9C1D0841
      437DB75253B764F192E54B56CE5F3467F14ACAB55B2893746E410C1312DDA3B1
      96D2231A7F278D604CE7EE443011F560EE643898A0677301B4383B124C468389
      5ACA5F8D54F0DADAEBBB3735773776B65155531B35C2B150145789361227840A
      61F250B14C5E77F6FC45CB466ABA683E4D17610C8B9B2E9C64655EDCEBA91782
      E108D20A54AF040D23188E31F6E848737D7D46776B7D9BF8DDD2CC6E910A47C5
      CF9EF4D6B6E694F83EA6AD77FE82F98BCE5C7CEEE2A54CB93736A43BD6D73736
      A7C2463C6218B1B8284A37F7F31B348AD64D85E38944C260945925CE092D1462
      1B27AC36525B1B0FD5CA65FC2CE95A7A67F77C5CDED352CF1EE4B01887B978F6
      3973CF5CC671F2B183357828B570EEA2E5F397CD5D38C31E3BD83862A989F00C
      EB0B1B4A1ADB3A7B9A855A98D1936E12DFD8A8D25EDFAF17475354A0F5E2588A
      F17A6F975E134F49F2CD70CC507E4F999C48F56CEDE125DAD5B529EB4C7C8674
      0BFBCCA47DA64C8FC779E1907DA24B9FD76961E734875EAFD38C14D5595B75E0
      7576FBAF652A9DF68A32CE0B79B38C162618548FDA9642C82DA51A9E8A50B436
      180DD93790AA684D92AB795B09A33A3E30B4777677D1E76F48D9DFE9194DA9F6
      4D5DBD3D2D42A53169B2C6877048147189B2CB28EB35B5F6B552F56FDD399660
      8F8D1B4EB97207FB6CE9264C2A2997F31BC482E160848E6574F8E48308C65BAC
      4E10F4BB45AEDCF4763477D437B43537B995AE8A567581D3906A854594565EDF
      4189487B34FCFA6E4A851048F734CA08CDDD7DF56D29B9D3441D954676626F8F
      185A1DC2F02F69F075CFB0EEA30E9EB6B08FC881D373B3603418A54C16A35ADB
      930539B585336053F3FAFADEB6B4C4189427E873E8809128800DD6F73474B635
      C9CCE0F67C769EA8A7CA9589723A95AE67DCBBB1B727DDBA7E2B1D5AF82342D6
      17A5D97199A58B9D6FCAC94A216707DC32163CBD821739CD828B255973EE8A05
      ADEC2CCA46487EA9E03257DDDA8C76262BF2E436C393D924164C852913841341
      B7FB4AC16B42D9D1EE709E11670F8970B9EE61CA81DFAB079BD474A2574F2F6F
      6C6F14F4D0C9193384F123AD4281C8B3CA79AC5A61D3812BEB9C61C96ECE85F5
      FDADEDADDB8A6DD1086DCD602C52DE26650F89B3A7E4DBA6ED0E5172B352DB92
      0E0E318EB580966597C5D97591DCAD6B8FE64EEBD259F9285A37C686B344B8BC
      ADCB1E12674FC9BB751DA2C6B6756523D06EE0A5B46C795791CD9B6083426DB2
      BCCDCB1E12674FC9B779059963A81190C13C4A8B32128CC783514AAFDEA49160
      2DAF0A876225B3290DDDA43464C5411F269EC99C50CEA0C76689D17061A6400E
      8B30249E8A0A906D78A633B2977B04AD43B319BB3FCFDFDA431BEA085651A4B4
      24F9E8192AF3F09914E36728FF01D42277EC04C663CE38A2D41839A5A64C4DEB
      58C1D5D7BA1E865F916D5B169B4F6FD90A37FB14A7C468DB541AEBCBDAA8B271
      50BCE137060DAB1A7E45366C790C3EBD614B64F395B1615DC7976A4B2FEB5C46
      EB8A9D011ACCE60B4792E5E75D831B7EEC51853672BA33CD291CA3A616DEE845
      CB962E3ED7F5F3C6C3CCCF6BB91E1D87642ADDD9D9A6141ABCB0ABBEA3B96D06
      FF97070D5B9A1B373574F6CFE05FBAEB9B5A3B997B977F518B63A90DF5BD1B9A
      67F07F994F17DD2B916AAB6FA03FF9BFCC674BDB86DEBABE7B86FD85B967FBD0
      2DC2A1548BC769E1706A43776BD30CF68FF0AED637CCA01FFA3D926A6E6A4DCF
      60FFD05FD1547B737BE70CF60FFD154BF589680BBB9BF38D56C4532DDE151473
      6B4F9AD169FDA565B529DAD10D8278EB0B2D4D8A96B24F977FD0960DA57ABA5A
      3B3832FB0B2D655474D289103DDF6A23C348F5A49B443BD95F68698496D6A77B
      7B183CFBCCA85526DAD83E9392D8DBC5F86686F8438B28716A51C2E207A9A98C
      5ADBEDAF516C24EDAA11488C849C93F4D6898465F7BEEC21A775861D986655EE
      575A1349517EA762A4F069244AFBB1AB8D4540696F595F68718CF6A247713CD5
      D0996EF1EEE0086D89D60D3ADBD7DAC5EAA3935C46E41883F3958A45C8A915BC
      EA714AD8BEF3886719F2595E27508E1054D07676BED1F22867D8BED6E62D33EC
      2FB4344665ADB99997DA5F6869DCE2202471D144AABB95762DE30CFB0B2DAD4D
      35F78B26B2FED2B264AAA78D79BB67883F54FEA99E69EEA3E7F07FE9EFB0F504
      89CF6286CDCB2A07C66C2EF7109598CDED1ECC158BF15697EF1497D49B5C9EE0
      E55EF7AFE5355E774F5A4CA831493C24D5287C52E78C7868588B6409A6A2E129
      9E0C1A7125C04ACDDEA81A618D4778D0540DB18A71428DB08A01CA8DAF326F7D
      5C38EB9538298E8BAA51D3E2E2A4E59C9C5BE37193C785AEB110650D6B8444CB
      B25BB8AE2356C3C67656B3BEB39131AB6E2DD80F29C28E188557A0A7A5730B87
      C42C1F26FE224B607D5BBDE2F377EBB2957BD90B6EAD6E68B87552BCC869DE3A
      97E50B6671DA1586511BA4ED6EC4A25A0A4638A4E518458361A3583667291846
      626F61733A0D604D1B0E8545DB22460FB35C2D561B31446DC5327BA802999DEB
      FC8279DD08C6E82C3012AC8DE88C6EA88C1E1B2DA3C76B8346724C18DD234B4F
      4E2D7363975200B5B1B983DB632309893182907073D32315A0B7235B0DEBD26C
      71D3528652E92CA4AB4BE546AB5089B6EBA52E9BD933AD22B82CCA836A7195CB
      8C605265B26822585B2C8F192C424807CB78452B53DE43B9D4EB48D91E8A52A5
      DAB296B56E3426F320CFF20C33D321C9C30F8C79789911663189046F258531C3
      B4AE96296036CC191E9CCBDCB9EC04232C4EB0D201B3B0B7A8CDCEFE0E8D394F
      C87E0F96A599FD0602C1C8E7E41C32EA6C5782CFF77B28DF27239CAB5954C493
      ED1349569F8CEC4D4CCF67DB05737C2C163484028926B4145C8DE713C29C2E8E
      E959B485764CB8764C98BEABBB73039D4CF758ECE53CDA2ED738B2A179436B87
      1B286EEE68727F50D32FDDDA48CDCA51240ADA0F56C66F8F62ED128976279CAB
      1BC44E15378AB9F0F6A04BD2ADCCD0B02D64E9FE23DC543B45B9B956AF3DC4A9
      911B582E775B9AD92CC599C5B483A9E64EC6E97C24963B933C190E7A2C31A12C
      12CF92841FD718D9CAC2F72DE3EAB48CB973BB602E8B84D8A0130B46981E3454
      5703E508CDA1160E268BB7110CE64F0B272ADA46A8B34328858B2C73DBD0F68C
      B1368D684BC334E7246F1FB52999D727CFB66441CDC898B465B600216F2A61DA
      B87884CF4BB4086517D622897830526BDF46A98F86787D2C240D4A61FB2E8A00
      68856EAFF515672D84934986D008B33EAB55FA2CA92B5ACF3E4B0613893CCD05
      FA9C44727CCC05EBD1C85C08276A79072563BC2E2F8B21EC5B0C65B6185A8A56
      4106CF014C243C94793C18D78CDFD0E89439CFF6AC200564E191140C3391433C
      21356C843D14104B1163CB6A436171826C1617AA8158A0BDA86096B0165AFBE9
      5CA9B9AD4DB4AE110A4662512A9BB5746C66CB6BA825D198C6F58998A84FC62C
      47B55B9D14974762D6E5CEDD713AA9FB509C53EA94A32CD2789C8FDDFA6D3CEE
      802E66DA279EE0EB94DA5A3BD8C26CABCD1A36A8CB493C6CC362958D6832AF35
      2BBCB13C2B18DDDAF3EC42F9A17699B274C62E76ED4EDA0E1A873BCDABF3BE1C
      CDAA4BD737143B6F60F11C2A0AF40EB65E30A2BC0FA28E17C3AE13DA825F168E
      DAAD635786A3495ECB074856DBDEC9D65575D8F56E620F560DC9081F133DBA53
      89D96A4A897274DC6BB5BCE77AE2DA443011E6644A1C1913744B0C294A7A1A36
      08A1A7269A11A497861386A850BBA1BAE2600A3B879C4EC26E2D9ED862E7B928
      ACC6BF88C6E28965D2EFADEC771D4B012898179959C7142CB58F0C6D6A11D66C
      2B66888C2AB813098D952F26DB78546CAFEA914BC5E588CE960630C5E5E655C3
      BADBABDCF1F27955D6B174B0C2954F98A5C9D2BEAD3598C6C86D8150FBDF63F3
      80583056EBD1E5B1643096D0237A54AF85F7904E0F8D5777EB03B1F500ADBCCE
      4D0F2CDC3AAD0DB10D3592B57C6C50A65A4628AFB95682AA94FCE65A4CBF07ED
      F48932B3866B87CA0FB6D76F5988986024F8F4DEF2D07765EB3F5463502161F3
      683A4EB36653FAD7CEF84FD877CDD6FFAC5CA963774EF01B1BB4EFD22DBDED96
      B5100F05D9984FF5B7BB58DEAD46B7F428E64562F008A722E8B7E1FC56EC6AB5
      CC617E5ED1C33BD5ED025ED8DEDAC132CB52B5EEEFAEFA0D3CDB8C2FB5DFD0B6
      B5ABC5332EA157304A3C8A7991EA8453CADC0940CB2824C34830773E138DA42A
      1A6CE30F4D36F8B85A74DC82AF638D8E95274E120EE9C188C759194B7772D938
      5FE1A04603E7D628F769975238E89DA306BF73ACD6978E514B8795053D063645
      C87B43A298978F8E4E9063312F2F757C6CD2E1F8824EE1880C7332F9442BE1F8
      2A707DC2AA4FDA263BAE4E8A6A83ED1F947BEDA875129AA51B71EE4129FDD621
      59A7DC9E911FAB508521154B68A4521B945424CD7FB2DB51792A9B9C3656C14A
      C6A598273665BD65D66A76BFAC95AEA9C65BB14F4AEA6FC1552D52155E09C0AB
      7191EAA6B013C18B18F5D89221366FA3E21D8B6953442D5A1F8B8F62D4639305
      3A850827C775B2E048AC61502C116A0ED732FD6668022F4D2F6441E76D16AB15
      97319F4871821E8B8D6ADFB0ACE23CF2F4858D9C749CE6B67EDE3318A396511C
      A75C62088A479CC958C30C27CA5978C3F79BD3BC7076BBE6F0C2C96B784A3C7A
      C5F21DBDA80D92F46071367DAEF5472FE1A8F4872F7FF82A62F8625C2416683A
      33061146CA9E7A6A88F87EB6D4D5B8A8AEB3974E15372E3235C916476BF3C1A8
      D7029038DF34B2F8501E0F0257A517CD6B6148766F2A9E3C26A949108DF0A62B
      6CD6996043111B8469BBD7EAF34E36B487F99D93C5CC3CD9DD6BE3E2EEC9280F
      2D8A25B045E4F72482711E294CE8A19770D2C31D1B4E7AFA636379CE9DE86C3B
      1E77B28DC73791CCCE378A159E4A16CD3F954C15FB9C6AA3CA12CBEC25D62AEF
      F16DA7F38C6D976E3C0E87E3B50295B5D6BB089188B104894882E9D190965AA9
      AF396261EFC8A872DE124123EC6756566B66A5B4854011CC16B7F22B139EF995
      B51AB319C5A7E4C4DC1C8D4ACEAFB4365F28BC2D6361BE197B84C95344F516B8
      4D3472FC28BFA674A793E56F48CDE6088B594CC141223794A3191BFC96C18851
      6490480A3FD5B514D97D0635AB99616B44299F468D3DB3FB682387683317D17F
      23C63134AE283E8E51E7EEF8507817B2AE630BA7936C7DBA91CFBC6414EA8CAF
      4B8FEC75191D0653E368EA908F8F2C497B3864042361DA33ECCA91933BF02E36
      45CD2AB8DF3611F5989F8A1D33B4D41EC3637E1AA13C9FA75B2B5CEB4765C6C7
      AD156572582B162D96DBB1158B046927CB3B2CE7A93FC394EB583FB094D8A826
      1E54FFD139AC21DDB61005CAEF1C36C49D556F5584F22ADF5F355694B38B0906
      BD7BA456DC7DAC2236FA5655255602518F7C1E23E1A904A2DED95EF108F779FB
      4A4070F7786B013BBF32E16B813D440B7838BE63A5717C2B9BDC95382E1CF14A
      878A8FCECEDC2BE3C286575C38BA17C485B1F93BCAF0B0B451631109B1493E27
      8EB0BDD5A2E8C5684690BFAC8871A5B4617D4A7BE393B477B4C76B9BE8C5F666
      BDDA4B9818B87EA5CE2EA018E51DBF3D5F1D6525F6316F9E32C171CA9577B5E9
      EF0862ECA7BE6BC7D9DD72946B5F14A56178BCB82EE23525F15E336FA86BE6F9
      2A97315B33EFCA799029083652B03C680F876F0BF3652A8154BD8895D84988E8
      A761F78B94A2E8FE34EC9FF974A552E4B0017B9887FFD5D3F92A6F6E5AE26DF4
      621ECE0ACFC50861AFD40BB6622AA96D17C9FC5BFE3E7A55B48F5EA56D1AE96C
      DA5BF858C2C64F6648D6525D170B69DB3DE5B7943DE2CDEDE3E9602D5118A7A5
      F8968D09A5CBA7169178EE96A513BD4835B8AE4BD4B2789651ECDA8748389EEF
      DA8750F1FB94F94B1FFCA50F63BEF441DE3EBD703F1B354B8C24958F38FD44E3
      BA9F4DDB57261A7636C72E6ED3EB28CB8AF21316AA3561016DCB5F30BFD5C6F8
      32B4B011A3D3523DB6A3278DB1B7B8D78E6AD9367BEBCDDEB1C7BA61356EDC6A
      5C6C35C7452D7B432CAFF5779F2E60F769F47EB2425313E8B0C6DC065116BC8F
      E4B155011B5947956F1B4E068DC85EC1F3061B8E58E3B21730D9C929D2ACC5E0
      B5CC89C76B7D9ECF8FE7A5D7A2A82F93D25F9C5294444498B28A32DD1CD64781
      70C925829AFA7B8D442444E3D2993A6F5C2C11B5515E1BE15B40857D89285622
      8C08CBC58A735BB8CEFB8542C58D1431764FA6B6F4158B612DA1331271E69AC5
      5B47F1BD432EE211DEB81116C6658D8BE482F907782D7F8543CC978B62E52292
      A457C5E8709BC47251EC7C21CABB856F12A64984D8ED555FAB543BAA9122B9B7
      48049F2FB0C68D7B4944382E24C208C57D89288DEDE4BC26AE94FB75536BDF23
      CDDF33F6188D7B6742B15DFB2A69BFEE3AFBC579E3B02AC8634F2AFB857D9581
      467A63E0182C1819CD960851B13A698C9CE1684762F6665A3A92FB2F30A8FCED
      88ED575C56867459EFD62C5CB28291683248FF8F78ADA8D65F8613F2B4DBA3DC
      33AE095634CCCB71B26A9CAAED60746C2C15366CB548BB4EC439B53C898E5906
      ACBACF7D454A981A50064B9489B05DBF59A5E49C8E8812D9376D1551E0B84060
      C5657D6AD668D4102FE66408D5BA30AB46494CF6FA69B1B331F387A26A2F4340
      AA762C01AA4422A110CB938930F5D8C2D14A3630BF3F5B91C4EE2FD57ADD5FAA
      76EFCF6F4F6F10615E8F16EB9DD37825107B8411B71F219FE1FD14F90CF7CDDA
      31FE24E6106084F42984B09662C6048B4E1BA8DAEB197D1E942839B37DDEA4B0
      F96EDC7E462E52FABC49515268BDD9A4684DC19FD5E3B95D778FF7BA4EFE46DE
      E277EC7674139DB752A32FCEBAB0B7CDB261C3313649A1D39F5AFE720D5AE7C6
      43C33CE011E1E99A1116BAED73AF63B63CAB33980433E1EC93AE63F76475CC3E
      88D3C6686EB2A29AB457B81EEA918240ECF5C2A3D0D86DACC955E5DBA4E7FAD5
      B96F2F2EF1DB473CDE50168F8CC2D819DBD78FECF93B04ABAFA82E3C3D2F180D
      8583093A741AFA3AFC84C7DBE94697E21DDAEBBA5EACA3107A35EFDE8F51ABA0
      96EFE21149C6F3E381A237BA4908160847BD7820EAF986C2D1C97FF532C128B6
      B989599A2F59F02E37CC779DCCBACB0D5B4A13B2556A11BBDCB0B5BD0969971B
      FCF6FA225EBF24B8C9087B7153DC23912C1A1F2D3B85C77B79B2BBCA2C1AA3D4
      1BFC553ED1706DDECB469805CE1A8DAA89285BFCA32C1B09E9CB46421ECB46D8
      5C233EE6CB4662F65B496A0B5A3642950853724CF1242263BE9D2073B717FB36
      05D6CCEC6D0A1E8127CDC568C446B557269B76048D906F2B95C45672F3B18ADE
      7881BFA98C6FBC10CBE75D1A622D62F1BD6F44F6BADEA7121363B98F8651BE9D
      1718238C725FC0A8B52F60321F25101DD52B55986BA05AD96074FB0272466062
      55F27D01F98E83EECBC846B52F20E3A651AEB20D5BAB6CF5C4627D27B4D86876
      9964DC144B8ED54E68792CB3152F8916AB482363BDFD72623CECA5782818E5CB
      6C8D2ADA7E59AC002C3E7F3ECA721DD876D7217DC3223D753EE2BD04306A7839
      FD0DCB798DE6042CC890F093E7AB31799EEF2F9964B9E812D795238D3EA12F3E
      65EFABF7E2BC8817E7B1B04E58E33C16EC48EC8179318AF9B60764D3577272CC
      FF03ED9CA788}
  end
  object bsBusinessSkinForm1: TbsBusinessSkinForm
    ShowMDIScrollBars = True
    WindowState = wsNormal
    QuickButtons = <>
    QuickButtonsShowHint = False
    QuickButtonsShowDivider = True
    ClientInActiveEffect = False
    ClientInActiveEffectType = bsieSemiTransparent
    DisableSystemMenu = False
    AlwaysResize = False
    PositionInMonitor = bspDefault
    UseFormCursorInNCArea = False
    MaxMenuItemsInWindow = 0
    ClientWidth = 0
    ClientHeight = 0
    HideCaptionButtons = False
    AlwaysShowInTray = False
    LogoBitMapTransparent = False
    AlwaysMinimizeToTray = False
    UseSkinFontInMenu = True
    UseSkinFontInCaption = True
    UseSkinSizeInMenu = True
    ShowIcon = True
    MaximizeOnFullScreen = False
    AlphaBlend = False
    AlphaBlendAnimation = False
    AlphaBlendValue = 200
    ShowObjectHint = False
    MenusAlphaBlend = False
    MenusAlphaBlendAnimation = False
    MenusAlphaBlendValue = 200
    DefCaptionFont.Charset = DEFAULT_CHARSET
    DefCaptionFont.Color = clBtnText
    DefCaptionFont.Height = 14
    DefCaptionFont.Name = 'Arial'
    DefCaptionFont.Style = [fsBold]
    DefInActiveCaptionFont.Charset = DEFAULT_CHARSET
    DefInActiveCaptionFont.Color = clBtnShadow
    DefInActiveCaptionFont.Height = 14
    DefInActiveCaptionFont.Name = 'Arial'
    DefInActiveCaptionFont.Style = [fsBold]
    DefMenuItemHeight = 20
    DefMenuItemFont.Charset = DEFAULT_CHARSET
    DefMenuItemFont.Color = clWindowText
    DefMenuItemFont.Height = 14
    DefMenuItemFont.Name = 'Arial'
    DefMenuItemFont.Style = []
    UseDefaultSysMenu = True
    SkinData = bsSkinData1
    MenusSkinData = bsSkinData1
    MinHeight = 0
    MinWidth = 0
    MaxHeight = 0
    MaxWidth = 0
    Magnetic = False
    MagneticSize = 5
    BorderIcons = [biSystemMenu, biMinimize, biMaximize]
    Left = 588
    Top = 235
  end
  object InputDialog: TbsSkinInputDialog
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    SkinData = bsSkinData1
    CtrlSkinData = bsSkinData1
    ButtonSkinDataName = 'button'
    LabelSkinDataName = 'stdlabel'
    EditSkinDataName = 'edit'
    DefaultLabelFont.Charset = DEFAULT_CHARSET
    DefaultLabelFont.Color = clWindowText
    DefaultLabelFont.Height = 14
    DefaultLabelFont.Name = 'Arial'
    DefaultLabelFont.Style = []
    DefaultButtonFont.Charset = DEFAULT_CHARSET
    DefaultButtonFont.Color = clWindowText
    DefaultButtonFont.Height = 14
    DefaultButtonFont.Name = 'Arial'
    DefaultButtonFont.Style = []
    DefaultEditFont.Charset = DEFAULT_CHARSET
    DefaultEditFont.Color = clWindowText
    DefaultEditFont.Height = 14
    DefaultEditFont.Name = 'Arial'
    DefaultEditFont.Style = []
    UseSkinFont = True
    Left = 620
    Top = 13
  end
  object bsSkinPopupMenu1: TbsSkinPopupMenu
    MenuAnimation = [maLeftToRight]
    OnPopup = bsSkinPopupMenu1Popup
    SkinData = bsSkinData1
    Left = 650
    Top = 425
    object N1: TMenuItem
      Caption = #28165#38500#25152#26377#22797#21046#21697
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #28165#38500#26412#26465#22797#21046#21697
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #28165#38500#26412#29289#21697#22797#21046#21697
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #28165#38500#21644#26412#21046#36896#32534#30721#30456#21516#22797#21046#21697
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Caption = #25335#36125#24080#21495
      OnClick = N6Click
    end
    object N7: TMenuItem
      Caption = #25335#36125#35282#33394#21517
      OnClick = N7Click
    end
    object N8: TMenuItem
      Caption = #25335#36125#29289#21697#21046#36896#32534#21495
      OnClick = N8Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Caption = #23548#20986#25968#25454#21040#25991#20214
      OnClick = bsSkinSpeedButton13Click
    end
  end
  object bsSkinMessage1: TbsSkinMessage
    ShowAgainFlag = False
    ShowAgainFlagValue = False
    AlphaBlend = False
    AlphaBlendAnimation = False
    AlphaBlendValue = 200
    SkinData = bsSkinData1
    CtrlSkinData = bsSkinData1
    ButtonSkinDataName = 'button'
    MessageLabelSkinDataName = 'stdlabel'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultButtonFont.Charset = DEFAULT_CHARSET
    DefaultButtonFont.Color = clWindowText
    DefaultButtonFont.Height = 14
    DefaultButtonFont.Name = 'Arial'
    DefaultButtonFont.Style = []
    UseSkinFont = True
    Left = 232
    Top = 16
  end
  object OpenDialog1: TRzOpenDialog
    Left = 633
    Top = 157
  end
  object SaveDialog: TRzSaveDialog
    Left = 625
    Top = 325
  end
end
