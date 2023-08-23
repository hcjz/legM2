unit FUpdate;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  uSocket, HUtil32, Grobal2, GShare, CShare, EDcode, Wil, wmM2Zip, wmM2Def;

type
  TfrmUpdate = class(TForm)
  private
    { Private declarations }
    m_nVerifyServerId:Integer;
    m_dwKeepAliveTimeOut: LongWord;                                             //心跳间隔时间
    m_dwSendkeepAliveTick: LongWord;                                            //发送心跳间隔
    m_vcUpdateRevice:TList;                                                     //更新接收列表
    m_vcUpdateList:TList;                                                       //在线微端列表
    m_hEvent:THandle;
    m_csServerSocketSection: TRTLCriticalSection;
    m_csUpdatesSocketSection: TRTLCriticalSection;
  private
    procedure InitVariable;
    procedure OnVerifyServerTimeOut;
    procedure OnUpdateSocketMsg(pServerInfo:pTServerInfo);
    procedure OnRecvWZLHeadInfo(pServerInfo:pTServerInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnRecvDataHeadInfo(pServerInfo:pTServerInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnRecvMapSizeInfo(pServerInfo:pTServerInfo; raAction:TDefaultMessage; szBody:string);
    procedure OnRecvWavSizeInfo(pServerInfo:pTServerInfo; raAction:TDefaultMessage; szBody:string);

    procedure OnClientUpdateComplete(pServerInfo:pTServerInfo);
    procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
    procedure SendUpdateHead(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
    procedure SendUpdateInfo(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
    procedure SendUpdateData(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
    procedure SendUpdateMapInfo(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
    procedure SendUpdateMapData(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);

    procedure SendUpdateWavInfo(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
    procedure SendUpdateWavData(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CUpdateThreadMsg:Integer;
    procedure MyUpdateImages(WMImages: TWMBaseImages; nIndex: Integer);
    procedure MyInitializeImages(WMImages: TWMBaseImages);
    procedure SendUpdateImages(dwRecogerId:LongWord; szFileName:string; nImageId:Integer);
    procedure SendUpdateInitializeImages(dwRecogerId:LongWord; szFileName:string);
    procedure SendUpdateMap(sMap:string);
    procedure SendUpdateWav(sWav:string; stScene:TSceneType; boBGM:Boolean);
  public
    procedure DUpdateConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DUpdateDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DUpdateRead(Sender: TObject; Socket: TCustomWinSocket);
  end;

  function CUpdateReviceThreadPro(Parameter: Pointer): Integer;

var
  frmUpdate: TfrmUpdate;

implementation

uses
  PlayScn, SoundUtil;

{$R *.dfm}

constructor TfrmUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitVariable;
end;

procedure TfrmUpdate.InitVariable;
var
  hThread:THandle;
  dwThreadId:LongWord;
begin
  m_nVerifyServerId:= 0;
  m_dwKeepAliveTimeOut:= 30;
  m_dwSendkeepAliveTick:= 2;
  m_vcUpdateList:= TList.Create;
  m_vcUpdateRevice:= TList.Create;
  m_hEvent:= CreateEvent(nil, TRUE, TRUE, nil);
  hThread := BeginThread(nil, 0, CUpdateReviceThreadPro, nil, 0, dwThreadId);
  InitializeCriticalSection(m_csServerSocketSection);
  InitializeCriticalSection(m_csUpdatesSocketSection);
end;

procedure TfrmUpdate.MyInitializeImages(WMImages: TWMBaseImages);
var
  szFileName, sMsg:string;
begin
  if (WMImages <> nil) then begin
    szFileName:= GetValidStr3(WMImages.FileName, sMsg, ['\']);
    if szFileName <> '' then begin
      SendUpdateInitializeImages(LongWord(WMImages), szFileName);
    end;
  end;
end;


procedure TfrmUpdate.MyUpdateImages(WMImages: TWMBaseImages; nIndex: Integer);
var
  szFileName, sMsg:string;
begin
  if (WMImages <> nil) then begin
    szFileName:= GetValidStr3(WMImages.FileName, sMsg, ['\']);
    if szFileName <> '' then begin
      SendUpdateImages(LongWord(WMImages), szFileName, nIndex);
    end;
  end;
end;

procedure TfrmUpdate.SendUpdateHead(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
var
  szAction, szMsg:string;
begin
  szMsg:= EncodeBuffer(PAnsiChar(pUpdateInfo), sizeof(TUpdateInfo));
  szAction:= EncodeMessage(MakeDefaultMsg(CM_UPDATEHEAD, 0, Length(szMsg), 0, 0, 0))  + szMsg;
  if pServerInfo.Socket <> nil then begin
    pServerInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
    QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
  end;
end;

procedure TfrmUpdate.SendUpdateInfo(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
var
  szAction, szMsg:string;
begin
  szMsg:= EncodeBuffer(PAnsiChar(pUpdateInfo), sizeof(TUpdateInfo));
  szAction:= EncodeMessage(MakeDefaultMsg(CM_UPDATEINFO, 0, Length(szMsg), 0, 0, 0))  + szMsg;
  if pServerInfo.Socket <> nil then begin
    pServerInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
    QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
  end;
end;

procedure TfrmUpdate.SendUpdateData(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
var
  szAction, szMsg:string;
begin
  szMsg:= EncodeBuffer(PAnsiChar(pUpdateInfo), sizeof(TUpdateInfo));
  szAction:= EncodeMessage(MakeDefaultMsg(CM_UPDATEDATA, 0, Length(szMsg), 0, 0, 0))  + szMsg;
  if pServerInfo.Socket <> nil then begin
    pServerInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
    QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
  end;
end;

procedure TfrmUpdate.SendUpdateMapInfo(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
var
  szAction, szMsg:string;
begin
  szMsg:= EncodeBuffer(PAnsiChar(pUpdateInfo), sizeof(TUpdateInfo));
  szAction:= EncodeMessage(MakeDefaultMsg(CM_UPDATEMAPINFO, 0, Length(szMsg), 0, 0, 0))  + szMsg;
  if pServerInfo.Socket <> nil then begin
    pServerInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
    QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
  end;
end;

procedure TfrmUpdate.SendUpdateMapData(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
var
  szAction, szMsg:string;
begin
  szMsg:= EncodeBuffer(PAnsiChar(pUpdateInfo), sizeof(TUpdateInfo));
  szAction:= EncodeMessage(MakeDefaultMsg(CM_UPDATEMAPDATA, 0, Length(szMsg), 0, 0, 0))  + szMsg;
  if pServerInfo.Socket <> nil then begin
    pServerInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
    QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
  end;
end;

procedure TfrmUpdate.SendUpdateWavInfo(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
var
  szAction, szMsg:string;
begin
  szMsg:= EncodeBuffer(PAnsiChar(pUpdateInfo), sizeof(TUpdateInfo));
  szAction:= EncodeMessage(MakeDefaultMsg(CM_UPDATEWAVINFO, 0, Length(szMsg), 0, 0, 0))  + szMsg;
  if pServerInfo.Socket <> nil then begin
    pServerInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
    QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
  end;
end;

procedure TfrmUpdate.SendUpdateWavData(pServerInfo:pTServerInfo; pUpdateInfo:pTUpdateInfo);
var
  szAction, szMsg:string;
begin
  szMsg:= EncodeBuffer(PAnsiChar(pUpdateInfo), sizeof(TUpdateInfo));
  szAction:= EncodeMessage(MakeDefaultMsg(CM_UPDATEWAVDATA, 0, Length(szMsg), 0, 0, 0))  + szMsg;
  if pServerInfo.Socket <> nil then begin
    pServerInfo.Socket.SendText(MG_CodeHead + szAction + MG_CodeEnd);
    QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
  end;
end;

procedure TfrmUpdate.SendUpdateInitializeImages(dwRecogerId:LongWord; szFileName:string);
var
  nIndex:Integer;
  pUpdateInfo:pTUpdateInfo;
  pServerInfo:pTServerInfo;
begin
  if (szFileName <> '') then begin
    //生成更新对象
    new(pUpdateInfo);
    FillChar(pUpdateInfo^, sizeof(TUpdateInfo), #0);
    pUpdateInfo.utUpdateType:= utWzlHead;                                       //更新文件头
    pUpdateInfo.nImageIndex:= -1;
    pUpdateInfo.boDownLoad:= False;
    pUpdateInfo.dwFileSize:= 0;
    pUpdateInfo.dwRecvSize:= 0;
    pUpdateInfo.szFileName:= ShortString(szFileName);
    pUpdateInfo.dwRecogerId:= dwRecogerId;
    g_vcUpdateHeadStr.Add(pUpdateInfo);
    //遍历可更新服务器
    EnterCriticalSection(m_csServerSocketSection);
    pServerInfo:= nil;
    for nIndex := 0 to m_vcUpdateList.Count - 1 do begin
      pServerInfo:= m_vcUpdateList.Items[nIndex];
      //检测是否可以提交更新
      if pServerInfo.boVerifyConn and (pServerInfo.pUpdateInfo = nil) then begin
        break;
      end;
      pServerInfo:=nil;
    end;

    if (pServerInfo <> nil) then begin
      if g_vcUpdateHeadStr.Count > 0 then begin
        pUpdateInfo:= g_vcUpdateHeadStr.First;
        if pUpdateInfo <> nil then begin
          g_vcUpdateHeadStr.Delete(g_vcUpdateHeadStr.IndexOf(pUpdateInfo));
          //发送更新消息
          pServerInfo.pUpdateInfo:= pUpdateInfo;
          SendUpdateHead(pServerInfo, pUpdateInfo);
        end;
      end;
    end;
    LeaveCriticalSection(m_csServerSocketSection);
  end;
end;

procedure TfrmUpdate.SendUpdateImages(dwRecogerId:LongWord; szFileName:string; nImageId:Integer);
var
  nIndex:Integer;
  pUpdateInfo:pTUpdateInfo;
  pServerInfo:pTServerInfo;
begin
  if (szFileName <> '') and (nImageId <> -1) then begin
    //生成更新对象
    new(pUpdateInfo);
    FillChar(pUpdateInfo^, sizeof(TUpdateInfo), #0);
    pUpdateInfo.utUpdateType:= utImgHead;                                       //更新文件头
    pUpdateInfo.nImageIndex:= nImageId;
    pUpdateInfo.boDownLoad:= False;
    pUpdateInfo.dwFileSize:= 0;
    pUpdateInfo.dwRecvSize:= 0;
    pUpdateInfo.szFileName:= ShortString(szFileName);
    pUpdateInfo.dwRecogerId:= dwRecogerId;
    g_vcUpdateDataStr.Add(pUpdateInfo);
    //遍历可更新服务器
    EnterCriticalSection(m_csServerSocketSection);
    pServerInfo:= nil;
    for nIndex := 0 to m_vcUpdateList.Count - 1 do begin
      pServerInfo:= m_vcUpdateList.Items[nIndex];
      //检测是否可以提交更新
      if pServerInfo.boVerifyConn and (pServerInfo.pUpdateInfo = nil) then begin
        break;
      end;
      pServerInfo:=nil;
    end;

    if (pServerInfo <> nil) then begin
      if g_vcUpdateDataStr.Count > 0 then begin
        pUpdateInfo:= g_vcUpdateDataStr.First;
        if pUpdateInfo <> nil then begin
          g_vcUpdateDataStr.Delete(g_vcUpdateDataStr.IndexOf(pUpdateInfo));
          //发送更新消息
          pServerInfo.pUpdateInfo:= pUpdateInfo;
          SendUpdateInfo(pServerInfo, pUpdateInfo);
        end;
      end;
    end;
    LeaveCriticalSection(m_csServerSocketSection);
  end;
end;

procedure TfrmUpdate.SendUpdateMap(sMap:string);
var
  nIndex:Integer;
  pUpdateInfo:pTUpdateInfo;
  pServerInfo:pTServerInfo;
begin
  if sMap <> '' then begin
    //生成更新对象
    new(pUpdateInfo);
    FillChar(pUpdateInfo^, sizeof(TUpdateInfo), #0);
    pUpdateInfo.utUpdateType:= utMap;                                       //更新文件头
    pUpdateInfo.nImageIndex:= -1;
    pUpdateInfo.boDownLoad:= False;
    pUpdateInfo.dwFileSize:= 0;
    pUpdateInfo.dwRecvSize:= 0;
    pUpdateInfo.szFileName:= ShortString(sMap);
    pUpdateInfo.dwRecogerId:= 0;
    g_vcUpdateHeadStr.Insert(0, pUpdateInfo);
    //遍历可更新服务器
    EnterCriticalSection(m_csServerSocketSection);
    pServerInfo:= nil;
    for nIndex := 0 to m_vcUpdateList.Count - 1 do begin
      pServerInfo:= m_vcUpdateList.Items[nIndex];
      //检测是否可以提交更新
      if pServerInfo.boVerifyConn and (pServerInfo.pUpdateInfo = nil) then begin
        break;
      end;
      pServerInfo:=nil;
    end;

    if (pServerInfo <> nil) then begin
      if g_vcUpdateHeadStr.Count > 0 then begin
        pUpdateInfo:= g_vcUpdateHeadStr.First;
        if pUpdateInfo <> nil then begin
          g_vcUpdateHeadStr.Delete(g_vcUpdateHeadStr.IndexOf(pUpdateInfo));
          //发送更新消息
          pServerInfo.pUpdateInfo:= pUpdateInfo;
          SendUpdateMapInfo(pServerInfo, pUpdateInfo);
        end;
      end;
    end;
    LeaveCriticalSection(m_csServerSocketSection);
  end;
end;

procedure TfrmUpdate.SendUpdateWav(sWav:string; stScene:TSceneType; boBGM:Boolean);
var
  nIndex:Integer;
  pUpdateInfo:pTUpdateInfo;
  pServerInfo:pTServerInfo;
begin
  if sWav <> '' then begin
    //生成更新对象
    new(pUpdateInfo);
    FillChar(pUpdateInfo^, sizeof(TUpdateInfo), #0);
    pUpdateInfo.utUpdateType:= utWav;                                           //更新文件头
    pUpdateInfo.nImageIndex:= Integer(stScene);                                          //保存场景类型
    pUpdateInfo.boDownLoad:= False;
    pUpdateInfo.dwFileSize:= 0;
    pUpdateInfo.dwRecvSize:= 0;
    pUpdateInfo.szFileName:= ShortString(sWav);
    pUpdateInfo.dwRecogerId:= Integer(boBGM);                                   //是否更新玩播放
    g_vcUpdateWavStr.Add(pUpdateInfo);
    //遍历可更新服务器
    EnterCriticalSection(m_csServerSocketSection);
    pServerInfo:= nil;
    for nIndex := 0 to m_vcUpdateList.Count - 1 do begin
      pServerInfo:= m_vcUpdateList.Items[nIndex];
      //检测是否可以提交更新
      if pServerInfo.boVerifyConn and (pServerInfo.pUpdateInfo = nil) then begin
        break;
      end;
      pServerInfo:=nil;
    end;

    if (pServerInfo <> nil) then begin
      if g_vcUpdateWavStr.Count > 0 then begin
        pUpdateInfo:= g_vcUpdateWavStr.First;
        if pUpdateInfo <> nil then begin
          g_vcUpdateWavStr.Delete(g_vcUpdateWavStr.IndexOf(pUpdateInfo));
          //发送更新消息
          pServerInfo.pUpdateInfo:= pUpdateInfo;
          SendUpdateWavInfo(pServerInfo, pUpdateInfo);
        end;
      end;
    end;
    LeaveCriticalSection(m_csServerSocketSection);
  end;
end;

procedure TfrmUpdate.SendKeepAlivePacket(Socket: TCustomWinSocket);
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

procedure TfrmUpdate.OnRecvWZLHeadInfo(pServerInfo:pTServerInfo; raAction:TDefaultMessage; szBody:string);
var
  nZip, nIndex, nLoaded, nLen, nSize:Integer;
  pData:PAnsiChar;
  Info:TWZImageInfo;
  WZIndex:TWZIndexHeader;
  WMIndex:TWMIndexHeader;
  bo16bit:Boolean;
  pUpdateInfo, pDeleteInfo:pTUpdateInfo;
begin
  if pServerInfo.pUpdateInfo.utUpdateType = utWzlHead then begin
    if raAction.Series = S_OK then begin
      //更新资源文件头信息
      nZip:= raAction.Tag;
      if nZip = 1 then begin
        DecodeBuffer(szBody, @WZIndex, sizeof(TWZIndexHeader));
        pData:= PAnsiChar(@WZIndex);
        nSize:= sizeof(TWZIndexHeader);
      end else begin
        DecodeBuffer(szBody, @WMIndex, sizeof(TWMIndexHeader));
        pData:= PAnsiChar(@WMIndex);
        nSize:= sizeof(TWMIndexHeader);
      end;
      TWMImages(pServerInfo.pUpdateInfo.dwRecogerID).SynchronizeProcessImagesHeadWrite(pData, nSize);
    end;
    pDeleteInfo:= pServerInfo.pUpdateInfo;
    //检测队列是否还有待发送数据
    if g_vcUpdateHeadStr.Count > 0 then begin
      pUpdateInfo:= g_vcUpdateHeadStr.First;
      if pUpdateInfo <> nil then begin
        g_vcUpdateHeadStr.Delete(g_vcUpdateHeadStr.IndexOf(pUpdateInfo));
        //更新发送对象
        pServerInfo.pUpdateInfo:= pUpdateInfo;
        //释放完成对象
        dispose(pDeleteInfo);
        //发送更新对象
        SendUpdateHead(pServerInfo, pUpdateInfo);
      end;
    end else begin
      //释放完成对象
      dispose(pServerInfo.pUpdateInfo);
      pServerInfo.pUpdateInfo:= nil;
    end;
  end;
end;

procedure TfrmUpdate.OnRecvDataHeadInfo(pServerInfo:pTServerInfo; raAction:TDefaultMessage; szBody:string);
var
  nZip, nIndex, nLoaded, nLen, nSize:Integer;
  pData:PAnsiChar;
  Info:TWZImageInfo;
  WZIndex:TWZIndexHeader;
  WMIndex:TWMIndexHeader;
  bo16bit:Boolean;
  pUpdateInfo, pDeleteInfo:pTUpdateInfo;
begin
  if pServerInfo.pUpdateInfo.utUpdateType = utImgHead then begin
    //更新图片文件头信息
    nZip:= raAction.Tag;
    nLoaded:= raAction.Series;
    nSize:= raAction.Param;
    if (nLoaded = S_OK) then begin
      if raAction.Recog = pServerInfo.pUpdateInfo.nImageIndex then begin
        //更新图片文件头信息
        nIndex:= pServerInfo.pUpdateInfo.nImageIndex;
        if nZip = 1 then begin
          DecodeBuffer(szBody, @Info, sizeof(TWZImageInfo));
        end else begin
          DecodeBuffer(szBody, @Info, sizeof(TWZImageInfo));
          pData:= PAnsiChar(@Info);
        end;
        //更新图片数据列信息
        if Info.nSize = 0 then begin
          bo16bit := Info.Encode = 5;
          if bo16bit then begin
            nLen := WidthBytes(16, Info.DXInfo.nWidth);
            Info.nSize := nLen * Info.DXInfo.nHeight;
          end else begin
            nLen := WidthBytes(8, Info.DXInfo.nWidth);
            Info.nSize := nLen * Info.DXInfo.nHeight;
          end;
        end;

        pServerInfo.pUpdateInfo.utUpdateType:= utImage;
        pServerInfo.pUpdateInfo.dwFileSize:= Info.nSize  + sizeof(TWZImageInfo);
        pServerInfo.pUpdateInfo.boDownLoad:= True;
        SendUpdateData(pServerInfo, pServerInfo.pUpdateInfo);
      end else begin
        //释放完成对象
        dispose(pServerInfo.pUpdateInfo);
        pServerInfo.pUpdateInfo:= nil;
      end;

    end else begin
      //更新资源状态
      nIndex:= pServerInfo.pUpdateInfo.nImageIndex;
      TWMImages(pServerInfo.pUpdateInfo.dwRecogerID).SynchronizeProcessImagesHeadNotFound(nIndex);
      pDeleteInfo:= pServerInfo.pUpdateInfo;

      //检测队列是否还有待发送数据
    if g_vcUpdateHeadStr.Count > 0 then begin
      pUpdateInfo:= g_vcUpdateHeadStr.First;
      if pUpdateInfo <> nil then begin
        g_vcUpdateHeadStr.Delete(g_vcUpdateHeadStr.IndexOf(pUpdateInfo));

        //更新发送对象
        pServerInfo.pUpdateInfo:= pUpdateInfo;
        //释放完成对象
        dispose(pDeleteInfo);
        //发送更新对象
        SendUpdateHead(pServerInfo, pUpdateInfo);
      end;
    end else
      //继续投递列表对象
      if (g_vcUpdateDataStr.Count > 0) then begin
        pUpdateInfo:= g_vcUpdateDataStr.First;
        if pUpdateInfo <> nil then begin
          g_vcUpdateDataStr.Delete(g_vcUpdateDataStr.IndexOf(pUpdateInfo));

          //移除完成对象
          pDeleteInfo:= pServerInfo.pUpdateInfo;
          //更新发送对象
          pServerInfo.pUpdateInfo:= pUpdateInfo;
          //释放完成对象
          dispose(pDeleteInfo);
          //发送更新对象
          SendUpdateInfo(pServerInfo, pUpdateInfo);
        end;
      end else begin
        //释放完成对象
        dispose(pServerInfo.pUpdateInfo);
        pServerInfo.pUpdateInfo:= nil;
      end;
    end;
  end;
end;

procedure TfrmUpdate.OnRecvMapSizeInfo(pServerInfo:pTServerInfo; raAction:TDefaultMessage; szBody:string);
var
  ZipInfo:TZipInfo;
  pUpdateInfo, pDeleteInfo:pTUpdateInfo;
begin
  if pServerInfo.pUpdateInfo.utUpdateType = utMap then begin
    if (raAction.Series = S_OK) then begin
      DecodeBuffer(szBody, @ZipInfo, SizeOf(TZipInfo));
      if ZipInfo.dwZipSize > 0 then begin
        pServerInfo.pUpdateInfo.boZipData:= True;
        pServerInfo.pUpdateInfo.dwZipSize:= ZipInfo.dwSize;
        pServerInfo.pUpdateInfo.dwZipLevel:= ZipInfo.dwZipLevel;
        pServerInfo.pUpdateInfo.dwFileSize:= ZipInfo.dwZipSize;
      end else begin
        pServerInfo.pUpdateInfo.dwFileSize:= ZipInfo.dwSize;
      end;
      pServerInfo.pUpdateInfo.boDownLoad:= True;
      SendUpdateMapData(pServerInfo, pServerInfo.pUpdateInfo);
    end else begin
      //更新失败(微端服务器未找到该地图文件)
      g_LegendMap.UpdateError;
      pDeleteInfo:= pServerInfo.pUpdateInfo;
      //检测队列是否还有待发送数据
    if g_vcUpdateHeadStr.Count > 0 then begin
      pUpdateInfo:= g_vcUpdateHeadStr.First;
      if pUpdateInfo <> nil then begin
        g_vcUpdateHeadStr.Delete(g_vcUpdateHeadStr.IndexOf(pUpdateInfo));

        //更新发送对象
        pServerInfo.pUpdateInfo:= pUpdateInfo;
        //释放完成对象
        dispose(pDeleteInfo);
        //发送更新对象
        SendUpdateHead(pServerInfo, pUpdateInfo);
      end;
    end else
      //继续投递列表对象
      if (g_vcUpdateDataStr.Count > 0) then begin
        pUpdateInfo:= g_vcUpdateDataStr.First;
        if pUpdateInfo <> nil then begin
          g_vcUpdateDataStr.Delete(g_vcUpdateDataStr.IndexOf(pUpdateInfo));

          //移除完成对象
          pDeleteInfo:= pServerInfo.pUpdateInfo;
          //更新发送对象
          pServerInfo.pUpdateInfo:= pUpdateInfo;
          //释放完成对象
          dispose(pDeleteInfo);
          //发送更新对象
          SendUpdateInfo(pServerInfo, pUpdateInfo);
        end;
      end else begin
        //释放完成对象
        dispose(pServerInfo.pUpdateInfo);
        pServerInfo.pUpdateInfo:= nil;
      end;
    end;
  end;
end;

procedure TfrmUpdate.OnRecvWavSizeInfo(pServerInfo:pTServerInfo; raAction:TDefaultMessage; szBody:string);
var
  ZipInfo:TZipInfo;
  pUpdateInfo, pDeleteInfo:pTUpdateInfo;
begin
  if pServerInfo.pUpdateInfo.utUpdateType = utWav then begin
    if (raAction.Series = S_OK) then begin
      DecodeBuffer(szBody, @ZipInfo, SizeOf(TZipInfo));
      if ZipInfo.dwZipSize > 0 then begin
        pServerInfo.pUpdateInfo.boZipData:= True;
        pServerInfo.pUpdateInfo.dwZipSize:= ZipInfo.dwSize;
        pServerInfo.pUpdateInfo.dwZipLevel:= ZipInfo.dwZipLevel;
        pServerInfo.pUpdateInfo.dwFileSize:= ZipInfo.dwZipSize;
      end else begin
        pServerInfo.pUpdateInfo.dwFileSize:= ZipInfo.dwSize;
      end;
      pServerInfo.pUpdateInfo.boDownLoad:= True;
      SendUpdateWavData(pServerInfo, pServerInfo.pUpdateInfo);
    end else begin
      //更新失败(微端服务器未找到该地图文件)
      pDeleteInfo:= pServerInfo.pUpdateInfo;
      //检测队列是否还有待发送数据
    if g_vcUpdateHeadStr.Count > 0 then begin
      pUpdateInfo:= g_vcUpdateHeadStr.First;
      if pUpdateInfo <> nil then begin
        g_vcUpdateHeadStr.Delete(g_vcUpdateHeadStr.IndexOf(pUpdateInfo));

        //更新发送对象
        pServerInfo.pUpdateInfo:= pUpdateInfo;
        //释放完成对象
        dispose(pDeleteInfo);
        //发送更新对象
        SendUpdateHead(pServerInfo, pUpdateInfo);
      end;
    end else
      //继续投递列表对象
      if (g_vcUpdateDataStr.Count > 0) then begin
        pUpdateInfo:= g_vcUpdateDataStr.First;
        if pUpdateInfo <> nil then begin
          g_vcUpdateDataStr.Delete(g_vcUpdateDataStr.IndexOf(pUpdateInfo));

          //移除完成对象
          pDeleteInfo:= pServerInfo.pUpdateInfo;
          //更新发送对象
          pServerInfo.pUpdateInfo:= pUpdateInfo;
          //释放完成对象
          dispose(pDeleteInfo);
          //发送更新对象
          SendUpdateInfo(pServerInfo, pUpdateInfo);
        end;
      end else begin
        //释放完成对象
        dispose(pServerInfo.pUpdateInfo);
        pServerInfo.pUpdateInfo:= nil;
      end;
    end;
  end;
end;

procedure TfrmUpdate.OnClientUpdateComplete(pServerInfo:pTServerInfo);
var
  nIndex, nSize, nZipSize:Integer;
  pData, pZipData:PByte;
  pUpdateInfo, pDeleteInfo:pTUpdateInfo;
begin
  if pServerInfo.pUpdateInfo.utUpdateType = utImage then begin
    nIndex:= pServerInfo.pUpdateInfo.nImageIndex;
    pData:= pServerInfo.ImageStream.Memory;
    nSize:= pServerInfo.ImageStream.Size;
    TWMImages(pServerInfo.pUpdateInfo.dwRecogerID).SynchronizeProcessImagesWrite(nIndex, pData, nSize);
    pServerInfo.boUpdateComplete:= False;
    pServerInfo.ImageStream.Clear;
    pServerInfo.ImageStream.Position:= 0;
    //检测是否游戏场景
    if g_stMainScenes = stPlayGame then begin
      //重绘地图地砖
      g_PlayScene.ReDrawMap;
    end;
  end else if pServerInfo.pUpdateInfo.utUpdateType = utMap then begin
    if pServerInfo.pUpdateInfo.boZipData then begin
      pZipData:= pServerInfo.ImageStream.Memory;
      nZipSize:= pServerInfo.ImageStream.Size;
      GetMem(pData, pServerInfo.pUpdateInfo.dwZipSize);                       //原始文件大小
      nSize:= ZIPDecompress(pZipData, nZipSize, pServerInfo.pUpdateInfo.dwZipLevel, PAnsiChar(pData));
    end  else begin
      pData:= pServerInfo.ImageStream.Memory;
      nSize:= pServerInfo.ImageStream.Size;
    end;

    g_LegendMap.UpdateMapData(string(pServerInfo.pUpdateInfo.szFileName), pData, nSize);
    pServerInfo.boUpdateComplete:= False;
    pServerInfo.ImageStream.Clear;
    pServerInfo.ImageStream.Position:= 0;
  end else if pServerInfo.pUpdateInfo.utUpdateType = utWav then begin
    if pServerInfo.pUpdateInfo.boZipData then begin
      pZipData:= pServerInfo.ImageStream.Memory;
      nZipSize:= pServerInfo.ImageStream.Size;
      GetMem(pData, pServerInfo.pUpdateInfo.dwZipSize);                       //原始文件大小
      nSize:= ZIPDecompress(pZipData, nZipSize, pServerInfo.pUpdateInfo.dwZipLevel, PAnsiChar(pData));
    end  else begin
      pData:= pServerInfo.ImageStream.Memory;
      nSize:= pServerInfo.ImageStream.Size;
    end;
    SaveWavFileData(string(pServerInfo.pUpdateInfo.szFileName), pData, TSceneType(pServerInfo.pUpdateInfo.nImageIndex), nSize, Boolean(pServerInfo.pUpdateInfo.dwRecogerID));
    pServerInfo.boUpdateComplete:= False;
    pServerInfo.ImageStream.Clear;
    pServerInfo.ImageStream.Position:= 0;
  end;


  pDeleteInfo:= pServerInfo.pUpdateInfo;
  if g_vcUpdateHeadStr.Count > 0 then begin
      pUpdateInfo:= g_vcUpdateHeadStr.First;
      if pUpdateInfo <> nil then begin
        g_vcUpdateHeadStr.Delete(g_vcUpdateHeadStr.IndexOf(pUpdateInfo));
        //更新发送对象
        pServerInfo.pUpdateInfo:= pUpdateInfo;
        //释放完成对象
        dispose(pDeleteInfo);
        //发送更新对象
        SendUpdateHead(pServerInfo, pUpdateInfo);
      end;
  end else
  //检测队列是否还有待发送数据
  if (g_vcUpdateDataStr.Count > 0) then begin
    pUpdateInfo:= g_vcUpdateDataStr.First;
    if pUpdateInfo <> nil then begin
      g_vcUpdateDataStr.Delete(g_vcUpdateDataStr.IndexOf(pUpdateInfo));
      //更新发送对象
      pServerInfo.pUpdateInfo:= pUpdateInfo;
      //释放完成对象
      dispose(pDeleteInfo);
      //发送更新对象
      SendUpdateInfo(pServerInfo, pUpdateInfo);
    end;
  end else begin
    //释放完成对象
    dispose(pDeleteInfo);
    pServerInfo.pUpdateInfo:= nil;
  end;
end;

procedure TfrmUpdate.OnUpdateSocketMsg(pServerInfo:pTServerInfo);
var
  szBody, szAction:string;
  raAction:TDefaultMessage;
  dwCommand:LongWord;
begin
  while True do begin
    //检测是否有可存储的资源数据
    if Pos(MG_CodeEnd, pServerInfo.sStr) <= 0 then break;
    //取出单包信息
    pServerInfo.sStr := ArrestStringEx(pServerInfo.sStr, MG_CodeHead, MG_CodeEnd, szBody);
    if not pServerInfo.boVerifyConn then begin
      //校验连接安全信息
      if MG_SAFECONNECTEDMSG = szBody then begin
        pServerInfo.boVerifyConn:= True;
      end;
      continue;
    end;
    if szBody <> '' then begin
      if Length(AnsiString(szBody)) = DEFAULTENCODEACTIONSIZE then begin
        szAction:= szBody;
      end else begin
        szAction:= LeftStr(szBody, DEFAULTENCODEACTIONSIZE);
      end;
      FillChar(raAction, sizeof(TDefaultMessage), 0);
      szBody:= MidStr(szBody, DEFAULTENCODEACTIONSIZE+1, Length(AnsiString(szBody)) - DEFAULTENCODEACTIONSIZE);
      DecodeBuffer(szAction, @raAction, sizeof(TDefaultMessage));
      dwCommand:= raAction.Ident;
      if dwCommand = MG_ALIVEMSG then begin
        //客户端心跳包
        QueryPerformanceCounter(Int64(pServerInfo.liKeepAliveTime));
        QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
        continue;
      end;
      case dwCommand of
        SM_UPDATEHEAD:begin
          OnRecvWZLHeadInfo(pServerInfo, raAction, szBody);
          QueryPerformanceCounter(Int64(pServerInfo.liKeepAliveTime));
          QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
        end;
        SM_UPDATEINFO:begin
          //更新文件
          OnRecvDataHeadInfo(pServerInfo, raAction, szBody);
          QueryPerformanceCounter(Int64(pServerInfo.liKeepAliveTime));
          QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
        end;
        SM_UPDATECOMPELETE:begin
          //处理资源更新
          if pServerInfo.boUpdateComplete then begin
            OnClientUpdateComplete(pServerInfo);
          end;
        end;
        SM_UPDATEMAPINFO:begin
          OnRecvMapSizeInfo(pServerInfo, raAction, szBody);
        end;
        SM_UPDATEWAVINFO:begin
          OnRecvWavSizeInfo(pServerInfo, raAction, szBody);
        end;
      end;
    end;
  end;
end;

procedure TfrmUpdate.OnVerifyServerTimeOut;
var
  fTime:Double;
  liQueryTime: LARGE_INTEGER;
  pServerInfo:pTServerInfo;
begin
  if m_nVerifyServerId >= m_vcUpdateList.Count then begin
    m_nVerifyServerId:= 0;
  end;
  if (m_vcUpdateList.Count > 0) and (m_nVerifyServerId < m_vcUpdateList.Count) then begin
    pServerInfo:= m_vcUpdateList.Items[m_nVerifyServerId];
    if pServerInfo.boVerifyConn then begin
      //发送心跳
      QueryPerformanceCounter(Int64(liQueryTime));
      fTime:= (liQueryTime.QuadPart - pServerInfo.liSendKeepAliveTime.QuadPart) / g_dbFrequency / 1000;
      if (fTime >= m_dwSendkeepAliveTick) then begin
        SendKeepAlivePacket(pServerInfo.Socket);
        pServerInfo.liSendKeepAliveTime.QuadPart:= liQueryTime.QuadPart;
      end;

      //检测心跳包是否超时
      QueryPerformanceCounter(Int64(liQueryTime));
      fTime:= (liQueryTime.QuadPart - pServerInfo.liKeepAliveTime.QuadPart) / g_dbFrequency / 1000;
      if (fTime >= m_dwKeepAliveTimeOut) then begin
        pServerInfo.boClosed:= True;
        pServerInfo.boVerifyConn:= False;
        pServerInfo.boKeepAliveTimcOut:=True;
        pServerInfo.Socket.Close;
      end;
    end;
    InterlockedIncrement(m_nVerifyServerId);
  end;
end;

destructor TfrmUpdate.Destroy;
begin
  m_vcUpdateList.Free;
  m_vcUpdateRevice.Free;
  DeleteCriticalSection(m_csServerSocketSection);
  DeleteCriticalSection(m_csUpdatesSocketSection);
  inherited Destroy;
end;

function TfrmUpdate.CUpdateThreadMsg:Integer;
var
  pServerInfo:pTServerInfo;
begin
  while g_gsStatus <> gsClose do begin
    if m_vcUpdateRevice.Count > 0 then begin
      pServerInfo:= pTServerInfo(m_vcUpdateRevice.First);
      m_vcUpdateRevice.Delete(m_vcUpdateRevice.IndexOf(pServerInfo));
      if pServerInfo <> nil then begin
        OnUpdateSocketMsg(pServerInfo);
      end;
    end;
    OnVerifyServerTimeOut;
    Sleep(10);
  end;
  result:= 0;
end;

procedure TfrmUpdate.DUpdateConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  Index: Integer;
  pServerInfo:pTServerInfo;
begin
  EnterCriticalSection(m_csUpdatesSocketSection);
  Index:= Socket.nIndex;
  if (Index >= 0) and (Index < GATEMAXSESSION) then begin
    pServerInfo:= @g_vcUpdateArray[Index];
    if pServerInfo.Socket = nil then begin
      pServerInfo.nServerIndex:= Index;
      pServerInfo.Socket:= Socket;
      pServerInfo.boClosed:= False;
      pServerInfo.boVerifyConn:= False;
      pServerInfo.ImageStream:= TMemoryStream.Create;
      pServerInfo.pUpdateInfo:= nil;
      QueryPerformanceCounter(Int64(pServerInfo.liConnctTick));
      pServerInfo.liKeepAliveTime.QuadPart:= pServerInfo.liConnctTick.QuadPart;
      pServerInfo.liLastRecvTime.QuadPart:= pServerInfo.liConnctTick.QuadPart;
      pServerInfo.liVerifyServerTime.QuadPart:= pServerInfo.liConnctTick.QuadPart;
      m_vcUpdateList.Add(pServerInfo);
      if g_boOpenConnectedMode  then begin
        Socket.SendText(MG_CodeHead + MG_SAFECONNECTEDMSG + MG_CodeEnd);
      end;
    end;
  end;
  LeaveCriticalSection(m_csUpdatesSocketSection);
end;

procedure TfrmUpdate.DUpdateDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  Index: Integer;
  pServerInfo:pTServerInfo;
begin
  EnterCriticalSection(m_csUpdatesSocketSection);
  Index:= Socket.nIndex;
  if (Index >= 0) and (Index < GATEMAXSESSION) then begin
    pServerInfo:= @g_vcUpdateArray[Index];
    if pServerInfo.Socket <> nil then begin
      //释放服务对象
      pServerInfo.Socket:= nil;
      pServerInfo.boClosed:= True;
      pServerInfo.nServerIndex:=-1;
      pServerInfo.boVerifyConn:= False;
      pServerInfo.ImageStream.Free;
      pServerInfo.pUpdateInfo:= nil;
      pServerInfo.boKeepAliveTimcOut:= False;
      pServerInfo.sStr:= '';
      pServerInfo.sServerAddr:= '';
      pServerInfo.wServerPort:= 0;
      FillChar(pServerInfo.liConnctTime, sizeof(LARGE_INTEGER), 0);
      FillChar(pServerInfo.liConnctTick, sizeof(LARGE_INTEGER), 0);
      FillChar(pServerInfo.liLastRecvTime, sizeof(LARGE_INTEGER), 0);
      FillChar(pServerInfo.liKeepAliveTime, sizeof(LARGE_INTEGER), 0);
      FillChar(pServerInfo.liVerifyServerTime, sizeof(LARGE_INTEGER), 0);
      FillChar(pServerInfo.liSendKeepAliveTime, sizeof(LARGE_INTEGER), 0);
      //移除对象所在链表数据
      m_vcUpdateList.Delete(m_vcUpdateList.IndexOf(pServerInfo));
    end;
  end;
  LeaveCriticalSection(m_csUpdatesSocketSection);
end;

procedure TfrmUpdate.DUpdateRead(Sender: TObject; Socket: TCustomWinSocket);
var
  Index: Integer;
  dwTrans:Integer;
  szAction:string;
  pRecvBuffer:PAnsiChar;
  pServerInfo:pTServerInfo;
begin
  Index:= Socket.nIndex;
  if (Index >= 0) and (Index < GATEMAXSESSION) then begin
    pServerInfo:= pTServerInfo(@g_vcUpdateArray[Index]);
    if (pServerInfo.pUpdateInfo = nil) or (not pServerInfo.pUpdateInfo.boDownLoad) then begin
      pServerInfo.sStr:= pServerInfo.sStr + Socket.ReceiveText;
      m_vcUpdateRevice.Add(pServerInfo);
    end else begin

      QueryPerformanceCounter(Int64(pServerInfo.liKeepAliveTime));
      QueryPerformanceCounter(Int64(pServerInfo.liSendKeepAliveTime));
      pServerInfo.pUpdateInfo.dwRecvSize:= pServerInfo.pUpdateInfo.dwRecvSize + LongWord(Socket.ReceiveSize);
      dwTrans:= Socket.ReceiveSize;
      pRecvBuffer:= Socket.ReceiceBuff;
      pServerInfo.ImageStream.WriteBuffer(pRecvBuffer^, dwTrans);
      if pServerInfo.pUpdateInfo.dwRecvSize = pServerInfo.pUpdateInfo.dwFileSize then begin
        pServerInfo.boUpdateComplete:= True;
        szAction:= EncodeMessage(MakeDefaultMsg(SM_UPDATECOMPELETE, 0, 0, 0, 0, 0));
        pServerInfo.sStr:= MG_CodeHead + szAction + MG_CodeEnd;
        m_vcUpdateRevice.Add(pServerInfo);
      end;
    end;
  end;
end;

function CUpdateReviceThreadPro(Parameter: Pointer): Integer;
begin
  Result:= frmUpdate.CUpdateThreadMsg;
end;

end.
