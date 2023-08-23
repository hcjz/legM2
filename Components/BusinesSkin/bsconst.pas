{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       BusinessSkinForm                                            }
{       Version 9.45                                                }
{                                                                   }
{       Copyright (c) 2000-2011 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit bsconst;

interface

resourcestring

  BS_MI_MINCAPTION = '��С��(&N)';
  BS_MI_MAXCAPTION = '���(&X)';
  BS_MI_CLOSECAPTION = '�ر�(&C)';
  BS_MI_RESTORECAPTION = '�ָ�(&R)';
  BS_MI_MINTOTRAYCAPTION = '��С��������(&T)';
  BS_MI_ROLLUPCAPTION = '����(&L)';

  BS_MINBUTTON_HINT = '��С��';
  BS_MAXBUTTON_HINT = '���';
  BS_CLOSEBUTTON_HINT = '�ر�';
  BS_TRAYBUTTON_HINT = '��С��������';
  BS_ROLLUPBUTTON_HINT = '����';
  BS_MENUBUTTON_HINT = 'ϵͳ�˵�';
  BS_RESTORE_HINT = '�ָ�';

  BS_EDIT_UNDO = '����';
  BS_EDIT_COPY = '����';
  BS_EDIT_CUT = '����';
  BS_EDIT_PASTE = 'ճ��';
  BS_EDIT_DELETE = 'ɾ��';
  BS_EDIT_SELECTALL = 'ȫ��ѡ��';

  BS_MSG_BTN_YES = '��(&Y)';
  BS_MSG_BTN_NO = '��(&N)';
  BS_MSG_BTN_OK = 'ȷ��';
  BS_MSG_BTN_CLOSE = '�ر�';
  BS_MSG_BTN_CANCEL = 'ȡ��';
  BS_MSG_BTN_ABORT = '��ֹ(&A)';
  BS_MSG_BTN_RETRY = '����(&R)';
  BS_MSG_BTN_IGNORE = '����(&I)';
  BS_MSG_BTN_ALL = 'ȫ��(&A)';
  BS_MSG_BTN_NOTOALL = 'ȫ����(&O)';
  BS_MSG_BTN_YESTOALL = 'ȫ����(&Y)';
  BS_MSG_BTN_HELP = '����(&H)';
  BS_MSG_BTN_OPEN = '��(&O)';
  BS_MSG_BTN_SAVE = '����(&S)';

  BS_MSG_BTN_BACK_HINT = 'ת�������ʵ��ļ���';
  BS_MSG_BTN_UP_HINT = '����';
  BS_MSG_BTN_NEWFOLDER_HINT = '�½��ļ���';
  BS_MSG_BTN_VIEWMENU_HINT = '�鿴�˵�';
  BS_MSG_BTN_STRETCH_HINT = '����ͼ��';


  BS_MSG_FILENAME = '�ļ���:';
  BS_MSG_FILETYPE = '�ļ�����:';
  BS_MSG_NEWFOLDER = '�½��ļ���';
  BS_MSG_LV_DETAILS = '��ϸ��Ϣ';
  BS_MSG_LV_ICON = '��ͼ��';
  BS_MSG_LV_SMALLICON = 'Сͼ��';
  BS_MSG_LV_LIST = '�б�';
  BS_MSG_PREVIEWSKIN = 'Ԥ��';
  BS_MSG_PREVIEWBUTTON = '��ť';
  BS_MSG_OVERWRITE = '����ԭ�����ļ���?';

  BS_MSG_CAP_WARNING = '����';
  BS_MSG_CAP_ERROR = '����';
  BS_MSG_CAP_INFORMATION = '��Ϣ';
  BS_MSG_CAP_CONFIRM = 'ȷ��';
  BS_MSG_CAP_SHOWFLAG = '������ʾ����Ϣ';

  BS_CALC_CAP = '������';
  BS_ERROR = '����';

  BS_COLORGRID_CAP = '������ɫ';
  BS_CUSTOMCOLORGRID_CAP = '�Զ�����ɫ';
  BS_ADDCUSTOMCOLORBUTTON_CAP = '��ӵ��Զ�����ɫ';

  BS_FONTDLG_COLOR = '��ɫ:';
  BS_FONTDLG_NAME = '����:';
  BS_FONTDLG_SIZE = '�ֺ�:';
  BS_FONTDLG_HEIGHT = '�߶�:';
  BS_FONTDLG_EXAMPLE = 'ʾ��:';
  BS_FONTDLG_STYLE = '����:';
  BS_FONTDLG_SCRIPT = '�ַ���:';

  BS_DBNAV_FIRST_HINT = '�׼�¼';
  BS_DBNAV_PRIOR_HINT = 'ǰһ��¼';
  BS_DBNAV_NEXT_HINT = '��һ��¼';
  BS_DBNAV_LAST_HINT = 'ĩ��¼';
  BS_DBNAV_INSERT_HINT = '�����¼';
  BS_DBNAV_DELETE_HINT = 'ɾ����¼';
  BS_DBNAV_EDIT_HINT = '�༭��¼';
  BS_DBNAV_POST_HINT = '�����޸�';
  BS_DBNAV_CANCEL_HINT = 'ȡ���޸�';
  BS_DBNAV_REFRESH_HINT = 'ˢ�¼�¼';

  BS_DB_DELETE_QUESTION = 'ɾ���˼�¼��?';
  BS_DB_MULTIPLEDELETE_QUESTION = 'ɾ������ѡ��ļ�¼��?';

  BS_NODISKINDRIVE = '������û�д��̻���������û��׼����';
  BS_NOVALIDDRIVEID = '�Ƿ�������������';

  BS_FLV_NAME = '����';
  BS_FLV_SIZE = '��С';
  BS_FLV_TYPE = '����';
  BS_FLV_LOOKIN = '����:  ';
  BS_FLV_MODIFIED = '�޸�ʱ��';
  BS_FLV_ATTRIBUTES = '����';
  BS_FLV_DISKSIZE = '���̿ռ�';
  BS_FLV_FREESPACE = '���ÿռ�';

  BS_PRNSTATUS_Paused = '��ͣ';
  BS_PRNSTATUS_PendingDeletion = '����ɾ��';
  BS_PRNSTATUS_Busy = 'æ';
  BS_PRNSTATUS_DoorOpen = '���ų���';
  BS_PRNSTATUS_Error = '����';
  BS_PRNSTATUS_Initializing = '���ڳ�ʼ��';
  BS_PRNSTATUS_IOActive = 'IO Active';
  BS_PRNSTATUS_ManualFeed = '�ֶ���ֽ';
  BS_PRNSTATUS_NoToner = 'û��ī��';
  BS_PRNSTATUS_NotAvailable = '������';
  BS_PRNSTATUS_OFFLine = '�ѻ�';
  BS_PRNSTATUS_OutOfMemory = '�ڴ����';
  BS_PRNSTATUS_OutBinFull = '��������';
  BS_PRNSTATUS_PagePunt = '��ֽ';
  BS_PRNSTATUS_PaperJam = '��ֽ';
  BS_PRNSTATUS_PaperOut = 'ȱֽ';
  BS_PRNSTATUS_PaperProblem = 'ֽ������';
  BS_PRNSTATUS_Printing = '��ӡ';
  BS_PRNSTATUS_Processing = '����';
  BS_PRNSTATUS_TonerLow = 'ī�۲���';
  BS_PRNSTATUS_UserIntervention = '�û�ȡ��';
  BS_PRNSTATUS_Waiting = '�ȴ�';
  BS_PRNSTATUS_WarningUp = 'Ԥ��';
  BS_PRNSTATUS_Ready = '����';
  BS_PRNSTATUS_PrintingAndWaiting = '���ڴ�ӡ: %d �ĵ�,��ȴ�';
  BS_PRNDLG_PRINTER = '��ӡ��';
  BS_PRNDLG_NAME = '����:';
  BS_PRNDLG_PROPERTIES = '����...';
  BS_PRNDLG_STATUS = '״̬:';
  BS_PRNDLG_TYPE = '����:';
  BS_PRNDLG_WHERE = 'λ��:';
  BS_PRNDLG_COMMENT = '��ע:';
  BS_PRNDLG_PRINTRANGE = 'ҳ�淶Χ';
  BS_PRNDLG_COPIES = '����';
  BS_PRNDLG_NUMCOPIES = '����:';
  BS_PRNDLG_COLLATE = '��ݴ�ӡ';
  BS_PRNDLG_ALL = 'ȫ��';
  BS_PRNDLG_PAGES = 'ҳ�淶Χ';
  BS_PRNDLG_SELECTION = '��ǰ����';
  BS_PRNDLG_FROM = '��:';
  BS_PRNDLG_TO = '��:';
  BS_PRNDLG_PRINTTOFILE = '��ӡ���ļ�';
  BS_PRNDLG_ORIENTATION = '����';
  BS_PRNDLG_PAPER = 'ֽ��';
  BS_PRNDLG_PORTRAIT = '����';
  BS_PRNDLG_LANDSCAPE = '����';
  BS_PRNDLG_SOURCE = 'ֽ����Դ:';
  BS_PRNDLG_SIZE = 'ֽ��:';
  BS_PRNDLG_MARGINS = 'ҳ�߾� (����)';
  BS_PRNDLG_MARGINS_INCHES = 'ҳ�߾� (Ӣ��)';
  BS_PRNDLG_LEFT = '��:';
  BS_PRNDLG_RIGHT = '��:';
  BS_PRNDLG_TOP = '��:';
  BS_PRNDLG_BOTTOM = '��:';
  BS_PRNDLG_WARNING = 'ϵͳ��û�а�װ��ӡ��!';
  BS_FIND_NEXT = '������һ��';
  BS_FIND_WHAT = '��������:';
  BS_FIND_DIRECTION = '����';
  BS_FIND_DIRECTIONUP = '����';
  BS_FIND_DIRECTIONDOWN = '����';
  BS_FIND_MATCH_CASE = '���ִ�Сд';
  BS_FIND_MATCH_WHOLE_WORD_ONLY = 'ȫ��ƥ��';
  BS_FIND_REPLACE_WITH = '�滻Ϊ:';
  BS_FIND_REPLACE = '�滻';
  BS_FIND_REPLACE_All = 'ȫ���滻';

  BS_MORECOLORS = '������ɫ...';
  BS_AUTOCOLOR = '�Զ�����ɫ';
  BS_CUSTOMCOLOR = '������ɫ...';

  BS_DBNAV_FIRST = '��һ��';
  BS_DBNAV_PRIOR = '��һ��';
  BS_DBNAV_NEXT = '��һ��';
  BS_DBNAV_LAST = '���һ��';
  BS_DBNAV_INSERT = '����';
  BS_DBNAV_DELETE = 'ɾ��';
  BS_DBNAV_EDIT = '�༭';
  BS_DBNAV_POST = '�ύ';
  BS_DBNAV_CANCEL = '����';
  BS_DBNAV_REFRESH = 'ˢ��';

implementation

end.
