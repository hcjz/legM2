unit CShare;

interface

uses
  Windows, Classes, Mir2Res, uSocket;

{------------------------------- �ڲ������� ---------------------------------}
const
  MAXOPENGATE                             = 8;
  MAXSENDSIZE                             = 8192;
const
  SENDDATAMSG                             = '(Data: %.2f MB)';
  SENDMAPMSG                              = '(Map: %.2f MB)';
  SENDWAVMSG                              = '(Wav: %.2f MB)';
  UPDATETIMEMSG                           = '��������: %s';
  UPDATETIME                              = '2018.03.31';

  SHOWMSGMAX                              = 150;
  GATEMAXSESSION                          = 10000;

type
  TDownStatus = (dsNormal ,dsDownLoading);

  TClientInfo = record
    Socket     :TCustomWinSocket;                                               //�����ն�
    nServerIndex:Integer;                                                       //΢������
    liConnctTime:LARGE_INTEGER;                                                 //���ӳ�ʱ
    liKeepAliveTime:LARGE_INTEGER;                                              //�Ựʱ��
    boVerifyConn:Boolean;                                                       //�Ϸ�У��
    boKeepAliveTimcOut:Boolean;                                                 //������ʱ
    boConnected :Boolean;                                                       //����״̬
    sRemoteAddr :string[16];
    wRemotePort :Word;
    sStr        :string;                                                        //��������
  end;
  pTClientInfo = ^TClientInfo;
  TClientSessionArray = array [0..GATEMAXSESSION - 1] of TClientInfo;

  TUpdateType = (utNone, utWzlHead, utMapHead, utWavHead, utImgHead, utImage, utMap, utWav);
  TUpDateInfo = packed record
	  utUpdateType:TUpdateType;	                                                  //��Դ����
	  nImageIndex:Integer;		                                                    //��Դ��ʾ
	  boDownLoad:Boolean;		                                                      //��ʼ����
    boZipData:Boolean;                                                          //�Ƿ�ѹ��
	  dwFileSize:LongWord;		                                                    //�ļ���С
    dwZipSize:LongWord;                                                         //ѹ����С
    dwZipLevel:LongWord;                                                        //ѹ���ȼ�
	  dwRecvSize:LongWord;		                                                    //���մ�С
    dwRecogerID:LongWord;                                                       //��Դ����
	  szFileName:string[64];		                                                  //�ļ�����
  end;
  pTUpdateInfo = ^TUpDateInfo;

  TStatus = (tsNone, tsRun, tsLock, tsExit);                                    //�߳�״̬

  TThreadStatus = record
    dwThreadId:LongWord;                                                        //�̱߳�ʾ
    dwThreadhd:LongWord;                                                        //�߳̾��
    tsThreadStatus:TStatus;                                                     //�߳�״̬
    liRunTime:LARGE_INTEGER;                                                    //�߳�����
    szThreadDesc:string[8];			                                                //�̱߳�ע
  end;
  pTThreadStatus = ^TThreadStatus;

{------------------------------- �ڲ������� ---------------------------------}
  procedure WriteRuntimesLog(szRuntimeLog:string);
  procedure OpenThread(ThreadFunc: TThreadFunc; ThreadName:string; ThreadCount:Integer = 1);
{------------------------------- �ڲ�������� ---------------------------------}
var
  g_fSendDataSize                 :Double = 0;                                  //�ѷ���MB(Data)
  g_fSendMapsSize                 :Double = 0;                                  //�ѷ���MB(Map)
  g_fSendWavsSize                 :Double = 0;                                  //�ѷ���MB(Wav)
  g_fWaitDataSize                 :Double = 0;                                  //������MB(Data)
  g_fWaitMapsSize                 :Double = 0;                                  //������MB(Map)
  g_fWaitWavsSize                 :Double = 0;                                  //������MB(Wav)
  g_WMMainImages                  :TStringList;                                 //��Դ�б�
  g_WMMapList                     :TStringList;                                 //��ͼ�б�
  g_WMWavList                     :TStringList;                                 //�����б�
  g_ClientArray                   :TClientSessionArray;                         //�����ն��б�
  g_vcConnections                 :TList;                                       //�����б�
  g_nConnection                   : array[0..7] of Integer;                     //΢����������
  g_csCriticalSection             : TRTLCriticalSection;
  g_vcClientReviceList:TList;
  g_nRunningThreadCount         : Integer   = 0;                                //�߳���������
  g_tsThreadStatus              : array [0..3] of TThreadStatus;                //�����߳�״̬
  g_hEvent                      : THandle;                                      //�߳��ź��¼�
  g_boMapView                     :Boolean = False;                             //�Ƿ�����ļ�ӳ��(����ڴ�֧�֣�������������쳣)

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
