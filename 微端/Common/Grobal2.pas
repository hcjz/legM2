unit Grobal2;

interface

const
  NOTFOUND                        = -1;
  S_OK                            = 0;                                          //����ֵ����
  S_ERROR                         = 1;                                          //����ֵ����
  DEFAULTENCODEACTIONSIZE         = 22;                                         //Ĭ�ϼ��ܳ���
  DEFAULTACTIONENCODE             = 128;                                        //Ĭ�ϼ�������
  SHOWMSGMAX                      = 150;
  GATEMAXSESSION                  = 10000;
  SERVERNAMELENGTH                = 64;                                         //��Ϸ����󳤶�
  IPNAMELENGTH                    = 16;                                         //IP��ַ��󳤶�
  SERVICELIMIT                    = 8;                                          //������������
  QUERYCHRINFOSIZE                = 32;                                         //��ѯ��ɫ�ṹ���ܳ���
  DELCHRINFOSIZE                  = 43;                                         //ɾ����ɫ�ṹ���ܳ���
  DEFAULTSENDSIZE                 = 8192;


  DEFALUT_ZIP_LEVEL     = 2;                                                    //ѹ���ȼ�

  BIND_MSG                        = '�Ѱ�(%s:%d)...';
  CONN_MSG                        = '������(%s:%d)...';
  DCON_MSG                        = '�ѹر�(%s:%d)...';
  DTIMEOUT_MSG                    = '������ʱ:(%s:%d)...';
  UNKNOWNCONN_MSG                 = '�Ƿ�����:(%s:%d)...';
  CONNTIMEOUT_MSG                 = '���ӳ�ʱ:(%s:%d)...';
  VERIFYSERVICETIMEOUT_MSG        = '��֤��ʱ:(%s:%d)...';
  GATEOPENMSG                     = '-----][-----';
  GATEUNKNOWN                     = '??????';
  GATENOTCONNECT                  = 'δ����';
  GATEALIVETIMEOUT                = '���ӳ�ʱ';
  ERRORPACKGEMSG                  = '�Ƿ����:%s:%d';

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
  SM_UPDATEINFO                   = $9001;                                      //�����ļ�ͷ
  SM_UPDATEDATA                   = $9002;                                      //����������
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
    dwSize:LongWord;              //ʵ�����ݳ���
    dwZipSize:LongWord;           //ѹ�����ݳ���
    dwZipLevel:LongWord;          //ѹ�����ݵȼ�
  end;

implementation

end.
