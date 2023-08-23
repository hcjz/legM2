unit IntroScn;

interface

uses
  Windows, SysUtils, StrUtils, Controls, Graphics, Classes, Dialogs,
  HGETextures, HGECanvas, HGE, HGEGUI, CShare, Logo, SoundUtil;

type
  TScene = class
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; virtual; abstract;
    procedure CloseScene; virtual; abstract;
    procedure PlayScene(MSurface: TDirectDrawSurface); virtual; abstract;
  end;

  //登录场景
  TLoginScene = class(TScene)
  private
    m_boNowOpening: Boolean;

    m_dwStartTime: LongWord;
    m_nCurFrame: Integer;
    m_nMaxFrame: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure OpenLoginDoor;
    procedure NewClick;
    procedure NewAccountOk;
    procedure LoginSubmit;
    procedure NewAccountClose;
    function CheckUserEntrys:Boolean;
    procedure EdNewOnEnter(Sender: TObject);
    function NewIdCheckNewId: Boolean;
    function NewIdCheckBirthDay: Boolean;
    procedure ChangeLoginState(State: TLoginState);
    procedure EdLoginPasswdKeyPress(Sender: TObject; var Key: Char);
    procedure EdNewIdKeyPress(Sender: TObject; var Key: Char);
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
  end;

  //角色场景
  TSelChrScene = class(TScene)
  private
    procedure MakeNewChar(Index: Integer);
  public
    m_HGE:IHGE;
    m_pLightsData:PAnsiChar;
    NewIndex: Integer;
    m_cbJob:Byte;
    m_cbSex:Byte;
    m_cbDelCount:Byte;
    m_cbCurPage:Byte;
    m_cbMaxPage:Byte;
    m_boCreateChrMode: Boolean;
    m_SelChrArr: array[0..1] of TSelChar;
    m_RenewChrIdx:Integer;
    m_HintSurface   : TDXImageTexture;
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure SelChrNewChrClick;
    procedure SelChrNewJob(job: Integer);
    procedure SelChrNewSex(sex: Integer);
    procedure SelectChr(Index: Integer);
    procedure SelChrNewClose;
    procedure SelChrNewOk;
    procedure SelChrSelect1Click;
    procedure SelChrSelect2Click;
    procedure SelChrEraseChrClick;
    procedure SelChrStartClick;
    procedure SelChrCreditsClick;
    procedure SelRenewChr;
    procedure LoadSelChrData(szMsg:string; dwHumCount:LongWord; cbEncode:Byte);
    procedure ChangeSelectChrState(State: TSelectChrState);
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
  end;

  //公告场景
  TNoticeScene = class(TScene)
  private
    m_HGE:IHGE;
    m_Background   : TDXImageTexture;
  public
    constructor Create;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
  public
    procedure OpenGameNoticeWin(sNotice:string);
  end;


var
  g_LoginScene:TLoginScene;
  g_SelChrScene:TSelChrScene;
  g_NoticeScene:TNoticeScene;

implementation

uses
  ClMain, FState, WMFile;

constructor TScene.Create;
begin
  inherited;
end;

destructor TScene.Destroy;
begin
  inherited;
end;

constructor TLoginScene.Create;
begin
  inherited;
  g_stMainScenes:= stLogin;
  m_boNowOpening:=False;
  m_dwStartTime:=0;
  m_nCurFrame:= 0;
  m_nMaxFrame := 10;
end;

procedure TLoginScene.OpenScene;
begin
  PlayBGM (bmg_intro);
end;

procedure TLoginScene.EdNewOnEnter(Sender: TObject);
begin

end;

procedure TLoginScene.EdNewIdKeyPress(Sender: TObject; var Key: Char);
begin

end;

function TLoginScene.NewIdCheckNewId: Boolean;
begin
  Result := True;

end;

function TLoginScene.NewIdCheckBirthDay: Boolean;
begin
  Result := True;
end;

procedure TLoginScene.NewClick;
begin
  ChangeLoginState(lsNewid);
end;

procedure TLoginScene.LoginSubmit;
var
  Key: Char;
begin
  Key := #13;
  EdLoginPasswdKeyPress(Self, Key);
end;

procedure TLoginScene.EdLoginPasswdKeyPress(Sender: TObject; var Key: Char);
begin
end;

function TLoginScene.CheckUserEntrys: Boolean;
begin
  Result := FALSE;
end;

procedure TLoginScene.NewAccountOk;
begin

end;

procedure TLoginScene.ChangeLoginState(State: TLoginState);
var
  i, focus: Integer;
  c: TControl;
begin
  focus := -1;
  case State of
    lsLogin: focus := 10;
    lsNewid: focus := 11;
    lsChgpw: focus := 12;
    lsCloseAll: focus := -1;
  end;
  with FrmDlg do begin //login
    case State of
      lsLogin: begin
        FrmDlg.DWinLogin.Visible := True;
        DEditAccounts.Visible := True;
        DEditPassword.Visible := True;
        FrmDlg.DEditAccounts.SetFocus;
      end;
      lsNewid: begin
      end;
      lsChgpw: begin
      end;
      lsCard: begin
      end;
      lsCloseAll: begin
      end;
      lsNewidRetry: begin
      end;
    end;
  end;
end;

procedure TLoginScene.NewAccountClose;
begin
  ChangeLoginState(lsLogin);
end;

procedure TLoginScene.CloseScene;
begin
  SilenceSound;
end;

procedure TLoginScene.OpenLoginDoor;
begin
  m_boNowOpening := True;
  m_dwStartTime := GetTickCount;
  PlaySound (s_rock_door_open);
end;

procedure TLoginScene.PlayScene(MSurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with g_DXCanvas do begin
    d := g_WChrSelImages.Images[22];
    if (d <> nil) then
      MSurface.Draw(0, 0, d.ClientRect, d, fxBlend);

    if m_boNowOpening then begin
      //开门速度
      if GetTickCount - m_dwStartTime > 100 then begin
        m_dwStartTime := GetTickCount;
        Inc(m_nCurFrame);
      end;
      if m_nCurFrame >= m_nMaxFrame - 1 then begin
        m_nCurFrame := m_nMaxFrame - 1;
        frmMain.ChangeGameScene(stSelectChr);
        g_csConnectionStep:= cnsSelChr;
      end;
      d := g_WChrSelImages.Images[23 + m_nCurFrame];
      if (d <> nil) then
        MSurface.Draw(152, 96, d.ClientRect, d, True);
    end;
  end;
end;

destructor TLoginScene.Destroy;
begin
  m_boNowOpening:=False;
  inherited;
end;

{-------------------- TSelectChrScene ------------------------}

constructor TSelChrScene.Create;
begin
  m_cbJob:= 0;
  m_cbSex:= 0;
  m_cbDelCount:= 0;
  m_RenewChrIdx:= -1;
  m_boCreateChrMode:= False;
  m_HGE:= HGECreate(HGE_VERSION);
end;

destructor TSelChrScene.Destroy;
begin
  inherited Destroy;
  m_HintSurface.Free;
end;

procedure TSelChrScene.OpenScene;
begin
  g_stMainScenes := stSelectChr;
  frmDlg.DSelectChr.Visible:= True;

  m_SelChrArr[0].Valid:= True;
  m_SelChrArr[0].FreezeState:= False;
  m_SelChrArr[0].Selected:= True;
  m_SelChrArr[0].UserChr.Name:='飞机中的战斗机';
  m_SelChrArr[0].UserChr.Sex:= 1;
  m_SelChrArr[0].UserChr.Job:= 1;
  m_SelChrArr[0].UserChr.Level:= 999;

  m_SelChrArr[1].Valid:= True;
  m_SelChrArr[1].FreezeState:= True;
  m_SelChrArr[1].Selected:= False;
  m_SelChrArr[1].UserChr.Name:='战斗机中的飞机';
  m_SelChrArr[1].UserChr.Sex:= 1;
  m_SelChrArr[1].UserChr.Job:= 2;
  m_SelChrArr[1].UserChr.Level:= 999;
  PlayBGM (bmg_select);
end;

procedure TSelChrScene.CloseScene;
begin
  ChangeSelectChrState(scCloseAll);
  SilenceSound;
end;


procedure TSelChrScene.SelChrSelect1Click;
begin
  if (not m_SelChrArr[0].Selected) and (m_SelChrArr[0].Valid) then begin
    m_SelChrArr[0].Freezing := FALSE;
    m_SelChrArr[0].FreezeState := True;
    m_SelChrArr[0].Selected := True;
    m_SelChrArr[0].Unfreezing := True;
    m_SelChrArr[0].AniIndex := 0;
    m_SelChrArr[0].DarkLevel := 0;
    m_SelChrArr[0].EffIndex := 0;
    m_SelChrArr[0].StartTime := GetTickCount;
    m_SelChrArr[0].moretime := GetTickCount;
    m_SelChrArr[0].startefftime := GetTickCount;
    m_SelChrArr[1].Freezing:= True;
    m_SelChrArr[1].Selected:= False;
    PlaySound (s_meltstone);
  end;
end;

procedure TSelChrScene.SelChrSelect2Click;
begin
  if (not m_SelChrArr[1].Selected) and (m_SelChrArr[1].Valid) then begin
    m_SelChrArr[1].Freezing := FALSE;
    m_SelChrArr[1].FreezeState := True;
    m_SelChrArr[1].Selected := True;
    m_SelChrArr[1].Unfreezing := True;
    m_SelChrArr[1].AniIndex := 0;
    m_SelChrArr[1].DarkLevel := 0;
    m_SelChrArr[1].EffIndex := 0;
    m_SelChrArr[1].StartTime := GetTickCount;
    m_SelChrArr[1].moretime := GetTickCount;
    m_SelChrArr[1].startefftime := GetTickCount;
    m_SelChrArr[0].Freezing:= True;
    m_SelChrArr[0].Selected:= False;
    PlaySound (s_meltstone);
  end;
end;

procedure TSelChrScene.SelChrCreditsClick;
begin
end;

procedure TSelChrScene.SelChrEraseChrClick;
begin
end;

procedure TSelChrScene.SelChrStartClick;
//var
//  sChrname:string;
begin
//  if not frmDlg.DCreateChr.Visible then begin
//    //获取选择的角色
//    if m_SelChrArr[0].Valid and m_SelChrArr[0].Selected then begin
//      sChrname := string(m_SelChrArr[0].UserChr.name);
//    end;
//    if m_SelChrArr[1].Valid and m_SelChrArr[1].Selected then begin
//      sChrname := string(m_SelChrArr[1].UserChr.name);
//    end;
//    if sChrname <> '' then begin
//      frmMain.ChangeGameScene(stNotice);
//      frmMain.SendSelChr(sChrname);
//      g_szChrname:= ShortString(sChrname);
//      g_csConnectionStep:= cnsNotice;
//    end else begin
//      //请创建角色
//    end;
//  end else begin
//    if frmDlg.DCreateChr.Visible then begin
//      frmDlg.DCreateChr.Visible:= True;
//      frmDlg.DEditChrName.SetFocus;
//    end;
//  end;
end;

procedure TSelChrScene.MakeNewChar(Index: Integer);
begin

end;

procedure TSelChrScene.SelChrNewChrClick;
begin

end;

procedure TSelChrScene.LoadSelChrData(szMsg:string; dwHumCount:LongWord; cbEncode:Byte);
begin

end;

procedure TSelChrScene.SelChrNewJob(job: Integer);
begin
  if (job in [0..3]) and (m_SelChrArr[NewIndex].UserChr.job <> job) then begin
    m_cbJob:=job;
    m_SelChrArr[NewIndex].UserChr.job := job;
    SelectChr(NewIndex);
  end;
end;

procedure TSelChrScene.SelChrNewSex(sex: Integer);
begin
  if sex <> m_SelChrArr[NewIndex].UserChr.sex then begin
    m_cbSex:= sex;
    m_SelChrArr[NewIndex].UserChr.sex := sex;
    SelectChr(NewIndex);
  end;
end;

procedure TSelChrScene.SelChrNewClose;
begin
  m_SelChrArr[NewIndex].Valid := FALSE;
  if NewIndex = 1 then begin
    m_SelChrArr[0].Selected := TRUE;
    m_SelChrArr[0].FreezeState := FALSE;
  end;
  ChangeSelectChrState(scSelectChr);
end;

procedure TSelChrScene.SelectChr(Index: Integer);
begin
  m_SelChrArr[Index].Selected := True;
  m_SelChrArr[Index].DarkLevel := 30;
  m_SelChrArr[Index].StartTime := GetTickCount;
  m_SelChrArr[Index].moretime := GetTickCount;
  if Index = 0 then begin
    m_SelChrArr[1].Selected := FALSE;
  end
  else if Index = 1 then begin
    m_SelChrArr[0].Selected := FALSE;
  end
end;

procedure TSelChrScene.SelChrNewOk;
begin

end;

procedure TSelChrScene.SelRenewChr;
begin

end;

procedure TSelChrScene.ChangeSelectChrState(State: TSelectChrState);
begin

end;

procedure TSelChrScene.PlayScene(MSurface: TDirectDrawSurface);
var
  d, e: TDirectDrawSurface;
  Img, Index:Integer;
  fx, fy: Integer;
  bx, by: Integer;
  ex, ey: Integer;
begin
  d := g_WMain2Images.Images[480];
  if (d <> nil) then begin
    MSurface.Draw(0, 0, d.ClientRect, d, FALSE);

    fx := 0;
    fy := 0;
    bx := 0;
    by := 0;
    for Index := 0 to 1 do begin
      if m_SelChrArr[Index].Valid then begin
        ex :=  90;
        ey :=  58;
        case m_SelChrArr[Index].UserChr.Job of
          0: begin
            if m_SelChrArr[Index].UserChr.Sex = 0 then begin
              bx :=  71;
              by :=  23;
              fx := bx;
              fy := by;
            end else begin
              bx :=  65;
              by :=  75 - 2 - 18;
              fx := bx - 28 + 28;
              fy := by - 16 + 16;
            end;
          end;
          1: begin
            if m_SelChrArr[Index].UserChr.Sex = 0 then begin
              bx := 77;
              by :=  75 - 29;
              fx := bx;
              fy := by;
            end else begin
              bx :=  141 + 30;
              by := 85 + 14 - 2;
              fx := bx - 30;
              fy := by - 14;
            end;
          end;
          2: begin
            if m_SelChrArr[Index].UserChr.Sex = 0 then begin
              bx :=  85;
              by :=  75 - 12;
              fx := bx;
              fy := by;
            end else begin
              bx := 141 + 23;
              by :=  85 + 20 - 2;
              fx := bx - 23;
              fy := by - 20;
            end;
          end;
          3: begin
            if m_SelChrArr[Index].UserChr.Sex = 0 then begin
              bx :=  80;
              by :=  36;
              fx := bx;
              fy := by;
            end else begin
              bx :=  71;
              by :=  39;
              fx := bx;
              fy := by;
            end;
          end;
        end;
        if Index = 1 then begin
          ex :=  430;
          ey :=  60;
          bx := bx + 340;
          by := by + 2;
          fx := fx + 340;
          fy := fy + 2;
        end;

        //绘制角色解封动作
        if m_SelChrArr[Index].Unfreezing then begin
          img := 140 - 80 + m_SelChrArr[Index].UserChr.Job * 40 + m_SelChrArr[Index].UserChr.Sex * 120;
          if m_SelChrArr[Index].UserChr.Job = 3 then begin
            img := 280 + (m_SelChrArr[Index].UserChr.Job - 2) * 20 + m_SelChrArr[Index].UserChr.Sex * 40;
          end;

          d := g_WChrSelImages.Images[img + m_SelChrArr[Index].aniIndex];
          e := g_WChrSelImages.Images[4 + m_SelChrArr[Index].effIndex];
          if d <> nil then
            MSurface.Draw(bx, by, d.ClientRect, d, TRUE);
          if e <> nil then
            MSurface.Draw(ex, ey, e.ClientRect, e, fxAnti);
          if GetTickCount - m_SelChrArr[Index].StartTime > 50 then begin
            m_SelChrArr[Index].StartTime := GetTickCount;
            m_SelChrArr[Index].aniIndex := m_SelChrArr[Index].aniIndex + 1;
          end;
          if GetTickCount - m_SelChrArr[Index].startefftime > 50 then begin
            m_SelChrArr[Index].startefftime := GetTickCount;
            m_SelChrArr[Index].effIndex := m_SelChrArr[Index].effIndex + 1;
          end;
          if m_SelChrArr[Index].aniIndex > FREEZEFRAME - 1 then begin
            m_SelChrArr[Index].Unfreezing := FALSE;
            m_SelChrArr[Index].FreezeState := FALSE;
            m_SelChrArr[Index].aniIndex := 0;
          end;
        end else if not m_SelChrArr[Index].Selected and (not m_SelChrArr[Index].FreezeState and not m_SelChrArr[Index].Freezing) then begin
          m_SelChrArr[Index].Freezing := TRUE;
          m_SelChrArr[Index].aniIndex := 0;
          m_SelChrArr[Index].StartTime := GetTickCount;
        end;
        //创建时角色的动画
        if not m_SelChrArr[Index].Unfreezing and not m_SelChrArr[Index].Freezing then begin
          if not m_SelChrArr[Index].FreezeState then begin
            if m_SelChrArr[Index].UserChr.Job = 3 then begin
              Img := 280 + m_SelChrArr[Index].aniIndex + m_SelChrArr[Index].UserChr.Sex * 40;
            end else begin
              img := 120 - 80 + m_SelChrArr[Index].UserChr.Job * 40 + m_SelChrArr[Index].aniIndex + m_SelChrArr[Index].UserChr.Sex * 120;
            end;
            d:= g_WChrSelImages.Images[Img];
            if d <> nil then begin
              MSurface.Draw(fx, fy, d.ClientRect, d, TRUE);
            end;
          end;
          if m_SelChrArr[Index].Selected then begin
            if GetTickCount - m_SelChrArr[Index].StartTime > 200 then begin
              m_SelChrArr[Index].StartTime := GetTickCount;
              m_SelChrArr[Index].aniIndex := m_SelChrArr[Index].aniIndex + 1;
              if m_SelChrArr[Index].aniIndex > SELECTEDFRAME - 1 then
                m_SelChrArr[Index].aniIndex := 0;
            end;
          end;
        end;

        //角色禁用
        if m_SelChrArr[Index].Freezing then begin
          img := 60 + m_SelChrArr[Index].UserChr.Job * 40 + m_SelChrArr[Index].UserChr.Sex * 120;
          if m_SelChrArr[Index].UserChr.Job = 3 then begin
            img := 280 + (m_SelChrArr[Index].UserChr.Job - 2) * 20 + m_SelChrArr[Index].UserChr.Sex * 40;
          end;
          d := g_WChrSelImages.Images[img + FREEZEFRAME - m_SelChrArr[Index].aniIndex - 1];
          if d <> nil then
            MSurface.Draw(bx, by, d.ClientRect, d, TRUE);
          if GetTickCount - m_SelChrArr[Index].StartTime > 75 then begin
            m_SelChrArr[Index].StartTime := GetTickCount;
            m_SelChrArr[Index].aniIndex := m_SelChrArr[Index].aniIndex + 1;
          end;
          if m_SelChrArr[Index].aniIndex > FREEZEFRAME - 1 then begin
            m_SelChrArr[Index].Freezing := FALSE;
            m_SelChrArr[Index].FreezeState := TRUE;
            m_SelChrArr[Index].aniIndex := 0;
          end;
        end;

        //绘制正常角色动作
        if not m_SelChrArr[Index].Unfreezing and not m_SelChrArr[Index].Freezing then begin
          if not m_SelChrArr[Index].FreezeState then begin
            if m_SelChrArr[Index].UserChr.Job = 3 then begin
              Img := 280 + m_SelChrArr[Index].aniIndex + m_SelChrArr[Index].UserChr.Sex * 40;
            end else begin
              img := 120 - 80 + m_SelChrArr[Index].UserChr.Job * 40 + m_SelChrArr[Index].aniIndex + m_SelChrArr[Index].UserChr.Sex * 120;
            end;
            d:= g_WChrSelImages.Images[Img];
            if d <> nil then begin
              MSurface.Draw(fx, fy, d.ClientRect, d, TRUE);
          end;
          end
          else begin
            img := 140 - 80 + m_SelChrArr[Index].UserChr.Job * 40 + m_SelChrArr[Index].UserChr.Sex * 120;
            if m_SelChrArr[Index].UserChr.Job = 3 then begin
              img := 280 + (m_SelChrArr[Index].UserChr.Job - 2) * 20 + m_SelChrArr[Index].UserChr.Sex * 40;
            end;

            d := g_WChrSelImages.Images[img];
            if d <> nil then
              MSurface.Draw(bx, by, d.ClientRect, d, TRUE);
          end;
          if m_SelChrArr[Index].Selected then begin
            if GetTickCount - m_SelChrArr[Index].StartTime > 200 then begin
              m_SelChrArr[Index].StartTime := GetTickCount;
              m_SelChrArr[Index].aniIndex := m_SelChrArr[Index].aniIndex + 1;
              if m_SelChrArr[Index].aniIndex > SELECTEDFRAME - 1 then
                m_SelChrArr[Index].aniIndex := 0;
            end;
          end;
        end;
      end;
    end;
  end;
end;

{-------------------- TNoticeScene ------------------------}
constructor TNoticeScene.Create;
begin
  inherited;
  m_HGE:= HGECreate(HGE_VERSION);
end;

procedure TNoticeScene.OpenScene;
begin
  g_stMainScenes := stNotice;
  if m_Background = nil then begin
    m_Background := TDXImageTexture.Create(g_DXCanvas);
    m_Background.Size := Point(800, 600);
    m_Background.PatternSize := Point(800, 600);
    m_Background.Image := m_HGE.Texture_Create(800, 600);
  end;
end;

procedure TNoticeScene.OpenGameNoticeWin(sNotice:string);
begin
  if mrOk = frmDlg.DMessageDlg('', [mbOk]) then begin
    frmMain.ChangeGameScene(stPlayGame);
  end;
end;

procedure TNoticeScene.PlayScene(MSurface: TDirectDrawSurface);
begin
  if (m_Background <> nil) then
    MSurface.Draw(0, 0, m_Background.ClientRect, m_Background, False);
end;

procedure TNoticeScene.CloseScene;
begin

end;

destructor TNoticeScene.Destroy;
begin
  m_Background.Free;
  inherited Destroy;
end;


end.
