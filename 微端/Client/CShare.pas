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

  //选择角色信息
  TUserCharacterInfo = record
    ID: Integer;
    Name: string[16];
    Job: Byte;
    Sex: Byte;
    Level: LongWord;
    LoginTime: TDateTime;
  end;

  //选择角色结构
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
    szServiceName: string[128];                                    //游戏服务名称
    szServiceAddr: string[32];                                        //游戏服务地址
    wdServicePort: Word;                                                        //游戏服务端口
    csServiceStatus:TCServiceStatus;                                            //游戏服务状态
  end;
  pTCServiceInfo = ^TCServiceInfo;
  TCServiceInfos = array[0..7] of TCServiceInfo;

  //微端数据结构
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

  TServerInfo = record
    Socket     :TCustomWinSocket;                                               //连接终端
    liConnctTick:LARGE_INTEGER;                                                 //连接超时
    liConnctTime:LARGE_INTEGER;                                                 //重练时间
    liLastRecvTime:LARGE_INTEGER;                                               //上次回话时间
    liVerifyServerTime:LARGE_INTEGER;                                           //验证服务超时
    liSendKeepAliveTime:LARGE_INTEGER;
    liKeepAliveTime:LARGE_INTEGER;
    nServerIndex:Integer;
    boClosed    :Boolean;                                                       //是否关闭
    boVerifyConn:Boolean;                                                       //合法校验
    boKeepAliveTimcOut:Boolean;                                                 //心跳超时
    sServerAddr :string[16];
    wServerPort :Word;
    ImageStream :TMemoryStream;                                                 //资源内存
    pUpdateInfo :pTUpdateInfo;                                                  //更新对象
    boUpdateComplete:Boolean;                                                   //更新状态(True 更新完成 False 未完成)
    sStr        :string;                                                        //数据内容
  end;
  pTServerInfo = ^TServerInfo;
  TServerSessionArray = array [0..MAXCONNECTGATE - 1] of TServerInfo;

  function GetMapDirAndName(sFileName: string): string;
  procedure DrawBlend(dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; blendmode: integer);

var
  g_gsStatus        : TGameStatus = gsOpen;
  g_stMainScenes    : TSceneType  = stLogin;                                    //当前场景类型
  g_csConnectionStep: TConnectionStep;                                          //当前连接状态
  g_CServiceInfos   : TCServiceInfos;
  g_LServerCount    : Integer     = 0;
  g_LegendMap: TLegendMap;
  g_FScreenWidth: Integer = DEFSCREENWIDTH;
  g_FScreenHeight: Integer = DEFSCREENHEIGHT;
  g_wRx:Integer = 317;
  g_wRy:Integer = 270;
  g_boDrawTileMap: Boolean = True;
  g_SoundList: TStringList; //声音列表

  g_boSound: Boolean; //开启声音
  g_boBGSound: Boolean = True; //开启背景音乐
  g_boBGSoundCLose: Boolean = False;
  g_Sound: TSoundEngine;
  g_DXSound: TDXSound;
  g_dbFrequency     : Double = 0;
  g_liStartTime     : LARGE_INTEGER;
  g_vcUpdateArray   : TServerSessionArray;
  g_boOpenConnectedMode         : Boolean   = True;
  g_vcUpdateHeadStr : TList;
  g_vcUpdateDataStr : TList;                                                    //数据更新列表
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
