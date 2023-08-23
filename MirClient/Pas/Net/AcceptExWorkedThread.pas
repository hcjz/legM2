unit AcceptExWorkedThread;

interface

uses
  Windows, SysUtils, WinSock2, SHSocket, ThreadPool, MemPool,
  IOCPTypeDef, SendQueue, ClientThread, FixedMemoryPool;

const
  LOGIN_BUFFER_LEN          = 128;
  ACCEPTEX_POST_COUNT       = 128;      //һ��ACCEPTEX����Ŀ
  RECV_BUFFER_LEN           = 32 * 1024; //���ջ������Ĵ�С      //0401
  RECV_PACKET_LEN           = 04 * 1024; //ÿ��Ͷ�ݵĽ��ջ�������С
  TEMP_ENCODE_LEN           = 32 * 1024;

type
  TIOCPWriter = class;
  TIOCPReader = class;
  TUserManager = class;

  PServerInfo = ^_tagServerInfo;
  _tagServerInfo = record
    Socket: TSocket;
    Client: TClientThread;
    Port: Integer;
    Def: Integer;
  end;
  TServerInfo = _tagServerInfo;

  //��½���ݽṹ
  PLoginObj = ^_tagLoginObj;
  _tagLoginObj = record
    CommObj: TIOCPCommObj;
    Buffer: array[0..LOGIN_BUFFER_LEN + 63] of Char;
  end;
  TLoginObj = _tagLoginObj;

  PRecvObj = ^_tagRecvObj;
  _tagRecvObj = record
    CommObj: TIOCPCommObj;
    UserData: TObject;
    RecvPos: DWORD;                     //���յ������ݳ���
    Buffer: array[0..RECV_BUFFER_LEN + 63] of Char;
  end;
  TRecvObj = _tagRecvObj;

  PUserOBJ = ^_tagUserObj;
  _tagUserObj = record
    Data: TObject;
    GameServ: TClientThread;
    _SendObj: PIOCPCommObj;
    _RecvObj: PIOCPCommObj;
    Reader: TIOCPReader;
    Writer: TIOCPWriter;
    UserManager: TUserManager;
    UID: Cardinal;
    IPLen: Integer;
    IP: array[0..15] of Char;           //array[0..119] of Char;          //��������ָ-->128�ֽ�   //0401
    Port: Integer;
  end;
  TUserObj = _tagUserObj;

  TOnUserEnter = procedure(Sender: TUserManager; const UserOBJ: PUserOBJ) of object;
  TOnUserLeave = procedure(Sender: TUserManager; const UserOBJ: PUserOBJ) of object;

  //�������е��û��ṹ
  TUserManager = class
  private
    FUserList: TFixedMemoryPool;
    FOnUserLeave: TOnUserLeave;
    FOnUserEnter: TOnUserEnter;
    FReader: TIOCPReader;
    FWriter: TIOCPWriter;
  protected
    procedure _DeleteUser(const UserOBJ: PUserOBJ);
  public
    property OnUserLeave: TOnUserLeave read FOnUserLeave write FOnUserLeave;
    property OnUserEnter: TOnUserEnter read FOnUserEnter write FOnUserEnter;
    function AddUser(const SendObj: PIOCPCommObj; const CIP: PChar; const CPort: Integer): PUserOBJ;
    procedure DeleteUser(const UserOBJ: PUserOBJ);
    function IsAvailayUser(const UserOBJ: PUserOBJ): Boolean;

    constructor Create(MaxUser: Integer);
    destructor Destroy; override;
  end;

  TOnCompPortEvent = procedure(Sender: TObject; CompPort: THANDLE) of object;
  EAcceptExSocket = class(Exception);

  TIOCPAccepter = class
  private
    FAcceptExFunc: LPFN_ACCEPTEX;
    FGetAcceptExSockaddrsFunc: LPFN_GETACCEPTEXSOCKADDRS;
    FUserManager: TUserManager;
    FRecvSocket: TIOCPReader;
    FSendSocket: TIOCPWriter;
    FRecvLen: Integer;
    FThreadCount: Integer;
    FCompPort: THANDLE;
    FAddrAddLen: DWORD;
    FMaxLoginUser: Integer;
    FAcceptExPool: TMemPool;
    FOnInitCompPortFinished: TOnCompPortEvent;
    FOnCleanupCompPortEnd: TOnCompPortEvent;
    FActive: BOOL;
    FServerCount: Integer;
    FServerInfoList: array[0..MAX_SERVER_COUNT - 1] of TServerInfo;
    procedure InitAcceptEx(Port: Integer; Index: Integer);
    procedure cleanupAcceptEx(Socket: TSocket);
    procedure SetThreadCount(const Value: Integer);
    procedure SetRecvSocket(const Value: TIOCPReader);
    procedure SetSendSocket(const Value: TIOCPWriter);
    procedure SetActive(const Value: BOOL);
    function GetServerInfo: PServerInfo;
    function GetInUseBlock: Integer;
    function GetMaxInUseBlock: Integer;
  protected
    procedure HandleException(const PTRMsgError: string);
  public
    property UserManager: TUserManager read FUserManager;
    property ServerInfo: PServerInfo read GetServerInfo;
    property ServerCount: Integer read FServerCount;
    property InUseBlock: Integer read GetInUseBlock;
    property MaxInUseBlock: Integer read GetMaxInUseBlock;
    property ThreadCount: Integer read FThreadCount write SetThreadCount;
    property SendSocket: TIOCPWriter read FSendSocket write SetSendSocket;
    property RecvSocket: TIOCPReader read FRecvSocket write SetRecvSocket;

    property OnInitCompPortFinished: TOnCompPortEvent read FOnInitCompPortFinished write FOnInitCompPortFinished;
    property OnCleanupComPortEnd: TOnCompPortEvent read FOnCleanupCompPortEnd write FOnCleanupCompPortEnd;
    property CompPort: THANDLE read FCompPort;
    procedure PostAcceptEx(ListenSocket: TSocket; LoginObj: PLoginObj = nil);
    procedure HandleAcceptFinished(const IOCPData: PIOCPCommObj; IOKey: DWORD);
    procedure FreeAcceptEx(const IOCPData: PIOCPCommObj; const ListenSocket: TSocket);
    //��ѯ���е�SOCKET�Ƿ���Ч
    procedure PollAcceptExSocket(var WakeTime: DWORD);
    property Active: BOOL read FActive write SetActive;
    procedure CloseWorkerThread;
    procedure InitServer(Port: Integer; Client: TClientThread);
    constructor Create(MaxLogin: Integer; UserManager: TUserManager);
    destructor Destroy; override;
  end;

  TOnReadEvent = procedure(UserData: TObject; const Buffer: PChar; var BufLen: DWORD; var Succeed: BOOL) of object;

  EIOCPReader = class(Exception);

  TIOCPReader = class
  private
    FUserManager: TUserManager;
    FSendSocket: TIOCPWriter;
    FRecvPool: TMemPool;
    FMaxUser: Integer;
    FOnReadEvent: TOnReadEvent;         //��һ�����Ľ��ճ���
    procedure InitRecvSocket;
    procedure CleanupRecvSocket;
    function GetCurrentUser: Integer;
  public
    property CurrentUser: Integer read GetCurrentUser;
    property OnReadEvent: TOnReadEvent read FOnReadEvent write FOnReadEvent;
    function AddLoginUser(const IOCPData: PLoginObj; var ReaderOBJ: PRecvObj): Boolean; //���IOLen=0 ���½����뵽�����ݿ��������������Ҫ�������ܵ�½����
    procedure DeleteLoginUser(IOCPData: PIOCPCommObj); //�ڹ���������SOCKET�����������ʱ��ɾ�����׽���
    function PostIORecv(IOCPData: PIOCPCommObj): Boolean;
    procedure PollRecvSocket(var WakeTime: DWORD); //��ѯ���е�SOCKET�Ƿ���Ч
    function ReadDone(const IOCPData: PIOCPCommObj; const IOLen: DWORD): BOOL;
    function HandleReadData(const IOCPData: PIOCPCommObj; const IOLen: DWORD): BOOL;
    constructor Create(MaxUser: Integer; SendSocket: TIOCPWriter; UserManager: TUserManager);
    destructor Destroy; override;
  end;

  TOnBroadCastEvent = procedure(UserOBJ: PUserOBJ; WParam, LParam: DWORD) of object;

  EIOCPWriter = class(Exception);

  TIOCPWriter = class
  private
    FSendQueue: TSendQueue;
    FUserManager: TUserManager;
    FMaxUser: Integer;
    FOnBroadCastEvent: TOnBroadCastEvent;
    procedure InitSendSocket;
    procedure cleanupSendSocket;
    function GetCurrentUser: Integer;
  protected
    function HandleSendFinished(IOCPData: PIOCPCommObj): Boolean;
    procedure DeleteLoginUser(IOCPData: PIOCPCommObj);
    function AddLoginUser(IOCPData: PIOCPCommObj; var WriterOBJ: PIOCPCommObj): Boolean;
  public
    //���Ͷ���
    property SendQueue: TSendQueue read FSendQueue;
    property CurrentUser: Integer read GetCurrentUser;
    property OnBroadcastEvent: TOnBroadCastEvent read FOnBroadCastEvent write FOnBroadCastEvent;
    procedure PostAllUserSend(const Buffer: PChar; const BufLen: DWORD);
    procedure BroadUserMsg(WParam, LParam: Integer; OnBroadcastEvent: TOnBroadCastEvent);
    function SendData(const WriterOBJ: PIOCPCommObj; const Buffer: PChar; const size: UINT): Boolean;
    procedure DeleteSocket(const WriterOBJ: PIOCPCommObj);
    //��ѯ���е�SOCKET�Ƿ���Ч
    procedure PollSendSocket(var WakeTime: DWORD);
    constructor Create(MaxUser: Integer; UserManager: TUserManager);
    destructor Destroy; override;
  end;

  TAcceptExWorkedThread = class(TBaseThread)
  private
    FIOCPPort: THANDLE;
    FSendSocket: TIOCPWriter;
    FRecvSocket: TIOCPReader;
    FAcceptExSocket: TIOCPAccepter;
    FABuffer: PChar;
    FBBuffer: PChar;
    FThread_A_Buffer: array[0..TEMP_ENCODE_LEN + 127] of Char; //����CPU������
    FThread_B_Buffer: array[0..TEMP_ENCODE_LEN + 127] of Char;
    procedure HandleExcept(const IOCPData: PIOCPCommObj; const Str: string);
  protected
    procedure Run(); override;
    function HandleRecvEvent(const IOCPData: PIOCPCommObj; const IOLength: DWORD): Boolean;
    function HandleSendEvent(const IOCPData: PIOCPCommObj; const IOLength: DWORD): Boolean;
    procedure HandleAllError(const IOCPData: PIOCPCommObj; const IOKey: DWORD);
  public
    constructor Create(SendSocket: TIOCPWriter; RecvSocket: TIOCPReader; AcceptExSocket: TIOCPAccepter; IOCPPort: THANDLE);
    destructor Destroy; override;
  end;

implementation

uses
  Messages, main, ClientData;

{ TAcceptExWorkedThread }

constructor TAcceptExWorkedThread.Create(
  SendSocket: TIOCPWriter;
  RecvSocket: TIOCPReader;
  AcceptExSocket: TIOCPAccepter;
  IOCPPort: THANDLE);
begin
  FSendSocket := SendSocket;
  FRecvSocket := RecvSocket;
  FAcceptExSocket := AcceptExSocket;
  FIOCPPort := IOCPPort;
  inherited Create(False);
  FThreadType := 'Handle Game User';
  FABuffer := @FThread_A_Buffer[0];     //����64���ֽڷ�ֹ��������
  FBBuffer := @FThread_B_Buffer[0];     //����64���ֽڷ�ֹ��������
  Start;
end;

destructor TAcceptExWorkedThread.Destroy;
begin
  inherited Destroy;
end;

procedure TAcceptExWorkedThread.HandleAllError(const IOCPData: PIOCPCommObj; const IOKey: DWORD);
var
  ServerOBJ                 : PServerInfo;
begin
  case IOCPData.WorkType of
    SOCKET_ACCEPT: begin
        ServerOBJ := PServerInfo(IOKey);
        FAcceptExSocket.FreeAcceptEx(IOCPData, ServerOBJ.Socket);
      end;
    SOCKET_READ: FSendSocket.FUserManager.DeleteUser(IOCPData.AddObject);
    SOCKET_SEND: FSendSocket.FUserManager.DeleteUser(IOCPData.AddObject);
  end;
end;

procedure TAcceptExWorkedThread.HandleExcept(const IOCPData: PIOCPCommObj; const Str: string);
var
  PTRUser                   : PUserOBJ;
  StrExcept                 : string;
  PSendData                 : PSendQueueNode;
begin
  //����StrExcept��ʼΪnil
  if IOCPData <> nil then begin
    PTRUser := IOCPData.AddObject;
    case IOCPData.WorkType of
      SOCKET_READ: begin
          StrExcept := Format('IOData:RecvPos:%d,IOKey:%d', [PRecvObj(IOCPData).RecvPos, IOCPData.PTRIOKey.Internal]);
          if PTRUser <> nil then
            StrExcept := StrExcept + #13#10 + Format('�������ݷ����쳣�����û�IP:%s,Port:%d', [PTRUser.IP, PTRUser.Port]);
        end;
      SOCKET_SEND: begin
          PSendData := PSendQueueNode(IOCPData);
          StrExcept := Format('IOData:BufLPos:%d,BufRPos:%d,LeftLen:%d,RightLen:%d,SendLen:%d',
            [PSendData.BufLPos,
            PSendData.BufRPos,
              PSendData.LeftLen,
              PSendData.RightLen,
              PSendData.SendLen]);

          if PTRUser <> nil then
            StrExcept := StrExcept + #13#10 + (Format('д�����ݷ����쳣,���û�IP:%s,Port:%d', [PTRUser.IP, PTRUser.Port]));
        end;
    end;
  end;

  MainOutMessage(StrExcept + #13#10 + Str, 5);
end;

function TAcceptExWorkedThread.HandleRecvEvent(const IOCPData: PIOCPCommObj; const IOLength: DWORD): Boolean;
begin
  IOCPData.ABuffer := FABuffer;
  IOCPData.BBuffer := FBBuffer;
  try
    Result := FRecvSocket.HandleReadData(IOCPData, IOLength);
  except
    on E: Exception do begin
      Result := False;
      HandleExcept(IOCPData, Format('Except Message%s', [E.Message]));
    end;
  end;
end;

function TAcceptExWorkedThread.HandleSendEvent(const IOCPData: PIOCPCommObj; const IOLength: DWORD): Boolean;
begin
  if IOCPData.WBuf.Len = IOLength then
    Result := FSendSocket.HandleSendFinished(IOCPData)
  else begin
    Inc(IOCPData.WBuf.Buf, IOLength);
    Dec(IOCPData.WBuf.Len, IOLength);
    Result := IOCPTypeDef.PostIOCPSend(IOCPData);
  end;
end;

procedure TAcceptExWorkedThread.Run;
var
  IOCPData                  : PIOCPCommObj;
  IOCPKey, dwIOSize         : DWORD;
  bRc                       : BOOL;
  PIOData                   : POverlapped;
begin
  IOCPData := nil;
  try
    while True do begin
      bRc := GetQueuedCompletionStatus(FIOCPPort, dwIOSize, IOCPKey, PIOData, INFINITE);
      if (PIOData <> nil) then begin
        IOCPData := PIOCPCommObj(PIOData);
        if bRc then begin
          case IOCPData.WorkType of
            SOCKET_READ: begin
                if dwIOSize > 0 then
                  bRc := HandleRecvEvent(IOCPData, dwIOSize)
                else
                  bRc := False;
              end;
            SOCKET_SEND: begin
                if dwIOSize > 0 then
                  bRc := HandleSendEvent(IOCPData, dwIOSize)
                else
                  bRc := False;
              end;
            SOCKET_ACCEPT: try
                FAcceptExSocket.HandleAcceptFinished(IOCPData, IOCPKey);
              except
{$IFDEF _SHDEBUG}
                SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('HANDLE ERROR�����쳣')));
{$ENDIF}
                MainOutMessage('HandleAcceptEvent Error', 5);
              end;
          else begin
{$IFDEF _SHDEBUG}
              SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('��д���ʹ���')));
{$ENDIF}
              bRc := False;
            end;
          end;
        end;
        if not bRc then
          HandleAllError(IOCPData, IOCPKey);
      end else
        Break;
    end;
  except
    on E: Exception do
      HandleExcept(IOCPData, Format('Unhook Exception,Message:%s', [E.Message]));
  end;
end;

{ TIOCPAccepter }

procedure TIOCPAccepter.cleanupAcceptEx(Socket: TSocket);
begin
  SHSocket.FreeSocket(Socket);
end;

procedure TIOCPAccepter.CloseWorkerThread;
var
  i                         : Integer;
begin

  for i := 0 to FThreadCount - 1 do begin

    PostQueuedCompletionStatus(
      FCompPort,
      0,
      0,
      nil);

  end;

  if Assigned(FOnCleanupCompPortEnd) then
    FOnCleanupCompPortEnd(self, FCompPort);

end;

constructor TIOCPAccepter.Create(MaxLogin: Integer; UserManager: TUserManager);
begin
  inherited Create();
  FMaxLoginUser := MaxLogin;
  FAcceptExPool := TMemPool.Create(FMaxLoginUser, SizeOf(TLoginObj));
  FAddrAddLen := SizeOf(SOCKADDR_IN) + 16;
  FRecvLen := LOGIN_BUFFER_LEN - FAddrAddLen shl 1;
  FUserManager := UserManager;
  FCompPort := CreateIoCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 0);
end;

destructor TIOCPAccepter.Destroy;
begin
  if FActive then
    SetActive(False);
  FAcceptExPool.Free;
  CloseHandle(FCompPort);
  inherited Destroy;
end;

procedure TIOCPAccepter.FreeAcceptEx(const IOCPData: PIOCPCommObj; const ListenSocket: TSocket);
var
  bClose                    : Boolean;
begin
  FreeSocket(IOCPData.Socket);
  if FActive then
    PostAcceptEx(ListenSocket, PLoginObj(IOCPData))
  else begin
    bClose := False;
    FAcceptExPool.LockMemPool;
    try
      FAcceptExPool.FreeMemory(IOCPData.MemIndex);
      if FAcceptExPool.InUseBlock <= 0 then
        bClose := True;
    finally
      FAcceptExPool.UnLockMemPool;
    end;
    if bClose then
      CloseWorkerThread;
  end;
end;

function TIOCPAccepter.GetServerInfo: PServerInfo;
begin
  Result := @FServerInfoList;
end;

function TIOCPAccepter.GetInUseBlock: Integer;
begin
  Result := FUserManager.FUserList.InUseBlock;
end;

function TIOCPAccepter.GetMaxInUseBlock: Integer;
begin
  Result := FUserManager.FUserList.MaxInUseBlock;
end;

procedure TIOCPAccepter.HandleAcceptFinished(const IOCPData: PIOCPCommObj; IOKey: DWORD);
var
  PTRLoginObj               : PLoginObj;
  PLocalSockaddr, PRemoteSockaddr: PSockAddr;
  LocalSockaddrLen, RemoteSockaddrLen: Integer;
  FClientPort               : Integer;
  FClientIP                 : PChar;
  iRc                       : Integer;
  bClose                    : Boolean;
  WriterOBJ                 : PIOCPCommObj;
  ReaderOBJ                 : PRecvObj;
  UserOBJ                   : PUserOBJ;
  ServerOBJ                 : PServerInfo;
begin
  bClose := False;
  ServerOBJ := PServerInfo(IOKey);
  try
    if not ServerOBJ.Client.Active then begin //Blue
      MainOutMessage('�����������δ����,��ֹ�ͻ�������...', 1);
      bClose := True;
      Exit;
    end;
    //����û���Ŀ��������
    if FUserManager.FUserList.InUseBlock >= MAX_GAME_USER then begin
      bClose := True;
      Exit;
    end;
    PTRLoginObj := PLoginObj(IOCPData);
    //��ʼ�õ����յ����ӵĶ˿ں�IPͬʱ�õ�Ӧ���յ�������
    FGetAcceptExSockaddrsFunc(
      @PTRLoginObj.Buffer,
      0,
      FAddrAddLen,
      FAddrAddLen,
      PLocalSockaddr,
      LocalSockaddrLen,
      PRemoteSockaddr,
      RemoteSockaddrLen);

    //�õ��ͻ��Ķ˿ں�IP
    FClientPort := ntohs(PRemoteSockaddr.sin_port);
    FClientIP := inet_ntoa(PRemoteSockaddr.sin_addr);

    if frmMain.IsBlockIP(FClientIP) then begin
      MainOutMessage('Block IP: ' + FClientIP, 5);
      bClose := True;
      Exit;
    end;

    //�Ѽ����׽��ӵ������������ص���Client�׽���
    iRc := setsockopt(
      IOCPData.Socket,
      SOL_SOCKET,
      SO_UPDATE_ACCEPT_CONTEXT,
      @ServerOBJ.Socket,
      SizeOf(TSocket));

    if iRc = SOCKET_ERROR then begin
      HandleException(Format('����AcceptEx���׽��ּ̳�Lenten Socket�������������������:%d', [WSAGetLastError()]));
      bClose := True;
      Exit;
    end;

    iRc := CreateIoCompletionPort(
      IOCPData.Socket,
      FCompPort,
      IOCPData.Socket,
      0);

    if iRc = SOCKET_ERROR then begin
      HandleException(Format('�ѽ��յ����׽��ֹ�������ɶ˿�ʧ�ܣ��������Ϊ��%d', [GetLastError()]));
      bClose := True;
      Exit;
    end;

    //û�м���Ƿ����
    if FSendSocket.AddLoginUser(IOCPData, WriterOBJ) then begin
      //����FUserManager���Զ������ڴ棬����һ��������ǲ����жϷ����Ƿ���nil��
      UserOBJ := FUserManager.AddUser(WriterOBJ, FClientIP, FClientPort);
      UserOBJ.GameServ := ServerOBJ.Client;
      PTRLoginObj.CommObj.AddObject := UserOBJ;
      with WriterOBJ^ do begin
        AddObject := UserOBJ;
        InterlockedExchange(Integer(Socket), Integer(IOCPData.Socket));
      end;
      FUserManager.FOnUserEnter(FUserManager, UserOBJ);
      if not FRecvSocket.AddLoginUser(PTRLoginObj, ReaderOBJ) then begin
        FUserManager._DeleteUser(UserOBJ);
        FSendSocket.DeleteLoginUser(WriterOBJ);
{$IFDEF _SHDEBUG}
        SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar('����ʧ�ܣ��Ͽ�����')));
{$ENDIF}
      end;
      //����ط�����˵�����û���ȷ�ļ�����
      MainOutMessage(Format('��½��Ϸ: %s:%d', [FClientIP, FClientPort]), 5);
    end else
      bClose := True;
  finally
    if bClose then
      SHSocket.FreeSocket(IOCPData.Socket);
    PostAcceptEx(ServerOBJ.Socket, PLoginObj(IOCPData)); //����Ͷ����һ��IO����
  end;
end;

procedure TIOCPAccepter.HandleException(const PTRMsgError: string);
begin
  MainOutMessage(PTRMsgError, 5);
  //raise EAcceptExSocket.Create(PTRMsgError);  //blue
{$IFDEF SHDEBUG}
  //��¼����־�ļ������׳��쳣
  SendMessage(hDebug, LB_ADDSTRING, 0, Integer(PChar(PTRMsgError)));
{$ENDIF}

end;

procedure TIOCPAccepter.InitAcceptEx(Port: Integer; Index: Integer);
var
  SI                        : TSockAddrIn;
  iRc                       : Integer;
  Func                      : Integer;
  dwBytes                   : DWORD;
  i                         : Integer;
  dwIOKey                   : DWORD;
  FListenSocket             : TSocket;
begin

  FListenSocket := WSASocket(
    AF_INET,
    SOCK_STREAM,
    0,
    nil,
    0,
    WSA_FLAG_OVERLAPPED);

  if FListenSocket = INVALID_SOCKET then begin
    HandleException(Format('�����׽���ʧ�ܣ��������Ϊ:%d', [WSAGetLastError()]));
    CloseHandle(FCompPort);
    FCompPort := INVALID_HANDLE_VALUE;
  end;

  SI.sin_family := AF_INET;
  SI.sin_port := htons(Port);
  SI.sin_addr.S_addr := INADDR_ANY;

  if bind(FListenSocket, @SI, SizeOf(SI)) = SOCKET_ERROR then begin
    SHSocket.FreeSocket(FListenSocket);
    CloseHandle(FCompPort);
    FCompPort := INVALID_HANDLE_VALUE;
    HandleException(Format('�󶨵�:%d�˿ڳ������������Ϊ:%d', [Port, WSAGetLastError()]));
  end;

  dwIOKey := DWORD(@FServerInfoList[Index]);

  FServerInfoList[Index].Socket := FListenSocket;

  iRc := CreateIoCompletionPort(
    FListenSocket,
    FCompPort,
    dwIOKey,
    0);

  if iRc = 0 then begin
    SHSocket.FreeSocket(FListenSocket);
    CloseHandle(FCompPort);
    FCompPort := INVALID_HANDLE_VALUE;
    HandleException(Format('��������ɶ˿ڴ��󣬴������Ϊ:%d', [GetLastError()]));
  end;

  iRc := WSAIoctl(
    FListenSocket,
    SIO_GET_EXTENSION_FUNCTION_POINTER,
    @WSAID_ACCEPTEX,
    SizeOf(WSAID_ACCEPTEX),
    @Func,                              //@FAcceptExFunc,
    SizeOf(LPFN_ACCEPTEX),
    @dwBytes,
    nil,
    nil);

  if iRc = SOCKET_ERROR then begin
    SHSocket.FreeSocket(FListenSocket);
    CloseHandle(FCompPort);
    FCompPort := INVALID_HANDLE_VALUE;
    HandleException(Format('�õ�acceptEx��ַ���󣬴������Ϊ��%d', [WSAGetLastError()]));
  end;

  FAcceptExFunc := LPFN_ACCEPTEX(Func);

  iRc := WSAIoctl(
    FListenSocket,
    SIO_GET_EXTENSION_FUNCTION_POINTER,
    @WSAID_GETACCEPTEXSOCKADDRS,
    SizeOf(WSAID_GETACCEPTEXSOCKADDRS),
    @Func,
    SizeOf(LPFN_GETACCEPTEXSOCKADDRS),
    @dwBytes,
    nil,
    nil);

  if iRc = SOCKET_ERROR then begin
    SHSocket.FreeSocket(FListenSocket);
    CloseHandle(FCompPort);
    FCompPort := INVALID_HANDLE_VALUE;
    HandleException(Format('�õ�GetAcceptExSockaddrs��ַ���󣬴������Ϊ��%d', [WSAGetLastError()]));
  end;

  FGetAcceptExSockaddrsFunc := LPFN_GETACCEPTEXSOCKADDRS(Func);

  if listen(FListenSocket, BIND_MAX_COUNT) = SOCKET_ERROR then begin
    SHSocket.FreeSocket(FListenSocket);
    CloseHandle(FCompPort);
    FCompPort := INVALID_HANDLE_VALUE;
    HandleException(Format('Listen���󣬴������Ϊ��%d', [WSAGetLastError()]));
  end;

  //��ʼͶ���ص�I/O AcceptEx ����
  for i := 0 to ACCEPTEX_POST_COUNT - 1 do
    PostAcceptEx(FListenSocket);
end;

procedure TIOCPAccepter.InitServer(Port: Integer; Client: TClientThread);
begin
  if FServerCount >= MAX_SERVER_COUNT then
    raise EAcceptExSocket.CreateFmt('�򿪶˿���Ŀ��������...', [MAX_SERVER_COUNT]);
  FServerInfoList[FServerCount].Client := Client;
  FServerInfoList[FServerCount].Port := Port;
  Inc(FServerCount);
end;

procedure TIOCPAccepter.PollAcceptExSocket(var WakeTime: DWORD);
var
  IPLen, iRc                : Integer;
  PTRAcceptObj              : PLoginObj;
  dwConTime                 : DWORD;
begin
  IPLen := SizeOf(DWORD);
  FAcceptExPool.LockMemPool;
  try
    FAcceptExPool.FirstMemory;
    while not FAcceptExPool.IsEnd do begin
      PTRAcceptObj := PLoginObj(FAcceptExPool.MemoryItem);
      //�õ����ӽ���ʱ��
      iRc := getsockopt(
        PTRAcceptObj.CommObj.Socket,
        SOL_SOCKET,
        SO_CONNECT_TIME,
        @dwConTime,
        IPLen);
      if iRc <> SOCKET_ERROR then begin
        if dwConTime <> $FFFFFFFF then begin
          if dwConTime > 3000 then
            SHSocket.FreeSocket(PTRAcceptObj.CommObj.Socket);
        end;
      end;
      FAcceptExPool.NextMemory;
    end;
  finally
    FAcceptExPool.UnLockMemPool;
  end;
end;

procedure TIOCPAccepter.PostAcceptEx(ListenSocket: TSocket; LoginObj: PLoginObj = nil);
var
  NewSocket                 : TSocket;
  PThreadObj                : PLoginObj;
  NewObjIndex               : UINT;
  bRc                       : BOOL;
  dwBytes                   : DWORD;
begin
  NewSocket := Socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  if NewSocket = INVALID_SOCKET then
    HandleException(Format('�½����׽��ִ��󣬴������Ϊ:%d', [WSAGetLastError()]));
  if LoginObj <> nil then
    PThreadObj := LoginObj
  else begin
    EnterCriticalSection(FAcceptExPool.FMemLock);
    try
      PThreadObj := FAcceptExPool.GetMemory(NewObjIndex);
    finally
      LeaveCriticalSection(FAcceptExPool.FMemLock);
    end;
    if NewObjIndex = 0 then begin
      HandleException(Format('��ǰ�û���̫�࣬��������Ϊ:%d', [FAcceptExPool.InUseBlock]));
      Exit;
    end;
    PThreadObj^.CommObj.MemIndex := NewObjIndex;
  end;

  with PThreadObj^ do begin
    dwBytes := 0;
    //FillChar(CommObj, SizeOf(TWSAOverlapped), 0);
    CommObj.PTRIOKey.Internal := dwBytes;
    CommObj.PTRIOKey.InternalHigh := dwBytes;
    CommObj.PTRIOKey.Offset := dwBytes;
    CommObj.PTRIOKey.OffsetHigh := dwBytes;
    CommObj.PTRIOKey.hEvent := dwBytes;
    CommObj.Socket := NewSocket;
    CommObj.WorkType := SOCKET_ACCEPT;
    bRc := FAcceptExFunc(
      ListenSocket,
      CommObj.Socket,
      @Buffer,
      dwBytes,                          //0
      FAddrAddLen,
      FAddrAddLen,
      dwBytes,
      @CommObj.PTRIOKey);

    if not bRc then begin
      if WSAGetLastError() <> WSA_IO_PENDING then
        HandleException(Format('Ͷ��AccpetEx���󣬴������Ϊ:%d', [WSAGetLastError()]));
    end;
  end;
end;

procedure TIOCPAccepter.SetActive(const Value: BOOL);
var
  i                         : Integer;
begin
  if FActive <> Value then begin
    InterlockedExchange(Integer(FActive), Integer(Value));
    if FActive then begin
      for i := 0 to FServerCount - 1 do
        InitAcceptEx(FServerInfoList[i].Port, i);

      if Assigned(FOnInitCompPortFinished) then
        FOnInitCompPortFinished(self, FCompPort);

      FUserManager.FReader := FRecvSocket;
      FUserManager.FWriter := FSendSocket;

    end else
      for i := 0 to FServerCount - 1 do
        cleanupAcceptEx(FServerInfoList[i].Socket);
  end;
end;

procedure TIOCPAccepter.SetRecvSocket(const Value: TIOCPReader);
begin
  FRecvSocket := Value;
end;

procedure TIOCPAccepter.SetSendSocket(const Value: TIOCPWriter);
begin
  FSendSocket := Value;
end;

procedure TIOCPAccepter.SetThreadCount(const Value: Integer);
begin
  if FThreadCount <> Value then
    FThreadCount := Value;
end;

{ TRecvSocket }

function TIOCPReader.AddLoginUser(const IOCPData: PLoginObj; var ReaderOBJ: PRecvObj): Boolean;
var
  MemID                     : UINT;
  PTRUserOBJ                : PUserOBJ;
begin
  Result := False;

  FRecvPool.LockMemPool;
  try
    ReaderOBJ := FRecvPool.GetMemory(MemID);
  finally
    FRecvPool.UnLockMemPool;
  end;

  if MemID <> 0 then begin
    //�����û�����
    PTRUserOBJ := PUserOBJ(IOCPData.CommObj.AddObject);
    PTRUserOBJ._RecvObj := PIOCPCommObj(ReaderOBJ);
    TClientData(PTRUserOBJ.Data).RecvOBJ := PIOCPCommObj(ReaderOBJ);

    with ReaderOBJ^ do begin
      CommObj.MemIndex := MemID;
      CommObj.Socket := IOCPData.CommObj.Socket;
      CommObj.WorkType := SOCKET_READ;
      CommObj.AddObject := PTRUserOBJ;
      RecvPos := 0;
      UserData := PTRUserOBJ.Data;
      CommObj.WBuf.Len := RECV_PACKET_LEN;
      CommObj.WBuf.Buf := @ReaderOBJ.Buffer;
    end;

    //Ͷ�ݵ�һ���ص���������
    Result := PostIOCPRecv(PIOCPCommObj(ReaderOBJ));
    if not Result then begin
      FRecvPool.LockMemPool;
      try
        FRecvPool.FreeMemory(MemID);
      finally
        FRecvPool.UnLockMemPool;
      end;
    end;
  end;
end;

procedure TIOCPReader.CleanupRecvSocket;
//var
//  PTRCommObj                            : PIOCPCommObj;
begin
  //FRecvPool.FirstMemory;
  //
  //  while not FRecvPool.IsEnd do
  //  begin
  //    PTRCommObj := PIOCPCommObj(FRecvPool.MemoryItem);
  //    SHSocket.FreeSocket(PTRCommObj.Socket);
  //    FRecvPool.NextMemory;
  //  end;
  //sunway�޸ģ�����2004-4-6��ֹ�ظ�ɾ��

  FRecvPool.Free;
end;

constructor TIOCPReader.Create(MaxUser: Integer; SendSocket: TIOCPWriter; UserManager: TUserManager);
begin
  FMaxUser := MaxUser;
  FSendSocket := SendSocket;
  FUserManager := UserManager;
  InitRecvSocket;
end;

procedure TIOCPReader.DeleteLoginUser(IOCPData: PIOCPCommObj);
begin
  with IOCPData^ do begin
    InterlockedExchange(Integer(Socket), Integer(INVALID_SOCKET));
    FRecvPool.LockMemPool;
    try
      FRecvPool.FreeMemory(MemIndex);
    finally
      FRecvPool.UnLockMemPool;
    end;
  end;
end;

destructor TIOCPReader.Destroy;
begin
  CleanupRecvSocket;
  inherited Destroy;
end;

function TIOCPReader.GetCurrentUser: Integer;
begin
  FRecvPool.LockMemPool;
  try
    Result := FRecvPool.InUseBlock;
  finally
    FRecvPool.UnLockMemPool;
  end;
end;

function TIOCPReader.HandleReadData(const IOCPData: PIOCPCommObj; const IOLen: DWORD): BOOL;
var
  IOWorkOut                 : DWORD;
begin
  Result := True;
  with PRecvObj(IOCPData)^ do begin
    Inc(RecvPos, IOLen);
    IOWorkOut := RecvPos;
    FOnReadEvent(UserData, Buffer, IOWorkOut, Result);
  end;
  if Result then
    Result := ReadDone(IOCPData, IOWorkOut);
end;

procedure TIOCPReader.InitRecvSocket;
begin
  FRecvPool := TMemPool.Create(FMaxUser, SizeOf(TRecvObj));
  //�����ͷ�ʱ�� �ͷŵ����м��������
  //FRecvPool.OnDestroyEvent := FreeMemPoolRecvObj;
end;

procedure TIOCPReader.PollRecvSocket(var WakeTime: DWORD);
begin
  //��ѭ���еĽ����׽��ӽṹ�����Ƿ����׽��ӳ�ʱ��û���յ�����
end;

function TIOCPReader.PostIORecv(IOCPData: PIOCPCommObj): Boolean;
begin
  Result := IOCPTypeDef.PostIOCPRecv(IOCPData);
end;

function TIOCPReader.ReadDone(const IOCPData: PIOCPCommObj; const IOLen: DWORD): BOOL;
var
  PTRRecvOBJ                : PRecvObj;
  iRecvLen                  : Integer;
begin
  PTRRecvOBJ := PRecvObj(IOCPData);
  with IOCPData^, PTRRecvOBJ^ do begin
    if (IOLen >= PTRRecvOBJ.RecvPos) then begin
      WBuf.Buf := @Buffer;
      WBuf.Len := RECV_PACKET_LEN;
      RecvPos := 0;
    end else begin
      RecvPos := RecvPos - IOLen;
      if IOLen > 0 then
        Move(Buffer[IOLen], Buffer, RecvPos)
      else if RecvPos >= RECV_BUFFER_LEN then begin
        Result := False;
        Exit;
      end;
      WBuf.Buf := @Buffer[RecvPos];
      iRecvLen := RECV_BUFFER_LEN - RecvPos;
      if iRecvLen > RECV_PACKET_LEN then
        iRecvLen := RECV_PACKET_LEN;
      WBuf.Len := iRecvLen;
    end;
  end;
  Result := PostIOCPRecv(IOCPData);
end;

{ TIOCPWriter }

function TIOCPWriter.AddLoginUser(IOCPData: PIOCPCommObj; var WriterOBJ: PIOCPCommObj): Boolean;
begin
  WriterOBJ := PIOCPCommObj(FSendQueue.GetSendQueue(IOCPData));
  Result := WriterOBJ <> nil;
end;

procedure TIOCPWriter.BroadUserMsg(WParam, LParam: Integer; OnBroadcastEvent: TOnBroadCastEvent);
begin
  with FSendQueue.MemPool do begin
    LockMemPool;
    try
      FirstMemory;
      while not IsEnd do begin
        OnBroadcastEvent(PIOCPCommObj(MemoryItem).AddObject, WParam, LParam);
        NextMemory();
      end;
    finally
      UnLockMemPool;
    end;
  end;
end;

procedure TIOCPWriter.cleanupSendSocket;
begin
  FSendQueue.Free;
end;

constructor TIOCPWriter.Create(MaxUser: Integer; UserManager: TUserManager);
begin
  FMaxUser := MaxUser;
  FUserManager := UserManager;
  InitSendSocket;
end;

procedure TIOCPWriter.DeleteLoginUser(IOCPData: PIOCPCommObj);
begin
  FSendQueue.FreeSendQueue(IOCPData)
end;

procedure TIOCPWriter.DeleteSocket(const WriterOBJ: PIOCPCommObj);
begin
  FSendQueue.FreeSocket(WriterOBJ);
end;

destructor TIOCPWriter.Destroy;
begin
  cleanupSendSocket;
  inherited Destroy;
end;

function TIOCPWriter.GetCurrentUser: Integer;
begin
  FSendQueue.MemPool.LockMemPool;
  try
    Result := FSendQueue.MemPool.InUseBlock;
  finally
    FSendQueue.MemPool.UnLockMemPool;
  end;
end;

function TIOCPWriter.HandleSendFinished(IOCPData: PIOCPCommObj): Boolean;
begin
  Result := FSendQueue.GetBuffer(IOCPData);
end;

procedure TIOCPWriter.InitSendSocket;
begin
  FSendQueue := TSendQueue.Create(FMaxUser);
end;

procedure TIOCPWriter.PollSendSocket(var WakeTime: DWORD);
var
  dwNow                     : DWORD;
  PTRSendObj                : PIOCPCommObj;
begin
  dwNow := GetTickCount();

  with FSendQueue.MemPool do begin
    LockMemPool;
    try
      FirstMemory;

      while not IsEnd do begin
        PTRSendObj := PIOCPCommObj(MemoryItem);

        if dwNow - PTRSendObj.PostTime > 5000 then begin
          SHSocket.FreeSocket(PTRSendObj.Socket);
        end;

        NextMemory;

      end;

    finally
      UnLockMemPool;
    end;
  end;

end;

procedure TIOCPWriter.PostAllUserSend(const Buffer: PChar; const BufLen: DWORD);
var
  PTRPoll                   : PIOCPCommObj;
begin
  with FSendQueue.MemPool do begin
    LockMemPool;
    try
      FirstMemory;
      while not IsEnd do begin
        PTRPoll := PIOCPCommObj(MemoryItem);
        NextMemory;
        if PTRPoll.Socket <> INVALID_SOCKET then
          SendData(PTRPoll, Buffer, BufLen);
      end;
    finally
      UnLockMemPool;
    end;
  end;
end;

function TIOCPWriter.SendData(const WriterOBJ: PIOCPCommObj; const Buffer: PChar; const size: UINT): Boolean;
var
  iRc                       : Integer;
begin
  iRc := FSendQueue.AddBuffer(WriterOBJ, Buffer, size);
  if iRc = ADD_BUFFER_TO_QUEUE_OK then
    Result := True
  else begin
    FSendQueue.FreeSocket(WriterOBJ);
    Result := False;
  end;
end;

{ TUserManager }

function TUserManager.AddUser(const SendObj: PIOCPCommObj; const CIP: PChar; const CPort: Integer): PUserOBJ;
var
  dwUserID                  : DWORD;
begin
  FUserList.LockMemPool;
  try
    Result := FUserList.GetMemory(dwUserID);
  finally
    FUserList.UnLockMemPool;
  end;
  if Result <> nil then
    with Result^ do begin
      IPLen := StrLen(CIP);
      StrLCopy(IP, CIP, IPLen);
      Port := CPort;
      _SendObj := SendObj;
      UID := dwUserID;
      UserManager := self;
      Reader := FReader;
      Writer := FWriter;
    end;

end;

constructor TUserManager.Create(MaxUser: Integer);
begin
  //+4��Ϊ������
  FUserList := TFixedMemoryPool.Create(SizeOf(TUserObj), MaxUser + 4);
end;

destructor TUserManager.Destroy;
begin
  FUserList.Free;
  inherited Destroy;
end;

procedure TUserManager.DeleteUser(const UserOBJ: PUserOBJ);
var
  bOK                       : Boolean;
begin
  FUserList.LockMemPool;
  try
    bOK := FUserList.FreeMemory(UserOBJ);
  finally
    FUserList.UnLockMemPool;
  end;
  if bOK then try
    FOnUserLeave(self, UserOBJ);
    FReader.DeleteLoginUser(UserOBJ._RecvObj);
    FWriter.DeleteLoginUser(UserOBJ._SendObj);
  except
    MainOutMessage('ɾ���û������쳣...', 5);
  end;
end;

procedure TUserManager._DeleteUser(const UserOBJ: PUserOBJ);
begin
  FUserList.LockMemPool;
  try
    FOnUserLeave(self, UserOBJ);
    FUserList.FreeMemory(UserOBJ);
  finally
    FUserList.UnLockMemPool;
  end;
end;

function TUserManager.IsAvailayUser(const UserOBJ: PUserOBJ): Boolean;
var
  PTRFreeItem               : PXMemItem;
begin
  Result := False;
  PTRFreeItem := FUserList.IsUserMemory(UserOBJ);
  if PTRFreeItem <> nil then
    Result := PTRFreeItem.MemNode.InUse;
end;

end.
