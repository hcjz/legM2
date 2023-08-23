unit MShare;

interface

uses
  Windows, Classes, SysUtils, Forms, Dialogs,
  HGE,HGEFont,HGEFonts,HGECanvas,HGEBase,HGETextures,Wilpion,
  DWinCtl, WIL, HumanActor, Actor, Grobal2, NewFont, GfxFont,
  GList, IniFiles, HashList, Graphics, MirEffect, CnHashTable;

const
  MAXX = 40; //SCREENWIDTH div 20;
  MAXY = 30; //SCREENWIDTH div 20;
  LONGHEIGHT_IMAGE = 35;
  FLASHBASE = 410;
  SOFFX = 0;
  SOFFY = 0;
  HEALTHBAR_BLACK = 0;
//  HEALTHBAR_RED = 1;
  BARWIDTH = 30;
  BARHEIGHT = 2;
  MAXSYSLINE = 8;
  BOTTOMBOARD = 1;
  AREASTATEICONBASE = 150;
  g_WinBottomRetry = 45;

var
  g_Titles: THumTitles;
  g_ActiveTitle: THumTitle;
  g_hTitles: THumTitles;
  g_hActiveTitle: THumTitle;

{$IFDEF DEBUG_LOGIN}
  g_fWZLFirst: Byte = 7;
{$ELSE}
  g_fWZLFirst: Byte = 7;
{$ENDIF}

  g_boLogon: Boolean = False;
  g_fGoAttack: Boolean = False;
  //g_QueryWinBottomTick: Longword;
  //g_fGetRenderBottom: Boolean = False;

  g_nDragonRageStateIndex: Integer = 0;
  SCREENWIDTH: Integer = 800;
  SCREENHEIGHT: Integer = 600;
  AAX: Integer = 26 + 14;
  LMX: Integer = 30;
  LMY: Integer = 26;
  VIEWWIDTH: Integer = 8;

  BOTTOMTOP: Integer = 600 - 251;
  WINRIGHT: Integer = 800 - 100; //窗体右边 图片素材左边以屏幕左边为起点到屏幕右边的宽度为X分辨率 - 100
  BOTTOMEDGE: Integer = 600 - 19; //窗体底边 图片素材底边以屏幕顶边为起点到屏幕底边的高度为Y分辨率 - 19
  SURFACEMEMLEN: Integer;
  MAPSURFACEWIDTH: Integer = 800;
  MAPSURFACEHEIGHT: Integer = 600 - 150;
  BOXWIDTH: Integer;

  g_SkidAD_Rect: TRect;
  g_SkidAD_Rect2: TRect;
  G_RC_LEVEL: TRect;
  G_RC_EXP: TRect;
  G_RC_WEIGTH: TRect;
  G_RC_SQUENGINER: TRect;
  G_RC_IMEMODE: TRect;

const
  {------------}
  NEWHINTSYS = True;
//  MIR2EX = True;



  NPC_CILCK_INVTIME = 500;
  MAXITEMBOX_WIDTH = 177;
  MAXMAGICLV = 3;
  RUNLOGINCODE = 0;
  CLIENT_VERSION_NUMBER = 120020522;
  STDCLIENT = 0;
  RMCLIENT = 46;
  CLIENTTYPE = RMCLIENT;
  CUSTOMLIBFILE = 0;
  DEBUG = 0;

  LOGICALMAPUNIT = 30; //1108 40;
  HUMWINEFFECTTICK = 200;

  WINLEFT = 100; //窗体左边 图片素材留在左边屏幕内的尺寸为100
  WINTOP = 100; //窗体顶边 图片素材留在顶边屏幕内的尺寸为100
  MINIMAPSIZE = 200; //迷你地图宽度


  DEFAULTCURSOR = 0; //系统默认光标
  IMAGECURSOR = 1; //图形光标
  USECURSOR = DEFAULTCURSOR; //使用什么类型的光标



  MAXBAGITEMCL = 52;
  MAXFONT = 8;
  ENEMYCOLOR = 69;
  HERO_MIIDX_OFFSET = 5000;
  SAVE_MIIDX_OFFSET = HERO_MIIDX_OFFSET + 500;
  STALL_MIIDX_OFFSET = HERO_MIIDX_OFFSET + 500 + 50;
  DETECT_MIIDX_OFFSET = HERO_MIIDX_OFFSET + 500 + 50 + 10 + 1;
  MSGMUCH = 2;

  g_sHumAttr: array[1..5] of string = ('金', '木', '水', '火', '土');
{$IFDEF UI_0508}
//  g_DBStateStrArr:  array[0..3] of string = ('装', '状', '属', '技');
//  g_DBStateStrArrW: array[0..3] of string = ('备', '态', '性', '能');
  //扩展四格称号修改 Development 2019-01-25
  g_DBStateStrArr:  array[0..4] of string = ('装', '状', '属', '技', '称');
  g_DBStateStrArrW: array[0..4] of string = ('备', '态', '性', '能', '号');

  g_DBStateStrArrUS:  array[0..2] of string = ('装', '时', '称');
  g_DBStateStrArrUSW: array[0..2] of string = ('备', '装', '号');

  g_DBStateStrArr2:  array[0..3] of string = ('状', '技', '经', '连');
  g_DBStateStrArr2W: array[0..3] of string = ('态', '能', '络', '击');
{$ELSE}
  g_DBStateStrArr:  array[0..6] of string = ('装', '时', '状', '属', '称', '技', '其');
  g_DBStateStrArrw: array[0..6] of string = ('备', '装', '态', '性', '号', '能', '他');
  g_DBStateStrArrUS:  array[0..2] of string = ('装', '时', '称');
  g_DBStateStrArrUSw: array[0..2] of string = ('备', '装', '号');
  g_DBStateStrArr2:  array[0..4] of string = ('状', '技', '经', '连', '其');
  g_DBStateStrArr2w: array[0..4] of string = ('态', '能', '络', '击', '他');
{$ENDIF}


{$IF SERIESSKILL}
  g_VenationLvStrArr:  array[0..6] of string = ('经', '经', '一', '二', '三', '四', '五');
  g_VenationLvStrArr2: array[0..6] of string = ('络', '络', '重', '重', '重', '重', '重');
  g_VenationLvStrArr3: array[0..6] of string = ('未', '已', '经', '经', '经', '经', '经');
  g_VenationLvStrArr4: array[0..6] of string = ('通', '通', '络', '络', '络', '络', '络');
{$IFEND SERIESSKILL}

  g_slegend: array[0..13] of string = (
    '', //0
    '传奇神剑', //1
    '传奇勋章', //2
    '传奇项链', //3
    '传奇之冠', //4
    '', //5
    '传奇护腕', //6
    '', //7
    '传奇之戒', //8
    '', //9
    '传奇腰带', //10
    '传奇之靴', //11
    '', //12
    '传奇面巾' //13
    );

  //config
  MAX_GC_GENERAL = 16;
  g_ptGeneral: array[0..MAX_GC_GENERAL] of TRect = (
    (Left: 35 + 000; Top: 70 + 23 * 0; Right: 35 + 000 + 72 + 18; Bottom: 70 + 23 * 0 + 16), //0
    (Left: 35 + 000; Top: 70 + 23 * 1; Right: 35 + 000 + 72 + 18; Bottom: 70 + 23 * 1 + 16), //1
    (Left: 35 + 000; Top: 70 + 23 * 2; Right: 35 + 000 + 78 + 18; Bottom: 70 + 23 * 2 + 16), //2
    (Left: 35 + 000; Top: 70 + 23 * 3; Right: 35 + 000 + 96; Bottom: 70 + 23 * 3 + 16), //3

    (Left: 35 + 120; Top: 70 + 23 * 0; Right: 35 + 120 + 72 + 30; Bottom: 70 + 23 * 0 + 16), //4
    (Left: 35 + 120; Top: 70 + 23 * 1; Right: 35 + 120 + 72; Bottom: 70 + 23 * 1 + 16), //5
    (Left: 35 + 120; Top: 70 + 23 * 2; Right: 35 + 120 + 72 + 18; Bottom: 70 + 23 * 2 + 16), //6
    (Left: 35 + 120; Top: 70 + 23 * 3; Right: 35 + 120 + 72; Bottom: 70 + 23 * 3 + 16), //7
    (Left: 35 + 120; Top: 70 + 23 * 4; Right: 35 + 120 + 72 + 18; Bottom: 70 + 23 * 4 + 16),

    (Left: 35 + 240; Top: 70 + 23 * 0; Right: 35 + 240 + 72; Bottom: 70 + 23 * 0 + 16),
    (Left: 35 + 240; Top: 70 + 23 * 1; Right: 35 + 240 + 72; Bottom: 70 + 23 * 1 + 16),
    (Left: 35 + 240; Top: 70 + 23 * 2; Right: 35 + 240 + 48; Bottom: 70 + 23 * 2 + 16),
    (Left: 35 + 240; Top: 70 + 23 * 3; Right: 35 + 240 + 72; Bottom: 70 + 23 * 3 + 16),
    (Left: 35 + 240; Top: 70 + 23 * 4; Right: 35 + 240 + 72; Bottom: 70 + 23 * 4 + 16),
    (Left: 35 + 240; Top: 70 + 23 * 5; Right: 35 + 240 + 72; Bottom: 70 + 23 * 5 + 16),

    (Left: 35 + 120; Top: 70 + 23 * 5; Right: 35 + 120 + 72; Bottom: 70 + 23 * 5 + 16),
    (Left: 35 + 000; Top: 70 + 23 * 5; Right: 35 + 000 + 96; Bottom: 70 + 23 * 5 + 16)
    );
  g_caGeneral: array[0..MAX_GC_GENERAL] of string = (
    '人名显示(Z)', //0
    '持久警告(X)', //1
    '免Shift键(C)', //2
    '显示经验过滤', //3
    '物品提示(ESC)', //4
    '显示过滤', //'显示过滤',                     //5
    '隐藏人物翅膀', //6
    '预留(无作用)', //'拣取过滤',                     //7
    '隐藏尸体(V)', //8
    '自动修理', //9
    '屏幕震动',
    '音效',
    '预留',
    '数字飘血',
    '装备比较',
    '稳如泰山',
    '显示称号'
    );
  g_HintGeneral: array[0..MAX_GC_GENERAL] of string = (
    '钩选此项将全屏显示玩家名字', //0
    '钩选此项在装备持久低时进行提示', //1
    '钩选此项将不需要按Shift也能\攻击其他玩家', //2
    '钩选此项将隐藏聊天栏中低于\设置的经验值提示', //3
    '钩选此项将显示地面未过滤的\物品的名字', //4
    '钩选此项将过滤部分地面物品的显示', //5
    '钩选此项将不显示人物翅膀效果，可避免\电脑较差且翅膀显示过多而导致卡问题', //6
    '', //'钩选此项将不自动拣取未显示\在地面上的物品', //7
    '钩选此项将隐藏已死亡的怪物\尸体，避免资源效果，游戏更流畅', //8
    '钩选此项将自动修理身上装备\包裹需放置有一定持久的修复神水', //9
    '钩选此项将触发游戏中的屏幕震动效果',
    '钩选此项将启用游戏音效反之\则关闭游戏的音效',
    '',
    '钩选此项将触发开启伤害值显示',
    '是否开启装备比较功能',
    '钩选此项将屏蔽人物受打击时的后昂动作',
    '钩选此项将显示人物头顶的称号'
    );
  g_gcGeneral: array[0..MAX_GC_GENERAL] of Boolean = (True, True, False, True, True, True, False, True, False, True, True, True, True, False, False, True, True);
  g_clGeneral: array[0..MAX_GC_GENERAL] of TColor = (clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver);
  g_clGeneralDef: array[0..MAX_GC_GENERAL] of TColor = (clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver);

  //====================================Protect====================================
  MAX_GC_PROTECT = 11;
  g_ptProtect: array[0..MAX_GC_PROTECT] of TRect = (
    (Left: 35 + 000; Top: 70 + 24 * 0; Right: 35 + 000 + 20; Bottom: 70 + 24 * 0 + 16), //0
    (Left: 35 + 000; Top: 70 + 24 * 1; Right: 35 + 000 + 20; Bottom: 70 + 24 * 1 + 16), //1
    (Left: 35 + 000; Top: 70 + 24 * 2; Right: 35 + 000 + 20; Bottom: 70 + 24 * 2 + 16), //2
    (Left: 35 + 000; Top: 70 + 24 * 3; Right: 35 + 000 + 20; Bottom: 70 + 24 * 3 + 16), //3
    (Left: 35 + 000; Top: 70 + 24 * 4; Right: 35 + 000 + 20; Bottom: 70 + 24 * 4 + 16), //4
    (Left: 35 + 000; Top: 70 + 24 * 5; Right: 35 + 000 + 20; Bottom: 70 + 24 * 5 + 16), //5
    (Left: 35 + 000; Top: 70 + 24 * 6; Right: 35 + 000 + 72; Bottom: 70 + 24 * 6 + 16), //6
    (Left: 35 + 180; Top: 70 + 24 * 0; Right: 35 + 180 + 20; Bottom: 70 + 24 * 0 + 16), //0
    (Left: 35 + 180; Top: 70 + 24 * 1; Right: 35 + 180 + 20; Bottom: 70 + 24 * 1 + 16), //1
    (Left: 35 + 180; Top: 70 + 24 * 3; Right: 35 + 180 + 20; Bottom: 70 + 24 * 3 + 16),
    (Left: 35 + 180; Top: 70 + 24 * 5; Right: 35 + 180 + 20; Bottom: 70 + 24 * 5 + 16),
    (Left: 35 + 180; Top: 70 + 24 * 6; Right: 35 + 180 + 20; Bottom: 70 + 24 * 6 + 16)
    );
  g_caProtect: array[0..MAX_GC_PROTECT] of string = (
    'HP               毫秒', //0
    'MP               毫秒', //1
    '', //2
    'HP               毫秒', //3
    '', //4
    'HP               毫秒', //5
    '卷轴类型', //6
    'HP               毫秒', //7
    'MP               毫秒', //8
    'HP               毫秒', //9
    'HP', //10
    'MP不足允许使用特殊药品'
    );
  g_sRenewBooks: array[0..MAX_GC_PROTECT] of string = (
    '随机传送卷', //shape = 2
    '地牢逃脱卷', //shape = 1
    '回城卷', //shape = 3
    '行会回城卷', //shape = 5
    '盟重传送石',
    '比奇传送石',
    '随机传送石',
    '',
    '',
    '',
    '',
    ''
    );
  g_gcProtect: array[0..MAX_GC_PROTECT] of Boolean = (False, False, False, False, False, False, False, True, True, True, False, True);
  g_gnProtectPercent: array[0..MAX_GC_PROTECT] of Integer = (10, 10, 10, 10, 10, 10, 0, 88, 88, 88, 20, 00);
  g_gnProtectTime: array[0..MAX_GC_PROTECT] of Integer = (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 1000, 1000, 1000);
  g_clProtect: array[0..MAX_GC_PROTECT] of TColor = (clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clLime);

  //====================================Tec====================================
  MAX_GC_TEC = 14;
  g_ptTec: array[0..MAX_GC_TEC] of TRect = (
    (Left: 35 + 000; Top: 70 + 20 * 0; Right: 35 + 000 + 72; Bottom: 70 + 20 * 0 + 16), //0
    (Left: 35 + 000; Top: 70 + 20 * 1; Right: 35 + 000 + 72; Bottom: 70 + 20 * 1 + 16), //1
    (Left: 35 + 000; Top: 70 + 20 * 2; Right: 35 + 000 + 72; Bottom: 70 + 20 * 2 + 16), //2
    (Left: 35 + 000; Top: 70 + 20 * 3; Right: 35 + 000 + 72; Bottom: 70 + 20 * 3 + 16), //3

    (Left: 35 + 120; Top: 70 + 24 * 0; Right: 35 + 120 + 72; Bottom: 70 + 24 * 0 + 16), //4
    (Left: 35 + 120; Top: 70 + 24 * 1; Right: 35 + 120 + 72; Bottom: 70 + 24 * 1 + 16), //5

    (Left: 35 + 240; Top: 70 + 24 * 0; Right: 35 + 240 + 72; Bottom: 70 + 24 * 0 + 16), //6

    (Left: 35 + 120; Top: 70 + 24 * 5; Right: 35 + 120 + 72; Bottom: 70 + 24 * 5 + 16), //7
    (Left: 35 + 120; Top: 70 + 24 * 6; Right: 35 + 120 + 20; Bottom: 70 + 24 * 6 + 16), //8

    (Left: 35 + 000; Top: 70 + 20 * 4; Right: 35 + 000 + 72; Bottom: 70 + 20 * 4 + 16), //9
    (Left: 35 + 000; Top: 70 + 20 * 5; Right: 35 + 000 + 72; Bottom: 70 + 20 * 5 + 16),
    (Left: 35 + 000; Top: 70 + 20 * 6; Right: 35 + 000 + 72; Bottom: 70 + 20 * 6 + 16),

    (Left: 35 + 240; Top: 70 + 24 * 5; Right: 35 + 240 + 72; Bottom: 70 + 24 * 5 + 16),
    (Left: 35 + 000; Top: 70 + 20 * 7; Right: 35 + 000 + 72; Bottom: 70 + 20 * 7 + 16),
    (Left: 35 + 120; Top: 70 + 24 * 2 + 12; Right: 35 + 120 + 72; Bottom: 70 + 24 * 2 + 16 + 12)
    );

  g_HintTec: array[0..MAX_GC_TEC] of string = (
    '钩选此项将开启刀刀刺杀', //0
    '钩选此项将开启智能半月', //1
    '钩选此项将自动凝聚烈火剑法', //2
    '钩选此项将自动凝聚逐日剑法', //3
    '钩选此项将自动开启魔法盾', //4
    '钩选此项英雄将自动开启魔法盾', //5
    '钩选此项道士将自动使用隐身术', //6
    '',
    '',
    '钩选此项将自动凝聚雷霆剑法', //7
    '钩选此项将自动进行隔位刺杀', //8
    '钩选此项将自动凝聚断空斩', //9
    '钩选此项英雄将不使用连击打怪\方便玩家之间进行PK',
    '钩选此项将自动凝聚开天斩',
    '钩选此项：施展魔法超过允许距离时，会自动跑近目标并释放魔法'
    );
  g_caTec: array[0..MAX_GC_TEC] of string = (
    '刀刀刺杀', //0
    '智能半月', //1
    '自动烈火', //2
    '逐日剑法', //3
    '自动开盾', //4
    '持续开盾(英雄)', //5
    '自动隐身', //6
    '时间间隔', //7
    '', //8
    '自动雷霆', //9
    '隔位刺杀',
    '自动断空斩',
    '英雄连击不打怪',
    '自动开天斩',
    '自动调节魔法距离');
  g_sMagics: array[0..MAX_GC_TEC] of string = (
    '火球术',
    '治愈术',
    '大火球',
    '施毒术',
    '攻杀剑术',
    '抗拒火环',
    '地狱火',
    '疾光电影',
    '雷电术',
    '雷电术',
    '雷电术',
    '雷电术',
    '雷电术',
    '开天斩',
    '开天斩');
  g_gnTecPracticeKey: Integer = 0;
  g_gcTec: array[0..MAX_GC_TEC] of Boolean = (True, True, True, True, True, True, False, False, False, False, False, False, False, True, False);
  g_gnTecTime: array[0..MAX_GC_TEC] of Integer = (0, 0, 0, 0, 0, 0, 0, 0, 4000, 0, 0, 0, 0, 0, 0);
  g_clTec: array[0..MAX_GC_TEC] of TColor = (clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver);

  //====================================Assistant====================================
  MAX_GC_ASS = 6;
  g_ptAss: array[0..MAX_GC_ASS] of TRect = (
    (Left: 35 + 000; Top: 70 + 24 * 0; Right: 35 + 000 + 142; Bottom: 70 + 24 * 0 + 16), //0
    (Left: 35 + 000; Top: 70 + 24 * 1; Right: 35 + 000 + 72; Bottom: 70 + 24 * 1 + 16), //1
    (Left: 35 + 000; Top: 70 + 24 * 2; Right: 35 + 000 + 72; Bottom: 70 + 24 * 2 + 16), //2
    (Left: 35 + 000; Top: 70 + 24 * 3; Right: 35 + 000 + 72; Bottom: 70 + 24 * 3 + 16), //3
    (Left: 35 + 000; Top: 70 + 24 * 4; Right: 35 + 000 + 72; Bottom: 70 + 24 * 4 + 16), //4
    (Left: 35 + 000; Top: 70 + 24 * 5; Right: 35 + 000 + 120; Bottom: 70 + 24 * 5 + 16), //5
    (Left: 35 + 000; Top: 70 + 24 * 6; Right: 35 + 000 + 120; Bottom: 70 + 24 * 6 + 16)
    );
  g_HintAss: array[0..MAX_GC_ASS] of string = (
    '',
    '', //0
    '', //1
    '', //2
    '', //3
    '可以自己编辑要显示和拾取的物品，开启\此功能后，将替换掉 [物品] 选项卡的设置', //4
    '');
  g_caAss: array[0..MAX_GC_ASS] of string = (
    '开启挂机(Ctrl+Alt+X)',
    '红药用完回城', //0
    '蓝药用完回城', //1
    '符毒用完回城', //2
    '背包满时回城', //3
    '自定物品过滤(钩选编辑)', //4
    '自定打怪过滤(钩选编辑)');
  g_gcAss: array[0..MAX_GC_ASS] of Boolean = (False, False, False, False, False, False, False);
  g_clAss: array[0..MAX_GC_ASS] of TColor = (clLime, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver);

  //====================================HotKey====================================
  MAX_GC_HOTKEY = 8;
  g_ptHotkey: array[0..MAX_GC_HOTKEY] of TRect = (
    (Left: 25 + 000; Top: 43 + 20 * 0; Right: 35 + 000 + 99; Bottom: 43 + 20 * 0 + 16), //0
    (Left: 25 + 000; Top: 43 + 20 * 2; Right: 35 + 000 + 80; Bottom: 43 + 20 * 2 + 16), //2
    (Left: 25 + 000; Top: 43 + 20 * 3; Right: 35 + 000 + 80; Bottom: 43 + 20 * 3 + 16), //3
    (Left: 25 + 000; Top: 43 + 20 * 4; Right: 35 + 000 + 80; Bottom: 43 + 20 * 4 + 16), //4
    (Left: 25 + 000; Top: 43 + 20 * 5; Right: 35 + 000 + 80; Bottom: 43 + 20 * 5 + 16), //5
    (Left: 25 + 000; Top: 43 + 20 * 6; Right: 35 + 000 + 80; Bottom: 43 + 20 * 6 + 16), //6
    (Left: 25 + 000; Top: 43 + 20 * 7; Right: 35 + 000 + 80; Bottom: 43 + 20 * 7 + 16), //7
    (Left: 25 + 000; Top: 43 + 20 * 8; Right: 35 + 000 + 80; Bottom: 43 + 20 * 8 + 16),
    (Left: 25 + 000; Top: 43 + 20 * 9; Right: 35 + 000 + 80; Bottom: 43 + 20 * 9 + 16) //8
    );
  g_caHotkey: array[0..MAX_GC_HOTKEY] of string = (
    '启用自定快捷键',
    '召唤英雄', //0
    '英雄攻击目标', //1
    '使用合击技能', //2
    '英雄攻击模式', //3
    '英雄守护模式', //4
    '切换攻击模式', //5
    '切换小地图',
    '释放连击'
    );
  g_gcHotkey: array[0..MAX_GC_HOTKEY] of Boolean = (False, False, False, False, False, False, False, False, False);
  g_gnHotkey: array[0..MAX_GC_HOTKEY] of Integer = (0, 0, 0, 0, 0, 0, 0, 0, 0);
  g_clHotkey: array[0..MAX_GC_HOTKEY] of TColor = (clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clLime);

  //====================================物品====================================
var
  g_BuildBotTex: Byte = 0;
  g_WinBottomType: Byte = 0;
  g_Windowed: Boolean = False;
//  g_pkeywords: PString = nil;

  g_boAutoPickUp: Boolean = True;
  g_boPickUpAll: Boolean = False;
  g_ptItems_Pos: Integer = -1;
  g_ptItems_Type: Integer = 0;
  g_ItemsFilter_All: TCnHashTableSmall;
  g_ItemsFilter_All_Def: TCnHashTableSmall;
  g_ItemsFilter_Dress: TStringList;
  g_ItemsFilter_Weapon: TStringList;
  g_ItemsFilter_Headgear: TStringList;
  g_ItemsFilter_Drug: TStringList;
  g_ItemsFilter_Other: TStringList;

  g_xMapDescList: TStringList;
  g_xCurMapDescList: TStringList;

const

  MAX_GC_ITEMS = 7;
  g_ptItemsA: TRect = (Left: 25 + 194; Top: 68 + 18 * 7 + 23; Right: 25 + 194 + 80; Bottom: 68 + 18 * 7 + 16 + 23);
  g_ptAutoPickUp: TRect = (Left: 25 + 267; Top: 68 + 18 * 7 + 23; Right: 25 + 267 + 80; Bottom: 68 + 18 * 7 + 16 + 23);

  g_ptItems0: array[0..MAX_GC_ITEMS] of TRect = (
    (Left: 25 + 000; Top: 68 + 18 * 0; Right: 25 + 000 + 120; Bottom: 68 + 18 * 0 + 16), //0
    (Left: 25 + 000; Top: 68 + 18 * 1; Right: 25 + 000 + 120; Bottom: 68 + 18 * 1 + 16), //1
    (Left: 25 + 000; Top: 68 + 18 * 2; Right: 25 + 000 + 120; Bottom: 68 + 18 * 2 + 16), //2
    (Left: 25 + 000; Top: 68 + 18 * 3; Right: 25 + 000 + 120; Bottom: 68 + 18 * 3 + 16), //3
    (Left: 25 + 000; Top: 68 + 18 * 4; Right: 25 + 000 + 120; Bottom: 68 + 18 * 4 + 16), //4
    (Left: 25 + 000; Top: 68 + 18 * 5; Right: 25 + 000 + 120; Bottom: 68 + 18 * 5 + 16), //5
    (Left: 25 + 000; Top: 68 + 18 * 6; Right: 25 + 000 + 120; Bottom: 68 + 18 * 6 + 16),
    (Left: 25 + 000; Top: 68 + 18 * 7; Right: 25 + 000 + 120; Bottom: 68 + 18 * 7 + 16)
    );
  g_ptItems1: array[0..MAX_GC_ITEMS] of TRect = (
    (Left: 25 + 160; Top: 68 + 18 * 0; Right: 25 + 160 + 16; Bottom: 68 + 18 * 0 + 16), //0
    (Left: 25 + 160; Top: 68 + 18 * 1; Right: 25 + 160 + 16; Bottom: 68 + 18 * 1 + 16), //1
    (Left: 25 + 160; Top: 68 + 18 * 2; Right: 25 + 160 + 16; Bottom: 68 + 18 * 2 + 16), //2
    (Left: 25 + 160; Top: 68 + 18 * 3; Right: 25 + 160 + 16; Bottom: 68 + 18 * 3 + 16), //3
    (Left: 25 + 160; Top: 68 + 18 * 4; Right: 25 + 160 + 16; Bottom: 68 + 18 * 4 + 16), //4
    (Left: 25 + 160; Top: 68 + 18 * 5; Right: 25 + 160 + 16; Bottom: 68 + 18 * 5 + 16), //5
    (Left: 25 + 160; Top: 68 + 18 * 6; Right: 25 + 160 + 16; Bottom: 68 + 18 * 6 + 16),
    (Left: 25 + 160; Top: 68 + 18 * 7; Right: 25 + 160 + 16; Bottom: 68 + 18 * 7 + 16)
    );
  g_ptItems2: array[0..MAX_GC_ITEMS] of TRect = (
    (Left: 25 + 220; Top: 68 + 18 * 0; Right: 25 + 220 + 16; Bottom: 68 + 18 * 0 + 16), //0
    (Left: 25 + 220; Top: 68 + 18 * 1; Right: 25 + 220 + 16; Bottom: 68 + 18 * 1 + 16), //1
    (Left: 25 + 220; Top: 68 + 18 * 2; Right: 25 + 220 + 16; Bottom: 68 + 18 * 2 + 16), //2
    (Left: 25 + 220; Top: 68 + 18 * 3; Right: 25 + 220 + 16; Bottom: 68 + 18 * 3 + 16), //3
    (Left: 25 + 220; Top: 68 + 18 * 4; Right: 25 + 220 + 16; Bottom: 68 + 18 * 4 + 16), //4
    (Left: 25 + 220; Top: 68 + 18 * 5; Right: 25 + 220 + 16; Bottom: 68 + 18 * 5 + 16), //5
    (Left: 25 + 220; Top: 68 + 18 * 6; Right: 25 + 220 + 16; Bottom: 68 + 18 * 6 + 16),
    (Left: 25 + 220; Top: 68 + 18 * 7; Right: 25 + 220 + 16; Bottom: 68 + 18 * 7 + 16)
    );
  g_ptItems3: array[0..MAX_GC_ITEMS] of TRect = (
    (Left: 25 + 280; Top: 68 + 18 * 0; Right: 25 + 280 + 16; Bottom: 68 + 18 * 0 + 16), //0
    (Left: 25 + 280; Top: 68 + 18 * 1; Right: 25 + 280 + 16; Bottom: 68 + 18 * 1 + 16), //1
    (Left: 25 + 280; Top: 68 + 18 * 2; Right: 25 + 280 + 16; Bottom: 68 + 18 * 2 + 16), //2
    (Left: 25 + 280; Top: 68 + 18 * 3; Right: 25 + 280 + 16; Bottom: 68 + 18 * 3 + 16), //3
    (Left: 25 + 280; Top: 68 + 18 * 4; Right: 25 + 280 + 16; Bottom: 68 + 18 * 4 + 16), //4
    (Left: 25 + 280; Top: 68 + 18 * 5; Right: 25 + 280 + 16; Bottom: 68 + 18 * 5 + 16), //5
    (Left: 25 + 280; Top: 68 + 18 * 6; Right: 25 + 280 + 16; Bottom: 68 + 18 * 6 + 16),
    (Left: 25 + 280; Top: 68 + 18 * 7; Right: 25 + 280 + 16; Bottom: 68 + 18 * 7 + 16)
    );

  g_caItems: array[0..MAX_GC_ITEMS] of pTCItemRule = (nil, nil, nil, nil, nil, nil, nil, nil);
  g_caItems2: array[0..MAX_GC_ITEMS] of pTCItemRule = (nil, nil, nil, nil, nil, nil, nil, nil);
  g_clItems: array[0..MAX_GC_ITEMS] of TColor = (clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver);

  MAX_SERIESSKILL_POINT = 4;

  g_HitSpeedRate: Integer = 0;
  g_MagSpeedRate: Integer = 0;
  g_MoveSpeedRate: Integer = 0;

type
  TVaInfo = packed record
    cap: string;
    pt1: array[0..MAX_SERIESSKILL_POINT] of TRect;
    pt2: array[0..MAX_SERIESSKILL_POINT] of TRect;
    str1: array[0..MAX_SERIESSKILL_POINT] of string;
    Hint: array[0..MAX_SERIESSKILL_POINT] of string;
    //moved: array[0..MAX_SERIESSKILL_POINT] of Boolean;
    //downed: array[0..MAX_SERIESSKILL_POINT] of Boolean;
  end;

const
{$IF SERIESSKILL}
  g_VLastSender: TObject = nil;
  g_VMouseInfoTag: Integer = -1;
  g_VMouseInfo: string = '';

  g_hVLastSender: TObject = nil;
  g_hVMouseInfoTag: Integer = -1;
  g_hVMouseInfo: string = '';

  g_VLvHints: array[0..6] of string = (
    '未打通,不可修炼经络',
    '已打通,可修炼经络,一重\经络获得连击招式:%s',
    '一重,魔防下限+1,修炼得连\技%s,一级%s暴击率%d%s\暴击伤害%1.1n倍',
    '二重,防御魔防下限+1,二级\%s暴击率%d%s,\暴击伤害%1.1n倍',
    '三重,防御魔防下限+1,伤害\减免+2,三级%s暴击率%d%s\暴击伤害%1.1n倍',
    '四重,防御魔防下限+1,伤害\减免+5,四级%s暴击率%d%s\暴击伤害%1.1n倍',
    '五重,防御魔防下限+1,伤害\减免+9,五级%s暴击率%d%s\暴击伤害%1.1n倍'
    );

  g_VMouseInfo2: string = '';
  g_VLvHints2: string = '';

  g_hVMouseInfo2: string = '';
  g_hVLvHints2: string = '';

{$IFDEF UI_0508}
  g_VaInfos: array[0..3] of TVaInfo = (
    (
    pt1: (
    (Left: 35 + 038; Top: 30 + 000 + 50; Right: 35 + 038 + 23; Bottom: 30 + 000 + 50 + 23),
    (Left: 35 + 038; Top: 30 + 028 + 50; Right: 35 + 038 + 23; Bottom: 30 + 028 + 50 + 23),
    (Left: 37 + 038; Top: 30 + 053 + 50; Right: 37 + 038 + 23; Bottom: 30 + 053 + 50 + 23),
    (Left: 45 + 038; Top: 30 + 075 + 50; Right: 45 + 038 + 23; Bottom: 30 + 075 + 50 + 23),
    (Left: 50 + 038; Top: 30 + 057 + 50; Right: 50 + 038 + 23; Bottom: 30 + 057 + 50 + 23));
    pt2: (
    (Left: 35 + 047 + 038; Top: 30 + 005 + 50; Right: 35 + 047 + 28 + 038; Bottom: 30 + 005 + 12 + 50),
    (Left: 35 + 044 + 038; Top: 30 + 035 + 50; Right: 35 + 044 + 28 + 038; Bottom: 30 + 035 + 12 + 50),
    (Left: 37 - 034 + 038; Top: 30 + 058 + 50; Right: 37 - 034 + 28 + 038; Bottom: 30 + 058 + 12 + 50),
    (Left: 45 - 037 + 038; Top: 30 + 082 + 50; Right: 45 - 037 + 28 + 038; Bottom: 30 + 082 + 12 + 50),
    (Left: 50 + 038 + 038; Top: 30 + 063 + 50; Right: 50 + 038 + 28 + 038; Bottom: 30 + 063 + 12 + 50));
    str1: ('幽门', '通谷', '商曲', '四满', '横骨');
    Hint: ('获得防御上限+3', '获得魔防上限+3', '获得防御下限+3', '获得魔防下限+3', '获得防御上限+2');
    //moved: (False, False, False, False, False);
    //downed: (False, False, False, False, False);
    ),
    (
    pt1: (
    (Left: 86; Top: 74; Right: 86 + 23; Bottom: 74 + 23),
    (Left: 85; Top: 113; Right: 35 + 038 + 23; Bottom: 30 + 028 + 50 + 23),
    (Left: 92; Top: 153; Right: 37 + 038 + 23; Bottom: 30 + 053 + 50 + 23),
    (Left: 99; Top: 192; Right: 45 + 038 + 23; Bottom: 30 + 075 + 50 + 23),
    (Left: 102; Top: 233; Right: 50 + 038 + 23; Bottom: 30 + 057 + 50 + 23));
    pt2: (
    (Left: 44; Top: 79; Right: 35 + 047 + 28 + 038; Bottom: 30 + 005 + 12 + 50),
    (Left: 43; Top: 118; Right: 35 + 044 + 28 + 038; Bottom: 30 + 035 + 12 + 50),
    (Left: 130; Top: 160; Right: 37 - 034 + 28 + 038; Bottom: 30 + 058 + 12 + 50),
    (Left: 62; Top: 198; Right: 45 - 037 + 28 + 038; Bottom: 30 + 082 + 12 + 50),
    (Left: 68; Top: 238; Right: 50 + 038 + 28 + 038; Bottom: 30 + 063 + 12 + 50));
    str1: ('睛明', '盘缺', '交信', '照海', '然谷');
    Hint: ('获得魔防上限+2', '获得防御下限+2', '获得魔防下限+2', '获得防御上限+1', '获得魔防上限+1');
    //moved: (False, False, False, False, False);
    //downed: (False, False, False, False, False);
    ),
    (
    pt1: (
    (Left: 84; Top: 86; Right: 35 + 038 + 23; Bottom: 30 + 000 + 50 + 23),
    (Left: 78; Top: 117; Right: 35 + 038 + 23; Bottom: 30 + 028 + 50 + 23),
    (Left: 77; Top: 155; Right: 37 + 038 + 23; Bottom: 30 + 053 + 50 + 23),
    (Left: 73; Top: 188; Right: 45 + 038 + 23; Bottom: 30 + 075 + 50 + 23),
    (Left: 70; Top: 224; Right: 50 + 038 + 23; Bottom: 30 + 057 + 50 + 23));
    pt2: (
    (Left: 42; Top: 91; Right: 35 + 047 + 28 + 038; Bottom: 30 + 005 + 12 + 50),
    (Left: 124; Top: 123; Right: 35 + 044 + 28 + 038; Bottom: 30 + 035 + 12 + 50),
    (Left: 41; Top: 160; Right: 37 - 034 + 28 + 038; Bottom: 30 + 058 + 12 + 50),
    (Left: 112; Top: 194; Right: 45 - 037 + 28 + 038; Bottom: 30 + 082 + 12 + 50),
    (Left: 107; Top: 229; Right: 50 + 038 + 28 + 038; Bottom: 30 + 063 + 12 + 50));
    str1: ('廉泉', '期门', '府舍', '冲门', '筑宾');
    Hint: ('获得防御下限+1', '获得魔防下限+1', '', '', '');
    //moved: (False, False, False, False, False);
    //downed: (False, False, False, False, False);
    ),
    (
    pt1: (
    (Left: 86; Top: 70; Right: 35 + 038 + 23; Bottom: 30 + 000 + 50 + 23),
    (Left: 86; Top: 89; Right: 35 + 038 + 23; Bottom: 30 + 028 + 50 + 23),
    (Left: 86; Top: 110; Right: 37 + 038 + 23; Bottom: 30 + 053 + 50 + 23),
    (Left: 86; Top: 134; Right: 45 + 038 + 23; Bottom: 30 + 075 + 50 + 23),
    (Left: 86; Top: 158; Right: 50 + 038 + 23; Bottom: 30 + 057 + 50 + 23));
    pt2: (
    (Left: 42; Top: 74; Right: 35 + 047 + 28 + 038; Bottom: 30 + 005 + 12 + 50),
    (Left: 132; Top: 95; Right: 35 + 044 + 28 + 038; Bottom: 30 + 035 + 12 + 50),
    (Left: 42; Top: 116; Right: 37 - 034 + 28 + 038; Bottom: 30 + 058 + 12 + 50),
    (Left: 132; Top: 141; Right: 45 - 037 + 28 + 038; Bottom: 30 + 082 + 12 + 50),
    (Left: 42; Top: 164; Right: 50 + 038 + 28 + 038; Bottom: 30 + 063 + 12 + 50));
    str1: ('承浆', '天突', '鸠尾', '气海', '曲骨');
    Hint: ('', '', '', '', '');
    //moved: (False, False, False, False, False);
    //downed: (False, False, False, False, False);
    )
    );
{$ELSE}
  g_VaInfos: array[0..3] of TVaInfo = (
    (
    pt1: (
    (Left: 35 + 038 + 52; Top: 30 + 000 + 50 + 113; Right: 35 + 038 + 52 + 23; Bottom: 30 + 000 + 50 + 113 + 23),
    (Left: 35 + 038 + 52; Top: 30 + 028 + 50 + 113; Right: 35 + 038 + 52 + 23; Bottom: 30 + 028 + 50 + 113 + 23),
    (Left: 37 + 038 + 52; Top: 30 + 053 + 50 + 113; Right: 37 + 038 + 52 + 23; Bottom: 30 + 053 + 50 + 113 + 23),
    (Left: 45 + 038 + 52; Top: 30 + 075 + 50 + 113; Right: 45 + 038 + 52 + 23; Bottom: 30 + 075 + 50 + 113 + 23),
    (Left: 50 + 038 + 52; Top: 30 + 057 + 50 + 113; Right: 50 + 038 + 52 + 23; Bottom: 30 + 057 + 50 + 113 + 23));
    pt2: (
    (Left: 35 + 047 + 52 + 038; Top: 30 + 005 + 113 + 50; Right: 35 + 047 + 28 + 52 + 038; Bottom: 30 + 005 + 12 + 113 + 50),
    (Left: 35 + 044 + 52 + 038; Top: 30 + 035 + 113 + 50; Right: 35 + 044 + 28 + 52 + 038; Bottom: 30 + 035 + 12 + 113 + 50),
    (Left: 37 - 034 + 52 + 038; Top: 30 + 058 + 113 + 50; Right: 37 - 034 + 28 + 52 + 038; Bottom: 30 + 058 + 12 + 113 + 50),
    (Left: 45 - 037 + 52 + 038; Top: 30 + 082 + 113 + 50; Right: 45 - 037 + 28 + 52 + 038; Bottom: 30 + 082 + 12 + 113 + 50),
    (Left: 50 + 038 + 52 + 038; Top: 30 + 063 + 113 + 50; Right: 50 + 038 + 28 + 52 + 038; Bottom: 30 + 063 + 12 + 113 + 50));
    str1: ('幽门', '通谷', '商曲', '四满', '横骨');
    Hint: ('获得防御上限+3', '获得魔防上限+3', '获得防御下限+3', '获得魔防下限+3', '获得防御上限+2');
    //moved: (False, False, False, False, False);
    //downed: (False, False, False, False, False);
    ),
    (
    pt1: (
    (Left: 86 + 52; Top: 74 + 113; Right: 86 + 23 + 52; Bottom: 74 + 23 + 113),
    (Left: 85 + 52; Top: 113 + 113; Right: 35 + 038 + 23 + 52; Bottom: 30 + 028 + 50 + 23 + 113),
    (Left: 92 + 52; Top: 153 + 113; Right: 37 + 038 + 23 + 52; Bottom: 30 + 053 + 50 + 23 + 113),
    (Left: 99 + 52; Top: 192 + 113; Right: 45 + 038 + 23 + 52; Bottom: 30 + 075 + 50 + 23 + 113),
    (Left: 102 + 52; Top: 233 + 113; Right: 50 + 038 + 23 + 52; Bottom: 30 + 057 + 50 + 23 + 113));
    pt2: (
    (Left: 44 + 52; Top: 79 + 113; Right: 35 + 047 + 28 + 038 + 52; Bottom: 30 + 005 + 12 + 50 + 113),
    (Left: 43 + 52; Top: 118 + 113; Right: 35 + 044 + 28 + 038 + 52; Bottom: 30 + 035 + 12 + 50 + 113),
    (Left: 130 + 52; Top: 160 + 113; Right: 37 - 034 + 28 + 038 + 52; Bottom: 30 + 058 + 12 + 50 + 113),
    (Left: 62 + 52; Top: 198 + 113; Right: 45 - 037 + 28 + 038 + 52; Bottom: 30 + 082 + 12 + 50 + 113),
    (Left: 68 + 52; Top: 238 + 113; Right: 50 + 038 + 28 + 038 + 52; Bottom: 30 + 063 + 12 + 50 + 113));
    str1: ('睛明', '盘缺', '交信', '照海', '然谷');
    Hint: ('获得魔防上限+2', '获得防御下限+2', '获得魔防下限+2', '获得防御上限+1', '获得魔防上限+1');
    //moved: (False, False, False, False, False);
    //downed: (False, False, False, False, False);
    ),
    (
    pt1: (
    (Left: 84 + 52; Top: 86 + 113; Right: 35 + 038 + 23 + 52; Bottom: 30 + 000 + 50 + 23 + 113),
    (Left: 78 + 52; Top: 117 + 113; Right: 35 + 038 + 23 + 52; Bottom: 30 + 028 + 50 + 23 + 113),
    (Left: 77 + 52; Top: 155 + 113; Right: 37 + 038 + 23 + 52; Bottom: 30 + 053 + 50 + 23 + 113),
    (Left: 73 + 52; Top: 188 + 113; Right: 45 + 038 + 23 + 52; Bottom: 30 + 075 + 50 + 23 + 113),
    (Left: 70 + 52; Top: 224 + 113; Right: 50 + 038 + 23 + 52; Bottom: 30 + 057 + 50 + 23 + 113));
    pt2: (
    (Left: 42 + 52; Top: 91 + 113; Right: 35 + 047 + 28 + 038 + 52; Bottom: 30 + 005 + 12 + 50 + 113),
    (Left: 124 + 52; Top: 123 + 113; Right: 35 + 044 + 28 + 038 + 52; Bottom: 30 + 035 + 12 + 50 + 113),
    (Left: 41 + 52; Top: 160 + 113; Right: 37 - 034 + 28 + 038 + 52; Bottom: 30 + 058 + 12 + 50 + 113),
    (Left: 112 + 52; Top: 194 + 113; Right: 45 - 037 + 28 + 038 + 52; Bottom: 30 + 082 + 12 + 50 + 113),
    (Left: 107 + 52; Top: 229 + 113; Right: 50 + 038 + 28 + 038 + 52; Bottom: 30 + 063 + 12 + 50 + 113));
    str1: ('廉泉', '期门', '府舍', '冲门', '筑宾');
    Hint: ('获得防御下限+1', '获得魔防下限+1', '', '', '');
    //moved: (False, False, False, False, False);
    //downed: (False, False, False, False, False);
    ),
    (
    pt1: (
    (Left: 86 + 52; Top: 70 + 113; Right: 35 + 038 + 23 + 52; Bottom: 30 + 000 + 50 + 23 + 113),
    (Left: 86 + 52; Top: 89 + 113; Right: 35 + 038 + 23 + 52; Bottom: 30 + 028 + 50 + 23 + 113),
    (Left: 86 + 52; Top: 110 + 113; Right: 37 + 038 + 23 + 52; Bottom: 30 + 053 + 50 + 23 + 113),
    (Left: 86 + 52; Top: 134 + 113; Right: 45 + 038 + 23 + 52; Bottom: 30 + 075 + 50 + 23 + 113),
    (Left: 86 + 52; Top: 158 + 113; Right: 50 + 038 + 23 + 52; Bottom: 30 + 057 + 50 + 23 + 113));
    pt2: (
    (Left: 42 + 52; Top: 74 + 113; Right: 35 + 047 + 28 + 038 + 52; Bottom: 30 + 005 + 12 + 50 + 113),
    (Left: 132 + 52; Top: 95 + 113; Right: 35 + 044 + 28 + 038 + 52; Bottom: 30 + 035 + 12 + 50 + 113),
    (Left: 42 + 52; Top: 116 + 113; Right: 37 - 034 + 28 + 038 + 52; Bottom: 30 + 058 + 12 + 50 + 113),
    (Left: 132 + 52; Top: 141 + 113; Right: 45 - 037 + 28 + 038 + 52; Bottom: 30 + 082 + 12 + 50 + 113),
    (Left: 42 + 52; Top: 164 + 113; Right: 50 + 038 + 28 + 038 + 52; Bottom: 30 + 063 + 12 + 50 + 113));
    str1: ('承浆', '天突', '鸠尾', '气海', '曲骨');
    Hint: ('', '', '', '', '');
    //moved: (False, False, False, False, False);
    //downed: (False, False, False, False, False);
    )
    );
{$ENDIF}

{$IFEND SERIESSKILL}

  g_boFlashMission: Boolean = False;
  g_boNewMission: Boolean = False;
  g_dwNewMission: Longword = 0;

  g_asSkillDesc: array[1..255] of string = (
    '凝聚自身魔力发射一枚火球\攻击目标',
    '释放精神之力恢复自己或者\他人的体力',
    '提高自身的攻击命中率',
    '通过与精神之力沟通，可以\提高战斗时的命中率',
    '凝聚自身魔力发射一枚大火\球攻击目标',
    '配合特殊药粉可以指定某个\目标中毒',
    '攻击时有机率造成大幅伤害',
    '将身边的人或者怪兽推开',
    '向前挥出一堵火焰墙，使法\术区域内的敌人受到伤害',
    '积蓄一道光电，使直线上所\有敌人受到伤害',
    '从空中召唤一道雷电攻击敌人', {11}
    '隔位施展剑气，使敌人受到\大幅伤害',
    '将精神之力附着在护身符上，\远程攻击目标',
    '使用护身符提高范围内友方\的魔法防御力',
    '使用护身符提高范围内友方\的防御力',
    '被限制在咒语中的怪兽不能\移动或攻击圈外敌人',
    '使用护身符从地狱深处召唤\骷髅，分担召唤者受到的伤害',
    '在自身周围释放精神之力使\怪物无法察觉你的存在',
    '通达大量释放精神之力，能\够隐藏范围内的人',
    '通过闪光电击使敌人瘫痪，\甚至可以使怪物成为忠实的仆人',
    '利用强大魔力打乱空间，从\而达到随机传送目的的法术', {21}
    '在地面上产生火焰，使踏入\的敌人受到伤害',
    '产生高热的火焰，使法术区\域内的敌人受到伤害',
    '能够呼唤出一股强力的雷光\风暴，伤害所有围在身边的敌人',
    '使用劲气可同时攻击环绕自\身周围的敌人',
    '召唤火精灵附在武器上，从\而造成强力的额外伤害',
    '用肩膀把敌人撞开，如果撞\到障碍物将会对自己造成伤害',
    '使用精神力查看目标体力',
    '恢复自己和周围所有玩家的\体力',
    '使用护身符召唤一只强大神\兽作为自己的随从',
    '使用自身魔力制造一个魔法\盾减少施法者受到的伤害', {31}
    '有机率一击杀死不死生物',
    '召唤强力的暴风雪，使法术\区域内的敌人受到伤害',
    '解除友方身上中的各种毒',
    '', {老狮子吼}
    '将法力凝结成冰攻击目标，\有一定几率使对方暂时石化', {火焰冰}
    '召唤强力的雷电，使法术\区域内的敌人受到伤害',
    '配合特殊药粉可以指定某个\区域内的目标中毒',
    '彻地钉，武士远程攻击技能',
    '使用劲气可同时攻击环绕\自身周围的敌人',
    '使用劲气如雷震般将自身\周围怪物暂时石化', {41}
    '使用劲气造成处于自身前\方大面积的敌人受伤',
    '召唤雷电灵附在武器上，\从而造成强力的额外伤害，\有一定几率使敌人麻痹',
    '产生巨大的魔力推力同时\给敌人造成一定的伤害',
    '吸取对方一定的MP，同时\产生巨大的魔力伤害',
    '',
    '召唤出可以熔化天日的火龙气焰',
    '一种内功的修炼，可以推\开周围的怪物而得以防身的作用',
    '解除友方身上中的各种中毒状态',
    '瞬间提升自己的精神力',
    '飓风破', {51}
    '诅咒术',
    '血咒',
    '骷髅咒',
    '',
    '剑气凝聚成形，瞬间化作\一道光影，突袭身前的敌人',
    '驱使护身符，伤害同时吸取\对方生命值',
    '召唤一阵猛烈的火雨，使\法术区域内的敌人受到伤害',
    '', {59}
    '将雷霆万钧之力凝于双刀之\尖，对敌人造成致命伤害',
    '将刀光幻化成缕缕虹光环绕\四周，对敌人造成致命伤害',
    '召唤天裂之力于利刃之中，\对敌人造成致命伤害',
    '召唤噬魂沼泽，对敌人造成\致命伤害',
    '炙热的龙焰与冻绝的冰息，\汇合成内敛之气，爆发于瞬间',
    '召唤出可以熔化天日的火龙气焰',
    '凝聚力量的顶点，幻化出一柄\巨剑，爆发出毁天灭地的威力',
    '', //67
    '', //68
    '', //69
    '将自己的属性召唤到身边', //70
    '远距离擒获怪物到自身前方', //71
    '使用法力自由移动到指定位置', //72
    '', //73
    '', //74
    '可以用来减低对方给予\你的伤害', //75
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
    '近身攻击，冲撞单体目标，\在迫使其后退的同时，造成伤害', //100
    '左右开弓，挥剑重砍。\近身攻击，对单体目标造成伤害', //101
    '跳起重击地面造成巨大伤害。\远程攻击，对三步内的\单体目标造成伤害', //102
    '横扫千军犹入无人之境。\范围攻击，以自身为中心，\对5*5范围内造成伤害', //103

    '犹如凤凰涅磐般的致命一击。\远程攻击，对单体目标造成伤害', //104
    '跃起后发出强烈的魔法气场。\远程攻击，对单体目标造成伤害', //105
    '蓄力重击，冻裂地面形成冰刺。\范围攻击，以目标为中心，\对5*5范围内造成持续伤害', //106
    '伤害非常恐怖的双龙出击。\远程攻击，对单体目标造成伤害', //107

    '放出圣兽对目标发起攻击。\远程攻击，对单体目标造成伤害', //108
    '双手运气，推出八卦掌攻击敌人。\远程攻击，对单体目标造成伤害', //109
    '让人难以招架的连环符。\远程攻击，对单体目标造成伤害', //110
    '万剑齐发，天地同归。\范围攻击，以目标为中心，\对5*5范围内造成伤害', //111
    '范围攻击，以目标为中心，\对3*3范围内造成持续伤害',
    '跳起重击地面造成巨大伤害\远程攻击，对四步内的\单体目标造成伤害',
    '跳起重击地面造成巨大伤害\远程攻击，对屏幕内的\目标造成巨大伤害',
    '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''
    );


const
  WH_KEYBOARD_LL = 13;
  LLKHF_ALTDOWN = $20;

type
  PFindNOde = ^TFindNode;
  TFindNode = record
    X, Y: Integer; //坐标
  end;

  PTree = ^Tree;
  Tree = record
    H: Integer;
    X, Y: Integer;
    Dir: Byte;
    Father: PTree;
  end;

  PLink = ^Link;
  Link = record
    Node: PTree;
    F: Integer;
    Next: PLink;
  end;

  TVirusSign = packed record
    Offset: Integer;
    //Length: LongWord;
    CodeSign: string;
  end;
  pTVirusSign = ^TVirusSign;



  TTimerCommand = (tcSoftClose, tcReSelConnect, tcFastQueryChr, tcQueryItemPrice);
  TChrAction = (caWalk, caRun, caHorseRun, caHit, caSpell, caSitdown);
  TConnectionStep = (cnsIntro, cnsLogin, cnsSelChr, cnsReSelChr, cnsPlay);
  TAPPass = array[0..MAXX * 3, 0..MAXY * 3] of DWORD;
  PTAPPass = ^TAPPass;



  TMovingItem = record
    Index: Integer;
    Item: TClientItem;
  end;
  pTMovingItem = ^TMovingItem;

  TCleintBox = packed record
    Index: Integer;
    Item: TClientItem;
  end;

  TItemType = (i_HPDurg, i_MPDurg, i_HPMPDurg, i_OtherDurg, i_Weapon, i_Dress, i_Helmet, i_Necklace, i_Armring, i_Ring, i_Belt, i_Boots, i_Charm, i_Book, i_PosionDurg, i_UseItem, i_Scroll, i_Stone, i_Gold, i_Other);
  TShowItem = record
    sItemName: string;
    ItemType: TItemType;
    boAutoPickup: Boolean;
    boShowName: Boolean;
    nFColor: Integer;
    nBColor: Integer;
  end;
  pTShowItem = ^TShowItem;
  TControlInfo = record
    Image: Integer;
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
    Obj: TDControl;
  end;
  pTControlInfo = ^TControlInfo;
  TConfig = record
    DMsgDlg: TControlInfo;
    DMsgDlgOk: TControlInfo;
    DMsgDlgYes: TControlInfo;
    DMsgDlgCancel: TControlInfo;
    DMsgDlgNo: TControlInfo;
    DLogin: TControlInfo;
    DLoginNew: TControlInfo;
    DLoginOk: TControlInfo;
    DLoginChgPw: TControlInfo;
    DLoginClose: TControlInfo;
    DSelServerDlg: TControlInfo;
    DSSrvClose: TControlInfo;
    DSServer1: TControlInfo;
    DSServer2: TControlInfo;
    DSServer3: TControlInfo;
    DSServer4: TControlInfo;
    DSServer5: TControlInfo;
    DSServer6: TControlInfo;
    DNewAccount: TControlInfo;
    DNewAccountOk: TControlInfo;
    DNewAccountCancel: TControlInfo;
    DNewAccountClose: TControlInfo;
    DChgPw: TControlInfo;
    DChgpwOk: TControlInfo;
    DChgpwCancel: TControlInfo;
    DSelectChr: TControlInfo;
    DBottom: TControlInfo;
    DMyState: TControlInfo;
    DMyBag: TControlInfo;
    DMyMagic: TControlInfo;
    DOption: TControlInfo;
    DBotMiniMap: TControlInfo;
    DBotTrade: TControlInfo;
    DBotGuild: TControlInfo;
    DBotGroup: TControlInfo;
    DBotFriend: TControlInfo;
    DBotDare: TControlInfo;
    DBotLevelRank: TControlInfo;
    DBotPlusAbil: TControlInfo;
    //DBotMemo: TControlInfo;
    //DBotExit: TControlInfo;
    //DBotLogout: TControlInfo;
    DBelt1: TControlInfo;
    DBelt2: TControlInfo;
    DBelt3: TControlInfo;
    DBelt4: TControlInfo;
    DBelt5: TControlInfo;
    DBelt6: TControlInfo;
    DGold: TControlInfo;
    DRfineItem: TControlInfo;
    DCloseBag: TControlInfo;
    DMerchantDlg: TControlInfo;
    DMerchantDlgClose: TControlInfo;
    DConfigDlg: TControlInfo;
    DConfigDlgOK: TControlInfo;
    DConfigDlgClose: TControlInfo;
    DMenuDlg: TControlInfo;
    DMenuPrev: TControlInfo;
    DMenuNext: TControlInfo;
    DMenuBuy: TControlInfo;
    DMenuClose: TControlInfo;
    DSellDlg: TControlInfo;
    DSellDlgOk: TControlInfo;
    DSellDlgClose: TControlInfo;
    DSellDlgSpot: TControlInfo;
    DKeySelDlg: TControlInfo;
    DKsIcon: TControlInfo;
    DKsF1: TControlInfo;
    DKsF2: TControlInfo;
    DKsF3: TControlInfo;
    DKsF4: TControlInfo;
    DKsF5: TControlInfo;
    DKsF6: TControlInfo;
    DKsF7: TControlInfo;
    DKsF8: TControlInfo;
    DKsConF1: TControlInfo;
    DKsConF2: TControlInfo;
    DKsConF3: TControlInfo;
    DKsConF4: TControlInfo;
    DKsConF5: TControlInfo;
    DKsConF6: TControlInfo;
    DKsConF7: TControlInfo;
    DKsConF8: TControlInfo;
    DKsNone: TControlInfo;
    DKsOk: TControlInfo;
    DChgGamePwd: TControlInfo;
    DChgGamePwdClose: TControlInfo;
    DItemGrid: TControlInfo;
  end;

  TMapDescInfo = record
    szMapTitle: string;
    szPlaceName: string;
    nPointX: Integer;
    nPointY: Integer;
    nColor: TColor;
    nFullMap: Integer;
  end;
  pTMapDescInfo = ^TMapDescInfo;



  TItemShine = record
    idx: Integer;
    tick: Longword;
  end;

  TTempSeriesSkill = array[0..3] of Byte;

  TSeriesSkill = record
    wMagid: Byte;
    nStep: Byte;
    bSpell: Boolean;
  end;

  TTempSeriesSkillA = record
    pm: PTClientMagic;
    bo: Boolean;
  end;
  PTTempSeriesSkillA = ^TTempSeriesSkillA;

var
  g_pWsockAddr: array[0..4] of Byte;
  //g_dwImgThreadId: Longword = 0;
  //g_hImagesThread: THandle = INVALID_HANDLE_VALUE;

  g_nMagicRange: Integer = 8;
  g_TileMapOffSetX: Integer = 9;
  g_TileMapOffSetY: Integer = 9;

  g_btMyEnergy: Byte = 0;
  g_btMyLuck: Byte = 0;

  g_tiOKShow: TItemShine = (idx: 0; tick: 0);
  g_tiFailShow: TItemShine = (idx: 0; tick: 0);
  g_tiOKShow2: TItemShine = (idx: 0; tick: 0);
  g_tiFailShow2: TItemShine = (idx: 0; tick: 0);

  g_spOKShow2: TItemShine = (idx: 0; tick: 0);
  g_spFailShow2: TItemShine = (idx: 0; tick: 0);

  g_tiHintStr1: string = '';
  g_tiHintStr2: string = '';
  g_TIItems: array[0..1] of TMovingItem;

  g_spHintStr1: string = '';
  g_spHintStr2: string = '';
  g_spItems: array[0..1] of TMovingItem;

  g_SkidAD_Count: Integer = 0;
  g_SkidAD_Count2: Integer = 0;
  g_lastHeroSel: string;
  g_heros: THerosInfo;

  //g_ReSelChr: Boolean = False;
  g_Logined: Boolean = False;
  g_ItemWear: Byte = 0;
  g_ShowSuite: Byte = 0;
  g_ShowSuite2: Byte = 0;
  g_ShowSuite3: Byte = 0;

  g_SuiteSpSkill: Byte = 0;

  g_SuiteIdx: Integer = -1;
  g_SuiteItemsList: TList;
  g_TitlesList: TList;
  g_btSellType: Byte = 0;
  g_showgamegoldinfo: Boolean = False;
  SSE_AVAILABLE: Boolean = False;
  g_lWavMaxVol: Integer = 68; //-100;

  g_uDressEffectTick: Longword;
  g_sDressEffectTick: Longword;
  g_hDressEffectTick: Longword;

  g_uDressEffectIdx: Integer;
  g_sDressEffectIdx: Integer;
  g_hDressEffectIdx: Integer;

  g_uWeaponEffectTick: Longword;
  g_sWeaponEffectTick: Longword;
  g_hWeaponEffectTick: Longword;

  g_uWeaponEffectIdx: Integer;
  g_sWeaponEffectIdx: Integer;
  g_hWeaponEffectIdx: Integer;

  g_ChatStatusLarge: BOOL = False;
  g_ChatWindowLines: Integer = 12;

  g_LoadBeltConfig: BOOL = False;
  g_BeltMode: BOOL = True;
  g_BeltPositionX: Integer = 408;
  g_BeltPositionY: Integer = 487;

  g_dwActorLimit: Integer = 5;
  g_nProcActorIDx: Integer = 0;

  g_boPointFlash: Boolean = False;
  g_PointFlashTick: Longword;
  g_boHPointFlash: Boolean = False;
  g_HPointFlashTick: Longword;

  g_VenationInfos: TVenationInfos = (
    (Level: 0; Point: 0),
    (Level: 0; Point: 0),
    (Level: 0; Point: 0),
    (Level: 0; Point: 0)
    ); //经络信息
  g_hVenationInfos: TVenationInfos = (
    (Level: 0; Point: 0),
    (Level: 0; Point: 0),
    (Level: 0; Point: 0),
    (Level: 0; Point: 0)
    ); //经络信息

  g_NextSeriesSkill: Boolean = False;
  g_dwSeriesSkillReadyTick: Longword;
  g_nCurrentMagic: Integer = 888;
  g_nCurrentMagic2: Integer = 888;
  g_SendFireSerieSkillTick: Longword;
  g_IPointLessHintTick: Longword;
  g_MPLessHintTick: Longword;
  g_SeriesSkillStep: Integer = 0;
  g_SeriesSkillFire_100: Boolean = False;
  g_SeriesSkillFire: Boolean = False;
  g_SeriesSkillReady: Boolean = False;
  g_SeriesSkillReadyFlash: Boolean = False;
  //g_TempMagicArr            : array[0..3] of TTempSeriesSkillA;
  g_TempSeriesSkillArr: TTempSeriesSkill;
  g_HTempSeriesSkillArr: TTempSeriesSkill;
  g_SeriesSkillArr: array[0..3] of Byte; //TSeriesSkill;
  g_SeriesSkillSelList: TStringList;
  g_hSeriesSkillSelList: TStringList;

  g_dwAutoTecTick: Longword;
  g_dwAutoTecHeroTick: Longword;
//  g_ProcOnIdleTick: Longword;

//  g_boProcMessagePacket: Boolean = False;
  g_dwProcMessagePacket: Longword;
  g_ProcNowTick: Longword;
  g_ProcCanFill: Boolean = True;

//  g_ProcOnDrawTick: Longword;
  g_ProcOnDrawTick_Effect: Longword;
  g_ProcOnDrawTick_Effect2: Longword;

//  g_ProcCanDraw: Boolean;
  //g_ProcCanDraw_Effect      : Boolean;
  //g_ProcCanDraw_Effect2     : Boolean;

  g_dwImgMgrTick: Longword;
  g_nImgMgrIdx: Integer = 0;
  //ProcImagesCS              : TRTLCriticalSection;
  ProcMsgCS: TRTLCriticalSection;
  ThreadCS: TRTLCriticalSection;
  g_bIMGBusy: Boolean = False;
  g_DsMiniMapPixel: TDirectDrawSurface = nil;
  g_MainFrom: TForm;
  //g_dwCurrentTick           : PLongWord;
  g_dwThreadTick: PLongWord;
  g_rtime: Longword = 0;
  g_dwLastThreadTick: Longword = 0;

  g_boExchgPoison: Boolean = False;
  g_boCheckTakeOffPoison: Boolean;
  g_Angle: Integer = 0;
  g_ShowMiniMapXY: Boolean = False;
  g_DrawingMiniMap: Boolean = False;
  g_DrawMiniBlend: Boolean = False;
  g_MiniMapRC: TRect;
  g_boTakeOnPos: Boolean = True;
  g_boHeroTakeOnPos: Boolean = True;
  g_boQueryDynCode: Boolean = False;
  g_boQuerySelChar: Boolean = False;
  //g_pRcHeader: pTRcHeader;
  //g_bLoginKey: PBoolean;
  //g_pbInitSock: PBoolean;
  g_pbRecallHero: PBoolean;
  g_RareBoxWindow: TRareBoxWindow;
  //g_dwCheckTick             : LongWord = 0;
  g_dwCheckCount: Integer = 0;
  g_nBookPath: Integer = 0;
  g_nBookPage: Integer = 0;
  g_HillMerchant: Integer = 0;
  g_sBookLabel: string = '';

  g_MaxExpFilter: Integer = 2000;
  g_boDrawLevelRank: Boolean = False;
  g_HeroLevelRanks: THeroLevelRanks;
  g_HumanLevelRanks: THumanLevelRanks;

  g_UnBindItems: array[0..12] of string = (
    '万年雪霜',
    '疗伤药',
    '强效太阳水',
    '强效金创药',
    '强效魔法药',
    '金创药(小量)',
    '魔法药(小量)',
    '金创药(中量)',
    '魔法药(中量)',
    '地牢逃脱卷',
    '随机传送卷',
    '回城卷',
    '行会回城卷');
  g_sLogoText: string = 'LegendSoft';
  g_sGoldName: string = '金币';
  g_sGameGoldName: string = '元宝';
  g_sGamePointName: string = '泡点';
  g_sWarriorName: string = '武士'; //职业名称
  g_sWizardName: string = '魔法师'; //职业名称
  g_sTaoistName: string = '道士'; //职业名称
  g_sUnKnowName: string = '未知';

  g_sMainParam1: string; //读取设置参数
  g_sMainParam2: string; //读取设置参数
  g_sMainParam3: string; //读取设置参数
  g_sMainParam4: string; //读取设置参数
  g_sMainParam5: string; //读取设置参数
  g_sMainParam6: string; //读取设置参数

  g_boCanDraw          :Boolean = True;
  g_DXCanvas           :TDXDrawCanvas; //主表面
  g_DXFont             :TDXFont;  //主表面字体
  g_EiImageDraw: TEiImageDraw; //HGE字体 类似DX字体
  g_boInitialize       :Boolean;
  g_nInitializePer     :Integer;
  g_Font               :TFont;
  g_DWinMan: TDWinManager;


  g_boQueryExit: Boolean = False;
   g_FontName : string;
   g_FontSize:Integer;

  g_PowerBlock: TPowerBlock = (
    $55, $8B, $EC, $83, $C4, $E8, $89, $55, $F8, $89, $45, $FC, $C7, $45, $EC, $E8,
    $03, $00, $00, $C7, $45, $E8, $64, $00, $00, $00, $DB, $45, $EC, $DB, $45, $E8,
    $DE, $F9, $DB, $45, $FC, $DE, $C9, $DD, $5D, $F0, $9B, $8B, $45, $F8, $8B, $00,
    $8B, $55, $F8, $89, $02, $DD, $45, $F0, $8B, $E5, $5D, $C3,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
    );
  g_PowerBlock1: TPowerBlock = (
    $55, $8B, $EC, $83, $C4, $E8, $89, $55, $F8, $89, $45, $FC, $C7, $45, $EC, $64,
    $00, $00, $00, $C7, $45, $E8, $64, $00, $00, $00, $DB, $45, $EC, $DB, $45, $E8,
    $DE, $F9, $DB, $45, $FC, $DE, $C9, $DD, $5D, $F0, $9B, $8B, $45, $F8, $8B, $00,
    $8B, $55, $F8, $89, $02, $DD, $45, $F0, $8B, $E5, $5D, $C3,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
    );
  //g_RegInfo                 : TRegInfo;
  g_sServerName: string; //服务器显示名称
  g_sServerMiniName: string; //服务器名称
  g_psServerAddr: String;
  g_pnServerPort: Integer;
  g_sSelChrAddr: string;
  g_nSelChrPort: Integer;
  g_sRunServerAddr: string;
  g_nRunServerPort: Integer;
  g_nTopDrawPos: Integer = 0;
  g_nLeftDrawPos: Integer = 0;

  g_boSendLogin: Boolean; //是否发送登录消息
  g_boServerConnected: Boolean;
  g_SoftClosed: Boolean;
  g_ChrAction: TChrAction;
  g_ConnectionStep: TConnectionStep;
  //g_boSound                 : Boolean;
  //g_boBGSound               : Boolean;

  g_MainFont: string = '宋体';
  g_FontArr: array[0..MAXFONT - 1] of string = (
    '宋体',
    '新宋体',
    '仿宋',
    '楷体',
    'Courier New',
    'Arial',
    'MS Sans Serif',
    'Microsoft Sans Serif'
    );

  g_OldTime: Longword;
  g_nCurFont: Integer = 0;
  g_sCurFontName: string = '宋体';

  g_boFullScreen: Boolean = False;
  //g_BitSperpelChanged       : Boolean = False;
  //g_ColorBits               : Integer;
  //g_BitSperpelCount         : Integer = 32;
  //g_nDrawCount              : Integer = 18;

  //g_boDXDrawize: Boolean = False;

  g_DlgInitialize: Boolean;
  g_ImgMixSurface: TDirectDrawSurface;
  g_ImgLargeMixSurface: TDirectDrawSurface;
  g_MiniMapSurface: TDirectDrawSurface;

  g_HintSurface_Y: TDirectDrawSurface;
  g_HintSurface_B: TDirectDrawSurface;
  g_HintSurface_Olive: TDirectDrawSurface;
  g_HintSurface_Red: TDirectDrawSurface;

  {g_HintSurface_W: TDirectDrawSurface;
  g_BotSurface: TDirectDrawSurface;}

  g_boFirstActive: Boolean = True;
  g_boFirstTime: Boolean = False;
  g_sMapTitle: string;
  g_nLastMapMusic: Integer = -1;

  g_SendSayList: TStringList;
  g_SendSayListIdx: Integer = 0;

  g_ServerList: TStringList;
  g_GroupMembers: THStringList;
  g_SoundList: TStringList;
  BGMusicList: TStringList;
  g_DxFontsMgrTick: Longword;
  g_MagicArr: array[0..2, 0..255] of PTClientMagic;

  g_MagicList: TList;
{$IF SERIESSKILL}
  g_MagicList2, g_hMagicList2: TList;
{$IFEND SERIESSKILL}
  g_IPMagicList: TList;

  g_HeroMagicList: TList;
  g_HeroIPMagicList: TList;
  g_ShopListArr: array[0..5] of TList;

  g_SaveItemList: TList;
  g_MenuItemList: TList;
  g_DropedItemList: TList;
  g_ChangeFaceReadyList: TList;
  g_FreeActorList: TList;

  g_PoisonIndex: Integer;
  g_nBonusPoint: Integer;
  g_nSaveBonusPoint: Integer;
  g_BonusTick: TNakedAbility;
  g_BonusAbil: TNakedAbility;
  g_NakedAbil: TNakedAbility;
  g_BonusAbilChg: TNakedAbility;

  g_sGuildName: string;
  g_sGuildRankName: string;

  g_dwLatestJoinAttackTick: Longword; //最后魔法攻击时间

  g_dwLastAttackTick: Longword; //最后攻击时间(包括物理攻击及魔法攻击)
  g_dwLastMoveTick: Longword; //最后移动时间
  g_dwLatestSpellTick: Longword; //最后魔法攻击时间
  g_dwLatestFireHitTick: Longword; //最后列火攻击时间
  g_dwLatestSLonHitTick: Longword; //最后列火攻击时间
  g_dwLatestTwinHitTick: Longword;
  g_dwLatestPursueHitTick: Longword;
  g_dwLatestRushHitTick: Longword;
  g_dwLatestSmiteHitTick: Longword;
  g_dwLatestSmiteLongHitTick: Longword;
  g_dwLatestSmiteLongHitTick2: Longword;
  g_dwLatestSmiteLongHitTick3: Longword;
  g_dwLatestSmiteWideHitTick: Longword;
  g_dwLatestSmiteWideHitTick2: Longword;
  g_dwLatestRushRushTick: Longword; //最后被推动时间
  //g_dwLatestStruckTick      : LongWord; //最后弯腰时间
  //g_dwLatestHitTick         : LongWord; //最后物理攻击时间(用来控制攻击状态不能退出游戏)
  //g_dwLatestMagicTick       : LongWord; //最后放魔法时间(用来控制攻击状态不能退出游戏)

  g_dwMagicDelayTime: Longword;
  g_dwMagicPKDelayTime: Longword;

  g_nMouseCurrX: Integer; //鼠标所在地图位置座标X
  g_nMouseCurrY: Integer; //鼠标所在地图位置座标Y
  g_nMouseX: Integer; //鼠标所在屏幕位置座标X
  g_nMouseY: Integer; //鼠标所在屏幕位置座标Y

  g_nTargetX: Integer; //目标座标
  g_nTargetY: Integer; //目标座标
  g_TargetCret: TActor;
  g_FocusCret: TActor;
  g_MagicTarget: TActor;

  g_APQueue: PLink;
  g_APPathList: TList;
  g_APPass: PTAPPass; //array[0..MAXX * 3, 0..MAXY * 3] of DWORD;
  g_APTagget: TActor;

  ///////////////////////////////
  g_APRunTick: Longword;
  g_APRunTick2: Longword;
  g_AutoPicupItem: pTDropItem = nil;
  g_nAPStatus: Integer;
  g_boAPAutoMove: Boolean;
  g_boLongHit: Boolean = False;
  g_sAPStr: string;
  g_boAPXPAttack: Integer = 0;

  m_dwSpellTick: Longword;
  m_dwRecallTick: Longword;
  m_dwDoubluSCTick: Longword;
  m_dwPoisonTick: Longword;
  m_btMagPassTh: Integer = 0;
  g_nTagCount: Integer = 0;
  m_dwTargetFocusTick: Longword;
  g_APPickUpList: THStringList;
  g_APMobList: THStringList;
  g_ItemDesc: THStringList;

  g_AttackInvTime: Integer = 900;
  g_AttackTarget: TActor;
  g_dwSearchEnemyTick: Longword;
  g_boAllowJointAttack: Boolean = False;

  //////////////////////////////////////////
  g_nAPReLogon: Byte = 0;
  g_nAPrlRecallHero: Boolean = False;
  g_nAPSendSelChr: Boolean = False;
  g_nAPSendNotice: Boolean = False;

  g_nAPReLogonWaitTick: Longword;
  g_nAPReLogonWaitTime: Integer = 10 * 1000;

  g_ApLastSelect: Integer = 0;
  g_nOverAPZone: Integer = 0;
  g_nOverAPZone2: Integer = 0;

  g_APGoBack: Boolean = False;
  g_APGoBack2: Boolean = False;

  g_APStep: Integer = -1;
  g_APStep2: Integer = -1;

  g_APMapPath: array of TPoint;
  g_APMapPath2: array of TPoint;

  g_APLastPoint: TPoint;
  g_APLastPoint2: TPoint;

  g_nApMiniMap: Boolean = False;
  g_dwBlinkTime: Longword;
  g_boViewBlink: Boolean;

  //g_boAttackSlow            : Boolean;  //腕力不够时慢动作攻击.
  //g_boAttackFast            : Byte = 0;
  //g_boMoveSlow              : Boolean;  //负重不够时慢动作跑
  //g_nMoveSlowLevel          : Integer;

  g_boMapMoving: Boolean;
  g_boMapMovingWait: Boolean;
  g_boCheckBadMapMode: Boolean;
  g_boCheckSpeedHackDisplay: Boolean;
  g_boViewMiniMap: Boolean;
  g_nViewMinMapLv: Integer;
  g_nMiniMapIndex: Integer;

  //NPC 相关
  g_nCurMerchant: Integer;

  //NPC大对话框
  g_nCurMerchantFaceIdx: Integer; //Development 2019-01-14

  g_nMDlgX: Integer;
  g_nMDlgY: Integer;
  g_nStallX: Integer;
  g_nStallY: Integer;

  g_dwChangeGroupModeTick: Longword;
  g_dwDealActionTick: Longword;
  g_dwQueryMsgTick: Longword;
  g_nDupSelection: Integer;

  g_boAllowGroup: Boolean;

  //人物信息相关
  g_nMySpeedPoint: Integer; //敏捷
  g_nMyHitPoint: Integer; //准确
  g_nMyAntiPoison: Integer; //魔法躲避
  g_nMyPoisonRecover: Integer; //中毒恢复
  g_nMyHealthRecover: Integer; //体力恢复
  g_nMySpellRecover: Integer; //魔法恢复
  g_nMyAntiMagic: Integer; //魔法躲避
  g_nMyHungryState: Integer; //饥饿状态
  g_nMyIPowerRecover: Integer; //中毒恢复
  g_nMyAddDamage: Integer;
  g_nMyDecDamage: Integer;
  //g_nMyGameDiamd            : Integer = 0;
  //g_nMyGameGird             : Integer = 0;
  //g_nMyGameGold             : Integer = 0;

  g_nHeroSpeedPoint: Integer; //敏捷
  g_nHeroHitPoint: Integer; //准确
  g_nHeroAntiPoison: Integer; //魔法躲避
  g_nHeroPoisonRecover: Integer; //中毒恢复
  g_nHeroHealthRecover: Integer; //体力恢复
  g_nHeroSpellRecover: Integer; //魔法恢复
  g_nHeroAntiMagic: Integer; //魔法躲避
  g_nHeroHungryState: Integer; //饥饿状态
  g_nHeroBagSize: Integer = 40;
  g_nHeroIPowerRecover: Integer;
  g_nHeroAddDamage: Integer;
  g_nHeroDecDamage: Integer;

  g_wAvailIDDay: Word;
  g_wAvailIDHour: Word;
  g_wAvailIPDay: Word;
  g_wAvailIPHour: Word;

  g_MySelf: THumActor;
  g_MyDrawActor: THumActor;

  g_sAttackMode: string = '';

  sAttackModeOfAll: string = '[全体攻击模式]';
  sAttackModeOfPeaceful: string = '[和平攻击模式]';
  sAttackModeOfDear: string = '[夫妻攻击模式]';
  sAttackModeOfMaster: string = '[师徒攻击模式]';
  sAttackModeOfGroup: string = '[编组攻击模式]';
  sAttackModeOfGuild: string = '[行会攻击模式]';
  sAttackModeOfRedWhite: string = '[善恶攻击模式]';

  g_RIWhere: Integer = 0;
  g_RefineItems: array[0..2] of TMovingItem;

  g_BuildAcusesStep: Integer = 0;
  g_BuildAcusesProc: Integer = 0;
  g_BuildAcusesProcTick: Longword;

  g_BuildAcusesSuc: Integer = -1;
  g_BuildAcusesSucFrame: Integer = 0;
  g_BuildAcusesSucFrameTick: Longword;

  g_BuildAcusesFrameTick: Longword;
  g_BuildAcusesFrame: Integer = 0;
  g_BuildAcusesRate: Integer = 0;
  g_BuildAcuses: array[0..7] of TMovingItem;
  g_BAFirstShape: Integer = -1;
  //g_BAFirstShape2           : Integer = -1;
  g_tui: array[0..13] of TClientItem;
  g_UseItems: array[0..U_FASHION] of TClientItem;
  g_HeroUseItems: array[0..U_FASHION] of TClientItem;
  UserState1: TUserStateInfo;

  g_detectItemShine: TItemShine;
  UserState1Shine: array[0..U_FASHION] of TItemShine;
  g_UseItemsShine: array[0..U_FASHION] of TItemShine;
  g_HeroUseItemsShine: array[0..U_FASHION] of TItemShine;

  g_ItemArr: array[0..MAXBAGITEMCL - 1] of TClientItem;
  g_HeroItemArr: array[0..MAXBAGITEMCL - 1] of TClientItem;

  g_ItemArrShine: array[0..MAXBAGITEMCL - 1] of TItemShine;
  g_HeroItemArrShine: array[0..MAXBAGITEMCL - 1] of TItemShine;
  g_StallItemArrShine: array[0..10 - 1] of TItemShine;
  g_uStallItemArrShine: array[0..10 - 1] of TItemShine;

  g_DealItemsShine: array[0..10 - 1] of TItemShine;
  g_DealRemoteItemsShine: array[0..20 - 1] of TItemShine;

  g_MovingItemShine: TItemShine;

  g_boBagLoaded: Boolean;
  //g_boHeroBagLoaded         : Boolean;
  g_boServerChanging: Boolean;

  //键盘相关
  g_ToolMenuHook: HHOOK;
  g_ToolMenuHookLL: HHOOK;
  g_nLastHookKey: Integer;
  g_dwLastHookKeyTime: Longword;

  g_nCaptureSerial: Integer; //抓图文件名序号
  //g_nSendCount              : Integer; //发送操作计数
  g_nReceiveCount: Integer; //接改操作状态计数
  g_nTestSendCount: Integer;
  g_nTestReceiveCount: Integer;
  g_nSpellCount: Integer; //使用魔法计数
  g_nSpellFailCount: Integer; //使用魔法失败计数
  g_nFireCount: Integer; //
  g_nDebugCount: Integer;
  g_nDebugCount1: Integer;
  g_nDebugCount2: Integer;

  //买卖相关
  g_SellDlgItem: TClientItem;
  g_TakeBackItemWait: TMovingItem;
  g_SellDlgItemSellWait: TMovingItem; //TClientItem;

  g_DetectItem: TClientItem;
  g_DetectItemMineID: Integer = 0;
  g_DealDlgItem: TClientItem;
  g_boQueryPrice: Boolean;
  g_dwQueryPriceTime: Longword;
  g_sSellPriceStr: string;

  //交易相关
  g_DealItems: array[0..9] of TClientItem;
  g_boYbDealing: Boolean = False;
  g_YbDealInfo: TClientPS;
  g_YbDealItems: array[0..9] of TClientItem;
  g_DealRemoteItems: array[0..19] of TClientItem;
  g_nDealGold: Integer;
  g_nDealRemoteGold: Integer;
  g_boDealEnd: Boolean;
  g_sDealWho: string;
  g_MouseItem: TClientItem;
  g_MouseStateItem: TClientItem;
  g_HeroMouseStateItem: TClientItem;
  g_MouseUserStateItem: TClientItem;
  g_HeroMouseItem: TClientItem;
  g_ClickShopItem: TShopItem;

  g_boItemMoving: Boolean;
  g_MovingItem: TMovingItem;
  g_OpenBoxItem: TMovingItem;
  g_WaitingUseItem: TMovingItem;
  g_WaitingStallItem: TMovingItem;
  g_WaitingDetectItem: TMovingItem;

  g_FocusItem, g_FocusItem2: pTDropItem;
  g_boOpenStallSystem: Boolean = True;
  g_boAutoLongAttack: Boolean = True;
  g_boAutoSay: Boolean = True;
  g_boMutiHero: Boolean = True;
  g_boSkill_114_MP: Boolean = False;
  g_boSkill_68_MP: Boolean = False;
  g_nDayBright: Integer;
  g_nAreaStateValue: Integer;
  g_boNoDarkness: Boolean;
  g_nRunReadyCount: Integer;

  g_boLastViewFog: Boolean = False;
{$IF VIEWFOG}
  g_boViewFog: Boolean = True; //是否显示黑暗
  g_boForceNotViewFog: Boolean = True; //免蜡烛
{$ELSE}
  g_boViewFog: Boolean = False; //是否显示黑暗
  g_boForceNotViewFog: Boolean = True; //免蜡烛
{$IFEND VIEWFOG}

  g_EatingItem: TClientItem;
  g_dwEatTime: Longword; //timeout...
  g_dwHeroEatTime: Longword;

  g_dwDizzyDelayStart: Longword;
  g_dwDizzyDelayTime: Longword;

  g_boDoFadeOut: Boolean;
  g_boDoFadeIn: Boolean; //由暗变亮
  g_nFadeIndex: Integer; //由亮变暗
  g_boDoFastFadeOut: Boolean;

  g_boAutoDig, g_boAutoSit: Boolean; //自动锄矿
  g_boSelectMyself: Boolean; //鼠标是否指到自己

  //游戏速度检测相关变量
  g_dwFirstServerTime: Longword;
  g_dwFirstClientTime: Longword;
  //ServerTimeGap: int64;
  g_nTimeFakeDetectCount: Integer;
  //g_dwSHGetCount            : PLongWord;
  //g_dwSHGetTime             : LongWord;
  //g_dwSHTimerTime           : LongWord;
  //g_nSHFakeCount            : Integer;  //检查机器速度异常次数，如果超过4次则提示速度不稳定

  g_dwLatestClientTime2: Longword;
  g_dwFirstClientTimerTime: Longword; //timer 矫埃
  g_dwLatestClientTimerTime: Longword;
  g_dwFirstClientGetTime: Longword; //gettickcount 矫埃
  g_dwLatestClientGetTime: Longword;
  g_nTimeFakeDetectSum: Integer;
  g_nTimeFakeDetectTimer: Integer;

  g_dwLastestClientGetTime: Longword;

  //外挂功能变量开始
  g_dwDropItemFlashTime: Longword = 5 * 1000; //地面物品闪时间间隔
  g_nHitTime: Integer = 1400; //攻击间隔时间间隔  0820
  g_nItemSpeed: Integer = 60;
  g_dwSpellTime: Longword = 500; //魔法攻间隔时间

  g_boHero: Boolean = True;
  g_boOpenAutoPlay: Boolean = True;
  g_DeathColorEffect: TColorEffect = ceRed;  //死亡颜色  Development 2018-12-29
  g_boClientCanSet: Boolean = True;

  g_nEatIteminvTime: Integer = 200;
  g_boCanRunSafeZone: Boolean = True;
  g_boCanRunHuman: Boolean = True;
  g_boCanRunMon: Boolean = True;
  g_boCanRunNpc: Boolean = True;
  g_boCanRunAllInWarZone: Boolean = False;
  g_boCanStartRun: Boolean = True; //是否允许免助跑
  g_boParalyCanRun: Boolean = False; //麻痹是否可以跑
  g_boParalyCanWalk: Boolean = False; //麻痹是否可以走
  g_boParalyCanHit: Boolean = False; //麻痹是否可以攻击
  g_boParalyCanSpell: Boolean = False; //麻痹是否可以魔法

  g_boShowRedHPLable: Boolean = True; //显示血条
  g_boShowHPNumber: Boolean = True; //显示血量数字
  g_boShowJobLevel: Boolean = True; //显示职业等级
  g_boDuraAlert: Boolean = True; //物品持久警告
  g_boMagicLock: Boolean = True; //魔法锁定
  g_boSpeedRate: Boolean = False;
  g_boSpeedRateShow: Boolean = False;
  //g_boAutoPuckUpItem        : Boolean = False;

  g_boShowHumanInfo: Boolean = True;
  g_boShowMonsterInfo: Boolean = False;
  g_boShowNpcInfo: Boolean = False;
  //外挂功能变量结束
  g_boQuickPickup: Boolean = False;
  g_dwAutoPickupTick: Longword;
  g_dwAutoPickupTime: Longword = 100; //自动捡物品间隔
  //g_AutoPickupList          : TList;
  g_MagicLockActor: TActor;
  g_boNextTimePowerHit: Boolean;
  g_boCanLongHit: Boolean;
  g_boCanWideHit: Boolean;
  g_boCanCrsHit: Boolean;
  g_boCanStnHit: Boolean;
  g_boNextTimeFireHit: Boolean;
  g_boNextTimeTwinHit: Boolean;
  g_boNextTimePursueHit: Boolean;
  g_boNextTimeRushHit: Boolean;
  g_boNextTimeSmiteHit: Boolean;
  g_boNextTimeSmiteLongHit: Boolean;
  g_boNextTimeSmiteLongHit2: Boolean;
  g_boNextTimeSmiteLongHit3: Boolean;
  g_boNextTimeSmiteWideHit: Boolean;
  g_boNextTimeSmiteWideHit2: Boolean;

  g_boCanSLonHit: Boolean = False;
  g_boCanSquHit: Boolean;
  g_ShowItemList: THStringList;
  g_boDrawTileMap: Boolean = True;
  g_boDrawDropItem: Boolean = True;

  g_nTestX: Integer = 71;
  g_nTestY: Integer = 212;

  g_nSquHitPoint: Integer = 0;
  g_nMaxSquHitPoint: Integer = 0;

  g_boConfigLoaded: Boolean = False;

  g_dwCollectExpLv: Byte = 0;
  g_boCollectStateShine: Boolean = False;
  g_nCollectStateShine: Integer = 0;
  g_dwCollectStateShineTick: Longword;
  g_dwCollectStateShineTick2: Longword;

  g_dwCollectExp: Longword = 0;
  g_dwCollectExpMax: Longword = 1;
  g_boCollectExpShine: Boolean = False;
  g_boCollectExpShineCount: Integer = 0;
  g_dwCollectExpShineTick: Longword;

  g_dwCollectIpExp: Longword = 0;
  g_dwCollectIpExpMax: Longword = 1;

  g_ReSelChr: Boolean = False;
  DlgConf: TConfig = (
    DBottom: (Image: 1; Left: 0; Top: 0; Width: 0; Height: 0);
    DMyState: (Image: 8; Left: 643; Top: 61; Width: 0; Height: 0);
    DMyBag: (Image: 9; Left: 682; Top: 41; Width: 0; Height: 0);
    DMyMagic: (Image: 10; Left: 722; Top: 21; Width: 0; Height: 0);
    DOption: (Image: 11; Left: 764; Top: 11; Width: 0; Height: 0);

    DBotMiniMap: (Image: 130; Left: 209; Top: 104; Width: 0; Height: 0);
    DBotTrade: (Image: 132; Left: 209 + 30; Top: 104; Width: 0; Height: 0);
    DBotGuild: (Image: 134; Left: 209 + 30 * 2; Top: 104; Width: 0; Height: 0);
    DBotGroup: (Image: 128; Left: 209 + 30 * 3; Top: 104; Width: 0; Height: 0);
    DBotFriend: (Image: 34; Left: 209 + 30 * 4; Top: 104; Width: 0; Height: 0);
    DBotDare: (Image: 36; Left: 209 + 30 * 5; Top: 104; Width: 0; Height: 0);
    DBotLevelRank: (Image: 460; Left: 209 + 30 * 6; Top: 104; Width: 0; Height: 0);

    DBotPlusAbil: (Image: 140; Left: 209 + 30 * 8; Top: 104; Width: 0; Height: 0);
    //DBotMemo: (Image: 532; Left: SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 353)) {753}; Top: 204; Width: 0; Height: 0);
    //DBotExit: (Image: 138; Left: SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 160)) {560}; Top: 104; Width: 0; Height: 0);
    //DBotLogout: (Image: 136; Left: SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 160)) - 30 {560}; Top: 104; Width: 0; Height: 0);
    DBelt1: (Image: 0; Left: 285; Top: 59; Width: 32; Height: 29);
    DBelt2: (Image: 0; Left: 328; Top: 59; Width: 32; Height: 29);
    DBelt3: (Image: 0; Left: 371; Top: 59; Width: 32; Height: 29);
    DBelt4: (Image: 0; Left: 415; Top: 59; Width: 32; Height: 29);
    DBelt5: (Image: 0; Left: 459; Top: 59; Width: 32; Height: 29);
    DBelt6: (Image: 0; Left: 503; Top: 59; Width: 32; Height: 29);
    DGold: (Image: 29; Left: 10; Top: 190; Width: 0; Height: 0);
    DRfineItem: (Image: 26; Left: 254; Top: 183; Width: 48; Height: 22);
    DCloseBag: (Image: 371; Left: 309; Top: 203; Width: 14; Height: 20);
    DMerchantDlg: (Image: 384; Left: 0; Top: 0; Width: 0; Height: 0);
    DMerchantDlgClose: (Image: 64; Left: 399; Top: 1; Width: 0; Height: 0);
    DConfigDlg: (Image: 204; Left: 0; Top: 0; Width: 0; Height: 0);
    DConfigDlgOK: (Image: 361; Left: 514; Top: 287; Width: 0; Height: 0);
    DConfigDlgClose: (Image: 64; Left: 584; Top: 6; Width: 0; Height: 0);
    DMenuDlg: (Image: 385; Left: 138; Top: 163; Width: 0; Height: 0);
    DMenuPrev: (Image: 388; Left: 43; Top: 175; Width: 0; Height: 0);
    DMenuNext: (Image: 387; Left: 90; Top: 175; Width: 0; Height: 0);
    DMenuBuy: (Image: 386; Left: 215; Top: 171; Width: 0; Height: 0);
    DMenuClose: (Image: 64; Left: 291; Top: 0; Width: 0; Height: 0);
    DSellDlg: (Image: 392; Left: 328; Top: 163; Width: 0; Height: 0);
    DSellDlgOk: (Image: 393; Left: 85; Top: 150; Width: 0; Height: 0);
    DSellDlgClose: (Image: 64; Left: 115; Top: 0; Width: 0; Height: 0);
    DSellDlgSpot: (Image: 0; Left: 27; Top: 67; Width: 0; Height: 0);
    DKeySelDlg: (Image: 620; Left: 0; Top: 0; Width: 0; Height: 0);
    DKsIcon: (Image: 0; Left: 51; Top: 31; Width: 0; Height: 0);
    DKsF1: (Image: 232; Left: 25; Top: 78; Width: 0; Height: 0);
    DKsF2: (Image: 234; Left: 57; Top: 78; Width: 0; Height: 0);
    DKsF3: (Image: 236; Left: 89; Top: 78; Width: 0; Height: 0);
    DKsF4: (Image: 238; Left: 121; Top: 78; Width: 0; Height: 0);
    DKsF5: (Image: 240; Left: 160; Top: 78; Width: 0; Height: 0);
    DKsF6: (Image: 242; Left: 192; Top: 78; Width: 0; Height: 0);
    DKsF7: (Image: 244; Left: 224; Top: 78; Width: 0; Height: 0);
    DKsF8: (Image: 246; Left: 256; Top: 78; Width: 0; Height: 0);
    DKsConF1: (Image: 626; Left: 25; Top: 120; Width: 0; Height: 0);
    DKsConF2: (Image: 628; Left: 57; Top: 120; Width: 0; Height: 0);
    DKsConF3: (Image: 630; Left: 89; Top: 120; Width: 0; Height: 0);
    DKsConF4: (Image: 632; Left: 121; Top: 120; Width: 0; Height: 0);
    DKsConF5: (Image: 633; Left: 160; Top: 120; Width: 0; Height: 0);
    DKsConF6: (Image: 634; Left: 192; Top: 120; Width: 0; Height: 0);
    DKsConF7: (Image: 638; Left: 224; Top: 120; Width: 0; Height: 0);
    DKsConF8: (Image: 640; Left: 256; Top: 120; Width: 0; Height: 0);
    DKsNone: (Image: 623; Left: 296; Top: 78; Width: 0; Height: 0);
    DKsOk: (Image: 621; Left: 296; Top: 120; Width: 0; Height: 0);
    DChgGamePwd: (Image: 621; Left: 296; Top: 120; Width: 0; Height: 0);
    DChgGamePwdClose: (Image: 64; Left: 312; Top: 1; Width: 0; Height: 0);
    DItemGrid: (Image: 0; Left: 29; Top: 41; Width: 286; Height: 162);
    );

const
  // Windows 2000/XP multimedia keys (adapted from winuser.h and renamed to avoid potential conflicts)
  // See also: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/WindowsUserInterface/UserInput/VirtualKeyCodes.asp
  _VK_BROWSER_BACK = $A6; // Browser Back key
  _VK_BROWSER_FORWARD = $A7; // Browser Forward key
  _VK_BROWSER_REFRESH = $A8; // Browser Refresh key
  _VK_BROWSER_STOP = $A9; // Browser Stop key
  _VK_BROWSER_SEARCH = $AA; // Browser Search key
  _VK_BROWSER_FAVORITES = $AB; // Browser Favorites key
  _VK_BROWSER_HOME = $AC; // Browser Start and Home key
  _VK_VOLUME_MUTE = $AD; // Volume Mute key
  _VK_VOLUME_DOWN = $AE; // Volume Down key
  _VK_VOLUME_UP = $AF; // Volume Up key
  _VK_MEDIA_NEXT_TRACK = $B0; // Next Track key
  _VK_MEDIA_PREV_TRACK = $B1; // Previous Track key
  _VK_MEDIA_STOP = $B2; // Stop Media key
  _VK_MEDIA_PLAY_PAUSE = $B3; // Play/Pause Media key
  _VK_LAUNCH_MAIL = $B4; // Start Mail key
  _VK_LAUNCH_MEDIA_SELECT = $B5; // Select Media key
  _VK_LAUNCH_APP1 = $B6; // Start Application 1 key
  _VK_LAUNCH_APP2 = $B7; // Start Application 2 key
  // Self-invented names for the extended keys
  NAME_VK_BROWSER_BACK = 'Browser Back';
  NAME_VK_BROWSER_FORWARD = 'Browser Forward';
  NAME_VK_BROWSER_REFRESH = 'Browser Refresh';
  NAME_VK_BROWSER_STOP = 'Browser Stop';
  NAME_VK_BROWSER_SEARCH = 'Browser Search';
  NAME_VK_BROWSER_FAVORITES = 'Browser Favorites';
  NAME_VK_BROWSER_HOME = 'Browser Start/Home';
  NAME_VK_VOLUME_MUTE = 'Volume Mute';
  NAME_VK_VOLUME_DOWN = 'Volume Down';
  NAME_VK_VOLUME_UP = 'Volume Up';
  NAME_VK_MEDIA_NEXT_TRACK = 'Next Track';
  NAME_VK_MEDIA_PREV_TRACK = 'Previous Track';
  NAME_VK_MEDIA_STOP = 'Stop Media';
  NAME_VK_MEDIA_PLAY_PAUSE = 'Play/Pause Media';
  NAME_VK_LAUNCH_MAIL = 'Start Mail';
  NAME_VK_LAUNCH_MEDIA_SELECT = 'Select Media';
  NAME_VK_LAUNCH_APP1 = 'Start Application 1';
  NAME_VK_LAUNCH_APP2 = 'Start Application 2';

const

  CONFIGFILE = 'Config\%s.ini';
//*****************************************************************
  MAINIMAGEFILE = 'Data\Prguse.wil';
  MAINIMAGEFILE2 = 'Data\Prguse2.wil';
  MAINIMAGEFILE3 = 'Data\Prguse3.wil';
  MAINIMAGEFILE3_16 = 'Data\Prguse3_16.wil';
  //MAINIMAGEFILE99 = 'Data\NewUI.pak';
  EFFECTIMAGEDIR = 'Data\';


  NewopUIIMAGEFILE = 'Data\NewopUI.wil';
  ui1IMAGEFILE = 'Data\ui1.wil';

  CHRSELIMAGEFILE = 'Data\ChrSel.wil';
  MINMAPIMAGEFILE = 'Data\mmap.wil';
  TITLESIMAGEFILE = 'Data\Tiles.wil';
  TITLESIMAGEFILEX = 'Data\Tiles%d.wil';

  SMLTITLESIMAGEFILE = 'Data\SmTiles.wil';
  SMLTITLESIMAGEFILEX = 'Data\SmTiles%d.wil';

  HUMWINGIMAGESFILE = 'Data\HumEffect.wil';
  HUMWINGIMAGESFILE2 = 'Data\HumEffect2.wil';
  HUMWINGIMAGESFILE3 = 'Data\HumEffect3.wil';
  MAGICONIMAGESFILE = 'Data\MagIcon.wil';
  MAGICON2IMAGESFILE = 'Data\MagIcon2.wil';

  HUMIMGIMAGESFILE = 'Data\Hum.wil';
  HUM2IMGIMAGESFILE = 'Data\Hum2.wil';
  HUM3IMGIMAGESFILE = 'Data\Hum3.wil';
//扩展自定义衣服补丁 每个文件支持48件武器  Development 2019-02-03
  HUM4IMGIMAGESFILE = 'Data\Hum4.wil';
  HUM5IMGIMAGESFILE = 'Data\Hum5.wil';
  HUM6IMGIMAGESFILE = 'Data\Hum6.wil';
  HUM7IMGIMAGESFILE = 'Data\Hum7.wil';
  HUM8IMGIMAGESFILE = 'Data\Hum8.wil';
  HUM9IMGIMAGESFILE = 'Data\Hum9.wil';
//////////////////////////////////////////////////////////////////
  HAIRIMGIMAGESFILE = 'Data\Hair.wil';
  HAIR2IMGIMAGESFILE = 'Data\Hair2.wil';

  WEAPONIMAGESFILE = 'Data\Weapon.wil';
  WEAPON2IMAGESFILE = 'Data\Weapon2.wil';
  WEAPON3IMAGESFILE = 'Data\Weapon3.wil';

//扩展自定义武器补丁 每个文件支持48件武器  Development 2019-02-03
  WEAPON4IMAGESFILE = 'Data\Weapon4.wil';
  WEAPON5IMAGESFILE = 'Data\Weapon5.wil';
  WEAPON6IMAGESFILE = 'Data\Weapon6.wil';
  WEAPON7IMAGESFILE = 'Data\Weapon7.wil';
  WEAPON8IMAGESFILE = 'Data\Weapon8.wil';
  WEAPON9IMAGESFILE = 'Data\Weapon9.wil';
//////////////////////////////////////////////////////////////////
  NPCIMAGESFILE = 'Data\Npc.wil';
  NPC2IMAGESFILE = 'Data\Npc2.wil';
  NPCFACEIMAGESFILE = 'Data\NpcFace.wil'; //NPC大窗口扩展 Development 2019-01-14 添加
  MAGICIMAGESFILE = 'Data\Magic.wil';
  MAGIC2IMAGESFILE = 'Data\Magic2.wil';
  MAGIC3IMAGESFILE = 'Data\Magic3.wil';
  MAGIC4IMAGESFILE = 'Data\Magic4.wil';
  MAGIC5IMAGESFILE = 'Data\Magic5.wil';
  MAGIC6IMAGESFILE = 'Data\Magic6.wil';
  MAGIC7IMAGESFILE = 'Data\magic7-16.wil';
  MAGIC7IMAGESFILE2 = 'Data\magic7.wil';
  MAGIC8IMAGESFILE = 'Data\magic8-16.wil';
  MAGIC8IMAGESFILE2 = 'Data\magic8.wil';
  MAGIC9IMAGESFILE = 'Data\magic9.wil';
  MAGIC10IMAGESFILE = 'Data\magic10.wil';
  STATEEFFECTFILE = 'Data\StateEffect.wil';


  BAGITEMIMAGESFILE = 'Data\Items.wil';
  BAGITEMIMAGESFILE2 = 'Data\Items2.wil';
  STATEITEMIMAGESFILE = 'Data\StateItem.wil';
  STATEITEMIMAGESFILE2 = 'Data\StateItem2.wil';
  DNITEMIMAGESFILE = 'Data\DnItems.wil';
  DNITEMIMAGESFILE2 = 'Data\DnItems2.wil';

  OBJECTIMAGEFILE = 'Data\Objects.wil';
  OBJECTIMAGEFILE1 = 'Data\Objects%d.wil';
  MONIMAGEFILE = 'Data\Mon%d.wil';

  DRAGONIMAGEFILE = 'Data\Dragon.wil';
  EFFECTIMAGEFILE = 'Data\Effect.wil';
  MONKULOUIMAGEFILE   = 'Data\Mon-kulou.wil';



  cboEffectFile = 'Data\cboEffect.wil';
  cbohairFile = 'Data\cbohair.wil';
  cbohumFile = 'Data\cbohum.wil';
  cbohum3File = 'Data\cbohum3.wil';
  cbohum4File = 'Data\cbohum4.wil';

  cboHumEffectFile = 'Data\cboHumEffect.wil';
  cboHumEffect2File = 'Data\cboHumEffect2.wil';
  cboHumEffect3File = 'Data\cboHumEffect3.wil';
  cboweaponFile = 'Data\cboweapon.wil';
  cboweapon3File = 'Data\cboweapon3.wil';

  bInterfaceFile = 'Data\bInterface.wil';

  MONIMAGEFILEEX = 'Data\%d.wil';
  MONPMFILE = 'Data\%d.pm';




  g_WMon1_IMAGEFILE = 'Data\Mon1.wil';//1~21
  g_WMon2_IMAGEFILE = 'Data\Mon2.wil';//1~21
  g_WMon3_IMAGEFILE = 'Data\Mon3.wil';//1~21
  g_WMon4_IMAGEFILE = 'Data\Mon4.wil';//1~21
  g_WMon5_IMAGEFILE = 'Data\Mon5.wil';//1~21
  g_WMon6_IMAGEFILE = 'Data\Mon6.wil';//1~21
  g_WMon7_IMAGEFILE = 'Data\Mon7.wil';//1~21
  g_WMon8_IMAGEFILE = 'Data\Mon8.wil';//1~21
  g_WMon9_IMAGEFILE = 'Data\Mon9.wil';//1~21
  g_WMon10_IMAGEFILE = 'Data\Mon10.wil';//1~21
  g_WMon11_IMAGEFILE = 'Data\Mon11.wil';//1~21
  g_WMon12_IMAGEFILE = 'Data\Mon12.wil';//1~21
  g_WMon13_IMAGEFILE = 'Data\Mon13.wil';//1~21
  g_WMon14_IMAGEFILE = 'Data\Mon14.wil';//1~21
  g_WMon15_IMAGEFILE = 'Data\Mon15.wil';//1~21
  g_WMon16_IMAGEFILE = 'Data\Mon16.wil';//1~21
  g_WMon17_IMAGEFILE = 'Data\Mon17.wil';//1~21
  g_WMon18_IMAGEFILE = 'Data\Mon18.wil';//1~21
  g_WMon19_IMAGEFILE = 'Data\Mon19.wil';//1~21
  g_WMon20_IMAGEFILE = 'Data\Mon20.wil';//1~21
  g_WMon21_IMAGEFILE = 'Data\Mon21.wil';//1~21
  g_WMon22_IMAGEFILE = 'Data\Mon22.wil';//1~21
  g_WMon23_IMAGEFILE = 'Data\Mon23.wil';//1~21
  g_WMon24_IMAGEFILE = 'Data\Mon24.wil';//1~21
  g_WMon25_IMAGEFILE = 'Data\Mon25.wil';//1~21
  g_WMon26_IMAGEFILE = 'Data\Mon26.wil';
  g_WMon27_IMAGEFILE = 'Data\Mon27.wil';
  g_WMon28_IMAGEFILE = 'Data\Mon28.wil';
  g_WMon29_IMAGEFILE = 'Data\Mon29.wil';
  g_WMon30_IMAGEFILE = 'Data\Mon30.wil';
  g_WMon31_IMAGEFILE = 'Data\Mon31.wil';
  g_WMon32_IMAGEFILE = 'Data\Mon32.wil';
  g_WMon33_IMAGEFILE = 'Data\Mon33.wil';
  g_WMon34_IMAGEFILE = 'Data\Mon34.wil';
  g_WMon35_IMAGEFILE = 'Data\Mon35.wil';
  g_WMon36_IMAGEFILE = 'Data\Mon36.wil';
  g_WMon37_IMAGEFILE = 'Data\Mon37.wil';
  g_WMon38_IMAGEFILE = 'Data\Mon38.wil';
  g_WMon39_IMAGEFILE = 'Data\Mon39.wil';
  g_WMon40_IMAGEFILE = 'Data\Mon40.wil';
//扩展自定义怪物外观素材 Mon100wil~Mon130.wil  Development 2019-01-29
  g_WMon100_IMAGEFILE = 'Data\Mon100.wil';
  g_WMon101_IMAGEFILE = 'Data\Mon101.wil';
  g_WMon102_IMAGEFILE = 'Data\Mon102.wil';
  g_WMon103_IMAGEFILE = 'Data\Mon103.wil';
  g_WMon104_IMAGEFILE = 'Data\Mon104.wil';
  g_WMon105_IMAGEFILE = 'Data\Mon105.wil';
  g_WMon106_IMAGEFILE = 'Data\Mon106.wil';
  g_WMon107_IMAGEFILE = 'Data\Mon107.wil';
  g_WMon108_IMAGEFILE = 'Data\Mon108.wil';
  g_WMon109_IMAGEFILE = 'Data\Mon109.wil';
  g_WMon110_IMAGEFILE = 'Data\Mon110.wil';
  g_WMon111_IMAGEFILE = 'Data\Mon111.wil';
  g_WMon112_IMAGEFILE = 'Data\Mon112.wil';
  g_WMon113_IMAGEFILE = 'Data\Mon113.wil';
  g_WMon114_IMAGEFILE = 'Data\Mon114.wil';
  g_WMon115_IMAGEFILE = 'Data\Mon115.wil';
  g_WMon116_IMAGEFILE = 'Data\Mon116.wil';
  g_WMon117_IMAGEFILE = 'Data\Mon117.wil';
  g_WMon118_IMAGEFILE = 'Data\Mon118.wil';
  g_WMon119_IMAGEFILE = 'Data\Mon119.wil';
  g_WMon120_IMAGEFILE = 'Data\Mon120.wil';
  g_WMon121_IMAGEFILE = 'Data\Mon121.wil';
  g_WMon122_IMAGEFILE = 'Data\Mon122.wil';
  g_WMon123_IMAGEFILE = 'Data\Mon123.wil';
  g_WMon124_IMAGEFILE = 'Data\Mon124.wil';
  g_WMon125_IMAGEFILE = 'Data\Mon125.wil';
  g_WMon126_IMAGEFILE = 'Data\Mon126.wil';
  g_WMon127_IMAGEFILE = 'Data\Mon127.wil';
  g_WMon128_IMAGEFILE = 'Data\Mon128.wil';
  g_WMon129_IMAGEFILE = 'Data\Mon129.wil';
  g_WMon130_IMAGEFILE = 'Data\Mon130.wil';
//*******************************************************************************
  g_sGameConfigBackGround = 'Data\ui\gcbkd.uib';
  g_sGameConfigOk1 = 'Data\ui\gcok1.uib';
  g_sGameConfigOk2 = 'Data\ui\gcok2.uib';
  g_sGameConfigPage1 = 'Data\ui\gcpage1.uib';
  g_sGameConfigPage2 = 'Data\ui\gcpage2.uib';
  g_sGameConfigClose1 = 'Data\ui\gcclose1.uib';
  g_sGameConfigClose2 = 'Data\ui\gcclose2.uib';
  g_sGameConfigCheckBox1 = 'Data\ui\gccheckbox1.uib';
  g_sGameConfigCheckBox2 = 'Data\ui\gccheckbox2.uib';
//*******************************************************************************
  g_sBookPage = 'Data\books\%d\%d.uib';
  g_sBookBtn = 'Data\books\%d\%s.uib';
  g_sMiniMap = 'Data\minimap\%d.mmap';
//*******************************************************************************
  g_sStateWindowHero = 'Data\ui\StateWindowHero.uib';
  g_sHeroStatusWindow = 'Data\ui\HeroStatusWindow.uib';
  g_sStateWindowHumanB = 'Data\ui\StateWindowHumanB.uib';
  g_sStateWindowHumanC = 'Data\ui\StateWindowHumanC.uib';
  g_sDscStart = 'Data\ui\DscStart%d.uib';
  g_sDscStart0 = 'Data\ui\DscStart0.uib';
  g_sDscStart1 = 'Data\ui\DscStart1.uib';
//*******************************************************************************
  g_sMainBoard = 'Data\ui\MainBoard.uib';
  g_sItemBag = 'Data\ui\ItemBag.uib';
//*******************************************************************************
  g_sHeroItemBag = 'Data\ui\HeroItemBag%d.uib';
//*******************************************************************************
  g_sHeroStateWin = 'Data\ui\HeroStateWin.uib';
  g_sGloryButton = 'Data\ui\GloryButton.uib';
  //g_sLogoUIB                = 'Data\ui\blue.uib';
  g_sVigourbar1 = 'Data\ui\vigourbar1.uib';
  g_sVigourbar2 = 'Data\ui\vigourbar2.uib';
//*******************************************************************************
  g_sBookBkgnd = 'Data\ui\BookBkgnd.uib';
  g_sBookCloseNormal = 'Data\ui\BookCloseNormal.uib';
  g_sBookCloseDown = 'Data\ui\BookCloseDown.uib';
  g_sBookNextPageNormal = 'Data\ui\BookNextPageNormal.uib';
  g_sBookNextPageDown = 'Data\ui\BookNextPageDown.uib';
  g_sBookPrevPageNormal = 'Data\ui\BookPrevPageNormal.uib';
  g_sBookPrevPageDown = 'Data\ui\BookPrevPageDown.uib';
//*******************************************************************************
  g_WStall = 'Data\ui\WStall.uib';
  g_WStallPrice = 'Data\ui\WStallPrice.uib';
  g_PStallPrice0 = 'Data\ui\PStallPrice0.uib';
  g_PStallPrice1 = 'Data\ui\PStallPrice1.uib';
  g_StallBot = 'Data\ui\StallBot%d.uib';
  g_StallLooks = 'Data\ui\StallLooks%d.uib';
  g_sLogoUIB = 'Data\ui\Logo.uib'; //读取LOGO界面 Development 2019-01-28
  g_schenghao = 'Data\ui\chenghao.uib'; //读取四格称号界面  Development 2019-01-25
//*******************************************************************************
  g_affiche0 = '游戏音效已关闭！';
  g_affiche1 = '健康游戏公告';
  g_affiche2 = '抵制不良游戏 拒绝盗版游戏 注意自我保护 谨防受骗上当 适度游戏益脑';
  g_affiche3 = '沉迷游戏伤身 合理安排时间 享受健康生活 严厉打击赌博 营造和谐环境';
//*******************************************************************************




var
  g_wui: TWMImages;
  g_opui: TWMImages;
  g_WMainImages: TWMImages;
  g_WMain2Images: TWMImages;
  g_WMain3Images: TWMImages;
  g_WChrSelImages: TWMImages;
  g_WMonImg: TWMImages;
  g_WMon2Img: TWMImages;
  g_WMon3Img: TWMImages;
  g_WMon4Img: TWMImages;
  g_WMon5Img: TWMImages;
  g_WMon6Img: TWMImages;
  g_WMon7Img: TWMImages;
  g_WMon8Img: TWMImages;
  g_WMon9Img: TWMImages;
  g_WMon10Img: TWMImages;
  g_WMon11Img: TWMImages;
  g_WMon12Img: TWMImages;
  g_WMon13Img: TWMImages;
  g_WMon14Img: TWMImages;
  g_WMon15Img: TWMImages;
  g_WMon16Img: TWMImages;
  g_WMon17Img: TWMImages;
  g_WMon18Img: TWMImages;
  g_WMon19Img: TWMImages;
  g_WMon20Img: TWMImages;
  g_WMon21Img: TWMImages;
  g_WMon22Img: TWMImages;
  g_WMon23Img: TWMImages;
  g_WMon24Img: TWMImages;
  g_WMon25Img: TWMImages;
  g_WMon26Img: TWMImages;
  g_WMon27Img: TWMImages;
  g_WMon28Img: TWMImages;
  g_WMon29Img: TWMImages;
  g_WMon30Img: TWMImages;
  g_WMon31Img: TWMImages;
  g_WMon32Img: TWMImages;
  g_WMon33Img: TWMImages;
  g_WMon34Img: TWMImages;
  g_WMon35Img: TWMImages;
  g_WMon36Img: TWMImages;
  g_WMon37Img: TWMImages;
  g_WMon38Img: TWMImages;
  g_WMon39Img: TWMImages;
  g_WMon40Img: TWMImages;

//扩展自定义怪物外观素材 Mon100wil~Mon130.wil  Development 2019-01-29
  g_WMon100Img: TWMImages;
  g_WMon101Img: TWMImages;
  g_WMon102Img: TWMImages;
  g_WMon103Img: TWMImages;
  g_WMon104Img: TWMImages;
  g_WMon105Img: TWMImages;
  g_WMon106Img: TWMImages;
  g_WMon107Img: TWMImages;
  g_WMon108Img: TWMImages;
  g_WMon109Img: TWMImages;
  g_WMon110Img: TWMImages;
  g_WMon111Img: TWMImages;
  g_WMon112Img: TWMImages;
  g_WMon113Img: TWMImages;
  g_WMon114Img: TWMImages;
  g_WMon115Img: TWMImages;
  g_WMon116Img: TWMImages;
  g_WMon117Img: TWMImages;
  g_WMon118Img: TWMImages;
  g_WMon119Img: TWMImages;
  g_WMon120Img: TWMImages;
  g_WMon121Img: TWMImages;
  g_WMon122Img: TWMImages;
  g_WMon123Img: TWMImages;
  g_WMon124Img: TWMImages;
  g_WMon125Img: TWMImages;
  g_WMon126Img: TWMImages;
  g_WMon127Img: TWMImages;
  g_WMon128Img: TWMImages;
  g_WMon129Img: TWMImages;
  g_WMon130Img: TWMImages;
//////////////////////////////////////////////////////////////////////
  g_WEffectImg: TWMImages;
  g_WDragonImg: TWMImages;
  g_WSkeletonImg: TWMImages;
  g_WBooksImages: TUIBImages;
  g_WMainUibImages: TUIBImages;
  g_WMiniMapImages: TUIBImages;
  g_WMMapImages: TWMImages;
  g_WHumWingImages: TWMImages;
  g_WHumEffect2: TWMImages;
  g_WHumEffect3: TWMImages;
  g_WBagItemImages: TWMImages;
  g_WBagItemImages2: TWMImages;
  g_WStateItemImages: TWMImages;
  g_WStateItemImages2: TWMImages;
  g_WDnItemImages: TWMImages;
  g_WDnItemImages2: TWMImages;
  g_WHumImgImages: TWMImages;
  g_WHum2ImgImages: TWMImages;
  g_WHum3ImgImages: TWMImages;
//扩展自定义衣服补丁 每个文件支持48件衣服  Development 2019-02-03
  g_WHum4ImgImages: TWMImages; //Hum4.wzl
  g_WHum5ImgImages: TWMImages; //Hum5.wzl
  g_WHum6ImgImages: TWMImages; //Hum6.wzl
  g_WHum7ImgImages: TWMImages; //Hum7.wzl
  g_WHum8ImgImages: TWMImages; //Hum8.wzl
  g_WHum9ImgImages: TWMImages; //Hum9.wzl
/////////////////////////////////////////////////////////////////
  g_WHairImgImages: TWMImages;
  g_WHair2ImgImages: TWMImages;
  g_WWeaponImages: TWMImages;
  g_WWeapon2Images: TWMImages;
  g_WWeapon3Images: TWMImages;
//扩展自定义武器补丁 每个文件支持48件武器  Development 2019-02-03
  g_WWeapon4Images: TWMImages;
  g_WWeapon5Images: TWMImages;
  g_WWeapon6Images: TWMImages;
  g_WWeapon7Images: TWMImages;
  g_WWeapon8Images: TWMImages;
  g_WWeapon9Images: TWMImages;
//////////////////////////////////////////////////////////////////
  g_WMagIconImages: TWMImages;
  g_WMagIcon2Images: TWMImages;
  g_WNpcImgImages: TWMImages;
  g_WNpc2ImgImages: TWMImages;
  g_WMagicImages: TWMImages;
  g_WMagic2Images: TWMImages;
  g_WMagic3Images: TWMImages;
  g_WMagic4Images: TWMImages;
  g_WMagic5Images: TWMImages;
  g_WMagic6Images: TWMImages;
  g_WMagic7Images: TWMImages; //Data\magic7-16.wil
  g_WMagic7Images2: TWMImages; //Data\magic7.wil
  g_WMagic8Images: TWMImages; //Data\magic8-16.wil
  g_WMagic8Images2: TWMImages; //Data\magic8.wil
  g_WMagic9Images: TWMImages;
  g_WMagic10Images: TWMImages;
  g_StateEffect: TWMImages;
  g_WObjectArr: array[0..30] of TWMImages;
  g_WTilesArr: array[0..9] of TWMImages;
  g_WSmTilesArr: array[0..9] of TWMImages;
  g_cboEffect: TWMImages;
  g_cbohair: TWMImages;
  g_cbohum: TWMImages;
  g_cbohum3: TWMImages;
  g_cbohum4: TWMImages;
  g_cboHumEffect: TWMImages;
  g_cboHumEffect2: TWMImages;
  g_cboHumEffect3: TWMImages;
  g_cboweapon: TWMImages;
  g_cboweapon3: TWMImages;
  g_WMainPAK: TWMImages;
  g_WBigNpcImages: TWMImages; //NPC大窗口相关 2019-01-14


procedure LoadWMImagesLib();
procedure InitWMImagesLib(password: string);
procedure UnLoadWMImagesLib();
procedure FreeOldWMImagesLib(); //释放图片 2018-12-26  Development添加
procedure ClearWMImagesLib(); //清理图像 2018-12-26 Development添加

procedure InitClientItems();
function GetTIHintString1(idx: Integer; ci: PTClientItem = nil; iname: string = ''): Byte;
function GetTIHintString2(idx: Integer; ci: PTClientItem = nil; iname: string = ''): Byte;
procedure AutoPutOntiBooks();
procedure AutoPutOntiCharms();

function GetSuiteAbil(idx, Shape: Integer; var sa: TtSuiteAbil): Boolean;

procedure AutoPutOntiSecretBooks();

function GetSpHintString1(idx: Integer; ci: PTClientItem = nil; iname: string = ''): Byte;
function GetSpHintString2(idx: Integer; ci: PTClientItem = nil; iname: string = ''): Byte;

function GetEvaluationInfo(CurrMouseItem: TClientItem): string;
function GetSecretAbil(CurrMouseItem: TClientItem): Boolean;

procedure InitObj();
procedure LoadItemDesc();
procedure LoadItemFilter();
procedure LoadItemFilter2();
procedure SaveItemFilter();
function getSuiteHint(var idx: Integer; s: string; gender: Byte): pTClientSuiteItems;
function GetItemWhere(Item: TClientItem): Integer;
function GetObjs(nUnit, nIdx: Integer): TDirectDrawSurface;
function GetObjsEx(nUnit, nIdx: Integer; var px, py: Integer): TDirectDrawSurface;
function  GetTiles(nUnit,nIdx:Integer):TDirectDrawSurface;
function  GetSmTiles(nUnit,nIdx:Integer):TDirectDrawSurface;

function GetMonImg(nAppr: Integer): TWMImages;
function GetMonAction(nAppr: Integer): pTMonsterAction;
function GetJobName(nJob: Integer): string;
//procedure ClearShowItemList();
function GetItemType(ItemType: TItemType): string;
procedure LoadUserConfig(sUserName: string);
//procedure SaveUserConfig(sUserName: string);
function IsPersentHP(nMin, nMax: Integer): Boolean;
function IsPersentMP(nMin, nMax: Integer): Boolean;
function IsPersentSpc(nMin, nMax: Integer): Boolean;
function IsPersentBook(nMin, nMax: Integer): Boolean;

function IsPersentHPHero(nMin, nMax: Integer): Boolean;
function IsPersentMPHero(nMin, nMax: Integer): Boolean;
function IsPersentSpcHero(nMin, nMax: Integer): Boolean;

function GetHotKey(Modifiers, Key: Word): Cardinal;
procedure SeparateHotKey(HotKey: Cardinal; var Modifiers, Key: Word);
function HotKeyToText(HotKey: Cardinal; Localized: Boolean): string;

procedure CheckSpeedCount(Count: Integer = 2);
function GetSeriesSkillIcon(id: Integer): Integer;
procedure ResetSeriesSkillVar();
//function timeGetTime: DWORD; stdcall;
function GetTickCount: DWORD; //stdcall;

function IsDetectItem(idx: Integer): Boolean;
function IsBagItem(idx: Integer): Boolean;
function IsEquItem(idx: Integer): Boolean;
function IsStorageItem(idx: Integer): Boolean;
function IsStallItem(idx: Integer): Boolean;
function GetLevelColor(iLevel: Byte): Integer;

procedure ScreenChanged();
function ShiftYOffset(): Integer;
procedure InitScreenConfig();

function IsInMyRange(Act: TActor): Boolean;
function IsItemInMyRange(X, Y: Integer): Boolean;

function GetTitle(nItemIdx: Integer): pTClientStdItem;
procedure CopyStrToClipboard(sStr: string);
//123456
procedure LoadMapDesc();

procedure ShowMsg(Str: string);

const
  mmsyst = 'winmm.dll';
  kernel32 = 'kernel32.dll';
  HotKeyAtomPrefix = 'HotKeyManagerHotKey';
  ModName_Shift = 'Shift';
  ModName_Ctrl = 'Ctrl';
  ModName_Alt = 'Alt';
  ModName_Win = 'Win';
  VK2_SHIFT = 32;
  VK2_CONTROL = 64;
  VK2_ALT = 128;
  VK2_WIN = 256;

var
  EnglishKeyboardLayout: HKL;
  ShouldUnloadEnglishKeyboardLayout: Boolean;
  LocalModName_Shift: string = ModName_Shift;
  LocalModName_Ctrl: string = ModName_Ctrl;
  LocalModName_Alt: string = ModName_Alt;
  LocalModName_Win: string = ModName_Win;

implementation

uses
  ClMain, FState, HUtil32, cliUtil, SoundUtil,wmM2Def, wmM2Wis, wmMyImage, wmM2Zip, Clipbrd;

//function timeGetTime; external mmsyst name 'timeGetTime';
//function GetTickCount; external kernel32 name 'GetTickCount';

procedure ShowMsg(Str: string);
begin
  DScreen.AddChatBoardString(Str, clWhite, clBlack);
end;

procedure LoadWMImagesLib();
var
  i: Integer;
begin
  try
    g_WBooksImages := TUIBImages.Create;
    g_WMainUibImages := TUIBImages.Create;
    g_WMiniMapImages := TUIBImages.Create;
    g_WMainImages:= CreateWMImages(t_wmM2Def);
    g_WMain2Images:= CreateWMImages(t_wmM2Def);
    g_WMain3Images:= CreateWMImages(t_wmM2Def);
    g_WChrSelImages:= CreateWMImages(t_wmM2Def);
    g_opui:= CreateWMImages(t_wmM2Def);
    g_WEffectImg:= CreateWMImages(t_wmM2Def);
    g_WDragonImg:= CreateWMImages(t_wmM2Def);
    g_WSkeletonImg:= CreateWMImages(t_wmM2Def);
    g_cboEffect:= CreateWMImages(t_wmM2Def);
    g_cbohair:= CreateWMImages(t_wmM2Def);
    g_cbohum:= CreateWMImages(t_wmM2Def);
    g_cbohum3:= CreateWMImages(t_wmM2Def);
    g_cbohum4:= CreateWMImages(t_wmM2Def);
    g_cboHumEffect:= CreateWMImages(t_wmM2Def);
    g_cboHumEffect2:= CreateWMImages(t_wmM2Def);
    g_cboHumEffect3:= CreateWMImages(t_wmM2Def);
    g_cboweapon:= CreateWMImages(t_wmM2Def);
    g_cboweapon3:= CreateWMImages(t_wmM2Def);
    g_WMMapImages:= CreateWMImages(t_wmM2Def);
    g_StateEffect:= CreateWMImages(t_wmM2Def);
    for i := Low(g_WTilesArr) to High(g_WTilesArr) do begin
       g_WTilesArr[i]:= CreateWMImages(t_wmM2Def);
    end;
    for i := Low(g_WSmTilesArr) to High(g_WSmTilesArr) do begin
       g_WSmTilesArr[i] := CreateWMImages(t_wmM2Def);
    end;
    for i := Low(g_WObjectArr) to High(g_WObjectArr) do begin
       g_WObjectArr[i]:= CreateWMImages(t_wmM2Def);
    end;

    g_WMonImg:= CreateWMImages(t_wmM2Def);
    g_WMon2Img:= CreateWMImages(t_wmM2Def);
    g_WMon3Img:= CreateWMImages(t_wmM2Def);
    g_WMon4Img:= CreateWMImages(t_wmM2Def);
    g_WMon5Img:= CreateWMImages(t_wmM2Def);
    g_WMon6Img:= CreateWMImages(t_wmM2Def);
    g_WMon7Img:= CreateWMImages(t_wmM2Def);
    g_WMon8Img:= CreateWMImages(t_wmM2Def);
    g_WMon9Img:= CreateWMImages(t_wmM2Def);
    g_WMon10Img:= CreateWMImages(t_wmM2Def);
    g_WMon11Img:= CreateWMImages(t_wmM2Def);
    g_WMon12Img:= CreateWMImages(t_wmM2Def);
    g_WMon13Img:= CreateWMImages(t_wmM2Def);
    g_WMon14Img:= CreateWMImages(t_wmM2Def);
    g_WMon15Img:= CreateWMImages(t_wmM2Def);
    g_WMon16Img:= CreateWMImages(t_wmM2Def);
    g_WMon17Img:= CreateWMImages(t_wmM2Def);
    g_WMon18Img:= CreateWMImages(t_wmM2Def);
    g_WMon19Img:= CreateWMImages(t_wmM2Def);
    g_WMon20Img:= CreateWMImages(t_wmM2Def);
    g_WMon21Img:= CreateWMImages(t_wmM2Def);
    g_WMon22Img:= CreateWMImages(t_wmM2Def);
    g_WMon23Img:= CreateWMImages(t_wmM2Def);
    g_WMon24Img:= CreateWMImages(t_wmM2Def);
    g_WMon25Img:= CreateWMImages(t_wmM2Def);
    g_WMon26Img:= CreateWMImages(t_wmM2Def);
    g_WMon27Img:= CreateWMImages(t_wmM2Def);
    g_WMon28Img:= CreateWMImages(t_wmM2Def);
    g_WMon29Img:= CreateWMImages(t_wmM2Def);
    g_WMon30Img:= CreateWMImages(t_wmM2Def);
    g_WMon31Img:= CreateWMImages(t_wmM2Def);
    g_WMon32Img:= CreateWMImages(t_wmM2Def);
    g_WMon33Img:= CreateWMImages(t_wmM2Def);
    g_WMon34Img:= CreateWMImages(t_wmM2Def);
    g_WMon35Img:= CreateWMImages(t_wmM2Def);
    g_WMon36Img:= CreateWMImages(t_wmM2Def);
    g_WMon37Img:= CreateWMImages(t_wmM2Def);
    g_WMon38Img:= CreateWMImages(t_wmM2Def);
    g_WMon39Img:= CreateWMImages(t_wmM2Def);
    g_WMon40Img:= CreateWMImages(t_wmM2Def);
//扩展自定义怪物外观素材 Mon100wil~Mon130.wil  Development 2019-01-29
    g_WMon100Img:= CreateWMImages(t_wmM2Def);
    g_WMon101Img:= CreateWMImages(t_wmM2Def);
    g_WMon102Img:= CreateWMImages(t_wmM2Def);
    g_WMon103Img:= CreateWMImages(t_wmM2Def);
    g_WMon104Img:= CreateWMImages(t_wmM2Def);
    g_WMon105Img:= CreateWMImages(t_wmM2Def);
    g_WMon106Img:= CreateWMImages(t_wmM2Def);
    g_WMon107Img:= CreateWMImages(t_wmM2Def);
    g_WMon108Img:= CreateWMImages(t_wmM2Def);
    g_WMon109Img:= CreateWMImages(t_wmM2Def);
    g_WMon110Img:= CreateWMImages(t_wmM2Def);
    g_WMon111Img:= CreateWMImages(t_wmM2Def);
    g_WMon112Img:= CreateWMImages(t_wmM2Def);
    g_WMon113Img:= CreateWMImages(t_wmM2Def);
    g_WMon114Img:= CreateWMImages(t_wmM2Def);
    g_WMon115Img:= CreateWMImages(t_wmM2Def);
    g_WMon116Img:= CreateWMImages(t_wmM2Def);
    g_WMon117Img:= CreateWMImages(t_wmM2Def);
    g_WMon118Img:= CreateWMImages(t_wmM2Def);
    g_WMon119Img:= CreateWMImages(t_wmM2Def);
    g_WMon120Img:= CreateWMImages(t_wmM2Def);
    g_WMon121Img:= CreateWMImages(t_wmM2Def);
    g_WMon122Img:= CreateWMImages(t_wmM2Def);
    g_WMon123Img:= CreateWMImages(t_wmM2Def);
    g_WMon124Img:= CreateWMImages(t_wmM2Def);
    g_WMon125Img:= CreateWMImages(t_wmM2Def);
    g_WMon126Img:= CreateWMImages(t_wmM2Def);
    g_WMon127Img:= CreateWMImages(t_wmM2Def);
    g_WMon128Img:= CreateWMImages(t_wmM2Def);
    g_WMon129Img:= CreateWMImages(t_wmM2Def);
    g_WMon130Img:= CreateWMImages(t_wmM2Def);
///////////////////////////////////////////////////////////////////////
    g_wui:= CreateWMImages(t_wmM2Def);
    g_WHumWingImages:= CreateWMImages(t_wmM2Def);
    g_WHumEffect2:= CreateWMImages(t_wmM2Def);
    g_WHumEffect3:= CreateWMImages(t_wmM2Def);
    g_WBagItemImages:= CreateWMImages(t_wmM2Def);
    g_WBagItemImages2:= CreateWMImages(t_wmM2Def);
    g_WStateItemImages:= CreateWMImages(t_wmM2Def);
    g_WStateItemImages2:= CreateWMImages(t_wmM2Def);
    g_WDnItemImages:= CreateWMImages(t_wmM2Def);
    g_WDnItemImages2:= CreateWMImages(t_wmM2Def);
    g_WHumImgImages:= CreateWMImages(t_wmM2Def);
	  g_WHum2ImgImages:= CreateWMImages(t_wmM2Def);
    g_WHum3ImgImages:= CreateWMImages(t_wmM2Def);
//扩展自定义衣服补丁 每个文件支持48件衣服  Development 2019-02-03
    g_WHum4ImgImages:= CreateWMImages(t_wmM2Def);
    g_WHum5ImgImages:= CreateWMImages(t_wmM2Def);
    g_WHum6ImgImages:= CreateWMImages(t_wmM2Def);
    g_WHum7ImgImages:= CreateWMImages(t_wmM2Def);
    g_WHum8ImgImages:= CreateWMImages(t_wmM2Def);
    g_WHum9ImgImages:= CreateWMImages(t_wmM2Def);
//////////////////////////////////////////////////////////////////
    g_WHairImgImages:= CreateWMImages(t_wmM2Def);
    g_WHair2ImgImages:= CreateWMImages(t_wmM2Def);
    g_WWeaponImages:= CreateWMImages(t_wmM2Def);
    g_WWeapon2Images:= CreateWMImages(t_wmM2Def);
    g_WWeapon3Images:= CreateWMImages(t_wmM2Def);
//扩展自定义武器补丁 每个文件支持48件武器  Development 2019-02-03
    g_WWeapon4Images:= CreateWMImages(t_wmM2Def);
    g_WWeapon5Images:= CreateWMImages(t_wmM2Def);
    g_WWeapon6Images:= CreateWMImages(t_wmM2Def);
    g_WWeapon7Images:= CreateWMImages(t_wmM2Def);
    g_WWeapon8Images:= CreateWMImages(t_wmM2Def);
    g_WWeapon9Images:= CreateWMImages(t_wmM2Def);
//////////////////////////////////////////////////////////////////
    g_WMagIconImages:= CreateWMImages(t_wmM2Def);
    g_WMagIcon2Images:= CreateWMImages(t_wmM2Def);
    g_WNpcImgImages := CreateWMImages(t_wmM2Def);
    g_WNpc2ImgImages := CreateWMImages(t_wmM2Def);
    g_WMagicImages:= CreateWMImages(t_wmM2Def);
    g_WMagic2Images:= CreateWMImages(t_wmM2Def);
    g_WMagic3Images:= CreateWMImages(t_wmM2Def);
    g_WMagic4Images:= CreateWMImages(t_wmM2Def);
    g_WMagic5Images:= CreateWMImages(t_wmM2Def);
    g_WMagic6Images:= CreateWMImages(t_wmM2Def);
    g_WMagic7Images:= CreateWMImages(t_wmM2Def);
    g_WMagic7Images2:= CreateWMImages(t_wmM2Def);
    g_WMagic8Images:= CreateWMImages(t_wmM2Def);
    g_WMagic8Images2:= CreateWMImages(t_wmM2Def);
    g_WMagic9Images:= CreateWMImages(t_wmM2Def);
    g_WMagic10Images:= CreateWMImages(t_wmM2Def);
    g_WMainPAK := CreateWMImages(t_wmMyImage);
    g_WBigNpcImages:= CreateWMImages(t_wmM2Def); //NPC大窗口相关 2019-01-14
  except
    DebugOutStr('[Exception]: LoadWMImagesLib');
  end;
end;

procedure InitWMImagesLib(password: string);
  procedure InitializeImage(var AWMImages: TWMImages);
  var
    sFileName, sPassword: string;
    vLibType: TLibType;
  begin
    if (not AWMImages.Initialize()) and (AWMImages.FileName <> '') and (AWMImages.WILType in [t_wmM2Def, t_wmM2wis]) then
    begin
      sFileName := ChangeFileExt(AWMImages.FileName, '.wzl'); //将文件后缀修改为wzl
      vLibType := AWMImages.LibType;
      sPassword := AWMImages.Password;
      AWMImages.Finalize;
      AWMImages.Free;
      AWMImages := CreateWMImages(t_wmM2Zip);
      AWMImages.FileName := sFileName;
      AWMImages.LibType := vLibType;
      AWMImages.Password := sPassword;
      AWMImages.Initialize();
    end;
  end;
var
  Index: Integer;
  sFileName: string;
begin
  try
    password := '';
    //读取界面部分
    g_WMainUibImages.SearchPath := 'Data\ui\';
    g_WMainUibImages.SearchFileExt := '*.uib';
    g_WMainUibImages.FileName := 'Data\ui\*.uib';
    g_WMainUibImages.SearchSubDir := False;
    g_WMainUibImages.LibType := ltUseCache;
    g_WMainUibImages.Initialize;

     //读取小地图
    g_WMiniMapImages.SearchPath := 'Data\minimap\';
    g_WMiniMapImages.SearchFileExt := '*.mmap';
    g_WMiniMapImages.FileName := 'Data\minimap\*.mmap';
    g_WMiniMapImages.SearchSubDir := False;
    g_WMiniMapImages.LibType := ltUseCache;
    g_WMiniMapImages.Initialize;

    //读取卧龙 BOOK
    g_WBooksImages.SearchPath := 'Data\books\';
    g_WBooksImages.SearchFileExt := '*.uib';
    g_WBooksImages.FileName := 'Data\books\*.uib';
    g_WBooksImages.SearchSubDir := True;
    g_WBooksImages.LibType := ltUseCache;
    g_WBooksImages.Initialize;

    g_WMainImages.FileName := MAINIMAGEFILE;
    g_WMainImages.LibType := ltUseCache;
    g_WMainImages.Password := password;
    InitializeImage(g_WMainImages);

    g_WMain2Images.FileName := MAINIMAGEFILE2;
    g_WMain2Images.LibType := ltUseCache;
    g_WMain2Images.Password := password;
    InitializeImage(g_WMain2Images);

    g_WMain3Images.FileName := MAINIMAGEFILE3;
    g_WMain3Images.LibType := ltUseCache;
    g_WMain3Images.Password := password;
    InitializeImage(g_WMain3Images);

    g_WChrSelImages.FileName := CHRSELIMAGEFILE;
    g_WChrSelImages.LibType := ltUseCache;
    g_WChrSelImages.Password := password;
    InitializeImage(g_WChrSelImages);

    g_opui.FileName := NewopUIIMAGEFILE;
    g_opui.LibType := ltUseCache;
    g_opui.Password := password;
    InitializeImage(g_opui);
    g_WEffectImg.FileName := EFFECTIMAGEFILE;
    g_WEffectImg.LibType := ltUseCache;
    g_WEffectImg.Password := password;
    InitializeImage(g_WEffectImg);

    g_WDragonImg.FileName := DRAGONIMAGEFILE;
    g_WDragonImg.LibType := ltUseCache;
    g_WDragonImg.Password := password;
    InitializeImage(g_WDragonImg);

    g_WSkeletonImg.FileName := MONKULOUIMAGEFILE;
    g_WSkeletonImg.LibType := ltUseCache;
    g_WSkeletonImg.Password := password;
    InitializeImage(g_WSkeletonImg);

    g_cboEffect.FileName := cboEffectFile;
    g_cboEffect.LibType := ltUseCache;
    g_cboEffect.Password := password;
    InitializeImage(g_cboEffect);

    g_cbohair.FileName := cbohairFile;
    g_cbohair.LibType := ltUseCache;
    g_cbohair.Password := password;
    InitializeImage(g_cbohair);

    g_cbohum.FileName := cbohumFile;
    g_cbohum.LibType := ltUseCache;
    g_cbohum.Password := password;
    InitializeImage(g_cbohum);

    g_cbohum3.FileName := cbohum3File;
    g_cbohum3.LibType := ltUseCache;
    g_cbohum3.Password := password;
    InitializeImage(g_cbohum3);

    g_cbohum4.FileName := cbohum4File;
    g_cbohum4.LibType := ltUseCache;
    g_cbohum4.Password := password;
    InitializeImage(g_cbohum4);

    g_cboHumEffect.FileName := cboHumEffectFile;
    g_cboHumEffect.LibType := ltUseCache;
    g_cboHumEffect.Password := password;
    InitializeImage(g_cboHumEffect);

    g_cboHumEffect2.FileName := cboHumEffect2File;
    g_cboHumEffect2.LibType := ltUseCache;
    g_cboHumEffect2.Password := password;
    InitializeImage(g_cboHumEffect2);

    g_cboHumEffect3.FileName := cboHumEffect3File;
    g_cboHumEffect3.LibType := ltUseCache;
    g_cboHumEffect3.Password := password;
    InitializeImage(g_cboHumEffect3);

    g_cboweapon.FileName := cboweaponFile;
    g_cboweapon.LibType := ltUseCache;
    g_cboweapon.Password := password;
    InitializeImage(g_cboweapon);

    g_cboweapon3.FileName := cboweapon3File;
    g_cboweapon3.LibType := ltUseCache;
    g_cboweapon3.Password := password;
    InitializeImage(g_cboweapon3);

    g_cboEffect.FileName := cboEffectFile;
    g_cboEffect.LibType := ltUseCache;
    g_cboEffect.Password := password;
    InitializeImage(g_cboEffect);

    g_WMMapImages.FileName := MINMAPIMAGEFILE;
    g_WMMapImages.LibType := ltUseCache;
    g_WMMapImages.Password := password;
    InitializeImage(g_WMMapImages);

    g_StateEffect.FileName := STATEEFFECTFILE;
    g_StateEffect.LibType := ltUseCache;
    g_StateEffect.Password := password;
    InitializeImage(g_StateEffect);

    for Index := Low(g_WSmTilesArr) to High(g_WSmTilesArr) do begin
      if Index = 0 then sFileName:=SMLTITLESIMAGEFILE
      else sFileName:=format(SMLTITLESIMAGEFILEX,[Index+1]);
      g_WSmTilesArr[Index].FileName := sFileName;
      g_WSmTilesArr[Index].LibType := ltUseCache;
      g_WSmTilesArr[Index].Password := password;
      InitializeImage(g_WSmTilesArr[Index]);
    end;

    for Index := Low(g_WTilesArr) to High(g_WTilesArr) do begin
      if Index = 0 then sFileName:=TITLESIMAGEFILE
      else sFileName:=format(TITLESIMAGEFILEX,[Index+1]);
      g_WTilesArr[Index].FileName := sFileName;
      g_WTilesArr[Index].LibType := ltUseCache;
      g_WTilesArr[Index].Password := password;
      InitializeImage(g_WTilesArr[Index]);
    end;

    for Index := Low(g_WObjectArr) to High(g_WObjectArr) do begin
      if Index = 0 then sFileName:=OBJECTIMAGEFILE
      else sFileName:=format(OBJECTIMAGEFILE1,[Index+1]);
      g_WObjectArr[Index].FileName := sFileName;
      g_WObjectArr[Index].LibType := ltUseCache;
      g_WObjectArr[Index].Password := password;
      InitializeImage(g_WObjectArr[Index]);
    end;

    g_WMonImg.FileName := g_WMon1_IMAGEFILE;
    g_WMonImg.LibType := ltUseCache;
    g_WMonImg.Password := password;
    InitializeImage(g_WMonImg);
    
    g_WMon2Img.FileName := g_WMon2_IMAGEFILE;
    g_WMon2Img.LibType := ltUseCache;
    g_WMon2Img.Password := password;
    InitializeImage(g_WMon2Img);
	
    g_WMon3Img.FileName := g_WMon3_IMAGEFILE;
    g_WMon3Img.LibType := ltUseCache;
    g_WMon3Img.Password := password;
    InitializeImage(g_WMon3Img);
	
    g_WMon4Img.FileName := g_WMon4_IMAGEFILE;
    g_WMon4Img.LibType := ltUseCache;
    g_WMon4Img.Password := password;
    InitializeImage(g_WMon4Img);
	
    g_WMon5Img.FileName := g_WMon5_IMAGEFILE;
    g_WMon5Img.LibType := ltUseCache;
    g_WMon5Img.Password := password;
    InitializeImage(g_WMon5Img);
	
    g_WMon6Img.FileName := g_WMon6_IMAGEFILE;
    g_WMon6Img.LibType := ltUseCache;
    g_WMon6Img.Password := password;
    InitializeImage(g_WMon6Img);
	
    g_WMon7Img.FileName := g_WMon7_IMAGEFILE;
    g_WMon7Img.LibType := ltUseCache;
    g_WMon7Img.Password := password;
    InitializeImage(g_WMon7Img);
	
    g_WMon8Img.FileName := g_WMon8_IMAGEFILE;
    g_WMon8Img.LibType := ltUseCache;
    g_WMon8Img.Password := password;
    InitializeImage(g_WMon8Img);
	
    g_WMon9Img.FileName := g_WMon9_IMAGEFILE;
    g_WMon9Img.LibType := ltUseCache;
    g_WMon9Img.Password := password;
    InitializeImage(g_WMon9Img);
	
    g_WMon10Img.FileName := g_WMon10_IMAGEFILE;
    g_WMon10Img.LibType := ltUseCache;
    g_WMon10Img.Password := password;
    InitializeImage(g_WMon10Img);
	
    g_WMon11Img.FileName := g_WMon11_IMAGEFILE;
    g_WMon11Img.LibType := ltUseCache;
    g_WMon11Img.Password := password;
    InitializeImage(g_WMon11Img);
	
    g_WMon12Img.FileName := g_WMon12_IMAGEFILE;
    g_WMon12Img.LibType := ltUseCache;
    g_WMon12Img.Password := password;
    InitializeImage(g_WMon12Img);
	
    g_WMon13Img.FileName := g_WMon13_IMAGEFILE;
    g_WMon13Img.LibType := ltUseCache;
    g_WMon13Img.Password := password;
    InitializeImage(g_WMon13Img);
	
    g_WMon14Img.FileName := g_WMon14_IMAGEFILE;
    g_WMon14Img.LibType := ltUseCache;
    g_WMon14Img.Password := password;
    InitializeImage(g_WMon14Img);
	
    g_WMon15Img.FileName := g_WMon15_IMAGEFILE;
    g_WMon15Img.LibType := ltUseCache;
    g_WMon15Img.Password := password;
    InitializeImage(g_WMon15Img);
	
    g_WMon16Img.FileName := g_WMon16_IMAGEFILE;
    g_WMon16Img.LibType := ltUseCache;
    g_WMon16Img.Password := password;
    InitializeImage(g_WMon16Img);
	
    g_WMon17Img.FileName := g_WMon17_IMAGEFILE;
    g_WMon17Img.LibType := ltUseCache;
    g_WMon17Img.Password := password;
    InitializeImage(g_WMon17Img);
	
    g_WMon18Img.FileName := g_WMon18_IMAGEFILE;
    g_WMon18Img.LibType := ltUseCache;
    g_WMon18Img.Password := password;
    InitializeImage(g_WMon18Img);
	
    g_WMon19Img.FileName := g_WMon19_IMAGEFILE;
    g_WMon19Img.LibType := ltUseCache;
    g_WMon19Img.Password := password;
    InitializeImage(g_WMon19Img);
	
    g_WMon20Img.FileName := g_WMon20_IMAGEFILE;
    g_WMon20Img.LibType := ltUseCache;
    g_WMon20Img.Password := password;
    InitializeImage(g_WMon20Img);
	
    g_WMon21Img.FileName := g_WMon21_IMAGEFILE;
    g_WMon21Img.LibType := ltUseCache;
    g_WMon21Img.Password := password;
    InitializeImage(g_WMon21Img);
	
    g_WMon22Img.FileName := g_WMon22_IMAGEFILE;
    g_WMon22Img.LibType := ltUseCache;
    g_WMon22Img.Password := password;
    InitializeImage(g_WMon22Img);
	
    g_WMon23Img.FileName := g_WMon23_IMAGEFILE;
    g_WMon23Img.LibType := ltUseCache;
    g_WMon23Img.Password := password;
    InitializeImage(g_WMon23Img);
	
    g_WMon24Img.FileName := g_WMon24_IMAGEFILE;
    g_WMon24Img.LibType := ltUseCache;
    g_WMon24Img.Password := password;
    InitializeImage(g_WMon24Img);
	
    g_WMon25Img.FileName := g_WMon25_IMAGEFILE;
    g_WMon25Img.LibType := ltUseCache;
    g_WMon25Img.Password := password;
    InitializeImage(g_WMon25Img);
	
    g_WMon26Img.FileName := g_WMon26_IMAGEFILE;
    g_WMon26Img.LibType := ltUseCache;
    g_WMon26Img.Password := password;
    InitializeImage(g_WMon26Img);
	
    g_WMon27Img.FileName := g_WMon27_IMAGEFILE;
    g_WMon27Img.LibType := ltUseCache;
    g_WMon27Img.Password := password;
    InitializeImage(g_WMon27Img);
	
    g_WMon28Img.FileName := g_WMon28_IMAGEFILE;
    g_WMon28Img.LibType := ltUseCache;
    g_WMon28Img.Password := password;
    InitializeImage(g_WMon28Img);
	
    g_WMon29Img.FileName := g_WMon29_IMAGEFILE;
    g_WMon29Img.LibType := ltUseCache;
    g_WMon29Img.Password := password;
    InitializeImage(g_WMon29Img);
	
    g_WMon30Img.FileName := g_WMon30_IMAGEFILE;
    g_WMon30Img.LibType := ltUseCache;
    g_WMon30Img.Password := password;
    InitializeImage(g_WMon30Img);
	
    g_WMon31Img.FileName := g_WMon31_IMAGEFILE;
    g_WMon31Img.LibType := ltUseCache;
    g_WMon31Img.Password := password;
    InitializeImage(g_WMon31Img);
	
    g_WMon32Img.FileName := g_WMon32_IMAGEFILE;
    g_WMon32Img.LibType := ltUseCache;
    g_WMon32Img.Password := password;
    InitializeImage(g_WMon32Img);
	
    g_WMon33Img.FileName := g_WMon33_IMAGEFILE;
    g_WMon33Img.LibType := ltUseCache;
    g_WMon33Img.Password := password;
    InitializeImage(g_WMon33Img);

    g_WMon34Img.FileName := g_WMon34_IMAGEFILE;
    g_WMon34Img.LibType := ltUseCache;
    g_WMon34Img.Password := password;
    InitializeImage(g_WMon34Img);
	
    g_WMon35Img.FileName := g_WMon35_IMAGEFILE;
    g_WMon35Img.LibType := ltUseCache;
    g_WMon35Img.Password := password;
    InitializeImage(g_WMon35Img);
	
    g_WMon36Img.FileName := g_WMon36_IMAGEFILE;
    g_WMon36Img.LibType := ltUseCache;
    g_WMon36Img.Password := password;
    InitializeImage(g_WMon36Img);
	
    g_WMon37Img.FileName := g_WMon37_IMAGEFILE;
    g_WMon37Img.LibType := ltUseCache;
    g_WMon37Img.Password := password;
    InitializeImage(g_WMon37Img);
	
    g_WMon38Img.FileName := g_WMon38_IMAGEFILE;
    g_WMon38Img.LibType := ltUseCache;
    g_WMon38Img.Password := password;
    InitializeImage(g_WMon38Img);
	
    g_WMon39Img.FileName := g_WMon39_IMAGEFILE;
    g_WMon39Img.LibType := ltUseCache;
    g_WMon39Img.Password := password;
    InitializeImage(g_WMon39Img);
	
    g_WMon40Img.FileName := g_WMon40_IMAGEFILE;
    g_WMon40Img.LibType := ltUseCache;
    g_WMon40Img.Password := password;
    InitializeImage(g_WMon40Img);

//扩展自定义怪物外观素材 Mon100wil~Mon130.wil  Development 2019-01-29
    g_WMon100Img.FileName := g_WMon100_IMAGEFILE;
    g_WMon100Img.LibType := ltUseCache;
    g_WMon100Img.Password := password;
    InitializeImage(g_WMon100Img);

    g_WMon101Img.FileName := g_WMon101_IMAGEFILE;
    g_WMon101Img.LibType := ltUseCache;
    g_WMon101Img.Password := password;
    InitializeImage(g_WMon101Img);

    g_WMon102Img.FileName := g_WMon102_IMAGEFILE;
    g_WMon102Img.LibType := ltUseCache;
    g_WMon102Img.Password := password;
    InitializeImage(g_WMon102Img);

    g_WMon103Img.FileName := g_WMon103_IMAGEFILE;
    g_WMon103Img.LibType := ltUseCache;
    g_WMon103Img.Password := password;
    InitializeImage(g_WMon103Img);

    g_WMon104Img.FileName := g_WMon104_IMAGEFILE;
    g_WMon104Img.LibType := ltUseCache;
    g_WMon104Img.Password := password;
    InitializeImage(g_WMon104Img);

    g_WMon105Img.FileName := g_WMon105_IMAGEFILE;
    g_WMon105Img.LibType := ltUseCache;
    g_WMon105Img.Password := password;
    InitializeImage(g_WMon105Img);

    g_WMon106Img.FileName := g_WMon106_IMAGEFILE;
    g_WMon106Img.LibType := ltUseCache;
    g_WMon106Img.Password := password;
    InitializeImage(g_WMon106Img);

    g_WMon107Img.FileName := g_WMon107_IMAGEFILE;
    g_WMon107Img.LibType := ltUseCache;
    g_WMon107Img.Password := password;
    InitializeImage(g_WMon107Img);

    g_WMon108Img.FileName := g_WMon108_IMAGEFILE;
    g_WMon108Img.LibType := ltUseCache;
    g_WMon108Img.Password := password;
    InitializeImage(g_WMon108Img);

    g_WMon109Img.FileName := g_WMon109_IMAGEFILE;
    g_WMon109Img.LibType := ltUseCache;
    g_WMon109Img.Password := password;
    InitializeImage(g_WMon109Img);

    g_WMon110Img.FileName := g_WMon110_IMAGEFILE;
    g_WMon110Img.LibType := ltUseCache;
    g_WMon110Img.Password := password;
    InitializeImage(g_WMon110Img);

    g_WMon111Img.FileName := g_WMon111_IMAGEFILE;
    g_WMon111Img.LibType := ltUseCache;
    g_WMon111Img.Password := password;
    InitializeImage(g_WMon111Img);

    g_WMon112Img.FileName := g_WMon112_IMAGEFILE;
    g_WMon112Img.LibType := ltUseCache;
    g_WMon112Img.Password := password;
    InitializeImage(g_WMon112Img);

    g_WMon113Img.FileName := g_WMon113_IMAGEFILE;
    g_WMon113Img.LibType := ltUseCache;
    g_WMon113Img.Password := password;
    InitializeImage(g_WMon113Img);

    g_WMon114Img.FileName := g_WMon114_IMAGEFILE;
    g_WMon114Img.LibType := ltUseCache;
    g_WMon114Img.Password := password;
    InitializeImage(g_WMon114Img);

    g_WMon115Img.FileName := g_WMon115_IMAGEFILE;
    g_WMon115Img.LibType := ltUseCache;
    g_WMon115Img.Password := password;
    InitializeImage(g_WMon115Img);

    g_WMon116Img.FileName := g_WMon116_IMAGEFILE;
    g_WMon116Img.LibType := ltUseCache;
    g_WMon116Img.Password := password;
    InitializeImage(g_WMon116Img);

    g_WMon117Img.FileName := g_WMon117_IMAGEFILE;
    g_WMon117Img.LibType := ltUseCache;
    g_WMon117Img.Password := password;
    InitializeImage(g_WMon117Img);

    g_WMon118Img.FileName := g_WMon118_IMAGEFILE;
    g_WMon118Img.LibType := ltUseCache;
    g_WMon118Img.Password := password;
    InitializeImage(g_WMon118Img);

    g_WMon119Img.FileName := g_WMon119_IMAGEFILE;
    g_WMon119Img.LibType := ltUseCache;
    g_WMon119Img.Password := password;
    InitializeImage(g_WMon119Img);

    g_WMon120Img.FileName := g_WMon120_IMAGEFILE;
    g_WMon120Img.LibType := ltUseCache;
    g_WMon120Img.Password := password;
    InitializeImage(g_WMon120Img);

    g_WMon121Img.FileName := g_WMon121_IMAGEFILE;
    g_WMon121Img.LibType := ltUseCache;
    g_WMon121Img.Password := password;
    InitializeImage(g_WMon121Img);

    g_WMon122Img.FileName := g_WMon122_IMAGEFILE;
    g_WMon122Img.LibType := ltUseCache;
    g_WMon122Img.Password := password;
    InitializeImage(g_WMon122Img);

    g_WMon123Img.FileName := g_WMon123_IMAGEFILE;
    g_WMon123Img.LibType := ltUseCache;
    g_WMon123Img.Password := password;
    InitializeImage(g_WMon123Img);

    g_WMon124Img.FileName := g_WMon124_IMAGEFILE;
    g_WMon124Img.LibType := ltUseCache;
    g_WMon124Img.Password := password;
    InitializeImage(g_WMon124Img);

    g_WMon125Img.FileName := g_WMon125_IMAGEFILE;
    g_WMon125Img.LibType := ltUseCache;
    g_WMon125Img.Password := password;
    InitializeImage(g_WMon125Img);

    g_WMon126Img.FileName := g_WMon126_IMAGEFILE;
    g_WMon126Img.LibType := ltUseCache;
    g_WMon126Img.Password := password;
    InitializeImage(g_WMon126Img);

    g_WMon127Img.FileName := g_WMon127_IMAGEFILE;
    g_WMon127Img.LibType := ltUseCache;
    g_WMon127Img.Password := password;
    InitializeImage(g_WMon127Img);

    g_WMon128Img.FileName := g_WMon128_IMAGEFILE;
    g_WMon128Img.LibType := ltUseCache;
    g_WMon128Img.Password := password;
    InitializeImage(g_WMon128Img);

    g_WMon129Img.FileName := g_WMon129_IMAGEFILE;
    g_WMon129Img.LibType := ltUseCache;
    g_WMon129Img.Password := password;
    InitializeImage(g_WMon129Img);

    g_WMon130Img.FileName := g_WMon130_IMAGEFILE;
    g_WMon130Img.LibType := ltUseCache;
    g_WMon130Img.Password := password;
    InitializeImage(g_WMon130Img);
///////////////////////////////////////////////////////////////////////////////


    g_wui.FileName := ui1IMAGEFILE;
    g_wui.LibType := ltUseCache;
    g_wui.Password := password;
    InitializeImage(g_wui);
    g_WHumWingImages.FileName := HUMWINGIMAGESFILE;
    g_WHumWingImages.LibType := ltUseCache;
    g_WHumWingImages.Password := password;
    InitializeImage(g_WHumWingImages);
	
    g_WHumEffect2.FileName := HUMWINGIMAGESFILE2;
    g_WHumEffect2.LibType := ltUseCache;
    g_WHumEffect2.Password := password;
    InitializeImage(g_WHumEffect2);
	
    g_WHumEffect3.FileName := HUMWINGIMAGESFILE3;
    g_WHumEffect3.LibType := ltUseCache;
    g_WHumEffect3.Password := password;
    InitializeImage(g_WHumEffect3);

    g_WBagItemImages.FileName := BAGITEMIMAGESFILE;
    g_WBagItemImages.LibType := ltUseCache;
    g_WBagItemImages.Password := password;
    InitializeImage(g_WBagItemImages);

    g_WBagItemImages2.FileName := BAGITEMIMAGESFILE2;
    g_WBagItemImages2.LibType := ltUseCache;
    g_WBagItemImages2.Password := password;
    InitializeImage(g_WBagItemImages2);
	
    g_WStateItemImages.FileName := STATEITEMIMAGESFILE;
    g_WStateItemImages.LibType := ltUseCache;
    g_WStateItemImages.Password := password;
    InitializeImage(g_WStateItemImages);
	
    g_WStateItemImages2.FileName := STATEITEMIMAGESFILE2;
    g_WStateItemImages2.LibType := ltUseCache;
    g_WStateItemImages2.Password := password;
    InitializeImage(g_WStateItemImages2);

    g_WDnItemImages.FileName := DNITEMIMAGESFILE;
    g_WDnItemImages.LibType := ltUseCache;
    g_WDnItemImages.Password := password;
    InitializeImage(g_WDnItemImages);
	
    g_WDnItemImages2.FileName := DNITEMIMAGESFILE2;
    g_WDnItemImages2.LibType := ltUseCache;
    g_WDnItemImages2.Password := password;
    InitializeImage(g_WDnItemImages2);

    g_WHumImgImages.FileName := HUMIMGIMAGESFILE;
    g_WHumImgImages.LibType := ltUseCache;
    g_WHumImgImages.Password := password;
    InitializeImage(g_WHumImgImages);
	
	  g_WHum2ImgImages.FileName := HUM2IMGIMAGESFILE;
    g_WHum2ImgImages.LibType := ltUseCache;
    g_WHum2ImgImages.Password := password;
    InitializeImage(g_WHum2ImgImages);
	
	  g_WHum3ImgImages.FileName := HUM3IMGIMAGESFILE;
    g_WHum3ImgImages.LibType := ltUseCache;
    g_WHum3ImgImages.Password := password;
    InitializeImage(g_WHum3ImgImages);
//扩展自定义衣服补丁 每个文件支持48件衣服  Development 2019-02-03
	  g_WHum4ImgImages.FileName := HUM4IMGIMAGESFILE;
    g_WHum4ImgImages.LibType := ltUseCache;
    g_WHum4ImgImages.Password := password;
    InitializeImage(g_WHum4ImgImages);

	  g_WHum5ImgImages.FileName := HUM5IMGIMAGESFILE;
    g_WHum5ImgImages.LibType := ltUseCache;
    g_WHum5ImgImages.Password := password;
    InitializeImage(g_WHum5ImgImages);

	  g_WHum6ImgImages.FileName := HUM6IMGIMAGESFILE;
    g_WHum6ImgImages.LibType := ltUseCache;
    g_WHum6ImgImages.Password := password;
    InitializeImage(g_WHum6ImgImages);

	  g_WHum7ImgImages.FileName := HUM7IMGIMAGESFILE;
    g_WHum7ImgImages.LibType := ltUseCache;
    g_WHum7ImgImages.Password := password;
    InitializeImage(g_WHum7ImgImages);

	  g_WHum8ImgImages.FileName := HUM8IMGIMAGESFILE;
    g_WHum8ImgImages.LibType := ltUseCache;
    g_WHum8ImgImages.Password := password;
    InitializeImage(g_WHum8ImgImages);

	  g_WHum9ImgImages.FileName := HUM9IMGIMAGESFILE;
    g_WHum9ImgImages.LibType := ltUseCache;
    g_WHum9ImgImages.Password := password;
    InitializeImage(g_WHum9ImgImages);
////////////////////////////////////////////////////////////
    g_WHairImgImages.FileName := HAIRIMGIMAGESFILE;
    g_WHairImgImages.LibType := ltUseCache;
    g_WHairImgImages.Password := password;
    InitializeImage(g_WHairImgImages);
	
    g_WHair2ImgImages.FileName := HAIR2IMGIMAGESFILE;
    g_WHair2ImgImages.LibType := ltUseCache;
    g_WHair2ImgImages.Password := password;
    InitializeImage(g_WHair2ImgImages);

    g_WWeaponImages.FileName := WEAPONIMAGESFILE;
    g_WWeaponImages.LibType := ltUseCache;
    g_WWeaponImages.Password := password;
    InitializeImage(g_WWeaponImages);
	
	  g_WWeapon2Images.FileName := WEAPON2IMAGESFILE;
    g_WWeapon2Images.LibType := ltUseCache;
    g_WWeapon2Images.Password := password;
    InitializeImage(g_WWeapon2Images);
	
	  g_WWeapon3Images.FileName := WEAPON3IMAGESFILE;
    g_WWeapon3Images.LibType := ltUseCache;
    g_WWeapon3Images.Password := password;
    InitializeImage(g_WWeapon3Images);
//扩展自定义武器补丁 每个文件支持48件武器  Development 2019-02-03
	  g_WWeapon4Images.FileName := WEAPON4IMAGESFILE;
    g_WWeapon4Images.LibType := ltUseCache;
    g_WWeapon4Images.Password := password;
    InitializeImage(g_WWeapon4Images);

	  g_WWeapon5Images.FileName := WEAPON5IMAGESFILE;
    g_WWeapon5Images.LibType := ltUseCache;
    g_WWeapon5Images.Password := password;
    InitializeImage(g_WWeapon5Images);

	  g_WWeapon6Images.FileName := WEAPON6IMAGESFILE;
    g_WWeapon6Images.LibType := ltUseCache;
    g_WWeapon6Images.Password := password;
    InitializeImage(g_WWeapon6Images);

	  g_WWeapon7Images.FileName := WEAPON7IMAGESFILE;
    g_WWeapon7Images.LibType := ltUseCache;
    g_WWeapon7Images.Password := password;
    InitializeImage(g_WWeapon7Images);

	  g_WWeapon8Images.FileName := WEAPON8IMAGESFILE;
    g_WWeapon8Images.LibType := ltUseCache;
    g_WWeapon8Images.Password := password;
    InitializeImage(g_WWeapon8Images);

	  g_WWeapon9Images.FileName := WEAPON9IMAGESFILE;
    g_WWeapon9Images.LibType := ltUseCache;
    g_WWeapon9Images.Password := password;
    InitializeImage(g_WWeapon9Images);
/////////////////////////////////////////////////////////////////////
    g_WMagIconImages.FileName := MAGICONIMAGESFILE;
    g_WMagIconImages.LibType := ltUseCache;
    g_WMagIconImages.Password := password;
    InitializeImage(g_WMagIconImages);
	
	  g_WMagIcon2Images.FileName := MAGICON2IMAGESFILE;
    g_WMagIcon2Images.LibType := ltUseCache;
    g_WMagIcon2Images.Password := password;
    InitializeImage(g_WMagIcon2Images);

    g_WNpcImgImages.FileName := NPCIMAGESFILE;
    g_WNpcImgImages.LibType := ltUseCache;
    g_WNpcImgImages.Password := password;
    InitializeImage(g_WNpcImgImages);
	
	  g_WNpc2ImgImages.FileName := NPC2IMAGESFILE;
    g_WNpc2ImgImages.LibType := ltUseCache;
    g_WNpc2ImgImages.Password := password;
    InitializeImage(g_WNpc2ImgImages);

    g_WMagicImages.FileName := MAGICIMAGESFILE;
    g_WMagicImages.LibType := ltUseCache;
    g_WMagicImages.Password := password;
    InitializeImage(g_WMagicImages);

	  g_WMagic2Images.FileName := MAGIC2IMAGESFILE;
    g_WMagic2Images.LibType := ltUseCache;
    g_WMagic2Images.Password := password;
    InitializeImage(g_WMagic2Images);
	
	  g_WMagic3Images.FileName := MAGIC3IMAGESFILE;
    g_WMagic3Images.LibType := ltUseCache;
    g_WMagic3Images.Password := password;
    InitializeImage(g_WMagic3Images);
	
	  g_WMagic4Images.FileName := MAGIC4IMAGESFILE;
    g_WMagic4Images.LibType := ltUseCache;
    g_WMagic4Images.Password := password;
    InitializeImage(g_WMagic4Images);
	
	  g_WMagic5Images.FileName := MAGIC5IMAGESFILE;
    g_WMagic5Images.LibType := ltUseCache;
    g_WMagic5Images.Password := password;
    InitializeImage(g_WMagic5Images);
	
	  g_WMagic6Images.FileName := MAGIC6IMAGESFILE;
    g_WMagic6Images.LibType := ltUseCache;
    g_WMagic6Images.Password := password;
    InitializeImage(g_WMagic6Images);
	
	  g_WMagic7Images.FileName := MAGIC7IMAGESFILE;
    g_WMagic7Images.LibType := ltUseCache;
    g_WMagic7Images.Password := password;
    InitializeImage(g_WMagic7Images);

	  g_WMagic7Images2.FileName := MAGIC7IMAGESFILE2;
    g_WMagic7Images2.LibType := ltUseCache;
    g_WMagic7Images2.Password := password;
    InitializeImage(g_WMagic7Images2);
	
	  g_WMagic8Images.FileName := MAGIC8IMAGESFILE;
    g_WMagic8Images.LibType := ltUseCache;
    g_WMagic8Images.Password := password;
    InitializeImage(g_WMagic8Images);

	  g_WMagic8Images2.FileName := MAGIC8IMAGESFILE2;
    g_WMagic8Images2.LibType := ltUseCache;
    g_WMagic8Images2.Password := password;
    InitializeImage(g_WMagic8Images2);
	
	  g_WMagic9Images.FileName := MAGIC9IMAGESFILE;
    g_WMagic9Images.LibType := ltUseCache;
    g_WMagic9Images.Password := password;
    InitializeImage(g_WMagic9Images);
	
	  g_WMagic10Images.FileName := MAGIC10IMAGESFILE;
    g_WMagic10Images.LibType := ltUseCache;
    g_WMagic10Images.Password := password;
    InitializeImage(g_WMagic10Images);

    g_WMainPAK.FileName := '.\Data\NewProUI.pak';
    g_WMainPAK.LibType := ltUseCache;
    g_WMainPAK.Password := password;
    InitializeImage(g_WMainPAK);

    //NPC大窗口相关 2019-01-14
    g_WBigNpcImages.FileName := NPCFACEIMAGESFILE;
    g_WBigNpcImages.LibType := ltUseCache;
    g_WBigNpcImages.Password := password;
    InitializeImage(g_WBigNpcImages);
  except
    DebugOutStr('[Exception]: InitWMImagesLib');
  end;
end;

procedure UnLoadWMImagesLib();
var
  i: Integer;
begin
  try
    for i := Low(g_WTilesArr) to High(g_WTilesArr) do begin
      if g_WTilesArr[i] <> nil then begin
        g_WTilesArr[i].Finalize;
        g_WTilesArr[i].Free;
      end;
    end;
    for i := Low(g_WSmTilesArr) to High(g_WSmTilesArr) do begin
      if g_WSmTilesArr[i] <> nil then begin
        g_WSmTilesArr[i].Finalize;
        g_WSmTilesArr[i].Free;
      end;
    end;
    for i := Low(g_WObjectArr) to High(g_WObjectArr) do begin
      if g_WObjectArr[i] <> nil then begin
        g_WObjectArr[i].Finalize;
        g_WObjectArr[i].Free;
      end;
    end;
    g_WMainImages.Finalize;
    g_WMainImages.Free;
    g_WMain2Images.Finalize;
    g_WMain2Images.Free;
    g_WMain3Images.Finalize;
    g_WMain3Images.Free;
    g_WChrSelImages.Finalize;
    g_WChrSelImages.Free;
    g_opui.Finalize;
    g_opui.Free;
    g_wui.Finalize;
    g_wui.Free;
    g_WMonImg.Finalize;
    g_WMonImg.Free;
    g_WMon2Img.Finalize;
    g_WMon2Img.Free;
    g_WMon3Img.Finalize;
    g_WMon3Img.Free;
    g_WMon4Img.Finalize;
    g_WMon4Img.Free;
    g_WMon5Img.Finalize;
    g_WMon5Img.Free;
    g_WMon6Img.Finalize;
    g_WMon6Img.Free;
    g_WMon7Img.Finalize;
    g_WMon7Img.Free;
    g_WMon8Img.Finalize;
    g_WMon8Img.Free;
    g_WMon9Img.Finalize;
    g_WMon9Img.Free;
    g_WMon10Img.Finalize;
    g_WMon10Img.Free;
    g_WMon11Img.Finalize;
    g_WMon11Img.Free;
    g_WMon12Img.Finalize;
    g_WMon12Img.Free;
    g_WMon13Img.Finalize;
    g_WMon13Img.Free;
    g_WMon14Img.Finalize;
    g_WMon14Img.Free;
    g_WMon15Img.Finalize;
    g_WMon15Img.Free;
    g_WMon16Img.Finalize;
    g_WMon16Img.Free;
    g_WMon17Img.Finalize;
    g_WMon17Img.Free;
    g_WMon18Img.Finalize;
    g_WMon18Img.Free;
    g_WMon19Img.Finalize;
    g_WMon19Img.Free;
    g_WMon20Img.Finalize;
    g_WMon20Img.Free;
    g_WMon21Img.Finalize;
    g_WMon21Img.Free;
    g_WMon22Img.Finalize;
    g_WMon22Img.Free;
    g_WMon23Img.Finalize;
    g_WMon23Img.Free;
    g_WMon24Img.Finalize;
    g_WMon24Img.Free;
    g_WMon25Img.Finalize;
    g_WMon25Img.Free;
    g_WMon26Img.Finalize;
    g_WMon26Img.Free;
    g_WMon27Img.Finalize;
    g_WMon27Img.Free;
    g_WMon28Img.Finalize;
    g_WMon28Img.Free;
    g_WMon29Img.Finalize;
    g_WMon29Img.Free;
    g_WMon30Img.Finalize;
    g_WMon30Img.Free;
    g_WEffectImg.Finalize;
    g_WEffectImg.Free;
    g_WDragonImg.Finalize;
    g_WDragonImg.Free;
    g_WSkeletonImg.Finalize;
    g_WSkeletonImg.Free;
    g_cboEffect.Finalize;
    g_cboEffect.Free;
    g_cbohair.Finalize;
    g_cbohair.Free;
    g_cbohum.Finalize;
    g_cbohum.Free;
    g_cbohum3.Finalize;
    g_cbohum3.Free;
    g_cbohum4.Finalize;
    g_cbohum4.Free;
    g_cboHumEffect.Finalize;
    g_cboHumEffect.Free;
    g_cboHumEffect2.Finalize;
    g_cboHumEffect2.Free;
    g_cboHumEffect3.Finalize;
    g_cboHumEffect3.Free;
    g_cboweapon.Finalize;
    g_cboweapon.Free;
    g_cboweapon3.Finalize;
    g_cboweapon3.Free;
    g_WMMapImages.Finalize;
    g_WMMapImages.Free;
    g_WHumWingImages.Finalize;
    g_WHumWingImages.Free;
    g_WHumEffect2.Finalize;
    g_WHumEffect2.Free;
    g_WHumEffect3.Finalize;
    g_WHumEffect3.Free;
    g_WBagItemImages.Finalize;
    g_WBagItemImages.Free;
    g_WStateItemImages.Finalize;
    g_WStateItemImages.Free;
    g_WDnItemImages.Finalize;
    g_WDnItemImages.Free;
    g_WBagItemImages2.Finalize;
    g_WBagItemImages2.Free;
    g_WStateItemImages2.Finalize;
    g_WStateItemImages2.Free;
    g_WDnItemImages2.Finalize;
    g_WDnItemImages2.Free;
    g_WHumImgImages.Finalize;
    g_WHumImgImages.Free;
    if g_WHum2ImgImages <> nil then begin
      g_WHum2ImgImages.Finalize;
      g_WHum2ImgImages.Free;
    end;
    if g_WHum3ImgImages <> nil then begin
      g_WHum3ImgImages.Finalize;
      g_WHum3ImgImages.Free;
    end;
//扩展自定义衣服补丁 每个文件支持48件衣服  Development 2019-02-03
    if g_WHum4ImgImages <> nil then begin
      g_WHum4ImgImages.Finalize;
      g_WHum4ImgImages.Free;
    end;
    if g_WHum5ImgImages <> nil then begin
      g_WHum5ImgImages.Finalize;
      g_WHum5ImgImages.Free;
    end;
    if g_WHum6ImgImages <> nil then begin
      g_WHum6ImgImages.Finalize;
      g_WHum6ImgImages.Free;
    end;
    if g_WHum7ImgImages <> nil then begin
      g_WHum7ImgImages.Finalize;
      g_WHum7ImgImages.Free;
    end;
    if g_WHum8ImgImages <> nil then begin
      g_WHum8ImgImages.Finalize;
      g_WHum8ImgImages.Free;
    end;
    if g_WHum9ImgImages <> nil then begin
      g_WHum9ImgImages.Finalize;
      g_WHum9ImgImages.Free;
    end;
/////////////////////////////////////////////////////////////////////

    g_WHairImgImages.Finalize;
    g_WHairImgImages.Free;
    g_WHair2ImgImages.Finalize;
    g_WHair2ImgImages.Free;
    g_WWeaponImages.Finalize;
    g_WWeaponImages.Free;
    if g_WWeapon2Images <> nil then begin
      g_WWeapon2Images.Finalize;
      g_WWeapon2Images.Free;
    end;
    if g_WWeapon3Images <> nil then begin
      g_WWeapon3Images.Finalize;
      g_WWeapon3Images.Free;
    end;
//扩展自定义武器补丁 每个文件支持48件武器  Development 2019-02-03
    if g_WWeapon4Images <> nil then begin
      g_WWeapon4Images.Finalize;
      g_WWeapon4Images.Free;
    end;
    if g_WWeapon5Images <> nil then begin
      g_WWeapon5Images.Finalize;
      g_WWeapon5Images.Free;
    end;
    if g_WWeapon6Images <> nil then begin
      g_WWeapon6Images.Finalize;
      g_WWeapon6Images.Free;
    end;
    if g_WWeapon7Images <> nil then begin
      g_WWeapon7Images.Finalize;
      g_WWeapon7Images.Free;
    end;
    if g_WWeapon8Images <> nil then begin
      g_WWeapon8Images.Finalize;
      g_WWeapon8Images.Free;
    end;
    if g_WWeapon9Images <> nil then begin
      g_WWeapon9Images.Finalize;
      g_WWeapon9Images.Free;
    end;
//////////////////////////////////////////////////////////////////////
    g_WMagIconImages.Finalize;
    g_WMagIconImages.Free;
    g_WMagIcon2Images.Finalize;
    g_WMagIcon2Images.Free;
    g_WNpcImgImages.Finalize;
    g_WNpcImgImages.Free;
    g_WNpc2ImgImages.Finalize;
    g_WNpc2ImgImages.Free;
    g_WMagicImages.Finalize;
    g_WMagicImages.Free;
    g_WMagic2Images.Finalize;
    g_WMagic2Images.Free;
    g_WMagic3Images.Finalize;
    g_WMagic3Images.Free;
    g_WMagic4Images.Finalize;
    g_WMagic4Images.Free;
    g_WMagic5Images.Finalize;
    g_WMagic5Images.Free;
    g_WMagic6Images.Finalize;
    g_WMagic6Images.Free;
    g_WMagic7Images.Finalize;
    g_WMagic7Images.Free;
    g_WMagic7Images2.Finalize; 
    g_WMagic7Images2.Free;
    g_WMagic8Images.Finalize;
    g_WMagic8Images.Free;
    g_WMagic8Images2.Finalize;
    g_WMagic8Images2.Free;
    g_WMagic9Images.Finalize;
    g_WMagic9Images.Free;
    g_WMagic10Images.Finalize;
    g_WMagic10Images.Free;
    g_StateEffect.Finalize;
    g_StateEffect.Free;
    g_WBooksImages.Finalize;
    g_WBooksImages.Free;
    g_WMainUibImages.Finalize;
    g_WMainUibImages.Free;
    g_WMiniMapImages.Finalize;
    g_WMiniMapImages.Free;
    g_WMainPAK.Finalize;
    g_WMainPAK.Free;
    g_WBigNpcImages.Finalize; //NPC大窗口相关 2019-01-14
    g_WBigNpcImages.Free;
  except
    DebugOutStr('[Exception]: UnLoadWMImagesLib');
  end;
end;

//释放图片 2018-12-26  Development添加
procedure FreeOldWMImagesLib();
var
  i: Integer;
begin
  try
    for i := Low(g_WTilesArr) to High(g_WTilesArr) do begin
      if g_WTilesArr[i] <> nil then begin
        g_WTilesArr[i].FreeTextureByTime;
      end;
    end;
    for i := Low(g_WSmTilesArr) to High(g_WSmTilesArr) do begin
      if g_WSmTilesArr[i] <> nil then begin
        g_WSmTilesArr[i].FreeTextureByTime;
      end;
    end;
    for i := Low(g_WObjectArr) to High(g_WObjectArr) do begin
      if g_WObjectArr[i] <> nil then begin
        g_WObjectArr[i].FreeTextureByTime;
      end;
    end;
    g_WMainImages.FreeTextureByTime;
    g_WMain2Images.FreeTextureByTime;
    g_WMain3Images.FreeTextureByTime;
    g_WChrSelImages.FreeTextureByTime;
    g_opui.FreeTextureByTime;
    g_wui.FreeTextureByTime;
    g_WMonImg.FreeTextureByTime;
    g_WMon2Img.FreeTextureByTime;
    g_WMon3Img.FreeTextureByTime;
    g_WMon4Img.FreeTextureByTime;
    g_WMon5Img.FreeTextureByTime;
    g_WMon6Img.FreeTextureByTime;
    g_WMon7Img.FreeTextureByTime;
    g_WMon8Img.FreeTextureByTime;
    g_WMon9Img.FreeTextureByTime;
    g_WMon10Img.FreeTextureByTime;
    g_WMon11Img.FreeTextureByTime;
    g_WMon12Img.FreeTextureByTime;
    g_WMon13Img.FreeTextureByTime;
    g_WMon14Img.FreeTextureByTime;
    g_WMon15Img.FreeTextureByTime;
    g_WMon16Img.FreeTextureByTime;
    g_WMon17Img.FreeTextureByTime;
    g_WMon18Img.FreeTextureByTime;
    g_WMon19Img.FreeTextureByTime;
    g_WMon20Img.FreeTextureByTime;
    g_WMon21Img.FreeTextureByTime;
    g_WMon22Img.FreeTextureByTime;
    g_WMon23Img.FreeTextureByTime;
    g_WMon24Img.FreeTextureByTime;
    g_WMon25Img.FreeTextureByTime;
    g_WMon26Img.FreeTextureByTime;
    g_WMon27Img.FreeTextureByTime;
    g_WMon28Img.FreeTextureByTime;
    g_WMon29Img.FreeTextureByTime;
    g_WMon30Img.FreeTextureByTime;
    g_WEffectImg.FreeTextureByTime;
    g_WDragonImg.FreeTextureByTime;
    g_WSkeletonImg.FreeTextureByTime;
    g_cboEffect.FreeTextureByTime;
    g_cbohair.FreeTextureByTime;
    g_cbohum.FreeTextureByTime;
    g_cbohum3.FreeTextureByTime;
    g_cbohum4.FreeTextureByTime;
    g_cboHumEffect.FreeTextureByTime;
    g_cboHumEffect2.FreeTextureByTime;
    g_cboHumEffect3.FreeTextureByTime;
    g_cboweapon.FreeTextureByTime;
    g_cboweapon3.FreeTextureByTime;
    g_WMMapImages.FreeTextureByTime;
    g_WHumWingImages.FreeTextureByTime;
    g_WHumEffect2.FreeTextureByTime;
    g_WHumEffect3.FreeTextureByTime;
    g_WBagItemImages.FreeTextureByTime;
    g_WStateItemImages.FreeTextureByTime;
    g_WDnItemImages.FreeTextureByTime;
    g_WBagItemImages2.FreeTextureByTime;
    g_WStateItemImages2.FreeTextureByTime;
    g_WDnItemImages2.FreeTextureByTime;
    g_WHumImgImages.FreeTextureByTime;
    if g_WHum2ImgImages <> nil then begin
      g_WHum2ImgImages.FreeTextureByTime;
    end;
    if g_WHum3ImgImages <> nil then begin
      g_WHum3ImgImages.FreeTextureByTime;
    end;
//扩展自定义衣服补丁 每个文件支持48件衣服  Development 2019-02-03
    if g_WHum4ImgImages <> nil then begin
      g_WHum4ImgImages.FreeTextureByTime;
    end;
    if g_WHum5ImgImages <> nil then begin
      g_WHum5ImgImages.FreeTextureByTime;
    end;
    if g_WHum6ImgImages <> nil then begin
      g_WHum6ImgImages.FreeTextureByTime;
    end;
    if g_WHum7ImgImages <> nil then begin
      g_WHum7ImgImages.FreeTextureByTime;
    end;
    if g_WHum8ImgImages <> nil then begin
      g_WHum8ImgImages.FreeTextureByTime;
    end;
    if g_WHum9ImgImages <> nil then begin
      g_WHum9ImgImages.FreeTextureByTime;
    end;
//////////////////////////////////////////////////////////////////
    g_WHairImgImages.FreeTextureByTime;
    g_WHair2ImgImages.FreeTextureByTime;
    g_WWeaponImages.FreeTextureByTime;
    if g_WWeapon2Images <> nil then begin
      g_WWeapon2Images.FreeTextureByTime;
    end;
    if g_WWeapon3Images <> nil then begin
      g_WWeapon3Images.FreeTextureByTime;
    end;
//扩展自定义武器补丁 每个文件支持48件武器  Development 2019-02-03
    if g_WWeapon4Images <> nil then begin
      g_WWeapon4Images.FreeTextureByTime;
    end;
    if g_WWeapon5Images <> nil then begin
      g_WWeapon5Images.FreeTextureByTime;
    end;
     if g_WWeapon6Images <> nil then begin
      g_WWeapon6Images.FreeTextureByTime;
    end;
    if g_WWeapon7Images <> nil then begin
      g_WWeapon7Images.FreeTextureByTime;
    end;
    if g_WWeapon8Images <> nil then begin
      g_WWeapon8Images.FreeTextureByTime;
    end;
    if g_WWeapon9Images <> nil then begin
      g_WWeapon9Images.FreeTextureByTime;
    end;
///////////////////////////////////////////////////////////////////    
    g_WMagIconImages.FreeTextureByTime;
    g_WMagIcon2Images.FreeTextureByTime;
    g_WNpcImgImages.FreeTextureByTime;
    g_WNpc2ImgImages.FreeTextureByTime;
    g_WMagicImages.FreeTextureByTime;
    g_WMagic2Images.FreeTextureByTime;
    g_WMagic3Images.FreeTextureByTime;
    g_WMagic4Images.FreeTextureByTime;
    g_WMagic5Images.FreeTextureByTime;
    g_WMagic6Images.FreeTextureByTime;
    g_WMagic7Images.FreeTextureByTime;
    g_WMagic7Images2.FreeTextureByTime;
    g_WMagic8Images.FreeTextureByTime;
    g_WMagic8Images2.FreeTextureByTime;
    g_WMagic9Images.FreeTextureByTime;
    g_WMagic10Images.FreeTextureByTime;
    g_StateEffect.FreeTextureByTime;
    g_WBooksImages.FreeTextureByTime;
    g_WMainUibImages.FreeTextureByTime;
    g_WMiniMapImages.FreeTextureByTime;
    g_WMainPAK.FreeTextureByTime;
    g_WBigNpcImages.FreeTextureByTime; //NPC大窗口相关 2019-01-14
  except
    DebugOutStr('[Exception]: FreeOldWMImagesLib');
  end;
end;

//清理图像 2018-12-26 Development添加
procedure ClearWMImagesLib();
var
  i: Integer;
begin
  try
    for i := Low(g_WTilesArr) to High(g_WTilesArr) do begin
      if g_WTilesArr[i] <> nil then begin
        g_WTilesArr[i].FreeTexture;
      end;
    end;
    for i := Low(g_WSmTilesArr) to High(g_WSmTilesArr) do begin
      if g_WSmTilesArr[i] <> nil then begin
        g_WSmTilesArr[i].FreeTexture;
      end;
    end;
    for i := Low(g_WObjectArr) to High(g_WObjectArr) do begin
      if g_WObjectArr[i] <> nil then begin
        g_WObjectArr[i].FreeTexture;
      end;
    end;
    g_WMainImages.FreeTexture;
    g_WMain2Images.FreeTexture;
    g_WMain3Images.FreeTexture;
    g_WChrSelImages.FreeTexture;
    g_opui.FreeTexture;
    g_wui.FreeTexture;
    g_WMonImg.FreeTexture;
    g_WMon2Img.FreeTexture;
    g_WMon3Img.FreeTexture;
    g_WMon4Img.FreeTexture;
    g_WMon5Img.FreeTexture;
    g_WMon6Img.FreeTexture;
    g_WMon7Img.FreeTexture;
    g_WMon8Img.FreeTexture;
    g_WMon9Img.FreeTexture;
    g_WMon10Img.FreeTexture;
    g_WMon11Img.FreeTexture;
    g_WMon12Img.FreeTexture;
    g_WMon13Img.FreeTexture;
    g_WMon14Img.FreeTexture;
    g_WMon15Img.FreeTexture;
    g_WMon16Img.FreeTexture;
    g_WMon17Img.FreeTexture;
    g_WMon18Img.FreeTexture;
    g_WMon19Img.FreeTexture;
    g_WMon20Img.FreeTexture;
    g_WMon21Img.FreeTexture;
    g_WMon22Img.FreeTexture;
    g_WMon23Img.FreeTexture;
    g_WMon24Img.FreeTexture;
    g_WMon25Img.FreeTexture;
    g_WMon26Img.FreeTexture;
    g_WMon27Img.FreeTexture;
    g_WMon28Img.FreeTexture;
    g_WMon29Img.FreeTexture;
    g_WMon30Img.FreeTexture;
    g_WEffectImg.FreeTexture;
    g_WDragonImg.FreeTexture;
    g_WSkeletonImg.FreeTexture;
    g_cboEffect.FreeTexture;
    g_cbohair.FreeTexture;
    g_cbohum.FreeTexture;
    g_cbohum3.FreeTexture;
    g_cbohum4.FreeTexture;
    g_cboHumEffect.FreeTexture;
    g_cboHumEffect2.FreeTexture;
    g_cboHumEffect3.FreeTexture;
    g_cboweapon.FreeTexture;
    g_cboweapon3.FreeTexture;
    g_WMMapImages.FreeTexture;
    g_WHumWingImages.FreeTexture;
    g_WHumEffect2.FreeTexture;
    g_WHumEffect3.FreeTexture;
    g_WBagItemImages.FreeTexture;
    g_WStateItemImages.FreeTexture;
    g_WDnItemImages.FreeTexture;
    g_WBagItemImages2.FreeTexture;
    g_WStateItemImages2.FreeTexture;
    g_WDnItemImages2.FreeTexture;
    g_WHumImgImages.FreeTexture;
    if g_WHum2ImgImages <> nil then begin
      g_WHum2ImgImages.FreeTexture;
    end;
    if g_WHum3ImgImages <> nil then begin
      g_WHum3ImgImages.FreeTexture;
    end;
    if g_WHum4ImgImages <> nil then begin
      g_WHum4ImgImages.FreeTexture;
    end;
    if g_WHum5ImgImages <> nil then begin
      g_WHum5ImgImages.FreeTexture;
    end;
    if g_WHum6ImgImages <> nil then begin
      g_WHum6ImgImages.FreeTexture;
    end;
    g_WHairImgImages.FreeTexture;
    g_WHair2ImgImages.FreeTexture;
    g_WWeaponImages.FreeTexture;
    if g_WWeapon2Images <> nil then begin
      g_WWeapon2Images.FreeTexture;
    end;
    if g_WWeapon3Images <> nil then begin
      g_WWeapon3Images.FreeTexture;
    end;
    g_WMagIconImages.FreeTexture;
    g_WMagIcon2Images.FreeTexture;
    g_WNpcImgImages.FreeTexture;
    g_WNpc2ImgImages.FreeTexture;
    g_WMagicImages.FreeTexture;
    g_WMagic2Images.FreeTexture;
    g_WMagic3Images.FreeTexture;
    g_WMagic4Images.FreeTexture;
    g_WMagic5Images.FreeTexture;
    g_WMagic6Images.FreeTexture;
    g_WMagic7Images.FreeTexture;
    g_WMagic7Images2.FreeTexture;
    g_WMagic8Images.FreeTexture;
    g_WMagic8Images2.FreeTexture;
    g_WMagic9Images.FreeTexture;
    g_WMagic10Images.FreeTexture;
    g_StateEffect.FreeTexture;
    g_WBooksImages.FreeTexture;
    g_WMainUibImages.FreeTexture;
    g_WMiniMapImages.FreeTexture;
    g_WMainPAK.FreeTexture;
  except
    DebugOutStr('[Exception]: ClearWMImagesLib');
  end;
end;


procedure LoadMapDesc();
var
  i: Integer;
  szFileName, szLine: string;
  xsl: TStringList;
  szMapTitle, szPointX, szPointY, szPlaceName, szColor, szFullMap: string;
  nPointX, nPointY, nFullMap: Integer;
  nColor: TColor;
  pMapDescInfo: pTMapDescInfo;
begin
  szFileName := '.\data\MapDesc2.dat';
  if FileExists(szFileName) then begin
    xsl := TStringList.Create;
    xsl.LoadFromFile(szFileName);
    for i := 0 to xsl.Count - 1 do begin
      szLine := xsl[i];
      if (szLine = '') or (szLine[1] = ';') then
        Continue;
      szLine := GetValidStr3(szLine, szMapTitle, [',']);
      szLine := GetValidStr3(szLine, szPointX, [',']);
      szLine := GetValidStr3(szLine, szPointY, [',']);
      szLine := GetValidStr3(szLine, szPlaceName, [',']);
      szLine := GetValidStr3(szLine, szColor, [',']);
      szLine := GetValidStr3(szLine, szFullMap, [',']);
      nPointX := Str_ToInt(szPointX, -1);
      nPointY := Str_ToInt(szPointY, -1);
      nColor := StrToInt(szColor);
      nFullMap := Str_ToInt(szFullMap, -1);
      if (szPlaceName <> '') and (szMapTitle <> '') and (nPointX >= 0) and (nPointY >= 0) and (nFullMap >= 0) then begin
        New(pMapDescInfo);
        pMapDescInfo.szMapTitle := szMapTitle;
        pMapDescInfo.szPlaceName := szPlaceName;
        pMapDescInfo.nPointX := nPointX;
        pMapDescInfo.nPointY := nPointY;
        pMapDescInfo.nColor := nColor;
        pMapDescInfo.nFullMap := nFullMap;
        //DebugOutStr(format('%.8x', [pMapDescInfo.nColor]));
        g_xMapDescList.AddObject(szMapTitle, TObject(pMapDescInfo));
      end;
    end;
    xsl.Free;
  end;
end;

function GetTickCount: DWORD; // external kernel32 name 'GetTickCount';
var
  li: TLargeInteger;
begin
  //Result := g_tTime;
  //if g_tTime = 0 then
  Result := Windows.GetTickCount();
  //Result := timeGetTime;
end;

function IsDetectItem(idx: Integer): Boolean;
begin
  Result := idx = DETECT_MIIDX_OFFSET;
end;

function IsBagItem(idx: Integer): Boolean;
begin
  Result := idx in [6..MAXBAGITEM - 1];
end;

function IsEquItem(idx: Integer): Boolean;
var sel:Integer;
begin
    Result := False;
    if  idx < 0 then
    begin
      sel := -(idx+1);
      Result :=sel in [0..U_FASHION];
    end;

end;

function IsStorageItem(idx: Integer): Boolean;
begin
  Result := (idx >= SAVE_MIIDX_OFFSET) and (idx < SAVE_MIIDX_OFFSET + 46);
end;

function IsStallItem(idx: Integer): Boolean;
begin
  Result := (idx >= STALL_MIIDX_OFFSET) and (idx < STALL_MIIDX_OFFSET + 10);
end;

procedure ResetSeriesSkillVar();
begin
  g_nCurrentMagic := 888;
  g_nCurrentMagic2 := 888;
  g_SeriesSkillStep := 0;
  g_SeriesSkillFire := False;
  g_SeriesSkillFire_100 := False;
  g_SeriesSkillReady := False;
  g_NextSeriesSkill := False;
  FillChar(g_VenationInfos, SizeOf(g_VenationInfos), 0);
  FillChar(g_TempSeriesSkillArr, SizeOf(g_TempSeriesSkillArr), 0);
  FillChar(g_HTempSeriesSkillArr, SizeOf(g_HTempSeriesSkillArr), 0);
  FillChar(g_SeriesSkillArr, SizeOf(g_SeriesSkillArr), 0);
end;

function GetSeriesSkillIcon(id: Integer): Integer;
begin
  Result := -1;
  case id of
    100: Result := 950;
    101: Result := 952;
    102: Result := 956;
    103: Result := 954;

    104: Result := 942;
    105: Result := 946;
    106: Result := 940;
    107: Result := 944;

    108: Result := 934;
    109: Result := 936;
    110: Result := 932;
    111: Result := 930;
    112: Result := 944;
  end;
end;

procedure CheckSpeedCount(Count: Integer);
begin
  Inc(g_dwCheckCount);
  if g_dwCheckCount > Count then begin
    g_dwCheckCount := 0;
    //g_ModuleDetect.FCheckTick := 0;
  end;
end;

function IsExtendedKey(Key: Word): Boolean;
begin
  Result := ((Key >= _VK_BROWSER_BACK) and (Key <= _VK_LAUNCH_APP2));
end;

function GetHotKey(Modifiers, Key: Word): Cardinal;
var
  HK: Cardinal;
begin
  HK := 0;
  if (Modifiers and MOD_ALT) <> 0 then
    Inc(HK, VK2_ALT);
  if (Modifiers and MOD_CONTROL) <> 0 then
    Inc(HK, VK2_CONTROL);
  if (Modifiers and MOD_SHIFT) <> 0 then
    Inc(HK, VK2_SHIFT);
  if (Modifiers and MOD_WIN) <> 0 then
    Inc(HK, VK2_WIN);
  HK := HK shl 8;
  Inc(HK, Key);
  Result := HK;
end;

function HotKeyToText(HotKey: Cardinal; Localized: Boolean): string;

  function GetExtendedVKName(Key: Word): string;
  begin
    case Key of
      _VK_BROWSER_BACK: Result := NAME_VK_BROWSER_BACK;
      _VK_BROWSER_FORWARD: Result := NAME_VK_BROWSER_FORWARD;
      _VK_BROWSER_REFRESH: Result := NAME_VK_BROWSER_REFRESH;
      _VK_BROWSER_STOP: Result := NAME_VK_BROWSER_STOP;
      _VK_BROWSER_SEARCH: Result := NAME_VK_BROWSER_SEARCH;
      _VK_BROWSER_FAVORITES: Result := NAME_VK_BROWSER_FAVORITES;
      _VK_BROWSER_HOME: Result := NAME_VK_BROWSER_HOME;
      _VK_VOLUME_MUTE: Result := NAME_VK_VOLUME_MUTE;
      _VK_VOLUME_DOWN: Result := NAME_VK_VOLUME_DOWN;
      _VK_VOLUME_UP: Result := NAME_VK_VOLUME_UP;
      _VK_MEDIA_NEXT_TRACK: Result := NAME_VK_MEDIA_NEXT_TRACK;
      _VK_MEDIA_PREV_TRACK: Result := NAME_VK_MEDIA_PREV_TRACK;
      _VK_MEDIA_STOP: Result := NAME_VK_MEDIA_STOP;
      _VK_MEDIA_PLAY_PAUSE: Result := NAME_VK_MEDIA_PLAY_PAUSE;
      _VK_LAUNCH_MAIL: Result := NAME_VK_LAUNCH_MAIL;
      _VK_LAUNCH_MEDIA_SELECT: Result := NAME_VK_LAUNCH_MEDIA_SELECT;
      _VK_LAUNCH_APP1: Result := NAME_VK_LAUNCH_APP1;
      _VK_LAUNCH_APP2: Result := NAME_VK_LAUNCH_APP2;
    else
      Result := '';
    end;
  end;

  function GetModifierNames: string;
  var
    s: string;
  begin
    s := '';
    if Localized then begin
      if (HotKey and $4000) <> 0 then // scCtrl
        s := s + LocalModName_Ctrl + '+';
      if (HotKey and $2000) <> 0 then // scShift
        s := s + LocalModName_Shift + '+';
      if (HotKey and $8000) <> 0 then // scAlt
        s := s + LocalModName_Alt + '+';
      if (HotKey and $10000) <> 0 then
        s := s + LocalModName_Win + '+';
    end
    else begin
      if (HotKey and $4000) <> 0 then // scCtrl
        s := s + ModName_Ctrl + '+';
      if (HotKey and $2000) <> 0 then // scShift
        s := s + ModName_Shift + '+';
      if (HotKey and $8000) <> 0 then // scAlt
        s := s + ModName_Alt + '+';
      if (HotKey and $10000) <> 0 then
        s := s + ModName_Win + '+';
    end;
    Result := s;
  end;

  function GetVKName(Special: Boolean): string;
  var
    scanCode: Cardinal;
    KeyName: array[0..255] of Char;
    oldkl: HKL;
    Modifiers, Key: Word;
  begin
    Result := '';
    if Localized then {// Local language key names}  begin
      if Special then
        scanCode := (MapVirtualKey(Byte(HotKey), 0) shl 16) or (1 shl 24)
      else
        scanCode := (MapVirtualKey(Byte(HotKey), 0) shl 16);
      if scanCode <> 0 then begin
        GetKeyNameText(scanCode, KeyName, SizeOf(KeyName));
        Result := KeyName;
      end;
    end
    else {// English key names}  begin
      if Special then
        scanCode := (MapVirtualKeyEx(Byte(HotKey), 0, EnglishKeyboardLayout) shl 16) or (1 shl 24)
      else
        scanCode := (MapVirtualKeyEx(Byte(HotKey), 0, EnglishKeyboardLayout) shl 16);
      if scanCode <> 0 then begin
        oldkl := GetKeyboardLayout(0);
        if oldkl <> EnglishKeyboardLayout then
          ActivateKeyboardLayout(EnglishKeyboardLayout, 0); // Set English kbd. layout
        GetKeyNameText(scanCode, KeyName, SizeOf(KeyName));
        Result := KeyName;
        if oldkl <> EnglishKeyboardLayout then begin
          if ShouldUnloadEnglishKeyboardLayout then
            UnloadKeyboardLayout(EnglishKeyboardLayout); // Restore prev. kbd. layout
          ActivateKeyboardLayout(oldkl, 0);
        end;
      end;
    end;

    if Length(Result) <= 1 then begin
      // Try the internally defined names
      SeparateHotKey(HotKey, Modifiers, Key);
      if IsExtendedKey(Key) then
        Result := GetExtendedVKName(Key);
    end;
  end;

var
  KeyName: string;
begin
  case Byte(HotKey) of
    // PgUp, PgDn, End, Home, Left, Up, Right, Down, Ins, Del
    $21..$28, $2D, $2E: KeyName := GetVKName(True);
  else
    KeyName := GetVKName(False);
  end;
  Result := GetModifierNames + KeyName;
end;

procedure SeparateHotKey(HotKey: Cardinal; var Modifiers, Key: Word);
var
  Virtuals: Integer;
  v: Word;
  X: Word;
begin
  Key := Byte(HotKey);
  X := HotKey shr 8;
  Virtuals := X;
  v := 0;
  if (Virtuals and VK2_WIN) <> 0 then
    Inc(v, MOD_WIN);
  if (Virtuals and VK2_ALT) <> 0 then
    Inc(v, MOD_ALT);
  if (Virtuals and VK2_CONTROL) <> 0 then
    Inc(v, MOD_CONTROL);
  if (Virtuals and VK2_SHIFT) <> 0 then
    Inc(v, MOD_SHIFT);
  Modifiers := v;
end;

function IsPersentHP(nMin, nMax: Integer): Boolean;
begin
  Result := False;
  if nMax <> 0 then
    Result := (Round((nMin / nMax) * 100) < g_gnProtectPercent[0]) {or (nMax - nMin > 1500)};
end;

function IsPersentMP(nMin, nMax: Integer): Boolean;
begin
  Result := False;
  if nMax <> 0 then
    Result := (Round((nMin / nMax) * 100) < g_gnProtectPercent[1]) {or (nMax - nMin > 1500)};
end;

function IsPersentSpc(nMin, nMax: Integer): Boolean;
begin
  Result := False;
  if nMax <> 0 then
    Result := (Round((nMin / nMax) * 100) < g_gnProtectPercent[3]) {or (nMax - nMin > 6000)};
end;

function IsPersentBook(nMin, nMax: Integer): Boolean;
begin
  Result := False;
  if nMax <> 0 then
    Result := (Round((nMin / nMax) * 100) < g_gnProtectPercent[5]) {or (nMax - nMin > 6000)};
end;

function IsPersentHPHero(nMin, nMax: Integer): Boolean;
begin
  Result := False;
  if nMax <> 0 then
    Result := (Round((nMin / nMax) * 100) < g_gnProtectPercent[7]) {or (nMax - nMin > 1500)};
end;

function IsPersentMPHero(nMin, nMax: Integer): Boolean;
begin
  Result := False;
  if nMax <> 0 then
    Result := (Round((nMin / nMax) * 100) < g_gnProtectPercent[8]) {or (nMax - nMin > 1500)};
end;

function IsPersentSpcHero(nMin, nMax: Integer): Boolean;
begin
  Result := False;
  if nMax <> 0 then
    Result := (Round((nMin / nMax) * 100) < g_gnProtectPercent[9]) {or (nMax - nMin > 6000)};
end;


//取地图图库
function GetObjs (nUnit,nIdx:Integer):TDirectDrawSurface;
begin
  Result:=nil;
  if (nUnit < Low(g_WObjectArr)) or (nUnit > High(g_WObjectArr)) then nUnit:=0;
  if g_WObjectArr[nUnit] <> nil then
  Result:=g_WObjectArr[nUnit].Images[nIdx];
end;
//取地图图库
function  GetObjsEx (nUnit,nIdx:Integer; var px, py: integer): TDirectDrawSurface;
begin
  Result:=nil;
  if (nUnit < Low(g_WObjectArr)) or (nUnit > High(g_WObjectArr)) then nUnit:=0;
  if g_WObjectArr[nUnit] <> nil then
  Result:=g_WObjectArr[nUnit].GetCachedImage(nIdx,px,py);
end;

function GetTiles (nUnit,nIdx:Integer):TDirectDrawSurface;
begin
  Result:=nil;
  if (nUnit < Low(g_WTilesArr)) or (nUnit > High(g_WTilesArr)) then nUnit:=0;
  if g_WTilesArr[nUnit] <> nil then
  Result:=g_WTilesArr[nUnit].Images[nIdx];
end;

function GetSmTiles (nUnit,nIdx:Integer):TDirectDrawSurface;
begin
  Result:=nil;
  if (nUnit < Low(g_WSmTilesArr)) or (nUnit > High(g_WSmTilesArr)) then nUnit:=0;
  if g_WSmTilesArr[nUnit] <> nil then
  Result:=g_WSmTilesArr[nUnit].Images[nIdx];
end;





function GetMonImg(nAppr: Integer): TWMImages;
var
  WMImage: TWMImages;
begin
  Result := g_WMonImg;
  if nAppr < 10000 then begin  //怪物Appr外观值最大9999  Development 分析
    case (nAppr div 10) of  //每个Mon单元支持10个怪物  Development 分析
      0: Result := g_WMonImg;
      1: Result := g_WMon2Img;
      2: Result := g_WMon3Img;
      3: Result := g_WMon4Img;
      4: Result := g_WMon5Img;
      5: Result := g_WMon6Img;
      6: Result := g_WMon7Img;
      7: Result := g_WMon8Img;
      8: Result := g_WMon9Img;
      9: Result := g_WMon10Img;
      10: Result := g_WMon11Img;
      11: Result := g_WMon12Img;
      12: Result := g_WMon13Img;
      13: Result := g_WMon14Img;
      14: Result := g_WMon15Img;
      15: Result := g_WMon16Img;
      16: Result := g_WMon17Img;
      17: Result := g_WMon18Img;
      18: Result := g_WMon19Img;
      19: Result := g_WMon20Img;
      20: Result := g_WMon21Img;
      21: Result := g_WMon22Img;
      22: Result := g_WMon23Img;
      23: Result := g_WMon24Img;
      24: Result := g_WMon25Img;
      25: Result := g_WMon26Img;
      26: Result := g_WMon27Img;
      27: Result := g_WMon28Img;
      28: Result := g_WMon29Img;
      29: Result := g_WMon30Img;
      30: Result := g_WMon31Img;
      31: Result := g_WMon32Img;
      32: Result := g_WMon33Img;
      33: Result := g_WMon34Img;
      34: Result := g_WMon35Img;
      35: Result := g_WMon36Img;
      36: Result := g_WMon37Img;
      37: Result := g_WMon38Img;
      38: Result := g_WMon39Img;
      39: Result := g_WMon40Img;

      70: begin
          case (nAppr mod 100) of
            0..2: Result := g_WSkeletonImg;
          else
            Result := g_WMon28Img;
          end;
        end;
      80: Result := g_WDragonImg;
      81: Result := g_WMon36Img;
      82: Result := g_WMon36Img;
      90: begin
          case nAppr of
            904: Result := g_WMon34Img;
            905: Result := g_WMon34Img;
            906: Result := g_WMon34Img;
          else
            Result := g_WEffectImg;
          end;
        end;
//扩展自定义怪物外观素材 Mon100wil~Mon130.wil  Development 2019-01-29
      99: Result := g_WMon100Img;
      100: Result := g_WMon101Img;
      101: Result := g_WMon102Img;
      102: Result := g_WMon103Img;
      103: Result := g_WMon104Img;
      104: Result := g_WMon105Img;
      105: Result := g_WMon106Img;
      106: Result := g_WMon107Img;
      107: Result := g_WMon108Img;
      108: Result := g_WMon109Img;
      109: Result := g_WMon110Img;
      110: Result := g_WMon111Img;
      111: Result := g_WMon112Img;
      112: Result := g_WMon113Img;
      113: Result := g_WMon114Img;
      114: Result := g_WMon115Img;
      115: Result := g_WMon116Img;
      116: Result := g_WMon117Img;
      117: Result := g_WMon118Img;
      118: Result := g_WMon119Img;
      119: Result := g_WMon120Img;
      120: Result := g_WMon121Img;
      121: Result := g_WMon122Img;
      122: Result := g_WMon123Img;
      123: Result := g_WMon124Img;
      124: Result := g_WMon125Img;
      125: Result := g_WMon126Img;
      126: Result := g_WMon127Img;
      127: Result := g_WMon128Img;
      128: Result := g_WMon129Img;
      129: Result := g_WMon130Img;
    end;
  end; // else Result := GetMonImgEx(nAppr);
end;

function GetMonAction(nAppr: Integer): pTMonsterAction;
var
  FileStream: TFileStream;
  sFileName: string;
  MonsterAction: TMonsterAction;
begin
  Result := nil;
  sFileName := Format(MONPMFILE, [nAppr]);
  if FileExists(sFileName) then begin
    FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
    FileStream.Read(MonsterAction, SizeOf(MonsterAction));
    New(Result);
    Result^ := MonsterAction;
    FileStream.Free;
  end;
end;

//取得职业名称
//0 武士
//1 魔法师
//2 道士

function GetJobName(nJob: Integer): string;
begin
  Result := '';
  case nJob of
    0: Result := g_sWarriorName;
    1: Result := g_sWizardName;
    2: Result := g_sTaoistName;
  else begin
      Result := g_sUnKnowName;
    end;
  end;
end;

function GetItemType(ItemType: TItemType): string;
begin
  case ItemType of //
    i_HPDurg: Result := '金创药';
    i_MPDurg: Result := '魔法药';
    i_HPMPDurg: Result := '高级药';
    i_OtherDurg: Result := '其它药品';
    i_Weapon: Result := '武器';
    i_Dress: Result := '衣服';
    i_Helmet: Result := '头盔';
    i_Necklace: Result := '项链';
    i_Armring: Result := '手镯';
    i_Ring: Result := '戒指';
    i_Belt: Result := '腰带';
    i_Boots: Result := '鞋子';
    i_Charm: Result := '宝石';
    i_Book: Result := '技能书';
    i_PosionDurg: Result := '毒药';
    i_UseItem: Result := '消耗品';
    i_Scroll: Result := '卷类';
    i_Stone: Result := '矿石';
    i_Gold: Result := '金币';
    i_Other: Result := '其它';
  end;
end;

function GetItemShowFilter(sItemName: string): Boolean;
var
  i: Integer;
begin
  Result := g_ShowItemList.IndexOf(sItemName) > -1;
end;

procedure LoadUserConfig(sUserName: string);
var
  ShowItem: pTShowItem;
  ini, ini2: TIniFile;
  sFileName: string;
  Strings: TStringList;
  i, no: Integer;
  sItemName, sLineText: string;
  sType, sPickup, sShow, sFColor, sBColor: string;
  sn, so: string;
begin
  sFileName := '.\Config\' + g_sServerName + '.' + sUserName + '.Set';

  ini := TIniFile.Create(sFileName);
  //base
  g_gcGeneral[0] := ini.ReadBool('Basic', 'ShowActorName', g_gcGeneral[0]);
  g_gcGeneral[1] := ini.ReadBool('Basic', 'DuraWarning', g_gcGeneral[1]);
  g_gcGeneral[2] := ini.ReadBool('Basic', 'AutoAttack', g_gcGeneral[2]);
  g_gcGeneral[3] := ini.ReadBool('Basic', 'ShowExpFilter', g_gcGeneral[3]);
  g_MaxExpFilter := ini.ReadInteger('Basic', 'ShowExpFilterMax', g_MaxExpFilter);
  g_gcGeneral[4] := ini.ReadBool('Basic', 'ShowDropItems', g_gcGeneral[4]);
  g_gcGeneral[5] := ini.ReadBool('Basic', 'ShowDropItemsFilter', g_gcGeneral[5]);
  g_gcGeneral[6] := ini.ReadBool('Basic', 'ShowHumanWing', g_gcGeneral[6]);

  g_boAutoPickUp := ini.ReadBool('Basic', 'AutoPickUp', g_boAutoPickUp);
  g_gcGeneral[7] := ini.ReadBool('Basic', 'AutoPickUpFilter', g_gcGeneral[7]);
  g_boPickUpAll := ini.ReadBool('Basic', 'PickUpAllItem', g_boPickUpAll);

  g_gcGeneral[8] := ini.ReadBool('Basic', 'HideDeathBody', g_gcGeneral[8]);
  g_gcGeneral[9] := ini.ReadBool('Basic', 'AutoFixItem', g_gcGeneral[9]);
  g_gcGeneral[10] := ini.ReadBool('Basic', 'ShakeScreen', g_gcGeneral[10]);
  g_gcGeneral[13] := ini.ReadBool('Basic', 'StruckShow', g_gcGeneral[13]);
  g_gcGeneral[15] := ini.ReadBool('Basic', 'HideStruck', g_gcGeneral[15]);

  g_gcGeneral[14] := ini.ReadBool('Basic', 'CompareItems', g_gcGeneral[14]);

  //g_gcGeneral[12] := ini.ReadBool('Basic', 'DayLight', g_gcGeneral[12]);

  ini2 := TIniFile.Create('.\lscfg.ini');
  g_gcGeneral[11] := ini2.ReadBool('Setup', 'EffectSound', g_gcGeneral[11]);
  g_SndMgr.Silent := not g_gcGeneral[11];

  g_gcGeneral[12] := ini2.ReadBool('Setup', 'EffectBKGSound', g_gcGeneral[12]);
  //g_boBGSound := g_boSound;
  g_lWavMaxVol := ini2.ReadInteger('Setup', 'EffectSoundLevel', g_lWavMaxVol);
  g_SndMgr.Volume := Round(g_lWavMaxVol / 68 * 100);
  ini2.Free;

  g_HitSpeedRate := ini.ReadInteger('Basic', 'HitSpeedRate', g_HitSpeedRate);
  g_MagSpeedRate := ini.ReadInteger('Basic', 'MagSpeedRate', g_MagSpeedRate);
  g_MoveSpeedRate := ini.ReadInteger('Basic', 'MoveSpeedRate', g_MoveSpeedRate);

  //Protect
  g_gcProtect[0] := ini.ReadBool('Protect', 'RenewHPIsAuto', g_gcProtect[0]);
  g_gcProtect[1] := ini.ReadBool('Protect', 'RenewMPIsAuto', g_gcProtect[1]);
  g_gcProtect[3] := ini.ReadBool('Protect', 'RenewSpecialIsAuto', g_gcProtect[3]);
  g_gcProtect[5] := ini.ReadBool('Protect', 'RenewBookIsAuto', g_gcProtect[5]);
  g_gcProtect[7] := ini.ReadBool('Protect', 'HeroRenewHPIsAuto', g_gcProtect[7]);
  g_gcProtect[8] := ini.ReadBool('Protect', 'HeroRenewMPIsAuto', g_gcProtect[8]);
  g_gcProtect[9] := ini.ReadBool('Protect', 'HeroRenewSpecialIsAuto', g_gcProtect[9]);
  g_gcProtect[10] := ini.ReadBool('Protect', 'HeroSidestep', g_gcProtect[10]);
  g_gcProtect[11] := ini.ReadBool('Protect', 'RenewSpecialIsAuto_MP', g_gcProtect[11]);

  g_gnProtectTime[0] := ini.ReadInteger('Protect', 'RenewHPTime', g_gnProtectTime[0]);
  g_gnProtectTime[1] := ini.ReadInteger('Protect', 'RenewMPTime', g_gnProtectTime[1]);
  g_gnProtectTime[3] := ini.ReadInteger('Protect', 'RenewSpecialTime', g_gnProtectTime[3]);
  g_gnProtectTime[5] := ini.ReadInteger('Protect', 'RenewBookTime', g_gnProtectTime[5]);
  g_gnProtectTime[7] := ini.ReadInteger('Protect', 'HeroRenewHPTime', g_gnProtectTime[7]);
  g_gnProtectTime[8] := ini.ReadInteger('Protect', 'HeroRenewMPTime', g_gnProtectTime[8]);
  g_gnProtectTime[9] := ini.ReadInteger('Protect', 'HeroRenewSpecialTime', g_gnProtectTime[9]);
  g_gnProtectPercent[0] := ini.ReadInteger('Protect', 'RenewHPPercent', g_gnProtectPercent[0]);
  g_gnProtectPercent[1] := ini.ReadInteger('Protect', 'RenewMPPercent', g_gnProtectPercent[1]);
  g_gnProtectPercent[3] := ini.ReadInteger('Protect', 'RenewSpecialPercent', g_gnProtectPercent[3]);
  g_gnProtectPercent[7] := ini.ReadInteger('Protect', 'HeroRenewHPPercent', g_gnProtectPercent[7]);
  g_gnProtectPercent[8] := ini.ReadInteger('Protect', 'HeroRenewMPPercent', g_gnProtectPercent[8]);
  g_gnProtectPercent[9] := ini.ReadInteger('Protect', 'HeroRenewSpecialPercent', g_gnProtectPercent[9]);
  g_gnProtectPercent[10] := ini.ReadInteger('Protect', 'HeroPerSidestep', g_gnProtectPercent[10]);
  g_gnProtectPercent[5] := ini.ReadInteger('Protect', 'RenewBookPercent', g_gnProtectPercent[5]);
  g_gnProtectPercent[6] := ini.ReadInteger('Protect', 'RenewBookNowBookIndex', g_gnProtectPercent[6]);
  frmMain.SendClientMessage(CM_HEROSIDESTEP, MakeLong(Integer(g_gcProtect[10]), g_gnProtectPercent[10]), 0, 0, 0);

  //
  g_gcTec[0] := ini.ReadBool('Tec', 'SmartLongHit', g_gcTec[0]);
  g_gcTec[10] := ini.ReadBool('Tec', 'SmartLongHit2', g_gcTec[10]);
  g_gcTec[11] := ini.ReadBool('Tec', 'SmartSLongHit', g_gcTec[11]);
  g_gcTec[1] := ini.ReadBool('Tec', 'SmartWideHit', g_gcTec[1]);
  g_gcTec[2] := ini.ReadBool('Tec', 'SmartFireHit', g_gcTec[2]);
  g_gcTec[3] := ini.ReadBool('Tec', 'SmartPureHit', g_gcTec[3]);
  g_gcTec[4] := ini.ReadBool('Tec', 'SmartShield', g_gcTec[4]);
  g_gcTec[5] := ini.ReadBool('Tec', 'SmartShieldHero', g_gcTec[5]);
  g_gcTec[6] := ini.ReadBool('Tec', 'SmartTransparence', g_gcTec[6]);
  g_gcTec[9] := ini.ReadBool('Tec', 'SmartThunderHit', g_gcTec[9]);

  g_gcTec[7] := ini.ReadBool('AutoPractice', 'PracticeIsAuto', g_gcTec[7]);
  g_gnTecTime[8] := ini.ReadInteger('AutoPractice', 'PracticeTime', g_gnTecTime[8]);
  g_gnTecPracticeKey := ini.ReadInteger('AutoPractice', 'PracticeKey', g_gnTecPracticeKey);

  g_gcTec[12] := ini.ReadBool('Tec', 'HeroSeriesSkillFilter', g_gcTec[12]);
  g_gcTec[13] := ini.ReadBool('Tec', 'SLongHit', g_gcTec[13]);
  g_gcTec[14] := ini.ReadBool('Tec', 'SmartGoMagic', g_gcTec[14]);
  frmMain.SendClientMessage(CM_HEROSERIESSKILLCONFIG, MakeLong(Integer(g_gcTec[12]), 0), 0, 0, 0);

  //
  g_gcHotkey[0] := ini.ReadBool('Hotkey', 'UseHotkey', g_gcHotkey[0]);
  FrmDlg.DEHeroCallHero.SetOfHotKey(ini.ReadInteger('Hotkey', 'HeroCallHero', 0));
  FrmDlg.DEHeroSetAttackState.SetOfHotKey(ini.ReadInteger('Hotkey', 'HeroSetAttackState', 0));
  FrmDlg.DEHeroSetGuard.SetOfHotKey(ini.ReadInteger('Hotkey', 'HeroSetGuard', 0));
  FrmDlg.DEHeroSetTarget.SetOfHotKey(ini.ReadInteger('Hotkey', 'HeroSetTarget', 0));
  FrmDlg.DEHeroUnionHit.SetOfHotKey(ini.ReadInteger('Hotkey', 'HeroUnionHit', 0));
  FrmDlg.DESwitchAttackMode.SetOfHotKey(ini.ReadInteger('Hotkey', 'SwitchAttackMode', 0));
  FrmDlg.DESwitchMiniMap.SetOfHotKey(ini.ReadInteger('Hotkey', 'SwitchMiniMap', 0));
  FrmDlg.DxEditSSkill.SetOfHotKey(ini.ReadInteger('Hotkey', 'SerieSkill', 0));

  g_ShowItemList.LoadFromFile('.\Data\Filter.dat');

  //============================================================================
  //g_gcAss[0] := ini.ReadBool('Ass', '0', g_gcAss[0]);
  g_gcAss[1] := ini.ReadBool('Ass', '1', g_gcAss[1]);
  g_gcAss[2] := ini.ReadBool('Ass', '2', g_gcAss[2]);
  g_gcAss[3] := ini.ReadBool('Ass', '3', g_gcAss[3]);
  g_gcAss[4] := ini.ReadBool('Ass', '4', g_gcAss[4]);
  g_gcAss[5] := ini.ReadBool('Ass', '5', g_gcAss[5]);
  g_gcAss[6] := ini.ReadBool('Ass', '6', g_gcAss[6]);

  g_APPickUpList.Clear;
  g_APMobList.Clear;

  Strings := TStringList.Create;
  if g_gcAss[5] then begin
    sFileName := '.\Config\' + g_sServerName + '.' + sUserName + '.ItemFilterEx.txt';
    if FileExists(sFileName) then
      Strings.LoadFromFile(sFileName)
    else
      Strings.SaveToFile(sFileName);

    for i := 0 to Strings.Count - 1 do begin
      if (Strings[i] = '') or (Strings[i][1] = ';') then Continue;
      so := GetValidStr3(Strings[i], sn, [',', ' ', #9]);
      no := Integer(so <> '');
      g_APPickUpList.AddObject(sn, TObject(no));
    end;
  end;

  if g_gcAss[6] then begin
    sFileName := '.\Config\' + g_sServerName + '.' + sUserName + '.MonFilter.txt';
    if FileExists(sFileName) then
      Strings.LoadFromFile(sFileName)
    else
      Strings.SaveToFile(sFileName);

    for i := 0 to Strings.Count - 1 do begin
      if (Strings[i] = '') or (Strings[i][1] = ';') then Continue;
      g_APMobList.Add(Strings[i] {, nil});
    end;
  end;
  Strings.Free;

  ini.Free;

end;

procedure LoadItemDesc();
const
  fItemDesc = '.\data\ItemDesc.dat';
var
  i: Integer;
  Name, desc: string;
  ps: PString;
  temp: TStringList;
begin
  //g_ItemDesc
  if FileExists(fItemDesc) then begin
    temp := TStringList.Create;
    temp.LoadFromFile(fItemDesc);
    for i := 0 to temp.Count - 1 do begin
      if temp[i] = '' then Continue;
      desc := GetValidStr3(temp[i], Name, ['=']);
      desc := StringReplace(desc, '\', '', [rfReplaceAll]);
      New(ps);
      ps^ := desc;
      if (Name <> '') and (desc <> '') then begin
        //g_ItemDesc.Put(name, TObject(ps));
        g_ItemDesc.AddObject(Name, TObject(ps));
      end;
    end;
    temp.Free;
  end;
end;

procedure InitObj();
begin
  //frmMain.DXDraw.AutoInitialize := True;
  DlgConf.DMsgDlg.Obj := FrmDlg.DMsgDlg;
  DlgConf.DMsgDlgOk.Obj := FrmDlg.DMsgDlgOk;
  DlgConf.DMsgDlgYes.Obj := FrmDlg.DMsgDlgYes;
  DlgConf.DMsgDlgCancel.Obj := FrmDlg.DMsgDlgCancel;
  DlgConf.DMsgDlgNo.Obj := FrmDlg.DMsgDlgNo;
  DlgConf.DLogin.Obj := FrmDlg.DLogin;
  DlgConf.DLoginNew.Obj := FrmDlg.DLoginNew;
  DlgConf.DLoginOk.Obj := FrmDlg.DLoginOk;
  DlgConf.DLoginChgPw.Obj := FrmDlg.DLoginChgPw;
  DlgConf.DLoginClose.Obj := FrmDlg.DLoginClose;
  DlgConf.DSelServerDlg.Obj := FrmDlg.DSelServerDlg;
  DlgConf.DSSrvClose.Obj := FrmDlg.DSSrvClose;
  DlgConf.DSServer1.Obj := FrmDlg.DSServer1;
  DlgConf.DSServer2.Obj := FrmDlg.DSServer2;
  DlgConf.DSServer3.Obj := FrmDlg.DSServer3;
  DlgConf.DSServer4.Obj := FrmDlg.DSServer4;
  DlgConf.DSServer5.Obj := FrmDlg.DSServer5;
  DlgConf.DSServer6.Obj := FrmDlg.DSServer6;
  DlgConf.DNewAccount.Obj := FrmDlg.DNewAccount;
  DlgConf.DNewAccountOk.Obj := FrmDlg.DNewAccountOk;
  DlgConf.DNewAccountCancel.Obj := FrmDlg.DNewAccountCancel;
  DlgConf.DNewAccountClose.Obj := FrmDlg.DNewAccountClose;
  DlgConf.DChgPw.Obj := FrmDlg.DChgPw;
  DlgConf.DChgpwOk.Obj := FrmDlg.DChgpwOk;
  DlgConf.DChgpwCancel.Obj := FrmDlg.DChgpwCancel;
  DlgConf.DSelectChr.Obj := FrmDlg.DSelectChr;
  DlgConf.DBottom.Obj := FrmDlg.DBottom;
  DlgConf.DMyState.Obj := FrmDlg.DMyState;
  DlgConf.DMyBag.Obj := FrmDlg.DMyBag;
  DlgConf.DMyMagic.Obj := FrmDlg.DMyMagic;
  DlgConf.DOption.Obj := FrmDlg.DOption;
  DlgConf.DBotMiniMap.Obj := FrmDlg.DBotMiniMap;
  DlgConf.DBotTrade.Obj := FrmDlg.DBotTrade;
  DlgConf.DBotGuild.Obj := FrmDlg.DBotGuild;
  DlgConf.DBotGroup.Obj := FrmDlg.DBotGroup;
  DlgConf.DBotPlusAbil.Obj := FrmDlg.DBotPlusAbil;
  DlgConf.DBotFriend.Obj := FrmDlg.DBotFriend;
  DlgConf.DBotDare.Obj := FrmDlg.DBotDare;
  DlgConf.DBotLevelRank.Obj := FrmDlg.DBotLevelRank;

  //DlgConf.DBotMemo.Obj := FrmDlg.DBotMemo;
  //DlgConf.DBotExit.Obj := FrmDlg.DBotExit;
  //DlgConf.DBotLogout.Obj := FrmDlg.DBotLogout;
  DlgConf.DBelt1.Obj := FrmDlg.DBelt1;
  DlgConf.DBelt2.Obj := FrmDlg.DBelt2;
  DlgConf.DBelt3.Obj := FrmDlg.DBelt3;
  DlgConf.DBelt4.Obj := FrmDlg.DBelt4;
  DlgConf.DBelt5.Obj := FrmDlg.DBelt5;
  DlgConf.DBelt6.Obj := FrmDlg.DBelt6;
  DlgConf.DGold.Obj := FrmDlg.DGold;
  DlgConf.DRfineItem.Obj := FrmDlg.DRefineItem;
  DlgConf.DCloseBag.Obj := FrmDlg.DCloseBag;
  DlgConf.DMerchantDlg.Obj := FrmDlg.DMerchantDlg;
  DlgConf.DMerchantDlgClose.Obj := FrmDlg.DMerchantDlgClose;
  //DlgConf.DConfigDlg.Obj := FrmDlg.DConfigDlg;
  //DlgConf.DConfigDlgOK.Obj := FrmDlg.DConfigDlgOK;
  //DlgConf.DConfigDlgClose.Obj := FrmDlg.DConfigDlgClose;
  DlgConf.DMenuDlg.Obj := FrmDlg.DMenuDlg;
  DlgConf.DMenuPrev.Obj := FrmDlg.DMenuPrev;
  DlgConf.DMenuNext.Obj := FrmDlg.DMenuNext;
  DlgConf.DMenuBuy.Obj := FrmDlg.DMenuBuy;
  DlgConf.DMenuClose.Obj := FrmDlg.DMenuClose;
  DlgConf.DSellDlg.Obj := FrmDlg.DSellDlg;
  DlgConf.DSellDlgOk.Obj := FrmDlg.DSellDlgOk;
  DlgConf.DSellDlgClose.Obj := FrmDlg.DSellDlgClose;
  DlgConf.DSellDlgSpot.Obj := FrmDlg.DSellDlgSpot;
  DlgConf.DKeySelDlg.Obj := FrmDlg.DKeySelDlg;
  DlgConf.DKsIcon.Obj := FrmDlg.DKsIcon;
  DlgConf.DKsF1.Obj := FrmDlg.DKsF1;
  DlgConf.DKsF2.Obj := FrmDlg.DKsF2;
  DlgConf.DKsF3.Obj := FrmDlg.DKsF3;
  DlgConf.DKsF4.Obj := FrmDlg.DKsF4;
  DlgConf.DKsF5.Obj := FrmDlg.DKsF5;
  DlgConf.DKsF6.Obj := FrmDlg.DKsF6;
  DlgConf.DKsF7.Obj := FrmDlg.DKsF7;
  DlgConf.DKsF8.Obj := FrmDlg.DKsF8;
  DlgConf.DKsConF1.Obj := FrmDlg.DKsConF1;
  DlgConf.DKsConF2.Obj := FrmDlg.DKsConF2;
  DlgConf.DKsConF3.Obj := FrmDlg.DKsConF3;
  DlgConf.DKsConF4.Obj := FrmDlg.DKsConF4;
  DlgConf.DKsConF5.Obj := FrmDlg.DKsConF5;
  DlgConf.DKsConF6.Obj := FrmDlg.DKsConF6;
  DlgConf.DKsConF7.Obj := FrmDlg.DKsConF7;
  DlgConf.DKsConF8.Obj := FrmDlg.DKsConF8;
  DlgConf.DKsNone.Obj := FrmDlg.DKsNone;
  DlgConf.DKsOk.Obj := FrmDlg.DKsOk;
  DlgConf.DItemGrid.Obj := FrmDlg.DItemGrid;
end;

function GetLevelColor(iLevel: Byte): Integer;
begin
  case iLevel of
    0: Result := $00FFFFFF;
    1: Result := $004AD663;
    2: Result := $00E9A000;
    3: Result := $00FF35B1;
    4: Result := $000061EB;
    5: Result := $005CF4FF;
    15: Result := clGray;
  else
    Result := $005CF4FF;
  end;
end;

procedure LoadItemFilter();
var
  i, n: Integer;
  s, s0, s1, s2, s3, s4, fn: string;
  ls: TStringList;
  p, p2: pTCItemRule;
begin
  fn := '.\Data\lsDefaultItemFilter.txt';
  if FileExists(fn) then begin
    ls := TStringList.Create;
    ls.LoadFromFile(fn);
    for i := 0 to ls.Count - 1 do begin
      s := ls[i];
      if s = '' then Continue;

      s := GetValidStr3(s, s0, [',']);
      s := GetValidStr3(s, s1, [',']);
      s := GetValidStr3(s, s2, [',']);
      s := GetValidStr3(s, s3, [',']);
      s := GetValidStr3(s, s4, [',']);
      New(p);
      p.Name := s0;
      p.rare := s2 = '1';
      p.pick := s3 = '1';
      p.show := s4 = '1';
      g_ItemsFilter_All.Put(s0, TObject(p));

      New(p2);
      p2^ := p^;
      g_ItemsFilter_All_Def.Put(s0, TObject(p2));

      n := StrToInt(s1);
      case n of
        0: g_ItemsFilter_Dress.AddObject(s0, TObject(p));
        1: g_ItemsFilter_Weapon.AddObject(s0, TObject(p));
        2: g_ItemsFilter_Headgear.AddObject(s0, TObject(p));
        3: g_ItemsFilter_Drug.AddObject(s0, TObject(p));
      else
        g_ItemsFilter_Other.AddObject(s0, TObject(p)); //服装
      end;

    end;

    ls.Free;
  end;
end;

procedure LoadItemFilter2();
var
  i, n: Integer;
  s, s0, s1, s2, s3, s4, fn: string;
  ls: TStringList;
  p, p2: pTCItemRule;
  b2, b3, b4: Boolean;
begin
  fn := '.\Config\' + g_sServerName + '.' + frmMain.m_sCharName + '.ItemFilter.txt';
  //DScreen.AddChatBoardString(fn, clWhite, clBlue);
  if FileExists(fn) then begin
    //DScreen.AddChatBoardString('1', clWhite, clBlue);
    ls := TStringList.Create;
    ls.LoadFromFile(fn);
    for i := 0 to ls.Count - 1 do begin
      s := ls[i];
      if s = '' then Continue;

      s := GetValidStr3(s, s0, [',']);
      s := GetValidStr3(s, s2, [',']);
      s := GetValidStr3(s, s3, [',']);
      s := GetValidStr3(s, s4, [',']);

      p := pTCItemRule(g_ItemsFilter_All_Def.GetValues(s0));
      if p <> nil then begin
        //DScreen.AddChatBoardString('2', clWhite, clBlue);
        b2 := s2 = '1';
        b3 := s3 = '1';
        b4 := s4 = '1';
        if (b2 <> p.rare) or (b3 <> p.pick) or (b4 <> p.show) then begin
          //DScreen.AddChatBoardString('3', clWhite, clBlue);
          p2 := pTCItemRule(g_ItemsFilter_All.GetValues(s0));
          if p2 <> nil then begin
            //DScreen.AddChatBoardString('4', clWhite, clBlue);
            p2.rare := b2;
            p2.pick := b3;
            p2.show := b4;
          end;
        end;
      end;
    end;

    ls.Free;
  end;
end;

procedure SaveItemFilter(); //退出增量保存
var
  i, n: Integer;
  s, s0, s1, s2, s3, s4, fn: string;
  ls: TStringList;
  p, p2: pTCItemRule;
begin
  //Savebagsdat(, @g_ItemArr);
  fn := '.\Config\' + g_sServerName + '.' + frmMain.m_sCharName + '.ItemFilter.txt';
  ls := TStringList.Create;
  for i := 0 to g_ItemsFilter_All.Count - 1 do begin
    p := pTCItemRule(g_ItemsFilter_All.GetValues(g_ItemsFilter_All.Keys[i]));
    p2 := pTCItemRule(g_ItemsFilter_All_Def.GetValues(g_ItemsFilter_All_Def.Keys[i]));
    if p.Name = p2.Name then begin
      if (p.rare <> p2.rare) or
        (p.pick <> p2.pick) or
        (p.show <> p2.show) then begin

        ls.Add(Format('%s,%d,%d,%d', [
          p.Name,
            Byte(p.rare),
            Byte(p.pick),
            Byte(p.show)
            ]));

      end;
    end;
  end;
  if ls.Count > 0 then
    ls.SaveToFile(fn);
  ls.Free;
end;

function getSuiteHint(var idx: Integer; s: string; gender: Byte): pTClientSuiteItems;
var
  i: Integer;
  p: pTClientSuiteItems;
begin
  Result := nil;
  if (idx > 12) or (idx < 0) then Exit;
  for i := 0 to g_SuiteItemsList.Count - 1 do begin
    p := g_SuiteItemsList[i];
    if ((p.asSuiteName[0] = '') or (gender = p.gender)) and (CompareText(s, p.asSuiteName[idx]) = 0) then begin
      Result := p;
      Break;
    end;
  end;
  idx := -1;
end;

function GetItemWhere(Item: TClientItem): Integer;
begin
  Result := -1;
  if Item.s.Name = '' then Exit;
  case Item.s.StdMode of
    10, 11: begin
        Result := U_DRESS;
      end;
    5, 6: begin
        Result := U_WEAPON;
      end;
    30: begin
        Result := U_RIGHTHAND;
      end;
    19, 20, 21: begin
        Result := U_NECKLACE;
      end;
    15: begin
        Result := U_HELMET;
      end;
    16: begin

      end;
    24, 26: begin
        Result := U_ARMRINGL;
      end;
    22, 23: begin
        Result := U_RINGL;
      end;
    25: begin
        Result := U_BUJUK;
      end;
    27: begin
        Result := U_BELT;
      end;
    28: begin
        Result := U_BOOTS;
      end;
    7, 29: begin
        Result := U_CHARM;
      end;
  end;
end;

const
  g_levelstring: array[1..8] of string = ('一', '二', '三', '四', '五', '六', '七', '八');

function GetEvaBaseAbil(Val: TEvaAbil): string;
begin
  Result := '';
  if Val.btValue = 0 then Exit;
  case Val.btType of
    01: Result := Format(' 攻击上限 +%d', [Val.btValue]);
    02: Result := Format(' 魔法上限 +%d', [Val.btValue]);
    03: Result := Format(' 道术上限 +%d', [Val.btValue]);
    04: Result := Format(' 物防上限 +%d', [Val.btValue]);
    05: Result := Format(' 魔防上限 +%d', [Val.btValue]);

    06: Result := Format('< 准确     +%d|c=clSkyBlue>', [Val.btValue]);
    07: Result := Format('< 敏捷     +%d|c=clSkyBlue>', [Val.btValue]);
    08: Result := Format('< 魔法躲避 +%d|c=clSkyBlue>', [Val.btValue * 10]);
    09: Result := Format('< 幸运     +%d|c=clSkyBlue>', [Val.btValue]);
    10: Result := Format('< 诅咒     +%d|c=clSkyBlue>', [Val.btValue]);
    11: Result := Format('< 攻击速度 +%d|c=clSkyBlue>', [Val.btValue]);
    12: Result := Format('< 神圣     +%d|c=clSkyBlue>', [Val.btValue]);
    13: Result := Format('< 魔法回复 +%d|c=clSkyBlue>', [Val.btValue * 10]);
    14: Result := Format('< 体力回复 +%d|c=clSkyBlue>', [Val.btValue * 10]);

    //
    15: Result := Format('< 击杀爆率 +%d|c=clSkyBlue>', [Val.btValue]);
    16: Result := Format('< 防爆     +%d|c=clSkyBlue>', [Val.btValue]);
    17: Result := Format('< 吸血上限 +%d|c=clSkyBlue>', [Val.btValue]);

    18: Result := Format('< 内力恢复 +%d|c=clSkyBlue>', [Val.btValue]);
    19: Result := Format('< 内力上限 +%d|c=clSkyBlue>', [Val.btValue]);

    20: Result := Format('< 内功伤害 +%d|c=clSkyBlue>', [Val.btValue]);
    21: Result := Format('< 内功减免 +%d|c=clSkyBlue>', [Val.btValue]);
    22: Result := Format('< 内伤等级 +%d|c=clSkyBlue>', [Val.btValue]);

    23: Result := Format('< 暴击威力 +%d|c=clSkyBlue>', [Val.btValue * 2]);
    24: Result := Format('< 合击威力 +%d|c=clSkyBlue>', [Val.btValue]) + '<%|c=clSkyBlue>';

    25: Result := Format('< 麻痹抗性 +%d|c=clSkyBlue>', [Val.btValue]) + '<%|c=clSkyBlue>';

    26: Result := Format('< 强身等级 +%d|c=clSkyBlue>', [Val.btValue]);
    27: Result := Format('< 聚魔等级 +%d|c=clSkyBlue>', [Val.btValue]);
    28: Result := Format('< 主属性   +%d|c=clWhite>', [Val.btValue]);

    29: Result := Format('< 毒物躲避 +%d|c=clSkyBlue>', [Val.btValue]);
    30: Result := Format('< 中毒恢复 +%d|c=clSkyBlue>', [Val.btValue]);

    //11: Result := Format(' 增加血量 +%d', [val.btValue]);
    //12: Result := Format(' 增加魔法 +%d', [val.btValue]);
  end;
end;

function GetEvaMysteryAbil(Val, val2: Byte; var cnt: Byte; Std: TClientStdItem): string;
var
  SpSkill: Byte;
begin
  cnt := 0;
  Result := '';
  Val := Val and $7F;
  if Val and $01 <> 0 then begin
    Result := Result + '< 八卦护身神技|c=$004AD663>\';
    Inc(cnt);
  end;
  if Val and $02 <> 0 then begin
    Result := Result + '< 战意麻痹神技|c=$004AD663>\';
    Inc(cnt);
  end;
  if Val and $04 <> 0 then begin
    Result := Result + '< 重生神技|c=$004AD663>\';
    Inc(cnt);
  end;
  if Val and $08 <> 0 then begin
    Result := Result + '< 探测神技|c=$004AD663>\';
    Inc(cnt);
  end;
  if Val and $10 <> 0 then begin
    Result := Result + '< 传送神技|c=$004AD663>\';
    Inc(cnt);
  end;
  if Val and $20 <> 0 then begin
    Result := Result + '< 麻痹神技|c=$004AD663>\';
    Inc(cnt);
  end;
  if Val and $40 <> 0 then begin
    Result := Result + '< 魔道麻痹神技|c=$004AD663>\';
    Inc(cnt);
  end;

  {
      0: Result := $00FFFFFF;
      1: Result := $004AD663;
      2: Result := $00E9A000;
      3: Result := $00FF35B1;
      4: Result := $000061EB;
      5: Result := $005CF4FF;
  }
  if Std.StdMode in [5, 6] then begin
    if val2 and $01 <> 0 then begin
      Result := Result + '< 五岳独尊特技|c=$00E9A000>\';
      Inc(cnt);
    end;
    if val2 and $02 <> 0 then begin
      Result := Result + '< 召唤巨魔特技|c=$00E9A000>\';
      Inc(cnt);
    end;
    if val2 and $04 <> 0 then begin
      Result := Result + '< 神龙附体特技|c=$00E9A000>\';
      Inc(cnt);
    end;
    if val2 and $08 <> 0 then begin
      Result := Result + '< 倚天劈地特技|c=$00E9A000>\';
      Inc(cnt);
    end;
  end else begin
    SpSkill := 0;
    case g_ShowSuite3 of
      1: if (g_UseItems[1].s.Name <> '') and (g_UseItems[1].s.Eva.SpSkill <> 0) then
          SpSkill := g_UseItems[1].s.Eva.SpSkill;
      2: if (g_HeroUseItems[1].s.Name <> '') and (g_HeroUseItems[1].s.Eva.SpSkill <> 0) then
          SpSkill := g_UseItems[1].s.Eva.SpSkill;
      3: if (UserState1.UseItems[1].s.Name <> '') and (UserState1.UseItems[1].s.Eva.SpSkill <> 0) then
          SpSkill := g_UseItems[1].s.Eva.SpSkill;
    end;
    g_ShowSuite3 := 0;

    if (val2 and $01 <> 0) then begin
      if (SpSkill and $01 <> 0) then
        Result := Result + '< 五岳独尊Lv+1|c=$00E9A000>\'
      else
        Result := Result + '< 五岳独尊Lv+1 (未修炼)|c=clGray>\';
      Inc(cnt);
    end;

    if (val2 and $2 <> 0) then begin
      if (SpSkill and $2 <> 0) or (g_SuiteSpSkill > 0) then
        Result := Result + '< 召唤巨魔Lv+1|c=$00E9A000>\'
      else
        Result := Result + '< 召唤巨魔Lv+1 (未修炼)|c=clGray>\';
      Inc(cnt);
    end;

    if (val2 and $4 <> 0) then begin
      if (SpSkill and $4 <> 0) then
        Result := Result + '< 神龙附体Lv+1|c=$00E9A000>\'
      else
        Result := Result + '< 神龙附体Lv+1 (未修炼)|c=clGray>\';
      Inc(cnt);
    end;

    if (val2 and $8 <> 0) then begin
      if (SpSkill and $8 <> 0) then
        Result := Result + '< 倚天劈地Lv+1|c=$00E9A000>\'
      else
        Result := Result + '< 倚天劈地Lv+1 (未修炼)|c=clGray>\';
      Inc(cnt);
    end;

    g_SuiteSpSkill := 0;
  end;
end;

function GetSecretAbil(CurrMouseItem: TClientItem): Boolean;
var
  i, start: Integer;
  adv, cnt: Byte;
  s, ss: string;
begin
  Result := False;
  if not (CurrMouseItem.s.StdMode in [5, 6, 10..13, 15..24, 26..30]) then Exit;

  if CurrMouseItem.s.Eva.AdvAbilMax > 0 then begin
    cnt := 0;
    for i := CurrMouseItem.s.Eva.BaseMax to 7 do begin
      if CurrMouseItem.s.Eva.Abil[i].btValue = 0 then
        Break;
      s := GetEvaBaseAbil(CurrMouseItem.s.Eva.Abil[i]);
      if s <> '' then begin
        Inc(cnt);
      end;
    end;

    adv := 0;
    if (CurrMouseItem.s.Eva.AdvAbil <> 0) or (CurrMouseItem.s.Eva.SpSkill <> 0) then
      GetEvaMysteryAbil(CurrMouseItem.s.Eva.AdvAbil, CurrMouseItem.s.Eva.SpSkill, adv, CurrMouseItem.s);

    cnt := cnt + adv;
    start := Integer(CurrMouseItem.s.Eva.AdvAbilMax - cnt);
    if start > 0 then
      Result := True;
  end;
end;

function GetEvaluationInfo(CurrMouseItem: TClientItem): string;
var
  i, start: Integer;
  adv, cnt: Byte;
  s, ss: string;
begin
  Result := '';

  if (CurrMouseItem.s.Eva.EvaTimesMax <> 0) and (CurrMouseItem.s.Eva.EvaTimes = 0) then begin
    Result := Result + '<可鉴定|c=clyellow>\';
  end else begin
    if CurrMouseItem.s.Eva.EvaTimes in [1..8] then begin
      if CurrMouseItem.s.Eva.EvaTimes < CurrMouseItem.s.Eva.EvaTimesMax then
        Result := Result + Format('<%s鉴(仍可鉴定)|c=clyellow>\', [g_levelstring[CurrMouseItem.s.Eva.EvaTimes]])
      else
        Result := Result + Format('<%s鉴|c=clyellow>\', [g_levelstring[CurrMouseItem.s.Eva.EvaTimes]]);
    end;
  end;

  start := 0;
  case CurrMouseItem.s.Eva.Quality of
    001..050: start := 1;
    051..100: start := 2;
    101..150: start := 3;
    151..200: start := 4;
    201..255: start := 5;
  end;
  ss := '';
  if start > 0 then begin
    for i := 0 to start - 1 do
      ss := ss + '<u~|I=1345>';
  end;
  if (ss <> '') then
    Result := Result + ' ' + ss + '\';

  //基础属性
  ss := '';
  if CurrMouseItem.s.Eva.BaseMax in [1..8] then begin
    for i := 0 to CurrMouseItem.s.Eva.BaseMax - 1 do begin
      s := GetEvaBaseAbil(CurrMouseItem.s.Eva.Abil[i]);
      if s <> '' then
        ss := ss + s + '\';
    end;
  end;
  if ss <> '' then
    Result := Result + ' \<附加基础属性|c=clYellow>\' + ss;

  //神秘属性
  ss := '';
  if CurrMouseItem.s.Eva.AdvAbilMax > 0 then begin
    cnt := 0;
    for i := CurrMouseItem.s.Eva.BaseMax to 7 do begin
      if CurrMouseItem.s.Eva.Abil[i].btValue = 0 then
        Break;
      s := GetEvaBaseAbil(CurrMouseItem.s.Eva.Abil[i]);
      if s <> '' then begin
        ss := ss + s + '\';
        Inc(cnt);
      end;
    end;

    adv := 0;
    if (CurrMouseItem.s.Eva.AdvAbil <> 0) or (CurrMouseItem.s.Eva.SpSkill <> 0) then begin
      ss := ss + GetEvaMysteryAbil(CurrMouseItem.s.Eva.AdvAbil, CurrMouseItem.s.Eva.SpSkill, adv, CurrMouseItem.s);
    end;

    cnt := cnt + adv;

    start := Integer(CurrMouseItem.s.Eva.AdvAbilMax - cnt);
    if start > 0 then
      for i := 0 to start - 1 do
        ss := ss + '< 神秘属性(待解读)|c=clRed>\';
  end;
  if ss <> '' then
    Result := Result + ' \<附加神秘属性|c=clYellow>\' + ss;

  //灵媒
  ss := '';
  if CurrMouseItem.s.Eva.SpiritMax > 0 then begin
    if CurrMouseItem.s.Eva.Spirit > 0 then
      ss := ss + Format('<宝物灵媒|c=clLime> <品质%d|c=clYellow> <灵气%d/%d|c=clYellow>\', [CurrMouseItem.s.Eva.SpiritQ, CurrMouseItem.s.Eva.Spirit, CurrMouseItem.s.Eva.SpiritMax])
    else
      ss := ss + Format('<宝物灵媒|c=clLime> <品质%d|c=clYellow> <灵气0/%d|c=clRed>\', [CurrMouseItem.s.Eva.SpiritQ, CurrMouseItem.s.Eva.SpiritMax]);
  end;
  if ss <> '' then
    Result := Result + '-\' + ss;

end;

procedure InitClientItems();
begin
  FillChar(g_MagicArr, SizeOf(g_MagicArr), 0);
  FillChar(g_TakeBackItemWait, SizeOf(g_TakeBackItemWait), 0);

  FillChar(g_UseItems, SizeOf(TClientItem) * 14, #0);
  FillChar(g_ItemArr, SizeOf(TClientItem) * MAXBAGITEMCL, #0);
  FillChar(g_HeroUseItems, SizeOf(TClientItem) * 14, #0);
  FillChar(g_HeroItemArr, SizeOf(TClientItem) * MAXBAGITEMCL, #0);
  FillChar(g_RefineItems, SizeOf(TMovingItem) * 3, #0);
  FillChar(g_BuildAcuses, SizeOf(g_BuildAcuses), #0);
  FillChar(g_DetectItem, SizeOf(g_DetectItem), #0);
  FillChar(g_TIItems, SizeOf(g_TIItems), #0);
  FillChar(g_spItems, SizeOf(g_spItems), #0);

  FillChar(g_ItemArr, SizeOf(TClientItem) * MAXBAGITEMCL, #0);
  FillChar(g_HeroItemArr, SizeOf(TClientItem) * MAXBAGITEMCL, #0);

  FillChar(g_DealItems, SizeOf(TClientItem) * 10, #0);
  FillChar(g_YbDealItems, SizeOf(TClientItem) * 10, #0);
  FillChar(g_DealRemoteItems, SizeOf(TClientItem) * 20, #0);
end;

function GetTIHintString1(idx: Integer; ci: PTClientItem = nil; iname: string = ''): Byte;
begin
  Result := 0;
  g_tiHintStr1 := '';
  case idx of
    0: begin
        g_tiHintStr1 := '我收藏天下的奇珍异宝，走南闯北几十年了，各种神器见过不少，把你要鉴定的装备放在桌子上吧！';
        FrmDlg.DBTIbtn1.btnState := tdisable;
        FrmDlg.DBTIbtn1.Caption := '普通鉴定';
        FrmDlg.DBTIbtn2.btnState := tdisable;
        FrmDlg.DBTIbtn2.Caption := '高级鉴定';
      end;
    1: begin
        if (ci = nil) or (ci.s.Name = '') then Exit;
        if ci.s.Eva.EvaTimesMax = 0 then begin
          g_tiHintStr1 := '标志了不可鉴定的物品我是鉴定不了的，你换一个吧。';
          FrmDlg.DBTIbtn1.btnState := tdisable;
          FrmDlg.DBTIbtn1.Caption := '普通鉴定';
          FrmDlg.DBTIbtn2.btnState := tdisable;
          FrmDlg.DBTIbtn2.Caption := '高级鉴定';
          Exit;
        end;
        if ci.s.Eva.EvaTimes < ci.s.Eva.EvaTimesMax then begin
          if FrmDlg.DWTI.tag = 1 then begin
            case ci.s.Eva.EvaTimes of
              0: begin
                  g_tiHintStr1 := '第一次鉴定我需要一个一级鉴定卷轴，你快去收集一个吧！';
                  FrmDlg.DBTIbtn1.btnState := tnor;
                  FrmDlg.DBTIbtn1.Caption := '普通一鉴';
                  FrmDlg.DBTIbtn2.btnState := tnor;
                  FrmDlg.DBTIbtn2.Caption := '高级一鉴';
                end;
              1: begin
                  g_tiHintStr1 := '第二次鉴定我需要一个二级鉴定卷轴，你快去收集一个吧！';
                  FrmDlg.DBTIbtn1.btnState := tnor;
                  FrmDlg.DBTIbtn1.Caption := '普通二鉴';
                  FrmDlg.DBTIbtn2.btnState := tnor;
                  FrmDlg.DBTIbtn2.Caption := '高级二鉴';
                end;
              2: begin
                  g_tiHintStr1 := '第三次鉴定我需要一个三级鉴定卷轴，你快去收集一个吧！';
                  FrmDlg.DBTIbtn1.btnState := tnor;
                  FrmDlg.DBTIbtn1.Caption := '普通三鉴';
                  FrmDlg.DBTIbtn2.btnState := tnor;
                  FrmDlg.DBTIbtn2.Caption := '高级三鉴';
                end;
            else begin
                g_tiHintStr1 := '我需要一个三级鉴定卷轴来鉴定你这个装备。';
                FrmDlg.DBTIbtn1.btnState := tnor;
                FrmDlg.DBTIbtn1.Caption := '普通三鉴';
                FrmDlg.DBTIbtn2.btnState := tnor;
                FrmDlg.DBTIbtn2.Caption := '高级三鉴';
              end;
            end;
          end else if FrmDlg.DWTI.tag = 2 then begin
            FrmDlg.DBTIbtn1.btnState := tnor;
            FrmDlg.DBTIbtn1.Caption := '更换';
          end;

          Result := ci.s.Eva.EvaTimes;
        end else begin
          g_tiHintStr1 := Format('你的这件%s已经不能再鉴定了。', [ci.s.Name]);
          FrmDlg.DBTIbtn1.btnState := tdisable;
          FrmDlg.DBTIbtn1.Caption := '普通鉴定';
          FrmDlg.DBTIbtn2.btnState := tdisable;
          FrmDlg.DBTIbtn2.Caption := '高级鉴定';
        end;
      end;

    2: g_tiHintStr1 := Format('借助卷轴的力量，我已经帮你发现了你这%s的潜能。', [iname]);
    3: g_tiHintStr1 := Format('借助卷轴的力量，我已经帮你发现了你这%s的神秘潜能。', [iname]);
    4: g_tiHintStr1 := Format('这%s虽然没能发现更大的潜能，但是他拥有感应其他宝物存在的特殊能力。', [iname]);
    5: g_tiHintStr1 := Format('我并没能从你的这个%s上发现更多的潜能。你不要沮丧，我会给你额外的补偿。', [iname]);
    6: g_tiHintStr1 := Format('我并没能从你的这个%s上发现更多的潜能。', [iname]);
    7: g_tiHintStr1 := Format('我并没能从你的这个%s上发现更多的潜能。你的宝物已经不可鉴定。', [iname]);

    8: g_tiHintStr1 := '你缺少宝物或者卷轴。';
    9: g_tiHintStr1 := Format('恭喜你的宝物被鉴定为主宰装备，你获得了%s。', [iname]);
    10: g_tiHintStr1 := '待鉴物品错误或不存在！';
    11: g_tiHintStr1 := Format('你的这件%s不可以鉴定！', [iname]);
    12: begin
        FrmDlg.DBTIbtn1.btnState := tdisable;
        FrmDlg.DBTIbtn2.btnState := tdisable;
        g_tiHintStr1 := Format('以我目前的能力，%s只能先鉴定到这里了。', [iname]);
      end;

    30: g_tiHintStr1 := '鉴定卷轴错误或不存在！';
    31: g_tiHintStr1 := Format('我需要一个%s级鉴定卷轴，你的卷轴不符合要求！', [iname]);

    32: g_tiHintStr1 := Format('高级鉴定失败，你的%s消失了！', [iname]);
    33: g_tiHintStr1 := Format('服务器没有%s的数据，高级鉴定失败！', [iname]);
  end;
end;

function GetTIHintString2(idx: Integer; ci: PTClientItem = nil; iname: string = ''): Byte;
begin
  Result := 0;
  g_tiHintStr1 := '';
  case idx of
    0: begin
        g_tiHintStr1 := '如果你不喜欢已经鉴定过了的宝物，你可以把他给我，我平素最爱收藏各种宝物，我会给你一个一模一样的没鉴定过的装备作为补偿。';
        FrmDlg.DBTIbtn1.btnState := tdisable;
      end;
    1: begin
        g_tiHintStr1 := Format('这个%s，看上去不错，我这里正好有没有鉴定过的各种%s你可以挑一把，要换的话，你要给我一个幸运符。', [ci.s.Name, ci.s.Name]);
        FrmDlg.DBTIbtn1.btnState := tnor;
      end;
    2: g_tiHintStr1 := Format('我已经给了你一把没鉴定过的%s，跟你原来的%s没鉴定过之前是一模一样的！', [iname, iname]);
    3: g_tiHintStr1 := '缺少宝物或材料。';
    4: g_tiHintStr1 := Format('你的这件%s并没有鉴定过。', [iname]);
    5: g_tiHintStr1 := '材料不符合，请放入幸运符。';
    6: g_tiHintStr1 := '该物品框只能放鉴定过的宝物，你的东西不符合，我已经将它放回你的包裹了。';
    7: g_tiHintStr1 := '该物品框只能放幸运符，你的东西不符合，我已经将它放回你的包裹了。';
    8: g_tiHintStr1 := '宝物更换失败。';
  end;
end;

function GetSpHintString1(idx: Integer; ci: PTClientItem = nil; iname: string = ''): Byte;
begin
  Result := 0;
  g_spHintStr1 := '';
  case idx of
    0: g_spHintStr1 := '你可以跟别人购买神秘卷轴，也可以自己制作神秘卷轴来解读宝物的神秘属性。';
    1: g_spHintStr1 :=
      '这次解读不幸失败，解读幸运值、神秘卷轴' +
        '的等级和熟练度过低可能导致解读失败，不' +
        '要失望，再接再厉吧。';
    2: g_spHintStr1 := '找不到鉴定物品或卷轴';
    3: begin
        FrmDlg.DBSP.btnState := tdisable;
        g_spHintStr1 := '没有可鉴定的神秘属性';
      end;
    4: g_spHintStr1 := '装备不符合神秘解读要求';
    5: g_spHintStr1 := '卷轴类型不符合';
    6: g_spHintStr1 := '卷轴等级不符合';
    7: g_spHintStr1 := '借助神秘卷轴的帮助，已经帮你解读出了一个神秘属性';

    10: g_spHintStr1 := '神秘卷轴制作成功。';
    11: g_spHintStr1 :=
      '这次制作不幸的失败了，可能是因为你的神' +
        '秘解读技能等级还不够高，或者是你制作的' +
        '卷轴等级太高了';
    12: g_spHintStr1 := '找不到羊皮卷。';
    13: g_spHintStr1 := '请放入羊皮卷。';
    14: g_spHintStr1 := '精力值不够。';
    15: g_spHintStr1 := '没有解读技能，制作失败。';

  end;
end;

function GetSpHintString2(idx: Integer; ci: PTClientItem = nil; iname: string = ''): Byte;
begin
  Result := 0;
  g_spHintStr1 := '';
  case idx of
    0: begin
        g_spHintStr1 := '你可以把你对鉴宝的心得还有你的鉴定经验写在神秘卷轴上，这样的话，就可以帮助更多人解读神秘属性。';
      end;
  end;
end;

procedure AutoPutOntiBooks();
var
  i: Integer;
  cu: TClientItem;
begin
  if FrmDlg.DWTI.Visible and (FrmDlg.DWTI.tag = 1) and
    (g_TIItems[0].Item.s.Name <> '') and
    (g_TIItems[0].Item.s.Eva.EvaTimesMax > 0) and
    (g_TIItems[0].Item.s.Eva.EvaTimes < g_TIItems[0].Item.s.Eva.EvaTimesMax) and
    ((g_TIItems[1].Item.s.Name = '') or
    (g_TIItems[1].Item.s.StdMode <> 56) or
    not (g_TIItems[1].Item.s.Shape in [1..3]) or
    (g_TIItems[1].Item.s.Shape <> g_TIItems[0].Item.s.Eva.EvaTimes + 1)) then begin
    for i := MAXBAGITEMCL - 1 downto 6 do begin
      if (g_ItemArr[i].s.Name <> '') and (g_ItemArr[i].s.StdMode = 56) and (g_ItemArr[i].s.Shape = g_TIItems[0].Item.s.Eva.EvaTimes + 1) then begin
        if g_TIItems[1].Item.s.Name <> '' then begin
          cu := g_TIItems[1].Item;
          g_TIItems[1].Item := g_ItemArr[i];
          g_TIItems[1].Index := i;
          g_ItemArr[i] := cu;
        end else begin
          g_TIItems[1].Item := g_ItemArr[i];
          g_TIItems[1].Index := i;
          g_ItemArr[i].s.Name := '';
        end;
        Break;
      end;
    end;
  end;
end;

procedure AutoPutOntiSecretBooks();
var
  i: Integer;
  cu: TClientItem;
begin
  if FrmDlg.DWSP.Visible and (FrmDlg.DWSP.tag = 1) and
    (g_spItems[0].Item.s.Name <> '') and
    (g_spItems[0].Item.s.Eva.EvaTimesMax > 0) and
    ((g_spItems[1].Item.s.Name = '') or
    (g_spItems[1].Item.s.StdMode <> 56) or
    (g_spItems[1].Item.s.Shape <> 0)) then begin
    for i := MAXBAGITEMCL - 1 downto 6 do begin
      if (g_ItemArr[i].s.Name <> '') and (g_ItemArr[i].s.StdMode = 56) and (g_ItemArr[i].s.Shape = 0) then begin
        if g_spItems[1].Item.s.Name <> '' then begin
          cu := g_spItems[1].Item;
          g_spItems[1].Item := g_ItemArr[i];
          g_spItems[1].Index := i;
          g_ItemArr[i] := cu;
        end else begin
          g_spItems[1].Item := g_ItemArr[i];
          g_spItems[1].Index := i;
          g_ItemArr[i].s.Name := '';
        end;
        Break;
      end;
    end;
  end;
end;

procedure AutoPutOntiCharms();
var
  i, n: Integer;
  cu: TClientItem;
begin
  n := 0;
  if FrmDlg.DWTI.Visible and (FrmDlg.DWTI.tag = 2) and
    (g_TIItems[0].Item.s.Name <> '') and
    (g_TIItems[0].Item.s.Eva.EvaTimesMax > 0) and
    (g_TIItems[0].Item.s.Eva.EvaTimes > 0) and
    ((g_TIItems[1].Item.s.Name = '') or (g_TIItems[1].Item.s.StdMode <> 41) or (g_TIItems[1].Item.s.Shape <> 30)) then begin
    n := 1;
    for i := MAXBAGITEMCL - 1 downto 6 do begin
      n := 2;
      if (g_ItemArr[i].s.Name <> '') and (g_ItemArr[i].s.StdMode = 41) and (g_ItemArr[i].s.Shape = 30) then begin
        n := 3;
        if g_TIItems[1].Item.s.Name <> '' then begin
          n := 4;
          cu := g_TIItems[1].Item;
          g_TIItems[1].Item := g_ItemArr[i];
          g_TIItems[1].Index := i;
          g_ItemArr[i] := cu;
        end else begin
          n := 5;
          g_TIItems[1].Item := g_ItemArr[i];
          g_TIItems[1].Index := i;
          g_ItemArr[i].s.Name := '';
        end;
        Break;
      end;
    end;
  end;
  //DScreen.AddChatBoardString(inttostr(n), clWhite, GetRGB($FC));
end;

function GetSuiteAbil(idx, Shape: Integer; var sa: TtSuiteAbil): Boolean;
var
  i: Integer;
begin
  FillChar(sa, SizeOf(sa), 0);
  case idx of
    1: begin
        for i := Low(TtSuiteAbil) to High(TtSuiteAbil) do begin
          if (g_UseItems[i].s.Name <> '') and ((g_UseItems[i].s.Shape = Shape) or (g_UseItems[i].s.AniCount = Shape)) then
            sa[i] := 1;
        end;
      end;
    2: for i := Low(TtSuiteAbil) to High(TtSuiteAbil) do begin
        if (g_HeroUseItems[i].s.Name <> '') and ((g_HeroUseItems[i].s.Shape = Shape) or (g_HeroUseItems[i].s.AniCount = Shape)) then
          sa[i] := 1;
      end;
    3: for i := Low(TtSuiteAbil) to High(TtSuiteAbil) do begin
        if (UserState1.UseItems[i].s.Name <> '') and ((UserState1.UseItems[i].s.Shape = Shape) or (UserState1.UseItems[i].s.AniCount = Shape)) then
          sa[i] := 1;
      end;
  end;
end;

procedure ScreenChanged();
begin
  g_TileMapOffSetX := Round(SCREENWIDTH div 2 / UNITX) + 1;
  g_TileMapOffSetY := Round(SCREENHEIGHT div 2 / UNITY);
  AAX := (SCREENWIDTH - UNITX) div 2 mod UNITX;

  LMX := Round(SCREENWIDTH / UNITX * 2) + 4; //30
  LMY := Round((SCREENHEIGHT - 150) / UNITX * 2); //26;
end;

function ShiftYOffset(): Integer;
begin
  Result := Round((SCREENHEIGHT - 150) / UNITY / 2) * UNITY - HALFY;
end;

procedure InitScreenConfig();
var
  i: Integer;
  ini: TIniFile;
begin
  ini := TIniFile.Create('.\lscfg.ini');
  SCREENWIDTH := ini.ReadInteger('Setup', 'SCREENWIDTH', 800);
  SCREENHEIGHT := ini.ReadInteger('Setup', 'SCREENHEIGHT', 600);
  g_Windowed := ini.ReadBool('Setup', 'Windowed', True);
  ini.Free;

  BOTTOMTOP := SCREENHEIGHT - 251;
  WINRIGHT := SCREENWIDTH - 100;
  BOTTOMEDGE := SCREENHEIGHT - 19;
  SURFACEMEMLEN := ((SCREENWIDTH + 3) div 4) * 4 * SCREENHEIGHT;
  BOXWIDTH := (SCREENWIDTH div 2 - 214) * 2;

  with g_SkidAD_Rect do begin //屏幕顶部滚动公告-范围
    Left := 5;
    Top := 7;
    Right := SCREENWIDTH - 5;
    Bottom := 7 + 20;
  end;

  with g_SkidAD_Rect2 do begin
    Left := 183;
    Top := 6;
    Right := SCREENWIDTH - 208;
    Bottom := 6 + 20;
  end;

  with G_RC_LEVEL do begin
    Left := SCREENWIDTH - 800 + 664;
    Top := 144;
    Right := SCREENWIDTH - 800 + 664 + 34;
    Bottom := 144 + 14;
  end;
  with G_RC_EXP do begin
    Left := SCREENWIDTH - 800 + 666;
    Top := 178;
    Right := SCREENWIDTH - 800 + 666 + 72;
    Bottom := 178 + 14;
  end;
  with G_RC_WEIGTH do begin
    Left := SCREENWIDTH - 800 + 666;
    Top := 212;
    Right := SCREENWIDTH - 800 + 666 + 72;
    Bottom := 212 + 14;
  end;
  with G_RC_SQUENGINER do begin
    Left := 78;
    Top := 90;
    Right := Left + 16;
    Bottom := Top + 95;
  end;
  with G_RC_IMEMODE do begin
    Left := SCREENWIDTH - 270 - 65;
    Top := 105;
    Right := Left + 60;
    Bottom := Top + 9;
  end;
end;

function IsInMyRange(Act: TActor): Boolean;
begin
  Result := False;
  if (Act = nil) or (g_MySelf = nil) then
    Exit;
  if (abs(Act.m_nCurrX - g_MySelf.m_nCurrX) <= (g_TileMapOffSetX - 2)) and (abs(Act.m_nCurrY - g_MySelf.m_nCurrY) <= (g_TileMapOffSetY - 1)) then
    Result := True;
end;

function IsItemInMyRange(X, Y: Integer): Boolean;
begin
  Result := False;
  if (g_MySelf = nil) then
    Exit;
  if (abs(X - g_MySelf.m_nCurrX) <= _MIN(24, g_TileMapOffSetX + 9)) and (abs(Y - g_MySelf.m_nCurrY) <= _MIN(24, (g_TileMapOffSetY + 10))) then
    Result := True;
end;

function GetTitle(nItemIdx: Integer): pTClientStdItem;
begin
  Result := nil;
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (g_TitlesList.Count > nItemIdx) then begin
    if pTStdItem(g_TitlesList.Items[nItemIdx]).Name <> '' then
      Result := g_TitlesList.Items[nItemIdx];
  end;
end;
procedure CopyStrToClipboard(sStr: string);
var
  Clipboard: TClipboard;
begin
  Clipboard := TClipboard.Create;
  Try
    Clipboard.AsText := sStr;
  Finally
    Clipboard.Free;
  End;
end;
initialization
  New(g_APPass);
  New(g_dwThreadTick);
  g_dwThreadTick^ := 0;
//  g_psServerAddr := NewStr('218.213.233.88');


  New(g_pbRecallHero);
  g_pbRecallHero^ := False;



  //InitializeCriticalSection(ProcImagesCS);
  InitializeCriticalSection(ProcMsgCS);
  InitializeCriticalSection(ThreadCS);
  g_APPickUpList := THStringList.Create;
  g_APMobList := THStringList.Create;

  g_ItemsFilter_All := TCnHashTableSmall.Create;
  g_ItemsFilter_All_Def := TCnHashTableSmall.Create;
  g_ItemsFilter_Dress := TStringList.Create;
  g_ItemsFilter_Weapon := TStringList.Create;
  g_ItemsFilter_Headgear := TStringList.Create;
  g_ItemsFilter_Drug := TStringList.Create;
  g_ItemsFilter_Other := TStringList.Create;
  //g_VCLUnZip1 := TVCLUnZip.Create(nil);
  g_SuiteItemsList := TList.Create;
  g_TitlesList := TList.Create;
  g_xMapDescList := TStringList.Create;
  g_xCurMapDescList := TStringList.Create;

finalization
  Dispose(g_APPass);
  //DeleteCriticalSection(ProcImagesCS);
  DeleteCriticalSection(ProcMsgCS);
  DeleteCriticalSection(ThreadCS);
  g_APPickUpList.Free;
  g_APMobList.Free;
  g_ItemsFilter_All.Free;
  g_ItemsFilter_All_Def.Free;
  g_ItemsFilter_Dress.Free;
  g_ItemsFilter_Weapon.Free;
  g_ItemsFilter_Headgear.Free;
  g_ItemsFilter_Drug.Free;
  g_ItemsFilter_Other.Free;
  //g_VCLUnZip1.Free;
  g_SuiteItemsList.Free;

  g_xMapDescList.Free;
  g_xCurMapDescList.Free;

end.



