unit PlayScn;

interface

uses
  Windows, Forms, Classes, SysUtils, StrUtils, Graphics, DirectX, HGE, HGEBase, HGECanvas, HGETextures,
  IntroScn, WIL, CShare, WMFile;

type


  TPlayScene = class(TScene)
  protected
    m_HGE:IHGE;
    m_nDefXX        :Integer;
    m_nDefYY        :Integer;
    m_nAniCount: Integer;
    m_dwAniTime: LongWord;
    m_boInitTile: Boolean;
    m_boCanDraw:Boolean;
  public
    m_MapSurface: TDXRenderTargetTexture;
    m_ObjSurface: TDXRenderTargetTexture;
  public
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure BeginScene();
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
  public
    procedure ReDrawMap;
    procedure DrawMapObj(boDrawObj:Boolean = True);
    procedure DrawTileMap;
    function CanDrawTileMap(): Boolean;
  end;

var
  g_PlayScene:TPlayScene;

implementation

uses
  ClMain, FState;

constructor TPlayScene.Create;
var
  Index: Integer;
begin
  m_HGE:= HGECreate(HGE_VERSION);
  m_boInitTile:= False;
  m_nDefXX:= 0;
  m_nDefYY:= 0;
  m_dwAniTime:= 0;
  m_nAniCount := 0;
  m_boCanDraw:= True;
end;

destructor TPlayScene.Destroy;
var
  Index: Integer;
begin
  CloseScene;
  m_MapSurface.Free;
  m_ObjSurface.Free;
end;

procedure TPlayScene.OpenScene;
var
  DXAccessInfo: TDXAccessInfo;

  WriteBuffer: PWord;
  Y, X:Integer;
  sMap:string;
begin
  sMap:= '0';
  X:= g_wRx;
  y:= g_wRY;

  g_LegendMap.LoadFileData(GetMapDirAndName(sMap));
  Map.LoadMap(sMap, X, Y);

  g_stMainScenes:= stPlayGame;
  m_HGE := HGECreate(HGE_VERSION);
  m_MapSurface := TDXRenderTargetTexture.Create(g_DXCanvas);
  m_MapSurface.Size := Point(DEFMAXSCREENWIDTH + UNITX * 10, DEFMAXSCREENHEIGHT + UNITY * 10);
  m_MapSurface.Active := True;
  if not m_MapSurface.Active then
    exit;

  m_ObjSurface := TDXRenderTargetTexture.Create(g_DXCanvas);
  m_ObjSurface.Size := Point(DEFMAXSCREENWIDTH, DEFMAXSCREENHEIGHT);
  m_ObjSurface.Active := True;
  if not m_ObjSurface.Active then
    exit;

end;

procedure TPlayScene.CloseScene;
begin

end;

function TPlayScene.CanDrawTileMap: Boolean;
begin
  Result := False;
  with Map do
    if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then
      Exit;
  Result := True;
end;

procedure TPlayScene.DrawTileMap;
var
  index, i, j, nY, nX, nImgNumber: Integer;        //新动态地图
  dsurface: TDirectDrawSurface;
begin
//  with Map do
//    if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then
//      Exit;
//
//  Map.m_OldClientRect := Map.m_ClientRect;

  //地图背景
  with Map.m_ClientRect do begin
    if g_FScreenHeight = 768 then nY := -UNITY * 1
    else nY := -UNITY * 4;

    for j := (Top - Map.m_nBlockTop - 1) to (Bottom - Map.m_nBlockTop + 1) do begin
      if g_FScreenWidth = 1024 then nX := AAX + 28 - UNITX * 2
      else nX := AAX + 14 - UNITX * 4;
      for i := (Left - Map.m_nBlockLeft - 2) to (Right - Map.m_nBlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          nImgNumber := (Map.m_MArr[i, j].wBkImg and $7FFF);
          if nImgNumber > 0 then begin
            if (i mod 2 = 0) and (j mod 2 = 0) then begin
              nImgNumber := nImgNumber - 1;
              Index:= Map.m_MArr[i, j].btBkIndex;
             dsurface := g_WTilesImages[Index].Images[nImgNumber];
              if dsurface <> nil then begin
                m_MapSurface.Draw(nX, nY, dsurface.ClientRect, dsurface, FALSE);
              end;
            end;
          end;
        end;
        Inc(nX, UNITX);
      end;
      Inc(nY, UNITY);
    end;
  end;

  with Map.m_ClientRect do begin
    if g_FScreenHeight = 768 then nY := -UNITY * 1
    else nY := -UNITY * 4;
    for j := (Top - Map.m_nBlockTop - 1) to (Bottom - Map.m_nBlockTop + 1) do begin
      if g_FScreenWidth = 1024 then nX := AAX + 28 - UNITX * 2
      else nX := AAX + 14 - UNITX * 4;
      for i := (Left - Map.m_nBlockLeft - 2) to (Right - Map.m_nBlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          nImgNumber := Map.m_MArr[i, j].wMidImg;
          if nImgNumber > 0 then begin
            nImgNumber := nImgNumber - 1;
            Index:= Map.m_MArr[i, j].btSmIndex;
            if Map.m_sCurrentMap = '3' then
               dsurface := g_WSmTilesImages[Index].Images[nImgNumber]
            else begin
               if (Map.m_sCurrentMap = 'n6') or (Map.m_sCurrentMap = 'N6') or (Map.m_sCurrentMap = 'n0') or (Map.m_sCurrentMap = 'N0') or (Map.m_sCurrentMap = 'n3') or (Map.m_sCurrentMap = 'N3')then
                 dsurface := g_WSmTilesImages[Index].Images[nImgNumber]
               else if (Map.m_boNewMap = True) and (Index = 0) and (Map.m_sCurrentMap <> '3') then
                 dsurface := g_WAnTilesImages[Index].Images[nImgNumber]
               else
                 dsurface := g_WSmTilesImages[Index].Images[nImgNumber];
            end;
            if dsurface <> nil then
              m_MapSurface.Draw(nX, nY, dsurface.ClientRect, dsurface, True);
          end;
        end;
        Inc(nX, UNITX);
      end;
      Inc(nY, UNITY);
    end;
  end;
end;


procedure TPlayScene.DrawMapObj;
var
i, j, k, ii, n, M, mmm, ix, iy, line, defx, defy, wunit, fridx, ani, anitick,
    ax,
    ay, idx, drawingbottomline: Integer;
  dsurface, d: TDirectDrawSurface;
  blend, movetick: Boolean;

  cm, px, cn, py:Integer;
  EffectTex: TDirectDrawSurface;
  nFColor, nBColor: Integer;
  TestTick1: LongWord;
  NameTexture, HintTexture: TDXImageTexture;
  nIndex: Integer;
  Images: TWMImages;
  ISPTDL:Boolean;
begin
  m_ObjSurface.Draw(0, 0,
    Rect(UNITX * 4,
    UNITY * 5,
    UNITX * 4 + g_FScreenWidth,
    UNITY * 5 + g_FScreenHeight),
    m_MapSurface,
    FALSE);
   defx := -UNITX * 3 + AAX + 14;
   if g_FScreenWidth = 1024 then defx := -UNITX * 4 + AAX + 28
   else defx := -UNITX * 6 + AAX + 14;

   if g_FScreenHeight = 768 then defy := -UNITY * 4
   else defy := -UNITY * 7;

   m := defy - UNITY;
   drawingbottomline := g_FScreenHeight;

   for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(m, UNITY);
        continue;
      end;
      n := defx - UNITX * 2;
      for i := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2) do
      begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
          if fridx > 0 then begin
            ani := Map.m_MArr[i, j].btAniFrame;
            wunit := Map.m_MArr[i, j].btArea;
            blend := FALSE;
            if (ani and $80) > 0 then begin
              blend := TRUE;
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
            DSurface := GetObjsEx(wunit, fridx, ax, ay);
            if DSurface <> nil then begin
              if blend then begin
                mmm := m + ay - 68;
                if (n > 0) and (mmm + DSurface.Height > 0) and (n + Dsurface.Width < g_FScreenWidth) and (mmm < drawingbottomline) then begin
                  if (Map.m_sCurrentMap = 'n6') or (Map.m_sCurrentMap = 'N6') then
                      DrawBlend(m_ObjSurface, n + ax - 72, mmm - 140, DSurface, 1)
                  else if (DSurface.Width = 100) and (DSurface.Height = 100) then begin
                      DrawBlend(m_ObjSurface, n + ax - 2, mmm, DSurface, 1);
                  end ELSE if (DSurface.Width = 128) and (DSurface.Height = 128) then begin
                      if Map.m_MArr[i, j].cbXXXXXX13 > 250 then
                      Map.m_MArr[i, j].cbXXXXXX13:= 0;
                      DrawBlend(m_ObjSurface, n + ax - 3, mmm + Map.m_MArr[i, j].cbXXXXXX13, DSurface, 1);
                  end else
                      DrawBlend(m_ObjSurface, n + ax - 2, mmm, DSurface, 1);
                end
                else begin
                  if mmm < drawingbottomline then begin
                    if (Map.m_sCurrentMap = 'n6') or (Map.m_sCurrentMap = 'N6') then
                      DrawBlend(m_ObjSurface, n + ax - 72, mmm - 140, DSurface, 1)
                    else if (DSurface.Width = 100) and (DSurface.Height = 100) then begin
                      DrawBlend(m_ObjSurface, n + ax - 2, mmm, DSurface, 1);
                    end
                    ELSE if (DSurface.Width = 128) and (DSurface.Height = 128) then begin
                      if Map.m_MArr[i, j].cbXXXXXX13 > 250 then
                      Map.m_MArr[i, j].cbXXXXXX13:= 0;
                      DrawBlend(m_ObjSurface, n + ax - 3, mmm + Map.m_MArr[i, j].cbXXXXXX13, DSurface, 1);
                  end
                    else
                      DrawBlend(m_ObjSurface, n + ax - 2, mmm, DSurface, 1);
                  end;
                end;
              end
              else if (DSurface.Width = 48) and (DSurface.Height = 32) then begin
                mmm := m + UNITY - DSurface.Height;
                if (n + DSurface.Width > 0) and (n <= g_FScreenWidth) and (mmm + DSurface.Height > 0) and
                  (mmm < drawingbottomline) then begin
                  m_ObjSurface.Draw(n, mmm, DSurface.ClientRect, Dsurface, TRUE)
                end
                else begin
                  if mmm < drawingbottomline then begin
                    m_ObjSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, TRUE)
                  end;
                end;
              end
              else begin
                mmm := m + UNITY - DSurface.Height;
                if (n + DSurface.Width > 0) and (n <= g_FScreenWidth) and (mmm + DSurface.Height > 0) and
                  (mmm < drawingbottomline) then begin
                  m_ObjSurface.Draw(n, mmm, DSurface.ClientRect, Dsurface, TRUE)
                end
                else begin
                  if mmm < drawingbottomline then begin
                    m_ObjSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, TRUE)
                  end;
                end;
              end;
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;
end;

procedure TPlayScene.PlayScene(MSurface: TDXTexture);
begin
end;

procedure TPlayScene.BeginScene();
begin

  if GetTickCount - m_dwAniTime >= 50 then begin
    m_dwAniTime := GetTickCount;
    Inc(m_nAniCount);
    if m_nAniCount > 100000 then
      m_nAniCount := 0;
  end;

 with Map.m_ClientRect do begin
      Left := g_wRx - 13;
      Top := g_wRy - 15;
      Right := g_wRx + 13;
      Bottom := g_wRy + 13;
    end;

  Map.UpdateMapPos(g_wRx, g_wRy);
end;

procedure TPlayScene.ReDrawMap;
begin
  SetRect(Map.m_OldClientRect, 0, 0, 0, 0);
end;



end.

