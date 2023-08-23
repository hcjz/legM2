unit FState;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, WIL, HGEBase, HGE,
  HGEGUI, HGECanvas, HGETextures, WMFile, CShare, SoundUtil;

type
  TfrmDlg = class(TForm)
    DWinSelServer: TDWindow;
    DSelServerExit: TDButton;
    dbtnSelServer5: TDButton;
    dbtnSelServer1: TDButton;
    dbtnSelServer2: TDButton;
    dbtnSelServer6: TDButton;
    dbtnSelServer7: TDButton;
    dbtnSelServer3: TDButton;
    dbtnSelServer4: TDButton;
    dbtnSelServer8: TDButton;
    DBackground: TDWindow;
    DWinLogin: TDWindow;
    DEditAccounts: TDEdit;
    DEditPassword: TDEdit;
    DLoginSubmit: TDButton;
    DNewAccounts: TDButton;
    DLoginExit: TDButton;
    DLoginChgPw: TDButton;
    DSelectChr: TDWindow;
    DscExit: TDButton;
    DscCredits: TDButton;
    DscEraseChr: TDButton;
    DscStart: TDButton;
    DscNewChr: TDButton;
    DscSelect2: TDButton;
    DscSelect1: TDButton;
    DMsgDlgOk: TDButton;
    DMsgDlgCancel: TDButton;
    DMsgDlg: TDWindow;
    procedure DWinSelServerDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DSelServerExitDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure dbtnSelServer1DirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure dbtnSelServer1Click(Sender: TObject; X, Y: Integer);
    procedure DWinLoginDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DNewAccountsDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DLoginSubmitDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DLoginSubmitClick(Sender: TObject; X, Y: Integer);
    procedure DSelServerExitClick(Sender: TObject; X, Y: Integer);
    procedure DscSelect1DirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DscSelect1Click(Sender: TObject; X, Y: Integer);
    procedure DscStartClick(Sender: TObject; X, Y: Integer);
    procedure DMsgDlgDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DMsgDlgOkDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DMsgDlgOkClick(Sender: TObject; X, Y: Integer);
    procedure DSelServerExitClickSound(Sender: TObject;
      Clicksound: TClickSound);
    procedure dbtnSelServer1ClickSound(Sender: TObject;
      Clicksound: TClickSound);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Initialize;
    function  DMessageDlg (msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
  end;

var
  frmDlg: TfrmDlg;

implementation

uses
  IntroScn, ClMain;

{$R *.dfm}
procedure TfrmDlg.Initialize;
var
  ServerIndex: Integer;
  btnServerList: array[0..7] of TDButton;
begin
  g_DWinMan.ClearAll;
  DBackground.Left := 0;
  DBackground.Top := 0;
  DBackground.Width := 800;
  DBackground.Height := 600;
  DBackground.Background := True;
  g_DWinMan.AddDControl(DBackground, True);

  //选择服务器界面
  DWinSelServer.SetImgIndex(g_WMainImages, 256);
  DWinSelServer.Left :=  (800 - 308) div 2;
  DWinSelServer.Top :=  (600 - 450) div 2;
  DSelServerExit.SetImgIndex(g_WMain3Images, 234);
  DSelServerExit.Left := 245;
  DSelServerExit.Top := 31;
  DSelServerExit.Width:= 16;
  DSelServerExit.Height:= 23;

  g_LServerCount:= 2;
  g_CServiceInfos[0].szServiceName:= '雷霆';
  g_CServiceInfos[0].szServiceAddr:= '192.168.0.106';
  g_CServiceInfos[0].wdServicePort:= 7100;
  g_CServiceInfos[0].csServiceStatus:= csOpen;

  g_CServiceInfos[1].szServiceName:= '光芒';
  g_CServiceInfos[1].szServiceAddr:= '192.168.0.107';
  g_CServiceInfos[1].wdServicePort:= 7100;
  g_CServiceInfos[1].csServiceStatus:= csClose;

  btnServerList[0] := dbtnSelServer1;
  btnServerList[1] := dbtnSelServer2;
  btnServerList[2] := dbtnSelServer3;
  btnServerList[3] := dbtnSelServer4;
  btnServerList[4] := dbtnSelServer5;
  btnServerList[5] := dbtnSelServer6;
  btnServerList[6] := dbtnSelServer7;
  btnServerList[7] := dbtnSelServer8;
  for ServerIndex := 0 to g_LServerCount - 1 do begin
    btnServerList[ServerIndex].Left := 63;
    btnServerList[ServerIndex].Top := (214 - ((g_LServerCount - 1) * 42 div 2) + ServerIndex * 42);
    btnServerList[ServerIndex].Width:= 168;
    btnServerList[ServerIndex].Height:= 41;
    btnServerList[ServerIndex].SetImgIndex(g_WMain3Images, 2);
    btnServerList[ServerIndex].Caption := string(g_CServiceInfos[ServerIndex].szServiceName);
    btnServerList[ServerIndex].Visible := True;
  end;

  DWinLogin.SetImgIndex(g_WMain3Images, 732);
  DWinLogin.Left :=  (800 - 287) div 2;
  DWinLogin.Top := (600 - 341) div 2;

  DLoginExit.SetImgIndex(g_WMain3Images, 234);
  DLoginExit.Left := 255;
  DLoginExit.Top := 16;

  DNewAccounts.SetImgIndex(g_WMain3Images, 743);
  DNewAccounts.Left := 31;
  DNewAccounts.Top := 178;
  DNewAccounts.Width:= 100;
  DNewAccounts.Height:= 34;

  DLoginSubmit.SetImgIndex(g_WMain3Images, 10);
  DLoginSubmit.Left := 163;
  DLoginSubmit.Top := 177;
  DLoginSubmit.Width:= 100;
  DLoginSubmit.Height:= 34;

  //角色选择界面
  DSelectChr.Left := 0;
  DSelectChr.Top := 0;
  DSelectChr.Width := 800;
  DSelectChr.Height := 600;

  DscStart.SetImgIndex(g_WMain2Images, 481);
  DscStart.Left := 373;
  DscStart.Top := 452;
  DscStart.Width:= 68;
  DscStart.Height:= 30;

  DscSelect1.SetImgIndex(g_WMain2Images, 483);
  DscSelect1.Left := 133;
  DscSelect1.Top := 453;
  DscSelect1.Width:= 76;
  DscSelect1.Height:= 33;

  DscSelect2.SetImgIndex(g_WMain2Images, 484);
  DscSelect2.Left := 685;
  DscSelect2.Top := 454;
  DscSelect2.Width:= 76;
  DscSelect2.Height:= 32;

  DscNewChr.SetImgIndex(g_WMain2Images, 485);
  DscNewChr.Left := 348;
  DscNewChr.Top := 486;
  DscNewChr.Width:= 120;
  DscNewChr.Height:= 21;

  DscEraseChr.SetImgIndex(g_WMain2Images, 486);
  DscEraseChr.Left := 347;
  DscEraseChr.Top := 506;
  DscEraseChr.Width:= 120;
  DscEraseChr.Height:= 21;

  DscCredits.SetImgIndex(g_WMain2Images, 487);
  DscCredits.Left := 346;
  DscCredits.Top := 527;
  DscCredits.Width:= 120;
  DscCredits.Height:= 20;

  DscExit.SetImgIndex(g_WMain2Images, 488);
  DscExit.Left := 379;
  DscExit.Top := 547;
  DscExit.Width:= 56;
  DscExit.Height:= 20;
end;

procedure TfrmDlg.dbtnSelServer1Click(Sender: TObject; X, Y: Integer);
begin
  DWinSelServer.Visible:= False;
  DWinLogin.Visible:= True;
end;

procedure TfrmDlg.dbtnSelServer1ClickSound(Sender: TObject;
  Clicksound: TClickSound);
begin
  case Clicksound of
    csNorm: PlaySound(s_norm_button_click);
    csStone: PlaySound(s_rock_button_click);
    csGlass: PlaySound(s_glass_button_click);
  end;
end;

procedure TfrmDlg.dbtnSelServer1DirectPaint(Sender: TObject;
  dsurface: TDXTexture);
var
  d: TDXTexture;
  ax, ay:Integer;
begin
  with Sender as TDButton do begin
    if WLib <> nil then begin
      with g_DXCanvas do begin
        if Downed then begin
          d := WLib.Images[TDButton(Sender).FaceIndex + 1];
          if d <> nil then begin
            DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
          end;
        end else begin
          d := WLib.Images[TDButton(Sender).FaceIndex];
          if d <> nil then begin
            DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmDlg.DLoginSubmitClick(Sender: TObject; X, Y: Integer);
begin
  DWinLogin.Visible:= False;
  g_LoginScene.OpenLoginDoor;
end;

procedure TfrmDlg.DLoginSubmitDirectPaint(Sender: TObject;
  dsurface: TDXTexture);
var
  d: TDXTexture;
begin
  with Sender as TDButton do begin
    if WLib <> nil then begin
      if Downed then begin
        d := WLib.Images[TDButton(Sender).FaceIndex];
        if d <> nil then
          DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      end;
    end;
  end;
end;

function  TFrmDlg.DMessageDlg (msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
const
   XBase = 324;
var
  I: Integer;
   lx, ly: integer;
   d: TDXTexture;
begin
   lx := XBase;
   ly := 126;
   DMsgDlg.SetImgIndex (g_WMainImages, 380);
      DMsgDlg.Left := (800 - 256) div 2;
      DMsgDlg.Top := (600 - 359) div 2;
      DMsgDlg.Width:= 256;
      DMsgDlg.Height:= 359;

      lx := 90;
      ly := 305;

   DMsgDlg.Floating := TRUE;

   if (mbOk in DlgButtons) or (lx = XBase) then begin
      DMsgDlgOk.SetImgIndex(g_WMainImages, 361);
      DMsgDlgOk.Left := lx;
      DMsgDlgOk.Top := ly;
      DMsgDlgOk.Width:= 80;
      DMsgDlgOk.Height:= 34;
      DMsgDlgOk.Visible := TRUE;
   end;

   DMsgDlg.ShowModal;

   Result := mrOk;

   while TRUE do begin
      if not DMsgDlg.Visible then break;
      Application.ProcessMessages;

      if Application.Terminated then exit;
   end;
   Result := DMsgDlg.DialogResult;
end;

procedure TfrmDlg.DMsgDlgDirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
  ax, ay: integer;
begin
  with Sender as TDWindow do begin
    ax := SurfaceX(Left);
    ay := SurfaceY(Top);
    with TDModalWindow(Sender) do begin
      d:= WLib.Images[FaceIndex];
      if d <> nil then
        g_DXCanvas.Draw(ax, ay, d.ClientRect, d, True);
    end;
  end;
end;

procedure TfrmDlg.DMsgDlgOkClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DMsgDlgOk then DMsgDlg.DialogResult := mrOk;
  if (Sender = DMsgDlgCancel) then begin
    DMsgDlg.DialogResult := mrNo;
  end;
  DMsgDlg.Visible := FALSE;
end;

procedure TfrmDlg.DMsgDlgOkDirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
begin
  with Sender as TDButton do begin
    if WLib <> nil then begin
      with g_DXCanvas do begin
        if Downed then begin
          d := WLib.Images[TDButton(Sender).FaceIndex + 1];
          if d <> nil then
            DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end else begin
          d := WLib.Images[TDButton(Sender).FaceIndex];
          if d <> nil then
            DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end;
    end;
  end;
end;

procedure TfrmDlg.DNewAccountsDirectPaint(Sender: TObject;
  dsurface: TDXTexture);
var
  d: TDXTexture;
begin
  with Sender as TDButton do begin
    if WLib <> nil then begin
      if Downed then begin
        d := WLib.Images[TDButton(Sender).FaceIndex];
        if d <> nil then
          DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      end;
    end;
  end;
end;

procedure TfrmDlg.DscSelect1Click(Sender: TObject; X, Y: Integer);
begin
  if Sender = DscStart then
    g_SelChrScene.SelChrStartClick;
  if Sender = DscSelect1 then
    g_SelChrScene.SelChrSelect1Click;
  if Sender = DscSelect2 then
    g_SelChrScene.SelChrSelect2Click;
end;

procedure TfrmDlg.DscSelect1DirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
begin
  with Sender as TDButton do begin
    if WLib <> nil then begin
      if Downed then begin
        d:= nil;
        if Tag = 0 then
          d := g_WMainImages.Images[66]
        else if Tag = 1 then
          d := g_WMainImages.Images[67]
        else if Tag = 2 then
          d := g_WMain2Images.Images[482]
        else if Tag = 3 then
          d := g_WMainImages.Images[69]
        else if Tag = 4 then
          d := g_WMainImages.Images[70]
        else if Tag = 5 then
          d := g_WMain3Images.Images[405]
        else if Tag = 6 then
          d := g_WMainImages.Images[72];
        if d <> nil then begin
          DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end else if (MouseEntry = msIn) then begin
        d := WLib.Images[FaceIndex];
        if d <> nil then begin
          DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end;
    end;
  end;
end;

procedure TfrmDlg.DscStartClick(Sender: TObject; X, Y: Integer);
begin
  DSelectChr.Visible:= False;
  //模拟等待接受服务器发送游戏公告消息
  Sleep(200);
  frmMain.ChangeGameScene(stNotice);
  g_csConnectionStep:= cnsNotice;
  g_NoticeScene.OpenGameNoticeWin('');
end;

procedure TfrmDlg.DSelServerExitClick(Sender: TObject; X, Y: Integer);
begin
  if (Sender = DSelServerExit) or (Sender = DLoginExit)  or (Sender = DscExit) then
    frmMain.ExitGame;
end;

procedure TfrmDlg.DSelServerExitClickSound(Sender: TObject;
  Clicksound: TClickSound);
begin
  case Clicksound of
    csNorm: PlaySound(s_norm_button_click);
    csStone: PlaySound(s_rock_button_click);
    csGlass: PlaySound(s_glass_button_click);
  end;
end;

procedure TfrmDlg.DSelServerExitDirectPaint(Sender: TObject;
  dsurface: TDXTexture);
var
  d: TDXTexture;
begin
  with Sender as TDButton do begin
    if WLib <> nil then begin
      if Downed then begin
        d := WLib.Images[TDButton(Sender).FaceIndex];
        if d <> nil then
          DSurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      end;
    end;
  end;
end;

procedure TfrmDlg.DWinLoginDirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
  ax, ay: integer;
begin
  with Sender as TDWindow do begin
    ax := SurfaceX(Left);
    ay := SurfaceY(Top);

    d := WLib.Images[TDWindow(Sender).FaceIndex];
    if d <> nil then
      DSurface.Draw(ax, ay, d, True);
    //绘制默认关闭按钮
    d := g_WMain3Images.Images[233];
    if d <> nil then
      DSurface.Draw(ax + 255, ay + 16, d, True);
    //绘制帐号输入界面
    d := g_WMain3Images.Images[734];
    if d <> nil then
      DSurface.Draw(ax + 118, ay + 99, d, True);
    //绘制密码输入界面
    d := g_WMain3Images.Images[734];
    if d <> nil then
      DSurface.Draw(ax + 118, ay + 136, d, True);
    //绘制帐号提示界面
    d := g_WMain3Images.Images[740];
    if d <> nil then
      DSurface.Draw(ax + 25, ay + 101, d, True);
    //绘制帐号提示界面
    d := g_WMain3Images.Images[742];
    if d <> nil then
      DSurface.Draw(ax + 25, ay + 139, d, True);

    //绘制创建按钮界面
    d := g_WMain3Images.Images[743];
    if d <> nil then
      DSurface.Draw(ax + 31, ay + 178, d, True);

    //绘制登录按钮界面
    d := g_WMain3Images.Images[744];
    if d <> nil then
      DSurface.Draw(ax + 163, ay + 177, d, True);

    //绘制密保按钮界面
    d := g_WMain3Images.Images[745];
    if d <> nil then
      DSurface.Draw(ax + 31, ay + 220, d, True);

    //绘制密保按钮界面
    d := g_WMain3Images.Images[746];
    if d <> nil then
      DSurface.Draw(ax + 163, ay + 220, d, True);
    //绘制密保按钮界面
    d := g_WMain3Images.Images[747];
    if d <> nil then
      DSurface.Draw(ax + 32, ay + 264, d, True);
    //绘制密保按钮界面
    d := g_WMain3Images.Images[748];
    if d <> nil then
      DSurface.Draw(ax + 163, ay + 263, d, True);
  end;
end;

procedure TfrmDlg.DWinSelServerDirectPaint(Sender: TObject;
  dsurface: TDXTexture);
var
  d: TDXTexture;
  ax, ay: integer;
begin
  with Sender as TDWindow do begin
    ax := SurfaceX(Left);
    ay := SurfaceY(Top);

    d := WLib.Images[TDWindow(Sender).FaceIndex];
    if d <> nil then
      DSurface.Draw(ax, ay, d, True);
    d := g_WMain3Images.Images[233];
    if d <> nil then
      DSurface.Draw(ax + 245, ay + 31, d, True);
  end;
end;

end.
