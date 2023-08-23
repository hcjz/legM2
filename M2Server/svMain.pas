unit svMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  NMUDP, Buttons, StdCtrls, M2Share, ShellAPI, Grobal2, HUtil32, RunSock, Envir, ItmUnit, CnHashTable,
  Magic, NoticeM, Guild, Event, Castle, FrnEngn, UsrEngn, MudUtil, SyncObjs, Menus, ComCtrls, Grids,
  D7ScktComp, WinSock, Sockets, bDiaLogs, md5, TLHelp32, SqlEngn, DBSQL, psapi, HashList, StallSystem,
  IdTime, IdBaseComponent, IdComponent, IdIPWatch, VCLUnZip, VCLZip;

 Type

  TFrmMain = class(TForm)
    MemoLog: TMemo;
    Timer1: TTimer;
    RunTimer: TTimer;
    DBSocket: TClientSocket;
    ConnectTimer: TTimer;
    StartTimer: TTimer;
    SaveVariableTimer: TTimer;
    CloseTimer: TTimer;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_CONTROL_RELOAD_CONF: TMenuItem;
    MENU_CONTROL_CLEARLOGMSG: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_MANAGE: TMenuItem;
    MENU_CONTROL_RELOAD: TMenuItem;
    MENU_CONTROL_RELOAD_ITEMDB: TMenuItem;
    MENU_CONTROL_RELOAD_MAGICDB: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem;
    MENU_MANAGE_PLUG: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_SERVERCONFIG: TMenuItem;
    MENU_OPTION_GAME: TMenuItem;
    MENU_OPTION_FUNCTION: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem;
    MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem;
    MENU_CONTROL_GATE: TMenuItem;
    MENU_CONTROL_GATE_OPEN: TMenuItem;
    MENU_CONTROL_GATE_CLOSE: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_VIEW_GATE: TMenuItem;
    MENU_VIEW_SESSION: TMenuItem;
    MENU_VIEW_ONLINEHUMAN: TMenuItem;
    MENU_VIEW_LEVEL: TMenuItem;
    MENU_VIEW_LIST: TMenuItem;
    MENU_MANAGE_ONLINEMSG: TMenuItem;
    MENU_VIEW_KERNELINFO: TMenuItem;
    MENU_TOOLS: TMenuItem;
    MENU_TOOLS_MERCHANT: TMenuItem;
    MENU_TOOLS_NPC: TMenuItem;
    MENU_OPTION_ITEMFUNC: TMenuItem;
    MENU_TOOLS_MONGEN: TMenuItem;
    MENU_TOOLS_TEST: TMenuItem;
    DECODESCRIPT: TMenuItem;
    MENU_CONTROL_RELOAD_STARTPOINT: TMenuItem;
    G1: TMenuItem;
    MenuStackTest: TMenuItem;
    MENU_OPTION_MONSTER: TMenuItem;
    MENU_TOOLS_IPSEARCH: TMenuItem;
    MENU_MANAGE_CASTLE: TMenuItem;
    MENU_CONTROL_RELOAD_SABAK: TMenuItem;
    N1: TMenuItem;
    Panel1: TPanel;
    LbRunTime: TLabel;
    LbUserCount: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    LbRunSocketTime: TLabel;
    Label20: TLabel;
    MemStatus: TLabel;
    GridGate: TStringGrid;
    MENU_VIEW_HIGHRANK: TMenuItem;
    MENU_CONTROL_RELOAD_QFUNCTIONSCRIPT: TMenuItem;
    LogUDP: TNMUDP;
    N3: TMenuItem;
    MENU_CONTROL_RELOAD_QMagegeScriptClick: TMenuItem;
    Splitter: TSplitter;
    MENU_CONTROL_RELOAD_BOXITEM: TMenuItem;
    MENU_CONTROL_RELOAD_REFINEITEM: TMenuItem;
    RELOADHILLITEMNAMELIST: TMenuItem;
    M1: TMenuItem;
    IdIPWatch: TIdIPWatch;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    NPCM1: TMenuItem;
    NPCN1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MemoLogChange(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
    procedure MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_GAMEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MENU_OPTION_FUNCTIONClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_OPENClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
    procedure MENU_CONTROLClick(Sender: TObject);
    procedure MENU_VIEW_GATEClick(Sender: TObject);
    procedure MENU_VIEW_SESSIONClick(Sender: TObject);
    procedure MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
    procedure MENU_VIEW_LEVELClick(Sender: TObject);
    procedure MENU_VIEW_LISTClick(Sender: TObject);
    procedure MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
    procedure MENU_VIEW_KERNELINFOClick(Sender: TObject);
    procedure MENU_TOOLS_MERCHANTClick(Sender: TObject);
    procedure MENU_OPTION_ITEMFUNCClick(Sender: TObject);
    procedure MENU_TOOLS_MONGENClick(Sender: TObject);
    procedure DECODESCRIPTClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_STARTPOINTClick(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure MENU_OPTION_MONSTERClick(Sender: TObject);
    procedure MENU_TOOLS_IPSEARCHClick(Sender: TObject);
    procedure MENU_MANAGE_CASTLEClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_SABAKClick(Sender: TObject);
    procedure MENU_TOOLS_NPCClick(Sender: TObject);
    procedure MENU_VIEW_HIGHRANKClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_QFUNCTIONSCRIPTClick(Sender: TObject);
    procedure MENU_MANAGE_PLUGClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_QMagegeScriptClickClick(Sender: TObject);
    procedure MemStatusClick(Sender: TObject);
    procedure MENU_TOOLS_TESTClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_BOXITEMClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_REFINEITEMClick(Sender: TObject);
    procedure RELOADHILLITEMNAMELISTClick(Sender: TObject);
    procedure M1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure NPCM1Click(Sender: TObject);
    procedure NPCN1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    Liu: String;
    boServiceStarted: Boolean;
    procedure GateSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure SaveVariableTimerTimer(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);
    procedure ConnectTimerTimer(Sender: TObject);
    procedure StartService();
    procedure StopService();
    procedure SaveItemNumber(boSaveVal: Boolean);
    function  LoadClientFile(): Boolean;

    procedure StartEngine;
    procedure MakeStoneMines;
    procedure ReloadConfig(Sender: TObject);
    procedure ClearMemoLog();
    procedure CloseGateSocket();
  public
    GateSocket: TServerSocket;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
  end;

function LoadAbuseInformation(FileName: string): Boolean;
procedure LoadServerTable();
procedure WriteConLog(MsgList: TStringlist);
procedure ChangeCaptionText(msg: PChar; nLen: Integer); stdcall;
procedure ChangeLabelVerColor(nColor: Integer); stdcall;
procedure UserEngineThread(ThreadInfo: pTThreadInfo); stdcall;
procedure ProcessGameRun();


var
  FrmMain           : TFrmMain;
  g_GateSocket      : TServerSocket;
  g_dwGetResStrTick : LongWord;
  g_dwCheckHDTick   : LongWord;
  l_dwRunTimeTick, l_dwRunTimeTick2: LongWord;
  g_lpDateTime      : TDateTime = 0;

implementation

uses
  LocalDB, InterServerMsg, InterMsgClient, IdSrvClient, FSrvValue, GeneralConfig, GameConfig,
  FunctionConfig, ObjRobot, ViewSession, ViewOnlineHuman, ViewLevel, ViewList, OnlineMsg,
  ViewKernelInfo, PlugIn, ConfigMerchant, ItemSet, ConfigMonGen, EDcode, EncryptUnit, AdaptersInfo,
  PlugInManage, GameCommand, MonsterConfig, RunDB, CastleManage, SDK, ViewHighRank, StartPointManage, ObjBase, __DESUnit;

var
  sCaption          : string;
  sCaptionExtText   : string;
  c_dwRunTimeTick   : LongWord = 0;
  l_dwSaveTimeTick  : LongWord = 0;
  boRemoteOpenGateSocket: Boolean = False;
  boRemoteOpenGateSocketed: Boolean = False;
  g_SaveGlobalValNo : Integer = 0;

{$R *.dfm}

procedure ChangeCaptionText(msg: PChar; nLen: Integer); stdcall;
var
  sMsg              : string;
begin
  if (nLen > 0) and (nLen < 30) then begin
    SetLength(sMsg, nLen);
    Move(msg^, sMsg[1], nLen);
    sCaptionExtText := sMsg;
  end;
end;

procedure ChangeLabelVerColor(nColor: Integer); stdcall;
begin
  case nColor of
    1: FrmMain.MemStatus.Font.Color := clRed;
    2: FrmMain.MemStatus.Font.Color := clBlue;
  else
    FrmMain.MemStatus.Font.Color := clBlack;
  end;
end;

procedure PlugRunOver(); stdcall;
begin
  boRemoteOpenGateSocket := True;
  if RemoteXORKey <> LocalXORKey then begin
    //sChar := '?';
    //sRun := 'run';
    FrontEngine.Suspend;
  end;
end;


function LoadAbuseInformation(FileName: string): Boolean;
var
  i                 : Integer;
  sText             : string;
begin
  Result := False;
  if FileExists(FileName) then begin
    AbuseTextList.Clear;
    AbuseTextList.LoadFromFile(FileName);
    i := 0;
    while (True) do begin
      if AbuseTextList.Count <= i then
        Break;
      sText := Trim(AbuseTextList.Strings[i]);
      if sText = '' then begin
        AbuseTextList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result := True;
  end;
end;

procedure LoadServerTable();
var
  i                 : Integer;
  LoadList          : TStringlist;
  nRouteIdx, nGateIdx, nServerIndex: Integer;
  sLineText, sIdx, sSelGateIPaddr, sGameGateIPaddr, sGameGate, sGameGatePort, sMapName, sMapInfo, sServerIndex: string;
begin
  FillChar(g_RouteInfo, SizeOf(g_RouteInfo), #0);
  LoadList := TStringlist.Create;
  LoadList.LoadFromFile('.\!ServerTable.txt');
  nRouteIdx := 0;
  for i := 0 to LoadList.Count - 1 do begin
    sLineText := LoadList.Strings[i];
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      sLineText := GetValidStr3(sLineText, sIdx, [' ', #9]);
      sGameGate := GetValidStr3(sLineText, sSelGateIPaddr, [' ', #9]);
      if (sIdx = '') or (sGameGate = '') or (sSelGateIPaddr = '') then Continue;
      g_RouteInfo[nRouteIdx].nGateCount := 0;
      g_RouteInfo[nRouteIdx].nServerIdx := Str_ToInt(sIdx, 0);
      g_RouteInfo[nRouteIdx].sSelGateIP := Trim(sSelGateIPaddr);
      nGateIdx := 0;
      while (sGameGate <> '') do begin
        sGameGate := GetValidStr3(sGameGate, sGameGateIPaddr, [' ', #9]);
        sGameGate := GetValidStr3(sGameGate, sGameGatePort, [' ', #9]);
        g_RouteInfo[nRouteIdx].sGameGateIP[nGateIdx] := Trim(sGameGateIPaddr);
        g_RouteInfo[nRouteIdx].nGameGatePort[nGateIdx] := Str_ToInt(sGameGatePort, 0);
        Inc(nGateIdx);
      end;
      g_RouteInfo[nRouteIdx].nGateCount := nGateIdx;
      Inc(nRouteIdx);
      if nRouteIdx > High(g_RouteInfo) then Break
    end;
  end;
  LoadList.Free;
end;

procedure WriteConLog(MsgList: TStringlist);
var
  i                 : Integer;
  Year, Month, Day, Hour, Min, Sec, msec: Word;
  sLogDir, sLogFileName: string;
  LogFile           : TextFile;
begin
  if MsgList.Count <= 0 then Exit;
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, msec);
  if not DirectoryExists(g_Config.sConLogDir) then
    CreateDir(g_Config.sConLogDir);
  sLogDir := g_Config.sConLogDir + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day);
  if not DirectoryExists(sLogDir) then
    CreateDirectory(PChar(sLogDir), nil);
  sLogFileName := sLogDir + '\C-' + IntToStr(g_nServerIndex) + '-' + IntToStr2(Hour) + 'H' + IntToStr2((Min div 10 * 2) * 5) + 'M.txt';
  AssignFile(LogFile, sLogFileName);
  if not FileExists(sLogFileName) then
    Rewrite(LogFile)
  else
    Append(LogFile);
  for i := 0 to MsgList.Count - 1 do
    Writeln(LogFile, '1' + #9 + MsgList.Strings[i]);
  CloseFile(LogFile);
end;



procedure TFrmMain.SaveItemNumber(boSaveVal: Boolean);
var
  i, n, t           : Integer;
begin
  Config.WriteInteger('Setup', 'ItemNumber', g_Config.nItemNumber);
  Config.WriteInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);
  if boSaveVal or ((GetTickCount - l_dwSaveTimeTick) > 15 * 60 * 1000) then begin
    l_dwSaveTimeTick := GetTickCount;
    if not boSaveVal then begin
      case g_SaveGlobalValNo of
        0: for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do
            Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i), g_Config.GlobalVal[i]);
        1: for i := Low(g_Config.HGlobalVal) to High(g_Config.HGlobalVal) do
            Config.WriteInteger('Setup', 'HGlobalVal' + IntToStr(i), g_Config.HGlobalVal[i]);
        2: for i := Low(g_Config.GlobaDyTval) to High(g_Config.GlobaDyTval) do
            Config.WriteString('Setup', 'GlobaStrVal' + IntToStr(i), Trim(g_Config.GlobaDyTval[i]));
      end;
    end else begin
      for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do
        Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i), g_Config.GlobalVal[i]);
      for i := Low(g_Config.HGlobalVal) to High(g_Config.HGlobalVal) do
        Config.WriteInteger('Setup', 'HGlobalVal' + IntToStr(i), g_Config.HGlobalVal[i]);
      for i := Low(g_Config.GlobaDyTval) to High(g_Config.GlobaDyTval) do
        Config.WriteString('Setup', 'GlobaStrVal' + IntToStr(i), Trim(g_Config.GlobaDyTval[i]));
    end;
    Inc(g_SaveGlobalValNo);
    if g_SaveGlobalValNo > 2 then g_SaveGlobalValNo := 0;
    Config.WriteInteger('Setup', 'WinLotteryCount', g_Config.nWinLotteryCount);
    Config.WriteInteger('Setup', 'NoWinLotteryCount', g_Config.nNoWinLotteryCount);
    Config.WriteInteger('Setup', 'WinLotteryLevel1', g_Config.nWinLotteryLevel1);
    Config.WriteInteger('Setup', 'WinLotteryLevel2', g_Config.nWinLotteryLevel2);
    Config.WriteInteger('Setup', 'WinLotteryLevel3', g_Config.nWinLotteryLevel3);
    Config.WriteInteger('Setup', 'WinLotteryLevel4', g_Config.nWinLotteryLevel4);
    Config.WriteInteger('Setup', 'WinLotteryLevel5', g_Config.nWinLotteryLevel5);
    Config.WriteInteger('Setup', 'WinLotteryLevel6', g_Config.nWinLotteryLevel6);
  end;
end;

procedure TFrmMain.AppOnIdle(Sender: TObject; var Done: Boolean);
begin
  //MainOutMessageAPI ('空闲');
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessageAPI(E.Message);
end;

procedure TFrmMain.DBSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  tStr              : string;
begin
  EnterCriticalSection(UserDBSection);
  try
    tStr := Socket.ReceiveText;
    g_Config.sDBSocketRecvText := g_Config.sDBSocketRecvText + tStr;
    if not g_Config.boDBSocketWorking then
      g_Config.sDBSocketRecvText := '';
  finally
    LeaveCriticalSection(UserDBSection);
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  boWriteLog        : Boolean;
  i, nRow           : Integer;
  wDay, wHour, wMinute, wSecond: Word;
  tSecond           : Integer;
  sSrvType          : string;
  sVerType          : string;
  tTimeCount        : Currency;
  GateInfo          : pTGateInfo;
  LogFile           : TextFile;
  MemoryStream      : TMemoryStream;
  s28               : string;
begin

 Caption := Format('%s', [g_Config.sServerName]);


  EnterCriticalSection(LogMsgCriticalSection);
  try
    if MemoLog.Lines.Count > 500 then MemoLog.Clear;
    boWriteLog := True;
    if MainLogMsgList.Count > 0 then begin
      try
        if not FileExists(sLogFileName) then begin
          AssignFile(LogFile, sLogFileName);
          Rewrite(LogFile);
        end else begin
          AssignFile(LogFile, sLogFileName);
          Append(LogFile);
        end;
        boWriteLog := False;
      except
        MemoLog.Lines.Add('保存日志信息出错！');
      end;
    end;

    for i := 0 to MainLogMsgList.Count - 1 do begin
      MemoLog.Lines.Add(MainLogMsgList.Strings[i]);
      if not boWriteLog then
        Writeln(LogFile, MainLogMsgList.Strings[i]);
    end;
    MainLogMsgList.Clear;

    if not boWriteLog then CloseFile(LogFile);

    for i := 0 to LogStringList.Count - 1 do begin
      MemoryStream := TMemoryStream.Create;
      try
        s28 := '1' + #9 + IntToStr(g_Config.nServerNumber) + #9 + IntToStr(g_nServerIndex) + #9 + LogStringList.Strings[i];
        MemoryStream.Write(s28[1], Length(s28));
        LogUDP.SendStream(MemoryStream);
      finally
        MemoryStream.Free;
      end;
    end;
    LogStringList.Clear;

    if LogonCostLogList.Count > 0 then
      WriteConLog(LogonCostLogList);
    LogonCostLogList.Clear;
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;



{$IF SoftVersion = VERDEMO}
  sVerType := '[D]';
{$ELSEIF SoftVersion = VERFREE}
  sVerType := '[F]';
{$ELSEIF SoftVersion = VERSTD}
  sVerType := '[S]';
{$ELSEIF SoftVersion = VEROEM}
  sVerType := '[O]';
{$ELSEIF SoftVersion = VERPRO}
  sVerType := '[P]';
{$ELSEIF SoftVersion = VERENT}
  sVerType := '[E]';
{$IFEND}

  if g_nServerIndex = 0 then sSrvType := '[M]' else if FrmMsgClient.MsgClient.Socket.Connected then sSrvType := '[S]' else sSrvType := '[ ]';
  nRow := UserEngine.OfflinePlayCount;
  LbUserCount.Caption := Format('(%d) [%d+%d/%d][%d/%d/%d]', [UserEngine.MonsterCount, nRow, UserEngine.OnlinePlayObject - nRow, UserEngine.PlayObjectCount, FrontEngine.SaveListCount, UserEngine.LoadPlayCount, UserEngine.m_PlayObjectFreeList.Count]);
  Label1.Caption := Format('Run(%d/%d) Soc(%d/%d) Usr(%d/%d)', [nRunTimeMin, nRunTimeMax, g_nSockCountMin, g_nSockCountMax, g_nUsrTimeMin, g_nUsrTimeMax]);
  Label2.Caption := Format('Hum%d/%d Her%d/%d Usr%d/%d Mer%d/%d Npc%d/%d', [g_nHumCountMin, g_nHumCountMax, UserEngine.dwProcessHeroTimeMin, UserEngine.dwProcessHeroTimeMax, dwUsrRotCountMin, dwUsrRotCountMax, UserEngine.dwProcessMerchantTimeMin, UserEngine.dwProcessMerchantTimeMax, UserEngine.dwProcessNpcTimeMin, UserEngine.dwProcessNpcTimeMax]);
  Label5.Caption := Format('[%s]  [%s]', [g_sMonGenInfo1, g_sMonGenInfo2]);
  Label20.Caption := Format('Mong(%d/%d/%d) Monp(%d/%d/%d) ObjRun(%d/%d)', [g_nMonGenTime, g_nMonGenTimeMin, g_nMonGenTimeMax, g_nMonProcTime, g_nMonProcTimeMin, g_nMonProcTimeMax, g_nBaseObjTimeMin, g_nBaseObjTimeMax]);

  if (MemStatus.Caption = '') or (GetTickCount - g_dwGetResStrTick > 5 * 60 * 1000) then begin
    g_dwGetResStrTick := GetTickCount;
    MemStatus.Caption := GetResourceString(t_sUpDateTime);
  end;

  tSecond := (GetTickCount - g_dwStartTick) div 1000;
  wDay := tSecond div (3600 * 24);
  wHour := (tSecond div 3600) mod 24;
  wMinute := (tSecond div 60) mod 60;
  wSecond := tSecond mod 60;
  tTimeCount := GetTickCount() / (24 * 60 * 60 * 1000);
  if tTimeCount >= 30 then LbRunSocketTime.Font.Color := clRed else LbRunSocketTime.Font.Color := clBlack;
  LbRunSocketTime.Caption := sSrvType + '[' + IntToStr(wDay) + ':' + IntToStr(wHour) + ':' + IntToStr(wMinute) + ':' + IntToStr(wSecond) + '/' + CurrToStr(tTimeCount) + ']'; // + ' ' + sSrvType + sVerType;

  nRow := 1;
  for i := Low(g_GateArr) to High(g_GateArr) do begin
    GridGate.Cells[0, i + 1] := '';
    GridGate.Cells[1, i + 1] := '';
    GridGate.Cells[2, i + 1] := '';
    GridGate.Cells[3, i + 1] := '';
    GridGate.Cells[4, i + 1] := '';
    GridGate.Cells[5, i + 1] := '';
    GridGate.Cells[6, i + 1] := '';
    GateInfo := @g_GateArr[i];
    if GateInfo.boUsed and (GateInfo.Socket <> nil) then begin
      GridGate.Cells[0, nRow] := IntToStr(i);
      GridGate.Cells[1, nRow] := GateInfo.sAddr + ':' + IntToStr(GateInfo.nPort);
      GridGate.Cells[2, nRow] := IntToStr(GateInfo.nSendMsgCount);
      GridGate.Cells[3, nRow] := IntToStr(GateInfo.nSendedMsgCount);
      GridGate.Cells[4, nRow] := IntToStr(GateInfo.nSendRemainCount);
      if GateInfo.nSendMsgBytes < 1024 then
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes) + 'b'
      else
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes div 1024) + 'kb';
      GridGate.Cells[6, nRow] := IntToStr(GateInfo.nUserCount) + '/' + IntToStr(GateInfo.UserList.Count);
      Inc(nRow);
    end;
  end;
  Inc(nRunTimeMax);
  if g_nSockCountMax > 0 then Dec(g_nSockCountMax);
  if g_nUsrTimeMax > 0 then Dec(g_nUsrTimeMax);
  if g_nHumCountMax > 0 then Dec(g_nHumCountMax);
  if g_nMonTimeMax > 0 then Dec(g_nMonTimeMax);
  if dwUsrRotCountMax > 0 then Dec(dwUsrRotCountMax);
  if g_nMonGenTimeMin > 1 then Dec(g_nMonGenTimeMin, 2);
  if g_nMonProcTimeMin > 1 then Dec(g_nMonProcTimeMin, 2);
  if g_nBaseObjTimeMax > 0 then Dec(g_nBaseObjTimeMax);
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
var
  i, nCode, nVar, nCheckVar: Integer;
  sHash             : string;
  MachineId         : array[0..100] of Char;

  Info              : STARTUPINFO;
resourcestring
  sStartMsg         = '正在启动游戏主程序...';
  sStartOkMsg       = '游戏主程序启动完成...';
begin
  SendGameCenterMsg(SG_STARTNOW, sStartMsg);
  StartTimer.Enabled := False;
  FrmDB := TFrmDB.Create();
  try
    StartService();
    if SizeOf(THumDataInfo) <> SIZEOFTHUMAN then begin
      ShowMessage('SizeOf(THuman) ' + IntToStr(SizeOf(THumDataInfo)) + ' <> SIZEOFTHUMAN ' + IntToStr(SIZEOFTHUMAN));
      Close;
      Exit;
    end;
    if not LoadClientFile then begin
      Close;
      Exit;
    end;
{$IF DBTYPE = BDE}
    FrmDB.Query.DatabaseName := sDBName;
{$ELSE}
    FrmDB.Query.ConnectionString := g_sADODBString;
{$IFEND}

    InitIPNeedExps();

    MemoLog.Lines.Add('正在加载物品数据库...');
    nCode := FrmDB.LoadItemsDB;
    if nCode < 0 then begin
     MemoLog.Lines.Add('物品数据库加载失败' + 'Code: ' + IntToStr(nCode));
     Exit;
    end;
    MemoLog.Lines.Add(Format('物品数据库加载成功(%d)...', [UserEngine.StdItemList.Count]));

    LoadGameLogItemNameList();
    LoadNoClearMonList();
    LoadUserDataList();
    LoadSuiteItemsList();
    FrmDB.LoadItemsDB();

    LoadPetPickItemList();
    MemoLog.Lines.Add('加载英雄可捡物品配置列表完成...');
    LoadDenyIPAddrList();
    LoadDenyAccountList();
    LoadDenyChrNameList();
    LoadHintItemList();

    g_DigItemList := TStringlist.Create;
    LoadDigItemList();

    MemoLog.Lines.Add('正在加载数据图文件...');
    nCode := FrmDB.LoadMinMap;
    if nCode < 0 then begin
     MemoLog.Lines.Add('小地图数据加载失败' + 'Code: ' + IntToStr(nCode));
     Exit;
    end;
    MemoLog.Lines.Add('小地图数据加载成功...');

    MemoLog.Lines.Add('正在加载怪物数据库...');
    nCode := FrmDB.LoadMonsterDB;
    if nCode < 0 then begin
     MemoLog.Lines.Add('加载怪物数据库失败' + 'Code: ' + IntToStr(nCode));
     Exit;
    end;
    MemoLog.Lines.Add(Format('加载怪物数据库成功(%d)...', [UserEngine.MonsterList.Count]));

    MemoLog.Lines.Add('正在加载技能数据库...');
    nCode := FrmDB.LoadMagicDB;
    if nCode < 0 then begin
     MemoLog.Lines.Add('加载技能数据库失败' + 'Code: ' + IntToStr(nCode));
     Exit;
    end;
    MemoLog.Lines.Add(Format('加载技能数据库成功(%d)...', [UserEngine.m_MagicList.Count]));

    MemoLog.Lines.Add('正在加载地图数据...');
    nCode := FrmDB.LoadMapInfo;
    if nCode < 0 then begin
     MemoLog.Lines.Add('地图数据加载失败' + 'Code: ' + IntToStr(nCode));
     Exit;
    end;
    MemoLog.Lines.Add(Format('地图数据加载成功(%d)...', [g_MapManager.Count]));

    MemoLog.Lines.Add('正在加载怪物刷新配置信息...');
    nCode := FrmDB.LoadMonGen;
    if nCode < 0 then begin
     MemoLog.Lines.Add('加载怪物刷新配置信息失败' + 'Code: ' + IntToStr(nCode));
     Exit;
    end;
    MemoLog.Lines.Add(Format('加载怪物刷新配置信息成功(%d)...', [UserEngine.m_MonGenList.Count]));

    MemoLog.Lines.Add('正加载怪物说话配置信息...');
    LoadMonSayMsg();
    MemoLog.Lines.Add(Format('加载怪物说话配置信息成功(%d)...', [g_MonSayMsgList.Count]));

    LoadAllowBindNameList();
    MemoLog.Lines.Add(Format('加载允许绑定列表成功(%d)...', [g_AllowBindNameList.Count]));

    LoadItemLimitList();
    MemoLog.Lines.Add('加载物品规则配置列表完成...');

    LoadDeathWalkingSays();

    LoadUserBuyItemList();
    MemoLog.Lines.Add('加载传奇商城配置列表完成...');
    LoadShopItemList();
    MemoLog.Lines.Add('加载传奇商铺(新)配置列表完成...');

    LoadUserCmdList();
    MemoLog.Lines.Add('加载自定义命令配置列表完成...');
    LoadGuildRankNameFilterList();
    MemoLog.Lines.Add('加载行会字符过滤配置列表完成...');


    LoadMonDropLimitList();
    LoadDisableMoveMap;
    nCode := LoadMissionList();

    if nCode > 0 then MemoLog.Lines.Add(Format('加载任务导航列表完成(%d)...', [nCode]));
    ItemUnit.LoadCustomItemName();
    LoadDisableSendMsgList();
    LoadItemBindIPaddr();
    LoadItemBindAccount();
    LoadItemBindCharName();
    LoadUnMasterList();
    LoadUnForceMasterList();

    MemoLog.Lines.Add('正在加载捆装物品信息...');
    nCode := FrmDB.LoadUnbindList;
    if nCode < 0 then begin
     MemoLog.Lines.Add('加载捆装物品信息失败' + 'Code: ' + IntToStr(nCode));
     Exit;
    end;
    MemoLog.Lines.Add('加载捆装物品信息成功...');

    MemoLog.Lines.Add('正在加载任务地图信息...');
    nCode := FrmDB.LoadMapQuest;
    if nCode < 0 then begin
     MemoLog.Lines.Add('加载任务地图信息失败！！！');
     Exit;
    end;
    MemoLog.Lines.Add('加载任务地图信息成功...');

    MemoLog.Lines.Add('正在加载任务说明信息...');
    nCode := FrmDB.LoadQuestDiary;
    if nCode < 0 then begin
     MemoLog.Lines.Add('加载任务说明信息失败');
     Exit;
    end;
    MemoLog.Lines.Add('加载任务说明信息成功...');

    if LoadAbuseInformation('.\!abuse.txt') then
    MemoLog.Lines.Add('加载文字过滤信息成功...');

    MemoLog.Lines.Add('正在加载公告提示信息...');
    if not LoadLineNotice(g_Config.sNoticeDir + 'LineNotice.txt') then
    MemoLog.Lines.Add('加载公告提示信息失败');
    MemoLog.Lines.Add('加载公告提示信息成功...');

    FrmDB.LoadAdminList();
    MemoLog.Lines.Add('管理员列表加载成功...');
    g_GuildManager.LoadGuildInfo();
    MemoLog.Lines.Add('行会列表加载成功...');

    g_CastleManager.LoadCastleList();
    MemoLog.Lines.Add('城堡列表加载成功...');

    g_CastleManager.Initialize;
    MemoLog.Lines.Add('城堡城初始完成...');

    if g_DBSQL.Connect(g_Config.sServerName, '.\!DBSQL.TXT') then
     MemoLog.Lines.Add('数据库连接成功...')
    else
     MemoLog.Lines.Add('数据库连接失败...');

{$IF INTERSERVER = 1}
      if g_nServerIndex = 0 then
        FrmSrvMsg.StartMsgServer
      else
        FrmMsgClient.ConnectMsgServer;
{$IFEND}
      StartEngine();
      boStartReady := True;
      Sleep(500);

{$IF DBSOCKETMODE = TIMERENGINE}
      ConnectTimer.Enabled := True;
{$ELSE}
      FillChar(g_Config.DBSOcketThread, SizeOf(g_Config.DBSOcketThread), 0);
      g_Config.DBSOcketThread.Config := @g_Config;
      g_Config.DBSOcketThread.hThreadHandle := CreateThread(nil,
        0,
        @DBSOcketThread,
        @g_Config.DBSOcketThread,
        0,
        g_Config.DBSOcketThread.dwThreadID);
{$IFEND}

{$IF IDSOCKETMODE = THREADENGINE}
      FillChar(g_Config.IDSocketThread, SizeOf(g_Config.IDSocketThread), 0);
      g_Config.IDSocketThread.Config := @g_Config;
      g_Config.IDSocketThread.hThreadHandle := CreateThread(nil,
        0,
        @IDSocketThread,
        @g_Config.IDSocketThread,
        0,
        g_Config.IDSocketThread.dwThreadID);

{$IFEND}
      g_dwRunTick := GetTickCount();

      g_nRunTimes := 0;
      g_dwUsrRotCountTick := GetTickCount();

{$IF USERENGINEMODE = THREADENGINE}
      FillChar(g_Config.UserEngineThread, SizeOf(g_Config.UserEngineThread), 0);
      for i := 0 to 2 - 1 do begin
        g_Config.UserEngineThread[i].Config := @g_Config;
        g_Config.UserEngineThread[i].hThreadHandle := CreateThread(nil,
          0,
          @UserEngineThread,
          @g_Config.UserEngineThread[i],
          0,
          g_Config.UserEngineThread[i].dwThreadID);
      end;
{$IFEND}

      RunTimer.Enabled := True;
      SendGameCenterMsg(SG_STARTOK, sStartOkMsg);
      GateSocket.Address := g_Config.sGateAddr;
      GateSocket.Port := g_Config.nGatePort;
      g_GateSocket := GateSocket;
{$IF SoftVersion <> VERDEMO}
      PlugInEngine.StartM2ServerDLL;
{$IFEND}

{$IF SoftVersion = VERDEMO}
      boRemoteOpenGateSocket := True;
{$IFEND}
      MENU_CONTROL_GATE_OPENClick(self);
  except
    on E: Exception do MainOutMessageAPI('Start ServerEngine Exception, ' + E.Message);
  end;
end;

procedure TFrmMain.StartEngine();
var
  S                 : string;
  n, nCode          : Integer;
begin
  n := 0;
  try
    n := 1;
{$IF IDSOCKETMODE = TIMERENGINE}
    FrmIDSoc.Initialize;
    MemoLog.Lines.Add('登录服务器连接初始化完成...');
{$IFEND}
    n := 2;
    g_MapManager.LoadMapDoor;
    MemoLog.Lines.Add('地图环境加载成功...');

    n := 3;
    MakeStoneMines();
    MemoLog.Lines.Add('矿物数据初始成功...');

    n := 4;
    nCode := FrmDB.LoadMerchant;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load Merchant Error ' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('交易NPC列表加载成功...');

    n := 5;
    if not g_Config.boVentureServer then begin
      nCode := FrmDB.LoadGuardList;
      if nCode < 0 then begin
        MemoLog.Lines.Add('Load GuardList Error ' + 'Code: ' + IntToStr(nCode));
        Exit;
      end;
      MemoLog.Lines.Add('守卫列表加载成功...');
    end;

    n := 6;
    nCode := FrmDB.LoadNpcs;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load NpcList Error ' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('管理NPC列表加载成功...');

    n := 7;
    nCode := FrmDB.LoadMakeItem;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load MakeItem Error ' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('炼制物品信息加载成功...');

    n := 8;
    nCode := FrmDB.LoadBoxItem;
    if nCode < 0 then
      MemoLog.Lines.Add('Load BoxItemList Error ' + 'Code: ' + IntToStr(nCode))
    else
      MemoLog.Lines.Add('宝箱物品信息加载成功...');

    n := 9;
    nCode := FrmDB.LoadRefineItem;
    if nCode < 0 then
      MemoLog.Lines.Add('Load LoadRefineItemList Error ' + 'Code: ' + IntToStr(nCode))
    else
      MemoLog.Lines.Add('淬炼物品信息加载成功...');

    n := 10;
    if g_StartPointManager.Initialize(S) then
      MemoLog.Lines.Add('加载回城点配置成功...')
    else begin
      MemoLog.Lines.Add(S + ' 地图不存在，加载回城点配置失败...');
      Exit;
    end;

    n := 11;
    if g_Config.boSafeZoneAureole then begin
      g_StartPointManager.CreateAureole();
      MemoLog.Lines.Add('安全区光环效果初始完成...');
    end;

    n := 12;
    FrontEngine.Resume;

    n := 13;
    g_SQlEngine.Resume;
    MemoLog.Lines.Add('人物数据引擎启动成功...');

    n := 14;
    UserEngine.Initialize;
    MemoLog.Lines.Add('游戏处理引擎初始化成功...');
    MemoLog.Lines.Add('===============================================');
    MemoLog.Lines.Add('无限制版引擎：LGEGEND引擎');
    MemoLog.Lines.Add('程序反馈：QQ：8302775 群号：858641818 715347659');
    MemoLog.Lines.Add('更新日期：2019-02-03');
    MemoLog.Lines.Add('非以上QQ均属假冒，请注意！');
    MemoLog.Lines.Add('===============================================');

  except
    on E: Exception do begin
      MainOutMessageAPI('服务启动时出现异常错误！ Code:' + IntToStr(n));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

procedure TFrmMain.M1Click(Sender: TObject);
var
  i                 : Integer;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    i := LoadMissionList();
    if i > 0 then
      MainOutMessageAPI(Format('重新加载任务导航列表完成(%d)...', [i]))
    else
      MainOutMessageAPI('加载任务导航列表失败!');
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MakeStoneMines();
var
  i, n, nW, nH, nt, x, y, z: Integer;
  Envir             : TEnvirnoment;
  sme               : TStoneMineEvent;
  NimbusEvent       : TNimbusEvent;
  MapCellInfo       : pTMapCellinfo;
begin
  for i := 0 to g_MapManager.Count - 1 do begin
{$IF USEHASHLIST = 1}
    Envir := TEnvirnoment(g_MapManager.GetValues(g_MapManager.Keys[i]));
{$ELSE}
    Envir := TEnvirnoment(g_MapManager[i]);
{$IFEND}
    if Envir.m_MapFlag.boMINE then begin
      for nW := 0 to Envir.m_MapHeader.wWidth - 1 do begin
        for nH := 0 to Envir.m_MapHeader.wHeight - 1 do begin
          sme := TStoneMineEvent.Create(Envir, nW, nH, ET_STONEMINE);
          if not sme.m_boAddToMap then
            FreeAndNil(sme);
        end;
      end;
    end;
    //挖宝
    n := 0;
    if Envir.m_MapFlag.nDigItem > 0 then begin
      x := 11 + Random(8);
      y := 11 + Random(8);
      for nW := 0 to Envir.m_MapHeader.wWidth - 1 do begin
        if x > 0 then Dec(x);
        z := 0;
        for nH := 0 to Envir.m_MapHeader.wHeight - 1 do begin
          if y > 0 then Dec(y);
          if Envir.GetMapCellInfo(nW, nH, MapCellInfo) and (MapCellInfo.chFlag = 0) and ((x = 0) and (y = 0)) then begin
            //if Random(Envir.m_MapFlag.nDigItem) = 0 then begin

            if Random(35) = 0 then
              nt := ET_ITEMMINE3
            else if Random(8) = 0 then
              nt := ET_ITEMMINE2
            else
              nt := ET_ITEMMINE1;

            sme := TStoneMineEvent.Create(Envir, nW, nH, nt);
            if not sme.m_boAddToMap then
              FreeAndNil(sme)
            else begin
              Inc(n);
              Inc(z);
              //if x = 0 then x := 22 + Random(15) + Random(Envir.m_MapFlag.nDigItem);
              if y = 0 then y := 15 + Random(12) + Random(Envir.m_MapFlag.nDigItem);
            end;

            //end;
          end;
        end;
        if (z > 0) and (x = 0) then x := 15 + Random(12) + Random(Envir.m_MapFlag.nDigItem);
      end;
    end;
    if n > 0 then
      MemoLog.Lines.Add(Format('                            %s加载宝藏(%d)处', [Envir.m_sMapDesc, n]));
  end;
end;

function TFrmMain.LoadClientFile(): Boolean;
begin
  Result := True;
  MemoLog.Lines.Add('正在加载客户端版本信息...');
  if not (g_Config.sClientFile1 = '') then
    g_Config.nClientFile1_CRC := CalcFileCRC(g_Config.sClientFile1);
  if not (g_Config.sClientFile2 = '') then
    g_Config.nClientFile2_CRC := CalcFileCRC(g_Config.sClientFile2);
  if not (g_Config.sClientFile3 = '') then
    g_Config.nClientFile3_CRC := CalcFileCRC(g_Config.sClientFile3);
  if (g_Config.nClientFile1_CRC <> 0) or (g_Config.nClientFile2_CRC <> 0) or (g_Config.nClientFile3_CRC <> 0) then
    MemoLog.Lines.Add('加载客户端版本信息成功...')
  else begin
    MemoLog.Lines.Add('加载客户端版本信息失败');
    Result := False;
  end;
end;


procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY                  : Integer;
resourcestring
  sDemoVersion      = '演示版';
  sGateIdx          = '网关';
  sGateIPaddr       = '网关地址';
  sGateListMsg      = '队列数据';
  sGateSendCount    = '发送数据';
  sGateMsgCount     = '剩余数据';
  sGateSendKB       = '平均流量';
  sGateUserCount    = '最高人数';
begin
  g_VCLZip1 := TVCLZip.Create(nil);
  g_nServerIndex := 0;
  g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then begin
   Left := nX;
   Top := nY;
  end;
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(self.Handle));
  GridGate.RowCount := 21;
  GridGate.Cells[0, 0] := sGateIdx;
  GridGate.Cells[1, 0] := sGateIPaddr;
  GridGate.Cells[2, 0] := sGateListMsg;
  GridGate.Cells[3, 0] := sGateSendCount;
  GridGate.Cells[4, 0] := sGateMsgCount;
  GridGate.Cells[5, 0] := sGateSendKB;
  GridGate.Cells[6, 0] := sGateUserCount;

  GateSocket := TServerSocket.Create(self.Owner);
  GateSocket.OnClientConnect := GateSocketClientConnect;
  GateSocket.OnClientDisconnect := GateSocketClientDisconnect;
  GateSocket.OnClientError := GateSocketClientError;
  GateSocket.OnClientRead := GateSocketClientRead;

  DBSocket.OnConnect := DBSocketConnect;
  DBSocket.OnError := DBSocketError;
  DBSocket.OnRead := DBSocketRead;

  Timer1.OnTimer := Timer1Timer;
  RunTimer.OnTimer := RunTimerTimer;
  StartTimer.OnTimer := StartTimerTimer;
  SaveVariableTimer.OnTimer := SaveVariableTimerTimer;
  ConnectTimer.OnTimer := ConnectTimerTimer;
  CloseTimer.OnTimer := CloseTimerTimer;
  MemoLog.OnChange := MemoLogChange;
  StartTimer.Enabled := True;

end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
resourcestring
  sCloseServerYesNo = '是否确认关闭游戏服务器？';
  sCloseServerTitle = '确认信息';
begin
  if not boServiceStarted then
    Exit;
  if g_boExitServer then begin
    boStartReady := False;
    StopService();
    Exit;
  end;
  CanClose := False;
  if Application.MessageBox(PChar(sCloseServerYesNo), PChar(sCloseServerTitle), MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    g_boExitServer := True;
    CloseGateSocket();
    g_Config.boKickAllUser := True;
    CloseTimer.Enabled := True;
  end;
end;

procedure TFrmMain.CloseTimerTimer(Sender: TObject);
resourcestring
  sCloseServer      = '%s [正在关闭服务器(%d/%d)...]';
begin
  Caption := Format(sCloseServer, [g_Config.sServerName, UserEngine.OnlinePlayObject, FrontEngine.SaveListCount]);
  if (UserEngine.OnlinePlayObject = 0) and (FrontEngine.SaveListCount = 0) then begin
    if FrontEngine.IsIdle then begin
      CloseTimer.Enabled := False;
      Close();
    end;
  end;
end;



procedure TFrmMain.SaveVariableTimerTimer(Sender: TObject);
begin
  SaveItemNumber(False);
end;

procedure TFrmMain.GateSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  RunSocket.CloseErrGate(Socket, ErrorCode);
end;

procedure TFrmMain.GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  RunSocket.CloseGate(Socket);
end;

procedure TFrmMain.GateSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.SocketRead(Socket);
end;

procedure TFrmMain.GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  RunSocket.AddGate(Socket);
end;

procedure TFrmMain.RunTimerTimer(Sender: TObject);
begin
  if boStartReady then begin
    RunSocket.Execute;
    FrmIDSoc.Run;
    UserEngine.Execute;
    g_SQlEngine.ExecuteRun;
{$IF USERENGINEMODE <> THREADENGINE}
    ProcessGameRun();
{$IFEND}

{$IF INTERSERVER = 1}
    if g_nServerIndex = 0 then
      FrmSrvMsg.Run
    else
      FrmMsgClient.Run;
{$IFEND}
  end;
  Inc(g_nRunTimes);
  if (GetTickCount - g_dwRunTick) > 250 then begin
    g_dwRunTick := GetTickCount();
    nRunTimeMin := g_nRunTimes;
    if nRunTimeMax > nRunTimeMin then
      nRunTimeMax := nRunTimeMin;
    g_nRunTimes := 0;
  end;
  if boRemoteOpenGateSocket then begin
    if not boRemoteOpenGateSocketed then begin
      boRemoteOpenGateSocketed := True;
      try
        if Assigned(g_GateSocket) then
          g_GateSocket.Active := True;
      except
        on E: Exception do MainOutMessageAPI(E.Message);
      end;
    end;
  end;
end;

procedure TFrmMain.ConnectTimerTimer(Sender: TObject);
begin
  if DBSocket.Active then
    Exit;
  DBSocket.Active := True;
end;

procedure TFrmMain.ReloadConfig(Sender: TObject);
begin
  LoadConfig();
  FrmIDSoc.Timer1Timer(Sender);
  if not (g_nServerIndex = 0) then
    if not FrmMsgClient.MsgClient.Active then
      FrmMsgClient.MsgClient.Active := True;
  LogUDP.RemoteHost := g_Config.sLogServerAddr;
  LogUDP.RemotePort := g_Config.nLogServerPort;
  LoadServerTable();
  LoadClientFile();
end;

procedure TFrmMain.RELOADHILLITEMNAMELISTClick(Sender: TObject);
begin
  LoadHintItemList();
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 500 then
    MemoLog.Clear;
end;

procedure TFrmMain.MemoLogDblClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
begin
  FrmDB.LoadItemsDB();
  MainOutMessageAPI('重新加载物品数据库完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
begin
  FrmDB.LoadMagicDB();
  MainOutMessageAPI('重新加载技能数据库完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
begin
  FrmDB.LoadMonsterDB();
  MainOutMessageAPI('重新加载怪物数据库完成...');
end;


procedure TFrmMain.StartService;
var

  nVar, nExtendedInfo: Integer;
  TimeNow           : TDateTime;
  Year, Month, Day, Hour, Min, Sec, msec: Word;
  F                 : TextFile;
  Config            : pTConfig;
  nCount            : Integer;
  i                 : Integer;

begin
  Config := @g_Config;


  MENU_CONTROL_START.Enabled := False;
  MENU_CONTROL_STOP.Enabled := False;
  if not DirectoryExists(g_Config.sUserDataDir) then CreateDir(g_Config.sUserDataDir);
  nRunTimeMax := 99999;
//  g_nRegStatus^ := 1;
  g_nServerTickDifference := 0;
  g_nSockCountMax := 0;
  g_nUsrTimeMax := 0;
  g_nHumCountMax := 0;
  g_nMonTimeMax := 0;
  g_nMonGenTimeMax := 0;
  g_nMonProcTime := 0;
  g_nMonProcTimeMin := 0;
  g_nMonProcTimeMax := 0;
  dwUsrRotCountMin := 0;
  dwUsrRotCountMax := 0;
  g_nProcessHumanLoopTime := 0;
  g_dwHumLimit := 30;
  g_dwMonLimit := 30;
  g_dwZenLimit := 5;
  g_dwNpcLimit := 5;
  g_dwSocLimit := 10;
  nDecLimit := 20;
  Config.sDBSocketRecvText := '';
  Config.boDBSocketWorking := False;
  Config.nLoadDBErrorCount := 0;
  Config.nLoadDBCount := 0;
  Config.nSaveDBCount := 0;
  Config.nDBQueryID := 0;
  Config.nItemNumber := 0;
  Config.nItemNumberEx := High(Integer) div 2;
  boStartReady := False;
  g_boExitServer := False;
  boFilterWord := True;
  Config.nWinLotteryCount := 0;
  Config.nNoWinLotteryCount := 0;
  Config.nWinLotteryLevel1 := 0;
  Config.nWinLotteryLevel2 := 0;
  Config.nWinLotteryLevel3 := 0;
  Config.nWinLotteryLevel4 := 0;
  Config.nWinLotteryLevel5 := 0;
  Config.nWinLotteryLevel6 := 0;
  FillChar(g_Config.GlobalVal, SizeOf(g_Config.GlobalVal), #0);
  FillChar(g_Config.HGlobalVal, SizeOf(g_Config.HGlobalVal), #0);
  FillChar(g_Config.GlobaDyMval, SizeOf(g_Config.GlobaDyMval), #0);
  FillChar(g_Config.GlobaDyTval, SizeOf(g_Config.GlobaDyTval), #0); //T变量(string)
{$IF USECODE = USEREMOTECODE}
  New(Config.Encode6BitBuf);
  Config.Encode6BitBuf^ := g_Encode6BitBuf;
  New(Config.Decode6BitBuf);
  Config.Decode6BitBuf^ := g_Decode6BitBuf;
{$IFEND}


  LoadConfig();
  MENU_OPTION_FUNCTION.Visible := True;
  MENU_VIEW_ONLINEHUMAN.Visible := True;

  g_MainMemo := MemoLog;
  Application.HintColor := StringToColor(g_Config.sHintColor);
  g_MainMemo.Color := StringToColor(g_Config.sMemoLogColor);
  g_MainMemo.Font.Color := StringToColor(g_Config.sMemoLogFontColor);

  PlugInEngine := TPlugInManage.Create;
  //zPlugOfEngine := TPlugOfEngine.Create;
  RunSocket := TRunSocket.Create();
  MainLogMsgList := TStringlist.Create;
  LogStringList := TStringlist.Create;
  LogonCostLogList := TStringlist.Create;
  g_MapManager := TMapManager.Create;
  ItemUnit := TItemUnit.Create;
  MagicManager := TMagicManager.Create;
  NoticeManager := TNoticeManager.Create;
  g_GuildManager := TGuildManager.Create;
  g_EventManager := TEventManager.Create;
  g_CastleManager := TCastleManager.Create;
  g_StartPointManager := TStartPointManager.Create;
  FrontEngine := TFrontEngine.Create(True);
  g_DBSQL := TDBSQL.Create;
  g_SQlEngine := TSQLEngine.Create;

  UserEngine := TUserEngine.Create();
  g_RobotManage := TRobotManage.Create;
  g_BaseObject := TBaseObject.Create;
  g_BaseObject.m_btRaceServer := 62;
  g_BaseObject.m_boSuperMan := True;

  g_xBlockUserList := TStringlist.Create;
  g_AutoLoginList := TStringlist.Create;
  g_DeathWalkingSays := TStringlist.Create;
  g_MakeItemList := TStringlist.Create;
  g_BoxItemList := TStringlist.Create;

  g_RefineItemList := TStringlist.Create;
  g_DenySayMsgList := TQuickList.Create;
  MiniMapList := TStringlist.Create;
  g_UnbindList := TStringlist.Create;
  LineNoticeList := TStringlist.Create;
  QuestDiaryList := TList.Create;
  ItemEventList := TStringlist.Create;
  AbuseTextList := TStringlist.Create;
  g_MonSayMsgList := THStringlist.Create;
  g_AllowBindNameList := THStringlist.Create;
  g_SayMsgList := TStringlist.Create;
  g_DisableMoveMapList := TGStringList.Create;
  for nCount := Low(g_MissionList) to High(g_MissionList) do g_MissionList[nCount] := TStringlist.Create;

  g_ItemNameList := TGList.Create;
  g_DisableSendMsgList := TGStringList.Create;
  g_MonDropLimitLIst := TGStringList.Create;
  g_SaleItemList := TGList.Create;
  g_ShopItemList := TGList.Create;
  g_GuildRankNameFilterList := TGStringList.Create;
  g_UnMasterList := TGStringList.Create;
  g_UnForceMasterList := TGStringList.Create;
  g_GameLogItemNameList := TGStringList.Create;
  g_DenyIPAddrList := TGStringList.Create;
  g_DenyChrNameList := TGStringList.Create;
  g_DenyAccountList := TGStringList.Create;
  g_NoClearMonList := TGStringList.Create;
  g_ItemLimitList := TGList.Create;

  g_UserCmdList := TGStringList.Create;
  g_UpgradeItemList := TGStringList.Create;
  g_PetPickItemList := TGStringList.Create;
  g_ItemBindIPaddr := TGList.Create;
  g_ItemBindAccount := TGList.Create;
  g_ItemBindCharName := TGList.Create;
  InitUserDataList();
  InitSuiteItemsList();
  g_HintItemList := TCnHashTableSmall.Create;
  InitVariablesList();
  //g_HWIDFilter := THWIDFilter.Create;

  InitializeCriticalSection(g_BlockUserLock);
  InitializeCriticalSection(LogMsgCriticalSection);
  //InitializeCriticalSection(ProcessMsgCriticalSection);
  InitializeCriticalSection(ProcessHumanCriticalSection);
  InitializeCriticalSection(USInterMsgCriticalSection);
  InitializeCriticalSection(SQLCriticalSection);
  //InitializeCriticalSection(NPCListCS);
  //InitializeCriticalSection(UserMgrEngnCriticalSection);
  InitializeCriticalSection(Config.UserIDSection);
  InitializeCriticalSection(UserDBSection);
  g_DynamicVarList := TList.Create;

  TimeNow := Now();
  DecodeDate(TimeNow, Year, Month, Day);
  DecodeTime(TimeNow, Hour, Min, Sec, msec);
  if not DirectoryExists(g_Config.sLogDir) then
    CreateDir(Config.sLogDir);
  sLogFileName := g_Config.sLogDir + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day) + '.' + IntToStr2(Hour) + '-' + IntToStr2(Min) + '.txt';
  AssignFile(F, sLogFileName);
  Rewrite(F);
  CloseFile(F);


  PlugInEngine.LoadPlugIn();
//  MemoLog.Lines.Add('正在读取配置信息...');
  DBSocket.Address := g_Config.sDBAddr;
  DBSocket.Port := g_Config.nDBPort;
  sCaption := g_Config.sServerName;
  Caption := Format('%s', [sCaption]);
  LoadServerTable();
  LogUDP.RemoteHost := g_Config.sLogServerAddr;
  LogUDP.RemotePort := g_Config.nLogServerPort;
  Application.OnIdle := AppOnIdle;
  Application.OnException := OnProgramException;
  dwRunDBTimeMax := GetTickCount();
  g_dwStartTick := GetTickCount();
  Timer1.Enabled := True;
  boServiceStarted := True;
  MENU_CONTROL_STOP.Enabled := True;

end;

procedure TFrmMain.StopService;
var
  i, ii, iii        : Integer;
  List              : TList;
  Config            : pTConfig;
  ThreadInfo        : pTThreadInfo;
  pDigItemLists     : pTDigItemLists;
begin
  Config := @g_Config;
  MENU_CONTROL_START.Enabled := False;
  MENU_CONTROL_STOP.Enabled := False;
  Timer1.Enabled := False;
  RunTimer.Enabled := False;
  FrmIDSoc.Close;
  GateSocket.Close;
  g_MainMemo := nil;
  SaveItemNumber(True);
  g_CastleManager.Free;
  //g_GuildTerritory.Free;
{$IF USERENGINEMODE = THREADENGINE}
  {ThreadInfo := @Config.UserEngineThread;
  ThreadInfo.boTerminaled := True;
  if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then
    SuspendThread(ThreadInfo.hThreadHandle);}
  for i := 0 to 2 - 1 do begin
    ThreadInfo := @Config.UserEngineThread[i];
    ThreadInfo.boTerminaled := True;
    if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then
      SuspendThread(ThreadInfo.hThreadHandle);
  end;
{$IFEND}

{$IF DBSOCKETMODE = THREADENGINE}
  ThreadInfo := @Config.DBSOcketThread;
  ThreadInfo.boTerminaled := True;
  if WaitForSingleObject(ThreadInfo.hThreadHandle, 1000) <> 0 then
    SuspendThread(ThreadInfo.hThreadHandle);
{$IFEND}
  FrontEngine.Terminate();
  //FrontEngine.WaitFor;
  FrontEngine.Free;
  MagicManager.Free;
  UserEngine.Free;
  if g_RobotManage <> nil then g_RobotManage.Free;

  g_SQlEngine.Terminate;
  g_DBSQL.Free;
  g_SQlEngine.Free;

  RunSocket.Free;
  ConnectTimer.Enabled := False;
  DBSocket.Close;
  MainLogMsgList.Free;
  LogStringList.Free;
  LogonCostLogList.Free;
  g_MapManager.Free;
  ItemUnit.Free;
  NoticeManager.Free;
  g_GuildManager.Free;
  for i := 0 to g_MakeItemList.Count - 1 do
    TStringlist(g_MakeItemList.Objects[i]).Free;
  g_MakeItemList.Free;

  g_xBlockUserList.Free;
  g_AutoLoginList.Free;
  g_DeathWalkingSays.Free;

  for i := 0 to g_BoxItemList.Count - 1 do begin
    List := TList(g_BoxItemList.Objects[i]);
    for ii := 0 to List.Count - 1 do
      Dispose(pTBoxItem(List.Items[ii]));
    List.Free;
  end;
  g_BoxItemList.Free;

  for i := 0 to g_DigItemList.Count - 1 do begin
    pDigItemLists := pTDigItemLists(g_DigItemList.Objects[i]);
    for ii := Low(TDigItemLists) to High(TDigItemLists) do begin
      for iii := 0 to pDigItemLists[ii].Count - 1 do
        Dispose(pTDigItem(pDigItemLists[ii].Items[iii]));
      pDigItemLists[ii].Free;
    end;
  end;
  g_DigItemList.Free;

  for i := 0 to g_RefineItemList.Count - 1 do begin
    List := TList(g_RefineItemList.Objects[i]);
    for ii := 0 to List.Count - 1 do
      Dispose(pTRefineItem(List.Items[ii]));
    List.Free;
  end;
  g_RefineItemList.Free;
  g_DenySayMsgList.Free;
  MiniMapList.Free;
  g_UnbindList.Free;
  LineNoticeList.Free;
  QuestDiaryList.Free;
  ItemEventList.Free;
  AbuseTextList.Free;
  g_AllowBindNameList.Free;

  for i := 0 to g_MonSayMsgList.Count - 1 do begin
    List := TList(g_MonSayMsgList.Objects[i]);
    for ii := 0 to List.Count - 1 do
      Dispose(pTMonSayMsg(List.Items[ii]));
    List.Free;
  end;
  g_MonSayMsgList.Free;

  g_SayMsgList.Free;
  g_DisableMoveMapList.Free;

  for i := Low(g_MissionList) to High(g_MissionList) do begin
    for ii := 0 to g_MissionList[i].Count - 1 do
      TStringlist(g_MissionList[i].Objects[ii]).Free;
    g_MissionList[i].Free;
  end;

  g_ItemNameList.Free;
  g_DisableSendMsgList.Free;
  for i := 0 to g_MonDropLimitLIst.Count - 1 do
    Dispose(pTMonDrop(g_MonDropLimitLIst.Objects[i]));
  g_MonDropLimitLIst.Free;
  g_GuildRankNameFilterList.Free;
  g_UnMasterList.Free;
  g_UnForceMasterList.Free;
  g_GameLogItemNameList.Free;
  g_DenyIPAddrList.Free;
  g_DenyChrNameList.Free;
  g_DenyAccountList.Free;
  g_NoClearMonList.Free;
  {for i := 0 to g_MapEventList.Count - 1 do
    Dispose(pTItemLimit(g_MapEventList.Items[i]));
  g_MapEventList.Free;}
  for i := 0 to g_ItemLimitList.Count - 1 do
    Dispose(pTItemLimit(g_ItemLimitList.Items[i]));
  g_ItemLimitList.Free;
  for i := 0 to g_SaleItemList.Count - 1 do
    Dispose(pTSaleItem(g_SaleItemList.Items[i]));
  g_SaleItemList.Free;
  for i := 0 to g_ShopItemList.Count - 1 do
    Dispose(pTShopItem(g_ShopItemList.Items[i]));
  g_ShopItemList.Free;
  for i := 0 to g_ItemBindIPaddr.Count - 1 do
    Dispose(pTItemBind(g_ItemBindIPaddr.Items[i]));
  for i := 0 to g_ItemBindAccount.Count - 1 do
    Dispose(pTItemBind(g_ItemBindAccount.Items[i]));
  for i := 0 to g_ItemBindCharName.Count - 1 do
    Dispose(pTItemBind(g_ItemBindCharName.Items[i]));
  g_ItemBindIPaddr.Free;
  SaveUserDataList();
  UnInitUserDataList();
  UnInitSuiteItemsList();
  g_ItemBindAccount.Free;
  g_ItemBindCharName.Free;
  PlugInEngine.Free;
  g_UserCmdList.Free;
  g_UpgradeItemList.Free;
  g_PetPickItemList.Free;
  g_HintItemList.Free;
  g_VariablesList.Free;
  DeleteCriticalSection(g_BlockUserLock);
  DeleteCriticalSection(LogMsgCriticalSection);
  //DeleteCriticalSection(ProcessMsgCriticalSection);
  DeleteCriticalSection(ProcessHumanCriticalSection);
  DeleteCriticalSection(USInterMsgCriticalSection);
  DeleteCriticalSection(SQLCriticalSection);
  //DeleteCriticalSection(NPCListCS);
  //DeleteCriticalSection(UserMgrEngnCriticalSection);
  DeleteCriticalSection(Config.UserIDSection);
  DeleteCriticalSection(UserDBSection);
  //CS_6.Free;
  for i := 0 to g_DynamicVarList.Count - 1 do
    Dispose(pTDynamicVar(g_DynamicVarList.Items[i]));
  g_DynamicVarList.Free;
  boServiceStarted := False;
  MENU_CONTROL_START.Enabled := True;
{$IF USECODE = USEREMOTECODE}
  Dispose(g_Config.Encode6BitBuf);
  Dispose(g_Config.Decode6BitBuf);
{$IFEND}
  g_StartPointManager.Free;
  FrmDB.Free;
  //g_BaseObject.free;
  //Dispose(g_dwIPNeedInfo);

end;

procedure TFrmMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  //  StartService();
end;

procedure TFrmMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  //  StopService();
end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
    MemoLog.Lines.Add('============================================');
    MemoLog.Lines.Add('无限制版引擎：LGEGEND引擎');
    MemoLog.Lines.Add('程序反馈：QQ：8302775 群号：858641818 715347659');
    MemoLog.Lines.Add('更新日期：2019-02-03');
    MemoLog.Lines.Add('非以上QQ均属假冒，请注意！');
    MemoLog.Lines.Add('============================================');
end;

procedure TFrmMain.MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
begin
  FrmServerValue := TFrmServerValue.Create(Owner);
  FrmServerValue.Top := Top + OPENTOPLEN;
  FrmServerValue.Left := Left;
  FrmServerValue.AdjuestServerConfig();
  FrmServerValue.Free;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig := TfrmGeneralConfig.Create(Owner);
  frmGeneralConfig.Top := Top + OPENTOPLEN;
  frmGeneralConfig.Left := Left;
  frmGeneralConfig.Open();
  frmGeneralConfig.Free;
  Caption := g_Config.sServerName;
end;

procedure TFrmMain.MENU_OPTION_GAMEClick(Sender: TObject);
begin
  frmGameConfig := TfrmGameConfig.Create(Owner);
  frmGameConfig.Top := Top + OPENTOPLEN;
  frmGameConfig.Left := Left;
  frmGameConfig.Open;
  frmGameConfig.Free;
end;

procedure TFrmMain.MENU_OPTION_FUNCTIONClick(Sender: TObject);
begin
  frmFunctionConfig := TfrmFunctionConfig.Create(Owner);
  frmFunctionConfig.Top := Top + OPENTOPLEN;
  frmFunctionConfig.Left := Left;
  frmFunctionConfig.Open;
  frmFunctionConfig.Free;
end;

procedure TFrmMain.G1Click(Sender: TObject);
begin
  frmGameCmd := TfrmGameCmd.Create(Owner);
  frmGameCmd.Top := Top + OPENTOPLEN;
  frmGameCmd.Left := Left;
  frmGameCmd.Open;
  frmGameCmd.Free;
end;

procedure TFrmMain.DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessageAPI('数据库服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')连接成功...');
  FrontEngine.AddToLoadIPList;
end;

procedure TFrmMain.MENU_OPTION_MONSTERClick(Sender: TObject);
begin
  frmMonsterConfig := TfrmMonsterConfig.Create(Owner);
  frmMonsterConfig.Top := Top + OPENTOPLEN;
  frmMonsterConfig.Left := Left;
  frmMonsterConfig.Open;
  frmMonsterConfig.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
begin
  UserEngine.ClearMonSayMsg();
  LoadMonSayMsg();
  MainOutMessageAPI('重新加载怪物说话配置完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
begin
  LoadItemLimitList();
  LoadDisableMoveMap();
  ItemUnit.LoadCustomItemName();
  LoadDisableSendMsgList();
  LoadGameLogItemNameList();
  LoadItemBindIPaddr();
  LoadItemBindAccount();
  LoadItemBindCharName();
  LoadUnMasterList();
  LoadUnForceMasterList();
  LoadDenyIPAddrList();
  LoadDenyAccountList();
  LoadDenyChrNameList();
  LoadNoClearMonList();
  FrmDB.LoadAdminList();
  MainOutMessageAPI('重新加载列表配置完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_STARTPOINTClick(Sender: TObject);
var
  S                 : string;
begin
  if g_StartPointManager.Initialize(S) then
    MemoLog.Lines.Add('重新加载回城点配置成功...')
  else
    MemoLog.Lines.Add(S + ' 地图不存在，加载回城点配置失败...');
end;

procedure TFrmMain.MENU_CONTROL_GATE_OPENClick(Sender: TObject);
resourcestring
  sGatePortOpen     = '游戏网关端口(%s:%d)已打开...';
begin
  if not GateSocket.Active then begin
    GateSocket.Active := True;
    MainOutMessageAPI(Format(sGatePortOpen, [GateSocket.Address, GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
begin
  CloseGateSocket();
end;

procedure TFrmMain.CloseGateSocket;
var
  i                 : Integer;
resourcestring
  sGatePortClose    = '游戏网关端口(%s:%d)已关闭...';
begin
  if GateSocket.Active then begin
    for i := 0 to GateSocket.Socket.ActiveConnections - 1 do
      GateSocket.Socket.Connections[i].Close;
    GateSocket.Active := False;
    MainOutMessageAPI(Format(sGatePortClose, [GateSocket.Address, GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROLClick(Sender: TObject);
begin
  if GateSocket.Active then begin
    MENU_CONTROL_GATE_OPEN.Enabled := False;
    MENU_CONTROL_GATE_CLOSE.Enabled := True;
  end else begin
    MENU_CONTROL_GATE_OPEN.Enabled := True;
    MENU_CONTROL_GATE_CLOSE.Enabled := False;
  end;
end;

procedure UserEngineProcess(Config: pTConfig; ThreadInfo: pTThreadInfo);
var
  nRunTime          : Integer;
  dwRunTick         : LongWord;
begin
  l_dwRunTimeTick := 0;
  dwRunTick := GetTickCount();
  ThreadInfo.dwRunTick := dwRunTick;
  while not ThreadInfo.boTerminaled do begin
    nRunTime := GetTickCount - ThreadInfo.dwRunTick;

    if ThreadInfo.nRunTime < nRunTime then
      ThreadInfo.nRunTime := nRunTime;

    if ThreadInfo.nMaxRunTime < nRunTime then
      ThreadInfo.nMaxRunTime := nRunTime;

    if GetTickCount - dwRunTick >= 1000 then begin
      dwRunTick := GetTickCount();
      if ThreadInfo.nRunTime > 0 then
        Dec(ThreadInfo.nRunTime);
    end;

    ThreadInfo.dwRunTick := GetTickCount();
    ThreadInfo.boActived := True;
    ThreadInfo.nRunFlag := 125;
    //if Config.boThreadRun then
    ProcessGameRun();
    Sleep(1);
    //SleepEx(1, True);
  end;
end;

procedure UserEngineThread(ThreadInfo: pTThreadInfo); stdcall;
var
  nErrorCount       : Integer;
resourcestring
  sExceptionMsg     = '[Exception] UserEngineThread ErrorCount = %d';
begin
  try
    UserEngineProcess(ThreadInfo.Config, ThreadInfo);
    ExitThread(0);
  except
    MainOutMessageAPI(Format(sExceptionMsg, [nErrorCount]));
  end;
end;

procedure ProcessDenySayMsgList();
var
  i                 : Integer;
begin
  g_DenySayMsgList.Lock;
  try
    for i := g_DenySayMsgList.Count - 1 downto 0 do
      if GetTickCount > LongWord(g_DenySayMsgList.Objects[i]) then
        g_DenySayMsgList.Delete(i);
  finally
    g_DenySayMsgList.UnLock;
  end;
end;

procedure ProcessGameRun();
var
  nCheckVar         : Integer;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    UserEngine.PrcocessData;

    if g_RobotManage <> nil then g_RobotManage.Run;

    g_EventManager.Run();

    if GetTickCount - l_dwRunTimeTick > 10 * 1000 then begin //0410
      l_dwRunTimeTick := GetTickCount();
      g_GuildManager.Run;
      g_CastleManager.Run;
      ProcessDenySayMsgList();
    end;

  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MENU_VIEW_GATEClick(Sender: TObject);
begin
  MENU_VIEW_GATE.Checked := not MENU_VIEW_GATE.Checked;
  GridGate.Visible := MENU_VIEW_GATE.Checked;
end;

procedure TFrmMain.MENU_VIEW_SESSIONClick(Sender: TObject);
begin
  frmViewSession := TfrmViewSession.Create(Owner);
  frmViewSession.Top := Top + OPENTOPLEN;
  frmViewSession.Left := Left;
  frmViewSession.Open();
  frmViewSession.Free;
end;

procedure TFrmMain.MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
begin
  frmViewOnlineHuman := TfrmViewOnlineHuman.Create(Owner);
  frmViewOnlineHuman.Top := Top + OPENTOPLEN;
  frmViewOnlineHuman.Left := Left;
  frmViewOnlineHuman.Open();
  frmViewOnlineHuman.Free;
end;

procedure TFrmMain.MENU_VIEW_LEVELClick(Sender: TObject);
begin
  frmViewLevel := TfrmViewLevel.Create(Owner);
  frmViewLevel.Top := Top + OPENTOPLEN;
  frmViewLevel.Left := Left;
  frmViewLevel.Open();
  frmViewLevel.Free;
end;

procedure TFrmMain.MENU_VIEW_LISTClick(Sender: TObject);
begin
  frmViewList := TfrmViewList.Create(Owner);
  frmViewList.Top := Top + OPENTOPLEN;
  frmViewList.Left := Left;
  frmViewList.Open();
  frmViewList.Free;
end;

procedure TFrmMain.MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
begin
  frmOnlineMsg := TfrmOnlineMsg.Create(Owner);
  frmOnlineMsg.Top := Top + OPENTOPLEN;
  frmOnlineMsg.Left := Left;
  frmOnlineMsg.Open();
  frmOnlineMsg.Free;
end;

procedure TFrmMain.MENU_VIEW_KERNELINFOClick(Sender: TObject);
begin
  frmViewKernelInfo := TfrmViewKernelInfo.Create(Owner);
  frmViewKernelInfo.Top := Top + OPENTOPLEN;
  frmViewKernelInfo.Left := Left;
  frmViewKernelInfo.Open();
  frmViewKernelInfo.Free;
end;

procedure TFrmMain.MENU_TOOLS_MERCHANTClick(Sender: TObject);
begin
  frmConfigMerchant := TfrmConfigMerchant.Create(Owner);
  frmConfigMerchant.Top := Top + OPENTOPLEN;
  frmConfigMerchant.Left := Left;
  frmConfigMerchant.Open();
  frmConfigMerchant.Free;
end;

procedure TFrmMain.MENU_OPTION_ITEMFUNCClick(Sender: TObject);
begin
  frmItemSet := TfrmItemSet.Create(Owner);
  frmItemSet.Top := Top + OPENTOPLEN;
  frmItemSet.Left := Left;
  frmItemSet.Open();
  frmItemSet.Free;
end;

procedure TFrmMain.ClearMemoLog;
begin
  if Application.MessageBox('是否确定清除日志信息？', '提示信息', MB_YESNO + MB_ICONQUESTION) = mrYes then
    MemoLog.Clear;
end;

procedure TFrmMain.MENU_TOOLS_MONGENClick(Sender: TObject);
begin
  frmConfigMonGen := TfrmConfigMonGen.Create(Owner);
  frmConfigMonGen.Top := Top + OPENTOPLEN;
  frmConfigMonGen.Left := Left;
  frmConfigMonGen.Open();
  frmConfigMonGen.Free;
end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData             : string;
  wIdent            : Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT: begin
        g_boExitServer := True;
        CloseGateSocket();
        g_Config.boKickAllUser := True;
        CloseTimer.Enabled := True;
      end;
  end;
end;



procedure TFrmMain.N2Click(Sender: TObject);
var
  i                 : Integer;
  sAccount, sName   : string;
begin
  if g_InitAutoLogin then Exit;

  LoadAutoLogin();

  if not DBSocketConnected() then begin
    MemoLog.Lines.Add('DBS未连接，不能加载自动挂机人物！');
    Exit;
  end;
  if (g_AutoLoginList.Count = 0) then begin
    MemoLog.Lines.Add('自动挂机人物列表为空，无法加载！');
    Exit;
  end;

  //EnterCriticalSection(ProcessHumanCriticalSection);
  //try
  for i := 0 to g_AutoLoginList.Count - 1 do begin
    sName := GetValidStr3(g_AutoLoginList[i], sAccount, [' ', #9]);
    if (sName <> '') and (sAccount <> '') then begin
      FrontEngine.AddToLoadRcdList(sAccount,
        sName,
        g_sAutoLogin,
        4,
        0,
        1, //PlayObject.m_nPayMent,
        1, //PlayObject.m_nPayMode,
        g_Config.nSoftVersionDate,
        -1, //PlayObject.m_nSocket,
        -1, //PlayObject.m_nGSocketIdx,
        -1, //PlayObject.m_nGateIdx,
        '',
        nil);
    end;
  end;

  g_InitAutoLogin := True;
  N2.Enabled := False;
  //finally
  //  LeaveCriticalSection(ProcessHumanCriticalSection);
  //end;
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin
  LoadAllowBindNameList();
  MainOutMessageAPI(Format('重新加载允许绑定名字列表成功(%d)...', [g_AllowBindNameList.Count]));
end;

procedure TFrmMain.N6Click(Sender: TObject);
begin
  //
  N6.Checked := not N6.Checked;
  g_Config.boViewWhisper := N6.Checked;
end;

procedure TFrmMain.N7Click(Sender: TObject);
begin
  MainOutMessageAPI('正在重新加载地图挖宝配置...');
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if LoadDigItemList(True) then
      MainOutMessageAPI('重新加载地图挖宝配置完成...')
    else
      MainOutMessageAPI('重新加载地图挖宝配置失败！！！')
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

//Development 2019-01-12 添加
procedure TFrmMain.N8Click(Sender: TObject);
var
  I: Integer;
  Monster: pTMonInfo;
begin
  try
    for i := 0 to UserEngine.MonsterList.Count - 1 do begin
{$IF USEHASHLIST = 1}
      Monster := pTMonInfo(UserEngine.MonsterList.Values[UserEngine.MonsterList.Keys[i]]);
      FrmDB.LoadMonitems(UserEngine.MonsterList.Keys[i], Monster.ItemList);
{$ELSE}
      Monster := UserEngine.MonsterList.Items[i];
      FrmDB.LoadMonitems(Monster.sName, Monster.ItemList);
{$IFEND}

    end;
    MainOutMessageAPI('怪物爆物品列表重加载完成...');
  except
    MainOutMessageAPI('怪物爆物品列表重加载失败！！！');
  end;
end;

//Development 2019-01-12 添加
procedure TFrmMain.N9Click(Sender: TObject);
begin
  if FrmDB.LoadMonGen > 0 then begin
    MainOutMessageAPI('重新加载怪物刷新配置完成...');
  end;
end;



//重新加载交易NPC配置 Development 2019-01-10 添加
procedure TFrmMain.NPCM1Click(Sender: TObject);
begin
  FrmDB.ReLoadMerchants();
  UserEngine.ReloadMerchantList();
  MainOutMessageAPI('重新加载交易NPC配置信息完成...');
end;

//重新加载管理NPC配置 Development 2019-01-10 添加
procedure TFrmMain.NPCN1Click(Sender: TObject);
begin
  FrmDB.ReLoadNpc;
  UserEngine.ReloadNpcList();
  MainOutMessageAPI('重新加载管理NPC配置信息完成...');
end;

procedure TFrmMain.DECODESCRIPTClick(Sender: TObject);
begin
  //
end;

procedure TFrmMain.MENU_TOOLS_IPSEARCHClick(Sender: TObject);
var
  sIPaddr           : string;
begin
  sIPaddr := '192.168.0.1';
  if not BLUE_InputQuery('IP所在地区查询', '请输入IP地址:', sIPaddr) then
    Exit;
  if not IsIPaddr(sIPaddr) then begin
    Application.MessageBox('输入的IP地址格式不正确', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
{$IF EXPIPLOCAL=1}
  MemoLog.Lines.Add(Format('%s: %s', [sIPaddr, GetIPLocal(sIPaddr)]));
{$ELSE}
  MemoLog.Lines.Add(Format('%s: %s', [sIPaddr, '未知']));
{$IFEND}
end;

procedure TFrmMain.MENU_MANAGE_CASTLEClick(Sender: TObject);
begin
  frmCastleManage := TfrmCastleManage.Create(Owner);
  frmCastleManage.Top := Top + OPENTOPLEN;
  frmCastleManage.Left := Left;
  frmCastleManage.Open();
  frmCastleManage.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_SABAKClick(Sender: TObject);
begin
  try
    g_CastleManager.ReInit();
    g_CastleManager.Initialize;
  finally
    MainOutMessageAPI('重新加载沙巴克数据完成...');
  end;
end;

procedure TFrmMain.MENU_TOOLS_NPCClick(Sender: TObject);
begin
  frmConfigMerchant := TfrmConfigMerchant.Create(Owner);
  frmConfigMerchant.Top := Top + OPENTOPLEN;
  frmConfigMerchant.Left := Left;
  frmConfigMerchant.Open();
  frmConfigMerchant.Free;
end;

procedure TFrmMain.MENU_VIEW_HIGHRANKClick(Sender: TObject);
begin
  frmHighRank := TfrmHighRank.Create(Owner);
  frmHighRank.Top := Top + OPENTOPLEN;
  frmHighRank.Left := Left;
  frmHighRank.Open();
  frmHighRank.Free;
end;


procedure TFrmMain.MENU_MANAGE_PLUGClick(Sender: TObject);
begin
  ftmPlugInManage := TftmPlugInManage.Create(Owner);
  ftmPlugInManage.Top := Top + OPENTOPLEN;
  ftmPlugInManage.Left := Left;
  ftmPlugInManage.Open();
  ftmPlugInManage.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_QMagegeScriptClickClick(Sender: TObject);
begin
    EnterCriticalSection(ProcessHumanCriticalSection);
    try
      if g_ManageNPC <> nil then begin
        g_ManageNPC.ClearScript();
        g_ManageNPC.LoadNpcScript();
        MainOutMessageAPI('重新加载登录脚本完成...');
      end;
    finally
      LeaveCriticalSection(ProcessHumanCriticalSection);
    end;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_QFUNCTIONSCRIPTClick(Sender: TObject);
begin
    EnterCriticalSection(ProcessHumanCriticalSection);
    try
      if g_FunctionNPC <> nil then begin
        g_FunctionNPC.ClearScript();
        g_FunctionNPC.LoadNpcScript();
        MainOutMessageAPI('重新加载功能脚本完成...');
      end;
      if g_MapEventNPC <> nil then begin
        g_MapEventNPC.ClearScript();
        g_MapEventNPC.LoadNpcScript();
        MainOutMessageAPI('重新加载事件脚本完成...');
      end;
    finally
      LeaveCriticalSection(ProcessHumanCriticalSection);
    end;
end;

procedure TFrmMain.MemStatusClick(Sender: TObject);
resourcestring
  sWebSite          = 'http://www.legendm2.com';
begin
  ShellExecute(Handle, nil, PChar(sWebSite), nil, nil, sw_shownormal);
end;

procedure TFrmMain.MENU_TOOLS_TESTClick(Sender: TObject);
type
  TpExecute = function(): string;
begin
  if (nPulgProc15 >= 0) and Assigned(PlugProcArray[nPulgProc15].nProcAddr) then
    MainOutMessageAPI(TpExecute(PlugProcArray[nPulgProc15].nProcAddr));
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_BOXITEMClick(Sender: TObject);
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if FrmDB.LoadBoxItem > 0 then
      MemoLog.Lines.Add('重新加载宝箱物品信息成功...')
    else
      MemoLog.Lines.Add('重新加载宝箱物品信息失败...');
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_REFINEITEMClick(Sender: TObject);
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if FrmDB.LoadRefineItem > 0 then
      MemoLog.Lines.Add('重新加载淬炼物品信息成功...')
    else
      MemoLog.Lines.Add('重新加载淬炼物品信息失败...');
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;



initialization
  begin
    AddToProcTable(@ChangeCaptionText, ('ChangeCaptionText'));
    AddToProcTable(@ChangeLabelVerColor, ('ChangeLabelVerColor'));
    AddToProcTable(@PlugRunOver, ('PlugRunOver'));
  end;

finalization

end.

