unit makeMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Mars, Grobal2, D7ScktComp,jpeg,ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Edit7: TEdit;
    Label8: TLabel;
    Edit8: TEdit;
    Label9: TLabel;
    Button2: TButton;
    Button3: TButton;
    EndDate_Edit: TEdit;
    ImageBack: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }

    DCP_mars: TDCP_mars;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
var
  edHeader, edHeader2: TEdHeader;
  edHeader_t, edHeader2_t: TEdHeader;
  url, enkey, enurl2: String;
  scet, encet, decet: String;
  gs, ts: TMemoryStream;
  pszBuffer: array[0..4096 - 1] of Char;
  g_pszEndePtr: pChar;
  temp, buf: array[0..2048 - 1] of Char;

  rcHeader, rcHeader2: TRCHeader;
  Company, AppTitle, InfoUrl, WebSite, BBSSite,
  SerList, SerList2, UpUrl, EndDate: String;


  tBuffer: array[0..4096 - 1] of Char;
  tPtr: pChar;
begin
  if EndDate_Edit.Text = '' then begin
    ShowMessage('��Ȩ��ֹ���ڲ����ǿ�ֵ������ȷ��д������');
    Exit;
  end;

  //url := 'http://www.ramm2.com';//��¼���͵�¼���ؽ��й�ͨʱ�İ���
  url := Edit4.Text;//��¼���͵�¼���ؽ��й�ͨʱ��ͨѶ��Կ
  DCP_mars.InitStr('');
  enkey := DCP_mars.EncryptString(url);//��һ�μ��ܣ�Key�ǿմ�

{$IFDEF  FREE}
  DCP_mars.InitStr('legendm2 gate free'); //�������Free������ram gate free��ΪKey
{$ELSE}
  DCP_mars.InitStr('legendm2 gate');//��������ram gate��ΪKey
{$ENDIF}

  enurl2 := DCP_mars.EncryptString(enkey);//�ڶ��μ���
  edHeader.nStrLen := Length(enurl2);//����enurl�ĳ��ȣ�д��enHeader.nStrLen��enurl��url��������������μ��ܵõ�
  //ShowMessage(enurl2 + '            ' + InttoStr(Length(enurl2))); //ȥ����ʾ 2018-08-24

  //scet := '��ȥ����Ԫ';//�Լ����дһ����������������ĳ���д��edHeader.nGetLen
  scet := Trim(EndDate_Edit.Text);
  edHeader.nCetLen := Length(scet);

  DCP_mars.InitStr(enkey); //��ʱenkey��Ϊ��Կ����ʼ��
  //encet := DCP_mars.EncryptString(scet);

  FillChar(pszBuffer, 4096, #0);//���pszBuffer������飬�൱��һ���ڴ���������������ʼλ�õ�ַ����g_gszEndePtr
  g_pszEndePtr := @pszBuffer[0];//�Ա���ͨ��g_pszEndePtrָ���������в���

  DCP_mars.Encrypt(scet[1], pszBuffer[0], edHeader.nCetLen);
  //ShowMessage('g_pszEndePtr is: ' + g_pszEndePtr); //ȥ����ʾ 2018-08-24

  {FillChar(tBuffer, 4096, #0);
  tPtr := @tBuffer[0];
  DCP_mars.InitStr(enkey);
  DCP_mars.Decrypt(pszBuffer, tBuffer, edHeader.nCetLen);
  ShowMessage('pPtr is:  ' + tPtr);}


  {TedHeader = packed record
    nStrLen: Integer;
    nCetLen: Integer;
    nLoginToolCrc: Integer;
  end;}
  edHeader.nLoginToolCrc := 128;//ֱ�Ӹ�enHeader.nLoginToolCrc��ֵ����

  DCP_mars.InitStr('LEGEND LoginGate - edHeader 20190131');//������RAMM2 LoginGate - edHeader 20160201��Ϊ��Կ
  DCP_mars.EncryptCFB8bit(edHeader, edHeader2, Sizeof(TEDHeader));//����edHeader�ṹ����д��edHeader2����ṹ��

  gs := TMemoryStream.Create;//�����д��LoginGate.exeβ��������
  ts := TMemoryStream.Create;//�����д���������


  //������ַ���enurl2���Ƶ��ַ�����temp�У���д������ֱ��д�ַ��������
  Move(enurl2[1], temp[0], Length(enurl2));

  //ShowMessage(temp); //ȥ����ʾ 2018-08-24

  gs.Write(temp, Length(enurl2)); //д��enurl2��enurl2�������μ���
  gs.Write(g_pszEndePtr^, edHeader.nCetLen);//д����ܺ��scet  ����ǰ scet := '��ȥ����Ԫ'
  gs.Write(edHeader2, Sizeof(TEDHeader));//д����ܺ��edHeader2�ṹ
  gs.Position := 0;
  //����Ҫ��gs���������д�뵽ts����ȥ��gs�����Ҫд����¼���ص�β��ȥ

  //gs.SaveToFile('d:\gateinfo.dat');

  {gs.Position := 0;
  gs.Read(buf, edHeader.nStrLen);
  buf[edHeader.nStrLen] := #0;
  ShowMessage(buf);}    


  //�Դ����ϸ����༭���е����ݣ����ֱ���м��ܺ�д��rcHeader����Ӧ����ȥ
  DCP_mars.InitStr('sCompany');
  Company := DCP_mars.EncryptString(Edit1.Text);
  //ShowMessage(Company);
  rcHeader.sCompany := Company;

  DCP_mars.InitStr('sFileName');
  AppTitle := DCP_mars.EncryptString(Edit2.Text);
  //ShowMessage(AppTitle);
  rcHeader.sFileName := AppTitle;

  //DCP_mars.InitStr('sWebLink');
//  InfoUrl := DCP_mars.EncryptString(Edit3.Text);
  //ShowMessage(InfoUrl);
    InfoUrl := Edit3.Text;
  rcHeader.sWebLink := InfoUrl;

  DCP_mars.InitStr('sWebSite');//�ٷ���վ
  WebSite := DCP_mars.EncryptString(Edit4.Text);  {ShowMessage(Edit4.Text);}//ȥ����ʾ 2018-08-24
  //ShowMessage(WebSite);
  rcHeader.sWebSite := WebSite;

  DCP_mars.InitStr('sBbsSite');
  BBSSite := DCP_mars.EncryptString(Edit5.Text);
  //ShowMessage(BBSSite);
  rcHeader.sBbsSite := BBSSite;

  DCP_mars.InitStr('GameList');
  SerList := DCP_mars.EncryptString(Edit6.Text);
  //ShowMessage(SerList);
  rcHeader.GameList := SerList;

  DCP_mars.InitStr('GameList2');
  SerList2 := DCP_mars.EncryptString(Edit7.Text);
  //ShowMessage(SerList2); //ȥ����ʾ 2018-08-24
  rcHeader.GameList2 := SerList2;

  DCP_mars.InitStr('sSiteUrl');
  UpUrl := DCP_mars.EncryptString(Edit8.Text);
  //ShowMessage(UpUrl); //ȥ����ʾ 2018-08-24
  rcHeader.sSiteUrl := UpUrl; 

  DCP_mars.InitStr('sLuiName2');
  EndDate := DCP_mars.EncryptString(EndDate_Edit.Text);
  //ShowMessage(EndDate);
  rcHeader.sLuiName2 := EndDate;

  DCP_mars.InitStr('sWebLink');
  //ShowMessage(DCP_mars.DecryptString(rcHeader.sWebLink)); //ȥ����ʾ 2018-08-24

{$IFDEF FREE}
  DCP_mars.InitStr('blue free');
{$ELSE}
  DCP_mars.InitStr('blue');
{$ENDIF}
  DCP_mars.Encrypt(rcHeader, rcHeader2, SizeOf(TRcHeader));//����rcHeader�е����ݣ�����rcHeader2��


  edHeader_t.nLoginToolCrc := 12800;//Ϊʲô��12800 ����
  edHeader_t.nCetLen := Sizeof(TRCHeader);//���ֵ��RcHeader�ṹ�ĳ���
  edHeader_t.nStrLen := gs.Size; //���ֵ�Ǽӵ�LoginGate.exeβ�����ݵĳ���

  DCP_mars.InitStr('MIR2EX - edHeader 20160201');//edHeader_t��edHeader������ͬһ��Key���м���
  DCP_mars.EncryptCFB8bit(edHeader_t, EDHeader2_t, SizeOf(TedHeader));//����edHeader_t�������뵽EDHeader2_t��ȥ

  ts.CopyFrom(gs, gs.Size);//��gs������д��ts֮��
  ts.Write(rcHeader2, edHeader_t.nCetLen);//�Ѽ��ܺ��rcHeader2д��ts��rcHeader2�б�����Ǽ��ܺ��rcHeader
  ts.Write(EDHeader2_t, Sizeof(TedHeader)); //�Ѽ��ܺ��edHeader_tд��ts��EDHeader2_t�б������edHeader
  ts.Position := 0;
  ShowMessage('��Ȩ�ļ�config.dat���ɳɹ���');
  ts.SaveToFile('.\config.dat');

  gs.Free;
  ts.Free;


end;

procedure TForm1.Button3Click(Sender: TObject);
var
  edHeader, EDHeader2: TEDHeader;
  rcHeader: TRCHeader;
  Company, AppTitle, InfoUrl, WebSite, BBSSite,
  SerList, SerList2, EndDate: String;
begin
  if EndDate_Edit.Text = '' then begin
    ShowMessage('��Ȩ��ֹ���ڲ����ǿ�ֵ������ȷ��д������');
    Exit;
  end;

  DCP_mars.InitStr('sCompany');
  Company := DCP_mars.EncryptString(Edit1.Text);
  //ShowMessage(Company); //ȥ����ʾ 2018-08-24
  rcHeader.sCompany := Company;

  DCP_mars.InitStr('sFileName');
  AppTitle := DCP_mars.EncryptString(Edit2.Text);
  //ShowMessage(AppTitle); //ȥ����ʾ 2018-08-24
  rcHeader.sFileName := AppTitle;

  //DCP_mars.InitStr('sWebLink');
  //InfoUrl := DCP_mars.EncryptString(Edit3.Text);
    InfoUrl := Edit3.Text;
  //ShowMessage(InfoUrl);  //ȥ����ʾ 2018-08-24
  rcHeader.sWebLink := InfoUrl;

  DCP_mars.InitStr('sWebSite');
  WebSite := DCP_mars.EncryptString(Edit4.Text);
  //ShowMessage(WebSite); //ȥ����ʾ 2018-08-24
  rcHeader.sWebSite := WebSite;

  DCP_mars.InitStr('sBbsSite');
  BBSSite := DCP_mars.EncryptString(Edit5.Text);
  //ShowMessage(BBSSite); //ȥ����ʾ 2018-08-24
  rcHeader.sBbsSite := BBSSite;

  DCP_mars.InitStr('GameList');
  SerList := DCP_mars.EncryptString(Edit6.Text);
  //ShowMessage(SerList);  //ȥ����ʾ 2018-08-24
  rcHeader.GameList := SerList;

  DCP_mars.InitStr('GameList2');
  SerList2 := DCP_mars.EncryptString(Edit7.Text);
  //ShowMessage(SerList2); //ȥ����ʾ 2018-08-24
  rcHeader.GameList2 := SerList2;

  DCP_mars.InitStr('sLuiName2');
  EndDate := DCP_mars.EncryptString(EndDate_Edit.Text);
  //ShowMessage(EndDate); //ȥ����ʾ 2018-08-24
  rcHeader.sLuiName2 := EndDate;

  DCP_mars.InitStr('sWebLink');
  //ShowMessage(DCP_mars.DecryptString(rcHeader.sWebLink)); //ȥ����ʾ 2018-08-24

  edHeader.nLoginToolCrc := 12800;
  edHeader.nCetLen := Sizeof(TRCHeader);
  edHeader.nStrLen := 999; //���ֵ��Ӧ�üӵ�LoginGate.exeβ�����ݵĳ���

  DCP_mars.InitStr('MIR2EX - edHeader 20160201');
  DCP_mars.EncryptCFB8bit(edHeader, EDHeader2, SizeOf(TedHeader));
  ShowMessage('��Ȩ�ļ�������OK��');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Font := Screen.IconFont;
  ShortDateFormat := 'yyyymmdd';
  DCP_mars := TDCP_mars.Create(nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if DCP_mars <> nil then DCP_mars.Free;
end;

end.