program Mir2;

uses          
  Forms,
  Windows,
  SysUtils,
  ClMain in 'ClMain.pas' {frmMain},
  DrawScrn in 'DrawScrn.pas',
  IntroScn in 'IntroScn.pas',
  PlayScn in 'PlayScn.pas',
  MapUnit in 'MapUnit.pas',
  FState in 'FState.pas' {FrmDlg},
  ClFunc in 'ClFunc.pas',
  cliUtil in 'cliUtil.pas',
  DWinCtl in 'HGE_Full\DWinCtl.pas',
  magiceff in 'magiceff.pas',
  SoundUtil in 'SoundUtil.pas',
  Actor in 'Actor.pas',
  HerbActor in 'HerbActor.pas',
  AxeMon in 'AxeMon.pas',
  clEvent in 'clEvent.pas',
  MShare in 'MShare.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  EDcode in '..\Common\EDcode.pas',
  MirEffect in 'MirEffect.pas',
  MaketSystem in 'MaketSystem.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  frmWebBroser in 'frmWebBroser.pas' {frmWebBrowser},
  HashList in '..\Common\HashList.pas',
  HumanActor in 'HumanActor.pas',
  HeroActor in 'HeroActor.pas',
  DxHint in 'DxHint.pas',
  StallSystem in '..\Common\StallSystem.pas',
  GList in '..\Common\GList.pas',
  DlgConfig in 'DlgConfig.pas' {frmDlgConfig},
  WIL in 'HGE_Full\WIL\WIL.pas',
  wmM2Def in 'HGE_Full\WIL\wmM2Def.pas',
  wmM2Wis in 'HGE_Full\WIL\wmM2Wis.pas',
  wmM2Zip in 'HGE_Full\WIL\wmM2Zip.pas',
  wmMyImage in 'HGE_Full\WIL\wmMyImage.pas',
  HGE in 'HGE_Full\HGE.pas',
  HGEBase in 'HGE_Full\HGEBase.pas',
  HGECanvas in 'HGE_Full\HGECanvas.pas',
  HGEFont in 'HGE_Full\HGEFont.pas',
  HGEFonts in 'HGE_Full\HGEFonts.pas',
  HGERect in 'HGE_Full\HGERect.pas',
  HGESprite in 'HGE_Full\HGESprite.pas',
  HGETextures in 'HGE_Full\HGETextures.pas',
  HGEUtils in 'HGE_Full\HGEUtils.pas',
  Wilpion in 'HGE_Full\Wilpion.pas',
  Vectors2px in 'HGE_Full\Vectors2px.pas',
  DirectXSound in 'HGE_Full\Sound\DirectXSound.pas',
  DirectXTypes in 'HGE_Full\Sound\DirectXTypes.pas',
  DirectXWave in 'HGE_Full\Sound\DirectXWave.pas',
  D3DX81mo in 'HGE_Full\DirectX\D3DX81mo.pas',
  DirectX in 'HGE_Full\DirectX\DirectX.pas',
  DLLLoader in 'HGE_Full\DirectX\DLLLoader.pas',
  DXCommon in 'HGE_Full\DirectX\DXCommon.pas',
  JEDIFile in 'HGE_Full\DirectX\JEDIFile.pas',
  NewFont in 'HGE_Full\NewFont.pas',
  GfxFont in 'HGE_Full\GfxFont.pas';

{$R *.RES}

begin
  Application.Initialize;
  //Application.Title := 'Legend Of Mir2';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TFrmDlg, FrmDlg);
  Application.CreateForm(TfrmWebBrowser, frmWebBrowser);
  Application.CreateForm(TfrmDlgConfig, frmDlgConfig);
  InitObj();
  Application.Run;
end.

