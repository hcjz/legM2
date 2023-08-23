unit MShare;

interface

uses
  Windows, WIL;


type
  TImagesStatus = (isNone, isReady);
  TWMFileType = (wtWil, wtWis, wtWiz);
  
  TImagesInfo = packed record
    szFileName:string[32];              //�ļ�����
    dwRecord:LongWord;                  //�ļ���ʶ(��������TWMImages����)
    wfFormat:TWILColorFormat;           //��ɫ��ʽ
  end;

  TWMImages = packed record
    dwRecord:LongWord;                  //�ļ���ʶ
    dwImages:LongWord;                  //��Դ���
    dwTrans:LongWord;                   //��Դ��С
    isStatus:TImagesStatus;             //��Դ״̬
    ftType:TWMFileType;                 //�ļ�����
    wtType:TWILType;                    //ѹ������(t_wmM2Def, t_wmM2wis, t_wmM2Zip)
  end;


implementation

end.
 