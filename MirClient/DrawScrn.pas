unit DrawScrn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StrUtils, MShare,
  HGE, HGECanvas, HGETextures, HGEFont, IntroScn,
  HumanActor, Actor, cliUtil, ClFunc, HUtil32, GList, DxHint;

//const
//  USECENTERMAG              = True;
//  MAXSYSLINE                = 8;
//  AREASTATEICONBASE         = 150;
//  HEALTHBAR_BLACK           = 0;
//  HEALTHBAR_RED             = 1;

type


  TDrawScreen = class
  private
    m_dwFrameTime: LongWord;
    m_dwFrameCount: LongWord;
    m_dwDrawFrameCount: LongWord;
    m_SysMsgList: TStringList;
    m_SysMsgListEx: TStringList;
    m_SysMsgListEx2: TStringList;
  public
    CurrentScene: TScene;
    ChatStrs: TStringList;
    ChatBks: TList;
    ChatBoardTop: Integer;

    m_adList, m_adList2: TStringList;

    m_smListCnt: TGList;
    m_smListCntFree: TGList;

    m_Hint1: TDxHintMgr;
    m_Hint2: TDxHintMgr;
    m_Hint3: TDxHintMgr;

    constructor Create;
    destructor Destroy; override;
    procedure KeyPress(var Key: Char);
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Initialize;
    procedure Finalize;
    procedure ChangeScene(scenetype: TSceneType);
    procedure DrawScreen(MSurface: TDirectDrawSurface);
    procedure DrawScreenTop(MSurface: TDirectDrawSurface);
    procedure DrawScreenBottom(MSurface: TDirectDrawSurface);
    procedure DrawScreenCenter(MSurface: TDirectDrawSurface);
    procedure AddSysMsg(Msg: string);
    procedure AddSysMsgBottom(Msg: string);
    procedure AddSysMsgBottom2(Msg: string);
    procedure AddSysMsgCenter(Msg: string; fc, bc, sec: Integer);
    procedure AddChatBoardString(Str: string; fcolor, bcolor: Integer);
    procedure ClearChatBoard;

    function ShowHint(X, Y: Integer;
      Str: string;
      Color: TColor;
      drawup: Boolean;
      drawLeft: Boolean = False;
      bfh: Boolean = False;
      Lines: Boolean = False;
      mgr: Byte = 1;
      TakeOn: Boolean = False): Integer;
    procedure ClearHint;
    procedure DrawHint(MSurface: TDirectDrawSurface);
  end;

implementation

uses
  ClMain, FState, Grobal2;



constructor TDrawScreen.Create;
var
  i                         : Integer;
begin
  CurrentScene := nil;
  m_dwFrameTime := GetTickCount;
  m_dwFrameCount := 0;
  m_SysMsgList := TStringList.Create;
  m_SysMsgListEx := TStringList.Create;
  m_SysMsgListEx2 := TStringList.Create;

  m_smListCnt := TGList.Create;
  m_smListCntFree := TGList.Create;

  ChatStrs := TStringList.Create;
  m_adList := TStringList.Create;
  m_adList2 := TStringList.Create;

  ChatBks := TList.Create;
  ChatBoardTop := 0;
  m_Hint1 := TDxHintMgr.Create;
  m_Hint2 := TDxHintMgr.Create;
  m_Hint3 := TDxHintMgr.Create;
end;

destructor TDrawScreen.Destroy;
var
  i                         : Integer;
begin
  m_SysMsgList.Free;
  m_SysMsgListEx.Free;
  m_SysMsgListEx2.Free;
//ע�͵��ͷſɽ�����͹��浼�¿ͻ����ں˼��� Development 2019-01-04
  for i := 0 to m_smListCnt.Count - 1 do
    Dispose(PTCenterMsg(m_smListCnt[i]));
  m_smListCnt.Free;
  for i := 0 to m_smListCntFree.Count - 1 do
    Dispose(PTCenterMsg(m_smListCntFree[i]));
  m_smListCntFree.Free;

  ChatStrs.Free;
  m_adList.Free;
  m_adList2.Free;
  ChatBks.Free;

  m_Hint1.Free;
  m_Hint2.Free;
  m_Hint3.Free;
  inherited Destroy;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
end;

procedure TDrawScreen.KeyPress(var Key: Char);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyPress(Key);
end;

procedure TDrawScreen.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyDown(Key, Shift);
end;

procedure TDrawScreen.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseMove(Shift, X, Y);
end;

procedure TDrawScreen.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseDown(Button, Shift, X, Y);
end;

procedure TDrawScreen.ChangeScene(scenetype: TSceneType);
begin
  if CurrentScene <> nil then
    CurrentScene.CloseScene;
  case scenetype of
    stIntro: begin
        CurrentScene := IntroScene;
        IntroScene.m_dwStartTime := GetTickCount + 2000;
      end;
    stLogin: CurrentScene := LoginScene;
    stSelectCountry: ;
    stSelectChr: CurrentScene := SelectChrScene;
    stNewChr: ;
    stLoading: ;
    stLoginNotice: CurrentScene := LoginNoticeScene;
    stPlayGame: CurrentScene := g_PlayScene;
  end;
  if CurrentScene <> nil then
    CurrentScene.OpenScene;
end;

procedure TDrawScreen.AddSysMsg(Msg: string);
begin
  if m_SysMsgList.Count >= 10 then m_SysMsgList.Delete(0);
  m_SysMsgList.AddObject(Msg, TObject(GetTickCount));
end;

procedure TDrawScreen.AddSysMsgBottom(Msg: string);
begin
  if m_SysMsgListEx.Count >= 10 then m_SysMsgListEx.Delete(0);
  m_SysMsgListEx.AddObject(Msg, TObject(GetTickCount));
end;

procedure TDrawScreen.AddSysMsgBottom2(Msg: string);
begin
  if m_SysMsgListEx2.Count >= 10 then m_SysMsgListEx2.Delete(0);
  m_SysMsgListEx2.AddObject(Msg, TObject(GetTickCount));
end;

procedure TDrawScreen.AddSysMsgCenter(Msg: string; fc, bc, sec: Integer);
var
  i, n, p                   : Integer;
  s                         : string;
  pm, pmfree                : PTCenterMsg;
begin
  if Msg = '' then Exit;
  //if TagCount(Msg, '%') >= 2 then Exit;

  m_smListCnt.Lock;
  try
    if m_smListCnt.Count >= 5 then begin
      m_smListCnt.Delete(0);
      pm := m_smListCnt[0];
      pm.dwCloseTick := GetTickCount;
      m_smListCntFree.Lock;
      try
        m_smListCntFree.Add(pm);
      finally
        m_smListCntFree.UnLock;
      end;
    end;
  finally
    m_smListCnt.UnLock;
  end;
//ע�͵��ͷſɽ�����͹��浼�¿ͻ����ں˼��� Development 2019-01-04
  m_smListCntFree.Lock;
  try
    for i := m_smListCntFree.Count - 1 downto 0 do begin
      pmfree := m_smListCntFree[i];
      if (pmfree.dwCloseTick > 0) and (GetTickCount - pmfree.dwCloseTick > 5 * 60 * 1000) then begin
        m_smListCntFree.Delete(i);
        Dispose(pmfree);
        //Break;
      end;
    end;
  finally
    m_smListCntFree.UnLock;
  end;

  i := 0;
  p := 0;
  s := Msg;
  n := Length(Msg);
  while True do begin
    p := Pos('%', s);
    if p > 0 then begin
      if p < n then begin
        if (Msg[p + 1] = 't') then
          Msg[p + 1] := 'd'
        else begin
          Msg[p] := ' ';
          Msg[p + 1] := ' ';
        end;
      end else if p = n then begin
        Msg[p] := ' ';
      end;
      s := Copy(Msg, p + 1, n - p);
    end else
      Break;
    Inc(i);
    if i > 10 then Break;
  end;
  if Trim(Msg) <> '' then begin
    New(pm);
    pm.s := Msg;
    pm.fc := fc;
    pm.bc := bc;
    pm.dwSec := _MAX(1, sec);
    pm.dwNow := GetTickCount;
    pm.dwCloseTick := 0;
    m_smListCnt.Lock;
    try
      m_smListCnt.Add(pm);
    finally
      m_smListCnt.UnLock;
    end;
  end;
end;


procedure TDrawScreen.AddChatBoardString(Str: string; fcolor, bcolor: Integer);
var
  i, Len, aline             : Integer;
  temp                      : string;
begin
  Len := Length(Str);
  temp := '';
  i := 1;
  while True do begin
    if i > Len then Break;
    if Byte(Str[i]) >= 128 then begin
      temp := temp + Str[i];
      Inc(i);
      if i <= Len then
        temp := temp + Str[i]
      else
        Break;
    end else
      temp := temp + Str[i];
    aline := g_DXCanvas.TextWidth(temp);
    if aline > BOXWIDTH then begin
      ChatStrs.AddObject(temp, TObject(fcolor));
      ChatBks.Add(Pointer(bcolor));
      Str := Copy(Str, i + 1, Len - i);
      temp := '';
      Break;
    end;
    Inc(i);
  end;
  if temp <> '' then begin
    ChatStrs.AddObject(temp, TObject(fcolor));
    ChatBks.Add(Pointer(bcolor));
    Str := '';
  end;

  if ChatStrs.Count > 200 then begin
    ChatStrs.Delete(0);
    ChatBks.Delete(0);
    if ChatStrs.Count - ChatBoardTop < VIEWCHATLINE then
      Dec(ChatBoardTop);
  end else begin
    if not frmDlg.DBChat.Visible then begin
      if (ChatStrs.Count - ChatBoardTop) > VIEWCHATLINE then
        Inc(ChatBoardTop);
    end else begin
      if (ChatStrs.Count - ChatBoardTop) > VIEWCHATLINE then
        Inc(ChatBoardTop);
    end;
  end;
  if Str <> '' then
    AddChatBoardString(' ' + Str, fcolor, bcolor);
end;

function TDrawScreen.ShowHint(X, Y: Integer; Str: string; Color: TColor;
  drawup: Boolean;
  drawLeft: Boolean;
  bfh: Boolean;
  Lines: Boolean;
  mgr: Byte;
  TakeOn: Boolean): Integer;
var
  b                         : Boolean;
  cl                        : TColor;
  scl, data                 : string;
  i, w, h, j                : Integer;
begin
  //  g_DxHintMgr.AnalyseText(X, Y, STR, clWhite, drawup, drawLeft, False, False);
  case mgr of
    1: Result := m_Hint1.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
    2: Result := m_Hint2.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
    3: Result := m_Hint3.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
  else begin
      Result := m_Hint1.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
      Result := Result + m_Hint2.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
      Result := Result + m_Hint3.ShowHint(X, Y, Str, Color, drawup, drawLeft, Lines, TakeOn);
    end;
  end;
end;

procedure TDrawScreen.ClearChatBoard;
var
  i                         : Integer;
begin
  m_SysMsgList.Clear;
  m_SysMsgListEx.Clear;
  m_SysMsgListEx2.Clear;
//ע�͵��ͷſɽ�����͹��浼�¿ͻ����ں˼��� Development 2019-01-04
    for i := 0 to m_smListCnt.Count - 1 do
//      DisPose(PTCenterMsg(m_smListCnt[i]));
   m_smListCnt.Clear;
////
    for i := 0 to m_smListCntFree.Count - 1 do
//      DisPose(PTCenterMsg(m_smListCntFree[i]));
   m_smListCntFree.Clear;


  ChatStrs.Clear;
  ChatBks.Clear;
  ChatBoardTop := 0;
end;

procedure TDrawScreen.DrawScreen(MSurface: TDirectDrawSurface);
  procedure NameTextOut(Surface: TDirectDrawSurface; X, Y, fcolor, bcolor: Integer; namestr: string; bExplore: Boolean = False);
  var
    i, Row                  : Integer;
    nstr                    : string;
    tmpcolor                : TColor;
  begin
    Row := 0;
    for i := 0 to 10 do begin
      if namestr = '' then Break;
      namestr := GetValidStr3(namestr, nstr, ['\']);
      if bExplore and (i = 0) then
        tmpcolor := clLime
      else if tmpcolor <> fcolor then tmpcolor := fcolor;
      //g_DXCanvas.BoldTextOut(X - g_DXCanvas.TextWidth(nstr) shr 1, Y + Row * 12, tmpcolor, nstr);
      g_EiImageDraw.TextOut(x - g_EiImageDraw.TextWidth(nstr) div 2, y + Row * 12, fcolor, bcolor, nstr);
      Inc(Row);
    end;
  end;

  procedure NameTextOut2(Surface: TDirectDrawSurface; X, Y, fcolor, bcolor: Integer; Actor: TActor);
  begin
    if Actor.m_sUserName <> '' then
      //g_DXCanvas.BoldTextOut(X - Actor.m_sUserNameOffSet, Y, fcolor, Actor.m_sUserName);
      g_EiImageDraw.TextOut(x - Actor.m_sUserNameOffSet, y, fcolor, bcolor, Actor.m_sUserName);
  end;

var
  t, t2                     : DWORD;
  i, n, k, line, sX, sY, fcolor, bcolor: Integer;
  Actor                     : TActor;
  uname                     : string[255];
  dsurface                  : TDirectDrawSurface;
  d, dd{ , dh}              : TDirectDrawSurface;
  rc: TRect;
  Right                     : Integer;
  infoMsg                   : string[255];
  nNameColor                : Integer;
  sad                       : string;
  p                         : pTClientStdItem;
  FontColor: TColor;
begin
  if CurrentScene <> nil then begin
    CurrentScene.PlayScene(MSurface);
  end;

  if g_MySelf = nil then Exit;

  if CurrentScene = g_PlayScene then begin
    t := GetTickCount;
    with g_DXCanvas do begin
      with g_PlayScene do begin

        for k := 0 to m_ActorList.Count - 1 do begin
          Actor := m_ActorList[k];
          if IsInMyRange(Actor) then begin

            if (Actor.m_btRace = RCC_MERCHANT) and (Actor.m_wAppearance in [33..75, 84..98, 112..123, 130..132]) then
              Continue;

            //������Ѫ
            if (g_boShowHPNumber or Actor.m_boOpenHealth) and
             (Actor.m_btRace <> RCC_MERCHANT) and
             (Actor.m_Abil.MaxHP > 1) and not Actor.m_boDeath   then begin //��ʾ����Ѫ��
              infoMsg := IntToStr(Actor.m_Abil.HP) + '/' + IntToStr(Actor.m_Abil.MaxHP);



//              if (Actor.m_btRace  = RCC_USERHUMAN)  then
//                case Actor.m_btJob of //ְҵ����
//                  0: infoMsg := infoMsg + '/Z' + IntToStr(Actor.m_Abil.Level); //սʿ�ȼ�
//                  1: infoMsg := infoMsg + '/F' + IntToStr(Actor.m_Abil.Level); //��ʦ�ȼ�
//                  2: infoMsg := infoMsg + '/D' + IntToStr(Actor.m_Abil.Level); //��ʿ�ȼ�
//                else infoMsg := infoMsg + '/UnKnow';
//                end;

              g_EiImageDraw.TextOut(Actor.m_nSayX - g_EiImageDraw.TextWidth(infoMsg) div 2 + 1, Actor.m_nSayY - 21, clWhite, infoMsg);
            end;
            if (Actor.m_btRace <> RCC_MERCHANT) then begin //��ʾѪ��
              if (Actor.m_boOpenHealth or Actor.m_noInstanceOpenHealth or g_boShowRedHPLable) and not Actor.m_boDeath then begin
                if Actor.m_noInstanceOpenHealth then
                  if t - Actor.m_dwOpenHealthStart > Actor.m_dwOpenHealthTime then
                    Actor.m_noInstanceOpenHealth := False;
                //Ѫ���ڿ�
                g_DXCanvas.FrameRect(Rect(actor.m_nSayX - 30 div 2, Actor.m_nSayY - 8, actor.m_nSayX - 30 div 2 + 32, actor.m_nSayY - 5), clBlack);
                if (Actor <> g_MySelf) and (Actor <> g_MySelf.m_HeroObject) then begin //����
                  if Actor.m_Abil.MaxHP > 0 then begin
                    Right := Round(32 / Actor.m_Abil.MaxHP * Actor.m_Abil.HP);
                  end else begin
                    Right := 32;
                  end;
                  if Right > 0 then
                  g_DXCanvas.FillRectAlpha(Rect(actor.m_nSayX - 30 div 2, Actor.m_nSayY - 8, actor.m_nSayX - 30 div 2 + Right, actor.m_nSayY - 5), clRed, 255);
                end;
                if (Actor = g_MySelf) then begin //ͻ���Լ�
                  if not g_MySelf.m_boDeath then begin
                    if g_MySelf.m_Abil.MaxHP > 0 then begin
                      Right := Round(32 / g_MySelf.m_Abil.MaxHP * g_MySelf.m_Abil.HP);
                    end else begin
                      Right := 32;
                    end;
                    if Right > 0 then
                    g_DXCanvas.FillRectAlpha(Rect(actor.m_nSayX - 30 div 2, Actor.m_nSayY - 8, actor.m_nSayX - 30 div 2 + Right, actor.m_nSayY - 5), clLime, 255);
                  end;
                end;
                if (g_MySelf <> nil) and (g_MySelf.m_HeroObject <> nil) and (Actor = g_MySelf.m_HeroObject) then begin //Ӣ��
                  if IsInMyRange(g_MySelf.m_HeroObject) then begin
                    if g_MySelf.m_HeroObject.m_Abil.MaxHP > 0 then begin
                      Right := Round(32 / g_MySelf.m_HeroObject.m_Abil.MaxHP * g_MySelf.m_HeroObject.m_Abil.HP);
                    end else begin
                      Right := 32;
                    end;
                    if Right > 0 then
                    g_DXCanvas.FillRectAlpha(Rect(actor.m_nSayX - 30 div 2, Actor.m_nSayY - 8, actor.m_nSayX - 30 div 2 + Right, actor.m_nSayY - 5), clRed, 255);
                  end;
                end;
                if (Actor.m_btRace = 0) and (Actor.m_nIPower >= 0) then begin //�ڹ�
                  if (Actor.m_nIPowerLvl in [1..MAX_IPLEVEL]) then begin
                    g_DXCanvas.FrameRect(Rect(actor.m_nSayX - 30 div 2,Actor.m_nSayY - 5,actor.m_nSayX - 30 div 2 + 32, actor.m_nSayY - 2), clBlack);
                    if Actor.m_nIPower > 0 then
                      Right := Round(32 / g_dwIPNeedInfo[Actor.m_nIPowerLvl].nPower * Actor.m_nIPower)
                    else
                      Right := 0;
                    if Right > 0 then
                    g_DXCanvas.FillRectAlpha(Rect(actor.m_nSayX - 30 div 2, Actor.m_nSayY - 5, actor.m_nSayX - 30 div 2 + Right, actor.m_nSayY - 2), clYellow, 255);
                  end;
                end;
              end;
            end else begin //NPC
              g_DXCanvas.FrameRect(Rect(actor.m_nSayX - 30 div 2, Actor.m_nSayY - 8, actor.m_nSayX - 30 div 2 + 32, actor.m_nSayY - 5), clBlack);
              g_DXCanvas.FillRectAlpha(Rect(actor.m_nSayX - 30 div 2, Actor.m_nSayY - 8, actor.m_nSayX - 30 div 2 + 32, actor.m_nSayY - 5), clBlue, 255);
            end;
          end;
        end;
      end;

      //��ʾ���� ShowActorName
      if g_gcGeneral[0] then begin
        with g_PlayScene do begin
          for k := 0 to m_ActorList.Count - 1 do begin
            Actor := m_ActorList[k];
            if (Actor = nil) or (Actor.m_boDeath) then Continue;
            if (Actor.m_BodySurface = nil) then Continue;
            if (Actor.m_nSayX = 0) and (Actor.m_nSayY = 0) then Continue;

            if ((Actor.m_btRace = 0) or (Actor.m_btRace = RCC_MERCHANT)) and IsInMyRange(Actor) then begin

              if (Actor <> g_FocusCret) and (not g_boSelectMyself or (Actor <> g_MySelf)) then
              begin
                //������ʾ
                NameTextOut2(MSurface, Actor.m_nSayX, Actor.m_nSayY + 30, Actor.m_nNameColor, clBlack, Actor);
               //ȫ����ʾ
//                uname := Format('%s\%s', [g_MySelf.m_sDescUserName, g_MySelf.m_sUserName]);
//                NameTextOut(MSurface, g_MySelf.m_nSayX, g_MySelf.m_nSayY + 30, g_MySelf.m_nNameColor, clBlack, uname);

              end;

              if Actor is THumActor then begin
                if THumActor(Actor).m_StallMgr.OnSale then begin
                  if THumActor(Actor).m_StallMgr.mBlock.StallName <> '' then begin
                    if g_boShowHPNumber and (Actor.m_Abil.MaxHP > 1) then
                      BoldTextOut( THumActor(Actor).m_nSayX - (TextWidth(THumActor(Actor).m_StallMgr.mBlock.StallName) div 2),
                        THumActor(Actor).m_nSayY - 36,
                        GetRGB(94),

                        THumActor(Actor).m_StallMgr.mBlock.StallName)
                    else
                      BoldTextOut( THumActor(Actor).m_nSayX - (TextWidth(THumActor(Actor).m_StallMgr.mBlock.StallName) div 2),
                        THumActor(Actor).m_nSayY - 24,
                        GetRGB(94),

                        THumActor(Actor).m_StallMgr.mBlock.StallName);
                  end;
                  if g_gcGeneral[16] and (Actor.m_btTitleIndex > 0) then begin
                    p := GetTitle(Actor.m_btTitleIndex);
                    if p <> nil then begin
                      if g_boShowHPNumber and (Actor.m_Abil.MaxHP > 1) then begin
                        if p.Reserved = 0 then begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (TextWidth(p.Name) + dd.Width) div 2 - 4,
                              Actor.m_nSayY - 55 - (dd.Width - TextHeight(p.Name)) div 2,
                              dd, True);
                          if dd <> nil then
                            BoldTextOut( Actor.m_nSayX - ((TextWidth(p.Name) - dd.Width) div 2),
                              Actor.m_nSayY - 55,
                              GetLevelColor(p.Source),

                              p.Name)
                          else
                            BoldTextOut( Actor.m_nSayX - (TextWidth(p.Name) div 2),
                              Actor.m_nSayY - 55,
                              GetLevelColor(p.Source),

                              p.Name);
                        end else begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (dd.Width div 2),
                              Actor.m_nSayY - 55 - (dd.Height - TextHeight('a')) div 2 - 5,
                              dd, True);
                        end;
                      end else begin
                        if p.Reserved = 0 then begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (TextWidth(p.Name) + dd.Width) div 2 - 4,
                              Actor.m_nSayY - 43 - (dd.Width - TextHeight(p.Name)) div 2,
                              dd, True);
                          if dd <> nil then
                            BoldTextOut( Actor.m_nSayX - ((TextWidth(p.Name) - dd.Width) div 2),
                              Actor.m_nSayY - 43,
                              GetLevelColor(p.Source),

                              p.Name)
                          else
                            BoldTextOut( Actor.m_nSayX - ((TextWidth(p.Name)) div 2),
                              Actor.m_nSayY - 43,
                              GetLevelColor(p.Source),

                              p.Name);
                        end else begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (dd.Width div 2),
                              Actor.m_nSayY - 43 - (dd.Height - TextHeight('a')) div 2 - 5,
                              dd, True);
                        end;
                      end;
                    end;
                  end;
                end else begin
                  if g_gcGeneral[16] and (Actor.m_btTitleIndex > 0) then begin
                    p := GetTitle(Actor.m_btTitleIndex);
                    if p <> nil then begin
                      if g_boShowHPNumber and (Actor.m_Abil.MaxHP > 1) then begin
                        if p.Reserved = 0 then begin
                          dd := g_wui.Images[p.looks];
                          //MSurface.Draw(Actor.m_nSayX - dd.Width div 2, Actor.m_nSayY - 10 - 4, dd.ClientRect, dd, True);
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (TextWidth(p.Name) + dd.Width) div 2 - 4,
                              Actor.m_nSayY - 40 - (dd.Width - TextHeight(p.Name)) div 2,
                              dd, True);
                          if dd <> nil then
                            BoldTextOut( Actor.m_nSayX - ((TextWidth(p.Name) - dd.Width) div 2),
                              Actor.m_nSayY - 40,
                              GetLevelColor(p.Source),

                              p.Name)
                          else
                            BoldTextOut( Actor.m_nSayX - ((TextWidth(p.Name)) div 2),
                              Actor.m_nSayY - 40,
                              GetLevelColor(p.Source),

                              p.Name);
                        end else begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (dd.Width div 2),
                              Actor.m_nSayY - 40 - (dd.Height - TextHeight('a')) div 2 - 5,
                              dd, True);
                        end;
                      end else begin
                        if p.Reserved = 0 then begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (TextWidth(p.Name) + dd.Width) div 2 - 4,
                              Actor.m_nSayY - 28 - (dd.Width - TextHeight(p.Name)) div 2,
                              dd, True);
                          if dd <> nil then
                            BoldTextOut( Actor.m_nSayX - ((TextWidth(p.Name) - dd.Width) div 2),
                              Actor.m_nSayY - 28,
                              GetLevelColor(p.Source),

                              p.Name)
                          else
                            BoldTextOut( Actor.m_nSayX - ((TextWidth(p.Name)) div 2),
                              Actor.m_nSayY - 28,
                              GetLevelColor(p.Source),

                              p.Name);
                        end else begin
                          dd := g_wui.Images[p.looks];
                          if dd <> nil then
                            MSurface.Draw(Actor.m_nSayX - (dd.Width div 2),
                              Actor.m_nSayY - 28 - (dd.Height - TextHeight('a')) div 2 - 5,
                              dd, True);
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;

      if (g_FocusCret <> nil) and (g_FocusCret.m_BodySurface <> nil) and g_PlayScene.IsValidActor(g_FocusCret) then begin //1001
        if g_FocusCret.m_boDeath and not g_FocusCret.m_boSkeleton and g_FocusCret.m_boItemExplore {and (g_FocusCret.m_btRace <> 0)} then begin
          uname := Format('(��̽��)\%s\%s', [g_FocusCret.m_sDescUserName, g_FocusCret.m_sUserName]);
          NameTextOut(MSurface,
            g_FocusCret.m_nSayX,
            g_FocusCret.m_nSayY + 18,
            g_FocusCret.m_nNameColor, clBlack,
            uname, True);
        end else begin
          if not (g_FocusCret.m_boDeath and g_gcGeneral[8] and not g_FocusCret.m_boItemExplore and (g_FocusCret.m_btRace <> 0)) then begin
            uname := Format('%s\%s', [g_FocusCret.m_sDescUserName, g_FocusCret.m_sUserName]);
            if g_FocusCret.m_btRace = RCC_MERCHANT then
              nNameColor := clLime
            else
              nNameColor := g_FocusCret.m_nNameColor;
            NameTextOut(MSurface,
              g_FocusCret.m_nSayX,
              g_FocusCret.m_nSayY + 30,
              nNameColor, clBlack,
              uname);
          end;
        end;
      end;

      if g_boSelectMyself then begin
        uname := Format('%s\%s', [g_MySelf.m_sDescUserName, g_MySelf.m_sUserName]);
        NameTextOut(MSurface,
          g_MySelf.m_nSayX,
          g_MySelf.m_nSayY + 30,
          g_MySelf.m_nNameColor, clBlack,
          uname);
      end;

      //����ƮѪ
      with g_PlayScene do begin
        for k := 0 to m_ActorList.Count - 1 do begin
          Actor := m_ActorList[k];
          if (Actor = nil) {or (Actor.m_boDeath)} then Continue;
          for i := 0 to Actor.m_StruckDamage2.Count - 1 do begin
            with g_DXCanvas do begin
              n := MainForm.Canvas.Font.Size;
              uname := MainForm.Canvas.Font.Name;
              try
                MainForm.Canvas.Font.Size := 18;
                MainForm.Canvas.Font.Name := 'Times New Roman Bold Italic';
                sY := Integer(Actor.m_StruckDamage2.Objects[i]);
                if sY <= 1 then sY := 0;
                TextOutR(Actor.m_nSayX + Integer(Actor.m_StruckDamage2.Objects[i]) - TextWidth(Actor.m_StruckDamage2[i]) div 2,
                  Actor.m_nSayY - 10 - Round(Integer(Actor.m_StruckDamage2.Objects[i]) * 1.4) - TextHeight(Actor.m_StruckDamage2[i]),
                  Actor.m_StruckDamage2[i], $000061EB, $00050505);
              finally
                MainForm.Canvas.Font.Size := n;
                MainForm.Canvas.Font.Name := uname;
              end;
            end;
            Actor.m_StruckDamage2.Objects[i] := TObject(Integer(Actor.m_StruckDamage2.Objects[i]) + 1);
          end;
          for i := Actor.m_StruckDamage2.Count - 1 downto 0 do begin //��ʲô���壿����
            if Integer(Actor.m_StruckDamage2.Objects[i]) > 32 then begin
              Actor.m_StruckDamage2.Delete(i);
            end;
          end;
        end;

        //����Ʈ��???
        for k := 0 to m_ActorList.Count - 1 do begin
          Actor := m_ActorList[k];
          if (Actor = nil) {or (Actor.m_boDeath)} then Continue;
          for i := 0 to Actor.m_StruckDamage.Count - 1 do begin
            with g_DXCanvas do begin
              n := MainForm.Canvas.Font.Size;
              uname := MainForm.Canvas.Font.Name;
              try
                MainForm.Canvas.Font.Size := 18;
                MainForm.Canvas.Font.Name := 'Times New Roman Bold Italic';
                TextOutR(Actor.m_nSayX + Integer(Actor.m_StruckDamage.Objects[i]) - TextWidth(Actor.m_StruckDamage[i]) div 2,
                  Actor.m_nSayY - 10 - Round(Integer(Actor.m_StruckDamage.Objects[i]) * 1.4) - TextHeight(Actor.m_StruckDamage[i]),
                  Actor.m_StruckDamage[i], $00FF35B1, $00050505);
              finally
                MainForm.Canvas.Font.Size := n;
                MainForm.Canvas.Font.Name := uname;
              end;
            end;
            Actor.m_StruckDamage.Objects[i] := TObject(Integer(Actor.m_StruckDamage.Objects[i]) + 1);
          end;
          for i := Actor.m_StruckDamage.Count - 1 downto 0 do begin
            if Integer(Actor.m_StruckDamage.Objects[i]) > 38 then begin
              Actor.m_StruckDamage.Delete(i);
            end;
          end;
        end;

        for k := 0 to m_ActorList.Count - 1 do begin //��ʾ��������
          Actor := m_ActorList[k];
          if Actor.m_SayingArr[0] <> '' then begin
            if t - Actor.m_dwSayTime < 4 * 1000 then begin
              for i := 0 to Actor.m_nSayLineCount - 1 do begin
                if (Actor is THumActor) and THumActor(Actor).m_StallMgr.OnSale then begin
                  if Actor.m_boDeath then
                    g_EiImageDraw.TextOut(Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                      Actor.m_nSayY - (Actor.m_nSayLineCount * 14) + i * 14 - 35 , clGray, actor.m_SayingArr[i])
                  else begin
                    if g_boShowHPNumber and (Actor.m_Abil.MaxHP > 1) then
                      g_EiImageDraw.TextOut(Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                        Actor.m_nSayY - (Actor.m_nSayLineCount * 16) + i * 14 - 35, clWhite ,actor.m_SayingArr[i])
                    else
                    g_EiImageDraw.TextOut(Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                      Actor.m_nSayY - (Actor.m_nSayLineCount * 14) + i * 14 - 35, clWhite ,actor.m_SayingArr[i]);
                  end;
                end else begin
                  if Actor.m_boDeath then
                    g_EiImageDraw.TextOut(Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                      Actor.m_nSayY - (Actor.m_nSayLineCount * 16) + i * 14 - 35, clGray, Actor.m_SayingArr[i])
                  else
                    g_EiImageDraw.TextOut(Actor.m_nSayX - (Actor.m_SayWidthsArr[i] div 2),
                      Actor.m_nSayY - (Actor.m_nSayLineCount * 16) + i * 14 - 35, clWhite, Actor.m_SayingArr[i]);
                end;
              end;
            end else
              Actor.m_SayingArr[0] := '';
          end;
        end;
      end;

      with g_DXCanvas do begin //��Ļ������������
        if m_adList.Count > 0 then begin
          n := MainForm.Canvas.Font.Size;
          MainForm.Canvas.Font.Size := 11;
          MainForm.Canvas.Font.Style := [fsBold];
          try
            FontColor := GetRGB(152); 
            g_DXCanvas.FillRect(0, 0, SCREENWIDTH, 28, SetA(FontColor, 150)); //�������ֱ���
            for i := m_adList.Count - 1 downto 0 do begin
              if i = m_adList.Count - 1 then begin
                SkidADTextOut(g_SkidAD_Rect.Right - Integer(m_adList2.Objects[i]), g_SkidAD_Rect.Top, m_adList[i],
                  GetRGB(LoByte(Word(m_adList.Objects[i]))), GetRGB(HiByte(Word(m_adList.Objects[i]))));
                m_adList2.Objects[i] := TObject(Integer(m_adList2.Objects[i]) + 1);
                if Integer(m_adList2.Objects[i]) >= Round(8.255 * Length(m_adList[i])) + SCREENWIDTH then begin
                  m_adList.Delete(i);
                  m_adList2.Delete(i);
                end;
              end else begin
                if (i < m_adList.Count - 1) and (i >= 0) then begin
                  sX := Round(8.255 * Length(m_adList[i + 1]));
                  if Integer(m_adList2.Objects[i + 1]) >= sX + 82 then begin
                    SkidADTextOut(g_SkidAD_Rect.Right - Integer(m_adList2.Objects[i]), g_SkidAD_Rect.Top, m_adList[i],
                      GetRGB(LoByte(Word(m_adList.Objects[i]))), GetRGB(HiByte(Word(m_adList.Objects[i]))));
                    m_adList2.Objects[i] := TObject(Integer(m_adList2.Objects[i]) + 1);
                  end;
                end;
              end;
            end;
          finally
            MainForm.Canvas.Font.Size := n;
            MainForm.Canvas.Font.Style := [];
          end;
        end;
      end;

      if g_boViewMiniMap then
      //g_PlayScene.DrawMiniMap(MSurface); //ԭ����PlayScn���л��Ƶģ�С��ͼ�ᱻ��Ʒ���ָ���  Development 2019-01-11
      FrmDlg.DrawMiniMap.Visible := True; //��FState���л��ƽ��С��ͼ����Ʒ���ָ���  Development 2019-01-11


      if (g_nAreaStateValue and 4) <> 0 then g_EiImageDraw.TextOut(0, 0, clWhite, clBlack, '��������');

      k := 0;
      for i := 0 to 1 do begin
        if g_nAreaStateValue and ($01 shl i) <> 0 then begin
          d := g_WMainImages.Images[150 + i];
          if d <> nil then begin
            k := k + d.Width;
            MSurface.Draw(SCREENWIDTH - k, 0, d.ClientRect, d, True);
          end;
        end;
      end;
      if frmMain.TimerAutoPlay.Enabled and (g_sAPstr <> '') then g_EiImageDraw.TextOut(190, 5, clLime, clBlack, g_sAPstr);
    end;
  end;
end;

procedure TDrawScreen.DrawScreenTop(MSurface: TDirectDrawSurface); //���Ͻ�����
var
  i, sX, sY: Integer;
begin
  if g_MySelf = nil then Exit;
  if CurrentScene = g_PlayScene then begin
    with g_DXCanvas do begin
      if m_SysMsgList.Count > 0 then begin
        sX := 20;
        if frmDlg.DWHeroStatus.Visible then
          sY := 88
        else sY := 30;
        for i := 0 to m_SysMsgList.Count - 1 do begin
          g_EiImageDraw.TextOut(sX, sY, clGreen, clBlack, m_SysMsgList[i]);
          Inc(sY, 16);
        end;
        if GetTickCount - LongWord(m_SysMsgList.Objects[0]) >= 3000 then m_SysMsgList.Delete(0);
      end;
    end;
  end;
end;

procedure TDrawScreen.DrawScreenBottom(MSurface: TDirectDrawSurface); //�������
var
  cl: TColor;
  i, sX, sY: Integer;
begin
  if g_MySelf = nil then Exit;
  if CurrentScene = g_PlayScene then begin
    with g_DXCanvas do begin
      if m_SysMsgListEx.Count > 0 then begin
        sX := 20;
        sY := SCREENHEIGHT - 250;
        for i := 0 to m_SysMsgListEx.Count - 1 do begin
          cl := clRed;
          if Pos('����', m_SysMsgListEx[i]) > 0 then
            cl := clLime;
          g_EiImageDraw.TextOut(sX, sY, cl, clBlack, m_SysMsgListEx[i]);
          Dec(sY, 16);
        end;
        if GetTickCount - LongWord(m_SysMsgListEx.Objects[0]) >= 3000 then m_SysMsgListEx.Delete(0);
      end;

      if m_SysMsgListEx2.Count > 0 then begin
        sY := SCREENHEIGHT - 270;
        for i := 0 to m_SysMsgListEx2.Count - 1 do begin
          cl := clRed;
          sX := SCREENWIDTH - TextWidth(m_SysMsgListEx2[i]) - 14;
          g_EiImageDraw.TextOut(sX, sY, cl, clBlack, m_SysMsgListEx2[i]);
          Dec(sY, 16);
        end;
        if GetTickCount - LongWord(m_SysMsgListEx2.Objects[0]) >= 4000 then m_SysMsgListEx2.Delete(0);
      end;
    end;
  end;
end;

procedure TDrawScreen.DrawScreenCenter(MSurface: TDirectDrawSurface); //��Ļ�м乫��
var
  sOutMsg: string;
  i, sX, sY: Integer;
  pm: PTCenterMsg;
begin
  if g_MySelf = nil then Exit;
  if CurrentScene = g_PlayScene then begin
    m_smListCnt.Lock;
    try
      if m_smListCnt.Count > 0 then begin
        sY := SCREENHEIGHT - 220;
        with g_DXCanvas do begin
          for i := m_smListCnt.Count - 1 downto 0 do begin
            pm := m_smListCnt[i];
            try
              if (GetTickCount - pm.dwNow) div 1000 < pm.dwSec then begin
                sOutMsg := pm.s;
                if Pos('%d', sOutMsg) > 0 then sOutMsg := Format(sOutMsg, [pm.dwSec - (GetTickCount - pm.dwNow) div 1000]);
                sX := (SCREENWIDTH - TextWidth(sOutMsg)) div 2 + 14;
                if pm.bc = 0 then
                  g_EiImageDraw.TextOut(sX, sY, pm.fc, $00050505, sOutMsg)
                else
                  g_EiImageDraw.TextOut(sX, sY, pm.fc, pm.bc, sOutMsg);
                Dec(sY, 16);
              end;
            except
              Break;
            end;
          end;
        end;
      end;
    finally
      m_smListCnt.UnLock;
    end;
  end;
end;

procedure TDrawScreen.ClearHint;
begin
  m_Hint1.ClearHint;
  m_Hint2.ClearHint;
  m_Hint3.ClearHint;
end;

procedure TDrawScreen.DrawHint(MSurface: TDirectDrawSurface);
begin
  m_Hint1.DrawHint(MSurface);
  m_Hint2.DrawHint(MSurface);
  m_Hint3.DrawHint(MSurface);
end;

end.




