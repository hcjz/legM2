program CreateLoginTool;

uses
  Forms,
  MakePlugDLL in 'MakePlugDLL.pas' {frmMain},
  Grobal2 in '..\Common\Grobal2.pas',
  LocalDB in 'LocalDB.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  MD5 in '..\Common\MD5.pas',
  SecMan in 'SecMan.pas',
  SetBtnImage in 'SetBtnImage.pas' {FrmSetBtnImage},
  SkinConfig in 'SkinConfig.pas';

{$R *.res}
{$R UAC.res}
{$R PlugResData.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
