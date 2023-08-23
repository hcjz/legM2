unit Grobal2;

interface

const
  NOTFOUND                        = -1;
  S_OK                            = 0;                                          //返回值类型
  S_ERROR                         = 1;                                          //返回值类型
  DEFAULTENCODEACTIONSIZE         = 22;                                         //默认加密长度
  DEFAULTACTIONENCODE             = 128;                                        //默认加密索引
  SHOWMSGMAX                      = 150;
  GATEMAXSESSION                  = 10000;
  SERVERNAMELENGTH                = 64;                                         //游戏名最大长度
  IPNAMELENGTH                    = 16;                                         //IP地址最大长度
  SERVICELIMIT                    = 8;                                          //单区服务上限
  QUERYCHRINFOSIZE                = 32;                                         //查询角色结构加密长度
  DELCHRINFOSIZE                  = 43;                                         //删除角色结构加密长度
  DEFAULTSENDSIZE                 = 8192;


  DEFALUT_ZIP_LEVEL     = 2;                                                    //压缩等级

  BIND_MSG                        = '已绑定(%s:%d)...';
  CONN_MSG                        = '已连接(%s:%d)...';
  DCON_MSG                        = '已关闭(%s:%d)...';
  DTIMEOUT_MSG                    = '心跳超时:(%s:%d)...';
  UNKNOWNCONN_MSG                 = '非法连接:(%s:%d)...';
  CONNTIMEOUT_MSG                 = '连接超时:(%s:%d)...';
  VERIFYSERVICETIMEOUT_MSG        = '验证超时:(%s:%d)...';
  GATEOPENMSG                     = '-----][-----';
  GATEUNKNOWN                     = '??????';
  GATENOTCONNECT                  = '未连接';
  GATEALIVETIMEOUT                = '连接超时';
  ERRORPACKGEMSG                  = '非法封包:%s:%d';

  MG_AddConnMsg                   = 'v';
  MG_AliveSMsg                    = '+';
  MG_CodeHead                     = '%';
  MG_CodeEnd                      = '$';
  MG_SAFECONNECTEDMSG             = '*';


  MG_UPDATEFILE                   = 'F';
  MG_IMAGESIZE                    = 'S';
  MG_NOTDATA                      = 'N';
  MG_UPDATEIMAGES                 = 'I';
  MG_UPDATEDATA                   = 'D';
  MG_UPDATEMAP                    = 'M';
  MG_UPDATEWAV                    = 'W';

  MG_ALIVEMSG                     = $1000;
  CM_UPDATEHEAD                   = $8000;
  CM_UPDATEINFO                   = $8001;
  CM_UPDATEDATA                   = $8002;
  CM_UPDATEMAPINFO                = $8003;
  CM_UPDATEMAPDATA                = $8004;
  CM_UPDATEWAVINFO                = $8005;
  CM_UPDATEWAVDATA                = $8006;

  SM_UPDATEHEAD                   = $9000;
  SM_UPDATEINFO                   = $9001;                                      //更新文件头
  SM_UPDATEDATA                   = $9002;                                      //更新数据列
  SM_UPDATEMAPINFO                = $9003;
  SM_UPDATEMAPDATA                = $9004;
  SM_UPDATEWAVINFO                = $9005;
  SM_UPDATEWAVDATA                = $9006;

  SM_UPDATECOMPELETE              = $9007;

type
  TDefaultMessage = record
    Recog: Integer;
    Ident: Word;
    Param: Word;
    Tag: Word;
    Series: Word;
    nSessionID: Integer;
  end;
  pTDefaultMessage = ^TDefaultMessage;

  TZipInfo = packed record
    dwSize:LongWord;              //实际数据长度
    dwZipSize:LongWord;           //压缩数据长度
    dwZipLevel:LongWord;          //压缩数据等级
  end;

implementation

end.
