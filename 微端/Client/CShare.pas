unit CShare;

interface

uses
  Windows, Classes, SysUtils, FindMapPath, uSocket, HGE, HGETextures, HGESounds;

const
  SELECTEDFRAME                   = 16;
  FREEZEFRAME                     = 13;
  EFFECTFRAME                     = 14;
  MAXUPDATEGATE                   = 3;
  LONGHEIGHT_IMAGE = 35;
  MAXX = 52;
  MAXY = 40;
  UNITX = 48;
  UNITY = 32;
  HALFX = 24;
  HALFY = 16;
  AAX = 16;
  LOGICALMAPUNIT = 30;
  MAXCONNECTGATE                  = 3;

  DEFSCREENWIDTH = 800;
  DEFSCREENHEIGHT = 600;
  DEFWIDESCREENWIDTH = 1024;
  DEFWIDESCREENHEIGHT = 600;
  DEFMAXSCREENWIDTH = 1024;
  DEFMAXSCREENHEIGHT = 768;

  MAPDIRNAME = '.\Map\';

type
  TGameStatus = (gsNone, gsOpen, gsClose);
  TSceneType = (stLogin, stSelectChr, stNotice, stPlayGame, stHint, stClose);
  TLoginState = (lsLogin, lsNewid, lsNewidRetry, lsChgpw, lsCloseAll, lsCard);
  TSelectChrState = (scSelectChr, scCreateChr, scRenewChr, scCloseAll);
  TConnectionStep = (cnsSelServer, cnsLogin, cnsSelChr, cnsNotice, cnsPlay);

  //ѡ���ɫ��Ϣ
  TUserCharacterInfo = record
    ID: Integer;
    Name: string[16];
    Job: Byte;
    Sex: Byte;
    Level: LongWord;
    LoginTime: TDateTime;
  end;

  //ѡ���ɫ�ṹ
  TSelChar = record
    Valid: Boolean;
    UserChr: TUserCharacterInfo;
    Selected: Boolean;
    FreezeState: Boolean;
    Unfreezing: Boolean;
    Freezing: Boolean;
    AniIndex: Integer;
    DarkLevel: Integer;
    EffIndex: Integer;
    StartTime: LongWord;
    moretime: LongWord;
    startefftime: LongWord;
  end;

  TCServiceStatus = (csClose, csOpen);
  TCServiceInfo = packed record
    szServiceName: string[128];                                    //��Ϸ��������
    szServiceAddr: string[32];                                        //��Ϸ�����ַ
    wdServicePort: Word;                                                        //��Ϸ����˿�
    csServiceStatus:TCServiceStatus;                                            //��Ϸ����״̬
  end;
  pTCServiceInfo = ^TCServiceInfo;
  TCServiceInfos = array[0..7] of TCServiceInfo;

  //΢�����ݽṹ
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

  TServerInfo = record
    Socket     :TCustomWinSocket;                                               //�����ն�
    liConnctTick:LARGE_INTEGER;                                                 //���ӳ�ʱ
    liConnctTime:LARGE_INTEGER;                                                 //����ʱ��
    liLastRecvTime:LARGE_INTEGER;                                               //�ϴλػ�ʱ��
    liVerifyServerTime:LARGE_INTEGER;                                           //��֤����ʱ
    liSendKeepAliveTime:LARGE_INTEGER;
    liKeepAliveTime:LARGE_INTEGER;
    nServerIndex:Integer;
    boClosed    :Boolean;                                                       //�Ƿ�ر�
    boVerifyConn:Boolean;                                                       //�Ϸ�У��
    boKeepAliveTimcOut:Boolean;                                                 //������ʱ
    sServerAddr :string[16];
    wServerPort :Word;
    ImageStream :TMemoryStream;                                                 //��Դ�ڴ�
    pUpdateInfo :pTUpdateInfo;                                                  //���¶���
    boUpdateComplete:Boolean;                                                   //����״̬(True ������� False δ���)
    sStr        :string;                                                        //��������
  end;
  pTServerInfo = ^TServerInfo;
  TServerSessionArray = array [0..MAXCONNECTGATE - 1] of TServerInfo;

  function GetMapDirAndName(sFileName: string): string;
  procedure DrawBlend(dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; blendmode: integer);

var
  g_gsStatus        : TGameStatus = gsOpen;
  g_stMainScenes    : TSceneType  = stLogin;                                    //��ǰ��������
  g_csConnectionStep: TConnectionStep;                                          //��ǰ����״̬
  g_CServiceInfos   : TCServiceInfos;
  g_LServerCount    : Integer     = 0;
  g_LegendMap: TLegendMap;
  g_FScreenWidth: Integer = DEFSCREENWIDTH;
  g_FScreenHeight: Integer = DEFSCREENHEIGHT;
  g_wRx:Integer = 317;
  g_wRy:Integer = 270;
  g_boDrawTileMap: Boolean = True;
  g_SoundList: TStringList; //�����б�

  g_boSound: Boolean; //��������
  g_boBGSound: Boolean = True; //������������
  g_boBGSoundCLose: Boolean = False;
  g_Sound: TSoundEngine;
  g_DXSound: TDXSound;
  g_dbFrequency     : Double = 0;
  g_liStartTime     : LARGE_INTEGER;
  g_vcUpdateArray   : TServerSessionArray;
  g_boOpenConnectedMode         : Boolean   = True;
  g_vcUpdateHeadStr : TList;
  g_vcUpdateDataStr : TList;                                                    //���ݸ����б�
  g_vcUpdateWavStr  : TList;


implementation

function GetMapDirAndName(sFileName: string): string;
begin
  Result := MAPDIRNAME + sFileName + '.map';
end;

procedure DrawBlend(dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; blendmode: integer);
begin
  if blendmode = 0 then
    dsuf.Draw(x, y, ssuf.ClientRect, ssuf, $80FFFFFF, fxBlend)
  else
    dsuf.Draw(x, y, ssuf.ClientRect, ssuf, fxAnti);
end;

end.
