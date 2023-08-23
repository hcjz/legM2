unit uSocket;

interface

uses
  Windows, Classes, SysUtils, uWinsock2;

{------------------------------- 运行环境版本 ----------------------------------
                        Running for Delphi 10 Seattle
                                  2016.08.20
-------------------------------------------------------------------------------}

const
  MAXTHREADSIZE           = 64;
  MAX_RECV_SIZE                               = 32768;                           //最大接收上限
  DEFAULTMAXFREEBUFFRESIZE                    = 2000;
  DEFAULTMAXFREESOCKETSIZE                    = 1000;

type
  ESocketError = class(Exception);
  TCustomWinSocket = class;

  TErrorEvent = (eeGeneral, eeSend, eeRecv, eeConnect, eeDisconnect, eeAccept, eeLookup);
  TSocketEvent = (seNone, seAccept, seConnect, seRecv, seSend, seDisconnect);
  TSocketStyle = (
    ssUnknow,                                                                   //未知
    ssSWSocket,                                                                 //服务器(主)
    ssCWSocket,                                                                 //客户端(主)
    ssGSSocket,                                                                 //服务器(副)
    ssGCSocket);                                                                //客户端(副)

  TSocketNotifyEvent = procedure (Sender: TObject; Socket: TCustomWinSocket) of object;
  TSocketErrorEvent = procedure (Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; szError:string) of object;

  pTBuffer = ^TBuffer;
  TBuffer = packed record
    Overlapped: OVERLAPPED;
    Event:TSocketEvent;
    dwSocket:TSocket;
    dwSequenceNumber: LongWord;   //当前序列
    dwSendTrans: LongWord;        //数据大小
    dwRetnTrans: LongWord;        //返回大小
    szData: array[0..MAX_RECV_SIZE-1] of AnsiChar;
  end;

  TCustomWinSocket = class(TObject)
  private
    m_stSocket: TSocket;
    m_boConnected: Boolean;
    m_ssStyle:TSocketStyle;
    m_szHost: string;
    m_wdPort: Word;
    m_boActive:Boolean;
    m_boNoDelay:Boolean;
    m_pRecvData:pTBuffer;
    m_pSendData:pTBuffer;
    m_boSocketError: Boolean;
    m_boSendOver:Boolean;
    m_DParent:TCustomWinSocket;
    m_vcSendList:TList;
    m_szLocalAddress:string;
    m_nCurSequencesNumber:Integer;                                              //当前发送编号
    m_nSequencesNumber:Integer;                                                 //最后发送编号
    m_nOutstandingSend:Integer;
    m_nOutstandingRecv:Integer;
    m_nConnection:Integer;
    m_vcConnections: TList;
    m_fnOnErrorEvent: TSocketErrorEvent;
    m_csSendListSection: TRTLCriticalSection;
    m_csCriticalSection: TRTLCriticalSection;                                   //用户锁
    m_csSendCriticalSection: TRTLCriticalSection;
  private
    procedure Unitialize;
    procedure SendDataList;
    function SendBufEx(var Buf; Count: Integer):Integer;
    function AsyncSendBuf(Buf:PAnsiChar; Count: Integer):Integer;
    procedure AddSendBuffList(Buf:PAnsiChar; Count:Integer);
    function GetCurrSendDataByCurSequenceNumber(nCurSequencesNumber:Integer):pTBuffer;
  protected
    procedure AddCSocket(Socket:TCustomWinSocket);
    procedure DelCSocket(Socket:TCustomWinSocket);
  public
    nIndex:Integer;
    constructor Create; overload;
    destructor Destroy; override;
    procedure Close; virtual;
    procedure Lock;
    procedure UnLock;
    procedure SendLock;
    procedure SendUnlock;
    procedure InitializeWinsock; virtual;
    function ReceiveText:string;
    function ReceiceBuff:PAnsiChar;
    function ReceiveSize:Integer;
    procedure UpdateData(pBuffer:pTBuffer);
    procedure UpdateSendData(pBuffer:pTBuffer);
    function EmptyOutstandingEvent:Boolean;
    procedure SocketError;
    function SendBuf(Buf:PAnsiChar; Count: Integer; boAsyncSend:Boolean = True): Integer;
    function SendText(S: string; boAsyncSend:Boolean = True): Integer;
    function PostSocketWSAEvent(pBuffer:pTBuffer):Boolean;
    function CheckSocketResult(ResultCode: Integer; const Op: string): Integer;
    procedure Event(Socket: TCustomWinSocket; SocketEvent: TSocketEvent); dynamic;
    procedure Error(Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: LongWord); dynamic;
    property Connection: Integer read m_nConnection;
    property DParent: TCustomWinSocket read m_DParent write m_DParent;
    property Connected: Boolean read m_boConnected write m_boConnected;
    property Active: Boolean read m_boActive write m_boActive;
    property Host:string read m_szHost write m_szHost;
    property Port:Word read m_wdPort write m_wdPort;
    property LocalAddress:string read m_szLocalAddress;
    property Socket: TSocket read m_stSocket write m_stSocket;
    property Style: TSocketStyle read m_ssStyle write m_ssStyle;
    property NoDelay: Boolean read m_boNoDelay write m_boNoDelay;
  end;

  TServerWinSocket = class(TCustomWinSocket)                                    //服务对象
  private
    m_hAccept:THandle;
    m_nIniAccept:Integer;
    m_nCurAccept:Integer;
    m_nMinAccept:Integer;
    m_nAddAccept:Integer;
    m_vcAcceptEx:TList;
    m_fnOnClientConnect: TSocketNotifyEvent;
    m_fnOnClientDisconnect: TSocketNotifyEvent;
    m_fnOnClientRead: TSocketNotifyEvent;
    m_fnOnClientWrite: TSocketNotifyEvent;
    m_fnOnClientError: TSocketErrorEvent;
    m_fnAcceptEx: LPFN_ACCEPTEX;
    m_fnGetAcceptExSockaddrs: LPFN_GETACCEPTEXSOCKADDRS;
  protected
    function GetConnections(Index: Integer): TCustomWinSocket;
    procedure InitializeAcceptEx;
    procedure PostAcceptExPendingEvent;

    procedure CheckAcceptExPendingEvent;
    procedure ClientEvent(Sender: TObject; Socket: TCustomWinSocket;
      SocketEvent: TSocketEvent);
    procedure ClientConnect(Socket: TCustomWinSOcket); dynamic;
    procedure ClientDisconnect(Socket: TCustomWinSOcket); dynamic;
    procedure ClientRead(Socket: TCustomWinSocket); dynamic;
    procedure ClientWrite(Socket: TCustomWinSOcket); dynamic;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure Close; override;
    procedure OnAcceptEx(pBuffer:pTBuffer);
    procedure InitializeWinsock; override;
    procedure Event(Socket: TCustomWinSocket; SocketEvent: TSocketEvent); override;
    property Connection;
    property Connections[Index: Integer]: TCustomWinSocket read GetConnections;
    property OnClientConnect: TSocketNotifyEvent read m_fnOnClientConnect write m_fnOnClientConnect;
    property OnClientDisconnect: TSocketNotifyEvent read m_fnOnClientDisconnect write m_fnOnClientDisconnect;
    property OnClientRead: TSocketNotifyEvent read m_fnOnClientRead write m_fnOnClientRead;
    property OnClientWrite: TSocketNotifyEvent read m_fnOnClientWrite write m_fnOnClientWrite;
    property OnClientError: TSocketErrorEvent read m_fnOnClientError write m_fnOnClientError;
  end;

  TClientWinSocket = class(TCustomWinSocket)
  protected
    m_boConnError:Boolean;
    m_csConnSocket:TCustomWinSocket;
    m_fnOnConnect: TSocketNotifyEvent;
    m_fnOnDisconnect:TSocketNotifyEvent;
    m_fnOnRead: TSocketNotifyEvent;
    m_fnOnWrite: TSocketNotifyEvent;
    m_fnOnError: TSocketErrorEvent;
    m_fnConnectEx: LPFN_CONNECTEX;
  protected
    procedure ServerEvent(Sender: TObject; Socket: TCustomWinSocket;
      SocketEvent: TSocketEvent);
    procedure ServerConnect(Socket: TCustomWinSOcket); dynamic;
    procedure ServerDisconnect(Socket: TCustomWinSOcket); dynamic;
    procedure ServerRead(Socket: TCustomWinSocket); dynamic;
    procedure ServerWrite(Socket: TCustomWinSOcket); dynamic;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Close; override;
    procedure OnConnecting;
    procedure Event(Socket: TCustomWinSocket; SocketEvent: TSocketEvent); override;
    property Connected;
    property OnConnect: TSocketNotifyEvent read m_fnOnConnect write m_fnOnConnect;
    property OnDisconnect: TSocketNotifyEvent read m_fnOnDisconnect write m_fnOnDisconnect;
    property OnRead: TSocketNotifyEvent read m_fnOnRead write m_fnOnRead;
    property OnWrite: TSocketNotifyEvent read m_fnOnWrite write m_fnOnWrite;
    property OnError: TSocketErrorEvent read m_fnOnError write m_fnOnError;
  end;

  TAbstractSocket = class(TComponent)
  private
    m_szHost: string;
    m_wdPort: Integer;
    m_boNoDelay:Boolean;
    m_boActiveService:Boolean;
    m_csSocket:TCustomWinSocket;
  protected
    procedure DoActivate(Value: Boolean); virtual; abstract;
    procedure SetActive(Value: Boolean);
    procedure SetHost(Value: string);
    procedure SetPort(Value: Integer);
    procedure SetNoDelay(Value:Boolean);
    function  GateActive:Boolean;
    function  GetNoDelay:Boolean;
    property Active: Boolean read GateActive write SetActive;
    property Host: string read m_szHost write SetHost;
    property Port: Integer read m_wdPort write SetPort;
    property NoDelay: Boolean read GetNoDelay write SetNoDelay;
    property Socket: TCustomWinSocket read m_csSocket;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Close; virtual; abstract;
  end;

  TCustomSocket = class(TAbstractSocket)
  private
    function GetConnected:Boolean;
    procedure InitializeWinsock; virtual;
    function GetOnServerEvent(Index: Integer): TSocketNotifyEvent;
    procedure SetOnServerEvent(Index: Integer; Value: TSocketNotifyEvent);
    function GetError: TSocketErrorEvent;
    procedure SetError(Value: TSocketErrorEvent);
  protected
    property Connected: Boolean read GetConnected;
    property OnConnect: TSocketNotifyEvent index 2 read GetOnServerEvent write SetOnServerEvent;
    property OnDisconnect: TSocketNotifyEvent index 3 read GetOnServerEvent write SetOnServerEvent;
    property OnRead: TSocketNotifyEvent index 0 read GetOnServerEvent write SetOnServerEvent;
    property OnWrite: TSocketNotifyEvent index 1 read GetOnServerEvent write SetOnServerEvent;
    property OnError: TSocketErrorEvent read GetError write SetError;
  end;

  TCustomServerSocket = class(TCustomSocket)
  protected
    procedure DoActivate(Value: Boolean); override;
    procedure InitializeWinsock; override;
    function GetOnClientEvent(Index: Integer): TSocketNotifyEvent;
    procedure SetOnClientEvent(Index: Integer; Value: TSocketNotifyEvent);
    function GetOnClientError: TSocketErrorEvent;
    procedure SetOnClientError(Value: TSocketErrorEvent);
    property OnClientConnect: TSocketNotifyEvent index 2 read GetOnClientEvent write SetOnClientEvent;
    property OnClientDisconnect: TSocketNotifyEvent index 3 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientRead: TSocketNotifyEvent index 0 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientWrite: TSocketNotifyEvent index 1 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientError: TSocketErrorEvent read GetOnClientError write SetOnClientError;
  end;

  TServerSocket = class(TCustomServerSocket)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Close; override;
  published
    property Active;
    property Port;
    property Host;
    property Connected;
    property Socket;
    property NoDelay;
    property OnClientConnect;
    property OnClientDisconnect;
    property OnClientRead;
    property OnClientWrite;
    property OnClientError;
  end;

  TClientSocket = class(TCustomSocket)
  protected
    FInitialize:Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Close; override;
  protected
    procedure DoActivate(Value: Boolean); override;
  published
    property Active;
    property Port;
    property Host;
    property Socket;
    property NoDelay;
    property Connected;
    property OnConnect;
    property OnDisconnect;
    property OnRead;
    property OnWrite;
    property OnError;
  end;

  procedure Register;
  function OnMonitorThreadProc(Parameter: Pointer): Integer;

implementation

uses RTLConsts;

const
  strConnection = '$++$';

var
  g_hWaitEvent:THandle = 0;
  g_hBufferHeap:THandle = 0;
  g_boInitialize: Boolean = False;                                              //是否已初始化
  g_hCompletions: THandle = INVALID_HANDLE_VALUE;                               //完成端口句柄
  g_nUseSocketCount: Integer = 0;                                               //引用计数
  g_nMonitorThreadCount: Integer = 0;                                           //监听线程数量
  g_hThread:array[0..MAXTHREADSIZE -1] of THandle;
  g_vcFreeBufferList:TList;
  g_vcFreeSocketList:TList;
  g_csFreeBufferLock:TRTLCriticalSection;
  g_csFreeSocketLock: TRTLCriticalSection;
  g_csCriticalSection: TRTLCriticalSection;                                     //互斥对象

procedure Startup;
var
  ErrorCode: Integer;
  t_WSAData: TWSAData;
begin
  ErrorCode := WSAStartup($0202, t_WSAData);
  if ErrorCode <> 0 then
    raise ESocketError.CreateResFmt(@sWindowsSocketError,
      [SysErrorMessage(ErrorCode), ErrorCode, 'WSAStartup']);
end;

procedure Cleanup;
var
  ErrorCode: Integer;
begin
  ErrorCode := WSACleanup;
  if ErrorCode <> 0 then
    raise ESocketError.CreateResFmt(@sWindowsSocketError,
      [SysErrorMessage(ErrorCode), ErrorCode, 'WSACleanup']);
end;

function AllocateBuffer(Event:TSocketEvent): pTBuffer;
var
  pBuffer:pTBuffer;
begin
  EnterCriticalSection(g_csFreeBufferLock);
  try
    if g_vcFreeBufferList.Count > 0 then begin
      pBuffer := g_vcFreeBufferList.First;
      g_vcFreeBufferList.Delete(g_vcFreeBufferList.IndexOf(pBuffer));
    end else begin
      pBuffer := HeapAlloc(g_hBufferHeap, HEAP_ZERO_MEMORY, sizeof(TBuffer));
    end;
    pBuffer.Event := Event;
    pBuffer.dwSocket:= INVALID_SOCKET;
  finally
    LeaveCriticalSection(g_csFreeBufferLock);
  end;
  Result := pBuffer;
end;

procedure ReleaseBuffer(pBuffer: pTBuffer; boFree: Boolean= False);
begin
  if boFree then begin
    HeapFree(g_hBufferHeap, 0, pBuffer);
  end else begin
    //添加空闲列表的缓冲区
    EnterCriticalSection(g_csFreeBufferLock);
    try
      if pBuffer <> nil then begin
        if g_vcFreeBufferList.Count < DEFAULTMAXFREEBUFFRESIZE then begin
          FillChar(pBuffer^, SizeOf(TBuffer), 0);
          pBuffer.Event := seNone;
          g_vcFreeBufferList.Add(pBuffer);
        end else begin
          HeapFree(g_hBufferHeap, 0, pBuffer);
        end;
      end;
    finally
      LeaveCriticalSection(g_csFreeBufferLock);
    end;
  end;
end;

function InitializeSocket(Style:TSocketStyle):TCustomWinSocket;
var
  CSocket:TCustomWinSocket;
begin
  EnterCriticalSection(g_csFreeSocketLock);
  try
    if g_vcFreeSocketList.Count > 0 then begin
      CSocket := g_vcFreeSocketList.First;
      g_vcFreeSocketList.Delete(g_vcFreeSocketList.IndexOf(CSocket));
    end else begin
      CSocket := TCustomWinSocket.Create;
    end;
    CSocket.Style:= Style;
    CSocket.Socket:= INVALID_SOCKET;
  finally
    LeaveCriticalSection(g_csFreeSocketLock);
  end;
  Result := CSocket;
end;

procedure UnitializeSocket(Socket:TCustomWinSocket);
begin
  EnterCriticalSection(g_csFreeSocketLock);
  try
    if Socket <> nil then begin
      if g_vcFreeSocketList.Count < DEFAULTMAXFREESOCKETSIZE then begin
        if g_vcFreeSocketList.IndexOf(Socket) = -1 then
          g_vcFreeSocketList.Add(Socket);
      end;
    end;
  finally
    LeaveCriticalSection(g_csFreeSocketLock);
  end;
end;

//初始化网络引擎
procedure InitializeGThread;
var
  Index:Integer;
  hThread:THandle;
  Info:TSystemInfo;
  dwThreadId:LongWord;
begin
  EnterCriticalSection(g_csCriticalSection);
  InterlockedIncrement(g_nUseSocketCount);
  //初始化网络引擎
  if not g_boInitialize then begin
    g_boInitialize:= True;
    if g_hBufferHeap = 0 then
      g_hBufferHeap :=HeapCreate(1024* 8 * 1024 , 0, 0);
    g_hWaitEvent:= CreateEvent(nil, True, True, nil);
    g_hCompletions:= CreateIoCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 0);
    GetSystemInfo(Info);
    g_nMonitorThreadCount := 1;//Info.dwNumberOfProcessors * 2 + 2;
    //创建监听线程
    for Index := 0 to g_nMonitorThreadCount - 1 do begin
      ReSetEvent(g_hWaitEvent);
      hThread:= BeginThread(nil, 0, @OnMonitorThreadProc, @Index, 0, dwThreadId);
      SetThreadPriority(hThread, THREAD_PRIORITY_HIGHEST);
      g_hThread[Index]:= CreateEvent(nil, FALSE, FALSE, nil);
      CloseHandle(hThread);
      WaitForSingleObject(g_hWaitEvent, INFINITE);
    end;
  end;
  LeaveCriticalSection(g_csCriticalSection);
end;

procedure UnitializeGThread;
var
  i:Integer;
  hEvent:THandle;
  pBuffer:pTBuffer;
  CSocket:TCustomWinSocket;
begin
  EnterCriticalSection(g_csCriticalSection);
  InterlockedDecrement(g_nUseSocketCount);
  if g_boInitialize and (g_nUseSocketCount = 0) then begin
    Sleep(10);
    //通知线程退出
    for i := 0 to g_nMonitorThreadCount - 1 do begin
      PostQueuedCompletionStatus(g_hCompletions, $FFFFFFFF, 0, nil);
    end;
    i:= 0;
    hEvent:= g_hThread[i];
    while i < g_nMonitorThreadCount do begin
      //等待线程事件有信号
      WaitForSingleObject(hEvent, INFINITE);
      CloseHandle(g_hThread[i]);
      g_hThread[i]:= 0;
      InterlockedIncrement(i);
      hEvent:= g_hThread[i];
    end;

    //释放空闲数据列表
    EnterCriticalSection(g_csFreeBufferLock);
    for I := 0 to g_vcFreeBufferList.Count - 1 do begin
      pBuffer:= g_vcFreeBufferList.Items[i];
      HeapFree(g_hBufferHeap, 0, pBuffer);
    end;
    g_vcFreeBufferList.Clear;
    LeaveCriticalSection(g_csFreeBufferLock);
    EnterCriticalSection(g_csFreeSocketLock);
    for I := 0 to g_vcFreeSocketList.Count - 1 do begin
      CSocket:= g_vcFreeSocketList.Items[i];
      if CSocket <> nil then begin
        CSocket.Free;
      end;
    end;
    g_vcFreeSocketList.Clear;
    EnterCriticalSection(g_csFreeSocketLock);
    CloseHandle(g_hWaitEvent);
    HeapDestroy(g_hBufferHeap);
    g_boInitialize:= False;
  end;
  LeaveCriticalSection(g_csCriticalSection);
end;

procedure OnQueuedNormalComeBackStatus(Socket:TCustomWinSocket; pBuffer:pTBuffer;
  dwTrans:LongWord);
begin
  if (dwTrans <> $FFFFFFFF) and (pBuffer <> nil) then begin

    try
      case pBuffer.Event of
        seAccept:begin
          Socket.Lock;
          TServerWinSocket(Socket).OnAcceptEx(pBuffer);
          Socket.UnLock;
        end;
        seConnect:begin
          Socket.Lock;
          if dwTrans = 0 then begin
            Socket.SocketError;
            Socket.Event(Socket, pBuffer.Event);
            Socket.Close;
          end else begin
            Socket.Event(Socket, pBuffer.Event);
          end;
          Socket.UnLock;
        end;
        seRecv:begin
        //  Socket.Lock;
          if dwTrans = 0 then begin
            Socket.SocketError;
            Socket.Event(Socket, pBuffer.Event);
          end else begin
            pBuffer.dwRetnTrans:= dwTrans;
            Socket.UpdateData(pBuffer);
            Socket.Event(Socket, pBuffer.Event);
          end;
        //  Socket.UnLock;
        end;
        seSend:begin
        //  Socket.SendLock;
          //2016.04.23 返回大小大于零时返回已测试ok.
          if dwTrans >= pBuffer.dwSendTrans then begin
            Socket.UpdateSendData(pBuffer);
            Socket.Event(Socket, pBuffer.Event);
          end else begin
            if dwTrans = 0 then begin
              Socket.SocketError;
              Socket.Event(Socket, pBuffer.Event);
            end;
          end;
        //  Socket.SendUnlock;
        end;
      end;
    finally

    end;
  end;
  if dwTrans = 0 then begin
    if Socket.EmptyOutstandingEvent then begin
      //未决事件释放完通知退出消息
      Socket.Event(Socket, seDisconnect);
      //释放离线终端
      UnitializeSocket(Socket);
    end;
  end;
  ReleaseBuffer(pBuffer);
end;

procedure OnQueuedErrorsComeBackStatus(Socket:TCustomWinSocket; pBuffer:pTBuffer;
  dwTrans:LongWord);
begin
  if (Socket.Style = ssGSSocket) or (Socket.Style = ssGCSocket) then begin
    Socket.Lock;
    try
      pBuffer.dwRetnTrans:= dwTrans;
      Socket.SocketError;
      Socket.Event(Socket, pBuffer.Event);
    finally
      Socket.UnLock;
    end;
    if Socket.EmptyOutstandingEvent then begin
      //未决事件释放完通知退出消息
      Socket.Event(Socket, seDisconnect);
      //释放离线终端
      UnitializeSocket(Socket);
    end;
  end;
  ReleaseBuffer(pBuffer);
end;

function OnMonitorThreadProc(Parameter: Pointer): Integer;
var
  Index:Integer;
  dwTrans: LongWord;
  boNotTimeOut:Boolean;
  pBuffer: pTBuffer;
  CSocket: TCustomWinSocket;
begin
  Index:= Integer(Parameter^);
  ResetEvent(g_hThread[Index]);
  SetEvent(g_hWaitEvent);
  while True do begin
    {$IF CompilerVersion > 18.5}
    boNotTimeOut := GetQueuedCompletionStatus(g_hCompletions, dwTrans, ULONG_PTR(CSocket), POverlapped(pBuffer), INFINITE);       //INFINITE
    {$ELSE}
    boNotTimeOut := GetQueuedCompletionStatus(g_hCompletions, dwTrans, LongWord(CSocket), POverlapped(pBuffer), INFINITE);
    {$IFEND}
    //通知线程退出
    if ((dwTrans = $FFFFFFFF) and (CSocket = nil)) then begin
      break;
    end;
    if boNotTimeOut then begin
      //事件正常返回
      OnQueuedNormalComeBackStatus(CSocket, pBuffer, dwTrans);
    end else begin
      //事件异常返回
      OnQueuedErrorsComeBackStatus(CSocket, pBuffer, dwTrans);
    end;
  end;
  SetEvent(g_hThread[Index]);
  Result:= 0;
end;

constructor TCustomWinSocket.Create;
begin
  inherited Create;
  nIndex:= -1;
  m_stSocket:= INVALID_SOCKET;
  m_ssStyle:= ssUnknow;
  m_szHost:= '0.0.0.0';
  m_wdPort:= 0;
  m_DParent:= nil;
  m_boActive:= False;
  m_boConnected:= False;
  m_nSequencesNumber:= 0;
  m_nOutstandingSend:= 0;
  m_nOutstandingRecv:= 0;
  m_nCurSequencesNumber:= 0;
  m_fnOnErrorEvent:= nil;
  m_pRecvData:= nil;
  m_pSendData:= nil;
  m_boNoDelay:= False;
  m_boSendOver:= True;
  m_boSocketError:= False;
  m_vcSendList:= TList.Create;
  m_vcConnections:= TList.Create;
  InitializeCriticalSection(m_csCriticalSection);
  InitializeCriticalSection(m_csSendListSection);
  InitializeCriticalSection(m_csSendCriticalSection);
end;

procedure TCustomWinSocket.Close;
begin
  Lock;
  try
    shutdown(m_stSocket, SD_BOTH);
    closesocket(m_stSocket);
  finally
    UnLock;
  end;
end;

procedure TCustomWinSocket.Unitialize;
var
  I: Integer;
  pBuffer:pTBuffer;
begin
  nIndex:= -1;
  m_stSocket:= INVALID_SOCKET;
  m_szHost:= '0.0.0.0';
  m_wdPort:= 0;
  m_DParent:= nil;
  m_boActive:= False;
  m_boConnected:= False;
  m_nSequencesNumber:= 0;
  m_nOutstandingSend:= 0;
  m_nOutstandingRecv:= 0;
  m_nCurSequencesNumber:= 0;
  m_fnOnErrorEvent:= nil;
  m_pRecvData:= nil;
  m_pSendData:= nil;
  //释放发送列表
  for I := 0 to m_vcSendList.Count - 1 do begin
    pBuffer:= m_vcSendList.Items[i];
    ReleaseBuffer(pBuffer);
  end;
  m_vcSendList.Clear;
  m_boSocketError:= False;
end;

procedure TCustomWinSocket.Lock;
begin
  EnterCriticalSection(m_csCriticalSection);
end;

procedure TCustomWinSocket.UnLock;
begin
  LeaveCriticalSection(m_csCriticalSection);
end;

procedure TCustomWinSocket.SendLock;
begin
  EnterCriticalSection(m_csSendCriticalSection);
end;

procedure TCustomWinSocket.SendUnlock;
begin
  LeaveCriticalSection(m_csSendCriticalSection);
end;

procedure TCustomWinSocket.InitializeWinsock;
begin

end;

procedure TCustomWinSocket.AddCSocket(Socket:TCustomWinSocket);
begin
  m_vcConnections.Add(Socket);
  InterlockedIncrement(m_nConnection);
end;

procedure TCustomWinSocket.DelCSocket(Socket:TCustomWinSocket);
var
  nIndex:Integer;
begin
  try
    nIndex:= m_vcConnections.IndexOf(Socket);
    if nIndex <> -1 then begin
      m_vcConnections.Delete(nIndex);
      InterlockedDecrement(m_nConnection);
    end;
  finally
  end;
end;

function TCustomWinSocket.EmptyOutstandingEvent:Boolean;
begin
  Result:= False;
  if (m_nOutstandingRecv = 0) and (m_nOutstandingSend = 0) then begin
    Result:= True;
  end;
end;

procedure TCustomWinSocket.Event(Socket: TCustomWinSocket; SocketEvent: TSocketEvent);
var
  pBuffer:pTBuffer;
begin
  case SocketEvent of
    seConnect:begin
      if not m_boSocketError then begin
        m_boActive:= True;
        m_boConnected:= True;
        m_DParent.Event(Self, SocketEvent);
        pBuffer:= AllocateBuffer(seRecv);
        if not PostSocketWSAEvent(pBuffer) then begin
          ReleaseBuffer(pBuffer);
        end;
      end;
    end;
    seRecv: begin
      //递减未决消息计数
      InterlockedDecrement(m_nOutstandingRecv);
      if not m_boSocketError then begin
        //继续投递未决接收事件
        pBuffer:= AllocateBuffer(seRecv);
        if not PostSocketWSAEvent(pBuffer) then begin
          ReleaseBuffer(pBuffer);
        end;
        //未发生错误时发送通知
        m_DParent.Event(Self, SocketEvent);
      end;
    end;
    seSend: begin
      //递减未决消息计数
      InterlockedDecrement(m_nOutstandingSend);
      if not m_boSocketError then begin
        //未发生错误时发送通知
        m_DParent.Event(Self, SocketEvent);
        //继续投递未发送的列表
        SendDataList;
      end;
    end;
    seDisconnect: begin
      //检测未决消息计数
      if (m_nOutstandingRecv = 0) and (m_nOutstandingSend = 0) then begin
        //离线消息通知
        m_DParent.Event(Self, SocketEvent);
        //关闭套接字
        Close;
        //释放用户数据
        Unitialize;
      end;
    end;
  end;
end;

procedure TCustomWinSocket.Error(Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: LongWord);
begin
end;

function TCustomWinSocket.CheckSocketResult(ResultCode: Integer; const Op: string): Integer;
begin
  if ResultCode <> 0 then  begin
    Result := WSAGetLastError;
    if Result <> WSAEWOULDBLOCK then begin
      if ResultCode <> 0 then
        raise ESocketError.CreateResFmt(@sWindowsSocketError,
        [SysErrorMessage(Result), Result, Op]);
    end;
  end else Result := 0;
end;

function TCustomWinSocket.PostSocketWSAEvent(pBuffer:pTBuffer):Boolean;
var
  dwBytes: DWORD;
  dwFlags: DWORD;
  dwError: LongWord;
  FWBuf: WSABUF;
begin
  Result:= False;
  try
    dwBytes := 0;
    dwFlags := 0;
    FWBuf.buf := pBuffer.szData;

    if Connected then begin
      if pBuffer.Event = seRecv then begin
        //投递接收事件
        FWBuf.len := MAX_RECV_SIZE;
        if WSARecv(m_stSocket, @FWBuf, 1, dwBytes, dwFlags, @pBuffer.Overlapped, nil) <> NO_ERROR then begin
          dwError:= WSAGetLastError;
          if dwError <> WSA_IO_PENDING then begin
            Error(Self, eeRecv, dwError);
            Close;
          end else begin
            Result:= True;
            InterlockedIncrement(m_nOutstandingRecv);
          end;
        end else begin
          Result:= True;
          InterlockedIncrement(m_nOutstandingRecv);
        end;
      end else if pBuffer.Event = seSend then begin
        //投递发送事件
        FWBuf.len := pBuffer.dwSendTrans;
        if WSASend(m_stSocket, @FWBuf, 1, dwBytes, dwFlags, @pBuffer.Overlapped, nil) <> NO_ERROR then begin
          dwError:= WSAGetLastError();
          if dwError <> WSA_IO_PENDING then begin
            Error(Self, eeSend, dwError);
            Close;
          end else begin
            Result:= True;
            InterlockedIncrement(m_nOutstandingSend);
          end;
        end else begin
          Result:= True;
          InterlockedIncrement(m_nOutstandingSend);
        end;
      end;
    end;
  finally
  end;
end;

function TCustomWinSocket.GetCurrSendDataByCurSequenceNumber(nCurSequencesNumber:Integer):pTBuffer;
var
  nIndex:Integer;
  pBuffer:pTBuffer;
begin
  pBuffer:= nil;
  for nIndex := 0 to m_vcSendList.Count - 1 do begin
    pBuffer:= m_vcSendList.Items[nIndex];
    if pBuffer.dwSequenceNumber = LongWord(nCurSequencesNumber) then
      break;
    pBuffer:= nil;
  end;
  Result:= pBuffer;
end;

procedure TCustomWinSocket.SendDataList;
var
  pBuffer:pTBuffer;
begin
  m_boSendOver:= True;
  //检测发送当前发送的编号
  if m_pSendData.dwSequenceNumber = LongWord(m_nCurSequencesNumber) then begin
    //增加当前发送编号
    InterlockedIncrement(m_nCurSequencesNumber);
    //更新发送状态完成
    m_boSendOver:= True;
    if m_vcSendList.Count > 0 then begin
      //获取发送事件缓冲区
      pBuffer:= GetCurrSendDataByCurSequenceNumber(m_nCurSequencesNumber);
      if pBuffer <> nil then begin
        m_vcSendList.Delete(m_vcSendList.IndexOf(pBuffer));
        //计算发送长度
        if not PostSocketWSAEvent(pBuffer) then begin
          ReleaseBuffer(pBuffer);
        end else begin
          m_boSendOver:= False;
        end;
      end;
    end;
  end;
end;

function TCustomWinSocket.SendBufEx(var Buf; Count: Integer):Integer;
var
  ErrorCode: Integer;
begin
  try
    Result := 0;
    if not m_boConnected then Exit;
    Result := send(m_stSocket, Buf, Count, 0);
    if Result = SOCKET_ERROR then
    begin
      ErrorCode := WSAGetLastError;
      if (ErrorCode <> WSAEWOULDBLOCK) then
      begin
        Close;
        if ErrorCode <> 0 then
          raise ESocketError.CreateResFmt(@sWindowsSocketError,
            [SysErrorMessage(ErrorCode), ErrorCode, 'send']);
      end;
    end;
  finally
  end;
end;

procedure TCustomWinSocket.AddSendBuffList(Buf:PAnsiChar; Count:Integer);
var
  nIndex:Integer;
  pBuffer : pTBuffer;
  nPosition, nSendByte:Integer;
  nSendCount:Integer;
begin
  nPosition:= 0;
  nSendCount:= Trunc(Count / MAX_RECV_SIZE);
  for nIndex := 0 to nSendCount do begin
    if Count >= (nPosition + MAX_RECV_SIZE) then begin
      nSendByte:= MAX_RECV_SIZE;
    end else begin
      nSendByte:= Count - nPosition;
    end;
    //创建字符串流。
    pBuffer:= AllocateBuffer(seSend);
    Move(PAnsiChar(Buf + nPosition)^, pBuffer.szData, nSendByte);
    pBuffer.dwSendTrans:= nSendByte;
    pBuffer.dwSequenceNumber:= m_nSequencesNumber;
    //增加发送编号引用计数
    InterlockedIncrement(m_nSequencesNumber);
    inc(nPosition, nSendByte);
    //添加发送列表
    m_vcSendList.Add(pBuffer);
  end;
end;

function TCustomWinSocket.AsyncSendBuf(Buf:PAnsiChar; Count: Integer):Integer;
var
  pBuffer : pTBuffer;
begin
  if not m_boSendOver then begin
    //加入待发送队列
    AddSendBuffList(Buf, Count);
  end else begin
    //检测发送队列是否完成
    if m_vcSendList.Count = 0 then begin
      //更新发送完成状态
      m_boSendOver:= False;
      //加入待发送队列
      AddSendBuffList(Buf, Count);
      //获取第一条数据
      pBuffer:= m_vcSendList.First;
      //移除待发送数据
      m_vcSendList.Delete(m_vcSendList.IndexOf(pBuffer));
      //发送第一条数据
      PostSocketWSAEvent(pBuffer);
    end else begin
      AddSendBuffList(Buf, Count);
    end;
  end;
  Result:= 0;
end;

function TCustomWinSocket.SendBuf(Buf:PAnsiChar; Count: Integer; boAsyncSend:Boolean = True): Integer;
begin
  SendLock;
  if boAsyncSend then begin
    Result:= AsyncSendBuf(Buf, Count);
  end else begin
    Result:= SendBufEx(Buf, Count);
  end;
  SendUnLock;
end;

function TCustomWinSocket.SendText(S: string; boAsyncSend:Boolean = True): Integer;
begin
  SendLock;
  if not boAsyncSend then begin
    //同步发送
    Result := SendBufEx(Pointer(AnsiString(S))^, Length(AnsiString(S)));
  end else begin
    //异步发送
    Result := AsyncSendBuf(PAnsiChar(AnsiString(s)), Length(AnsiString(S)));
  end;
  SendUnLock;
end;

function TCustomWinSocket.ReceiveText:string;
begin
  Result:= string(m_pRecvData.szData);
end;

function TCustomWinSocket.ReceiceBuff:PAnsiChar;
begin
  Result:= m_pRecvData.szData;
end;

function TCustomWinSocket.ReceiveSize:Integer;
begin
  Result:= m_pRecvData.dwRetnTrans;
end;

procedure TCustomWinSocket.SocketError;
begin
  m_boSocketError:= True;
end;

procedure TCustomWinSocket.UpdateData(pBuffer:pTBuffer);
begin
  m_pRecvData:= pBuffer;
end;

procedure TCustomWinSocket.UpdateSendData(pBuffer:pTBuffer);
begin
  m_pSendData:= pBuffer;
end;

destructor TCustomWinSocket.Destroy;
begin
  m_vcSendList.Free;
  m_vcConnections.Free;
  DeleteCriticalSection(m_csCriticalSection);
  DeleteCriticalSection(m_csSendListSection);
  DeleteCriticalSection(m_csSendCriticalSection);
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
constructor TServerWinSocket.Create;
begin
  inherited Create;
  m_hAccept:= 0;
  m_boNoDelay:= True;
  m_nIniAccept:= 10;
  m_nCurAccept:= 0;
  m_nMinAccept:= 5;
  m_nAddAccept:= 10;
  m_ssStyle:= ssSWSocket;
  m_vcAcceptEx:= TList.Create;
end;

procedure TServerWinSocket.InitializeWinsock;
var
  InternetAddr: TSockAddrIn;
  dwBytes, dwSendSize: LongWord;
  dwFlag:Integer;
begin
  if m_boConnected then raise ESocketError.CreateRes(@sCannotListenOnOpen);
  m_stSocket:= WSASocket(AF_INET, SOCK_STREAM, IPPROTO_IP, nil, 0, WSA_FLAG_OVERLAPPED);
  if m_stSocket = INVALID_SOCKET then raise ESocketError.CreateRes(@sCannotCreateSocket);
  InternetAddr.sin_port := htons(m_wdPort);
  InternetAddr.sin_family := AF_INET;
  InternetAddr.sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(m_szHost)));
  CheckSocketResult(bind(m_stSocket, PSOCKADDR(@InternetAddr), SizeOf(InternetAddr)), 'bind');
  CheckSocketResult(uWinsock2.listen(m_stSocket, SOMAXCONN), 'listen');
  WSAIoctl(m_stSocket, SIO_GET_EXTENSION_FUNCTION_POINTER, @WSAID_ACCEPTEX, sizeof(WSAID_ACCEPTEX), @@m_fnAcceptEx, sizeof(Pointer), @dwBytes, nil, nil);
  if Assigned(m_fnAcceptEx) then begin
    WSAIoctl(m_stSocket, SIO_GET_EXTENSION_FUNCTION_POINTER, @WSAID_GETACCEPTEXSOCKADDRS, sizeof(WSAID_GETACCEPTEXSOCKADDRS), @@m_fnGetAcceptExSockaddrs, sizeof(Pointer), @dwBytes, nil, nil);
    if Assigned(m_fnGetAcceptExSockaddrs) then begin
      if CreateIoCompletionPort(m_stSocket, g_hCompletions, LongWord(Self), 0) = g_hCompletions then begin
        m_hAccept:= CreateEvent(nil, FALSE, FALSE, nil);
        if WSAEventSelect(m_stSocket, m_hAccept, FD_ACCEPT) <> SOCKET_ERROR then begin
          m_boConnected:= True;
          dwFlag:= 4;
          dwSendSize:= 0;
          if(getsockopt(m_stSocket, SOL_SOCKET, SO_SNDBUF, PAnsiChar(@dwSendSize), dwFlag) <> SOCKET_ERROR) then begin
            dwSendSize:= $FFFF;
            if setsockopt(m_stSocket, SOL_SOCKET, SO_SNDBUF, PAnsiChar(@dwSendSize), SizeOf(LongWord)) = 0 then begin
            end;
          end;
          InitializeAcceptEx;
        end;
      end;
    end;
  end;
end;

procedure TServerWinSocket.InitializeAcceptEx;
var
  nIndex:Integer;
begin
  //初始投递预链接用户
  for nIndex := 0 to m_nIniAccept - 1 do begin
    PostAcceptExPendingEvent;
  end;
end;

procedure TServerWinSocket.PostAcceptExPendingEvent;
var
  dwBytes: LongWord;
  pBuffer:pTBuffer;
begin
  //添加到链接未决列表
  if Assigned(m_fnAcceptEx) then begin
    pBuffer:= AllocateBuffer(seAccept);
    dwBytes:= 0;
    pBuffer.dwSocket:= WSASocket(AF_INET, SOCK_STREAM, IPPROTO_IP, nil, 0, WSA_FLAG_OVERLAPPED);;
    if not m_fnAcceptEx(m_stSocket, pBuffer.dwSocket,
      @pBuffer.szData, MAX_RECV_SIZE - ((SizeOf(sockaddr_in) + 16) * 2),
      SizeOf(sockaddr_in) + 16, SizeOf(sockaddr_in) + 16,
      dwBytes, @pBuffer.Overlapped) then begin
      if WSAGetLastError = WSA_IO_PENDING then begin
        m_vcAcceptEx.Add(pBuffer);
        //链接引用计数增加
        InterlockedIncrement(m_nCurAccept);
      end;
    end;
  end;
end;

procedure TServerWinSocket.OnAcceptEx(pBuffer:pTBuffer);
var
  Index:Integer;
  szAddr:string;
  wdPort:Word;
  nNoDelay, dwFlag:Integer;
  dwSendSize:LongWord;
  pLocalAddr, pRemoteAddr: PSOCKADDR;
  nLocalLens, nRemoteLens: Integer;
  CSocket:TCustomWinSocket;
begin
  if pBuffer <> nil then begin
    nLocalLens:= 0;
    nRemoteLens:= 0;
    pLocalAddr:= nil;
    pRemoteAddr:= nil;
    m_fnGetAcceptExSockaddrs(@pBuffer.szData, MAX_RECV_SIZE - ((sizeof(sockaddr_in) + 16) * 2),
    SizeOf(sockaddr_in) + 16, SizeOf(sockaddr_in) + 16, pLocalAddr,
    nLocalLens, pRemoteAddr, nRemoteLens);
    szAddr:= string(inet_ntoa(PSockAddrIn(pRemoteAddr).sin_addr));
    wdPort:= ntohs(PSockAddrIn(pRemoteAddr).sin_port);

    Index:= m_vcAcceptEx.IndexOf(pBuffer);
    if Index <> -1 then begin
      m_vcAcceptEx.Delete(Index);
    end;
    if (szAddr <> '') and (wdPort <> 0) then begin
      CSocket:= InitializeSocket(ssGSSocket);
      if Assigned(CSocket) then begin
        CSocket.Host:= szAddr;
        CSocket.Port:= wdPort;
        CSocket.nIndex:= nIndex;
        CSocket.Socket:= pBuffer.dwSocket;
        CSocket.Connected:= True;
        CSocket.Active:= True;
        CSocket.DParent:= Self;
        if m_boNoDelay then begin
          nNoDelay:= 1;
          if SetSockOpt(CSocket.Socket, IPPROTO_TCP, TCP_NODELAY, @nNoDelay, sizeof(Integer)) <> 0 then begin
            CSocket.Close;
            exit;
          end;
        end;
        dwFlag:= 4;
        dwSendSize:= 0;
        if(getsockopt(m_stSocket, SOL_SOCKET, SO_SNDBUF, PAnsiChar(@dwSendSize), dwFlag) <> SOCKET_ERROR) then begin
          dwSendSize:= $FFFF;
          if setsockopt(CSocket.Socket, SOL_SOCKET, SO_SNDBUF, PAnsiChar(@dwSendSize), SizeOf(LongWord)) = 0 then begin
            if CreateIoCompletionPort(CSocket.Socket, g_hCompletions, Cardinal(CSocket), 0) = g_hCompletions then begin
              //添加到在线列表
              AddCSocket(CSocket);
              InterlockedDecrement(m_nCurAccept);
              //检测预连接数量
              CheckAcceptExPendingEvent;
              //更新接收连接数据
              CSocket.UpdateData(pBuffer);
              //通知事件已完成
              CSocket.Event(CSocket, seConnect);
            end;
          end;
        end;
        //设置发送缓冲区大小
        dwSendSize:= MAX_RECV_SIZE;

      end;
    end;
  end;
end;

procedure TServerWinSocket.Event(Socket: TCustomWinSocket; SocketEvent: TSocketEvent);
begin
  case SocketEvent of
    seConnect:begin
      ClientEvent(Self, Socket, SocketEvent);
    end;
    seRecv:begin
      ClientEvent(Self, Socket, SocketEvent);
    end;
    seDisconnect:begin
      DelCSocket(Socket);
      ClientEvent(Self, Socket, SocketEvent);
    end;
  end;
end;

procedure TServerWinSocket.CheckAcceptExPendingEvent;
var
  nIndex:Integer;
begin
  if (m_nCurAccept < m_nMinAccept) and m_boConnected then begin
    for nIndex := 0 to m_nAddAccept do begin
      PostAcceptExPendingEvent;
    end;
  end;
end;

procedure TServerWinSocket.ClientEvent(Sender: TObject; Socket: TCustomWinSocket;
  SocketEvent: TSocketEvent);
begin
  case SocketEvent of
    seConnect: ClientConnect(Socket);
    seDisconnect: ClientDisconnect(Socket);
    seRecv: ClientRead(Socket);
    seSend: ClientWrite(Socket);
  end;
end;

procedure TServerWinSocket.ClientConnect(Socket: TCustomWinSocket);
begin
  if Assigned(m_fnOnClientConnect) then m_fnOnClientConnect(Self, Socket);
end;

procedure TServerWinSocket.ClientDisconnect(Socket: TCustomWinSocket);
begin
  if Assigned(m_fnOnClientDisconnect) then m_fnOnClientDisconnect(Self, Socket);
end;

procedure TServerWinSocket.ClientRead(Socket: TCustomWinSocket);
begin
  if Assigned(m_fnOnClientRead) then m_fnOnClientRead(Self, Socket);
end;

procedure TServerWinSocket.ClientWrite(Socket: TCustomWinSocket);
begin
  if Assigned(m_fnOnClientWrite) then m_fnOnClientWrite(Self, Socket);
end;


function TServerWinSocket.GetConnections(Index: Integer): TCustomWinSocket;
begin
  Result:= nil;
  if (Index >= 0) and (Index < m_vcConnections.Count) then
    Result := m_vcConnections[Index];
end;

procedure TServerWinSocket.Close;
var
  I: Integer;
  pBuffer:pTBuffer;
  CSocket:TCustomWinSocket;
begin
  Lock;
  try
    shutdown(m_stSocket, SD_BOTH);
    closesocket(m_stSocket);
    m_boConnected:= False;
    m_boActive:= False;
    //释放连接列表
    for I := 0 to m_vcAcceptEx.Count - 1 do begin
      pBuffer:= pTBuffer(m_vcAcceptEx.Items[i]);
      if pBuffer.dwSocket <> INVALID_SOCKET then begin
        shutdown(pBuffer.dwSocket, SD_BOTH);
        closesocket(pBuffer.dwSocket);
      end;
    end;
    m_vcAcceptEx.Clear;

    //释放在线列表
    for I := 0 to m_vcConnections.Count - 1 do begin
      CSocket:= TCustomWinSocket(m_vcConnections.Items[i]);
      if CSocket.Connected then begin
        CSocket.Close;
      end;
    end;
    m_vcConnections.Clear;
  finally
    UnLock;
  end;
end;

destructor TServerWinSocket.Destroy;
begin
  m_vcAcceptEx.Free;
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
constructor TClientWinSocket.Create;
begin
  inherited Create;
  m_csConnSocket:= nil;
  m_ssStyle:= ssGCSocket;
  m_boConnError:= True;
  m_fnConnectEx:= nil;
  m_fnOnConnect:= nil;
  m_boNoDelay:= False;
end;

procedure TClientWinSocket.Event(Socket: TCustomWinSocket; SocketEvent: TSocketEvent);
begin
  case SocketEvent of
    seConnect:begin
      AddCSocket(Socket);
      m_boConnError:= False;
      m_csConnSocket:= nil;
      ServerEvent(Self, Socket, SocketEvent);
    end;
    seRecv:begin
      ServerEvent(Self, Socket, SocketEvent);
    end;
    seDisconnect:begin
      DelCSocket(Socket);
      ServerEvent(Self, Socket, SocketEvent);
    end;
  end;
end;

procedure TClientWinSocket.OnConnecting;
var
  pBuffer:pTBuffer;
  dwBytes: LongWord;
  nNoDelay:Integer;
  dwSendSize:LongWord;
  InternetAddr, LocalAddr: SOCKADDR_IN;
begin
  Lock;
  if (Host <> '') and (Port <> 0) and (not m_boConnected) then begin
    pBuffer:= AllocateBuffer(seConnect);
    pBuffer.dwSocket:= WSASocket(AF_INET, SOCK_STREAM, IPPROTO_IP, nil, 0, WSA_FLAG_OVERLAPPED);
    WSAIoctl(pBuffer.dwSocket, SIO_GET_EXTENSION_FUNCTION_POINTER, @WSAID_CONNECTEX, sizeof(WSAID_CONNECTEX), @@m_fnConnectEx, sizeof(Pointer), @dwBytes, nil, nil);
    if Assigned(m_fnConnectEx) then begin
      m_ssStyle:= ssCWSocket;
      LocalAddr.sin_port := htons(0);
      LocalAddr.sin_family := AF_INET;
      LocalAddr.sin_addr.S_addr := htonl(INADDR_ANY);
      CheckSocketResult(bind(pBuffer.dwSocket, PSOCKADDR(@LocalAddr), SizeOf(LocalAddr)), 'bind');
      InternetAddr.sin_port := htons(Port);
      InternetAddr.sin_family := AF_INET;
      InternetAddr.sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Host)));
      m_stSocket:= pBuffer.dwSocket;
      dwSendSize:= $FFFF;
      if setsockopt(m_stSocket, SOL_SOCKET, SO_RCVBUF, PAnsiChar(@dwSendSize), SizeOf(LongWord)) = 0 then begin
        Host:= m_szHost;
        Port:= m_wdPort;
        m_boSocketError:= False;
        m_ssStyle:= ssGCSocket;
        m_pRecvData:= nil;

        m_csConnSocket:= InitializeSocket(ssGCSocket);
        m_csConnSocket.Host:= Host;
        m_csConnSocket.Port:= Port;
        m_csConnSocket.nIndex:= nIndex;
        m_csConnSocket.Socket:= pBuffer.dwSocket;
        m_csConnSocket.Connected:= True;
        m_csConnSocket.Active:= True;
        m_csConnSocket.DParent:= Self;
        Move(PAnsiChar(AnsiString(strConnection))^, pBuffer.szData, Length(AnsiString(strConnection)));
        if CreateIoCompletionPort(pBuffer.dwSocket, g_hCompletions, LongWord(m_csConnSocket), 0) = g_hCompletions then begin
          if not m_fnConnectEx(pBuffer.dwSocket, @InternetAddr, SizeOf(SOCKADDR_IN), @pBuffer.szData, Length(AnsiString(strConnection)), dwBytes, @pBuffer.Overlapped) then begin
            if WSAGetLastError <> ERROR_IO_PENDING then begin
              closesocket(pBuffer.dwSocket);
              m_fnConnectEx:=nil;
            end else begin
              if m_boNoDelay then begin
                      nNoDelay:= 1;
                    if SetSockOpt(pBuffer.dwSocket, IPPROTO_TCP, TCP_NODELAY, @nNoDelay, sizeof(Integer)) <> 0 then begin
                      exit;
                    end;
                  end;
            end;
          end;
          m_fnConnectEx:=nil;
        end;
      end;
    end;
  end;
  UnLock;
end;

procedure TClientWinSocket.ServerConnect(Socket: TCustomWinSocket);
begin
  if Assigned(m_fnOnConnect) then
    m_fnOnConnect(Self, Socket);
end;

procedure TClientWinSocket.ServerDisconnect(Socket: TCustomWinSocket);
begin
  if Assigned(m_fnOnDisconnect) then m_fnOnDisconnect(Self, Socket);
end;

procedure TClientWinSocket.ServerRead(Socket: TCustomWinSocket);
begin
  if Assigned(m_fnOnRead) then
    m_fnOnRead(Self, Socket);
end;

procedure TClientWinSocket.ServerWrite(Socket: TCustomWinSocket);
begin
  if Assigned(m_fnOnWrite) then m_fnOnWrite(Self, Socket);
end;

procedure TClientWinSocket.ServerEvent(Sender: TObject; Socket: TCustomWinSocket;
  SocketEvent: TSocketEvent);
begin
  case SocketEvent of
    seConnect: ServerConnect(Socket);
    seDisconnect: ServerDisconnect(Socket);
    seRecv: ServerRead(Socket);
    seSend: ServerWrite(Socket);
  end;
end;

procedure TClientWinSocket.Close;
var
  i:Integer;
  CSocket:TCustomWinSocket;
begin
  Lock;
  m_boConnError:= True;
  //释放在线列表
  for I := 0 to m_vcConnections.Count - 1 do begin
    CSocket:= TCustomWinSocket(m_vcConnections.Items[i]);
    if CSocket.Connected then begin
      CSocket.Close;
    end;
  end;
  m_vcConnections.Clear;
  UnLock;
end;

destructor TClientWinSocket.Destroy;
begin
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
constructor TAbstractSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_szHost:= '0.0.0.0';
  m_wdPort:= 0;
  m_csSocket:= nil;
end;

procedure TAbstractSocket.SetHost(Value: string);
begin
  if CompareText(Value, m_szHost) <> 0 then begin
    if not (csLoading in ComponentState) and m_csSocket.Active then
      raise ESocketError.CreateRes(@sCantChangeWhileActive);
    m_szHost := Value;
    m_csSocket.Host:= m_szHost;
  end;
end;

procedure TAbstractSocket.SetPort(Value: Integer);
begin
  if m_wdPort <> Value then begin
    if not (csLoading in ComponentState) and m_csSocket.Active then
      raise ESocketError.CreateRes(@sCantChangeWhileActive);
    m_wdPort := Value;
    m_csSocket.Port:= m_wdPort;
  end;
end;

procedure TAbstractSocket.SetNoDelay(Value:Boolean);
begin
  if m_boNoDelay <> Value then begin
    if not (csLoading in ComponentState) and m_csSocket.Active then
      raise ESocketError.CreateRes(@sCantChangeWhileActive);
    m_boNoDelay:= Value;
    m_csSocket.NoDelay:= m_boNoDelay;
  end;
end;

procedure TAbstractSocket.SetActive(Value: Boolean);
begin
  DoActivate(Value);
  m_csSocket.Active := Value;
end;

function TAbstractSocket.GateActive:Boolean;
begin
  Result:= m_csSocket.Active;
end;

function TAbstractSocket.GetNoDelay:Boolean;
begin
  Result:= m_csSocket.Nodelay;
end;

destructor TAbstractSocket.Destroy;
begin
  if m_boActiveService then
    UnitializeGThread;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TCustomSocket.GetConnected:Boolean;
begin
  Result:= False;
  if Assigned(m_csSocket) then
    Result:= m_csSocket.Connected;
end;

procedure TCustomSocket.InitializeWinsock;
begin
  TClientWinSocket(m_csSocket).OnConnecting;
end;

procedure TCustomSocket.SetOnServerEvent(Index: Integer; Value: TSocketNotifyEvent);
begin
  case Index of
    0: TClientWinSocket(m_csSocket).OnRead := Value;
    1: TClientWinSocket(m_csSocket).OnWrite := Value;
    2: TClientWinSocket(m_csSocket).OnConnect := Value;
    3: TClientWinSocket(m_csSocket).OnDisconnect := Value;
  end;
end;

function TCustomSocket.GetOnServerEvent(Index: Integer): TSocketNotifyEvent;
begin
  case Index of
    0: Result := TClientWinSocket(m_csSocket).OnRead;
    1: Result := TClientWinSocket(m_csSocket).OnWrite;
    2: Result := TClientWinSocket(m_csSocket).OnConnect;
    3: Result := TClientWinSocket(m_csSocket).OnDisconnect;
  end;
end;

function TCustomSocket.GetError: TSocketErrorEvent;
begin
  Result := TClientWinSocket(m_csSocket).OnError;
end;

procedure TCustomSocket.SetError(Value: TSocketErrorEvent);
begin
  TClientWinSocket(m_csSocket).OnError:= Value;
end;
{------------------------------------------------------------------------------}
procedure TCustomServerSocket.DoActivate(Value: Boolean);
var
  nIndex, nConnection:Integer;
  CSocket: TCustomWinSocket;
begin
  if (Value <> m_csSocket.Connected) and not (csDesigning in ComponentState) then begin
    if m_csSocket.Connected then begin
      //关闭现有的网络连接服务
      nConnection:= TServerWinSocket(m_csSocket).Connection;
      for nIndex := 0 to nConnection - 1 do begin
        CSocket:= TServerWinSocket(m_csSocket).Connections[nIndex];
        if CSocket.Connected then
          CSocket.Close;
      end;
    end else begin
      //初始线程服务
      InitializeGThread;
      //初始网络服务
      InitializeWinsock;
      m_boActiveService:= True;
    end;
  end;
end;

procedure TCustomServerSocket.InitializeWinsock;
begin
  TServerWinSocket(m_csSocket).InitializeWinsock;
end;

function TCustomServerSocket.GetOnClientEvent(Index: Integer): TSocketNotifyEvent;
begin
  case Index of
    0: Result := TServerWinSocket(m_csSocket).OnClientRead;
    1: Result := TServerWinSocket(m_csSocket).OnClientWrite;
    2: Result := TServerWinSocket(m_csSocket).OnClientConnect;
    3: Result := TServerWinSocket(m_csSocket).OnClientDisconnect;
  end;
end;

procedure TCustomServerSocket.SetOnClientEvent(Index: Integer;
  Value: TSocketNotifyEvent);
begin
  case Index of
    0: TServerWinSocket(m_csSocket).OnClientRead := Value;
    1: TServerWinSocket(m_csSocket).OnClientWrite := Value;
    2: TServerWinSocket(m_csSocket).OnClientConnect := Value;
    3: TServerWinSocket(m_csSocket).OnClientDisconnect := Value;
  end;
end;

function TCustomServerSocket.GetOnClientError: TSocketErrorEvent;
begin
  Result := TServerWinSocket(m_csSocket).OnClientError;
end;

procedure TCustomServerSocket.SetOnClientError(Value: TSocketErrorEvent);
begin
  TServerWinSocket(m_csSocket).OnClientError := Value;
end;
{------------------------------------------------------------------------------}
constructor TServerSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_csSocket:= TServerWinSocket.Create;
end;

procedure TServerSocket.close;
begin
  TServerWinSocket(m_csSocket).Close;
end;

destructor TServerSocket.Destroy;
begin
  m_csSocket.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
constructor TClientSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInitialize:= False;
  m_csSocket:= TClientWinSocket.Create
end;

procedure TClientSocket.DoActivate(Value: Boolean);
begin
  if (Value <> m_csSocket.Connected) and not (csDesigning in ComponentState) then begin
    if m_csSocket.Connected then begin
      //关闭现有的网络连接服务
      m_csSocket.Close;
    end else begin
      //初始线程服务
      InitializeGThread;
      //初始网络服务
      m_csSocket.Host:= m_szHost;
      m_csSocket.Port:= m_wdPort;
      InitializeWinsock;
      m_boActiveService:= True;
    end;
  end;
  EnterCriticalSection(g_csCriticalSection);
  if not Value then begin
    if m_boActiveService then begin
      InterlockedDecrement(g_nUseSocketCount);
      m_boActiveService:= False;
    end;
  end;
  LeaveCriticalSection(g_csCriticalSection);
end;

procedure TClientSocket.Close;
begin
  TClientWinSocket(m_csSocket).Close;
end;

destructor TClientSocket.Destroy;
begin
  if m_boActiveService then begin
    UnitializeSocket(m_csSocket);
  end else begin
    m_csSocket.Free;
  end;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('GSocket', [TServerSocket, TClientSocket]);
end;

initialization
begin
  g_vcFreeBufferList:= TList.Create;
  g_vcFreeSocketList:= TList.Create;
  InitializeCriticalSection(g_csFreeBufferLock);
  InitializeCriticalSection(g_csFreeSocketLock);
  InitializeCriticalSection(g_csCriticalSection);
end;

finalization
begin
  g_vcFreeBufferList.Free;
  g_vcFreeSocketList.Free;
  DeleteCriticalSection(g_csFreeBufferLock);
  DeleteCriticalSection(g_csFreeSocketLock);
  DeleteCriticalSection(g_csCriticalSection);
end;



end.
