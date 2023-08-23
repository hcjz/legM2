unit frmClient;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  uSocket, Grobal2, GShare, CShare, Mir2Res, uConfig, HUtil32, EDcode, MapUnit, WavUnit;

type
  TfrmUpdateClient = class(TForm)
    GSocket: TServerSocket;
    procedure GSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure GSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; szError: string);
    procedure GSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure GSocketClientWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_boClosed:Boolean;
    m_Lines: TStringList;
  private
    procedure LoadWzlInfo(Lines:TStrings);
    procedure LoadMapInfo(Lines:TStrings);
    procedure LoadWavInfo(Lines:TStrings);
    procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
    procedure OnClientSocketMsg(pClientInfo:pTClientInfo);
    procedure OnSendHeadInfo(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnSendInfoSize(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnSendDataInfo(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnSendMapInfoSize(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnSendMapDataInfo(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnSendWavInfoSize(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnSendWavDataInfo(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
  public
    { Public declarations }
    procedure InitializeVariable;
    procedure UnitializeVariable;
    procedure InitializeResource;
    procedure UnitializeResource;
    procedure InitializeUpdateSrv;
    procedure InitializeProcess;
    function GUpdateReviceThreadMsg:Integer;
  end;

  function GSocketReviceThreadPro(Parameter: Pointer): Integer;

var
  frmUpdateClient: TfrmUpdateClient;

implementation

{$R *.dfm}

uses LooksFile, ClMain;

procedure Searchfile(path, ext: string; var Lines:TStringList);
var
  SearchRec: TSearchRec;
  found: integer;
begin
  Lines.Clear;
  found := FindFirst(path + '\' + ext, faAnyFile, SearchRec);
  while found = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
      (SearchRec.Attr <> faDirectory) then
      Lines.Add(SearchRec.Name);
    found := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

procedure TfrmUpdateClient.InitializeVariable;
begin
  m_boClosed:= False;
  m_Lines:= TStringList.Create;
end;

procedure TfrmUpdateClient.UnitializeVariable;
begin

end;

procedure TfrmUpdateClient.InitializeResource;
var
  szPath:string;
begin
  WriteRuntimesLog('正在读取配置信息...');
  m2ConfigManage.LoadDBConfig;
  GSocket.Host:= m2ConfigManage.m2ConFigEx.szGateAddr;
  GSocket.Port:= m2ConfigManage.m2ConFigEx.wdGatePort;

  szPath:= m2ConfigManage.m2ConFigEx.szResourcePath;
  WriteRuntimesLog('正在加载Data目录...');
  if m2ConfigManage.m2ConFigEx.szResourcePath <> '' then begin
    Searchfile(szPath + '\Data', '*.wzl', m_Lines);
    frmLooksFile.meWzlRunLog.Lines:= m_Lines;
    LoadWzlInfo(m_Lines);
    WriteRuntimesLog('加载' + szPath + '\Data目录完成(' + IntToStr(m_Lines.Count) + ')');
  end;

  WriteRuntimesLog('正在加载Map目录...');
  if m2ConfigManage.m2ConFigEx.szResourcePath <> '' then begin
    Searchfile(szPath + '\Map', '*.map',  m_Lines);
    frmLooksFile.MeMapRunLog.Lines:= m_Lines;
    LoadMapInfo(m_Lines);
    WriteRuntimesLog('加载' + szPath + '\Map目录完成(' + IntToStr(m_Lines.Count) + ')');
  end;
  WriteRuntimesLog('正在加载Wav目录...');
  if m2ConfigManage.m2ConFigEx.szResourcePath <> '' then begin
    Searchfile(szPath + '\Wav', '*.wav',  m_Lines);
    frmLooksFile.meWavRunLog.Lines:= m_Lines;
    LoadWavInfo(m_Lines);
    WriteRuntimesLog('加载' + szPath + '\Wav目录完成(' + IntToStr(m_Lines.Count) + ')');
  end;

  m_Lines.Free;
end;

procedure TfrmUpdateClient.LoadWzlInfo(Lines:TStrings);
var
  nIndex:Integer;
  szPath:string;
  szFile:string;
  WMImages:TWMImages;
begin
  szPath:= m2ConfigManage.m2ConFigEx.szResourcePath + '\Data\';
  for nIndex := 0 to Lines.Count - 1 do begin
    WMImages:= TWMImages.Create;
    WMImages.FileName:= szPath + Lines[nIndex];
    WMImages.Initialize;
    szFile:= Lines[nIndex];
    g_WMMainImages.AddObject(szFile, WMImages);
  end;
end;

procedure TfrmUpdateClient.LoadMapInfo(Lines:TStrings);
var
  nIndex:Integer;
  szPath:string;
  szFile:string;
  LegendMap:TLegendMap;
begin
  szPath:= m2ConfigManage.m2ConFigEx.szResourcePath + '\Map\';
  for nIndex := 0 to Lines.Count - 1 do begin
    LegendMap:= TLegendMap.Create;
    LegendMap.FileName:= szPath + Lines[nIndex];
    LegendMap.Initialize;
    szFile:= Lines[nIndex];
    g_WMMapList.AddObject(szFile, LegendMap);
  end;
end;

procedure TfrmUpdateClient.LoadWavInfo(Lines:TStrings);
var
  nIndex:Integer;
  szPath:string;
  szFile:string;
  Sounds:TSounds;
begin
  szPath:= m2ConfigManage.m2ConFigEx.szResourcePath + '\Wav\';
  for nIndex := 0 to Lines.Count - 1 do begin
    Sounds:= TSounds.Create;
    Sounds.FileName:= szPath + Lines[nIndex];
    Sounds.Initialize;
    szFile:= Lines[nIndex];
    g_WMWavList.AddObject(szFile, Sounds);
  end;
end;

procedure TfrmUpdateClient.UnitializeResource;
begin

end;

procedure TfrmUpdateClient.InitializeUpdateSrv;
begin
  GSocket.Active:= True;
  if GSocket.Active then begin
    WriteRuntimesLog(Format(BIND_MSG, [GSocket.Host, GSocket.Port]));
    frmMain.StatusBar.Panels[0].Text:= '----][----';
  end;
end;

procedure TfrmUpdateClient.InitializeProcess;
begin
  OpenThread(@GSocketReviceThreadPro, '消息线程');
end;

procedure TfrmUpdateClient.FormDestroy(Sender: TObject);
begin
  m_boClosed:= True;
  GSocket.Close;
end;

procedure TfrmUpdateClient.GSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Index:Integer;
  pClientInfo:pTClientInfo;
begin
  EnterCriticalSection(g_csCriticalSection);
  for Index := 0 to GATEMAXSESSION - 1 do begin
    pClientInfo:= @g_ClientArray[Index];
    if pClientInfo.Socket = nil then begin
      pClientInfo.Socket:= Socket;
      pClientInfo.sRemoteAddr:= ShortString(Socket.Host);
      pClientInfo.wRemotePort:= Socket.Port;
      pClientInfo.boConnected:= True;
      pClientInfo.nServerIndex:= Socket.nIndex;
      pClientInfo.Socket.nIndex:= Index;
      pCLientInfo.boVerifyConn:= False;
      QueryPerformanceCounter(Int64(pClientInfo.liConnctTime));
      pClientInfo.liKeepAliveTime.QuadPart:= pClientInfo.liConnctTime.QuadPart;
      g_vcConnections.Add(pCLientInfo);
      break;
    end;
  end;
  LeaveCriticalSection(g_csCriticalSection);
end;

procedure TfrmUpdateClient.GSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Index: Integer;
  pClientInfo:pTClientInfo;
begin
  EnterCriticalSection(g_csCriticalSection);
  Index:= Socket.nIndex;
  if (Index >= 0) and (Index < GATEMAXSESSION) then begin
    pClientInfo:= @g_ClientArray[Index];
    if pClientInfo.Socket <> nil then begin
      //移除对象所在链表数据
      InterlockedDecrement(g_nConnection[0]);
      g_vcConnections.Delete(g_vcConnections.IndexOf(pClientInfo));
      pClientInfo.Socket:= nil;
      pClientInfo.boConnected:= False;
      pClientInfo.sRemoteAddr:= '';
      pClientInfo.wRemotePort:= 0;
      pClientInfo.nServerIndex:= -1;
      pCLientInfo.boVerifyConn:= False;
      pClientInfo.sStr:= '';
      FillChar(pClientInfo.liConnctTime, sizeof(pClientInfo.liConnctTime), 0);
      FillChar(pClientInfo.liKeepAliveTime, sizeof(pClientInfo.liKeepAliveTime), 0);
    end;
  end;
  LeaveCriticalSection(g_csCriticalSection);
end;

procedure TfrmUpdateClient.GSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; szError: string);
begin
  Socket.Close;
end;

procedure TfrmUpdateClient.GSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Index: Integer;
  szAction:string;
  pClientInfo:pTClientInfo;
begin
  EnterCriticalSection(g_csCriticalSection);
  Index:= Socket.nIndex;
  szAction:= Socket.ReceiveText;
  if (Index >= 0) and (Index < GATEMAXSESSION) then begin
    pClientInfo:= @g_ClientArray[Index];
    if pClientInfo.Socket <> nil then begin
      pClientInfo.sStr:= pClientInfo.sStr + szAction;
      g_vcClientReviceList.Add(pClientInfo);
    end else begin
      Socket.Close;
    end;
  end;
  LeaveCriticalSection(g_csCriticalSection);
end;

procedure TfrmUpdateClient.GSocketClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //
end;

procedure TfrmUpdateClient.SendKeepAlivePacket(Socket: TCustomWinSocket);
var
  szMsg:string;
  szAction:string;
  dwTrans:LongWord;
begin
  if (Socket <> nil) and Socket.Connected then begin
    szMsg:= EncodeString(MG_AliveSMsg+MG_AliveSMsg);
    dwTrans:= Length(AnsiString(szMsg));
    szAction:= EncodeMessage(MakeDefaultMsg(MG_ALIVEMSG, 0, dwTrans, 0, 0, 0))  + szMsg;
    Socket.SendText(MG_CodeHead+szAction+MG_CodeEnd);
  end;
end;

procedure TfrmUpdateClient.OnSendHeadInfo(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
var
  nIndex, nZip, nSize:Integer;
  WMImages:TWMImages;
  UpdateInfo:TUpdateInfo;
  szAction, szMsg:string;
begin
  if szBody <> '' then begin
    DecodeBuffer(szBody, @UpdateInfo, sizeof(TUpdateInfo));
    if UpdateInfo.utUpdateType = utWzlHead then begin
      //更新 wzl 文件头信息
      nIndex:= g_WMMainImages.IndexOf((string(UpdateInfo.szFileName)));
      if nIndex <> NOTFOUND then begin
        WMImages:= TWMImages(g_WMMainImages.Objects[nIndex]);
        if WMImages <> nil then begin
          szMsg:= WMImages.GateFileHeadData(nZip);
          szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEHEAD, 0, Length(szMsg), nZip, S_OK, 0))  + szMsg;
          pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
        end;
      end;
      exit;
    end;
    if UpdateInfo.utUpdateType = utImgHead then begin
      //更新 wzl 图片信息
      nIndex:= g_WMMainImages.IndexOf((string(UpdateInfo.szFileName)));
      if nIndex <> NOTFOUND then begin
        WMImages:= TWMImages(g_WMMainImages.Objects[nIndex]);
        if WMImages <> nil then begin
          szMsg:= WMImages.GetImageInfo(UpdateInfo.nImageIndex, nZip, nSize);
          if szMsg <> '' then begin
            //发送正常数据
            szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEHEAD, 0, Length(szMsg), nZip, S_OK, nSize))  + szMsg;
            pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
          end else begin
            //发送空白数据
            szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEHEAD, 0, 0, 0, S_ERROR, 0));
            pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
          end;
        end;
      end else begin
        //发送空白数据
        szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEHEAD, 0, 0, 0, S_ERROR, 0));
        pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
      end;
      exit;
    end;
  end;
end;

procedure TfrmUpdateClient.OnSendInfoSize(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
var
  nIndex, nZip, nSize:Integer;
  WMImages:TWMImages;
  UpdateInfo:TUpdateInfo;
  szAction, szMsg:string;
begin
  if szBody <> '' then begin
    DecodeBuffer(szBody, @UpdateInfo, sizeof(TUpdateInfo));
    if UpdateInfo.utUpdateType = utImgHead then begin
      //更新 wzl 图片信息
      nIndex:= g_WMMainImages.IndexOf((string(UpdateInfo.szFileName)));
      if nIndex <> NOTFOUND then begin
        WMImages:= TWMImages(g_WMMainImages.Objects[nIndex]);
        if WMImages <> nil then begin
          szMsg:= WMImages.GetImageInfo(UpdateInfo.nImageIndex, nZip, nSize);
          if szMsg <> '' then begin
            //发送正常数据
            szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEINFO, UpdateInfo.nImageIndex, Length(szMsg), nZip, S_OK, nSize))  + szMsg;
            pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
          end else begin
            //发送空白数据
            szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEINFO, UpdateInfo.nImageIndex, 0, 0, S_ERROR, 0));
            pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
          end;
        end;
      end else begin
        //发送空白数据
        szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEINFO, UpdateInfo.nImageIndex, 0, 0, S_ERROR, 0));
        pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
      end;
      exit;
    end;
  end;
end;

procedure TfrmUpdateClient.OnSendDataInfo(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
var
  nIndex, nSize:Integer;
  UpdateInfo:TUpdateInfo;
  pData:PAnsiChar;
  WMImages:TWMImages;
begin
  if szBody <> '' then begin
    DecodeBuffer(szBody, @UpdateInfo, sizeof(TUpdateInfo));
    if UpdateInfo.utUpdateType = utImage then begin
      //更新 wzl 图片信息
      nIndex:= g_WMMainImages.IndexOf((string(UpdateInfo.szFileName)));
      if nIndex <> NOTFOUND then begin
        WMImages:= TWMImages(g_WMMainImages.Objects[nIndex]);
        if WMImages <> nil then begin
          pData:= WMImages.GetImageData(UpdateInfo.nImageIndex, nSize);
          if (pData <> nil) and (nSize > 0) then begin
            if pClientInfo.Socket <> nil then
              pClientInfo.Socket.SendBuf(pData, nSize);
            if not g_boMapView then begin
              FreeMem(pData);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmUpdateClient.OnSendMapInfoSize(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
var
  nIndex:Integer;
  UpdateInfo:TUpdateInfo;
  szAction:string;
  Map:TLegendMap;
  ZipInfo:TZipInfo;
begin
  if szBody <> '' then begin
    DecodeBuffer(szBody, @UpdateInfo, sizeof(TUpdateInfo));
    if UpdateInfo.utUpdateType = utMap then begin
      if UpdateInfo.szFileName <> '' then begin
        nIndex:= g_WMMapList.IndexOf(string(UpdateInfo.szFileName));
        if nIndex <> NOTFOUND then begin
          Map:= TLegendMap(g_WMMapList.Objects[nIndex]);
          if Map <> nil then begin
            ZipInfo.dwSize:= Map.getMapSize();
            ZipInfo.dwZipSize:= Map.getZipSize();
            ZipInfo.dwZipLevel:= DEFALUT_ZIP_LEVEL;
            //发送正常数据
            szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEMAPINFO, 0, 0, 0, S_OK, 0)) + EncodeBuffer(@ZipInfo, SizeOf(TZipInfo));
            pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
          end;
        end else begin
          szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEMAPINFO, 0, 0, 0, S_ERROR, 0));
          pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
        end;
      end;
    end;
  end;
end;

procedure TfrmUpdateClient.OnSendMapDataInfo(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
var
  nIndex:Integer;
  UpdateInfo:TUpdateInfo;
  Map:TLegendMap;
  pData:PAnsiChar;
  dwZipSize:LongWord;
begin
  if szBody <> '' then begin
    DecodeBuffer(szBody, @UpdateInfo, sizeof(TUpdateInfo));
    if UpdateInfo.utUpdateType = utMap then begin
      if UpdateInfo.szFileName <> '' then begin
        nIndex:= g_WMMapList.IndexOf(string(UpdateInfo.szFileName));
        if nIndex <> NOTFOUND then begin
          Map:= TLegendMap(g_WMMapList.Objects[nIndex]);
          if Map <> nil then begin
            dwZipSize:= Map.getZipSize();
            pData:= Map.getZipData();
            if (pData <> nil) and (dwZipSize > 0) then begin
              if pClientInfo.Socket <> nil then
                pClientInfo.Socket.SendBuf(pData, dwZipSize);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmUpdateClient.OnSendWavInfoSize(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
var
  nIndex:Integer;
  UpdateInfo:TUpdateInfo;
  szAction:string;
  Sounds:TSounds;
  ZipInfo:TZipInfo;
begin
  if szBody <> '' then begin
    DecodeBuffer(szBody, @UpdateInfo, sizeof(TUpdateInfo));
    if UpdateInfo.utUpdateType = utWav then begin
      if UpdateInfo.szFileName <> '' then begin
        nIndex:= g_WMWavList.IndexOf(string(UpdateInfo.szFileName));
        if nIndex <> NOTFOUND then begin
          Sounds:= TSounds(g_WMWavList.Objects[nIndex]);
          if Sounds <> nil then begin
            ZipInfo.dwSize:= Sounds.getWavSize();
            ZipInfo.dwZipSize:= Sounds.getZipSize();
            ZipInfo.dwZipLevel:= DEFALUT_ZIP_LEVEL;
            //发送正常数据
            szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEWAVINFO, 0, 0, 0, S_OK, 0)) + EncodeBuffer(@ZipInfo, SizeOf(TZipInfo));
            pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
          end;
        end else begin
          szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATEWAVINFO, 0, 0, 0, S_ERROR, 0));
          pClientInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
        end;
      end;
    end;
  end;
end;

procedure TfrmUpdateClient.OnSendWavDataInfo(pClientInfo:pTClientInfo; raAction:TDefaultMessage; szBody:string);
var
  nIndex:Integer;
  UpdateInfo:TUpdateInfo;
  Sounds:TSounds;
  pData:PAnsiChar;
  dwZipSize:LongWord;
begin
  if szBody <> '' then begin
    DecodeBuffer(szBody, @UpdateInfo, sizeof(TUpdateInfo));
    if UpdateInfo.utUpdateType = utWav then begin
      if UpdateInfo.szFileName <> '' then begin
        nIndex:= g_WMWavList.IndexOf(string(UpdateInfo.szFileName));
        if nIndex <> NOTFOUND then begin
          Sounds:= TSounds(g_WMWavList.Objects[nIndex]);
          if Sounds <> nil then begin
            dwZipSize:= Sounds.getZipSize;
            pData:= Sounds.getZipData();
            if (pData <> nil) and (dwZipSize > 0) then begin
              if pClientInfo.Socket <> nil then
                pClientInfo.Socket.SendBuf(pData, dwZipSize);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmUpdateClient.OnClientSocketMsg(pClientInfo:pTClientInfo);
var
  szAction, szBody:string;
  raAction:TDefaultMessage;
  dwCommand:LongWord;
begin
  while True do begin
    if Pos(MG_CodeEnd, pClientInfo.sStr) <= 0 then break;
    //取出单包信息
    pClientInfo.sStr := ArrestStringEx(pClientInfo.sStr, MG_CodeHead, MG_CodeEnd, szBody);
    if not pClientInfo.boVerifyConn then begin
      //校验连接安全信息
      if MG_SAFECONNECTEDMSG = szBody then begin
        pClientInfo.boVerifyConn:= True;
        InterlockedIncrement(g_nConnection[0]);
        //发送连接服务信息
        pClientInfo.Socket.SendText(MG_CodeHead + MG_SAFECONNECTEDMSG + MG_CodeEnd);
      end;
      continue;
    end;
    if szBody <> '' then begin
      szAction:= LeftStr(szBody, DEFAULTENCODEACTIONSIZE);
      szBody:= MidStr(szBody, DEFAULTENCODEACTIONSIZE+1, Length(AnsiString(szBody)) - DEFAULTENCODEACTIONSIZE);
      DecodeBuffer(szAction, @raAction, sizeof(TDefaultMessage));
      dwCommand:= raAction.Ident;
      if dwCommand = MG_ALIVEMSG then begin
        //客户端心跳包
        SendKeepAlivePacket(pClientInfo.Socket);
        QueryPerformanceCounter(Int64(pClientInfo.liKeepAliveTime));
        continue;
      end;

      case dwCommand of
        CM_UPDATEHEAD:begin
          //更新文件
          OnSendHeadInfo(pClientInfo, raAction, szBody);
        end;
        CM_UPDATEINFO:begin
          //更新文件
          OnSendInfoSize(pClientInfo, raAction, szBody);
        end;
        CM_UPDATEDATA:begin
          //更新数据
          OnSendDataInfo(pClientInfo, raAction, szBody);
        end;
        CM_UPDATEMAPINFO:begin
          OnSendMapInfoSize(pClientInfo, raAction, szBody);
        end;
        CM_UPDATEMAPDATA:begin
          OnSendMapDataInfo(pClientInfo, raAction, szBody);
        end;
        CM_UPDATEWAVINFO:begin
          OnSendWavInfoSize(pClientInfo, raAction, szBody);
        end;
        CM_UPDATEWAVDATA:begin
          OnSendWavDataInfo(pClientInfo, raAction, szBody);
        end;
      end;
    end;
  end;
end;

function TfrmUpdateClient.GUpdateReviceThreadMsg:Integer;
var
  Index:Integer;
  pClientInfo:pTClientInfo;
  liQueryTime, liVerifyTime: LARGE_INTEGER;
begin
  //当前线程下标
  Index:= g_nRunningThreadCount;
  SetEvent(g_hEvent);
  //每次进入时线程事件无信号
  ResetEvent(g_tsThreadStatus[Index].dwThreadhd);
  //更新线程状态
  QueryPerformanceCounter(Int64(liQueryTime));
  g_tsThreadStatus[Index].tsThreadStatus:= tsRun;
  g_tsThreadStatus[Index].liRunTime.QuadPart:= liQueryTime.QuadPart;
  liVerifyTime.QuadPart:= liQueryTime.QuadPart;
  //增加引用计数
  InterlockedIncrement(g_nRunningThreadCount);
  while not m_boClosed do begin
    //处理通讯消息
    if g_vcClientReviceList.Count > 0 then begin
      pClientInfo:= pTClientInfo(g_vcClientReviceList.First);
      g_vcClientReviceList.Delete(g_vcClientReviceList.IndexOf(pClientInfo));
      if pClientInfo <> nil then begin
        //处理客户端网络消息
        OnClientSocketMsg(pClientInfo);
      end;
    end;
    Sleep(5);
  end;

  g_tsThreadStatus[Index].tsThreadStatus:= tsExit;
  SetEvent(g_tsThreadStatus[Index].dwThreadhd);
  Result:= 0;
end;

function GSocketReviceThreadPro(Parameter: Pointer): Integer;                   //终端处理线程
begin
  Result:= frmUpdateClient.GUpdateReviceThreadMsg;
end;



end.
