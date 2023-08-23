unit CShare;

interface

uses
  Windows, Classes, Mir2Res, uSocket;

{------------------------------- 内部共享常量 ---------------------------------}
const
  MAXOPENGATE                             = 8;
  MAXSENDSIZE                             = 8192;
const
  SENDDATAMSG                             = '(Data: %.2f MB)';
  SENDMAPMSG                              = '(Map: %.2f MB)';
  SENDWAVMSG                              = '(Wav: %.2f MB)';
  UPDATETIMEMSG                           = '更新日期: %s';
  UPDATETIME                              = '2018.03.31';

  SHOWMSGMAX                              = 150;
  GATEMAXSESSION                          = 10000;

type
  TDownStatus = (dsNormal ,dsDownLoading);

  TClientInfo = record
    Socket     :TCustomWinSocket;                                               //连接终端
    nServerIndex:Integer;                                                       //微端索引
    liConnctTime:LARGE_INTEGER;                                                 //连接超时
    liKeepAliveTime:LARGE_INTEGER;                                              //会话时间
    boVerifyConn:Boolean;                                                       //合法校验
    boKeepAliveTimcOut:Boolean;                                                 //心跳超时
    boConnected :Boolean;                                                       //连接状态
    sRemoteAddr :string[16];
    wRemotePort :Word;
    sStr        :string;                                                        //数据内容
  end;
  pTClientInfo = ^TClientInfo;
  TClientSessionArray = array [0..GATEMAXSESSION - 1] of TClientInfo;

  TUpdateType = (utNone, utWzlHead, utMapHead, utWavHead, utImgHead, utImage, utMap, utWav);
  TUpDateInfo = packed record
	  utUpdateType:TUpdateType;	                                                  //资源类型
	  nImageIndex:Integer;		                                                    //资源标示
	  boDownLoad:Boolean;		                                                      //开始下载
    boZipData:Boolean;                                                          //是否压缩
	  dwFileSize:LongWord;		                                                    //文件大小
    dwZipSize:LongWord;                                                         //压缩大小
    dwZipLevel:LongWord;                                                        //压缩等级
	  dwRecvSize:LongWord;		                                                    //接收大小
    dwRecogerID:LongWord;                                                       //资源对象
	  szFileName:string[64];		                                                  //文件名称
  end;
  pTUpdateInfo = ^TUpDateInfo;

  TStatus = (tsNone, tsRun, tsLock, tsExit);                                    //线程状态

  TThreadStatus = record
    dwThreadId:LongWord;                                                        //线程标示
    dwThreadhd:LongWord;                                                        //线程句柄
    tsThreadStatus:TStatus;                                                     //线程状态
    liRunTime:LARGE_INTEGER;                                                    //线程周期
    szThreadDesc:string[8];			                                                //线程备注
  end;
  pTThreadStatus = ^TThreadStatus;

{------------------------------- 内部共享函数 ---------------------------------}
  procedure WriteRuntimesLog(szRuntimeLog:string);
  procedure OpenThread(ThreadFunc: TThreadFunc; ThreadName:string; ThreadCount:Integer = 1);
{------------------------------- 内部共享变量 ---------------------------------}
var
  g_fSendDataSize                 :Double = 0;                                  //已发送MB(Data)
  g_fSendMapsSize                 :Double = 0;                                  //已发送MB(Map)
  g_fSendWavsSize                 :Double = 0;                                  //已发送MB(Wav)
  g_fWaitDataSize                 :Double = 0;                                  //待发送MB(Data)
  g_fWaitMapsSize                 :Double = 0;                                  //待发送MB(Map)
  g_fWaitWavsSize                 :Double = 0;                                  //待发送MB(Wav)
  g_WMMainImages                  :TStringList;                                 //资源列表
  g_WMMapList                     :TStringList;                                 //地图列表
  g_WMWavList                     :TStringList;                                 //声音列表
  g_ClientArray                   :TClientSessionArray;                         //连接终端列表
  g_vcConnections                 :TList;                                       //连接列表
  g_nConnection                   : array[0..7] of Integer;                     //微端连接数组
  g_csCriticalSection             : TRTLCriticalSection;
  g_vcClientReviceList:TList;
  g_nRunningThreadCount         : Integer   = 0;                                //线程运行数量
  g_tsThreadStatus              : array [0..3] of TThreadStatus;                //服务线程状态
  g_hEvent                      : THandle;                                      //线程信号事件
  g_boMapView                     :Boolean = False;                             //是否采用文件映射(需大内存支持，否则服务器出异常)

implementation

uses
  ClMain;

procedure WriteRuntimesLog(szRuntimeLog:string);
begin
  frmMain.WriteRuntimesLog(szRuntimeLog);
end;

procedure OpenThread(ThreadFunc: TThreadFunc; ThreadName:string; ThreadCount:Integer = 1);
var
  hThread:LongWord;
begin
  if sizeof(g_tsThreadStatus) > g_nRunningThreadCount then begin
    ReSetEvent(g_hEvent);
    hThread := BeginThread(nil, 0, ThreadFunc, nil, 0, g_tsThreadStatus[g_nRunningThreadCount].dwThreadId);
    g_tsThreadStatus[g_nRunningThreadCount].dwThreadhd := CreateEvent(nil, FALSE, FALSE, nil);
    CloseHandle(hThread);
    g_tsThreadStatus[g_nRunningThreadCount].szThreadDesc:= ShortString(ThreadName);
    WaitForSingleObject(g_hEvent, INFINITE);
  end;
end;

end.
