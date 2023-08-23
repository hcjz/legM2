program LoginTool;

uses
  Forms,
  SysUtils,
  Classes,
  Windows,
  LMain in 'LMain.pas' {FrmMain},
  LNewAccount in 'LNewAccount.pas' {frmNewAccount},
  LGetBackPassword in 'LGetBackPassword.pas' {frmGetBackPassword},
  LChgPassword in 'LChgPassword.pas' {frmChangePassword},
  SlectDir in 'SlectDir.pas' {FormSlectDir},
  LShare in 'LShare.pas',
  EDcode in '..\Common\EDcode.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  D7ScktComp in '..\Common\D7ScktComp.pas',
  MD5 in '..\Common\MD5.pas',
  MsgBox in 'MsgBox.pas' {FrmMessageBox},
  UpgradeModule in 'UpgradeModule.pas',
  SechThread in 'SechThread.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  PEUnit in 'PEUnit.pas',
  UnitBackForm in 'UnitBackForm.pas' {BackForm},
  SkinConfig in 'SkinConfig.pas';

{$R *.res}
{$R UAC.res}
{$R ClientBin\mir2.RES}




begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmGetBackPassword, frmGetBackPassword);
  Application.CreateForm(TfrmChangePassword, frmChangePassword);
  Application.CreateForm(TFrmMessageBox, FrmMessageBox);
  Application.CreateForm(TFormSlectDir, FormSlectDir);
  Application.CreateForm(TfrmNewAccount, frmNewAccount);
  Application.Run;
end.
