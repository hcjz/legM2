unit M2Share;

interface

uses
  Windows, Messages, Classes, SysUtils, StdCtrls, Graphics, VCLUnZip, VCLZip, RunSock, Envir, ItmUnit, Magic, NoticeM,
  Guild, Event, SDK, PlugIn, StartPointManage, Castle, FrnEngn, UsrEngn, MudUtil, Grobal2, ObjBase,
  ObjRobot, ObjNpc, SyncObjs, IniFiles, EncryptUnit, WinSock, StrUtils, TLHelp32, psapi, CnHashTable, HashList;

const
  THREADENGINE              = 0;
  TIMERENGINE               = 1;
  DBSOCKETMODE              = TIMERENGINE;
  IDSOCKETMODE              = TIMERENGINE;
  USERENGINEMODE            = TIMERENGINE;

  DEBUGTEST                 = 0;
  CUSTOMBUILD               = 0;
  INTERSERVER               = 1;        //多地图负载

  VERDEMO                   = 0;
  VERFREE                   = 1;
  VERSTD                    = 2;
  VEROEM                    = 3;
  VERPRO                    = 4;
  VERENT                    = 5;
  SoftVersion               = VERENT;
  ReleaseVersion            = VERENT;
  CUSTOM_VERSION            = VERENT;

  USEPLUGFUNC               = 1;
  PLUGINLIST                = 1;
  OPENTOPLEN                = 25;
  MAXMAGICLV                = 4;

  DEBUG                     = 1;
  EXPIPLOCAL                = 1;
  CHECKNEWMSG               = 0;

  NOEXCEPTION               = 0;
  TRYEXCEPTION              = 1;
  CATEXCEPTION              = TRYEXCEPTION;

  DEMOCLIENT                = 0;
  CLIENTFLAG                = 9;

  BDE                       = 0;
  ADO                       = 1;
  DBTYPE                    = BDE;

  USELOCALCODE              = 0;
  USEREMOTECODE             = 1;

  USECODE                   = USELOCALCODE;
  RequestVersion            = 5;

  LF                        = 0;
  LD                        = 1;
  ZQ                        = 2;
  DUDU                      = 3;
  ZYL                       = 4;
  WL                        = 5;
  TEST                      = 53;
  VEROWNER                  = 0;

  OEM                       = 0;
  OEM775                    = 1;
  OEMVER                    = OEM;

  OLDMONSTERMODE            = 0;
  NEWMONSTERMODE            = 1;
  PROCESSMONSTMODE          = NEWMONSTERMODE;

  MAXUPLEVEL                = High(Word);
  MAXHUMPOWER               = High(Word);

  BODYLUCKUNIT              = 5.0E3;

  DEFHIT                    = 5;
  DEFSPEED                  = 15;
  WARR                      = 0;
  WIZARD                    = 1;
  TAOS                      = 2;

  SIZEOFTHUMAN              = {$IF V_DIGITEM} {7156} 7490{$ELSE}5036{$IFEND}; //$C5C;

  MONSTER_SANDMOB           = 3;
  MONSTER_ROCKMAN           = 4;
  MONSTER_RON               = 9;
  MONSTER_MINORNUMA         = 18;
  ANIMAL_CHICKEN            = 20;
  ANIMAL_DEER               = 21;
  MONSTER_OMA               = 23;
  MONSTER_OMAKNIGHT         = 25;
  MONSTER_OMAWARRIOR        = 27;
  MONSTER_SPITSPIDER        = 30;
  MONSTER_STICK             = 39;
  MONSTER_DUALAXE           = 42;
  MONSTER_THONEDARK         = 74;
  MONSTER_LIGHTZOMBI        = 78;
  MONSTER_WHITESKELETON     = 94;
  MONSTER_BEEQUEEN          = 124;
  MONSTER_BEE               = 125;
  MONSTER_MAGUNGSA          = 143;
  MONSTER_SCULTURE1         = 145;
  MONSTER_SCULTURE2         = 148;
  MONSTER_SCULTUREKING      = 152;
  MONSTER_ELFMONSTER        = 161;
  MONSTER_ELFWARRIOR        = 162;
  //MAXMAGIC                  = 20;
  SUPREGUARD                = 11;
  CHICKEN                   = 51;
  DEER                      = 52;
  WOLF                      = 53;
  TRAINER                   = 55;

  ID_REGMAINFRM             = 1000;
  ID_REGHARDWAREEDIT        = 1001;
  ID_REGOKBUTTON            = 1002;
  ID_REGCLOSEBUTTON         = 1003;
  ID_REGIPADRESSEDIT        = 1004;
  ID_REGKEYEDIT             = 1005;
  ID_REGDAYSLEFTEDIT        = 1006;
  ID_REGTIMESLEFTEDIT       = 1007;
  ID_DATETIMEPICKER         = 1008;
  ID_REGSOFTINFOSTICK       = 1009;
  ID_REGKEYSTICK            = 1010;
  DTM_SETSYSTEMTIME         = $1000 + 2;

  sHumRun                   : array[0..2] of string = ('穿人穿怪模式', '穿怪模式', '穿人模式');
  g_sAttribArr              : array[1..5] of string = ('[金]', '[木]', '[水]', '[火]', '[土]');

  sMAN                      = 'MAN';
  sSUNRAISE                 = 'SUNRAISE';
  sDay                      = 'DAY';
  sSUNSET                   = 'SUNSET';
  sNIGHT                    = 'NIGHT';
  sWARRIOR                  = 'WARRIOR';
  sWIZARD                   = 'WIZARD';
  sTAOS                     = 'TAOIST';
  sSUN                      = 'SUN';
  sMON                      = 'MON';
  sTUE                      = 'TUE';
  sWED                      = 'WED';
  sTHU                      = 'THU';
  sFRI                      = 'FRI';
  sSAT                      = 'SAT';

  //脚本常量
  sCHECK                    = 'CHECK';
  nCHECK                    = 1;
  sRANDOM                   = 'RANDOM';
  nRANDOM                   = 2;
  sGENDER                   = 'GENDER';
  nGENDER                   = 3;
  sDAYTIME                  = 'DAYTIME';
  nDAYTIME                  = 4;
  sCHECKOPEN                = 'CHECKOPEN';
  nCHECKOPEN                = 5;
  sCHECKUNIT                = 'CHECKUNIT';
  nCHECKUNIT                = 6;
  sCHECKLEVEL               = 'CHECKLEVEL';
  nCHECKLEVEL               = 7;
  sCHECKJOB                 = 'CHECKJOB';
  nCHECKJOB                 = 8;
  sCHECKBBCOUNT             = 'CHECKBBCOUNT';
  nCHECKBBCOUNT             = 9;
  sSC_CHECKCURRENTDATE      = 'CHECKCURRENTDATE';
  nSC_CHECKCURRENTDATE      = 10;

  sCHECKITEM                = 'CHECKITEM';
  nCHECKITEM                = 20;
  sCHECKITEMW               = 'CHECKITEMW';
  nCHECKITEMW               = 21;
  sCHECKGOLD                = 'CHECKGOLD';
  nCHECKGOLD                = 22;
  sISTAKEITEM               = 'ISTAKEITEM';
  nISTAKEITEM               = 23;
  sCHECKDURA                = 'CHECKDURA';
  nCHECKDURA                = 24;
  sCHECKDURAEVA             = 'CHECKDURAEVA';
  nCHECKDURAEVA             = 25;
  sDAYOFWEEK                = 'DAYOFWEEK';
  nDAYOFWEEK                = 26;
  sHOUR                     = 'HOUR';
  nHOUR                     = 27;
  sMIN                      = 'MIN';
  nMIN                      = 28;
  sCHECKPKPOINT             = 'CHECKPKPOINT';
  nCHECKPKPOINT             = 29;
  sCHECKLUCKYPOINT          = 'CHECKLUCKYPOINT';
  nCHECKLUCKYPOINT          = 30;
  sCHECKMONMAP              = 'CHECKMONMAP';
  nCHECKMONMAP              = 31;
  sCHECKMONAREA             = 'CHECKMONAREA';
  nCHECKMONAREA             = 32;
  sCHECKHUM                 = 'CHECKHUM';
  nCHECKHUM                 = 33;
  sCHECKBAGGAGE             = 'CHECKBAGGAGE';
  nCHECKBAGGAGE             = 34;
  sEQUAL                    = 'EQUAL';
  nEQUAL                    = 35;
  sLARGE                    = 'LARGE';
  nLARGE                    = 36;
  sSMALL                    = 'SMALL';
  nSMALL                    = 37;
  sSC_CHECKMAGIC            = 'CHECKMAGIC';
  nSC_CHECKMAGIC            = 38;
  sSC_CHKMAGICLEVEL         = 'CHKMAGICLEVEL';
  nSC_CHKMAGICLEVEL         = 39;
  sSC_CHECKMONRECALL        = 'CHECKMONRECALL';
  nSC_CHECKMONRECALL        = 40;
  sSC_CHECKHORSE            = 'CHECKHORSE';
  nSC_CHECKHORSE            = 41;
  sSC_CHECKRIDING           = 'CHECKRIDING';
  nSC_CHECKRIDING           = 42;
  sSC_STARTDAILYQUEST       = 'STARTDAILYQUEST';
  nSC_STARTDAILYQUEST       = 45;
  sSC_CHECKDAILYQUEST       = 'CHECKDAILYQUEST';
  nSC_CHECKDAILYQUEST       = 46;
  sSC_RANDOMEX              = 'RANDOMEX';
  nSC_RANDOMEX              = 47;
  sCHECKNAMELIST            = 'CHECKNAMELIST';
  nCHECKNAMELIST            = 48;
  sSC_CHECKWEAPONLEVEL      = 'CHECKWEAPONLEVEL';
  nSC_CHECKWEAPONLEVEL      = 49;
  sSC_CHECKWEAPONATOM       = 'CHECKWEAPONATOM';
  nSC_CHECKWEAPONATOM       = 50;
  sSC_CHECKREFINEWEAPON     = 'CHECKREFINEWEAPON';
  nSC_CHECKREFINEWEAPON     = 51;
  sSC_CHECKWEAPONMCTYPE     = 'CHECKWEAPONMCTYPE';
  nSC_CHECKWEAPONMCTYPE     = 52;
  sSC_CHECKREFINEITEM       = 'CHECKREFINEITEM';
  nSC_CHECKREFINEITEM       = 53;
  sSC_HASWEAPONATOM         = 'HASWEAPONATOM';
  nSC_HASWEAPONATOM         = 54;
  sSC_ISGUILDMASTER         = 'ISGUILDMASTER';
  nSC_ISGUILDMASTER         = 55;
  sSC_CANPROPOSECASTLEWAR   = 'CANPROPOSECASTLEWAR';
  nSC_CANPROPOSECASTLEWAR   = 56;
  sSC_CANHAVESHOOTER        = 'CANHAVESHOOTER';
  nSC_CANHAVESHOOTER        = 57;
  sSC_CHECKFAME             = 'CHECKFAME';
  nSC_CHECKFAME             = 58;
  sSC_ISONCASTLEWAR         = 'ISONCASTLEWAR';
  nSC_ISONCASTLEWAR         = 59;
  sSC_ISONREADYCASTLEWAR    = 'ISONREADYCASTLEWAR';
  nSC_ISONREADYCASTLEWAR    = 60;
  sSC_ISCASTLEGUILD         = 'ISCASTLEGUILD';
  nSC_ISCASTLEGUILD         = 61;
  sSC_ISATTACKGUILD         = 'ISATTACKGUILD'; //是否为攻城方
  nSC_ISATTACKGUILD         = 63;
  sSC_ISDEFENSEGUILD        = 'ISDEFENSEGUILD'; //是否为守城方
  nSC_ISDEFENSEGUILD        = 65;
  sSC_CHECKSHOOTER          = 'CHECKSHOOTER';
  nSC_CHECKSHOOTER          = 66;
  sSC_CHECKSAVEDSHOOTER     = 'CHECKSAVEDSHOOTER';
  nSC_CHECKSAVEDSHOOTER     = 67;
  sSC_HASGUILD              = 'HAVEGUILD'; //是否加入行会
  nSC_HASGUILD              = 68;
  sSC_CHECKCASTLEDOOR       = 'CHECKCASTLEDOOR'; //检查城门
  nSC_CHECKCASTLEDOOR       = 69;
  sSC_CHECKCASTLEDOOROPEN   = 'CHECKCASTLEDOOROPEN'; //城门是否打开
  nSC_CHECKCASTLEDOOROPEN   = 70;
  sSC_CHECKPOS              = 'CHECKPOS';
  nSC_CHECKPOS              = 71;
  sSC_CANCHARGESHOOTER      = 'CANCHARGESHOOTER';
  nSC_CANCHARGESHOOTER      = 72;
  sSC_ISATTACKALLYGUILD     = 'ISATTACKALLYGUILD'; //是否为攻城方联盟行会
  nSC_ISATTACKALLYGUILD     = 73;
  sSC_ISDEFENSEALLYGUILD    = 'ISDEFENSEALLYGUILD'; //是否为守城方联盟行会
  nSC_ISDEFENSEALLYGUILD    = 74;
  sSC_TESTTEAM              = 'TESTTEAM';
  nSC_TESTTEAM              = 75;
  sSC_ISSYSOP               = 'ISSYSOP';
  nSC_ISSYSOP               = 76;
  sSC_ISADMIN               = 'ISADMIN';
  nSC_ISADMIN               = 77;
  sSC_CHECKBONUS            = 'CHECKBONUS';
  nSC_CHECKBONUS            = 78;
  sSC_CHECKMARRIAGE         = 'CHECKMARRIAGE';
  nSC_CHECKMARRIAGE         = 79;
  sSC_CHECKMARRIAGERING     = 'CHECKMARRIAGERING';
  nSC_CHECKMARRIAGERING     = 80;
  sSC_CHECKSIGNMAP          = 'CHECKSIGNMAP';
  nSC_CHECKSIGNMAP          = 81;
  sSC_CHECKRANGEMONCOUNTEX  = 'CHECKRANGEMONCOUNTEX';
  nSC_CHECKRANGEMONCOUNTEX  = 82;
  sSC_CHECKSTRINGLIST       = 'CHECKSTRINGLIST';
  nSC_CHECKSTRINGLIST       = 83;
  sSC_CHECKMISSION          = 'CHECKMISSION';
  nSC_CHECKMISSION          = 84;
  sSC_CHECKTITLE            = 'CHECKTITLE';
  nSC_CHECKTITLE            = 85;

  sSC_CHECKGMETERM          = 'CHECKGMETERM';
  nSC_CHECKGMETERM          = 100;
  sSC_CHECKOPENGME          = 'CHECKOPENGME';
  nSC_CHECKOPENGME          = 101;
  sSC_CHECKENTERGMEMAP      = 'CHECKENTERGMEMAP';
  nSC_CHECKENTERGMEMAP      = 102;
  sSC_CHECKSERVER           = 'CHECKSERVER';
  nSC_CHECKSERVER           = 103;
  sSC_ELARGE                = 'ELARGE';
  nSC_ELARGE                = 104;
  sSC_ESMALL                = 'ESMALL';
  nSC_ESMALL                = 105;
  sSC_CHECKGROUPCOUNT       = 'CHECKGROUPCOUNT';
  nSC_CHECKGROUPCOUNT       = 106;
  sSC_CHECKACCESSORY        = 'CHECKACCESSORY';
  nSC_CHECKACCESSORY        = 107;
  sSC_ONERROR               = 'ONERROR';
  nSC_ONERROR               = 108;
  sSC_CHECKARMOR            = 'CHECKARMOR';
  nSC_CHECKARMOR            = 109;
  sSC_CHECKGAMEGOLDDEAL     = 'CHECKGAMEGOLDDEAL';
  nSC_CHECKGAMEGOLDDEAL     = 110;
  sSC_CHECKGAMEDIAMOND      = 'CHECKGAMEDIAMOND';
  nSC_CHECKGAMEDIAMOND      = 111;
  sSC_CHECKGAMEGIRD         = 'CHECKGAMEGIRD';
  nSC_CHECKGAMEGIRD         = 112;
  sSC_CHECKMASTERONLINE     = 'CHECKMASTERONLINE';
  nSC_CHECKMASTERONLINE     = 113;
  sSC_CHECKDEARONLINE       = 'CHECKDEARONLINE';
  nSC_CHECKDEARONLINE       = 114;
  sSC_CHECKMASTERONMAP      = 'CHECKMASTERONMAP';
  nSC_CHECKMASTERONMAP      = 115;
  sSC_CHECKDEARONMAP        = 'CHECKDEARONMAP';
  nSC_CHECKDEARONMAP        = 116;
  sSC_CHECKPOSEISPRENTICE   = 'CHECKPOSEISPRENTICE';
  nSC_CHECKPOSEISPRENTICE   = 117;
  sSC_CHECKHEROCREDITPOINT  = 'CHECKHEROCREDITPOINT';
  nSC_CHECKHEROCREDITPOINT  = 118;
  sSC_CHECKDLGITEMADDVALUE  = 'CHECKDLGITEMADDVALUE';
  nSC_CHECKDLGITEMADDVALUE  = 119;
  sSC_CHECKDLGITEMTYPE      = 'CHECKDLGITEMTYPE';
  nSC_CHECKDLGITEMTYPE      = 120;
  sSC_CHECKDLGITEMNAME      = 'CHECKDLGITEMNAME';
  nSC_CHECKDLGITEMNAME      = 121;
  sSC_CHECKIPLEVEL          = 'CHECKIPLEVEL';
  nSC_CHECKIPLEVEL          = 122;
  sSC_CHECKPOSDLGITEMNAME   = 'CHECKPOSDLGITEMNAME';
  nSC_CHECKPOSDLGITEMNAME   = 123;
  sSC_GIVEOK                = 'GIVEOK';
  nSC_GIVEOK                = 124;
  sSC_CHECKMAPRANGEHUMANCOUNT = 'CHECKMAPRANGEHUMANCOUNT';
  nSC_CHECKMAPRANGEHUMANCOUNT = 125;
  SSC_UNWRAPNIMBUSITEM      = 'UNWRAPNIMBUSITEM';
  nSC_UNWRAPNIMBUSITEM      = 126;
  SSC_CHECKMAPNIMBUSCOUNT   = 'CHECKMAPNIMBUSCOUNT';
  nSC_CHECKMAPNIMBUSCOUNT   = 127;
  sSC_CHECKVENATIONLEVEL    = 'CHECKVENATIONLEVEL';
  nSC_CHECKVENATIONLEVEL    = 128;
  sSC_CHECKNIMBUSITEMCOUNT  = 'CHECKNIMBUSITEMCOUNT';
  nSC_CHECKNIMBUSITEMCOUNT  = 129;
  sSC_CHECKNIMBUS           = 'CHECKNIMBUS';
  nSC_CHECKNIMBUS           = 130;
  sSC_CHECKATTACKMODE       = 'CHECKATTACKMODE';
  nSC_CHECKATTACKMODE       = 131;
  sSC_CHECKESCORTINNEAR     = 'CHECKESCORTINNEAR';
  nSC_CHECKESCORTINNEAR     = 132;
  sSC_IsEscortIng           = 'ISESCORTING';
  nSC_IsEscortIng           = 133;

  sCHECKACCOUNTLIST         = 'CHECKACCOUNTLIST';
  nCHECKACCOUNTLIST         = 135;
  sCHECKIPLIST              = 'CHECKIPLIST';
  nCHECKIPLIST              = 136;
  //sSC_CHECKPOSENAME         = 'CHECKPOSENAME';
  //nSC_CHECKPOSENAME         = 137;
  sSC_CHECKPOSEDIR          = 'CHECKPOSEDIR';
  nSC_CHECKPOSEDIR          = 138;
  sSC_CHECKPOSELEVEL        = 'CHECKPOSELEVEL';
  nSC_CHECKPOSELEVEL        = 139;
  sSC_CHECKPOSEGENDER       = 'CHECKPOSEGENDER';
  nSC_CHECKPOSEGENDER       = 140;
  sSC_CHECKLEVELEX          = 'CHECKLEVELEX';
  nSC_CHECKLEVELEX          = 141;
  sSC_CHECKBONUSPOINT       = 'CHECKBONUSPOINT';
  nSC_CHECKBONUSPOINT       = 142;
  sSC_CHECKMARRY            = 'CHECKMARRY';
  nSC_CHECKMARRY            = 143;
  sSC_CHECKPOSEMARRY        = 'CHECKPOSEMARRY';
  nSC_CHECKPOSEMARRY        = 144;
  sSC_CHECKMARRYCOUNT       = 'CHECKMARRYCOUNT';
  nSC_CHECKMARRYCOUNT       = 145;
  sSC_CHECKMASTER           = 'CHECKMASTER';
  nSC_CHECKMASTER           = 146;
  sSC_HAVEMASTER            = 'HAVEMASTER';
  nSC_HAVEMASTER            = 147;
  sSC_CHECKPOSEMASTER       = 'CHECKPOSEMASTER';
  nSC_CHECKPOSEMASTER       = 148;
  sSC_POSEHAVEMASTER        = 'POSEHAVEMASTER';
  nSC_POSEHAVEMASTER        = 149;
  sSC_CHECKISMASTER         = 'CHECKISMASTER';
  nSC_CHECKISMASTER         = 150;
  sSC_CHECKPOSEISMASTER     = 'CHECKPOSEISMASTER';
  nSC_CHECKPOSEISMASTER     = 151;
  sSC_CHECKNAMEIPLIST       = 'CHECKNAMEIPLIST';
  nSC_CHECKNAMEIPLIST       = 152;
  sSC_CHECKACCOUNTIPLIST    = 'CHECKACCOUNTIPLIST';
  nSC_CHECKACCOUNTIPLIST    = 153;
  sSC_CHECKSLAVECOUNT       = 'CHECKSLAVECOUNT';
  nSC_CHECKSLAVECOUNT       = 154;
  sSC_CHECKCASTLEMASTER     = 'ISCASTLEMASTER';
  nSC_CHECKCASTLEMASTER     = 155;
  sSC_ISNEWHUMAN            = 'ISNEWHUMAN';
  nSC_ISNEWHUMAN            = 156;
  sSC_CHECKMEMBERTYPE       = 'CHECKMEMBERTYPE';
  nSC_CHECKMEMBERTYPE       = 157;
  sSC_CHECKMEMBERLEVEL      = 'CHECKMEMBERLEVEL';
  nSC_CHECKMEMBERLEVEL      = 158;
  sSC_CHECKGAMEGOLD         = 'CHECKGAMEGOLD';
  nSC_CHECKGAMEGOLD         = 159;
  sSC_CHECKGAMEPOINT        = 'CHECKGAMEPOINT';
  nSC_CHECKGAMEPOINT        = 160;
  sSC_CHECKNAMELISTPOSITION = 'CHECKNAMELISTPOSITION';
  nSC_CHECKNAMELISTPOSITION = 161;
  sSC_CHECKGUILDLIST        = 'CHECKGUILDLIST';
  nSC_CHECKGUILDLIST        = 162;
  sSC_CHECKRENEWLEVEL       = 'CHECKRENEWLEVEL';
  nSC_CHECKRENEWLEVEL       = 163;
  sSC_CHECKSLAVELEVEL       = 'CHECKSLAVELEVEL';
  nSC_CHECKSLAVELEVEL       = 164;
  sSC_CHECKSLAVENAME        = 'CHECKSLAVENAME';
  nSC_CHECKSLAVENAME        = 165;
  sSC_CHECKCREDITPOINT      = 'CHECKCREDITPOINT';
  nSC_CHECKCREDITPOINT      = 166;
  sSC_CHECKOFGUILD          = 'CHECKOFGUILD';
  nSC_CHECKOFGUILD          = 167;
  sSC_CHECKPAYMENT          = 'CHECKPAYMENT';
  nSC_CHECKPAYMENT          = 168;
  sSC_CHECKUSEITEM          = 'CHECKUSEITEM';
  nSC_CHECKUSEITEM          = 169;
  sSC_CHECKBAGSIZE          = 'CHECKBAGSIZE';
  nSC_CHECKBAGSIZE          = 170;
  sSC_CHECKLISTCOUNT        = 'CHECKLISTCOUNT';
  nSC_CHECKLISTCOUNT        = 171;
  sSC_CHECKDC               = 'CHECKDC';
  nSC_CHECKDC               = 172;
  sSC_CHECKMC               = 'CHECKMC';
  nSC_CHECKMC               = 173;
  sSC_CHECKSC               = 'CHECKSC';
  nSC_CHECKSC               = 174;
  sSC_CHECKHP               = 'CHECKHP';
  nSC_CHECKHP               = 175;
  sSC_CHECKMP               = 'CHECKMP';
  nSC_CHECKMP               = 176;
  sSC_CHECKITEMBOX          = 'CHECKITEMBOX';
  nSC_CHECKITEMBOX          = 177;
  sSC_ISHIGH                = 'ISHIGH';
  nSC_ISHIGH                = 178;
  sSC_ISDUPMODE             = 'ISDUPMODE';
  nSC_ISDUPMODE             = 179;
  sSC_CHECKITEMTYPE         = 'CHECKITEMTYPE';
  nSC_CHECKITEMTYPE         = 180;
  sSC_CHECKEXP              = 'CHECKEXP';
  nSC_CHECKEXP              = 181;
  sSC_CHECKCASTLEGOLD       = 'CHECKCASTLEGOLD';
  nSC_CHECKCASTLEGOLD       = 182;
  sSC_PASSWORDERRORCOUNT    = 'PASSWORDERRORCOUNT';
  nSC_PASSWORDERRORCOUNT    = 183;
  sSC_ISLOCKPASSWORD        = 'ISLOCKPASSWORD';
  nSC_ISLOCKPASSWORD        = 184;
  sSC_ISLOCKSTORAGE         = 'ISLOCKSTORAGE';
  nSC_ISLOCKSTORAGE         = 185;
  sSC_CHECKBUILDPOINT       = 'CHECKGUILDBUILDPOINT';
  nSC_CHECKBUILDPOINT       = 186;
  sSC_CHECKAURAEPOINT       = 'CHECKGUILDAURAEPOINT';
  nSC_CHECKAURAEPOINT       = 187;
  sSC_CHECKSTABILITYPOINT   = 'CHECKGUILDSTABILITYPOINT';
  nSC_CHECKSTABILITYPOINT   = 188;
  sSC_CHECKFLOURISHPOINT    = 'CHECKGUILDFLOURISHPOINT';
  nSC_CHECKFLOURISHPOINT    = 189;
  sSC_CHECKCONTRIBUTION     = 'CHECKCONTRIBUTION'; //贡献度
  nSC_CHECKCONTRIBUTION     = 190;
  sSC_CHECKRANGEMONCOUNT    = 'CHECKRANGEMONCOUNT'; //检查一个区域中有多少怪
  nSC_CHECKRANGEMONCOUNT    = 191;
  sSC_CHECKITEMADDVALUE     = 'CHECKITEMADDVALUE';
  nSC_CHECKITEMADDVALUE     = 192;
  sSC_CHECKINMAPRANGE       = 'CHECKINMAPRANGE';
  nSC_CHECKINMAPRANGE       = 193;
  sSC_CASTLECHANGEDAY       = 'CASTLECHANGEDAY';
  nSC_CASTLECHANGEDAY       = 194;
  sSC_CASTLEWARDAY          = 'CASTLEWARAY';
  nSC_CASTLEWARDAY          = 195;
  sSC_ONLINELONGMIN         = 'ONLINELONGMIN';
  nSC_ONLINELONGMIN         = 196;
  sSC_CHECKGUILDCHIEFITEMCOUNT = 'CHECKGUILDCHIEFITEMCOUNT';
  nSC_CHECKGUILDCHIEFITEMCOUNT = 197;
  sSC_CHECKNAMEDATELIST     = 'CHECKNAMEDATELIST';
  nSC_CHECKNAMEDATELIST     = 198;
  sSC_CHECKMAPHUMANCOUNT    = 'CHECKMAPHUMANCOUNT';
  nSC_CHECKMAPHUMANCOUNT    = 199;
  sSC_CHECKMAPMONCOUNT      = 'CHECKMAPMONCOUNT';
  nSC_CHECKMAPMONCOUNT      = 200;
  sSC_CHECKVAR              = 'CHECKVAR';
  nSC_CHECKVAR              = 201;
  sSC_CHECKSERVERNAME       = 'CHECKSERVERNAME';
  nSC_CHECKSERVERNAME       = 202;
  sSc_checkcastlewar        = 'CHECKCASTLEWAR';
  nSc_checkcastlewar        = 203;
  sCheckDiemon              = 'CHECKDIEMON';
  nCheckDiemon              = 204;
  scheckkillplaymon         = 'CHECKKILLPLAYMON';
  ncheckkillplaymon         = 205;
  sSC_CHECKMAGICNAME        = 'CHECKMAGICNAME';
  nSC_CHECKMAGICNAME        = 206;
  sSC_CHECKMAGICLEVEL       = 'CHECKMAGICLEVEL';
  nSC_CHECKMAGICLEVEL       = 207;
  sSC_CHEckISGROUPMASTER    = 'ISGROUPMASTER';
  nSC_CHEckISGROUPMASTER    = 208;
  sSC_CHECKISONMAP          = 'ISONMAP';
  nSC_CHECKISONMAP          = 209;
  sSC_CHECKRANDOMNO         = 'CHECKRANDOMNO';
  nSC_CHECKRANDOMNO         = 210;
  sSC_INSAFEZONE            = 'INSAFEZONE';
  nSC_INSAFEZONE            = 211;
  sSC_KILLBYHUM             = 'KILLBYHUM';
  nSC_KILLBYHUM             = 212;
  sSC_KILLBYMON             = 'KILLBYMON';
  nSC_KILLBYMON             = 213;
  sSC_CHECKMAPNAME          = 'CHECKMAPNAME';
  nSC_CHECKMAPNAME          = 214;
  sSC_CHECKONLINE           = 'CHECKONLINE';
  nSC_CHECKONLINE           = 215;
  sSC_OFFLINEPLAYERCOUNT    = 'OFFLINEPLAYERCOUNT';
  nSC_OFFLINEPLAYERCOUNT    = 216;
  sSC_CHECKHEROONLINE       = 'CHECKHEROONLINE';
  nSC_CHECKHEROONLINE       = 217;
  sSC_HAVEHERO              = 'HAVEHERO';
  nSC_HAVEHERO              = 218;
  sSC_CHECKHEROLEVEL        = 'CHECKHEROLEVEL';
  nSC_CHECKHEROLEVEL        = 219;
  sSC_CHECKHEROJOB          = 'CHECKHEROJOB';
  nSC_CHECKHEROJOB          = 220;
  sSC_CHECKHEROPKPOINT      = 'CHECKHEROPKPOINT';
  nSC_CHECKHEROPKPOINT      = 221;
  sSC_IsSameGuildOnMap      = 'ISSAMEGUILDONMAP';
  nSC_IsSameGuildOnMap      = 222;
  sSC_CHECKITEMLUCK         = 'CHECKITEMLUCK';
  nSC_CHECKITEMLUCK         = 223;
  sSC_CHECKLISTTEXT         = 'CHECKLISTTEXT';//检查文件是否包含指定文本 Development 2019-01-21
  nSC_CHECKLISTTEXT         = 224;



  //Action
  sSET                      = 'SET';
  nSet                      = 1;
  sTAKE                     = 'TAKE';
  nTAKE                     = 2;
  sSC_GIVE                  = 'GIVE';
  nSC_GIVE                  = 3;
  sTAKEW                    = 'TAKEW';
  nTAKEW                    = 4;
  sCLOSE                    = 'CLOSE';
  nCLOSE                    = 5;
  sRESET                    = 'RESET';
  nRESET                    = 6;
  sSETOPEN                  = 'SETOPEN';
  nSETOPEN                  = 7;
  sSETUNIT                  = 'SETUNIT';
  nSETUNIT                  = 8;
  sRESETUNIT                = 'RESETUNIT';
  nRESETUNIT                = 9;
  sBREAK                    = 'BREAK';
  nBREAK                    = 10;
  sTIMERECALL               = 'TIMERECALL';
  nTIMERECALL               = 11;
  sSC_PARAM1                = 'PARAM1';
  nSC_PARAM1                = 12;
  sSC_PARAM2                = 'PARAM2';
  nSC_PARAM2                = 13;
  sSC_PARAM3                = 'PARAM3';
  nSC_PARAM3                = 14;
  sSC_PARAM4                = 'PARAM4';
  nSC_PARAM4                = 15;
  sSC_EXEACTION             = 'EXEACTION';
  nSC_EXEACTION             = 16;
  sSC_WEBBROWSER            = 'WEBBROWSER';
  nSC_WEBBROWSER            = 17;
  sSC_TAKEON                = 'TAKEON';
  nSC_TAKEON                = 18;
  sMAPMOVE                  = 'MAPMOVE';
  nMAPMOVE                  = 19;
  sMAP                      = 'MAP';
  nMAP                      = 20;
  sTAKECHECKITEM            = 'TAKECHECKITEM';
  nTAKECHECKITEM            = 21;
  sMONGEN                   = 'MONGEN';
  nMONGEN                   = 22;
  sSC_MONGENP               = 'MONGENP';
  nSC_MONGENP               = 23;
  sMONCLEAR                 = 'MONCLEAR';
  nMONCLEAR                 = 24;
  sMOV                      = 'MOV';
  nMOV                      = 25;
  sINC                      = 'INC';
  nINC                      = 26;
  sDEC                      = 'DEC';
  nDEC                      = 27;
  sSUM                      = 'SUM';
  nSUM                      = 28;
  sBREAKTIMERECALL          = 'BREAKTIMERECALL';
  nBREAKTIMERECALL          = 29;
  sSC_SENDMSG               = 'SENDMSG';
  nSC_SENDMSG               = 30;
  sCHANGEMODE               = 'CHANGEMODE';
  nCHANGEMODE               = 31;
  sPKPOINT                  = 'PKPOINT';
  nPKPOINT                  = 32;
  sCHANGEXP                 = 'CHANGEXP';
  nCHANGEXP                 = 33;
  sSC_RECALLMOB             = 'RECALLMOB';
  nSC_RECALLMOB             = 34;
  sKICK                     = 'KICK';
  nKICK                     = 35;
  sSC_DIV                   = 'DIV';
  nSC_DIV                   = 36;
  sSC_MUL                   = 'MUL';
  nSC_MUL                   = 37;
  sSC_PERCENT               = 'PERCENT';
  nSC_PERCENT               = 38;
  sSC_SETSCTIMER            = 'SETSCTIMER';
  nSC_SETSCTIMER            = 39;
  sSC_KILLSCTIMER           = 'KILLSCTIMER';
  nSC_KILLSCTIMER           = 40;
  sSC_RECALLMOBEX           = 'RECALLMOBEX';
  nSC_RECALLMOBEX           = 41;
  sSC_READRANDOMSTR         = 'READRANDOMSTR';
  nSC_READRANDOMSTR         = 42;
  sSC_CHANGERANGEMONPOS     = 'CHANGERANGEMONPOS';
  nSC_CHANGERANGEMONPOS     = 43;
  sSC_OPENBOOK              = 'OPENBOOK';
  nSC_OPENBOOK              = 44;
  sSC_OPENBOX               = 'OPENBOX';
  nSC_OPENBOX               = 45;
  sSC_QUERYREFINEITEM       = 'QUERYREFINEITEM';
  nSC_QUERYREFINEITEM       = 46;
  sSC_AFFILIATEGUILD        = 'AFFILIATEGUILD';
  nSC_AFFILIATEGUILD        = 47;
  sSC_SETTARGETXY           = 'SETTARGETXY';
  nSC_SETTARGETXY           = 48;
  sSC_MAPMOVEHUMAN          = 'MAPMOVEHUMAN';
  nSC_MAPMOVEHUMAN          = 49;
  sMOVR                     = 'MOVR';
  nMOVR                     = 50;
  sEXCHANGEMAP              = 'EXCHANGEMAP';
  nEXCHANGEMAP              = 51;
  sRECALLMAP                = 'RECALLMAP';
  nRECALLMAP                = 52;
  sADDBATCH                 = 'ADDBATCH';
  nADDBATCH                 = 53;
  sBATCHDELAY               = 'BATCHDELAY';
  nBATCHDELAY               = 54;
  sBATCHMOVE                = 'BATCHMOVE';
  nBATCHMOVE                = 55;
  sPLAYDICE                 = 'PLAYDICE';
  nPLAYDICE                 = 56;
  sADDNAMELIST              = 'ADDNAMELIST';
  nADDNAMELIST              = 57;
  sDELNAMELIST              = 'DELNAMELIST';
  nDELNAMELIST              = 58;
  sADDGUILDLIST             = 'ADDGUILDLIST';
  nADDGUILDLIST             = 59;
  sDELGUILDLIST             = 'DELGUILDLIST';
  nDELGUILDLIST             = 60;
  sADDACCOUNTLIST           = 'ADDACCOUNTLIST';
  nADDACCOUNTLIST           = 61;
  sDELACCOUNTLIST           = 'DELACCOUNTLIST';
  nDELACCOUNTLIST           = 62;
  sADDIPLIST                = 'ADDIPLIST';
  nADDIPLIST                = 63;
  sDELIPLIST                = 'DELIPLIST';
  nDELIPLIST                = 64;
  sSC_RECALLPLAYER          = 'RECALLPLAYER';
  nSC_RECALLPLAYER          = 65;
  sSC_QUERYBAGITEMS         = 'QUERYBAGITEMS';
  nSC_QUERYBAGITEMS         = 66;
  sSC_SETATTRIBUTE          = 'SETATTRIBUTE';
  nSC_SETATTRIBUTE          = 67;
  sSC_CHANGEHEROPKPOINT     = 'CHANGEHEROPKPOINT';
  nSC_CHANGEHEROPKPOINT     = 68;
  sSC_CHANGEHEROEXP         = 'CHANGEHEROEXP';
  nSC_CHANGEHEROEXP         = 69;
  sSC_QUERYITEMDLG          = 'QUERYITEMDLG';
  nSC_QUERYITEMDLG          = 70;
  sSC_UPGRADEDLGITEM        = 'UPGRADEDLGITEM';
  nSC_UPGRADEDLGITEM        = 71;
  sSC_GETDLGITEMVALUE       = 'GETDLGITEMVALUE';
  nSC_GETDLGITEMVALUE       = 72;
  sSC_CHANGEIPLEVEL         = 'CHANGEIPLEVEL';
  nSC_CHANGEIPLEVEL         = 73;
  sSC_CHANGETRANPOINT       = 'CHANGETRANPOINT';
  nSC_CHANGETRANPOINT       = 74;
  sSC_TAKEDLGITEM           = 'TAKEDLGITEM';
  nSC_TAKEDLGITEM           = 75;
  sSC_ADDLINELIST           = 'ADDLINELIST';
  nSC_ADDLINELIST           = 76;
  sSC_DELLINELIST           = 'DELLINELIST';
  nSC_DELLINELIST           = 77;
  SSC_CREATEMAPNIMBUS       = 'CREATEMAPNIMBUS';
  nSC_CREATEMAPNIMBUS       = 78;
  sSC_CLEARMAPITEM          = 'CLEARMAPITEM';
  nSC_CLEARMAPITEM          = 79;
  sSC_ADDMAPROUTE           = 'ADDMAPROUTE';
  nSC_ADDMAPROUTE           = 80;
  sSC_DELMAPROUTE           = 'DELMAPROUTE';
  nSC_DELMAPROUTE           = 81;
  sSC_QUERYVALUE            = 'QUERYVALUE';
  nSC_QUERYVALUE            = 82;
  sSC_RELEASECOLLECTEXP     = 'RELEASECOLLECTEXP';
  nSC_RELEASECOLLECTEXP     = 83;
  sSC_RESETCOLLECTEXPSTATE  = 'RESETCOLLECTEXPSTATE';
  nSC_RESETCOLLECTEXPSTATE  = 84;
  sSC_GETSTRLENGTH          = 'GETSTRLENGTH';
  nSC_GETSTRLENGTH          = 85;
  sSC_CHANGEVENATIONLEVEL   = 'CHANGEVENATIONLEVEL';
  nSC_CHANGEVENATIONLEVEL   = 86;
  sSC_CHANGEVENATIONPOINT   = 'BREAKVENATIONPOINT';
  nSC_CHANGEVENATIONPOINT   = 87;
  sSC_CLEARVENATIONDATA     = 'CLEARVENATIONDATA';
  nSC_CLEARVENATIONDATA     = 88;
  sSC_CONVERTSKILL          = 'CONVERTSKILL';
  nSC_CONVERTSKILL          = 89;
  sSC_KILLSLAVENAME         = 'KILLSLAVENAME';
  nSC_KILLSLAVENAME         = 90;
  sSC_READRANDOMLINE        = 'READRANDOMLINE';
  nSC_READRANDOMLINE        = 91;
  sSC_SENDSCROLLMSG         = 'SENDSCROLLMSG';
  nSC_SENDSCROLLMSG         = 92;
  sSC_SETMERCHANTDLGIMGNAME = 'SETMERCHANTDLGIMGNAME';
  nSC_SETMERCHANTDLGIMGNAME = 93;
  sSC_RECALLHERO            = 'RECALLHERO';
  nSC_RECALLHERO            = 94;
  sSC_GETPOSENAME           = 'GETPOSENAME';
  nSC_GETPOSENAME           = 95;
  sSC_GIVEEX                = 'GIVEEX';
  nSC_GIVEEX                = 96;
  sSC_CONFERTITLE           = 'CONFERTITLE';
  nSC_CONFERTITLE           = 97;
  sSC_DEPRIVETITLE          = 'DEPRIVETITLE';
  nSC_DEPRIVETITLE          = 98;
  sSC_PLAYSOUND             = 'PLAYSOUND';
  nSC_PLAYSOUND             = 99;

  sGOQUEST                  = 'GOQUEST';
  nGOQUEST                  = 100;
  sENDQUEST                 = 'ENDQUEST';
  nENDQUEST                 = 101;
  sGOTO                     = 'GOTO';
  nGOTO                     = 102;
  sSC_HAIRCOLOR             = 'HAIRCOLOR';
  nSC_HAIRCOLOR             = 104;
  sSC_WEARCOLOR             = 'WEARCOLOR';
  nSC_WEARCOLOR             = 105;
  sSC_HAIRSTYLE             = 'HAIRSTYLE';
  nSC_HAIRSTYLE             = 106;
  sSC_MONRECALL             = 'MONRECALL';
  nSC_MONRECALL             = 107;
  sSC_HORSECALL             = 'HORSECALL';
  nSC_HORSECALL             = 108;
  sSC_HAIRRNDCOL            = 'HAIRRNDCOL';
  nSC_HAIRRNDCOL            = 109;
  sSC_RANDSETDAILYQUEST     = 'RANDSETDAILYQUEST';
  nSC_RANDSETDAILYQUEST     = 110;
  sSC_OPENGAMEGOLDDEAL      = 'OPENYBDEAL';
  nSC_OPENGAMEGOLDDEAL      = 111;
  sSC_QUERYGAMEGOLDDEAL     = 'QUERYYBDEAL';
  nSC_QUERYGAMEGOLDDEAL     = 112;
  sSC_REFINEWEAPON          = 'REFINEWEAPON';
  nSC_REFINEWEAPON          = 113;
  sSC_QUERYGAMEGOLDSELL     = 'QUERYYBSELL';
  nSC_QUERYGAMEGOLDSELL     = 114;
  sSC_CHANGEIPEXP           = 'CHANGEIPEXP';
  nSC_CHANGEIPEXP           = 115;
  sSC_GROUPMAPTING          = 'GROUPMAPTING';
  nSC_GROUPMAPTING          = 116;
  sSC_RECALLGROUPMEMBERS    = 'RECALLGROUPMEMBERS';
  nSC_RECALLGROUPMEMBERS    = 117;
  sSC_MAPTING               = 'MAPTING';
  nSC_MAPTING               = 118;
  sSC_WRITEWEAPONNAME       = 'WRITEWEAPONNAME';
  nSC_WRITEWEAPONNAME       = 119;
  sSC_DELAYGOTO             = 'DELAYGOTO';
  nSC_DELAYGOTO             = 120;
  sSC_ENABLECMD             = 'ENABLECMD';
  nSC_ENABLECMD             = 121;
  sSC_LINEMSG               = 'LINEMSG';
  nSC_LINEMSG               = 122;
  sSC_EVENTMSG              = 'EVENTMSG';
  nSC_EVENTMSG              = 123;
  sSC_SOUNDMSG              = 'SOUNDMSG';
  nSC_SOUNDMSG              = 124;

  sSC_SETMISSION            = 'SETMISSION';
  nSC_SETMISSION            = 125;
  sSC_CLEARMISSION          = 'CLEARMISSION';
  nSC_CLEARMISSION          = 126;

  sSC_MONPWR                = 'MONPWR';
  nSC_MONPWR                = 127;
  sSC_ENTER_OK              = 'ENTER_OK';
  nSC_ENTER_OK              = 128;
  sSC_ENTER_FAIL            = 'ENTER_FAIL';
  nSC_ENTER_FAIL            = 129;
  sSC_MONADDITEM            = 'MONADDITEM';
  nSC_MONADDITEM            = 130;
  sSC_CHANGEWEATHER         = 'CHANGEWEATHER';
  nSC_CHANGEWEATHER         = 131;
  sSC_CHANGEWEAPONATOM      = 'CHANGEWEAPONATOM';
  nSC_CHANGEWEAPONATOM      = 132;
  sSC_GETREPAIRCOST         = 'GETREPAIRCOST';
  nSC_GETREPAIRCOST         = 134;
  sSC_KILLHORSE             = 'KILLHORSE';
  nSC_KILLHORSE             = 133;
  sSC_REPAIRITEM            = 'REPAIRITEM';
  nSC_REPAIRITEM            = 135;
  sSC_USEREMERGENCYCLOSE    = 'USEREMERGENCYCLOSE';
  nSC_USEREMERGENCYCLOSE    = 138;
  sSC_BUILDGUILD            = 'BUILDGUILD';
  nSC_BUILDGUILD            = 139;
  sSC_GUILDWAR              = 'GUILDWAR';
  nSC_GUILDWAR              = 140;
  sSC_CHANGEUSERNAME        = 'CHANGEUSERNAME';
  nSC_CHANGEUSERNAME        = 141;
  sSC_CHANGEMONLEVEL        = 'CHANGEMONLEVEL';
  nSC_CHANGEMONLEVEL        = 142;
  sSC_DROPITEMMAP           = 'DROPITEMMAP';
  nSC_DROPITEMMAP           = 143;
  sSC_CLEARITEMMAP          = 'CLEARITEMMAP';
  nSC_CLEARITEMMAP          = 170;
  sSC_PROPOSECASTLEWAR      = 'PROPOSECASTLEWAR';
  nSC_PROPOSECASTLEWAR      = 144;
  sSC_FINISHCASTLEWAR       = 'FINISHCASTLEWAR';
  nSC_FINISHCASTLEWAR       = 145;
  sSC_MOVENPC               = 'MOVENPC';
  nSC_MOVENPC               = 146;
  sSC_SPEAK                 = 'SPEAK';
  nSC_SPEAK                 = 147;
  sSC_SENDCMD               = 'SENDCMD';
  nSC_SENDCMD               = 148;
  sSC_INCFAME               = 'INCFAME';
  nSC_INCFAME               = 149;
  sSC_DECFAME               = 'DECFAME';
  nSC_DECFAME               = 150;
  sSC_CAPTURECASTLEFLAG     = 'CAPTURECASTLEFLAG';
  nSC_CAPTURECASTLEFLAG     = 151;
  sSC_MAKESHOOTER           = 'MAKESHOOTER';
  nSC_MAKESHOOTER           = 153;
  sSC_KILLSHOOTER           = 'KILLSHOOTER';
  nSC_KILLSHOOTER           = 154;
  sSC_LEAVESHOOTER          = 'LEAVESHOOTER';
  nSC_LEAVESHOOTER          = 155;
  sSC_CHANGEMAPATTR         = 'CHANGEMAPATTR';
  nSC_CHANGEMAPATTR         = 157;
  sSC_RESETMAPATTR          = 'RESETMAPATTR';
  nSC_RESETMAPATTR          = 158;
  sSC_MAKECASTLEDOOR        = 'MAKECASTLEDOOR';
  nSC_MAKECASTLEDOOR        = 159;
  sSC_REPAIRCASTLEDOOR      = 'REPAIRCASTLEDOOR';
  nSC_REPAIRCASTLEDOOR      = 160;
  sSC_CHARGESHOOTER         = 'CHARGESHOOTER';
  nSC_CHARGESHOOTER         = 161;
  sSC_SETAREAATTR           = 'SETAREAATTR';
  nSC_SETAREAATTR           = 162;
  sSC_CLEARDELAYGOTO        = 'CLEARDELAYGOTO';
  nSC_CLEARDELAYGOTO        = 163;
  sSC_TESTFLAG              = 'TESTFLAG';
  nSC_TESTFLAG              = 164;
  sSC_APPLYFLAG             = 'APPLYFLAG';
  nSC_APPLYFLAG             = 165;
  sSC_PASTEFLAG             = 'PASTEFLAG';
  nSC_PASTEFLAG             = 166;
  sSC_GETBACKCASTLEGOLD     = 'GETBACKCASTLEGOLD';
  nSC_GETBACKCASTLEGOLD     = 167;
  sSC_GETBACKUPGITEM        = 'GETBACKUPGITEM';
  nSC_GETBACKUPGITEM        = 168;
  sSC_TINGWAR               = 'TINGWAR';
  nSC_TINGWAR               = 169;
  sSC_SAVEPASSWD            = 'SAVEPASSWD';
  nSC_SAVEPASSWD            = 171;
  sSC_CREATENPC             = 'CREATENPC';
  nSC_CREATENPC             = 172;
  sSC_TAKEBONUS             = 'TAKEBONUS';
  nSC_TAKEBONUS             = 173;
  sSC_SYSMSG                = 'SYSMSG';
  nSC_SYSMSG                = 174;
  sSC_LOADVALUE             = 'LOADVALUE';
  nSC_LOADVALUE             = 175;
  sSC_SAVEVALUE             = 'SAVEVALUE';
  nSC_SAVEVALUE             = 176;
  sSC_SAVELOG               = 'SAVELOG';
  nSC_SAVELOG               = 177;
  sSC_GETMARRIED            = 'GETMARRIED';
  nSC_GETMARRIED            = 178;
  sSC_DIVORCE               = 'DIVORCE';
  nSC_DIVORCE               = 189;
  sSC_CAPTURESAYING         = 'CAPTURESAYING';
  nSC_CAPTURESAYING         = 190;
  sSC_CANCELMARRIAGERING    = 'CANCELMARRIAGERING';
  nSC_CANCELMARRIAGERING    = 191;
  sSC_OPENUSERMARKET        = 'OPENUSERMARKET';
  nSC_OPENUSERMARKET        = 192;
  sSC_SETTYPEUSERMARKET     = 'SETTYPEUSERMARKET';
  nSC_SETTYPEUSERMARKET     = 193;
  sSC_CHECKSOLDITEMSUSERMARKET = 'CHECKSOLDITEMSUSERMARKET';
  nSC_CHECKSOLDITEMSUSERMARKET = 194;
  sSC_SETGMEMAP             = 'SETGMEMAP';
  nSC_SETGMEMAP             = 200;
  sSC_SETGMEPOINT           = 'SETGMEPOINT';
  nSC_SETGMEPOINT           = 201;
  sSC_SETGMETIME            = 'SETGMETIME';
  nSC_SETGMETIME            = 209;
  sSC_STARTNEWGME           = 'STARTNEWGME';
  nSC_STARTNEWGME           = 202;
  sSC_MOVETOGMEMAP          = 'MOVETOGMEMAP';
  mSC_MOVETOGMEMAP          = 203;
  sSC_FINISHGME             = 'FINISHGME';
  nSC_FINISHGME             = 204;
  sSC_CONTINUEGME           = 'CONTINUEGME';
  nSC_CONTINUEGME           = 205;
  sSC_SETGMEPLAYTIME        = 'SETGMEPLAYTIME';
  nSC_SETGMEPLAYTIME        = 206;
  sSC_SETGMEPAUSETIME       = 'SETGMEPAUSETIME';
  nSC_SETGMEPAUSETIME       = 207;
  sSC_SETGMELIMITUSER       = 'SETGMELIMITUSER';
  nSC_SETGMELIMITUSER       = 208;
  sSC_SETEVENTMAP           = 'SETEVENTMAP';
  nSC_SETEVENTMAP           = 210;
  sSC_RESETEVENTMAP         = 'RESETEVENTMAP';
  nSC_RESETEVENTMAP         = 211;
  sSC_TESTREFINEPOINTS      = 'TESTREFINEPOINTS';
  nSC_TESTREFINEPOINTS      = 220;
  sSC_RESETREFINEWEAPON     = 'RESETREFINEWEAPON';
  nSC_RESETREFINEWEAPON     = 221;
  sSC_TESTREFINEACCESSORIES = 'TESTREFINEACCESSORIES';
  nSC_TESTREFINEACCESSORIES = 222;
  sSC_REFINEACCESSORIES     = 'REFINEACCESSORIES';
  nSC_REFINEACCESSORIES     = 223;
  sSC_APPLYMONMISSION       = 'APPLYMONMISSION';
  nSC_APPLYMONMISSION       = 225;
  sSC_MAPMOVER              = 'MAPMOVER';
  nSC_MAPMOVER              = 226;
  sSC_ADDSTR                = 'ADDSTR';
  nSC_ADDSTR                = 227;
  sSC_SETEVENTDAMAGE        = 'SETEVENTDAMAGE';
  nSC_SETEVENTDAMAGE        = 228;
  sSC_FORMATSTR             = 'FORMATSTR';
  nSC_FORMATSTR             = 229;
  sSC_CLEARPATH             = 'CLEARPATH';
  nSC_CLEARPATH             = 230;
  sSC_ADDPATH               = 'ADDPATH';
  nSC_ADDPATH               = 231;
  sSC_APPLYPATH             = 'APPLYPATH';
  nSC_APPLYPATH             = 232;
  sSC_MAPSPELL              = 'MAPSPELL';
  nSC_MAPSPELL              = 233;
  sSC_GIVEEXP               = 'GIVEEXP';
  nSC_GIVEEXP               = 234;
  sSC_GROUPMOVE             = 'GROUPMOVE';
  nSC_GROUPMOVE             = 235;
  sSC_GIVEEXPMAP            = 'GIVEEXPMAP';
  nSC_GIVEEXPMAP            = 236;
  sSC_APPLYMONEX            = 'APPLYMONEX';
  nSC_APPLYMONEX            = 237;
  sSC_CLEARNAMELIST         = 'CLEARNAMELIST';
  nSC_CLEARNAMELIST         = 238;
  sSC_TINGCASTLEVISITOR     = 'TINGCASTLEVISITOR';
  nSC_TINGCASTLEVISITOR     = 239;
  sSC_MAKEHEALZONE          = 'MAKEHEALZONE';
  nSC_MAKEHEALZONE          = 240;
  sSC_MAKEDAMAGEZONE        = 'MAKEDAMAGEZONE';
  nSC_MAKEDAMAGEZONE        = 241;
  sSC_CLEARZONE             = 'CLEARZONE';
  nSC_CLEARZONE             = 242;
  sSC_READVALUESQL          = 'READVALUESQL';
  nSC_READVALUESQL          = 250;
  sSC_READSTRINGSQL         = 'READSTRINGSQL';
  nSC_READSTRINGSQL         = 255;
  sSC_WRITEVALUESQL         = 'WRITEVALUESQL';
  nSC_WRITEVALUESQL         = 251;
  sSC_INCVALUESQL           = 'INCVALUESQL';
  nSC_INCVALUESQL           = 252;
  sSC_DECVALUESQL           = 'DECVALUESQL';
  nSC_DECVALUESQL           = 253;
  sSC_UPDATEVALUESQL        = 'UPDATEVALUESQL';
  nSC_UPDATEVALUESQL        = 254;

  sSC_KILLSLAVE             = 'KILLSLAVE';
  nSC_KILLSLAVE             = 260;
  sSC_SETITEMEVENT          = 'SETITEMEVENT';
  nSC_SETITEMEVENT          = 261;
  sSC_REMOVEITEMEVENT       = 'REMOVEITEMEVENT';
  nSC_REMOVEITEMEVENT       = 262;
  sSC_RETURN                = 'RETURN';
  nSC_RETURN                = 263;
  sSC_CLEARCASTLEOWNER      = 'CLEARCASTLEOWNER';
  nSC_CLEARCASTLEOWNER      = 270;
  sSC_DISSOLUTIONGUILD      = 'DISSOLUTIONGUILD';
  nSC_DISSOLUTIONGUILD      = 271;
  sSC_CHANGEGENDER          = 'CHANGEGENDER';
  nSC_CHANGEGENDER          = 272;
  sSC_SETFAME               = 'SETFAME';
  nSC_SETFAME               = 273;
  sSC_SETOFFLINEFUNC        = 'SETOFFLINEFUNC';
  nSC_SETOFFLINEFUNC        = 274;
  sSC_GAMEDIAMOND           = 'GAMEDIAMOND';
  nSC_GAMEDIAMOND           = 275;
  sSC_GAMEGIRD              = 'GAMEGIRD';
  nSC_GAMEGIRD              = 276;
  sSC_BONUSABIL             = 'BONUSABIL';
  nSC_BONUSABIL             = 277;
  sSC_HEROSKILLLEVEL        = 'HEROSKILLLEVEL';
  nSC_HEROSKILLLEVEL        = 278;
  sSC_HEROCREDITPOINT       = 'HEROCREDITPOINT';
  nSC_HEROCREDITPOINT       = 279;
  sSC_CHANGEATTACKMODE      = 'CHANGEATTACKMODE';
  nSC_CHANGEATTACKMODE      = 280;

  sSC_CHANGEHEROLEVEL       = 'CHANGEHEROLEVEL';
  nSC_CHANGEHEROLEVEL       = 299;
  sSC_CHANGELEVEL           = 'CHANGELEVEL';
  nSC_CHANGELEVEL           = 300;
  sSC_MARRY                 = 'MARRY';
  nSC_MARRY                 = 301;
  sSC_UNMARRY               = 'UNMARRY';
  nSC_UNMARRY               = 302;
  sSC_GETMARRY              = 'GETMARRY';
  nSC_GETMARRY              = 303;
  sSC_GETMASTER             = 'GETMASTER';
  nSC_GETMASTER             = 304;
  sSC_CLEARSKILL            = 'CLEARSKILL';
  nSC_CLEARSKILL            = 305;
  sSC_DELNOJOBSKILL         = 'DELNOJOBSKILL';
  nSC_DELNOJOBSKILL         = 306;
  sSC_DELSKILL              = 'DELSKILL';
  nSC_DELSKILL              = 307;
  sSC_ADDSKILL              = 'ADDSKILL';
  nSC_ADDSKILL              = 308;
  sSC_SKILLLEVEL            = 'SKILLLEVEL';
  nSC_SKILLLEVEL            = 309;
  sSC_CHANGEPKPOINT         = 'CHANGEPKPOINT';
  nSC_CHANGEPKPOINT         = 310;
  sSC_CHANGEEXP             = 'CHANGEEXP';
  nSC_CHANGEEXP             = 311;
  sSC_CHANGEJOB             = 'CHANGEJOB';
  nSC_CHANGEJOB             = 312;
  sSC_MISSION               = 'MISSION';
  nSC_MISSION               = 313;
  sSC_MOBPLACE              = 'MOBPLACE';
  nSC_MOBPLACE              = 314;
  sSC_SETMEMBERTYPE         = 'SETMEMBERTYPE';
  nSC_SETMEMBERTYPE         = 315;
  sSC_SETMEMBERLEVEL        = 'SETMEMBERLEVEL';
  nSC_SETMEMBERLEVEL        = 316;
  sSC_GAMEGOLD              = 'GAMEGOLD';
  nSC_GAMEGOLD              = 317;
  sSC_AUTOADDGAMEGOLD       = 'AUTOADDGAMEGOLD';
  nSC_AUTOADDGAMEGOLD       = 318;
  sSC_AUTOSUBGAMEGOLD       = 'AUTOSUBGAMEGOLD';
  nSC_AUTOSUBGAMEGOLD       = 319;
  sSC_CHANGENAMECOLOR       = 'CHANGENAMECOLOR';
  nSC_CHANGENAMECOLOR       = 320;
  sSC_CLEARPASSWORD         = 'CLEARPASSWORD';
  nSC_CLEARPASSWORD         = 321;
  sSC_RENEWLEVEL            = 'RENEWLEVEL';
  nSC_RENEWLEVEL            = 322;
  sSC_KILLMONEXPRATE        = 'KILLMONEXPRATE';
  nSC_KILLMONEXPRATE        = 323;
  sSC_POWERRATE             = 'POWERRATE';
  nSC_POWERRATE             = 324;
  sSC_CHANGEMODE            = 'CHANGEMODE';
  nSC_CHANGEMODE            = 325;
  sSC_CHANGEPERMISSION      = 'CHANGEPERMISSION';
  nSC_CHANGEPERMISSION      = 326;
  sSC_KILL                  = 'KILL';
  nSC_KILL                  = 327;
  sSC_KICK                  = 'KICK';
  nSC_KICK                  = 328;
  sSC_BONUSPOINT            = 'BONUSPOINT';
  nSC_BONUSPOINT            = 329;
  sSC_RESTRENEWLEVEL        = 'RESTRENEWLEVEL';
  nSC_RESTRENEWLEVEL        = 330;
  sSC_DELMARRY              = 'DELMARRY';
  nSC_DELMARRY              = 331;
  sSC_DELMASTER             = 'DELMASTER';
  nSC_DELMASTER             = 332;
  sSC_MASTER                = 'MASTER';
  nSC_MASTER                = 333;
  sSC_UNMASTER              = 'UNMASTER';
  nSC_UNMASTER              = 334;
  sSC_CREDITPOINT           = 'CREDITPOINT';
  nSC_CREDITPOINT           = 335;
  sSC_CLEARNEEDITEMS        = 'CLEARNEEDITEMS';
  nSC_CLEARNEEDITEMS        = 336;
  sSC_CLEARMAKEITEMS        = 'CLEARMAKEITEMS';
  nSC_CLEARMAEKITEMS        = 337;
  sSC_SETSENDMSGFLAG        = 'SETSENDMSGFLAG';
  nSC_SETSENDMSGFLAG        = 338;
  sSC_UPGRADEITEMS          = 'UPGRADEITEM';
  nSC_UPGRADEITEMS          = 339;
  sSC_UPGRADEITEMSEX        = 'UPGRADEITEMEX';
  nSC_UPGRADEITEMSEX        = 340;
  sSC_MONGENEX              = 'MONGENEX';
  nSC_MONGENEX              = 341;
  sSC_CLEARMAPMON           = 'CLEARMAPMON';
  nSC_CLEARMAPMON           = 342;
  sSC_SETMAPMODE            = 'SETMPAMODE';
  nSC_SETMAPMODE            = 343;
  sSC_GAMEPOINT             = 'GAMEPOINT';
  nSC_GAMEPOINT             = 344;
  sSC_PKZONE                = 'PKZONE';
  nSC_PKZONE                = 345;
  sSC_RESTBONUSPOINT        = 'RESTBONUSPOINT';
  nSC_RESTBONUSPOINT        = 346;
  sSC_TAKECASTLEGOLD        = 'TAKECASTLEGOLD';
  nSC_TAKECASTLEGOLD        = 347;
  sSC_HUMANHP               = 'HUMANHP';
  nSC_HUMANHP               = 348;
  sSC_HUMANMP               = 'HUMANMP';
  nSC_HUMANMP               = 349;
  sSC_BUILDPOINT            = 'GUILDBUILDPOINT';
  nSC_BUILDPOINT            = 350;
  sSC_AURAEPOINT            = 'GUILDAURAEPOINT';
  nSC_AURAEPOINT            = 351;
  sSC_STABILITYPOINT        = 'GUILDSTABILITYPOINT';
  nSC_STABILITYPOINT        = 352;
  sSC_FLOURISHPOINT         = 'GUILDFLOURISHPOINT';
  nSC_FLOURISHPOINT         = 353;
  sSC_OPENMAGICBOX          = 'OPENITEMBOX' {'OPENMAGICBOX'};
  nSC_OPENMAGICBOX          = 354;
  sSC_SETRANKLEVELNAME      = 'SETRANKLEVELNAME';
  nSC_SETRANKLEVELNAME      = 355;
  sSC_GMEXECUTE             = 'GMEXECUTE';
  nSC_GMEXECUTE             = 356;
  sSC_GUILDCHIEFITEMCOUNT   = 'GUILDCHIEFITEMCOUNT';
  nSC_GUILDCHIEFITEMCOUNT   = 357;
  sSC_ADDNAMEDATELIST       = 'ADDNAMEDATELIST';
  nSC_ADDNAMEDATELIST       = 358;
  sSC_DELNAMEDATELIST       = 'DELNAMEDATELIST';
  nSC_DELNAMEDATELIST       = 359;
  sSC_MOBFIREBURN           = 'MOBFIREBURN';
  nSC_MOBFIREBURN           = 360;
  sSC_MESSAGEBOX            = 'MESSAGEBOX';
  nSC_MESSAGEBOX            = 361;
  sSC_SETSCRIPTFLAG         = 'SETSCRIPTFLAG'; //设置用于NPC输入框操作的控制标志
  nSC_SETSCRIPTFLAG         = 362;
  sSC_SETAUTOGETEXP         = 'SETAUTOGETEXP';
  nSC_SETAUTOGETEXP         = 363;
  sSC_VAR                   = 'VAR';
  nSC_VAR                   = 364;
  sSC_LOADVAR               = 'LOADVAR';
  nSC_LOADVAR               = 365;
  sSC_SAVEVAR               = 'SAVEVAR';
  nSC_SAVEVAR               = 366;
  sSC_CALCVAR               = 'CALCVAR';
  nSC_CALCVAR               = 367;
  sSC_CLEAREctype           = 'CLEARCOPYITEM';
  nSC_CLEAREctype           = 368;
  sSC_SETRANDOMNO           = 'SETRANDOMNO';
  nSC_SETRANDOMNO           = 369;
  sSC_CHATCOLOR             = 'CHATCOLOR';
  nSC_CHATCOLOR             = 370;
  sSC_CHATFONT              = 'CHATFONT';
  nSC_CHATFONT              = 371;
  sSC_GUILDMAPMOVE          = 'GUILDMAPMOVE';
  nSC_GUILDMAPMOVE          = 372;
  sSC_RECALLPNEUMA          = 'RECALLPNEUMA';
  nSC_RECALLPNEUMA          = 373;
  sSC_ADDGUILD              = 'ADDGUILD';
  nSC_ADDGUILD              = 374;
  sSC_REPAIRALL             = 'REPAIRALL';
  nSC_REPAIRALL             = 375;
  sSC_DELAYCALL             = 'DELAYCALL';
  nSC_DELAYCALL             = 376;
  sSC_OFFLINE               = 'OFFLINE';
  nSC_OFFLINE               = 380;
  sSC_STARTTAKEGOLD         = 'STARTTAKEGOLD';
  nSC_STARTTAKEGOLD         = 381;
  sSC_RECALLHeroEX          = 'RECALLPNEUMAEX';
  nSC_RECALLHeroEX          = 382;
  sSC_SETOFFLINE            = 'SETOFFLINEPLAY';
  nSC_SETOFFLINE            = 383;
  sSC_CREATEHERO            = 'CREATEHERO';
  nSC_CREATEHERO            = 384;
  sSC_DELETEHERO            = 'DELETEHERO';
  nSC_DELETEHERO            = 385;
  sSC_TAGMAPINFO            = 'TAGMAPINFO';
  nSC_TAGMAPINFO            = 386;
  sSC_TAGMAPMOVE            = 'TAGMAPMOVE';
  nSC_TAGMAPMOVE            = 387;
  sSC_CHANGEHEROJOB         = 'CHANGEHEROJOB';
  nSC_CHANGEHEROJOB         = 388;
  sSC_CLEARHEROSKILL        = 'CLEARHEROSKILL';
  nSC_CLEARHEROSKILL        = 389;
  sSC_NIMBUS                = 'NIMBUS';
  nSC_NIMBUS                = 390;
  sSC_ABILITYADD            = 'ABILITYADD';
  nSC_ABILITYADD            = 391;
  sSC_MONGENEX2             = 'STARTESCORT';
  nSC_MONGENEX2             = 392;
  sSC_MoveToEscort          = 'MOVETOESCORT';
  nSC_MoveToEscort          = 393;
  sSC_EscortFinish          = 'FINISHESCORT';
  nSC_EscortFinish          = 394;
  sSC_GiveUpEscort          = 'GIVEUPESCORT';
  NSC_GiveUpEscort          = 395;
  sSC_OFFLINEPLAY           = 'OFFLINEPLAYEX';
  nSC_OFFLINEPLAY           = 396;

  sSC_QUERYBINDITEM         = 'QUERYBINDITEM';
  nSC_QUERYBINDITEM         = 397;
  sSC_BINDRESUME            = 'RESUMEBINDITEM';
  nSC_BINDRESUME            = 398;
  sSC_UNBINDRESUME          = 'RESUMEUNBINDITEM';
  nSC_UNBINDRESUME          = 399;

  sCHECKUSERDATE            = 'CHECKUSERDATE';
  nCHECKUSERDATE            = 400;
  sADDUSERDATE              = 'ADDUSERDATE';
  nADDUSERDATE              = 401;
  sDELUSERDATE              = 'DELUSERDATE';
  nDELUSERDATE              = 402;
  sYCCALLMOB                = 'YCCALLMOB';
  nYCCALLMOB                = 403;
  sClearCodeList            = 'CLEARCODELIST';
  nClearCodeList            = 404;
  sCheckCodeList            = 'CHECKCODELIST';
  nCheckCodeList            = 405;
  sgroupmapmove             = 'GROUPMAPMOVE';
  ngroupmapmove             = 406;
  sthroughhum               = 'THROUGHHUM';
  nthroughhum               = 407;
  sSC_CREATEHEROEX          = 'CREATEHEROEX';
  nSC_CREATEHEROEX          = 408;

  sSC_STATUSRATE            = 'STATUSRATE';
  nSC_STATUSRATE            = 500;
  sSC_NAMECOLOR             = 'NAMECOLOR';
  nSC_NAMECOLOR             = 501;
  sSC_DETOXIFCATION         = 'DETOXIFCATION';
  nSC_DETOXIFCATION         = 502;

  sSC_OPENBIGDIALOGBOX      = 'SETBIGDIALOGBOX';  //使用NPC大对话框  Development 2019-01-14
  nSC_OPENBIGDIALOGBOX      = 503;



  sSL_SENDMSG               = '@@sendmsg';
  sSUPERREPAIR              = '@s_repair';
  sSUPERREPAIROK            = '~@s_repair';
  sSUPERREPAIRFAIL          = '@fail_s_repair';
  sREPAIR                   = '@repair';
  sREPAIROK                 = '~@repair';
  sBUY                      = '@buy';
  sSELL                     = '@sell';
  sMAKEDURG                 = '@makedrug';
  sPRICES                   = '@prices';
  sSTORAGE                  = '@storage';
  sGETBACK                  = '@getback';
  sUPGRADENOW               = '@upgradenow';
  sUPGRADEING               = '~@upgradenow_ing';
  sUPGRADEOK                = '~@upgradenow_ok';
  sUPGRADEFAIL              = '~@upgradenow_fail';
  sGETBACKUPGNOW            = '@getbackupgnow';
  sGETBACKUPGOK             = '~@getbackupgnow_ok';
  sGETBACKUPGFAIL           = '~@getbackupgnow_fail';
  sGETBACKUPGFULL           = '~@getbackupgnow_bagfull';
  sGETBACKUPGING            = '~@getbackupgnow_ing';
  sEXIT                     = '@exit';
  sBACK                     = '@back';
  sMAIN                     = '@main';
  sFAILMAIN                 = '~@main';
  sYBDEAL                   = '@ybdeal';
  sITEMMARKET               = '@ItemMarket';
  sGETMASTER                = '@@getmaster';
  sGETMARRY                 = '@@getmarry';
  sDEALGOLD                 = '@@dealgold';
  sUSEITEMNAME              = '@@useitemname';
  sOFFLINEMSG               = '@@offlinemsg';
  sMAKEPEUMA                = '@@RecallHero';
  sINPUTINTEGER             = '@@InPutInteger';
  sINPUTSTRING              = '@@InPutString';
  sREMOTEMUSIC              = '@@rmst://';
  sREMOTEMSG                = '@@http://';
  sCERATEHERO               = '@@BuHero';
  sCERATEHERO2              = '@@BuHeroEx';
  sRECALLPLAYER             = '@@RecallPlayer';
  sMDlgImgName              = '@MDlgImgName=';

  sBUILDGUILDNOW            = '@@buildguildnow';
  sSCL_GUILDWAR             = '@@guildwar';
  sDONATE                   = '@@donate';
  sREQUESTCASTLEWAR         = '@requestcastlewarnow';

  sCASTLENAME               = '@@castlename';
  sWITHDRAWAL               = '@@withdrawal';
  sRECEIPTS                 = '@@receipts';
  sOPENMAINDOOR             = '@openmaindoor';
  sCLOSEMAINDOOR            = '@closemaindoor';
  sREPAIRDOORNOW            = '@repairdoornow';
  sREPAIRWALLNOW1           = '@repairwallnow1';
  sREPAIRWALLNOW2           = '@repairwallnow2';
  sREPAIRWALLNOW3           = '@repairwallnow3';
  sHIREARCHERNOW            = '@hirearchernow';
  sHIREGUARDNOW             = '@hireguardnow';
  sHIREGUARDOK              = '@hireguardok';
  sMarket_Def               = 'Market_Def\';
  sNpc_def                  = 'Npc_def\';

  ///////////////////////////////////////////////////////////////////

  v_SERVERNAME              = 1;
  v_SERVERIP                = 2;
  v_WEBSITE                 = 3;
  v_BBSSITE                 = 4;
  v_CLIENTDOWNLOAD          = 5;
  v_QQ                      = 6;
  v_PHONE                   = 7;
  v_BANKACCOUNT0            = 8;
  v_BANKACCOUNT1            = 9;
  v_BANKACCOUNT2            = 10;
  v_BANKACCOUNT3            = 11;
  v_BANKACCOUNT4            = 12;
  v_BANKACCOUNT5            = 13;
  v_BANKACCOUNT6            = 14;
  v_BANKACCOUNT7            = 15;
  v_BANKACCOUNT8            = 16;
  v_BANKACCOUNT9            = 17;
  v_GAMEGOLDNAME            = 18;
  v_GAMEPOINTNAME           = 19;
  v_USERCOUNT               = 20;
  v_MACRUNTIME              = 21;
  v_SERVERRUNTIME           = 22;
  v_DATETIME                = 23;
  v_HIGHLEVELINFO           = 24;
  v_HIGHPKINFO              = 25;
  v_HIGHDCINFO              = 26;
  v_HIGHMCINFO              = 27;
  v_HIGHSCINFO              = 28;
  v_HIGHONLINEINFO          = 29;

  v_CURRENTMAPDESC          = 30;
  v_CURRENTMAP              = 31;
  v_CURRENTX                = 32;
  v_CURRENTY                = 33;
  v_GENDER                  = 34;
  v_H_GENDER                = 35;
  v_JOB                     = 36;
  v_H_JOB                   = 37;
  v_ABILITYADDPOINT0        = 38;
  v_ABILITYADDPOINT1        = 39;
  v_ABILITYADDPOINT2        = 40;
  v_ABILITYADDPOINT3        = 41;
  v_ABILITYADDPOINT4        = 42;
  v_ABILITYADDPOINT5        = 43;
  v_ABILITYADDPOINT6        = 44;
  v_ABILITYADDTIME0         = 45;
  v_ABILITYADDTIME1         = 46;
  v_ABILITYADDTIME2         = 47;
  v_ABILITYADDTIME3         = 48;
  v_ABILITYADDTIME4         = 49;
  v_ABILITYADDTIME5         = 50;
  v_ABILITYADDTIME6         = 51;

  v_USERNAME                = 52;
  v_DLGITEMNAME             = 53;
  v_RANDOMNO                = 54;

  v_DEALGOLDPLAY            = 55;
  v_MONKILLER               = 56;
  v_KILLER                  = 57;
  v_DECEDENT                = 58;
  v_RELEVEL                 = 59;
  v_H_RELEVEL               = 60;
  v_HUMANSHOWNAME           = 61;

  v_GUILDHUMCOUNT           = 62;
  v_GUILDNAME               = 63;
  v_RANKNAME                = 64;
  v_LEVEL                   = 65;
  v_GCEPAYMENT              = 66;
  v_COLLECTEXP              = 67;
  v_COLLECTIPEXP            = 68;
  v_GAINCOLLECTEXP          = 69;
  v_GAINCOLLECTIPEXP        = 70;
  v_HP                      = 71;
  v_MAXHP                   = 72;
  v_MP                      = 73;
  v_MAXMP                   = 74;
  v_AC                      = 75;
  v_MAXAC                   = 76;
  v_MAC                     = 77;
  v_MAXMAC                  = 78;
  v_DC                      = 79;
  v_MAXDC                   = 80;
  v_MC                      = 81;
  v_MAXMC                   = 82;
  v_SC                      = 83;
  v_MAXSC                   = 84;

  v_HIT                     = 85;
  v_SPD                     = 86;
  v_BONUSPOINT              = 87;
  v_BONUSABIL_AC            = 88;
  v_BONUSABIL_MAC           = 89;
  v_BONUSABIL_DC            = 90;
  v_BONUSABIL_MC            = 91;
  v_BONUSABIL_SC            = 92;
  v_BONUSABIL_HP            = 93;
  v_BONUSABIL_MP            = 94;
  v_BONUSABIL_HIT           = 95;
  v_BONUSABIL_SPD           = 96;
  v_BONUSABIL_X2            = 97;

  v_BONUSTICK_AC            = 98;
  v_BONUSTICK_MAC           = 99;
  v_BONUSTICK_DC            = 100;
  v_BONUSTICK_MC            = 101;
  v_BONUSTICK_SC            = 102;
  v_BONUSTICK_HP            = 103;
  v_BONUSTICK_MP            = 104;
  v_BONUSTICK_HIT           = 105;
  v_BONUSTICK_SPD           = 106;
  v_BONUSTICK_X2            = 107;

  v_EXP                     = 108;
  v_MAXEXP                  = 109;
  v_PKPOINT                 = 110;
  v_CREDITPOINT             = 111;
  v_HEROCREDITPOINT         = 112;
  v_HW                      = 113;
  v_MAXHW                   = 114;
  v_BW                      = 115;
  v_MAXBW                   = 116;
  v_WW                      = 117;
  v_MAXWW                   = 118;
  v_GOLDCOUNT               = 119;
  v_GAMEGOLD                = 120;
  v_NIMBUS                  = 121;
  v_H_NIMBUS                = 122;
  v_GAMEPOINT               = 123;
  v_GAMEDIAMOND             = 124;
  v_GAMEGIRD                = 125;
  v_HUNGER                  = 126;
  v_LOGINTIME               = 127;
  v_LOGINLONG               = 128;
  v_DRESS                   = 129;
  v_WEAPON                  = 130;
  v_RIGHTHAND               = 131;
  v_HELMET                  = 132;
  v_HELMETEX                = 133;
  v_NECKLACE                = 134;
  v_RING_R                  = 135;
  v_RING_L                  = 136;
  v_ARMRING_R               = 137;
  v_ARMRING_L               = 138;
  v_BUJUK                   = 139;
  v_BELT                    = 140;
  v_BOOTS                   = 141;
  v_CHARM                   = 142;
  v_IPADDR                  = 143;
  v_IPLOCAL                 = 144;
  v_GUILDBUILDPOINT         = 145;
  v_GUILDAURAEPOINT         = 146;
  v_GUILDSTABILITYPOINT     = 147;
  v_GUILDFLOURISHPOINT      = 148;
  v_REQUESTCASTLEWARITEM    = 149;
  v_REQUESTCASTLEWARDAY     = 150;
  v_REQUESTBUILDGUILDITEM   = 151;
  v_OWNERGUILD              = 152;
  v_CASTLENAME              = 153;
  v_LORD                    = 154;
  v_GUILDWARFEE             = 155;
  v_BUILDGUILDFEE           = 156;
  v_CASTLEWARDATE           = 157;
  v_LISTOFWAR               = 158;
  v_CASTLECHANGEDATE        = 159;
  v_CASTLEWARLASTDATE       = 160;
  v_CASTLEGETDAYS           = 161;
  v_CMD_DATE                = 162;
  v_CMD_ALLOWMSG            = 163;
  v_CMD_LETSHOUT            = 164;
  v_CMD_LETTRADE            = 165;
  v_CMD_LETGUILD            = 166;
  v_CMD_ENDGUILD            = 167;
  v_CMD_BANGUILDCHAT        = 168;
  v_CMD_AUTHALLY            = 169;
  v_CMD_AUTH                = 170;
  v_CMD_AUTHCANCEL          = 171;
  v_CMD_USERMOVE            = 172;
  v_CMD_SEARCHING           = 173;
  v_CMD_ALLOWGROUPCALL      = 174;
  v_CMD_GROUPRECALLL        = 175;
  v_CMD_ATTACKMODE          = 176;
  v_CMD_REST                = 177;
  v_CMD_STORAGESETPASSWORD  = 178;
  v_CMD_STORAGECHGPASSWORD  = 179;
  v_CMD_STORAGELOCK         = 180;
  v_CMD_STORAGEUNLOCK       = 181;
  v_CMD_UNLOCK              = 182;

  v_ROBBER                  = 183;
  v_MEMBRETYPE              = 184;
  v_MEMBRELEVEL             = 185;

  v_DRUM                    = 186;
  v_HORSE                   = 187;
  v_FASHION                 = 188;
  v_HWID                    = 189;

type
  TItemBind = record
    nMakeIdex: Integer;
    nItemIdx: Integer;
    sBindName: string[20];
  end;
  pTItemBind = ^TItemBind;
  TConsoleData = packed record
    nCrcExtInt: Integer;
    nCrcDllInt: Integer;
  end;
  pTConsoleData = ^TConsoleData;
{$IF OEMVER = OEM775}
  TLevelInfo = record
    wHP: Word;
    wMP: Word;
    dwExp: LongWord;
    wAC: Word;
    wMaxAC: Word;
    wACLimit: Word;
    wMAC: Word;
    wMaxMAC: Word;
    wMACLimit: Word;
    wDC: Word;
    wMaxDC: Word;
    wDCLimit: Word;
    dwDCExp: LongWord;
    wMC: Word;
    wMaxMC: Word;
    wMCLimit: Word;
    dwMCExp: LongWord;
    wSC: Word;
    wMaxSC: Word;
    wSCLimit: Word;
    dwSCExp: LongWord;
  end;
{$IFEND}

function GetExVersionNO(nVersionDate: Integer; var nOldVerstionDate: Integer): Integer;
function GetNextDirection(sX, sY, dx, dy: Integer): Byte;
function GetGoldShape(nGold: Integer): Word; //金币在地上显示的外形ID
procedure SetProcessName(sName: string);
procedure CopyStdItemToOStdItem(StdItem: pTStdItem; OStdItem: pTOStdItem);
procedure InitPlugArrayTable();
function AddToProcTable(ProcAddr: Pointer; sProcName: string): Boolean;
function AddToPulgProcTable(sProcName: string): Integer;
function AddToObjTable(Obj: TObject; sObjName: string): Boolean;
function LoadLineNotice(FileName: string): Boolean;
function GetMultiServerAddrPort(btSrvIdx: Byte; var sIPaddr: string; var nPort: Integer): Boolean;
procedure MainOutMessageAPI(Msg: string);
function AddDateTimeOfDay(DateTime: TDateTime; nDay: Integer): TDateTime;
function GetRandomLook(nBaseLook, nRage: Integer): Integer;
function FilterCharName(sName: string): string;
function CheckGuildName(sGuildName: string): Boolean;
function CheckUserItems(nIdx{$IF VER_ClientType_45}, nType{$IFEND VER_ClientType_45}: Integer; StdItem: pTStdItem): Boolean;
function GetItemNumber(): Integer;
function GetItemNumberEx(): Integer;
function GetNearPosition(nDir, nRage: Integer): Byte;
function GetValNameNo(sText: string): Integer;
function IsUseItem(nIndex: Integer): Boolean;
function GetMakeItemInfo(sItemName: string): TStringList;
function GetBoxItemInfoByIndx(nItemShape: Integer): TList;
function GetBoxItemInfoByName(sItemName: string): TList;
function GetRefineItemList(sItemName1, sItemName2, sItemName3: string): TList;
procedure AddLogonCostLog(sMsg: string);
procedure AddGameDataLogAPI(sMsg: string);
function GetGameGoldNameAPI(): string;
procedure TrimStringList(sList: TStringList);
function CanMoveMap(sMapName: string): Boolean;
function LoadMonSayMsg(): Boolean;
function LoadAllowBindNameList(): Boolean;

function GetDigItemByName(sMAP: string): PTDigItemLists;
function LoadDigItemList(bReload: Boolean = False): Boolean;
function LoadQFLableList(): Boolean;
function LoadDisableTreasureIdentifyList(): Boolean;

function LoadItemBindIPaddr(): Boolean;
function SaveItemBindIPaddr(): Boolean;
function LoadItemBindAccount(): Boolean;
function SaveItemBindAccount(): Boolean;
function LoadItemBindCharName(): Boolean;
function SaveItemBindCharName(): Boolean;
function SaveAdminList(): Boolean;
function LoadUnMasterList(): Boolean;
function SaveUnMasterList(): Boolean;
function LoadUnForceMasterList(): Boolean;
function SaveUnForceMasterList(): Boolean;
function LoadDisableMoveMap(): Boolean;
function LoadMissionList(): Integer;
function GetMissionSendMsg(sid: string; nStep: Integer; var nClass: Integer): string;

function SaveDisableMoveMap(): Boolean;
function GetUseItemName(nIndex: Integer): string;
function GetUseItemIdx(sName: string): Integer;
function LoadMonDropLimitList(): Boolean;
function SaveMonDropLimitList(): Boolean;
function LoadGuildRankNameFilterList(): Boolean;
procedure SaveGuildRankNameFilterList();
function IsInGuildRankNameFilterList(sWord: string): Boolean;
function LoadDisableSendMsgList(): Boolean;
function SaveDisableSendMsgList(): Boolean;
function GetDisableSendMsgList(sHumanName: string): Boolean;
function LoadGameLogItemNameList(): Boolean;
function GetGameLogItemNameList(sItemName: string): Byte;
function SaveGameLogItemNameList(): Boolean;
function LoadDenyIPAddrList(): Boolean;
function GetDenyIPaddrList(sIPaddr: string): Boolean;
function SaveDenyIPAddrList(): Boolean;
function LoadDenyAccountList(): Boolean;
function GetDenyAccountList(sAccount: string): Boolean;
function SaveDenyAccountList(): Boolean;
function LoadDenyChrNameList(): Boolean;
function GetDenyChrNameList(sChrName: string): Boolean;
function SaveDenyChrNameList(): Boolean;
function LoadNoClearMonList(): Boolean;
function GetNoClearMonList(sMonName: string): Boolean;
function SaveNoClearMonList(): Boolean;
function LoadHintItemList(): Boolean;
procedure InitVariablesList();
procedure LoadExp();
procedure LoadGameCommand();
procedure LoadString();
procedure LoadConfig();
function GetRGB(c256: Byte): TColor; stdcall;
procedure SendGameCenterMsg(wIdent: Word; sSENDMSG: string);
function GetIPLocal(sIPaddr: string): string;
function GetResourceString(sType: TStrType): string;
function IsCheapStuff(tByte: Byte): Boolean;
function CompareIPaddr(sIPaddr, dIPaddr: string): Boolean;
//function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: Byte): Integer;
//function MakeMonsterFeature(btRaceImg, btWeapon: Byte; wAppr: Word): Integer;
procedure LoadUserCmdList();
procedure SaveUserCmdList();
procedure LoadPetPickItemList();
procedure SavePetPickItemList();
function IsInPetPickItemList(sItemName: string): Boolean;
procedure LoadUpgradeItemList();
procedure SaveUpgradeItemList();
function IsInUpgradeItemList(sItemName: string): Boolean;
function LoadItemLimitList(): Boolean;
procedure SaveItemLimitList();
function InLimitItemList(sItemName: string; nItemIdx: Integer; nType: TItemType): Boolean;

procedure UnInitSaleItemList();
procedure LoadUserBuyItemList();
function GetSaleItemByName(sItemName: string): pTSaleItem;

procedure LoadShopItemList();
function GetShopItemByName(sItemName: string): pTShopItem;
function GetShopItemByType(nItemType: Integer): pTShopItem;
procedure BindItemCharName(nItemIdx, nMakeIdex: Integer; sBindName: string);
procedure BindItemAccount(nItemIdx, nMakeIdex: Integer; sBindName: string);

function GetLocalIP(): string;
function CheckChrName(sChrName: string): Boolean;
procedure InitUserDataList();
procedure UnInitUserDataList();
procedure LoadUserDataList();
procedure SaveUserDataList();
function GetUserDataList(sName: string): pTMakerMap;

procedure InitSuiteItemsList();
procedure UnInitSuiteItemsList();
procedure LoadSuiteItemsList();
function GetSuiteItems(StdItem: pTStdItem): Boolean;
function DecodeStringPassword(var src: string; Key: Integer): string;
procedure SetGatherExpItem(StdItem: pTStdItem; UserItem: pTUserItem);
function GetUnbindItemName(nShape: Integer): string;

function LoadAutoLogin(): Boolean;
function LoadDeathWalkingSays(): Boolean;

procedure GetSendClientItem(const UserItem: pTUserItem; const Player: TPlayObject; var ClientItem: TClientItem);

function GetStdPosType(std, Pos: Integer): Byte;
function GetItemEvaInfo(UserItem: pTUserItem; var Eva: TEvaluation): Byte;
function SetItemEvaInfo(UserItem: pTUserItem; EvaType: TEvaValTpye; v: Byte; Abil: array of TEvaAbil): Byte;
function GetItemSecretProperty(UserItem: pTUserItem; var Abil: array of TEvaAbil): Byte;
function CheckTIType(btType, btStdMode: Byte): Boolean;

function UseItemSpiritQuality(UserItem: pTUserItem; var nRet: Byte): Byte;

procedure MakeTitleSendBuffer();
function GetTitleTime(Title: THumTitle): Integer;

function AddBlockUser(szUserName: string): Boolean;

var
  g_VCLZip1                 : TVCLZip;
  g_boLimitLevelExp         : Boolean = False;



  ENDYEARMIN                : PInteger;
  ENDMONTHMIN               : PInteger;
  ENDDAYMIN                 : PInteger;

  ENDYEAR                   : PInteger;
  ENDMONTH                  : PInteger;
  ENDDAY                    : PInteger;

  MonDropClearTime          : Integer;
  g_PowerBlock              : TPowerBlock = (
    $55, $8B, $EC, $83, $C4, $E8, $89, $55, $F8, $89, $45, $FC, $C7, $45, $EC, $64,
    $00, $00, $00, $C7, $45, $E8, $64, $00, $00, $00, $DB, $45, $EC, $DB, $45, $E8,
    $DE, $F9, $DB, $45, $FC, $DE, $C9, $DD, $5D, $F0, $9B, $8B, $45, $F8, $8B, $00,
    $8B, $55, $F8, $89, $02, $DD, $45, $F0, $8B, $E5, $5D, $C3, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00
    );
  RemoteXORKey              : Integer = -1;
  LocalXORKey               : Integer = -2;
  M2ServerVersion           : Single = 2;
  g_dwGameCenterHandle      : THandle;
  IsDebuggerPresent         : function(): Boolean; stdcall;
  nCheckVersion             : Integer = -1;
{$IF OEMVER = OEM775}
  Level775                  : TIniFile;
{$IFEND}
  Config                    : TIniFile;
  CommandConf               : TIniFile;
  StringConf                : TIniFile;
  g_UserDataList            : TGList;
  g_SuiteItemsList          : TList;

  g_pcsiLen                 : Integer = 0;
  g_pcsi                    : Pointer = nil;

  g_TitlesBuffLen           : Integer = 0;
  g_TitlesBuff              : Pointer = nil;

  g_HintItemList            : TCnHashTableSmall;
  g_VariablesList           : TCnHashTableSmall = nil;
  g_MainMemo                : TMemo;
  ProcArray                 : TProcArray;
  ObjectArray               : TObjectArray;
  PlugProcArray             : TProcArray;
  PlugInEngine              : TPlugInManage;
  g_nServerIndex            : Integer = 0;
  g_nShareFileNameNum       : Integer = 1;
  g_nServerTickDifference   : LongWord;
  RunSocket                 : TRunSocket;
  MainLogMsgList            : TStringList;
  LogStringList             : TStringList;
  LogonCostLogList          : TStringList;
  g_MapManager              : TMapManager;
  ItemUnit                  : TItemUnit;
  MagicManager              : TMagicManager;
  NoticeManager             : TNoticeManager;
  g_GuildManager            : TGuildManager;
  g_EventManager            : TEventManager;
  g_CastleManager           : TCastleManager;
  //g_GuildTerritory          : TGTManager;
  g_StartPointManager       : TStartPointManager;
  FrontEngine               : TFrontEngine;
  UserEngine                : TUserEngine;
  //UserMgrEngine             : TUserMgrEngine;

  g_AutoLoginList           : TStringList;
  g_DeathWalkingSays        : TStringList;
  g_InitAutoLogin           : Boolean = False;

  g_RobotManage             : TRobotManage;
  g_BaseObject              : TBaseObject;
  g_MakeItemList            : TStringList;
  g_BoxItemList             : TStringList;
  g_DigItemList             : TStringList;
  g_QFLabelList             : TCnHashTableSmall = nil;
  g_DisTIList               : TCnHashTableSmall = nil;

  g_RefineItemList          : TStringList;
  g_RedStartPoint           : TStartPoint;
  //g_ServerTableList         : TList;
  g_RouteInfo               : array[0..19] of TRouteInfo;
  g_DenySayMsgList          : TQuickList;
  g_SayMsgList              : TStringList;
  g_nSayMsgIdx              : Integer;
  MiniMapList               : TStringList;
  g_UnbindList              : TStringList;
  LineNoticeList            : TStringList;
  QuestDiaryList            : TList;
  ItemEventList             : TStringList;
  AbuseTextList             : TStringList;
  g_MonSayMsgList           : THStringlist;
  g_DisableMoveMapList      : TGStringList;
  g_MissionList             : array[1..4] of TStringList;

  //g_DigItemList             : array[0..4] of TList;

  g_ItemNameList            : TGList;
  g_DisableSendMsgList      : TGStringList;
  g_MonDropLimitLIst        : TGStringList;
  g_GuildRankNameFilterList : TGStringList;
  g_AllowBindNameList       : THStringlist;

  //g_MapEventList            : TGList;
  g_ItemLimitList           : TGList;
  g_ItemBindIPaddr          : TGList;
  g_ItemBindAccount         : TGList;
  g_ItemBindCharName        : TGList;
  g_SaleItemList            : TGList;
  g_ShopItemList            : TGList;
  g_PetPickItemList         : TGStringList;
  g_UpgradeItemList         : TGStringList;
  g_UserCmdList             : TGStringList;
  g_UnMasterList            : TGStringList;
  g_UnForceMasterList       : TGStringList;
  g_GameLogItemNameList     : TGStringList;
  g_boGameLogGold           : Boolean;
  g_boGameLogGameGold       : Boolean;
  g_boGameLogGamePoint      : Boolean;
  g_boGameLogHumanDie       : Boolean;
  g_boHeroPickupGold        : Boolean;
  g_DenyIPAddrList          : TGStringList;
  g_DenyChrNameList         : TGStringList;
  g_DenyAccountList         : TGStringList;
  g_NoClearMonList          : TGStringList;
  g_DecorationList          : TList;

  g_xBlockUserList          : TStringList;
  g_BlockUserLock           : TRTLCriticalSection;

  n4EBBD0                   : Integer;
  g_CheckCode               : TCheckCode;
  g_nIdent                  : Integer;
  g_ProcessMsg              : TProcessMessage;
  LogMsgCriticalSection     : TRTLCriticalSection;
  ProcessMsgCriticalSection : TRTLCriticalSection; //0428
  UserDBSection             : TRTLCriticalSection;
  ProcessHumanCriticalSection: TRTLCriticalSection;
  USInterMsgCriticalSection : TRTLCriticalSection;
  SQLCriticalSection        : TRTLCriticalSection;
  //NPCListCS                 : TRTLCriticalSection;

  g_nTotalHumCount          : Integer;
  g_boMission               : Boolean;
  g_sMissionMap             : string;
  g_nMissionX               : Integer;
  g_nMissionY               : Integer;
  boStartReady              : Boolean;
  g_boExitServer            : Boolean;
  boFilterWord              : Boolean;
  sLogFileName              : string;
  nRunTimeMin               : Integer;
  nRunTimeMax               : Integer;
  g_nBaseObjTimeMin         : Integer;
  g_nBaseObjTimeMax         : Integer;
  g_nSockCountMin           : Integer;
  g_nSockCountMax           : Integer;
  g_nUsrTimeMin             : Integer;
  g_nUsrTimeMax             : Integer;
  g_nHumCountMin            : Integer;
  g_nHumCountMax            : Integer;
  g_nMonTimeMin             : Integer;
  g_nMonTimeMax             : Integer;
  g_nMonGenTime             : Integer;
  g_nMonGenTimeMin          : Integer;
  g_nMonGenTimeMax          : Integer;
  g_nMonProcTime            : Integer;
  g_nMonProcTimeMin         : Integer;
  g_nMonProcTimeMax         : Integer;
  dwUsrRotCountMin          : Integer;
  dwUsrRotCountMax          : Integer;

  g_dwUsrRotCountTick       : LongWord;
  g_nProcessHumanLoopTime   : Integer;
  g_dwHumLimit              : LongWord = 30;
  g_dwMonLimit              : LongWord = 30;
  g_dwZenLimit              : LongWord = 5;
  g_dwNpcLimit              : LongWord = 5;
  g_dwSocLimit              : LongWord = 10;
  g_dwSocCheckTimeOut       : LongWord = 50;
  nDecLimit                 : Integer = 20;

{$IF OEMVER = OEM775}
  sConfig775FileName        : string = '.\775.txt';
{$IFEND}
  sConfigFileName           : string = '.\!Setup.txt';
  sExpConfigFileName        : string = '.\Exps.ini';
  sCommandFileName          : string = '.\Command.ini';
  sStringFileName           : string = '.\String.ini';

  dwRunDBTimeMax            : LongWord;
  g_dwStartTick             : LongWord;
  g_dwRunTick               : LongWord;
  g_nRunTimes               : Integer;
  g_nGameTime               : Integer;
  g_Time                    : Single;

  g_sMonGenInfo1            : string;
  g_sMonGenInfo2            : string;
  g_sProcessName            : string;
  g_sOldProcessName         : string;
  g_ManageNPC               : TNormNpc;
  g_RobotNPC                : TNormNpc;
  g_FunctionNPC             : TMerchant; //TQFunction
  g_MapEventNPC             : TMerchant;
  g_DynamicVarList          : TList;
  nCurrentMonthly           : Integer;
  nTotalTimeUsage           : Integer;
  nLastMonthlyTotalUsage    : Integer;
  nGrossTotalCnt            : Integer;
  nGrossResetCnt            : Integer;
  //g_sRemovedIP              : string;
  //g_boDBSConnected          : Boolean = False;

  ColorTable                : array[0..255] of TRGBQuad;
  ColorArray                : array[0..1023] of Byte = (
    $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $80, $80, $00,
    $80, $00, $00, $00, $80, $00, $80, $00, $80, $80, $00, $00, $C0, $C0, $C0, $00,
    $97, $80, $55, $00, $C8, $B9, $9D, $00, $73, $73, $7B, $00, $29, $29, $2D, $00,
    $52, $52, $5A, $00, $5A, $5A, $63, $00, $39, $39, $42, $00, $18, $18, $1D, $00,
    $10, $10, $18, $00, $18, $18, $29, $00, $08, $08, $10, $00, $71, $79, $F2, $00,
    $5F, $67, $E1, $00, $5A, $5A, $FF, $00, $31, $31, $FF, $00, $52, $5A, $D6, $00,
    $00, $10, $94, $00, $18, $29, $94, $00, $00, $08, $39, $00, $00, $10, $73, $00,
    $00, $18, $B5, $00, $52, $63, $BD, $00, $10, $18, $42, $00, $99, $AA, $FF, $00,
    $00, $10, $5A, $00, $29, $39, $73, $00, $31, $4A, $A5, $00, $73, $7B, $94, $00,
    $31, $52, $BD, $00, $10, $21, $52, $00, $18, $31, $7B, $00, $10, $18, $2D, $00,
    $31, $4A, $8C, $00, $00, $29, $94, $00, $00, $31, $BD, $00, $52, $73, $C6, $00,
    $18, $31, $6B, $00, $42, $6B, $C6, $00, $00, $4A, $CE, $00, $39, $63, $A5, $00,
    $18, $31, $5A, $00, $00, $10, $2A, $00, $00, $08, $15, $00, $00, $18, $3A, $00,
    $00, $00, $08, $00, $00, $00, $29, $00, $00, $00, $4A, $00, $00, $00, $9D, $00,
    $00, $00, $DC, $00, $00, $00, $DE, $00, $00, $00, $FB, $00, $52, $73, $9C, $00,
    $4A, $6B, $94, $00, $29, $4A, $73, $00, $18, $31, $52, $00, $18, $4A, $8C, $00,
    $11, $44, $88, $00, $00, $21, $4A, $00, $10, $18, $21, $00, $5A, $94, $D6, $00,
    $21, $6B, $C6, $00, $00, $6B, $EF, $00, $00, $77, $FF, $00, $84, $94, $A5, $00,
    $21, $31, $42, $00, $08, $10, $18, $00, $08, $18, $29, $00, $00, $10, $21, $00,
    $18, $29, $39, $00, $39, $63, $8C, $00, $10, $29, $42, $00, $18, $42, $6B, $00,
    $18, $4A, $7B, $00, $00, $4A, $94, $00, $7B, $84, $8C, $00, $5A, $63, $6B, $00,
    $39, $42, $4A, $00, $18, $21, $29, $00, $29, $39, $46, $00, $94, $A5, $B5, $00,
    $5A, $6B, $7B, $00, $94, $B1, $CE, $00, $73, $8C, $A5, $00, $5A, $73, $8C, $00,
    $73, $94, $B5, $00, $73, $A5, $D6, $00, $4A, $A5, $EF, $00, $8C, $C6, $EF, $00,
    $42, $63, $7B, $00, $39, $56, $6B, $00, $5A, $94, $BD, $00, $00, $39, $63, $00,
    $AD, $C6, $D6, $00, $29, $42, $52, $00, $18, $63, $94, $00, $AD, $D6, $EF, $00,
    $63, $8C, $A5, $00, $4A, $5A, $63, $00, $7B, $A5, $BD, $00, $18, $42, $5A, $00,
    $31, $8C, $BD, $00, $29, $31, $35, $00, $63, $84, $94, $00, $4A, $6B, $7B, $00,
    $5A, $8C, $A5, $00, $29, $4A, $5A, $00, $39, $7B, $9C, $00, $10, $31, $42, $00,
    $21, $AD, $EF, $00, $00, $10, $18, $00, $00, $21, $29, $00, $00, $6B, $9C, $00,
    $5A, $84, $94, $00, $18, $42, $52, $00, $29, $5A, $6B, $00, $21, $63, $7B, $00,
    $21, $7B, $9C, $00, $00, $A5, $DE, $00, $39, $52, $5A, $00, $10, $29, $31, $00,
    $7B, $BD, $CE, $00, $39, $5A, $63, $00, $4A, $84, $94, $00, $29, $A5, $C6, $00,
    $18, $9C, $10, $00, $4A, $8C, $42, $00, $42, $8C, $31, $00, $29, $94, $10, $00,
    $10, $18, $08, $00, $18, $18, $08, $00, $10, $29, $08, $00, $29, $42, $18, $00,
    $AD, $B5, $A5, $00, $73, $73, $6B, $00, $29, $29, $18, $00, $4A, $42, $18, $00,
    $4A, $42, $31, $00, $DE, $C6, $63, $00, $FF, $DD, $44, $00, $EF, $D6, $8C, $00,
    $39, $6B, $73, $00, $39, $DE, $F7, $00, $8C, $EF, $F7, $00, $00, $E7, $F7, $00,
    $5A, $6B, $6B, $00, $A5, $8C, $5A, $00, $EF, $B5, $39, $00, $CE, $9C, $4A, $00,
    $B5, $84, $31, $00, $6B, $52, $31, $00, $D6, $DE, $DE, $00, $B5, $BD, $BD, $00,
    $84, $8C, $8C, $00, $DE, $F7, $F7, $00, $18, $08, $00, $00, $39, $18, $08, $00,
    $29, $10, $08, $00, $00, $18, $08, $00, $00, $29, $08, $00, $A5, $52, $00, $00,
    $DE, $7B, $00, $00, $4A, $29, $10, $00, $6B, $39, $10, $00, $8C, $52, $10, $00,
    $A5, $5A, $21, $00, $5A, $31, $10, $00, $84, $42, $10, $00, $84, $52, $31, $00,
    $31, $21, $18, $00, $7B, $5A, $4A, $00, $A5, $6B, $52, $00, $63, $39, $29, $00,
    $DE, $4A, $10, $00, $21, $29, $29, $00, $39, $4A, $4A, $00, $18, $29, $29, $00,
    $29, $4A, $4A, $00, $42, $7B, $7B, $00, $4A, $9C, $9C, $00, $29, $5A, $5A, $00,
    $14, $42, $42, $00, $00, $39, $39, $00, $00, $59, $59, $00, $2C, $35, $CA, $00,
    $21, $73, $6B, $00, $00, $31, $29, $00, $10, $39, $31, $00, $18, $39, $31, $00,
    $00, $4A, $42, $00, $18, $63, $52, $00, $29, $73, $5A, $00, $18, $4A, $31, $00,
    $00, $21, $18, $00, $00, $31, $18, $00, $10, $39, $18, $00, $4A, $84, $63, $00,
    $4A, $BD, $6B, $00, $4A, $B5, $63, $00, $4A, $BD, $63, $00, $4A, $9C, $5A, $00,
    $39, $8C, $4A, $00, $4A, $C6, $63, $00, $4A, $D6, $63, $00, $4A, $84, $52, $00,
    $29, $73, $31, $00, $5A, $C6, $63, $00, $4A, $BD, $52, $00, $00, $FF, $10, $00,
    $18, $29, $18, $00, $4A, $88, $4A, $00, $4A, $E7, $4A, $00, $00, $5A, $00, $00,
    $00, $88, $00, $00, $00, $94, $00, $00, $00, $DE, $00, $00, $00, $EE, $00, $00,
    $00, $FB, $00, $00, $94, $5A, $4A, $00, $B5, $73, $63, $00, $D6, $8C, $7B, $00,
    $D6, $7B, $6B, $00, $FF, $88, $77, $00, $CE, $C6, $C6, $00, $9C, $94, $94, $00,
    $C6, $94, $9C, $00, $39, $31, $31, $00, $84, $18, $29, $00, $84, $00, $18, $00,
    $52, $42, $4A, $00, $7B, $42, $52, $00, $73, $5A, $63, $00, $F7, $B5, $CE, $00,
    $9C, $7B, $8C, $00, $CC, $22, $77, $00, $FF, $AA, $DD, $00, $2A, $B4, $F0, $00,
    $9F, $00, $DF, $00, $B3, $17, $E3, $00, $F0, $FB, $FF, $00, $A4, $A0, $A0, $00,
    $80, $80, $80, $00, $00, $00, $FF, $00, $00, $FF, $00, $00, $00, $FF, $FF, $00,
    $FF, $00, $00, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00, $FF, $FF, $FF, $00
    );

  g_GMRedMsgCmd             : Char = '!';
  g_nGMREDMSGCMD            : Integer = 6;
  g_dwSendOnlineTick        : LongWord;
  g_HighLevelHuman          : TObject = nil;
  g_HighPKPointHuman        : TObject = nil;
  g_HighDCHuman             : TObject = nil;
  g_HighMCHuman             : TObject = nil;
  g_HighSCHuman             : TObject = nil;
  g_HighOnlineHuman         : TObject = nil;

  g_dwSpiritMutinyTick      : LongWord;

{$IF USECODE = USEREMOTECODE}
  g_Encode6BitBuf           : TEncode6BitBuf = (
    $55, $8B, $EC, $83, $C4, $E0, $89, $4D, $F4, $89, $55, $F8, $89, $45, $FC, $33,
    $C0, $89, $45, $EC, $C6, $45, $E5, $00, $33, $C0, $89, $45, $E8, $8B, $45, $F4,
    $48, $85, $C0, $0F, $8C, $C3, $00, $00, $00, $40, $89, $45, $E0, $C7, $45, $F0,
    $00, $00, $00, $00, $8B, $45, $E8, $3B, $45, $08, $0F, $8D, $AC, $00, $00, $00,
    $8B, $45, $FC, $8B, $55, $F0, $8A, $04, $10, $88, $45, $E6, $8B, $4D, $EC, $83,
    $C1, $02, $33, $C0, $8A, $45, $E6, $D3, $E8, $0A, $45, $E5, $24, $3F, $88, $45,
    $E7, $8B, $45, $EC, $83, $C0, $02, $B9, $08, $00, $00, $00, $2B, $C8, $33, $C0,
    $8A, $45, $E6, $D3, $E0, $C1, $E8, $02, $24, $3F, $88, $45, $E5, $83, $45, $EC,
    $02, $83, $7D, $EC, $06, $7D, $13, $8A, $45, $E7, $04, $3C, $8B, $55, $F8, $8B,
    $4D, $E8, $88, $04, $0A, $FF, $45, $E8, $EB, $46, $8B, $45, $08, $48, $3B, $45,
    $E8, $7E, $23, $8A, $45, $E7, $04, $3C, $8B, $55, $F8, $8B, $4D, $E8, $88, $04,
    $0A, $8A, $45, $E5, $04, $3C, $8B, $55, $F8, $8B, $4D, $E8, $88, $44, $0A, $01,
    $83, $45, $E8, $02, $EB, $11, $8A, $45, $E7, $04, $3C, $8B, $55, $F8, $8B, $4D,
    $E8, $88, $04, $0A, $FF, $45, $E8, $33, $C0, $89, $45, $EC, $C6, $45, $E5, $00,
    $FF, $45, $F0, $FF, $4D, $E0, $0F, $85, $48, $FF, $FF, $FF, $83, $7D, $EC, $00,
    $7E, $11, $8A, $45, $E5, $04, $3C, $8B, $55, $F8, $8B, $4D, $E8, $88, $04, $0A,
    $FF, $45, $E8, $8B, $45, $F8, $8B, $55, $E8, $C6, $04, $10, $00, $8B, $E5, $5D,
    $C2, $04, $00, $90);

  g_Decode6BitBuf           : TDecode6BitBuf = (
    $55, $8B, $EC, $83, $C4, $DC, $89, $4D, $F4, $89, $55, $F8, $89, $45, $FC, $C7,
    $45, $EC, $02, $00, $00, $00, $33, $C0, $89, $45, $E8, $33, $C0, $89, $45, $E4,
    $C6, $45, $E2, $00, $8B, $45, $F4, $48, $85, $C0, $0F, $8C, $B5, $00, $00, $00,
    $40, $89, $45, $DC, $C7, $45, $F0, $00, $00, $00, $00, $8B, $45, $FC, $8B, $55,
    $F0, $0F, $B6, $04, $10, $83, $E8, $3C, $78, $10, $8B, $45, $FC, $8B, $55, $F0,
    $8A, $04, $10, $2C, $3C, $88, $45, $E3, $EB, $0A, $33, $C0, $89, $45, $E4, $E9,
    $81, $00, $00, $00, $8B, $45, $E4, $3B, $45, $08, $7D, $79, $8B, $45, $E8, $83,
    $C0, $06, $83, $F8, $08, $7C, $43, $B9, $06, $00, $00, $00, $2B, $4D, $EC, $8A,
    $45, $E3, $24, $3F, $25, $FF, $00, $00, $00, $D3, $E8, $0A, $45, $E2, $88, $45,
    $E1, $8B, $45, $F8, $8B, $55, $E4, $8A, $4D, $E1, $88, $0C, $10, $FF, $45, $E4,
    $33, $C0, $89, $45, $E8, $83, $7D, $EC, $06, $7D, $06, $83, $45, $EC, $02, $EB,
    $09, $C7, $45, $EC, $02, $00, $00, $00, $EB, $1F, $8B, $4D, $EC, $8A, $45, $E3,
    $D2, $E0, $8B, $55, $EC, $22, $82, $02, $15, $5E, $00, $88, $45, $E2, $B8, $08,
    $00, $00, $00, $2B, $45, $EC, $01, $45, $E8, $FF, $45, $F0, $FF, $4D, $DC, $0F,
    $85, $56, $FF, $FF, $FF, $8B, $45, $F8, $8B, $55, $E4, $C6, $04, $10, $00, $8B,
    $E5, $5D, $C2, $04, $00);
{$IFEND}

  g_Config                  : TConfig = (
    nConfigSize: SizeOf(TConfig);
    sServerName: 'DragonServer';
    sServerIPaddr: '127.0.0.1';
    sWebSite: 'http://www.legendm2.com';
    sBbsSite: 'http://bbs.legendm2.com';
    sClientDownload: 'http://down.legendm2.com';
    sQQ: '88888888';
    sPhone: '123456789';
    sBankAccount0: '银行信息';
    sBankAccount1: '银行信息';
    sBankAccount2: '银行信息';
    sBankAccount3: '银行信息';
    sBankAccount4: '银行信息';
    sBankAccount5: '银行信息';
    sBankAccount6: '银行信息';
    sBankAccount7: '银行信息';
    sBankAccount8: '银行信息';
    sBankAccount9: '银行信息';
    nServerNumber: 0;
    boVentureServer: False;
    boTestServer: True;
    boServiceMode: False;
    boNonPKServer: False;
    nTestLevel: 1;
    nTestGold: 0;
    nTestUserLimit: 1000;
    nSendBlock: 1024;
    nCheckBlock: 12288;
    nAvailableBlock: 8192;
    nGateLoad: 0;
    nUserFull: 1000;
    nZenFastStep: 300;
    sGateAddr: '127.0.0.1';
    nGatePort: 5000;
    sDBAddr: '127.0.0.1';
    nDBPort: 6000;
    sIDSAddr: '127.0.0.1';
    nIDSPort: 5600;
    sMsgSrvAddr: '127.0.0.1';
    nMsgSrvPort: 4900;
    sLogServerAddr: '127.0.0.1';
    nLogServerPort: 10000;
    boDiscountForNightTime: False;
    nHalfFeeStart: 2;
    nHalfFeeEnd: 10;
    boViewHackMessage: False;
    boViewAdmissionFailure: False;
    sBaseDir: '.\BaseDir\';
    sGuildDir: '.\GuildDir\List\';
    sGuildFile: '.\GuildDir\List.txt';
    sVentureDir: '.\VentureDir\';
    sConLogDir: '.\ConLogDir\';
    sCastleDir: '.\CastleDir\';
    sCastleFile: '.\CastleDir\List.txt';
    sEnvirDir: '.\Envir\';
    sMapDir: '.\Map\';
    sNoticeDir: '.\Notice\';
    sLogDir: '.\Log\';
    sPlugDir: '.\';
    sUserDataDir: '.\Envir\UserData\';
    sClientFile1: 'mir.1';
    sClientFile2: 'mir.2';
    sClientFile3: 'mir.3';

    sClothsMan: '布衣(男)';
    sClothsWoman: '布衣(女)';
    sWoodenSword: '木剑';
    sCandle: '蜡烛';
    sBasicDrug: '金创药(小量)';
    sGoldStone: '金矿';
    sSilverStone: '银矿';
    sSteelStone: '铁矿';
    sCopperStone: '铜矿';
    sBlackStone: '黑铁矿';
    sZuma: ('祖玛卫士', '祖玛雕像', '祖玛弓箭手', '楔蛾');
    sBee: '小角蝇';
    sSpider: '小蜘蛛';
    sWomaHorn: '沃玛号角';
    sZumaPiece: '祖玛头像';
    sGameGoldName: '游戏币';
    sGamePointName: '游戏点';
    sPayMentPointName: '秒卡点';
    sBloodMonSlave: ('炎魔1', '炎魔2', '炎魔3');
    DBSocket: INVALID_SOCKET;
    nHealthFillTime: 300;
    nSpellFillTime: 800;
    nMonUpLvNeedKillBase: 100;
    nMonUpLvRate: 16;
    MonUpLvNeedKillCount: (0, 0, 50, 100, 200, 300, 600, 1200, 2400, 4800, 9600, 19200, 38400, 76800, 153600);
    SlaveColor: ($FF, $FE, $93, $9A, $E5, $A8, $B4, $FC, 249, 250, 250, 250, 250, 250, 250);
    WideAttack: (7, 1, 2);
    CrsAttack: (7, 1, 2, 3, 4, 5, 6);
    SpitMap: (
    ((0, 0, 1, 0, 0),                   //DR_UP
    (0, 0, 1, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0)),
    ((0, 0, 0, 0, 1),                   //DR_UPRIGHT
    (0, 0, 0, 1, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0)),
    ((0, 0, 0, 0, 0),                   //DR_RIGHT
    (0, 0, 0, 0, 0),
    (0, 0, 0, 1, 1),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0)),
    ((0, 0, 0, 0, 0),                   //DR_DOWNRIGHT
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 1, 0),
    (0, 0, 0, 0, 1)),
    ((0, 0, 0, 0, 0),                   //DR_DOWN
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 1, 0, 0),
    (0, 0, 1, 0, 0)),
    ((0, 0, 0, 0, 0),                   //DR_DOWNLEFT
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 1, 0, 0, 0),
    (1, 0, 0, 0, 0)),
    ((0, 0, 0, 0, 0),                   //DR_LEFT
    (0, 0, 0, 0, 0),
    (1, 1, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0)),
    ((1, 0, 0, 0, 0),                   //DR_UPLEFT
    (0, 1, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0))
    );

    sHomeMap: '0';
    nHomeX: 289;
    nHomeY: 618;
    sRedHomeMap: '3';
    nRedHomeX: 845;
    nRedHomeY: 674;
    sRedDieHomeMap: '3';
    nRedDieHomeX: 839;
    nRedDieHomeY: 668;
    dwDecPkPointTime: 2 * 60 * 1000;
    nDecPkPointCount: 1;
    dwPKFlagTime: 60 * 1000;
    nKillHumanAddPKPoint: 100;
    nKillHumanDecLuckPoint: 500;
    dwDecLightItemDrugTime: 500;
    nSafeZoneSize: 10;
    nStartPointSize: 2;
    nNonGuildWarZoneSize: 60;
    boSafeZoneAureole: True;
    dwHumanGetMsgTime: 200;
    nGroupMembersMax: 10;
    sFireBallSkill: '火球术';
    sHealSkill: '治愈术';
    ReNewNameColor: ($FF, $FE, $93, $9A, $E5, $A8, $B4, $FC, $B4, $FC);
    dwReNewNameColorTime: 2000;
    boReNewChangeColor: True;
    btReNewChangeColorLevel: 1;
    boReNewLevelClearExp: True;
    BonusAbilofWarr: (DC: 17; MC: 20; SC: 20; AC: 20; MAC: 20; HP: 1; MP: 3; HIT: 20; Speed: 35; X2: 0);
    BonusAbilofWizard: (DC: 17; MC: 25; SC: 30; AC: 20; MAC: 15; HP: 2; MP: 1; HIT: 25; Speed: 35; X2: 0);
    BonusAbilofTaos: (DC: 20; MC: 30; SC: 17; AC: 20; MAC: 15; HP: 2; MP: 1; HIT: 30; Speed: 30; X2: 0);
    NakedAbilofWarr: (DC: 512; MC: 2560; SC: 20; AC: 768; MAC: 1280; HP: 0; MP: 0; HIT: 0; Speed: 0; X2: 0);
    NakedAbilofWizard: (DC: 512; MC: 512; SC: 2560; AC: 1280; MAC: 768; HP: 0; MP: 0; HIT: 5; Speed: 0; X2: 0);
    NakedAbilofTaos: (DC: 20; MC: 30; SC: 17; AC: 20; MAC: 15; HP: 2; MP: 1; HIT: 30; Speed: 30; X2: 0);
    nUpgradeWeaponMaxPoint: 20;
    nUpgradeWeaponPrice: 10000;
    dwUPgradeWeaponGetBackTime: 60 * 60 * 1000;
    nClearExpireUpgradeWeaponDays: 8;
    nUpgradeWeaponDCRate: 100;
    nUpgradeWeaponDCTwoPointRate: 30;
    nUpgradeWeaponDCThreePointRate: 200;
    nUpgradeWeaponSCRate: 100;
    nUpgradeWeaponSCTwoPointRate: 30;
    nUpgradeWeaponSCThreePointRate: 200;
    nUpgradeWeaponMCRate: 100;
    nUpgradeWeaponMCTwoPointRate: 30;
    nUpgradeWeaponMCThreePointRate: 200;
    dwProcessMonstersTime: 10;
    dwRegenMonstersTime: 200;
    nMonGenRate: 10;
    nProcessMonRandRate: 5;
    nProcessMonLimitCount: 5;
    nSoftVersionDate: 20020522;
    boCanOldClientLogon: True;
    dwConsoleShowUserCountTime: 10 * 60 * 1000;
    dwShowLineNoticeTime: 5 * 60 * 1000;
    nLineNoticeColor: 2;
    nStartCastleWarDays: 4;
    nStartCastlewarTime: 20;
    dwShowCastleWarEndMsgTime: 10 * 60 * 1000;
    dwCastleWarTime: 3 * 60 * 60 * 1000;
    dwGetCastleTime: 10 * 60 * 1000;
    dwGuildWarTime: 3 * 60 * 60 * 1000;
    nBuildGuildPrice: 1000000;
    nGuildWarPrice: 30000;
    nMakeDurgPrice: 100;
    nHumanMaxGold: 2000000000;
    nHumanTryModeMaxGold: 100000;
    nTryModeLevel: 7;
    boTryModeUseStorage: False;
    nCanShoutMsgLevel: 7;
    boShowMakeItemMsg: False;
    boShutRedMsgShowGMName: False;
    nSayMsgMaxLen: 80;
    dwSayMsgTime: 3 * 1000;
    nSayMsgCount: 2;
    dwDisableSayMsgTime: 60 * 1000;
    nSayRedMsgMaxLen: 255;
    boShowGuildName: True;
    boShowRankLevelName: False;
    boMonSayMsg: False;
    nStartPermission: 0;
    boKillHumanWinLevel: False;
    boKilledLostLevel: False;
    boKillHumanWinExp: False;
    boKilledLostExp: False;
    nKillHumanWinLevel: 1;
    nKilledLostLevel: 1;
    nKillHumanWinExp: 100000;
    nKillHumanLostExp: 100000;
    nHumanLevelDiffer: 10;
    nMonsterPowerRate: 10;
    nItemsPowerRate: 10;
    nItemsACPowerRate: 10;
    boSendOnlineCount: True;
    nSendOnlineCountRate: 10;
    dwSendOnlineTime: 5 * 60 * 1000;
    dwSaveHumanRcdTime: 10 * 60 * 1000;
    dwHumanFreeDelayTime: 5 * 60 * 1000;
    dwMakeGhostTime: 3 * 60 * 1000;
    dwClearDropOnFloorItemTime: 60 * 60 * 1000;
    dwFloorItemCanPickUpTime: 2 * 60 * 1000;
    boPasswordLockSystem: False;        //是否启用密码保护系统
    boLockDealAction: False;            //是否锁定交易操作
    boLockDropAction: False;            //是否锁定扔物品操作
    boLockGetBackItemAction: False;     //是否锁定取仓库操作
    boLockHumanLogin: False;            //是否锁定走操作
    boLockWalkAction: False;            //是否锁定走操作
    boLockRunAction: False;             //是否锁定跑操作
    boLockHitAction: False;             //是否锁定攻击操作
    boLockSpellAction: False;           //是否锁定魔法操作
    boLockSendMsgAction: False;         //是否锁定发信息操作
    boLockUserItemAction: False;        //是否锁定使用物品操作
    boLockInObModeAction: False;        //锁定时进入隐身状态
    nPasswordErrorCountLock: 3;         //输入密码错误超过 指定次数则锁定密码
    boPasswordErrorKick: False;         //输入密码错误超过限制则踢下线
    boLockRecallAction: True;
    nSendRefMsgRange: 12;
    boDecLampDura: True;
    boHungerSystem: False;
    boHungerDecHP: False;
    boHungerDecPower: False;
    boDiableHumanRun: True;

    boRUNHUMAN: False;
    boRUNMON: False;
    boRunNpc: False;
    boRunGuard: False;
    boWarDisHumRun: False;
    boGMRunAll: False;
    boSafeZoneRunAll: False;
    dwTryDealTime: 3000;
    dwDealOKTime: 1000;
    boCanNotGetBackDeal: True;
    boDisableDeal: False;
    nMasterOKLevel: 500;
    nMasterOKCreditPoint: 0;
    nMasterOKBonusPoint: 0;
    boPKLevelProtect: False;
    nPKProtectLevel: 10;
    nRedPKProtectLevel: 10;
    nItemPowerRate: 10000;
    nItemExpRate: 10000;
    nItemAcRate: 10000;
    nItemMacRate: 10000;
    nScriptGotoCountLimit: {30}1500;  //脚本允许使用GOTO的数量  Development 2019-01-26 修改
    btHearMsgFColor: $00;               //前景
    btHearMsgBColor: $FF;               //背景
    btWhisperMsgFColor: $FC;            //前景
    btWhisperMsgBColor: $FF;            //背景
    btGMWhisperMsgFColor: $FF;          //前景
    btGMWhisperMsgBColor: $38;          //背景
    btCryMsgFColor: $0;                 //前景
    btCryMsgBColor: $97;                //背景
    btGreenMsgFColor: $DB;              //前景
    btGreenMsgBColor: $FF;              //背景
    btBlueMsgFColor: $FF;               //前景
    btBlueMsgBColor: $FC;               //背景
    btRedMsgFColor: $FF;                //前景
    btRedMsgBColor: $38;                //背景
    btGuildMsgFColor: $DB;              //前景
    btGuildMsgBColor: $FF;              //背景
    btGroupMsgFColor: $C4;              //前景
    btGroupMsgBColor: $FF;              //背景
    btCustMsgFColor: $FC;               //前景
    btCustMsgBColor: $FF;               //背景
    btPurpleMsgFColor: $FF;
    btPurpleMsgBColor: 253;
    nMonRandomAddValue: 10;
    nMakeRandomAddValue: 10;
    nWeaponDCAddValueMaxLimit: 12;
    nWeaponDCAddValueRate: 15;
    nWeaponMCAddValueMaxLimit: 12;
    nWeaponMCAddValueRate: 15;
    nWeaponSCAddValueMaxLimit: 12;
    nWeaponSCAddValueRate: 15;
    nDressDCAddRate: 40;
    nDressDCAddValueMaxLimit: 6;
    nDressDCAddValueRate: 20;
    nDressMCAddRate: 40;
    nDressMCAddValueMaxLimit: 6;
    nDressMCAddValueRate: 20;
    nDressSCAddRate: 40;
    nDressSCAddValueMaxLimit: 6;
    nDressSCAddValueRate: 20;
    nNeckLace202124DCAddRate: 40;
    nNeckLace202124DCAddValueMaxLimit: 6;
    nNeckLace202124DCAddValueRate: 20;
    nNeckLace202124MCAddRate: 40;
    nNeckLace202124MCAddValueMaxLimit: 6;
    nNeckLace202124MCAddValueRate: 20;
    nNeckLace202124SCAddRate: 40;
    nNeckLace202124SCAddValueMaxLimit: 6;
    nNeckLace202124SCAddValueRate: 20;
    nNeckLace19DCAddRate: 30;
    nNeckLace19DCAddValueMaxLimit: 6;
    nNeckLace19DCAddValueRate: 20;
    nNeckLace19MCAddRate: 30;
    nNeckLace19MCAddValueMaxLimit: 6;
    nNeckLace19MCAddValueRate: 20;
    nNeckLace19SCAddRate: 30;
    nNeckLace19SCAddValueMaxLimit: 6;
    nNeckLace19SCAddValueRate: 20;
    nArmRing26DCAddRate: 30;
    nArmRing26DCAddValueMaxLimit: 6;
    nArmRing26DCAddValueRate: 20;
    nArmRing26MCAddRate: 30;
    nArmRing26MCAddValueMaxLimit: 6;
    nArmRing26MCAddValueRate: 20;
    nArmRing26SCAddRate: 30;
    nArmRing26SCAddValueMaxLimit: 6;
    nArmRing26SCAddValueRate: 20;
    nRing22DCAddRate: 30;
    nRing22DCAddValueMaxLimit: 6;
    nRing22DCAddValueRate: 20;
    nRing22MCAddRate: 30;
    nRing22MCAddValueMaxLimit: 6;
    nRing22MCAddValueRate: 20;
    nRing22SCAddRate: 30;
    nRing22SCAddValueMaxLimit: 6;
    nRing22SCAddValueRate: 20;
    nRing23DCAddRate: 30;
    nRing23DCAddValueMaxLimit: 6;
    nRing23DCAddValueRate: 20;
    nRing23MCAddRate: 30;
    nRing23MCAddValueMaxLimit: 6;
    nRing23MCAddValueRate: 20;
    nRing23SCAddRate: 30;
    nRing23SCAddValueMaxLimit: 6;
    nRing23SCAddValueRate: 20;
    nHelMetDCAddRate: 30;
    nHelMetDCAddValueMaxLimit: 6;
    nHelMetDCAddValueRate: 20;
    nHelMetMCAddRate: 30;
    nHelMetMCAddValueMaxLimit: 6;
    nHelMetMCAddValueRate: 20;
    nHelMetSCAddRate: 30;
    nHelMetSCAddValueMaxLimit: 6;
    nHelMetSCAddValueRate: 20;
    nUnknowHelMetACAddRate: 20;
    nUnknowHelMetACAddValueMaxLimit: 4;
    nUnknowHelMetMACAddRate: 20;
    nUnknowHelMetMACAddValueMaxLimit: 4;
    nUnknowHelMetDCAddRate: 30;
    nUnknowHelMetDCAddValueMaxLimit: 3;
    nUnknowHelMetMCAddRate: 30;
    nUnknowHelMetMCAddValueMaxLimit: 3;
    nUnknowHelMetSCAddRate: 30;
    nUnknowHelMetSCAddValueMaxLimit: 3;
    nUnknowRingACAddRate: 20;
    nUnknowRingACAddValueMaxLimit: 4;
    nUnknowRingMACAddRate: 20;
    nUnknowRingMACAddValueMaxLimit: 4;
    nUnknowRingDCAddRate: 20;
    nUnknowRingDCAddValueMaxLimit: 6;
    nUnknowRingMCAddRate: 20;
    nUnknowRingMCAddValueMaxLimit: 6;
    nUnknowRingSCAddRate: 20;
    nUnknowRingSCAddValueMaxLimit: 6;
    nUnknowNecklaceACAddRate: 20;
    nUnknowNecklaceACAddValueMaxLimit: 5;
    nUnknowNecklaceMACAddRate: 20;
    nUnknowNecklaceMACAddValueMaxLimit: 5;
    nUnknowNecklaceDCAddRate: 30;
    nUnknowNecklaceDCAddValueMaxLimit: 5;
    nUnknowNecklaceMCAddRate: 30;
    nUnknowNecklaceMCAddValueMaxLimit: 5;
    nUnknowNecklaceSCAddRate: 30;
    nUnknowNecklaceSCAddValueMaxLimit: 5;
    nMonOneDropGoldCount: 2000;
    nMakeMineHitRate: 4;                //挖矿命中率
    nMakeMineRate: 12;                  //挖矿率
    nStoneTypeRate: 120;
    nStoneTypeRateMin: 56;
    nGoldStoneMin: 1;
    nGoldStoneMax: 2;
    nSilverStoneMin: 3;
    nSilverStoneMax: 20;
    nSteelStoneMin: 21;
    nSteelStoneMax: 45;
    nBlackStoneMin: 46;
    nBlackStoneMax: 56;
    nStoneMinDura: 3000;
    nStoneGeneralDuraRate: 13000;
    nStoneAddDuraRate: 20;
    nStoneAddDuraMax: 10000;
    nWinLottery6Min: 1;
    nWinLottery6Max: 4999;
    nWinLottery5Min: 14000;
    nWinLottery5Max: 15999;
    nWinLottery4Min: 16000;
    nWinLottery4Max: 16149;
    nWinLottery3Min: 16150;
    nWinLottery3Max: 16169;
    nWinLottery2Min: 16170;
    nWinLottery2Max: 16179;
    nWinLottery1Min: 16180;
    nWinLottery1Max: 16185;             //16180 + 1820;
    nWinLottery1Gold: 1000000;
    nWinLottery2Gold: 200000;
    nWinLottery3Gold: 100000;
    nWinLottery4Gold: 10000;
    nWinLottery5Gold: 1000;
    nWinLottery6Gold: 500;
    nWinLotteryRate: 30000;
    nWinLotteryCount: 0;
    nNoWinLotteryCount: 0;
    nWinLotteryLevel1: 0;
    nWinLotteryLevel2: 0;
    nWinLotteryLevel3: 0;
    nWinLotteryLevel4: 0;
    nWinLotteryLevel5: 0;
    nWinLotteryLevel6: 0;
    GlobalVal: (
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    nItemNumber: 0;
    nItemNumberEx: High(Integer) div 2;
    nGuildRecallTime: 180;
    nGroupRecallTime: 180;
    boControlDropItem: False;
    boInSafeDisableDrop: False;
    nCanDropGold: 1000;
    nCanDropPrice: 500;
    boSendCustemMsg: True;
    boSubkMasterSendMsg: True;
    nSuperRepairPriceRate: 3;
    nRepairItemDecDura: 30;
    boDieScatterBag: True;
    nDieScatterBagRate: 3;
    boDieRedScatterBagAll: True;
    nDieDropUseItemRate: 30;
    nDieRedDropUseItemRate: 15;
    nMonDieDropUseItemRate: 30;
    boDieDropGold: False;
    boKillByHumanDropUseItem: False;
    boKillByMonstDropUseItem: True;
    boKickExpireHuman: False;
    nGuildRankNameLen: 16;
    nGuildMemberMaxLimit: 1000;
    nGuildNameLen: 16;
    nAttackPosionRate: 5;
    nAttackPosionTime: 5;
    boAutoClearEctype: False;           //Add by blue   2005.01.05
    nAutoClearEctypeTick: 600000;
    dwRevivalTime: 60 * 1000;           //复活间隔时间
    boUserMoveCanDupObj: False;
    boUserMoveCanOnItem: True;
    dwUserMoveTime: 10;
    dwPKDieLostExpRate: 1000;
    nPKDieLostLevelRate: 20000;
    btPKFlagNameColor: $2F;
    btPKLevel1NameColor: $FB;
    btPKLevel2NameColor: $F9;
    btAllyAndGuildNameColor: $B4;
    btWarGuildNameColor: $45;
    btInFreePKAreaNameColor: $DD;
    boSpiritMutiny: False;
    dwSpiritMutinyTime: 30 * 60 * 1000;
    nSpiritPowerRate: 2;
    boMasterDieMutiny: False;
    nMasterDieMutinyRate: 5;
    nMasterDieMutinyPower: 10;
    nMasterDieMutinySpeed: 5;
    boBBMonAutoChangeColor: False;
    dwBBMonAutoChangeColorTime: 3000;
    boOldClientShowHiLevel: True;
    boShowScriptActionMsg: True;
    nRunSocketDieLoopLimit: 100;
    boThreadRun: True;
    boShowExceptionMsg: False;
    boShowPreFixMsg: True;
    nMagicAttackRage: 9;                //魔法锁定范围
    sBody: '随身护卫';
    nBodyCount: 1;
    boAllowBodyMakeSlave: False;
    boMoveMakeSlave: False; //道士心灵召唤  Development 2019-01-12 添加
    sBoneFamm: '变异骷髅';
    nBoneFammCount: 1;
    sDogz: '神兽';
    nDogzCount: 1;
    nAmyOunsulPoint: 10;
    boDisableInSafeZoneFireCross: False;
    boGroupMbAttackPlayObject: True;
    boGroupMbAttackBaoBao: True;
    dwPosionDecHealthTime: 2500;
    nPosionDamagarmor: 12;              //中红毒着持久及减防量（实际大小为 12 / 10）
    boLimitSwordLong: False;
    nSwordLongPowerRate: 100;
    nFireBoomRage: 1;
    nSnowWindRange: 1;
    nElecBlizzardRange: 2;
    nMagTurnUndeadLevel: 50;            //圣言怪物等级限制
    nMagTammingLevel: 50;               //诱惑之光怪物等级限制
    nMagTammingTargetLevel: 10;         //诱惑怪物相差等级机率，此数字越小机率越大；
    nMagTammingHPRate: 100;
    nMagTammingCount: 5;
    nMabMabeHitRandRate: 100;
    nMabMabeHitMinLvLimit: 10;
    nMabMabeHitSucessRate: 21;
    nMabMabeHitMabeTimeRate: 20;
    sCASTLENAME: '沙巴克';
    sCastleHomeMap: '3';
    nCastleHomeX: 644;
    nCastleHomeY: 290;
    nCastleWarRangeX: 100;
    nCastleWarRangeY: 100;
    nCastleTaxRate: 5;
    boGetAllNpcTax: False;
    nHireGuardPrice: 300000;
    nHireArcherPrice: 300000;
    nCastleGoldMax: 10000000;
    nCastleOneDayGold: 2000000;
    nRepairDoorPrice: 2000000;
    nRepairWallPrice: 500000;
    nCastleMemberPriceRate: 80;
    nMaxHitMsgCount: 1;
    nMaxSpellMsgCount: 1;
    nMaxRunMsgCount: 1;
    nMaxWalkMsgCount: 1;
    nMaxTurnMsgCount: 1;
    nMaxSitDonwMsgCount: 1;
    nMaxDigUpMsgCount: 1;
    boSpellSendUpdateMsg: False;
    boActionSendActionMsg: False;
    boKickOverSpeed: False;
    btSpeedControlMode: 0;
    nOverSpeedKickCount: 4;
    dwDropOverSpeed: 10;
    dwHitIntervalTime: 900;             //攻击间隔
    dwMagicHitIntervalTime: 800;        //魔法间隔
    dwRunIntervalTime: 600;             //跑步间隔
    dwWalkIntervalTime: 600;            //走路间隔
    dwTurnIntervalTime: 600;            //换方向间隔
    boControlActionInterval: True;
    boControlWalkHit: True;
    boControlRunLongHit: True;
    boControlRunHit: True;
    boControlRunMagic: True;
    dwActionIntervalTime: 350;          //组合操作间隔
    dwRunLongHitIntervalTime: 800;      //跑位刺杀间隔
    dwRunHitIntervalTime: 800;          //跑位攻击间隔
    dwWalkHitIntervalTime: 800;         //走位攻击间隔
    dwRunMagicIntervalTime: 900;        //跑位魔法间隔
    boDisableStruck: False;             //不显示人物弯腰动作
    boDisableSelfStruck: False;         //自己不显示人物弯腰动作
    boHeroDisableStruck: False;
    dwStruckTime: 100;                  //人物弯腰停留时间
    dwKillMonExpMultiple: 1;            //杀怪经验倍数
{$IF SoftVersion = VERENT}
    dwRequestVersion: 98;
{$ELSE}
    dwRequestVersion: RequestVersion;
{$IFEND}
    boHighLevelKillMonFixExp: False;
    boHighLevelGroupFixExp: False;
    boHighLevelLimitExp: False;
    nLimitLevel: 88;
    nKillMonExpDiv: 600;
    boAddUserItemNewValue: True;
    sLineNoticePreFix: '〖公告〗';
    sSysMsgPreFix: '〖系统〗';
    sGuildMsgPreFix: '〖行会〗';
    sGroupMsgPreFix: '〖组队〗';
    sHintMsgPreFix: '〖提示〗';
    sGMRedMsgpreFix: '〖ＧＭ〗';
    sMonSayMsgpreFix: '〖怪物〗';
    sCustMsgpreFix: '〖祝福〗';
    sCastleMsgpreFix: '〖城主〗';
    sGuildNotice: '公告';
    sGuildWar: '敌对行会';
    sGuildAll: '联盟行会';
    sGuildMember: '行会成员';
    sGuildMemberRank: '行会成员';
    sGuildChief: '掌门人';
    boKickAllUser: False;
    boTestSpeedMode: False;
    boSaveRcdNow: False;                //封复制
    ClientConf: (
    boClientCanSet: True;
    boRUNHUMAN: True;
    boRUNMON: True;
    boRunNpc: True;
    boWarRunAll: True;
    btDieColor: 5;
    wSpellTime: 500;
    wHitIime: 1400;
    wItemFlashTime: 5 * 100;
    btItemSpeed: 25;
    boCanStartRun: True;
    boParalyCanRun: False;
    boParalyCanWalk: False;
    boParalyCanHit: False;
    boParalyCanSpell: False;
    boShowRedHPLable: True;
    boShowHPNumber: True;
    boShowJobLevel: True;
    boDuraAlert: True;
    boMagicLock: True;
    boAutoPuckUpItem: False;
    );

    boCheckHookTool: False;
    nCheckHookToolTimes: 20;
    nWeaponMakeUnLuckRate: 20;
    nWeaponMakeLuckPoint1: 1;
    nWeaponMakeLuckPoint2: 3;
    nWeaponMakeLuckPoint3: 7;
    nWeaponMakeLuckPoint2Rate: 6;
    nWeaponMakeLuckPoint3Rate: 10 + 30;
    boCheckUserItemPlace: True;
{$IF DEMOCLIENT = 1}
    nClientKey: 6534;
{$ELSE}
    nClientKey: 500;
{$IFEND}
    nLevelValueOfTaosHP: 6;
    nLevelValueOfTaosHPRate: 2.5;
    nLevelValueOfTaosMP: 8;
    nLevelValueOfWizardHP: 15;
    nLevelValueOfWizardHPRate: 1.8;
    nLevelValueOfWarrHP: 4;
    nLevelValueOfWarrHPRate: 4.5;
    nProcessMonsterInterval: 2;
    nCheckLicenseFail: 0;
    nSendWhisperPlayCount: 20;
    dwSendWhisperTime: 15 * 60 * 1000;
    SellCount: 100;
    SellTax: 10;
    boNoDropItemOfGameGold: False;
    nNoDropItemGamegold: 5000;
    nNoScatterBagGamegold: 5000;
    dwMagNailTick: 5000;
    nFireHitPowerRate: 100;
    boNoDoubleFireHit: False;
    boDisableDoubleAttack: False;
    nDoubleAttackCheck: 200;
    boSafeZonePush: True;
    nHeroNextHitTime_Warr: 900;
    nHeroNextHitTime_Wizard: 1250;
    nHeroNextHitTime_Taos: 1250;
    nHeroWalkSpeed_Warr: 600;
    nHeroWalkSpeed_Wizard: 570;
    nHeroWalkSpeed_Taos: 570;
    sHeroName: '英雄';
    sHeroSlaveName: '的英雄';
    nHeroFireSwordTime: 10 * 1000;
    nMagNailPowerRate: 100;
    nHeroMainSkill: 0;
    boHeroDoMotaebo: True;
    boSaveKillMonExpRate: False;
    boEnableMapEvent: False;
    boPShowMasterName: False;
    nScatterRange: 3;
    nMagIceBallRange: 20;
    nEarthFirePowerRate: 100;
    boMagCapturePlayer: False;
    nHPStoneStartRate: 10;
    nMPStoneStartRate: 10;
    nHPStoneIntervalTime: 1000;
    nMPStoneIntervalTime: 1000;
    nHPStoneAddRate: 10;
    nMPStoneAddRate: 10;
    nHPStoneDecDura: 1000;
    nMPStoneDecDura: 1000;
    boFireBurnEventOff: False;
    boExtendStorage: False;
    boUseCustomData: True;
    nForceOffLineMsg: 5;
    sHintColor: 'clAqua';
{$IF ReleaseVersion = VERPRO}
    sMemoLogFontColor: 'clWindowText';
    sMemoLogColor: 'clWindow';
{$ELSE}
    sMemoLogFontColor: 'clLime';
    sMemoLogColor: 'clWindowText ';
{$IFEND}
    nHeroNameColor: 147;
    boAllowHeroPickUpItem: False;
    boTaosHeroAutoChangePoison: True;
    boHeroActiveAttack: True;
    boGetFullRateExp: False;
    nHeroGetExpRate: 30;
    nHeroGainExpRate: 33;
    nRecallHeroIntervalTime: 60;
    nTestHeroType: 0;
    boCalcHeroHitSpeed: False;
    nHeroHitSpeedMax: 9;
    boAllowJointAttack: True;
    nSkillWWPowerRate: 100;
    nSkillTWPowerRate: 100;
    nSkillZWPowerRate: 100;
    nSkillTTPowerRate: 100;
    nSkillZTPowerRate: 100;
    nSkillZZPowerRate: 100;
    nEnergyStepUpRate: 10;
    boHumanAttribute: False;
    nGroupAttribHPMPRate: 150;
    nGroupAttribPowerRate: 150;
    boHeroHomicideAddPKPoint: True;
    boHeroLockTarget: True;
    nRegStatus_Null: 0;
    boNoButchItemSubGird: True;
    nButchItemNeedGird: 1;
    boOnlyHeroClientLogon: True;
    boShowShieldEffect: True;
    boAutoOpenShield: True;
    nCordialAddHPMPMax: 5;
    nHeroLevelExpRate: 100;
    nShopItemBind: 0;
    boMagCanHitTarget: True;
    boHeroNeedAmulet: True;
    boOpenLevelRankSystem: True;
    nPursueHitPowerRate: 100;
    boNoDoublePursueHit: False;
    dwCloneSelfTime: 20 * 1000;
    nEatItemTime: 200;
    nGatherExpRate: 100;
    HGlobalVal: (
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    nHeroMaxHealthRate: 100;
    boHeroMaxHealthType: False;
    nInternalPowerRate: 100;
    nInternalPowerSkillRate: 100;
    nMagicShootingStarPowerRate: 100;
    nWarrCmpInvTime: 400;
    nWizaCmpInvTime: 200;
    nTaosCmpInvTime: 200;

    nShadowExpriesTime: 15;
    boLimitSquAttack: False;
    boIgnoreTagDefence: False;
    boIgnoreTagDefence2: False;
    nMagBubbleDefenceRate: 10;
    boClientAutoPlay: True;

    nSeriesSkillReleaseInvTime: 30 * 1000;
    nSmiteWideHitSkillInvTime: 5 * 60 * 1000;
    nPowerRateOfSeriesSkill_100: 100;
    nPowerRateOfSeriesSkill_101: 100;
    nPowerRateOfSeriesSkill_102: 100;
    nPowerRateOfSeriesSkill_103: 100;
    nPowerRateOfSeriesSkill_104: 100;
    nPowerRateOfSeriesSkill_105: 100;
    nPowerRateOfSeriesSkill_106: 100;
    nPowerRateOfSeriesSkill_107: 100;
    nPowerRateOfSeriesSkill_108: 100;
    nPowerRateOfSeriesSkill_109: 100;
    nPowerRateOfSeriesSkill_110: 100;
    nPowerRateOfSeriesSkill_111: 100;
    nPowerRateOfSeriesSkill_114: 100;

    nMaxHealth: 2100000000;
    nBoneFammDcEx: 0;
    nDogzDcEx: 0;
    nAngelDcEx: 0;
    nMagSuckHpRate: 100;
    nMagSuckHpPowerRate: 100;
    nMagTwinPowerRate: 100;
    nMagSquPowerRate: 100;
    SmiteLongHit2PowerRate: 100;
    boTDBeffect: True;

    boSpeedCtrl: False;
    boSpeedHackCheck: False;
    nSSFreezeRate: 100;

    boStallSystem: True;
    boClientNoFog: True;
    boSpiritMutinyDie: True;
    boMedalItemLight: True;
    boNullAttackOnSale: False;
    nDoubleScRate: 100;
    boRecallHeroCtrl: False;
    nEffectBonuPointLevel: 2;
    btMaxPowerLuck: 9;
    SetShopNeedLevel: 1;
    EffectHeroDropRate: True;
    ClientAotoLongAttack: True;
    LargeMagicRange: False;
    nInternalPowerRate2: 100;

    DeathWalking: False;
    btSellType: 0;

    boDieDropUseItemRateSingle: False;
    nDieRedDropUseItemRateSingle: 20;
    aDieDropUseItemRate: (30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 45, 45, 45);
    boHeroSystem: True;

    boBindNoScatter: True;
    boBindNoMelt: True;
    boBindNoUse: True;
    boBindNoSell: False;
    boBindNoPickUp: True;

    SuperSkillInvTime: 45;
    ssPowerRate_115: 100;
    PushedPauseTime: 1;
    nSuperSkill68InvTime: 5 * 60;
    IceMonLiveTime: 30;
    Skill77Time: 6;
    Skill77Inv: 45;
    Skill77PowerRate: 100;
    SkillMedusaEyeEffectTimeMax: 38;

    ItemSuiteDamageTypes: 1;
    DoubleScInvTime: 20;
    ClientAutoSay: True;
    cbMutiHero: False;
    boViewWhisper: False;
    boBindPickUp: False;
    boBindTakeOn: False;

    nFireBurnHoldTime: 5 * 60 * 1000;
    nSquareHitPowerRate: 100;
    nHeroMaxHealthRate1: 100;
    nHeroMaxHealthRate2: 100;

    nNeckLace19LuckAddRate: 40;
    nNeckLace19LuckAddValueMaxLimit: 6;
    nNeckLace19LuckAddValueRate: 20;
    boAddValEx: False;
    cbSmiteDamegeShow: True;
    dwMasterRoyaltyRate: 10;
    boHeroAutoLockTarget: False;
    boHeroHitCmp: False;
    boHeroEvade: True;
    boHeroRecalcWalkTick: False;
    boSkill_114_MP: False;
    boSkill_68_MP: False;

    tiOpenSystem: True;
    tiPutAbilOnce: True;
    nDetectItemRate: 3;
    nMakeItemButchRate: 4;
    nMakeItemRate: 10;

    tiSpiritAddRate: 50;
    tiSpiritAddValueRate: 8;

    tiSecretPropertyAddRate: 20;
    tiSecretPropertyAddValueMaxLimit: 4;
    tiSecretPropertyAddValueRate: 8;

    tiSucessRate: 95;
    tiSucessRateEx: 400;
    tiExchangeItemRate: 90;
    spSecretPropertySucessRate: 100;
    spMakeBookSucessRate: 100;
    spEnergyAddTime: 6912;
    tiSpSkillAddHPMax: True;
    tiHPSkillAddHPMax: True;
    tiMPSkillAddMPMax: True;
    tiAddHealthPlus_0: 200;
    tiAddHealthPlus_1: 60;
    tiAddHealthPlus_2: 140;
    tiAddSpellPlus_0: 40;
    tiAddSpellPlus_1: 150;
    tiAddSpellPlus_2: 220;

    tiWeaponDCAddRate: 30;
    tiWeaponDCAddValueMaxLimit: 10;
    tiWeaponDCAddValueRate: 10;
    tiWeaponMCAddRate: 30;
    tiWeaponMCAddValueMaxLimit: 10;
    tiWeaponMCAddValueRate: 10;
    tiWeaponSCAddRate: 30;
    tiWeaponSCAddValueMaxLimit: 10;
    tiWeaponSCAddValueRate: 10;
    tiWeaponLuckAddRate: 200;
    tiWeaponLuckAddValueMaxLimit: 3;
    tiWeaponLuckAddValueRate: 25;
    tiWeaponCurseAddRate: 90;
    tiWeaponCurseAddValueMaxLimit: 3;
    tiWeaponCurseAddValueRate: 15;
    tiWeaponHitAddRate: 150;
    tiWeaponHitAddValueMaxLimit: 3;
    tiWeaponHitAddValueRate: 12;
    tiWeaponHitSpdAddRate: 999;
    tiWeaponHitSpdAddValueMaxLimit: 2;
    tiWeaponHitSpdAddValueRate: 12;
    tiWeaponHolyAddRate: 300;
    tiWeaponHolyAddValueMaxLimit: 10;
    tiWeaponHolyAddValueRate: 15;

    tiWearingDCAddRate: 32;
    tiWearingDCAddValueMaxLimit: 10;
    tiWearingDCAddValueRate: 10;
    tiWearingMCAddRate: 32;
    tiWearingMCAddValueMaxLimit: 10;
    tiWearingMCAddValueRate: 10;
    tiWearingSCAddRate: 32;
    tiWearingSCAddValueMaxLimit: 10;
    tiWearingSCAddValueRate: 10;
    tiWearingACAddRate: 28;
    tiWearingACAddValueMaxLimit: 12;
    tiWearingACAddValueRate: 10;
    tiWearingMACAddRate: 28;
    tiWearingMACAddValueMaxLimit: 12;
    tiWearingMACAddValueRate: 10;

    tiWearingHitAddRate: 30;
    tiWearingHitAddValueMaxLimit: 8;
    tiWearingHitAddValueRate: 10;
    tiWearingSpeedAddRate: 35;
    tiWearingSpeedAddValueMaxLimit: 5;
    tiWearingSpeedAddValueRate: 10;
    tiWearingLuckAddRate: 50;
    tiWearingLuckAddValueMaxLimit: 3;
    tiWearingLuckAddValueRate: 15;
    tiWearingAntiMagicAddRate: 35;
    tiWearingAntiMagicAddValueMaxLimit: 5;
    tiWearingAntiMagicAddValueRate: 12;
    tiWearingHealthRecoverAddRate: 32;
    tiWearingHealthRecoverAddValueMaxLimit: 4;
    tiWearingHealthRecoverAddValueRate: 10;
    tiWearingSpellRecoverAddRate: 32;
    tiWearingSpellRecoverAddValueMaxLimit: 4;
    tiWearingSpellRecoverAddValueRate: 10;
    tiAbilTagDropAddRate: 60;
    tiAbilTagDropAddValueMaxLimit: 2;
    tiAbilTagDropAddValueRate: 20;
    tiAbilPreDropAddRate: 55;
    tiAbilPreDropAddValueMaxLimit: 2;
    tiAbilPreDropAddValueRate: 15;
    tiAbilSuckAddRate: 50;
    tiAbilSuckAddValueMaxLimit: 2;
    tiAbilSuckAddValueRate: 12;
    tiAbilIpRecoverAddRate: 45;
    tiAbilIpRecoverAddValueMaxLimit: 5;
    tiAbilIpRecoverAddValueRate: 10;
    tiAbilIpExAddRate: 40;
    tiAbilIpExAddValueMaxLimit: 15;
    tiAbilIpExAddValueRate: 15;
    tiAbilIpDamAddRate: 40;
    tiAbilIpDamAddValueMaxLimit: 15;
    tiAbilIpDamAddValueRate: 15;
    tiAbilIpReduceAddRate: 40;
    tiAbilIpReduceAddValueMaxLimit: 15;
    tiAbilIpReduceAddValueRate: 15;
    tiAbilIpDecAddRate: 35;
    tiAbilIpDecAddValueMaxLimit: 12;
    tiAbilIpDecAddValueRate: 12;
    tiAbilBangAddRate: 30;
    tiAbilBangAddValueMaxLimit: 15;
    tiAbilBangAddValueRate: 10;
    tiAbilGangUpAddRate: 28;
    tiAbilGangUpAddValueMaxLimit: 15;
    tiAbilGangUpAddValueRate: 10;
    tiAbilPalsyReduceAddRate: 50;
    tiAbilPalsyReduceAddValueMaxLimit: 2;
    tiAbilPalsyReduceAddValueRate: 18;
    tiAbilHPExAddRate: 40;
    tiAbilHPExAddValueMaxLimit: 15;
    tiAbilHPExAddValueRate: 15;
    tiAbilMPExAddRate: 40;
    tiAbilMPExAddValueMaxLimit: 15;
    tiAbilMPExAddValueRate: 15;
    tiAbilCCAddRate: 30;
    tiAbilCCAddValueMaxLimit: 10;
    tiAbilCCAddValueRate: 12;
    tiAbilPoisonReduceAddRate: 40;
    tiAbilPoisonReduceAddValueMaxLimit: 5;
    tiAbilPoisonReduceAddValueRate: 12;
    tiAbilPoisonRecoverAddRate: 40;
    tiAbilPoisonRecoverAddValueMaxLimit: 5;
    tiAbilPoisonRecoverAddValueRate: 12;

    tiSpecialSkills1AddRate: 150;
    tiSpecialSkills2AddRate: 150;
    tiSpecialSkills3AddRate: 150;
    tiSpecialSkills4AddRate: 150;
    tiSpecialSkills5AddRate: 150;
    tiSpecialSkills6AddRate: 150;
    tiSpecialSkills7AddRate: 150;

    tiSpMagicAddAtFirst: False;
    tiSpMagicAddMaxLevel: 12;
    tiSpMagicAddRate1: 450;
    tiSpMagicAddRate2: 450;
    tiSpMagicAddRate3: 450;
    tiSpMagicAddRate4: 450;
    tiSpMagicAddRate5: 450;
    tiSpMagicAddRate6: 450;
    tiSpMagicAddRate7: 450;
    tiSpMagicAddRate8: 450;

    tiGift_weapon: '主宰神剑';
    tiGift_dress_m: '主宰神甲(男)';
    tiGift_dress_w: '主宰神甲(女)';
    tiGift_medal: '主宰勋章';
    tiGift_necklace: '主宰项链';
    tiGift_helmet: '主宰之冠';
    tiGift_helmetex: '主宰斗笠';
    tiGift_mask: '主宰面巾';
    tiGift_armring: '主宰护腕';
    tiGift_ring: '主宰之戒';
    tiGift_belt: '主宰腰带';
    tiGift_boots: '主宰之靴';

    sSnowMobName1: '温顺的冰眼巨魔';
    sSnowMobName2: '降伏的冰眼巨魔';
    sSnowMobName3: '追随的冰眼巨魔';

    fPosMoveAttackOnItem: False;
    fPosMoveAttackParalysisPlayer: False;
    nPosMoveAttackPowerRate: 100;
    nPosMoveAttackInterval: 30;

    fMagicIceRainParalysisPlayer: False;
    nMagicIceRainPowerRate: 100;
    nMagicIceRainInterval: 30;

    fMagicDeadEyeParalysisPlayer: False;
    nMagicDeadEyePowerRate: 100;
    nMagicDeadEyeInterval: 30;
    nMagicDragonRageInterval: 90;
    nMagicDragonRageDuration: 10;
    nMagicDragonRageDamageAdd: 10000;

    boPresendItem: True;
    boSearchHumanOutSafeZone: False;
    nHealingRate: 5;
    fDieDeductionExp: True;

    fProcClientHWID: False;
    nMaxClientCount: 20;
    boHeroHomicideAddMasterPkPoint: True;
    );

  g_boEnCodePassword        : Boolean = False;
  sDBName                   : string = 'HeroDB'; //BDE 数据源名称
  g_sADODBString            : string = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\Envir\Data.mdb;Persist Security Info=False'; //ADO 数据源名称

{$IF OEMVER = OEM775}
  g_LevelInfo               : array[0..MAXLEVEL] of TLevelInfo;
{$IFEND}

  g_dwOldNeedExps           : TLevelNeedExp = (
    100,                                //1
    200,                                //2
    300,                                //3
    400,                                //4
    600,                                //5
    900,                                //6
    1200,                               //7
    1700,                               //8
    2500,                               //9
    6000,                               //10
    8000,                               //11
    10000,                              //12
    15000,                              //13
    30000,                              //14
    40000,                              //15
    50000,                              //16
    70000,                              //17
    100000,                             //18
    120000,                             //19
    140000,                             //20
    250000,                             //21
    300000,                             //22
    350000,                             //23
    400000,                             //24
    500000,                             //25
    700000,                             //26
    1000000,                            //27
    1400000,                            //28
    1800000,                            //29
    2000000,                            //30
    2400000,                            //31
    2800000,                            //32
    3200000,                            //33
    3600000,                            //34
    4000000,                            //35
    4800000,                            //36
    5600000,                            //37
    8200000,                            //38
    9000000,                            //39
    12000000,                           //40
    16000000,                           //41
    30000000,                           //42
    50000000,                           //43
    80000000,                           //44
    120000000,                          //45
    480000000,                          //46
    1000000000,                         //47
    3000000000,                         //48
    3500000000,                         //49
    4000000000,                         //50
    4000000000,                         //51
    4000000000,                         //52
    4000000000,                         //53
    4000000000,                         //54
    4000000000,                         //55
    4000000000,                         //56
    4000000000,                         //57
    4000000000,                         //58
    4000000000,                         //59
    4000000000,                         //60
    4000000000,                         //61
    4000000000,                         //62
    4000000000,                         //63
    4000000000,                         //64
    4000000000,                         //65
    4000000000,                         //66
    4000000000,                         //67
    4000000000,                         //68
    4000000000,                         //69
    4000000000,                         //70
    4000000000,                         //71
    4000000000,                         //72
    4000000000,                         //73
    4000000000,                         //74
    4000000000,                         //75
    4000000000,                         //76
    4000000000,                         //77
    4000000000,                         //78
    4000000000,                         //79
    4000000000,                         //80
    4000000000,                         //81
    4000000000,                         //82
    4000000000,                         //83
    4000000000,                         //84
    4000000000,                         //85
    4000000000,                         //86
    4000000000,                         //87
    4000000000,                         //88
    4000000000,                         //89
    4000000000,                         //90
    4000000000,                         //91
    4000000000,                         //92
    4000000000,                         //93
    4000000000,                         //94
    4000000000,                         //95
    4000000000,                         //96
    4000000000,                         //97
    4000000000,                         //98
    4000000000,                         //99
    4000000000,                         //100
    4000000000,                         //101
    4000000000,                         //102
    4000000000,                         //103
    4000000000,                         //104
    4000000000,                         //105
    4000000000,                         //106
    4000000000,                         //107
    4000000000,                         //108
    4000000000,                         //109
    4000000000,                         //110
    4000000000,                         //111
    4000000000,                         //112
    4000000000,                         //113
    4000000000,                         //114
    4000000000,                         //115
    4000000000,                         //116
    4000000000,                         //117
    4000000000,                         //118
    4000000000,                         //119
    4000000000,                         //120
    4000000000,                         //121
    4000000000,                         //122
    4000000000,                         //123
    4000000000,                         //124
    4000000000,                         //125
    4000000000,                         //126
    4000000000,                         //127
    4000000000,                         //128
    4000000000,                         //129
    4000000000,                         //130
    4000000000,                         //131
    4000000000,                         //132
    4000000000,                         //133
    4000000000,                         //134
    4000000000,                         //135
    4000000000,                         //136
    4000000000,                         //137
    4000000000,                         //138
    4000000000,                         //139
    4000000000,                         //140
    4000000000,                         //141
    4000000000,                         //142
    4000000000,                         //143
    4000000000,                         //144
    4000000000,                         //145
    4000000000,                         //146
    4000000000,                         //147
    4000000000,                         //148
    4000000000,                         //149
    4000000000,                         //150
    4000000000,                         //151
    4000000000,                         //152
    4000000000,                         //153
    4000000000,                         //154
    4000000000,                         //155
    4000000000,                         //156
    4000000000,                         //157
    4000000000,                         //158
    4000000000,                         //159
    4000000000,                         //160
    4000000000,                         //161
    4000000000,                         //162
    4000000000,                         //163
    4000000000,                         //164
    4000000000,                         //165
    4000000000,                         //166
    4000000000,                         //167
    4000000000,                         //168
    4000000000,                         //169
    4000000000,                         //170
    4000000000,                         //171
    4000000000,                         //172
    4000000000,                         //173
    4000000000,                         //174
    4000000000,                         //175
    4000000000,                         //176
    4000000000,                         //177
    4000000000,                         //178
    4000000000,                         //179
    4000000000,                         //180
    4000000000,                         //181
    4000000000,                         //182
    4000000000,                         //183
    4000000000,                         //184
    4000000000,                         //185
    4000000000,                         //186
    4000000000,                         //187
    4000000000,                         //188
    4000000000,                         //189
    4000000000,                         //190
    4000000000,                         //191
    4000000000,                         //192
    4000000000,                         //193
    4000000000,                         //194
    4000000000,                         //195
    4000000000,                         //196
    4000000000,                         //197
    4000000000,                         //198
    4000000000,                         //199
    4000000000,                         //200
    4000000000,                         //201
    4000000000,                         //202
    4000000000,                         //203
    4000000000,                         //204
    4000000000,                         //205
    4000000000,                         //206
    4000000000,                         //207
    4000000000,                         //208
    4000000000,                         //209
    4000000000,                         //210
    4000000000,                         //211
    4000000000,                         //212
    4000000000,                         //213
    4000000000,                         //214
    4000000000,                         //215
    4000000000,                         //216
    4000000000,                         //217
    4000000000,                         //218
    4000000000,                         //219
    4000000000,                         //220
    4000000000,                         //221
    4000000000,                         //222
    4000000000,                         //223
    4000000000,                         //224
    4000000000,                         //225
    4000000000,                         //226
    4000000000,                         //227
    4000000000,                         //228
    4000000000,                         //229
    4000000000,                         //230
    4000000000,                         //231
    4000000000,                         //232
    4000000000,                         //233
    4000000000,                         //234
    4000000000,                         //235
    4000000000,                         //236
    4000000000,                         //237
    4000000000,                         //238
    4000000000,                         //239
    4000000000,                         //240
    4000000000,                         //241
    4000000000,                         //242
    4000000000,                         //243
    4000000000,                         //244
    4000000000,                         //245
    4000000000,                         //246
    4000000000,                         //247
    4000000000,                         //248
    4000000000,                         //249
    4000000000,                         //250
    4000000000,                         //251
    4000000000,                         //252
    4000000000,                         //253
    4000000000,                         //254
    4000000000,                         //255
    4000000000,                         //256
    4000000000,                         //257
    4000000000,                         //258
    4000000000,                         //259
    4000000000,                         //260
    4000000000,                         //261
    4000000000,                         //262
    4000000000,                         //263
    4000000000,                         //264
    4000000000,                         //265
    4000000000,                         //266
    4000000000,                         //267
    4000000000,                         //268
    4000000000,                         //269
    4000000000,                         //270
    4000000000,                         //271
    4000000000,                         //272
    4000000000,                         //273
    4000000000,                         //274
    4000000000,                         //275
    4000000000,                         //276
    4000000000,                         //277
    4000000000,                         //278
    4000000000,                         //279
    4000000000,                         //280
    4000000000,                         //281
    4000000000,                         //282
    4000000000,                         //283
    4000000000,                         //284
    4000000000,                         //285
    4000000000,                         //286
    4000000000,                         //287
    4000000000,                         //288
    4000000000,                         //289
    4000000000,                         //290
    4000000000,                         //291
    4000000000,                         //292
    4000000000,                         //293
    4000000000,                         //294
    4000000000,                         //295
    4000000000,                         //296
    4000000000,                         //297
    4000000000,                         //298
    4000000000,                         //299
    4000000000,                         //300
    4000000000,                         //301
    4000000000,                         //302
    4000000000,                         //303
    4000000000,                         //304
    4000000000,                         //305
    4000000000,                         //306
    4000000000,                         //307
    4000000000,                         //308
    4000000000,                         //309
    4000000000,                         //310
    4000000000,                         //311
    4000000000,                         //312
    4000000000,                         //313
    4000000000,                         //314
    4000000000,                         //315
    4000000000,                         //316
    4000000000,                         //317
    4000000000,                         //318
    4000000000,                         //319
    4000000000,                         //320
    4000000000,                         //321
    4000000000,                         //322
    4000000000,                         //323
    4000000000,                         //324
    4000000000,                         //325
    4000000000,                         //326
    4000000000,                         //327
    4000000000,                         //328
    4000000000,                         //329
    4000000000,                         //330
    4000000000,                         //331
    4000000000,                         //332
    4000000000,                         //333
    4000000000,                         //334
    4000000000,                         //335
    4000000000,                         //336
    4000000000,                         //337
    4000000000,                         //338
    4000000000,                         //339
    4000000000,                         //340
    4000000000,                         //341
    4000000000,                         //342
    4000000000,                         //343
    4000000000,                         //344
    4000000000,                         //345
    4000000000,                         //346
    4000000000,                         //347
    4000000000,                         //348
    4000000000,                         //349
    4000000000,                         //350
    4000000000,                         //351
    4000000000,                         //352
    4000000000,                         //353
    4000000000,                         //354
    4000000000,                         //355
    4000000000,                         //356
    4000000000,                         //357
    4000000000,                         //358
    4000000000,                         //359
    4000000000,                         //360
    4000000000,                         //361
    4000000000,                         //362
    4000000000,                         //363
    4000000000,                         //364
    4000000000,                         //365
    4000000000,                         //366
    4000000000,                         //367
    4000000000,                         //368
    4000000000,                         //369
    4000000000,                         //370
    4000000000,                         //371
    4000000000,                         //372
    4000000000,                         //373
    4000000000,                         //374
    4000000000,                         //375
    4000000000,                         //376
    4000000000,                         //377
    4000000000,                         //378
    4000000000,                         //379
    4000000000,                         //380
    4000000000,                         //381
    4000000000,                         //382
    4000000000,                         //383
    4000000000,                         //384
    4000000000,                         //385
    4000000000,                         //386
    4000000000,                         //387
    4000000000,                         //388
    4000000000,                         //389
    4000000000,                         //390
    4000000000,                         //391
    4000000000,                         //392
    4000000000,                         //393
    4000000000,                         //394
    4000000000,                         //395
    4000000000,                         //396
    4000000000,                         //397
    4000000000,                         //398
    4000000000,                         //399
    4000000000,                         //400
    4000000000,                         //401
    4000000000,                         //402
    4000000000,                         //403
    4000000000,                         //404
    4000000000,                         //405
    4000000000,                         //406
    4000000000,                         //407
    4000000000,                         //408
    4000000000,                         //409
    4000000000,                         //410
    4000000000,                         //411
    4000000000,                         //412
    4000000000,                         //413
    4000000000,                         //414
    4000000000,                         //415
    4000000000,                         //416
    4000000000,                         //417
    4000000000,                         //418
    4000000000,                         //419
    4000000000,                         //420
    4000000000,                         //421
    4000000000,                         //422
    4000000000,                         //423
    4000000000,                         //424
    4000000000,                         //425
    4000000000,                         //426
    4000000000,                         //427
    4000000000,                         //428
    4000000000,                         //429
    4000000000,                         //430
    4000000000,                         //431
    4000000000,                         //432
    4000000000,                         //433
    4000000000,                         //434
    4000000000,                         //435
    4000000000,                         //436
    4000000000,                         //437
    4000000000,                         //438
    4000000000,                         //439
    4000000000,                         //440
    4000000000,                         //441
    4000000000,                         //442
    4000000000,                         //443
    4000000000,                         //444
    4000000000,                         //445
    4000000000,                         //446
    4000000000,                         //447
    4000000000,                         //448
    4000000000,                         //449
    4000000000,                         //450
    4000000000,                         //451
    4000000000,                         //452
    4000000000,                         //453
    4000000000,                         //454
    4000000000,                         //455
    4000000000,                         //456
    4000000000,                         //457
    4000000000,                         //458
    4000000000,                         //459
    4000000000,                         //460
    4000000000,                         //461
    4000000000,                         //462
    4000000000,                         //463
    4000000000,                         //464
    4000000000,                         //465
    4000000000,                         //466
    4000000000,                         //467
    4000000000,                         //468
    4000000000,                         //469
    4000000000,                         //470
    4000000000,                         //471
    4000000000,                         //472
    4000000000,                         //473
    4000000000,                         //474
    4000000000,                         //475
    4000000000,                         //476
    4000000000,                         //477
    4000000000,                         //478
    4000000000,                         //479
    4000000000,                         //480
    4000000000,                         //481
    4000000000,                         //482
    4000000000,                         //483
    4000000000,                         //484
    4000000000,                         //485
    4000000000,                         //486
    4000000000,                         //487
    4000000000,                         //488
    4000000000,                         //489
    4000000000,                         //490
    4000000000,                         //491
    4000000000,                         //492
    4000000000,                         //493
    4000000000,                         //494
    4000000000,                         //495
    4000000000,                         //496
    4000000000,                         //497
    4000000000,                         //498
    4000000000,                         //499
    4000000000                          //500
    );

  g_GameCommand             : TGameCommand = (
    Data: (sCmd: 'Date'; nPermissionMin: 0; nPermissionMax: 10);
    PRVMSG: (sCmd: 'PrvMsg'; nPermissionMin: 0; nPermissionMax: 10);
    ALLOWMSG: (sCmd: 'AllowMsg'; nPermissionMin: 0; nPermissionMax: 10);
    LETSHOUT: (sCmd: 'LetShout'; nPermissionMin: 0; nPermissionMax: 10);
    LETTRADE: (sCmd: 'LetTrade'; nPermissionMin: 0; nPermissionMax: 10);
    LETGUILD: (sCmd: 'LetGuild'; nPermissionMin: 0; nPermissionMax: 10);
    ENDGUILD: (sCmd: 'EndGuild'; nPermissionMin: 0; nPermissionMax: 10);
    BANGUILDCHAT: (sCmd: 'BanGuildChat'; nPermissionMin: 0; nPermissionMax: 10);
    AUTHALLY: (sCmd: 'AuthAlly'; nPermissionMin: 0; nPermissionMax: 10);
    AUTH: (sCmd: '联盟'; nPermissionMin: 0; nPermissionMax: 10);
    AUTHCANCEL: (sCmd: '取消联盟'; nPermissionMin: 0; nPermissionMax: 10);
    DIARY: (sCmd: 'Diary'; nPermissionMin: 0; nPermissionMax: 10);
    USERMOVE: (sCmd: 'Move'; nPermissionMin: 0; nPermissionMax: 10);
    SEARCHING: (sCmd: 'Searching'; nPermissionMin: 0; nPermissionMax: 10);
    ALLOWGROUPCALL: (sCmd: 'AllowGroupRecall'; nPermissionMin: 0; nPermissionMax: 10);
    GROUPRECALLL: (sCmd: 'GroupRecall'; nPermissionMin: 0; nPermissionMax: 10);
    ALLOWGUILDRECALL: (sCmd: 'AllowGuildRecall'; nPermissionMin: 0; nPermissionMax: 10);
    GUILDRECALLL: (sCmd: 'GuildRecall'; nPermissionMin: 0; nPermissionMax: 10);
    UNLOCKSTORAGE: (sCmd: 'UnLockStorage'; nPermissionMin: 0; nPermissionMax: 10);
    UnLock: (sCmd: 'UnLock'; nPermissionMin: 0; nPermissionMax: 10);
    Lock: (sCmd: 'Lock'; nPermissionMin: 0; nPermissionMax: 10);
    PASSWORDLOCK: (sCmd: 'PasswordLock'; nPermissionMin: 0; nPermissionMax: 10);
    SETPASSWORD: (sCmd: 'SetPassword'; nPermissionMin: 0; nPermissionMax: 10);
    CHGPASSWORD: (sCmd: 'ChgPassword'; nPermissionMin: 0; nPermissionMax: 10);
    CLRPASSWORD: (sCmd: 'ClrPassword'; nPermissionMin: 10; nPermissionMax: 10);
    UNPASSWORD: (sCmd: 'UnPassword'; nPermissionMin: 0; nPermissionMax: 10);
    MEMBERFUNCTION: (sCmd: 'MemberFunc'; nPermissionMin: 0; nPermissionMax: 10);
    MEMBERFUNCTIONEX: (sCmd: 'MemberFuncEx'; nPermissionMin: 0; nPermissionMax: 10);
    DEAR: (sCmd: 'Dear'; nPermissionMin: 0; nPermissionMax: 10);
    ALLOWDEARRCALL: (sCmd: 'AllowDearRecall'; nPermissionMin: 0; nPermissionMax: 10);
    DEARRECALL: (sCmd: 'DearRecall'; nPermissionMin: 0; nPermissionMax: 10);
    Master: (sCmd: 'Master'; nPermissionMin: 0; nPermissionMax: 10);
    ALLOWMASTERRECALL: (sCmd: 'AllowMasterRecall'; nPermissionMin: 0; nPermissionMax: 10);
    MASTERECALL: (sCmd: 'MasterRecall'; nPermissionMin: 0; nPermissionMax: 10);
    ATTACKMODE: (sCmd: 'AttackMode'; nPermissionMin: 0; nPermissionMax: 10);
    REST: (sCmd: 'Rest'; nPermissionMin: 0; nPermissionMax: 10);
    TAKEONHORSE: (sCmd: '骑马'; nPermissionMin: 0; nPermissionMax: 10);
    TAKEOFHORSE: (sCmd: '下马'; nPermissionMin: 0; nPermissionMax: 10);
    HUMANLOCAL: (sCmd: 'HumanLocal'; nPermissionMin: 3; nPermissionMax: 10);
    Move: (sCmd: 'Move'; nPermissionMin: 3; nPermissionMax: 6);
    POSITIONMOVE: (sCmd: 'PositionMove'; nPermissionMin: 3; nPermissionMax: 6);
    SignMove: (sCmd: 'SignMove'; nPermissionMin: 10; nPermissionMax: 10);
    INFO: (sCmd: 'Info'; nPermissionMin: 3; nPermissionMax: 10);
    MOBLEVEL: (sCmd: 'MobLevel'; nPermissionMin: 3; nPermissionMax: 10);
    MOBCOUNT: (sCmd: 'MobCount'; nPermissionMin: 3; nPermissionMax: 10);
    HUMANCOUNT: (sCmd: 'HumanCount'; nPermissionMin: 3; nPermissionMax: 10);
    Map: (sCmd: 'Map'; nPermissionMin: 3; nPermissionMax: 10);
    KICK: (sCmd: 'Kick'; nPermissionMin: 10; nPermissionMax: 10);
    TING: (sCmd: 'Ting'; nPermissionMin: 10; nPermissionMax: 10);
    SUPERTING: (sCmd: 'SuperTing'; nPermissionMin: 10; nPermissionMax: 10);
    MAPMOVE: (sCmd: 'MapMove'; nPermissionMin: 10; nPermissionMax: 10);
    SHUTUP: (sCmd: 'Shutup'; nPermissionMin: 10; nPermissionMax: 10);
    RELEASESHUTUP: (sCmd: 'ReleaseShutup'; nPermissionMin: 10; nPermissionMax: 10);
    SHUTUPLIST: (sCmd: 'ShutupList'; nPermissionMin: 10; nPermissionMax: 10);
    GAMEMASTER: (sCmd: 'GameMaster'; nPermissionMin: 10; nPermissionMax: 10);
    OBSERVER: (sCmd: 'Observer'; nPermissionMin: 10; nPermissionMax: 10);
    SUEPRMAN: (sCmd: 'Superman'; nPermissionMin: 10; nPermissionMax: 10);
    Level: (sCmd: 'Level'; nPermissionMin: 10; nPermissionMax: 10);
    SABUKWALLGOLD: (sCmd: 'SabukWallGold'; nPermissionMin: 10; nPermissionMax: 10);
    RECALL: (sCmd: 'Recall'; nPermissionMin: 10; nPermissionMax: 10);
    REGOTO: (sCmd: 'ReGoto'; nPermissionMin: 10; nPermissionMax: 10);
    SHOWFLAG: (sCmd: 'showflag'; nPermissionMin: 10; nPermissionMax: 10);
    SHOWOPEN: (sCmd: 'showopen'; nPermissionMin: 10; nPermissionMax: 10);
    SHOWUNIT: (sCmd: 'showunit'; nPermissionMin: 10; nPermissionMax: 10);
    Attack: (sCmd: 'Attack'; nPermissionMin: 10; nPermissionMax: 10);
    MOB: (sCmd: 'Mob'; nPermissionMin: 10; nPermissionMax: 10);
    MOBNPC: (sCmd: 'MobNpc'; nPermissionMin: 10; nPermissionMax: 10);
    DELNPC: (sCmd: 'DelNpc'; nPermissionMin: 10; nPermissionMax: 10);
    NPCSCRIPT: (sCmd: 'NpcScript'; nPermissionMin: 10; nPermissionMax: 10);
    RECALLMOB: (sCmd: 'RecallMob'; nPermissionMin: 10; nPermissionMax: 10);
    LUCKYPOINT: (sCmd: 'LuckyPoint'; nPermissionMin: 10; nPermissionMax: 10);
    LOTTERYTICKET: (sCmd: 'LotteryTicket'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADGUILD: (sCmd: 'ReloadGuild'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADLINENOTICE: (sCmd: 'ReloadLineNotice'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADABUSE: (sCmd: 'ReloadAbuse'; nPermissionMin: 10; nPermissionMax: 10);
    BACKSTEP: (sCmd: 'Backstep'; nPermissionMin: 10; nPermissionMax: 10);
    BALL: (sCmd: 'Ball'; nPermissionMin: 10; nPermissionMax: 10);
    FREEPENALTY: (sCmd: 'FreePK'; nPermissionMin: 10; nPermissionMax: 10);
    PKPOINT: (sCmd: 'PKpoint'; nPermissionMin: 10; nPermissionMax: 10);
    IncPkPoint: (sCmd: 'IncPkPoint'; nPermissionMin: 10; nPermissionMax: 10);
    CHANGELUCK: (sCmd: 'ChangeLuck'; nPermissionMin: 10; nPermissionMax: 10);
    HUNGER: (sCmd: 'Hunger'; nPermissionMin: 10; nPermissionMax: 10);
    HAIR: (sCmd: 'hair'; nPermissionMin: 10; nPermissionMax: 10);
    TRAINING: (sCmd: 'Training'; nPermissionMin: 10; nPermissionMax: 10);
    DELETESKILL: (sCmd: 'DeleteSkill'; nPermissionMin: 10; nPermissionMax: 10);
    CHANGEJOB: (sCmd: 'ChangeJob'; nPermissionMin: 10; nPermissionMax: 10);
    CHANGEGENDER: (sCmd: 'ChangeGender'; nPermissionMin: 10; nPermissionMax: 10);
    NameColor: (sCmd: 'NameColor'; nPermissionMin: 10; nPermissionMax: 10);
    Mission: (sCmd: 'Mission'; nPermissionMin: 10; nPermissionMax: 10);
    MobPlace: (sCmd: 'MobPlace'; nPermissionMin: 10; nPermissionMax: 10);
    TRANSPARECY: (sCmd: 'Transparency'; nPermissionMin: 10; nPermissionMax: 10);
    DELETEITEM: (sCmd: 'DeleteItem'; nPermissionMin: 10; nPermissionMax: 10);
    LEVEL0: (sCmd: 'Level0'; nPermissionMin: 10; nPermissionMax: 10);
    CLEARMISSION: (sCmd: 'ClearMission'; nPermissionMin: 10; nPermissionMax: 10);
    SETFLAG: (sCmd: 'setflag'; nPermissionMin: 10; nPermissionMax: 10);
    SETOPEN: (sCmd: 'setopen'; nPermissionMin: 10; nPermissionMax: 10);
    SETUNIT: (sCmd: 'setunit'; nPermissionMin: 10; nPermissionMax: 10);
    RECONNECTION: (sCmd: 'Reconnection'; nPermissionMin: 10; nPermissionMax: 10);
    DISABLEFILTER: (sCmd: 'DisableFilter'; nPermissionMin: 10; nPermissionMax: 10);
    CHGUSERFULL: (sCmd: 'CHGUSERFULL'; nPermissionMin: 10; nPermissionMax: 10);
    CHGZENFASTSTEP: (sCmd: 'CHGZENFASTSTEP'; nPermissionMin: 10; nPermissionMax: 10);
    CONTESTPOINT: (sCmd: 'ContestPoint'; nPermissionMin: 10; nPermissionMax: 10);
    STARTCONTEST: (sCmd: 'StartContest'; nPermissionMin: 10; nPermissionMax: 10);
    ENDCONTEST: (sCmd: 'EndContest'; nPermissionMin: 10; nPermissionMax: 10);
    ANNOUNCEMENT: (sCmd: 'Announcement'; nPermissionMin: 10; nPermissionMax: 10);
    OXQUIZROOM: (sCmd: 'OXQuizRoom'; nPermissionMin: 10; nPermissionMax: 10);
    GSA: (sCmd: 'gsa'; nPermissionMin: 10; nPermissionMax: 10);
    CHANGEITEMNAME: (sCmd: 'ChangeItemName'; nPermissionMin: 10; nPermissionMax: 10);
    DISABLESENDMSG: (sCmd: 'DisableSendMsg'; nPermissionMin: 10; nPermissionMax: 10);
    ENABLESENDMSG: (sCmd: 'EnableSendMsg'; nPermissionMin: 10; nPermissionMax: 10);
    DISABLESENDMSGLIST: (sCmd: 'DisableSendMsgList'; nPermissionMin: 10; nPermissionMax: 10);
    KILL: (sCmd: 'Kill'; nPermissionMin: 10; nPermissionMax: 10);
    MAKE: (sCmd: 'make'; nPermissionMin: 10; nPermissionMax: 10);
    SMAKE: (sCmd: 'Supermake'; nPermissionMin: 10; nPermissionMax: 10);
    BonusPoint: (sCmd: 'BonusPoint'; nPermissionMin: 10; nPermissionMax: 10);
    DELBONUSPOINT: (sCmd: 'DelBonusPoint'; nPermissionMin: 10; nPermissionMax: 10);
    RESTBONUSPOINT: (sCmd: 'RestBonusPoint'; nPermissionMin: 10; nPermissionMax: 10);
    FIREBURN: (sCmd: 'FireBurn'; nPermissionMin: 10; nPermissionMax: 10);
    TESTFIRE: (sCmd: 'TestFire'; nPermissionMin: 10; nPermissionMax: 10);
    TESTSTATUS: (sCmd: 'TestStatus'; nPermissionMin: 10; nPermissionMax: 10);
    DELGOLD: (sCmd: 'DelGold'; nPermissionMin: 10; nPermissionMax: 10);
    ADDGOLD: (sCmd: 'AddGold'; nPermissionMin: 10; nPermissionMax: 10);
    DELGAMEGOLD: (sCmd: 'DelGamePoint'; nPermissionMin: 10; nPermissionMax: 10);
    ADDGAMEGOLD: (sCmd: 'AddGamePoint'; nPermissionMin: 10; nPermissionMax: 10);
    GAMEGOLD: (sCmd: 'GameGold'; nPermissionMin: 10; nPermissionMax: 10);
    GAMEPOINT: (sCmd: 'GamePoint'; nPermissionMin: 10; nPermissionMax: 10);
    CREDITPOINT: (sCmd: 'CreditPoint'; nPermissionMin: 10; nPermissionMax: 10);
    TESTGOLDCHANGE: (sCmd: 'Test_GOLD_Change'; nPermissionMin: 10; nPermissionMax: 10);
    REFINEWEAPON: (sCmd: 'RefineWeapon'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADADMIN: (sCmd: 'ReloadAdmin'; nPermissionMin: 10; nPermissionMax: 10);
    ReLoadNpc: (sCmd: 'ReloadNpc'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADMANAGE: (sCmd: 'ReloadManage'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADROBOTMANAGE: (sCmd: 'ReloadRobotManage'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADROBOT: (sCmd: 'ReloadRobot'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADMONITEMS: (sCmd: 'ReloadMonItems'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADDIARY: (sCmd: 'ReloadDiary'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADITEMDB: (sCmd: 'ReloadItemDB'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADMAGICDB: (sCmd: 'ReloadMagicDB'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADMONSTERDB: (sCmd: 'ReloadMonsterDB'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADMINMAP: (sCmd: 'ReLoadMinMap'; nPermissionMin: 10; nPermissionMax: 10);
    ReAlive: (sCmd: 'ReAlive'; nPermissionMin: 10; nPermissionMax: 10);
    ADJUESTLEVEL: (sCmd: 'AdjustLevel'; nPermissionMin: 10; nPermissionMax: 10);
    ADJUESTEXP: (sCmd: 'AdjustExp'; nPermissionMin: 10; nPermissionMax: 10);
    AddGuild: (sCmd: 'AddGuild'; nPermissionMin: 10; nPermissionMax: 10);
    DelGuild: (sCmd: 'DelGuild'; nPermissionMin: 10; nPermissionMax: 10);
    CHANGESABUKLORD: (sCmd: 'ChangeSabukLord'; nPermissionMin: 10; nPermissionMax: 10);
    FORCEDWALLCONQUESTWAR: (sCmd: 'ForcedWallconquestWar'; nPermissionMin: 10; nPermissionMax: 10);
    ADDTOITEMEVENT: (sCmd: 'AddToItemEvent'; nPermissionMin: 10; nPermissionMax: 10);
    ADDTOITEMEVENTASPIECES: (sCmd: 'AddToItemEventAsPieces'; nPermissionMin: 10; nPermissionMax: 10);
    ItemEventList: (sCmd: 'ItemEventList'; nPermissionMin: 10; nPermissionMax: 10);
    STARTINGGIFTNO: (sCmd: 'StartingGiftNo'; nPermissionMin: 10; nPermissionMax: 10);
    DELETEALLITEMEVENT: (sCmd: 'DeleteAllItemEvent'; nPermissionMin: 10; nPermissionMax: 10);
    STARTITEMEVENT: (sCmd: 'StartItemEvent'; nPermissionMin: 10; nPermissionMax: 10);
    ITEMEVENTTERM: (sCmd: 'ItemEventTerm'; nPermissionMin: 10; nPermissionMax: 10);
    ADJUESTTESTLEVEL: (sCmd: 'AdjustTestLevel'; nPermissionMin: 10; nPermissionMax: 10);
    TRAININGSKILL: (sCmd: 'TrainingSkill'; nPermissionMin: 10; nPermissionMax: 10);
    OPDELETESKILL: (sCmd: 'OPDeleteSkill'; nPermissionMin: 10; nPermissionMax: 10);
    CHANGEWEAPONDURA: (sCmd: 'ChangeWeaponDura'; nPermissionMin: 10; nPermissionMax: 10);
    RELOADGUILDALL: (sCmd: 'ReloadGuildAll'; nPermissionMin: 10; nPermissionMax: 10);
    WHO: (sCmd: 'Who '; nPermissionMin: 3; nPermissionMax: 10);
    TOTAL: (sCmd: 'Total '; nPermissionMin: 5; nPermissionMax: 10);
    TESTGA: (sCmd: 'Testga'; nPermissionMin: 10; nPermissionMax: 10);
    MAPINFO: (sCmd: 'MapInfo'; nPermissionMin: 10; nPermissionMax: 10);
    SBKDOOR: (sCmd: 'SbkDoor'; nPermissionMin: 10; nPermissionMax: 10);
    CHANGEDEARNAME: (sCmd: 'DearName'; nPermissionMin: 10; nPermissionMax: 10);
    CHANGEMASTERNAME: (sCmd: 'MasterName'; nPermissionMin: 10; nPermissionMax: 10);
    STARTQUEST: (sCmd: 'StartQuest'; nPermissionMin: 10; nPermissionMax: 10);
    SETPERMISSION: (sCmd: 'SetPermission'; nPermissionMin: 10; nPermissionMax: 10);
    CLEARMON: (sCmd: 'ClearMon'; nPermissionMin: 10; nPermissionMax: 10);
    RENEWLEVEL: (sCmd: 'ReNewLevel'; nPermissionMin: 10; nPermissionMax: 10);
    DENYIPLOGON: (sCmd: 'DenyIPLogon'; nPermissionMin: 10; nPermissionMax: 10);
    DENYACCOUNTLOGON: (sCmd: 'DenyAccountLogon'; nPermissionMin: 10; nPermissionMax: 10);
    DENYCHARNAMELOGON: (sCmd: 'DenyCharNameLogon'; nPermissionMin: 10; nPermissionMax: 10);
    DELDENYIPLOGON: (sCmd: 'DelDenyIPLogon'; nPermissionMin: 10; nPermissionMax: 10);
    DELDENYACCOUNTLOGON: (sCmd: 'DelDenyAccountLogon'; nPermissionMin: 10; nPermissionMax: 10);
    DELDENYCHARNAMELOGON: (sCmd: 'DelDenyCharNameLogon'; nPermissionMin: 10; nPermissionMax: 10);
    SHOWDENYIPLOGON: (sCmd: 'ShowDenyIPLogon'; nPermissionMin: 10; nPermissionMax: 10);
    SHOWDENYACCOUNTLOGON: (sCmd: 'ShowDenyAccountLogon'; nPermissionMin: 10; nPermissionMax: 10);
    SHOWDENYCHARNAMELOGON: (sCmd: 'ShowDenyCharNameLogon'; nPermissionMin: 10; nPermissionMax: 10);
    VIEWWHISPER: (sCmd: 'ViewWhisper'; nPermissionMin: 10; nPermissionMax: 10);
    Spirit: (sCmd: '祈祷生效'; nPermissionMin: 10; nPermissionMax: 10);
    SpiritStop: (sCmd: '停止叛变'; nPermissionMin: 10; nPermissionMax: 10);
    SetMapMode: (sCmd: 'SetMapMode'; nPermissionMin: 10; nPermissionMax: 10);
    SHOWMAPMODE: (sCmd: 'ShowMapMode'; nPermissionMin: 10; nPermissionMax: 10);
    TESTSERVERCONFIG: (sCmd: 'TestServerConfig'; nPermissionMin: 10; nPermissionMax: 10);
    SERVERSTATUS: (sCmd: 'ServerStatus'; nPermissionMin: 10; nPermissionMax: 10);
    TESTGETBAGITEM: (sCmd: 'TestGetBagItem'; nPermissionMin: 10; nPermissionMax: 10);
    CLEARBAG: (sCmd: 'ClearBag'; nPermissionMin: 10; nPermissionMax: 10);
    SHOWUSEITEMINFO: (sCmd: 'ShowUseItemInfo'; nPermissionMin: 10; nPermissionMax: 10);
    BINDUSEITEM: (sCmd: 'BindUseItem'; nPermissionMin: 10; nPermissionMax: 10);
    MOBFIREBURN: (sCmd: 'MobFireBurn'; nPermissionMin: 10; nPermissionMax: 10);
    TESTSPEEDMODE: (sCmd: 'TestSpeedMode'; nPermissionMin: 10; nPermissionMax: 10);
    LOCKLOGON: (sCmd: 'LockLogin'; nPermissionMin: 0; nPermissionMax: 0);
    UNLOCKLOGON: (sCmd: 'UnLockLogin'; nPermissionMin: 0; nPermissionMax: 0);
    RemoteMusic: (sCmd: 'RemoteMusic'; nPermissionMin: 0; nPermissionMax: 0);
    RemoteMsg: (sCmd: 'RemoteMsg'; nPermissionMin: 0; nPermissionMax: 0);
    INITSABUK: (sCmd: 'InitSabuk'; nPermissionMin: 10; nPermissionMax: 10);
    );

  sClientSoftVersionError   : string = '游戏版本错误';
  sDownLoadNewClientSoft    : string = '请到网站上下载最新版本游戏客户端软件';
  sForceDisConnect          : string = '连接被强行中断';
  sClientSoftVersionTooOld  : string = '您现在使用的客户端软件版本太老了，大量的游戏效果新将无法使用';
  sDownLoadAndUseNewClient  : string = '为了更好的进行游戏，请下载最新的客户端软件';
  sOnlineUserFull           : string = '可允许的玩家数量已满';
  sYouNowIsTryPlayMode      : string = '你现在处于测试中，你可以在七级以前使用，但是会限制你的一些功能';
  g_sNowIsFreePlayMode      : string = '当前服务器运行于测试模式';
  sAttackModeOfAll          : string = '[全体攻击模式]';
  sAttackModeOfPeaceful     : string = '[和平攻击模式]';
  sAttackModeOfDear         : string = '[夫妻攻击模式]';
  sAttackModeOfMaster       : string = '[师徒攻击模式]';
  sAttackModeOfGroup        : string = '[编组攻击模式]';
  sAttackModeOfGuild        : string = '[行会攻击模式]';
  sAttackModeOfRedWhite     : string = '[善&恶攻击模式]';
  sStartChangeAttackModeHelp: string = '使用组合快捷键 CTRL-H 更改攻击模式..';
  sStartHeroAttackModeHelp  : string = '(英雄) 英雄行动: %s';
  sStartHeroModeHelp        : string = '(英雄) 状态更改：CTRL-E 指定攻击目标：CTRL-W 守护位置：CTRL-Q 使用合击技: CTRL-S';

  sStartNoticeMsg           : string = '欢迎进入本服务器进行游戏..';

  sThrustingOn              : string = '启用刺杀剑法';
  sThrustingOff             : string = '关闭刺杀剑法';
  sHalfMoonOn               : string = '开启半月弯刀';
  sHalfMoonOff              : string = '关闭半月弯刀';
  sCrsHitOn                 : string = '开启抱月刀';
  sCrsHitOff                : string = '关闭抱月刀';
  sFireSpiritsSummoned      : string = '召唤烈火精灵成功...';
  //sFireSpiritsFail          : string = '召唤烈火精灵失败';
  sSpiritsGone              : string = '召唤烈火结束';

  sPursueSpiritsSummoned    : string = '凝聚逐日剑法力量成功...';
  //sPursueSpiritsFail        : string = '凝聚逐日剑法力量失败';
  sPursueSpiritsGone        : string = '逐日剑法力量消失';

  //sTwinSpiritsSummoned      : string = '召集雷电力量成功...';
  //sTwinSpiritsFail          : string = '召集雷电力量失败';
  //sTwinSpiritsGone          : string = '雷电的力量消失了';

  sMateDoTooweak            : string = '冲撞力不够';

  sHeroRest                 : string = '英雄行动：休息';
  sHeroAttack               : string = '英雄行动：攻击';
  sHeroFolow                : string = '英雄行动：跟随';
  g_sTheWeaponBroke         : string = '武器破碎';
  sTheWeaponRefineSuccessfull: string = '升级成功';
  sYouPoisoned              : string = '中毒了';
  sHeroSearchTag            : string = '(英雄) 守护位置：%d:%d';
  sUnHeroSearchTag          : string = '(英雄) 停止守护';
  sPetRest                  : string = '下属：休息';
  sPetAttack                : string = '下属：攻击';
  sWearNotOfWoMan           : string = '非女性用品';
  sWearNotOfMan             : string = '非男性用品';
  sHandWeightNot            : string = '腕力不够';
  sWearWeightNot            : string = '负重力不够';
  g_sItemIsNotThisAccount   : string = '此物品不为此帐号所有';
  g_sItemIsNotThisIPaddr    : string = '此物品不为此IP所有';
  g_sItemIsNotThisCharName  : string = '此物品不为你所有';
  g_sLevelNot               : string = '等级不够';
  g_sJobOrLevelNot          : string = '职业不对或等级不够';
  g_sJobOrDCNot             : string = '职业不对或攻击力不够';
  g_sJobOrMCNot             : string = '职业不对或魔法力不够';
  g_sJobOrSCNot             : string = '职业不对或道术不够';
  g_sDCNot                  : string = '攻击力不够';
  g_sMCNot                  : string = '魔法力不够';
  g_sSCNot                  : string = '道术不够';
  g_sCreditPointNot         : string = '声望点不够';
  g_sReNewLevelNot          : string = '转生等级不够';
  g_sGuildNot               : string = '加入了行会才可以使用此物品';
  g_sGuildMasterNot         : string = '行会掌门才可以使用此物品';
  g_sSabukHumanNot          : string = '沙城成员才可以使用此物品';
  g_sSabukMasterManNot      : string = '沙城城主才可以使用此物品';
  g_sMemberNot              : string = '会员才可以使用此物品';
  g_sMemberTypeNot          : string = '指定类型的会员可以使用此物品';
  g_sCanottWearIt           : string = '此物品不适使用';

  sCanotUseDrugOnThisMap    : string = '此地图不允许使用任何药品';
  sGameMasterMode           : string = '已进入管理员模式';
  sReleaseGameMasterMode    : string = '已退出管理员模式';
  sObserverMode             : string = '已进入隐身模式';
  g_sReleaseObserverMode    : string = '已退出隐身模式';
  sSupermanMode             : string = '已进入无敌模式';
  sReleaseSupermanMode      : string = '已退出无敌模式';
  sYouFoundNothing          : string = '未获取任何物品';

  g_sNoPasswordLockSystemMsg: string = '游戏密码保护系统还没有启用';
  g_sAlreadySetPasswordMsg  : string = '仓库早已设置了一个密码，如需要修改密码请使用修改密码命令';
  g_sReSetPasswordMsg       : string = '请重复输入一次仓库密码:';
  g_sPasswordOverLongMsg    : string = '输入的密码长度不正确，密码长度必须在 4 - 7 的范围内，请重新设置密码';
  g_sReSetPasswordOKMsg     : string = '密码设置成功，仓库已经自动上锁，请记好您的仓库密码，在取仓库时需要使用此密码开锁';
  g_sReSetPasswordNotMatchMsg: string = '二次输入的密码不一致，请重新设置密码';
  g_sPleaseInputUnLockPasswordMsg: string = '请输入仓库密码:';
  g_sStorageUnLockOKMsg     : string = '密码输入成功，仓库已经开锁';
  g_sPasswordUnLockOKMsg    : string = '密码输入成功，密码系统已经开锁';
  g_sStorageAlreadyUnLockMsg: string = '仓库早已解锁';
  g_sStorageNoPasswordMsg   : string = '仓库还没设置密码';
  g_sUnLockPasswordFailMsg  : string = '密码输入错误，请检查好再输入';
  g_sLockStorageSuccessMsg  : string = '仓库加锁成功';
  g_sStoragePasswordClearMsg: string = '仓库密码已清除';
  g_sPleaseUnloadStoragePasswordMsg: string = '请先解锁密码再使用此命令清除密码';
  g_sStorageAlreadyLockMsg  : string = '仓库早已加锁了';
  g_sStoragePasswordLockedMsg: string = '由于密码输入错误超过三次，仓库密码已被锁定';
  g_sSetPasswordMsg         : string = '请输入一个长度为 4 - 7 位的仓库密码:';
  g_sPleaseInputOldPasswordMsg: string = '请输入原仓库密码: ';
  g_sOldPasswordIsClearMsg  : string = '密码已清除';
  g_sPleaseUnLockPasswordMsg: string = '请先解锁仓库密码后再用此命令清除密码';
  g_sNoPasswordSetMsg       : string = '仓库还没设置密码，请用设置密码命令设置仓库密码';
  g_sOldPasswordIncorrectMsg: string = '输入的原仓库密码不正确';
  g_sStorageIsLockedMsg     : string = '仓库已被加锁，请先输入仓库正确的开锁密码，再取物品';
  g_sActionIsLockedMsg      : string = '你当前已启用密码保护系统，请先输入正确的密码，才可以正常游戏';
  g_sPasswordNotSetMsg      : string = '对不起，没有设置仓库密码此功能无法使用，设置仓库密码请输入指令 @%s';
  g_sNotPasswordProtectMode : string = '你正处于非保护模式，如想你的装备更加安全，请输入指令 @%s';
  g_sPasswordProtectMode    : string = '你正处于保护模式，如果你想进入非保护模式，请输入指令:@%s';
  g_sCanotDropGoldMsg       : string = '太少的金币不允许扔在地上';
  g_sCanotDropInSafeZoneMsg : string = '安全区不允许扔东西在地上';
  g_sCanotDropItemMsg       : string = '无法执行当前动作';
  g_sCanotUseItemMsg        : string = '无法执行当前动作';
  g_sCanotTryDealMsg        : string = '无法执行当前动作';
  g_sPleaseTryDealLaterMsg  : string = '请稍候再交易';
  g_sDealItemsDenyGetBackMsg: string = '交易的金币或物品不可以取回，要取回请取消再重新交易';
  g_sDisableDealItemsMsg    : string = '交易功能暂时关闭';
  g_sDealActionCancelMsg    : string = '交易取消';
  g_sPoseDisableDealMsg     : string = '对方禁止进入交易';
  g_sDealSuccessMsg         : string = '交易成功..';
  g_sDealOKTooFast          : string = '过早按了成交按钮';
  g_sYourBagSizeTooSmall    : string = '你的背包空间不够，无法装下对方交易给你的物品';
  g_sDealHumanBagSizeTooSmall: string = '交易对方的背包空间不够，无法装下对方交易给你的物品';
  g_sYourGoldLargeThenLimit : string = '你的所带的金币太多，无法装下对方交易给你的金币';
  g_sDealHumanGoldLargeThenLimit: string = '交易对方的所带的金币太多，无法装下对方交易给你的金币';
  g_sYouDealOKMsg           : string = '你已经确认交易了';
  g_sPoseDealOKMsg          : string = '对方已经确认交易了';
  g_sKickClientUserMsg      : string = '请不要使用非法外挂软件';

  g_sStartMarryManMsg       : string = '[%n]: %s 与 %d 的婚礼现在开始..';
  g_sStartMarryWoManMsg     : string = '[%n]: %d 与 %s 的婚礼现在开始..';
  g_sStartMarryManAskQuestionMsg: string = '[%n]: %s 你愿意娶 %d 小姐为妻，并照顾她一生一世吗？';
  g_sStartMarryWoManAskQuestionMsg: string = '[%n]: %d 你愿意娶 %s 小姐为妻，并照顾她一生一世吗？';
  g_sMarryManAnswerQuestionMsg: string = '[%s]: 我愿意，%d 小姐我会尽我一生的时间来照顾您，让您过上快乐美满的日子的';
  g_sMarryManAskQuestionMsg : string = '[%n]: %d 你愿意嫁给 %s 先生为妻，并照顾他一生一世吗？';
  g_sMarryWoManAnswerQuestionMsg: string = '[%s]: 我愿意，%d 先生我愿意让你来照顾我，保护我';
  g_sMarryWoManGetMarryMsg  : string = '[%n]: 我宣布 %d 先生与 %s 小姐正式成为合法夫妻';
  g_sMarryWoManDenyMsg      : string = '[%s]: %d 你这个好色之徒，谁会愿意嫁给你呀，癞蛤蟆想吃天鹅肉';
  g_sMarryWoManCancelMsg    : string = '[%n]: 真是可惜，二个人这个时候才翻脸，你们培养好感情后再来找我吧';
  g_sfUnMarryManLoginMsg    : string = '你的老婆%d已经强行与你脱离了夫妻关系了';
  g_sfUnMarryWoManLoginMsg  : string = '你的老公%d已经强行与你脱离了夫妻关系了';
  g_sManLoginDearOnlineSelfMsg: string = '你的老婆%d当前位于%m(%x:%y)';
  g_sManLoginDearOnlineDearMsg: string = '你的老公%s在:%m(%x:%y)上线了';
  g_sWoManLoginDearOnlineSelfMsg: string = '你的老公当前位于%m(%x:%y)';
  g_sWoManLoginDearOnlineDearMsg: string = '你的老婆%s在:%m(%x:%y) 上线了';
  g_sManLoginDearNotOnlineMsg: string = '你的老婆现在不在线';
  g_sWoManLoginDearNotOnlineMsg: string = '你的老公现在不在线';
  g_sManLongOutDearOnlineMsg: string = '你的老公在:%m(%x:%y)下线了';
  g_sWoManLongOutDearOnlineMsg: string = '你的老婆在:%m(%x:%y)下线了';
  g_sYouAreNotMarryedMsg    : string = '你都没结婚查什么？';
  g_sYourWifeNotOnlineMsg   : string = '你的老婆还没有上线';
  g_sYourHusbandNotOnlineMsg: string = '你的老公还没有上线';
  g_sYourWifeNowLocateMsg   : string = '你的老婆现在位于:';
  g_sYourHusbandSearchLocateMsg: string = '你的老公正在找你，他现在位于:';
  g_sYourHusbandNowLocateMsg: string = '你的老公现在位于:';
  g_sYourWifeSearchLocateMsg: string = '你的老婆正在找你，他现在位于:';
  g_sfUnMasterLoginMsg      : string = '你的一个徒弟已经背判师门了';
  g_sfUnMasterListLoginMsg  : string = '你的师父%d已经将你逐出师门了';
  g_sMasterListOnlineSelfMsg: string = '你的师父%d当前位于%m(%x:%y)';
  g_sMasterListOnlineMasterMsg: string = '你的徒弟%s在:%m(%x:%y)上线了';
  g_sMasterOnlineSelfMsg    : string = '你的徒弟当前位于%m(%x:%y)';
  g_sMasterOnlineMasterListMsg: string = '你的师父%s在:%m(%x:%y) 上线了';
  g_sMasterLongOutMasterListOnlineMsg: string = '你的师父在:%m(%x:%y)下线了';
  g_sMasterListLongOutMasterOnlineMsg: string = '你的徒弟%s在:%m(%x:%y)下线了';
  g_sMasterListNotOnlineMsg : string = '你的师父现不在线';
  g_sMasterNotOnlineMsg     : string = '你的徒弟现不在线';
  g_sYouAreNotMasterMsg     : string = '你都没师徒关系查什么？';
  g_sYourMasterNotOnlineMsg : string = '你的师父还没有上线';
  g_sYourMasterListNotOnlineMsg: string = '你的徒弟还没有上线';
  g_sYourMasterNowLocateMsg : string = '你的师父现在位于:';
  g_sYourMasterListSearchLocateMsg: string = '你的徒弟正在找你，他现在位于:';
  g_sYourMasterListNowLocateMsg: string = '你的徒弟现在位于:';
  g_sYourMasterSearchLocateMsg: string = '你的师父正在找你，他现在位于:';
  g_sYourMasterListUnMasterOKMsg: string = '你的徒弟%d已经圆满出师了';
  g_sYouAreUnMasterOKMsg    : string = '你已经出师了';
  g_sUnMasterLoginMsg       : string = '你的一个徒弟已经圆满出师了';
  g_sNPCSayUnMasterOKMsg    : string = '[%n]: 我宣布%d与%s正式脱离师徒关系';
  g_sNPCSayForceUnMasterMsg : string = '[%n]: 我宣布%s与%d已经正式脱离师徒关系';
  g_sMyInfo                 : string;
  g_sSendOnlineCountMsg     : string = '当前在线人数: %c';
  g_sOpenedDealMsg          : string = '开始交易';
  g_sSendCustMsgCanNotUseNowMsg: string = '祝福语功能还没有开放';
  g_sSubkMasterMsgCanNotUseNowMsg: string = '城主发信息功能还没有开放';
  g_sWeaponRepairSuccess    : string = '武器修复成功..';
  g_sDefenceUpTime          : string = '防御力增加%d秒';
  g_sMagDefenceUpTime       : string = '魔法防御力增加%d秒';
  g_sAttPowerUpTime         : string = '物理攻击力增强，%d分钟%d秒';
  g_sAttPowerDownTime       : string = '物理攻击力减弱，%d分钟%d秒';
  g_sScPowerDefenceUpTime   : string = '道术增加%d秒';
  g_sWinLottery1Msg         : string = '祝贺您，中了一等奖';
  g_sWinLottery2Msg         : string = '祝贺您，中了二等奖';
  g_sWinLottery3Msg         : string = '祝贺您，中了三等奖';
  g_sWinLottery4Msg         : string = '祝贺您，中了四等奖';
  g_sWinLottery5Msg         : string = '祝贺您，中了五等奖';
  g_sWinLottery6Msg         : string = '祝贺您，中了六等奖';
  g_sNotWinLotteryMsg       : string = '等下次机会吧';
  g_sWeaptonMakeLuck        : string = '武器被加幸运了..';
  g_sWeaptonNotMakeLuck     : string = '无效';
  g_sTheWeaponIsCursed      : string = '你的武器被诅咒了';
  g_sCanotTakeOffItem       : string = '无法取下物品';
  g_sJoinGroup              : string = '%s 已加入小组';
  g_sTryModeCanotUseStorage : string = '试玩模式不可以使用仓库功能';
  g_sCanotGetItems          : string = '无法携带更多的东西';
  g_sEnableDearRecall       : string = '允许夫妻传送';
  g_sDisableDearRecall      : string = '禁止夫妻传送';
  g_sEnableMasterRecall     : string = '允许师徒传送';
  g_sDisableMasterRecall    : string = '禁止师徒传送';
  g_sNowCurrDateTime        : string = '当前日期时间: ';
  g_sEnableHearWhisper      : string = '[允许私聊]';
  g_sDisableHearWhisper     : string = '[禁止私聊]';
  g_sEnableShoutMsg         : string = '[允许群聊]';
  g_sDisableShoutMsg        : string = '[禁止群聊]';
  g_sEnableDealMsg          : string = '[允许交易]';
  g_sDisableDealMsg         : string = '[禁止交易]';
  g_sEnableGuildChat        : string = '[允许行会聊天]';
  g_sDisableGuildChat       : string = '[禁止行会聊天]';
  g_sEnableJoinGuild        : string = '[允许加入行会]';
  g_sDisableJoinGuild       : string = '[禁止加入行会]';
  g_sEnableAuthAllyGuild    : string = '[允许行会联盟]';
  g_sDisableAuthAllyGuild   : string = '[禁止行会联盟]';
  g_sEnableGroupRecall      : string = '[允许天地合一]';
  g_sDisableGroupRecall     : string = '[禁止天地合一]';
  g_sEnableGuildRecall      : string = '[允许行会合一]';
  g_sDisableGuildRecall     : string = '[禁止行会合一]';
  g_sPleaseInputPassword    : string = '请输入密码:';
  g_sTheMapDisableMove      : string = '地图%s(%s)不允许传送';
  g_sTheMapNotFound         : string = '%s 此地图号不存在';
  g_sYourIPaddrDenyLogon    : string = '你当前登录的IP地址已被禁止登录了';
  g_sYourAccountDenyLogon   : string = '你当前登录的帐号已被禁止登录了';
  g_sYourCharNameDenyLogon  : string = '你当前登录的人物已被禁止登录了';
  g_sCanotPickUpItem        : string = '在一定时间以内无法捡起此物品';
  g_sCanotSendmsg           : string = '无法发送信息';
  g_sUserDenyWhisperMsg     : string = ' 拒绝私聊';
  g_sUserNotOnLine          : string = ' 没有在线';
  g_sRevivalRecoverMsg      : string = '复活戒指生效，体力恢复';
  g_sClientVersionTooOld    : string = '由于您使用的客户端版本太老了，无法正确显示人物信息';

  g_sCastleGuildName        : string = '(%castlename)%guildname[%rankname]';
  g_sNoCastleGuildName      : string = '%guildname[%rankname]';
  g_sWarrReNewName          : string = '%chrname\*<圣>*';
  g_sWizardReNewName        : string = '%chrname\*<神>*';
  g_sTaosReNewName          : string = '%chrname\*<尊>*';
  g_sRankLevelName          : string = '%s\平民';
  g_sManDearName            : string = '%s的老公';
  g_sWoManDearName          : string = '%s的老婆';
  g_sMasterName             : string = '%s的师父';
  g_sNoMasterName           : string = '%s的徒弟';
  g_sHumanShowName          : string = '%chrname\%guildname\%dearname\%mastername';

  g_sChangePermissionMsg    : string = '当前权限等级为:%d';
  g_sChangeKillMonExpRateMsg: string = '经验倍数:%g 时长%d秒';
  g_sChangePowerRateMsg     : string = '攻击力倍数:%g 时长%d秒';
  g_sChangeMemberLevelMsg   : string = '当前会员等级为:%d';
  g_sChangeMemberTypeMsg    : string = '当前会员类型为:%d';
  g_sScriptChangeHumanHPMsg : string = '当前HP值为:%d';
  g_sScriptChangeHumanMPMsg : string = '当前MP值为:%d';
  g_sScriptGuildAuraePointNoGuild: string = '你还没加入行会';
  g_sScriptGuildAuraePointMsg: string = '你的行会人气度为:%d';
  g_sScriptGuildBuildPointNoGuild: string = '你还没加入行会';
  g_sScriptGuildBuildPointMsg: string = '你的行会的建筑度为:%d';
  g_sScriptGuildFlourishPointNoGuild: string = '你还没加入行会';
  g_sScriptGuildFlourishPointMsg: string = '你的行会的繁荣度为:%d';
  g_sScriptGuildStabilityPointNoGuild: string = '你的行会的建筑度为:%d';
  g_sScriptGuildStabilityPointMsg: string = '你的行会的安定度为:%d';
  g_sScriptChiefItemCountMsg: string = '你的行会的超级装备数为:%d';

  g_sDisableSayMsg          : string = '[由于你重复发相同的内容，%d分钟内你将被禁止发言...]';
  g_sOnlineCountMsg         : string = '当前服务器在线人数: %d(%d/%d)';
  g_sTotalOnlineCountMsg    : string = '总在线数: %d';
  g_sYouNeedLevelMsg        : string = '你的等级要在%d级以上才能用此功能';
  g_sThisMapDisableSendCyCyMsg: string = '本地图不允许喊话';
  g_sYouCanSendCyCyLaterMsg : string = '%d秒后才可以再发文字';
  g_sYouIsDisableSendMsg    : string = '禁止聊天';
  g_sYouMurderedMsg         : string = '你犯了谋杀罪';
  g_sYouKilledByMsg         : string = '你被%s杀害了';
  g_sYouProtectedByLawOfDefense: string = '[你受到正当规则保护]';
  g_sYourUseItemIsNul       : string = '你的%s处没有放上装备';
  sPowerRateName            : array[0..6] of string = ('[防御]', '[魔防]', '[攻击]', '[魔法]', '[道术]', '[体力值]', '[魔法值]');
  g_sBYouMurderedMsg        : string = '你犯了谋杀罪';
  g_sBYouKilledByMsg        : string = '你被%s杀害了';

resourcestring
  g_sM2Server               = 'M2Server.exe';
  g_sHeroName               = '英雄';
  g_HeroMsg                 = '(英雄) ';
  sRecallHeroLaterMsg       = '你的英雄还比较虚弱，请在%d秒后再次召唤英雄。';
  sRecallHeroTooFastMsg     = '你的英雄还比较虚弱，如果继续召唤将会损伤英雄。';
  sHeroDisConnectMsg        = '神奇的力量散去，你的英雄开始沉睡。';
  g_sHeroDispear            = '神奇的力量散去，你的元神开始沉睡。';
  g_sHeroStrikeDispear      = '元神受猛烈攻击，回到本身开始沉睡。';
  g_sCrystal                = '火云石';
  g_sCrystalScrap           = '火云石碎片';

  sIPlocalDLL               = 'IPLocal.dll';
  sPlugOfScript             = 'mPlugOfScript.dll';
  sPlugOfEngine             = 'mPlugOfEngine.dll';
  sSystemModule             = 'mSystemModule.dll';
  sPlugOfAccess             = 'mPlugOfAccess.dll';

  g_sGameLogMsg1            = '%d'#9'%s'#9'%d'#9'%d'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s';
  g_sHumanDieEvent          = '人物死亡事件';
  g_sHitOverSpeed           = '[攻击超速] %s 间隔:%d 数量:%d';
  g_sRunOverSpeed           = '[跑步超速] %s 间隔:%d 数量:%d';
  g_sWalkOverSpeed          = '[行走超速] %s 间隔:%d 数量:%d';
  g_sSpellOverSpeed         = '[魔法超速] %s 间隔:%d 数量:%d';
  g_sBunOverSpeed           = '[游戏超速] %s 间隔:%d 数量:%d';

  g_sSlaveKilledByHum       = '你的属下:[%s]被[%s]杀死了！';
  g_sPneumaKilledByHum      = '你的分身:[%s]被[%s]杀死了！';
  g_sHeroKilledByHum        = '你的英雄:[%s]被[%s]杀死了！';

  g_sGameCommandPermissionTooLow = '权限不够';
  g_sGameCommandParamUnKnow = '命令格式: @%s %s';
  g_sGameCommandMoveHelpMsg = '地图号';
  g_sGameCommandPositionMoveHelpMsg = '地图号 座标X 座标Y';
  g_sGameCommandPositionMoveCanotMoveToMap = '无法移动到地图: %s X:%s Y:%s';
  g_sGameCommandInfoHelpMsg = '人物名称';
  g_sNowNotOnLineOrOnOtherServer = '%s 现在不在线，或在其它服务器上';
  g_sGameCommandMobCountHelpMsg = '地图号';
  g_sGameCommandMobCountMapNotFound = '指定的地图不存在';
  g_sGameCommandMobCountMonsterCount = '怪物数量：%d';
  g_sGameCommandHumanCountHelpMsg = '地图号';
  g_sGameCommandKickHumanHelpMsg = '人物名称';
  g_sGameCommandTingHelpMsg = '人物名称';
  g_sGameCommandSuperTingHelpMsg = '人物名称 范围(0-10)';
  g_sGameCommandMapMoveHelpMsg = '源地图  目标地图';
  g_sGameCommandMapMoveMapNotFound = '地图%s不存在';
  g_sGameCommandShutupHelpMsg = '人物名称  时间长度(分钟)';
  g_sGameCommandShutupHumanMsg = '%s 已被禁言%d分钟';
  g_sGameCommandGamePointHelpMsg = '人物名称 控制符(+,-,=) 游戏点数(1-100000000)';
  g_sGameCommandGamePointHumanMsg = '你的游戏点已增加%d点，当前总点数为%d点';
  g_sGameCommandGamePointGMMsg = '%s的游戏点已增加%d点，当前总点数为%d点';
  g_sGameCommandCreditPointHelpMsg = '人物名称 控制符(+,-,=) 声望点数(0-255)';
  g_sGameCommandCreditPointHumanMsg = '你的声望点已增加%d点，当前总声望点数为%d点';
  g_sGameCommandCreditPointGMMsg = '%s的声望点已增加%d点，当前总声望点数为%d点';
  g_sGameCommandGameGoldHelpMsg = ' 人物名称 控制符(+,-,=) 游戏币(1-200000000)';
  g_sGameCommandGameGoldHumanMsg = '你的%s已增加%d，当前拥有%d%s';
  g_sGameCommandGameGoldGMMsg = '%s的%s已增加%d，当前拥有%d%s';

  g_sGameCommandMapInfoMsg  = '地图名称: %s(%s)';
  g_sGameCommandMapInfoSizeMsg = '地图大小: X(%d) Y(%d)';

  g_sGameCommandShutupReleaseHelpMsg = '人物名称';
  g_sGameCommandShutupReleaseCanSendMsg = '你已经恢复聊天功能';
  g_sGameCommandShutupReleaseHumanCanSendMsg = '%s 已经恢复聊天';
  g_sGameCommandShutupListIsNullMsg = '禁言列表为空';

  g_sGameCommandLevelConsoleMsg = '[等级调整] %s (%d -> %d)';
  g_sGameCommandSbkGoldHelpMsg = '城堡名称 控制符(=、-、+) 金币数(1-100000000)';
  g_sGameCommandSbkGoldCastleNotFoundMsg = '城堡%s未找到';
  g_sGameCommandSbkGoldShowMsg = '%s的金币数为: %d 今天收入: %d';
  g_sGameCommandRecallHelpMsg = '人物名称';
  g_sGameCommandReGotoHelpMsg = '人物名称';
  g_sGameCommandShowHumanFlagHelpMsg = '人物名称 标识号';
  g_sGameCommandShowHumanFlagONMsg = '%s: [%d] = ON';
  g_sGameCommandShowHumanFlagOFFMsg = '%s: [%d] = OFF';

  g_sGameCommandShowHumanUnitHelpMsg = '人物名称 单元号';
  g_sGameCommandShowHumanUnitONMsg = '%s: [%d] = ON';
  g_sGameCommandShowHumanUnitOFFMsg = '%s: [%d] = OFF';
  g_sGameCommandMobHelpMsg  = '怪物名称 数量 等级';
  g_sGameCommandMobMsg      = '怪物名称不正确或其它未问题';
  g_sGameCommandMobNpcHelpMsg = 'NPC名称 脚本文件名 外形(数字) 属沙城(0,1)';
  g_sGameCommandNpcScriptHelpMsg = '？？？？';
  g_sGameCommandDelNpcMsg   = '命令使用方法不正确，必须与NPC面对面，才能使用此命令';
  g_sGameCommandRecallMobHelpMsg = '怪物名称 数量 等级';
  g_sGameCommandLuckPointHelpMsg = '人物名称 控制符 幸运点数';
  g_sGameCommandLuckPointMsg = '%s 的幸运点数为:%d/%g 幸运值为:%d';
  g_sGameCommandLotteryTicketMsg = '已中彩票数:%d 未中彩票数:%d 一等奖:%d 二等奖:%d 三等奖:%d 四等奖:%d 五等奖:%d 六等奖:%d ';
  g_sGameCommandReloadGuildHelpMsg = '行会名称';
  g_sGameCommandReloadGuildOnMasterserver = '此命令只能在主游戏服务器上执行';
  g_sGameCommandReloadGuildNotFoundGuildMsg = '未找到行会%s';
  g_sGameCommandReloadGuildSuccessMsg = '行会%s重加载成功..';

  g_sGameCommandReloadLineNoticeSuccessMsg = '重新加载公告设置信息完成';
  g_sGameCommandReloadLineNoticeFailMsg = '重新加载公告设置信息失败';
  g_sGameCommandFreePKHelpMsg = '人物名称';
  g_sGameCommandFreePKHumanMsg = '你的PK值已经被清除..';
  g_sGameCommandFreePKMsg   = '%s的PK值已经被清除..';
  g_sGameCommandPKPointHelpMsg = '人物名称';
  g_sGameCommandPKPointMsg  = '%s的PK点数为:%d';
  g_sGameCommandIncPkPointHelpMsg = '人物名称 PK点数';
  g_sGameCommandIncPkPointAddPointMsg = '%s的PK值已增加%d点..';
  g_sGameCommandIncPkPointDecPointMsg = '%s的PK值已减少%d点..';
  g_sGameCommandHumanLocalHelpMsg = '人物名称';
  g_sGameCommandHumanLocalMsg = '%s来自:%s';
  g_sGameCommandPrvMsgHelpMsg = '人物名称';
  g_sGameCommandPrvMsgUnLimitMsg = '%s 已从禁止私聊列表中删除..';
  g_sGameCommandPrvMsgLimitMsg = '%s 已被加入禁止私聊列表..';
  g_sGamecommandMakeHelpMsg = ' 物品名称  数量';
  g_sGamecommandMakeItemNameOrPerMissionNot = '输入的物品名称不正确，或权限不够';
  g_sGamecommandMakeInCastleWarRange = '攻城区域，禁止使用此功能';
  g_sGamecommandMakeInSafeZoneRange = '非安全区，禁止使用此功能';
  g_sGamecommandMakeItemNameNotFound = '%s 物品名称不正确';
  g_sGamecommandSuperMakeHelpMsg = '身上没指定物品';
  g_sGameCommandViewWhisperHelpMsg = ' 人物名称';
  g_sGameCommandViewWhisperMsg1 = '已停止侦听%s的私聊信息..';
  g_sGameCommandViewWhisperMsg2 = '正在侦听%s的私聊信息..';
  g_sGameCommandReAliveHelpMsg = ' 人物名称';
  g_sGameCommandReAliveMsg  = '%s 已获重生';
  g_sGameCommandChangeJobHelpMsg = ' 人物名称 职业类型(Warr Wizard Taos)';
  g_sGameCommandChangeJobMsg = '%s 的职业更改成功';
  g_sGameCommandChangeJobHumanMsg = '职业更改成功';
  g_sGameCommandTestGetBagItemsHelpMsg = '(用于测试升级武器方面参数)';
  g_sGameCommandShowUseItemInfoHelpMsg = '人物名称';
  g_sGameCommandBindUseItemHelpMsg = '人物名称 物品类型 绑定方法';
  g_sGameCommandBindUseItemNoItemMsg = '%s的%s没有戴物品';
  g_sGameCommandBindUseItemAlreadBindMsg = '%s的%s上的物品早已绑定过了';
  g_sGameCommandMobFireBurnHelpMsg = '命令格式: %s %s %s %s %s %s %s';
  g_sGameCommandMobFireBurnMapNotFountMsg = '地图%s 不存在';

resourcestring
  U_DRESSNAME               = '衣服';
  U_WEAPONNAME              = '武器';
  U_RIGHTHANDNAME           = '照明物';
  U_NECKLACENAME            = '项链';
  U_HELMETNAME              = '头盔';
  U_ARMRINGLNAME            = '左手镯';
  U_ARMRINGRNAME            = '右手镯';
  U_RINGLNAME               = '左戒指';
  U_RINGRNAME               = '右戒指';
  U_BUJUKNAME               = '物品';
  U_BELTNAME                = '腰带';
  U_BOOTSNAME               = '鞋子';
  U_CHARMNAME               = '宝石';
  U_HELMETexNAME            = '斗笠';
  U_DRUMNAME                = '军鼓';
  U_HORSENAME               = '马牌';
  U_FASHIONNAME             = '时装';

var
  nIPLocal                  : Integer = -1;
  nExVersionNO              : Integer = -1;
  nGoldShape                : Integer = -1;
  nResourceString           : Integer = -1;
  nPulgProc01               : Integer = -1;
  nPulgProc02               : Integer = -1;
  nPulgProc03               : Integer = -1;
  nPulgProc04               : Integer = -1;
  nPulgProc05               : Integer = -1;
  nPulgProc06               : Integer = -1;
  nPulgProc07               : Integer = -1;
  nPulgProc08               : Integer = -1;
  nPulgProc09               : Integer = -1;
  nPulgProc10               : Integer = -1;
  nPulgProc11               : Integer = -1;
  nPulgProc12               : Integer = -1;
  nPulgProc13               : Integer = -1;
  nPulgProc14               : Integer = -1;
  nPulgProc15               : Integer = -1;
  nAddGameDataLogAPI        : Integer = -1;



implementation

uses HUtil32, EDcode, __DESUnit, AdaptersInfo;

procedure SetProcessName(sName: string);
begin
  g_sOldProcessName := g_sProcessName;
  g_sProcessName := sName;
end;

procedure CopyStdItemToOStdItem(StdItem: pTStdItem; OStdItem: pTOStdItem);
begin
  OStdItem.Name := StdItem.Name;
  OStdItem.StdMode := StdItem.StdMode;
  OStdItem.Shape := StdItem.Shape;
  OStdItem.Weight := StdItem.Weight;
  OStdItem.AniCount := StdItem.AniCount;
  OStdItem.Source := StdItem.Source;
  OStdItem.Reserved := StdItem.Reserved;
  OStdItem.NeedIdentify := StdItem.NeedIdentify;
  OStdItem.looks := StdItem.looks;
  OStdItem.DuraMax := StdItem.DuraMax;
  OStdItem.AC := MakeWord(_MIN(High(Byte), LoWord(StdItem.AC)), _MIN(High(Byte), HiWord(StdItem.AC)));
  OStdItem.MAC := MakeWord(_MIN(High(Byte), LoWord(StdItem.MAC)), _MIN(High(Byte), HiWord(StdItem.MAC)));
  OStdItem.DC := MakeWord(_MIN(High(Byte), LoWord(StdItem.DC)), _MIN(High(Byte), HiWord(StdItem.DC)));
  OStdItem.MC := MakeWord(_MIN(High(Byte), LoWord(StdItem.MC)), _MIN(High(Byte), HiWord(StdItem.MC)));
  OStdItem.SC := MakeWord(_MIN(High(Byte), LoWord(StdItem.SC)), _MIN(High(Byte), HiWord(StdItem.SC)));
  OStdItem.Need := StdItem.Need;
  OStdItem.NeedLevel := StdItem.NeedLevel;
  OStdItem.Price := StdItem.Price;
end;

procedure InitPlugArrayTable();
begin
  //SetProcTable(@TRunSocket.DemoRun, PChar('TRunSocket.Run') {'TRunSocket.Run'}, Length('TRunSocket.Run'));
  //SetProcTable(@TUserEngine.DemoRun, PChar('TUserEngine.Run') {'TUserEngine.Run'}, Length('TUserEngine.Run'));
end;

function AddToPulgProcTable(sProcName: string): Integer;
var
  i                         : Integer;
begin
  Result := -1;
  for i := Low(PlugProcArray) to High(PlugProcArray) do begin
    if PlugProcArray[i].sProcName = '' then begin
      PlugProcArray[i].sProcName := sProcName;
      Result := i;
      Break;
    end;
  end;
end;

function AddToProcTable(ProcAddr: Pointer; sProcName: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  for i := Low(ProcArray) to High(ProcArray) do begin
    if ProcArray[i].nProcAddr = nil then begin
      ProcArray[i].nProcAddr := ProcAddr;
      ProcArray[i].sProcName := sProcName;
      Result := True;
      Break;
    end;
  end;
end;

function AddToObjTable(Obj: TObject; sObjName: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  for i := Low(ObjectArray) to High(ObjectArray) do begin
    if ObjectArray[i].Obj = nil then begin
      ObjectArray[i].Obj := Obj;
      ObjectArray[i].sObjcName := sObjName;
      Result := True;
      Break;
    end;
  end;
end;

function LoadLineNotice(FileName: string): Boolean;
var
  i                         : Integer;
  sText                     : string;
begin
  Result := False;
  if FileExists(FileName) then begin
    LineNoticeList.LoadFromFile(FileName);
    i := 0;
    while (True) do begin
      if LineNoticeList.Count <= i then
        Break;
      sText := Trim(LineNoticeList.Strings[i]);
      if sText = '' then begin
        LineNoticeList.Delete(i);
        Continue;
      end;
      LineNoticeList.Strings[i] := sText;
      Inc(i);
    end;
    Result := True;
  end;
end;

function GetMultiServerAddrPort(btSrvIdx: Byte; var sIPaddr: string; var nPort: Integer): Boolean;

  function GetRandpmRoute(RouteInfo: pTRouteInfo; var nGatePort: Integer): string;
  var
    nC                      : Integer;
  begin
    nC := Random(RouteInfo.nGateCount);
    Result := RouteInfo.sGameGateIP[nC];
    nGatePort := RouteInfo.nGameGatePort[nC];
  end;

var
  i                         : Integer;
  RouteInfo                 : pTRouteInfo;
begin
  Result := False;
  nPort := 0;
  sIPaddr := '';
  for i := Low(g_RouteInfo) to High(g_RouteInfo) do begin
    RouteInfo := @g_RouteInfo[i];
    if RouteInfo.nGateCount <= 0 then Continue;
    if RouteInfo.nServerIdx = btSrvIdx then begin
      sIPaddr := GetRandpmRoute(RouteInfo, nPort);
      Result := True;
      Break;
    end;
  end;
end;

{var
  i, n                      : Integer;
  sGateMsg, sIdx, sIP, sPort: string;
  sList                     : TStringList;
begin
  Result := False;
  for i := 0 to g_ServerTableList.Count - 1 do begin
    sGateMsg := g_ServerTableList.Strings[i];
    if (sGateMsg = '') or (sGateMsg[1] = ';') then Continue;
    sGateMsg := Trim(GetValidStr3(sGateMsg, sIdx, [' ', #9]));
    sGateMsg := Trim(GetValidStr3(sGateMsg, sIP, [' ', #9]));
    sGateMsg := Trim(GetValidStr3(sGateMsg, sPort, [' ', #9]));
    if btServerIndex = StrToInt(sIdx) then begin
      sIPaddr := sIP;
      nPort := StrToInt(sPort);
      Result := True;
      Break;
    end;
  end;
  Result := False;
  if btServerIndex < g_ServerTableList.Count then begin
    sList := TStringList(g_ServerTableList[btServerIndex]);
    n := Random(sList.Count);
    sIPaddr := sList[n];
    nPort := Integer(sList.Objects[n]);
    Result := True;
  end else
    MainOutMessageAPI('GetMultiServerAddrPort Fail..:' + IntToStr(btServerIndex));
end;}

procedure MainOutMessageAPI(Msg: string);
begin
  if not g_Config.boShowExceptionMsg then begin
    if (Length(Msg) > 2) and ((Msg[2] = 'E') or (Msg[1] = 'A')) then
      Exit;
  end;
  EnterCriticalSection(LogMsgCriticalSection);
  try
    MainLogMsgList.Add(DateTimeToStr(Now) + ' ' + Msg);
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;
end;

function GetExVersionNO(nVersionDate: Integer; var nOldVerstionDate: Integer): Integer;
begin
  Result := 0;
  nOldVerstionDate := 0;
  if (nExVersionNO >= 0) and Assigned(PlugProcArray[nExVersionNO].nProcAddr) then
    Result := TGetExVersionNO(PlugProcArray[nExVersionNO].nProcAddr)(nVersionDate, nOldVerstionDate);
  {Result := 0;
  nOldVerstionDate := 0;
  if nVersionDate > 100000000 then begin
    while (nVersionDate > 100000000) do begin
      Dec(nVersionDate, 100000000);
      Inc(Result, 100000000);
    end;
  end;
  nOldVerstionDate := nVersionDate;}
end;

function GetNextDirection(sX, sY, dx, dy: Integer): Byte;
var
  flagx, flagy              : Integer;
begin
  Result := DR_DOWN;
  if sX < dx then
    flagx := 1
  else if sX = dx then
    flagx := 0
  else
    flagx := -1;

  if abs(sY - dy) > 2 then
    if (sX >= dx - 1) and (sX <= dx + 1) then
      flagx := 0;

  if sY < dy then
    flagy := 1
  else if sY = dy then
    flagy := 0
  else
    flagy := -1;

  if abs(sX - dx) > 2 then
    if (sY > dy - 1) and (sY <= dy + 1) then
      flagy := 0;

  if (flagx = 0) and (flagy = -1) then
    Result := DR_UP;
  if (flagx = 1) and (flagy = -1) then
    Result := DR_UPRIGHT;
  if (flagx = 1) and (flagy = 0) then
    Result := DR_RIGHT;
  if (flagx = 1) and (flagy = 1) then
    Result := DR_DOWNRIGHT;
  if (flagx = 0) and (flagy = 1) then
    Result := DR_DOWN;
  if (flagx = -1) and (flagy = 1) then
    Result := DR_DOWNLEFT;
  if (flagx = -1) and (flagy = 0) then
    Result := DR_LEFT;
  if (flagx = -1) and (flagy = -1) then
    Result := DR_UPLEFT;
end;

function CheckUserItems(nIdx{$IF VER_ClientType_45}, nType{$IFEND VER_ClientType_45}: Integer; StdItem: pTStdItem): Boolean;
begin
{$IF CUSTOMBUILD = 0}
  Result := False;
  case nIdx of
    U_DRUM: if StdItem.StdMode in [17] then
        Result := True;
    U_HORSE: if StdItem.StdMode in [18] then
        Result := True;
    U_FASHION: if StdItem.StdMode in [12, 13] then
        Result := True;
    U_DRESS: if StdItem.StdMode in [10, 11] then
        Result := True;
    U_WEAPON: if StdItem.StdMode in [5, 6] then
        Result := True;
    U_RIGHTHAND: begin
{$IF VER_ClientType_45}
        if nType in [45, 46] then begin
{$IFEND VER_ClientType_45}
          if StdItem.StdMode = 30 then
            Result := True;
{$IF VER_ClientType_45}
        end else if StdItem.StdMode in [28, 29, 30] then
          Result := True;
{$IFEND VER_ClientType_45}
      end;
    U_NECKLACE: if StdItem.StdMode in [19, 20, 21] then
        Result := True;
    U_HELMET: if StdItem.StdMode = 15 then
        Result := True;
    U_HELMETEX: if StdItem.StdMode = 16 then
        Result := True;
    U_ARMRINGL, U_ARMRINGR: if StdItem.StdMode in [24, 25, 26] then
        Result := True;
    U_RINGL, U_RINGR: if StdItem.StdMode in [22, 23] then
        Result := True;
    U_BUJUK: if (StdItem.StdMode in [25, 51, 61]) or ((StdItem.StdMode = 2) and (StdItem.Source <> 0)) then
        Result := True;
    U_BELT: begin
{$IF VER_ClientType_45}
        if nType in [45, 46] then begin
{$IFEND VER_ClientType_45}
          if StdItem.StdMode in [27] then
            Result := True;
{$IF VER_ClientType_45}
        end else if StdItem.StdMode in [54, 64] then
          Result := True;
{$IFEND VER_ClientType_45}
      end;
    U_BOOTS: begin
{$IF VER_ClientType_45}
        if nType in [45, 46] then begin
{$IFEND VER_ClientType_45}
          if StdItem.StdMode in [28] then
            Result := True;
{$IF VER_ClientType_45}
        end else if StdItem.StdMode in [52, 62] then
          Result := True;
{$IFEND VER_ClientType_45}
      end;
    U_CHARM: begin
{$IF VER_ClientType_45}
        if nType in [45, 46] then begin
{$IFEND VER_ClientType_45}
          if StdItem.StdMode in [7, 29] then
            Result := True;
{$IF VER_ClientType_45}
        end else if StdItem.StdMode in [53, 63] then
          Result := True;
{$IFEND VER_ClientType_45}
      end;
  end;
{$IFEND}
{$IF CUSTOMBUILD = 1}
  Result := False;
  case nIdx of
    U_DRESS: if StdItem.StdMode in [10, 11] then
        Result := True;
    U_WEAPON: if StdItem.StdMode in [5, 6] then
        Result := True;
    U_RIGHTHAND: begin
        if nType in [45, 46] then begin
          if StdItem.StdMode = 30 then
            Result := True;
        end else if StdItem.StdMode in [28, 29, 30] then
          Result := True;
      end;
    U_NECKLACE: if StdItem.StdMode in [19, 20, 21] then
        Result := True;
    U_HELMET: if StdItem.StdMode = 15 then
        Result := True;
    U_HELMETEX: if StdItem.StdMode = 16 then
        Result := True;
    U_ARMRINGL, U_ARMRINGR: if StdItem.StdMode in [24, 25, 26] then
        Result := True;
    U_RINGL, U_RINGR: if StdItem.StdMode in [22, 23] then
        Result := True;
    U_BUJUK: if StdItem.StdMode in [25, 51, 61] then
        Result := True;
    U_BELT: begin
        if StdItem.StdMode in [27, 54, 64] then
          Result := True;
      end;
    U_BOOTS: begin
        if StdItem.StdMode in [28, 52, 62] then
          Result := True;
      end;
    U_CHARM: begin
        if StdItem.StdMode in [29, 7, 53, 63] then
          Result := True;
      end;
  end;
{$IFEND}
end;

function AddDateTimeOfDay(DateTime: TDateTime; nDay: Integer): TDateTime;
var
  Year, Month, Day          : Word;
begin
  if nDay > 0 then begin
    Dec(nDay);
    DecodeDate(DateTime, Year, Month, Day);
    while (True) do begin
      if MonthDays[False][Month] >= (Day + nDay) then
        Break;
      nDay := (Day + nDay) - MonthDays[False][Month] - 1;
      Day := 1;
      if Month <= 11 then begin
        Inc(Month);
        Continue;
      end;
      Month := 1;
      if Year = 99 then begin
        Year := 2000;
        Continue;
      end;
      Inc(Year);
    end;
    //TryEncodeDate(Year,Month,Day,Result);
    Inc(Day, nDay);
    Result := EncodeDate(Year, Month, Day);
  end else
    Result := DateTime;
end;


function GetGoldShape(nGold: Integer): Word; //取金币外形 2018-12-20
begin
  Result := 112;
  if nGold >= 30 then Result := 113;
  if nGold >= 70 then Result := 114;
  if nGold >= 300 then Result := 115;
  if nGold >= 1000 then Result := 116;
end;

function GetRandomLook(nBaseLook, nRage: Integer): Integer;
begin
  Result := nBaseLook + Random(nRage);
end;

function CheckGuildName(sGuildName: string): Boolean;
var
  i                         : Integer;
begin
  Result := True;
  i := Length(sGuildName);
  if (i > g_Config.nGuildNameLen) or (i < 4) then begin //0410
    Result := False;
    Exit;
  end;
  for i := 1 to Length(sGuildName) do begin
    if (sGuildName[i] < '0' {30}) or
      (sGuildName[i] = '/' {2F}) or
      (sGuildName[i] = '\' {5C}) or
      (sGuildName[i] = ':' {3A}) or
      (sGuildName[i] = '*') or
      (sGuildName[i] = ' ') or
      (sGuildName[i] = '"') or
      (sGuildName[i] = '''') or
      (sGuildName[i] = '<' {3C}) or
      (sGuildName[i] = '|' {7C}) or
      (sGuildName[i] = '?' {3F}) or
      (sGuildName[i] = '>' {3E}) then begin
      Result := False;
    end;
  end;
end;

function GetItemNumber(): Integer;
begin
  {Result := High(Integer) div 3;
  if (nPulgProc04 >= 0) and Assigned(PlugProcArray[nPulgProc04].nProcAddr) then
    Result := TGetItemNumber(PlugProcArray[nPulgProc04].nProcAddr)();}
  Inc(g_Config.nItemNumber);
  if g_Config.nItemNumber > (High(Integer) div 2 - 1) then
    g_Config.nItemNumber := 1;
  Result := g_Config.nItemNumber;
end;

function GetItemNumberEx(): Integer;
begin
  {Result := High(Integer) div 2 + 99;
  if (nPulgProc05 >= 0) and Assigned(PlugProcArray[nPulgProc05].nProcAddr) then
    Result := TGetItemNumberEx(PlugProcArray[nPulgProc05].nProcAddr)();}
  Inc(g_Config.nItemNumberEx);
  if g_Config.nItemNumberEx < High(Integer) div 2 then
    g_Config.nItemNumberEx := High(Integer) div 2;
  if g_Config.nItemNumberEx > (High(Integer) - 1) then
    g_Config.nItemNumberEx := High(Integer) div 2;
  Result := g_Config.nItemNumberEx;
end;

function FilterCharName(sName: string): string;
var
  i                         : Integer;
  b                         : Boolean;
begin
  Result := '';
  if sName = '' then Exit;
  b := False;
  for i := 1 to Length(sName) do begin
    if ((sName[i] >= '0') and (sName[i] <= '9')) or (sName[i] = '-') then begin
      Result := Copy(sName, 1, i - 1);
      b := True;
      Break;
    end;
  end;
  if not b then Result := sName;
end;

function GetNearPosition(nDir, nRage: Integer): Byte;
begin
  Result := (nDir + nRage) mod 8;
end;

function GetValNameNo(sText: string): Integer;
var
  nValNo                    : Integer;
begin
  Result := -1;
  if Length(sText) >= 2 then begin
    if UpCase(sText[1]) = 'P' then begin
      nValNo := Str_ToInt(sText[2], -1);
      if nValNo < 10 then
        Result := nValNo;
    end;

    if UpCase(sText[1]) = 'G' then begin
      if Length(sText) = 3 then begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then
          Result := nValNo + 100;
      end
      else begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then
          Result := nValNo + 100;
      end;
    end;

    if UpCase(sText[1]) = 'D' then begin
      if Length(sText) = 3 then begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then
          Result := nValNo + 200;
      end else begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then
          Result := nValNo + 200;
      end;
    end;

    if UpCase(sText[1]) = 'M' then begin
      if Length(sText) = 3 then begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then
          Result := nValNo + 300;
      end
      else begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then
          Result := nValNo + 300;
      end;
    end;
    if UpCase(sText[1]) = 'I' then begin
      if Length(sText) = 3 then begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then
          Result := nValNo + 400;
      end
      else begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then
          Result := nValNo + 400;
      end;
    end;

    if UpCase(sText[1]) = 'A' then begin
      if Length(sText) = 3 then begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then
          Result := nValNo + 500;
      end
      else begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then
          Result := nValNo + 500;
      end;
    end;

    if UpCase(sText[1]) = 'S' then begin
      if Length(sText) = 3 then begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then
          Result := nValNo + 600;
      end
      else begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then
          Result := nValNo + 600;
      end;
    end;

    if UpCase(sText[1]) = 'H' then begin
      if Length(sText) = 3 then begin
        nValNo := Str_ToInt(Copy(sText, 2, 2), -1);
        if nValNo < 100 then
          Result := nValNo + 700;
      end else begin
        nValNo := Str_ToInt(sText[2], -1);
        if nValNo < 10 then
          Result := nValNo + 700;
      end;
    end;

  end;
  {//$IFEND}
end;

function IsUseItem(nIndex: Integer): Boolean;
var
  StdItem                   : pTStdItem;
begin
  StdItem := UserEngine.GetStdItem(nIndex);
  if StdItem.StdMode in [19..24, 26] then //0319
    Result := True
  else
    Result := False;
end;

function GetMakeItemInfo(sItemName: string): TStringList;
var
  i                         : Integer;
begin
  Result := nil;
  for i := 0 to g_MakeItemList.Count - 1 do begin
    if g_MakeItemList.Strings[i] = sItemName then begin
      Result := TStringList(g_MakeItemList.Objects[i]);
      Break;
    end;
  end;
end;

function GetRefineItemList(sItemName1, sItemName2, sItemName3: string): TList;
var
  i, ii                     : Integer;
  sa                        : array[0..5] of string;
begin
  Result := nil;
  sa[0] := sItemName1 + '+' + sItemName2 + '+' + sItemName3;
  sa[1] := sItemName1 + '+' + sItemName3 + '+' + sItemName2;
  sa[2] := sItemName2 + '+' + sItemName1 + '+' + sItemName3;
  sa[3] := sItemName2 + '+' + sItemName3 + '+' + sItemName1;
  sa[4] := sItemName3 + '+' + sItemName1 + '+' + sItemName2;
  sa[5] := sItemName3 + '+' + sItemName2 + '+' + sItemName1;
  for i := 0 to g_RefineItemList.Count - 1 do begin
    for ii := Low(sa) to High(sa) do begin
      if CompareText(g_RefineItemList.Strings[i], sa[ii]) = 0 then begin
        if TList(g_RefineItemList.Objects[i]).Count > 0 then
          Result := TList(g_RefineItemList.Objects[i]);
        Break;
      end;
    end;
  end;
end;

function GetBoxItemInfoByName(sItemName: string): TList;
var
  i                         : Integer;
begin
  Result := nil;
  for i := 0 to g_BoxItemList.Count - 1 do begin
    if g_BoxItemList.Strings[i] = sItemName then begin
      Result := TList(g_BoxItemList.Objects[i]);
      Break;
    end;
  end;
end;

function GetBoxItemInfoByIndx(nItemShape: Integer): TList;
var
  i                         : Integer;
  sBoxName                  : string;
begin
  Result := nil;
  sBoxName := '';
  case nItemShape of
    2: sBoxName := '檀木宝箱';
    3: sBoxName := '紫铜宝箱';
    4: sBoxName := '白银宝箱';
    5: sBoxName := '赤金宝箱';
    6: sBoxName := '黄金宝箱';
  end;
  if sBoxName = '' then Exit;
  for i := 0 to g_BoxItemList.Count - 1 do begin
    if g_BoxItemList.Strings[i] = sBoxName then begin
      Result := TList(g_BoxItemList.Objects[i]);
      Break;
    end;
  end;
end;

function GetGameGoldNameAPI(): string;
begin
  Result := g_Config.sGameGoldName;
end;

procedure AddGameDataLogAPI(sMsg: string);
begin
  EnterCriticalSection(LogMsgCriticalSection);
  try
    LogStringList.Add(sMsg);
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;
end;

procedure AddLogonCostLog(sMsg: string); //004E437C
begin
  EnterCriticalSection(LogMsgCriticalSection);
  try
    LogonCostLogList.Add(sMsg);
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;
end;

procedure TrimStringList(sList: TStringList); //0x00455D48
var
  i                         : Integer;
  sLine                     : string;
begin
  i := 0;
  while True do begin
    if i >= sList.Count - 1 then Break;
    sLine := Trim(sList.Strings[i]);
    if sLine = '' then begin
      sList.Delete(i);
      Continue;
    end;
    Inc(i);
  end;
end;

function CanMoveMap(sMapName: string): Boolean;
var
  i                         : Integer;
begin
  Result := True;
  g_DisableMoveMapList.Lock;
  try
    for i := 0 to g_DisableMoveMapList.Count - 1 do begin
      if CompareText(g_DisableMoveMapList.Strings[i], sMapName) = 0 then begin
        Result := False;
        Break;
      end;
    end;
  finally
    g_DisableMoveMapList.UnLock;
  end;
end;

function LoadItemBindIPaddr(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
  sLineText, sMakeIndex, sItemIndex, sBindName: string;
  nMakeIndex, nItemIndex    : Integer;
  ItemBind                  : pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindIPaddr.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_ItemBindIPaddr.Lock;
    try
      for i := 0 to g_ItemBindIPaddr.Count - 1 do begin
        Dispose(pTItemBind(g_ItemBindIPaddr.Items[i]));
      end;
      g_ItemBindIPaddr.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        sLineText := Trim(LoadList.Strings[i]);
        if (sLineText = '') or (sLineText[1] = ';') then
          Continue;
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sBindName, [' ', ',', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex > 0) and (nItemIndex > 0) and (sBindName <> '') then begin
          New(ItemBind);
          ItemBind.nMakeIdex := nMakeIndex;
          ItemBind.nItemIdx := nItemIndex;
          ItemBind.sBindName := sBindName;
          g_ItemBindIPaddr.Add(ItemBind);
        end;
      end;
    finally
      g_ItemBindIPaddr.UnLock;
    end;
    Result := True;
  end
  else begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function SaveItemBindIPaddr(): Boolean;
var
  i                         : Integer;
  SaveList                  : TStringList;
  sFileName                 : string;
  ItemBind                  : pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindIPaddr.txt';
  SaveList := TStringList.Create;
  g_ItemBindIPaddr.Lock;
  try
    for i := 0 to g_ItemBindIPaddr.Count - 1 do begin
      ItemBind := g_ItemBindIPaddr.Items[i];
      SaveList.Add(IntToStr(ItemBind.nItemIdx) + #9 + IntToStr(ItemBind.nMakeIdex) + #9 + ItemBind.sBindName);
    end;
  finally
    g_ItemBindIPaddr.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;

function LoadItemBindAccount(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
  sLineText, sMakeIndex, sItemIndex, sBindName: string;
  nMakeIndex, nItemIndex    : Integer;
  ItemBind                  : pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindAccount.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_ItemBindAccount.Lock;
    try
      for i := 0 to g_ItemBindAccount.Count - 1 do
        Dispose(pTItemBind(g_ItemBindAccount.Items[i]));
      g_ItemBindAccount.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        sLineText := Trim(LoadList.Strings[i]);
        if (sLineText = '') or (sLineText[1] = ';') then
          Continue;
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sBindName, [' ', ',', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex > 0) and (nItemIndex > 0) and (sBindName <> '') then begin
          New(ItemBind);
          ItemBind.nMakeIdex := nMakeIndex;
          ItemBind.nItemIdx := nItemIndex;
          ItemBind.sBindName := sBindName;
          g_ItemBindAccount.Add(ItemBind);
        end;
      end;
    finally
      g_ItemBindAccount.UnLock;
    end;
    Result := True;
  end else
    LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function SaveItemBindAccount(): Boolean;
var
  i                         : Integer;
  SaveList                  : TStringList;
  sFileName                 : string;
  ItemBind                  : pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindAccount.txt';
  SaveList := TStringList.Create;
  g_ItemBindAccount.Lock;
  try
    for i := 0 to g_ItemBindAccount.Count - 1 do begin
      ItemBind := g_ItemBindAccount.Items[i];
      SaveList.Add(IntToStr(ItemBind.nItemIdx) + #9 +
        IntToStr(ItemBind.nMakeIdex) + #9 + ItemBind.sBindName);
    end;
  finally
    g_ItemBindAccount.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;

function LoadItemBindCharName(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
  sLineText, sMakeIndex, sItemIndex, sBindName: string;
  nMakeIndex, nItemIndex    : Integer;
  ItemBind                  : pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindChrName.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_ItemBindCharName.Lock;
    try
      for i := 0 to g_ItemBindCharName.Count - 1 do
        Dispose(pTItemBind(g_ItemBindCharName.Items[i]));
      g_ItemBindCharName.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        sLineText := Trim(LoadList.Strings[i]);
        if (sLineText = '') or (sLineText[1] = ';') then
          Continue;
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', ',', #9]);
        sLineText := GetValidStr3(sLineText, sBindName, [' ', ',', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex > 0) and (nItemIndex > 0) and (sBindName <> '') then begin
          New(ItemBind);
          ItemBind.nMakeIdex := nMakeIndex;
          ItemBind.nItemIdx := nItemIndex;
          ItemBind.sBindName := sBindName;
          g_ItemBindCharName.Add(ItemBind);
        end;
      end;
    finally
      g_ItemBindCharName.UnLock;
    end;
    Result := True;
  end else
    LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function SaveItemBindCharName(): Boolean;
var
  i                         : Integer;
  SaveList                  : TStringList;
  sFileName                 : string;
  ItemBind                  : pTItemBind;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemBindChrName.txt';
  SaveList := TStringList.Create;
  g_ItemBindCharName.Lock;
  try
    for i := 0 to g_ItemBindCharName.Count - 1 do begin
      ItemBind := g_ItemBindCharName.Items[i];
      SaveList.Add(IntToStr(ItemBind.nItemIdx) + #9 +
        IntToStr(ItemBind.nMakeIdex) + #9 + ItemBind.sBindName);
    end;
  finally
    g_ItemBindCharName.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;

function SaveAdminList(): Boolean;
var
  i                         : Integer;
  sFileName                 : string;
  SaveList                  : TStringList;
  sPermission               : string;
  nPermission               : Integer;
  AdminInfo                 : pTAdminInfo;
begin
  sFileName := g_Config.sEnvirDir + 'AdminList.txt';
  SaveList := TStringList.Create;
  UserEngine.m_AdminList.Lock;
  try
    for i := 0 to UserEngine.m_AdminList.Count - 1 do begin
      AdminInfo := pTAdminInfo(UserEngine.m_AdminList.Items[i]);
      nPermission := AdminInfo.nLv;
      if nPermission = 10 then sPermission := '*';
      if nPermission = 9 then sPermission := '1';
      if nPermission = 8 then sPermission := '2';
      if nPermission = 7 then sPermission := '3';
      if nPermission = 6 then sPermission := '4';
      if nPermission = 5 then sPermission := '5';
      if nPermission = 4 then sPermission := '6';
      if nPermission = 3 then sPermission := '7';
      if nPermission = 2 then sPermission := '8';
      if nPermission = 1 then sPermission := '9';
{$IF VEROWNER = WL}
      SaveList.Add(sPermission + #9 + AdminInfo.sChrName + #9 + AdminInfo.sIPaddr);
{$ELSE}
      SaveList.Add(sPermission + #9 + AdminInfo.sChrName);
{$IFEND}
    end;
    SaveList.SaveToFile(sFileName);
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  Result := True;
end;

function LoadUnMasterList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'UnMaster.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_UnMasterList.Lock;
    try
      g_UnMasterList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        g_UnMasterList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_UnMasterList.UnLock;
    end;
    Result := True;
  end else
    LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function SaveUnMasterList(): Boolean;
var
  sFileName                 : string;
begin
  sFileName := g_Config.sEnvirDir + 'UnMaster.txt';
  g_UnMasterList.Lock;
  try
    g_UnMasterList.SaveToFile(sFileName);
  finally
    g_UnMasterList.UnLock;
  end;
  Result := True;
end;

function LoadUnForceMasterList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'UnForceMaster.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_UnForceMasterList.Lock;
    try
      g_UnForceMasterList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        g_UnForceMasterList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_UnForceMasterList.UnLock;
    end;
    Result := True;
  end else
    LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function SaveUnForceMasterList(): Boolean;
var
  sFileName                 : string;
begin
  sFileName := g_Config.sEnvirDir + 'UnForceMaster.txt';
  g_UnForceMasterList.Lock;
  try
    g_UnForceMasterList.SaveToFile(sFileName);
  finally
    g_UnForceMasterList.UnLock;
  end;
  Result := True;
end;

function LoadDisableMoveMap(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DisableMoveMap.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_DisableMoveMapList.Lock;
    try
      g_DisableMoveMapList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        g_DisableMoveMapList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DisableMoveMapList.UnLock;
    end;
    Result := True;
  end else
    LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function LoadMissionList(): Integer;
var
  i, ii, iii, nClass        : Integer;
  sFileName                 : string;
  sLine, sid, SC, sTitle    : string;
  List, LoadList            : TStringList;
  sDesc                     : string;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'Missions.txt';
  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.Add(';任务列表');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;

  for i := Low(g_MissionList) to High(g_MissionList) do begin
    for ii := 0 to g_MissionList[i].Count - 1 do
      TStringList(g_MissionList[i].Objects[ii]).Free;
    g_MissionList[i].Clear;
  end;

  sTitle := '';
  nClass := 0;
  List := nil;
  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sFileName);
  for i := 0 to LoadList.Count - 1 do begin
    sLine := Trim(LoadList.Strings[i]);
    if (sLine = '') or (sLine[1] = ';') then Continue;
    if sLine[1] = '[' then begin
      if (List <> nil) and (sTitle <> '') and (sid <> '') and (nClass in [1..4]) then begin
        g_MissionList[nClass].AddObject(sid, List);
      end;
      List := TStringList.Create;
      sTitle := Trim(ArrestStringEx(sLine, '[', ']', SC));
      sid := GetValidStrCap(SC, SC, [' ', ',', '-', #9]);
      nClass := Str_ToInt(SC, 0);
      Inc(Result);
    end else if (List <> nil) and (sTitle <> '') and (sid <> '') and (nClass in [1..4]) then
      List.Add(Format(MISSION_DESC, [sTitle, sLine])); //'title=%s desc=%s'
  end;
  if (List <> nil) and (sTitle <> '') and (sid <> '') and (nClass in [1..4]) then
    g_MissionList[nClass].AddObject(sid, List);
  LoadList.Free;
end;

function GetMissionSendMsg(sid: string; nStep: Integer; var nClass: Integer): string;
var
  bf                        : Boolean;
  i, ii                     : Integer;
  mList, SetpList           : TStringList;
begin
  Result := '';
  bf := False;
  nClass := 0;
  for i := Low(g_MissionList) to High(g_MissionList) do begin
    mList := g_MissionList[i];
    for ii := 0 to mList.Count - 1 do begin
      if CompareText(mList[ii], sid) <> 0 then Continue;
      SetpList := TStringList(mList.Objects[ii]);
      if (SetpList.Count > 0) and (nStep > 0) and (nStep <= SetpList.Count) then Result := SetpList[nStep - 1];
      bf := True;
      nClass := i;
      Break;
    end;
    if bf then Break;
  end;
end;

function SaveDisableMoveMap(): Boolean;
var
  sFileName                 : string;
begin
  sFileName := g_Config.sEnvirDir + 'DisableMoveMap.txt';
  g_DisableMoveMapList.Lock;
  try
    g_DisableMoveMapList.SaveToFile(sFileName);
  finally
    g_DisableMoveMapList.UnLock;
  end;
  Result := True;
end;

function GetUseItemIdx(sName: string): Integer;
begin
  Result := -1;
  if CompareText(sName, U_DRESSNAME) = 0 then
    Result := 0
  else if CompareText(sName, U_WEAPONNAME) = 0 then
    Result := 1
  else if CompareText(sName, U_RIGHTHANDNAME) = 0 then
    Result := 2
  else if CompareText(sName, U_NECKLACENAME) = 0 then
    Result := 3
  else if CompareText(sName, U_HELMETNAME) = 0 then
    Result := 4
  else if CompareText(sName, U_ARMRINGLNAME) = 0 then
    Result := 5
  else if CompareText(sName, U_ARMRINGRNAME) = 0 then
    Result := 6
  else if CompareText(sName, U_RINGLNAME) = 0 then
    Result := 7
  else if CompareText(sName, U_RINGRNAME) = 0 then
    Result := 8
  else if CompareText(sName, U_BUJUKNAME) = 0 then
    Result := 9
  else if CompareText(sName, U_BELTNAME) = 0 then
    Result := 10
  else if CompareText(sName, U_BOOTSNAME) = 0 then
    Result := 11
  else if CompareText(sName, U_CHARMNAME) = 0 then
    Result := 12
  else if CompareText(sName, U_HELMETexNAME) = 0 then
    Result := 13
  else if CompareText(sName, U_DRUMNAME) = 0 then
    Result := 14
  else if CompareText(sName, U_HORSENAME) = 0 then
    Result := 15
  else if CompareText(sName, U_FASHIONNAME) = 0 then
    Result := 16
end;

function GetUseItemName(nIndex: Integer): string;
begin
  case nIndex of
    0: Result := U_DRESSNAME;
    1: Result := U_WEAPONNAME;
    2: Result := U_RIGHTHANDNAME;
    3: Result := U_NECKLACENAME;
    4: Result := U_HELMETNAME;
    5: Result := U_ARMRINGLNAME;
    6: Result := U_ARMRINGRNAME;
    7: Result := U_RINGLNAME;
    8: Result := U_RINGRNAME;
    9: Result := U_BUJUKNAME;
    10: Result := U_BELTNAME;
    11: Result := U_BOOTSNAME;
    12: Result := U_CHARMNAME;
    13: Result := U_HELMETexNAME;
    14: Result := U_DRUMNAME;
    15: Result := U_HORSENAME;
    16: Result := U_FASHIONNAME;
  end;
end;

function LoadDisableSendMsgList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DisableSendMsgList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_DisableSendMsgList.Clear;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      g_DisableSendMsgList.Add(Trim(LoadList.Strings[i]));
    end;
    Result := True;
  end else
    LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function LoadMonDropLimitList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sLineText                 : string;
  sFileName                 : string;
  sItemName, sItemCount     : string;
  nItemCount                : Integer;
  MonDrop                   : pTMonDrop;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'MonDropLimitList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_MonDropLimitLIst.Clear;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText = '') or (sLineText[1] = ';') then
        Continue;
      sLineText := GetValidStr3(sLineText, sItemName, [' ', '/', ',', #9]);
      sLineText := GetValidStr3(sLineText, sItemCount, [' ', '/', ',', #9]);
      nItemCount := Str_ToInt(sItemCount, -1);
      if (sItemName <> '') and (nItemCount >= 0) then begin
        New(MonDrop);
        MonDrop.sItemName := sItemName;
        MonDrop.nDropCount := 0;
        MonDrop.nNoDropCount := 0;
        MonDrop.nCountLimit := nItemCount;
        MonDrop.ClearTime := Str_ToInt(sLineText, 10);
        MonDrop.Time := GetTickCount;
        g_MonDropLimitLIst.AddObject(sItemName, TObject(MonDrop));
      end;
    end;
    Result := True;
  end else
    LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function SaveMonDropLimitList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
  sLineText                 : string;
  MonDrop                   : pTMonDrop;
begin
  sFileName := g_Config.sEnvirDir + 'MonDropLimitList.txt';
  LoadList := TStringList.Create;
  for i := 0 to g_MonDropLimitLIst.Count - 1 do begin
    MonDrop := pTMonDrop(g_MonDropLimitLIst.Objects[i]);
    sLineText := MonDrop.sItemName + #9 + IntToStr(MonDrop.nCountLimit) + #9 + IntToStr(MonDrop.ClearTime);
    LoadList.Add(sLineText);
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
  Result := True;
end;

procedure LoadUserCmdList();
var
  i, nVar                   : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
  sLineText                 : string;
  sUserCmd                  : string;
  sCmdNo                    : string;
  nCmdNo                    : Integer;
begin
  sFileName := g_Config.sEnvirDir + 'UserCmd.txt';
  if not FileExists(sFileName) then begin
    LoadList := Classes.TStringList.Create();
    LoadList.Add(';自定义命令配置文件');
    LoadList.Add(';命令名称'#9'对应编号');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;
  g_UserCmdList.Lock;
  try
    g_UserCmdList.Clear;
    LoadList := TStringList.Create();
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sLineText := GetValidStr3(sLineText, sUserCmd, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sCmdNo, [' ', #9]);
        nCmdNo := Str_ToInt(sCmdNo, -1);
        if (sUserCmd <> '') and (nCmdNo >= 0) then
          g_UserCmdList.AddObject(sUserCmd, TObject(nCmdNo));
      end;
    end;
  finally
    g_UserCmdList.UnLock;
  end;
  LoadList.Free;
end;

procedure SaveUserCmdList();
var
  i                         : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'UserCmd.txt';
  g_UserCmdList.Lock;
  try
    LoadList := TStringList.Create();
    for i := 0 to g_UserCmdList.Count - 1 do
      LoadList.Add(g_UserCmdList.Strings[i] + #9 + IntToStr(Integer(g_UserCmdList.Objects[i])));
  finally
    g_UserCmdList.UnLock;
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function LoadGuildRankNameFilterList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'GuildRankNameFilter.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_GuildRankNameFilterList.Lock;
    try
      g_GuildRankNameFilterList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
        g_GuildRankNameFilterList.Add(Trim(LoadList.Strings[i]));
    finally
      g_GuildRankNameFilterList.UnLock;
    end;
    Result := True;
  end else begin
    LoadList.Add('\');
    LoadList.Add('/');
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

procedure SaveGuildRankNameFilterList();
var
  sFileName                 : string;
begin
  sFileName := g_Config.sEnvirDir + 'GuildRankNameFilter.txt';
  g_GuildRankNameFilterList.Lock;
  try
    g_GuildRankNameFilterList.SaveToFile(sFileName);
  finally
    g_GuildRankNameFilterList.UnLock;
  end;
end;

function IsInGuildRankNameFilterList(sWord: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  g_GuildRankNameFilterList.Lock;
  try
    for i := 0 to g_GuildRankNameFilterList.Count - 1 do begin
      if Pos(g_GuildRankNameFilterList.Strings[i], sWord) > 0 then begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_GuildRankNameFilterList.UnLock;
  end;
end;

function SaveDisableSendMsgList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  sFileName := g_Config.sEnvirDir + 'DisableSendMsgList.txt';
  LoadList := TStringList.Create;
  for i := 0 to g_DisableSendMsgList.Count - 1 do begin
    LoadList.Add(g_DisableSendMsgList.Strings[i]);
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
  Result := True;
end;

function GetDisableSendMsgList(sHumanName: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  for i := 0 to g_DisableSendMsgList.Count - 1 do begin
    if CompareText(sHumanName, g_DisableSendMsgList.Strings[i]) = 0 then begin
      Result := True;
      Break;
    end;
  end;
end;

function LoadGameLogItemNameList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'GameLogItemNameList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_GameLogItemNameList.Lock;
    try
      g_GameLogItemNameList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        g_GameLogItemNameList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_GameLogItemNameList.UnLock;
    end;
    Result := True;
  end
  else begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function GetGameLogItemNameList(sItemName: string): Byte;
var
  i                         : Integer;
begin
  Result := 0;
  g_GameLogItemNameList.Lock;
  try
    for i := 0 to g_GameLogItemNameList.Count - 1 do begin
      if CompareText(sItemName, g_GameLogItemNameList.Strings[i]) = 0 then begin
        Result := 1;
        Break;
      end;
    end;
  finally
    g_GameLogItemNameList.UnLock;
  end;
end;

function SaveGameLogItemNameList(): Boolean;
var
  sFileName                 : string;
begin
  sFileName := g_Config.sEnvirDir + 'GameLogItemNameList.txt';
  g_GameLogItemNameList.Lock;
  try
    g_GameLogItemNameList.SaveToFile(sFileName);
  finally
    g_GameLogItemNameList.UnLock;
  end;
  Result := True;
end;

function LoadDenyIPAddrList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DenyIPAddrList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_DenyIPAddrList.Lock;
    try
      g_DenyIPAddrList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        g_DenyIPAddrList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DenyIPAddrList.UnLock;
    end;
    Result := True;
  end
  else begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function GetDenyIPaddrList(sIPaddr: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  g_DenyIPAddrList.Lock;
  try
    for i := 0 to g_DenyIPAddrList.Count - 1 do begin
      if CompareText(sIPaddr, g_DenyIPAddrList.Strings[i]) = 0 then begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_DenyIPAddrList.UnLock;
  end;
end;

function SaveDenyIPAddrList(): Boolean;
var
  i                         : Integer;
  sFileName                 : string;
  SaveList                  : TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'DenyIPAddrList.txt';
  SaveList := TStringList.Create;
  g_DenyIPAddrList.Lock;
  try
    for i := 0 to g_DenyIPAddrList.Count - 1 do begin
      if Integer(g_DenyIPAddrList.Objects[i]) <> 0 then begin
        SaveList.Add(g_DenyIPAddrList.Strings[i]);
      end;
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_DenyIPAddrList.UnLock;
  end;
  SaveList.Free;
  Result := True;
end;

procedure InitVariablesList();
var
  pVar                      : pTVariables;
begin
  if g_VariablesList = nil then g_VariablesList := TCnHashTableSmall.Create;
  g_VariablesList.Clear;

  g_VariablesList.Add('$SERVERNAME', TObject(v_SERVERNAME));
  g_VariablesList.Add('$SERVERIP', TObject(v_SERVERIP));
  g_VariablesList.Add('$WEBSITE', TObject(v_WEBSITE));

  g_VariablesList.Add('$BBSSITE', TObject(v_BBSSITE));
  g_VariablesList.Add('$CLIENTDOWNLOAD', TObject(v_CLIENTDOWNLOAD));
  g_VariablesList.Add('$QQ', TObject(v_QQ));
  g_VariablesList.Add('$PHONE', TObject(v_PHONE));
  g_VariablesList.Add('$BANKACCOUNT0', TObject(v_BANKACCOUNT0));
  g_VariablesList.Add('$BANKACCOUNT1', TObject(v_BANKACCOUNT1));
  g_VariablesList.Add('$BANKACCOUNT2', TObject(v_BANKACCOUNT2));
  g_VariablesList.Add('$BANKACCOUNT3', TObject(v_BANKACCOUNT3));
  g_VariablesList.Add('$BANKACCOUNT4', TObject(v_BANKACCOUNT4));
  g_VariablesList.Add('$BANKACCOUNT5', TObject(v_BANKACCOUNT5));
  g_VariablesList.Add('$BANKACCOUNT6', TObject(v_BANKACCOUNT6));
  g_VariablesList.Add('$BANKACCOUNT7', TObject(v_BANKACCOUNT7));
  g_VariablesList.Add('$BANKACCOUNT8', TObject(v_BANKACCOUNT8));
  g_VariablesList.Add('$BANKACCOUNT9', TObject(v_BANKACCOUNT9));
  g_VariablesList.Add('$GAMEGOLDNAME', TObject(v_GAMEGOLDNAME));
  g_VariablesList.Add('$GAMEPOINTNAME', TObject(v_GAMEPOINTNAME));
  g_VariablesList.Add('$USERCOUNT', TObject(v_USERCOUNT));
  g_VariablesList.Add('$MACRUNTIME', TObject(v_MACRUNTIME));
  g_VariablesList.Add('$SERVERRUNTIME', TObject(v_SERVERRUNTIME));
  g_VariablesList.Add('$DATETIME', TObject(v_DATETIME));
  g_VariablesList.Add('$HIGHLEVELINFO', TObject(v_HIGHLEVELINFO));
  g_VariablesList.Add('$HIGHPKINFO', TObject(v_HIGHPKINFO));
  g_VariablesList.Add('$HIGHDCINFO', TObject(v_HIGHDCINFO));
  g_VariablesList.Add('$HIGHMCINFO', TObject(v_HIGHMCINFO));
  g_VariablesList.Add('$HIGHSCINFO', TObject(v_HIGHSCINFO));
  g_VariablesList.Add('$HIGHONLINEINFO', TObject(v_HIGHONLINEINFO));

  g_VariablesList.Add('$CURRENTMAPDESC', TObject(v_CURRENTMAPDESC));
  g_VariablesList.Add('$CURRENTMAP', TObject(v_CURRENTMAP));
  g_VariablesList.Add('$CURRENTX', TObject(v_CURRENTX));
  g_VariablesList.Add('$CURRENTY', TObject(v_CURRENTY));
  g_VariablesList.Add('$GENDER', TObject(v_GENDER));
  //g_VariablesList.Add('$H.GENDER', TObject(v_H_GENDER));
  g_VariablesList.Add('$JOB', TObject(v_JOB));
  //g_VariablesList.Add('$H.JOB', TObject(v_H_JOB));
  g_VariablesList.Add('$ABILITYADDPOINT0', TObject(v_ABILITYADDPOINT0));
  g_VariablesList.Add('$ABILITYADDPOINT1', TObject(v_ABILITYADDPOINT1));
  g_VariablesList.Add('$ABILITYADDPOINT2', TObject(v_ABILITYADDPOINT2));
  g_VariablesList.Add('$ABILITYADDPOINT3', TObject(v_ABILITYADDPOINT3));
  g_VariablesList.Add('$ABILITYADDPOINT4', TObject(v_ABILITYADDPOINT4));
  g_VariablesList.Add('$ABILITYADDPOINT5', TObject(v_ABILITYADDPOINT5));
  g_VariablesList.Add('$ABILITYADDPOINT6', TObject(v_ABILITYADDPOINT6));
  g_VariablesList.Add('$ABILITYADDTIME0', TObject(v_ABILITYADDTIME0));
  g_VariablesList.Add('$ABILITYADDTIME1', TObject(v_ABILITYADDTIME1));
  g_VariablesList.Add('$ABILITYADDTIME2', TObject(v_ABILITYADDTIME2));
  g_VariablesList.Add('$ABILITYADDTIME3', TObject(v_ABILITYADDTIME3));
  g_VariablesList.Add('$ABILITYADDTIME4', TObject(v_ABILITYADDTIME4));
  g_VariablesList.Add('$ABILITYADDTIME5', TObject(v_ABILITYADDTIME5));
  g_VariablesList.Add('$ABILITYADDTIME6', TObject(v_ABILITYADDTIME6));

  g_VariablesList.Add('$USERNAME', TObject(v_USERNAME));
  g_VariablesList.Add('$ROBBER', TObject(v_ROBBER));
  g_VariablesList.Add('$MEMBRETYPE', TObject(v_MEMBRETYPE));
  g_VariablesList.Add('$MEMBRELEVEL', TObject(v_MEMBRELEVEL));

  g_VariablesList.Add('$DLGITEMNAME', TObject(v_DLGITEMNAME));
  g_VariablesList.Add('$RANDOMNO', TObject(v_RANDOMNO));
  g_VariablesList.Add('$DEALGOLDPLAY', TObject(v_DEALGOLDPLAY));
  g_VariablesList.Add('$MONKILLER', TObject(v_MONKILLER));
  g_VariablesList.Add('$KILLER', TObject(v_KILLER));
  g_VariablesList.Add('$DECEDENT', TObject(v_DECEDENT));
  g_VariablesList.Add('$RELEVEL', TObject(v_RELEVEL));
  //g_VariablesList.Add('$H.RELEVEL', TObject(v_H_RELEVEL));
  g_VariablesList.Add('$HUMANSHOWNAME', TObject(v_HUMANSHOWNAME));

  g_VariablesList.Add('$GUILDHUMCOUNT', TObject(v_GUILDHUMCOUNT));
  g_VariablesList.Add('$GUILDNAME', TObject(v_GUILDNAME));
  g_VariablesList.Add('$RANKNAME', TObject(v_RANKNAME));
  g_VariablesList.Add('$LEVEL', TObject(v_LEVEL));
  g_VariablesList.Add('$GCEPAYMENT', TObject(v_GCEPAYMENT));
  g_VariablesList.Add('$COLLECTEXP', TObject(v_COLLECTEXP));
  g_VariablesList.Add('$COLLECTIPEXP', TObject(v_COLLECTIPEXP));

  g_VariablesList.Add('$GAINCOLLECTEXP', TObject(v_GAINCOLLECTEXP));
  g_VariablesList.Add('$GAINCOLLECTIPEXP', TObject(v_GAINCOLLECTIPEXP));
  g_VariablesList.Add('$HP', TObject(v_HP));
  g_VariablesList.Add('$MAXHP', TObject(v_MAXHP));
  g_VariablesList.Add('$MP', TObject(v_MP));
  g_VariablesList.Add('$MAXMP', TObject(v_MAXMP));
  g_VariablesList.Add('$AC', TObject(v_AC));
  g_VariablesList.Add('$MAXAC', TObject(v_MAXAC));
  g_VariablesList.Add('$MAC', TObject(v_MAC));
  g_VariablesList.Add('$MAXMAC', TObject(v_MAXMAC));
  g_VariablesList.Add('$DC', TObject(v_DC));
  g_VariablesList.Add('$MAXDC', TObject(v_MAXDC));
  g_VariablesList.Add('$MC', TObject(v_MC));
  g_VariablesList.Add('$MAXMC', TObject(v_MAXMC));
  g_VariablesList.Add('$SC', TObject(v_SC));
  g_VariablesList.Add('$MAXSC', TObject(v_MAXSC));
  g_VariablesList.Add('$HIT', TObject(v_HIT));
  g_VariablesList.Add('$SPD', TObject(v_SPD));
  g_VariablesList.Add('$BONUSPOINT', TObject(v_BONUSPOINT));
  g_VariablesList.Add('$BONUSABIL_AC', TObject(v_BONUSABIL_AC));
  g_VariablesList.Add('$BONUSABIL_MAC', TObject(v_BONUSABIL_MAC));
  g_VariablesList.Add('$BONUSABIL_DC', TObject(v_BONUSABIL_DC));
  g_VariablesList.Add('$BONUSABIL_MC', TObject(v_BONUSABIL_MC));
  g_VariablesList.Add('$BONUSABIL_SC', TObject(v_BONUSABIL_SC));
  g_VariablesList.Add('$BONUSABIL_HP', TObject(v_BONUSABIL_HP));
  g_VariablesList.Add('$BONUSABIL_MP', TObject(v_BONUSABIL_MP));
  g_VariablesList.Add('$BONUSABIL_HIT', TObject(v_BONUSABIL_HIT));
  g_VariablesList.Add('$BONUSABIL_SPD', TObject(v_BONUSABIL_SPD));
  g_VariablesList.Add('$BONUSABIL_X2', TObject(v_BONUSABIL_X2));

  g_VariablesList.Add('$BONUSTICK_AC', TObject(v_BONUSTICK_AC));
  g_VariablesList.Add('$BONUSTICK_MAC', TObject(v_BONUSTICK_MAC));
  g_VariablesList.Add('$BONUSTICK_DC', TObject(v_BONUSTICK_DC));
  g_VariablesList.Add('$BONUSTICK_MC', TObject(v_BONUSTICK_MC));
  g_VariablesList.Add('$BONUSTICK_SC', TObject(v_BONUSTICK_SC));
  g_VariablesList.Add('$BONUSTICK_HP', TObject(v_BONUSTICK_HP));
  g_VariablesList.Add('$BONUSTICK_MP', TObject(v_BONUSTICK_HP));
  g_VariablesList.Add('$BONUSTICK_HIT', TObject(v_BONUSTICK_HIT));
  g_VariablesList.Add('$BONUSTICK_SPD', TObject(v_BONUSTICK_SPD));
  g_VariablesList.Add('$BONUSTICK_X2', TObject(v_BONUSTICK_X2));

  g_VariablesList.Add('$EXP', TObject(v_EXP));
  g_VariablesList.Add('$MAXEXP', TObject(v_MAXEXP));
  g_VariablesList.Add('$PKPOINT', TObject(v_PKPOINT));
  g_VariablesList.Add('$CREDITPOINT', TObject(v_CREDITPOINT));
  g_VariablesList.Add('$HEROCREDITPOINT', TObject(v_HEROCREDITPOINT));
  g_VariablesList.Add('$HW', TObject(v_HW));
  g_VariablesList.Add('$MAXHW', TObject(v_MAXHW));
  g_VariablesList.Add('$BW', TObject(v_BW));
  g_VariablesList.Add('$MAXBW', TObject(v_MAXBW));
  g_VariablesList.Add('$WW', TObject(v_WW));
  g_VariablesList.Add('$MAXWW', TObject(v_MAXWW));
  g_VariablesList.Add('$GOLDCOUNT', TObject(v_GOLDCOUNT));
  g_VariablesList.Add('$GAMEGOLD', TObject(v_GAMEGOLD));
  g_VariablesList.Add('$NIMBUS', TObject(v_NIMBUS));
  //g_VariablesList.Add('$H.NIMBUS', TObject(v_H_NIMBUS));
  g_VariablesList.Add('$GAMEPOINT', TObject(v_GAMEPOINT));
  g_VariablesList.Add('$GAMEDIAMOND', TObject(v_GAMEDIAMOND));
  g_VariablesList.Add('$GAMEGIRD', TObject(v_GAMEGIRD));
  g_VariablesList.Add('$HUNGER', TObject(v_HUNGER));
  g_VariablesList.Add('$LOGINTIME', TObject(v_LOGINTIME));
  g_VariablesList.Add('$LOGINLONG', TObject(v_LOGINLONG));
  g_VariablesList.Add('$DRESS', TObject(v_DRESS));
  g_VariablesList.Add('$WEAPON', TObject(v_WEAPON));
  g_VariablesList.Add('$RIGHTHAND', TObject(v_RIGHTHAND));
  g_VariablesList.Add('$HELMET', TObject(v_HELMET));
  g_VariablesList.Add('$HELMETEX', TObject(v_HELMETEX));
  g_VariablesList.Add('$NECKLACE', TObject(v_NECKLACE));
  g_VariablesList.Add('$RING_R', TObject(v_RING_R));
  g_VariablesList.Add('$RING_L', TObject(v_RING_L));
  g_VariablesList.Add('$ARMRING_R', TObject(v_ARMRING_R));
  g_VariablesList.Add('$ARMRING_L', TObject(v_ARMRING_L));
  g_VariablesList.Add('$BUJUK', TObject(v_BUJUK));
  g_VariablesList.Add('$BELT', TObject(v_BELT));
  g_VariablesList.Add('$BOOTS', TObject(v_BOOTS));
  g_VariablesList.Add('$CHARM', TObject(v_CHARM));

  g_VariablesList.Add('$DRUM', TObject(v_DRUM));
  g_VariablesList.Add('$HORSE', TObject(v_HORSE));
  g_VariablesList.Add('$FASHION', TObject(v_FASHION));
  g_VariablesList.Add('$HWID', TObject(v_HWID));

  g_VariablesList.Add('$IPADDR', TObject(v_IPADDR));
  g_VariablesList.Add('$IPLOCAL', TObject(v_IPLOCAL));
  g_VariablesList.Add('$GUILDBUILDPOINT', TObject(v_GUILDBUILDPOINT));
  g_VariablesList.Add('$GUILDAURAEPOINT', TObject(v_GUILDAURAEPOINT));
  g_VariablesList.Add('$GUILDSTABILITYPOINT', TObject(v_GUILDSTABILITYPOINT));
  g_VariablesList.Add('$GUILDFLOURISHPOINT', TObject(v_GUILDFLOURISHPOINT));
  g_VariablesList.Add('$REQUESTCASTLEWARITEM', TObject(v_REQUESTCASTLEWARITEM));

  g_VariablesList.Add('$REQUESTCASTLEWARDAY', TObject(v_REQUESTCASTLEWARDAY));
  g_VariablesList.Add('$REQUESTBUILDGUILDITEM', TObject(v_REQUESTBUILDGUILDITEM));
  g_VariablesList.Add('$OWNERGUILD', TObject(v_OWNERGUILD));
  g_VariablesList.Add('$CASTLENAME', TObject(v_CASTLENAME));
  g_VariablesList.Add('$LORD', TObject(v_LORD));
  g_VariablesList.Add('$GUILDWARFEE', TObject(v_GUILDWARFEE));
  g_VariablesList.Add('$BUILDGUILDFEE', TObject(v_BUILDGUILDFEE));
  g_VariablesList.Add('$CASTLEWARDATE', TObject(v_CASTLEWARDATE));
  g_VariablesList.Add('$LISTOFWAR', TObject(v_LISTOFWAR));
  g_VariablesList.Add('$CASTLECHANGEDATE', TObject(v_CASTLECHANGEDATE));
  g_VariablesList.Add('$CASTLEWARLASTDATE', TObject(v_CASTLEWARLASTDATE));
  g_VariablesList.Add('$CASTLEGETDAYS', TObject(v_CASTLEGETDAYS));
  g_VariablesList.Add('$CMD_DATE', TObject(v_CMD_DATE));
  g_VariablesList.Add('$CMD_ALLOWMSG', TObject(v_CMD_ALLOWMSG));
  g_VariablesList.Add('$CMD_LETSHOUT', TObject(v_CMD_LETSHOUT));
  g_VariablesList.Add('$CMD_LETTRADE', TObject(v_CMD_LETTRADE));
  g_VariablesList.Add('$CMD_LETGUILD', TObject(v_CMD_LETGUILD));
  g_VariablesList.Add('$CMD_ENDGUILD', TObject(v_CMD_ENDGUILD));
  g_VariablesList.Add('$CMD_BANGUILDCHAT', TObject(v_CMD_BANGUILDCHAT));
  g_VariablesList.Add('$CMD_AUTHALLY', TObject(v_CMD_AUTHALLY));
  g_VariablesList.Add('$CMD_AUTH', TObject(v_CMD_AUTH));
  g_VariablesList.Add('$CMD_AUTHCANCEL', TObject(v_CMD_AUTHCANCEL));
  g_VariablesList.Add('$CMD_USERMOVE', TObject(v_CMD_USERMOVE));
  g_VariablesList.Add('$CMD_SEARCHING', TObject(v_CMD_SEARCHING));
  g_VariablesList.Add('$CMD_ALLOWGROUPCALL', TObject(v_CMD_ALLOWGROUPCALL));
  g_VariablesList.Add('$CMD_GROUPRECALLL', TObject(v_CMD_GROUPRECALLL));
  g_VariablesList.Add('$CMD_ATTACKMODE', TObject(v_CMD_ATTACKMODE));
  g_VariablesList.Add('$CMD_REST', TObject(v_CMD_REST));
  g_VariablesList.Add('$CMD_STORAGESETPASSWORD', TObject(v_CMD_STORAGESETPASSWORD));
  g_VariablesList.Add('$CMD_STORAGECHGPASSWORD', TObject(v_CMD_STORAGECHGPASSWORD));
  g_VariablesList.Add('$CMD_STORAGELOCK', TObject(v_CMD_STORAGELOCK));
  g_VariablesList.Add('$CMD_STORAGEUNLOCK', TObject(v_CMD_STORAGEUNLOCK));
  g_VariablesList.Add('$CMD_UNLOCK', TObject(v_CMD_UNLOCK));

  {g_VariablesList.Add('$H.GOLD', TObject(v_H_GOLD));
  g_VariablesList.Add('$H.GAMEPOINT', TObject(v_H_GAMEPOINT));
  g_VariablesList.Add('$H.GAMEGOLD', TObject(v_H_GAMEGOLD));
  g_VariablesList.Add('$H.GAMEDIAMOND', TObject(v_H_GAMEDIAMOND));
  g_VariablesList.Add('$H.GAMEGIRD', TObject(v_H_GAMEGIRD));}

  //////////////////////////////////////
  ///
  g_VariablesList.Add('$H.CURRENTMAPDESC', TObject(10000 + v_CURRENTMAPDESC));
  g_VariablesList.Add('$H.CURRENTMAP', TObject(10000 + v_CURRENTMAP));
  g_VariablesList.Add('$H.CURRENTX', TObject(10000 + v_CURRENTX));
  g_VariablesList.Add('$H.CURRENTY', TObject(10000 + v_CURRENTY));
  g_VariablesList.Add('$H.GENDER', TObject(10000 + v_GENDER));
  g_VariablesList.Add('$H.JOB', TObject(10000 + v_JOB));
  g_VariablesList.Add('$H.ABILITYADDPOINT0', TObject(10000 + v_ABILITYADDPOINT0));
  g_VariablesList.Add('$H.ABILITYADDPOINT1', TObject(10000 + v_ABILITYADDPOINT1));
  g_VariablesList.Add('$H.ABILITYADDPOINT2', TObject(10000 + v_ABILITYADDPOINT2));
  g_VariablesList.Add('$H.ABILITYADDPOINT3', TObject(10000 + v_ABILITYADDPOINT3));
  g_VariablesList.Add('$H.ABILITYADDPOINT4', TObject(10000 + v_ABILITYADDPOINT4));
  g_VariablesList.Add('$H.ABILITYADDPOINT5', TObject(10000 + v_ABILITYADDPOINT5));
  g_VariablesList.Add('$H.ABILITYADDPOINT6', TObject(10000 + v_ABILITYADDPOINT6));
  g_VariablesList.Add('$H.ABILITYADDTIME0', TObject(10000 + v_ABILITYADDTIME0));
  g_VariablesList.Add('$H.ABILITYADDTIME1', TObject(10000 + v_ABILITYADDTIME1));
  g_VariablesList.Add('$H.ABILITYADDTIME2', TObject(10000 + v_ABILITYADDTIME2));
  g_VariablesList.Add('$H.ABILITYADDTIME3', TObject(10000 + v_ABILITYADDTIME3));
  g_VariablesList.Add('$H.ABILITYADDTIME4', TObject(10000 + v_ABILITYADDTIME4));
  g_VariablesList.Add('$H.ABILITYADDTIME5', TObject(10000 + v_ABILITYADDTIME5));
  g_VariablesList.Add('$H.ABILITYADDTIME6', TObject(10000 + v_ABILITYADDTIME6));

  g_VariablesList.Add('$H.USERNAME', TObject(10000 + v_USERNAME));

  g_VariablesList.Add('$H.MEMBRETYPE', TObject(10000 + v_MEMBRETYPE));
  g_VariablesList.Add('$H.MEMBRELEVEL', TObject(10000 + v_MEMBRELEVEL));

  g_VariablesList.Add('$H.MONKILLER', TObject(10000 + v_MONKILLER));
  g_VariablesList.Add('$H.KILLER', TObject(10000 + v_KILLER));

  g_VariablesList.Add('$H.DECEDENT', TObject(10000 + v_DECEDENT));
  g_VariablesList.Add('$H.RELEVEL', TObject(10000 + v_RELEVEL));
  g_VariablesList.Add('$H.HUMANSHOWNAME', TObject(10000 + v_HUMANSHOWNAME));

  g_VariablesList.Add('$H.LEVEL', TObject(10000 + v_LEVEL));
  g_VariablesList.Add('$H.HP', TObject(10000 + v_HP));
  g_VariablesList.Add('$H.MAXHP', TObject(10000 + v_MAXHP));
  g_VariablesList.Add('$H.MP', TObject(10000 + v_MP));
  g_VariablesList.Add('$H.MAXMP', TObject(10000 + v_MAXMP));
  g_VariablesList.Add('$H.AC', TObject(10000 + v_AC));
  g_VariablesList.Add('$H.MAXAC', TObject(10000 + v_MAXAC));
  g_VariablesList.Add('$H.MAC', TObject(10000 + v_MAC));
  g_VariablesList.Add('$H.MAXMAC', TObject(10000 + v_MAXMAC));
  g_VariablesList.Add('$H.DC', TObject(10000 + v_DC));
  g_VariablesList.Add('$H.MAXDC', TObject(10000 + v_MAXDC));
  g_VariablesList.Add('$H.MC', TObject(10000 + v_MC));
  g_VariablesList.Add('$H.MAXMC', TObject(10000 + v_MAXMC));
  g_VariablesList.Add('$H.SC', TObject(10000 + v_SC));
  g_VariablesList.Add('$H.MAXSC', TObject(10000 + v_MAXSC));
  g_VariablesList.Add('$H.HIT', TObject(10000 + v_HIT));
  g_VariablesList.Add('$H.SPD', TObject(10000 + v_SPD));
  g_VariablesList.Add('$H.BONUSPOINT', TObject(10000 + v_BONUSPOINT));
  g_VariablesList.Add('$H.BONUSABIL_AC', TObject(10000 + v_BONUSABIL_AC));
  g_VariablesList.Add('$H.BONUSABIL_MAC', TObject(10000 + v_BONUSABIL_MAC));
  g_VariablesList.Add('$H.BONUSABIL_DC', TObject(10000 + v_BONUSABIL_DC));
  g_VariablesList.Add('$H.BONUSABIL_MC', TObject(10000 + v_BONUSABIL_MC));
  g_VariablesList.Add('$H.BONUSABIL_SC', TObject(10000 + v_BONUSABIL_SC));
  g_VariablesList.Add('$H.BONUSABIL_HP', TObject(10000 + v_BONUSABIL_HP));
  g_VariablesList.Add('$H.BONUSABIL_MP', TObject(10000 + v_BONUSABIL_MP));
  g_VariablesList.Add('$H.BONUSABIL_HIT', TObject(10000 + v_BONUSABIL_HIT));
  g_VariablesList.Add('$H.BONUSABIL_SPD', TObject(10000 + v_BONUSABIL_SPD));
  g_VariablesList.Add('$H.BONUSABIL_X2', TObject(10000 + v_BONUSABIL_X2));

  g_VariablesList.Add('$H.BONUSTICK_AC', TObject(10000 + v_BONUSTICK_AC));
  g_VariablesList.Add('$H.BONUSTICK_MAC', TObject(10000 + v_BONUSTICK_MAC));
  g_VariablesList.Add('$H.BONUSTICK_DC', TObject(10000 + v_BONUSTICK_DC));
  g_VariablesList.Add('$H.BONUSTICK_MC', TObject(10000 + v_BONUSTICK_MC));
  g_VariablesList.Add('$H.BONUSTICK_SC', TObject(10000 + v_BONUSTICK_SC));
  g_VariablesList.Add('$H.BONUSTICK_HP', TObject(10000 + v_BONUSTICK_HP));
  g_VariablesList.Add('$H.BONUSTICK_MP', TObject(10000 + v_BONUSTICK_HP));
  g_VariablesList.Add('$H.BONUSTICK_HIT', TObject(10000 + v_BONUSTICK_HIT));
  g_VariablesList.Add('$H.BONUSTICK_SPD', TObject(10000 + v_BONUSTICK_SPD));
  g_VariablesList.Add('$H.BONUSTICK_X2', TObject(10000 + v_BONUSTICK_X2));

  g_VariablesList.Add('$H.EXP', TObject(10000 + v_EXP));
  g_VariablesList.Add('$H.MAXEXP', TObject(10000 + v_MAXEXP));
  g_VariablesList.Add('$H.PKPOINT', TObject(10000 + v_PKPOINT));
  g_VariablesList.Add('$H.CREDITPOINT', TObject(10000 + v_CREDITPOINT));
  g_VariablesList.Add('$H.HEROCREDITPOINT', TObject(10000 + v_HEROCREDITPOINT));
  g_VariablesList.Add('$H.HW', TObject(10000 + v_HW));
  g_VariablesList.Add('$H.MAXHW', TObject(10000 + v_MAXHW));
  g_VariablesList.Add('$H.BW', TObject(10000 + v_BW));
  g_VariablesList.Add('$H.MAXBW', TObject(10000 + v_MAXBW));
  g_VariablesList.Add('$H.WW', TObject(10000 + v_WW));
  g_VariablesList.Add('$H.MAXWW', TObject(10000 + v_MAXWW));
  g_VariablesList.Add('$H.GOLDCOUNT', TObject(10000 + v_GOLDCOUNT));
  g_VariablesList.Add('$H.GAMEGOLD', TObject(10000 + v_GAMEGOLD));
  g_VariablesList.Add('$H.NIMBUS', TObject(10000 + v_NIMBUS));
  g_VariablesList.Add('$H.GAMEPOINT', TObject(10000 + v_GAMEPOINT));
  g_VariablesList.Add('$H.GAMEDIAMOND', TObject(10000 + v_GAMEDIAMOND));
  g_VariablesList.Add('$H.GAMEGIRD', TObject(10000 + v_GAMEGIRD));
  g_VariablesList.Add('$H.HUNGER', TObject(10000 + v_HUNGER));
  g_VariablesList.Add('$H.LOGINTIME', TObject(10000 + v_LOGINTIME));
  g_VariablesList.Add('$H.LOGINLONG', TObject(10000 + v_LOGINLONG));
  g_VariablesList.Add('$H.DRESS', TObject(10000 + v_DRESS));
  g_VariablesList.Add('$H.WEAPON', TObject(10000 + v_WEAPON));
  g_VariablesList.Add('$H.RIGHTHAND', TObject(10000 + v_RIGHTHAND));
  g_VariablesList.Add('$H.HELMET', TObject(10000 + v_HELMET));
  g_VariablesList.Add('$H.HELMETEX', TObject(10000 + v_HELMETEX));
  g_VariablesList.Add('$H.NECKLACE', TObject(10000 + v_NECKLACE));
  g_VariablesList.Add('$H.RING_R', TObject(10000 + v_RING_R));
  g_VariablesList.Add('$H.RING_L', TObject(10000 + v_RING_L));
  g_VariablesList.Add('$H.ARMRING_R', TObject(10000 + v_ARMRING_R));
  g_VariablesList.Add('$H.ARMRING_L', TObject(10000 + v_ARMRING_L));
  g_VariablesList.Add('$H.BUJUK', TObject(10000 + v_BUJUK));
  g_VariablesList.Add('$H.BELT', TObject(10000 + v_BELT));
  g_VariablesList.Add('$H.BOOTS', TObject(10000 + v_BOOTS));
  g_VariablesList.Add('$H.CHARM', TObject(10000 + v_CHARM));
  g_VariablesList.Add('$H.DRUM', TObject(10000 + v_DRUM));
  g_VariablesList.Add('$H.HORSE', TObject(10000 + v_HORSE));
  g_VariablesList.Add('$H.FASHION', TObject(10000 + v_FASHION));
  g_VariablesList.Add('$H.IPADDR', TObject(10000 + v_IPADDR));
  g_VariablesList.Add('$H.IPLOCAL', TObject(10000 + v_IPLOCAL));

end;

function LoadHintItemList(): Boolean;
var
  i                         : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'HintItemList.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    g_HintItemList.Clear;
    for i := 0 to LoadList.Count - 1 do
      if LoadList[i] <> '' then g_HintItemList.Put(Trim(LoadList[i]), nil);
    //g_HintItemList.LoadFromFile(sFileName);
    Result := True;
    LoadList.Free;
  end;
end;

function LoadDenyChrNameList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DenyChrNameList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_DenyChrNameList.Lock;
    try
      g_DenyChrNameList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        g_DenyChrNameList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DenyChrNameList.UnLock;
    end;
    Result := True;
  end
  else begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function GetDenyChrNameList(sChrName: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  g_DenyChrNameList.Lock;
  try
    for i := 0 to g_DenyChrNameList.Count - 1 do begin
      if CompareText(sChrName, g_DenyChrNameList.Strings[i]) = 0 then begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_DenyChrNameList.UnLock;
  end;
end;

function SaveDenyChrNameList(): Boolean;
var
  i                         : Integer;
  sFileName                 : string;
  SaveList                  : TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'DenyChrNameList.txt';
  SaveList := TStringList.Create;
  g_DenyChrNameList.Lock;
  try
    for i := 0 to g_DenyChrNameList.Count - 1 do begin
      if Integer(g_DenyChrNameList.Objects[i]) <> 0 then begin
        SaveList.Add(g_DenyChrNameList.Strings[i]);
      end;
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_DenyChrNameList.UnLock;
  end;
  SaveList.Free;
  Result := True;
end;

function LoadDenyAccountList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DenyAccountList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_DenyAccountList.Lock;
    try
      g_DenyAccountList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        g_DenyAccountList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_DenyAccountList.UnLock;
    end;
    Result := True;
  end
  else begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function GetDenyAccountList(sAccount: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  g_DenyAccountList.Lock;
  try
    for i := 0 to g_DenyAccountList.Count - 1 do begin
      if CompareText(sAccount, g_DenyAccountList.Strings[i]) = 0 then begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_DenyAccountList.UnLock;
  end;
end;

function SaveDenyAccountList(): Boolean;
var
  i                         : Integer;
  sFileName                 : string;
  SaveList                  : TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'DenyAccountList.txt';
  SaveList := TStringList.Create;
  g_DenyAccountList.Lock;
  try
    for i := 0 to g_DenyAccountList.Count - 1 do begin
      if Integer(g_DenyAccountList.Objects[i]) <> 0 then begin
        SaveList.Add(g_DenyAccountList.Strings[i]);
      end;
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_DenyAccountList.UnLock;
  end;
  SaveList.Free;
  Result := True;
end;

function LoadNoClearMonList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  sFileName                 : string;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'NoClearMonList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_NoClearMonList.Lock;
    try
      g_NoClearMonList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        g_NoClearMonList.Add(Trim(LoadList.Strings[i]));
      end;
    finally
      g_NoClearMonList.UnLock;
    end;
    Result := True;
  end
  else begin
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

function GetNoClearMonList(sMonName: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  g_NoClearMonList.Lock;
  try
    for i := 0 to g_NoClearMonList.Count - 1 do begin
      if CompareText(sMonName, g_NoClearMonList.Strings[i]) = 0 then begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_NoClearMonList.UnLock;
  end;
end;

function SaveNoClearMonList(): Boolean;
var
  i                         : Integer;
  sFileName                 : string;
  SaveList                  : TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'NoClearMonList.txt';
  SaveList := TStringList.Create;
  g_NoClearMonList.Lock;
  try
    for i := 0 to g_NoClearMonList.Count - 1 do begin
      SaveList.Add(g_NoClearMonList.Strings[i]);
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_NoClearMonList.UnLock;
  end;
  SaveList.Free;
  Result := True;
end;

function LoadAllowBindNameList(): Boolean;
var
  i                         : Integer;
  sFileName                 : string;
  sLineText                 : string;
  LoadList                  : TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'AllowBindNameList.txt';
  g_AllowBindNameList.Clear;
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        g_AllowBindNameList.Add(sLineText);
      end;
    end;
  end else begin
    LoadList.Add(';允许绑定的装备列表，每行一个装备名字');
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
  Result := True;
end;

function LoadMonSayMsg(): Boolean;
var
  i, ii                     : Integer;
  sStatus, sRate, sColor, sMonName, sSayMsg: string;
  nStatus, nRate, nColor    : Integer;
  LoadList                  : TStringList;
  sLineText                 : string;
  MonSayMsg                 : pTMonSayMsg;
  sFileName                 : string;
  MonSayList                : TList;
  boSearch                  : Boolean;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'MonSayMsg.txt';
  if FileExists(sFileName) then begin
    g_MonSayMsgList.Clear;
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sLineText := GetValidStr3(sLineText, sStatus, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sRate, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sColor, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sMonName, [' ', '/', ',', #9]);
        sLineText := GetValidStr3(sLineText, sSayMsg, [' ', '/', ',', #9]);
        if (sStatus <> '') and (sRate <> '') and (sColor <> '') and (sMonName <> '') and (sSayMsg <> '') then begin
          nStatus := Str_ToInt(sStatus, -1);
          nRate := Str_ToInt(sRate, -1);
          nColor := Str_ToInt(sColor, -1);
          if (nStatus >= 0) and (nRate >= 0) and (nColor >= 0) then begin
            New(MonSayMsg);
            case nStatus of
              0: MonSayMsg.State := s_KillHuman;
              1: MonSayMsg.State := s_UnderFire;
              2: MonSayMsg.State := s_Die;
              3: MonSayMsg.State := s_MonGen;
            else
              MonSayMsg.State := s_UnderFire;
            end;
            case nColor of
              0: MonSayMsg.Color := c_Red;
              1: MonSayMsg.Color := c_Green;
              2: MonSayMsg.Color := c_Blue;
              3: MonSayMsg.Color := c_White;
            else
              MonSayMsg.Color := c_White;
            end;
            MonSayMsg.nRate := nRate;
            MonSayMsg.sSayMsg := sSayMsg;
            boSearch := False;
            for ii := 0 to g_MonSayMsgList.Count - 1 do begin
              if CompareText(g_MonSayMsgList.Strings[ii], sMonName) = 0 then begin
                TList(g_MonSayMsgList.Objects[ii]).Add(MonSayMsg);
                boSearch := True;
                Break;
              end;
            end;
            if not boSearch then begin
              MonSayList := TList.Create;
              MonSayList.Add(MonSayMsg);
              g_MonSayMsgList.AddObject(sMonName, TObject(MonSayList));
            end;
          end;
        end;
      end;
    end;
    LoadList.Free;
    Result := True;
  end;
end;

procedure LoadExp();
var
  i                         : Integer;
  LoadInteger               : Integer;
  LoadString                : string;
begin
  LoadInteger := Config.ReadInteger('Exp', 'KillMonExpMultiple', -1);
  if LoadInteger < 0 then
    Config.WriteInteger('Exp', 'KillMonExpMultiple', g_Config.dwKillMonExpMultiple)
  else
    g_Config.dwKillMonExpMultiple := Config.ReadInteger('Exp', 'KillMonExpMultiple', g_Config.dwKillMonExpMultiple);

  LoadInteger := Config.ReadInteger('Exp', 'HighLevelKillMonFixExp', -1);
  if LoadInteger < 0 then
    Config.WriteBool('Exp', 'HighLevelKillMonFixExp', g_Config.boHighLevelKillMonFixExp)
  else
    g_Config.boHighLevelKillMonFixExp := Config.ReadBool('Exp', 'HighLevelKillMonFixExp', g_Config.boHighLevelKillMonFixExp);

  LoadInteger := Config.ReadInteger('Exp', 'HighLevelGroupFixExp', -1);
  if LoadInteger < 0 then
    Config.WriteBool('Exp', 'HighLevelGroupFixExp', g_Config.boHighLevelGroupFixExp)
  else
    g_Config.boHighLevelGroupFixExp := Config.ReadBool('Exp', 'HighLevelGroupFixExp', g_Config.boHighLevelGroupFixExp);

  LoadInteger := Config.ReadInteger('Exp', 'HighLevelLimitExp', -1);
  if LoadInteger < 0 then
    Config.WriteBool('Exp', 'HighLevelLimitExp', g_Config.boHighLevelLimitExp)
  else
    g_Config.boHighLevelLimitExp := Config.ReadBool('Exp', 'HighLevelLimitExp', g_Config.boHighLevelLimitExp);

  LoadInteger := Config.ReadInteger('Exp', 'LimitLevel', -1);
  if LoadInteger < 0 then
    Config.WriteInteger('Exp', 'LimitLevel', g_Config.nLimitLevel)
  else
    g_Config.nLimitLevel := Config.ReadInteger('Exp', 'LimitLevel', g_Config.nLimitLevel);

  LoadInteger := Config.ReadInteger('Exp', 'KillMonExpDiv', -1);
  if LoadInteger < 0 then
    Config.WriteInteger('Exp', 'KillMonExpDiv', g_Config.nKillMonExpDiv)
  else
    g_Config.nKillMonExpDiv := Config.ReadInteger('Exp', 'KillMonExpDiv', g_Config.nKillMonExpDiv);

  for i := 1 to High(g_Config.dwNeedExps) do begin
    LoadString := Config.ReadString('Exp', 'Level' + IntToStr(i), '');
    LoadInteger := Str_ToInt(LoadString, 0);
    if LoadInteger = 0 then begin
      Config.WriteString('Exp', 'Level' + IntToStr(i), IntToStr(g_dwOldNeedExps[i]));
      g_Config.dwNeedExps[i] := g_dwOldNeedExps[i];
    end else
      g_Config.dwNeedExps[i] := LoadInteger;
  end;

{$IF OEMVER = OEM775}
  for i := 1 to High(g_LevelInfo) do begin
    LoadInteger := Level775.ReadInteger('HP', 'HP' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('HP', 'HP' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wHP := Level775.ReadInteger('HP', 'HP' + IntToStr(i), g_LevelInfo[i].wHP);

    LoadInteger := Level775.ReadInteger('MP', 'MP' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('MP', 'MP' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wMP := Level775.ReadInteger('MP', 'MP' + IntToStr(i), g_LevelInfo[i].wMP);

    LoadString := Level775.ReadString('Exp', 'Exp' + IntToStr(i), '');
    LoadInteger := Str_ToInt(LoadString, 0);
    if LoadInteger = 0 then begin
      Level775.WriteString('Exp', 'Exp' + IntToStr(i), '1000');
      g_LevelInfo[i].dwExp := g_dwOldNeedExps[i];
    end else
      g_LevelInfo[i].dwExp := LoadInteger;

    LoadInteger := Level775.ReadInteger('AC', 'AC' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('AC', 'AC' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wAC := Level775.ReadInteger('AC', 'AC' + IntToStr(i), g_LevelInfo[i].wAC);

    LoadInteger := Level775.ReadInteger('MaxAC', 'MaxAC' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('MaxAC', 'MaxAC' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wMaxAC := Level775.ReadInteger('MaxAC', 'MaxAC' + IntToStr(i), g_LevelInfo[i].wMaxAC);

    LoadInteger := Level775.ReadInteger('ACLimit', 'ACLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('ACLimit', 'ACLimit' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wACLimit := Level775.ReadInteger('ACLimit', 'ACLimit' + IntToStr(i), g_LevelInfo[i].wACLimit);

    LoadInteger := Level775.ReadInteger('MAC', 'MAC' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('MAC', 'MAC' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wMAC := Level775.ReadInteger('MAC', 'MAC' + IntToStr(i), g_LevelInfo[i].wMAC);

    LoadInteger := Level775.ReadInteger('MaxMAC', 'MaxMAC' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('MaxMAC', 'MaxMAC' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wMaxMAC := Level775.ReadInteger('MaxMAC', 'MaxMAC' + IntToStr(i), g_LevelInfo[i].wMaxMAC);

    LoadInteger := Level775.ReadInteger('MACLimit', 'MACLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('MACLimit', 'MACLimit' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wMACLimit := Level775.ReadInteger('MACLimit', 'MACLimit' + IntToStr(i), g_LevelInfo[i].wMACLimit);

    LoadInteger := Level775.ReadInteger('DC', 'DC' + IntToStr(i), -1);
    if LoadInteger < 0 then begin
      Level775.WriteInteger('DC', 'DC' + IntToStr(i), 100);
    end
    else begin
      g_LevelInfo[i].wDC := Level775.ReadInteger('DC', 'DC' + IntToStr(i),
        g_LevelInfo[i].wDC);
    end;

    LoadInteger := Level775.ReadInteger('MaxDC', 'MaxDC' + IntToStr(i), -1);
    if LoadInteger < 0 then begin
      Level775.WriteInteger('MaxDC', 'MaxDC' + IntToStr(i), 100);
    end
    else begin
      g_LevelInfo[i].wMaxDC := Level775.ReadInteger('MaxDC', 'MaxDC' +
        IntToStr(i), g_LevelInfo[i].wMaxDC);
    end;
    LoadInteger := Level775.ReadInteger('DCLimit', 'DCLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then begin
      Level775.WriteInteger('DCLimit', 'DCLimit' + IntToStr(i), 100);
    end
    else begin
      g_LevelInfo[i].wDCLimit := Level775.ReadInteger('DCLimit', 'DCLimit' +
        IntToStr(i), g_LevelInfo[i].wDCLimit);
    end;

    LoadInteger := Level775.ReadInteger('MC', 'MC' + IntToStr(i), -1);
    if LoadInteger < 0 then
      Level775.WriteInteger('MC', 'MC' + IntToStr(i), 100)
    else
      g_LevelInfo[i].wMC := Level775.ReadInteger('MC', 'MC' + IntToStr(i), g_LevelInfo[i].wMC);

    LoadInteger := Level775.ReadInteger('MaxMC', 'MaxMC' + IntToStr(i), -1);
    if LoadInteger < 0 then begin
      Level775.WriteInteger('MaxMC', 'MaxMC' + IntToStr(i), 100);
    end
    else begin
      g_LevelInfo[i].wMaxMC := Level775.ReadInteger('MaxMC', 'MaxMC' +
        IntToStr(i), g_LevelInfo[i].wMaxMC);
    end;
    LoadInteger := Level775.ReadInteger('MCLimit', 'MCLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then begin
      Level775.WriteInteger('MCLimit', 'MCLimit' + IntToStr(i), 100);
    end
    else begin
      g_LevelInfo[i].wMCLimit := Level775.ReadInteger('MCLimit', 'MCLimit' +
        IntToStr(i), g_LevelInfo[i].wMCLimit);
    end;

    LoadInteger := Level775.ReadInteger('SC', 'SC' + IntToStr(i), -1);
    if LoadInteger < 0 then begin
      Level775.WriteInteger('SC', 'SC' + IntToStr(i), 100);
    end
    else begin
      g_LevelInfo[i].wSC := Level775.ReadInteger('SC', 'SC' + IntToStr(i),
        g_LevelInfo[i].wSC);
    end;

    LoadInteger := Level775.ReadInteger('MaxSC', 'MaxSC' + IntToStr(i), -1);
    if LoadInteger < 0 then begin
      Level775.WriteInteger('MaxSC', 'MaxSC' + IntToStr(i), 100);
    end
    else begin
      g_LevelInfo[i].wMaxSC := Level775.ReadInteger('MaxSC', 'MaxSC' +
        IntToStr(i), g_LevelInfo[i].wMaxSC);
    end;
    LoadInteger := Level775.ReadInteger('SCLimit', 'SCLimit' + IntToStr(i), -1);
    if LoadInteger < 0 then begin
      Level775.WriteInteger('SCLimit', 'SCLimit' + IntToStr(i), 100);
    end
    else begin
      g_LevelInfo[i].wSCLimit := Level775.ReadInteger('SCLimit', 'SCLimit' +
        IntToStr(i), g_LevelInfo[i].wSCLimit);
    end;
  end;
{$IFEND}
end;

procedure LoadGameCommand();
var
  LoadString                : string;
  nLoadInteger              : Integer;
begin
  LoadString := CommandConf.ReadString('Command', 'Date', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Date', g_GameCommand.Data.sCmd)
  else
    g_GameCommand.Data.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'Date', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Date', g_GameCommand.Data.nPermissionMin)
  else
    g_GameCommand.Data.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'PrvMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PrvMsg', g_GameCommand.PRVMSG.sCmd)
  else
    g_GameCommand.PRVMSG.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'PrvMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'PrvMsg', g_GameCommand.PRVMSG.nPermissionMin)
  else
    g_GameCommand.PRVMSG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AllowMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowMsg', g_GameCommand.ALLOWMSG.sCmd)
  else
    g_GameCommand.ALLOWMSG.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'AllowMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AllowMsg', g_GameCommand.ALLOWMSG.nPermissionMin)
  else
    g_GameCommand.ALLOWMSG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'LetShout', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LetShout', g_GameCommand.LETSHOUT.sCmd)
  else
    g_GameCommand.LETSHOUT.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'LetTrade', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LetTrade', g_GameCommand.LETTRADE.sCmd)
  else
    g_GameCommand.LETTRADE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'LetGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LetGuild', g_GameCommand.LETGUILD.sCmd)
  else
    g_GameCommand.LETGUILD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'EndGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'EndGuild', g_GameCommand.ENDGUILD.sCmd)
  else
    g_GameCommand.ENDGUILD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'BanGuildChat', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'BanGuildChat',
      g_GameCommand.BANGUILDCHAT.sCmd)
  else
    g_GameCommand.BANGUILDCHAT.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AuthAlly', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AuthAlly', g_GameCommand.AUTHALLY.sCmd)
  else
    g_GameCommand.AUTHALLY.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Auth', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Auth', g_GameCommand.AUTH.sCmd)
  else
    g_GameCommand.AUTH.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AuthCancel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AuthCancel',
      g_GameCommand.AUTHCANCEL.sCmd)
  else
    g_GameCommand.AUTHCANCEL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'ViewDiary', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ViewDiary', g_GameCommand.DIARY.sCmd)
  else
    g_GameCommand.DIARY.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'UserMove', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'UserMove', g_GameCommand.USERMOVE.sCmd)
  else
    g_GameCommand.USERMOVE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Searching', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Searching', g_GameCommand.SEARCHING.sCmd)
  else
    g_GameCommand.SEARCHING.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AllowGroupCall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowGroupCall',
      g_GameCommand.ALLOWGROUPCALL.sCmd)
  else
    g_GameCommand.ALLOWGROUPCALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'GroupCall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GroupCall',
      g_GameCommand.GROUPRECALLL.sCmd)
  else
    g_GameCommand.GROUPRECALLL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AllowGuildReCall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowGuildReCall', g_GameCommand.ALLOWGUILDRECALL.sCmd)
  else
    g_GameCommand.ALLOWGUILDRECALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'GuildReCall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GuildReCall', g_GameCommand.GUILDRECALLL.sCmd)
  else
    g_GameCommand.GUILDRECALLL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageUnLock', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageUnLock', g_GameCommand.UNLOCKSTORAGE.sCmd)
  else
    g_GameCommand.UNLOCKSTORAGE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'PasswordUnLock', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PasswordUnLock', g_GameCommand.UnLock.sCmd)
  else
    g_GameCommand.UnLock.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageLock', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageLock', g_GameCommand.Lock.sCmd)
  else
    g_GameCommand.Lock.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageSetPassword', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageSetPassword', g_GameCommand.SETPASSWORD.sCmd)
  else
    g_GameCommand.SETPASSWORD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'PasswordLock', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PasswordLock', g_GameCommand.PASSWORDLOCK.sCmd)
  else
    g_GameCommand.PASSWORDLOCK.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageChgPassword', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageChgPassword', g_GameCommand.CHGPASSWORD.sCmd)
  else
    g_GameCommand.CHGPASSWORD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'StorageClearPassword', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageClearPassword', g_GameCommand.CLRPASSWORD.sCmd)
  else
    g_GameCommand.CLRPASSWORD.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'StorageClearPassword', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StorageClearPassword', g_GameCommand.CLRPASSWORD.nPermissionMin)
  else
    g_GameCommand.CLRPASSWORD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StorageUserClearPassword',
    '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StorageUserClearPassword',
      g_GameCommand.UNPASSWORD.sCmd)
  else
    g_GameCommand.UNPASSWORD.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'MemberFunc', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MemberFunc',
      g_GameCommand.MEMBERFUNCTION.sCmd)
  else
    g_GameCommand.MEMBERFUNCTION.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'MemberFuncEx', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MemberFuncEx',
      g_GameCommand.MEMBERFUNCTIONEX.sCmd)
  else
    g_GameCommand.MEMBERFUNCTIONEX.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Dear', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Dear', g_GameCommand.DEAR.sCmd)
  else
    g_GameCommand.DEAR.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Master', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Master', g_GameCommand.Master.sCmd)
  else
    g_GameCommand.Master.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'DearRecall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DearRecall', g_GameCommand.DEARRECALL.sCmd)
  else
    g_GameCommand.DEARRECALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'MasterRecall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MasterRecall',
      g_GameCommand.MASTERECALL.sCmd)
  else
    g_GameCommand.MASTERECALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AllowDearRecall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowDearRecall',
      g_GameCommand.ALLOWDEARRCALL.sCmd)
  else
    g_GameCommand.ALLOWDEARRCALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AllowMasterRecall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AllowMasterRecall',
      g_GameCommand.ALLOWMASTERRECALL.sCmd)
  else
    g_GameCommand.ALLOWMASTERRECALL.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'AttackMode', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AttackMode',
      g_GameCommand.ATTACKMODE.sCmd)
  else
    g_GameCommand.ATTACKMODE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'Rest', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Rest', g_GameCommand.REST.sCmd)
  else
    g_GameCommand.REST.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'TakeOnHorse', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TakeOnHorse',
      g_GameCommand.TAKEONHORSE.sCmd)
  else
    g_GameCommand.TAKEONHORSE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'TakeOffHorse', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TakeOffHorse',
      g_GameCommand.TAKEOFHORSE.sCmd)
  else
    g_GameCommand.TAKEOFHORSE.sCmd := LoadString;

  LoadString := CommandConf.ReadString('Command', 'HumanLocal', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'HumanLocal',
      g_GameCommand.HUMANLOCAL.sCmd)
  else
    g_GameCommand.HUMANLOCAL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'HumanLocal', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'HumanLocal', g_GameCommand.HUMANLOCAL.nPermissionMin)
  else
    g_GameCommand.HUMANLOCAL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Move', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Move', g_GameCommand.Move.sCmd)
  else
    g_GameCommand.Move.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MoveMin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MoveMin',
      g_GameCommand.Move.nPermissionMin)
  else
    g_GameCommand.Move.nPermissionMin := nLoadInteger;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MoveMax', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MoveMax',
      g_GameCommand.Move.nPermissionMax)
  else
    g_GameCommand.Move.nPermissionMax := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'PositionMove', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PositionMove', g_GameCommand.POSITIONMOVE.sCmd)
  else
    g_GameCommand.POSITIONMOVE.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'PositionMoveMin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'PositionMoveMin', g_GameCommand.POSITIONMOVE.nPermissionMin)
  else
    g_GameCommand.POSITIONMOVE.nPermissionMin := nLoadInteger;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'PositionMoveMax', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'PositionMoveMax', g_GameCommand.POSITIONMOVE.nPermissionMax)
  else
    g_GameCommand.POSITIONMOVE.nPermissionMax := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SignMove', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SignMove', g_GameCommand.SignMove.sCmd)
  else
    g_GameCommand.SignMove.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'SignMoveMin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SignMoveMin', g_GameCommand.POSITIONMOVE.nPermissionMin)
  else
    g_GameCommand.POSITIONMOVE.nPermissionMin := nLoadInteger;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'SignMoveMax', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SignMoveMax', g_GameCommand.POSITIONMOVE.nPermissionMax)
  else
    g_GameCommand.POSITIONMOVE.nPermissionMax := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Info', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Info', g_GameCommand.INFO.sCmd)
  else
    g_GameCommand.INFO.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Info', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Info', g_GameCommand.INFO.nPermissionMin)
  else
    g_GameCommand.INFO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MobLevel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MobLevel', g_GameCommand.MOBLEVEL.sCmd)
  else
    g_GameCommand.MOBLEVEL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MobLevel', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MobLevel', g_GameCommand.MOBLEVEL.nPermissionMin)
  else
    g_GameCommand.MOBLEVEL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MobCount', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MobCount', g_GameCommand.MOBCOUNT.sCmd)
  else
    g_GameCommand.MOBCOUNT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MobCount', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MobCount',
      g_GameCommand.MOBCOUNT.nPermissionMin)
  else
    g_GameCommand.MOBCOUNT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'HumanCount', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'HumanCount',
      g_GameCommand.HUMANCOUNT.sCmd)
  else
    g_GameCommand.HUMANCOUNT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'HumanCount', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'HumanCount',
      g_GameCommand.HUMANCOUNT.nPermissionMin)
  else
    g_GameCommand.HUMANCOUNT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Map', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Map', g_GameCommand.Map.sCmd)
  else
    g_GameCommand.Map.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Map', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Map',
      g_GameCommand.Map.nPermissionMin)
  else
    g_GameCommand.Map.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Kick', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Kick', g_GameCommand.KICK.sCmd)
  else
    g_GameCommand.KICK.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Kick', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Kick', g_GameCommand.KICK.nPermissionMin)
  else
    g_GameCommand.KICK.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Ting', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Ting', g_GameCommand.TING.sCmd)
  else
    g_GameCommand.TING.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Ting', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Ting',
      g_GameCommand.TING.nPermissionMin)
  else
    g_GameCommand.TING.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SuperTing', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SuperTing', g_GameCommand.SUPERTING.sCmd)
  else
    g_GameCommand.SUPERTING.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SuperTing', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SuperTing',
      g_GameCommand.SUPERTING.nPermissionMin)
  else
    g_GameCommand.SUPERTING.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MapMove', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MapMove', g_GameCommand.MAPMOVE.sCmd)
  else
    g_GameCommand.MAPMOVE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MapMove', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MapMove',
      g_GameCommand.MAPMOVE.nPermissionMin)
  else
    g_GameCommand.MAPMOVE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Shutup', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Shutup', g_GameCommand.SHUTUP.sCmd)
  else
    g_GameCommand.SHUTUP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Shutup', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Shutup',
      g_GameCommand.SHUTUP.nPermissionMin)
  else
    g_GameCommand.SHUTUP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReleaseShutup', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReleaseShutup',
      g_GameCommand.RELEASESHUTUP.sCmd)
  else
    g_GameCommand.RELEASESHUTUP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReleaseShutup', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReleaseShutup',
      g_GameCommand.RELEASESHUTUP.nPermissionMin)
  else
    g_GameCommand.RELEASESHUTUP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShutupList', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShutupList',
      g_GameCommand.SHUTUPLIST.sCmd)
  else
    g_GameCommand.SHUTUPLIST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShutupList', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShutupList',
      g_GameCommand.SHUTUPLIST.nPermissionMin)
  else
    g_GameCommand.SHUTUPLIST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'GameMaster', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GameMaster',
      g_GameCommand.GAMEMASTER.sCmd)
  else
    g_GameCommand.GAMEMASTER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'GameMaster', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'GameMaster',
      g_GameCommand.GAMEMASTER.nPermissionMin)
  else
    g_GameCommand.GAMEMASTER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ObServer', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ObServer', g_GameCommand.OBSERVER.sCmd)
  else
    g_GameCommand.OBSERVER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ObServer', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ObServer',
      g_GameCommand.OBSERVER.nPermissionMin)
  else
    g_GameCommand.OBSERVER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SuperMan', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SuperMan', g_GameCommand.SUEPRMAN.sCmd)
  else
    g_GameCommand.SUEPRMAN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SuperMan', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SuperMan',
      g_GameCommand.SUEPRMAN.nPermissionMin)
  else
    g_GameCommand.SUEPRMAN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Level', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Level', g_GameCommand.Level.sCmd)
  else
    g_GameCommand.Level.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Level', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Level',
      g_GameCommand.Level.nPermissionMin)
  else
    g_GameCommand.Level.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SabukWallGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SabukWallGold',
      g_GameCommand.SABUKWALLGOLD.sCmd)
  else
    g_GameCommand.SABUKWALLGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SabukWallGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SabukWallGold',
      g_GameCommand.SABUKWALLGOLD.nPermissionMin)
  else
    g_GameCommand.SABUKWALLGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Recall', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Recall', g_GameCommand.RECALL.sCmd)
  else
    g_GameCommand.RECALL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Recall', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Recall',
      g_GameCommand.RECALL.nPermissionMin)
  else
    g_GameCommand.RECALL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReGoto', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReGoto', g_GameCommand.REGOTO.sCmd)
  else
    g_GameCommand.REGOTO.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReGoto', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReGoto',
      g_GameCommand.REGOTO.nPermissionMin)
  else
    g_GameCommand.REGOTO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Flag', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Flag', g_GameCommand.SHOWFLAG.sCmd)
  else
    g_GameCommand.SHOWFLAG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Flag', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Flag',
      g_GameCommand.SHOWFLAG.nPermissionMin)
  else
    g_GameCommand.SHOWFLAG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowOpen', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowOpen', g_GameCommand.SHOWOPEN.sCmd)
  else
    g_GameCommand.SHOWOPEN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowOpen', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowOpen',
      g_GameCommand.SHOWOPEN.nPermissionMin)
  else
    g_GameCommand.SHOWOPEN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowUnit', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowUnit', g_GameCommand.SHOWUNIT.sCmd)
  else
    g_GameCommand.SHOWUNIT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowUnit', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowUnit',
      g_GameCommand.SHOWUNIT.nPermissionMin)
  else
    g_GameCommand.SHOWUNIT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Attack', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Attack', g_GameCommand.Attack.sCmd)
  else
    g_GameCommand.Attack.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Attack', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Attack',
      g_GameCommand.Attack.nPermissionMin)
  else
    g_GameCommand.Attack.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Mob', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Mob', g_GameCommand.MOB.sCmd)
  else
    g_GameCommand.MOB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Mob', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Mob',
      g_GameCommand.MOB.nPermissionMin)
  else
    g_GameCommand.MOB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MobNpc', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MobNpc', g_GameCommand.MOBNPC.sCmd)
  else
    g_GameCommand.MOBNPC.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MobNpc', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MobNpc',
      g_GameCommand.MOBNPC.nPermissionMin)
  else
    g_GameCommand.MOBNPC.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelNpc', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelNpc', g_GameCommand.DELNPC.sCmd)
  else
    g_GameCommand.DELNPC.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelNpc', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelNpc',
      g_GameCommand.DELNPC.nPermissionMin)
  else
    g_GameCommand.DELNPC.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'NpcScript', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'NpcScript', g_GameCommand.NPCSCRIPT.sCmd)
  else
    g_GameCommand.NPCSCRIPT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'NpcScript', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'NpcScript',
      g_GameCommand.NPCSCRIPT.nPermissionMin)
  else
    g_GameCommand.NPCSCRIPT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'RecallMob', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'RecallMob', g_GameCommand.RECALLMOB.sCmd)
  else
    g_GameCommand.RECALLMOB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'RecallMob', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'RecallMob',
      g_GameCommand.RECALLMOB.nPermissionMin)
  else
    g_GameCommand.RECALLMOB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'LuckPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LuckPoint',
      g_GameCommand.LUCKYPOINT.sCmd)
  else
    g_GameCommand.LUCKYPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'LuckPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'LuckPoint',
      g_GameCommand.LUCKYPOINT.nPermissionMin)
  else
    g_GameCommand.LUCKYPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'LotteryTicket', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LotteryTicket',
      g_GameCommand.LOTTERYTICKET.sCmd)
  else
    g_GameCommand.LOTTERYTICKET.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'LotteryTicket', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'LotteryTicket',
      g_GameCommand.LOTTERYTICKET.nPermissionMin)
  else
    g_GameCommand.LOTTERYTICKET.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadGuild',
      g_GameCommand.RELOADGUILD.sCmd)
  else
    g_GameCommand.RELOADGUILD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadGuild', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadGuild',
      g_GameCommand.RELOADGUILD.nPermissionMin)
  else
    g_GameCommand.RELOADGUILD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadLineNotice', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadLineNotice',
      g_GameCommand.RELOADLINENOTICE.sCmd)
  else
    g_GameCommand.RELOADLINENOTICE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadLineNotice', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadLineNotice',
      g_GameCommand.RELOADLINENOTICE.nPermissionMin)
  else
    g_GameCommand.RELOADLINENOTICE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadAbuse', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadAbuse',
      g_GameCommand.RELOADABUSE.sCmd)
  else
    g_GameCommand.RELOADABUSE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadAbuse', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadAbuse',
      g_GameCommand.RELOADABUSE.nPermissionMin)
  else
    g_GameCommand.RELOADABUSE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'BackStep', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'BackStep', g_GameCommand.BACKSTEP.sCmd)
  else
    g_GameCommand.BACKSTEP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'BackStep', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'BackStep',
      g_GameCommand.BACKSTEP.nPermissionMin)
  else
    g_GameCommand.BACKSTEP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Ball', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Ball', g_GameCommand.BALL.sCmd)
  else
    g_GameCommand.BALL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Ball', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Ball',
      g_GameCommand.BALL.nPermissionMin)
  else
    g_GameCommand.BALL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'FreePenalty', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'FreePenalty',
      g_GameCommand.FREEPENALTY.sCmd)
  else
    g_GameCommand.FREEPENALTY.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'FreePenalty', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'FreePenalty',
      g_GameCommand.FREEPENALTY.nPermissionMin)
  else
    g_GameCommand.FREEPENALTY.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'PkPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'PkPoint', g_GameCommand.PKPOINT.sCmd)
  else
    g_GameCommand.PKPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'PkPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'PkPoint',
      g_GameCommand.PKPOINT.nPermissionMin)
  else
    g_GameCommand.PKPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'IncPkPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'IncPkPoint',
      g_GameCommand.IncPkPoint.sCmd)
  else
    g_GameCommand.IncPkPoint.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'IncPkPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'IncPkPoint',
      g_GameCommand.IncPkPoint.nPermissionMin)
  else
    g_GameCommand.IncPkPoint.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeLuck', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeLuck',
      g_GameCommand.CHANGELUCK.sCmd)
  else
    g_GameCommand.CHANGELUCK.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeLuck', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeLuck',
      g_GameCommand.CHANGELUCK.nPermissionMin)
  else
    g_GameCommand.CHANGELUCK.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Hunger', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Hunger', g_GameCommand.HUNGER.sCmd)
  else
    g_GameCommand.HUNGER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Hunger', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Hunger',
      g_GameCommand.HUNGER.nPermissionMin)
  else
    g_GameCommand.HUNGER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Hair', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Hair', g_GameCommand.HAIR.sCmd)
  else
    g_GameCommand.HAIR.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Hair', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Hair',
      g_GameCommand.HAIR.nPermissionMin)
  else
    g_GameCommand.HAIR.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Training', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Training', g_GameCommand.TRAINING.sCmd)
  else
    g_GameCommand.TRAINING.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Training', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Training',
      g_GameCommand.TRAINING.nPermissionMin)
  else
    g_GameCommand.TRAINING.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DeleteSkill', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DeleteSkill',
      g_GameCommand.DELETESKILL.sCmd)
  else
    g_GameCommand.DELETESKILL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DeleteSkill', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DeleteSkill',
      g_GameCommand.DELETESKILL.nPermissionMin)
  else
    g_GameCommand.DELETESKILL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeJob', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeJob', g_GameCommand.CHANGEJOB.sCmd)
  else
    g_GameCommand.CHANGEJOB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeJob', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeJob',
      g_GameCommand.CHANGEJOB.nPermissionMin)
  else
    g_GameCommand.CHANGEJOB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeGender', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeGender',
      g_GameCommand.CHANGEGENDER.sCmd)
  else
    g_GameCommand.CHANGEGENDER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeGender', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeGender',
      g_GameCommand.CHANGEGENDER.nPermissionMin)
  else
    g_GameCommand.CHANGEGENDER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'NameColor', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'NameColor', g_GameCommand.NameColor.sCmd)
  else
    g_GameCommand.NameColor.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'NameColor', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'NameColor',
      g_GameCommand.NameColor.nPermissionMin)
  else
    g_GameCommand.NameColor.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Mission', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Mission', g_GameCommand.Mission.sCmd)
  else
    g_GameCommand.Mission.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Mission', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Mission',
      g_GameCommand.Mission.nPermissionMin)
  else
    g_GameCommand.Mission.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MobPlace', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MobPlace', g_GameCommand.MobPlace.sCmd)
  else
    g_GameCommand.MobPlace.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MobPlace', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MobPlace',
      g_GameCommand.MobPlace.nPermissionMin)
  else
    g_GameCommand.MobPlace.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Transparecy', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Transparecy',
      g_GameCommand.TRANSPARECY.sCmd)
  else
    g_GameCommand.TRANSPARECY.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Transparecy', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Transparecy',
      g_GameCommand.TRANSPARECY.nPermissionMin)
  else
    g_GameCommand.TRANSPARECY.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DeleteItem', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DeleteItem',
      g_GameCommand.DELETEITEM.sCmd)
  else
    g_GameCommand.DELETEITEM.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DeleteItem', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DeleteItem',
      g_GameCommand.DELETEITEM.nPermissionMin)
  else
    g_GameCommand.DELETEITEM.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Level0', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Level0', g_GameCommand.LEVEL0.sCmd)
  else
    g_GameCommand.LEVEL0.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Level0', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Level0',
      g_GameCommand.LEVEL0.nPermissionMin)
  else
    g_GameCommand.LEVEL0.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ClearMission', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ClearMission',
      g_GameCommand.CLEARMISSION.sCmd)
  else
    g_GameCommand.CLEARMISSION.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ClearMission', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ClearMission',
      g_GameCommand.CLEARMISSION.nPermissionMin)
  else
    g_GameCommand.CLEARMISSION.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetFlag', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetFlag', g_GameCommand.SETFLAG.sCmd)
  else
    g_GameCommand.SETFLAG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetFlag', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetFlag',
      g_GameCommand.SETFLAG.nPermissionMin)
  else
    g_GameCommand.SETFLAG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetOpen', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetOpen', g_GameCommand.SETOPEN.sCmd)
  else
    g_GameCommand.SETOPEN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetOpen', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetOpen',
      g_GameCommand.SETOPEN.nPermissionMin)
  else
    g_GameCommand.SETOPEN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetUnit', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetUnit', g_GameCommand.SETUNIT.sCmd)
  else
    g_GameCommand.SETUNIT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetUnit', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetUnit',
      g_GameCommand.SETUNIT.nPermissionMin)
  else
    g_GameCommand.SETUNIT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReConnection', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReConnection',
      g_GameCommand.RECONNECTION.sCmd)
  else
    g_GameCommand.RECONNECTION.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReConnection', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReConnection',
      g_GameCommand.RECONNECTION.nPermissionMin)
  else
    g_GameCommand.RECONNECTION.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DisableFilter', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DisableFilter',
      g_GameCommand.DISABLEFILTER.sCmd)
  else
    g_GameCommand.DISABLEFILTER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DisableFilter', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DisableFilter',
      g_GameCommand.DISABLEFILTER.nPermissionMin)
  else
    g_GameCommand.DISABLEFILTER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeUserFull', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeUserFull',
      g_GameCommand.CHGUSERFULL.sCmd)
  else
    g_GameCommand.CHGUSERFULL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeUserFull', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeUserFull',
      g_GameCommand.CHGUSERFULL.nPermissionMin)
  else
    g_GameCommand.CHGUSERFULL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeZenFastStep', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeZenFastStep',
      g_GameCommand.CHGZENFASTSTEP.sCmd)
  else
    g_GameCommand.CHGZENFASTSTEP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeZenFastStep',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeZenFastStep',
      g_GameCommand.CHGZENFASTSTEP.nPermissionMin)
  else
    g_GameCommand.CHGZENFASTSTEP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ContestPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ContestPoint',
      g_GameCommand.CONTESTPOINT.sCmd)
  else
    g_GameCommand.CONTESTPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ContestPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ContestPoint',
      g_GameCommand.CONTESTPOINT.nPermissionMin)
  else
    g_GameCommand.CONTESTPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StartContest', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StartContest',
      g_GameCommand.STARTCONTEST.sCmd)
  else
    g_GameCommand.STARTCONTEST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'StartContest', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StartContest',
      g_GameCommand.STARTCONTEST.nPermissionMin)
  else
    g_GameCommand.STARTCONTEST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'EndContest', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'EndContest',
      g_GameCommand.ENDCONTEST.sCmd)
  else
    g_GameCommand.ENDCONTEST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'EndContest', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'EndContest',
      g_GameCommand.ENDCONTEST.nPermissionMin)
  else
    g_GameCommand.ENDCONTEST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Announcement', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Announcement',
      g_GameCommand.ANNOUNCEMENT.sCmd)
  else
    g_GameCommand.ANNOUNCEMENT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Announcement', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Announcement',
      g_GameCommand.ANNOUNCEMENT.nPermissionMin)
  else
    g_GameCommand.ANNOUNCEMENT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'OXQuizRoom', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'OXQuizRoom',
      g_GameCommand.OXQUIZROOM.sCmd)
  else
    g_GameCommand.OXQUIZROOM.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'OXQuizRoom', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'OXQuizRoom',
      g_GameCommand.OXQUIZROOM.nPermissionMin)
  else
    g_GameCommand.OXQUIZROOM.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Gsa', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Gsa', g_GameCommand.GSA.sCmd)
  else
    g_GameCommand.GSA.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Gsa', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Gsa',
      g_GameCommand.GSA.nPermissionMin)
  else
    g_GameCommand.GSA.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeItemName', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeItemName',
      g_GameCommand.CHANGEITEMNAME.sCmd)
  else
    g_GameCommand.CHANGEITEMNAME.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeItemName', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeItemName',
      g_GameCommand.CHANGEITEMNAME.nPermissionMin)
  else
    g_GameCommand.CHANGEITEMNAME.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DisableSendMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DisableSendMsg',
      g_GameCommand.DISABLESENDMSG.sCmd)
  else
    g_GameCommand.DISABLESENDMSG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DisableSendMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DisableSendMsg',
      g_GameCommand.DISABLESENDMSG.nPermissionMin)
  else
    g_GameCommand.DISABLESENDMSG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'EnableSendMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'EnableSendMsg',
      g_GameCommand.ENABLESENDMSG.sCmd)
  else
    g_GameCommand.ENABLESENDMSG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'EnableSendMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'EnableSendMsg',
      g_GameCommand.ENABLESENDMSG.nPermissionMin)
  else
    g_GameCommand.ENABLESENDMSG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DisableSendMsgList', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DisableSendMsgList',
      g_GameCommand.DISABLESENDMSGLIST.sCmd)
  else
    g_GameCommand.DISABLESENDMSGLIST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DisableSendMsgList',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DisableSendMsgList',
      g_GameCommand.DISABLESENDMSGLIST.nPermissionMin)
  else
    g_GameCommand.DISABLESENDMSGLIST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Kill', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Kill', g_GameCommand.KILL.sCmd)
  else
    g_GameCommand.KILL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Kill', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Kill',
      g_GameCommand.KILL.nPermissionMin)
  else
    g_GameCommand.KILL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Make', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Make', g_GameCommand.MAKE.sCmd)
  else
    g_GameCommand.MAKE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MakeMin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MakeMin',
      g_GameCommand.MAKE.nPermissionMin)
  else
    g_GameCommand.MAKE.nPermissionMin := nLoadInteger;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'MakeMax', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MakeMax',
      g_GameCommand.MAKE.nPermissionMax)
  else
    g_GameCommand.MAKE.nPermissionMax := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SuperMake', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SuperMake', g_GameCommand.SMAKE.sCmd)
  else
    g_GameCommand.SMAKE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SuperMake', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SuperMake',
      g_GameCommand.SMAKE.nPermissionMin)
  else
    g_GameCommand.SMAKE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'BonusPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'BonusPoint',
      g_GameCommand.BonusPoint.sCmd)
  else
    g_GameCommand.BonusPoint.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'BonusPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'BonusPoint',
      g_GameCommand.BonusPoint.nPermissionMin)
  else
    g_GameCommand.BonusPoint.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelBonuPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelBonuPoint',
      g_GameCommand.DELBONUSPOINT.sCmd)
  else
    g_GameCommand.DELBONUSPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelBonuPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelBonuPoint',
      g_GameCommand.DELBONUSPOINT.nPermissionMin)
  else
    g_GameCommand.DELBONUSPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'RestBonuPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'RestBonuPoint',
      g_GameCommand.RESTBONUSPOINT.sCmd)
  else
    g_GameCommand.RESTBONUSPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'RestBonuPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'RestBonuPoint',
      g_GameCommand.RESTBONUSPOINT.nPermissionMin)
  else
    g_GameCommand.RESTBONUSPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'FireBurn', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'FireBurn', g_GameCommand.FIREBURN.sCmd)
  else
    g_GameCommand.FIREBURN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'FireBurn', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'FireBurn',
      g_GameCommand.FIREBURN.nPermissionMin)
  else
    g_GameCommand.FIREBURN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'TestStatus', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TestStatus',
      g_GameCommand.TESTSTATUS.sCmd)
  else
    g_GameCommand.TESTSTATUS.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'TestStatus', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'TestStatus',
      g_GameCommand.TESTSTATUS.nPermissionMin)
  else
    g_GameCommand.TESTSTATUS.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelGold', g_GameCommand.DELGOLD.sCmd)
  else
    g_GameCommand.DELGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelGold',
      g_GameCommand.DELGOLD.nPermissionMin)
  else
    g_GameCommand.DELGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddGold', g_GameCommand.ADDGOLD.sCmd)
  else
    g_GameCommand.ADDGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddGold',
      g_GameCommand.ADDGOLD.nPermissionMin)
  else
    g_GameCommand.ADDGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelGameGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelGameGold',
      g_GameCommand.DELGAMEGOLD.sCmd)
  else
    g_GameCommand.DELGAMEGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelGameGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelGameGold',
      g_GameCommand.DELGAMEGOLD.nPermissionMin)
  else
    g_GameCommand.DELGAMEGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddGamePoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddGamePoint',
      g_GameCommand.ADDGAMEGOLD.sCmd)
  else
    g_GameCommand.ADDGAMEGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddGameGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddGameGold',
      g_GameCommand.ADDGAMEGOLD.nPermissionMin)
  else
    g_GameCommand.ADDGAMEGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'GameGold', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GameGold', g_GameCommand.GAMEGOLD.sCmd)
  else
    g_GameCommand.GAMEGOLD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'GameGold', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'GameGold',
      g_GameCommand.GAMEGOLD.nPermissionMin)
  else
    g_GameCommand.GAMEGOLD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'GamePoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GamePoint', g_GameCommand.GAMEPOINT.sCmd)
  else
    g_GameCommand.GAMEPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'GamePoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'GamePoint',
      g_GameCommand.GAMEPOINT.nPermissionMin)
  else
    g_GameCommand.GAMEPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'CreditPoint', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'CreditPoint',
      g_GameCommand.CREDITPOINT.sCmd)
  else
    g_GameCommand.CREDITPOINT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'CreditPoint', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'CreditPoint',
      g_GameCommand.CREDITPOINT.nPermissionMin)
  else
    g_GameCommand.CREDITPOINT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'TestGoldChange', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TestGoldChange',
      g_GameCommand.TESTGOLDCHANGE.sCmd)
  else
    g_GameCommand.TESTGOLDCHANGE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'TestGoldChange', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'TestGoldChange',
      g_GameCommand.TESTGOLDCHANGE.nPermissionMin)
  else
    g_GameCommand.TESTGOLDCHANGE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'RefineWeapon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'RefineWeapon',
      g_GameCommand.REFINEWEAPON.sCmd)
  else
    g_GameCommand.REFINEWEAPON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'RefineWeapon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'RefineWeapon',
      g_GameCommand.REFINEWEAPON.nPermissionMin)
  else
    g_GameCommand.REFINEWEAPON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadAdmin', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadAdmin',
      g_GameCommand.RELOADADMIN.sCmd)
  else
    g_GameCommand.RELOADADMIN.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadAdmin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadAdmin',
      g_GameCommand.RELOADADMIN.nPermissionMin)
  else
    g_GameCommand.RELOADADMIN.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadNpc', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadNpc', g_GameCommand.ReLoadNpc.sCmd)
  else
    g_GameCommand.ReLoadNpc.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadNpc', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadNpc', g_GameCommand.ReLoadNpc.nPermissionMin)
  else
    g_GameCommand.ReLoadNpc.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadManage', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadManage', g_GameCommand.RELOADMANAGE.sCmd)
  else
    g_GameCommand.RELOADMANAGE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadManage', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadManage', g_GameCommand.RELOADMANAGE.nPermissionMin)
  else
    g_GameCommand.RELOADMANAGE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadRobotManage', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadRobotManage', g_GameCommand.RELOADROBOTMANAGE.sCmd)
  else
    g_GameCommand.RELOADROBOTMANAGE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadRobotManage', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadRobotManage', g_GameCommand.RELOADROBOTMANAGE.nPermissionMin)
  else
    g_GameCommand.RELOADROBOTMANAGE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadRobot', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadRobot',
      g_GameCommand.RELOADROBOT.sCmd)
  else
    g_GameCommand.RELOADROBOT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadRobot', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadRobot',
      g_GameCommand.RELOADROBOT.nPermissionMin)
  else
    g_GameCommand.RELOADROBOT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadMonitems', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadMonitems',
      g_GameCommand.RELOADMONITEMS.sCmd)
  else
    g_GameCommand.RELOADMONITEMS.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadMonitems', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadMonitems',
      g_GameCommand.RELOADMONITEMS.nPermissionMin)
  else
    g_GameCommand.RELOADMONITEMS.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadDiary', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadDiary',
      g_GameCommand.RELOADDIARY.sCmd)
  else
    g_GameCommand.RELOADDIARY.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadDiary', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadDiary',
      g_GameCommand.RELOADDIARY.nPermissionMin)
  else
    g_GameCommand.RELOADDIARY.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadItemDB', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadItemDB',
      g_GameCommand.RELOADITEMDB.sCmd)
  else
    g_GameCommand.RELOADITEMDB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadItemDB', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadItemDB',
      g_GameCommand.RELOADITEMDB.nPermissionMin)
  else
    g_GameCommand.RELOADITEMDB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadMagicDB', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadMagicDB',
      g_GameCommand.RELOADMAGICDB.sCmd)
  else
    g_GameCommand.RELOADMAGICDB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadMagicDB', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadMagicDB',
      g_GameCommand.RELOADMAGICDB.nPermissionMin)
  else
    g_GameCommand.RELOADMAGICDB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadMonsterDB', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadMonsterDB',
      g_GameCommand.RELOADMONSTERDB.sCmd)
  else
    g_GameCommand.RELOADMONSTERDB.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadMonsterDB', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadMonsterDB',
      g_GameCommand.RELOADMONSTERDB.nPermissionMin)
  else
    g_GameCommand.RELOADMONSTERDB.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReAlive', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReAlive', g_GameCommand.ReAlive.sCmd)
  else
    g_GameCommand.ReAlive.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReAlive', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReAlive',
      g_GameCommand.ReAlive.nPermissionMin)
  else
    g_GameCommand.ReAlive.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AdjuestTLevel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AdjuestTLevel',
      g_GameCommand.ADJUESTLEVEL.sCmd)
  else
    g_GameCommand.ADJUESTLEVEL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AdjuestTLevel', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AdjuestTLevel',
      g_GameCommand.ADJUESTLEVEL.nPermissionMin)
  else
    g_GameCommand.ADJUESTLEVEL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AdjuestExp', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AdjuestExp',
      g_GameCommand.ADJUESTEXP.sCmd)
  else
    g_GameCommand.ADJUESTEXP.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AdjuestExp', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AdjuestExp',
      g_GameCommand.ADJUESTEXP.nPermissionMin)
  else
    g_GameCommand.ADJUESTEXP.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddGuild', g_GameCommand.AddGuild.sCmd)
  else
    g_GameCommand.AddGuild.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddGuild', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddGuild',
      g_GameCommand.AddGuild.nPermissionMin)
  else
    g_GameCommand.AddGuild.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelGuild', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelGuild', g_GameCommand.DelGuild.sCmd)
  else
    g_GameCommand.DelGuild.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelGuild', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelGuild',
      g_GameCommand.DelGuild.nPermissionMin)
  else
    g_GameCommand.DelGuild.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeSabukLord', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeSabukLord',
      g_GameCommand.CHANGESABUKLORD.sCmd)
  else
    g_GameCommand.CHANGESABUKLORD.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeSabukLord', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeSabukLord',
      g_GameCommand.CHANGESABUKLORD.nPermissionMin)
  else
    g_GameCommand.CHANGESABUKLORD.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ForcedWallConQuestWar', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ForcedWallConQuestWar',
      g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd)
  else
    g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ForcedWallConQuestWar',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ForcedWallConQuestWar',
      g_GameCommand.FORCEDWALLCONQUESTWAR.nPermissionMin)
  else
    g_GameCommand.FORCEDWALLCONQUESTWAR.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddToItemEvent', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddToItemEvent',
      g_GameCommand.ADDTOITEMEVENT.sCmd)
  else
    g_GameCommand.ADDTOITEMEVENT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AddToItemEvent', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddToItemEvent',
      g_GameCommand.ADDTOITEMEVENT.nPermissionMin)
  else
    g_GameCommand.ADDTOITEMEVENT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AddToItemEventAspieces', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AddToItemEventAspieces',
      g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd)
  else
    g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission',
    'AddToItemEventAspieces',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AddToItemEventAspieces',
      g_GameCommand.ADDTOITEMEVENTASPIECES.nPermissionMin)
  else
    g_GameCommand.ADDTOITEMEVENTASPIECES.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ItemEventList', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ItemEventList',
      g_GameCommand.ItemEventList.sCmd)
  else
    g_GameCommand.ItemEventList.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ItemEventList', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ItemEventList',
      g_GameCommand.ItemEventList.nPermissionMin)
  else
    g_GameCommand.ItemEventList.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StartIngGiftNO', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StartIngGiftNO',
      g_GameCommand.STARTINGGIFTNO.sCmd)
  else
    g_GameCommand.STARTINGGIFTNO.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'StartIngGiftNO', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StartIngGiftNO',
      g_GameCommand.STARTINGGIFTNO.nPermissionMin)
  else
    g_GameCommand.STARTINGGIFTNO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DeleteAllItemEvent', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DeleteAllItemEvent',
      g_GameCommand.DELETEALLITEMEVENT.sCmd)
  else
    g_GameCommand.DELETEALLITEMEVENT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DeleteAllItemEvent',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DeleteAllItemEvent',
      g_GameCommand.DELETEALLITEMEVENT.nPermissionMin)
  else
    g_GameCommand.DELETEALLITEMEVENT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StartItemEvent', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StartItemEvent',
      g_GameCommand.STARTITEMEVENT.sCmd)
  else
    g_GameCommand.STARTITEMEVENT.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'StartItemEvent', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StartItemEvent',
      g_GameCommand.STARTITEMEVENT.nPermissionMin)
  else
    g_GameCommand.STARTITEMEVENT.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ItemEventTerm', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ItemEventTerm',
      g_GameCommand.ITEMEVENTTERM.sCmd)
  else
    g_GameCommand.ITEMEVENTTERM.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ItemEventTerm', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ItemEventTerm',
      g_GameCommand.ITEMEVENTTERM.nPermissionMin)
  else
    g_GameCommand.ITEMEVENTTERM.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'AdjuestTestLevel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'AdjuestTestLevel',
      g_GameCommand.ADJUESTTESTLEVEL.sCmd)
  else
    g_GameCommand.ADJUESTTESTLEVEL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'AdjuestTestLevel', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'AdjuestTestLevel',
      g_GameCommand.ADJUESTTESTLEVEL.nPermissionMin)
  else
    g_GameCommand.ADJUESTTESTLEVEL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'OpTraining', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'OpTraining',
      g_GameCommand.TRAININGSKILL.sCmd)
  else
    g_GameCommand.TRAININGSKILL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'OpTraining', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'OpTraining',
      g_GameCommand.TRAININGSKILL.nPermissionMin)
  else
    g_GameCommand.TRAININGSKILL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'OpDeleteSkill', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'OpDeleteSkill',
      g_GameCommand.OPDELETESKILL.sCmd)
  else
    g_GameCommand.OPDELETESKILL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'OpDeleteSkill', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'OpDeleteSkill',
      g_GameCommand.OPDELETESKILL.nPermissionMin)
  else
    g_GameCommand.OPDELETESKILL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeWeaponDura', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeWeaponDura',
      g_GameCommand.CHANGEWEAPONDURA.sCmd)
  else
    g_GameCommand.CHANGEWEAPONDURA.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeWeaponDura', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeWeaponDura',
      g_GameCommand.CHANGEWEAPONDURA.nPermissionMin)
  else
    g_GameCommand.CHANGEWEAPONDURA.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReloadGuildAll', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReloadGuildAll',
      g_GameCommand.RELOADGUILDALL.sCmd)
  else
    g_GameCommand.RELOADGUILDALL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReloadGuildAll', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReloadGuildAll',
      g_GameCommand.RELOADGUILDALL.nPermissionMin)
  else
    g_GameCommand.RELOADGUILDALL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Who', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Who', g_GameCommand.WHO.sCmd)
  else
    g_GameCommand.WHO.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'Who', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Who',
      g_GameCommand.WHO.nPermissionMin)
  else
    g_GameCommand.WHO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'Total', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'Total', g_GameCommand.TOTAL.sCmd)
  else
    g_GameCommand.TOTAL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'Total', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'Total',
      g_GameCommand.TOTAL.nPermissionMin)
  else
    g_GameCommand.TOTAL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'TestGa', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'TestGa', g_GameCommand.TESTGA.sCmd)
  else
    g_GameCommand.TESTGA.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'TestGa', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'TestGa',
      g_GameCommand.TESTGA.nPermissionMin)
  else
    g_GameCommand.TESTGA.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'MapInfo', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'MapInfo', g_GameCommand.MAPINFO.sCmd)
  else
    g_GameCommand.MAPINFO.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'MapInfo', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'MapInfo',
      g_GameCommand.MAPINFO.nPermissionMin)
  else
    g_GameCommand.MAPINFO.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SbkDoor', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SbkDoor', g_GameCommand.SBKDOOR.sCmd)
  else
    g_GameCommand.SBKDOOR.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SbkDoor', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SbkDoor',
      g_GameCommand.SBKDOOR.nPermissionMin)
  else
    g_GameCommand.SBKDOOR.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeDearName', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeDearName',
      g_GameCommand.CHANGEDEARNAME.sCmd)
  else
    g_GameCommand.CHANGEDEARNAME.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeDearName', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeDearName',
      g_GameCommand.CHANGEDEARNAME.nPermissionMin)
  else
    g_GameCommand.CHANGEDEARNAME.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ChangeMasterName', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ChangeMasterrName',
      g_GameCommand.CHANGEMASTERNAME.sCmd)
  else
    g_GameCommand.CHANGEMASTERNAME.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ChangeMasterName', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ChangeMasterName',
      g_GameCommand.CHANGEMASTERNAME.nPermissionMin)
  else
    g_GameCommand.CHANGEMASTERNAME.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'StartQuest', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'StartQuest',
      g_GameCommand.STARTQUEST.sCmd)
  else
    g_GameCommand.STARTQUEST.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'StartQuest', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'StartQuest',
      g_GameCommand.STARTQUEST.nPermissionMin)
  else
    g_GameCommand.STARTQUEST.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetPermission', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetPermission',
      g_GameCommand.SETPERMISSION.sCmd)
  else
    g_GameCommand.SETPERMISSION.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetPermission', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetPermission',
      g_GameCommand.SETPERMISSION.nPermissionMin)
  else
    g_GameCommand.SETPERMISSION.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ClearMon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ClearMon', g_GameCommand.CLEARMON.sCmd)
  else
    g_GameCommand.CLEARMON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ClearMon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ClearMon',
      g_GameCommand.CLEARMON.nPermissionMin)
  else
    g_GameCommand.CLEARMON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ReNewLevel', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ReNewLevel',
      g_GameCommand.RENEWLEVEL.sCmd)
  else
    g_GameCommand.RENEWLEVEL.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ReNewLevel', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ReNewLevel',
      g_GameCommand.RENEWLEVEL.nPermissionMin)
  else
    g_GameCommand.RENEWLEVEL.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DenyIPaddrLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DenyIPaddrLogon',
      g_GameCommand.DENYIPLOGON.sCmd)
  else
    g_GameCommand.DENYIPLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DenyIPaddrLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DenyIPaddrLogon',
      g_GameCommand.DENYIPLOGON.nPermissionMin)
  else
    g_GameCommand.DENYIPLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DenyAccountLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DenyAccountLogon',
      g_GameCommand.DENYACCOUNTLOGON.sCmd)
  else
    g_GameCommand.DENYACCOUNTLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DenyAccountLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DenyAccountLogon',
      g_GameCommand.DENYACCOUNTLOGON.nPermissionMin)
  else
    g_GameCommand.DENYACCOUNTLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DenyCharNameLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DenyCharNameLogon',
      g_GameCommand.DENYCHARNAMELOGON.sCmd)
  else
    g_GameCommand.DENYCHARNAMELOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DenyCharNameLogon',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DenyCharNameLogon',
      g_GameCommand.DENYCHARNAMELOGON.nPermissionMin)
  else
    g_GameCommand.DENYCHARNAMELOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelDenyIPLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelDenyIPLogon',
      g_GameCommand.DELDENYIPLOGON.sCmd)
  else
    g_GameCommand.DELDENYIPLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelDenyIPLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelDenyIPLogon',
      g_GameCommand.DELDENYIPLOGON.nPermissionMin)
  else
    g_GameCommand.DELDENYIPLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelDenyAccountLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelDenyAccountLogon',
      g_GameCommand.DELDENYACCOUNTLOGON.sCmd)
  else
    g_GameCommand.DELDENYACCOUNTLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelDenyAccountLogon',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelDenyAccountLogon',
      g_GameCommand.DELDENYACCOUNTLOGON.nPermissionMin)
  else
    g_GameCommand.DELDENYACCOUNTLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'DelDenyCharNameLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'DelDenyCharNameLogon',
      g_GameCommand.DELDENYCHARNAMELOGON.sCmd)
  else
    g_GameCommand.DELDENYCHARNAMELOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'DelDenyCharNameLogon',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'DelDenyCharNameLogon',
      g_GameCommand.DELDENYCHARNAMELOGON.nPermissionMin)
  else
    g_GameCommand.DELDENYCHARNAMELOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowDenyIPLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowDenyIPLogon',
      g_GameCommand.SHOWDENYIPLOGON.sCmd)
  else
    g_GameCommand.SHOWDENYIPLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowDenyIPLogon', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowDenyIPLogon',
      g_GameCommand.SHOWDENYIPLOGON.nPermissionMin)
  else
    g_GameCommand.SHOWDENYIPLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowDenyAccountLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowDenyAccountLogon',
      g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd)
  else
    g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowDenyAccountLogon',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowDenyAccountLogon',
      g_GameCommand.SHOWDENYACCOUNTLOGON.nPermissionMin)
  else
    g_GameCommand.SHOWDENYACCOUNTLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShowDenyCharNameLogon', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShowDenyCharNameLogon',
      g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd)
  else
    g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShowDenyCharNameLogon',
    -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShowDenyCharNameLogon',
      g_GameCommand.SHOWDENYCHARNAMELOGON.nPermissionMin)
  else
    g_GameCommand.SHOWDENYCHARNAMELOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ViewWhisper', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ViewWhisper',
      g_GameCommand.VIEWWHISPER.sCmd)
  else
    g_GameCommand.VIEWWHISPER.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ViewWhisper', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ViewWhisper',
      g_GameCommand.VIEWWHISPER.nPermissionMin)
  else
    g_GameCommand.VIEWWHISPER.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SpiritStart', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SpiritStart', g_GameCommand.Spirit.sCmd)
  else
    g_GameCommand.Spirit.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SpiritStart', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SpiritStart',
      g_GameCommand.Spirit.nPermissionMin)
  else
    g_GameCommand.Spirit.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SpiritStop', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SpiritStop',
      g_GameCommand.SpiritStop.sCmd)
  else
    g_GameCommand.SpiritStop.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SpiritStop', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SpiritStop',
      g_GameCommand.SpiritStop.nPermissionMin)
  else
    g_GameCommand.SpiritStop.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'SetMapMode', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'SetMapMode',
      g_GameCommand.SetMapMode.sCmd)
  else
    g_GameCommand.SetMapMode.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'SetMapMode', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'SetMapMode',
      g_GameCommand.SetMapMode.nPermissionMin)
  else
    g_GameCommand.SetMapMode.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ShoweMapMode', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ShoweMapMode', g_GameCommand.SHOWMAPMODE.sCmd)
  else
    g_GameCommand.SHOWMAPMODE.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ShoweMapMode', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ShoweMapMode', g_GameCommand.SHOWMAPMODE.nPermissionMin)
  else
    g_GameCommand.SHOWMAPMODE.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'ClearBag', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'ClearBag', g_GameCommand.CLEARBAG.sCmd)
  else
    g_GameCommand.CLEARBAG.sCmd := LoadString;
  nLoadInteger := CommandConf.ReadInteger('Permission', 'ClearBag', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'ClearBag',
      g_GameCommand.CLEARBAG.nPermissionMin)
  else
    g_GameCommand.CLEARBAG.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'LockLogin', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'LockLogin', g_GameCommand.LOCKLOGON.sCmd)
  else
    g_GameCommand.LOCKLOGON.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'LockLogin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'LockLogin', g_GameCommand.LOCKLOGON.nPermissionMin)
  else
    g_GameCommand.LOCKLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'UnLockLogin', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'UnLockLogin', g_GameCommand.UNLOCKLOGON.sCmd)
  else
    g_GameCommand.UNLOCKLOGON.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'UnLockLogin', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'UnLockLogin', g_GameCommand.UNLOCKLOGON.nPermissionMin)
  else
    g_GameCommand.UNLOCKLOGON.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'RemoteMusic', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'RemoteMusic', g_GameCommand.RemoteMusic.sCmd)
  else
    g_GameCommand.RemoteMusic.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'RemoteMusic', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'RemoteMusic', g_GameCommand.RemoteMusic.nPermissionMin)
  else
    g_GameCommand.RemoteMusic.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'RemoteMsg', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'RemoteMsg', g_GameCommand.RemoteMsg.sCmd)
  else
    g_GameCommand.RemoteMsg.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'RemoteMsg', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'RemoteMsg', g_GameCommand.RemoteMsg.nPermissionMin)
  else
    g_GameCommand.RemoteMsg.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'InitSabuk', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'InitSabuk', g_GameCommand.INITSABUK.sCmd)
  else
    g_GameCommand.INITSABUK.sCmd := LoadString;

  nLoadInteger := CommandConf.ReadInteger('Permission', 'InitSabuk', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'InitSabuk', g_GameCommand.INITSABUK.nPermissionMin)
  else
    g_GameCommand.INITSABUK.nPermissionMin := nLoadInteger;

  LoadString := CommandConf.ReadString('Command', 'GMRedMsgCmd', '');
  if LoadString = '' then
    CommandConf.WriteString('Command', 'GMRedMsgCmd', g_GMRedMsgCmd)
  else
    g_GMRedMsgCmd := LoadString[1];

  nLoadInteger := CommandConf.ReadInteger('Permission', 'GMRedMsgCmd', -1);
  if nLoadInteger < 0 then
    CommandConf.WriteInteger('Permission', 'GMRedMsgCmd', g_nGMREDMSGCMD)
  else
    g_nGMREDMSGCMD := nLoadInteger;
end;

procedure LoadString();

  function LoadConfigString(sSection, sIdent, sDefault: string): string;
  var
    sString                 : string;
  begin
    sString := StringConf.ReadString(sSection, sIdent, '');
    if sString = '' then begin
      StringConf.WriteString(sSection, sIdent, sDefault);
      Result := sDefault;
    end
    else begin
      Result := sString;
    end;
  end;
var
  LoadString                : string;
begin
  LoadString := StringConf.ReadString('String', 'ClientSoftVersionError', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ClientSoftVersionError', sClientSoftVersionError)
  else
    sClientSoftVersionError := LoadString;

  LoadString := StringConf.ReadString('String', 'DownLoadNewClientSoft', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DownLoadNewClientSoft', sDownLoadNewClientSoft)
  else
    sDownLoadNewClientSoft := LoadString;

  LoadString := StringConf.ReadString('String', 'ForceDisConnect', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ForceDisConnect', sForceDisConnect)
  else
    sForceDisConnect := LoadString;

  LoadString := StringConf.ReadString('String', 'ClientSoftVersionTooOld', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ClientSoftVersionTooOld',
      sClientSoftVersionTooOld)
  else
    sClientSoftVersionTooOld := LoadString;

  LoadString := StringConf.ReadString('String', 'DownLoadAndUseNewClient', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DownLoadAndUseNewClient',
      sDownLoadAndUseNewClient)
  else
    sDownLoadAndUseNewClient := LoadString;

  LoadString := StringConf.ReadString('String', 'OnlineUserFull', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'OnlineUserFull', sOnlineUserFull)
  else
    sOnlineUserFull := LoadString;

  LoadString := StringConf.ReadString('String', 'YouNowIsTryPlayMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouNowIsTryPlayMode', sYouNowIsTryPlayMode)
  else
    sYouNowIsTryPlayMode := LoadString;

  LoadString := StringConf.ReadString('String', 'NowIsFreePlayMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NowIsFreePlayMode', g_sNowIsFreePlayMode)
  else
    g_sNowIsFreePlayMode := LoadString;

  {LoadString := StringConf.ReadString('String', 'AttackModeOfAll', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfAll', sAttackModeOfAll)
  else
    sAttackModeOfAll := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfPeaceful', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfPeaceful',
      sAttackModeOfPeaceful)
  else
    sAttackModeOfPeaceful := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfGroup', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfGroup', sAttackModeOfGroup)
  else
    sAttackModeOfGroup := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfGuild', sAttackModeOfGuild)
  else
    sAttackModeOfGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'AttackModeOfRedWhite', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AttackModeOfRedWhite',
      sAttackModeOfRedWhite)
  else
    sAttackModeOfRedWhite := LoadString;}

  LoadString := StringConf.ReadString('String', 'StartChangeAttackModeHelp', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartChangeAttackModeHelp', sStartChangeAttackModeHelp)
  else
    sStartChangeAttackModeHelp := LoadString;

  LoadString := StringConf.ReadString('String', 'StartNoticeMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartNoticeMsg', sStartNoticeMsg)
  else
    sStartNoticeMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ThrustingOn', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ThrustingOn', sThrustingOn)
  else
    sThrustingOn := LoadString;

  LoadString := StringConf.ReadString('String', 'ThrustingOff', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ThrustingOff', sThrustingOff)
  else
    sThrustingOff := LoadString;

  LoadString := StringConf.ReadString('String', 'HalfMoonOn', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HalfMoonOn', sHalfMoonOn)
  else
    sHalfMoonOn := LoadString;

  LoadString := StringConf.ReadString('String', 'HalfMoonOff', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HalfMoonOff', sHalfMoonOff)
  else
    sHalfMoonOff := LoadString;

  sCrsHitOn := LoadConfigString('String', 'CrsHitOn', sCrsHitOn);
  sCrsHitOff := LoadConfigString('String', 'CrsHitOff', sCrsHitOff);

  LoadString := StringConf.ReadString('String', 'FireSpiritsSummoned', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'FireSpiritsSummoned', sFireSpiritsSummoned)
  else
    sFireSpiritsSummoned := LoadString;

  //LoadString := StringConf.ReadString('String', 'FireSpiritsFail', '');
  //if LoadString = '' then
  //  StringConf.WriteString('String', 'FireSpiritsFail', sFireSpiritsFail)
  //else
  //  sFireSpiritsFail := LoadString;

  LoadString := StringConf.ReadString('String', 'SpiritsGone', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SpiritsGone', sSpiritsGone)
  else
    sSpiritsGone := LoadString;

  LoadString := StringConf.ReadString('String', 'PursueSpiritsSummoned', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PursueSpiritsSummoned', sPursueSpiritsSummoned)
  else
    sPursueSpiritsSummoned := LoadString;

  LoadString := StringConf.ReadString('String', 'PursueSpiritsGone', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PursueSpiritsGone', sPursueSpiritsGone)
  else
    sPursueSpiritsGone := LoadString;

  LoadString := StringConf.ReadString('String', 'MateDoTooweak', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MateDoTooweak', sMateDoTooweak)
  else
    sMateDoTooweak := LoadString;

  LoadString := StringConf.ReadString('String', 'TheWeaponBroke', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheWeaponBroke', g_sTheWeaponBroke)
  else
    g_sTheWeaponBroke := LoadString;

  LoadString := StringConf.ReadString('String', 'TheWeaponRefineSuccessfull',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheWeaponRefineSuccessfull',
      sTheWeaponRefineSuccessfull)
  else
    sTheWeaponRefineSuccessfull := LoadString;

  LoadString := StringConf.ReadString('String', 'YouPoisoned', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouPoisoned', sYouPoisoned)
  else
    sYouPoisoned := LoadString;

  LoadString := StringConf.ReadString('String', 'PetRest', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PetRest', sPetRest)
  else
    sPetRest := LoadString;

  LoadString := StringConf.ReadString('String', 'PetAttack', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PetAttack', sPetAttack)
  else
    sPetAttack := LoadString;

  LoadString := StringConf.ReadString('String', 'WearNotOfWoMan', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WearNotOfWoMan', sWearNotOfWoMan)
  else
    sWearNotOfWoMan := LoadString;

  LoadString := StringConf.ReadString('String', 'WearNotOfMan', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WearNotOfMan', sWearNotOfMan)
  else
    sWearNotOfMan := LoadString;

  LoadString := StringConf.ReadString('String', 'HandWeightNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HandWeightNot', sHandWeightNot)
  else
    sHandWeightNot := LoadString;

  LoadString := StringConf.ReadString('String', 'WearWeightNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WearWeightNot', sWearWeightNot)
  else
    sWearWeightNot := LoadString;

  LoadString := StringConf.ReadString('String', 'ItemIsNotThisAccount', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ItemIsNotThisAccount',
      g_sItemIsNotThisAccount)
  else
    g_sItemIsNotThisAccount := LoadString;

  LoadString := StringConf.ReadString('String', 'ItemIsNotThisIPaddr', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ItemIsNotThisIPaddr',
      g_sItemIsNotThisIPaddr)
  else
    g_sItemIsNotThisIPaddr := LoadString;

  LoadString := StringConf.ReadString('String', 'ItemIsNotThisCharName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ItemIsNotThisCharName',
      g_sItemIsNotThisCharName)
  else
    g_sItemIsNotThisCharName := LoadString;

  LoadString := StringConf.ReadString('String', 'LevelNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'LevelNot', g_sLevelNot)
  else
    g_sLevelNot := LoadString;

  LoadString := StringConf.ReadString('String', 'JobOrLevelNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JobOrLevelNot', g_sJobOrLevelNot)
  else
    g_sJobOrLevelNot := LoadString;

  LoadString := StringConf.ReadString('String', 'JobOrDCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JobOrDCNot', g_sJobOrDCNot)
  else
    g_sJobOrDCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'JobOrMCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JobOrMCNot', g_sJobOrMCNot)
  else
    g_sJobOrMCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'JobOrSCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JobOrSCNot', g_sJobOrSCNot)
  else
    g_sJobOrSCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'DCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DCNot', g_sDCNot)
  else
    g_sDCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'MCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MCNot', g_sMCNot)
  else
    g_sMCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'SCNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SCNot', g_sSCNot)
  else
    g_sSCNot := LoadString;

  LoadString := StringConf.ReadString('String', 'CreditPointNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CreditPointNot', g_sCreditPointNot)
  else
    g_sCreditPointNot := LoadString;

  LoadString := StringConf.ReadString('String', 'ReNewLevelNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReNewLevelNot', g_sReNewLevelNot)
  else
    g_sReNewLevelNot := LoadString;

  LoadString := StringConf.ReadString('String', 'GuildNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GuildNot', g_sGuildNot)
  else
    g_sGuildNot := LoadString;

  LoadString := StringConf.ReadString('String', 'GuildMasterNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GuildMasterNot', g_sGuildMasterNot)
  else
    g_sGuildMasterNot := LoadString;

  LoadString := StringConf.ReadString('String', 'SabukHumanNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SabukHumanNot', g_sSabukHumanNot)
  else
    g_sSabukHumanNot := LoadString;

  LoadString := StringConf.ReadString('String', 'SabukMasterManNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SabukMasterManNot', g_sSabukMasterManNot)
  else
    g_sSabukMasterManNot := LoadString;

  LoadString := StringConf.ReadString('String', 'MemberNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MemberNot', g_sMemberNot)
  else
    g_sMemberNot := LoadString;

  LoadString := StringConf.ReadString('String', 'MemberTypeNot', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MemberTypeNot', g_sMemberTypeNot)
  else
    g_sMemberTypeNot := LoadString;

  LoadString := StringConf.ReadString('String', 'CanottWearIt', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanottWearIt', g_sCanottWearIt)
  else
    g_sCanottWearIt := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotUseDrugOnThisMap', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotUseDrugOnThisMap',
      sCanotUseDrugOnThisMap)
  else
    sCanotUseDrugOnThisMap := LoadString;

  LoadString := StringConf.ReadString('String', 'GameMasterMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GameMasterMode', sGameMasterMode)
  else
    sGameMasterMode := LoadString;

  LoadString := StringConf.ReadString('String', 'ReleaseGameMasterMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReleaseGameMasterMode',
      sReleaseGameMasterMode)
  else
    sReleaseGameMasterMode := LoadString;

  LoadString := StringConf.ReadString('String', 'ObserverMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ObserverMode', sObserverMode)
  else
    sObserverMode := LoadString;

  LoadString := StringConf.ReadString('String', 'ReleaseObserverMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReleaseObserverMode',
      g_sReleaseObserverMode)
  else
    g_sReleaseObserverMode := LoadString;

  LoadString := StringConf.ReadString('String', 'SupermanMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SupermanMode', sSupermanMode)
  else
    sSupermanMode := LoadString;

  LoadString := StringConf.ReadString('String', 'ReleaseSupermanMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReleaseSupermanMode', sReleaseSupermanMode)
  else
    sReleaseSupermanMode := LoadString;

  LoadString := StringConf.ReadString('String', 'YouFoundNothing', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouFoundNothing', sYouFoundNothing)
  else
    sYouFoundNothing := LoadString;

  LoadString := StringConf.ReadString('String', 'LineNoticePreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'LineNoticePreFix',
      g_Config.sLineNoticePreFix)
  else
    g_Config.sLineNoticePreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'SysMsgPreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SysMsgPreFix', g_Config.sSysMsgPreFix)
  else
    g_Config.sSysMsgPreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'GuildMsgPreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GuildMsgPreFix', g_Config.sGuildMsgPreFix)
  else
    g_Config.sGuildMsgPreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'GroupMsgPreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GroupMsgPreFix', g_Config.sGroupMsgPreFix)
  else
    g_Config.sGroupMsgPreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'HintMsgPreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HintMsgPreFix', g_Config.sHintMsgPreFix)
  else
    g_Config.sHintMsgPreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'GMRedMsgpreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'GMRedMsgpreFix', g_Config.sGMRedMsgpreFix)
  else
    g_Config.sGMRedMsgpreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'MonSayMsgpreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MonSayMsgpreFix',
      g_Config.sMonSayMsgpreFix)
  else
    g_Config.sMonSayMsgpreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'CustMsgpreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CustMsgpreFix', g_Config.sCustMsgpreFix)
  else
    g_Config.sCustMsgpreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'CastleMsgpreFix', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CastleMsgpreFix',
      g_Config.sCastleMsgpreFix)
  else
    g_Config.sCastleMsgpreFix := LoadString;

  LoadString := StringConf.ReadString('String', 'NoPasswordLockSystemMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NoPasswordLockSystemMsg',
      g_sNoPasswordLockSystemMsg)
  else
    g_sNoPasswordLockSystemMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'AlreadySetPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'AlreadySetPassword',
      g_sAlreadySetPasswordMsg)
  else
    g_sAlreadySetPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ReSetPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReSetPassword', g_sReSetPasswordMsg)
  else
    g_sReSetPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PasswordOverLong', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PasswordOverLong', g_sPasswordOverLongMsg)
  else
    g_sPasswordOverLongMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ReSetPasswordOK', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReSetPasswordOK', g_sReSetPasswordOKMsg)
  else
    g_sReSetPasswordOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ReSetPasswordNotMatch', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ReSetPasswordNotMatch',
      g_sReSetPasswordNotMatchMsg)
  else
    g_sReSetPasswordNotMatchMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PleaseInputUnLockPassword',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseInputUnLockPassword',
      g_sPleaseInputUnLockPasswordMsg)
  else
    g_sPleaseInputUnLockPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageUnLockOK', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageUnLockOK', g_sStorageUnLockOKMsg)
  else
    g_sStorageUnLockOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageAlreadyUnLock', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageAlreadyUnLock',
      g_sStorageAlreadyUnLockMsg)
  else
    g_sStorageAlreadyUnLockMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageNoPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageNoPassword', g_sStorageNoPasswordMsg)
  else
    g_sStorageNoPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UnLockPasswordFail', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UnLockPasswordFail',
      g_sUnLockPasswordFailMsg)
  else
    g_sUnLockPasswordFailMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'LockStorageSuccess', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'LockStorageSuccess',
      g_sLockStorageSuccessMsg)
  else
    g_sLockStorageSuccessMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StoragePasswordClearMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StoragePasswordClearMsg',
      g_sStoragePasswordClearMsg)
  else
    g_sStoragePasswordClearMsg := LoadString;
  LoadString := StringConf.ReadString('String',
    'PleaseUnloadStoragePasswordMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseUnloadStoragePasswordMsg',
      g_sPleaseUnloadStoragePasswordMsg)
  else
    g_sPleaseUnloadStoragePasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageAlreadyLock', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageAlreadyLock',
      g_sStorageAlreadyLockMsg)
  else
    g_sStorageAlreadyLockMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StoragePasswordLocked', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StoragePasswordLocked',
      g_sStoragePasswordLockedMsg)
  else
    g_sStoragePasswordLockedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageSetPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageSetPassword', g_sSetPasswordMsg)
  else
    g_sSetPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PleaseInputOldPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseInputOldPassword',
      g_sPleaseInputOldPasswordMsg)
  else
    g_sPleaseInputOldPasswordMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PasswordIsClearMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PasswordIsClearMsg',
      g_sOldPasswordIsClearMsg)
  else
    g_sOldPasswordIsClearMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'NoPasswordSet', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NoPasswordSet', g_sNoPasswordSetMsg)
  else
    g_sNoPasswordSetMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'OldPasswordIncorrect', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'OldPasswordIncorrect',
      g_sOldPasswordIncorrectMsg)
  else
    g_sOldPasswordIncorrectMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StorageIsLocked', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StorageIsLocked', g_sStorageIsLockedMsg)
  else
    g_sStorageIsLockedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PleaseTryDealLaterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseTryDealLaterMsg',
      g_sPleaseTryDealLaterMsg)
  else
    g_sPleaseTryDealLaterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DealItemsDenyGetBackMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealItemsDenyGetBackMsg',
      g_sDealItemsDenyGetBackMsg)
  else
    g_sDealItemsDenyGetBackMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableDealItemsMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableDealItemsMsg',
      g_sDisableDealItemsMsg)
  else
    g_sDisableDealItemsMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotTryDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotTryDealMsg', g_sCanotTryDealMsg)
  else
    g_sCanotTryDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DealActionCancelMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealActionCancelMsg',
      g_sDealActionCancelMsg)
  else
    g_sDealActionCancelMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PoseDisableDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PoseDisableDealMsg', g_sPoseDisableDealMsg)
  else
    g_sPoseDisableDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DealSuccessMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealSuccessMsg', g_sDealSuccessMsg)
  else
    g_sDealSuccessMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DealOKTooFast', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealOKTooFast', g_sDealOKTooFast)
  else
    g_sDealOKTooFast := LoadString;

  LoadString := StringConf.ReadString('String', 'YourBagSizeTooSmall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourBagSizeTooSmall',
      g_sYourBagSizeTooSmall)
  else
    g_sYourBagSizeTooSmall := LoadString;

  LoadString := StringConf.ReadString('String', 'DealHumanBagSizeTooSmall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealHumanBagSizeTooSmall',
      g_sDealHumanBagSizeTooSmall)
  else
    g_sDealHumanBagSizeTooSmall := LoadString;

  LoadString := StringConf.ReadString('String', 'YourGoldLargeThenLimit', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourGoldLargeThenLimit',
      g_sYourGoldLargeThenLimit)
  else
    g_sYourGoldLargeThenLimit := LoadString;

  LoadString := StringConf.ReadString('String', 'DealHumanGoldLargeThenLimit',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DealHumanGoldLargeThenLimit',
      g_sDealHumanGoldLargeThenLimit)
  else
    g_sDealHumanGoldLargeThenLimit := LoadString;

  LoadString := StringConf.ReadString('String', 'YouDealOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouDealOKMsg', g_sYouDealOKMsg)
  else
    g_sYouDealOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PoseDealOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PoseDealOKMsg', g_sPoseDealOKMsg)
  else
    g_sPoseDealOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'KickClientUserMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'KickClientUserMsg', g_sKickClientUserMsg)
  else
    g_sKickClientUserMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ActionIsLockedMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ActionIsLockedMsg', g_sActionIsLockedMsg)
  else
    g_sActionIsLockedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'PasswordNotSetMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PasswordNotSetMsg', g_sPasswordNotSetMsg)
  else
    g_sPasswordNotSetMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'NotPasswordProtectMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NotPasswordProtectMode',
      g_sNotPasswordProtectMode)
  else
    g_sNotPasswordProtectMode := LoadString;

  LoadString := StringConf.ReadString('String', 'PasswordProtectMode', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PasswordProtectMode', g_sPasswordProtectMode)
  else
    g_sPasswordProtectMode := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotDropGoldMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotDropGoldMsg', g_sCanotDropGoldMsg)
  else
    g_sCanotDropGoldMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotDropInSafeZoneMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotDropInSafeZoneMsg',
      g_sCanotDropInSafeZoneMsg)
  else
    g_sCanotDropInSafeZoneMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotDropItemMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotDropItemMsg', g_sCanotDropItemMsg)
  else
    g_sCanotDropItemMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotDropItemMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotDropItemMsg', g_sCanotDropItemMsg)
  else
    g_sCanotDropItemMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotUseItemMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotUseItemMsg', g_sCanotUseItemMsg)
  else
    g_sCanotUseItemMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StartMarryManMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartMarryManMsg', g_sStartMarryManMsg)
  else
    g_sStartMarryManMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StartMarryWoManMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartMarryWoManMsg', g_sStartMarryWoManMsg)
  else
    g_sStartMarryWoManMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StartMarryManAskQuestionMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartMarryManAskQuestionMsg',
      g_sStartMarryManAskQuestionMsg)
  else
    g_sStartMarryManAskQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'StartMarryWoManAskQuestionMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'StartMarryWoManAskQuestionMsg',
      g_sStartMarryWoManAskQuestionMsg)
  else
    g_sStartMarryWoManAskQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryManAnswerQuestionMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryManAnswerQuestionMsg',
      g_sMarryManAnswerQuestionMsg)
  else
    g_sMarryManAnswerQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryManAskQuestionMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryManAskQuestionMsg',
      g_sMarryManAskQuestionMsg)
  else
    g_sMarryManAskQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryWoManAnswerQuestionMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryWoManAnswerQuestionMsg',
      g_sMarryWoManAnswerQuestionMsg)
  else
    g_sMarryWoManAnswerQuestionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryWoManGetMarryMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryWoManGetMarryMsg',
      g_sMarryWoManGetMarryMsg)
  else
    g_sMarryWoManGetMarryMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryWoManDenyMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryWoManDenyMsg', g_sMarryWoManDenyMsg)
  else
    g_sMarryWoManDenyMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MarryWoManCancelMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MarryWoManCancelMsg',
      g_sMarryWoManCancelMsg)
  else
    g_sMarryWoManCancelMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ForceUnMarryManLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ForceUnMarryManLoginMsg',
      g_sfUnMarryManLoginMsg)
  else
    g_sfUnMarryManLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ForceUnMarryWoManLoginMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ForceUnMarryWoManLoginMsg',
      g_sfUnMarryWoManLoginMsg)
  else
    g_sfUnMarryWoManLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ManLoginDearOnlineSelfMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManLoginDearOnlineSelfMsg',
      g_sManLoginDearOnlineSelfMsg)
  else
    g_sManLoginDearOnlineSelfMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ManLoginDearOnlineDearMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManLoginDearOnlineDearMsg',
      g_sManLoginDearOnlineDearMsg)
  else
    g_sManLoginDearOnlineDearMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManLoginDearOnlineSelfMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManLoginDearOnlineSelfMsg',
      g_sWoManLoginDearOnlineSelfMsg)
  else
    g_sWoManLoginDearOnlineSelfMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManLoginDearOnlineDearMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManLoginDearOnlineDearMsg',
      g_sWoManLoginDearOnlineDearMsg)
  else
    g_sWoManLoginDearOnlineDearMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ManLoginDearNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManLoginDearNotOnlineMsg',
      g_sManLoginDearNotOnlineMsg)
  else
    g_sManLoginDearNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManLoginDearNotOnlineMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManLoginDearNotOnlineMsg',
      g_sWoManLoginDearNotOnlineMsg)
  else
    g_sWoManLoginDearNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ManLongOutDearOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManLongOutDearOnlineMsg',
      g_sManLongOutDearOnlineMsg)
  else
    g_sManLongOutDearOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManLongOutDearOnlineMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManLongOutDearOnlineMsg',
      g_sWoManLongOutDearOnlineMsg)
  else
    g_sWoManLongOutDearOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouAreNotMarryedMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouAreNotMarryedMsg',
      g_sYouAreNotMarryedMsg)
  else
    g_sYouAreNotMarryedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourWifeNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourWifeNotOnlineMsg',
      g_sYourWifeNotOnlineMsg)
  else
    g_sYourWifeNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourHusbandNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourHusbandNotOnlineMsg',
      g_sYourHusbandNotOnlineMsg)
  else
    g_sYourHusbandNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourWifeNowLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourWifeNowLocateMsg',
      g_sYourWifeNowLocateMsg)
  else
    g_sYourWifeNowLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourHusbandSearchLocateMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourHusbandSearchLocateMsg',
      g_sYourHusbandSearchLocateMsg)
  else
    g_sYourHusbandSearchLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourHusbandNowLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourHusbandNowLocateMsg',
      g_sYourHusbandNowLocateMsg)
  else
    g_sYourHusbandNowLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourWifeSearchLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourWifeSearchLocateMsg',
      g_sYourWifeSearchLocateMsg)
  else
    g_sYourWifeSearchLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'FUnMasterLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'FUnMasterLoginMsg', g_sfUnMasterLoginMsg)
  else
    g_sfUnMasterLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UnMasterListLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UnMasterListLoginMsg',
      g_sfUnMasterListLoginMsg)
  else
    g_sfUnMasterListLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterListOnlineSelfMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterListOnlineSelfMsg',
      g_sMasterListOnlineSelfMsg)
  else
    g_sMasterListOnlineSelfMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterListOnlineMasterMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterListOnlineMasterMsg',
      g_sMasterListOnlineMasterMsg)
  else
    g_sMasterListOnlineMasterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterOnlineSelfMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterOnlineSelfMsg',
      g_sMasterOnlineSelfMsg)
  else
    g_sMasterOnlineSelfMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterOnlineMasterListMsg',
    '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterOnlineMasterListMsg',
      g_sMasterOnlineMasterListMsg)
  else
    g_sMasterOnlineMasterListMsg := LoadString;

  LoadString := StringConf.ReadString('String',
    'MasterLongOutMasterListOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterLongOutMasterListOnlineMsg',
      g_sMasterLongOutMasterListOnlineMsg)
  else
    g_sMasterLongOutMasterListOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String',
    'MasterListLongOutMasterOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterListLongOutMasterOnlineMsg', g_sMasterListLongOutMasterOnlineMsg)
  else
    g_sMasterListLongOutMasterOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterListNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterListNotOnlineMsg', g_sMasterListNotOnlineMsg)
  else
    g_sMasterListNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterNotOnlineMsg', g_sMasterNotOnlineMsg)
  else
    g_sMasterNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouAreNotMasterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouAreNotMasterMsg', g_sYouAreNotMasterMsg)
  else
    g_sYouAreNotMasterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterNotOnlineMsg', g_sYourMasterNotOnlineMsg)
  else
    g_sYourMasterNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterListNotOnlineMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterListNotOnlineMsg', g_sYourMasterListNotOnlineMsg)
  else
    g_sYourMasterListNotOnlineMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterNowLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterNowLocateMsg', g_sYourMasterNowLocateMsg)
  else
    g_sYourMasterNowLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterListSearchLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterListSearchLocateMsg', g_sYourMasterListSearchLocateMsg)
  else
    g_sYourMasterListSearchLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterListNowLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterListNowLocateMsg', g_sYourMasterListNowLocateMsg)
  else
    g_sYourMasterListNowLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterSearchLocateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterSearchLocateMsg', g_sYourMasterSearchLocateMsg)
  else
    g_sYourMasterSearchLocateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YourMasterListUnMasterOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourMasterListUnMasterOKMsg', g_sYourMasterListUnMasterOKMsg)
  else
    g_sYourMasterListUnMasterOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouAreUnMasterOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouAreUnMasterOKMsg', g_sYouAreUnMasterOKMsg)
  else
    g_sYouAreUnMasterOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UnMasterLoginMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UnMasterLoginMsg', g_sUnMasterLoginMsg)
  else
    g_sUnMasterLoginMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'NPCSayUnMasterOKMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NPCSayUnMasterOKMsg', g_sNPCSayUnMasterOKMsg)
  else
    g_sNPCSayUnMasterOKMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'NPCSayForceUnMasterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NPCSayForceUnMasterMsg', g_sNPCSayForceUnMasterMsg)
  else
    g_sNPCSayForceUnMasterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'MyInfo', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MyInfo', g_sMyInfo)
  else
    g_sMyInfo := LoadString;

  LoadString := StringConf.ReadString('String', 'OpenedDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'OpenedDealMsg', g_sOpenedDealMsg)
  else
    g_sOpenedDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'SendCustMsgCanNotUseNowMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SendCustMsgCanNotUseNowMsg', g_sSendCustMsgCanNotUseNowMsg)
  else
    g_sSendCustMsgCanNotUseNowMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'SubkMasterMsgCanNotUseNowMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SubkMasterMsgCanNotUseNowMsg', g_sSubkMasterMsgCanNotUseNowMsg)
  else
    g_sSubkMasterMsgCanNotUseNowMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'SendOnlineCountMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'SendOnlineCountMsg', g_sSendOnlineCountMsg)
  else
    g_sSendOnlineCountMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WeaponRepairSuccess', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WeaponRepairSuccess',
      g_sWeaponRepairSuccess)
  else
    g_sWeaponRepairSuccess := LoadString;

  LoadString := StringConf.ReadString('String', 'DefenceUpTime', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DefenceUpTime', g_sDefenceUpTime)
  else
    g_sDefenceUpTime := LoadString;

  LoadString := StringConf.ReadString('String', 'MagDefenceUpTime', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MagDefenceUpTime', g_sMagDefenceUpTime)
  else
    g_sMagDefenceUpTime := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery1Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery1Msg', g_sWinLottery1Msg)
  else
    g_sWinLottery1Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery2Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery2Msg', g_sWinLottery2Msg)
  else
    g_sWinLottery2Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery3Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery3Msg', g_sWinLottery3Msg)
  else
    g_sWinLottery3Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery4Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery4Msg', g_sWinLottery4Msg)
  else
    g_sWinLottery4Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery5Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery5Msg', g_sWinLottery5Msg)
  else
    g_sWinLottery5Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'WinLottery6Msg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WinLottery6Msg', g_sWinLottery6Msg)
  else
    g_sWinLottery6Msg := LoadString;

  LoadString := StringConf.ReadString('String', 'NotWinLotteryMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NotWinLotteryMsg', g_sNotWinLotteryMsg)
  else
    g_sNotWinLotteryMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'WeaptonMakeLuck', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WeaptonMakeLuck', g_sWeaptonMakeLuck)
  else
    g_sWeaptonMakeLuck := LoadString;

  LoadString := StringConf.ReadString('String', 'WeaptonNotMakeLuck', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WeaptonNotMakeLuck', g_sWeaptonNotMakeLuck)
  else
    g_sWeaptonNotMakeLuck := LoadString;

  LoadString := StringConf.ReadString('String', 'TheWeaponIsCursed', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheWeaponIsCursed', g_sTheWeaponIsCursed)
  else
    g_sTheWeaponIsCursed := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotTakeOffItem', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotTakeOffItem', g_sCanotTakeOffItem)
  else
    g_sCanotTakeOffItem := LoadString;

  LoadString := StringConf.ReadString('String', 'JoinGroupMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'JoinGroupMsg', g_sJoinGroup)
  else
    g_sJoinGroup := LoadString;

  LoadString := StringConf.ReadString('String', 'TryModeCanotUseStorage', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TryModeCanotUseStorage', g_sTryModeCanotUseStorage)
  else
    g_sTryModeCanotUseStorage := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotGetItemsMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotGetItemsMsg', g_sCanotGetItems)
  else
    g_sCanotGetItems := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableDearRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableDearRecall', g_sEnableDearRecall)
  else
    g_sEnableDearRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableDearRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableDearRecall', g_sDisableDearRecall)
  else
    g_sDisableDearRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableMasterRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableMasterRecall', g_sEnableMasterRecall)
  else
    g_sEnableMasterRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableMasterRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableMasterRecall', g_sDisableMasterRecall)
  else
    g_sDisableMasterRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'NowCurrDateTime', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NowCurrDateTime', g_sNowCurrDateTime)
  else
    g_sNowCurrDateTime := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableHearWhisper', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableHearWhisper', g_sEnableHearWhisper)
  else
    g_sEnableHearWhisper := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableHearWhisper', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableHearWhisper', g_sDisableHearWhisper)
  else
    g_sDisableHearWhisper := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableShoutMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableShoutMsg', g_sEnableShoutMsg)
  else
    g_sEnableShoutMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableShoutMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableShoutMsg', g_sDisableShoutMsg)
  else
    g_sDisableShoutMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableDealMsg', g_sEnableDealMsg)
  else
    g_sEnableDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableDealMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableDealMsg', g_sDisableDealMsg)
  else
    g_sDisableDealMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableGuildChat', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableGuildChat', g_sEnableGuildChat)
  else
    g_sEnableGuildChat := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableGuildChat', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableGuildChat', g_sDisableGuildChat)
  else
    g_sDisableGuildChat := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableJoinGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableJoinGuild', g_sEnableJoinGuild)
  else
    g_sEnableJoinGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableJoinGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableJoinGuild', g_sDisableJoinGuild)
  else
    g_sDisableJoinGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableAuthAllyGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableAuthAllyGuild', g_sEnableAuthAllyGuild)
  else
    g_sEnableAuthAllyGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableAuthAllyGuild', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableAuthAllyGuild', g_sDisableAuthAllyGuild)
  else
    g_sDisableAuthAllyGuild := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableGroupRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableGroupRecall', g_sEnableGroupRecall)
  else
    g_sEnableGroupRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableGroupRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableGroupRecall', g_sDisableGroupRecall)
  else
    g_sDisableGroupRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'EnableGuildRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'EnableGuildRecall', g_sEnableGuildRecall)
  else
    g_sEnableGuildRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'DisableGuildRecall', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'DisableGuildRecall', g_sDisableGuildRecall)
  else
    g_sDisableGuildRecall := LoadString;

  LoadString := StringConf.ReadString('String', 'PleaseInputPassword', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'PleaseInputPassword', g_sPleaseInputPassword)
  else
    g_sPleaseInputPassword := LoadString;

  LoadString := StringConf.ReadString('String', 'TheMapDisableMove', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheMapDisableMove', g_sTheMapDisableMove)
  else
    g_sTheMapDisableMove := LoadString;

  LoadString := StringConf.ReadString('String', 'TheMapNotFound', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TheMapNotFound', g_sTheMapNotFound)
  else
    g_sTheMapNotFound := LoadString;

  LoadString := StringConf.ReadString('String', 'YourIPaddrDenyLogon', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourIPaddrDenyLogon', g_sYourIPaddrDenyLogon)
  else
    g_sYourIPaddrDenyLogon := LoadString;

  LoadString := StringConf.ReadString('String', 'YourAccountDenyLogon', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourAccountDenyLogon', g_sYourAccountDenyLogon)
  else
    g_sYourAccountDenyLogon := LoadString;

  LoadString := StringConf.ReadString('String', 'YourCharNameDenyLogon', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YourCharNameDenyLogon', g_sYourCharNameDenyLogon)
  else
    g_sYourCharNameDenyLogon := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotPickUpItem', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotPickUpItem', g_sCanotPickUpItem)
  else
    g_sCanotPickUpItem := LoadString;

  LoadString := StringConf.ReadString('String', 'CanotSendmsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CanotSendmsg', g_sCanotSendmsg)
  else
    g_sCanotSendmsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UserDenyWhisperMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UserDenyWhisperMsg', g_sUserDenyWhisperMsg)
  else
    g_sUserDenyWhisperMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'UserNotOnLine', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'UserNotOnLine', g_sUserNotOnLine)
  else
    g_sUserNotOnLine := LoadString;

  LoadString := StringConf.ReadString('String', 'RevivalRecoverMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'RevivalRecoverMsg', g_sRevivalRecoverMsg)
  else
    g_sRevivalRecoverMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ClientVersionTooOld', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ClientVersionTooOld', g_sClientVersionTooOld)
  else
    g_sClientVersionTooOld := LoadString;

  LoadString := StringConf.ReadString('String', 'CastleGuildName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'CastleGuildName', g_sCastleGuildName)
  else
    g_sCastleGuildName := LoadString;

  LoadString := StringConf.ReadString('String', 'NoCastleGuildName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NoCastleGuildName', g_sNoCastleGuildName)
  else
    g_sNoCastleGuildName := LoadString;

  LoadString := StringConf.ReadString('String', 'WarrReNewName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WarrReNewName', g_sWarrReNewName)
  else
    g_sWarrReNewName := LoadString;

  LoadString := StringConf.ReadString('String', 'WizardReNewName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WizardReNewName', g_sWizardReNewName)
  else
    g_sWizardReNewName := LoadString;

  LoadString := StringConf.ReadString('String', 'TaosReNewName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TaosReNewName', g_sTaosReNewName)
  else
    g_sTaosReNewName := LoadString;

  LoadString := StringConf.ReadString('String', 'RankLevelName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'RankLevelName', g_sRankLevelName)
  else
    g_sRankLevelName := LoadString;

  LoadString := StringConf.ReadString('String', 'ManDearName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ManDearName', g_sManDearName)
  else
    g_sManDearName := LoadString;

  LoadString := StringConf.ReadString('String', 'WoManDearName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'WoManDearName', g_sWoManDearName)
  else
    g_sWoManDearName := LoadString;

  LoadString := StringConf.ReadString('String', 'MasterName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'MasterName', g_sMasterName)
  else
    g_sMasterName := LoadString;

  LoadString := StringConf.ReadString('String', 'NoMasterName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'NoMasterName', g_sNoMasterName)
  else
    g_sNoMasterName := LoadString;

  LoadString := StringConf.ReadString('String', 'HumanShowName', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'HumanShowName', g_sHumanShowName)
  else
    g_sHumanShowName := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangePermissionMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangePermissionMsg', g_sChangePermissionMsg)
  else
    g_sChangePermissionMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangeKillMonExpRateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangeKillMonExpRateMsg', g_sChangeKillMonExpRateMsg)
  else
    g_sChangeKillMonExpRateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangePowerRateMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangePowerRateMsg', g_sChangePowerRateMsg)
  else
    g_sChangePowerRateMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangeMemberLevelMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangeMemberLevelMsg', g_sChangeMemberLevelMsg)
  else
    g_sChangeMemberLevelMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ChangeMemberTypeMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ChangeMemberTypeMsg', g_sChangeMemberTypeMsg)
  else
    g_sChangeMemberTypeMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ScriptChangeHumanHPMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ScriptChangeHumanHPMsg', g_sScriptChangeHumanHPMsg)
  else
    g_sScriptChangeHumanHPMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ScriptChangeHumanMPMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ScriptChangeHumanMPMsg', g_sScriptChangeHumanMPMsg)
  else
    g_sScriptChangeHumanMPMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouCanotDisableSayMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouCanotDisableSayMsg', g_sDisableSayMsg)
  else
    g_sDisableSayMsg := LoadString;

  //LoadString := StringConf.ReadString('String', 'OnlineCountMsg', '');
  //if LoadString = '' then
  //  StringConf.WriteString('String', 'OnlineCountMsg', g_sOnlineCountMsg)
  //else
  //  g_sOnlineCountMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'TotalOnlineCountMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'TotalOnlineCountMsg', g_sTotalOnlineCountMsg)
  else
    g_sTotalOnlineCountMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouNeedLevelSendMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouNeedLevelSendMsg', g_sYouNeedLevelMsg)
  else
    g_sYouNeedLevelMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'ThisMapDisableSendCyCyMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'ThisMapDisableSendCyCyMsg', g_sThisMapDisableSendCyCyMsg)
  else
    g_sThisMapDisableSendCyCyMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouCanSendCyCyLaterMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouCanSendCyCyLaterMsg', g_sYouCanSendCyCyLaterMsg)
  else
    g_sYouCanSendCyCyLaterMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouIsDisableSendMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouIsDisableSendMsg', g_sYouIsDisableSendMsg)
  else
    g_sYouIsDisableSendMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouMurderedMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouMurderedMsg', g_sYouMurderedMsg)
  else
    g_sYouMurderedMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouKilledByMsg', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouKilledByMsg', g_sYouKilledByMsg)
  else
    g_sYouKilledByMsg := LoadString;

  LoadString := StringConf.ReadString('String', 'YouProtectedByLawOfDefense', '');
  if LoadString = '' then
    StringConf.WriteString('String', 'YouProtectedByLawOfDefense',
      g_sYouProtectedByLawOfDefense)
  else
    g_sYouProtectedByLawOfDefense := LoadString;
end;

procedure LoadConfig();
var
  i                         : Integer;
  nLoadInteger              : Integer;
  nLoadDword                : Dword;
  nLoadFloat                : Double;
  sLoadString               : string;
begin
  LoadString();
  LoadGameCommand();
  LoadExp();
  if StringConf.ReadString('Guild', 'GuildNotice', '') = '' then
    StringConf.WriteString('Guild', 'GuildNotice', g_Config.sGuildNotice);
  g_Config.sGuildNotice := StringConf.ReadString('Guild', 'GuildNotice', g_Config.sGuildNotice);

  if StringConf.ReadString('Guild', 'GuildWar', '') = '' then
    StringConf.WriteString('Guild', 'GuildWar', g_Config.sGuildWar);
  g_Config.sGuildWar := StringConf.ReadString('Guild', 'GuildWar', g_Config.sGuildWar);

  if StringConf.ReadString('Guild', 'GuildAll', '') = '' then
    StringConf.WriteString('Guild', 'GuildAll', g_Config.sGuildAll);
  g_Config.sGuildAll := StringConf.ReadString('Guild', 'GuildAll', g_Config.sGuildAll);

  if StringConf.ReadString('Guild', 'GuildMember', '') = '' then
    StringConf.WriteString('Guild', 'GuildMember', g_Config.sGuildMember);
  g_Config.sGuildMember := StringConf.ReadString('Guild', 'GuildMember', g_Config.sGuildMember);

  if StringConf.ReadString('Guild', 'GuildMemberRank', '') = '' then
    StringConf.WriteString('Guild', 'GuildMemberRank', g_Config.sGuildMemberRank);
  g_Config.sGuildMemberRank := StringConf.ReadString('Guild', 'GuildMemberRank', g_Config.sGuildMemberRank);

  if StringConf.ReadString('Guild', 'GuildChief', '') = '' then
    StringConf.WriteString('Guild', 'GuildChief', g_Config.sGuildChief);
  g_Config.sGuildChief := StringConf.ReadString('Guild', 'GuildChief', g_Config.sGuildChief);

  //服务器设置
  if Config.ReadString('Setup', 'HintColor', '') = '' then
    Config.WriteString('Setup', 'HintColor', g_Config.sHintColor);
  g_Config.sHintColor := Config.ReadString('Setup', 'HintColor', g_Config.sHintColor);

  if Config.ReadString('Setup', 'MemoLogFontColor', '') = '' then
    Config.WriteString('Setup', 'MemoLogFontColor', g_Config.sMemoLogFontColor);
  g_Config.sMemoLogFontColor := Config.ReadString('Setup', 'MemoLogFontColor', g_Config.sMemoLogFontColor);

  if Config.ReadString('Setup', 'MemoLogColor', '') = '' then
    Config.WriteString('Setup', 'MemoLogColor', g_Config.sMemoLogColor);
  g_Config.sMemoLogColor := Config.ReadString('Setup', 'MemoLogColor', g_Config.sMemoLogColor);

  if Config.ReadInteger('Server', 'ServerIndex', -1) < 0 then
    Config.WriteInteger('Server', 'ServerIndex', g_nServerIndex);
  g_nServerIndex := Config.ReadInteger('Server', 'ServerIndex', g_nServerIndex);

  if Config.ReadString('Server', 'ServerName', '') = '' then
    Config.WriteString('Server', 'ServerName', g_Config.sServerName);
  g_Config.sServerName := Config.ReadString('Server', 'ServerName', g_Config.sServerName);

  if StringConf.ReadString('Server', 'ServerIP', '') = '' then
    StringConf.WriteString('Server', 'ServerIP', g_Config.sServerIPaddr);
  g_Config.sServerIPaddr := StringConf.ReadString('Server', 'ServerIP', g_Config.sServerIPaddr);

  if StringConf.ReadString('Server', 'WebSite', '') = '' then
    StringConf.WriteString('Server', 'WebSite', g_Config.sWebSite);
  g_Config.sWebSite := StringConf.ReadString('Server', 'WebSite', g_Config.sWebSite);

  if StringConf.ReadString('Server', 'BbsSite', '') = '' then
    StringConf.WriteString('Server', 'BbsSite', g_Config.sBbsSite);
  g_Config.sBbsSite := StringConf.ReadString('Server', 'BbsSite', g_Config.sBbsSite);

  if StringConf.ReadString('Server', 'ClientDownload', '') = '' then
    StringConf.WriteString('Server', 'ClientDownload', g_Config.sClientDownload);
  g_Config.sClientDownload := StringConf.ReadString('Server', 'ClientDownload', g_Config.sClientDownload);

  if StringConf.ReadString('Server', 'QQ', '') = '' then
    StringConf.WriteString('Server', 'QQ', g_Config.sQQ);
  g_Config.sQQ := StringConf.ReadString('Server', 'QQ', g_Config.sQQ);

  if StringConf.ReadString('Server', 'Phone', '') = '' then
    StringConf.WriteString('Server', 'Phone', g_Config.sPhone);
  g_Config.sPhone := StringConf.ReadString('Server', 'Phone', g_Config.sPhone);

  if StringConf.ReadString('Server', 'BankAccount0', '') = '' then
    StringConf.WriteString('Server', 'BankAccount0', g_Config.sBankAccount0);
  g_Config.sBankAccount0 := StringConf.ReadString('Server', 'BankAccount0', g_Config.sBankAccount0);

  if StringConf.ReadString('Server', 'BankAccount1', '') = '' then
    StringConf.WriteString('Server', 'BankAccount1', g_Config.sBankAccount1);
  g_Config.sBankAccount1 := StringConf.ReadString('Server', 'BankAccount1', g_Config.sBankAccount1);

  if StringConf.ReadString('Server', 'BankAccount2', '') = '' then
    StringConf.WriteString('Server', 'BankAccount2', g_Config.sBankAccount2);
  g_Config.sBankAccount2 := StringConf.ReadString('Server', 'BankAccount2', g_Config.sBankAccount2);

  if StringConf.ReadString('Server', 'BankAccount3', '') = '' then
    StringConf.WriteString('Server', 'BankAccount3', g_Config.sBankAccount3);
  g_Config.sBankAccount3 := StringConf.ReadString('Server', 'BankAccount3', g_Config.sBankAccount3);

  if StringConf.ReadString('Server', 'BankAccount4', '') = '' then
    StringConf.WriteString('Server', 'BankAccount4', g_Config.sBankAccount4);
  g_Config.sBankAccount4 := StringConf.ReadString('Server', 'BankAccount4', g_Config.sBankAccount4);

  if StringConf.ReadString('Server', 'BankAccount5', '') = '' then
    StringConf.WriteString('Server', 'BankAccount5', g_Config.sBankAccount5);
  g_Config.sBankAccount5 := StringConf.ReadString('Server', 'BankAccount5', g_Config.sBankAccount5);

  if StringConf.ReadString('Server', 'BankAccount6', '') = '' then
    StringConf.WriteString('Server', 'BankAccount6', g_Config.sBankAccount6);
  g_Config.sBankAccount6 := StringConf.ReadString('Server', 'BankAccount6', g_Config.sBankAccount6);

  if StringConf.ReadString('Server', 'BankAccount7', '') = '' then
    StringConf.WriteString('Server', 'BankAccount7', g_Config.sBankAccount7);
  g_Config.sBankAccount7 := StringConf.ReadString('Server', 'BankAccount7', g_Config.sBankAccount7);

  if StringConf.ReadString('Server', 'BankAccount8', '') = '' then
    StringConf.WriteString('Server', 'BankAccount8', g_Config.sBankAccount8);
  g_Config.sBankAccount8 := StringConf.ReadString('Server', 'BankAccount8', g_Config.sBankAccount8);

  if StringConf.ReadString('Server', 'BankAccount9', '') = '' then
    StringConf.WriteString('Server', 'BankAccount9', g_Config.sBankAccount9);
  g_Config.sBankAccount9 := StringConf.ReadString('Server', 'BankAccount9', g_Config.sBankAccount9);

  if Config.ReadInteger('Server', 'ServerNumber', -1) < 0 then
    Config.WriteInteger('Server', 'ServerNumber', g_Config.nServerNumber);
  g_Config.nServerNumber := Config.ReadInteger('Server', 'ServerNumber', g_Config.nServerNumber);

  if Config.ReadString('Server', 'VentureServer', '') = '' then
    Config.WriteString('Server', 'VentureServer', BoolToStr(g_Config.boVentureServer));
  g_Config.boVentureServer := CompareText(Config.ReadString('Server', 'VentureServer', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'TestServer', '') = '' then
    Config.WriteString('Server', 'TestServer', BoolToStr(g_Config.boTestServer));
  g_Config.boTestServer := CompareText(Config.ReadString('Server', 'TestServer', 'FALSE'), 'TRUE') = 0;

  if Config.ReadInteger('Server', 'TestLevel', -1) < 0 then
    Config.WriteInteger('Server', 'TestLevel', g_Config.nTestLevel);
  g_Config.nTestLevel := Config.ReadInteger('Server', 'TestLevel', g_Config.nTestLevel);

  if Config.ReadInteger('Server', 'TestGold', -1) < 0 then
    Config.WriteInteger('Server', 'TestGold', g_Config.nTestGold);
  g_Config.nTestGold := Config.ReadInteger('Server', 'TestGold', g_Config.nTestGold);

  if Config.ReadInteger('Server', 'TestServerUserLimit', -1) < 0 then
    Config.WriteInteger('Server', 'TestServerUserLimit', g_Config.nTestUserLimit);
  g_Config.nTestUserLimit := Config.ReadInteger('Server', 'TestServerUserLimit', g_Config.nTestUserLimit);

  if Config.ReadString('Server', 'ServiceMode', '') = '' then
    Config.WriteString('Server', 'ServiceMode', BoolToStr(g_Config.boServiceMode));
  g_Config.boServiceMode := CompareText(Config.ReadString('Server', 'ServiceMode', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'NonPKServer', '') = '' then
    Config.WriteString('Server', 'NonPKServer', BoolToStr(g_Config.boNonPKServer));
  g_Config.boNonPKServer := CompareText(Config.ReadString('Server', 'NonPKServer', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'ViewHackMessage', '') = '' then
    Config.WriteString('Server', 'ViewHackMessage', BoolToStr(g_Config.boViewHackMessage));
  g_Config.boViewHackMessage := CompareText(Config.ReadString('Server', 'ViewHackMessage', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'ViewAdmissionFailure', '') = '' then
    Config.WriteString('Server', 'ViewAdmissionFailure', BoolToStr(g_Config.boViewAdmissionFailure));
  g_Config.boViewAdmissionFailure := CompareText(Config.ReadString('Server', 'ViewAdmissionFailure', 'FALSE'), 'TRUE') = 0;

  if Config.ReadString('Server', 'DBName', '') = '' then
    Config.WriteString('Server', 'DBName', sDBName);
  sDBName := Config.ReadString('Server', 'DBName', sDBName);

  if Config.ReadString('Server', 'GateAddr', '') = '' then
    Config.WriteString('Server', 'GateAddr', g_Config.sGateAddr);
  g_Config.sGateAddr := Config.ReadString('Server', 'GateAddr', g_Config.sGateAddr);

  if Config.ReadInteger('Server', 'GatePort', -1) < 0 then
    Config.WriteInteger('Server', 'GatePort', g_Config.nGatePort);
  g_Config.nGatePort := Config.ReadInteger('Server', 'GatePort', g_Config.nGatePort);

  if Config.ReadString('Server', 'DBAddr', '') = '' then
    Config.WriteString('Server', 'DBAddr', g_Config.sDBAddr);
  g_Config.sDBAddr := Config.ReadString('Server', 'DBAddr', g_Config.sDBAddr);

  if Config.ReadInteger('Server', 'DBPort', -1) < 0 then
    Config.WriteInteger('Server', 'DBPort', g_Config.nDBPort);
  g_Config.nDBPort := Config.ReadInteger('Server', 'DBPort', g_Config.nDBPort);

  if Config.ReadString('Server', 'IDSAddr', '') = '' then
    Config.WriteString('Server', 'IDSAddr', g_Config.sIDSAddr);
  g_Config.sIDSAddr := Config.ReadString('Server', 'IDSAddr', g_Config.sIDSAddr);

  if Config.ReadInteger('Server', 'IDSPort', -1) < 0 then
    Config.WriteInteger('Server', 'IDSPort', g_Config.nIDSPort);
  g_Config.nIDSPort := Config.ReadInteger('Server', 'IDSPort', g_Config.nIDSPort);

  if Config.ReadString('Server', 'MsgSrvAddr', '') = '' then
    Config.WriteString('Server', 'MsgSrvAddr', g_Config.sMsgSrvAddr);
  g_Config.sMsgSrvAddr := Config.ReadString('Server', 'MsgSrvAddr', g_Config.sMsgSrvAddr);

  if Config.ReadInteger('Server', 'MsgSrvPort', -1) < 0 then
    Config.WriteInteger('Server', 'MsgSrvPort', g_Config.nMsgSrvPort);
  g_Config.nMsgSrvPort := Config.ReadInteger('Server', 'MsgSrvPort', g_Config.nMsgSrvPort);

  if Config.ReadString('Server', 'LogServerAddr', '') = '' then
    Config.WriteString('Server', 'LogServerAddr', g_Config.sLogServerAddr);
  g_Config.sLogServerAddr := Config.ReadString('Server', 'LogServerAddr', g_Config.sLogServerAddr);

  if Config.ReadInteger('Server', 'LogServerPort', -1) < 0 then
    Config.WriteInteger('Server', 'LogServerPort', g_Config.nLogServerPort);
  g_Config.nLogServerPort := Config.ReadInteger('Server', 'LogServerPort', g_Config.nLogServerPort);

  if Config.ReadString('Server', 'DiscountForNightTime', '') = '' then
    Config.WriteString('Server', 'DiscountForNightTime', BoolToStr(g_Config.boDiscountForNightTime));
  g_Config.boDiscountForNightTime := CompareText(Config.ReadString('Server', 'DiscountForNightTime', 'FALSE'), 'TRUE') = 0;

  if Config.ReadInteger('Server', 'HalfFeeStart', -1) < 0 then
    Config.WriteInteger('Server', 'HalfFeeStart', g_Config.nHalfFeeStart);
  g_Config.nHalfFeeStart := Config.ReadInteger('Server', 'HalfFeeStart', g_Config.nHalfFeeStart);

  if Config.ReadInteger('Server', 'HalfFeeEnd', -1) < 0 then
    Config.WriteInteger('Server', 'HalfFeeEnd', g_Config.nHalfFeeEnd);
  g_Config.nHalfFeeEnd := Config.ReadInteger('Server', 'HalfFeeEnd', g_Config.nHalfFeeEnd);

  if Config.ReadInteger('Server', 'HumLimit', -1) < 0 then
    Config.WriteInteger('Server', 'HumLimit', g_dwHumLimit);
  g_dwHumLimit := Config.ReadInteger('Server', 'HumLimit', g_dwHumLimit);

  if Config.ReadInteger('Server', 'MonLimit', -1) < 0 then
    Config.WriteInteger('Server', 'MonLimit', g_dwMonLimit);
  g_dwMonLimit := Config.ReadInteger('Server', 'MonLimit', g_dwMonLimit);

  if Config.ReadInteger('Server', 'ZenLimit', -1) < 0 then
    Config.WriteInteger('Server', 'ZenLimit', g_dwZenLimit);
  g_dwZenLimit := Config.ReadInteger('Server', 'ZenLimit', g_dwZenLimit);

  if Config.ReadInteger('Server', 'NpcLimit', -1) < 0 then
    Config.WriteInteger('Server', 'NpcLimit', g_dwNpcLimit);
  g_dwNpcLimit := Config.ReadInteger('Server', 'NpcLimit', g_dwNpcLimit);

  if Config.ReadInteger('Server', 'SocLimit', -1) < 15 then
    Config.WriteInteger('Server', 'SocLimit', g_dwSocLimit);
  g_dwSocLimit := Config.ReadInteger('Server', 'SocLimit', g_dwSocLimit);

  if Config.ReadInteger('Server', 'DecLimit', -1) < 0 then
    Config.WriteInteger('Server', 'DecLimit', nDecLimit);
  nDecLimit := Config.ReadInteger('Server', 'DecLimit', nDecLimit);

  if Config.ReadInteger('Server', 'SendBlock', -1) < 0 then
    Config.WriteInteger('Server', 'SendBlock', g_Config.nSendBlock);
  g_Config.nSendBlock := Config.ReadInteger('Server', 'SendBlock', g_Config.nSendBlock);

  if Config.ReadInteger('Server', 'CheckBlock', -1) < 12288 then
    Config.WriteInteger('Server', 'CheckBlock', g_Config.nCheckBlock);
  g_Config.nCheckBlock := Config.ReadInteger('Server', 'CheckBlock', g_Config.nCheckBlock);

  if Config.ReadInteger('Server', 'SocCheckTimeOut', -1) < 0 then
    Config.WriteInteger('Server', 'SocCheckTimeOut', g_dwSocCheckTimeOut);
  g_dwSocCheckTimeOut := Config.ReadInteger('Server', 'SocCheckTimeOut', g_dwSocCheckTimeOut);

  if Config.ReadInteger('Server', 'AvailableBlock', -1) < 0 then
    Config.WriteInteger('Server', 'AvailableBlock', g_Config.nAvailableBlock);
  g_Config.nAvailableBlock := Config.ReadInteger('Server', 'AvailableBlock', g_Config.nAvailableBlock);

  if Config.ReadInteger('Server', 'GateLoad', -1) < 0 then
    Config.WriteInteger('Server', 'GateLoad', g_Config.nGateLoad);
  g_Config.nGateLoad := Config.ReadInteger('Server', 'GateLoad', g_Config.nGateLoad);

  if Config.ReadInteger('Server', 'UserFull', -1) < 0 then
    Config.WriteInteger('Server', 'UserFull', g_Config.nUserFull);
  g_Config.nUserFull := Config.ReadInteger('Server', 'UserFull', g_Config.nUserFull);

  if Config.ReadInteger('Server', 'ZenFastStep', -1) < 0 then
    Config.WriteInteger('Server', 'ZenFastStep', g_Config.nZenFastStep);
  g_Config.nZenFastStep := Config.ReadInteger('Server', 'ZenFastStep', g_Config.nZenFastStep);

  if Config.ReadInteger('Server', 'ProcessMonstersTime', -1) < 0 then
    Config.WriteInteger('Server', 'ProcessMonstersTime', g_Config.dwProcessMonstersTime);
  g_Config.dwProcessMonstersTime := Config.ReadInteger('Server', 'ProcessMonstersTime', g_Config.dwProcessMonstersTime);

  if Config.ReadInteger('Server', 'RegenMonstersTime', -1) < 0 then
    Config.WriteInteger('Server', 'RegenMonstersTime', g_Config.dwRegenMonstersTime);
  g_Config.dwRegenMonstersTime := Config.ReadInteger('Server', 'RegenMonstersTime', g_Config.dwRegenMonstersTime);

  if Config.ReadInteger('Server', 'HumanGetMsgTimeLimit', -1) < 0 then
    Config.WriteInteger('Server', 'HumanGetMsgTimeLimit', g_Config.dwHumanGetMsgTime);
  g_Config.dwHumanGetMsgTime := Config.ReadInteger('Server', 'HumanGetMsgTimeLimit', g_Config.dwHumanGetMsgTime);

  //============================================================================
  //目录设置
  if Config.ReadString('Share', 'BaseDir', '') = '' then
    Config.WriteString('Share', 'BaseDir', g_Config.sBaseDir);
  g_Config.sBaseDir := Config.ReadString('Share', 'BaseDir', g_Config.sBaseDir);

  if Config.ReadString('Share', 'GuildDir', '') = '' then
    Config.WriteString('Share', 'GuildDir', g_Config.sGuildDir);
  g_Config.sGuildDir := Config.ReadString('Share', 'GuildDir', g_Config.sGuildDir);

  if Config.ReadString('Share', 'GuildFile', '') = '' then
    Config.WriteString('Share', 'GuildFile', g_Config.sGuildFile);
  g_Config.sGuildFile := Config.ReadString('Share', 'GuildFile', g_Config.sGuildFile);

  if Config.ReadString('Share', 'VentureDir', '') = '' then
    Config.WriteString('Share', 'VentureDir', g_Config.sVentureDir);
  g_Config.sVentureDir := Config.ReadString('Share', 'VentureDir', g_Config.sVentureDir);

  if Config.ReadString('Share', 'ConLogDir', '') = '' then
    Config.WriteString('Share', 'ConLogDir', g_Config.sConLogDir);
  g_Config.sConLogDir := Config.ReadString('Share', 'ConLogDir', g_Config.sConLogDir);

  if Config.ReadString('Share', 'CastleDir', '') = '' then
    Config.WriteString('Share', 'CastleDir', g_Config.sCastleDir);
  g_Config.sCastleDir := Config.ReadString('Share', 'CastleDir', g_Config.sCastleDir);

  if Config.ReadString('Share', 'CastleFile', '') = '' then
    Config.WriteString('Share', 'CastleFile', g_Config.sCastleDir + 'List.txt');
  g_Config.sCastleFile := Config.ReadString('Share', 'CastleFile', g_Config.sCastleFile);

  if Config.ReadString('Share', 'EnvirDir', '') = '' then
    Config.WriteString('Share', 'EnvirDir', g_Config.sEnvirDir);
  g_Config.sEnvirDir := Config.ReadString('Share', 'EnvirDir', g_Config.sEnvirDir);

  if Config.ReadString('Share', 'MapDir', '') = '' then
    Config.WriteString('Share', 'MapDir', g_Config.sMapDir);
  g_Config.sMapDir := Config.ReadString('Share', 'MapDir', g_Config.sMapDir);

  if Config.ReadString('Share', 'NoticeDir', '') = '' then
    Config.WriteString('Share', 'NoticeDir', g_Config.sNoticeDir);
  g_Config.sNoticeDir := Config.ReadString('Share', 'NoticeDir', g_Config.sNoticeDir);

  sLoadString := Config.ReadString('Share', 'LogDir', '');
  if sLoadString = '' then
    Config.WriteString('Share', 'LogDir', g_Config.sLogDir)
  else
    g_Config.sLogDir := sLoadString;

  if Config.ReadString('Share', 'PlugDir', '') = '' then
    Config.WriteString('Share', 'PlugDir', g_Config.sPlugDir);
  g_Config.sPlugDir := Config.ReadString('Share', 'PlugDir', g_Config.sPlugDir);

  //============================================================================
  //名称设置
  if Config.ReadString('Names', 'HealSkill', '') = '' then
    Config.WriteString('Names', 'HealSkill', g_Config.sHealSkill);
  g_Config.sHealSkill := Config.ReadString('Names', 'HealSkill', g_Config.sHealSkill);

  if Config.ReadString('Names', 'FireBallSkill', '') = '' then
    Config.WriteString('Names', 'FireBallSkill', g_Config.sFireBallSkill);
  g_Config.sFireBallSkill := Config.ReadString('Names', 'FireBallSkill', g_Config.sFireBallSkill);

  if Config.ReadString('Names', 'ClothsMan', '') = '' then
    Config.WriteString('Names', 'ClothsMan', g_Config.sClothsMan);
  g_Config.sClothsMan := Config.ReadString('Names', 'ClothsMan', g_Config.sClothsMan);

  if Config.ReadString('Names', 'ClothsWoman', '') = '' then
    Config.WriteString('Names', 'ClothsWoman', g_Config.sClothsWoman);
  g_Config.sClothsWoman := Config.ReadString('Names', 'ClothsWoman', g_Config.sClothsWoman);

  if Config.ReadString('Names', 'WoodenSword', '') = '' then
    Config.WriteString('Names', 'WoodenSword', g_Config.sWoodenSword);
  g_Config.sWoodenSword := Config.ReadString('Names', 'WoodenSword', g_Config.sWoodenSword);

  if Config.ReadString('Names', 'Candle', '') = '' then
    Config.WriteString('Names', 'Candle', g_Config.sCandle);
  g_Config.sCandle := Config.ReadString('Names', 'Candle', g_Config.sCandle);

  if Config.ReadString('Names', 'BasicDrug', '') = '' then
    Config.WriteString('Names', 'BasicDrug', g_Config.sBasicDrug);
  g_Config.sBasicDrug := Config.ReadString('Names', 'BasicDrug', g_Config.sBasicDrug);

  if Config.ReadString('Names', 'GoldStone', '') = '' then
    Config.WriteString('Names', 'GoldStone', g_Config.sGoldStone);
  g_Config.sGoldStone := Config.ReadString('Names', 'GoldStone', g_Config.sGoldStone);

  if Config.ReadString('Names', 'SilverStone', '') = '' then
    Config.WriteString('Names', 'SilverStone', g_Config.sSilverStone);
  g_Config.sSilverStone := Config.ReadString('Names', 'SilverStone', g_Config.sSilverStone);

  if Config.ReadString('Names', 'SteelStone', '') = '' then
    Config.WriteString('Names', 'SteelStone', g_Config.sSteelStone);
  g_Config.sSteelStone := Config.ReadString('Names', 'SteelStone', g_Config.sSteelStone);

  if Config.ReadString('Names', 'CopperStone', '') = '' then
    Config.WriteString('Names', 'CopperStone', g_Config.sCopperStone);
  g_Config.sCopperStone := Config.ReadString('Names', 'CopperStone', g_Config.sCopperStone);

  if Config.ReadString('Names', 'BlackStone', '') = '' then
    Config.WriteString('Names', 'BlackStone', g_Config.sBlackStone);
  g_Config.sBlackStone := Config.ReadString('Names', 'BlackStone', g_Config.sBlackStone);

  if Config.ReadString('Names', 'Zuma1', '') = '' then
    Config.WriteString('Names', 'Zuma1', g_Config.sZuma[0]);
  g_Config.sZuma[0] := Config.ReadString('Names', 'Zuma1', g_Config.sZuma[0]);

  if Config.ReadString('Names', 'Zuma2', '') = '' then
    Config.WriteString('Names', 'Zuma2', g_Config.sZuma[1]);
  g_Config.sZuma[1] := Config.ReadString('Names', 'Zuma2', g_Config.sZuma[1]);

  if Config.ReadString('Names', 'Zuma3', '') = '' then
    Config.WriteString('Names', 'Zuma3', g_Config.sZuma[2]);
  g_Config.sZuma[2] := Config.ReadString('Names', 'Zuma3', g_Config.sZuma[2]);

  if Config.ReadString('Names', 'Zuma4', '') = '' then
    Config.WriteString('Names', 'Zuma4', g_Config.sZuma[3]);
  g_Config.sZuma[3] := Config.ReadString('Names', 'Zuma4', g_Config.sZuma[3]);

  if Config.ReadString('Names', 'Bee', '') = '' then
    Config.WriteString('Names', 'Bee', g_Config.sBee);
  g_Config.sBee := Config.ReadString('Names', 'Bee', g_Config.sBee);

  if Config.ReadString('Names', 'Spider', '') = '' then
    Config.WriteString('Names', 'Spider', g_Config.sSpider);
  g_Config.sSpider := Config.ReadString('Names', 'Spider', g_Config.sSpider);

  for i := Low(g_Config.sBloodMonSlave) to High(g_Config.sBloodMonSlave) do begin
    if Config.ReadString('Names', 'BloodMonSlave' + IntToStr(i), '') = '' then
      Config.WriteString('Names', 'BloodMonSlave' + IntToStr(i), g_Config.sBloodMonSlave[i]);
    g_Config.sBloodMonSlave[i] := Config.ReadString('Names', 'BloodMonSlave' + IntToStr(i), g_Config.sBloodMonSlave[i]);
  end;

  if Config.ReadString('Names', 'WomaHorn', '') = '' then
    Config.WriteString('Names', 'WomaHorn', g_Config.sWomaHorn);
  g_Config.sWomaHorn := Config.ReadString('Names', 'WomaHorn', g_Config.sWomaHorn);

  if Config.ReadString('Names', 'ZumaPiece', '') = '' then
    Config.WriteString('Names', 'ZumaPiece', g_Config.sZumaPiece);
  g_Config.sZumaPiece := Config.ReadString('Names', 'ZumaPiece', g_Config.sZumaPiece);

  if Config.ReadString('Names', 'Dogz', '') = '' then
    Config.WriteString('Names', 'Dogz', g_Config.sDogz);
  g_Config.sDogz := Config.ReadString('Names', 'Dogz', g_Config.sDogz);

  if Config.ReadString('Names', 'BoneFamm', '') = '' then
    Config.WriteString('Names', 'BoneFamm', g_Config.sBoneFamm);
  g_Config.sBoneFamm := Config.ReadString('Names', 'BoneFamm', g_Config.sBoneFamm);

  if Config.ReadString('Names', 'Body', '') = '' then
    Config.WriteString('Names', 'BoneFamm', g_Config.sBody);
  g_Config.sBody := Config.ReadString('Names', 'Body', g_Config.sBody);

  sLoadString := Config.ReadString('Names', 'GameGold', '');
  if sLoadString = '' then
    Config.WriteString('Names', 'GameGold', g_Config.sGameGoldName)
  else
    g_Config.sGameGoldName := sLoadString;

  sLoadString := Config.ReadString('Names', 'GamePoint', '');
  if sLoadString = '' then
    Config.WriteString('Names', 'GamePoint', g_Config.sGamePointName)
  else
    g_Config.sGamePointName := sLoadString;

  sLoadString := Config.ReadString('Names', 'PayMentPointName', '');
  if sLoadString = '' then
    Config.WriteString('Names', 'PayMentPointName', g_Config.sPayMentPointName)
  else
    g_Config.sPayMentPointName := sLoadString;

  if Config.ReadString('Names', 'HeroName', '') = '' then
    Config.WriteString('Names', 'HeroName', g_Config.sHeroName);
  g_Config.sHeroName := Config.ReadString('Names', 'HeroName', g_Config.sHeroName);

  if Config.ReadString('Names', 'HeroSlaveName', '') = '' then
    Config.WriteString('Names', 'HeroSlaveName', g_Config.sHeroSlaveName);
  g_Config.sHeroSlaveName := Config.ReadString('Names', 'HeroSlaveName', g_Config.sHeroSlaveName);

  if Config.ReadString('Names', 'tiGift_weapon', '') = '' then
    Config.WriteString('Names', 'tiGift_weapon', g_Config.tiGift_weapon);
  g_Config.tiGift_weapon := Config.ReadString('Names', 'tiGift_weapon', g_Config.tiGift_weapon);

  if Config.ReadString('Names', 'tiGift_dress_m', '') = '' then
    Config.WriteString('Names', 'tiGift_dress_m', g_Config.tiGift_dress_m);
  g_Config.tiGift_dress_m := Config.ReadString('Names', 'tiGift_dress_m', g_Config.tiGift_dress_m);

  if Config.ReadString('Names', 'tiGift_dress_w', '') = '' then
    Config.WriteString('Names', 'tiGift_dress_w', g_Config.tiGift_dress_w);
  g_Config.tiGift_dress_w := Config.ReadString('Names', 'tiGift_dress_w', g_Config.tiGift_dress_w);

  if Config.ReadString('Names', 'tiGift_medal', '') = '' then
    Config.WriteString('Names', 'tiGift_medal', g_Config.tiGift_medal);
  g_Config.tiGift_medal := Config.ReadString('Names', 'tiGift_medal', g_Config.tiGift_medal);

  if Config.ReadString('Names', 'tiGift_necklace', '') = '' then
    Config.WriteString('Names', 'tiGift_necklace', g_Config.tiGift_necklace);
  g_Config.tiGift_necklace := Config.ReadString('Names', 'tiGift_necklace', g_Config.tiGift_necklace);

  if Config.ReadString('Names', 'tiGift_helmet', '') = '' then
    Config.WriteString('Names', 'tiGift_helmet', g_Config.tiGift_helmet);
  g_Config.tiGift_helmet := Config.ReadString('Names', 'tiGift_helmet', g_Config.tiGift_helmet);

  if Config.ReadString('Names', 'tiGift_helmetex', '') = '' then
    Config.WriteString('Names', 'tiGift_helmetex', g_Config.tiGift_helmetex);
  g_Config.tiGift_helmetex := Config.ReadString('Names', 'tiGift_helmetex', g_Config.tiGift_helmetex);

  if Config.ReadString('Names', 'tiGift_mask', '') = '' then
    Config.WriteString('Names', 'tiGift_mask', g_Config.tiGift_mask);
  g_Config.tiGift_mask := Config.ReadString('Names', 'tiGift_mask', g_Config.tiGift_mask);

  if Config.ReadString('Names', 'tiGift_armring', '') = '' then
    Config.WriteString('Names', 'tiGift_armring', g_Config.tiGift_armring);
  g_Config.tiGift_armring := Config.ReadString('Names', 'tiGift_armring', g_Config.tiGift_armring);

  if Config.ReadString('Names', 'tiGift_ring', '') = '' then
    Config.WriteString('Names', 'tiGift_ring', g_Config.tiGift_ring);
  g_Config.tiGift_ring := Config.ReadString('Names', 'tiGift_ring', g_Config.tiGift_ring);

  if Config.ReadString('Names', 'tiGift_belt', '') = '' then
    Config.WriteString('Names', 'tiGift_belt', g_Config.tiGift_belt);
  g_Config.tiGift_belt := Config.ReadString('Names', 'tiGift_belt', g_Config.tiGift_belt);

  if Config.ReadString('Names', 'tiGift_boots', '') = '' then
    Config.WriteString('Names', 'tiGift_boots', g_Config.tiGift_boots);
  g_Config.tiGift_boots := Config.ReadString('Names', 'tiGift_boots', g_Config.tiGift_boots);

  if Config.ReadString('Names', 'sSnowMobName1', '') = '' then
    Config.WriteString('Names', 'sSnowMobName1', g_Config.sSnowMobName1);
  g_Config.sSnowMobName1 := Config.ReadString('Names', 'sSnowMobName1', g_Config.sSnowMobName1);

  if Config.ReadString('Names', 'sSnowMobName2', '') = '' then
    Config.WriteString('Names', 'sSnowMobName2', g_Config.sSnowMobName2);
  g_Config.sSnowMobName2 := Config.ReadString('Names', 'sSnowMobName2', g_Config.sSnowMobName2);

  if Config.ReadString('Names', 'sSnowMobName3', '') = '' then
    Config.WriteString('Names', 'sSnowMobName3', g_Config.sSnowMobName3);
  g_Config.sSnowMobName3 := Config.ReadString('Names', 'sSnowMobName3', g_Config.sSnowMobName3);

  //============================================================================
  //游戏设置
  if Config.ReadInteger('Setup', 'ItemNumber', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemNumber', g_Config.nItemNumber);
  g_Config.nItemNumber := Config.ReadInteger('Setup', 'ItemNumber', g_Config.nItemNumber);

  if Config.ReadInteger('Setup', 'ItemNumberEx', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);
  g_Config.nItemNumberEx := Config.ReadInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);

  if Config.ReadString('Setup', 'ClientFile1', '') = '' then
    Config.WriteString('Setup', 'ClientFile1', g_Config.sClientFile1);
  g_Config.sClientFile1 := Config.ReadString('Setup', 'ClientFile1', g_Config.sClientFile1);

  if Config.ReadString('Setup', 'ClientFile2', '') = '' then
    Config.WriteString('Setup', 'ClientFile2', g_Config.sClientFile2);
  g_Config.sClientFile2 := Config.ReadString('Setup', 'ClientFile2', g_Config.sClientFile2);

  if Config.ReadString('Setup', 'ClientFile3', '') = '' then
    Config.WriteString('Setup', 'ClientFile3', g_Config.sClientFile3);
  g_Config.sClientFile3 := Config.ReadString('Setup', 'ClientFile3', g_Config.sClientFile3);

  if Config.ReadInteger('Setup', 'MonUpLvNeedKillBase', -1) < 0 then
    Config.WriteInteger('Setup', 'MonUpLvNeedKillBase', g_Config.nMonUpLvNeedKillBase);
  g_Config.nMonUpLvNeedKillBase := Config.ReadInteger('Setup', 'MonUpLvNeedKillBase', g_Config.nMonUpLvNeedKillBase);

  if Config.ReadInteger('Setup', 'MonUpLvRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MonUpLvRate', g_Config.nMonUpLvRate);
  g_Config.nMonUpLvRate := Config.ReadInteger('Setup', 'MonUpLvRate', g_Config.nMonUpLvRate);

  for i := Low(g_Config.MonUpLvNeedKillCount) to High(g_Config.MonUpLvNeedKillCount) do begin
    if Config.ReadInteger('Setup', 'MonUpLvNeedKillCount' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'MonUpLvNeedKillCount' + IntToStr(i), g_Config.MonUpLvNeedKillCount[i]);
    g_Config.MonUpLvNeedKillCount[i] := Config.ReadInteger('Setup', 'MonUpLvNeedKillCount' + IntToStr(i), g_Config.MonUpLvNeedKillCount[i]);
  end;

  for i := Low(g_Config.SlaveColor) to High(g_Config.SlaveColor) do begin
    if Config.ReadInteger('Setup', 'SlaveColor' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'SlaveColor' + IntToStr(i), g_Config.SlaveColor[i]);
    g_Config.SlaveColor[i] := Config.ReadInteger('Setup', 'SlaveColor' + IntToStr(i), g_Config.SlaveColor[i]);
  end;

  if Config.ReadString('Setup', 'HomeMap', '') = '' then
    Config.WriteString('Setup', 'HomeMap', g_Config.sHomeMap);
  g_Config.sHomeMap := Config.ReadString('Setup', 'HomeMap', g_Config.sHomeMap);

  if Config.ReadInteger('Setup', 'HomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'HomeX', g_Config.nHomeX);
  g_Config.nHomeX := Config.ReadInteger('Setup', 'HomeX', g_Config.nHomeX);

  if Config.ReadInteger('Setup', 'HomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'HomeY', g_Config.nHomeY);
  g_Config.nHomeY := Config.ReadInteger('Setup', 'HomeY', g_Config.nHomeY);

  if Config.ReadString('Setup', 'RedHomeMap', '') = '' then
    Config.WriteString('Setup', 'RedHomeMap', g_Config.sRedHomeMap);
  g_Config.sRedHomeMap := Config.ReadString('Setup', 'RedHomeMap', g_Config.sRedHomeMap);

  if Config.ReadInteger('Setup', 'RedHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'RedHomeX', g_Config.nRedHomeX);
  g_Config.nRedHomeX := Config.ReadInteger('Setup', 'RedHomeX', g_Config.nRedHomeX);

  if Config.ReadInteger('Setup', 'RedHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'RedHomeY', g_Config.nRedHomeY);
  g_Config.nRedHomeY := Config.ReadInteger('Setup', 'RedHomeY', g_Config.nRedHomeY);

  if Config.ReadString('Setup', 'RedDieHomeMap', '') = '' then
    Config.WriteString('Setup', 'RedDieHomeMap', g_Config.sRedDieHomeMap);
  g_Config.sRedDieHomeMap := Config.ReadString('Setup', 'RedDieHomeMap', g_Config.sRedDieHomeMap);

  if Config.ReadInteger('Setup', 'RedDieHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'RedDieHomeX', g_Config.nRedDieHomeX);
  g_Config.nRedDieHomeX := Config.ReadInteger('Setup', 'RedDieHomeX', g_Config.nRedDieHomeX);

  if Config.ReadInteger('Setup', 'RedDieHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'RedDieHomeY', g_Config.nRedDieHomeY);
  g_Config.nRedDieHomeY := Config.ReadInteger('Setup', 'RedDieHomeY',
    g_Config.nRedDieHomeY);

  nLoadInteger := Config.ReadInteger('Setup', 'HealthFillTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HealthFillTime', g_Config.nHealthFillTime)
  else
    g_Config.nHealthFillTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SpellFillTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SpellFillTime', g_Config.nSpellFillTime)
  else
    g_Config.nSpellFillTime := nLoadInteger;

  if Config.ReadInteger('Setup', 'DecPkPointTime', -1) < 0 then
    Config.WriteInteger('Setup', 'DecPkPointTime', g_Config.dwDecPkPointTime);
  g_Config.dwDecPkPointTime := Config.ReadInteger('Setup', 'DecPkPointTime',
    g_Config.dwDecPkPointTime);

  if Config.ReadInteger('Setup', 'DecPkPointCount', -1) < 0 then
    Config.WriteInteger('Setup', 'DecPkPointCount', g_Config.nDecPkPointCount);
  g_Config.nDecPkPointCount := Config.ReadInteger('Setup', 'DecPkPointCount',
    g_Config.nDecPkPointCount);

  if Config.ReadInteger('Setup', 'PKFlagTime', -1) < 0 then
    Config.WriteInteger('Setup', 'PKFlagTime', g_Config.dwPKFlagTime);
  g_Config.dwPKFlagTime := Config.ReadInteger('Setup', 'PKFlagTime',
    g_Config.dwPKFlagTime);

  if Config.ReadInteger('Setup', 'KillHumanAddPKPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanAddPKPoint',
      g_Config.nKillHumanAddPKPoint);
  g_Config.nKillHumanAddPKPoint := Config.ReadInteger('Setup',
    'KillHumanAddPKPoint', g_Config.nKillHumanAddPKPoint);

  if Config.ReadInteger('Setup', 'KillHumanDecLuckPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanDecLuckPoint',
      g_Config.nKillHumanDecLuckPoint);
  g_Config.nKillHumanDecLuckPoint := Config.ReadInteger('Setup',
    'KillHumanDecLuckPoint', g_Config.nKillHumanDecLuckPoint);

  if Config.ReadInteger('Setup', 'DecLightItemDrugTime', -1) < 0 then
    Config.WriteInteger('Setup', 'DecLightItemDrugTime',
      g_Config.dwDecLightItemDrugTime);
  g_Config.dwDecLightItemDrugTime := Config.ReadInteger('Setup',
    'DecLightItemDrugTime', g_Config.dwDecLightItemDrugTime);

  if Config.ReadInteger('Setup', 'SafeZoneSize', -1) < 0 then
    Config.WriteInteger('Setup', 'SafeZoneSize', g_Config.nSafeZoneSize);
  g_Config.nSafeZoneSize := Config.ReadInteger('Setup', 'SafeZoneSize',
    g_Config.nSafeZoneSize);

  if Config.ReadInteger('Setup', 'StartPointSize', -1) < 0 then
    Config.WriteInteger('Setup', 'StartPointSize', g_Config.nStartPointSize);
  g_Config.nStartPointSize := Config.ReadInteger('Setup', 'StartPointSize', g_Config.nStartPointSize);

  if Config.ReadInteger('Setup', 'NonGuildWarZoneSize', -1) < 0 then
    Config.WriteInteger('Setup', 'NonGuildWarZoneSize', g_Config.nNonGuildWarZoneSize);
  g_Config.nNonGuildWarZoneSize := Config.ReadInteger('Setup', 'NonGuildWarZoneSize', g_Config.nNonGuildWarZoneSize);

  if Config.ReadInteger('Setup', 'SafeZoneAureole', -1) < 0 then
    Config.WriteBool('Setup', 'SafeZoneAureole', g_Config.boSafeZoneAureole);
  g_Config.boSafeZoneAureole := Config.ReadBool('Setup', 'SafeZoneAureole', g_Config.boSafeZoneAureole);

  for i := Low(g_Config.ReNewNameColor) to High(g_Config.ReNewNameColor) do begin
    if Config.ReadInteger('Setup', 'ReNewNameColor' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'ReNewNameColor' + IntToStr(i), g_Config.ReNewNameColor[i]);
    g_Config.ReNewNameColor[i] := Config.ReadInteger('Setup', 'ReNewNameColor' + IntToStr(i), g_Config.ReNewNameColor[i]);
  end;

  if Config.ReadInteger('Setup', 'ReNewNameColorTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ReNewNameColorTime', g_Config.dwReNewNameColorTime);
  g_Config.dwReNewNameColorTime := Config.ReadInteger('Setup', 'ReNewNameColorTime', g_Config.dwReNewNameColorTime);

  if Config.ReadInteger('Setup', 'ReNewChangeColor', -1) < 0 then
    Config.WriteBool('Setup', 'ReNewChangeColor', g_Config.boReNewChangeColor);
  g_Config.boReNewChangeColor := Config.ReadBool('Setup', 'ReNewChangeColor', g_Config.boReNewChangeColor);

  if Config.ReadInteger('Setup', 'ReNewChangeColorLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'ReNewChangeColorLevel', g_Config.btReNewChangeColorLevel);
  g_Config.btReNewChangeColorLevel := Config.ReadInteger('Setup', 'ReNewChangeColorLevel', g_Config.btReNewChangeColorLevel);

  if Config.ReadInteger('Setup', 'ReNewLevelClearExp', -1) < 0 then
    Config.WriteBool('Setup', 'ReNewLevelClearExp', g_Config.boReNewLevelClearExp);
  g_Config.boReNewLevelClearExp := Config.ReadBool('Setup', 'ReNewLevelClearExp', g_Config.boReNewLevelClearExp);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrDC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrDC', g_Config.BonusAbilofWarr.DC);
  g_Config.BonusAbilofWarr.DC := Config.ReadInteger('Setup', 'BonusAbilofWarrDC', g_Config.BonusAbilofWarr.DC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrMC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrMC', g_Config.BonusAbilofWarr.MC);
  g_Config.BonusAbilofWarr.MC := Config.ReadInteger('Setup', 'BonusAbilofWarrMC', g_Config.BonusAbilofWarr.MC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrSC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrSC', g_Config.BonusAbilofWarr.SC);
  g_Config.BonusAbilofWarr.SC := Config.ReadInteger('Setup', 'BonusAbilofWarrSC', g_Config.BonusAbilofWarr.SC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrAC', g_Config.BonusAbilofWarr.AC);
  g_Config.BonusAbilofWarr.AC := Config.ReadInteger('Setup', 'BonusAbilofWarrAC', g_Config.BonusAbilofWarr.AC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrMAC', g_Config.BonusAbilofWarr.MAC);
  g_Config.BonusAbilofWarr.MAC := Config.ReadInteger('Setup', 'BonusAbilofWarrMAC', g_Config.BonusAbilofWarr.MAC);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrHP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrHP', g_Config.BonusAbilofWarr.HP);
  g_Config.BonusAbilofWarr.HP := Config.ReadInteger('Setup', 'BonusAbilofWarrHP', g_Config.BonusAbilofWarr.HP);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrMP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrMP', g_Config.BonusAbilofWarr.MP);
  g_Config.BonusAbilofWarr.MP := Config.ReadInteger('Setup', 'BonusAbilofWarrMP', g_Config.BonusAbilofWarr.MP);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrHit', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrHit', g_Config.BonusAbilofWarr.HIT);
  g_Config.BonusAbilofWarr.HIT := Config.ReadInteger('Setup', 'BonusAbilofWarrHit', g_Config.BonusAbilofWarr.HIT);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrSpeed', g_Config.BonusAbilofWarr.Speed);
  g_Config.BonusAbilofWarr.Speed := Config.ReadInteger('Setup', 'BonusAbilofWarrSpeed', g_Config.BonusAbilofWarr.Speed);

  if Config.ReadInteger('Setup', 'BonusAbilofWarrX2', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWarrX2', g_Config.BonusAbilofWarr.X2);
  g_Config.BonusAbilofWarr.X2 := Config.ReadInteger('Setup', 'BonusAbilofWarrX2', g_Config.BonusAbilofWarr.X2);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardDC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardDC', g_Config.BonusAbilofWizard.DC);
  g_Config.BonusAbilofWizard.DC := Config.ReadInteger('Setup', 'BonusAbilofWizardDC', g_Config.BonusAbilofWizard.DC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardMC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardMC',
      g_Config.BonusAbilofWizard.MC);
  g_Config.BonusAbilofWizard.MC := Config.ReadInteger('Setup',
    'BonusAbilofWizardMC', g_Config.BonusAbilofWizard.MC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardSC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardSC',
      g_Config.BonusAbilofWizard.SC);
  g_Config.BonusAbilofWizard.SC := Config.ReadInteger('Setup',
    'BonusAbilofWizardSC', g_Config.BonusAbilofWizard.SC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardAC',
      g_Config.BonusAbilofWizard.AC);
  g_Config.BonusAbilofWizard.AC := Config.ReadInteger('Setup',
    'BonusAbilofWizardAC', g_Config.BonusAbilofWizard.AC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardMAC',
      g_Config.BonusAbilofWizard.MAC);
  g_Config.BonusAbilofWizard.MAC := Config.ReadInteger('Setup',
    'BonusAbilofWizardMAC', g_Config.BonusAbilofWizard.MAC);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardHP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardHP',
      g_Config.BonusAbilofWizard.HP);
  g_Config.BonusAbilofWizard.HP := Config.ReadInteger('Setup',
    'BonusAbilofWizardHP', g_Config.BonusAbilofWizard.HP);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardMP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardMP',
      g_Config.BonusAbilofWizard.MP);
  g_Config.BonusAbilofWizard.MP := Config.ReadInteger('Setup',
    'BonusAbilofWizardMP', g_Config.BonusAbilofWizard.MP);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardHit', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardHit',
      g_Config.BonusAbilofWizard.HIT);
  g_Config.BonusAbilofWizard.HIT := Config.ReadInteger('Setup',
    'BonusAbilofWizardHit', g_Config.BonusAbilofWizard.HIT);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardSpeed',
      g_Config.BonusAbilofWizard.Speed);
  g_Config.BonusAbilofWizard.Speed := Config.ReadInteger('Setup',
    'BonusAbilofWizardSpeed', g_Config.BonusAbilofWizard.Speed);

  if Config.ReadInteger('Setup', 'BonusAbilofWizardX2', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofWizardX2',
      g_Config.BonusAbilofWizard.X2);
  g_Config.BonusAbilofWizard.X2 := Config.ReadInteger('Setup',
    'BonusAbilofWizardX2', g_Config.BonusAbilofWizard.X2);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosDC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosDC',
      g_Config.BonusAbilofTaos.DC);
  g_Config.BonusAbilofTaos.DC := Config.ReadInteger('Setup',
    'BonusAbilofTaosDC', g_Config.BonusAbilofTaos.DC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosMC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosMC',
      g_Config.BonusAbilofTaos.MC);
  g_Config.BonusAbilofTaos.MC := Config.ReadInteger('Setup',
    'BonusAbilofTaosMC', g_Config.BonusAbilofTaos.MC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosSC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosSC',
      g_Config.BonusAbilofTaos.SC);
  g_Config.BonusAbilofTaos.SC := Config.ReadInteger('Setup',
    'BonusAbilofTaosSC', g_Config.BonusAbilofTaos.SC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosAC',
      g_Config.BonusAbilofTaos.AC);
  g_Config.BonusAbilofTaos.AC := Config.ReadInteger('Setup',
    'BonusAbilofTaosAC', g_Config.BonusAbilofTaos.AC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosMAC',
      g_Config.BonusAbilofTaos.MAC);
  g_Config.BonusAbilofTaos.MAC := Config.ReadInteger('Setup',
    'BonusAbilofTaosMAC', g_Config.BonusAbilofTaos.MAC);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosHP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosHP',
      g_Config.BonusAbilofTaos.HP);
  g_Config.BonusAbilofTaos.HP := Config.ReadInteger('Setup',
    'BonusAbilofTaosHP', g_Config.BonusAbilofTaos.HP);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosMP', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosMP',
      g_Config.BonusAbilofTaos.MP);
  g_Config.BonusAbilofTaos.MP := Config.ReadInteger('Setup',
    'BonusAbilofTaosMP', g_Config.BonusAbilofTaos.MP);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosHit', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosHit',
      g_Config.BonusAbilofTaos.HIT);
  g_Config.BonusAbilofTaos.HIT := Config.ReadInteger('Setup',
    'BonusAbilofTaosHit', g_Config.BonusAbilofTaos.HIT);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosSpeed',
      g_Config.BonusAbilofTaos.Speed);
  g_Config.BonusAbilofTaos.Speed := Config.ReadInteger('Setup',
    'BonusAbilofTaosSpeed', g_Config.BonusAbilofTaos.Speed);

  if Config.ReadInteger('Setup', 'BonusAbilofTaosX2', -1) < 0 then
    Config.WriteInteger('Setup', 'BonusAbilofTaosX2',
      g_Config.BonusAbilofTaos.X2);
  g_Config.BonusAbilofTaos.X2 := Config.ReadInteger('Setup',
    'BonusAbilofTaosX2', g_Config.BonusAbilofTaos.X2);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrDC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrDC',
      g_Config.NakedAbilofWarr.DC);
  g_Config.NakedAbilofWarr.DC := Config.ReadInteger('Setup',
    'NakedAbilofWarrDC', g_Config.NakedAbilofWarr.DC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrMC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrMC',
      g_Config.NakedAbilofWarr.MC);
  g_Config.NakedAbilofWarr.MC := Config.ReadInteger('Setup',
    'NakedAbilofWarrMC', g_Config.NakedAbilofWarr.MC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrSC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrSC',
      g_Config.NakedAbilofWarr.SC);
  g_Config.NakedAbilofWarr.SC := Config.ReadInteger('Setup',
    'NakedAbilofWarrSC', g_Config.NakedAbilofWarr.SC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrAC',
      g_Config.NakedAbilofWarr.AC);
  g_Config.NakedAbilofWarr.AC := Config.ReadInteger('Setup',
    'NakedAbilofWarrAC', g_Config.NakedAbilofWarr.AC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrMAC',
      g_Config.NakedAbilofWarr.MAC);
  g_Config.NakedAbilofWarr.MAC := Config.ReadInteger('Setup',
    'NakedAbilofWarrMAC', g_Config.NakedAbilofWarr.MAC);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrHP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrHP',
      g_Config.NakedAbilofWarr.HP);
  g_Config.NakedAbilofWarr.HP := Config.ReadInteger('Setup',
    'NakedAbilofWarrHP', g_Config.NakedAbilofWarr.HP);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrMP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrMP',
      g_Config.NakedAbilofWarr.MP);
  g_Config.NakedAbilofWarr.MP := Config.ReadInteger('Setup',
    'NakedAbilofWarrMP', g_Config.NakedAbilofWarr.MP);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrHit', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrHit',
      g_Config.NakedAbilofWarr.HIT);
  g_Config.NakedAbilofWarr.HIT := Config.ReadInteger('Setup',
    'NakedAbilofWarrHit', g_Config.NakedAbilofWarr.HIT);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrSpeed',
      g_Config.NakedAbilofWarr.Speed);
  g_Config.NakedAbilofWarr.Speed := Config.ReadInteger('Setup',
    'NakedAbilofWarrSpeed', g_Config.NakedAbilofWarr.Speed);

  if Config.ReadInteger('Setup', 'NakedAbilofWarrX2', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWarrX2',
      g_Config.NakedAbilofWarr.X2);
  g_Config.NakedAbilofWarr.X2 := Config.ReadInteger('Setup',
    'NakedAbilofWarrX2', g_Config.NakedAbilofWarr.X2);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardDC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardDC',
      g_Config.NakedAbilofWizard.DC);
  g_Config.NakedAbilofWizard.DC := Config.ReadInteger('Setup',
    'NakedAbilofWizardDC', g_Config.NakedAbilofWizard.DC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardMC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardMC',
      g_Config.NakedAbilofWizard.MC);
  g_Config.NakedAbilofWizard.MC := Config.ReadInteger('Setup',
    'NakedAbilofWizardMC', g_Config.NakedAbilofWizard.MC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardSC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardSC',
      g_Config.NakedAbilofWizard.SC);
  g_Config.NakedAbilofWizard.SC := Config.ReadInteger('Setup',
    'NakedAbilofWizardSC', g_Config.NakedAbilofWizard.SC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardAC',
      g_Config.NakedAbilofWizard.AC);
  g_Config.NakedAbilofWizard.AC := Config.ReadInteger('Setup',
    'NakedAbilofWizardAC', g_Config.NakedAbilofWizard.AC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardMAC',
      g_Config.NakedAbilofWizard.MAC);
  g_Config.NakedAbilofWizard.MAC := Config.ReadInteger('Setup',
    'NakedAbilofWizardMAC', g_Config.NakedAbilofWizard.MAC);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardHP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardHP',
      g_Config.NakedAbilofWizard.HP);
  g_Config.NakedAbilofWizard.HP := Config.ReadInteger('Setup',
    'NakedAbilofWizardHP', g_Config.NakedAbilofWizard.HP);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardMP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardMP',
      g_Config.NakedAbilofWizard.MP);
  g_Config.NakedAbilofWizard.MP := Config.ReadInteger('Setup',
    'NakedAbilofWizardMP', g_Config.NakedAbilofWizard.MP);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardHit', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardHit',
      g_Config.NakedAbilofWizard.HIT);
  g_Config.NakedAbilofWizard.HIT := Config.ReadInteger('Setup',
    'NakedAbilofWizardHit', g_Config.NakedAbilofWizard.HIT);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardSpeed',
      g_Config.NakedAbilofWizard.Speed);
  g_Config.NakedAbilofWizard.Speed := Config.ReadInteger('Setup',
    'NakedAbilofWizardSpeed', g_Config.NakedAbilofWizard.Speed);

  if Config.ReadInteger('Setup', 'NakedAbilofWizardX2', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofWizardX2',
      g_Config.NakedAbilofWizard.X2);
  g_Config.NakedAbilofWizard.X2 := Config.ReadInteger('Setup',
    'NakedAbilofWizardX2', g_Config.NakedAbilofWizard.X2);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosDC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosDC',
      g_Config.NakedAbilofTaos.DC);
  g_Config.NakedAbilofTaos.DC := Config.ReadInteger('Setup',
    'NakedAbilofTaosDC', g_Config.NakedAbilofTaos.DC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosMC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosMC',
      g_Config.NakedAbilofTaos.MC);
  g_Config.NakedAbilofTaos.MC := Config.ReadInteger('Setup',
    'NakedAbilofTaosMC', g_Config.NakedAbilofTaos.MC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosSC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosSC',
      g_Config.NakedAbilofTaos.SC);
  g_Config.NakedAbilofTaos.SC := Config.ReadInteger('Setup',
    'NakedAbilofTaosSC', g_Config.NakedAbilofTaos.SC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosAC',
      g_Config.NakedAbilofTaos.AC);
  g_Config.NakedAbilofTaos.AC := Config.ReadInteger('Setup',
    'NakedAbilofTaosAC', g_Config.NakedAbilofTaos.AC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosMAC', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosMAC',
      g_Config.NakedAbilofTaos.MAC);
  g_Config.NakedAbilofTaos.MAC := Config.ReadInteger('Setup',
    'NakedAbilofTaosMAC', g_Config.NakedAbilofTaos.MAC);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosHP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosHP',
      g_Config.NakedAbilofTaos.HP);
  g_Config.NakedAbilofTaos.HP := Config.ReadInteger('Setup',
    'NakedAbilofTaosHP', g_Config.NakedAbilofTaos.HP);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosMP', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosMP',
      g_Config.NakedAbilofTaos.MP);
  g_Config.NakedAbilofTaos.MP := Config.ReadInteger('Setup',
    'NakedAbilofTaosMP', g_Config.NakedAbilofTaos.MP);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosHit', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosHit',
      g_Config.NakedAbilofTaos.HIT);
  g_Config.NakedAbilofTaos.HIT := Config.ReadInteger('Setup',
    'NakedAbilofTaosHit', g_Config.NakedAbilofTaos.HIT);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosSpeed',
      g_Config.NakedAbilofTaos.Speed);
  g_Config.NakedAbilofTaos.Speed := Config.ReadInteger('Setup',
    'NakedAbilofTaosSpeed', g_Config.NakedAbilofTaos.Speed);

  if Config.ReadInteger('Setup', 'NakedAbilofTaosX2', -1) < 0 then
    Config.WriteInteger('Setup', 'NakedAbilofTaosX2',
      g_Config.NakedAbilofTaos.X2);
  g_Config.NakedAbilofTaos.X2 := Config.ReadInteger('Setup',
    'NakedAbilofTaosX2', g_Config.NakedAbilofTaos.X2);

  if Config.ReadInteger('Setup', 'GroupMembersMax', -1) < 0 then
    Config.WriteInteger('Setup', 'GroupMembersMax', g_Config.nGroupMembersMax);
  g_Config.nGroupMembersMax := Config.ReadInteger('Setup', 'GroupMembersMax',
    g_Config.nGroupMembersMax);

  if Config.ReadInteger('Setup', 'UPgradeWeaponGetBackTime', -1) < 0 then
    Config.WriteInteger('Setup', 'UPgradeWeaponGetBackTime',
      g_Config.dwUPgradeWeaponGetBackTime);
  g_Config.dwUPgradeWeaponGetBackTime := Config.ReadInteger('Setup',
    'UPgradeWeaponGetBackTime', g_Config.dwUPgradeWeaponGetBackTime);

  if Config.ReadInteger('Setup', 'ClearExpireUpgradeWeaponDays', -1) < 0 then
    Config.WriteInteger('Setup', 'ClearExpireUpgradeWeaponDays',
      g_Config.nClearExpireUpgradeWeaponDays);
  g_Config.nClearExpireUpgradeWeaponDays := Config.ReadInteger('Setup',
    'ClearExpireUpgradeWeaponDays', g_Config.nClearExpireUpgradeWeaponDays);

  if Config.ReadInteger('Setup', 'UpgradeWeaponPrice', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponPrice',
      g_Config.nUpgradeWeaponPrice);
  g_Config.nUpgradeWeaponPrice := Config.ReadInteger('Setup',
    'UpgradeWeaponPrice', g_Config.nUpgradeWeaponPrice);

  if Config.ReadInteger('Setup', 'UpgradeWeaponMaxPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponMaxPoint',
      g_Config.nUpgradeWeaponMaxPoint);
  g_Config.nUpgradeWeaponMaxPoint := Config.ReadInteger('Setup',
    'UpgradeWeaponMaxPoint', g_Config.nUpgradeWeaponMaxPoint);

  if Config.ReadInteger('Setup', 'UpgradeWeaponDCRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponDCRate',
      g_Config.nUpgradeWeaponDCRate);
  g_Config.nUpgradeWeaponDCRate := Config.ReadInteger('Setup',
    'UpgradeWeaponDCRate', g_Config.nUpgradeWeaponDCRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponDCTwoPointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponDCTwoPointRate',
      g_Config.nUpgradeWeaponDCTwoPointRate);
  g_Config.nUpgradeWeaponDCTwoPointRate := Config.ReadInteger('Setup',
    'UpgradeWeaponDCTwoPointRate', g_Config.nUpgradeWeaponDCTwoPointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponDCThreePointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponDCThreePointRate',
      g_Config.nUpgradeWeaponDCThreePointRate);
  g_Config.nUpgradeWeaponDCThreePointRate := Config.ReadInteger('Setup',
    'UpgradeWeaponDCThreePointRate', g_Config.nUpgradeWeaponDCThreePointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponMCRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponMCRate',
      g_Config.nUpgradeWeaponMCRate);
  g_Config.nUpgradeWeaponMCRate := Config.ReadInteger('Setup',
    'UpgradeWeaponMCRate', g_Config.nUpgradeWeaponMCRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponMCTwoPointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponMCTwoPointRate',
      g_Config.nUpgradeWeaponMCTwoPointRate);
  g_Config.nUpgradeWeaponMCTwoPointRate := Config.ReadInteger('Setup',
    'UpgradeWeaponMCTwoPointRate', g_Config.nUpgradeWeaponMCTwoPointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponMCThreePointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponMCThreePointRate',
      g_Config.nUpgradeWeaponMCThreePointRate);
  g_Config.nUpgradeWeaponMCThreePointRate := Config.ReadInteger('Setup',
    'UpgradeWeaponMCThreePointRate', g_Config.nUpgradeWeaponMCThreePointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponSCRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponSCRate',
      g_Config.nUpgradeWeaponSCRate);
  g_Config.nUpgradeWeaponSCRate := Config.ReadInteger('Setup',
    'UpgradeWeaponSCRate', g_Config.nUpgradeWeaponSCRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponSCTwoPointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponSCTwoPointRate',
      g_Config.nUpgradeWeaponSCTwoPointRate);
  g_Config.nUpgradeWeaponSCTwoPointRate := Config.ReadInteger('Setup',
    'UpgradeWeaponSCTwoPointRate', g_Config.nUpgradeWeaponSCTwoPointRate);

  if Config.ReadInteger('Setup', 'UpgradeWeaponSCThreePointRate', -1) < 0 then
    Config.WriteInteger('Setup', 'UpgradeWeaponSCThreePointRate',
      g_Config.nUpgradeWeaponSCThreePointRate);
  g_Config.nUpgradeWeaponSCThreePointRate := Config.ReadInteger('Setup',
    'UpgradeWeaponSCThreePointRate', g_Config.nUpgradeWeaponSCThreePointRate);

  if Config.ReadInteger('Setup', 'BuildGuild', -1) < 0 then
    Config.WriteInteger('Setup', 'BuildGuild', g_Config.nBuildGuildPrice);
  g_Config.nBuildGuildPrice := Config.ReadInteger('Setup', 'BuildGuild',
    g_Config.nBuildGuildPrice);

  if Config.ReadInteger('Setup', 'MakeDurg', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeDurg', g_Config.nMakeDurgPrice);
  g_Config.nMakeDurgPrice := Config.ReadInteger('Setup', 'MakeDurg',
    g_Config.nMakeDurgPrice);

  if Config.ReadInteger('Setup', 'GuildWarFee', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildWarFee', g_Config.nGuildWarPrice);
  g_Config.nGuildWarPrice := Config.ReadInteger('Setup', 'GuildWarFee',
    g_Config.nGuildWarPrice);

  if Config.ReadInteger('Setup', 'HireGuard', -1) < 0 then
    Config.WriteInteger('Setup', 'HireGuard', g_Config.nHireGuardPrice);
  g_Config.nHireGuardPrice := Config.ReadInteger('Setup', 'HireGuard',
    g_Config.nHireGuardPrice);

  if Config.ReadInteger('Setup', 'HireArcher', -1) < 0 then
    Config.WriteInteger('Setup', 'HireArcher', g_Config.nHireArcherPrice);
  g_Config.nHireArcherPrice := Config.ReadInteger('Setup', 'HireArcher',
    g_Config.nHireArcherPrice);

  if Config.ReadInteger('Setup', 'RepairDoor', -1) < 0 then
    Config.WriteInteger('Setup', 'RepairDoor', g_Config.nRepairDoorPrice);
  g_Config.nRepairDoorPrice := Config.ReadInteger('Setup', 'RepairDoor',
    g_Config.nRepairDoorPrice);

  if Config.ReadInteger('Setup', 'RepairWall', -1) < 0 then
    Config.WriteInteger('Setup', 'RepairWall', g_Config.nRepairWallPrice);
  g_Config.nRepairWallPrice := Config.ReadInteger('Setup', 'RepairWall',
    g_Config.nRepairWallPrice);

  if Config.ReadInteger('Setup', 'CastleMemberPriceRate', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleMemberPriceRate',
      g_Config.nCastleMemberPriceRate);
  g_Config.nCastleMemberPriceRate := Config.ReadInteger('Setup',
    'CastleMemberPriceRate', g_Config.nCastleMemberPriceRate);

  if Config.ReadInteger('Setup', 'CastleGoldMax', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleGoldMax', g_Config.nCastleGoldMax);
  g_Config.nCastleGoldMax := Config.ReadInteger('Setup', 'CastleGoldMax',
    g_Config.nCastleGoldMax);

  if Config.ReadInteger('Setup', 'CastleOneDayGold', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleOneDayGold',
      g_Config.nCastleOneDayGold);
  g_Config.nCastleOneDayGold := Config.ReadInteger('Setup', 'CastleOneDayGold',
    g_Config.nCastleOneDayGold);

  if Config.ReadString('Setup', 'CastleName', '') = '' then
    Config.WriteString('Setup', 'CastleName', g_Config.sCASTLENAME);
  g_Config.sCASTLENAME := Config.ReadString('Setup', 'CastleName',
    g_Config.sCASTLENAME);

  if Config.ReadString('Setup', 'CastleHomeMap', '') = '' then
    Config.WriteString('Setup', 'CastleHomeMap', g_Config.sCastleHomeMap);
  g_Config.sCastleHomeMap := Config.ReadString('Setup', 'CastleHomeMap',
    g_Config.sCastleHomeMap);

  if Config.ReadInteger('Setup', 'CastleHomeX', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleHomeX', g_Config.nCastleHomeX);
  g_Config.nCastleHomeX := Config.ReadInteger('Setup', 'CastleHomeX',
    g_Config.nCastleHomeX);

  if Config.ReadInteger('Setup', 'CastleHomeY', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleHomeY', g_Config.nCastleHomeY);
  g_Config.nCastleHomeY := Config.ReadInteger('Setup', 'CastleHomeY',
    g_Config.nCastleHomeY);

  if Config.ReadInteger('Setup', 'CastleWarRangeX', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleWarRangeX', g_Config.nCastleWarRangeX);
  g_Config.nCastleWarRangeX := Config.ReadInteger('Setup', 'CastleWarRangeX',
    g_Config.nCastleWarRangeX);

  if Config.ReadInteger('Setup', 'CastleWarRangeY', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleWarRangeY', g_Config.nCastleWarRangeY);
  g_Config.nCastleWarRangeY := Config.ReadInteger('Setup', 'CastleWarRangeY',
    g_Config.nCastleWarRangeY);

  if Config.ReadInteger('Setup', 'CastleTaxRate', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleTaxRate', g_Config.nCastleTaxRate);
  g_Config.nCastleTaxRate := Config.ReadInteger('Setup', 'CastleTaxRate',
    g_Config.nCastleTaxRate);

  if Config.ReadInteger('Setup', 'CastleGetAllNpcTax', -1) < 0 then
    Config.WriteBool('Setup', 'CastleGetAllNpcTax', g_Config.boGetAllNpcTax);
  g_Config.boGetAllNpcTax := Config.ReadBool('Setup', 'CastleGetAllNpcTax',
    g_Config.boGetAllNpcTax);

  nLoadInteger := Config.ReadInteger('Setup', 'GenMonRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GenMonRate', g_Config.nMonGenRate)
  else
    g_Config.nMonGenRate := nLoadInteger;
  if g_Config.nMonGenRate <= 0 then
    g_Config.nMonGenRate := 1;

  nLoadInteger := Config.ReadInteger('Setup', 'ProcessMonRandRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ProcessMonRandRate',
      g_Config.nProcessMonRandRate)
  else
    g_Config.nProcessMonRandRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'ProcessMonLimitCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ProcessMonLimitCount',
      g_Config.nProcessMonLimitCount)
  else
    g_Config.nProcessMonLimitCount := nLoadInteger;

  if Config.ReadInteger('Setup', 'HumanMaxGold', -1) < 0 then
    Config.WriteInteger('Setup', 'HumanMaxGold', g_Config.nHumanMaxGold);
  g_Config.nHumanMaxGold := Config.ReadInteger('Setup', 'HumanMaxGold',
    g_Config.nHumanMaxGold);

  if Config.ReadInteger('Setup', 'HumanTryModeMaxGold', -1) < 0 then
    Config.WriteInteger('Setup', 'HumanTryModeMaxGold',
      g_Config.nHumanTryModeMaxGold);
  g_Config.nHumanTryModeMaxGold := Config.ReadInteger('Setup',
    'HumanTryModeMaxGold', g_Config.nHumanTryModeMaxGold);

  if Config.ReadInteger('Setup', 'TryModeLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'TryModeLevel', g_Config.nTryModeLevel);
  g_Config.nTryModeLevel := Config.ReadInteger('Setup', 'TryModeLevel',
    g_Config.nTryModeLevel);

  if Config.ReadInteger('Setup', 'TryModeUseStorage', -1) < 0 then
    Config.WriteBool('Setup', 'TryModeUseStorage',
      g_Config.boTryModeUseStorage);
  g_Config.boTryModeUseStorage := Config.ReadBool('Setup', 'TryModeUseStorage',
    g_Config.boTryModeUseStorage);

  if Config.ReadInteger('Setup', 'ShutRedMsgShowGMName', -1) < 0 then
    Config.WriteBool('Setup', 'ShutRedMsgShowGMName',
      g_Config.boShutRedMsgShowGMName);
  g_Config.boShutRedMsgShowGMName := Config.ReadBool('Setup',
    'ShutRedMsgShowGMName', g_Config.boShutRedMsgShowGMName);

  if Config.ReadInteger('Setup', 'ShowMakeItemMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ShowMakeItemMsg', g_Config.boShowMakeItemMsg);
  g_Config.boShowMakeItemMsg := Config.ReadBool('Setup', 'ShowMakeItemMsg',
    g_Config.boShowMakeItemMsg);

  if Config.ReadInteger('Setup', 'ShowGuildName', -1) < 0 then
    Config.WriteBool('Setup', 'ShowGuildName', g_Config.boShowGuildName);
  g_Config.boShowGuildName := Config.ReadBool('Setup', 'ShowGuildName',
    g_Config.boShowGuildName);

  if Config.ReadInteger('Setup', 'ShowRankLevelName', -1) < 0 then
    Config.WriteBool('Setup', 'ShowRankLevelName',
      g_Config.boShowRankLevelName);
  g_Config.boShowRankLevelName := Config.ReadBool('Setup', 'ShowRankLevelName',
    g_Config.boShowRankLevelName);

  if Config.ReadInteger('Setup', 'MonSayMsg', -1) < 0 then
    Config.WriteBool('Setup', 'MonSayMsg', g_Config.boMonSayMsg);
  g_Config.boMonSayMsg := Config.ReadBool('Setup', 'MonSayMsg',
    g_Config.boMonSayMsg);

  if Config.ReadInteger('Setup', 'SayMsgMaxLen', -1) < 0 then
    Config.WriteInteger('Setup', 'SayMsgMaxLen', g_Config.nSayMsgMaxLen);
  g_Config.nSayMsgMaxLen := Config.ReadInteger('Setup', 'SayMsgMaxLen',
    g_Config.nSayMsgMaxLen);

  if Config.ReadInteger('Setup', 'SayMsgTime', -1) < 0 then
    Config.WriteInteger('Setup', 'SayMsgTime', g_Config.dwSayMsgTime);
  g_Config.dwSayMsgTime := Config.ReadInteger('Setup', 'SayMsgTime',
    g_Config.dwSayMsgTime);

  if Config.ReadInteger('Setup', 'SayMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'SayMsgCount', g_Config.nSayMsgCount);
  g_Config.nSayMsgCount := Config.ReadInteger('Setup', 'SayMsgCount',
    g_Config.nSayMsgCount);

  if Config.ReadInteger('Setup', 'DisableSayMsgTime', -1) < 0 then
    Config.WriteInteger('Setup', 'DisableSayMsgTime',
      g_Config.dwDisableSayMsgTime);
  g_Config.dwDisableSayMsgTime := Config.ReadInteger('Setup',
    'DisableSayMsgTime', g_Config.dwDisableSayMsgTime);

  if Config.ReadInteger('Setup', 'SayRedMsgMaxLen', -1) < 0 then
    Config.WriteInteger('Setup', 'SayRedMsgMaxLen', g_Config.nSayRedMsgMaxLen);
  g_Config.nSayRedMsgMaxLen := Config.ReadInteger('Setup', 'SayRedMsgMaxLen', g_Config.nSayRedMsgMaxLen);

  if Config.ReadInteger('Setup', 'CanShoutMsgLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'CanShoutMsgLevel', g_Config.nCanShoutMsgLevel);
  g_Config.nCanShoutMsgLevel := Config.ReadInteger('Setup', 'CanShoutMsgLevel', g_Config.nCanShoutMsgLevel);

  if Config.ReadInteger('Setup', 'StartPermission', -1) < 0 then
    Config.WriteInteger('Setup', 'StartPermission', g_Config.nStartPermission);
  g_Config.nStartPermission := Config.ReadInteger('Setup', 'StartPermission', g_Config.nStartPermission);

  if Config.ReadInteger('Setup', 'SendRefMsgRange', -1) < 0 then
    Config.WriteInteger('Setup', 'SendRefMsgRange', g_Config.nSendRefMsgRange);
  g_Config.nSendRefMsgRange := Config.ReadInteger('Setup', 'SendRefMsgRange', g_Config.nSendRefMsgRange);
  if g_Config.nSendRefMsgRange <> 12 then begin
    g_Config.nSendRefMsgRange := 12;
    Config.WriteInteger('Setup', 'SendRefMsgRange', g_Config.nSendRefMsgRange);
  end;

  if Config.ReadInteger('Setup', 'DecLampDura', -1) < 0 then
    Config.WriteBool('Setup', 'DecLampDura', g_Config.boDecLampDura);
  g_Config.boDecLampDura := Config.ReadBool('Setup', 'DecLampDura', g_Config.boDecLampDura);

  if Config.ReadInteger('Setup', 'HungerSystem', -1) < 0 then
    Config.WriteBool('Setup', 'HungerSystem', g_Config.boHungerSystem);
  g_Config.boHungerSystem := Config.ReadBool('Setup', 'HungerSystem', g_Config.boHungerSystem);

  if Config.ReadInteger('Setup', 'HungerDecHP', -1) < 0 then
    Config.WriteBool('Setup', 'HungerDecHP', g_Config.boHungerDecHP);
  g_Config.boHungerDecHP := Config.ReadBool('Setup', 'HungerDecHP', g_Config.boHungerDecHP);

  if Config.ReadInteger('Setup', 'HungerDecPower', -1) < 0 then
    Config.WriteBool('Setup', 'HungerDecPower', g_Config.boHungerDecPower);
  g_Config.boHungerDecPower := Config.ReadBool('Setup', 'HungerDecPower',
    g_Config.boHungerDecPower);

  if Config.ReadInteger('Setup', 'DiableHumanRun', -1) < 0 then
    Config.WriteBool('Setup', 'DiableHumanRun', g_Config.boDiableHumanRun);
  g_Config.boDiableHumanRun := Config.ReadBool('Setup', 'DiableHumanRun',
    g_Config.boDiableHumanRun);

  if Config.ReadInteger('Setup', 'RunHuman', -1) < 0 then
    Config.WriteBool('Setup', 'RunHuman', g_Config.boRUNHUMAN);
  g_Config.boRUNHUMAN := Config.ReadBool('Setup', 'RunHuman',
    g_Config.boRUNHUMAN);

  if Config.ReadInteger('Setup', 'RunMon', -1) < 0 then
    Config.WriteBool('Setup', 'RunMon', g_Config.boRUNMON);
  g_Config.boRUNMON := Config.ReadBool('Setup', 'RunMon', g_Config.boRUNMON);

  if Config.ReadInteger('Setup', 'RunNpc', -1) < 0 then
    Config.WriteBool('Setup', 'RunNpc', g_Config.boRunNpc);
  g_Config.boRunNpc := Config.ReadBool('Setup', 'RunNpc', g_Config.boRunNpc);

  nLoadInteger := Config.ReadInteger('Setup', 'RunGuard', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'RunGuard', g_Config.boRunGuard)
  else
    g_Config.boRunGuard := nLoadInteger = 1;

  if Config.ReadInteger('Setup', 'WarDisableHumanRun', -1) < 0 then
    Config.WriteBool('Setup', 'WarDisableHumanRun', g_Config.boWarDisHumRun);
  g_Config.boWarDisHumRun := Config.ReadBool('Setup', 'WarDisableHumanRun',
    g_Config.boWarDisHumRun);

  if Config.ReadInteger('Setup', 'GMRunAll', -1) < 0 then
    Config.WriteBool('Setup', 'GMRunAll', g_Config.boGMRunAll);
  g_Config.boGMRunAll := Config.ReadBool('Setup', 'GMRunAll',
    g_Config.boGMRunAll);

  if Config.ReadInteger('Setup', 'SafeZoneRunAll', -1) < 0 then
    Config.WriteBool('Setup', 'SafeZoneRunAll', g_Config.boSafeZoneRunAll);
  g_Config.boSafeZoneRunAll := Config.ReadBool('Setup', 'SafeZoneRunAll',
    g_Config.boSafeZoneRunAll);

  if Config.ReadInteger('Setup', 'BoneFammCount', -1) < 0 then
    Config.WriteInteger('Setup', 'BoneFammCount', g_Config.nBoneFammCount);
  g_Config.nBoneFammCount := Config.ReadInteger('Setup', 'BoneFammCount',
    g_Config.nBoneFammCount);

  if Config.ReadInteger('Setup', 'BodyCount', -1) < 0 then
    Config.WriteInteger('Setup', 'BodyCount', g_Config.nBodyCount);
  g_Config.nBodyCount := Config.ReadInteger('Setup', 'BodyCount', g_Config.nBodyCount);

  if Config.ReadInteger('Setup', 'AllowBodyMakeSlave', -1) < 0 then
    Config.WriteBool('Setup', 'AllowBodyMakeSlave', g_Config.boAllowBodyMakeSlave);
  g_Config.boAllowBodyMakeSlave := Config.ReadBool('Setup', 'AllowBodyMakeSlave', g_Config.boAllowBodyMakeSlave);

//道士心灵召唤  Development 2019-01-12 添加
  if Config.ReadInteger('Setup', 'MoveMakeSlave', -1) < 0 then
    Config.WriteBool('Setup', 'MoveMakeSlave', g_Config.boMoveMakeSlave);
  g_Config.boMoveMakeSlave := Config.ReadBool('Setup', 'MoveMakeSlave', g_Config.boMoveMakeSlave);

  for i := Low(g_Config.LimitLevelExp) to High(g_Config.LimitLevelExp) do begin
    if Config.ReadInteger('Setup', 'LimitExpLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'LimitExpLevel' + IntToStr(i), g_Config.LimitLevelExp[i].nHumLevel);
    g_Config.LimitLevelExp[i].nHumLevel := Config.ReadInteger('Setup', 'LimitExpLevel' + IntToStr(i), g_Config.LimitLevelExp[i].nHumLevel);
    if Config.ReadInteger('Setup', 'LimitExpRate' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'LimitExpRate' + IntToStr(i), g_Config.LimitLevelExp[i].nEXPRATE);
    g_Config.LimitLevelExp[i].nEXPRATE := Config.ReadInteger('Setup', 'LimitExpRate' + IntToStr(i), g_Config.LimitLevelExp[i].nEXPRATE);
  end;
  g_boLimitLevelExp := False;
  for i := Low(g_Config.LimitLevelExp) to High(g_Config.LimitLevelExp) do begin
    if g_Config.LimitLevelExp[i].nHumLevel > 0 then begin
      g_boLimitLevelExp := True;
      Break;
    end;
  end;

  for i := Low(g_Config.DieDropGold) to High(g_Config.DieDropGold) do begin
    if Config.ReadInteger('Setup', 'DieDropGoldLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'DieDropGoldLevel' + IntToStr(i), g_Config.DieDropGold[i].nHumLevel);
    g_Config.DieDropGold[i].nHumLevel := Config.ReadInteger('Setup', 'DieDropGoldLevel' + IntToStr(i), g_Config.DieDropGold[i].nHumLevel);
    if Config.ReadInteger('Setup', 'DieDropGoldRate' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'DieDropGoldRate' + IntToStr(i), g_Config.DieDropGold[i].nEXPRATE);
    g_Config.DieDropGold[i].nEXPRATE := Config.ReadInteger('Setup', 'DieDropGoldRate' + IntToStr(i), g_Config.DieDropGold[i].nEXPRATE);
  end;

  for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do begin
    if Config.ReadInteger('Setup', 'BoneFammHumLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'BoneFammHumLevel' + IntToStr(i), g_Config.BoneFammArray[i].nHumLevel);
    g_Config.BoneFammArray[i].nHumLevel := Config.ReadInteger('Setup', 'BoneFammHumLevel' + IntToStr(i), g_Config.BoneFammArray[i].nHumLevel);

    if Config.ReadString('Names', 'BoneFamm' + IntToStr(i), '') = '' then
      Config.WriteString('Names', 'BoneFamm' + IntToStr(i), g_Config.BoneFammArray[i].sMonName);
    g_Config.BoneFammArray[i].sMonName := Config.ReadString('Names', 'BoneFamm' + IntToStr(i), g_Config.BoneFammArray[i].sMonName);

    if Config.ReadInteger('Setup', 'BoneFammCount' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'BoneFammCount' + IntToStr(i), g_Config.BoneFammArray[i].nCount);
    g_Config.BoneFammArray[i].nCount := Config.ReadInteger('Setup', 'BoneFammCount' + IntToStr(i), g_Config.BoneFammArray[i].nCount);

    if Config.ReadInteger('Setup', 'BoneFammLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'BoneFammLevel' + IntToStr(i), g_Config.BoneFammArray[i].nLevel);
    g_Config.BoneFammArray[i].nLevel := Config.ReadInteger('Setup', 'BoneFammLevel' + IntToStr(i), g_Config.BoneFammArray[i].nLevel);
  end;

  if Config.ReadInteger('Setup', 'DogzCount', -1) < 0 then
    Config.WriteInteger('Setup', 'DogzCount', g_Config.nDogzCount);
  g_Config.nDogzCount := Config.ReadInteger('Setup', 'DogzCount', g_Config.nDogzCount);

  for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do begin
    if Config.ReadInteger('Setup', 'DogzHumLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'DogzHumLevel' + IntToStr(i), g_Config.DogzArray[i].nHumLevel);
    g_Config.DogzArray[i].nHumLevel := Config.ReadInteger('Setup', 'DogzHumLevel' + IntToStr(i), g_Config.DogzArray[i].nHumLevel);

    if Config.ReadString('Names', 'Dogz' + IntToStr(i), '') = '' then
      Config.WriteString('Names', 'Dogz' + IntToStr(i), g_Config.DogzArray[i].sMonName);
    g_Config.DogzArray[i].sMonName := Config.ReadString('Names', 'Dogz' + IntToStr(i), g_Config.DogzArray[i].sMonName);

    if Config.ReadInteger('Setup', 'DogzCount' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'DogzCount' + IntToStr(i), g_Config.DogzArray[i].nCount);
    g_Config.DogzArray[i].nCount := Config.ReadInteger('Setup', 'DogzCount' + IntToStr(i), g_Config.DogzArray[i].nCount);

    if Config.ReadInteger('Setup', 'DogzLevel' + IntToStr(i), -1) < 0 then
      Config.WriteInteger('Setup', 'DogzLevel' + IntToStr(i), g_Config.DogzArray[i].nLevel);
    g_Config.DogzArray[i].nLevel := Config.ReadInteger('Setup', 'DogzLevel' + IntToStr(i), g_Config.DogzArray[i].nLevel);
  end;

  if Config.ReadInteger('Setup', 'TryDealTime', -1) < 0 then
    Config.WriteInteger('Setup', 'TryDealTime', g_Config.dwTryDealTime);
  g_Config.dwTryDealTime := Config.ReadInteger('Setup', 'TryDealTime', g_Config.dwTryDealTime);

  if Config.ReadInteger('Setup', 'DealOKTime', -1) < 0 then
    Config.WriteInteger('Setup', 'DealOKTime', g_Config.dwDealOKTime);
  g_Config.dwDealOKTime := Config.ReadInteger('Setup', 'DealOKTime', g_Config.dwDealOKTime);

  if Config.ReadInteger('Setup', 'CanNotGetBackDeal', -1) < 0 then
    Config.WriteBool('Setup', 'CanNotGetBackDeal', g_Config.boCanNotGetBackDeal);
  g_Config.boCanNotGetBackDeal := Config.ReadBool('Setup', 'CanNotGetBackDeal', g_Config.boCanNotGetBackDeal);

  if Config.ReadInteger('Setup', 'DisableDeal', -1) < 0 then
    Config.WriteBool('Setup', 'DisableDeal', g_Config.boDisableDeal);
  g_Config.boDisableDeal := Config.ReadBool('Setup', 'DisableDeal', g_Config.boDisableDeal);

  if Config.ReadInteger('Setup', 'MasterOKLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterOKLevel', g_Config.nMasterOKLevel);
  g_Config.nMasterOKLevel := Config.ReadInteger('Setup', 'MasterOKLevel', g_Config.nMasterOKLevel);

  if Config.ReadInteger('Setup', 'MasterOKCreditPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterOKCreditPoint', g_Config.nMasterOKCreditPoint);
  g_Config.nMasterOKCreditPoint := Config.ReadInteger('Setup', 'MasterOKCreditPoint', g_Config.nMasterOKCreditPoint);

  if Config.ReadInteger('Setup', 'MasterOKBonusPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterOKBonusPoint', g_Config.nMasterOKBonusPoint);
  g_Config.nMasterOKBonusPoint := Config.ReadInteger('Setup', 'MasterOKBonusPoint', g_Config.nMasterOKBonusPoint);

  if Config.ReadInteger('Setup', 'PKProtect', -1) < 0 then
    Config.WriteBool('Setup', 'PKProtect', g_Config.boPKLevelProtect);
  g_Config.boPKLevelProtect := Config.ReadBool('Setup', 'PKProtect', g_Config.boPKLevelProtect);

  if Config.ReadInteger('Setup', 'PKProtectLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'PKProtectLevel', g_Config.nPKProtectLevel);
  g_Config.nPKProtectLevel := Config.ReadInteger('Setup', 'PKProtectLevel', g_Config.nPKProtectLevel);

  if Config.ReadInteger('Setup', 'RedPKProtectLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'RedPKProtectLevel', g_Config.nRedPKProtectLevel);
  g_Config.nRedPKProtectLevel := Config.ReadInteger('Setup', 'RedPKProtectLevel', g_Config.nRedPKProtectLevel);

  if Config.ReadInteger('Setup', 'ItemPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemPowerRate', g_Config.nItemPowerRate);
  g_Config.nItemPowerRate := Config.ReadInteger('Setup', 'ItemPowerRate', g_Config.nItemPowerRate);

  if Config.ReadInteger('Setup', 'ItemExpRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemExpRate', g_Config.nItemExpRate);
  g_Config.nItemExpRate := Config.ReadInteger('Setup', 'ItemExpRate', g_Config.nItemExpRate);

  if Config.ReadInteger('Setup', 'ItemAcRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemAcRate', g_Config.nItemAcRate);
  g_Config.nItemAcRate := Config.ReadInteger('Setup', 'ItemAcRate', g_Config.nItemAcRate);

  if Config.ReadInteger('Setup', 'ItemMacRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemMacRate', g_Config.nItemMacRate);
  g_Config.nItemMacRate := Config.ReadInteger('Setup', 'ItemMacRate', g_Config.nItemMacRate);

  if Config.ReadInteger('Setup', 'ScriptGotoCountLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'ScriptGotoCountLimit', g_Config.nScriptGotoCountLimit);
  g_Config.nScriptGotoCountLimit := Config.ReadInteger('Setup', 'ScriptGotoCountLimit', g_Config.nScriptGotoCountLimit);

  if Config.ReadInteger('Setup', 'HearMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'HearMsgFColor', g_Config.btHearMsgFColor);
  g_Config.btHearMsgFColor := Config.ReadInteger('Setup', 'HearMsgFColor', g_Config.btHearMsgFColor);

  if Config.ReadInteger('Setup', 'HearMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'HearMsgBColor', g_Config.btHearMsgBColor);
  g_Config.btHearMsgBColor := Config.ReadInteger('Setup', 'HearMsgBColor', g_Config.btHearMsgBColor);

  if Config.ReadInteger('Setup', 'WhisperMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'WhisperMsgFColor', g_Config.btWhisperMsgFColor);
  g_Config.btWhisperMsgFColor := Config.ReadInteger('Setup', 'WhisperMsgFColor', g_Config.btWhisperMsgFColor);

  if Config.ReadInteger('Setup', 'WhisperMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'WhisperMsgBColor', g_Config.btWhisperMsgBColor);
  g_Config.btWhisperMsgBColor := Config.ReadInteger('Setup', 'WhisperMsgBColor', g_Config.btWhisperMsgBColor);

  if Config.ReadInteger('Setup', 'GMWhisperMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GMWhisperMsgFColor', g_Config.btGMWhisperMsgFColor);
  g_Config.btGMWhisperMsgFColor := Config.ReadInteger('Setup', 'GMWhisperMsgFColor', g_Config.btGMWhisperMsgFColor);

  if Config.ReadInteger('Setup', 'GMWhisperMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GMWhisperMsgBColor', g_Config.btGMWhisperMsgBColor);
  g_Config.btGMWhisperMsgBColor := Config.ReadInteger('Setup', 'GMWhisperMsgBColor', g_Config.btGMWhisperMsgBColor);

  if Config.ReadInteger('Setup', 'CryMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'CryMsgFColor', g_Config.btCryMsgFColor);
  g_Config.btCryMsgFColor := Config.ReadInteger('Setup', 'CryMsgFColor', g_Config.btCryMsgFColor);

  if Config.ReadInteger('Setup', 'CryMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'CryMsgBColor', g_Config.btCryMsgBColor);
  g_Config.btCryMsgBColor := Config.ReadInteger('Setup', 'CryMsgBColor', g_Config.btCryMsgBColor);

  if Config.ReadInteger('Setup', 'GreenMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GreenMsgFColor', g_Config.btGreenMsgFColor);
  g_Config.btGreenMsgFColor := Config.ReadInteger('Setup', 'GreenMsgFColor', g_Config.btGreenMsgFColor);

  if Config.ReadInteger('Setup', 'GreenMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GreenMsgBColor', g_Config.btGreenMsgBColor);
  g_Config.btGreenMsgBColor := Config.ReadInteger('Setup', 'GreenMsgBColor', g_Config.btGreenMsgBColor);

  if Config.ReadInteger('Setup', 'BlueMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'BlueMsgFColor', g_Config.btBlueMsgFColor);
  g_Config.btBlueMsgFColor := Config.ReadInteger('Setup', 'BlueMsgFColor', g_Config.btBlueMsgFColor);

  if Config.ReadInteger('Setup', 'BlueMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'BlueMsgBColor', g_Config.btBlueMsgBColor);
  g_Config.btBlueMsgBColor := Config.ReadInteger('Setup', 'BlueMsgBColor', g_Config.btBlueMsgBColor);

  if Config.ReadInteger('Setup', 'RedMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'RedMsgFColor', g_Config.btRedMsgFColor);
  g_Config.btRedMsgFColor := Config.ReadInteger('Setup', 'RedMsgFColor', g_Config.btRedMsgFColor);

  if Config.ReadInteger('Setup', 'RedMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'RedMsgBColor', g_Config.btRedMsgBColor);
  g_Config.btRedMsgBColor := Config.ReadInteger('Setup', 'RedMsgBColor', g_Config.btRedMsgBColor);

  if Config.ReadInteger('Setup', 'GuildMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildMsgFColor', g_Config.btGuildMsgFColor);
  g_Config.btGuildMsgFColor := Config.ReadInteger('Setup', 'GuildMsgFColor', g_Config.btGuildMsgFColor);

  if Config.ReadInteger('Setup', 'GuildMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildMsgBColor', g_Config.btGuildMsgBColor);
  g_Config.btGuildMsgBColor := Config.ReadInteger('Setup', 'GuildMsgBColor', g_Config.btGuildMsgBColor);

  if Config.ReadInteger('Setup', 'GroupMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GroupMsgFColor', g_Config.btGroupMsgFColor);
  g_Config.btGroupMsgFColor := Config.ReadInteger('Setup', 'GroupMsgFColor', g_Config.btGroupMsgFColor);

  if Config.ReadInteger('Setup', 'GroupMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'GroupMsgBColor', g_Config.btGroupMsgBColor);
  g_Config.btGroupMsgBColor := Config.ReadInteger('Setup', 'GroupMsgBColor', g_Config.btGroupMsgBColor);

  if Config.ReadInteger('Setup', 'CustMsgFColor', -1) < 0 then
    Config.WriteInteger('Setup', 'CustMsgFColor', g_Config.btCustMsgFColor);
  g_Config.btCustMsgFColor := Config.ReadInteger('Setup', 'CustMsgFColor', g_Config.btCustMsgFColor);

  if Config.ReadInteger('Setup', 'CustMsgBColor', -1) < 0 then
    Config.WriteInteger('Setup', 'CustMsgBColor', g_Config.btCustMsgBColor);
  g_Config.btCustMsgBColor := Config.ReadInteger('Setup', 'CustMsgBColor', g_Config.btCustMsgBColor);

  if Config.ReadInteger('Setup', 'MonRandomAddValue', -1) < 0 then
    Config.WriteInteger('Setup', 'MonRandomAddValue', g_Config.nMonRandomAddValue);
  g_Config.nMonRandomAddValue := Config.ReadInteger('Setup', 'MonRandomAddValue', g_Config.nMonRandomAddValue);

  if Config.ReadInteger('Setup', 'MakeRandomAddValue', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeRandomAddValue', g_Config.nMakeRandomAddValue);
  g_Config.nMakeRandomAddValue := Config.ReadInteger('Setup', 'MakeRandomAddValue', g_Config.nMakeRandomAddValue);

  if Config.ReadInteger('Setup', 'WeaponDCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponDCAddValueMaxLimit', g_Config.nWeaponDCAddValueMaxLimit);
  g_Config.nWeaponDCAddValueMaxLimit := Config.ReadInteger('Setup', 'WeaponDCAddValueMaxLimit', g_Config.nWeaponDCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'WeaponDCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponDCAddValueRate', g_Config.nWeaponDCAddValueRate);
  g_Config.nWeaponDCAddValueRate := Config.ReadInteger('Setup', 'WeaponDCAddValueRate', g_Config.nWeaponDCAddValueRate);

  if Config.ReadInteger('Setup', 'WeaponMCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponMCAddValueMaxLimit', g_Config.nWeaponMCAddValueMaxLimit);
  g_Config.nWeaponMCAddValueMaxLimit := Config.ReadInteger('Setup', 'WeaponMCAddValueMaxLimit', g_Config.nWeaponMCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'WeaponMCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponMCAddValueRate', g_Config.nWeaponMCAddValueRate);
  g_Config.nWeaponMCAddValueRate := Config.ReadInteger('Setup', 'WeaponMCAddValueRate', g_Config.nWeaponMCAddValueRate);

  if Config.ReadInteger('Setup', 'WeaponSCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponSCAddValueMaxLimit', g_Config.nWeaponSCAddValueMaxLimit);
  g_Config.nWeaponSCAddValueMaxLimit := Config.ReadInteger('Setup', 'WeaponSCAddValueMaxLimit', g_Config.nWeaponSCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'WeaponSCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'WeaponSCAddValueRate', g_Config.nWeaponSCAddValueRate);
  g_Config.nWeaponSCAddValueRate := Config.ReadInteger('Setup', 'WeaponSCAddValueRate', g_Config.nWeaponSCAddValueRate);

  if Config.ReadInteger('Setup', 'DressDCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'DressDCAddValueMaxLimit', g_Config.nDressDCAddValueMaxLimit);
  g_Config.nDressDCAddValueMaxLimit := Config.ReadInteger('Setup', 'DressDCAddValueMaxLimit', g_Config.nDressDCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'DressDCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressDCAddValueRate', g_Config.nDressDCAddValueRate);
  g_Config.nDressDCAddValueRate := Config.ReadInteger('Setup', 'DressDCAddValueRate', g_Config.nDressDCAddValueRate);

  if Config.ReadInteger('Setup', 'DressDCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressDCAddRate', g_Config.nDressDCAddRate);
  g_Config.nDressDCAddRate := Config.ReadInteger('Setup', 'DressDCAddRate', g_Config.nDressDCAddRate);

  if Config.ReadInteger('Setup', 'DressMCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'DressMCAddValueMaxLimit', g_Config.nDressMCAddValueMaxLimit);
  g_Config.nDressMCAddValueMaxLimit := Config.ReadInteger('Setup', 'DressMCAddValueMaxLimit', g_Config.nDressMCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'DressMCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressMCAddValueRate', g_Config.nDressMCAddValueRate);
  g_Config.nDressMCAddValueRate := Config.ReadInteger('Setup', 'DressMCAddValueRate', g_Config.nDressMCAddValueRate);

  if Config.ReadInteger('Setup', 'DressMCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressMCAddRate', g_Config.nDressMCAddRate);
  g_Config.nDressMCAddRate := Config.ReadInteger('Setup', 'DressMCAddRate', g_Config.nDressMCAddRate);

  if Config.ReadInteger('Setup', 'DressSCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'DressSCAddValueMaxLimit', g_Config.nDressSCAddValueMaxLimit);
  g_Config.nDressSCAddValueMaxLimit := Config.ReadInteger('Setup', 'DressSCAddValueMaxLimit', g_Config.nDressSCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'DressSCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressSCAddValueRate', g_Config.nDressSCAddValueRate);
  g_Config.nDressSCAddValueRate := Config.ReadInteger('Setup', 'DressSCAddValueRate', g_Config.nDressSCAddValueRate);

  if Config.ReadInteger('Setup', 'DressSCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DressSCAddRate', g_Config.nDressSCAddRate);
  g_Config.nDressSCAddRate := Config.ReadInteger('Setup', 'DressSCAddRate',
    g_Config.nDressSCAddRate);

  nLoadInteger := Config.ReadInteger('Setup', 'NeckLace19LuckAddRate', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'NeckLace19LuckAddRate', g_Config.nNeckLace19LuckAddRate);
  end else
    g_Config.nNeckLace19LuckAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'NeckLace19LuckAddValueMaxLimit', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'NeckLace19LuckAddValueMaxLimit', g_Config.nNeckLace19LuckAddValueMaxLimit);
  end else
    g_Config.nNeckLace19LuckAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'NeckLace19LuckAddValueRate', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'NeckLace19LuckAddValueRate', g_Config.nNeckLace19LuckAddValueRate);
  end else
    g_Config.nNeckLace19LuckAddValueRate := nLoadInteger;

  if Config.ReadInteger('Setup', 'NeckLace19DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19DCAddValueMaxLimit',
      g_Config.nNeckLace19DCAddValueMaxLimit);
  g_Config.nNeckLace19DCAddValueMaxLimit := Config.ReadInteger('Setup',
    'NeckLace19DCAddValueMaxLimit', g_Config.nNeckLace19DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace19DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19DCAddValueRate',
      g_Config.nNeckLace19DCAddValueRate);
  g_Config.nNeckLace19DCAddValueRate := Config.ReadInteger('Setup',
    'NeckLace19DCAddValueRate', g_Config.nNeckLace19DCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace19DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19DCAddRate',
      g_Config.nNeckLace19DCAddRate);
  g_Config.nNeckLace19DCAddRate := Config.ReadInteger('Setup',
    'NeckLace19DCAddRate', g_Config.nNeckLace19DCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace19MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19MCAddValueMaxLimit',
      g_Config.nNeckLace19MCAddValueMaxLimit);
  g_Config.nNeckLace19MCAddValueMaxLimit := Config.ReadInteger('Setup',
    'NeckLace19MCAddValueMaxLimit', g_Config.nNeckLace19MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace19MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19MCAddValueRate',
      g_Config.nNeckLace19MCAddValueRate);
  g_Config.nNeckLace19MCAddValueRate := Config.ReadInteger('Setup',
    'NeckLace19MCAddValueRate', g_Config.nNeckLace19MCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace19MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19MCAddRate',
      g_Config.nNeckLace19MCAddRate);
  g_Config.nNeckLace19MCAddRate := Config.ReadInteger('Setup',
    'NeckLace19MCAddRate', g_Config.nNeckLace19MCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace19SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19SCAddValueMaxLimit',
      g_Config.nNeckLace19SCAddValueMaxLimit);
  g_Config.nNeckLace19SCAddValueMaxLimit := Config.ReadInteger('Setup',
    'NeckLace19SCAddValueMaxLimit', g_Config.nNeckLace19SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace19SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19SCAddValueRate',
      g_Config.nNeckLace19SCAddValueRate);
  g_Config.nNeckLace19SCAddValueRate := Config.ReadInteger('Setup',
    'NeckLace19SCAddValueRate', g_Config.nNeckLace19SCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace19SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace19SCAddRate',
      g_Config.nNeckLace19SCAddRate);
  g_Config.nNeckLace19SCAddRate := Config.ReadInteger('Setup',
    'NeckLace19SCAddRate', g_Config.nNeckLace19SCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace202124DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124DCAddValueMaxLimit',
      g_Config.nNeckLace202124DCAddValueMaxLimit);
  g_Config.nNeckLace202124DCAddValueMaxLimit := Config.ReadInteger('Setup',
    'NeckLace202124DCAddValueMaxLimit',
    g_Config.nNeckLace202124DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace202124DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124DCAddValueRate',
      g_Config.nNeckLace202124DCAddValueRate);
  g_Config.nNeckLace202124DCAddValueRate := Config.ReadInteger('Setup',
    'NeckLace202124DCAddValueRate', g_Config.nNeckLace202124DCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace202124DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124DCAddRate',
      g_Config.nNeckLace202124DCAddRate);
  g_Config.nNeckLace202124DCAddRate := Config.ReadInteger('Setup',
    'NeckLace202124DCAddRate', g_Config.nNeckLace202124DCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace202124MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124MCAddValueMaxLimit',
      g_Config.nNeckLace202124MCAddValueMaxLimit);
  g_Config.nNeckLace202124MCAddValueMaxLimit := Config.ReadInteger('Setup',
    'NeckLace202124MCAddValueMaxLimit',
    g_Config.nNeckLace202124MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace202124MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124MCAddValueRate',
      g_Config.nNeckLace202124MCAddValueRate);
  g_Config.nNeckLace202124MCAddValueRate := Config.ReadInteger('Setup',
    'NeckLace202124MCAddValueRate', g_Config.nNeckLace202124MCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace202124MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124MCAddRate',
      g_Config.nNeckLace202124MCAddRate);
  g_Config.nNeckLace202124MCAddRate := Config.ReadInteger('Setup',
    'NeckLace202124MCAddRate', g_Config.nNeckLace202124MCAddRate);

  if Config.ReadInteger('Setup', 'NeckLace202124SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124SCAddValueMaxLimit',
      g_Config.nNeckLace202124SCAddValueMaxLimit);
  g_Config.nNeckLace202124SCAddValueMaxLimit := Config.ReadInteger('Setup',
    'NeckLace202124SCAddValueMaxLimit',
    g_Config.nNeckLace202124SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'NeckLace202124SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124SCAddValueRate',
      g_Config.nNeckLace202124SCAddValueRate);
  g_Config.nNeckLace202124SCAddValueRate := Config.ReadInteger('Setup',
    'NeckLace202124SCAddValueRate', g_Config.nNeckLace202124SCAddValueRate);

  if Config.ReadInteger('Setup', 'NeckLace202124SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'NeckLace202124SCAddRate',
      g_Config.nNeckLace202124SCAddRate);
  g_Config.nNeckLace202124SCAddRate := Config.ReadInteger('Setup',
    'NeckLace202124SCAddRate', g_Config.nNeckLace202124SCAddRate);

  if Config.ReadInteger('Setup', 'ArmRing26DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26DCAddValueMaxLimit',
      g_Config.nArmRing26DCAddValueMaxLimit);
  g_Config.nArmRing26DCAddValueMaxLimit := Config.ReadInteger('Setup',
    'ArmRing26DCAddValueMaxLimit', g_Config.nArmRing26DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'ArmRing26DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26DCAddValueRate',
      g_Config.nArmRing26DCAddValueRate);
  g_Config.nArmRing26DCAddValueRate := Config.ReadInteger('Setup',
    'ArmRing26DCAddValueRate', g_Config.nArmRing26DCAddValueRate);

  if Config.ReadInteger('Setup', 'ArmRing26DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26DCAddRate',
      g_Config.nArmRing26DCAddRate);
  g_Config.nArmRing26DCAddRate := Config.ReadInteger('Setup',
    'ArmRing26DCAddRate', g_Config.nArmRing26DCAddRate);

  if Config.ReadInteger('Setup', 'ArmRing26MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26MCAddValueMaxLimit',
      g_Config.nArmRing26MCAddValueMaxLimit);
  g_Config.nArmRing26MCAddValueMaxLimit := Config.ReadInteger('Setup',
    'ArmRing26MCAddValueMaxLimit', g_Config.nArmRing26MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'ArmRing26MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26MCAddValueRate',
      g_Config.nArmRing26MCAddValueRate);
  g_Config.nArmRing26MCAddValueRate := Config.ReadInteger('Setup',
    'ArmRing26MCAddValueRate', g_Config.nArmRing26MCAddValueRate);

  if Config.ReadInteger('Setup', 'ArmRing26MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26MCAddRate',
      g_Config.nArmRing26MCAddRate);
  g_Config.nArmRing26MCAddRate := Config.ReadInteger('Setup',
    'ArmRing26MCAddRate', g_Config.nArmRing26MCAddRate);

  if Config.ReadInteger('Setup', 'ArmRing26SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26SCAddValueMaxLimit',
      g_Config.nArmRing26SCAddValueMaxLimit);
  g_Config.nArmRing26SCAddValueMaxLimit := Config.ReadInteger('Setup',
    'ArmRing26SCAddValueMaxLimit', g_Config.nArmRing26SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'ArmRing26SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26SCAddValueRate',
      g_Config.nArmRing26SCAddValueRate);
  g_Config.nArmRing26SCAddValueRate := Config.ReadInteger('Setup',
    'ArmRing26SCAddValueRate', g_Config.nArmRing26SCAddValueRate);

  if Config.ReadInteger('Setup', 'ArmRing26SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ArmRing26SCAddRate',
      g_Config.nArmRing26SCAddRate);
  g_Config.nArmRing26SCAddRate := Config.ReadInteger('Setup',
    'ArmRing26SCAddRate', g_Config.nArmRing26SCAddRate);

  if Config.ReadInteger('Setup', 'Ring22DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22DCAddValueMaxLimit',
      g_Config.nRing22DCAddValueMaxLimit);
  g_Config.nRing22DCAddValueMaxLimit := Config.ReadInteger('Setup',
    'Ring22DCAddValueMaxLimit', g_Config.nRing22DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring22DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22DCAddValueRate',
      g_Config.nRing22DCAddValueRate);
  g_Config.nRing22DCAddValueRate := Config.ReadInteger('Setup',
    'Ring22DCAddValueRate', g_Config.nRing22DCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring22DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22DCAddRate', g_Config.nRing22DCAddRate);
  g_Config.nRing22DCAddRate := Config.ReadInteger('Setup', 'Ring22DCAddRate',
    g_Config.nRing22DCAddRate);

  if Config.ReadInteger('Setup', 'Ring22MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22MCAddValueMaxLimit',
      g_Config.nRing22MCAddValueMaxLimit);
  g_Config.nRing22MCAddValueMaxLimit := Config.ReadInteger('Setup',
    'Ring22MCAddValueMaxLimit', g_Config.nRing22MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring22MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22MCAddValueRate',
      g_Config.nRing22MCAddValueRate);
  g_Config.nRing22MCAddValueRate := Config.ReadInteger('Setup',
    'Ring22MCAddValueRate', g_Config.nRing22MCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring22MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22MCAddRate', g_Config.nRing22MCAddRate);
  g_Config.nRing22MCAddRate := Config.ReadInteger('Setup', 'Ring22MCAddRate',
    g_Config.nRing22MCAddRate);

  if Config.ReadInteger('Setup', 'Ring22SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22SCAddValueMaxLimit',
      g_Config.nRing22SCAddValueMaxLimit);
  g_Config.nRing22SCAddValueMaxLimit := Config.ReadInteger('Setup',
    'Ring22SCAddValueMaxLimit', g_Config.nRing22SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring22SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22SCAddValueRate',
      g_Config.nRing22SCAddValueRate);
  g_Config.nRing22SCAddValueRate := Config.ReadInteger('Setup',
    'Ring22SCAddValueRate', g_Config.nRing22SCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring22SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring22SCAddRate', g_Config.nRing22SCAddRate);
  g_Config.nRing22SCAddRate := Config.ReadInteger('Setup', 'Ring22SCAddRate',
    g_Config.nRing22SCAddRate);

  if Config.ReadInteger('Setup', 'Ring23DCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23DCAddValueMaxLimit',
      g_Config.nRing23DCAddValueMaxLimit);
  g_Config.nRing23DCAddValueMaxLimit := Config.ReadInteger('Setup',
    'Ring23DCAddValueMaxLimit', g_Config.nRing23DCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring23DCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23DCAddValueRate',
      g_Config.nRing23DCAddValueRate);
  g_Config.nRing23DCAddValueRate := Config.ReadInteger('Setup',
    'Ring23DCAddValueRate', g_Config.nRing23DCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring23DCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23DCAddRate', g_Config.nRing23DCAddRate);
  g_Config.nRing23DCAddRate := Config.ReadInteger('Setup', 'Ring23DCAddRate',
    g_Config.nRing23DCAddRate);

  if Config.ReadInteger('Setup', 'Ring23MCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23MCAddValueMaxLimit',
      g_Config.nRing23MCAddValueMaxLimit);
  g_Config.nRing23MCAddValueMaxLimit := Config.ReadInteger('Setup',
    'Ring23MCAddValueMaxLimit', g_Config.nRing23MCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring23MCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23MCAddValueRate',
      g_Config.nRing23MCAddValueRate);
  g_Config.nRing23MCAddValueRate := Config.ReadInteger('Setup',
    'Ring23MCAddValueRate', g_Config.nRing23MCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring23MCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23MCAddRate', g_Config.nRing23MCAddRate);
  g_Config.nRing23MCAddRate := Config.ReadInteger('Setup', 'Ring23MCAddRate',
    g_Config.nRing23MCAddRate);

  if Config.ReadInteger('Setup', 'Ring23SCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23SCAddValueMaxLimit',
      g_Config.nRing23SCAddValueMaxLimit);
  g_Config.nRing23SCAddValueMaxLimit := Config.ReadInteger('Setup',
    'Ring23SCAddValueMaxLimit', g_Config.nRing23SCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'Ring23SCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23SCAddValueRate',
      g_Config.nRing23SCAddValueRate);
  g_Config.nRing23SCAddValueRate := Config.ReadInteger('Setup',
    'Ring23SCAddValueRate', g_Config.nRing23SCAddValueRate);

  if Config.ReadInteger('Setup', 'Ring23SCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'Ring23SCAddRate', g_Config.nRing23SCAddRate);
  g_Config.nRing23SCAddRate := Config.ReadInteger('Setup', 'Ring23SCAddRate',
    g_Config.nRing23SCAddRate);

  if Config.ReadInteger('Setup', 'HelMetDCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetDCAddValueMaxLimit',
      g_Config.nHelMetDCAddValueMaxLimit);
  g_Config.nHelMetDCAddValueMaxLimit := Config.ReadInteger('Setup',
    'HelMetDCAddValueMaxLimit', g_Config.nHelMetDCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'HelMetDCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetDCAddValueRate',
      g_Config.nHelMetDCAddValueRate);
  g_Config.nHelMetDCAddValueRate := Config.ReadInteger('Setup',
    'HelMetDCAddValueRate', g_Config.nHelMetDCAddValueRate);

  if Config.ReadInteger('Setup', 'HelMetDCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetDCAddRate', g_Config.nHelMetDCAddRate);
  g_Config.nHelMetDCAddRate := Config.ReadInteger('Setup', 'HelMetDCAddRate',
    g_Config.nHelMetDCAddRate);

  if Config.ReadInteger('Setup', 'HelMetMCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetMCAddValueMaxLimit',
      g_Config.nHelMetMCAddValueMaxLimit);
  g_Config.nHelMetMCAddValueMaxLimit := Config.ReadInteger('Setup',
    'HelMetMCAddValueMaxLimit', g_Config.nHelMetMCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'HelMetMCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetMCAddValueRate',
      g_Config.nHelMetMCAddValueRate);
  g_Config.nHelMetMCAddValueRate := Config.ReadInteger('Setup',
    'HelMetMCAddValueRate', g_Config.nHelMetMCAddValueRate);

  if Config.ReadInteger('Setup', 'HelMetMCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetMCAddRate', g_Config.nHelMetMCAddRate);
  g_Config.nHelMetMCAddRate := Config.ReadInteger('Setup', 'HelMetMCAddRate',
    g_Config.nHelMetMCAddRate);

  if Config.ReadInteger('Setup', 'HelMetSCAddValueMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetSCAddValueMaxLimit',
      g_Config.nHelMetSCAddValueMaxLimit);
  g_Config.nHelMetSCAddValueMaxLimit := Config.ReadInteger('Setup',
    'HelMetSCAddValueMaxLimit', g_Config.nHelMetSCAddValueMaxLimit);

  if Config.ReadInteger('Setup', 'HelMetSCAddValueRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetSCAddValueRate',
      g_Config.nHelMetSCAddValueRate);
  g_Config.nHelMetSCAddValueRate := Config.ReadInteger('Setup',
    'HelMetSCAddValueRate', g_Config.nHelMetSCAddValueRate);

  if Config.ReadInteger('Setup', 'HelMetSCAddRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HelMetSCAddRate', g_Config.nHelMetSCAddRate);
  g_Config.nHelMetSCAddRate := Config.ReadInteger('Setup', 'HelMetSCAddRate',
    g_Config.nHelMetSCAddRate);

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetACAddRate',
      g_Config.nUnknowHelMetACAddRate)
  else
    g_Config.nUnknowHelMetACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetACAddValueMaxLimit',
      g_Config.nUnknowHelMetACAddValueMaxLimit)
  else
    g_Config.nUnknowHelMetACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetMACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetMACAddRate',
      g_Config.nUnknowHelMetMACAddRate)
  else
    g_Config.nUnknowHelMetMACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetMACAddValueMaxLimit',
    -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetMACAddValueMaxLimit',
      g_Config.nUnknowHelMetMACAddValueMaxLimit)
  else
    g_Config.nUnknowHelMetMACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetDCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetDCAddRate',
      g_Config.nUnknowHelMetDCAddRate)
  else
    g_Config.nUnknowHelMetDCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetDCAddValueMaxLimit',
    -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetDCAddValueMaxLimit',
      g_Config.nUnknowHelMetDCAddValueMaxLimit)
  else
    g_Config.nUnknowHelMetDCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetMCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetMCAddRate',
      g_Config.nUnknowHelMetMCAddRate)
  else
    g_Config.nUnknowHelMetMCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetMCAddValueMaxLimit',
    -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetMCAddValueMaxLimit',
      g_Config.nUnknowHelMetMCAddValueMaxLimit)
  else
    g_Config.nUnknowHelMetMCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetSCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetSCAddRate',
      g_Config.nUnknowHelMetSCAddRate)
  else
    g_Config.nUnknowHelMetSCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowHelMetSCAddValueMaxLimit',
    -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowHelMetSCAddValueMaxLimit',
      g_Config.nUnknowHelMetSCAddValueMaxLimit)
  else
    g_Config.nUnknowHelMetSCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceACAddRate',
      g_Config.nUnknowNecklaceACAddRate)
  else
    g_Config.nUnknowNecklaceACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceACAddValueMaxLimit', g_Config.nUnknowNecklaceACAddValueMaxLimit)
  else
    g_Config.nUnknowNecklaceACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceMACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceMACAddRate', g_Config.nUnknowNecklaceMACAddRate)
  else
    g_Config.nUnknowNecklaceMACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceMACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceMACAddValueMaxLimit', g_Config.nUnknowNecklaceMACAddValueMaxLimit)
  else
    g_Config.nUnknowNecklaceMACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceDCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceDCAddRate', g_Config.nUnknowNecklaceDCAddRate)
  else
    g_Config.nUnknowNecklaceDCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceDCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceDCAddValueMaxLimit', g_Config.nUnknowNecklaceDCAddValueMaxLimit)
  else
    g_Config.nUnknowNecklaceDCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceMCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceMCAddRate', g_Config.nUnknowNecklaceMCAddRate)
  else
    g_Config.nUnknowNecklaceMCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceMCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceMCAddValueMaxLimit', g_Config.nUnknowNecklaceMCAddValueMaxLimit)
  else
    g_Config.nUnknowNecklaceMCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceSCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceSCAddRate', g_Config.nUnknowNecklaceSCAddRate)
  else
    g_Config.nUnknowNecklaceSCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowNecklaceSCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowNecklaceSCAddValueMaxLimit', g_Config.nUnknowNecklaceSCAddValueMaxLimit)
  else
    g_Config.nUnknowNecklaceSCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingACAddRate', g_Config.nUnknowRingACAddRate)
  else
    g_Config.nUnknowRingACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingACAddValueMaxLimit',
    -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingACAddValueMaxLimit', g_Config.nUnknowRingACAddValueMaxLimit)
  else
    g_Config.nUnknowRingACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingMACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingMACAddRate', g_Config.nUnknowRingMACAddRate)
  else
    g_Config.nUnknowRingMACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingMACAddValueMaxLimit',
    -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingMACAddValueMaxLimit', g_Config.nUnknowRingMACAddValueMaxLimit)
  else
    g_Config.nUnknowRingMACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingDCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingDCAddRate', g_Config.nUnknowRingDCAddRate)
  else
    g_Config.nUnknowRingDCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingDCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingDCAddValueMaxLimit', g_Config.nUnknowRingDCAddValueMaxLimit)
  else
    g_Config.nUnknowRingDCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingMCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingMCAddRate', g_Config.nUnknowRingMCAddRate)
  else
    g_Config.nUnknowRingMCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingMCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingMCAddValueMaxLimit', g_Config.nUnknowRingMCAddValueMaxLimit)
  else
    g_Config.nUnknowRingMCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingSCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingSCAddRate', g_Config.nUnknowRingSCAddRate)
  else
    g_Config.nUnknowRingSCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'UnknowRingSCAddValueMaxLimit',
    -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UnknowRingSCAddValueMaxLimit', g_Config.nUnknowRingSCAddValueMaxLimit)
  else
    g_Config.nUnknowRingSCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MonOneDropGoldCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MonOneDropGoldCount', g_Config.nMonOneDropGoldCount)
  else
    g_Config.nMonOneDropGoldCount := nLoadInteger;

  if Config.ReadInteger('Setup', 'MakeMineHitRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeMineHitRate', g_Config.nMakeMineHitRate);
  g_Config.nMakeMineHitRate := Config.ReadInteger('Setup', 'MakeMineHitRate', g_Config.nMakeMineHitRate);

  if Config.ReadInteger('Setup', 'MakeMineRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeMineRate', g_Config.nMakeMineRate);
  g_Config.nMakeMineRate := Config.ReadInteger('Setup', 'MakeMineRate', g_Config.nMakeMineRate);

  if Config.ReadInteger('Setup', 'StoneTypeRate', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneTypeRate', g_Config.nStoneTypeRate);
  g_Config.nStoneTypeRate := Config.ReadInteger('Setup', 'StoneTypeRate', g_Config.nStoneTypeRate);

  if Config.ReadInteger('Setup', 'StoneTypeRateMin', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneTypeRateMin', g_Config.nStoneTypeRateMin);
  g_Config.nStoneTypeRateMin := Config.ReadInteger('Setup', 'StoneTypeRateMin', g_Config.nStoneTypeRateMin);

  if Config.ReadInteger('Setup', 'GoldStoneMin', -1) < 0 then
    Config.WriteInteger('Setup', 'GoldStoneMin', g_Config.nGoldStoneMin);
  g_Config.nGoldStoneMin := Config.ReadInteger('Setup', 'GoldStoneMin', g_Config.nGoldStoneMin);

  if Config.ReadInteger('Setup', 'GoldStoneMax', -1) < 0 then
    Config.WriteInteger('Setup', 'GoldStoneMax', g_Config.nGoldStoneMax);
  g_Config.nGoldStoneMax := Config.ReadInteger('Setup', 'GoldStoneMax', g_Config.nGoldStoneMax);

  if Config.ReadInteger('Setup', 'SilverStoneMin', -1) < 0 then
    Config.WriteInteger('Setup', 'SilverStoneMin', g_Config.nSilverStoneMin);
  g_Config.nSilverStoneMin := Config.ReadInteger('Setup', 'SilverStoneMin', g_Config.nSilverStoneMin);

  if Config.ReadInteger('Setup', 'SilverStoneMax', -1) < 0 then
    Config.WriteInteger('Setup', 'SilverStoneMax', g_Config.nSilverStoneMax);
  g_Config.nSilverStoneMax := Config.ReadInteger('Setup', 'SilverStoneMax', g_Config.nSilverStoneMax);

  if Config.ReadInteger('Setup', 'SteelStoneMin', -1) < 0 then
    Config.WriteInteger('Setup', 'SteelStoneMin', g_Config.nSteelStoneMin);
  g_Config.nSteelStoneMin := Config.ReadInteger('Setup', 'SteelStoneMin', g_Config.nSteelStoneMin);

  if Config.ReadInteger('Setup', 'SteelStoneMax', -1) < 0 then
    Config.WriteInteger('Setup', 'SteelStoneMax', g_Config.nSteelStoneMax);
  g_Config.nSteelStoneMax := Config.ReadInteger('Setup', 'SteelStoneMax', g_Config.nSteelStoneMax);

  if Config.ReadInteger('Setup', 'BlackStoneMin', -1) < 0 then
    Config.WriteInteger('Setup', 'BlackStoneMin', g_Config.nBlackStoneMin);
  g_Config.nBlackStoneMin := Config.ReadInteger('Setup', 'BlackStoneMin', g_Config.nBlackStoneMin);

  if Config.ReadInteger('Setup', 'BlackStoneMax', -1) < 0 then
    Config.WriteInteger('Setup', 'BlackStoneMax', g_Config.nBlackStoneMax);
  g_Config.nBlackStoneMax := Config.ReadInteger('Setup', 'BlackStoneMax', g_Config.nBlackStoneMax);

  if Config.ReadInteger('Setup', 'StoneMinDura', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneMinDura', g_Config.nStoneMinDura);
  g_Config.nStoneMinDura := Config.ReadInteger('Setup', 'StoneMinDura', g_Config.nStoneMinDura);

  if Config.ReadInteger('Setup', 'StoneGeneralDuraRate', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneGeneralDuraRate', g_Config.nStoneGeneralDuraRate);
  g_Config.nStoneGeneralDuraRate := Config.ReadInteger('Setup', 'StoneGeneralDuraRate', g_Config.nStoneGeneralDuraRate);

  if Config.ReadInteger('Setup', 'StoneAddDuraRate', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneAddDuraRate', g_Config.nStoneAddDuraRate);
  g_Config.nStoneAddDuraRate := Config.ReadInteger('Setup', 'StoneAddDuraRate', g_Config.nStoneAddDuraRate);

  if Config.ReadInteger('Setup', 'StoneAddDuraMax', -1) < 0 then
    Config.WriteInteger('Setup', 'StoneAddDuraMax', g_Config.nStoneAddDuraMax);
  g_Config.nStoneAddDuraMax := Config.ReadInteger('Setup', 'StoneAddDuraMax', g_Config.nStoneAddDuraMax);

  if Config.ReadInteger('Setup', 'WinLottery1Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery1Min', g_Config.nWinLottery1Min);
  g_Config.nWinLottery1Min := Config.ReadInteger('Setup', 'WinLottery1Min', g_Config.nWinLottery1Min);

  if Config.ReadInteger('Setup', 'WinLottery1Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery1Max', g_Config.nWinLottery1Max);
  g_Config.nWinLottery1Max := Config.ReadInteger('Setup', 'WinLottery1Max', g_Config.nWinLottery1Max);

  if Config.ReadInteger('Setup', 'WinLottery2Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery2Min', g_Config.nWinLottery2Min);
  g_Config.nWinLottery2Min := Config.ReadInteger('Setup', 'WinLottery2Min', g_Config.nWinLottery2Min);

  if Config.ReadInteger('Setup', 'WinLottery2Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery2Max', g_Config.nWinLottery2Max);
  g_Config.nWinLottery2Max := Config.ReadInteger('Setup', 'WinLottery2Max', g_Config.nWinLottery2Max);

  if Config.ReadInteger('Setup', 'WinLottery3Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery3Min', g_Config.nWinLottery3Min);
  g_Config.nWinLottery3Min := Config.ReadInteger('Setup', 'WinLottery3Min', g_Config.nWinLottery3Min);

  if Config.ReadInteger('Setup', 'WinLottery3Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery3Max', g_Config.nWinLottery3Max);
  g_Config.nWinLottery3Max := Config.ReadInteger('Setup', 'WinLottery3Max', g_Config.nWinLottery3Max);

  if Config.ReadInteger('Setup', 'WinLottery4Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery4Min', g_Config.nWinLottery4Min);
  g_Config.nWinLottery4Min := Config.ReadInteger('Setup', 'WinLottery4Min', g_Config.nWinLottery4Min);

  if Config.ReadInteger('Setup', 'WinLottery4Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery4Max', g_Config.nWinLottery4Max);
  g_Config.nWinLottery4Max := Config.ReadInteger('Setup', 'WinLottery4Max', g_Config.nWinLottery4Max);

  if Config.ReadInteger('Setup', 'WinLottery5Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery5Min', g_Config.nWinLottery5Min);
  g_Config.nWinLottery5Min := Config.ReadInteger('Setup', 'WinLottery5Min', g_Config.nWinLottery5Min);

  if Config.ReadInteger('Setup', 'WinLottery5Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery5Max', g_Config.nWinLottery5Max);
  g_Config.nWinLottery5Max := Config.ReadInteger('Setup', 'WinLottery5Max', g_Config.nWinLottery5Max);

  if Config.ReadInteger('Setup', 'WinLottery6Min', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery6Min', g_Config.nWinLottery6Min);
  g_Config.nWinLottery6Min := Config.ReadInteger('Setup', 'WinLottery6Min', g_Config.nWinLottery6Min);

  if Config.ReadInteger('Setup', 'WinLottery6Max', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery6Max', g_Config.nWinLottery6Max);
  g_Config.nWinLottery6Max := Config.ReadInteger('Setup', 'WinLottery6Max', g_Config.nWinLottery6Max);

  if Config.ReadInteger('Setup', 'WinLotteryRate', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLotteryRate', g_Config.nWinLotteryRate);
  g_Config.nWinLotteryRate := Config.ReadInteger('Setup', 'WinLotteryRate', g_Config.nWinLotteryRate);

  if Config.ReadInteger('Setup', 'WinLottery1Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery1Gold', g_Config.nWinLottery1Gold);
  g_Config.nWinLottery1Gold := Config.ReadInteger('Setup', 'WinLottery1Gold', g_Config.nWinLottery1Gold);

  if Config.ReadInteger('Setup', 'WinLottery2Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery2Gold', g_Config.nWinLottery2Gold);
  g_Config.nWinLottery2Gold := Config.ReadInteger('Setup', 'WinLottery2Gold', g_Config.nWinLottery2Gold);

  if Config.ReadInteger('Setup', 'WinLottery3Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery3Gold', g_Config.nWinLottery3Gold);
  g_Config.nWinLottery3Gold := Config.ReadInteger('Setup', 'WinLottery3Gold', g_Config.nWinLottery3Gold);

  if Config.ReadInteger('Setup', 'WinLottery4Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery4Gold', g_Config.nWinLottery4Gold);
  g_Config.nWinLottery4Gold := Config.ReadInteger('Setup', 'WinLottery4Gold', g_Config.nWinLottery4Gold);

  if Config.ReadInteger('Setup', 'WinLottery5Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery5Gold', g_Config.nWinLottery5Gold);
  g_Config.nWinLottery5Gold := Config.ReadInteger('Setup', 'WinLottery5Gold', g_Config.nWinLottery5Gold);

  if Config.ReadInteger('Setup', 'WinLottery6Gold', -1) < 0 then
    Config.WriteInteger('Setup', 'WinLottery6Gold', g_Config.nWinLottery6Gold);
  g_Config.nWinLottery6Gold := Config.ReadInteger('Setup', 'WinLottery6Gold', g_Config.nWinLottery6Gold);

  if Config.ReadInteger('Setup', 'GuildRecallTime', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildRecallTime', g_Config.nGuildRecallTime);
  g_Config.nGuildRecallTime := Config.ReadInteger('Setup', 'GuildRecallTime', g_Config.nGuildRecallTime);

  if Config.ReadInteger('Setup', 'GroupRecallTime', -1) < 0 then
    Config.WriteInteger('Setup', 'GroupRecallTime', g_Config.nGroupRecallTime);
  g_Config.nGroupRecallTime := Config.ReadInteger('Setup', 'GroupRecallTime', g_Config.nGroupRecallTime);

  if Config.ReadInteger('Setup', 'ControlDropItem', -1) < 0 then
    Config.WriteBool('Setup', 'ControlDropItem', g_Config.boControlDropItem);
  g_Config.boControlDropItem := Config.ReadBool('Setup', 'ControlDropItem', g_Config.boControlDropItem);

  if Config.ReadInteger('Setup', 'InSafeDisableDrop', -1) < 0 then
    Config.WriteBool('Setup', 'InSafeDisableDrop', g_Config.boInSafeDisableDrop);
  g_Config.boInSafeDisableDrop := Config.ReadBool('Setup', 'InSafeDisableDrop', g_Config.boInSafeDisableDrop);

  if Config.ReadInteger('Setup', 'CanDropGold', -1) < 0 then
    Config.WriteInteger('Setup', 'CanDropGold', g_Config.nCanDropGold);
  g_Config.nCanDropGold := Config.ReadInteger('Setup', 'CanDropGold', g_Config.nCanDropGold);

  if Config.ReadInteger('Setup', 'CanDropPrice', -1) < 0 then
    Config.WriteInteger('Setup', 'CanDropPrice', g_Config.nCanDropPrice);
  g_Config.nCanDropPrice := Config.ReadInteger('Setup', 'CanDropPrice', g_Config.nCanDropPrice);

  nLoadInteger := Config.ReadInteger('Setup', 'SendCustemMsg', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SendCustemMsg', g_Config.boSendCustemMsg)
  else
    g_Config.boSendCustemMsg := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'SubkMasterSendMsg', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SubkMasterSendMsg', g_Config.boSubkMasterSendMsg)
  else
    g_Config.boSubkMasterSendMsg := nLoadInteger = 1;

  if Config.ReadInteger('Setup', 'SuperRepairPriceRate', -1) < 0 then
    Config.WriteInteger('Setup', 'SuperRepairPriceRate', g_Config.nSuperRepairPriceRate);
  g_Config.nSuperRepairPriceRate := Config.ReadInteger('Setup', 'SuperRepairPriceRate', g_Config.nSuperRepairPriceRate);

  if Config.ReadInteger('Setup', 'RepairItemDecDura', -1) < 0 then
    Config.WriteInteger('Setup', 'RepairItemDecDura', g_Config.nRepairItemDecDura);
  g_Config.nRepairItemDecDura := Config.ReadInteger('Setup', 'RepairItemDecDura', g_Config.nRepairItemDecDura);

  if Config.ReadInteger('Setup', 'DieScatterBag', -1) < 0 then
    Config.WriteBool('Setup', 'DieScatterBag', g_Config.boDieScatterBag);
  g_Config.boDieScatterBag := Config.ReadBool('Setup', 'DieScatterBag', g_Config.boDieScatterBag);

  if Config.ReadInteger('Setup', 'DieScatterBagRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DieScatterBagRate', g_Config.nDieScatterBagRate);
  g_Config.nDieScatterBagRate := Config.ReadInteger('Setup', 'DieScatterBagRate', g_Config.nDieScatterBagRate);

  if Config.ReadInteger('Setup', 'DieRedScatterBagAll', -1) < 0 then
    Config.WriteBool('Setup', 'DieRedScatterBagAll', g_Config.boDieRedScatterBagAll);
  g_Config.boDieRedScatterBagAll := Config.ReadBool('Setup', 'DieRedScatterBagAll', g_Config.boDieRedScatterBagAll);

  if Config.ReadInteger('Setup', 'DieDropUseItemRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DieDropUseItemRate', g_Config.nDieDropUseItemRate);
  g_Config.nDieDropUseItemRate := Config.ReadInteger('Setup', 'DieDropUseItemRate', g_Config.nDieDropUseItemRate);

  if Config.ReadInteger('Setup', 'DieRedDropUseItemRate', -1) < 0 then
    Config.WriteInteger('Setup', 'DieRedDropUseItemRate', g_Config.nDieRedDropUseItemRate);
  g_Config.nDieRedDropUseItemRate := Config.ReadInteger('Setup', 'DieRedDropUseItemRate', g_Config.nDieRedDropUseItemRate);

  if Config.ReadInteger('Setup', 'MonDieDropUseItemRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MonDieDropUseItemRate', g_Config.nMonDieDropUseItemRate);
  g_Config.nMonDieDropUseItemRate := Config.ReadInteger('Setup', 'MonDieDropUseItemRate', g_Config.nMonDieDropUseItemRate);

  if Config.ReadInteger('Setup', 'DieDropGold', -1) < 0 then
    Config.WriteBool('Setup', 'DieDropGold', g_Config.boDieDropGold);
  g_Config.boDieDropGold := Config.ReadBool('Setup', 'DieDropGold', g_Config.boDieDropGold);

  if Config.ReadInteger('Setup', 'DropGoldToPlayBag', -1) < 0 then
    Config.WriteBool('Setup', 'DropGoldToPlayBag', g_Config.boDropGoldToPlayBag);
  g_Config.boDropGoldToPlayBag := Config.ReadBool('Setup', 'DropGoldToPlayBag', g_Config.boDropGoldToPlayBag);

  if Config.ReadInteger('Setup', 'KillByHumanDropUseItem', -1) < 0 then
    Config.WriteBool('Setup', 'KillByHumanDropUseItem', g_Config.boKillByHumanDropUseItem);
  g_Config.boKillByHumanDropUseItem := Config.ReadBool('Setup', 'KillByHumanDropUseItem', g_Config.boKillByHumanDropUseItem);

  if Config.ReadInteger('Setup', 'KillByMonstDropUseItem', -1) < 0 then
    Config.WriteBool('Setup', 'KillByMonstDropUseItem', g_Config.boKillByMonstDropUseItem);
  g_Config.boKillByMonstDropUseItem := Config.ReadBool('Setup', 'KillByMonstDropUseItem', g_Config.boKillByMonstDropUseItem);

  if Config.ReadInteger('Setup', 'KickExpireHuman', -1) < 0 then
    Config.WriteBool('Setup', 'KickExpireHuman', g_Config.boKickExpireHuman);
  g_Config.boKickExpireHuman := Config.ReadBool('Setup', 'KickExpireHuman', g_Config.boKickExpireHuman);

  if Config.ReadInteger('Setup', 'GuildRankNameLen', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildRankNameLen', g_Config.nGuildRankNameLen);
  g_Config.nGuildRankNameLen := Config.ReadInteger('Setup', 'GuildRankNameLen', g_Config.nGuildRankNameLen);

  if Config.ReadInteger('Setup', 'GuildNameLen', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildNameLen', g_Config.nGuildNameLen);
  g_Config.nGuildNameLen := Config.ReadInteger('Setup', 'GuildNameLen', g_Config.nGuildNameLen);

  if Config.ReadInteger('Setup', 'GuildMemberMaxLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'GuildMemberMaxLimit', g_Config.nGuildMemberMaxLimit);
  g_Config.nGuildMemberMaxLimit := Config.ReadInteger('Setup', 'GuildMemberMaxLimit', g_Config.nGuildMemberMaxLimit);

  if Config.ReadInteger('Setup', 'AttackPosionRate', -1) < 0 then
    Config.WriteInteger('Setup', 'AttackPosionRate', g_Config.nAttackPosionRate);
  g_Config.nAttackPosionRate := Config.ReadInteger('Setup', 'AttackPosionRate', g_Config.nAttackPosionRate);

  nLoadInteger := Config.ReadInteger('Setup', 'AutoClearEctype', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'AutoClearEctype', g_Config.boAutoClearEctype)
  else
    g_Config.boAutoClearEctype := nLoadInteger = 1;

  if Config.ReadInteger('Setup', 'AutoClearEctypeTick', -1) < 0 then
    Config.WriteInteger('Setup', 'AutoClearEctypeTick', g_Config.nAutoClearEctypeTick);
  g_Config.nAutoClearEctypeTick := Config.ReadInteger('Setup', 'AutoClearEctypeTick', g_Config.nAutoClearEctypeTick);

  nLoadInteger := Config.ReadInteger('Setup', 'SaveRcdNow', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SaveRcdNow', g_Config.boSaveRcdNow)
  else
    g_Config.boSaveRcdNow := nLoadInteger = 1;

  if Config.ReadInteger('Setup', 'AttackPosionTime', -1) < 0 then
    Config.WriteInteger('Setup', 'AttackPosionTime', g_Config.nAttackPosionTime);
  g_Config.nAttackPosionTime := Config.ReadInteger('Setup', 'AttackPosionTime', g_Config.nAttackPosionTime);

  if Config.ReadInteger('Setup', 'RevivalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'RevivalTime', g_Config.dwRevivalTime);
  g_Config.dwRevivalTime := Config.ReadInteger('Setup', 'RevivalTime', g_Config.dwRevivalTime);

  nLoadInteger := Config.ReadInteger('Setup', 'UserMoveCanDupObj', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'UserMoveCanDupObj', g_Config.boUserMoveCanDupObj)
  else
    g_Config.boUserMoveCanDupObj := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'UserMoveCanOnItem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'UserMoveCanOnItem', g_Config.boUserMoveCanOnItem)
  else
    g_Config.boUserMoveCanOnItem := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'UserMoveTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'UserMoveTime', g_Config.dwUserMoveTime)
  else
    g_Config.dwUserMoveTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PKDieLostExpRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PKDieLostExpRate', g_Config.dwPKDieLostExpRate)
  else
    g_Config.dwPKDieLostExpRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PKDieLostLevelRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PKDieLostLevelRate',
      g_Config.nPKDieLostLevelRate)
  else
    g_Config.nPKDieLostLevelRate := nLoadInteger;

  if Config.ReadInteger('Setup', 'PKFlagNameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'PKFlagNameColor', g_Config.btPKFlagNameColor);
  g_Config.btPKFlagNameColor := Config.ReadInteger('Setup', 'PKFlagNameColor',
    g_Config.btPKFlagNameColor);

  if Config.ReadInteger('Setup', 'AllyAndGuildNameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'AllyAndGuildNameColor',
      g_Config.btAllyAndGuildNameColor);
  g_Config.btAllyAndGuildNameColor := Config.ReadInteger('Setup',
    'AllyAndGuildNameColor', g_Config.btAllyAndGuildNameColor);

  if Config.ReadInteger('Setup', 'WarGuildNameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'WarGuildNameColor',
      g_Config.btWarGuildNameColor);
  g_Config.btWarGuildNameColor := Config.ReadInteger('Setup',
    'WarGuildNameColor', g_Config.btWarGuildNameColor);

  if Config.ReadInteger('Setup', 'InFreePKAreaNameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'InFreePKAreaNameColor',
      g_Config.btInFreePKAreaNameColor);
  g_Config.btInFreePKAreaNameColor := Config.ReadInteger('Setup',
    'InFreePKAreaNameColor', g_Config.btInFreePKAreaNameColor);

  if Config.ReadInteger('Setup', 'PKLevel1NameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'PKLevel1NameColor',
      g_Config.btPKLevel1NameColor);
  g_Config.btPKLevel1NameColor := Config.ReadInteger('Setup',
    'PKLevel1NameColor', g_Config.btPKLevel1NameColor);

  if Config.ReadInteger('Setup', 'PKLevel2NameColor', -1) < 0 then
    Config.WriteInteger('Setup', 'PKLevel2NameColor',
      g_Config.btPKLevel2NameColor);
  g_Config.btPKLevel2NameColor := Config.ReadInteger('Setup',
    'PKLevel2NameColor', g_Config.btPKLevel2NameColor);

  if Config.ReadInteger('Setup', 'SpiritMutiny', -1) < 0 then
    Config.WriteBool('Setup', 'SpiritMutiny', g_Config.boSpiritMutiny);
  g_Config.boSpiritMutiny := Config.ReadBool('Setup', 'SpiritMutiny',
    g_Config.boSpiritMutiny);

  if Config.ReadInteger('Setup', 'SpiritMutinyTime', -1) < 0 then
    Config.WriteInteger('Setup', 'SpiritMutinyTime', g_Config.dwSpiritMutinyTime);
  g_Config.dwSpiritMutinyTime := Config.ReadInteger('Setup', 'SpiritMutinyTime', g_Config.dwSpiritMutinyTime);

  //if Config.ReadInteger('Setup', 'SendWhisperPlayCount', -1) < 0 then
  //  Config.WriteInteger('Setup', 'SendWhisperPlayCount', g_Config.nSendWhisperPlayCount);
  //g_Config.nSendWhisperPlayCount := Config.ReadInteger('Setup', 'SendWhisperPlayCount', -1);

  //if Config.ReadInteger('Setup', 'SendWhisperTime', -1) < 0 then
  //  Config.WriteInteger('Setup', 'SendWhisperTime', g_Config.dwSendWhisperTime);
  //g_Config.dwSendWhisperTime := Config.ReadInteger('Setup', 'SendWhisperTime', -1);

  if Config.ReadInteger('Setup', 'SellOffCountLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'SellOffCountLimit', g_Config.SellCount);
  g_Config.SellCount := Config.ReadInteger('Setup', 'SellOffCountLimit', -1);

  if Config.ReadInteger('Setup', 'SellOffRate', -1) < 0 then
    Config.WriteInteger('Setup', 'SellOffRate', g_Config.SellTax);
  g_Config.SellTax := Config.ReadInteger('Setup', 'SellOffRate', -1);

  if Config.ReadInteger('Setup', 'SpiritPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'SpiritPowerRate', g_Config.nSpiritPowerRate);
  g_Config.nSpiritPowerRate := Config.ReadInteger('Setup', 'SpiritPowerRate',
    g_Config.nSpiritPowerRate);

  if Config.ReadInteger('Setup', 'MasterDieMutiny', -1) < 0 then
    Config.WriteBool('Setup', 'MasterDieMutiny', g_Config.boMasterDieMutiny);
  g_Config.boMasterDieMutiny := Config.ReadBool('Setup', 'MasterDieMutiny',
    g_Config.boMasterDieMutiny);

  if Config.ReadInteger('Setup', 'MasterDieMutinyRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterDieMutinyRate',
      g_Config.nMasterDieMutinyRate);
  g_Config.nMasterDieMutinyRate := Config.ReadInteger('Setup',
    'MasterDieMutinyRate', g_Config.nMasterDieMutinyRate);

  if Config.ReadInteger('Setup', 'MasterDieMutinyPower', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterDieMutinyPower',
      g_Config.nMasterDieMutinyPower);
  g_Config.nMasterDieMutinyPower := Config.ReadInteger('Setup',
    'MasterDieMutinyPower', g_Config.nMasterDieMutinyPower);

  if Config.ReadInteger('Setup', 'MasterDieMutinyPower', -1) < 0 then
    Config.WriteInteger('Setup', 'MasterDieMutinyPower',
      g_Config.nMasterDieMutinySpeed);
  g_Config.nMasterDieMutinySpeed := Config.ReadInteger('Setup',
    'MasterDieMutinyPower', g_Config.nMasterDieMutinySpeed);

  nLoadInteger := Config.ReadInteger('Setup', 'BBMonAutoChangeColor', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'BBMonAutoChangeColor',
      g_Config.boBBMonAutoChangeColor)
  else
    g_Config.boBBMonAutoChangeColor := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'BBMonAutoChangeColorTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'BBMonAutoChangeColorTime',
      g_Config.dwBBMonAutoChangeColorTime)
  else
    g_Config.dwBBMonAutoChangeColorTime := nLoadInteger;

  if Config.ReadInteger('Setup', 'OldClientShowHiLevel', -1) < 0 then
    Config.WriteBool('Setup', 'OldClientShowHiLevel', g_Config.boOldClientShowHiLevel);
  g_Config.boOldClientShowHiLevel := Config.ReadBool('Setup', 'OldClientShowHiLevel', g_Config.boOldClientShowHiLevel);

  if Config.ReadInteger('Setup', 'ShowScriptActionMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ShowScriptActionMsg', g_Config.boShowScriptActionMsg);
  g_Config.boShowScriptActionMsg := Config.ReadBool('Setup', 'ShowScriptActionMsg', g_Config.boShowScriptActionMsg);

  if Config.ReadInteger('Setup', 'RunSocketDieLoopLimit', -1) < 0 then
    Config.WriteInteger('Setup', 'RunSocketDieLoopLimit',
      g_Config.nRunSocketDieLoopLimit);
  g_Config.nRunSocketDieLoopLimit := Config.ReadInteger('Setup',
    'RunSocketDieLoopLimit', g_Config.nRunSocketDieLoopLimit);

  if Config.ReadInteger('Setup', 'ThreadRun', -1) < 0 then
    Config.WriteBool('Setup', 'ThreadRun', g_Config.boThreadRun);
  g_Config.boThreadRun := Config.ReadBool('Setup', 'ThreadRun', g_Config.boThreadRun);

  if Config.ReadInteger('Setup', 'DeathColorEffect', -1) < 0 then
    Config.WriteInteger('Setup', 'DeathColorEffect', g_Config.ClientConf.btDieColor);
  g_Config.ClientConf.btDieColor := Config.ReadInteger('Setup', 'DeathColorEffect', g_Config.ClientConf.btDieColor);

  if Config.ReadInteger('Setup', 'ParalyCanRun', -1) < 0 then
    Config.WriteBool('Setup', 'ParalyCanRun', g_Config.ClientConf.boParalyCanRun);
  g_Config.ClientConf.boParalyCanRun := Config.ReadBool('Setup', 'ParalyCanRun', g_Config.ClientConf.boParalyCanRun);

  if Config.ReadInteger('Setup', 'ParalyCanWalk', -1) < 0 then
    Config.WriteBool('Setup', 'ParalyCanWalk', g_Config.ClientConf.boParalyCanWalk);
  g_Config.ClientConf.boParalyCanWalk := Config.ReadBool('Setup', 'ParalyCanWalk', g_Config.ClientConf.boParalyCanWalk);

  if Config.ReadInteger('Setup', 'ParalyCanHit', -1) < 0 then
    Config.WriteBool('Setup', 'ParalyCanHit', g_Config.ClientConf.boParalyCanHit);
  g_Config.ClientConf.boParalyCanHit := Config.ReadBool('Setup', 'ParalyCanHit', g_Config.ClientConf.boParalyCanHit);

  if Config.ReadInteger('Setup', 'ParalyCanSpell', -1) < 0 then
    Config.WriteBool('Setup', 'ParalyCanSpell', g_Config.ClientConf.boParalyCanSpell);
  g_Config.ClientConf.boParalyCanSpell := Config.ReadBool('Setup', 'ParalyCanSpell', g_Config.ClientConf.boParalyCanSpell);

  if Config.ReadInteger('Setup', 'ShowRedHPLable', -1) < 0 then
    Config.WriteBool('Setup', 'ShowRedHPLable', g_Config.ClientConf.boShowRedHPLable);
  g_Config.ClientConf.boShowRedHPLable := Config.ReadBool('Setup', 'ShowRedHPLable', g_Config.ClientConf.boShowRedHPLable);

  if Config.ReadInteger('Setup', 'ShowHPNumber', -1) < 0 then
    Config.WriteBool('Setup', 'ShowHPNumber', g_Config.ClientConf.boShowHPNumber);
  g_Config.ClientConf.boShowHPNumber := Config.ReadBool('Setup', 'ShowHPNumber', g_Config.ClientConf.boShowHPNumber);

  if Config.ReadInteger('Setup', 'ShowExceptionMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ShowExceptionMsg', g_Config.boShowExceptionMsg);
  g_Config.boShowExceptionMsg := Config.ReadBool('Setup', 'ShowExceptionMsg',
    g_Config.boShowExceptionMsg);

  if Config.ReadInteger('Setup', 'ShowPreFixMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ShowPreFixMsg', g_Config.boShowPreFixMsg);
  g_Config.boShowPreFixMsg := Config.ReadBool('Setup', 'ShowPreFixMsg',
    g_Config.boShowPreFixMsg);

  if Config.ReadInteger('Setup', 'MagTurnUndeadLevel', -1) < 0 then
    Config.WriteInteger('Setup', 'MagTurnUndeadLevel',
      g_Config.nMagTurnUndeadLevel);
  g_Config.nMagTurnUndeadLevel := Config.ReadInteger('Setup',
    'MagTurnUndeadLevel', g_Config.nMagTurnUndeadLevel);

  nLoadInteger := Config.ReadInteger('Setup', 'MagTammingLevel', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagTammingLevel', g_Config.nMagTammingLevel)
  else
    g_Config.nMagTammingLevel := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagTammingTargetLevel', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagTammingTargetLevel',
      g_Config.nMagTammingTargetLevel)
  else
    g_Config.nMagTammingTargetLevel := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagTammingTargetHPRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagTammingTargetHPRate',
      g_Config.nMagTammingHPRate)
  else
    g_Config.nMagTammingHPRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagTammingCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagTammingCount', g_Config.nMagTammingCount)
  else
    g_Config.nMagTammingCount := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MabMabeHitRandRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MabMabeHitRandRate',
      g_Config.nMabMabeHitRandRate)
  else
    g_Config.nMabMabeHitRandRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MabMabeHitMinLvLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MabMabeHitMinLvLimit',
      g_Config.nMabMabeHitMinLvLimit)
  else
    g_Config.nMabMabeHitMinLvLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MabMabeHitSucessRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MabMabeHitSucessRate',
      g_Config.nMabMabeHitSucessRate)
  else
    g_Config.nMabMabeHitSucessRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MabMabeHitMabeTimeRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MabMabeHitMabeTimeRate',
      g_Config.nMabMabeHitMabeTimeRate)
  else
    g_Config.nMabMabeHitMabeTimeRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicAttackRage', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicAttackRage', g_Config.nMagicAttackRage)
  else
    g_Config.nMagicAttackRage := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'AmyOunsulPoint', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'AmyOunsulPoint', g_Config.nAmyOunsulPoint)
  else
    g_Config.nAmyOunsulPoint := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'DisableInSafeZoneFireCross', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'DisableInSafeZoneFireCross', g_Config.boDisableInSafeZoneFireCross)
  else
    g_Config.boDisableInSafeZoneFireCross := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'PosMoveAttackOnItem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'PosMoveAttackOnItem', g_Config.fPosMoveAttackOnItem)
  else
    g_Config.fPosMoveAttackOnItem := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'PosMoveAttackParalysisPlayer', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'PosMoveAttackParalysisPlayer', g_Config.fPosMoveAttackParalysisPlayer)
  else
    g_Config.fPosMoveAttackParalysisPlayer := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicIceRainParalysisPlayer', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'MagicIceRainParalysisPlayer', g_Config.fMagicIceRainParalysisPlayer)
  else
    g_Config.fMagicIceRainParalysisPlayer := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicDeadEyeParalysisPlayer', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'MagicDeadEyeParalysisPlayer', g_Config.fMagicDeadEyeParalysisPlayer)
  else
    g_Config.fMagicDeadEyeParalysisPlayer := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'PresendItem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'PresendItem', g_Config.boPresendItem)
  else
    g_Config.boPresendItem := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'DieDeductionExp', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'DieDeductionExp', g_Config.fDieDeductionExp)
  else
    g_Config.fDieDeductionExp := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'ProcClientHWID', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ProcClientHWID', g_Config.fProcClientHWID)
  else
    g_Config.fProcClientHWID := nLoadInteger = 1;
    
  nLoadInteger := Config.ReadInteger('Setup', 'SearchHumanOutSafeZone', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SearchHumanOutSafeZone', g_Config.boSearchHumanOutSafeZone)
  else
    g_Config.boSearchHumanOutSafeZone := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'GroupMbAttackPlayObject', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'GroupMbAttackPlayObject', g_Config.boGroupMbAttackPlayObject)
  else
    g_Config.boGroupMbAttackPlayObject := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'GroupMbAttackBaoBao', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'GroupMbAttackBaoBao', g_Config.boGroupMbAttackBaoBao)
  else
    g_Config.boGroupMbAttackBaoBao := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'PosionDecHealthTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PosionDecHealthTime', g_Config.dwPosionDecHealthTime)
  else
    g_Config.dwPosionDecHealthTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PosionDamagarmor', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PosionDamagarmor', g_Config.nPosionDamagarmor)
  else
    g_Config.nPosionDamagarmor := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'LimitSwordLong', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'LimitSwordLong', g_Config.boLimitSwordLong)
  else
    g_Config.boLimitSwordLong := not (nLoadInteger = 0);

  {nLoadInteger := Config.ReadInteger('Setup', 'OffLinePlayLoginType', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'OffLinePlayLoginType', g_Config.nOffLinePlayLoginType)
  else
    g_Config.nOffLinePlayLoginType := nLoadInteger;}

  nLoadInteger := Config.ReadInteger('Setup', 'SwordLongPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SwordLongPowerRate', g_Config.nSwordLongPowerRate)
  else
    g_Config.nSwordLongPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'GroupAttribHPMPRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GroupAttribHPMPRate', g_Config.nGroupAttribHPMPRate)
  else
    g_Config.nGroupAttribHPMPRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'GroupAttribPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GroupAttribPowerRate', g_Config.nGroupAttribPowerRate)
  else
    g_Config.nGroupAttribPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'EnergyStepUpRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'EnergyStepUpRate', g_Config.nEnergyStepUpRate)
  else
    g_Config.nEnergyStepUpRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SkillWWPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SkillWWPowerRate', g_Config.nSkillWWPowerRate)
  else
    g_Config.nSkillWWPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SkillTWPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SkillTWPowerRate', g_Config.nSkillTWPowerRate)
  else
    g_Config.nSkillTWPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SkillZWPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SkillZWPowerRate', g_Config.nSkillZWPowerRate)
  else
    g_Config.nSkillZWPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SkillTTPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SkillTTPowerRate', g_Config.nSkillTTPowerRate)
  else
    g_Config.nSkillTTPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SkillZTPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SkillZTPowerRate', g_Config.nSkillZTPowerRate)
  else
    g_Config.nSkillZTPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SkillZZPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SkillZZPowerRate', g_Config.nSkillZZPowerRate)
  else
    g_Config.nSkillZZPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'FireHitPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'FireHitPowerRate', g_Config.nFireHitPowerRate)
  else
    g_Config.nFireHitPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PursueHitPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PursueHitPowerRate', g_Config.nPursueHitPowerRate)
  else
    g_Config.nPursueHitPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'DoubleAttackCheck', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'DoubleAttackCheck', g_Config.nDoubleAttackCheck)
  else
    g_Config.nDoubleAttackCheck := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'CloneSelfTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'CloneSelfTime', g_Config.dwCloneSelfTime)
  else
    g_Config.dwCloneSelfTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'EatItemTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'EatItemTime', g_Config.nEatItemTime)
  else
    g_Config.nEatItemTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SetShopNeedLevel', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SetShopNeedLevel', g_Config.SetShopNeedLevel)
  else
    g_Config.SetShopNeedLevel := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'GatherExpRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GatherExpRate', g_Config.nGatherExpRate)
  else
    g_Config.nGatherExpRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroMaxHealthRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroMaxHealthRate', g_Config.nHeroMaxHealthRate)
  else
    g_Config.nHeroMaxHealthRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroMaxHealthRate1', -1);
  if nLoadInteger < 0 then begin
    g_Config.nHeroMaxHealthRate1 := g_Config.nHeroMaxHealthRate;
    Config.WriteInteger('Setup', 'HeroMaxHealthRate1', g_Config.nHeroMaxHealthRate1);
  end else
    g_Config.nHeroMaxHealthRate1 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroMaxHealthRate2', -1);
  if nLoadInteger < 0 then begin
    g_Config.nHeroMaxHealthRate2 := g_Config.nHeroMaxHealthRate;
    Config.WriteInteger('Setup', 'HeroMaxHealthRate2', g_Config.nHeroMaxHealthRate2);
  end else
    g_Config.nHeroMaxHealthRate2 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'InternalPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'InternalPowerRate', g_Config.nInternalPowerRate)
  else
    g_Config.nInternalPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MasterRoyaltyRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MasterRoyaltyRate', g_Config.dwMasterRoyaltyRate)
  else
    g_Config.dwMasterRoyaltyRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'DetectItemRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'DetectItemRate', g_Config.nDetectItemRate)
  else
    g_Config.nDetectItemRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MakeItemButchRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MakeItemButchRate', g_Config.nMakeItemButchRate)
  else
    g_Config.nMakeItemButchRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MakeItemRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MakeItemRate', g_Config.nMakeItemRate)
  else
    g_Config.nMakeItemRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'InternalPowerRate2', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'InternalPowerRate2', g_Config.nInternalPowerRate2)
  else
    g_Config.nInternalPowerRate2 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'btSellType', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'btSellType', g_Config.btSellType)
  else
    g_Config.btSellType := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'boDieDropUseItemRateSingle', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boDieDropUseItemRateSingle', g_Config.boDieDropUseItemRateSingle);
  g_Config.boDieDropUseItemRateSingle := Config.ReadBool('Setup', 'boDieDropUseItemRateSingle', g_Config.boDieDropUseItemRateSingle);

  nLoadInteger := Config.ReadInteger('Setup', 'nDieRedDropUseItemRateSingle', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'nDieRedDropUseItemRateSingle', g_Config.nDieRedDropUseItemRateSingle)
  else
    g_Config.nDieRedDropUseItemRateSingle := nLoadInteger;

  for i := Low(g_Config.aDieDropUseItemRate) to High(g_Config.aDieDropUseItemRate) do begin
    nLoadInteger := Config.ReadInteger('Setup', 'aDieDropUseItemRate' + IntToStr(i), -1);
    if nLoadInteger < 0 then
      Config.WriteInteger('Setup', 'aDieDropUseItemRate' + IntToStr(i), g_Config.nDieDropUseItemRate)
    else
      g_Config.aDieDropUseItemRate[i] := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'InternalPowerSkillRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'InternalPowerSkillRate', g_Config.nInternalPowerSkillRate)
  else
    g_Config.nInternalPowerSkillRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicShootingStarPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicShootingStarPowerRate', g_Config.nMagicShootingStarPowerRate)
  else
    g_Config.nMagicShootingStarPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WarrCmpInvTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WarrCmpInvTime', g_Config.nWarrCmpInvTime)
  else
    g_Config.nWarrCmpInvTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WizaCmpInvTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WizaCmpInvTime', g_Config.nWizaCmpInvTime)
  else
    g_Config.nWizaCmpInvTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'TaosCmpInvTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'TaosCmpInvTime', g_Config.nTaosCmpInvTime)
  else
    g_Config.nTaosCmpInvTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'ShadowExpriesTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ShadowExpriesTime', g_Config.nShadowExpriesTime)
  else
    g_Config.nShadowExpriesTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagBubbleDefenceRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagBubbleDefenceRate', g_Config.nMagBubbleDefenceRate)
  else
    g_Config.nMagBubbleDefenceRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'ShieldHoldTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ShieldHoldTime', g_Config.nFireBurnHoldTime)
  else
    g_Config.nFireBurnHoldTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SquareHitPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SquareHitPowerRate', g_Config.nSquareHitPowerRate)
  else
    g_Config.nSquareHitPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SeriesSkillReleaseInvTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SeriesSkillReleaseInvTime', g_Config.nSeriesSkillReleaseInvTime)
  else
    g_Config.nSeriesSkillReleaseInvTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SmiteWideHitSkillInvTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SmiteWideHitSkillInvTime', g_Config.nSmiteWideHitSkillInvTime)
  else
    g_Config.nSmiteWideHitSkillInvTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_100', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_100', g_Config.nPowerRateOfSeriesSkill_100)
  else
    g_Config.nPowerRateOfSeriesSkill_100 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_101', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_101', g_Config.nPowerRateOfSeriesSkill_101)
  else
    g_Config.nPowerRateOfSeriesSkill_101 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_102', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_102', g_Config.nPowerRateOfSeriesSkill_102)
  else
    g_Config.nPowerRateOfSeriesSkill_102 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_103', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_103', g_Config.nPowerRateOfSeriesSkill_103)
  else
    g_Config.nPowerRateOfSeriesSkill_103 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_104', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_104', g_Config.nPowerRateOfSeriesSkill_104)
  else
    g_Config.nPowerRateOfSeriesSkill_104 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_105', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_105', g_Config.nPowerRateOfSeriesSkill_105)
  else
    g_Config.nPowerRateOfSeriesSkill_105 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_106', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_106', g_Config.nPowerRateOfSeriesSkill_106)
  else
    g_Config.nPowerRateOfSeriesSkill_106 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_107', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_107', g_Config.nPowerRateOfSeriesSkill_107)
  else
    g_Config.nPowerRateOfSeriesSkill_107 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_108', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_108', g_Config.nPowerRateOfSeriesSkill_108)
  else
    g_Config.nPowerRateOfSeriesSkill_108 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_109', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_109', g_Config.nPowerRateOfSeriesSkill_109)
  else
    g_Config.nPowerRateOfSeriesSkill_109 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_110', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_110', g_Config.nPowerRateOfSeriesSkill_110)
  else
    g_Config.nPowerRateOfSeriesSkill_110 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_111', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_111', g_Config.nPowerRateOfSeriesSkill_111)
  else
    g_Config.nPowerRateOfSeriesSkill_111 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PowerRateOfSeriesSkill_114', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PowerRateOfSeriesSkill_114', g_Config.nPowerRateOfSeriesSkill_114)
  else
    g_Config.nPowerRateOfSeriesSkill_114 := nLoadInteger;

  sLoadString := Config.ReadString('Setup', 'MaxHealth', '');
  nLoadDword := Dword(Str_ToInt(sLoadString, 0));
  if nLoadDword = 0 then begin
    Config.WriteString('Setup', 'MaxHealth', IntToStr(g_Config.nMaxHealth));
  end else
    g_Config.nMaxHealth := nLoadDword;

  nLoadInteger := Config.ReadInteger('Setup', 'BoneFammDcEx', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'BoneFammDcEx', g_Config.nBoneFammDcEx)
  else
    g_Config.nBoneFammDcEx := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'DogzDcEx', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'DogzDcEx', g_Config.nDogzDcEx)
  else
    g_Config.nDogzDcEx := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'AngelDcEx', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'AngelDcEx', g_Config.nAngelDcEx)
  else
    g_Config.nAngelDcEx := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagSuckHpRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagSuckHpRate', g_Config.nMagSuckHpRate)
  else
    g_Config.nMagSuckHpRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagSuckHpPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagSuckHpPowerRate', g_Config.nMagSuckHpPowerRate)
  else
    g_Config.nMagSuckHpPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'nMagTwinPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'nMagTwinPowerRate', g_Config.nMagTwinPowerRate)
  else
    g_Config.nMagTwinPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'nMagSquPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'nMagSquPowerRate', g_Config.nMagSquPowerRate)
  else
    g_Config.nMagSquPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SmiteLongHit2PowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SmiteLongHit2PowerRate', g_Config.SmiteLongHit2PowerRate)
  else
    g_Config.SmiteLongHit2PowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SuperSkillInvTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SuperSkillInvTime', g_Config.SuperSkillInvTime)
  else
    g_Config.SuperSkillInvTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'ssPowerRate_115', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ssPowerRate_115', g_Config.ssPowerRate_115)
  else
    g_Config.ssPowerRate_115 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PushedPauseTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PushedPauseTime', g_Config.PushedPauseTime)
  else
    g_Config.PushedPauseTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'nSuperSkill68InvTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'nSuperSkill68InvTime', g_Config.nSuperSkill68InvTime)
  else
    g_Config.nSuperSkill68InvTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'IceMonLiveTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'IceMonLiveTime', g_Config.IceMonLiveTime)
  else
    g_Config.IceMonLiveTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'Skill77Time', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'Skill77Time', g_Config.Skill77Time)
  else
    g_Config.Skill77Time := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'Skill77Inv', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'Skill77Inv', g_Config.Skill77Inv)
  else
    g_Config.Skill77Inv := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'Skill77PowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'Skill77PowerRate', g_Config.Skill77PowerRate)
  else
    g_Config.Skill77PowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SkillMedusaEyeEffectTimeMax', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SkillMedusaEyeEffectTimeMax', g_Config.SkillMedusaEyeEffectTimeMax)
  else
    g_Config.SkillMedusaEyeEffectTimeMax := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'ItemSuiteDamageTypes', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ItemSuiteDamageTypes', g_Config.ItemSuiteDamageTypes)
  else
    g_Config.ItemSuiteDamageTypes := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'DoubleScInvTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'DoubleScInvTime', g_Config.DoubleScInvTime)
  else
    g_Config.DoubleScInvTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'nSSFreezeRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'nSSFreezeRate', g_Config.nSSFreezeRate)
  else
    g_Config.nSSFreezeRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'EffectBonuPointLevel', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'EffectBonuPointLevel', g_Config.nEffectBonuPointLevel)
  else
    g_Config.nEffectBonuPointLevel := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'btMaxPowerLuck', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'btMaxPowerLuck', g_Config.btMaxPowerLuck)
  else
    g_Config.btMaxPowerLuck := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'nDoubleScRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'nDoubleScRate', g_Config.nDoubleScRate)
  else
    g_Config.nDoubleScRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroMaxHealthType', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroMaxHealthType', g_Config.boHeroMaxHealthType)
  else
    g_Config.boHeroMaxHealthType := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpSkillAddHPMax', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'tiSpSkillAddHPMax', g_Config.tiSpSkillAddHPMax)
  else
    g_Config.tiSpSkillAddHPMax := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'tiHPSkillAddHPMax', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'tiHPSkillAddHPMax', g_Config.tiHPSkillAddHPMax)
  else
    g_Config.tiHPSkillAddHPMax := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'tiMPSkillAddMPMax', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'tiMPSkillAddMPMax', g_Config.tiMPSkillAddMPMax)
  else
    g_Config.tiMPSkillAddMPMax := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'SquAttackLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SquAttackLimit', g_Config.boLimitSquAttack)
  else
    g_Config.boLimitSquAttack := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'IgnoreTagDefence', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'IgnoreTagDefence', g_Config.boIgnoreTagDefence)
  else
    g_Config.boIgnoreTagDefence := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'IgnoreTagDefence2', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'IgnoreTagDefence2', g_Config.boIgnoreTagDefence2)
  else
    g_Config.boIgnoreTagDefence2 := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'ClientAutoPlay', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ClientAutoPlay', g_Config.boClientAutoPlay)
  else
    g_Config.boClientAutoPlay := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'HeroSystem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroSystem', g_Config.boHeroSystem)
  else
    g_Config.boHeroSystem := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boBindNoScatter', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boBindNoScatter', g_Config.boBindNoScatter)
  else
    g_Config.boBindNoScatter := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boBindNoMelt', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boBindNoMelt', g_Config.boBindNoMelt)
  else
    g_Config.boBindNoMelt := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boBindNoUse', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boBindNoUse', g_Config.boBindNoUse)
  else
    g_Config.boBindNoUse := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boBindNoSell', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boBindNoSell', g_Config.boBindNoSell)
  else
    g_Config.boBindNoSell := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boBindNoPickUp', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boBindNoPickUp', g_Config.boBindNoPickUp)
  else
    g_Config.boBindNoPickUp := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'ClientAutoSay', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ClientAutoSay', g_Config.ClientAutoSay)
  else
    g_Config.ClientAutoSay := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'MutiHero', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'MutiHero', g_Config.cbMutiHero)
  else
    g_Config.cbMutiHero := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'ViewWhisper', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ViewWhisper', g_Config.boViewWhisper)
  else
    g_Config.boViewWhisper := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'BindPickUp', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'BindPickUp', g_Config.boBindPickUp)
  else
    g_Config.boBindPickUp := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'BindTakeOn', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'BindTakeOn', g_Config.boBindTakeOn)
  else
    g_Config.boBindTakeOn := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'AddValEx', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'AddValEx', g_Config.boAddValEx)
  else
    g_Config.boAddValEx := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'HeroAutoLockTarget', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroAutoLockTarget', g_Config.boHeroAutoLockTarget)
  else
    g_Config.boHeroAutoLockTarget := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boHeroHitCmp', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boHeroHitCmp', g_Config.boHeroHitCmp)
  else
    g_Config.boHeroHitCmp := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boHeroEvade', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boHeroEvade', g_Config.boHeroEvade)
  else
    g_Config.boHeroEvade := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boHeroRecalcWalkTick', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boHeroRecalcWalkTick', g_Config.boHeroRecalcWalkTick)
  else
    g_Config.boHeroRecalcWalkTick := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'Skill_114_MP', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'Skill_114_MP', g_Config.boSkill_114_MP)
  else
    g_Config.boSkill_114_MP := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'tiOpenSystem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'tiOpenSystem', g_Config.tiOpenSystem)
  else
    g_Config.tiOpenSystem := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'tiPutAbilOnce', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'tiPutAbilOnce', g_Config.tiPutAbilOnce)
  else
    g_Config.tiPutAbilOnce := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'Skill_68_MP', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'Skill_68_MP', g_Config.boSkill_68_MP)
  else
    g_Config.boSkill_68_MP := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'SmiteDamegeShow', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SmiteDamegeShow', g_Config.cbSmiteDamegeShow)
  else
    g_Config.cbSmiteDamegeShow := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'SpeedCtrl', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SpeedCtrl', g_Config.boSpeedCtrl)
  else
    g_Config.boSpeedCtrl := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boRecallHeroCtrl', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boRecallHeroCtrl', g_Config.boRecallHeroCtrl)
  else
    g_Config.boRecallHeroCtrl := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'EffectHeroDropRate', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'EffectHeroDropRate', g_Config.EffectHeroDropRate)
  else
    g_Config.EffectHeroDropRate := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'ClientAotoLongAttack', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ClientAotoLongAttack', g_Config.ClientAotoLongAttack)
  else
    g_Config.ClientAotoLongAttack := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'LargeMagicRange', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'LargeMagicRange', g_Config.LargeMagicRange)
  else
    g_Config.LargeMagicRange := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boTDBeffect', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boTDBeffect', g_Config.boTDBeffect)
  else
    g_Config.boTDBeffect := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'SpeedHackCheck', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SpeedHackCheck', g_Config.boSpeedHackCheck)
  else
    g_Config.boSpeedHackCheck := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'StallSystem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'StallSystem', g_Config.boStallSystem)
  else
    g_Config.boStallSystem := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'ClientNoFog', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ClientNoFog', g_Config.boClientNoFog)
  else
    g_Config.boClientNoFog := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'DeathWalking', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'DeathWalking', g_Config.DeathWalking)
  else
    g_Config.DeathWalking := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'SpiritMutinyDie', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SpiritMutinyDie', g_Config.boSpiritMutinyDie)
  else
    g_Config.boSpiritMutinyDie := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boMedalItemLight', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boMedalItemLight', g_Config.boMedalItemLight)
  else
    g_Config.boMedalItemLight := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'boNullAttackOnSale', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'boNullAttackOnSale', g_Config.boNullAttackOnSale)
  else
    g_Config.boNullAttackOnSale := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'NoDoubleFireHit', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'NoDoubleFireHit', g_Config.boNoDoubleFireHit)
  else
    g_Config.boNoDoubleFireHit := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'NoDoublePursueHit', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'NoDoublePursueHit', g_Config.boNoDoublePursueHit)
  else
    g_Config.boNoDoublePursueHit := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'DisableDoubleAttack', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'DisableDoubleAttack', g_Config.boDisableDoubleAttack)
  else
    g_Config.boDisableDoubleAttack := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'SafeZonePush', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SafeZonePush', g_Config.boSafeZonePush)
  else
    g_Config.boSafeZonePush := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'HeroDoMotaebo', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroDoMotaebo', g_Config.boHeroDoMotaebo)
  else
    g_Config.boHeroDoMotaebo := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'SaveKillMonExpRate', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'SaveKillMonExpRate', g_Config.boSaveKillMonExpRate)
  else
    g_Config.boSaveKillMonExpRate := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'EnableMapEvent', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'EnableMapEvent', g_Config.boEnableMapEvent)
  else
    g_Config.boEnableMapEvent := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'HeroShowMasterName', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroShowMasterName', g_Config.boPShowMasterName)
  else
    g_Config.boPShowMasterName := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'MagCapturePlayer', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'MagCapturePlayer', g_Config.boMagCapturePlayer)
  else
    g_Config.boMagCapturePlayer := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'AllowHeroPickUpItem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'AllowHeroPickUpItem', g_Config.boAllowHeroPickUpItem)
  else
    g_Config.boAllowHeroPickUpItem := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'TaosHeroAutoChangePoison', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'TaosHeroAutoChangePoison', g_Config.boTaosHeroAutoChangePoison)
  else
    g_Config.boTaosHeroAutoChangePoison := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'CalcHeroHitSpeed', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'CalcHeroHitSpeed', g_Config.boCalcHeroHitSpeed)
  else
    g_Config.boCalcHeroHitSpeed := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'AllowJointAttack', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'AllowJointAttack', g_Config.boAllowJointAttack)
  else
    g_Config.boAllowJointAttack := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'HeroHomicideAddPKPoint', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroHomicideAddPKPoint', g_Config.boHeroHomicideAddPKPoint)
  else
    g_Config.boHeroHomicideAddPKPoint := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'HeroHomicideAddMasterPkPoint', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroHomicideAddMasterPkPoint', g_Config.boHeroHomicideAddMasterPkPoint)
  else
    g_Config.boHeroHomicideAddMasterPkPoint := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'HeroLockTarget', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroLockTarget', g_Config.boHeroLockTarget)
  else
    g_Config.boHeroLockTarget := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'NoButchItemSubGird', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'NoButchItemSubGird', g_Config.boNoButchItemSubGird)
  else
    g_Config.boNoButchItemSubGird := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'ButchItemNeedGird', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ButchItemNeedGird', g_Config.nButchItemNeedGird)
  else
    g_Config.nButchItemNeedGird := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'GroupAttribute', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'GroupAttribute', g_Config.boHumanAttribute)
  else
    g_Config.boHumanAttribute := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'HeroActiveAttack', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroActiveAttack', g_Config.boHeroActiveAttack)
  else
    g_Config.boHeroActiveAttack := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'FireBurnEventOff', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'FireBurnEventOff', g_Config.boFireBurnEventOff)
  else
    g_Config.boFireBurnEventOff := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'ExtendStorage', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ExtendStorage', g_Config.boExtendStorage)
  else
    g_Config.boExtendStorage := False;  //not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'ExtendUserData', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ExtendUserData', g_Config.boUseCustomData)
  else
    g_Config.boUseCustomData := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'FireBoomRage', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'FireBoomRage', g_Config.nFireBoomRage)
  else
    g_Config.nFireBoomRage := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'SnowWindRange', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SnowWindRange', g_Config.nSnowWindRange)
  else
    g_Config.nSnowWindRange := nLoadInteger;

  if Config.ReadInteger('Setup', 'ElecBlizzardRange', -1) < 0 then
    Config.WriteInteger('Setup', 'ElecBlizzardRange', g_Config.nElecBlizzardRange);
  g_Config.nElecBlizzardRange := Config.ReadInteger('Setup', 'ElecBlizzardRange', g_Config.nElecBlizzardRange);

  if Config.ReadInteger('Setup', 'HumanLevelDiffer', -1) < 0 then
    Config.WriteInteger('Setup', 'HumanLevelDiffer', g_Config.nHumanLevelDiffer);
  g_Config.nHumanLevelDiffer := Config.ReadInteger('Setup', 'HumanLevelDiffer', g_Config.nHumanLevelDiffer);

  if Config.ReadInteger('Setup', 'KillHumanWinLevel', -1) < 0 then
    Config.WriteBool('Setup', 'KillHumanWinLevel', g_Config.boKillHumanWinLevel);
  g_Config.boKillHumanWinLevel := Config.ReadBool('Setup', 'KillHumanWinLevel', g_Config.boKillHumanWinLevel);

  if Config.ReadInteger('Setup', 'KilledLostLevel', -1) < 0 then
    Config.WriteBool('Setup', 'KilledLostLevel', g_Config.boKilledLostLevel);
  g_Config.boKilledLostLevel := Config.ReadBool('Setup', 'KilledLostLevel', g_Config.boKilledLostLevel);

  if Config.ReadInteger('Setup', 'KillHumanWinLevelPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanWinLevelPoint', g_Config.nKillHumanWinLevel);
  g_Config.nKillHumanWinLevel := Config.ReadInteger('Setup', 'KillHumanWinLevelPoint', g_Config.nKillHumanWinLevel);

  if Config.ReadInteger('Setup', 'KilledLostLevelPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KilledLostLevelPoint', g_Config.nKilledLostLevel);
  g_Config.nKilledLostLevel := Config.ReadInteger('Setup', 'KilledLostLevelPoint', g_Config.nKilledLostLevel);

  if Config.ReadInteger('Setup', 'KillHumanWinExp', -1) < 0 then
    Config.WriteBool('Setup', 'KillHumanWinExp', g_Config.boKillHumanWinExp);
  g_Config.boKillHumanWinExp := Config.ReadBool('Setup', 'KillHumanWinExp', g_Config.boKillHumanWinExp);

  if Config.ReadInteger('Setup', 'KilledLostExp', -1) < 0 then
    Config.WriteBool('Setup', 'KilledLostExp', g_Config.boKilledLostExp);
  g_Config.boKilledLostExp := Config.ReadBool('Setup', 'KilledLostExp', g_Config.boKilledLostExp);

  if Config.ReadInteger('Setup', 'KillHumanWinExpPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanWinExpPoint', g_Config.nKillHumanWinExp);
  g_Config.nKillHumanWinExp := Config.ReadInteger('Setup', 'KillHumanWinExpPoint', g_Config.nKillHumanWinExp);

  if Config.ReadInteger('Setup', 'KillHumanLostExpPoint', -1) < 0 then
    Config.WriteInteger('Setup', 'KillHumanLostExpPoint', g_Config.nKillHumanLostExp);
  g_Config.nKillHumanLostExp := Config.ReadInteger('Setup', 'KillHumanLostExpPoint', g_Config.nKillHumanLostExp);

  if Config.ReadInteger('Setup', 'MonsterPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'MonsterPowerRate', g_Config.nMonsterPowerRate);
  g_Config.nMonsterPowerRate := Config.ReadInteger('Setup', 'MonsterPowerRate', g_Config.nMonsterPowerRate);

  if Config.ReadInteger('Setup', 'ItemsPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemsPowerRate', g_Config.nItemsPowerRate);
  g_Config.nItemsPowerRate := Config.ReadInteger('Setup', 'ItemsPowerRate',
    g_Config.nItemsPowerRate);

  if Config.ReadInteger('Setup', 'ItemsACPowerRate', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemsACPowerRate', g_Config.nItemsACPowerRate);
  g_Config.nItemsACPowerRate := Config.ReadInteger('Setup', 'ItemsACPowerRate', g_Config.nItemsACPowerRate);

  if Config.ReadInteger('Setup', 'SendOnlineCount', -1) < 0 then
    Config.WriteBool('Setup', 'SendOnlineCount', g_Config.boSendOnlineCount);
  g_Config.boSendOnlineCount := Config.ReadBool('Setup', 'SendOnlineCount', g_Config.boSendOnlineCount);

  if Config.ReadInteger('Setup', 'SendOnlineCountRate', -1) < 0 then
    Config.WriteInteger('Setup', 'SendOnlineCountRate', g_Config.nSendOnlineCountRate);
  g_Config.nSendOnlineCountRate := Config.ReadInteger('Setup', 'SendOnlineCountRate', g_Config.nSendOnlineCountRate);

  if Config.ReadInteger('Setup', 'SendOnlineTime', -1) < 0 then
    Config.WriteInteger('Setup', 'SendOnlineTime', g_Config.dwSendOnlineTime);
  g_Config.dwSendOnlineTime := Config.ReadInteger('Setup', 'SendOnlineTime', g_Config.dwSendOnlineTime);

  if Config.ReadInteger('Setup', 'SaveHumanRcdTime', -1) < 0 then
    Config.WriteInteger('Setup', 'SaveHumanRcdTime', g_Config.dwSaveHumanRcdTime);
  g_Config.dwSaveHumanRcdTime := Config.ReadInteger('Setup', 'SaveHumanRcdTime', g_Config.dwSaveHumanRcdTime);
  if g_Config.dwSaveHumanRcdTime < 10 * 60 * 1000 then begin
    g_Config.dwSaveHumanRcdTime := 10 * 60 * 1000;
    Config.WriteInteger('Setup', 'SaveHumanRcdTime', g_Config.dwSaveHumanRcdTime);
  end;

  if Config.ReadInteger('Setup', 'HumanFreeDelayTime', -1) < 0 then
    Config.WriteInteger('Setup', 'HumanFreeDelayTime', g_Config.dwHumanFreeDelayTime);
  //g_Config.dwHumanFreeDelayTime := Config.ReadInteger('Setup', 'HumanFreeDelayTime', g_Config.dwHumanFreeDelayTime);

  if Config.ReadInteger('Setup', 'MakeGhostTime', -1) < 0 then
    Config.WriteInteger('Setup', 'MakeGhostTime', g_Config.dwMakeGhostTime);
  g_Config.dwMakeGhostTime := Config.ReadInteger('Setup', 'MakeGhostTime', g_Config.dwMakeGhostTime);

  if Config.ReadInteger('Setup', 'HeroHitSpeedMax', -1) < 0 then
    Config.WriteInteger('Setup', 'HeroHitSpeedMax', g_Config.nHeroHitSpeedMax);
  g_Config.nHeroHitSpeedMax := Config.ReadInteger('Setup', 'HeroHitSpeedMax', g_Config.nHeroHitSpeedMax);

  if Config.ReadInteger('Setup', 'ClearDropOnFloorItemTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ClearDropOnFloorItemTime', g_Config.dwClearDropOnFloorItemTime);
  g_Config.dwClearDropOnFloorItemTime := Config.ReadInteger('Setup', 'ClearDropOnFloorItemTime', g_Config.dwClearDropOnFloorItemTime);

  if Config.ReadInteger('Setup', 'FloorItemCanPickUpTime', -1) < 0 then
    Config.WriteInteger('Setup', 'FloorItemCanPickUpTime', g_Config.dwFloorItemCanPickUpTime);
  g_Config.dwFloorItemCanPickUpTime := Config.ReadInteger('Setup', 'FloorItemCanPickUpTime', g_Config.dwFloorItemCanPickUpTime);

  if Config.ReadInteger('Setup', 'PasswordLockSystem', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockSystem', g_Config.boPasswordLockSystem);
  g_Config.boPasswordLockSystem := Config.ReadBool('Setup', 'PasswordLockSystem', g_Config.boPasswordLockSystem);

  if Config.ReadInteger('Setup', 'PasswordLockDealAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockDealAction', g_Config.boLockDealAction);
  g_Config.boLockDealAction := Config.ReadBool('Setup', 'PasswordLockDealAction', g_Config.boLockDealAction);

  if Config.ReadInteger('Setup', 'PasswordLockDropAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockDropAction', g_Config.boLockDropAction);
  g_Config.boLockDropAction := Config.ReadBool('Setup', 'PasswordLockDropAction', g_Config.boLockDropAction);

  if Config.ReadInteger('Setup', 'PasswordLockGetBackItemAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockGetBackItemAction', g_Config.boLockGetBackItemAction);
  g_Config.boLockGetBackItemAction := Config.ReadBool('Setup', 'PasswordLockGetBackItemAction', g_Config.boLockGetBackItemAction);

  if Config.ReadInteger('Setup', 'PasswordLockHumanLogin', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockHumanLogin', g_Config.boLockHumanLogin);
  g_Config.boLockHumanLogin := Config.ReadBool('Setup', 'PasswordLockHumanLogin', g_Config.boLockHumanLogin);

  if Config.ReadInteger('Setup', 'PasswordLockWalkAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockWalkAction', g_Config.boLockWalkAction);
  g_Config.boLockWalkAction := Config.ReadBool('Setup', 'PasswordLockWalkAction', g_Config.boLockWalkAction);

  if Config.ReadInteger('Setup', 'PasswordLockRunAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockRunAction', g_Config.boLockRunAction);
  g_Config.boLockRunAction := Config.ReadBool('Setup', 'PasswordLockRunAction', g_Config.boLockRunAction);

  if Config.ReadInteger('Setup', 'PasswordLockHitAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockHitAction', g_Config.boLockHitAction);
  g_Config.boLockHitAction := Config.ReadBool('Setup', 'PasswordLockHitAction', g_Config.boLockHitAction);

  if Config.ReadInteger('Setup', 'PasswordLockSpellAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockSpellAction', g_Config.boLockSpellAction);
  g_Config.boLockSpellAction := Config.ReadBool('Setup', 'PasswordLockSpellAction', g_Config.boLockSpellAction);

  if Config.ReadInteger('Setup', 'PasswordLockSendMsgAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockSendMsgAction', g_Config.boLockSendMsgAction);
  g_Config.boLockSendMsgAction := Config.ReadBool('Setup', 'PasswordLockSendMsgAction', g_Config.boLockSendMsgAction);

  if Config.ReadInteger('Setup', 'PasswordLockUserItemAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockUserItemAction', g_Config.boLockUserItemAction);
  g_Config.boLockUserItemAction := Config.ReadBool('Setup', 'PasswordLockUserItemAction', g_Config.boLockUserItemAction);

  if Config.ReadInteger('Setup', 'PasswordLockInObModeAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockInObModeAction', g_Config.boLockInObModeAction);
  g_Config.boLockInObModeAction := Config.ReadBool('Setup', 'PasswordLockInObModeAction', g_Config.boLockInObModeAction);

  if Config.ReadInteger('Setup', 'PasswordErrorKick', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordErrorKick', g_Config.boPasswordErrorKick);
  g_Config.boPasswordErrorKick := Config.ReadBool('Setup', 'PasswordErrorKick', g_Config.boPasswordErrorKick);

  if Config.ReadInteger('Setup', 'PasswordErrorCountLock', -1) < 0 then
    Config.WriteInteger('Setup', 'PasswordErrorCountLock', g_Config.nPasswordErrorCountLock);
  g_Config.nPasswordErrorCountLock := Config.ReadInteger('Setup', 'PasswordErrorCountLock', g_Config.nPasswordErrorCountLock);

  if Config.ReadInteger('Setup', 'PasswordLockRecallHeroAction', -1) < 0 then
    Config.WriteBool('Setup', 'PasswordLockRecallHeroAction', g_Config.boLockRecallAction);
  g_Config.boLockRecallAction := Config.ReadBool('Setup', 'PasswordLockRecallHeroAction', g_Config.boLockRecallAction);

  if Config.ReadInteger('Setup', 'SoftVersionDate', -1) < 0 then
    Config.WriteInteger('Setup', 'SoftVersionDate', g_Config.nSoftVersionDate);
  g_Config.nSoftVersionDate := Config.ReadInteger('Setup', 'SoftVersionDate', g_Config.nSoftVersionDate);

  nLoadInteger := Config.ReadInteger('Setup', 'CanOldClientLogon', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'CanOldClientLogon', g_Config.boCanOldClientLogon)
  else
    g_Config.boCanOldClientLogon := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'OnlyHeroClientLogon', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'OnlyHeroClientLogon', g_Config.boOnlyHeroClientLogon)
  else
    g_Config.boOnlyHeroClientLogon := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'ShowShieldEffect', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ShowShieldEffect', g_Config.boShowShieldEffect)
  else
    g_Config.boShowShieldEffect := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'AutoOpenShield', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'AutoOpenShield', g_Config.boAutoOpenShield)
  else
    g_Config.boAutoOpenShield := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'MagCanHitTarget', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'MagCanHitTarget', g_Config.boMagCanHitTarget)
  else
    g_Config.boMagCanHitTarget := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroNeedAmulet', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'HeroNeedAmulet', g_Config.boHeroNeedAmulet)
  else
    g_Config.boHeroNeedAmulet := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'OpenLevelRankSystem', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'OpenLevelRankSystem', g_Config.boOpenLevelRankSystem)
  else
    g_Config.boOpenLevelRankSystem := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'GetFullRateExp', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'GetFullRateExp', g_Config.boGetFullRateExp)
  else
    g_Config.boGetFullRateExp := nLoadInteger = 1;

  if Config.ReadInteger('Setup', 'CordialAddHPMPMax', -1) < 0 then
    Config.WriteInteger('Setup', 'CordialAddHPMPMax', g_Config.nCordialAddHPMPMax);
  g_Config.nCordialAddHPMPMax := Config.ReadInteger('Setup', 'CordialAddHPMPMax', g_Config.nCordialAddHPMPMax);

  if Config.ReadInteger('Setup', 'HeroLevelExpRate', -1) < 0 then
    Config.WriteInteger('Setup', 'HeroLevelExpRate', g_Config.nHeroLevelExpRate);
  g_Config.nHeroLevelExpRate := Config.ReadInteger('Setup', 'HeroLevelExpRate', g_Config.nHeroLevelExpRate);

  if Config.ReadInteger('Setup', 'ShopItemBind', -1) < 0 then
    Config.WriteInteger('Setup', 'ShopItemBind', g_Config.nShopItemBind);
  g_Config.nShopItemBind := Config.ReadInteger('Setup', 'ShopItemBind', g_Config.nShopItemBind);

  if Config.ReadInteger('Setup', 'ConsoleShowUserCountTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ConsoleShowUserCountTime', g_Config.dwConsoleShowUserCountTime);
  g_Config.dwConsoleShowUserCountTime := Config.ReadInteger('Setup', 'ConsoleShowUserCountTime', g_Config.dwConsoleShowUserCountTime);

  if Config.ReadInteger('Setup', 'ShowLineNoticeTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ShowLineNoticeTime', g_Config.dwShowLineNoticeTime);
  g_Config.dwShowLineNoticeTime := Config.ReadInteger('Setup', 'ShowLineNoticeTime', g_Config.dwShowLineNoticeTime);

  if Config.ReadInteger('Setup', 'LineNoticeColor', -1) < 0 then
    Config.WriteInteger('Setup', 'LineNoticeColor', g_Config.nLineNoticeColor);
  g_Config.nLineNoticeColor := Config.ReadInteger('Setup', 'LineNoticeColor', g_Config.nLineNoticeColor);

  if Config.ReadInteger('Setup', 'ItemSpeedTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ItemSpeedTime', g_Config.ClientConf.btItemSpeed);
  g_Config.ClientConf.btItemSpeed := Config.ReadInteger('Setup', 'ItemSpeedTime', g_Config.ClientConf.btItemSpeed);

  if Config.ReadInteger('Setup', 'MaxHitMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxHitMsgCount', g_Config.nMaxHitMsgCount);
  g_Config.nMaxHitMsgCount := Config.ReadInteger('Setup', 'MaxHitMsgCount', g_Config.nMaxHitMsgCount);

  if Config.ReadInteger('Setup', 'MaxSpellMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxSpellMsgCount', g_Config.nMaxSpellMsgCount);
  g_Config.nMaxSpellMsgCount := Config.ReadInteger('Setup', 'MaxSpellMsgCount', g_Config.nMaxSpellMsgCount);

  if Config.ReadInteger('Setup', 'MaxRunMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxRunMsgCount', g_Config.nMaxRunMsgCount);
  g_Config.nMaxRunMsgCount := Config.ReadInteger('Setup', 'MaxRunMsgCount', g_Config.nMaxRunMsgCount);

  if Config.ReadInteger('Setup', 'MaxWalkMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxWalkMsgCount', g_Config.nMaxWalkMsgCount);
  g_Config.nMaxWalkMsgCount := Config.ReadInteger('Setup', 'MaxWalkMsgCount', g_Config.nMaxWalkMsgCount);

  if Config.ReadInteger('Setup', 'MaxTurnMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxTurnMsgCount', g_Config.nMaxTurnMsgCount);
  g_Config.nMaxTurnMsgCount := Config.ReadInteger('Setup', 'MaxTurnMsgCount', g_Config.nMaxTurnMsgCount);

  if Config.ReadInteger('Setup', 'MaxSitDonwMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxSitDonwMsgCount', g_Config.nMaxSitDonwMsgCount);
  g_Config.nMaxSitDonwMsgCount := Config.ReadInteger('Setup', 'MaxSitDonwMsgCount', g_Config.nMaxSitDonwMsgCount);

  if Config.ReadInteger('Setup', 'MaxDigUpMsgCount', -1) < 0 then
    Config.WriteInteger('Setup', 'MaxDigUpMsgCount', g_Config.nMaxDigUpMsgCount);
  g_Config.nMaxDigUpMsgCount := Config.ReadInteger('Setup', 'MaxDigUpMsgCount', g_Config.nMaxDigUpMsgCount);

  if Config.ReadInteger('Setup', 'SpellSendUpdateMsg', -1) < 0 then
    Config.WriteBool('Setup', 'SpellSendUpdateMsg', g_Config.boSpellSendUpdateMsg);
  g_Config.boSpellSendUpdateMsg := Config.ReadBool('Setup', 'SpellSendUpdateMsg', g_Config.boSpellSendUpdateMsg);

  if Config.ReadInteger('Setup', 'ActionSendActionMsg', -1) < 0 then
    Config.WriteBool('Setup', 'ActionSendActionMsg', g_Config.boActionSendActionMsg);
  g_Config.boActionSendActionMsg := Config.ReadBool('Setup', 'ActionSendActionMsg', g_Config.boActionSendActionMsg);

  if Config.ReadInteger('Setup', 'OverSpeedKickCount', -1) < 0 then
    Config.WriteInteger('Setup', 'OverSpeedKickCount', g_Config.nOverSpeedKickCount);
  g_Config.nOverSpeedKickCount := Config.ReadInteger('Setup', 'OverSpeedKickCount', g_Config.nOverSpeedKickCount);

  if Config.ReadInteger('Setup', 'DropOverSpeed', -1) < 0 then
    Config.WriteInteger('Setup', 'DropOverSpeed', g_Config.dwDropOverSpeed);
  g_Config.dwDropOverSpeed := Config.ReadInteger('Setup', 'DropOverSpeed', g_Config.dwDropOverSpeed);

  if Config.ReadInteger('Setup', 'KickOverSpeed', -1) < 0 then
    Config.WriteBool('Setup', 'KickOverSpeed', g_Config.boKickOverSpeed);
  g_Config.boKickOverSpeed := Config.ReadBool('Setup', 'KickOverSpeed', g_Config.boKickOverSpeed);

  nLoadInteger := Config.ReadInteger('Setup', 'SpeedControlMode', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'SpeedControlMode', g_Config.btSpeedControlMode)
  else
    g_Config.btSpeedControlMode := nLoadInteger;

  if Config.ReadInteger('Setup', 'HitIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'HitIntervalTime', g_Config.dwHitIntervalTime);
  g_Config.dwHitIntervalTime := Config.ReadInteger('Setup', 'HitIntervalTime', g_Config.dwHitIntervalTime);

  if Config.ReadInteger('Setup', 'MagicHitIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'MagicHitIntervalTime', g_Config.dwMagicHitIntervalTime);
  g_Config.dwMagicHitIntervalTime := Config.ReadInteger('Setup', 'MagicHitIntervalTime', g_Config.dwMagicHitIntervalTime);

  if Config.ReadInteger('Setup', 'RunIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'RunIntervalTime', g_Config.dwRunIntervalTime);
  g_Config.dwRunIntervalTime := Config.ReadInteger('Setup', 'RunIntervalTime', g_Config.dwRunIntervalTime);

  if Config.ReadInteger('Setup', 'WalkIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'WalkIntervalTime', g_Config.dwWalkIntervalTime);
  g_Config.dwWalkIntervalTime := Config.ReadInteger('Setup', 'WalkIntervalTime', g_Config.dwWalkIntervalTime);

  if Config.ReadInteger('Setup', 'TurnIntervalTime', -1) < 0 then
    Config.WriteInteger('Setup', 'TurnIntervalTime', g_Config.dwTurnIntervalTime);
  g_Config.dwTurnIntervalTime := Config.ReadInteger('Setup', 'TurnIntervalTime', g_Config.dwTurnIntervalTime);

  nLoadInteger := Config.ReadInteger('Setup', 'ControlActionInterval', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ControlActionInterval', g_Config.boControlActionInterval)
  else
    g_Config.boControlActionInterval := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'ControlWalkHit', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ControlWalkHit', g_Config.boControlWalkHit)
  else
    g_Config.boControlWalkHit := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'ControlRunLongHit', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'ControlRunLongHit', g_Config.boControlRunLongHit)
  else
    g_Config.boControlRunLongHit := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'ControlRunHit', -1);
  if nLoadInteger < 0 then begin
    Config.WriteBool('Setup', 'ControlRunHit', g_Config.boControlRunHit);
  end
  else begin
    g_Config.boControlRunHit := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'ControlRunMagic', -1);
  if nLoadInteger < 0 then begin
    Config.WriteBool('Setup', 'ControlRunMagic', g_Config.boControlRunMagic);
  end
  else begin
    g_Config.boControlRunMagic := nLoadInteger = 1;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'ActionIntervalTime', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'ActionIntervalTime',
      g_Config.dwActionIntervalTime);
  end
  else begin
    g_Config.dwActionIntervalTime := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'RunLongHitIntervalTime', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'RunLongHitIntervalTime',
      g_Config.dwRunLongHitIntervalTime);
  end
  else begin
    g_Config.dwRunLongHitIntervalTime := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'RunHitIntervalTime', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'RunHitIntervalTime',
      g_Config.dwRunHitIntervalTime);
  end
  else begin
    g_Config.dwRunHitIntervalTime := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'WalkHitIntervalTime', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'WalkHitIntervalTime',
      g_Config.dwWalkHitIntervalTime);
  end
  else begin
    g_Config.dwWalkHitIntervalTime := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'RunMagicIntervalTime', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'RunMagicIntervalTime',
      g_Config.dwRunMagicIntervalTime);
  end
  else begin
    g_Config.dwRunMagicIntervalTime := nLoadInteger;
  end;

  if Config.ReadInteger('Setup', 'DisableStruck', -1) < 0 then
    Config.WriteBool('Setup', 'DisableStruck', g_Config.boDisableStruck);
  g_Config.boDisableStruck := Config.ReadBool('Setup', 'DisableStruck', g_Config.boDisableStruck);

  if Config.ReadInteger('Setup', 'DisableSelfStruck', -1) < 0 then
    Config.WriteBool('Setup', 'DisableSelfStruck', g_Config.boDisableSelfStruck);
  g_Config.boDisableSelfStruck := Config.ReadBool('Setup', 'DisableSelfStruck', g_Config.boDisableSelfStruck);

  if Config.ReadInteger('Setup', 'DisableHeroStruck', -1) < 0 then
    Config.WriteBool('Setup', 'DisableHeroStruck', g_Config.boHeroDisableStruck);
  g_Config.boHeroDisableStruck := Config.ReadBool('Setup', 'DisableHeroStruck', g_Config.boHeroDisableStruck);

  if Config.ReadInteger('Setup', 'StruckTime', -1) < 0 then
    Config.WriteInteger('Setup', 'StruckTime', g_Config.dwStruckTime);
  g_Config.dwStruckTime := Config.ReadInteger('Setup', 'StruckTime', g_Config.dwStruckTime);

  nLoadInteger := Config.ReadInteger('Setup', 'AddUserItemNewValue', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'AddUserItemNewValue', g_Config.boAddUserItemNewValue)
  else
    g_Config.boAddUserItemNewValue := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'TestSpeedMode', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'TestSpeedMode', g_Config.boTestSpeedMode)
  else
    g_Config.boTestSpeedMode := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeUnLuckRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WeaponMakeUnLuckRate', g_Config.nWeaponMakeUnLuckRate)
  else
    g_Config.nWeaponMakeUnLuckRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'CheckHookTool', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'CheckHookTool', g_Config.boCheckHookTool)
  else
    g_Config.boCheckHookTool := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'CheckHookToolTimes', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'CheckHookToolTimes', g_Config.nCheckHookToolTimes)
  else
    g_Config.nCheckHookToolTimes := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint1', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint1',
      g_Config.nWeaponMakeLuckPoint1);
  end
  else begin
    g_Config.nWeaponMakeLuckPoint1 := nLoadInteger;
  end;
  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint2', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint2',
      g_Config.nWeaponMakeLuckPoint2);
  end
  else begin
    g_Config.nWeaponMakeLuckPoint2 := nLoadInteger;
  end;
  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint3', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint3',
      g_Config.nWeaponMakeLuckPoint3);
  end
  else begin
    g_Config.nWeaponMakeLuckPoint3 := nLoadInteger;
  end;
  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint2Rate', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint2Rate',
      g_Config.nWeaponMakeLuckPoint2Rate);
  end
  else begin
    g_Config.nWeaponMakeLuckPoint2Rate := nLoadInteger;
  end;
  nLoadInteger := Config.ReadInteger('Setup', 'WeaponMakeLuckPoint3Rate', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'WeaponMakeLuckPoint3Rate',
      g_Config.nWeaponMakeLuckPoint3Rate);
  end
  else begin
    g_Config.nWeaponMakeLuckPoint3Rate := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'CheckUserItemPlace', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'CheckUserItemPlace', g_Config.boCheckUserItemPlace)
  else
    g_Config.boCheckUserItemPlace := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'NoDropItemOfGameGold', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'NoDropItemOfGameGold', g_Config.boNoDropItemOfGameGold)
  else
    g_Config.boNoDropItemOfGameGold := nLoadInteger = 1;

  nLoadInteger := Config.ReadInteger('Setup', 'NoDropItemGamegold', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'NoDropItemGamegold', g_Config.nNoDropItemGamegold)
  else
    g_Config.nNoDropItemGamegold := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'NoScatterBagGamegold', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'NoScatterBagGamegold', g_Config.nNoScatterBagGamegold)
  else
    g_Config.nNoScatterBagGamegold := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagNailTick', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagNailTick', g_Config.dwMagNailTick)
  else
    g_Config.dwMagNailTick := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroNextHitTime_Warr', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroNextHitTime_Warr', g_Config.nHeroNextHitTime_Warr)
  else
    g_Config.nHeroNextHitTime_Warr := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroNextHitTime_Wizard', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroNextHitTime_Wizard', g_Config.nHeroNextHitTime_Wizard)
  else
    g_Config.nHeroNextHitTime_Wizard := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroNextHitTime_Taos', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroNextHitTime_Taos', g_Config.nHeroNextHitTime_Taos)
  else
    g_Config.nHeroNextHitTime_Taos := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroWalkSpeed_Warr', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroWalkSpeed_Warr', g_Config.nHeroWalkSpeed_Warr)
  else
    g_Config.nHeroWalkSpeed_Warr := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroWalkSpeed_Wizard', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroWalkSpeed_Wizard', g_Config.nHeroWalkSpeed_Wizard)
  else
    g_Config.nHeroWalkSpeed_Wizard := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroWalkSpeed_Taos', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroWalkSpeed_Taos', g_Config.nHeroWalkSpeed_Taos)
  else
    g_Config.nHeroWalkSpeed_Taos := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroFireSwordTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroFireSwordTime', g_Config.nHeroFireSwordTime)
  else
    g_Config.nHeroFireSwordTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagNailPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagNailPowerRate', g_Config.nMagNailPowerRate)
  else
    g_Config.nMagNailPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroMainSkill', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroMainSkill', g_Config.nHeroMainSkill)
  else
    g_Config.nHeroMainSkill := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'ScatterRange', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ScatterRange', g_Config.nScatterRange)
  else
    g_Config.nScatterRange := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagIceBallRange', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagIceBallRange', g_Config.nMagIceBallRange)
  else
    g_Config.nMagIceBallRange := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'EarthFirePowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'EarthFirePowerRate', g_Config.nEarthFirePowerRate)
  else
    g_Config.nEarthFirePowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HPStoneStartRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HPStoneStartRate', g_Config.nHPStoneStartRate)
  else
    g_Config.nHPStoneStartRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MPStoneStartRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MPStoneStartRate', g_Config.nMPStoneStartRate)
  else
    g_Config.nMPStoneStartRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HPStoneIntervalTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HPStoneIntervalTime', g_Config.nHPStoneIntervalTime)
  else
    g_Config.nHPStoneIntervalTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MPStoneIntervalTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MPStoneIntervalTime', g_Config.nMPStoneIntervalTime)
  else
    g_Config.nMPStoneIntervalTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HPStoneAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HPStoneAddRate', g_Config.nHPStoneAddRate)
  else
    g_Config.nHPStoneAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MPStoneAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MPStoneAddRate', g_Config.nMPStoneAddRate)
  else
    g_Config.nMPStoneAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HPStoneDecDura', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HPStoneDecDura', g_Config.nHPStoneDecDura)
  else
    g_Config.nHPStoneDecDura := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MPStoneDecDura', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MPStoneDecDura', g_Config.nMPStoneDecDura)
  else
    g_Config.nMPStoneDecDura := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroNameColor', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroNameColor', g_Config.nHeroNameColor)
  else
    g_Config.nHeroNameColor := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroGetExpRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroGetExpRate', g_Config.nHeroGetExpRate)
  else
    g_Config.nHeroGetExpRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroGainExpRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroGainExpRate', g_Config.nHeroGainExpRate)
  else begin
    g_Config.nHeroGainExpRate := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'RecallHeroIntervalTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'RecallHeroIntervalTime', g_Config.nRecallHeroIntervalTime)
  else
    g_Config.nRecallHeroIntervalTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HeroType', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HeroType', g_Config.nTestHeroType)
  else
    g_Config.nTestHeroType := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'LevelValueOfTaosHP', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'LevelValueOfTaosHP', g_Config.nLevelValueOfTaosHP)
  else
    g_Config.nLevelValueOfTaosHP := nLoadInteger;

  nLoadFloat := Config.ReadFloat('Setup', 'LevelValueOfTaosHPRate', 0);
  if nLoadFloat = 0 then begin
    Config.WriteFloat('Setup', 'LevelValueOfTaosHPRate',
      g_Config.nLevelValueOfTaosHPRate);
  end
  else begin
    g_Config.nLevelValueOfTaosHPRate := nLoadFloat;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'LevelValueOfTaosMP', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'LevelValueOfTaosMP',
      g_Config.nLevelValueOfTaosMP);
  end
  else begin
    g_Config.nLevelValueOfTaosMP := nLoadInteger;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'LevelValueOfWizardHP', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'LevelValueOfWizardHP',
      g_Config.nLevelValueOfWizardHP);
  end
  else begin
    g_Config.nLevelValueOfWizardHP := nLoadInteger;
  end;

  nLoadFloat := Config.ReadFloat('Setup', 'LevelValueOfWizardHPRate', 0);
  if nLoadFloat = 0 then begin
    Config.WriteFloat('Setup', 'LevelValueOfWizardHPRate',
      g_Config.nLevelValueOfWizardHPRate);
  end
  else begin
    g_Config.nLevelValueOfWizardHPRate := nLoadFloat;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'LevelValueOfWarrHP', -1);
  if nLoadInteger < 0 then begin
    Config.WriteInteger('Setup', 'LevelValueOfWarrHP', g_Config.nLevelValueOfWarrHP);
  end
  else begin
    g_Config.nLevelValueOfWarrHP := nLoadInteger;
  end;

  nLoadFloat := Config.ReadFloat('Setup', 'LevelValueOfWarrHPRate', 0);
  if nLoadFloat = 0 then
    Config.WriteFloat('Setup', 'LevelValueOfWarrHPRate', g_Config.nLevelValueOfWarrHPRate)
  else
    g_Config.nLevelValueOfWarrHPRate := nLoadFloat;

  nLoadInteger := Config.ReadInteger('Setup', 'ProcessMonsterInterval', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'ProcessMonsterInterval', g_Config.nProcessMonsterInterval)
  else
    g_Config.nProcessMonsterInterval := nLoadInteger;

  if Config.ReadInteger('Setup', 'StartCastleWarDays', -1) < 0 then
    Config.WriteInteger('Setup', 'StartCastleWarDays', g_Config.nStartCastleWarDays);
  g_Config.nStartCastleWarDays := Config.ReadInteger('Setup', 'StartCastleWarDays', g_Config.nStartCastleWarDays);

  if Config.ReadInteger('Setup', 'StartCastlewarTime', -1) < 0 then
    Config.WriteInteger('Setup', 'StartCastlewarTime', g_Config.nStartCastlewarTime);
  g_Config.nStartCastlewarTime := Config.ReadInteger('Setup', 'StartCastlewarTime', g_Config.nStartCastlewarTime);

  if Config.ReadInteger('Setup', 'ShowCastleWarEndMsgTime', -1) < 0 then
    Config.WriteInteger('Setup', 'ShowCastleWarEndMsgTime', g_Config.dwShowCastleWarEndMsgTime);
  g_Config.dwShowCastleWarEndMsgTime := Config.ReadInteger('Setup', 'ShowCastleWarEndMsgTime', g_Config.dwShowCastleWarEndMsgTime);

  if Config.ReadInteger('Setup', 'CastleWarTime', -1) < 0 then
    Config.WriteInteger('Setup', 'CastleWarTime', g_Config.dwCastleWarTime);
  g_Config.dwCastleWarTime := Config.ReadInteger('Setup', 'CastleWarTime', g_Config.dwCastleWarTime);

  nLoadInteger := Config.ReadInteger('Setup', 'GetCastleTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GetCastleTime', g_Config.dwGetCastleTime)
  else
    g_Config.dwGetCastleTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'GuildWarTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'GuildWarTime', g_Config.dwGuildWarTime)
  else
    g_Config.dwGuildWarTime := nLoadInteger;

  for i := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do begin
    nLoadInteger := Config.ReadInteger('Setup', 'GlobalVal' + IntToStr(i), -1);
    if nLoadInteger < 0 then
      Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(i), g_Config.GlobalVal[i])
    else
      g_Config.GlobalVal[i] := nLoadInteger;
  end;

  for i := Low(g_Config.HGlobalVal) to High(g_Config.HGlobalVal) do begin
    nLoadInteger := Config.ReadInteger('Setup', 'HGlobalVal' + IntToStr(i), -1);
    if nLoadInteger < 0 then
      Config.WriteInteger('Setup', 'HGlobalVal' + IntToStr(i), g_Config.HGlobalVal[i])
    else
      g_Config.HGlobalVal[i] := nLoadInteger;
  end;

  for i := Low(g_Config.GlobaDyTval) to High(g_Config.GlobaDyTval) do begin
    sLoadString := Config.ReadString('Setup', 'GlobaStrVal' + IntToStr(i), '');
    if sLoadString = '' then
      Config.WriteString('Setup', 'GlobaStrVal' + IntToStr(i), g_Config.GlobaDyTval[i])
    else
      g_Config.GlobaDyTval[i] := sLoadString;
  end;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryCount', g_Config.nWinLotteryCount)
  else
    g_Config.nWinLotteryCount := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'NoWinLotteryCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'NoWinLotteryCount', g_Config.nNoWinLotteryCount)
  else
    g_Config.nNoWinLotteryCount := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel1', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel1', g_Config.nWinLotteryLevel1)
  else
    g_Config.nWinLotteryLevel1 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel2', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel2', g_Config.nWinLotteryLevel2)
  else
    g_Config.nWinLotteryLevel2 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel3', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel3', g_Config.nWinLotteryLevel3)
  else
    g_Config.nWinLotteryLevel3 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel4', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel4', g_Config.nWinLotteryLevel4)
  else
    g_Config.nWinLotteryLevel4 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel5', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel5', g_Config.nWinLotteryLevel5)
  else
    g_Config.nWinLotteryLevel5 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'WinLotteryLevel6', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'WinLotteryLevel6', g_Config.nWinLotteryLevel6)
  else
    g_Config.nWinLotteryLevel6 := nLoadInteger;

  ///////////ttttiiiiiiiiiiiiiii
  nLoadInteger := Config.ReadInteger('Setup', 'tiSpiritAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpiritAddRate', g_Config.tiSpiritAddRate)
  else
    g_Config.tiSpiritAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpiritAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpiritAddValueRate', g_Config.tiSpiritAddValueRate)
  else
    g_Config.tiSpiritAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSecretPropertyAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSecretPropertyAddRate', g_Config.tiSecretPropertyAddRate)
  else
    g_Config.tiSecretPropertyAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSecretPropertyAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSecretPropertyAddValueMaxLimit', g_Config.tiSecretPropertyAddValueMaxLimit)
  else
    g_Config.tiSecretPropertyAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSecretPropertyAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSecretPropertyAddValueRate', g_Config.tiSecretPropertyAddValueRate)
  else
    g_Config.tiSecretPropertyAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSucessRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSucessRate', g_Config.tiSucessRate)
  else
    g_Config.tiSucessRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSucessRateEx', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSucessRateEx', g_Config.tiSucessRateEx)
  else
    g_Config.tiSucessRateEx := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiExchangeItemRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiExchangeItemRate', g_Config.tiExchangeItemRate)
  else
    g_Config.tiExchangeItemRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'spSecretPropertySucessRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'spSecretPropertySucessRate', g_Config.spSecretPropertySucessRate)
  else
    g_Config.spSecretPropertySucessRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'spMakeBookSucessRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'spMakeBookSucessRate', g_Config.spMakeBookSucessRate)
  else
    g_Config.spMakeBookSucessRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'spEnergyAddTime', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'spEnergyAddTime', g_Config.spEnergyAddTime)
  else
    g_Config.spEnergyAddTime := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAddHealthPlus_0', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAddHealthPlus_0', g_Config.tiAddHealthPlus_0)
  else
    g_Config.tiAddHealthPlus_0 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAddHealthPlus_1', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAddHealthPlus_1', g_Config.tiAddHealthPlus_1)
  else
    g_Config.tiAddHealthPlus_1 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAddHealthPlus_2', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAddHealthPlus_2', g_Config.tiAddHealthPlus_2)
  else
    g_Config.tiAddHealthPlus_2 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAddSpellPlus_0', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAddSpellPlus_0', g_Config.tiAddSpellPlus_0)
  else
    g_Config.tiAddSpellPlus_0 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAddSpellPlus_1', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAddSpellPlus_1', g_Config.tiAddSpellPlus_1)
  else
    g_Config.tiAddSpellPlus_1 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAddSpellPlus_2', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAddSpellPlus_2', g_Config.tiAddSpellPlus_2)
  else
    g_Config.tiAddSpellPlus_2 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponDCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponDCAddRate', g_Config.tiWeaponDCAddRate)
  else
    g_Config.tiWeaponDCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponDCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponDCAddValueMaxLimit', g_Config.tiWeaponDCAddValueMaxLimit)
  else
    g_Config.tiWeaponDCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponDCAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponDCAddValueRate', g_Config.tiWeaponDCAddValueRate)
  else
    g_Config.tiWeaponDCAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponMCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponMCAddRate', g_Config.tiWeaponMCAddRate)
  else
    g_Config.tiWeaponMCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponMCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponMCAddValueMaxLimit', g_Config.tiWeaponMCAddValueMaxLimit)
  else
    g_Config.tiWeaponMCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponMCAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponMCAddValueRate', g_Config.tiWeaponMCAddValueRate)
  else
    g_Config.tiWeaponMCAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponSCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponSCAddRate', g_Config.tiWeaponSCAddRate)
  else
    g_Config.tiWeaponSCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponSCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponSCAddValueMaxLimit', g_Config.tiWeaponSCAddValueMaxLimit)
  else
    g_Config.tiWeaponSCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponSCAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponSCAddValueRate', g_Config.tiWeaponSCAddValueRate)
  else
    g_Config.tiWeaponSCAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponLuckAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponLuckAddRate', g_Config.tiWeaponLuckAddRate)
  else
    g_Config.tiWeaponLuckAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponLuckAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponLuckAddValueMaxLimit', g_Config.tiWeaponLuckAddValueMaxLimit)
  else
    g_Config.tiWeaponLuckAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponLuckAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponLuckAddValueRate', g_Config.tiWeaponLuckAddValueRate)
  else
    g_Config.tiWeaponLuckAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponCurseAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponCurseAddRate', g_Config.tiWeaponCurseAddRate)
  else
    g_Config.tiWeaponCurseAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponCurseAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponCurseAddValueMaxLimit', g_Config.tiWeaponCurseAddValueMaxLimit)
  else
    g_Config.tiWeaponCurseAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponCurseAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponCurseAddValueRate', g_Config.tiWeaponCurseAddValueRate)
  else
    g_Config.tiWeaponCurseAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHitAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHitAddRate', g_Config.tiWeaponHitAddRate)
  else
    g_Config.tiWeaponHitAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHitAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHitAddValueMaxLimit', g_Config.tiWeaponHitAddValueMaxLimit)
  else
    g_Config.tiWeaponHitAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHitAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHitAddValueRate', g_Config.tiWeaponHitAddValueRate)
  else
    g_Config.tiWeaponHitAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHitSpdAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHitSpdAddRate', g_Config.tiWeaponHitSpdAddRate)
  else
    g_Config.tiWeaponHitSpdAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHitSpdAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHitSpdAddValueMaxLimit', g_Config.tiWeaponHitSpdAddValueMaxLimit)
  else
    g_Config.tiWeaponHitSpdAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHitSpdAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHitSpdAddValueRate', g_Config.tiWeaponHitSpdAddValueRate)
  else
    g_Config.tiWeaponHitSpdAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHolyAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHolyAddRate', g_Config.tiWeaponHolyAddRate)
  else
    g_Config.tiWeaponHolyAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHolyAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHolyAddValueMaxLimit', g_Config.tiWeaponHolyAddValueMaxLimit)
  else
    g_Config.tiWeaponHolyAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWeaponHolyAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWeaponHolyAddValueRate', g_Config.tiWeaponHolyAddValueRate)
  else
    g_Config.tiWeaponHolyAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingDCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingDCAddRate', g_Config.tiWearingDCAddRate)
  else
    g_Config.tiWearingDCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingDCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingDCAddValueMaxLimit', g_Config.tiWearingDCAddValueMaxLimit)
  else
    g_Config.tiWearingDCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingDCAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingDCAddValueRate', g_Config.tiWearingDCAddValueRate)
  else
    g_Config.tiWearingDCAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingMCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingMCAddRate', g_Config.tiWearingMCAddRate)
  else
    g_Config.tiWearingMCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingMCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingMCAddValueMaxLimit', g_Config.tiWearingMCAddValueMaxLimit)
  else
    g_Config.tiWearingMCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingMCAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingMCAddValueRate', g_Config.tiWearingMCAddValueRate)
  else
    g_Config.tiWearingMCAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSCAddRate', g_Config.tiWearingSCAddRate)
  else
    g_Config.tiWearingSCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSCAddValueMaxLimit', g_Config.tiWearingSCAddValueMaxLimit)
  else
    g_Config.tiWearingSCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSCAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSCAddValueRate', g_Config.tiWearingSCAddValueRate)
  else
    g_Config.tiWearingSCAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingACAddRate', g_Config.tiWearingACAddRate)
  else
    g_Config.tiWearingACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingACAddValueMaxLimit', g_Config.tiWearingACAddValueMaxLimit)
  else
    g_Config.tiWearingACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingACAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingACAddValueRate', g_Config.tiWearingACAddValueRate)
  else
    g_Config.tiWearingACAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingMACAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingMACAddRate', g_Config.tiWearingMACAddRate)
  else
    g_Config.tiWearingMACAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingMACAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingMACAddValueMaxLimit', g_Config.tiWearingMACAddValueMaxLimit)
  else
    g_Config.tiWearingMACAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingMACAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingMACAddValueRate', g_Config.tiWearingMACAddValueRate)
  else
    g_Config.tiWearingMACAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingHitAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingHitAddRate', g_Config.tiWearingHitAddRate)
  else
    g_Config.tiWearingHitAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingHitAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingHitAddValueMaxLimit', g_Config.tiWearingHitAddValueMaxLimit)
  else
    g_Config.tiWearingHitAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingHitAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingHitAddValueRate', g_Config.tiWearingHitAddValueRate)
  else
    g_Config.tiWearingHitAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSpeedAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSpeedAddRate', g_Config.tiWearingSpeedAddRate)
  else
    g_Config.tiWearingSpeedAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSpeedAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSpeedAddValueMaxLimit', g_Config.tiWearingSpeedAddValueMaxLimit)
  else
    g_Config.tiWearingSpeedAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSpeedAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSpeedAddValueRate', g_Config.tiWearingSpeedAddValueRate)
  else
    g_Config.tiWearingSpeedAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingLuckAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingLuckAddRate', g_Config.tiWearingLuckAddRate)
  else
    g_Config.tiWearingLuckAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingLuckAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingLuckAddValueMaxLimit', g_Config.tiWearingLuckAddValueMaxLimit)
  else
    g_Config.tiWearingLuckAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingLuckAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingLuckAddValueRate', g_Config.tiWearingLuckAddValueRate)
  else
    g_Config.tiWearingLuckAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingAntiMagicAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingAntiMagicAddRate', g_Config.tiWearingAntiMagicAddRate)
  else
    g_Config.tiWearingAntiMagicAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingAntiMagicAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingAntiMagicAddValueMaxLimit', g_Config.tiWearingAntiMagicAddValueMaxLimit)
  else
    g_Config.tiWearingAntiMagicAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingAntiMagicAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingAntiMagicAddValueRate', g_Config.tiWearingAntiMagicAddValueRate)
  else
    g_Config.tiWearingAntiMagicAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingHealthRecoverAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingHealthRecoverAddRate', g_Config.tiWearingHealthRecoverAddRate)
  else
    g_Config.tiWearingHealthRecoverAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingHealthRecoverAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingHealthRecoverAddValueMaxLimit', g_Config.tiWearingHealthRecoverAddValueMaxLimit)
  else
    g_Config.tiWearingHealthRecoverAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingHealthRecoverAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingHealthRecoverAddValueRate', g_Config.tiWearingHealthRecoverAddValueRate)
  else
    g_Config.tiWearingHealthRecoverAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSpellRecoverAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSpellRecoverAddRate', g_Config.tiWearingSpellRecoverAddRate)
  else
    g_Config.tiWearingSpellRecoverAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSpellRecoverAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSpellRecoverAddValueMaxLimit', g_Config.tiWearingSpellRecoverAddValueMaxLimit)
  else
    g_Config.tiWearingSpellRecoverAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiWearingSpellRecoverAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiWearingSpellRecoverAddValueRate', g_Config.tiWearingSpellRecoverAddValueRate)
  else
    g_Config.tiWearingSpellRecoverAddValueRate := nLoadInteger;

  //// tiAbil
  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilTagDropAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilTagDropAddRate', g_Config.tiAbilTagDropAddRate)
  else
    g_Config.tiAbilTagDropAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilTagDropAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilTagDropAddValueMaxLimit', g_Config.tiAbilTagDropAddValueMaxLimit)
  else
    g_Config.tiAbilTagDropAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilTagDropAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilTagDropAddValueRate', g_Config.tiAbilTagDropAddValueRate)
  else
    g_Config.tiAbilTagDropAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPreDropAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPreDropAddRate', g_Config.tiAbilPreDropAddRate)
  else
    g_Config.tiAbilPreDropAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPreDropAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPreDropAddValueMaxLimit', g_Config.tiAbilPreDropAddValueMaxLimit)
  else
    g_Config.tiAbilPreDropAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPreDropAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPreDropAddValueRate', g_Config.tiAbilPreDropAddValueRate)
  else
    g_Config.tiAbilPreDropAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilSuckAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilSuckAddRate', g_Config.tiAbilSuckAddRate)
  else
    g_Config.tiAbilSuckAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilSuckAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilSuckAddValueMaxLimit', g_Config.tiAbilSuckAddValueMaxLimit)
  else
    g_Config.tiAbilSuckAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilSuckAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilSuckAddValueRate', g_Config.tiAbilSuckAddValueRate)
  else
    g_Config.tiAbilSuckAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpRecoverAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpRecoverAddRate', g_Config.tiAbilIpRecoverAddRate)
  else
    g_Config.tiAbilIpRecoverAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpRecoverAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpRecoverAddValueMaxLimit', g_Config.tiAbilIpRecoverAddValueMaxLimit)
  else
    g_Config.tiAbilIpRecoverAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpRecoverAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpRecoverAddValueRate', g_Config.tiAbilIpRecoverAddValueRate)
  else
    g_Config.tiAbilIpRecoverAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpExAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpExAddRate', g_Config.tiAbilIpExAddRate)
  else
    g_Config.tiAbilIpExAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpExAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpExAddValueMaxLimit', g_Config.tiAbilIpExAddValueMaxLimit)
  else
    g_Config.tiAbilIpExAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpExAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpExAddValueRate', g_Config.tiAbilIpExAddValueRate)
  else
    g_Config.tiAbilIpExAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpDamAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpDamAddRate', g_Config.tiAbilIpDamAddRate)
  else
    g_Config.tiAbilIpDamAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpDamAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpDamAddValueMaxLimit', g_Config.tiAbilIpDamAddValueMaxLimit)
  else
    g_Config.tiAbilIpDamAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpDamAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpDamAddValueRate', g_Config.tiAbilIpDamAddValueRate)
  else
    g_Config.tiAbilIpDamAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpReduceAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpReduceAddRate', g_Config.tiAbilIpReduceAddRate)
  else
    g_Config.tiAbilIpReduceAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpReduceAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpReduceAddValueMaxLimit', g_Config.tiAbilIpReduceAddValueMaxLimit)
  else
    g_Config.tiAbilIpReduceAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpReduceAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpReduceAddValueRate', g_Config.tiAbilIpReduceAddValueRate)
  else
    g_Config.tiAbilIpReduceAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpDecAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpDecAddRate', g_Config.tiAbilIpDecAddRate)
  else
    g_Config.tiAbilIpDecAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpDecAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpDecAddValueMaxLimit', g_Config.tiAbilIpDecAddValueMaxLimit)
  else
    g_Config.tiAbilIpDecAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilIpDecAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilIpDecAddValueRate', g_Config.tiAbilIpDecAddValueRate)
  else
    g_Config.tiAbilIpDecAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilBangAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilBangAddRate', g_Config.tiAbilBangAddRate)
  else
    g_Config.tiAbilBangAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilBangAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilBangAddValueMaxLimit', g_Config.tiAbilBangAddValueMaxLimit)
  else
    g_Config.tiAbilBangAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilBangAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilBangAddValueRate', g_Config.tiAbilBangAddValueRate)
  else
    g_Config.tiAbilBangAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilGangUpAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilGangUpAddRate', g_Config.tiAbilGangUpAddRate)
  else
    g_Config.tiAbilGangUpAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilGangUpAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilGangUpAddValueMaxLimit', g_Config.tiAbilGangUpAddValueMaxLimit)
  else
    g_Config.tiAbilGangUpAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilGangUpAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilGangUpAddValueRate', g_Config.tiAbilGangUpAddValueRate)
  else
    g_Config.tiAbilGangUpAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPalsyReduceAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPalsyReduceAddRate', g_Config.tiAbilPalsyReduceAddRate)
  else
    g_Config.tiAbilPalsyReduceAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPalsyReduceAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPalsyReduceAddValueMaxLimit', g_Config.tiAbilPalsyReduceAddValueMaxLimit)
  else
    g_Config.tiAbilPalsyReduceAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPalsyReduceAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPalsyReduceAddValueRate', g_Config.tiAbilPalsyReduceAddValueRate)
  else
    g_Config.tiAbilPalsyReduceAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilHPExAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilHPExAddRate', g_Config.tiAbilHPExAddRate)
  else
    g_Config.tiAbilHPExAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilHPExAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilHPExAddValueMaxLimit', g_Config.tiAbilHPExAddValueMaxLimit)
  else
    g_Config.tiAbilHPExAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilHPExAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilHPExAddValueRate', g_Config.tiAbilHPExAddValueRate)
  else
    g_Config.tiAbilHPExAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilMPExAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilMPExAddRate', g_Config.tiAbilMPExAddRate)
  else
    g_Config.tiAbilMPExAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilMPExAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilMPExAddValueMaxLimit', g_Config.tiAbilMPExAddValueMaxLimit)
  else
    g_Config.tiAbilMPExAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilMPExAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilMPExAddValueRate', g_Config.tiAbilMPExAddValueRate)
  else
    g_Config.tiAbilMPExAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilCCAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilCCAddRate', g_Config.tiAbilCCAddRate)
  else
    g_Config.tiAbilCCAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilCCAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilCCAddValueMaxLimit', g_Config.tiAbilCCAddValueMaxLimit)
  else
    g_Config.tiAbilCCAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilCCAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilCCAddValueRate', g_Config.tiAbilCCAddValueRate)
  else
    g_Config.tiAbilCCAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPoisonReduceAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPoisonReduceAddRate', g_Config.tiAbilPoisonReduceAddRate)
  else
    g_Config.tiAbilPoisonReduceAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPoisonReduceAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPoisonReduceAddValueMaxLimit', g_Config.tiAbilPoisonReduceAddValueMaxLimit)
  else
    g_Config.tiAbilPoisonReduceAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPoisonReduceAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPoisonReduceAddValueRate', g_Config.tiAbilPoisonReduceAddValueRate)
  else
    g_Config.tiAbilPoisonReduceAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPoisonRecoverAddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPoisonRecoverAddRate', g_Config.tiAbilPoisonRecoverAddRate)
  else
    g_Config.tiAbilPoisonRecoverAddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPoisonRecoverAddValueMaxLimit', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPoisonRecoverAddValueMaxLimit', g_Config.tiAbilPoisonRecoverAddValueMaxLimit)
  else
    g_Config.tiAbilPoisonRecoverAddValueMaxLimit := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiAbilPoisonRecoverAddValueRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiAbilPoisonRecoverAddValueRate', g_Config.tiAbilPoisonRecoverAddValueRate)
  else
    g_Config.tiAbilPoisonRecoverAddValueRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpecialSkills1AddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpecialSkills1AddRate', g_Config.tiSpecialSkills1AddRate)
  else
    g_Config.tiSpecialSkills1AddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpecialSkills2AddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpecialSkills2AddRate', g_Config.tiSpecialSkills2AddRate)
  else
    g_Config.tiSpecialSkills2AddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpecialSkills3AddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpecialSkills3AddRate', g_Config.tiSpecialSkills3AddRate)
  else
    g_Config.tiSpecialSkills3AddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpecialSkills4AddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpecialSkills4AddRate', g_Config.tiSpecialSkills4AddRate)
  else
    g_Config.tiSpecialSkills4AddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpecialSkills5AddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpecialSkills5AddRate', g_Config.tiSpecialSkills5AddRate)
  else
    g_Config.tiSpecialSkills5AddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpecialSkills6AddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpecialSkills6AddRate', g_Config.tiSpecialSkills6AddRate)
  else
    g_Config.tiSpecialSkills6AddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpecialSkills7AddRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpecialSkills7AddRate', g_Config.tiSpecialSkills7AddRate)
  else
    g_Config.tiSpecialSkills7AddRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddAtFirst', -1);
  if nLoadInteger < 0 then
    Config.WriteBool('Setup', 'tiSpMagicAddAtFirst', g_Config.tiSpMagicAddAtFirst)
  else
    g_Config.tiSpMagicAddAtFirst := not (nLoadInteger = 0);

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddMaxLevel', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddMaxLevel', g_Config.tiSpMagicAddMaxLevel)
  else
    g_Config.tiSpMagicAddMaxLevel := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddRate1', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddRate1', g_Config.tiSpMagicAddRate1)
  else
    g_Config.tiSpMagicAddRate1 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddRate2', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddRate2', g_Config.tiSpMagicAddRate2)
  else
    g_Config.tiSpMagicAddRate2 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddRate3', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddRate3', g_Config.tiSpMagicAddRate3)
  else
    g_Config.tiSpMagicAddRate3 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddRate4', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddRate4', g_Config.tiSpMagicAddRate4)
  else
    g_Config.tiSpMagicAddRate4 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddRate5', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddRate5', g_Config.tiSpMagicAddRate5)
  else
    g_Config.tiSpMagicAddRate5 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddRate6', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddRate6', g_Config.tiSpMagicAddRate6)
  else
    g_Config.tiSpMagicAddRate6 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddRate7', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddRate7', g_Config.tiSpMagicAddRate7)
  else
    g_Config.tiSpMagicAddRate7 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'tiSpMagicAddRate8', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'tiSpMagicAddRate8', g_Config.tiSpMagicAddRate8)
  else
    g_Config.tiSpMagicAddRate8 := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PosMoveAttackPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PosMoveAttackPowerRate', g_Config.nPosMoveAttackPowerRate)
  else
    g_Config.nPosMoveAttackPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'PosMoveAttackInterval', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'PosMoveAttackInterval', g_Config.nPosMoveAttackInterval)
  else
    g_Config.nPosMoveAttackInterval := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicIceRainPowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicIceRainPowerRate', g_Config.nMagicIceRainPowerRate)
  else
    g_Config.nMagicIceRainPowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicIceRainInterval', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicIceRainInterval', g_Config.nMagicIceRainInterval)
  else
    g_Config.nMagicIceRainInterval := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicDeadEyePowerRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicDeadEyePowerRate', g_Config.nMagicDeadEyePowerRate)
  else
    g_Config.nMagicDeadEyePowerRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicDeadEyeInterval', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicDeadEyeInterval', g_Config.nMagicDeadEyeInterval)
  else
    g_Config.nMagicDeadEyeInterval := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicDragonRageInterval', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicDragonRageInterval', g_Config.nMagicDragonRageInterval)
  else
    g_Config.nMagicDragonRageInterval := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicDragonRageDuration', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicDragonRageDuration', g_Config.nMagicDragonRageDuration)
  else
    g_Config.nMagicDragonRageDuration := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MagicDragonRageDamageAdd', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MagicDragonRageDamageAdd', g_Config.nMagicDragonRageDamageAdd)
  else
    g_Config.nMagicDragonRageDamageAdd := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'HealingRate', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'HealingRate', g_Config.nHealingRate)
  else
    g_Config.nHealingRate := nLoadInteger;

  nLoadInteger := Config.ReadInteger('Setup', 'MaxClientCount', -1);
  if nLoadInteger < 0 then
    Config.WriteInteger('Setup', 'MaxClientCount', g_Config.nMaxClientCount)
  else
    g_Config.nMaxClientCount := nLoadInteger;

end;

function GetRGB(c256: Byte): TColor;
begin
  Result := RGB(ColorTable[c256].rgbRed, ColorTable[c256].rgbGreen, ColorTable[c256].rgbBlue);
end;

procedure SendGameCenterMsg(wIdent: Word; sSENDMSG: string);
var
  SendData                  : TCopyDataStruct;
  nParam                    : Integer;
begin
  nParam := MakeLong(Word(tM2Server), wIdent);
  SendData.cbData := Length(sSENDMSG) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSENDMSG));
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

function GetIPLocal(sIPaddr: string): string;
var
  sLocal                    : array[0..254] of Char;
resourcestring
  sReplaceText              = 'www.lingame.com';
  sIPUnKnow                 = '未知';
begin
  Result := sIPUnKnow;
  if sIPaddr = '' then Exit;
  if (nIPLocal >= 0) and Assigned(PlugProcArray[nIPLocal].nProcAddr) then begin
    TIPLocal(PlugProcArray[nIPLocal].nProcAddr)(PChar(sIPaddr), sLocal, SizeOf(sLocal));
    Result := sLocal;
    Result := AnsiReplaceText(Result, sReplaceText, 'www.legendm2.com');
  end;
end;

function GetResourceString(sType: TStrType): string;
begin
  if (nResourceString >= 0) and Assigned(PlugProcArray[nResourceString].nProcAddr) then
    Result := string(TGetResourceString(PlugProcArray[nResourceString].nProcAddr)(sType));
end;


(*procedure ExportProc();
begin
  AddToProcTable(@GetRGB, PN_GETRGB);
  nAddGameDataLogAPI := AddToPulgProcTable(PN_GAMEDATALOG);
end;*)


function IsCheapStuff(tByte: Byte): Boolean;
begin
  if tByte < 0 then
    Result := True
  else
    Result := False;
end;

function CompareIPaddr(sIPaddr, dIPaddr: string): Boolean;
var
  nPos                      : Integer;
begin
  Result := False;
  if (sIPaddr = '') or (dIPaddr = '') then
    Exit;

  if (dIPaddr[1] = '*') then begin
    Result := True;
    Exit;
  end;

  nPos := Pos('*', dIPaddr);
  if nPos > 0 then
    Result := CompareLStr(sIPaddr, dIPaddr, nPos - 1)
  else
    Result := CompareText(sIPaddr, dIPaddr) = 0;
end;

(*function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: Byte): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), MakeWord(btHair, btDress));
end;*)

procedure LoadPetPickItemList();
var
  i                         : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
  sLineText                 : string;
begin
  sFileName := g_Config.sEnvirDir + 'PetPickItem.txt';
  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create();
    LoadList.Add(';宠物可以捡取的物品列表');
    LoadList.Add('金币');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;
  g_PetPickItemList.Lock;
  try
    g_PetPickItemList.Clear;
    LoadList := TStringList.Create();
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then
        g_PetPickItemList.Add(sLineText);
    end;
  finally
    g_PetPickItemList.UnLock;
  end;
  LoadList.Free;
end;

procedure SavePetPickItemList();
var
  i                         : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'PetPickItem.txt';
  g_PetPickItemList.Lock;
  try
    LoadList := TStringList.Create();
    for i := 0 to g_PetPickItemList.Count - 1 do
      LoadList.Add(g_PetPickItemList.Strings[i]);
  finally
    g_PetPickItemList.UnLock;
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function IsInPetPickItemList(sItemName: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  g_PetPickItemList.Lock;
  try
    for i := 0 to g_PetPickItemList.Count - 1 do begin
      if CompareText(g_PetPickItemList.Strings[i], sItemName) = 0 then begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_PetPickItemList.UnLock;
  end;
end;

(*function MakeMonsterFeature(btRaceImg, btWeapon: Byte; wAppr: Word): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), wAppr);
end;*)

procedure LoadUpgradeItemList();
var
  i                         : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
  sLineText                 : string;
begin
  sFileName := g_Config.sEnvirDir + 'UpgradeItem.txt';
  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create();
    LoadList.Add(';允许升级的物品列表');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;
  g_UpgradeItemList.Lock;
  try
    g_UpgradeItemList.Clear;
    LoadList := TStringList.Create();
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then
        g_UpgradeItemList.Add(sLineText);
    end;
  finally
    g_UpgradeItemList.UnLock;
  end;
  LoadList.Free;
end;

procedure SaveUpgradeItemList();
var
  i                         : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
begin
  sFileName := g_Config.sEnvirDir + 'UpgradeItem.txt';
  g_UpgradeItemList.Lock;
  try
    LoadList := TStringList.Create();
    for i := 0 to g_UpgradeItemList.Count - 1 do
      LoadList.Add(g_UpgradeItemList.Strings[i]);
  finally
    g_UpgradeItemList.UnLock;
  end;
  LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function IsInUpgradeItemList(sItemName: string): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  g_UpgradeItemList.Lock;
  try
    for i := 0 to g_UpgradeItemList.Count - 1 do begin
      if CompareText(g_UpgradeItemList.Strings[i], sItemName) = 0 then begin
        Result := True;
        Break;
      end;
    end;
  finally
    g_UpgradeItemList.UnLock;
  end;
end;

function LoadItemLimitList(): Boolean;
var
  i                         : Integer;
  LoadList                  : TStringList;
  ItemLimit                 : pTItemLimit;
  sFileName, sLineText, sItemName, sItemIdx, sAllowMake, sDisableMake, sAbleDropInSafeZone,
    sDisableTakeOff, sAllowSellOff, sDisableSell, sDisableDeal, sDropWithoutFail, sDisCustomName,
    sDisableDrop, sDisableStorage, sDispearOnLogon, sDisableUpgrade, sDisableRepair,
    sDisallowPSell, sNoScatter, sDisallowHeroUse, sdTakeOn: string;
  nItemIdx                  : Integer;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'CheckItemList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    LoadList.LoadFromFile(sFileName);
    g_ItemLimitList.Lock;
    try
      g_ItemLimitList.Clear;
      for i := 0 to LoadList.Count - 1 do begin
        sLineText := Trim(LoadList.Strings[i]);
        if (sLineText = '') or (sLineText[1] = ';') then
          Continue;
        sLineText := GetValidStr3(sLineText, sItemName, [#9]);
        sLineText := GetValidStr3(sLineText, sItemIdx, [#9]);
        sLineText := GetValidStr3(sLineText, sAllowMake, [#9]);
        sLineText := GetValidStr3(sLineText, sDisableMake, [#9]);
        sLineText := GetValidStr3(sLineText, sDisableTakeOff, [#9]);
        sLineText := GetValidStr3(sLineText, sAllowSellOff, [#9]);
        sLineText := GetValidStr3(sLineText, sDisableSell, [#9]);
        sLineText := GetValidStr3(sLineText, sDisableDeal, [#9]);
        sLineText := GetValidStr3(sLineText, sDisableDrop, [#9]);
        sLineText := GetValidStr3(sLineText, sDisableStorage, [#9]);
        sLineText := GetValidStr3(sLineText, sDispearOnLogon, [#9]);
        sLineText := GetValidStr3(sLineText, sDisableUpgrade, [#9]);
        sLineText := GetValidStr3(sLineText, sDisableRepair, [#9]);
        sLineText := GetValidStr3(sLineText, sDropWithoutFail, [#9]);
        sLineText := GetValidStr3(sLineText, sAbleDropInSafeZone, [#9]);
        sLineText := GetValidStr3(sLineText, sDisCustomName, [#9]);
        sLineText := GetValidStr3(sLineText, sDisallowHeroUse, [#9]);
        sLineText := GetValidStr3(sLineText, sDisallowPSell, [#9]);
        sLineText := GetValidStr3(sLineText, sNoScatter, [#9]);
        sLineText := GetValidStr3(sLineText, sdTakeOn, [#9]);

        nItemIdx := Str_ToInt(sItemIdx, -1);
        if (sItemName <> '') and (nItemIdx >= 0) then begin
          New(ItemLimit);
          FillChar(ItemLimit^, SizeOf(TItemLimit), 0);
          ItemLimit.sItemName := sItemName;
          ItemLimit.nItemInedx := nItemIdx;
          ItemLimit.boAllowMake := StrToBool(sAllowMake);
          ItemLimit.boDisableMake := StrToBool(sDisableMake);
          ItemLimit.boDisableTakeOff := StrToBool(sDisableTakeOff);
          ItemLimit.boAllowSellOff := StrToBool(sAllowSellOff);
          ItemLimit.boDisableSell := StrToBool(sDisableSell);
          ItemLimit.boDisableDeal := StrToBool(sDisableDeal);
          ItemLimit.boDisableDrop := StrToBool(sDisableDrop);
          ItemLimit.boDisableStorage := StrToBool(sDisableStorage);
          ItemLimit.boDispearOnLogon := StrToBool(sDispearOnLogon);
          ItemLimit.boDisableUpgrade := StrToBool(sDisableUpgrade);
          ItemLimit.boDisableRepair := StrToBool(sDisableRepair);
          ItemLimit.boDropWithoutFail := StrToBool(sDropWithoutFail);
          ItemLimit.boAbleDropInSafeZone := StrToBool(sAbleDropInSafeZone);
          ItemLimit.boDisCustomName := StrToBool(sDisCustomName);
          ItemLimit.boDisallowHeroUse := StrToBool(sDisallowHeroUse);
          ItemLimit.boDisallowPSell := StrToBool(sDisallowPSell);
          ItemLimit.boNoScatter := StrToBool(sNoScatter);
          ItemLimit.bodTakeOn := StrToBool(sdTakeOn);
          g_ItemLimitList.Add(ItemLimit);
        end;
      end;
    finally
      g_ItemLimitList.UnLock;
    end;
    Result := True;
  end
  else begin
    LoadList.Add(';该文本存放用规则限制的物品列表');
    LoadList.Add(';物品名称' + #9 + '物品IDX' + #9 + '允许制造' + #9 + '禁止制造' + #9 +
      '禁止取下' + #9 + '允许拍卖' + #9 + '禁止出售' + #9 + '禁止交易' + #9 +
      '禁止仍掉' + #9 + '禁止存仓' + #9 + '上线消失' + #9 + '禁止升级' + #9 + '禁止修理(特修)' + #9 + '死亡掉落');
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;

procedure SaveItemLimitList();
var
  i                         : Integer;
  NewLimitItem              : pTItemLimit;
  SaveList                  : TStringList;
  sFileName, sLineText, sItemName, sItemIdx, sAllowMake, sDisableMake, sAbleDropInSafeZone,
    sDisableTakeOff, sAllowSellOff, sDisableSell, sDisableDeal, sDropWithoutFail, sDisCustomName,
    sDisableDrop, sDisableStorage, sDispearOnLogon, sDisableUpgrade, sDisableRepair, sdTakeOn,
    sp, ss, sDisallowHeroUse: string;
begin
  sLineText := '';
  sFileName := g_Config.sEnvirDir + 'CheckItemList.txt';
  SaveList := TStringList.Create;
  g_ItemLimitList.Lock;
  try
    for i := 0 to g_ItemLimitList.Count - 1 do begin
      NewLimitItem := g_ItemLimitList.Items[i];
      sItemName := NewLimitItem.sItemName;
      sItemIdx := IntToStr(NewLimitItem.nItemInedx);
      sAllowMake := BoolToStr(NewLimitItem.boAllowMake);
      sDisableMake := BoolToStr(NewLimitItem.boDisableMake);
      sDisableTakeOff := BoolToStr(NewLimitItem.boDisableTakeOff);
      sAllowSellOff := BoolToStr(NewLimitItem.boAllowSellOff);
      sDisableSell := BoolToStr(NewLimitItem.boDisableSell);
      sDisableDeal := BoolToStr(NewLimitItem.boDisableDeal);
      sDisableDrop := BoolToStr(NewLimitItem.boDisableDrop);
      sDisableStorage := BoolToStr(NewLimitItem.boDisableStorage);
      sDispearOnLogon := BoolToStr(NewLimitItem.boDispearOnLogon);
      sDisableUpgrade := BoolToStr(NewLimitItem.boDisableUpgrade);
      sDisableRepair := BoolToStr(NewLimitItem.boDisableRepair);
      sDropWithoutFail := BoolToStr(NewLimitItem.boDropWithoutFail);
      sAbleDropInSafeZone := BoolToStr(NewLimitItem.boAbleDropInSafeZone);
      sDisCustomName := BoolToStr(NewLimitItem.boDisCustomName);
      sDisallowHeroUse := BoolToStr(NewLimitItem.boDisallowHeroUse);
      sp := BoolToStr(NewLimitItem.boDisallowPSell);
      ss := BoolToStr(NewLimitItem.boNoScatter);
      sdTakeOn := BoolToStr(NewLimitItem.bodTakeOn);

      sLineText := sItemName + #9 + sItemIdx + #9 + sAllowMake + #9 + sDisableMake + #9 +
        sDisableTakeOff + #9 + sAllowSellOff + #9 + sDisableSell + #9 + sDisableDeal + #9 +
        sDisableDrop + #9 + sDisableStorage + #9 + sDispearOnLogon + #9 + sDisableUpgrade + #9 +
        sDisableRepair + #9 + sDropWithoutFail + #9 + sAbleDropInSafeZone + #9 + sDisCustomName + #9
        + sDisallowHeroUse + #9 + sp + #9 + ss + #9 + sdTakeOn;
      SaveList.Add(sLineText);
    end;
    SaveList.SaveToFile(sFileName);
  finally
    g_ItemLimitList.UnLock;
  end;
end;

function InLimitItemList(sItemName: string; nItemIdx: Integer; nType: TItemType): Boolean;
var
  i                         : Integer;
  LimitItem                 : pTItemLimit;
begin
  Result := False;

  g_ItemLimitList.Lock;
  try
    for i := 0 to g_ItemLimitList.Count - 1 do begin
      LimitItem := pTItemLimit(g_ItemLimitList.Items[i]);
      if ((sItemName <> '') and (CompareText(LimitItem.sItemName, sItemName) = 0)) or (LimitItem.nItemInedx = (nItemIdx - 1)) then begin
        case nType of
          t_aMake: begin
              if LimitItem.boAllowMake then begin
                Result := True;
                Break;
              end;
            end;
          t_dMake: begin
              if LimitItem.boDisableMake then begin
                Result := True;
                Break;
              end;
            end;
          t_dTakeOff: begin
              if LimitItem.boDisableTakeOff then begin
                Result := True;
                Break;
              end;
            end;
          t_aSellOff: begin
              if LimitItem.boAllowSellOff then begin
                Result := True;
                Break;
              end;
            end;
          t_dSell: begin
              if LimitItem.boDisableSell then begin
                Result := True;
                Break;
              end;
            end;
          t_dDeal: begin
              if LimitItem.boDisableDeal then begin
                Result := True;
                Break;
              end;
            end;
          t_dDrop: begin
              if LimitItem.boDisableDrop then begin
                Result := True;
                Break;
              end;
            end;
          t_dStorage: begin
              if LimitItem.boDisableStorage then begin
                Result := True;
                Break;
              end;
            end;
          t_pOnLogon: begin
              if LimitItem.boDispearOnLogon then begin
                Result := True;
                Break;
              end;
            end;
          t_dUpgrade: begin
              if LimitItem.boDisableUpgrade then begin
                Result := True;
                Break;
              end;
            end;
          t_dRepair: begin
              if LimitItem.boDisableRepair then begin
                Result := True;
                Break;
              end;
            end;
          t_sDrop: begin
              if LimitItem.boDropWithoutFail then begin
                Result := True;
                Break;
              end;
            end;
          t_ADrop: begin
              if LimitItem.boAbleDropInSafeZone then begin
                Result := True;
                Break;
              end;
            end;
          t_dCustomName: begin
              if LimitItem.boDisCustomName then begin
                Result := True;
                Break;
              end;
            end;
          t_dHeroUse: begin
              if LimitItem.boDisallowHeroUse then begin
                Result := True;
                Break;
              end;
            end;
          t_dps: begin
              if LimitItem.boDisallowPSell then begin
                Result := True;
                Break;
              end;
            end;
          t_nsc: begin
              if LimitItem.boNoScatter then begin
                Result := True;
                Break;
              end;
            end;
          t_dTakeOn: begin
              if LimitItem.bodTakeOn then begin
                Result := True;
                Break;
              end;
            end;

        end;
      end;
    end;
  finally
    g_ItemLimitList.UnLock;
  end;
end;

procedure UnInitSaleItemList();
var
  i                         : Integer;
begin
  g_SaleItemList.Lock;
  try
    for i := 0 to g_SaleItemList.Count - 1 do
      Dispose(pTSaleItem(g_SaleItemList.Items[i]));
    g_SaleItemList.Clear;
  finally
    g_SaleItemList.UnLock;
  end;
end;



procedure LoadUserBuyItemList();
var
  i, nPrice                 : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
  sLineText                 : string;
  sItemName                 : string;
  sItemPrice                : string;
  sItemDes                  : string;
  pStdItem                  : pTStdItem;
  pSaleItem                 : pTSaleItem;
begin
  sFileName := g_Config.sEnvirDir + 'SaleItemList.txt';
  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create();
    LoadList.Add(';引擎插件商铺配置文件');
    LoadList.Add(';物品名称'#9'出售价格'#9'描述');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;
  UnInitSaleItemList();
  LoadList := TStringList.Create();
  LoadList.LoadFromFile(sFileName);
  g_SaleItemList.Lock;
  try
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sLineText := GetValidStr3(sLineText, sItemName, [#9]);
        sLineText := GetValidStr3(sLineText, sItemPrice, [#9]);
        sLineText := GetValidStr3(sLineText, sItemDes, [#9]);
        nPrice := Str_ToInt(sItemPrice, 0);
        if (sItemName <> '') and (nPrice > 0) and (sItemDes <> '') then begin
          pStdItem := UserEngine.GetStdItem(sItemName);
          if pStdItem <> nil then begin
            New(pSaleItem);
            FillChar(pSaleItem^, SizeOf(TSaleItem), #0);
            //pSaleItem.sStdItem := pStdItem^;
            Move(pStdItem^, pSaleItem.sStdItem, SizeOf(TClientStdItem));
            pSaleItem.sStdItem.Price := nPrice * 100;
            sItemDes := Trim(sItemDes);
            Move(sItemDes[1], pSaleItem.sItemDesc, SizeOf(TSaleItem) - SizeOf(TClientStdItem));
            g_SaleItemList.Add(pSaleItem);
          end;
        end;
      end;
    end;
  finally
    g_SaleItemList.UnLock;
  end;
  LoadList.Free;
end;

function GetSaleItemByName(sItemName: string): pTSaleItem;
var
  i                         : Integer;
  pSaleItem                 : pTSaleItem;
begin
  Result := nil;
  g_SaleItemList.Lock;
  try
    for i := 0 to g_SaleItemList.Count - 1 do begin
      pSaleItem := g_SaleItemList.Items[i];
      if CompareText(sItemName, pSaleItem^.sStdItem.Name) = 0 then begin
        Result := pSaleItem;
        Break;
      end;
    end;
  finally
    g_SaleItemList.UnLock;
  end;
end;

procedure LoadShopItemList();

  procedure UnInitShopItemList();
  var
    i                       : Integer;
  begin
    g_ShopItemList.Lock;
    try
      for i := 0 to g_ShopItemList.Count - 1 do
        Dispose(pTShopItem(g_ShopItemList.Items[i]));
      g_ShopItemList.Clear;
    finally
      g_ShopItemList.UnLock;
    end;
  end;
var
  i, nPrice                 : Integer;
  sFileName                 : string;
  LoadList                  : TStringList;
  sLineText                 : string;
  sItemClass                : string;
  sItemName                 : string;
  s1, s2, s3                : string;
  sItemPrice                : string;
  sItemDes                  : string;
  pStdItem                  : pTStdItem;
  pShopItem                 : pTShopItem;
begin
  sFileName := g_Config.sEnvirDir + 'ShopItemList.txt';
  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create();
    LoadList.Add(';引擎插件商铺配置文件');
    LoadList.Add(';物品名称'#9'出售价格'#9'描述');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;
  UnInitShopItemList();
  LoadList := TStringList.Create();
  LoadList.LoadFromFile(sFileName);
  g_ShopItemList.Lock;
  try
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sLineText := GetValidStr3(sLineText, sItemClass, [#9]);
        sLineText := GetValidStr3(sLineText, sItemName, [#9]);
        sLineText := GetValidStr3(sLineText, s1, [#9]);
        sLineText := GetValidStr3(sLineText, sItemPrice, [#9]);
        sLineText := GetValidStr3(sLineText, s2, [#9]);
        sLineText := GetValidStr3(sLineText, s3, [#9]);
        sLineText := GetValidStr3(sLineText, sItemDes, [#9]);
        nPrice := Str_ToInt(sItemPrice, 2000000000);
        if (sItemName <> '') and (nPrice > 0) and (sItemDes <> '') then begin
          pStdItem := UserEngine.GetStdItem(sItemName);
          if pStdItem <> nil then begin
            New(pShopItem);
            FillChar(pShopItem^, SizeOf(TShopItem), #0);
            pShopItem.wPrice := nPrice;
            pShopItem.sExplain := sItemDes;
            pShopItem.sItemName := sItemName;
            pShopItem.btClass := Str_ToInt(sItemClass, 5);
            pShopItem.wLooks := Str_ToInt(s1, 0);
            pShopItem.wShape1 := Str_ToInt(s2, 0);
            pShopItem.wShape2 := Str_ToInt(s3, 0);
            g_ShopItemList.Add(pShopItem);
          end;
        end;
      end;
    end;
  finally
    g_ShopItemList.UnLock;
  end;
  LoadList.Free;
end;

function GetShopItemByName(sItemName: string): pTShopItem;
var
  i                         : Integer;
  pShopItem                 : pTShopItem;
begin
  Result := nil;
  g_ShopItemList.Lock;
  try
    for i := 0 to g_ShopItemList.Count - 1 do begin
      pShopItem := g_ShopItemList.Items[i];
      if CompareText(sItemName, pShopItem^.sItemName) = 0 then begin
        Result := pShopItem;
        Break;
      end;
    end;
  finally
    g_ShopItemList.UnLock;
  end;
end;

function GetShopItemByType(nItemType: Integer): pTShopItem;
var
  i                         : Integer;
  pShopItem                 : pTShopItem;
begin
  Result := nil;
  g_ShopItemList.Lock;
  try
    for i := 0 to g_ShopItemList.Count - 1 do begin
      pShopItem := g_ShopItemList.Items[i];
      if nItemType = pShopItem^.btClass then begin
        Result := pShopItem;
        Break;
      end;
    end;
  finally
    g_ShopItemList.UnLock;
  end;
end;

procedure BindItemCharName(nItemIdx, nMakeIdex: Integer; sBindName: string);
var
  i                         : Integer;
  ItemBind                  : pTItemBind;
begin
  if (nItemIdx <= 0) or (nMakeIdex < 0) or (sBindName = '') then Exit;
  g_ItemBindCharName.Lock;
  try
    for i := 0 to g_ItemBindCharName.Count - 1 do begin
      ItemBind := g_ItemBindCharName.Items[i];
      if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then Exit;
    end;
    New(ItemBind);
    ItemBind.nItemIdx := nItemIdx;
    ItemBind.nMakeIdex := nMakeIdex;
    ItemBind.sBindName := sBindName;
    g_ItemBindCharName.Insert(0, ItemBind);
  finally
    g_ItemBindCharName.UnLock;
  end;
  SaveItemBindCharName();
end;

procedure BindItemAccount(nItemIdx, nMakeIdex: Integer; sBindName: string);
var
  i                         : Integer;
  ItemBind                  : pTItemBind;
begin
  if (nItemIdx <= 0) or (nMakeIdex < 0) or (sBindName = '') then Exit;
  g_ItemBindAccount.Lock;
  try
    for i := 0 to g_ItemBindAccount.Count - 1 do begin
      ItemBind := g_ItemBindAccount.Items[i];
      if (ItemBind.nItemIdx = nItemIdx) and (ItemBind.nMakeIdex = nMakeIdex) then Exit;
    end;
    New(ItemBind);
    ItemBind.nItemIdx := nItemIdx;
    ItemBind.nMakeIdex := nMakeIdex;
    ItemBind.sBindName := sBindName;
    g_ItemBindAccount.Insert(0, ItemBind);
  finally
    g_ItemBindAccount.UnLock;
  end;
  SaveItemBindAccount();
end;

function GetLocalIP(): string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  i                         : Integer;
  phe                       : PHostEnt;
  pptr                      : PaPInAddr;
  Buffer                    : array[0..63] of Char;
  GInitData                 : TWSADATA;
  sIP                       : string;
resourcestring
  sKey                      = 'BlueSoft';
begin
  {.$I '..\Common\Macros\Encode_Start.inc'}
    {try
      Result := '';
      WSAStartup($101, GInitData);
      GetHostName(Buffer, SizeOf(Buffer));
      phe := gethostbyname(Buffer);
      if phe <> nil then begin
        pptr := PaPInAddr(phe^.h_addr_list);
        i := 0;
        while pptr^[i] <> nil do begin
          sIP := StrPas(inet_ntoa(pptr^[i]^));
          if (sIP <> '') and IsIPaddr(sIP) then begin
            Result := __En__(sIP, sKey);
            Break;
          end;
          Inc(i);
        end;
      end;
      WSACleanup;
    except
    end;}
  try
    Result := '';
    sIP := GetWanIP;
    Result := __En__(sIP, sKey);
  except
  end;
  {.$I '..\Common\Macros\Encode_End.inc'}
end;

function CheckChrName(sChrName: string): Boolean;
var
  i                         : Integer;
  Chr                       : Char;
  boIsTwoByte               : Boolean;
  FirstChr                  : Char;
begin
  Result := True;
  boIsTwoByte := False;
  FirstChr := #0;
  for i := 1 to Length(sChrName) do begin
    Chr := (sChrName[i]);
    if boIsTwoByte then begin
      if not ((FirstChr <= #$F7) and (Chr >= #$40) and (Chr <= #$FE)) then
        if not ((FirstChr > #$F7) and (Chr >= #$40) and (Chr <= #$A0)) then
          Result := False;
      boIsTwoByte := False;
    end else begin
      if (Chr >= #$81) and (Chr <= #$FE) then begin
        boIsTwoByte := True;
        FirstChr := Chr;
      end else begin
        if not ((Chr >= '0' {#30}) and (Chr <= '9' {#39})) and
          not ((Chr >= 'a' {#61}) and (Chr <= 'z') {#7A}) and
          not ((Chr >= 'A' {#41}) and (Chr <= 'Z' {#5A})) then
          Result := False;
      end;
    end;
    if not Result then
      Break;
  end;
end;

procedure InitUserDataList();
begin
  g_UserDataList := TGList.Create;
end;

procedure UnInitUserDataList();
var
  i                         : Integer;
begin
  for i := 0 to g_UserDataList.Count - 1 do
    Dispose(pTMakerMap(g_UserDataList.Items[i]));
  g_UserDataList.Free;
end;

procedure LoadUserDataList();
var
  i, nCount                 : Integer;
  sFileName                 : string;
  FileHandle                : Integer;
  MakerMap                  : pTMakerMap;
begin
  sFileName := g_Config.sUserDataDir + 'UserData.dat';
  if FileExists(sFileName) then begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then begin
      if FileRead(FileHandle, nCount, SizeOf(Integer)) = SizeOf(Integer) then begin
        g_UserDataList.Lock;
        try
          for i := 0 to nCount - 1 do begin
            New(MakerMap);
            if FileRead(FileHandle, MakerMap^, SizeOf(TMakerMap)) = SizeOf(TMakerMap) then
              g_UserDataList.Add(MakerMap)
            else begin
              Dispose(MakerMap);
              Break;
            end;
          end;
        finally
          g_UserDataList.UnLock;
        end;
      end;
      FileClose(FileHandle);
    end;
  end;
end;

procedure SaveUserDataList();
var
  i                         : Integer;
  sFileName                 : string;
  FileHandle                : Integer;
  MakerMap                  : pTMakerMap;
begin
  sFileName := g_Config.sUserDataDir + 'UserData.dat';
  if FileExists(sFileName) then begin
    DeleteFile(sFileName);
    FileHandle := FileCreate(sFileName);
  end else
    FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then begin
    FileWrite(FileHandle, g_UserDataList.Count, SizeOf(Integer));
    g_UserDataList.Lock;
    try
      for i := 0 to g_UserDataList.Count - 1 do begin
        MakerMap := pTMakerMap(g_UserDataList.Items[i]);
        FileWrite(FileHandle, MakerMap^, SizeOf(TMakerMap));
      end;
    finally
      g_UserDataList.UnLock;
    end;
    FileClose(FileHandle);
  end;
end;

function GetUserDataList(sName: string): pTMakerMap;
var
  i                         : Integer;
  FileHandle                : Integer;
  MakerMap                  : pTMakerMap;
begin
  Result := nil;
  g_UserDataList.Lock;
  try
    for i := 0 to g_UserDataList.Count - 1 do begin
      MakerMap := pTMakerMap(g_UserDataList.Items[i]);
      if MakerMap.sCharName = sName then begin
        Result := MakerMap;
        Break;
      end;
    end;
  finally
    g_UserDataList.UnLock;
  end;
end;

procedure SetUserDataList(UserMapInfo: TMakerMap);
var
  i                         : Integer;
  FileHandle                : Integer;
  boExist                   : Boolean;
  MakerMap                  : pTMakerMap;
begin
  g_UserDataList.Lock;
  try
    boExist := False;
    for i := 0 to g_UserDataList.Count - 1 do begin
      MakerMap := pTMakerMap(g_UserDataList.Items[i]);
      if MakerMap.sCharName = UserMapInfo.sCharName then begin
        MakerMap.sMapName := UserMapInfo.sMapName;
        MakerMap.wMapX := UserMapInfo.wMapX;
        MakerMap.wMapY := UserMapInfo.wMapY;
        boExist := True;
        Break;
      end;
    end;
    if not boExist then begin
      New(MakerMap);
      MakerMap^ := UserMapInfo;
      g_UserDataList.Insert(0, MakerMap);
    end;
  finally
    g_UserDataList.UnLock;
  end;
end;


procedure InitSuiteItemsList();
begin
  g_SuiteItemsList := TList.Create;
end;

procedure UnInitSuiteItemsList();
var
  i                         : Integer;
begin
  for i := 0 to g_SuiteItemsList.Count - 1 do
    Dispose(pTSuiteItems(g_SuiteItemsList.Items[i]));
  g_SuiteItemsList.Free;
end;

procedure MakeTitleSendBuffer();
var
  i, ii                     : Integer;
  StdItem                   : pTStdItem;
  aci                       : array[0..127] of TClientStdItem;
begin
  g_TitlesBuffLen := 0;
  if g_TitlesBuff <> nil then begin
    FreeMem(g_TitlesBuff);
    g_TitlesBuff := nil;
  end;

  ii := 0;
  for i := 0 to UserEngine.TitleList.Count - 1 do begin
    StdItem := UserEngine.TitleList[i];
    Move(StdItem^, aci[ii], SizeOf(TClientStdItem));
    Inc(ii);
    if ii > High(aci) then
      Break;
  end;

  if ii > 0 then begin
    g_VCLZip1.ZLibCompressBuffer(@aci[0], ii * SizeOf(TClientStdItem), g_TitlesBuff, g_TitlesBuffLen);
  end;
end;

procedure LoadSuiteItemsList();
var
  i, ii, nC, ItemColor, AbilColor, Gender: Integer;
  sStr                      : string;
  sHint, sFileName          : string;
  sItems, sAttrib           : string;
  SuiteItems                : pTSuiteItems;
  ini                       : TIniFile;
  b                         : Boolean;
  csi                       : array[0..255] of TClientSuiteItems;
  pstd                      : pTStdItem;
begin
  sFileName := g_Config.sEnvirDir + 'SuiteItemsList.txt';
  ini := TIniFile.Create(sFileName);
  nC := ini.ReadInteger('SuiteItems', 'Count', 0);
  if nC <= 0 then begin
    ini.Free;
    Exit;
  end;

  for i := 0 to g_SuiteItemsList.Count - 1 do
    Dispose(pTSuiteItems(g_SuiteItemsList.Items[i]));
  g_SuiteItemsList.Clear;

  for i := 0 to nC - 1 do begin
    if ini.ReadInteger(IntToStr(i), 'ItemColor', -1) < 0 then
      ini.WriteInteger(IntToStr(i), 'ItemColor', 239);
    ItemColor := ini.ReadInteger(IntToStr(i), 'ItemColor', 239);

    if ini.ReadInteger(IntToStr(i), 'AbilColor', -1) < 0 then
      ini.WriteInteger(IntToStr(i), 'AbilColor', 20);
    AbilColor := ini.ReadInteger(IntToStr(i), 'AbilColor', 20);

    b := ini.ReadBool(IntToStr(i), 'ClientShow', False);
    sHint := ini.ReadString(IntToStr(i), 'Hint', '');
    sItems := ini.ReadString(IntToStr(i), 'UseItems', '');
    sAttrib := ini.ReadString(IntToStr(i), 'Attribute', '');
    if (sHint <> '') and (sItems <> '') and (sAttrib <> '') then begin
      New(SuiteItems);
      FillChar(SuiteItems^, SizeOf(TSuiteItems), #0);
      SuiteItems.SendToClient := b;
      SuiteItems.ItemColor := ItemColor;
      SuiteItems.AbilColor := AbilColor;
      SuiteItems.sDesc := sHint;
      ii := 0;
      while sItems <> '' do begin
        sItems := GetValidStr3(sItems, sStr, [',']);
        if sStr <> 'NULL' then
          SuiteItems.asSuiteName[ii] := sStr;
        if SuiteItems.asSuiteName[ii] <> '' then
          Inc(SuiteItems.nNeedCount);
        Inc(ii);
        if ii > 12 then Break;
      end;

      //SuiteItems.Gender := 0;
      if SuiteItems.asSuiteName[0] <> '' then begin
        pstd := UserEngine.GetStdItem(SuiteItems.asSuiteName[0]);
        if (pstd <> nil) and (pstd.StdMode in [11, 13]) then
          SuiteItems.Gender := 1;
      end;

      ii := 0;
      while sAttrib <> '' do begin
        sAttrib := GetValidStr3(sAttrib, sStr, [',']);
        SuiteItems.aSuitSubRate[ii] := Str_ToInt(sStr, 0);
        Inc(ii);
        if ii > High(TSuitSubRate) then Break;
      end;
      g_SuiteItemsList.Add(SuiteItems);
    end;
  end;
  ini.Free;

  if g_pcsiLen <> 0 then
    g_pcsiLen := 0;

  if g_pcsi <> nil then begin
    FreeMem(g_pcsi);
    g_pcsi := nil;
  end;

  ii := 0;
  for i := 0 to g_SuiteItemsList.Count - 1 do begin
    SuiteItems := g_SuiteItemsList[i];
    if not SuiteItems.SendToClient then
      Continue;

    csi[ii].Gender := SuiteItems.Gender;

    csi[ii].ItemColor := SuiteItems.ItemColor;
    csi[ii].AbilColor := SuiteItems.AbilColor;
    csi[ii].nNeedCount := SuiteItems.nNeedCount;
    csi[ii].aSuitSubRate := SuiteItems.aSuitSubRate;
    csi[ii].asSuiteName := SuiteItems.asSuiteName;
    Inc(ii);
    if ii > High(csi) then
      Break;
  end;

  if ii > 0 then begin
    g_VCLZip1.ZLibCompressBuffer(@csi[0], ii * SizeOf(TClientSuiteItems), g_pcsi, g_pcsiLen);
  end;
end;

function GetSuiteItems(StdItem: pTStdItem): Boolean;
var
  i, ii                     : Integer;
  sName                     : string;
  SuiteItems                : pTSuiteItems;
begin
  Result := False;
  for i := 0 to g_SuiteItemsList.Count - 1 do begin
    SuiteItems := pTSuiteItems(g_SuiteItemsList.Items[i]);
    for ii := Low(TSuiteNames) to High(TSuiteNames) do begin
      sName := SuiteItems.asSuiteName[ii];
      if (sName <> '') and (CompareText(sName, StdItem.Name) = 0) then begin
        StdItem.SvrSet.aSuiteWhere[StdItem.SvrSet.btRefSuiteCount] := ii;
        StdItem.SvrSet.aSuiteIndex[StdItem.SvrSet.btRefSuiteCount] := i;
        Inc(StdItem.SvrSet.btRefSuiteCount);
        Result := True;
      end;
    end;
  end;
end;


function DecodeStringPassword(var src: string; Key: Integer): string;
var
  i, temp                   : Integer;
  tempstr, EncodedPwd       : string;
  EncodeString              : string;
begin
  Result := '';
  EncodeString := 'M2';

  tempstr := Copy(UpperCase(src), 1, _MIN(Length(EncodeString), Length(src)));
  if tempstr = EncodeString then begin
    src := Copy(src, Length(EncodeString) + 1, Length(src));
    EncodedPwd := src;
    //Encode Password
    for i := 1 to Length(src) do begin
      temp := Integer(src[i]) xor (Key + i);
      if not ((temp >= 33) and (temp <= 126)) then begin
        temp := Integer(src[i]);
      end;
      EncodedPwd[i] := Char(temp);
    end;
    Result := EncodedPwd;
  end else begin
    //Decode Password
    for i := 1 to Length(src) do begin
      temp := Integer(src[i]) xor (Key + i);
      if not ((temp >= 33) and (temp <= 126)) then begin
        temp := Integer(src[i]);
      end;
      src[i] := Char(temp);
    end;
  end;
end;

procedure SetGatherExpItem(StdItem: pTStdItem; UserItem: pTUserItem);
var
  idura                     : Integer;
  Abil                      : array[0..3] of TEvaAbil;
begin
  if StdItem.Overlap >= 1 then begin
    //if StdItem.DuraMax = 0 then
    UserItem.Dura := 1;
    //else
    //  UserItem.Dura := StdItem.DuraMax;
  end else begin
    case StdItem.StdMode of
      02: begin
          if (StdItem.Shape in [10..12]) then begin
            if StdItem.AniCount > 0 then
              UserItem.Dura := UserItem.DuraMax
            else
              UserItem.Dura := 0;
          end;
          if (StdItem.Source <> 0) then begin
            UserItem.Dura := 0;
          end;
        end;
      40: if StdItem.Shape > 0 then begin
          idura := UserItem.DuraMax div 3;
          UserItem.Dura := idura + Random(UserItem.DuraMax div 2);
        end;
      56: begin
          case StdItem.Shape of
            10: begin                   //除魔灵媒
                SetItemEvaInfo(UserItem, t_SpiritQ, LoWord(StdItem.AC), Abil);
                SetItemEvaInfo(UserItem, t_Spirit, HiWord(StdItem.AC), Abil);
                SetItemEvaInfo(UserItem, t_SpiritMax, HiWord(StdItem.AC), Abil);
              end;
          end;
        end;
    end;
    if (StdItem.StdMode in [5, 6, 10..13, 15..24, 26..30, 51..54, 62..64]) then begin
      SetItemEvaInfo(UserItem, t_Quality, Random(49) + 1, Abil);
    end;
  end;
end;

function GetUnbindItemName(nShape: Integer): string;
var
  i                         : Integer;
begin
  Result := '';
  for i := 0 to g_UnbindList.Count - 1 do begin
    if Integer(g_UnbindList.Objects[i]) = nShape then begin
      Result := g_UnbindList.Strings[i];
      Break;
    end;
  end;
end;

function LoadAutoLogin(): Boolean;
var
  sFileName                 : string;
begin
  Result := False;
  g_AutoLoginList.Clear;
  sFileName := g_Config.sEnvirDir + 'AutoLogin.txt';
  if FileExists(sFileName) then begin
    g_AutoLoginList.LoadFromFile(sFileName);
    if g_AutoLoginList.Count > 0 then
      Result := True;
  end;
end;

function LoadDeathWalkingSays(): Boolean;
var
  sFileName                 : string;
begin
  Result := False;
  g_DeathWalkingSays.Clear;
  sFileName := g_Config.sEnvirDir + 'DeathWalkingSay.txt';
  if FileExists(sFileName) then begin
    g_DeathWalkingSays.LoadFromFile(sFileName);
    if g_DeathWalkingSays.Count > 0 then
      Result := True;
  end;
end;

function GetStdPosType(std, Pos: Integer): Byte;
begin
  Result := 0;
  if Pos in [8..21] then
    Result := Pos + 7
  else begin
    case std of
      5, 6: case Pos of                 //武器
          0: Result := 1;
          1: Result := 2;
          2: Result := 3;
          3: Result := 9;
          4: Result := 10;
          5: Result := 6;
          6: Result := 11;
          7: Result := 12;
        end;
      10, 11: case Pos of               //武器
          0: Result := 4;
          1: Result := 5;
          2: Result := 1;
          3: Result := 2;
          4: Result := 3;
        end;
      15, 16, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30: begin //首饰
          if std in [19, 20, 21, 23, 24] then begin //特殊首饰
            case Pos of
              2: Result := 1;
              3: Result := 2;
              4: Result := 3;
            end;
            if std = 19 then begin
              case Pos of
                0: Result := 8;
                1: Result := 9;
              end;
            end else if std in [20, 24] then begin
              case Pos of
                0: Result := 6;
                1: Result := 7;
              end;
            end else if std in [21] then begin
              case Pos of
                0: Result := 13;
                1: Result := 14;
              end;
            end else if std in [23] then begin
              case Pos of
                0: Result := 29;
                1: Result := 30;
              end;
            end;
          end else begin                //普通首饰
            case Pos of
              0: Result := 4;
              1: Result := 5;
              2: Result := 1;
              3: Result := 2;
              4: Result := 3;
            end;
          end;
        end;

    end;
  end;
end;

function UseItemSpiritQuality(UserItem: pTUserItem; var nRet: Byte): Byte;
var
  Eva                       : TEvaluation;
begin
  Result := 0;
  GetItemEvaInfo(UserItem, Eva);
  if Eva.SpiritMax > 0 then begin
    if UserItem.btValueEx[17] > 0 then begin
      Result := UserItem.btValueEx[17];
      UserItem.btValueEx[17] := UserItem.btValueEx[17] - 1;
    end;
    nRet := UserItem.btValueEx[17];
  end;
end;

function GetItemSecretProperty(UserItem: pTUserItem; var Abil: array of TEvaAbil): Byte;
var
  i, n, v                   : Integer;
begin
  Result := 0;
  if UserItem.btValueEx[15] div 16 > 0 then begin
    Abil[Result].btType := UserItem.btValueEx[9];
    Abil[Result].btValue := UserItem.btValueEx[15] div 16;
    Inc(Result);
  end;
  if UserItem.btValueEx[15] mod 16 > 0 then begin
    Abil[Result].btType := UserItem.btValueEx[10];
    Abil[Result].btValue := UserItem.btValueEx[15] mod 16;
    Inc(Result);
  end;
  if UserItem.btValueEx[16] div 16 > 0 then begin
    Abil[Result].btType := UserItem.btValueEx[11];
    Abil[Result].btValue := UserItem.btValueEx[16] div 16;
    Inc(Result);
  end;
  if UserItem.btValueEx[16] mod 16 > 0 then begin
    Abil[Result].btType := UserItem.btValueEx[12];
    Abil[Result].btValue := UserItem.btValueEx[16] mod 16;
    Inc(Result);
  end;
  if UserItem.btValueEx[1] > 0 then begin
    for i := 0 to 6 do begin
      if UserItem.btValueEx[1] and (1 shl i) <> 0 then
        Inc(Result);
    end;
  end;
end;

function GetItemEvaInfo(UserItem: pTUserItem; var Eva: TEvaluation): Byte;
var
  i, n, v                   : Integer;
begin
  Result := 0;
  //FillChar(Eva, SizeOf(Eva), 0);
  Eva.SpiritQ := UserItem.btValueEx[17];
  Eva.SpSkill := UserItem.btValueEx[18];

  Eva.EvaTimes := UserItem.btValueEx[0] div 16;
  Eva.AdvAbilMax := UserItem.btValueEx[0] mod 16;

  Eva.AdvAbil := UserItem.btValueEx[1];

  Eva.Spirit := UserItem.btValueEx[2];
  Eva.SpiritMax := UserItem.btValueEx[3];

  Eva.Quality := UserItem.btValueEx[4];

  //05..12 类型
  //13..16 数值

  v := 0;
  if UserItem.btValueEx[13] div 16 > 0 then begin
    Eva.Abil[v].btType := UserItem.btValueEx[5];
    Eva.Abil[v].btValue := UserItem.btValueEx[13] div 16;
    Inc(v);
  end;
  if UserItem.btValueEx[13] mod 16 > 0 then begin
    Eva.Abil[v].btType := UserItem.btValueEx[6];
    Eva.Abil[v].btValue := UserItem.btValueEx[13] mod 16;
    Inc(v);
  end;
  if UserItem.btValueEx[14] div 16 > 0 then begin
    Eva.Abil[v].btType := UserItem.btValueEx[7];
    Eva.Abil[v].btValue := UserItem.btValueEx[14] div 16;
    Inc(v);
  end;
  if UserItem.btValueEx[14] mod 16 > 0 then begin
    Eva.Abil[v].btType := UserItem.btValueEx[8];
    Eva.Abil[v].btValue := UserItem.btValueEx[14] mod 16;
    Inc(v);
  end;
  Eva.BaseMax := v;

  if UserItem.btValueEx[15] div 16 > 0 then begin
    Eva.Abil[v].btType := UserItem.btValueEx[9];
    Eva.Abil[v].btValue := UserItem.btValueEx[15] div 16;
    Inc(v);
    Inc(Result);
  end;
  if UserItem.btValueEx[15] mod 16 > 0 then begin
    Eva.Abil[v].btType := UserItem.btValueEx[10];
    Eva.Abil[v].btValue := UserItem.btValueEx[15] mod 16;
    Inc(v);
    Inc(Result);
  end;
  if UserItem.btValueEx[16] div 16 > 0 then begin
    Eva.Abil[v].btType := UserItem.btValueEx[11];
    Eva.Abil[v].btValue := UserItem.btValueEx[16] div 16;
    Inc(v);
    Inc(Result);
  end;
  if UserItem.btValueEx[16] mod 16 > 0 then begin
    Eva.Abil[v].btType := UserItem.btValueEx[12];
    Eva.Abil[v].btValue := UserItem.btValueEx[16] mod 16;
    Inc(v);
    Inc(Result);
  end;

  if Eva.AdvAbil > 0 then begin
    for i := 0 to 6 do begin
      if Eva.AdvAbil and (1 shl i) <> 0 then
        Inc(Result);
    end;
  end;

  if Eva.SpSkill > 0 then begin
    for i := 0 to 7 - G_SpSkillRet do begin
      if Eva.SpSkill and (1 shl i) <> 0 then
        Inc(Result);
    end;
  end;

  //Eva.AdvAbilMax := v - Eva.AbilMax;
end;

function SetItemEvaInfo(UserItem: pTUserItem; EvaType: TEvaValTpye; v: Byte; Abil: array of TEvaAbil): Byte;
var
  i, n                      : Integer;
begin
  Result := 0;
  case EvaType of
    t_SpiritQ: UserItem.btValueEx[17] := v;
    t_SpSkill: UserItem.btValueEx[18] := v;

    t_EvaTimes: UserItem.btValueEx[0] := _MIN(15, v) * 16 + UserItem.btValueEx[0] mod 16;
    t_AdvAbilMax: UserItem.btValueEx[0] := UserItem.btValueEx[0] div 16 * 16 + _MIN(15, v);
    t_AdvAbil: UserItem.btValueEx[1] := v;
    t_Spirit: UserItem.btValueEx[2] := v;
    t_SpiritMax: UserItem.btValueEx[3] := v;
    t_Quality: UserItem.btValueEx[4] := v;
    t_BaseAbil: begin
        UserItem.btValueEx[05] := Abil[0].btType;
        UserItem.btValueEx[13] := _MIN(15, Abil[0].btValue) * 16 + UserItem.btValueEx[13] mod 16;

        UserItem.btValueEx[06] := Abil[1].btType;
        UserItem.btValueEx[13] := UserItem.btValueEx[13] div 16 * 16 + _MIN(15, Abil[1].btValue);

        UserItem.btValueEx[07] := Abil[2].btType;
        UserItem.btValueEx[14] := _MIN(15, Abil[2].btValue) * 16 + UserItem.btValueEx[14] mod 16;

        UserItem.btValueEx[08] := Abil[3].btType;
        UserItem.btValueEx[14] := UserItem.btValueEx[14] div 16 * 16 + _MIN(15, Abil[3].btValue);
      end;
    t_MystAbil: begin
        UserItem.btValueEx[09] := Abil[0].btType;
        UserItem.btValueEx[15] := _MIN(15, Abil[0].btValue) * 16 + UserItem.btValueEx[15] mod 16;

        UserItem.btValueEx[10] := Abil[1].btType;
        UserItem.btValueEx[15] := UserItem.btValueEx[15] div 16 * 16 + _MIN(15, Abil[1].btValue);

        UserItem.btValueEx[11] := Abil[2].btType;
        UserItem.btValueEx[16] := _MIN(15, Abil[2].btValue) * 16 + UserItem.btValueEx[16] mod 16;

        UserItem.btValueEx[12] := Abil[3].btType;
        UserItem.btValueEx[16] := UserItem.btValueEx[16] div 16 * 16 + _MIN(15, Abil[3].btValue);
      end;
  end;
end;

function CheckTIType(btType, btStdMode: Byte): Boolean;
begin
  Result := False;
  if not (btStdMode in [5, 6, 10, 11, 15, 16, 19..24, 26..30, 51..54, 62..64]) then
    Exit;
  case btType of
    1..3: Result := True;
    4, 5: if not (btStdMode in [5, 6, 19, 20, 21, 23, 24]) then
        Result := True;
    6: if (btStdMode in [5, 6, 20, 24]) then
        Result := True;
    7: if (btStdMode in [20, 24]) then
        Result := True;
    8: if (btStdMode in [19, 20, 21, 23, 24]) then
        Result := True;
    9: if (btStdMode in [5, 6, 19, 20, 21, 23, 24]) then
        Result := True;
    10: if (btStdMode in [5, 6]) then
        Result := True;
    11: if (btStdMode in [5, 6]) then
        Result := True;
    12: if (btStdMode in [5, 6]) then
        Result := True;
    13: if (btStdMode in [21, 23]) then
        Result := True;
    14: if (btStdMode in [21, 23]) then
        Result := True;
    15..30: Result := True;
  end;
end;

procedure GetSendClientItem(const UserItem: pTUserItem; const Player: TPlayObject; var ClientItem: TClientItem);
var
  i                         : Integer;
  cnt                       : Byte;
  Val                       : Byte;
  Pos                       : Byte;
  StdItem                   : pTStdItem;
  ui                        : TUserItem;
begin
  ClientItem.s.Binded := 0;
  if PCardinal(@UserItem.btValue[22])^ > 0 then begin
    if PCardinal(@UserItem.btValue[22])^ = Player.m_dwIdCRC then
      ClientItem.s.Binded := 1
    else begin
      if g_Config.boBindNoUse then
        ClientItem.s.Binded := 2
      else
        ClientItem.s.Binded := 3
    end;
  end else begin
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      case StdItem.SvrSet.nBind of
        1: ClientItem.s.Binded := 4;
        2: ClientItem.s.Binded := 5;
        3: ClientItem.s.Binded := 6;
      end;
    end;
  end;
  if (UserItem.btValue[18] > 0) then
    ClientItem.s.reserve[3] := UserItem.btValue[18]; //发光

  //if (UserItem.btValue[19] > 0) then ClientItem.s.reserve[4] := UserItem.btValue[19]; //品质
  //if (UserItem.btValue[20] > 0) then ClientItem.s.reserve[5] := UserItem.btValue[20]; //灵气值
  //if (UserItem.btValue[21] > 0) then ClientItem.s.reserve[6] := UserItem.btValue[21];

  if (ClientItem.s.Eva.EvaTimesMax > 0) or ((ClientItem.s.StdMode = 56) and (ClientItem.s.Shape = 10)) then
    GetItemEvaInfo(UserItem, ClientItem.s.Eva);
end;

function GetDigItemByName(sMAP: string): PTDigItemLists;
var
  i                         : Integer;
begin
  Result := nil;
  for i := 0 to g_DigItemList.Count - 1 do begin
    if CompareText(g_DigItemList[i], sMAP) = 0 then begin
      Result := PTDigItemLists(g_DigItemList.Objects[i]);
      Break;
    end;
  end;
end;

function LoadDigItemList(bReload: Boolean): Boolean;
var
  i, ii, iii, nVar          : Integer;
  sFileName                 : string;
  sLine, sMAP, sMAP2, sTemp, sCMap: string;
  sName, sType, sCnt, sRate : string;
  nType, nCnt, nRate        : Integer;
  pLists                    : PTDigItemLists;
  //List                      : TList;
  LoadList                  : TStringList;
  pDigItem                  : pTDigItem;
  pDigItemLists             : PTDigItemLists;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DigItemList.txt';

  try
    for i := 0 to g_DigItemList.Count - 1 do begin
      pDigItemLists := PTDigItemLists(g_DigItemList.Objects[i]);
      for ii := Low(TDigItemLists) to High(TDigItemLists) do begin
        for iii := 0 to pDigItemLists[ii].Count - 1 do
          Dispose(pTDigItem(pDigItemLists[ii].Items[iii]));
        pDigItemLists[ii].Free;
      end;
    end;
    g_DigItemList.Clear;

    if not FileExists(sFileName) then begin
      LoadList := TStringList.Create;
      LoadList.Add(';[地图名] 例如：[3]  表示是盟重的挖宝配置');
      LoadList.Add(';{难度分类 0=灵媒品质(1-50) 1=灵媒品质(51-100) 2=灵媒品质(101-150) 3=灵媒品质(151-250) 4=灵媒品质(250-255)}');
      LoadList.Add(';物品名称'#9'难度分类'#9'数量'#9'几率');
      LoadList.SaveToFile(sFileName);
      LoadList.Free;
      Exit;
    end;

    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);

    pLists := nil;
    sMAP := '';
    sMAP2 := '';
    for i := 0 to LoadList.Count - 1 do begin
      sLine := Trim(LoadList.Strings[i]);
      if (sLine <> '') and (sLine[1] <> ';') then begin
        if sLine[1] = '[' then begin
          if pLists <> nil then begin
            g_DigItemList.AddObject(sMAP, TObject(pLists));
            if sMAP2 <> '' then
              g_DigItemList.AddObject(sMAP2, TObject(pLists));
            Result := True;
          end;
          ArrestStringEx(sLine, '[', ']', sMAP);
          if sMAP <> '' then begin
            New(pLists);
            for ii := Low(TDigItemLists) to High(TDigItemLists) do
              pLists[ii] := TList.Create;
            if Pos('|', sMAP) > 0 then begin
              GetValidStr3(sMAP, sMAP2, ['|']);
            end else if Pos('>', sMAP) > 0 then begin
              sMAP2 := ArrestStringEx(sMAP, '<', '>', sCMap);
            end;
          end;
        end else if pLists <> nil then begin
          sLine := GetValidStr3(sLine, sName, [' ', ',', #9]);
          sLine := GetValidStr3(sLine, sType, [' ', ',', #9]);
          sLine := GetValidStr3(sLine, sCnt, [' ', ',', #9]);
          sLine := GetValidStr3(sLine, sRate, [' ', ',', #9]);

          nType := Str_ToInt(sType, -1);
          nCnt := Str_ToInt(sCnt, -1);
          nRate := Str_ToInt(sRate, -1);
          if (sName <> '') and (nType in [0..4]) and (nCnt > 0) and (nRate > 0) then begin
            New(pDigItem);
            pDigItem.sName := sName;
            pDigItem.nCnt := nCnt;
            pDigItem.nRate := nRate;
            pLists[nType].Add(pDigItem);
          end;
        end;
      end;
    end;
    if pLists <> nil then begin
      g_DigItemList.AddObject(sMAP, TObject(pLists));
      if sMAP2 <> '' then
        g_DigItemList.AddObject(sMAP2, TObject(pLists));
      Result := True;
    end;
    LoadList.Free;
  finally
    if bReload and Result then begin
      g_MapManager.ReSetMapDigItemLists(g_DigItemList);
    end;
  end;
end;

function LoadQFLableList(): Boolean;
var
  i, ii, iii, nVar          : Integer;
  sScriptFile               : string;
  sLine, sLabel             : string;
  boExist                   : Boolean;
  LoadList                  : TStringList;
begin
  Result := False;
  sScriptFile := g_Config.sEnvirDir + sMarket_Def + 'QFunction-0.txt';
  if g_QFLabelList = nil then
    g_QFLabelList := TCnHashTableSmall.Create();

  g_QFLabelList.Clear;
  if not FileExists(sScriptFile) then
    Exit;

  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sScriptFile);
  boExist := False;
  sLabel := '';
  for i := 0 to LoadList.Count - 1 do begin
    sLine := Trim(LoadList.Strings[i]);
    if (sLine <> '') and (sLine[1] <> ';') then begin
      if sLine[1] = '[' then begin
        if boExist then begin
          g_QFLabelList.Put(sLabel, nil);
          Result := True;
        end;
        boExist := True;
        ArrestStringEx(sLine, '[', ']', sLabel);
      end else if boExist then begin
        //
      end;
    end;
  end;
  if boExist then begin
    g_QFLabelList.Put(sLabel, nil);
    Result := True;
  end;
  LoadList.Free;
end;

function LoadDisableTreasureIdentifyList(): Boolean;
var
  i, ii                     : Integer;
  sFileName, sLineText      : string;
  LoadList                  : TStringList;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'DisTIList.txt';
  if g_DisTIList = nil then
    g_DisTIList := TCnHashTableSmall.Create();

  g_DisTIList.Clear;

  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.Add(';禁止鉴定的物品列表，每行一个物品名');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;

  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sFileName);
  for i := 0 to LoadList.Count - 1 do begin
    sLineText := Trim(LoadList.Strings[i]);
    if (sLineText = '') or (sLineText[1] = ';') then
      Continue;
    g_DisTIList.Put(Trim(sLineText), nil);
  end;
  LoadList.Free;
end;

function GetTitleTime(Title: THumTitle): Integer;
var
  StdItem                   : pTStdItem;
begin
  Result := 0;
  if Title.Index > 0 then begin
    StdItem := UserEngine.GetTitle(Title.Index);
    if StdItem <> nil then begin
      if StdItem.DuraMax = 0 then
        Result := -15
      else if Title.Time = 0 then
        Result := -14
      else
        Result := StdItem.DuraMax - Round((GetItemFormatDate - Title.Time) / (60 * 60));
      //if Result <= 0 then begin
      //  Title.Index := 0;
      //end;
    end;
  end;
end;

function AddBlockUser(szUserName: string): Boolean;
var
  i                         : Integer;
begin
  EnterCriticalSection(g_BlockUserLock);
  try
    for i := 0 to g_xBlockUserList.Count - 1 do begin
      if CompareText(g_xBlockUserList[i], szUserName) = 0 then
        Exit;
    end;
    g_xBlockUserList.Add(szUserName);
  finally
    LeaveCriticalSection(g_BlockUserLock);
  end;
end;

initialization
  Config := TIniFile.Create(sConfigFileName);
  CommandConf := TIniFile.Create(sCommandFileName);
  StringConf := TIniFile.Create(sStringFileName);
{$IF OEMVER = OEM775}
  Level775 := TIniFile.Create(sConfig775FileName);
{$IFEND}
  Move(ColorArray, ColorTable, SizeOf(ColorArray));
  nIPLocal := AddToPulgProcTable('GetIPLocal');
  nExVersionNO := AddToPulgProcTable('GetExVersionNO');
  nGoldShape := AddToPulgProcTable('GetGoldShape');
  nResourceString := AddToPulgProcTable('GetResourceString');
  nPulgProc01 := AddToPulgProcTable('PulgProc01');
  nPulgProc02 := AddToPulgProcTable('PulgProc02');
  nPulgProc03 := AddToPulgProcTable('PulgProc03');
  nPulgProc04 := AddToPulgProcTable('PulgProc04');
  nPulgProc05 := AddToPulgProcTable('PulgProc05');
  nPulgProc06 := AddToPulgProcTable('PulgProc06');
  nPulgProc07 := AddToPulgProcTable('PulgProc07');
  nPulgProc15 := AddToPulgProcTable('PulgProc15');



  New(ENDYEARMIN);
  New(ENDMONTHMIN);
  New(ENDDAYMIN);

  New(ENDYEAR);
  New(ENDMONTH);
  New(ENDDAY);

  ENDYEARMIN^ := 2009;
  ENDMONTHMIN^ := 10;
  ENDDAYMIN^ := 15;

  ENDYEAR^ := 2228;
  ENDMONTH^ := 12;
  ENDDAY^ := 15;



finalization
  Config.Free;
  CommandConf.Free;
  StringConf.Free;
{$IF OEMVER = OEM775}
  Level775.Free;
{$IFEND}



end.

