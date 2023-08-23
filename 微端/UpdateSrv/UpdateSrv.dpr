program UpdateSrv;

uses
  Forms,
  ClMain in 'ClMain.pas' {frmMain},
  frmClient in 'frmClient.pas' {frmUpdateClient},
  frmOpGate in 'frmOpGate.pas' {frmOpGateSrv},
  CShare in 'CShare.pas',
  frmConfig in 'frmConfig.pas' {frmUpdateConfig},
  Mir2Res in 'Mir2Res.pas',
  uConfig in 'uConfig.pas',
  LooksFile in 'LooksFile.pas' {frmLooksFile},
  GShare in '..\Common\GShare.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  EDcode in '..\Common\EDcode.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  MapUnit in 'MapUnit.pas',
  uSocket in '..\Component\JSocket\uSocket.pas',
  WavUnit in 'WavUnit.pas',
  SDK in 'SDK.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmOpGateSrv, frmOpGateSrv);
  Application.CreateForm(TfrmUpdateConfig, frmUpdateConfig);
  Application.Run;
end.
