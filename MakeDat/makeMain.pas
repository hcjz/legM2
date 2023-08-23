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
    ShowMessage('授权终止日期不能是空值，请正确填写！！！');
    Exit;
  end;

  //url := 'http://www.ramm2.com';//登录器和登录网关进行沟通时的暗号
  url := Edit4.Text;//登录器和登录网关进行沟通时的通讯密钥
  DCP_mars.InitStr('');
  enkey := DCP_mars.EncryptString(url);//第一次加密，Key是空串

{$IFDEF  FREE}
  DCP_mars.InitStr('legendm2 gate free'); //如果定义Free，则以ram gate free作为Key
{$ELSE}
  DCP_mars.InitStr('legendm2 gate');//否则，则以ram gate作为Key
{$ENDIF}

  enurl2 := DCP_mars.EncryptString(enkey);//第二次加密
  edHeader.nStrLen := Length(enurl2);//记下enurl的长度，写入enHeader.nStrLen，enurl是url这个串，经过两次加密得到
  //ShowMessage(enurl2 + '            ' + InttoStr(Length(enurl2))); //去除提示 2018-08-24

  //scet := '快去找美元';//自己随便写一个串，并把这个串的长度写入edHeader.nGetLen
  scet := Trim(EndDate_Edit.Text);
  edHeader.nCetLen := Length(scet);

  DCP_mars.InitStr(enkey); //此时enkey作为密钥来初始化
  //encet := DCP_mars.EncryptString(scet);

  FillChar(pszBuffer, 4096, #0);//填充pszBuffer这个数组，相当于一块内存区，并把它的起始位置地址赋给g_gszEndePtr
  g_pszEndePtr := @pszBuffer[0];//以便于通过g_pszEndePtr指针对数组进行操作

  DCP_mars.Encrypt(scet[1], pszBuffer[0], edHeader.nCetLen);
  //ShowMessage('g_pszEndePtr is: ' + g_pszEndePtr); //去除提示 2018-08-24

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
  edHeader.nLoginToolCrc := 128;//直接给enHeader.nLoginToolCrc赋值，？

  DCP_mars.InitStr('LEGEND LoginGate - edHeader 20190131');//这里以RAMM2 LoginGate - edHeader 20160201作为密钥
  DCP_mars.EncryptCFB8bit(edHeader, edHeader2, Sizeof(TEDHeader));//加密edHeader结构，并写入edHeader2这个结构中

  gs := TMemoryStream.Create;//保存待写入LoginGate.exe尾部的数据
  ts := TMemoryStream.Create;//保存待写入的总数据


  //必须把字符串enurl2复制到字符数组temp中，再写入流，直接写字符串会出错
  Move(enurl2[1], temp[0], Length(enurl2));

  //ShowMessage(temp); //去除提示 2018-08-24

  gs.Write(temp, Length(enurl2)); //写入enurl2，enurl2经过两次加密
  gs.Write(g_pszEndePtr^, edHeader.nCetLen);//写入加密后的scet  加密前 scet := '快去找美元'
  gs.Write(edHeader2, Sizeof(TEDHeader));//写入加密后的edHeader2结构
  gs.Position := 0;
  //后面要把gs这个流整体写入到ts流中去，gs流最后要写到登录网关的尾部去

  //gs.SaveToFile('d:\gateinfo.dat');

  {gs.Position := 0;
  gs.Read(buf, edHeader.nStrLen);
  buf[edHeader.nStrLen] := #0;
  ShowMessage(buf);}    


  //对窗体上各个编辑框中的内容，并分别进行加密后，写入rcHeader的相应域中去
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

  DCP_mars.InitStr('sWebSite');//官方网站
  WebSite := DCP_mars.EncryptString(Edit4.Text);  {ShowMessage(Edit4.Text);}//去除提示 2018-08-24
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
  //ShowMessage(SerList2); //去除提示 2018-08-24
  rcHeader.GameList2 := SerList2;

  DCP_mars.InitStr('sSiteUrl');
  UpUrl := DCP_mars.EncryptString(Edit8.Text);
  //ShowMessage(UpUrl); //去除提示 2018-08-24
  rcHeader.sSiteUrl := UpUrl; 

  DCP_mars.InitStr('sLuiName2');
  EndDate := DCP_mars.EncryptString(EndDate_Edit.Text);
  //ShowMessage(EndDate);
  rcHeader.sLuiName2 := EndDate;

  DCP_mars.InitStr('sWebLink');
  //ShowMessage(DCP_mars.DecryptString(rcHeader.sWebLink)); //去除提示 2018-08-24

{$IFDEF FREE}
  DCP_mars.InitStr('blue free');
{$ELSE}
  DCP_mars.InitStr('blue');
{$ENDIF}
  DCP_mars.Encrypt(rcHeader, rcHeader2, SizeOf(TRcHeader));//加密rcHeader中的数据，存入rcHeader2中


  edHeader_t.nLoginToolCrc := 12800;//为什么是12800 ？？
  edHeader_t.nCetLen := Sizeof(TRCHeader);//这个值是RcHeader结构的长度
  edHeader_t.nStrLen := gs.Size; //这个值是加到LoginGate.exe尾部数据的长度

  DCP_mars.InitStr('MIR2EX - edHeader 20160201');//edHeader_t和edHeader都是用同一个Key进行加密
  DCP_mars.EncryptCFB8bit(edHeader_t, EDHeader2_t, SizeOf(TedHeader));//加密edHeader_t，并存入到EDHeader2_t中去

  ts.CopyFrom(gs, gs.Size);//把gs流整体写入ts之中
  ts.Write(rcHeader2, edHeader_t.nCetLen);//把加密后的rcHeader2写入ts，rcHeader2中保存的是加密后的rcHeader
  ts.Write(EDHeader2_t, Sizeof(TedHeader)); //把加密后的edHeader_t写入ts，EDHeader2_t中保存的是edHeader
  ts.Position := 0;
  ShowMessage('授权文件config.dat生成成功！');
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
    ShowMessage('授权终止日期不能是空值，请正确填写！！！');
    Exit;
  end;

  DCP_mars.InitStr('sCompany');
  Company := DCP_mars.EncryptString(Edit1.Text);
  //ShowMessage(Company); //去除提示 2018-08-24
  rcHeader.sCompany := Company;

  DCP_mars.InitStr('sFileName');
  AppTitle := DCP_mars.EncryptString(Edit2.Text);
  //ShowMessage(AppTitle); //去除提示 2018-08-24
  rcHeader.sFileName := AppTitle;

  //DCP_mars.InitStr('sWebLink');
  //InfoUrl := DCP_mars.EncryptString(Edit3.Text);
    InfoUrl := Edit3.Text;
  //ShowMessage(InfoUrl);  //去除提示 2018-08-24
  rcHeader.sWebLink := InfoUrl;

  DCP_mars.InitStr('sWebSite');
  WebSite := DCP_mars.EncryptString(Edit4.Text);
  //ShowMessage(WebSite); //去除提示 2018-08-24
  rcHeader.sWebSite := WebSite;

  DCP_mars.InitStr('sBbsSite');
  BBSSite := DCP_mars.EncryptString(Edit5.Text);
  //ShowMessage(BBSSite); //去除提示 2018-08-24
  rcHeader.sBbsSite := BBSSite;

  DCP_mars.InitStr('GameList');
  SerList := DCP_mars.EncryptString(Edit6.Text);
  //ShowMessage(SerList);  //去除提示 2018-08-24
  rcHeader.GameList := SerList;

  DCP_mars.InitStr('GameList2');
  SerList2 := DCP_mars.EncryptString(Edit7.Text);
  //ShowMessage(SerList2); //去除提示 2018-08-24
  rcHeader.GameList2 := SerList2;

  DCP_mars.InitStr('sLuiName2');
  EndDate := DCP_mars.EncryptString(EndDate_Edit.Text);
  //ShowMessage(EndDate); //去除提示 2018-08-24
  rcHeader.sLuiName2 := EndDate;

  DCP_mars.InitStr('sWebLink');
  //ShowMessage(DCP_mars.DecryptString(rcHeader.sWebLink)); //去除提示 2018-08-24

  edHeader.nLoginToolCrc := 12800;
  edHeader.nCetLen := Sizeof(TRCHeader);
  edHeader.nStrLen := 999; //这个值是应该加到LoginGate.exe尾部数据的长度

  DCP_mars.InitStr('MIR2EX - edHeader 20160201');
  DCP_mars.EncryptCFB8bit(edHeader, EDHeader2, SizeOf(TedHeader));
  ShowMessage('授权文件检查完成OK！');
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
