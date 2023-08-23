unit ClMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Menus, ExtCtrls, uSocket, CShare, frmClient, uConfig,
  ComCtrls;
type
  TfrmMain = class(TForm)
    plTop: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    LabSendDataSize: TLabel;
    LabSendMapsSize: TLabel;
    LabSendWavsSize: TLabel;
    LabWaitWavsSize: TLabel;
    LabWaitMapsSize: TLabel;
    LabWaitDataSize: TLabel;
    Label5: TLabel;
    meRunningLog: TMemo;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    O1: TMenuItem;
    G1: TMenuItem;
    H1: TMenuItem;
    Runtime: TTimer;
    Panel1: TPanel;
    StatusBar: TStatusBar;
    RunTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure G1Click(Sender: TObject);
    procedure RuntimeTimer(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);
  private
    { Private declarations }
    m_szRunningLogMsgList:TStringList;                                          //服务运行日志
  private
    procedure InitializeVariable;
    procedure UnitializeVariable;
    procedure InitializeResource;
    procedure UnitializeResource;
    procedure InitializeOpGateSrv;
    procedure UnitializeOpGateSrv;
    procedure InitializeUpdateSrv;
    procedure UnitializeUpdateSrv;
    procedure UnitializeThreadSrv;
    procedure InitializeProcess;
  public
    { Public declarations }
    procedure WriteRuntimesLog(szRuntimeLog: string);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses frmConfig, LooksFile;
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnitializeOpGateSrv;
  UnitializeUpdateSrv;
  UnitializeThreadSrv;
  UnitializeResource;
  UnitializeVariable;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //初始化随机种子
  Randomize;
  //初始内部变量
  InitializeVariable;
  //初始更新资源
  InitializeResource;
  //初始更新服务
  InitializeUpdateSrv;
  //初始网关服务
  InitializeOpGateSrv;
  //初始运行进程
  InitializeProcess;
end;

procedure TfrmMain.G1Click(Sender: TObject);
begin
  frmUpdateConfig.Open;
  frmUpdateConfig.Visible:= False;
end;

procedure TfrmMain.InitializeVariable;
begin
  m_szRunningLogMsgList:= TStringList.Create;
  g_vcClientReviceList:= TList.Create;
  frmUpdateClient:= TfrmUpdateClient.Create(Self);
  frmLooksFile:= TfrmLooksFile.Create(Self);
  g_vcConnections:= TList.Create;
  m2ConfigManage:= Tm2ConfigManage.Create;
  g_WMMainImages:= TStringList.Create;
  g_WMMapList:= TStringList.Create;
  g_WMWavList:= TStringList.Create;
  g_hEvent:= CreateEvent(nil, True, True, nil);
  frmUpdateClient.InitializeVariable;
  InitializeCriticalSection(g_csCriticalSection);
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
  frmLooksFile.Open;
  frmLooksFile.Visible:= False;
end;

procedure TfrmMain.RunTimerTimer(Sender: TObject);
var
  sUserCount:string;
begin
  sUserCount:= Format('终端数量:%d', [g_vcConnections.Count]);
  StatusBar.Panels[1].Text:= sUserCount;
end;

procedure TfrmMain.RuntimeTimer(Sender: TObject);
var
  szMsg:string;
begin
  //更新日志记录
  if m_szRunningLogMsgList.Count > 0 then begin
    szMsg:= m_szRunningLogMsgList[0];
    szMsg := Format('[%s]%s', [FormatDateTime('YYYY-MM-DD hh:nn:ss', Now()), szMsg]);
    m_szRunningLogMsgList.Delete(0);
    if meRunningLog.Lines.Count >= SHOWMSGMAX then begin
      meRunningLog.Lines.Delete(0);
    end;
    meRunningLog.Lines.Add(szMsg);
  end;
end;

procedure TfrmMain.UnitializeVariable;
var
  Index:Integer;
begin
  m2ConfigManage.SaveDBConfig;
  for Index := 0 to g_WMMainImages.Count - 1 do begin
    g_WMMainImages.Objects[Index].Free;
  end;
  for Index := 0 to g_WMMapList.Count - 1 do begin
    g_WMMapList.Objects[Index].Free;
  end;
  for Index := 0 to g_WMWavList.Count - 1 do begin
    g_WMWavList.Objects[Index].Free;
  end;
  frmUpdateClient.Free;
  m2ConfigManage.Free;
  frmLooksFile.Free;
  g_WMMapList.Free;
  g_WMWavList.Free;
  g_WMMainImages.Free;
  g_vcConnections.Free;
  g_vcClientReviceList.Free;
  m_szRunningLogMsgList.Free;
  CloseHandle(g_hEvent);
  DeleteCriticalSection(g_csCriticalSection);
end;

procedure TfrmMain.InitializeResource;
begin
  frmUpdateClient.InitializeResource;
end;

procedure TfrmMain.UnitializeResource;
begin
  frmUpdateClient.UnitializeResource;
end;

procedure TfrmMain.InitializeOpGateSrv;
begin

end;

procedure TfrmMain.UnitializeOpGateSrv;
begin

end;

procedure TfrmMain.InitializeUpdateSrv;
begin
  frmUpdateClient.InitializeUpdateSrv;
end;

procedure TfrmMain.UnitializeUpdateSrv;
begin
  frmUpdateClient.UnitializeVariable;
end;

procedure TfrmMain.UnitializeThreadSrv;
begin

end;

procedure TfrmMain.InitializeProcess;
begin
  frmUpdateClient.InitializeProcess;
end;

procedure TfrmMain.WriteRuntimesLog(szRuntimeLog: string);
begin
  m_szRunningLogMsgList.Add(szRuntimeLog);
end;

end.
