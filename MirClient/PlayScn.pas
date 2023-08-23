unit PlayScn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HGE,HGECanvas,HGETextures, IntroScn, Grobal2, cliUtil, HUtil32,
  HumanActor, Actor, HerbActor, AxeMon, SoundUtil, clEvent, WIL,
  StdCtrls, ClFunc, magiceff, ExtCtrls, MShare;

const
  LONGHEIGHT_IMAGE          = 35;
  FLASHBASE                 = 410;
  SOFFX                     = 0;
  SOFFY                     = 0;
  LMX                       = 30;
  LMY                       = 26;

  MAXLIGHT                  = 5;


type
  TProcMagic = record
    nTargetX: Integer;
    nTargetY: Integer;
    xTarget: TActor;
    xMagic: TClientMagic;
    fReacll: Boolean;
    fContinue: Boolean;
    fUnLockMagic: Boolean;
    dwTick: LongWord;
  end;
  pTProcMagic = ^TProcMagic;

  TShakeScreen = class
  private
  public
    boShake_X: Boolean;
    boShake_Y: Boolean;
    nShakeCnt_X: Integer;
    nShakeCnt_Y: Integer;
    nShakeLoopCnt_X: Integer;
    nShakeLoopCnt_Y: Integer;
    nShakeRange_X: Integer;
    nShakeRange_Y: Integer;
    dwShakeTime_X: LongWord;
    dwShakeTick_X: LongWord;
    dwShakeTime_Y: LongWord;
    dwShakeTick_Y: LongWord;
    constructor Create;
    function GetShakeRect(tick: LongWord): TRect;
    procedure SetScrShake_X(cnt: Integer);
    procedure SetScrShake_Y(cnt: Integer);
  end;

  TPlayScene = class(TScene)
    m_MapSurface: TDXRenderTargetTexture;
    m_ObjSurface: TDXRenderTargetTexture; //0x0C
    m_MagSurface: TDXRenderTargetTexture; //0x0C
    m_Darksurface: TDxRenderTargetTexture; //黑夜
    m_boPlayChange: Boolean;
    m_dwPlayChangeTick: LongWord;
  private
    m_dwMoveTime: LongWord;
    m_dwPlayTime: LongWord;
    m_dwAniTime: LongWord;
    m_nAniCount: Integer;
    m_nDefXX: Integer;
    m_nDefYY: Integer;
    m_MainSoundTimer: TTimer;
    procedure SoundOnTimer(Sender: TObject);
    function CrashManEx(mx, my: Integer): Boolean;
    procedure ClearDropItemA();
  public
    EdChat: TEdit;
    MemoLog: TMemo;
    m_ActorList: TList;
    m_EffectList: TList;
    m_FlyList: TList;
    m_dwBlinkTime: LongWord;
    m_boViewBlink: Boolean;
    ProcMagic: TProcMagic;
    constructor Create;
    destructor Destroy; override;
//    procedure Initialize; override;
    function Initialize: Boolean;
    procedure Lost;
    procedure Recovered;
    procedure Finalize; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure OpeningScene; override;
    procedure DrawTileMap(Sender: TObject);
    function CanDrawTileMap(): Boolean;
   // procedure DrawMiniMap(Surface: TDXTexture);   //画小地图 Development 2019-01-11 注释
//    procedure DrawTileMap(Msurface: TDXTexture);
    procedure PlayScene(MSurface: TDXTexture); override;
    procedure BeginScene();
    procedure PlaySurface(Sender: TObject);
    procedure MagicSurface(Sender: TObject);
    function ButchAnimal(X, Y: Integer): TActor;

    procedure EdChatKeyPress(Sender: TObject; var Key: Char);
    procedure EdChatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdChatOnChange(Sender: TObject);
    function FindActor(id: Integer): TActor; overload;
    function FindActor(sName: string): TActor; overload;
    function FindActorXY(X, Y: Integer): TActor;
    function IsValidActor(Actor: TActor): Boolean;
    function NewActor(chrid: Integer; cx, cy, cdir: Word; cfeature, cstate: Integer): TActor;
    procedure ActorDied(Actor: TObject);
    procedure SetActorDrawLevel(Actor: TObject; Level: Integer);
    procedure ClearActors;
    function DeleteActor(id: Integer; boDeath: Boolean = False): TActor;
    procedure DelActor(Actor: TObject);
    procedure SendMsg(ident, chrid, X, Y, cdir, Feature, State: Integer; Str: string; IPInfo: Integer = 0);
    procedure NewMagic(aowner: TActor; magid, Magnumb, cx, cy, tx, ty, TargetCode: Integer; Mtype: TMagicType; Recusion: Boolean; anitime: Integer; var boFly: Boolean; maglv: Integer = 0; Poison: Integer = 0);
    procedure DelMagic(magid: Integer);
    function NewFlyObject(aowner: TActor; cx, cy, tx, ty, TargetCode: Integer; Mtype: TMagicType): TMagicEff;
    procedure ScreenXYfromMCXY(cx, cy: Integer; var sX, sY: Integer);
    procedure CXYfromMouseXY(mx, my: Integer; var ccx, ccy: Integer);
    function GetCharacter(X, Y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
    function GetAttackFocusCharacter(X, Y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
    function IsSelectMyself(X, Y: Integer): Boolean;
    function GetDropItems(X, Y: Integer; var inames: string): pTDropItem;
    function GetXYDropItems(nX, nY: Integer): pTDropItem;
    procedure GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
    function CanRun(sX, sY, ex, ey: Integer): Boolean;
    function CanWalk(mx, my: Integer): Boolean;
    function CanWalkEx(mx, my: Integer): Boolean;
    function CrashMan(mx, my: Integer): Boolean;
    function CanFly(mx, my: Integer): Boolean;
    procedure CleanObjects;
    procedure DropItemsShow(); //显示物品名称  Development 2019-01-11
  end;

var
  g_o                       : LongInt;
  g_w                       : LongInt;
  g_Bit                     : TBitmap;
  g_ProcDrawChrPos          : Integer = 0;
  g_ProcDrawChr             : LongInt;

implementation

uses
  ClMain, FState, MapUnit, EdCode;

constructor TShakeScreen.Create;
begin
  boShake_X := False;
  nShakeCnt_X := 0;
  boShake_Y := False;
  nShakeCnt_Y := 0;

  nShakeLoopCnt_X := 0;
  nShakeLoopCnt_Y := 0;

  dwShakeTime_X := 0;
  dwShakeTime_Y := 0;

  nShakeRange_X := 5;
  nShakeRange_Y := 5;
end;

procedure TShakeScreen.SetScrShake_X(cnt: Integer);
begin
  if boShake_X or not g_gcGeneral[10] then Exit;
  boShake_X := True;
  dwShakeTick_X := GetTickCount();
  nShakeCnt_X := 0;
  nShakeLoopCnt_X := cnt;

  nShakeRange_X := cnt;
end;

procedure TShakeScreen.SetScrShake_Y(cnt: Integer);
begin
  if boShake_Y or not g_gcGeneral[10] then Exit;
  boShake_Y := True;
  dwShakeTick_Y := GetTickCount();
  nShakeCnt_Y := 0;
  nShakeLoopCnt_Y := cnt;
  nShakeRange_Y := cnt;
end;

function TShakeScreen.GetShakeRect(tick: LongWord): TRect;
var
  i                         : Integer;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := SCREENWIDTH - SOFFX * 2;
  Result.Bottom := SCREENHEIGHT;
  if boShake_X then begin
    if nShakeLoopCnt_X > 0 then begin
      if nShakeCnt_X < nShakeRange_X then begin
        if tick - dwShakeTick_X > dwShakeTime_X then begin
          dwShakeTick_X := tick;

          i := nShakeRange_X;

          Dec(i, nShakeCnt_X);
          Result.Left := i;

          Inc(i, SCREENWIDTH - SOFFX * 2);
          Result.Right := i;

          Inc(nShakeCnt_X);
        end;
      end else begin
        if nShakeRange_X > 1 then
          Dec(nShakeRange_X);
        nShakeCnt_X := 0;
        Dec(nShakeLoopCnt_X);
        if nShakeLoopCnt_X <= 0 then
          boShake_X := False;
      end;
    end;
  end;

  if boShake_Y then begin
    if nShakeLoopCnt_Y > 0 then begin
      if nShakeCnt_Y < nShakeRange_Y then begin
        if tick - dwShakeTick_Y > dwShakeTime_Y then begin
          dwShakeTick_Y := tick;

          i := nShakeRange_Y;

          Dec(i, nShakeCnt_Y);
          Result.Top := i;

          Inc(i, SCREENHEIGHT);
          Result.Bottom := i;

          Inc(nShakeCnt_Y);
        end;
      end else begin
        if nShakeRange_Y > 1 then
          Dec(nShakeRange_Y);
        nShakeCnt_Y := 0;
        Dec(nShakeLoopCnt_Y);
        if nShakeLoopCnt_Y <= 0 then
          boShake_Y := False;
      end;
    end;
  end;
end;

constructor TPlayScene.Create;
begin
  m_MapSurface := nil;
  m_ObjSurface := nil;
  m_MagSurface := nil;
  ProcMagic.nTargetX := -1;
  m_ActorList := TList.Create;
  m_EffectList := TList.Create;
  m_FlyList := TList.Create;
  m_dwBlinkTime := GetTickCount;
  m_boViewBlink := False;

  EdChat := TEdit.Create(FrmMain.Owner);
  with EdChat do begin
    Parent := FrmMain;
    BorderStyle := bsNone;
    OnKeyPress := EdChatKeyPress;
    Visible := FALSE;
    Color := clSilver;
    Font.Color := clBlack;
    MaxLength := 70;
    Ctl3D := FALSE;
    Left := 208;
    Top := SCREENHEIGHT - 19;
    Height := 12;
    Width := (SCREENWIDTH div 2 - 207) * 2;
  end;

  MemoLog := TMemo.Create(frmMain.Owner);
  with MemoLog do begin
    Parent := frmMain;
    BorderStyle := bsNone;
    Visible := False;
    Ctl3D := True;
    Left := 0;
    Top := 250;
    Width := 300;
    Height := 150;
  end;

  m_dwMoveTime := GetTickCount;
  m_dwAniTime := GetTickCount;
  m_nAniCount := 0;
  //m_nMoveStepCount := 0;
  m_MainSoundTimer := TTimer.Create(frmMain.Owner);
  with m_MainSoundTimer do begin
    OnTimer := SoundOnTimer;
    Interval := 1;
    Enabled := False;
  end;
end;

destructor TPlayScene.Destroy;
begin
  m_ActorList.Free;
  m_EffectList.Free;
  m_FlyList.Free;
  inherited Destroy;
end;

procedure TPlayScene.SoundOnTimer(Sender: TObject);
begin
  g_SndMgr.PlaySound(s_main_theme);
  m_MainSoundTimer.Interval := 46 * 1000;
end;

procedure TPlayScene.EdChatKeyPress(Sender: TObject; var Key: Char);
begin
//  if Key = #13 then begin
//    frmMain.SendSay(frmDlg.DEdChat.Text);
//    if (frmDlg.DEdChat.Text <> '') and (g_SendSayList.indexof(frmDlg.DEdChat.Text) < 0) then
//      g_SendSayList.Add(frmDlg.DEdChat.Text);
//    frmDlg.DEdChat.Text := '';
//    frmDlg.DEdChat.Visible := False;
//    if not g_ChatStatusLarge then frmDlg.DBChat.Visible := False;
//    Key := #0;
//  end;
//  if Key = #27 then begin
//    frmDlg.DEdChat.Text := '';
//    frmDlg.DEdChat.Visible := False;
//    if not g_ChatStatusLarge then frmDlg.DBChat.Visible := False;
//    Key := #0;
//  end;

  if Key = #13 then begin //回车发送聊天框输入的消息
    frmMain.SendSay(EdChat.Text);
    if (EdChat.Text <> '') and (g_SendSayList.indexof(EdChat.Text) < 0) then
      g_SendSayList.Add(EdChat.Text);
    EdChat.Text := '';
    EdChat.Visible := False;
    if not g_ChatStatusLarge then frmDlg.DBChat.Visible := False;
    Key := #0;
  end;
  if Key = #27 then begin //Esc
    EdChat.Text := '';
    EdChat.Visible := False;
    if not g_ChatStatusLarge then frmDlg.DBChat.Visible := False;
    Key := #0;
  end;
end;

procedure TPlayScene.EdChatOnChange(Sender: TObject);
begin
  //
end;

procedure TPlayScene.EdChatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  frmMain.FormKeyDown(Sender, Key, Shift);

end;

//
//procedure TPlayScene.Initialize;
//begin
//
//end;
//
//procedure TPlayScene.Finalize;
//begin
//
//end;

function TPlayScene.Initialize: Boolean;
var
  DXAccessInfo: TDXAccessInfo;
  Y, X: Integer;
  WriteBuffer: PWord;
begin
  Result := False;
  //更新
  m_MapSurface := TDXRenderTargetTexture.Create(g_DXCanvas);
  m_MapSurface.Size := Point(SCREENWIDTH + UNITX * 10 + 30, SCREENHEIGHT + UNITY * 10 + 30);
  m_MapSurface.Active := True;
  if not m_MapSurface.Active then
    exit;

  m_ObjSurface := TDXRenderTargetTexture.Create(g_DXCanvas);
  m_ObjSurface.Size := Point(SCREENWIDTH + UNITX * 8 + 30, SCREENHEIGHT + UNITY * 8 + 30);
  m_ObjSurface.Active := True;
  if not m_ObjSurface.Active then
    exit;

  m_MagSurface := TDXRenderTargetTexture.Create(g_DXCanvas);
  m_MagSurface.Size := Point(SCREENWIDTH, SCREENHEIGHT);
  m_MagSurface.Active := True;
  if not m_MagSurface.Active then
    exit;

  Result := True;
end;

procedure TPlayScene.Finalize;
begin
  if m_MapSurface <> nil then
    m_MapSurface.Free;
  if m_ObjSurface <> nil then
    m_ObjSurface.Free;
  if m_MagSurface <> nil then
    m_MagSurface.Free;
  m_MapSurface := nil;
  m_ObjSurface := nil;
  m_MagSurface := nil;
end;

procedure TPlayScene.Recovered;
begin
  if m_MapSurface <> nil then
    m_MapSurface.Recovered;
  if m_ObjSurface <> nil then
    m_ObjSurface.Recovered;
  if m_MagSurface <> nil then
    m_MagSurface.Recovered;
end;

procedure TPlayScene.Lost;
begin
  if m_MapSurface <> nil then
    m_MapSurface.Lost;
  if m_ObjSurface <> nil then
    m_ObjSurface.Lost;
  if m_MagSurface <> nil then
    m_MagSurface.Lost;
end;

function TPlayScene.CanDrawTileMap: Boolean;
begin
  Result := False;
  with Map do
    if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then
      Exit;
  if not g_boDrawTileMap then
    Exit;
  Result := True;
end;
procedure TPlayScene.OpenScene; //进入游戏场景
begin
//  ClMain.HGE.Gfx_Restore(ScreenWidth, ScreenHeight, 16); //进入游戏场景后设置屏幕分辨率
////  g_WMainImages.ClearCache;
//  frmDlg.ViewBottomBox(True);
   ClMain.HGE.Gfx_Restore(SCREENWIDTH, SCREENHEIGHT, 32);
//   SetImeMode(frmMain.Handle, LocalLanguage);
   frmDlg.ViewBottomBox(True);
   g_WMainImages.ClearCache;  //释放场景
   FrmDlg.ViewBottomBox (TRUE);
//   SetImeMode (FrmMain.Handle, LocalLanguage);
end;

procedure TPlayScene.CloseScene; //关闭游戏场景
begin
  g_SndMgr.SilenceSound;
  //frmDlg.DEdChat.Visible := False;
  EdChat.Visible := False;
  frmDlg.DBChat.Visible := False;
  frmDlg.ViewBottomBox(False);
end;

procedure TPlayScene.OpeningScene;
begin
  ;
end;

function IsMySlaveObject(atc: TActor): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if g_MySelf = nil then Exit;
  for i := 0 to g_MySelf.m_SlaveObject.Count - 1 do begin
    if atc = TActor(g_MySelf.m_SlaveObject[i]) then begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TPlayScene.CleanObjects;
var
  i                         : Integer;
begin
  for i := m_ActorList.Count - 1 downto 0 do begin
    if (TActor(m_ActorList[i]) <> g_MySelf) and
      (TActor(m_ActorList[i]) <> g_MySelf.m_HeroObject) and not IsMySlaveObject(TActor(m_ActorList[i]))
      {(TActor(m_ActorList[i]) <> g_MySelf.m_SlaveObject)}then begin //BLUE
      TActor(m_ActorList[i]).Free;
      m_ActorList.Delete(i);
    end;
  end;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicTarget := nil;
  for i := 0 to m_EffectList.Count - 1 do
    TMagicEff(m_EffectList[i]).Free;
  m_EffectList.Clear;
end;

procedure TPlayScene.DrawTileMap(Sender: TObject);
var
  i, j, nY, nX, nImgNumber: Integer;
  dsurface : TDXTexture;
begin
  try
    with Map do
      if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then exit;

    Map.m_OldClientRect := Map.m_ClientRect;

    if not g_boDrawTileMap then Exit;

    //地图底层
    with Map.m_ClientRect do begin
      nY := - UNITY * 2;
      for j:=(Top - Map.m_nBlockTop - 1) to (Bottom - Map.m_nBlockTop+1) do begin //从地图顶部到下部
        nX := AAX -UNITX;
        for i:=(Left - Map.m_nBlockLeft - 2) to (Right - Map.m_nBlockLeft + 1) do begin //从地图左边到右边
          if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
            if (i mod 2 = 0) and (j mod 2 = 0) then begin
              nImgNumber := (Map.m_MArr[i, j].wBkImg and $7FFF);
              if nImgNumber > 0 then begin
                nImgNumber := nImgNumber - 1;
                DSurface := MShare.GetTiles(Map.m_MArr[i, j].btTiles, nImgNumber);
                if Dsurface <> nil then begin
                  m_MapSurface.Draw(nX, nY, DSurface.ClientRect, DSurface, FALSE);
                end;
              end;
            end;
          end;
          Inc(nX, UNITX);
        end;
        Inc(nY, UNITY);
      end;
    end;
    //地图中间层   比如比奇安全区的草
    with Map.m_ClientRect do begin
      nY :=  - UNITY * 2;
      for j:=(Top - Map.m_nBlockTop - 1) to (Bottom - Map.m_nBlockTop + 1) do begin //从地图顶部到下部
        nX := AAX - UNITX;
        for i:=(Left - Map.m_nBlockLeft - 2) to (Right - Map.m_nBlockLeft + 1) do begin //从地图左边到右边
          if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
            nImgNumber := Map.m_MArr[i, j].wMidImg;
            if nImgNumber > 0 then begin
              nImgNumber := nImgNumber - 1;
              DSurface := MShare.GetSmTiles(Map.m_MArr[i, j].btsmTiles, nImgNumber);
              if Dsurface <> nil then
                m_MapSurface.Draw(nX, nY, DSurface.ClientRect, DSurface, TRUE);
            end;
          end;
          Inc(nX, UNITX);
        end;
        Inc(nY, UNITY);
      end;
    end;
  except
    DebugOutStr('[Exception]: TPlayScene.DrawTileMap');
  end;
end;

procedure TPlayScene.ClearDropItemA;
var
  i                         : Integer;
  DropItem                  : pTDropItem;
begin
  for i := g_DropedItemList.Count - 1 downto 0 do begin
    DropItem := g_DropedItemList.Items[i];
    if DropItem = nil then begin
      g_DropedItemList.Delete(i);
      //Continue;
      Break;
    end;
    if (abs(DropItem.X - g_MySelf.m_nCurrX) > 20) or (abs(DropItem.Y - g_MySelf.m_nCurrY) > 20) then begin
      Dispose(DropItem);
      g_DropedItemList.Delete(i);
      Break;
    end;
  end;
end;


//const
//  g_MapRect                 : TRect = (
//    Left: 0;
//    Top: 0;
//    Right: MINIMAPSIZE;
//    Bottom: MINIMAPSIZE
//    );
//
////画小地图功能 Development 2019-01-11 注释
//procedure TPlayScene.DrawMiniMap(Surface: TDXTexture);
//var
//  D, dd                     : TDXTexture;
//  v                         : Boolean;
//  mx, my, nX, nY, i         : Integer;
//  Actor                     : TActor;
//  X, Y                      : Integer;
//  btColor                   : byte;
//  rx, ry, rrx, rry          : Real;
//  S                         : string;
//  tMapPath                  : array of TPoint;
//  pMapDescInfo              : pTMapDescInfo;
//  PenColor                  :TColor;
//begin
//  if g_nMiniMapIndex < 0 then Exit;
//  if g_nMiniMapIndex >= 300 then begin
//    D := g_WMiniMapImages.Images[Format(g_sMiniMap, [g_nMiniMapIndex + 1])];
//  end else
//    D := g_WMMapImages.Images[g_nMiniMapIndex];
//  if D = nil then begin
//    g_DrawingMiniMap := False;
//    Exit;
//  end;
//  if g_nViewMinMapLv = 1 then begin
//    mx := (g_MySelf.m_nCurrX * 48) div 32;
//    my := g_MySelf.m_nCurrY;
//    g_MiniMapRC.Left := _MAX(0, mx - 60);
//    g_MiniMapRC.Top := _MAX(0, my - 60);
//    g_MiniMapRC.Right := _MIN(D.ClientRect.Right, g_MiniMapRC.Left + 120);
//    g_MiniMapRC.Bottom := _MIN(D.ClientRect.Bottom, g_MiniMapRC.Top + 120);
//
//    if g_DrawMiniBlend then begin
//      DrawBlendEx(Surface, (SCREENWIDTH - 120), 0, g_MiniMapRC, D, 150); //小地图最小化虚化 Development 2019-01-11
//    end else begin
//      Surface.Draw(SCREENWIDTH - 120, 0, g_MiniMapRC, D, False); //小地图最小化实显 Development 2019-01-11
//    end;
//
//    g_DrawingMiniMap := True;
//
//    if GetTickCount > m_dwBlinkTime + 300 then begin
//      m_dwBlinkTime := GetTickCount;
//      m_boViewBlink := not m_boViewBlink;
//    end;
//    if m_boViewBlink then begin
//      mx := (SCREENWIDTH - 120) + (g_MySelf.m_nCurrX * 48) div 32 - g_MiniMapRC.Left;
//      my := (g_MySelf.m_nCurrY * 32) div 32 - g_MiniMapRC.Top;
//      g_DXCanvas.FillRectAlpha(Rect(mx - 1, my - 1, mx + 2, my + 2), GetRGB(255), 255);
//    end;
//
//    for i := 0 to m_ActorList.Count - 1 do begin //opt
//      Actor := TActor(m_ActorList[i]);
//      if (Actor <> nil) and not Actor.m_boDeath and Actor.m_boVisible and Actor.m_boHoldPlace and (Actor <> g_MySelf) then begin
//        if (abs(Actor.m_nCurrX - g_MySelf.m_nCurrX) <= 10) and (abs(Actor.m_nCurrY - g_MySelf.m_nCurrY) <= 10) then begin
//          mx := (SCREENWIDTH - 120) + (Actor.m_nCurrX * 48) div 32 - g_MiniMapRC.Left;
//          my := Actor.m_nCurrY - g_MiniMapRC.Top;
//          case Actor.m_btRace of
//            12, 24, 50: btColor := 250;
//            54, 55, 81: btColor := 0;
//            0: begin
//                if Actor.m_btNameColor = 255 then
//                  btColor := 251
//                else
//                  btColor := Actor.m_btNameColor;
//              end;
//          else
//            btColor := 249;
//          end;
//          if Actor.m_btNameColor = 253 then btColor := 253;
//          g_DXCanvas.FillRectAlpha(Rect(mx - 1, my - 1, mx + 2, my + 2), GetRGB(btColor),255);
//        end;
//      end;
//    end;
//    //123456
//    for i := 0 to g_xCurMapDescList.Count - 1 do begin
//      pMapDescInfo := pTMapDescInfo(g_xCurMapDescList.Objects[i]);
//      mx := (SCREENWIDTH - 120) + (pMapDescInfo.nPointX * 48) div 32 - g_MiniMapRC.Left;
//      my := pMapDescInfo.nPointY - g_MiniMapRC.Top;
//      if (mx >= SCREENWIDTH - 120) and ((my >= 0) and (my <= 120)) then begin
//        if g_DrawMiniBlend then
//          g_DXCanvas.BoldTextOut( mx, my, pMapDescInfo.nColor,pMapDescInfo.szPlaceName)
//        else
//          g_DXCanvas.BoldTextOut( mx, my, pMapDescInfo.nColor, pMapDescInfo.szPlaceName);
//      end;
//    end;
//    if g_ShowMiniMapXY then begin
//      rx := g_MySelf.m_nCurrX + (g_nMouseX - (SCREENWIDTH - (g_MiniMapRC.Right - g_MiniMapRC.Left)) - ((g_MiniMapRC.Right - g_MiniMapRC.Left) div 2)) * 2 / 3;
//      ry := g_MySelf.m_nCurrY + (g_nMouseY - (g_MiniMapRC.Bottom - g_MiniMapRC.Top) div 2);
//      if (rx >= 0) and (ry >= 0) then begin
//        S := Format('%s:%s', [IntToStr(Round(rx)), IntToStr(Round(ry))]);
//
//        with g_DXCanvas do begin  //输出坐标
//        TextOut(SCREENWIDTH - TextWidth(S) - 02, g_MiniMapRC.Bottom - g_MiniMapRC.Top - 14,clWhite, IntToStr(Round(rx)) + ':' + IntToStr(Round(ry)));
//        end;
//      end;
//    end;
//
//    if g_MapPath <> nil then  //画自动寻路时鼠标选择的定位点  Development 2019-01-11
//    if g_MoveStep <= High(g_MapPath) then
//    for i := g_MoveStep to High(g_MapPath) do
//    begin
//      mx := (SCREENWIDTH - 120) + (g_MapPath[i].X * 48) div 32 - g_MiniMapRC.Left;
//      my := g_MapPath[i].Y - g_MiniMapRC.Top;
//      if (mx >= SCREENWIDTH - 120) and ((my >= 0) and (my <= 120)) then
//      g_DXCanvas.FillRectAlpha(Rect(mx, my, mx + 2, my + 2), GetRGB(224), 255); //绿色
//    end;
//
//  end else begin
//    g_MiniMapRC.Left := SCREENWIDTH - MINIMAPSIZE;
//    g_MiniMapRC.Top := 0;
//    g_MiniMapRC.Right := SCREENWIDTH;
//    g_MiniMapRC.Bottom := MINIMAPSIZE;
//
//    if g_DrawMiniBlend then begin
//      DrawBlendStretchEX(Surface, Bounds(SCREENWIDTH-200, 0, 200, 200), D.ClientRect, D, 150); //小地图最大化虚化 Development 2019-01-11
//    end else
//      Surface.StretchDraw(g_MiniMapRC, D.ClientRect, D, False); //小地图最大话实际显示 Development 2019-01-11
//
//    g_DrawingMiniMap := True;
//    if GetTickCount > m_dwBlinkTime + 300 then begin
//      m_dwBlinkTime := GetTickCount;
//      m_boViewBlink := not m_boViewBlink;
//    end;
//    rx := D.Width / (MINIMAPSIZE * 1.5);
//    ry := D.Height / MINIMAPSIZE;
//    rrx := rx;
//    rry := ry;
//    if m_boViewBlink then begin
//      mx := g_MiniMapRC.Left + Round(g_MySelf.m_nCurrX / rx);
//      my := Round(g_MySelf.m_nCurrY / ry);
//      g_DXCanvas.FillRectAlpha(Rect(mx - 1, my - 1, mx + 2, my + 2), GetRGB(255),255);
//    end;
//
//    if g_boOpenAutoPlay and (g_APMapPath <> nil) then begin
//      nX := Round(12 / rx);
//      nY := Round(12 / ry);
//      SetLength(tMapPath, High(g_APMapPath) + 1);
//      for i := 0 to High(g_APMapPath) do begin
//        mx := Round(g_APMapPath[i].X / rx);
//        my := Round(g_APMapPath[i].Y / ry);
//        tMapPath[i] := Point(SCREENWIDTH - MINIMAPSIZE + mx, my);
//        g_DXCanvas.FillRectAlpha(Rect(SCREENWIDTH - 200 + mx - 1, my - 1, SCREENWIDTH - 200 + mx + 1, my + 1), GetRGB(249),255);
//
//        with g_DXCanvas do begin
//          if i = g_APStep then
//            PenColor := clRed
//          else
//            PenColor := clLime;
//
//          RoundRect((SCREENWIDTH - 200 + mx + nX), (0 + my + nY), (SCREENWIDTH - 200 + mx - nX), (0 + my - nY), nX * 2, nY * 2,PenColor);
//        end;
//      end;
//
//      with g_DXCanvas do begin
//        PenColor := GetRGB(151);
//        Polygon(tMapPath,PenColor,True);
//      end;
//
//    end;
//
//    if g_MapPath <> nil then begin
//      if g_MoveStep <= High(g_MapPath) then
//        for i := g_MoveStep to High(g_MapPath) do begin
//          mx := SCREENWIDTH - 200 + Round(g_MapPath[i].X / rx);
//          my := Round(g_MapPath[i].Y / ry);
//
//          g_DXCanvas.FillRectAlpha(Rect(mx, my, mx + 1, my + 1), GetRGB(224),255);
//        end;
//    end;
//
//   with g_DXCanvas do begin
//    for i := 0 to g_xCurMapDescList.Count - 1 do begin
//      pMapDescInfo := pTMapDescInfo(g_xCurMapDescList.Objects[i]);
//      mx := SCREENWIDTH - 200 + Round(pMapDescInfo.nPointX / rrx);
//      my := Round(pMapDescInfo.nPointY / rry);
//      if g_DrawMiniBlend then
//        BoldTextOut( mx, my, pMapDescInfo.nColor, pMapDescInfo.szPlaceName)
//      else
//        BoldTextOut( mx, my, pMapDescInfo.nColor, pMapDescInfo.szPlaceName);
//    end;
//    if g_ShowMiniMapXY then begin
//      rx := (g_nMouseX - g_MiniMapRC.Left) * (Map.m_MapHeader.wWidth / MINIMAPSIZE);
//      ry := g_nMouseY * (Map.m_MapHeader.wHeight / MINIMAPSIZE);
//      if (rx >= 0) and (ry >= 0) then begin
//        S := Format('%s:%s', [IntToStr(Round(rx)), IntToStr(Round(ry))]);
//            TextOut(SCREENWIDTH - TextWidth(S) - 2, MINIMAPSIZE - 14, S,clWhite);
//      end;
//    end;
//   end;
//  end;
//end;

procedure TPlayScene.BeginScene();
var
  i, j, k, n, M, mmm, ix, iy, line, defx, defy, wunit, fridx, ani, anitick, ax, ay, idx: Integer;
  dsurface, D: TDXTexture;
  b, blend, movetick: Boolean;
  DropItem: pTDropItem;
  evn: TClEvent;
  Actor: TActor;
  meff: TMagicEff;
  ShowItem: pTShowItem;
  cc, nFColor, nBColor: Integer;
  tick, dwCheckTime: LongWord;
  boCheckTimeLimit: Boolean;
  DrawRect: TRect;
begin
  cc := 0;
  tick := GetTickCount();
  if (g_MySelf = nil) then
  begin
    exit;
  end;
  g_boDoFastFadeOut := False;

  movetick := False;
  if g_boSpeedRate then
  begin           //move speed
    if tick - m_dwMoveTime >= (95 - g_MoveSpeedRate div 2) then
    begin //move speed
      m_dwMoveTime := tick;
      movetick := True;
    end;
  end
  else
  begin
    if tick - m_dwMoveTime >= 95 then
    begin
      m_dwMoveTime := tick;
      movetick := True;
    end;
  end;

  if tick - m_dwAniTime >= 150 then
  begin //活动素材
    m_dwAniTime := tick;
    Inc(m_nAniCount);
    if m_nAniCount > 100000 then
      m_nAniCount := 0;
  end;

  try
    i := 0;
    while True do
    begin                 //DYNAMIC MODE
      if i >= m_ActorList.Count then
        Break;
      Actor := m_ActorList[i];
      if Actor.m_boDeath and g_gcGeneral[8] and not Actor.m_boItemExplore and (Actor.m_btRace <> 0) and Actor.IsIdle then
      begin
        Inc(i);
        Continue;
      end;

      if movetick then
        Actor.m_boLockEndFrame := False;

      if not Actor.m_boLockEndFrame then
      begin
        Actor.ProcMsg;
        if movetick then
        begin
          if Actor.Move() then
          begin
            m_boPlayChange := m_boPlayChange;
            Inc(i);
            Continue;
          end;
        end;
        Actor.Run;
        if Actor <> g_MySelf then
          Actor.ProcHurryMsg;
      end;
      if Actor = g_MySelf then
        Actor.ProcHurryMsg;

      //dogz....
      if Actor.m_nWaitForRecogId <> 0 then
      begin
        if Actor.IsIdle then
        begin
          DelChangeFace(Actor.m_nWaitForRecogId);
          NewActor(Actor.m_nWaitForRecogId, Actor.m_nCurrX, Actor.m_nCurrY, Actor.m_btDir, Actor.m_nWaitForFeature, Actor.m_nWaitForStatus);
          Actor.m_nWaitForRecogId := 0;
          Actor.m_boDelActor := True;
        end;
      end;
      if Actor.m_boDelActor then
      begin
        g_FreeActorList.Add(Actor);
        m_ActorList.Delete(i);
        if g_TargetCret = Actor then
          g_TargetCret := nil;
        if g_FocusCret = Actor then
          g_FocusCret := nil;
        if g_MagicTarget = Actor then
          g_MagicTarget := nil;
      end
      else
        Inc(i);
    end;
  except
    on E: Exception do
      DebugOutStr('101 ' + E.Message);
  end;
  m_boPlayChange := m_boPlayChange or (GetTickCount > m_dwPlayChangeTick);

  try                                   //STATIC MODE
    i := 0;
    while True do
    begin
      if i >= m_EffectList.Count then
        Break;
      meff := m_EffectList[i];
      if meff.m_boActive then
      begin
        if not meff.Run then
        begin
          meff.Free;                    //1003
          m_EffectList.Delete(i);
          Continue;
        end;
      end;
      Inc(i);
    end;

    i := 0;
    while True do
    begin
      if i >= m_FlyList.Count then
        Break;
      meff := m_FlyList[i];
      if meff.m_boActive then
      begin
        if not meff.Run then
        begin
          meff.Free;
          m_FlyList.Delete(i);
          Continue;
        end;
      end;
      Inc(i);
    end;

    EventMan.Execute;

    if (g_RareBoxWindow <> nil) then
    begin
      if g_RareBoxWindow.m_boActive then
      begin
        if not g_RareBoxWindow.Run then
          g_RareBoxWindow.m_boActive := False;
      end;
    end;
  except
    DebugOutStr('102');
  end;

  try
    ClearDropItemA();
 //释放事件的地方
    if EventMan.EventList.Count > 0 then
    begin
      for k := 0 to EventMan.EventList.Count - 1 do
      begin
        evn := TClEvent(EventMan.EventList[k]);
        if (Abs(evn.m_nX - g_MySelf.m_nCurrX) > 16) or (Abs(evn.m_nY - g_MySelf.m_nCurrY) > 16) then
        begin
          evn.Free;
          EventMan.EventList.Delete(k);
          break;
        end;
      end;
    end;
  except
    DebugOutStr('103');
  end;

  try
    with Map.m_ClientRect do
    begin
      Left := g_MySelf.m_nRx - g_TileMapOffSetX;
      Right := g_MySelf.m_nRx + g_TileMapOffSetX;
      Top := g_MySelf.m_nRy - g_TileMapOffSetY;
      Bottom := g_MySelf.m_nRy + g_TileMapOffSetY;
    end;

    Map.UpdateMapPos(g_MySelf.m_nRx, g_MySelf.m_nRy);
  except
    on E: Exception do
      DebugOutStr('104 ' + E.Message);
  end;
end;

procedure TPlayScene.PlayScene(MSurface: TDXTexture);
begin
  ;
end;

procedure TPlayScene.PlaySurface(Sender: TObject);
var
  i, j, k, n, M, mmm, ix, iy, line, defx, defy, wunit, fridx, ani, anitick, ax, ay, idx: Integer;
  dsurface, D               : TDXTexture;
  b, blend, movetick        : Boolean;
  DropItem                  : pTDropItem;
  evn                       : TClEvent;
  Actor                     : TActor;
  meff                      : TMagicEff;
  ShowItem                  : pTShowItem;
  cc, nFColor, nBColor      : Integer;
  Tick          : LongWord;
  boCheckTimeLimit          : Boolean;
  DrawRect                  : TRect;

const
  bIMGBusy                  : Boolean = False;
  msgstr                    = '正在退出游戏，请稍候...';
begin
  Tick := GetTickCount();
  if (g_MySelf = nil) then begin
    with g_DXCanvas do
      g_DXCanvas.BoldTextOut((SCREENWIDTH - TextWidth(msgstr, False)) div 2, (SCREENHEIGHT - 280) div 2, clWhite, msgstr);
    Exit;
  end;
  try

    m_ObjSurface.Draw(0, 0,
      Rect(UNITX * 3 + g_MySelf.m_nShiftX,
      UNITY * 2 + g_MySelf.m_nShiftY,
      UNITX * 3 + g_MySelf.m_nShiftX + SCREENWIDTH,
      UNITY * 2 + g_MySelf.m_nShiftY + SCREENHEIGHT),
      m_MapSurface,
      False);
  except
    on E: Exception do DebugOutStr('104 ' + E.Message);
  end;

  defx := -UNITX * 2 - g_MySelf.m_nShiftX + AAX;
  defy := -UNITY * 2 - g_MySelf.m_nShiftY;
  m_nDefXX := defx;
  m_nDefYY := defy;

  try
    M := defy - UNITY;
    for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(M, UNITY);
        Continue;
      end;
      n := defx - UNITX * 2;
      for i := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
          if fridx > 0 then begin
            ani := Map.m_MArr[i, j].btAniFrame;
            wunit := Map.m_MArr[i, j].btArea;
            if (ani and $80) > 0 then begin
              blend := True;
              ani := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.m_MArr[i, j].btAniTick;
              fridx := fridx + (m_nAniCount mod (ani + (ani * anitick))) div (1 + anitick);
            end;
            if (Map.m_MArr[i, j].btDoorOffset and $80) > 0 then begin
              if (Map.m_MArr[i, j].btDoorIndex and $7F) > 0 then
                fridx := fridx + (Map.m_MArr[i, j].btDoorOffset and $7F);
            end;
            fridx := fridx - 1;
            dsurface := GetObjs(wunit, fridx);
            if dsurface <> nil then begin
              if (dsurface.Width = 48) and (dsurface.Height = 32) then begin
                mmm := M + UNITY - dsurface.Height;
                if (n + dsurface.Width > 0) and (n <= SCREENWIDTH) and (mmm + dsurface.Height > 0) and (mmm < SCREENHEIGHT) then begin
                  m_ObjSurface.Draw(n, mmm, dsurface.ClientRect, dsurface, True)
                end else if mmm < SCREENHEIGHT then
                  m_ObjSurface.Draw(n, mmm, dsurface.ClientRect, dsurface, True)
              end;
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(M, UNITY);
    end;
  except
    on E: Exception do DebugOutStr('105 ' + E.Message);
  end;

  try
    M := defy - UNITY;
    for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(M, UNITY);
        Continue;
      end;
      n := defx - UNITX * 2;
      for i := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
          if fridx > 0 then begin
            blend := False;
            wunit := Map.m_MArr[i, j].btArea;
            ani := Map.m_MArr[i, j].btAniFrame;
            if (ani and $80) > 0 then begin
              blend := True;
              ani := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.m_MArr[i, j].btAniTick;
              fridx := fridx + (m_nAniCount mod (ani + (ani * anitick))) div (1 + anitick);
            end;
            if (Map.m_MArr[i, j].btDoorOffset and $80) > 0 then begin
              if (Map.m_MArr[i, j].btDoorIndex and $7F) > 0 then
                fridx := fridx + (Map.m_MArr[i, j].btDoorOffset and $7F);
            end;
            fridx := fridx - 1;
            if not blend then begin
              dsurface := GetObjs(wunit, fridx);
              if dsurface <> nil then begin
                if (dsurface.Width <> 48) or (dsurface.Height <> 32) then begin
                  mmm := M + UNITY - dsurface.Height;
                  if (n + dsurface.Width > 0) and (n <= SCREENWIDTH) and (mmm + dsurface.Height > 0) and (mmm < SCREENHEIGHT) then begin
                    m_ObjSurface.Draw(n, mmm, dsurface.ClientRect, dsurface, True)
                  end else begin
                    if mmm < SCREENHEIGHT then
                      m_ObjSurface.Draw(n, mmm, dsurface.ClientRect, dsurface, True)
                  end;
                end;
              end;
            end else begin
              dsurface := GetObjsEx(wunit, fridx, ax, ay);
              if dsurface <> nil then begin
                mmm := M + ay - 68;     //UNITY - DSurface.Height;
                if (n > 0) and (mmm + dsurface.Height > 0) and (n + dsurface.Width < SCREENWIDTH) and (mmm < SCREENHEIGHT) then begin
                  // DrawBlend...
                  DrawBlend(m_ObjSurface, n + ax - 2, mmm, dsurface, 1);
                end else begin
                  if mmm < SCREENHEIGHT then
                    DrawBlend(m_ObjSurface, n + ax - 2, mmm, dsurface, 1);
                end;
              end;
            end;
          end;

        end;
        Inc(n, UNITX);
      end;

      if (j <= (Map.m_ClientRect.Bottom - Map.m_nBlockTop)) and (not g_boServerChanging) then begin

        for k := 0 to EventMan.EventList.Count - 1 do begin
          evn := TClEvent(EventMan.EventList[k]);
          if j = (evn.m_nY - Map.m_nBlockTop) then
            evn.DrawEvent(m_ObjSurface, (evn.m_nX - Map.m_ClientRect.Left) * UNITX + defx, M);
        end;

        if g_boDrawDropItem then begin  //显示地面物品外形
          for k := 0 to g_DropedItemList.Count - 1 do begin
            DropItem := pTDropItem(g_DropedItemList[k]);
            if DropItem <> nil then begin
              if j = (DropItem.Y - Map.m_nBlockTop) then begin

                D := frmMain.GetWDnItemImg(DropItem.looks);
                if D <> nil then begin
                  ix := (DropItem.X - Map.m_ClientRect.Left) * UNITX + defx + SOFFX;
                  iy := M;
                  if DropItem = g_FocusItem then begin
                    g_ImgMixSurface.Draw(ix + HALFX - (D.Width div 2), iy + HALFY - (D.Height div 2), D.ClientRect, D, True);
                    DrawEffect(g_ImgMixSurface,ix + HALFX - (D.Width div 2), iy + HALFY - (D.Height div 2), g_ImgMixSurface, ceBright, False);
                    m_ObjSurface.Draw(ix + HALFX - (D.Width div 2), iy + HALFY - (D.Height div 2), D.ClientRect, g_ImgMixSurface, True);
                  end else
                    m_ObjSurface.Draw(ix + HALFX - (D.Width div 2), iy + HALFY - (D.Height div 2), D.ClientRect, D, True);
                end;
              end;
            end;
          end;
        end;



        //if g_ProcActorLimit > 0 then begin
        for k := 0 to m_ActorList.Count - 1 do begin
          Actor := m_ActorList[k];
          if (j = Actor.m_nRy - Map.m_nBlockTop - Actor.m_nDownDrawLevel) then begin
            ix := (Actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx;
            iy := M + (Actor.m_nDownDrawLevel * UNITY);
            Actor.m_nSayX := ix + Actor.m_nShiftX + 24;
            if Actor.m_boDeath then
              Actor.m_nSayY := Actor.m_nShiftY + iy - 12
            else
              Actor.m_nSayY := Actor.m_nShiftY + iy - 47;

            //if not g_boServerChanging and (g_MagicLockActor = Actor) and not Actor.m_boDeath then begin
            //  g_MagicLockActor.DrawFocus(Msurface);
            //end;

            Actor.DrawChr(m_ObjSurface, //win effect
              ix,
              iy,
              False, True, True);
          end;
        end;
        //end;

        for k := 0 to m_FlyList.Count - 1 do begin
          meff := TMagicEff(m_FlyList[k]);
          if j = (meff.ry - Map.m_nBlockTop) then
            meff.DrawEff(m_ObjSurface);
        end;
      end;
      Inc(M, UNITY);
    end;
  except
    on E: Exception do DebugOutStr(Format('106 %d ', [cc]) + E.Message);
  end;



  if not g_boServerChanging then begin
    try
      if not g_boCheckBadMapMode then
        if g_MySelf.m_nState and $00800000 = 0 then
          g_MySelf.DrawChr(m_ObjSurface, (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, False)
        else
          g_MySelf.DrawChr_Transparent(m_ObjSurface, (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, False);

      if (g_FocusCret <> nil) then begin
        if IsValidActor(g_FocusCret) and (g_FocusCret <> g_MySelf) then
          if (g_FocusCret.m_nState and $00800000 = 0) then
            g_FocusCret.DrawChr(m_ObjSurface,
              (g_FocusCret.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
              (g_FocusCret.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, False);
      end;

      {if (g_MagicTarget <> nil) then begin
        if IsValidActor(g_MagicTarget) and (g_MagicTarget <> g_MySelf) then
          if g_MagicTarget.m_nState and $00800000 = 0 then
            g_MagicTarget.DrawChr(Msurface,
              (g_MagicTarget.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
              (g_MagicTarget.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, False);
      end;}
      //魔法锁定
      if (g_MagicLockActor <> nil) then begin
        if (g_MagicLockActor <> g_MySelf) and (g_MagicLockActor.m_sUserName <> '') and not g_MagicLockActor.m_boDeath and IsValidActor(g_MagicLockActor) then begin
          g_MagicLockActor.DrawFocus(m_ObjSurface);
        end;
      end;
    except
      DebugOutStr('108');
    end;
  end;

  // DrawBlend...
  try
    for k := 0 to m_ActorList.Count - 1 do begin
      Actor := m_ActorList[k];
      if Actor.m_btRace > 0 then
        Actor.DrawEff(m_ObjSurface,
          (Actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
          (Actor.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy);
    end;

    for k := 0 to m_EffectList.Count - 1 do begin
      meff := TMagicEff(m_EffectList[k]);
      meff.DrawEff(m_ObjSurface);

    end;

    if (g_RareBoxWindow <> nil) and g_RareBoxWindow.m_boActive then
      g_RareBoxWindow.DrawEff(m_ObjSurface);


  except
    DebugOutStr('109');
  end;

  //地面物品闪烁
  try
    for k := 0 to g_DropedItemList.Count - 1 do begin //1234
      DropItem := pTDropItem(g_DropedItemList[k]);
      if DropItem <> nil then begin
        if Tick - DropItem.FlashTime > g_dwDropItemFlashTime then begin
          DropItem.FlashTime := Tick;
          DropItem.BoFlash := True;
          DropItem.FlashStepTime := Tick;
          DropItem.FlashStep := 0;
        end;
        ix := (DropItem.X - Map.m_ClientRect.Left) * UNITX + defx + SOFFX;
        iy := (DropItem.Y - Map.m_ClientRect.Top - 1) * UNITY + defy + SOFFY;
        if DropItem.BoFlash then begin
          if Tick - DropItem.FlashStepTime >= 20 then begin
            DropItem.FlashStepTime := Tick;
            Inc(DropItem.FlashStep);
          end;
          if (DropItem.FlashStep >= 0) and (DropItem.FlashStep < 10) then begin
            dsurface := g_WMainImages.GetCachedImage(FLASHBASE + DropItem.FlashStep, ax, ay);
            if dsurface <> nil then
              DrawBlend(m_ObjSurface, ix + ax, iy + ay, dsurface, 1);
          end else
            DropItem.BoFlash := False;
        end;
        //
      end;
    end;

  except
    DebugOutStr('110');
  end;


  try
   if g_MySelf.m_boDeath then        //人物死亡，显示黑白画面
      DrawEffect(m_ObjSurface,0, 0, m_ObjSurface, ceGrayScaleMMX, False);
      DrawRect := g_ShakeScreen.GetShakeRect(tick);
      m_ObjSurface.Draw(SOFFX, SOFFY, m_ObjSurface.ClientRect, m_ObjSurface, False);
  except
    DebugOutStr('111');
  end;

end;
procedure TPlayScene.MagicSurface(Sender: TObject);
var
  k: integer;
  meff: TMagicEff;
begin
 m_MagSurface.Draw(SOFFX, SOFFY, m_ObjSurface.ClientRect, m_ObjSurface, FALSE);
 for k := 0 to m_EffectList.count - 1 do begin
    meff := TMagicEff(m_EffectList[k]);
    meff.DrawEff(m_ObjSurface);
  end; 
end;
procedure TPlayScene.NewMagic(aowner: TActor; magid, Magnumb, cx, cy, tx, ty, TargetCode: Integer; Mtype: TMagicType; Recusion: Boolean; anitime: Integer; var boFly: Boolean; maglv: Integer; Poison: Integer);
var
  i, scx, scy, sctx, scty, effnum: Integer;
  meff                      : TMagicEff;
  target                    : TActor;
  wimg                      : TWMImages;
begin
  boFly := False;
  if not (magid in [MAGIC_SOULBALL_ATT3_1..MAGIC_SOULBALL_ATT3_5, 255]) then
    for i := 0 to m_EffectList.Count - 1 do
      if TMagicEff(m_EffectList[i]).ServerMagicId = magid then
        Exit;

  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);

  if Magnumb > 0 then
    GetEffectBase(Magnumb - 1, 0, wimg, effnum)
  else
    effnum := -Magnumb;

  target := FindActor(TargetCode);
  meff := nil;
  case Mtype of
    mtReady {0}, mtFly, mtFlyAxe: begin
        meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
        meff.TargetActor := target;
        case Magnumb of
          39: begin
              meff.frame := 4;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          44: meff := nil;
          63: begin                     //噬魂沼泽
              meff.MagExplosionBase := 780;
              meff.NextFrameTime := 100;
              meff.ExplosionFrame := 25;
              meff.light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          100: begin
              meff.MagExplosionBase := 270;
              meff.NextFrameTime := 100;
              meff.ExplosionFrame := 5;
              meff.light := 3;
              meff.ImgLib := g_WMagic5Images;
            end;
          101: begin
              meff.MagExplosionBase := 450;
              meff.NextFrameTime := 100;
              meff.ExplosionFrame := 10;
              meff.light := 3;
              meff.ImgLib := g_WMagic5Images;
            end;
          121: begin
              //DScreen.AddChatBoardString(inttostr(Magnumb) + ' ' + IntToStr(TargetCode) + ' ' + IntToStr(g_MySelf.m_nRecogId), clWhite, clBlue);
              meff.MagExplosionBase := 0;
              meff.NextFrameTime := 100;
              meff.ExplosionFrame := 8;
              meff.light := 3;
              meff.ImgLib := g_WMagic8Images2;
            end;
          {120,}122: begin
              //DScreen.AddChatBoardString(inttostr(Magnumb) + ' ' + IntToStr(TargetCode) + ' ' + IntToStr(g_MySelf.m_nRecogId), clWhite, clBlue);
              meff.MagExplosionBase := 860;
              meff.NextFrameTime := 100;
              meff.ExplosionFrame := 20;
              meff.light := 3;
              meff.ImgLib := g_WMagic7Images2;
            end;

        end;
        boFly := True;
      end;
    mtExplosion:
      case Magnumb of
        04: begin
            case maglv div 4 of
              1: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  if Poison = 2 then
                    meff.MagExplosionBase := 830
                  else
                    meff.MagExplosionBase := 620;
                  meff.TargetActor := target;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 8;
                  meff.light := 2;
                  meff.ImgLib := g_WMagic7Images;
                end;
              2: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  if Poison = 2 then
                    meff.MagExplosionBase := 830 + 10
                  else
                    meff.MagExplosionBase := 620 + 10;
                  meff.TargetActor := target;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 8;
                  meff.light := 2;
                  meff.ImgLib := g_WMagic7Images;
                end;
              3: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  if Poison = 2 then
                    meff.MagExplosionBase := 830 + 20
                  else
                    meff.MagExplosionBase := 620 + 20;
                  meff.TargetActor := target;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 8;
                  meff.light := 2;
                  meff.ImgLib := g_WMagic7Images;
                end;
            else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                meff.TargetActor := target;
                meff.NextFrameTime := 80;
              end;
            end;
          end;
        18: begin                       //诱惑之光
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 1570;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
          end;
        21: begin                       //爆裂火焰
            case maglv div 4 of
              1: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 350;
                  meff.TargetActor := nil; //target;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 11;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic7Images;
                end;
              2: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 380;
                  meff.TargetActor := nil; //target;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 11;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic7Images;
                end;
              3: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 410;
                  meff.TargetActor := nil; //target;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 14;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic7Images;
                end;
            else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                meff.MagExplosionBase := 1660;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 20;
                meff.light := 3;
              end;
            end;
          end;
        26: begin                       //心灵启示
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 3990;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 10;
            meff.light := 2;
          end;
        27: begin                       //群体治疗术
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 1800;
            meff.TargetActor := nil;    //target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 10;
            meff.light := 3;
          end;
        30: begin                       //圣言术
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 3930;
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 16;
            meff.light := 3;
          end;
        31: begin                       //冰咆哮
            case maglv div 4 of
              1: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 90;
                  meff.TargetActor := nil;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 18;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic8Images;
                end;
              2: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 110;
                  meff.TargetActor := nil; //target;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 18;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic8Images;
                end;
              3: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 130;
                  meff.TargetActor := nil; //target;
                  meff.NextFrameTime := 80;
                  meff.ExplosionFrame := 18;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic8Images;
                end;
            else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                meff.MagExplosionBase := 3850;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 20;
                meff.light := 3;
              end;
            end;
          end;
        40: begin                       // 净化术
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 620;
            meff.TargetActor := target;
            meff.NextFrameTime := 100;
            meff.ExplosionFrame := 20;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        45: begin                       //火龙气焰
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 920;
            meff.TargetActor := nil;    //target;
            meff.NextFrameTime := 120;
            meff.ExplosionFrame := 20;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        47: begin                       //飓风破
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 1010;
            meff.TargetActor := nil;
            //meff.FixedEffect := False;
            meff.NextFrameTime := 120;
            meff.ExplosionFrame := 14;  //18
            meff.light := 3;
            meff.ImgLib := g_WMagic2Images;
            //PlaySoundName('wav\M6-3.wav');
            //PlaySoundName('wav\M6-3.wav');
          end;
        48: begin                       //血咒
            case maglv div 4 of
              1: begin
                  if target <> nil then begin
                    meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                    meff.MagExplosionBase := 710;
                    meff.TargetActor := aowner;
                    meff.NextFrameTime := 85;
                    meff.ExplosionFrame := 14;
                    meff.light := 3;
                    boFly := True;
                    meff.ImgLib := wimg;
                    meff.TargetRx := tx;
                    meff.TargetRy := ty;
                    if meff.TargetActor <> nil then begin
                      meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
                      meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
                    end;
                    meff.ImgLib := g_WMagic9Images;
                    meff.MagOwner := aowner;
                    m_EffectList.Add(meff);
                  end;
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 690;
                  meff.TargetActor := target;
                  meff.NextFrameTime := 70;
                  meff.ExplosionFrame := 20;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic9Images;
                end;
              2: begin
                  if target <> nil then begin
                    meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                    meff.MagExplosionBase := 860;
                    meff.TargetActor := aowner;
                    meff.NextFrameTime := 85;
                    meff.ExplosionFrame := 14;
                    meff.light := 3;
                    boFly := True;
                    meff.ImgLib := wimg;
                    meff.TargetRx := tx;
                    meff.TargetRy := ty;
                    if meff.TargetActor <> nil then begin
                      meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
                      meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
                    end;
                    meff.ImgLib := g_WMagic9Images;
                    meff.MagOwner := aowner;
                    m_EffectList.Add(meff);
                  end;
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 840;
                  meff.TargetActor := target;
                  meff.NextFrameTime := 70;
                  meff.ExplosionFrame := 20;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic9Images;
                end;
              3: begin
                  if target <> nil then begin
                    meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                    meff.MagExplosionBase := 1010;
                    meff.TargetActor := aowner;
                    meff.NextFrameTime := 85;
                    meff.ExplosionFrame := 14;
                    meff.light := 3;
                    boFly := True;
                    meff.ImgLib := wimg;
                    meff.TargetRx := tx;
                    meff.TargetRy := ty;
                    if meff.TargetActor <> nil then begin
                      meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
                      meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
                    end;
                    meff.ImgLib := g_WMagic9Images;
                    meff.MagOwner := aowner;
                    m_EffectList.Add(meff);
                  end;
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 990;
                  meff.TargetActor := target;
                  meff.NextFrameTime := 70;
                  meff.ExplosionFrame := 20;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic9Images;
                end;

            else begin
                if target <> nil then begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 1090;
                  meff.TargetActor := aowner;
                  meff.NextFrameTime := 85;
                  meff.ExplosionFrame := 10;
                  meff.light := 3;
                  boFly := True;
                  meff.ImgLib := wimg;
                  meff.TargetRx := tx;
                  meff.TargetRy := ty;
                  if meff.TargetActor <> nil then begin
                    meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
                    meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
                  end;
                  meff.MagOwner := aowner;
                  m_EffectList.Add(meff);
                end;
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                meff.MagExplosionBase := 1060;
                meff.TargetActor := target;
                meff.NextFrameTime := 85;
                meff.ExplosionFrame := 20;
                meff.light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          end;
        49: begin                       //骷髅咒
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 1110;
            meff.TargetActor := nil;    //target;
            meff.NextFrameTime := 120;
            meff.ExplosionFrame := 10;
            meff.light := 3;
            if wimg <> nil then
              meff.ImgLib := wimg;
          end;
        51: begin                       //流星火雨
            case maglv div 4 of
              1: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 530;
                  meff.TargetActor := nil;
                  meff.NextFrameTime := 60;
                  meff.ExplosionFrame := 30;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic9Images;
                end;
              2: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 560;
                  meff.TargetActor := nil;
                  meff.NextFrameTime := 60;
                  meff.ExplosionFrame := 30;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic9Images;
                end;
              3: begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 590;
                  meff.TargetActor := nil;
                  meff.NextFrameTime := 60;
                  meff.ExplosionFrame := 30;
                  meff.light := 3;
                  meff.ImgLib := g_WMagic9Images;
                end;
            else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                meff.MagExplosionBase := 650;
                meff.TargetActor := nil;
                meff.NextFrameTime := 60;
                meff.ExplosionFrame := 30;
                meff.light := 3;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            end;
          end;
        112: begin
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            if meff.Dir16 in [1..8] then
              meff.MagExplosionBase := 4020
            else
              meff.MagExplosionBase := 4030;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 10;
            meff.light := 3;
            meff.ImgLib := g_CboEffect;
          end;
        116: begin
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 2060 + (meff.Dir16 div 2) * 10;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 6 + 10;
            meff.light := 3;
            meff.ImgLib := g_WMagic8Images2;
            meff.m_nMagEffectNo := Magnumb;
            meff.MagOwner := aowner;
          end;
        117: begin
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 2200 + (meff.Dir16 div 2) * 20;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 13;
            meff.light := 3;
            meff.ImgLib := g_WMagic8Images2;
            meff.m_nMagEffectNo := Magnumb;
            meff.MagOwner := aowner;
          end;
        106: begin
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 3150;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 8;
            meff.light := 3;
            meff.ImgLib := g_CboEffect;
          end;
        125: begin                      //冰霜群雨
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 80;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 17;
            meff.light := 3;
            meff.ImgLib := g_WMagic10Images;
            if (meff <> nil) then begin
              meff.TargetRx := tx;
              meff.TargetRy := ty;
              meff.MagOwner := aowner;
              m_EffectList.Add(meff);
            end;

            ScreenXYfromMCXY(tx - 2, ty - 3, sctx, scty);
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 80;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 17;
            meff.light := 3;
            meff.ImgLib := g_WMagic10Images;
            if (meff <> nil) then begin
              meff.TargetRx := tx - 2;
              meff.TargetRy := ty - 3;
              meff.MagOwner := aowner;
              m_EffectList.Add(meff);
            end;

            ScreenXYfromMCXY(tx + 2, ty - 3, sctx, scty);
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 80;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 17;
            meff.light := 3;
            meff.ImgLib := g_WMagic10Images;
            if (meff <> nil) then begin
              meff.TargetRx := tx + 2;
              meff.TargetRy := ty - 3;
              meff.MagOwner := aowner;
              m_EffectList.Add(meff);
            end;

            ScreenXYfromMCXY(tx + 2, ty + 3, sctx, scty);
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 80;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 17;
            meff.light := 3;
            meff.ImgLib := g_WMagic10Images;
            if (meff <> nil) then begin
              meff.TargetRx := tx + 2;
              meff.TargetRy := ty + 3;
              meff.MagOwner := aowner;
              m_EffectList.Add(meff);
            end;

            ScreenXYfromMCXY(tx - 2, ty + 3, sctx, scty);
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 80;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 17;
            meff.light := 3;
            meff.ImgLib := g_WMagic10Images;
            if (meff <> nil) then begin
              meff.TargetRx := tx - 2;
              meff.TargetRy := ty + 3;
              meff.MagOwner := aowner;
              m_EffectList.Add(meff);
            end;
            Exit;
          end;
        127: begin                      //死亡之眼
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
            meff.MagExplosionBase := 30;
            meff.TargetActor := nil;
            meff.NextFrameTime := 80;
            meff.ExplosionFrame := 21;
            meff.light := 4;
            meff.ImgLib := g_WMagic10Images;
            if (meff <> nil) then begin
              meff.TargetRx := tx;
              meff.TargetRy := ty;
              meff.MagOwner := aowner;
              m_EffectList.Add(meff);
            end;
            Exit;
          end;
      else begin                        //默认
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
        end;
      end;
    mtFireWind: begin
        meff := nil;
        {if Magnumb = 15 then begin

        end;}
      end;
    mtFireGun: meff := TFireGunEffect.Create(930, scx, scy, sctx, scty);
    mtThunder: begin
        case Magnumb of
          61: begin                     //劈星斩
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
              meff.MagExplosionBase := 495;
              meff.TargetActor := nil;
              meff.NextFrameTime := 90;
              meff.ExplosionFrame := 24;
              meff.light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          62: begin                     //雷霆一击
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
              meff.MagExplosionBase := 390;
              meff.TargetActor := nil;
              meff.NextFrameTime := 90;
              meff.ExplosionFrame := 25;
              meff.light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          64: begin                     //末日审判
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
              meff.MagExplosionBase := 230;
              meff.TargetActor := nil;
              meff.NextFrameTime := 90;
              meff.ExplosionFrame := 27;
              meff.light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          65: begin                     //火龙气焰
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
              meff.MagExplosionBase := 560;
              meff.TargetActor := nil;
              meff.NextFrameTime := 90;
              meff.ExplosionFrame := 37;
              meff.light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          MAGIC_FOX_THUNDER: begin
              meff := TThuderEffectEx.Create(780, sctx, scty, nil, Magnumb);
              meff.ExplosionFrame := 9;
              meff.ImgLib := g_WMon33Img;
              meff.NextFrameTime := 80;
            end;
          MAGIC_FOX_FIRE1: begin
              meff := TThuderEffectEx.Create(790, sctx, scty, nil, Magnumb);
              meff.ExplosionFrame := 10;
              meff.ImgLib := g_WMon33Img;
              meff.NextFrameTime := 90;
            end;
          MAGIC_SOULBALL_ATT2: begin
              meff := TThuderEffectEx.Create(2120 + 1230, sctx, scty, nil, Magnumb);
              meff.ExplosionFrame := 20;
              meff.ImgLib := g_WMon33Img;
              meff.NextFrameTime := 100;
            end;
          MAGIC_SOULBALL_ATT3_1: begin
              meff := TThuderEffectEx.Create(2160 + 1230, sctx, scty, nil, Magnumb);
              meff.ExplosionFrame := 20;
              meff.ImgLib := g_WMon33Img;
              meff.NextFrameTime := 100;
              meff.light := 1;
            end;
          MAGIC_SOULBALL_ATT3_2: begin
              meff := TThuderEffectEx.Create(2180 + 1230, sctx, scty, nil, Magnumb);
              meff.ExplosionFrame := 20;
              meff.ImgLib := g_WMon33Img;
              meff.NextFrameTime := 100;
              meff.light := 1;
            end;
          MAGIC_SOULBALL_ATT3_3: begin
              meff := TThuderEffectEx.Create(2200 + 1230, sctx, scty, nil, Magnumb);
              meff.ExplosionFrame := 20;
              meff.ImgLib := g_WMon33Img;
              meff.NextFrameTime := 100;
              meff.light := 1;
            end;
          MAGIC_SOULBALL_ATT3_4: begin
              meff := TThuderEffectEx.Create(2220 + 1230, sctx, scty, nil, Magnumb);
              meff.ExplosionFrame := 20;
              meff.ImgLib := g_WMon33Img;
              meff.NextFrameTime := 100;
              meff.light := 1;
            end;
          MAGIC_SOULBALL_ATT3_5: begin
              meff := TThuderEffectEx.Create(2240 + 1230, sctx, scty, nil, Magnumb);
              meff.ExplosionFrame := 20;
              meff.ImgLib := g_WMon33Img;
              meff.NextFrameTime := 100;
              meff.light := 1;
            end;
        else begin
            case maglv div 4 of
              1: begin
                  meff := TThuderEffect.Create(210, sctx, scty, nil);
                  meff.ExplosionFrame := 5;
                  meff.NextFrameTime := 80;
                  meff.ImgLib := g_WMagic7Images;
                end;
              2: begin
                  meff := TThuderEffect.Create(230, sctx, scty, nil);
                  meff.ExplosionFrame := 5;
                  meff.NextFrameTime := 80;
                  meff.ImgLib := g_WMagic7Images;
                end;
              3: begin
                  meff := TThuderEffect.Create(250, sctx, scty, nil);
                  meff.ExplosionFrame := 7;
                  meff.NextFrameTime := 80;
                  meff.ImgLib := g_WMagic7Images;
                end;
            else begin
                meff := TThuderEffect.Create(10, sctx, scty, nil);
                meff.ExplosionFrame := 6;
                meff.ImgLib := g_WMagic2Images;
              end;
            end;
          end;
        end;
      end;
    mtRedThunder: begin
        meff := TRedThunderEffect.Create(230, sctx, scty, nil);
        //meff.ExplosionFrame := 6;
      end;
    mtRedGroundThunder: begin
        meff := TRedGroundThunderEffect.Create(400, sctx, scty, nil);
        //meff.ExplosionFrame := 5;
      end;
    mtSpurt: begin
        meff := TSpurtEffect.Create(470, sctx, scty, nil);
        //meff.ExplosionFrame := 10;
      end;
    mtLava: meff := TLavaEffect.Create(440, sctx, scty, nil);
    mtLightingThunder: begin
        case maglv div 4 of
          1: meff := TLightingThunder.Create(1100, scx, scy, sctx, scty, target);
          2: meff := TLightingThunder.Create(1270, scx, scy, sctx, scty, target);
          3: meff := TLightingThunder.Create(1440, scx, scy, sctx, scty, target);
        else
          meff := TLightingThunder.Create(970, scx, scy, sctx, scty, target);
        end;
        if maglv > 3 then
          meff.ImgLib := g_WMagic7Images;
      end;
    mtExploBujauk: begin
        case Magnumb of
          MAGIC_FOX_FIRE2: begin
              meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target, True, Magnumb);
              meff.MagExplosionBase := 1320;
              meff.ExplosionFrame := 10;
            end;
          MAGIC_FOX_CURSE: begin
              meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target, True, Magnumb);
              meff.MagExplosionBase := 1330;
              meff.ExplosionFrame := 20;
            end;
          10: begin                     //灵魂火符
              case maglv div 4 of
                1: begin
                    meff := TExploBujaukEffect.Create(600, scx, scy, sctx, scty, target, False, 10);
                    meff.frame := 6;
                    meff.EffectBase2 := 770;
                    meff.MagExplosionBase := 1620;
                    meff.NextFrameTime := 100;
                    meff.ExplosionFrame := 6;
                    meff.light := 3;
                    meff.ImgLib := g_WMagic8Images;
                  end;
                2: begin
                    meff := TExploBujaukEffect.Create(940, scx, scy, sctx, scty, target, False, 10);
                    meff.frame := 6;
                    meff.EffectBase2 := 1110;
                    meff.MagExplosionBase := 1630;
                    meff.NextFrameTime := 100;
                    meff.ExplosionFrame := 6;
                    meff.light := 3;
                    meff.ImgLib := g_WMagic8Images;
                  end;
                3: begin
                    meff := TExploBujaukEffect.Create(1280, scx, scy, sctx, scty, target, False, 10);
                    meff.frame := 6;
                    meff.EffectBase2 := 1450;
                    meff.MagExplosionBase := 1640;
                    meff.NextFrameTime := 100;
                    meff.ExplosionFrame := 6;
                    meff.light := 3;
                    meff.ImgLib := g_WMagic8Images;
                  end;
              else begin
                  meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target);
                  meff.MagExplosionBase := 1360;
                end;
              end;
            end;
          17: begin
              meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target);
              meff.MagExplosionBase := 1540;
            end;
          104: begin
              meff := TExploBujaukEffect.Create(2420, scx, scy, sctx, scty, target, True);
              meff.frame := 3;
              meff.MagExplosionBase := 2580;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 8;
              meff.light := 3;
              meff.ImgLib := g_CboEffect;
            end;
          105: begin
              meff := TExploBujaukEffect.Create(4230, scx, scy, sctx, scty, target, True, 105 {112});
              meff.frame := 4;
              meff.MagExplosionBase := 4240;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 7;
              meff.light := 3;
              meff.ImgLib := g_CboEffect;
            end;
          107: begin
              meff := TExploBujaukEffect.Create(2610, scx, scy, sctx, scty, target, True);
              meff.frame := 5;
              meff.MagExplosionBase := 2770;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 25;
              meff.light := 3;
              meff.ImgLib := g_CboEffect;
            end;
          108: begin
              meff := TExploBujaukEffect.Create(3580, scx, scy, sctx, scty, target, False, 108);
              meff.frame := 5;
              meff.EffectBase2 := 3660;
              meff.MagExplosionBase := 3740;
              meff.TargetActor := target;
              meff.NextFrameTime := 110;
              meff.ExplosionFrame := 10;
              meff.light := 3;
              meff.ImgLib := g_CboEffect;
              meff.Repetition := False;
            end;
          109: begin
              meff := TExploBujaukEffect.Create(2090, scx, scy, sctx, scty, target, True);
              meff.frame := 3;
              meff.MagExplosionBase := 2251;
              meff.TargetActor := target;
              meff.NextFrameTime := 60;
              meff.ExplosionFrame := 4;
              meff.light := 3;
              meff.ImgLib := g_CboEffect;
            end;
          110: begin
              meff := TExploBujaukEffect.Create(3400, scx, scy, sctx, scty, target, False, 110);
              meff.frame := 5;
              meff.EffectBase2 := 3240;
              meff.MagExplosionBase := 3560;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 6;
              meff.light := 3;
              meff.ImgLib := g_CboEffect;
            end;
          111: begin
              meff := TExploBujaukEffect.Create(2820, scx, scy, sctx, scty, target, True, 111);
              meff.frame := 5;
              meff.MagExplosionBase := 2980;
              meff.TargetActor := target;
              meff.NextFrameTime := 100;
              meff.ExplosionFrame := 6;
              meff.light := 3;
              meff.ImgLib := g_CboEffect;
              meff.Repetition := False;
            end;
          0075: begin
              meff := TExploBujaukEffect.Create(10, scx, scy, sctx, scty, target, True, 0075);
              meff.nStdX := g_MySelf.m_nRx;
              meff.nStdY := g_MySelf.m_nRy;
              meff.frame := 10;
              meff.TargetActor := nil;
              meff.NextFrameTime := 80;
              meff.light := 3;
              meff.ImgLib := g_WMagic5Images;
              meff.MagExplosionBase := 220;
              meff.ExplosionFrame := 10;
              meff.ExplosionImgLib := g_WMagic10Images;
              meff.Repetition := False;
            end;
        end;
        boFly := True;
      end;
    mtBujaukGroundEffect: begin
        case Magnumb of
          11: begin
              meff := TBujaukGroundEffect.Create(1160, Magnumb, scx, scy, sctx, scty, maglv);
              meff.ExplosionFrame := 16;
              if maglv > 3 then
                meff.ExplosionFrame := 20;
            end;
          12: begin
              meff := TBujaukGroundEffect.Create(1160, Magnumb, scx, scy, sctx, scty, maglv);
              meff.ExplosionFrame := 16;
              if maglv > 3 then
                meff.ExplosionFrame := 20;
            end;

          46: begin
              meff := TBujaukGroundEffect.Create(1160, Magnumb, scx, scy, sctx, scty);
              meff.ExplosionFrame := 24;
            end;
          74: begin                     //
              meff := TBujaukGroundEffect.Create(10, Magnumb, scx, scy, sctx, scty);
              meff.ExplosionFrame := 10;
              meff.NextFrameTime := 80;
              meff.ImgLib := g_WMagic5Images;
            end;
        end;
        boFly := True;
      end;
    mtKyulKai: meff := nil;             //TKyulKai.Create (1380, scx, scy, sctx, scty);
    mtFlyBug: ;
    mtGroundEffect: begin
        meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
        if meff <> nil then begin
          case Magnumb of
            32: begin
                meff.ImgLib := g_WMon21Img;
                meff.MagExplosionBase := 3580;
                meff.TargetActor := target;
                meff.light := 3;
                meff.NextFrameTime := 20;
              end;
            33: begin
                meff.ImgLib := g_WMon24Img;
                meff.MagExplosionBase := 3730;
                meff.TargetActor := target;
                meff.light := 3;
                meff.NextFrameTime := 120;
              end;
            37: begin
                meff.ImgLib := g_WMon22Img;
                meff.MagExplosionBase := 3520;
                meff.TargetActor := target;
                meff.light := 5;
                meff.NextFrameTime := 20;
              end;
            MAGIC_SIDESTONE_ATT1: begin
                meff.ImgLib := g_WMon33Img;
                meff.MagExplosionBase := 2670;
                meff.TargetActor := target;
                meff.light := 4;
                meff.ExplosionFrame := 10;
                meff.NextFrameTime := 150;
              end;
            MAGIC_SOULBALL_ATT1: begin
                meff.ImgLib := g_WMon33Img;
                meff.MagExplosionBase := 2140 + 1230;
                meff.TargetActor := target;
                meff.light := 5;
                meff.ExplosionFrame := 20;
              end;
          end;
        end;
      end;
    mtThuderEx: begin
        case Magnumb of
          34: begin                     //灭天火
              case maglv div 4 of
                1: begin
                    meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                    meff.MagExplosionBase := 380;
                    meff.TargetActor := nil;
                    meff.NextFrameTime := 100;
                    meff.ExplosionFrame := 9;
                    meff.light := 3;
                    meff.ImgLib := g_WMagic9Images;
                  end;
                2: begin
                    meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                    meff.MagExplosionBase := 390;
                    meff.TargetActor := nil; //target;
                    meff.NextFrameTime := 100;
                    meff.ExplosionFrame := 9;
                    meff.light := 3;
                    meff.ImgLib := g_WMagic9Images;
                  end;
                3: begin
                    meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                    meff.MagExplosionBase := 400;
                    meff.TargetActor := nil; //target;
                    meff.NextFrameTime := 100;
                    meff.ExplosionFrame := 9;
                    meff.light := 3;
                    meff.ImgLib := g_WMagic9Images;
                  end;
              else begin
                  meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
                  meff.MagExplosionBase := 140;
                  meff.TargetActor := nil; //target;
                  meff.NextFrameTime := 100;
                  meff.ExplosionFrame := 20;
                  meff.light := 3;
                  if wimg <> nil then
                    meff.ImgLib := wimg;
                end;
              end;
            end;
        end;
      end;
    mtFireBall: begin
        meff := TFlyingBug.Create(magid, effnum, scx, scy, sctx, scty, Mtype, Recusion, anitime);
        meff.TargetActor := target;
        boFly := True;
      end;
    mtFlyBolt: begin

      end;
  end;

  if (meff <> nil) then begin
    meff.TargetRx := tx;
    meff.TargetRy := ty;
    if meff.TargetActor <> nil then begin
      meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
      meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
    end;
    meff.MagOwner := aowner;
    m_EffectList.Add(meff);
  end;
end;

procedure TPlayScene.DelMagic(magid: Integer);
var
  i                         : Integer;
begin
  for i := 0 to m_EffectList.Count - 1 do begin
    if TMagicEff(m_EffectList[i]).ServerMagicId = magid then begin
      TMagicEff(m_EffectList[i]).Free;
      m_EffectList.Delete(i);
      Break;
    end;
  end;
end;

function TPlayScene.NewFlyObject(aowner: TActor; cx, cy, tx, ty, TargetCode: Integer; Mtype: TMagicType): TMagicEff;
var
  i, scx, scy, sctx, scty   : Integer;
  meff                      : TMagicEff;
begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  case Mtype of
    mtFlyArrow: meff := TFlyingArrow.Create(1, 1, scx, scy, sctx, scty, Mtype, True, 0);
    mtFlyBug: meff := TFlyingFireBall.Create(1, 1, scx, scy, sctx, scty, Mtype, True, 0);
    mtFireBall: meff := TFlyingBug.Create(1, 1, scx, scy, sctx, scty, Mtype, True, 0);
  else meff := TFlyingAxe.Create(1, 1, scx, scy, sctx, scty, Mtype, True, 0);
  end;
  meff.TargetRx := tx;
  meff.TargetRy := ty;
  meff.TargetActor := FindActor(TargetCode);
  meff.MagOwner := aowner;
  m_FlyList.Add(meff);
  Result := meff;
end;

procedure TPlayScene.ScreenXYfromMCXY(cx, cy: Integer; var sX, sY: Integer);
begin
  if g_MySelf = nil then Exit;

  sX := (cx - g_MySelf.m_nRx) * UNITX - g_MySelf.m_nShiftX + SCREENWIDTH div 2;
  sY := (cy - g_MySelf.m_nRy) * UNITY - g_MySelf.m_nShiftY + ShiftYOffset;

end;

procedure TPlayScene.CXYfromMouseXY(mx, my: Integer; var ccx, ccy: Integer);
begin
  if g_MySelf = nil then Exit;

  ccx := Round((mx - SCREENWIDTH div 2 + g_MySelf.m_nShiftX) / UNITX) + g_MySelf.m_nRx;
  ccy := Round((my - ShiftYOffset + g_MySelf.m_nShiftY) / UNITY) + g_MySelf.m_nRy;

end;

function TPlayScene.GetCharacter(X, Y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
var
  k, i, ccx, ccy, dx, dy    : Integer;
  a                         : TActor;
begin
  Result := nil;
  nowsel := -1;
  CXYfromMouseXY(X, Y, ccx, ccy);
  for k := ccy + 8 downto ccy - 1 do begin
    for i := m_ActorList.Count - 1 downto 0 do
      if TActor(m_ActorList[i]) <> g_MySelf then begin
        a := TActor(m_ActorList[i]);
        if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) and (a.m_boVisible) then begin
          if a.m_nCurrY = k then begin
            dx := (a.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
            dy := (a.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
            if a.CheckSelect(X - dx, Y - dy) then begin
              Result := a;
              Inc(nowsel);
              if nowsel >= wantsel then
                Exit;
            end;
          end;
        end;
      end;
  end;
end;

//取得鼠标所指坐标的角色

function TPlayScene.GetAttackFocusCharacter(X, Y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
var
  k, i, ccx, ccy, dx, dy, centx, centy: Integer;
  a                         : TActor;
begin
  Result := GetCharacter(X, Y, wantsel, nowsel, liveonly);
  if Result = nil then begin
    nowsel := -1;
    CXYfromMouseXY(X, Y, ccx, ccy);
    for k := ccy + 8 downto ccy - 1 do begin
      for i := m_ActorList.Count - 1 downto 0 do
        if TActor(m_ActorList[i]) <> g_MySelf then begin
          a := TActor(m_ActorList[i]);
          if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) and (a.m_boVisible) then begin
            if a.m_nCurrY = k then begin
              dx := (a.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
              dy := (a.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
              if a.CharWidth > 40 then
                centx := (a.CharWidth - 40) div 2
              else
                centx := 0;

              if a.CharHeight > 70 then
                centy := (a.CharHeight - 70) div 2
              else
                centy := 0;

              if (X - dx >= centx) and (X - dx <= a.CharWidth - centx) and (Y - dy >= centy) and (Y - dy <= a.CharHeight - centy) then begin
                Result := a;
                Inc(nowsel);
                if nowsel >= wantsel then
                  Exit;
              end;
            end;
          end;
        end;
    end;
  end;
end;

function TPlayScene.IsSelectMyself(X, Y: Integer): Boolean;
var
  k, i, ccx, ccy, dx, dy    : Integer;
begin
  Result := False;
  CXYfromMouseXY(X, Y, ccx, ccy);
  for k := ccy + 2 downto ccy - 1 do begin
    if g_MySelf.m_nCurrY = k then begin
      dx := (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + g_MySelf.m_nPx + g_MySelf.m_nShiftX;
      dy := (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + g_MySelf.m_nPy + g_MySelf.m_nShiftY;
      if g_MySelf.CheckSelect(X - dx, Y - dy) then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TPlayScene.GetDropItems(X, Y: Integer; var inames: string): pTDropItem; //拳搁谅钎肺 酒捞袍
var
  k, i, ccx, ccy, ssx, ssy, dx, dy: Integer;
  DropItem                  : pTDropItem;
  S                         : TDXTexture;
  c                         : byte;
begin
  Result := nil;
  CXYfromMouseXY(X, Y, ccx, ccy);
  ScreenXYfromMCXY(ccx, ccy, ssx, ssy);
  dx := X - ssx;
  dy := Y - ssy;
  inames := '';
  for i := 0 to g_DropedItemList.Count - 1 do begin
    DropItem := pTDropItem(g_DropedItemList[i]);
    if (DropItem.X = ccx) and (DropItem.Y = ccy) then begin
      if Result = nil then Result := DropItem;
      inames := inames + DropItem.Name + '\';
    end;
  end;
end;

procedure TPlayScene.GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
var
  i                         : Integer;
  DropItem                  : pTDropItem;
begin
  for i := 0 to g_DropedItemList.Count - 1 do begin
    DropItem := g_DropedItemList[i];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      ItemList.Add(DropItem);
    end;
  end;
end;

function TPlayScene.GetXYDropItems(nX, nY: Integer): pTDropItem;
var
  i                         : Integer;
  DropItem                  : pTDropItem;
begin
  Result := nil;
  for i := 0 to g_DropedItemList.Count - 1 do begin
    DropItem := g_DropedItemList[i];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      Result := DropItem;
      //if not g_gcGeneral[7] or DropItem.boShowName then
      //  Break;
      if g_boPickUpAll or {not g_gcGeneral[7] or} DropItem.boPickUp then
        Break;
    end;
  end;
end;

function TPlayScene.CanRun(sX, sY, ex, ey: Integer): Boolean;
var
  ndir, rx, ry              : Integer;
begin
  ndir := GetNextDirection(sX, sY, ex, ey);
  rx := sX;
  ry := sY;
  GetNextPosXY(ndir, rx, ry);

  {if Map.CanMove(rx, ry) and Map.CanMove(ex, ey) then
    Result := True
  else begin
    Result := False;
  end;}

  if CanWalkEx(rx, ry) and CanWalkEx(ex, ey) then
    Result := True
  else
    Result := False;
end;

function TPlayScene.CanWalkEx(mx, my: Integer): Boolean;
begin
  Result := False;
  if Map.CanMove(mx, my) then
    Result := not CrashManEx(mx, my);
end;

function TPlayScene.CrashManEx(mx, my: Integer): Boolean;
var
  i                         : Integer;
  Actor                     : TActor;
begin
  Result := False;
  for i := 0 to m_ActorList.Count - 1 do begin
    Actor := TActor(m_ActorList[i]);
    if Actor = g_MySelf then Continue;
    if (Actor.m_boVisible) and (Actor.m_boHoldPlace) and (not Actor.m_boDeath) and (Actor.m_nCurrX = mx) and (Actor.m_nCurrY = my) then begin
      if (g_MySelf.m_nTagX = 0) and (g_MySelf.m_nTagY = 0) then begin
        if (Actor.m_btRace = RCC_USERHUMAN) and (g_boCanRunHuman or g_boCanRunSafeZone) then Continue;
        if (Actor.m_btRace = RCC_MERCHANT) and g_boCanRunNpc then Continue;
        if ((Actor.m_btRace > RCC_USERHUMAN) and (Actor.m_btRace <> RCC_MERCHANT)) and (g_boCanRunMon or g_boCanRunSafeZone) then Continue;
      end;
      Result := True;
      Break;
    end;
  end;
end;

function TPlayScene.CanWalk(mx, my: Integer): Boolean;
begin
  Result := False;
  if Map.CanMove(mx, my) then
    Result := not CrashMan(mx, my);
end;

function TPlayScene.CrashMan(mx, my: Integer): Boolean;
var
  i                         : Integer;
  a                         : TActor;
begin
  Result := False;
  for i := 0 to m_ActorList.Count - 1 do begin
    a := TActor(m_ActorList[i]);
    if a = g_MySelf then Continue;
    if (a.m_boVisible) and (a.m_boHoldPlace) and (not a.m_boDeath) and (a.m_nCurrX = mx) and (a.m_nCurrY = my) then begin
      Result := True;
      Break;
    end;
  end;
end;

{function TPlayScene.CrashManPath(mx, my: Integer): Boolean;
var
  i                         : Integer;
  a                         : TActor;
begin
  Result := False;
  for i := 0 to m_ActorList.count - 1 do begin
    a := TActor(m_ActorList[i]);
    if a = g_MySelf then Continue;
    if (a.m_boVisible) and (a.m_boHoldPlace) and (not a.m_boDeath) and (a.m_nCurrX = mx) and (a.m_nCurrY = my) then begin
      Result := True;
      Break;
    end;
  end;
end; }

function TPlayScene.CanFly(mx, my: Integer): Boolean;
begin
  Result := Map.CanFly(mx, my);
end;

{------------------------ Actor ------------------------}

function TPlayScene.FindActor(id: Integer): TActor;
var
  i                         : Integer;
begin
  Result := nil;
  if id = 0 then
    Exit;
  for i := 0 to m_ActorList.Count - 1 do begin
    if TActor(m_ActorList[i]).m_nRecogId = id then begin
      Result := TActor(m_ActorList[i]);
      Break;
    end;
  end;
end;

function TPlayScene.FindActor(sName: string): TActor;
var
  i                         : Integer;
  Actor                     : TActor;
begin
  Result := nil;
  for i := 0 to m_ActorList.Count - 1 do begin
    Actor := TActor(m_ActorList[i]);
    if CompareText(Actor.m_sUserName, sName) = 0 then begin
      Result := Actor;
      Break;
    end;
  end;
end;

function TPlayScene.FindActorXY(X, Y: Integer): TActor;
var
  i                         : Integer;
  a                         : TActor;
begin
  Result := nil;
  for i := 0 to m_ActorList.Count - 1 do begin
    a := TActor(m_ActorList[i]);
    if (a.m_nCurrX = X) and (a.m_nCurrY = Y) then begin
      Result := a;
      if not Result.m_boDeath and Result.m_boVisible and Result.m_boHoldPlace then
        Break;
    end;
  end;
end;

function TPlayScene.IsValidActor(Actor: TActor): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  for i := 0 to m_ActorList.Count - 1 do begin
    if TActor(m_ActorList[i]) = Actor then begin
      Result := True;
      Break;
    end;
  end;
end;

function TPlayScene.NewActor(chrid: Integer; cx: Word; cy: Word; cdir: Word; cfeature: Integer; {race, hair, dress, weapon} cstate: Integer): TActor;
var
  i                         : Integer;
  Actor                     : TActor;
begin
  Result := nil;
  for i := 0 to m_ActorList.Count - 1 do
    if TActor(m_ActorList[i]).m_nRecogId = chrid then begin
      Result := TActor(m_ActorList[i]);
      //if is my hero then ???
      Exit;
    end;
  if IsChangingFace(chrid) then Exit;
  case RACEfeature(cfeature) of
    0: Actor := THumActor.Create;       //人物
    9: Actor := TSoccerBall.Create;     //足球
    13: Actor := TKillingHerb.Create;   //食人花
    14: Actor := TSkeletonOma.Create;   //骷髅
    15: Actor := TDualAxeOma.Create;    //掷斧骷髅
    16: Actor := TGasKuDeGi.Create;     //洞蛆
    17: Actor := TCatMon.Create;        //钩爪猫
    18: Actor := THuSuABi.Create;       //稻草人
    19: Actor := TCatMon.Create;        //沃玛战士
    20: Actor := TFireCowFaceMon.Create; //火焰沃玛
    21: Actor := TCowFaceKing.Create;   //沃玛教主
    22: Actor := TDualAxeOma.Create;    //黑暗战士
    23: Actor := TWhiteSkeleton.Create; //变异骷髅
    24: Actor := TSuperiorGuard.Create; //带刀卫士
    25: Actor := TKingOfSculpureKingMon.Create;
    26: Actor := TKingOfSculpureKingMon.Create;
    27: Actor := TSnowMon.Create;
    28: Actor := TSnowMon.Create;
    29: Actor := TSnowMon.Create;

    30: Actor := TCatMon.Create;        //朝俺窿
    31: Actor := TCatMon.Create;        //角蝇
    32: Actor := TScorpionMon.Create;   //蝎子
    33: Actor := TCentipedeKingMon.Create; //触龙神
    34: Actor := TBigHeartMon.Create;   //赤月恶魔
    35: Actor := TSpiderHouseMon.Create; //幻影蜘蛛
    36: Actor := TExplosionSpider.Create; //月魔蜘蛛
    37: Actor := TFlyingSpider.Create;  //
    38: Actor := TSnowMon.Create;
    39: Actor := TSnowMon.Create;

    40: Actor := TZombiLighting.Create; //僵尸1
    41: Actor := TZombiDigOut.Create;   //僵尸2
    42: Actor := TZombiZilkin.Create;   //僵尸3
    43: Actor := TBeeQueen.Create;      //角蝇巢
    44: Actor := TSnowMon.Create;
    45: Actor := TArcherMon.Create;     //弓箭手
    46: Actor := TSnowMon.Create;
    47: Actor := TSculptureMon.Create;  //祖玛雕像
    48: Actor := TSculptureMon.Create;  //
    49: Actor := TSculptureKingMon.Create; //祖玛教主

    50: Actor := TNpcActor.Create;
    51: Actor := TSnowMon.Create;
    52: Actor := TGasKuDeGi.Create;     //楔蛾
    53: Actor := TGasKuDeGi.Create;     //粪虫
    54: Actor := TSmallElfMonster.Create; //神兽
    55: Actor := TWarriorElfMonster.Create; //神兽1
    56: Actor := TAngel.Create;
    57: Actor := TDualAxeOma.Create;    //1234
    58: Actor := TDualAxeOma.Create;    //1234

    60: Actor := TElectronicScolpionMon.Create;
    61: Actor := TBossPigMon.Create;
    62: Actor := TKingOfSculpureKingMon.Create;
    63: Actor := TSkeletonKingMon.Create;
    64: Actor := TGasKuDeGi.Create;
    65: Actor := TSamuraiMon.Create;
    66: Actor := TSkeletonSoldierMon.Create;
    67: Actor := TSkeletonSoldierMon.Create;
    68: Actor := TSkeletonSoldierMon.Create;
    69: Actor := TSkeletonArcherMon.Create;
    70: Actor := TBanyaGuardMon.Create;
    71: Actor := TBanyaGuardMon.Create;
    72: Actor := TBanyaGuardMon.Create;
    73: Actor := TPBOMA1Mon.Create;
    74: Actor := TCatMon.Create;
    75: Actor := TStoneMonster.Create;
    76: Actor := TSuperiorGuard.Create;
    77: Actor := TStoneMonster.Create;
    78: Actor := TBanyaGuardMon.Create;
    79: Actor := TPBOMA6Mon.Create;
    80: Actor := TMineMon.Create;
    81: Actor := TAngel.Create;
    83: Actor := TFireDragon.Create;
    84: Actor := TDragonStatue.Create;
    87: Actor := TDragonStatue.Create;

    90: Actor := TDragonBody.Create;    //龙

    91: Actor := TWhiteSkeleton.Create; //变异骷髅
    92: Actor := TWhiteSkeleton.Create; //变异骷髅
    93: Actor := TWhiteSkeleton.Create; //变异骷髅

    94: Actor := TWarriorElfMonster.Create; //神兽1
    95: Actor := TWarriorElfMonster.Create; //神兽1

    98: Actor := TWallStructure.Create; //LeftWall
    99: Actor := TCastleDoor.Create;    //MainDoor
    101: Actor := TBanyaGuardMon.Create;
    102: Actor := TKhazardMon.Create;
    103: Actor := TFrostTiger.Create;
    104: Actor := TRedThunderZuma.Create;
    105: Actor := TCrystalSpider.Create;
    106: Actor := TYimoogi.Create;
    109: Actor := TBlackFox.Create;
    110: Actor := TGreenCrystalSpider.Create;
    111: Actor := TBanyaGuardMon.Create; // TSpiderKing.Create;

    113: Actor := TBanyaGuardMon.Create;
    114: Actor := TBanyaGuardMon.Create;
    115: Actor := TBanyaGuardMon.Create;

    117, 118, 119: Actor := TBanyaGuardMon.Create;
    120: Actor := TFireDragon.Create;
    121: Actor := TTiger.Create;
    122: Actor := TDragon.Create;
    123: Actor := TGhostShipMonster.Create;
  else
    Actor := TActor.Create;
  end;

  with Actor do begin
    m_nRecogId := chrid;
    m_nCurrX := cx;
    m_nCurrY := cy;
    m_nRx := m_nCurrX;
    m_nRy := m_nCurrY;
    m_btDir := cdir;
    m_nFeature := cfeature;
    if g_boOpenAutoPlay and g_gcAss[6] then m_btAFilter := g_APMobList.indexof(Actor.m_sUserName) >= 0;
    m_btRace := RACEfeature(cfeature);
    m_btHair := HAIRfeature(cfeature);
    m_btDress := DRESSfeature(cfeature);
    m_btWeapon := WEAPONfeature(cfeature);
    m_wAppearance := APPRfeature(cfeature);
    //if (m_btRace = 50) and (m_wAppearance in [54..48]) then
    //  m_boVisible := False;

    m_Action := nil;                    //GetMonAction(m_wAppearance);
    if m_btRace = 0 then begin
      m_btSex := m_btDress mod 2;
      if m_btDress in [24..27] then m_btDress := 18 + m_btSex;
    end else begin
      m_btSex := 0;
    end;
    m_nState := cstate;
    m_SayingArr[0] := '';
  end;
  m_ActorList.Add(Actor);
  Result := Actor;
end;

procedure TPlayScene.ActorDied(Actor: TObject);
var
  i                         : Integer;
  flag                      : Boolean;
begin
  for i := 0 to m_ActorList.Count - 1 do
    if m_ActorList[i] = Actor then begin
      m_ActorList.Delete(i);
      Break;
    end;
  flag := False;
  for i := 0 to m_ActorList.Count - 1 do
    if not TActor(m_ActorList[i]).m_boDeath then begin
      m_ActorList.Insert(i, Actor);
      flag := True;
      Break;
    end;
  if not flag then m_ActorList.Add(Actor);
end;

procedure TPlayScene.SetActorDrawLevel(Actor: TObject; Level: Integer);
var
  i                         : Integer;
begin
  if Level = 0 then begin
    for i := 0 to m_ActorList.Count - 1 do
      if m_ActorList[i] = Actor then begin
        m_ActorList.Delete(i);
        m_ActorList.Insert(0, Actor);
        Break;
      end;
  end;
end;

(*procedure TPlayScene.ClearActors;
var
  i                         : Integer;
begin
  for i := 0 to g_FreeActorList.Count - 1 do
    TActor(g_FreeActorList[i]).Free;
  g_FreeActorList.Clear;

  for i := 0 to m_ActorList.Count - 1 do
    TActor(m_ActorList[i]).Free;
  m_ActorList.Clear;

  if g_MySelf  <> nil then begin
    g_MySelf.m_HeroObject := nil;
    g_MySelf.m_SlaveObject.Clear;       // := nil;
    g_MySelf := nil;
  end;

  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicTarget := nil;
  for i := 0 to m_EffectList.Count - 1 do
    TMagicEff(m_EffectList[i]).Free;
  m_EffectList.Clear;
  DScreen.ClearHint;
end;*)

//清除所有角色
procedure TPlayScene.ClearActors;
var
   i: integer;
begin
  try
    if m_ActorList.Count > 0 then begin
      for i:=0 to m_ActorList.Count-1 do
      TActor(m_ActorList.Items[i]).Free;
      m_ActorList.Clear;
    end;
    g_MySelf := nil;
    g_TargetCret := nil;
    g_FocusCret := nil;
    g_MagicTarget := nil;

   //清除魔法效果对象
    if m_EffectList.Count > 0 then begin
      for i:=0 to m_EffectList.Count-1 do
      TMagicEff(m_EffectList[i]).Free;
      m_EffectList.Clear;
    end;
  except
    DebugOutStr('TPlayScene.ClearActors');
  end;
end;

function TPlayScene.DeleteActor(id: Integer; boDeath: Boolean = False): TActor;
var
  i                         : Integer;
begin
  Result := nil;
  i := 0;
  while True do begin
    if i >= m_ActorList.Count then Break;
    if TActor(m_ActorList[i]).m_nRecogId = id then begin
      if g_TargetCret = TActor(m_ActorList[i]) then g_TargetCret := nil;
      if g_FocusCret = TActor(m_ActorList[i]) then g_FocusCret := nil;
      if g_MagicTarget = TActor(m_ActorList[i]) then g_MagicTarget := nil;
      if (TActor(m_ActorList[i]) = g_MySelf.m_HeroObject) then begin
        //TActor(m_ActorList[i]).m_boNotShowHealth := True;
        if not boDeath then
          Break;
      end;
      if IsMySlaveObject(TActor(m_ActorList[i])) then begin
        if not boDeath then
          Break;
      end;
      {if (TActor(m_ActorList[i]) = g_MySelf.m_SlaveObject) then begin
        //TActor(m_ActorList[i]).m_boNotShowHealth := True;
        if not boDeath then
          Break;
      end;}
      TActor(m_ActorList[i]).m_dwDeleteTime := GetTickCount;
      g_FreeActorList.Add(m_ActorList[i]);
      m_ActorList.Delete(i);
    end else
      Inc(i);
  end;
end;

procedure TPlayScene.DelActor(Actor: TObject);
var
  i                         : Integer;
begin
  for i := 0 to m_ActorList.Count - 1 do
    if m_ActorList[i] = Actor then begin
      TActor(m_ActorList[i]).m_dwDeleteTime := GetTickCount;
      g_FreeActorList.Add(m_ActorList[i]);
      m_ActorList.Delete(i);
      Break;
    end;
end;

function TPlayScene.ButchAnimal(X, Y: Integer): TActor;
var
  i                         : Integer;
  a                         : TActor;
begin
  Result := nil;
  for i := 0 to m_ActorList.Count - 1 do begin
    a := TActor(m_ActorList[i]);
    if a.m_boDeath {and (a.m_btRace <> 0)} then begin
      if (abs(a.m_nCurrX - X) <= 1) and (abs(a.m_nCurrY - Y) <= 1) then begin
        Result := a;
        Break;
      end;
    end;
  end;
end;

procedure TPlayScene.SendMsg(ident, chrid, X, Y, cdir, Feature, State: Integer; Str: string; IPInfo: Integer);
var
  Actor                     : TActor;
  i, Row                    : Integer;
  nstr                      : string;
  meff                      : TMagicEff;
  mbw                       : TMessageBodyW;
begin
  case ident of
    SM_CHANGEMAP, SM_NEWMAP: begin
        ProcMagic.nTargetX := -1;

        EventMan.ClearEvents;

        if not g_boDoFadeOut and not g_boDoFadeIn then begin //由暗变亮，切换地图。
          g_boDoFadeIn := True;
          g_nFadeIndex := 0;
        end;

        g_PathBusy := True;
        try
          if frmMain.TimerAutoMove.Enabled then begin
            frmMain.TimerAutoMove.Enabled := False;
            SetLength(g_MapPath, 0);
            g_MapPath := nil;
            DScreen.AddChatBoardString('地图跳转，停止自动移动', GetRGB(5), clWhite);
          end;

          if g_boOpenAutoPlay and frmMain.TimerAutoPlay.Enabled then begin
            frmMain.TimerAutoPlay.Enabled := False;
            g_gcAss[0] := False;
            SetLength(g_APMapPath, 0);
            SetLength(g_APMapPath2, 0);
            g_APStep := -1;
            g_APLastPoint.X := -1;
            DScreen.AddChatBoardString('[挂机] 地图跳转，停止自动挂机', clRed, clWhite);
          end;

          if (g_MySelf <> nil) then begin
            g_MySelf.m_nTagX := 0;
            g_MySelf.m_nTagY := 0;
          end;

          if Map.m_MapBuf <> nil then begin
            FreeMem(Map.m_MapBuf);
            Map.m_MapBuf := nil;
          end;
          if Length(Map.m_MapData) > 0 then begin
            SetLength(Map.m_MapData, 0);
            Map.m_MapData := nil;
          end;
        finally
          g_PathBusy := False;
        end;

        Map.LoadMap(Str, X, Y);
//{$IF VIEWFOG}
//        DarkLevel := cdir;
//{$ELSE}
//        DarkLevel := 0;
//{$IFEND VIEWFOG}
//        if g_boForceNotViewFog then
//          DarkLevel := 0;
//        if DarkLevel = 0 then
//          g_boViewFog := False
//        else
//          g_boViewFog := True;

        if (ident = SM_NEWMAP) and (g_MySelf <> nil) then begin
          g_MySelf.m_nCurrX := X;
          g_MySelf.m_nCurrY := Y;
          g_MySelf.m_nRx := X;
          g_MySelf.m_nRy := Y;
          DelActor(g_MySelf);
        end;
        if frmDlg.DWGameConfig.Visible and (frmDlg.DWGameConfig.tag = 5) then begin
          g_nApMiniMap := True;
          frmMain.SendWantMiniMap;
        end;
        if g_boViewMiniMap then begin
          g_nMiniMapIndex := -1;
          frmMain.SendWantMiniMap;
        end;
        //if Str <> Map.m_sCurrentMap then
        //  g_nLastMapMusic := -1;
      end;
    SM_LOGON: begin
        Actor := FindActor(chrid);
        if Actor = nil then begin
          Actor := NewActor(chrid, X, Y, Lobyte(cdir), Feature, State);
          Actor.m_nChrLight := Hibyte(cdir);
          cdir := Lobyte(cdir);
          Actor.SendMsg(SM_TURN, X, Y, cdir, Feature, State, '', 0);
        end;
        if g_MySelf <> nil then begin
          if g_MySelf.m_HeroObject <> nil then begin
            //g_MySelf.m_HeroObject.Free;
            g_MySelf.m_HeroObject := nil;
          end;
          g_MySelf.m_SlaveObject.Clear; // := nil;
          //g_MySelf.Free;
          g_MySelf := nil;
        end;
        g_MySelf := THumActor(Actor);
      end;
    SM_HIDE: begin
        Actor := FindActor(chrid);
        if Actor <> nil then begin
          if Actor.m_boDelActionAfterFinished then Exit;
          if Actor.m_nWaitForRecogId <> 0 then Exit;
          if Actor = g_MySelf.m_HeroObject then begin
            if not Actor.m_boDeath then Exit;
            DeleteActor(chrid, True);
            Exit;
          end;
          if IsMySlaveObject(Actor) then begin
            //if (Actor = g_MySelf.m_SlaveObject) then begin
            if (cdir <> 0) or Actor.m_boDeath then
              DeleteActor(chrid, True);
            Exit;
          end;
        end;
        DeleteActor(chrid);
      end;
  else begin
      Actor := FindActor(chrid);
      if (ident = SM_TURN) or
        (ident = SM_RUN) or
        (ident = SM_HORSERUN) or
        (ident = SM_WALK) or
        (ident = SM_BACKSTEP) or
        (ident = SM_DEATH) or
        (ident = SM_SKELETON) or
        (ident = SM_DIGUP) or
        (ident = SM_ALIVE) then begin
        if Actor = nil then
          Actor := NewActor(chrid, X, Y, Lobyte(cdir), Feature, State);
        if Actor <> nil then begin
          if IPInfo <> 0 then begin
            //Actor.m_nIPower := LoWord(IPInfo);
            Actor.m_nIPowerLvl := HiWord(IPInfo);
          end;
          Actor.m_nChrLight := Hibyte(cdir);
          cdir := Lobyte(cdir);
          if ident = SM_SKELETON then begin
            Actor.m_boDeath := True;
            Actor.m_boSkeleton := True;
          end;
          if ident = SM_DEATH then begin
            if Hibyte(cdir) <> 0 then
              Actor.m_boItemExplore := True;
          end;
        end;
      end;
      if Actor = nil then Exit;
      case ident of
        SM_FEATURECHANGED: begin
            Actor.m_nFeature := Feature;
            Actor.m_nFeatureEx := State;
            if Str <> '' then begin
              DecodeBuffer(Str, @mbw, SizeOf(mbw));
              Actor.m_btTitleIndex := LoWord(mbw.param1);
            end else begin
              Actor.m_btTitleIndex := 0;
            end;
            Actor.FeatureChanged;
          end;
        SM_APPRCHANGED: begin

          end;
        SM_CHARSTATUSCHANGED: begin
            Actor.m_nState := Feature;
            Actor.m_nHitSpeed := State;
            if Str = '1' then begin
              meff := TCharEffect.Create(1110, 10, Actor);
              meff.NextFrameTime := 80;
              meff.ImgLib := g_WMagic2Images;
              g_PlayScene.m_EffectList.Add(meff);
              //PlaySoundName('wav\M1-2.wav');
            end;
          end;
      else begin
          if ident = SM_TURN then begin
            if Str <> '' then begin
              Actor.m_sUserName := Str;
              Actor.m_sUserNameOffSet := g_DXCanvas.TextWidth(Actor.m_sUserName) div 2;

            end;
          end;
          Actor.SendMsg(ident, X, Y, cdir, Feature, State, '', 0);
        end;
      end;
    end;
  end;
end;

procedure TPlayScene.DropItemsShow; //显示物品名称  Development 2019-01-11
var
  i, k, mx, my, n           : Integer;
  D                         : pTDropItem;
  bcolor                    : TColor;
  dds                       : TDXTexture;
  S, Str                    : string;
begin
  if g_DropedItemList.Count <= 0 then Exit;
  for k := 0 to g_DropedItemList.Count - 1 do begin
    D := pTDropItem(g_DropedItemList[k]);

    if (D <> nil) then begin
      ScreenXYfromMCXY(D.X, D.Y, mx, my);
      if D.boNonSuch then begin
        g_EiImageDraw.TextOut(
          mx - ((Length(D.Name) shr 1) * 6) + 6,
          my - 23,
          clRed,

          D.Name);
      end else if (not g_gcGeneral[5] or D.boShowName) then begin
        ScreenXYfromMCXY(D.X, D.Y, mx, my);
        g_EiImageDraw.TextOut(
          mx - ((Length(D.Name) shr 1) * 6) + 6,
          my - 23,
          clSkyBlue,
          D.Name);
      end;
    end;

  end;


end;

end.


