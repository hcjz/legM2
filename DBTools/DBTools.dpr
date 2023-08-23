program DBTools;

uses
  Forms,
  DBTMain in 'DBTMain.pas' {Form1},
  IDDB in 'IDDB.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  MudUtil in 'MudUtil.pas',
  Share in 'Share.pas',
  HumDB in 'HumDB.pas',
  grobal2 in '..\Common\Grobal2.pas',
  ItmUnit in 'ItmUnit.pas',
  EditUserInfo in 'EditUserInfo.pas' {FrmUserInfoEdit},
  DESUnit in '..\Common\DESUnit.pas',
  EDcode in '..\Common\EDCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DB Tools ';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmUserInfoEdit, FrmUserInfoEdit);
  Application.Run;
end.
