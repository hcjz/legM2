unit ClMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, ExtCtrls,
  Controls, Forms, Dialogs, DirectXD3D9, HGEBase, HGE, HGECanvas, HGEGUI, Logo, CShare, HGETextures,
  IntroScn, PlayScn, WMFile, FState, MapUnit, FindMapPath, HGESounds, SoundUtil, uSocket, FUpdate, Wil, HUtil32;

type
  TfrmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    m_boLoadLogoData:Boolean;
    m_boShowsLogo:Boolean;
    m_ProcOnIdleTimer:TTimer;
    m_dwLogosTime:LongWord;
    m_dwLogosIndex:LongWord;
    m_MainScene: TScene;
    m_vcUpdateSocket: array [0..MAXUPDATEGATE] of TClientSocket;
    m_ObjSurface: TDXRenderTargetTexture;                                       //对象纹理
    m_GuiSurface: TDXRenderTargetTexture;
  private
    { Private declarations }
    procedure ProcOnIdleTimerTimer(Sender: TObject);
    procedure MyDeviceNotifyEvent(Sender: TObject; Msg: Cardinal);
    procedure MyDeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
  private
    procedure DUpdateConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DUpdateDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DUpdateError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; szError: string);
    procedure DUpdateRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    procedure LoadLogoSurface;
    procedure InitializeLogo;
    procedure DrawGameLogo;
  private
    procedure MyUpdateImages(WMImages: TWMBaseImages; nIndex: Integer);
    procedure MyInitializeImages(WMImages: TWMBaseImages);
    procedure MyUpdateMap(sMap:string);
    procedure MyUpdateMapComplete(sMap:string);

    procedure MyUpdateWav(sWav:string; stScene:TSceneType; boBGM:Boolean);
    procedure MyUpdateWavComplete(sWav:string; stScene:TSceneType; boBGM:Boolean);
  public
    { Public declarations }
    procedure ProcOnIdle;
    procedure ExitGame;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean); overload;
    procedure ChangeGameScene(stScene: TSceneType);
  end;

var
  frmMain: TfrmMain;
  HGE              :IHGE = nil;
  Map: TMap;
  g_boFirstTime:Boolean = True;

implementation

{$R *.dfm}

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if g_boFirstTime then begin
    g_boFirstTime := FALSE;
    if not HGE.System_Initiate then begin
      HGE.System_Shutdown;
    end;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Index:Integer;
  pUpdateInfo:pTUpdateInfo;
begin
  g_gsStatus:= gsClose;
  m_vcUpdateSocket[0].Close;
  m_vcUpdateSocket[0].Free;
  m_vcUpdateSocket[1].Close;
  m_vcUpdateSocket[1].Free;
  m_ProcOnIdleTimer.Enabled:= False;
  Application.ProcessMessages;
  Sleep(20);
  for Index := 0 to g_vcUpdateDataStr.Count - 1 do begin
    pUpdateInfo:= g_vcUpdateDataStr.Items[Index];
    dispose(pUpdateInfo);
  end;
  if g_vcUpdateHeadStr.Count > 0 then begin
    for Index := 0 to g_vcUpdateHeadStr.Count - 1 do begin
      pUpdateInfo:= g_vcUpdateHeadStr.Items[Index];
      dispose(pUpdateInfo);
    end;
  end;
  for Index := 0 to g_vcUpdateWavStr.Count - 1 do begin
    pUpdateInfo:= g_vcUpdateWavStr.Items[Index];
    dispose(pUpdateInfo);
  end;

  g_vcUpdateWavStr.Clear;
  g_vcUpdateWavStr.Free;
  g_vcUpdateDataStr.Clear;
  g_vcUpdateDataStr.Free;
  g_vcUpdateHeadStr.Clear;
  g_vcUpdateHeadStr.Free;
  g_DXCanvas.Free;
  g_DWinMan.Free;
  g_LoginScene.Free;
  g_SelChrScene.Free;
  g_NoticeScene.Free;
  g_PlayScene.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
VAR
  sPath:string;
  nIndex: Integer;
  sServerAddr:string;
begin

  ClientWidth:= 800;
  ClientHeight:= 600;
  m_dwLogosTime:= 0;
  m_dwLogosIndex:= 0;
  frmDlg:= TfrmDlg.Create(Self);
  m_ProcOnIdleTimer:= TTimer.Create(Self);
  m_ProcOnIdleTimer.Enabled:= False;
  m_ProcOnIdleTimer.Interval:= 12;
  m_ProcOnIdleTimer.OnTimer:= ProcOnIdleTimerTimer;
  m_boShowsLogo:= False;
  g_SoundList := TStringList.Create;
  g_LoginScene:= TLoginScene.Create;
  g_SelChrScene:= TSelChrScene.Create;
  g_NoticeScene:= TNoticeScene.Create;
  g_DWinMan := TDWinManager.Create(Self);
  frmUpdate:=TfrmUpdate.Create(Self);
  g_PlayScene:= TPlayScene.Create;
  m_MainScene:= nil;
  Map := TMap.Create;
  g_LegendMap := TLegendMap.Create;
  g_vcUpdateDataStr:= TList.Create;
  g_vcUpdateHeadStr:= TList.Create;
  g_vcUpdateWavStr:= TList.Create;

  g_DXSound := TDXSound.Create(Self);
  g_DXSound.Initialize;
  If g_DXSound.Initialized Then Begin
    g_Sound := TSoundEngine.Create(g_DXSound.DSound);
  End;
  LoadSoundList('.\wav\sound.lst');
  g_boSound := True;
  g_boBGSound := True;

  sPath:= ExtractFilePath(ParamStr(0));
  if not DirectoryExists(sPath + 'data') then begin
    CreateDirectoryA(PAnsiChar(AnsiString(sPath+'data')), nil);
  end;
  if not DirectoryExists(sPath + 'map') then begin
    CreateDirectoryA(PAnsiChar(AnsiString(sPath+'map')), nil);
  end;
  if not DirectoryExists(sPath + 'wav') then begin
    CreateDirectoryA(PAnsiChar(AnsiString(sPath+'wav')), nil);
  end;

  QueryPerformanceFrequency(Int64(g_liStartTime));
  g_dbFrequency:= g_liStartTime.QuadPart / 1000;

  sServerAddr:= '127.0.0.1';              //103.37.44.49

  m_vcUpdateSocket[0]:= TClientSocket.Create(Self);
  m_vcUpdateSocket[0].Host:= sServerAddr;
  m_vcUpdateSocket[0].Port:= 8000;
  m_vcUpdateSocket[0].NoDelay:= True;
  m_vcUpdateSocket[0].Socket.nIndex:= 0;
  m_vcUpdateSocket[0].OnConnect:= DUpdateConnect;
  m_vcUpdateSocket[0].OnDisconnect:= DUpdateDisconnect;
  m_vcUpdateSocket[0].OnError:= DUpdateError;
  m_vcUpdateSocket[0].OnRead:= DUpdateRead;

  m_vcUpdateSocket[1]:= TClientSocket.Create(Self);
  m_vcUpdateSocket[1].Host:= sServerAddr;
  m_vcUpdateSocket[1].Port:= 8000;
  m_vcUpdateSocket[0].NoDelay:= True;
  m_vcUpdateSocket[1].Socket.nIndex:= 1;
  m_vcUpdateSocket[1].OnConnect:= DUpdateConnect;
  m_vcUpdateSocket[1].OnDisconnect:= DUpdateDisconnect;
  m_vcUpdateSocket[1].OnError:= DUpdateError;
  m_vcUpdateSocket[1].OnRead:= DUpdateRead;

  m_vcUpdateSocket[0].Active:= True;
  m_vcUpdateSocket[1].Active:= True;



  HGE := HGECreate(HGE_VERSION);
  HGE.System_SetState(HGE_SCREENBPP, 32);
  HGE.System_SetState(HGE_WINDOWED, true);
  HGE.System_SetState(HGE_FScreenWidth, ClientWidth);
  HGE.System_SetState(HGE_FScreenHeight, ClientHeight);
  HGE.System_SetState(HGE_HIDEMOUSE, False);
  HGE.System_SetState(HGE_HWNDPARENT, Handle);
  HGE.System_SetState(HGE_SHOWSPLASH, true);
  HGE.System_SetState(HGE_DONTSUSPEND, true);
  HGE.System_SetState(HGE_HARDWARE, True);
  HGE.System_SetState(HGE_TEXTUREFILTER, True);
  HGE.System_SetState(HGE_FPS, 60);
  HGE.System_SetState(HGE_INITIALIZE, MyDeviceInitialize);
  HGE.System_SetState(HGE_NOTIFYEVENT, MyDeviceNotifyEvent);
end;

procedure TfrmMain.LoadLogoSurface;
begin
  if not m_boLoadLogoData then begin
    CreateLogoSurface();
    m_boLoadLogoData:= True;
  end;
end;

procedure TfrmMain.InitializeLogo;
begin
  if m_boLoadLogoData and (not m_boShowsLogo) then begin
    DrawGameLogo;
    if (GetTickCount > m_dwLogosTime) and (m_dwLogosIndex < 400) then begin
      m_dwLogosTime := GetTickCount + 50;
      Inc(m_dwLogosIndex, 5);
    end;
    if (m_dwLogosIndex = 400)  then begin
      m_boShowsLogo:= True;
      ChangeGameScene(stLogin);
    end;
  end;
end;

procedure TfrmMain.ExitGame;
begin
  Close;
end;

procedure TfrmMain.ProcOnIdle;
var
  Done: Boolean;
begin
  AppOnIdle(Self, Done);
end;

procedure TfrmMain.AppOnIdle(Sender: TObject; var Done: Boolean);
var
  boCanDraw:Boolean;
begin
  Done := True;
  boCanDraw:= HGE.Gfx_CanBegin;
  if m_boShowsLogo and boCanDraw then begin
    if g_stMainScenes <> stPlayGame then begin
      if boCanDraw then begin
        HGE.Gfx_BeginScene(m_GuiSurface.Target);
        m_MainScene.PlayScene(m_GuiSurface);
        g_DWinMan.DirectPaint(m_GuiSurface);
        HGE.Gfx_EndScene;
      end;
    end else begin
      g_PlayScene.BeginScene;
       if g_PlayScene.CanDrawTileMap then begin
        HGE.Gfx_BeginScene(g_PlayScene.m_MapSurface.Target);
        HGE.Gfx_Clear(0);
        HGE.RenderBatch;
        g_PlayScene.DrawTileMap;
        HGE.Gfx_EndScene;
       end;

        HGE.Gfx_BeginScene(g_PlayScene.m_ObjSurface.Target);
        HGE.RenderBatch;
        g_PlayScene.DrawMapObj;
        HGE.Gfx_EndScene;

        HGE.Gfx_BeginScene(m_ObjSurface.Target);
        HGE.RenderBatch;
        g_DXCanvas.Draw(0, 0, g_PlayScene.m_ObjSurface.ClientRect, g_PlayScene.m_ObjSurface, True);
        g_PlayScene.PlayScene(m_ObjSurface);
        HGE.Gfx_EndScene;
        HGE.Gfx_BeginScene(m_GuiSurface.Target);
        HGE.RenderBatch;
        g_DXCanvas.Draw(0, 0, m_ObjSurface.ClientRect, m_ObjSurface, True);
        g_DWinMan.DirectPaint(m_GuiSurface);
        HGE.Gfx_EndScene;

    end;
    HGE.Gfx_BeginScene;
    g_DXCanvas.Draw(0, 0, m_GuiSurface.ClientRect, m_GuiSurface, True);
    HGE.Gfx_EndScene;
  end;
end;

procedure TfrmMain.ChangeGameScene(stScene: TSceneType);
begin
  try
    case stScene of
      stLogin: begin
        g_LoginScene.OpenScene;
        HGE.Gfx_Clear(0);
        m_MainScene := g_LoginScene;
      end;
      stSelectChr: begin
        m_MainScene.CloseScene;
        HGE.Gfx_Clear(0);
        g_SelChrScene.OpenScene;
        m_MainScene := g_SelChrScene;
      end;
      stNotice:begin
        m_MainScene.CloseScene;
        HGE.Gfx_Clear(0);
        g_NoticeScene.OpenScene;
        m_MainScene := g_NoticeScene;
      end;
      stPlayGame: begin
        m_MainScene.CloseScene;
        HGE.Gfx_Clear(0);
        g_PlayScene.OpenScene;
        m_MainScene := g_PlayScene;
      end;
    end;
    g_stMainScenes:= stScene;
  finally
  end;
end;


procedure TfrmMain.DrawGameLogo;
begin
  try
    if (g_LogoSurface <> nil) and (not m_boShowsLogo) and HGE.Gfx_CanBegin and (g_DXCanvas <> nil) then begin
      HGE.Gfx_BeginScene;
      HGE.Gfx_Clear($FF222222);
      if m_dwLogosIndex < 256 then begin
        g_DXCanvas.Draw((ClientWidth - g_LogoSurface.Width) div 2, (ClientHeight - g_LogoSurface.Height) div 2 - 20, g_LogoSurface.ClientRect, g_LogoSurface, True, cColor4($FFFFFF or (m_dwLogosIndex shl 24)));
      end else if m_dwLogosIndex < 400 then begin
        g_DXCanvas.Draw((ClientWidth - g_LogoSurface.Width) div 2, (ClientHeight - g_LogoSurface.Height) div 2 - 20, g_LogoSurface.ClientRect, g_LogoSurface, True);
      end;
      HGE.Gfx_EndScene;
    end;
  finally
  end;
end;

procedure TfrmMain.ProcOnIdleTimerTimer(Sender: TObject);
begin
  //初始绘制Logo
  InitializeLogo;
  //游戏场景绘制
  if m_boShowsLogo then
    ProcOnIdle;
end;

procedure TfrmMain.MyDeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
var
  nIndex:Integer;
begin
  m_ProcOnIdleTimer.Enabled:= True;
  LoadLogoSurface;
  LoadWMImagesLib;
  InitWMImagesLib('');

  //绑定资源更新回调函数
  for nIndex := Low(g_ClientImages) to High(g_ClientImages) do begin
    g_ClientImages[nIndex].OnUpdateImages := MyUpdateImages;
    g_ClientImages[nIndex].OnInitializeImages:= MyInitializeImages;
  end;
  //绑定地图更新回调函数
  g_LegendMap.OnUpdateMap:= MyUpdateMap;
  g_LegendMap.OnUpdateMapComplete:= MyUpdateMapComplete;

  g_fnOnUpdateWav:= MyUpdateWav;
  g_OnUpdateWavComplete:= MyUpdateWavComplete;


  g_DXCanvas:=TDXDrawCanvas.Create(nil);
  m_ObjSurface := TDXRenderTargetTexture.Create(g_DXCanvas);
  m_ObjSurface.Size := Point(ClientWidth, ClientHeight);
  m_ObjSurface.PatternSize := Point(ClientWidth, ClientHeight);
  m_ObjSurface.Format := D3DFMT_A1R5G5B5;
  m_ObjSurface.Active := True;

  m_GuiSurface := TDXRenderTargetTexture.Create(g_DXCanvas);
  m_GuiSurface.Size := Point(ClientWidth, ClientHeight);
  m_GuiSurface.PatternSize := Point(ClientWidth, ClientHeight);
  m_GuiSurface.Format := D3DFMT_A1R5G5B5;
  m_GuiSurface.Active := True;
  frmDlg.Initialize;
  while (g_gsStatus <> gsClose) do begin
    if m_boShowsLogo then
      break;
    Application.ProcessMessages;
    Sleep(25);
  end;
end;

procedure TfrmMain.MyDeviceNotifyEvent(Sender: TObject; Msg: Cardinal);
begin
  case Msg of
    msgDeviceLost:begin

    end;
  end;
end;

procedure TfrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if g_DWinMan.MouseDown(Button, Shift, x, y) then begin
    exit;
  end
end;

procedure TfrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if g_DWinMan.MouseMove(Shift, x, y) then begin
    exit;
  end;
end;

procedure TfrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if g_DWinMan.MouseUp(Button, Shift, x, y) then begin
    exit;
  end;
end;

procedure TfrmMain.DUpdateConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  frmUpdate.DUpdateConnect(Sender, Socket);
end;

procedure TfrmMain.DUpdateDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  frmUpdate.DUpdateDisconnect(Sender, Socket);
end;

procedure TfrmMain.DUpdateError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; szError: string);
begin
  Socket.close;
end;

procedure TfrmMain.DUpdateRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  frmUpdate.DUpdateRead(Sender, Socket);
end;

procedure TfrmMain.MyInitializeImages(WMImages: TWMBaseImages);
var
  szFileName, sMsg:string;
begin
  if WMImages <> nil then begin
    szFileName:= GetValidStr3(WMImages.FileName, sMsg, ['\']);
    if szFileName <> '' then begin
      frmUpdate.SendUpdateInitializeImages(LongWord(WMImages), szFileName);
    end;
  end;
end;

procedure TfrmMain.MyUpdateImages(WMImages: TWMBaseImages; nIndex: Integer);
var
  szFileName, sMsg:string;
begin
  if WMImages <> nil then begin
    szFileName:= GetValidStr3(WMImages.FileName, sMsg, ['\']);
    if szFileName <> '' then begin
      frmUpdate.SendUpdateImages(LongWord(WMImages), szFileName, nIndex);
    end;
  end;
end;

procedure TfrmMain.MyUpdateMap(sMap:string);
begin
  if sMap <> '' then begin
    frmUpdate.SendUpdateMap(sMap);
  end;
end;

procedure TfrmMain.MyUpdateMapComplete(sMap:string);
begin
  if sMap <> '' then begin
    //这里的g_wRx, g_wRy 替换成角色当前实际的坐标
    Map.LoadMap(sMap, g_wRx, g_wRy);
    //重新绘制地图
    g_PlayScene.ReDrawMap;
  end;
end;

procedure TfrmMain.MyUpdateWav(sWav:string; stScene:TSceneType; boBGM:Boolean);
begin
  if sWav <> '' then begin
    frmUpdate.SendUpdateWav(sWav, stScene, boBGM);
  end;
end;

procedure TfrmMain.MyUpdateWavComplete(sWav:string; stScene:TSceneType; boBGM:Boolean);
begin
  //更新后的声音文件所在的场景与当前场景一致时播放背景声音
  if (sWav <> '') and boBGM and (stScene = g_stMainScenes) then begin
    PlayBGM(sWav);
  end;
end;


end.
