program MirClient;

uses
  Forms,
  ClMain in 'ClMain.pas' {frmMain},
  WMFile in 'WMFile.pas',
  WIL in '..\Component\MyD3DX9\WIL\WIL.pas',
  wmM2Def in '..\Component\MyD3DX9\WIL\wmM2Def.pas',
  wmM2Zip in '..\Component\MyD3DX9\WIL\wmM2Zip.pas',
  Logo in 'Logo.pas',
  CShare in 'CShare.pas',
  IntroScn in 'IntroScn.pas',
  FState in 'FState.pas' {frmDlg},
  PlayScn in 'PlayScn.pas',
  MapUnit in 'MapUnit.pas',
  FindMapPath in 'FindMapPath.pas',
  SoundUtil in 'SoundUtil.pas',
  DirectXSound in '..\Component\MyD3DX9\Sound\DirectXSound.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  FUpdate in 'FUpdate.pas' {frmUpdate},
  uSocket in '..\Component\JSocket\uSocket.pas',
  HGEGUI in '..\Component\MyD3DX9\HGEGUI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDlg, frmDlg);
  Application.Run;
end.
