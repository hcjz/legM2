unit MakePlugDLL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, HUtil32,
  Dialogs, StdCtrls, XPMan, ExtCtrls, FileCtrl, ShellAPI, ImageHlp,
  OleCtrls, SHDocVw, Jpeg, ComCtrls, LocalDB, RzListVw, CheckLst, RzTreeVw, RzLstBox, RzGrids, Grids,
  BaseGrid, AdvGrid, VCLUnZip, VCLZip, RzPrgres, RzButton, RzRadChk, RzLabel, RzCmboBx, RzBmpBtn,
  SecMan, mars, Menus, SetBtnImage, PngImage, SkinConfig;

type
  TfrmMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    btnCreatePlug: TButton;
    ButtonPic: TButton;
    Edit1: TEdit;
    EditPic: TEdit;
    EditDBName: TEdit;
    btnLoadFromDB: TButton;
    btnSaveToFile: TButton;
    Label3: TLabel;
    Button1: TButton;
    AdvStringGrid1: TAdvStringGrid;
    CheckBox1: TCheckBox;
    OpenDlg: TOpenDialog;
    VCLZip1: TVCLZip;
    VCLUnZip1: TVCLUnZip;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    ImageMain: TImage;
    btnEditGameList: TRzBmpButton;
    btnEditGame: TRzBmpButton;
    RzBmpButton1: TRzBmpButton;
    btnGetBackPassword: TRzBmpButton;
    btnChangePassword: TRzBmpButton;
    RzBmpButton3: TRzBmpButton;
    btnStartGame: TRzBmpButton;
    btNewAccount: TRzBmpButton;
    RzLabel4: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabelStatus: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    PanelServerList: TPanel;
    PanelWebBrowser: TPanel;
    PanelProcessCur: TPanel;
    PanelProcessMax: TPanel;
    Panel2: TPanel;
    ckWindowed: TRzCheckBox;
    Panel3: TPanel;
    Memo1: TMemo;
    TabSheet3: TTabSheet;
    AdvStringGrid2: TAdvStringGrid;
    OpenDialog3: TOpenDialog;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Panel4: TPanel;
    PopStartGame: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    PopWebSite: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    PopZhuangBei: TPopupMenu;
    PopContactUs: TPopupMenu;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    PopRegister: TPopupMenu;
    MenuItem1: TMenuItem;
    N12: TMenuItem;
    PopPass: TPopupMenu;
    MenuItem3: TMenuItem;
    N14: TMenuItem;
    PopFindPass: TPopupMenu;
    MenuItem5: TMenuItem;
    N16: TMenuItem;
    PopExit: TPopupMenu;
    MenuItem7: TMenuItem;
    N18: TMenuItem;
    Button8: TButton;
    Button9: TButton;
    btnMinSize: TRzBmpButton;
    btnColse: TRzBmpButton;
    PopMized: TPopupMenu;
    PopClose: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;

  //private


    procedure btnCreatePlugClick(Sender: TObject);
    procedure ButtonPicClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFromDBClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

    procedure LoadClientPatchConfig(Sender: TObject);
    procedure PanelServerListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure AdvStringGrid2DblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure AdvStringGrid2ButtonClick(Sender: TObject; ACol, ARow: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure N1Click(Sender: TObject);


    procedure InitSetBtnImgForm(Btn: TRzBmpButton);

    procedure DropMoveBtn(aHandle: THandle);
    procedure PrepareDrop;
    procedure Droping(btn: TRzBmpButton);
    procedure DropingLabel(l: TRzLabel);
    procedure DropOver;
    procedure ReadRagSkp(all: String);//��ȡRAGƤ���ļ� 20180831
    procedure BuildRagSkp(all: TMemoryStream);//����RAGƤ���ļ� 20180831

    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure btnStartGameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButton3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditGameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btNewAccountMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnChangePasswordMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnGetBackPasswordMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditGameListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnStartGameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnStartGameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButton3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzBmpButton3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButton1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzBmpButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditGameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnEditGameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btNewAccountMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btNewAccountMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnChangePasswordMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnChangePasswordMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnGetBackPasswordMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnGetBackPasswordMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditGameListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnEditGameListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ckWindowedMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabelStatusMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabelStatusMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabelStatusMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure btnMinSizeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnMinSizeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnMinSizeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnColseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnColseMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnColseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopStartGamePopup(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PopWebSitePopup(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure PopZhuangBeiPopup(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure PopContactUsPopup(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure PopRegisterPopup(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure PopPassPopup(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure PopFindPassPopup(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure PopExitPopup(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure PanelProcessCurMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelProcessMaxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button8Click(Sender: TObject);

  private  
  public
    FPoint: TPoint;
    FMouseDowned: Boolean;



    bShowStartGame,
    bShowWebSite,
    bShowZhuangBei,
    bShowContuctUs,
    bShowAccount,
    bShowChangePass,
    bShowGetBackPass,
    bShowEditGameList: Boolean;

    procedure ManipulateControl(Control: TControl; Shift: TShiftState; X, Y, Precision: Integer);

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  Grobal2;

var
  sPath: string;
  //boBusy                    : boolean = False;
  mJpg: TMemoryStream;
  g_Buffer: array[0..16 * 1024] of Char;

function EncrypStr(Src, Key: string): string; //�ַ������ܺ���
//���ַ�������(Src:Դ Key:�ܳ�)
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  Range: Integer;
begin
  KeyLen := Length(Key);
  if KeyLen = 0 then
    Key := ('legendsoft');
  KeyPos := 0;
  Range := 256;
  Randomize;
  OffSet := 5; //Random(Range);
  dest := Format('%1.2x', [OffSet]);
  for SrcPos := 1 to Length(Src) do begin
    SrcAsc := (Ord(Src[SrcPos]) + OffSet) mod 255;
    if KeyPos < KeyLen then KeyPos := KeyPos + 1
    else KeyPos := 1;
    SrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    dest := dest + Format('%1.2x', [SrcAsc]);
    OffSet := SrcAsc;
  end;
  Result := dest;
end;

function DecrypStr(Src, Key: string): string; //�ַ������ܺ���
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
begin
  KeyLen := Length(Key);
  if KeyLen = 0 then Key := ('legendsoft');
  KeyPos := 0;
  OffSet := StrToInt('$' + Copy(Src, 1, 2));
  SrcPos := 3;
  repeat
    SrcAsc := StrToInt('$' + Copy(Src, SrcPos, 2));
    if KeyPos < KeyLen then KeyPos := KeyPos + 1
    else KeyPos := 1;
    TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
    else TmpSrcAsc := TmpSrcAsc - OffSet;
    dest := dest + Chr(TmpSrcAsc);
    OffSet := SrcAsc;
    SrcPos := SrcPos + 2;
  until SrcPos >= Length(Src);
  Result := dest;
end;


procedure TfrmMain.ManipulateControl(Control: TControl; Shift: TShiftState; X, Y, Precision: Integer);
var
  sc_manipulate: word;
begin
  if (X <= Precision) and (Y > Precision) and (Y < Control.height - Precision) then begin
    sc_manipulate := $F001;
    Control.Cursor := crsizewe;
  end
  else if (X >= Control.width - Precision) and (Y > Precision) and (Y < Control.height - Precision) then begin
    sc_manipulate := $F002;
    Control.Cursor := crsizewe;
  end
  else if (X > Precision) and (X < Control.width - Precision) and (Y <= Precision) then begin
    sc_manipulate := $F003;
    Control.Cursor := crsizens;
  end
  else if (X <= Precision) and (Y <= Precision) then begin
    sc_manipulate := $F004;
    Control.Cursor := crsizenwse;
  end
  else if (X >= Control.width - Precision) and (Y <= Precision) then begin
    sc_manipulate := $F005;
    Control.Cursor := crsizenesw;
  end
  else if (X > Precision) and (X < Control.width - Precision) and (Y >= Control.height - Precision) then begin
    sc_manipulate := $F006;
    Control.Cursor := crsizens;
  end
  else if (X <= Precision) and (Y >= Control.height - Precision) then begin
    sc_manipulate := $F007;
    Control.Cursor := crsizenesw;
  end
  else if (X >= Control.width - Precision) and (Y >= Control.height - Precision) then begin
    sc_manipulate := $F008;
    Control.Cursor := crsizenwse;
  end
  //else if (X > 5) and (Y > 5) and (X < Control.width - 5) and (Y < Control.height - 5) then begin
  else if (X > 1) and (Y > 1) and (X < Control.width - 1) and (Y < Control.height - 1) then begin
    sc_manipulate := $F009;
    Control.Cursor := crsizeall;
  end
  else begin
    sc_manipulate := $F000;
    Control.Cursor := crdefault;
  end;
  if Shift = [ssleft] then begin
    ReleaseCapture;
    Control.perform(wm_syscommand, sc_manipulate, 0);
  end;
end;

procedure TfrmMain.MenuItem1Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtNewAccount);
end;

procedure TfrmMain.MenuItem3Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnChangePassWord);
end;

procedure TfrmMain.MenuItem5Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnGetBackPassWord);
end;

procedure TfrmMain.MenuItem7Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnEditGameList);
end;

procedure TfrmMain.N10Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnColse);
end;

procedure TfrmMain.N12Click(Sender: TObject);
begin
  N12.Checked := not n12.Checked;
  bShowAccount := n12.Checked;
end;

procedure TfrmMain.N14Click(Sender: TObject);
begin
  n14.Checked := not n14.Checked;
  bShowChangePass := n14.Checked;
end;

procedure TfrmMain.N16Click(Sender: TObject);
begin
  n16.Checked := not n16.Checked;
  bShowGetBackPass := n16.Checked;
end;

procedure TfrmMain.N18Click(Sender: TObject);
begin
  n18.Checked := not n18.Checked;
  bShowEditGameList := n18.Checked;
end;

procedure TfrmMain.N1Click(Sender: TObject);
var
  FrmSetBtn: TFrmSetBtnImage;
begin
  {FrmSetBtn := TFrmSetBtnImage.Create(Application);
  FrmSetBtn.Image1.Picture.Bitmap.Assign(BtnStartGame.Bitmaps.Up);
  FrmSetBtn.Image2.Picture.Bitmap.Assign(BtnStartGame.Bitmaps.Hot);
  FrmSetBtn.Image3.Picture.Bitmap.Assign(BtnStartGame.Bitmaps.Down);
  FrmSetBtn.Image4.Picture.Bitmap.Assign(BtnStartGame.Bitmaps.Disabled);
  FrmSetBtn.ShowModal(); }

  //if Sender is TRzBmpButton then ShowMessage((Sender as TRzBmpButton).Caption);
    InitSetBtnImgForm(BtnStartGame);
end;

procedure TfrmMain.N2Click(Sender: TObject);
begin
  n2.Checked := not n2.Checked;
  bShowStartGame := n2.Checked;
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
  InitSetBtnImgForm(RzBmpButton3);
end;

procedure TfrmMain.N4Click(Sender: TObject);
begin
  n4.Checked := not n4.Checked;
  bShowWebSite := n4.Checked;
end;

procedure TfrmMain.N5Click(Sender: TObject);
begin
  InitSetBtnImgForm(RzBmpButton1);
end;

procedure TfrmMain.N6Click(Sender: TObject);
begin
  n6.Checked := not n6.Checked;
  bShowZhuangBei := n6.Checked;
end;

procedure TfrmMain.N7Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnEditGame);
end;

procedure TfrmMain.N8Click(Sender: TObject);
begin
  n8.Checked := not n8.Checked;
  bShowContuctUs := n8.Checked;
end;

procedure TfrmMain.N9Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnMinSize);
end;

function SetResInfo(ResType, ResName, ResNewName: string): Boolean;
var
  PlugRes: TResourceStream;
begin
  try
    PlugRes := TResourceStream.Create(Hinstance, ResName, PChar(ResType));
    try
      PlugRes.SavetoFile(ResNewName);
      Result := true;
    finally
      PlugRes.Free;
    end;
  except
    Result := False;
  end;
end;

var
  g_ts: TStringList;

procedure TfrmMain.LoadClientPatchConfig(Sender: TObject);
var
  nCount: Integer;
  hal: TCellHalign;
  Val: TCellValign;
begin
  AdvStringGrid2.Clear;
  AdvStringGrid2.ColCount := 6;
  frmMain.AdvStringGrid2.Cells[0, 0] := '���ɲ����ļ�·��  (˫��ȡ��)';
  frmMain.AdvStringGrid2.Cells[1, 0] := '�ͷŲ�����...';
  frmMain.AdvStringGrid2.Cells[2, 0] := 'Ԥ��';
  frmMain.AdvStringGrid2.Cells[3, 0] := 'Ԥ��';
  frmMain.AdvStringGrid2.Cells[4, 0] := 'Ԥ��';
  frmMain.AdvStringGrid2.Cells[5, 0] := 'Ԥ��';

  g_ts := TStringList.Create;
  g_ts.Add('����Ŀ¼     ');
  g_ts.Add('����DataĿ¼     ');
  g_ts.Add('��½��Ŀ¼');

  hal := haRight;
  Val := vaFull;

  for nCount := 1 to AdvStringGrid2.RowCount - 1 do begin
    frmMain.AdvStringGrid2.AddButton(0, nCount, 30, 23, IntToStr(nCount), hal, Val);
    frmMain.AdvStringGrid2.AddRadio(1, nCount, 1, 0, g_ts);
    //frmMain.AdvStringGrid2.AddProgress(2, nCount, clLime, clWhite);
    frmMain.AdvStringGrid2.AddCheckBox(2, nCount, False, False);
    frmMain.AdvStringGrid2.AddCheckBox(3, nCount, False, False);
    frmMain.AdvStringGrid2.AddCheckBox(4, nCount, False, False);
    frmMain.AdvStringGrid2.AddCheckBox(5, nCount, False, False);
  end;
end;

procedure TfrmMain.AdvStringGrid2ButtonClick(Sender: TObject; ACol, ARow: Integer);
begin
  if not OpenDialog3.Execute then Exit;

  frmMain.AdvStringGrid2.Cells[ACol, ARow] := OpenDialog3.FileName;
end;

procedure TfrmMain.AdvStringGrid2DblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if ARow <> 0 then
    frmMain.AdvStringGrid2.Cells[ACol, ARow] := '';
end;

procedure TfrmMain.btnChangePasswordMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btnChangePasswordMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Droping(btnChangePassword);
end;

procedure TfrmMain.btnChangePasswordMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnColseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.btnColseMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btnColse);
end;

procedure TfrmMain.btnColseMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnCreatePlugClick(Sender: TObject);
var
  rPlugRes: TResourceStream;
  mStream: TMemoryStream;
  zStream: TMemoryStream;
  fStream: TMemoryStream;
  sStream: TMemoryStream;
  xStream: TMemoryStream;
  sSrcDir: string;
  pn: PInteger;
  RcHeader: TRcHeader;
  cfg: TLoginToolConfig;//��½������
  cmds: TCliCmdLines;
  i, ii, n: Integer;

  p: pTCItemRule;
  t: TCItemRule;
  ls: TStringList;
  b2, b3, b4: Boolean;
  aaa: array of TCItemRule;
  buffer, buffer2: Pointer;
  nn, nSize, nSize2: Integer;

  nSign: Integer;
  DosHeader: TImageDosHeader;//MZ��ʽ���ļ�ͷ
  NTHeader: TImageNtHeaders;
  nAddress: Integer;
  HeaderSum: DWORD;
  CheckSum: DWORD;

  fcbState: Boolean;
  sFileName, sFileNameOnly: string;
  Indexs: array of Integer;
  ClientPatch: TClientPatch;
  nCount, nOffset, nRadioIdx, nBuffSize, nBuffSize2: Integer;
  szIP, szPort, szLine: string;
  nPort: Integer;
  szParam: string;
  szRoute: string;
  fHandle: THandle;
  edHeader, EDHeader2: TedHeader;
  DCP_mars: TDCP_mars;
  pszBufPtr: PChar;
  pszBuffer: array[0..1024 * 16 - 1] of Char;
  dumpy: array[0..99] of byte;

  sf: string;
  nexe, oexe, skp: TMemoryStream;
  lensk: Int64;
begin
  if CheckBox1.Checked and (AdvStringGrid1.RowCount < 20) then begin
    Application.MessageBox('��Ʒ�����б����ô���', '������Ϣ', MB_ICONERROR + MB_OK);
    Exit;
  end;

  //EditPic�����Ǵ�����Դ��·����Edit1�������ǵ�¼������
  if (Trim(EditPic.Text) = '') then begin
    Application.MessageBox('������Ϣ·������', '������Ϣ', MB_ICONERROR + MB_OK);
    Exit;
  end;
  sSrcDir := Trim(EditPic.Text);
  if sSrcDir[Length(sSrcDir)] <> '\' then
    sSrcDir := sSrcDir + '\';

  if (Trim(Edit1.Text) = '') then begin
    Application.MessageBox('��½�����ֲ���Ϊ�գ�', '������Ϣ', MB_ICONERROR + MB_OK);
    Exit;
  end;
  fillchar(dumpy, sizeof(dumpy), 0);//dumpy���ڴ�ʹ��һ��

  //���е�¼���������ṹ������
  cfg.Config1 := '';
  cfg.FileName := Trim(Edit1.Text);  //��½����ִ�г�����ļ�����������չ��exe
  //cfg.Config1 := Trim(Edit2.Text);
  //cfg.Config2 := Trim(Edit3.Text);

  //Config8��byte
  cfg.Config8 := 0;
  if CheckBox3.Checked then
    cfg.Config8 := cfg.Config8 or 1;//CheckBox3�Ƕ�ȡWis��־
  if CheckBox4.Checked then
    cfg.Config8 := cfg.Config8 or 2;//CheckBox4�Ƕ�ȡWil��־
  if CheckBox5.Checked then
    cfg.Config8 := cfg.Config8 or 4;//CheckBox�Ƕ�ȡWzl��־
 {
  if not FileExists(sSrcDir + 'LoginTool.dat') or not (FileExists(sSrcDir + 'LoginGate.dat')) then begin
    Application.MessageBox('��Ҫ��������Ϣ�ļ�������...', '������Ϣ', MB_ICONERROR + MB_OK);
    Exit;
  end;
  }
  
  if not FileExists(sSrcDir + 'config.dat') then begin
    Application.MessageBox('��Ҫ��������Ϣ�ļ�������...', '������Ϣ', MB_ICONERROR + MB_OK);
    Exit;
  end;

  //�������ļ� config.dat�����ļ���MakeMain�����д�������Ϊ�����֣���һ������һ�����ݣ�
  //�ڶ������Ǽ��ܺ��RCHeader�����������Ǽ��ܺ��edHeader���ڶ��������ּӵ���¼����β��
  //��һ����Ҫ�ص���¼���ص�β��
  fHandle := FileOpen(sSrcDir + 'config.dat', fmOpenRead or fmShareDenyNone);
  if fHandle = 0 then begin
    Application.MessageBox('��Ҫ��������Ϣ�ļ�������...', '������Ϣ', MB_ICONERROR + MB_OK);
    Exit;
  end;

  DCP_mars := TDCP_mars.Create(nil);
  
  FileSeek(fHandle, -SizeOf(TedHeader), 2);//2��ʾ���ļ�β��ʼ��
  FileRead(fHandle, edHeader, SizeOf(TedHeader));//��config.dat�ļ�ĩβ����һ��edheader�ṹ
  pszBufPtr := @pszBuffer[0];

  //InitStr�ǰѲ�����ΪKey���г�ʼ���������ʼ���󣬲��ܵ�����Ӧ�Ľ��ܺͽ��ܺ���
  //DCP_marsÿһ��ʹ��ǰ�������Ǽ��ܻ��ǽ��ܣ���������г�ʼ��
  DCP_mars.InitStr(('MIR2EX - edHeader 20160201'));
  DCP_mars.DecryptCFB8bit(edHeader, EDHeader2, SizeOf(TedHeader));//����edHader�����뵽EDHeader2��



  btnCreatePlug.Enabled := False;

  //��¼���͵�¼���ر��������Դ�������ڵ�¼����������Դ���ڣ������Ǹ�����Դ����
  //LoginTool���ӵ�¼����������Դ���ڶ�����¼��
  try
    rPlugRes := TResourceStream.Create(Hinstance, 'ResData', 'LoginTool');
    if rPlugRes <> nil then begin
      //rPlugRes.SaveToFile(ExtractFilePath(Application.ExeName) + Trim(Edit1.Text) + '.exe');
      sStream := TMemoryStream.Create;
      sStream.LoadFromStream(rPlugRes);//�ѵ�¼�����뵽sStream��

{$IFDEF PATCHMAN}
      buffer2 := nil;

      //���㲹��
      nCount := 0;
      for i := 1 to (AdvStringGrid2.RowCount - 1) do begin
        sFileName := AdvStringGrid2.Cells[0, i];
        if (sFileName <> '') and FileExists(sFileName) then begin
          Inc(nCount);
        end;
      end;
      if nCount > 0 then begin

        SetLength(Indexs, nCount + 1);
        Indexs[0] := nCount;

        nBuffSize := 0;
        nBuffSize2 := 0;
        nOffset := (nCount + 1) * 4;
        for i := 1 to (AdvStringGrid2.RowCount - 1) do begin
          sFileName := AdvStringGrid2.Cells[0, i];
          if FileExists(sFileName) then begin
            ClientPatch.PutToMir := 0;
            if AdvStringGrid2.GetRadioIdx(1, i, nRadioIdx) then
              ClientPatch.PutToMir := nRadioIdx;
            ClientPatch.Exec := False;
            fcbState := False;
            if AdvStringGrid2.GetCheckBoxState(2, i, fcbState) then begin
              if fcbState and ((CompareText(ExtractFileExt(sFileName), '.bat') = 0) or (CompareText(ExtractFileExt(sFileName), '.cmd') = 0)) then
                ClientPatch.Exec := true;
            end;
            ClientPatch.Reserve0 := 0;
            ClientPatch.Reserve1 := 0;
            sFileNameOnly := ExtractFileName(sFileName);
            FillChar(ClientPatch.Name, SizeOf(ClientPatch.Name), 0);
            Move(sFileNameOnly[1], ClientPatch.Name, Length(sFileNameOnly));

            xStream := TMemoryStream.Create;
            xStream.LoadFromFile(sFileName);
            VCLZip1.ZLibCompressBuffer(xStream.Memory, xStream.Size, buffer, nSize);
            ClientPatch.Size := nSize;

            Indexs[i] := nOffset;
            Inc(nOffset, nSize + SizeOf(ClientPatch));

            Inc(nBuffSize, nSize + SizeOf(ClientPatch));
            ReAllocMem(buffer2, nBuffSize);
            Move(ClientPatch, PChar(Integer(buffer2) + nBuffSize2)^, SizeOf(ClientPatch));
            Move(buffer^, PChar(Integer(buffer2) + nBuffSize2 + SizeOf(ClientPatch))^, nSize);
            Inc(nBuffSize2, nSize + SizeOf(ClientPatch));

            xStream.Free;
            FreeMem(buffer);

          end;
        end;

        //д����
        AddSection(sStream, 'UPX5', @Indexs[0], (nCount + 1) * 4, buffer2, nBuffSize);
        SetSectionAttrib(sStream);
      end;
      if buffer2 <> nil then
        FreeMem(buffer2);
{$ENDIF}


      //������Ʒ������Ʒ�б��е����ݣ�д��aaa��
      nn := AdvStringGrid1.RowCount - 1;
      SetLength(aaa, nn);
      for i := 1 to nn do begin
        if CompareText(AdvStringGrid1.Cells[1, i], '��װ��') = 0 then
          n := 0
        else if CompareText(AdvStringGrid1.Cells[1, i], '������') = 0 then
          n := 1
        else if CompareText(AdvStringGrid1.Cells[1, i], '������') = 0 then
          n := 2
        else if CompareText(AdvStringGrid1.Cells[1, i], 'ҩƷ��') = 0 then
          n := 3
        else
          n := 4;

        b2 := False;
        b3 := False;
        b4 := False;
        AdvStringGrid1.GetCheckBoxState(2, i, b2);
        AdvStringGrid1.GetCheckBoxState(3, i, b3);
        AdvStringGrid1.GetCheckBoxState(4, i, b4);
        aaa[i - 1].Name := AdvStringGrid1.Cells[0, i];
        aaa[i - 1].ntype := n;
        aaa[i - 1].rare := b2;
        aaa[i - 1].pick := b3;
        aaa[i - 1].show := b4;
      end;

      try
        zStream := TMemoryStream.Create;
        mStream := TMemoryStream.Create;
        fStream := TMemoryStream.Create;
        try
          //mStream.LoadFromStream(rPlugRes);

          mStream.LoadFromStream(sStream);//�����¼����mStream�У�sStream�б������LoginTool.exe

          //fStream.LoadFromFile(sSrcDir + 'LoginTool.dat');
          //�������ļ��У���β����ǰ����edHeader�ṹ���Ⱥ�EDHeader2.nCetLen��EDHeader2.nCetLen
          //�ǽ��ܺ��rcHeader�ĳ��ȣ�EDHeader2�ǽ��ܺ��edheader
          FileSeek(fHandle, -(EDHeader2.nCetLen + SizeOf(TedHeader)), 2);
          FillChar(pszBuffer, 1024 * 16, #0);
          FileRead(fHandle, pszBuffer, EDHeader2.nCetLen);//�Ѽ��ܺ��rcHeader��ȡ��pszBufferָ����ڴ��������飩��
          fStream.Write(pszBufPtr^, EDHeader2.nCetLen);//�Ѽ��ܺ��rcHeaderд�뵽fStream����
          //��ʱ��fStream�б�����Ǽ��ܺ��rcHeader

          mStream.Seek(0, 2); //mStreamָ���ƶ���β��
          //��ʱ��aaa�б�������б���ȫ����Ʒ�����ݣ���aaaд��zStream��
          zStream.WriteBuffer(aaa[0], nn * SizeOf(TCItemRule));

          //�����Memo1�е����ݣ�д��cmds���ٰ�cmdsд��zStream
          i := 0;
          ii := 0;
          FillChar(cmds, SizeOf(cmds), 0);
          for i := 0 to Memo1.Lines.Count - 1 do begin
            if ii > High(cmds) then
              Break;
            if Memo1.Lines.Strings[i] <> '' then begin
              cmds[ii] := Memo1.Lines.Strings[i];
              Inc(ii);
            end;
          end;
          //mStream.WriteBuffer(cmds, SizeOf(cmds));
          zStream.WriteBuffer(cmds, SizeOf(cmds));


          //mStream.WriteBuffer(cfg, SizeOf(TLoginToolConfig));
          //cfg��ǰ���Ѿ��������ˣ�����ֱ�Ӱ�cfgд��zStream��
          zStream.WriteBuffer(cfg, SizeOf(TLoginToolConfig));

          if mJpg.Size <> 0 then begin
            //mStream.WriteBuffer(mJpg.Memory^, mJpg.Size);
            zStream.WriteBuffer(mJpg.Memory^, mJpg.Size);
            New(pn);
            pn^ := mJpg.Size;
            //mStream.WriteBuffer(pn^, 4);
            zStream.WriteBuffer(pn^, 4);
            Dispose(pn);
          end;
          fStream.Seek(-SizeOf(TRcHeader), 2);
          fStream.ReadBuffer(RcHeader, SizeOf(TRcHeader));//��fStream�еļ���rcHeader�ṹ������RcHeader��

          //mStream.WriteBuffer(RcHeader {fStream.Memory^}, SizeOf(TRcHeader) {fStream.Size});
          zStream.WriteBuffer(RcHeader {fStream.Memory^}, SizeOf(TRcHeader) {fStream.Size});

          //zStream�е����ݣ�ѹ���󣬴��� buffer ������֮��
          VCLZip1.ZLibCompressBuffer(zStream.Memory, zStream.Size, buffer, nSize);

          nSign := (nSize + 4) mod 16; 
          if nSign > 0 then
            nSign := 16 - nSign;
          if nSign > 0 then begin //��ʱ��nSignΪ12������������ֻ��Ϊ����mStreamβ��д��һ������Ϊ12�Ŀ�������
            buffer2 := AllocMem(nSign);
            mStream.WriteBuffer(buffer2^, nSign);
            FreeMem(buffer2);
          end;

          //zStream�е������Ѿ�ѹ�������buffer�У���ʱ��buffer�е�����д��mStreamβ��
          //����buffer�ĳ������ӵ�β�����Ա���LoginTool����
          mStream.WriteBuffer(buffer^, nSize);
          New(pn);
          pn^ := nSize;
          mStream.WriteBuffer(pn^, 4);
          Dispose(pn);

          mStream.Seek(0, soFromBeginning);
          mStream.Read(DosHeader, SizeOf(TImageDosHeader));
          if DosHeader.e_magic = IMAGE_DOS_SIGNATURE then begin//�����DOS��־ MZ
            mStream.Seek(DosHeader._lfanew, soFromBeginning);
            mStream.Read(NTHeader, SizeOf(NTHeader));

            if NTHeader.Signature = IMAGE_NT_SIGNATURE then begin//�����NT��־ PE00
              if NTHeader.OptionalHeader.NumberOfRvaAndSizes > 4 then begin

                //������һ����룬����δ���� if �������������δִ��
                if (NTHeader.OptionalHeader.DataDirectory[4].VirtualAddress <> 0) and (NTHeader.OptionalHeader.DataDirectory[4].Size <> 0) then begin
                  nAddress := NTHeader.OptionalHeader.DataDirectory[4].VirtualAddress;
                  nSize := mStream.Size - nAddress;
                  NTHeader.OptionalHeader.DataDirectory[4].Size := nSize;
               //   NTHeader.OptionalHeader.DataDirectory[4].Size := NTHeader.OptionalHeader.DataDirectory[4].Size + sizeof(dumpy);
                  //NTHeader.OptionalHeader.CheckSum := CheckSum;
                  mStream.Seek(DosHeader._lfanew, soFromBeginning);
                  mStream.Write(NTHeader, SizeOf(NTHeader));
                end;

              end;
            end;
          end;

          mStream.Seek(0, soFromBeginning);
          CheckSumMappedFile(mStream.Memory, mStream.Size, @HeaderSum, @CheckSum);
          mStream.Read(DosHeader, SizeOf(TImageDosHeader));
          if DosHeader.e_magic = IMAGE_DOS_SIGNATURE then begin
            mStream.Seek(DosHeader._lfanew, soFromBeginning);
            mStream.Read(NTHeader, SizeOf(NTHeader));
            if NTHeader.Signature = IMAGE_NT_SIGNATURE then begin
              if NTHeader.OptionalHeader.NumberOfRvaAndSizes > 4 then begin
                if (NTHeader.OptionalHeader.DataDirectory[4].VirtualAddress <> 0) and (NTHeader.OptionalHeader.DataDirectory[4].Size <> 0) then begin
                  NTHeader.OptionalHeader.CheckSum := CheckSum;
                  mStream.Seek(DosHeader._lfanew, soFromBeginning);
                  mStream.Write(NTHeader, SizeOf(NTHeader));
                end;
              end;
            end;
          end;
          mStream.Seek(0, 2);
//          mStream.Write(dumpy,sizeof(dumpy));
          mStream.SavetoFile(ExtractFilePath(Application.ExeName) + Trim(Edit1.Text) + '.exe');

          FreeMem(buffer);
        finally
          fStream.Free;
          mStream.Free;
          zStream.Free;
        end;
      finally
        rPlugRes.Free;
        sStream.Free;
      end;
    end;

    //��¼����Ҳ���������Դ�������ڵ�¼����������Դ���У�����Դ���У���������LoginGate��������¼����
    rPlugRes := TResourceStream.Create(Hinstance, 'ResData', 'LoginGate');
    if rPlugRes <> nil then begin
      try
        mStream := TMemoryStream.Create;
        fStream := TMemoryStream.Create;
        try
          mStream.LoadFromStream(rPlugRes);//�ѵ�¼���ض���mStream��
          //fStream.LoadFromFile(sSrcDir + 'LoginGate.dat');

          //fHandle��config.dat���ļ������EDHeader2.nCetLen�Ǽ���RCHeader�Ĵ�С
          //EDHeader2.nStrLen�������ļ��е��ڴ�����С
          FileSeek(fHandle, -(EDHeader2.nStrLen + EDHeader2.nCetLen + SizeOf(TedHeader)), 2);
          FileRead(fHandle, pszBuffer, EDHeader2.nStrLen);//����Config.dat�е�ǰ������������ȫ������
          fStream.Write(pszBufPtr^, EDHeader2.nStrLen);//������������ݣ�д�뵽fStream��ȥ

          mStream.Seek(0, soFromBeginning);
          mStream.Read(DosHeader, SizeOf(TImageDosHeader));
          if DosHeader.e_magic = IMAGE_DOS_SIGNATURE then begin
            mStream.Seek(DosHeader._lfanew, soFromBeginning);
            mStream.Read(NTHeader, SizeOf(NTHeader));
            if NTHeader.Signature = IMAGE_NT_SIGNATURE then begin
              if (NTHeader.OptionalHeader.DataDirectory[4].VirtualAddress <> 0) and (NTHeader.OptionalHeader.DataDirectory[4].Size <> 0) then begin
                NTHeader.OptionalHeader.DataDirectory[4].Size := NTHeader.OptionalHeader.DataDirectory[4].Size + fStream.Size;
                mStream.Seek(DosHeader._lfanew, soFromBeginning);
                mStream.Write(NTHeader, SizeOf(NTHeader));
              end;
            end;
          end;  

          mStream.Seek(0, 2);//ָ���ƶ�����β��
          mStream.WriteBuffer(fStream.Memory^, fStream.Size);//��ǰ��д�뵽fStream�е������ݣ�д��mStream��β��
          mStream.SavetoFile(ExtractFilePath(Application.ExeName) + 'LoginGate.exe');
        finally
          fStream.Free;
          mStream.Free;
        end;
      finally
        rPlugRes.Free;
      end;
    end;



    sf := Trim(Edit1.Text) + '.exe';
    try
      skp := TMemoryStream.Create;
      nexe := TMemoryStream.Create;
      oexe := TMemoryStream.Create;

      BuildRagSkp(skp);
      oexe.LoadFromFile(sf);
      nexe.Size := skp.Size + oexe.Size + Sizeof(Int64);

      lensk := skp.Size;//�õ�Ƥ����Size
      //ShowMessage('Ƥ�����ȣ�' + InttoStr(lensk));
      //ShowMessage('��½�����ȣ�' + InttoStr(oexe.Size));

      skp.Position := 0;
      oexe.Position := 0;
      nexe.CopyFrom(oexe, oexe.Size);
      nexe.CopyFrom(skp, skp.Size);
      nexe.Write(lensk, Sizeof(Int64));

      nexe.Position := 0;
      nexe.SaveToFile(sf);

    finally
      skp.Free;
      nexe.Free;
      oexe.Free;
    end;



    Application.MessageBox(PChar(Format('%s %s �������ڱ�Ŀ¼��...', ['LoginGate.exe', Trim(Edit1.Text) + '.exe'])),
      '��ʾ��Ϣ',
      MB_ICONINFORMATION + MB_OK);
  except
    on E: Exception do begin
      MessageBox(0, PChar(E.Message), '����', MB_ICONERROR + MB_OK);
      btnCreatePlug.Enabled := true;
    end;
  end;
end;

procedure TfrmMain.btnEditGameListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btnEditGameListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Droping(btnEditGameList);
end;

procedure TfrmMain.btnEditGameListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnEditGameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btnEditGameMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btnEditGame);
end;

procedure TfrmMain.btnEditGameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btNewAccountMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btNewAccountMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btNewAccount);
end;

procedure TfrmMain.btNewAccountMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnGetBackPasswordMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btnGetBackPasswordMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Droping(btnGetBackPassword);
end;

procedure TfrmMain.btnGetBackPasswordMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnLoadFromDBClick(Sender: TObject);
var
  nCount: Integer;
begin
  AdvStringGrid1.Clear;
  frmMain.AdvStringGrid1.Cells[0, 0] := '��Ʒ����';
  frmMain.AdvStringGrid1.Cells[1, 0] := '��Ʒ���';
  frmMain.AdvStringGrid1.Cells[2, 0] := '��Ʒ��ʾ';
  frmMain.AdvStringGrid1.Cells[3, 0] := '�Զ�ʰȡ';
  frmMain.AdvStringGrid1.Cells[4, 0] := '��ʾ����';

  frmMain.AdvStringGrid1.Cells[0, 1] := '���';
  frmMain.AdvStringGrid1.Cells[1, 1] := '������';
  frmMain.AdvStringGrid1.AddCheckBox(2, 1, False, False);
  frmMain.AdvStringGrid1.AddCheckBox(3, 1, true, False);
  frmMain.AdvStringGrid1.AddCheckBox(4, 1, true, False);

  if g_LocalDBE = nil then
    g_LocalDBE := TLocalDB.Create();
  g_LocalDBE.Query.DatabaseName := EditDBName.Text;

  g_LocalDBE.LoadFromItemsDB;

end;

procedure TfrmMain.btnMinSizeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.btnMinSizeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btnMinSize);
end;

procedure TfrmMain.btnMinSizeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnSaveToFileClick(Sender: TObject);
var
  i, n: Integer;
  p: pTCItemRule;
  ls: TStringList;
  b2, b3, b4: Boolean;
begin
  //if SaveDialog1.Execute then begin
  ls := TStringList.Create;
  for i := 1 to (AdvStringGrid1.RowCount - 1) do begin
    //AdvStringGrid1.SavetoFile('.\lsDefaultItemFilter.txt');
    if CompareText(AdvStringGrid1.Cells[1, i], '��װ��') = 0 then
      n := 0
    else if CompareText(AdvStringGrid1.Cells[1, i], '������') = 0 then
      n := 1
    else if CompareText(AdvStringGrid1.Cells[1, i], '������') = 0 then
      n := 2
    else if CompareText(AdvStringGrid1.Cells[1, i], 'ҩƷ��') = 0 then
      n := 3
    else
      n := 4;

    b2 := False;
    b3 := False;
    b4 := False;
    AdvStringGrid1.GetCheckBoxState(2, i, b2);
    AdvStringGrid1.GetCheckBoxState(3, i, b3);
    AdvStringGrid1.GetCheckBoxState(4, i, b4);

    ls.Add(Format('%s,%d,%d,%d,%d', [
      AdvStringGrid1.Cells[0, i],
        n,
        Byte(b2),
        Byte(b3),
        Byte(b4)
        ]));
  end;
  ls.SavetoFile('.\lsDefaultItemFilter.txt');
  ls.Free;
  Application.MessageBox('lsDefaultItemFilter.txt �������ڱ�Ŀ¼�£�', '��Ϣ', MB_ICONINFORMATION + MB_OK);
  //end;
end;

procedure TfrmMain.btnStartGameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //ReleaseCapture();
  //SendMessage((Sender as TRzBmpButton).Handle{btnStartGame.Handle}, WM_SYSCOMMAND, $F012, 0);
  //DropMoveBtn((Sender as TRzBmpButton).Handle);

  PrepareDrop;
end;

procedure TfrmMain.btnStartGameMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btnStartGame);
end;

procedure TfrmMain.btnStartGameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  i, n: Integer;
  s, s0, s1, s2, s3, s4: string;
  st: string;
  p: pTCItemRule;
  ls: TStringList;
begin
  //if SaveDialog1.Execute then begin
  OpenDlg.InitialDir := ExtractFilePath(Application.ExeName);
  if not OpenDlg.Execute(Handle) then Exit;

  ls := TStringList.Create;
  ls.LoadFromFile(OpenDlg.FileName);
  AdvStringGrid1.RowCount := ls.Count + 1;

  for i := 0 to ls.Count - 1 do begin
    s := ls[i];
    s := GetValidStr3(s, s0, [',']);
    s := GetValidStr3(s, s1, [',']);
    s := GetValidStr3(s, s2, [',']);
    s := GetValidStr3(s, s3, [',']);
    s := GetValidStr3(s, s4, [',']);

    if s1 = '0' then
      st := '��װ��'
    else if s1 = '1' then
      st := '������'
    else if s1 = '2' then
      st := '������'
    else if s1 = '3' then
      st := 'ҩƷ��'
    else if s1 = '4' then
      st := '������';

    AdvStringGrid1.Cells[0, i + 1] := s0;
    AdvStringGrid1.Cells[1, i + 1] := st;
    AdvStringGrid1.AddCheckBox(2, i + 1, s2 = '1', False);
    AdvStringGrid1.AddCheckBox(3, i + 1, s3 = '1', False);
    AdvStringGrid1.AddCheckBox(4, i + 1, s4 = '1', False);

  end;
  ls.Free;
  Application.MessageBox('������ɣ�', '��Ϣ', MB_ICONINFORMATION + MB_OK);
  //end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  i, n, nn: Integer;
  b: Boolean;
begin
  if Sender = Button2 then begin
    n := 2;
    b := true;
  end else if Sender = Button3 then begin
    n := 3;
    b := true;
  end else if Sender = Button4 then begin
    n := 4;
    b := true;
  end else if Sender = Button5 then begin
    n := 2;
    b := False;
  end else if Sender = Button6 then begin
    n := 3;
    b := False;
  end else if Sender = Button7 then begin
    n := 4;
    b := False;
  end;

  nn := AdvStringGrid1.RowCount - 1;
  for i := 1 to nn do begin
    AdvStringGrid1.SetCheckBoxState(n, i, b);
  end;
end;

{===========================��ȡ��½��Ƥ��===============================}
procedure TfrmMain.Button8Click(Sender: TObject);
begin
      OpenDialog3.Execute();
      ReadRagSkp(OpenDialog3.FileName);
end;


procedure TfrmMain.ReadRagSkp(all: string);
  procedure DecRzBmpButton(btnArray: array of TRzBmpButton; skn, dis, down, hot, up: TMemoryStream);
  var
    bc: BtnConf;
    tSize: Integer;
    i: Integer;
  begin
    for i := low(btnArray) to high(btnArray) do
    begin
      skn.Read(bc, Sizeof(bc));
      btnArray[i].Left := bc.Left;
      btnArray[i].Top := bc.Top + panel1.Height;
      btnArray[i].Width := bc.Width;
      btnArray[i].Height := bc.Height;
      btnArray[i].Visible := bc.bShow;

      dis.Clear;
      down.Clear;
      hot.Clear;
      up.Clear;
      skn.Read(tSize, Sizeof(Int64));
      dis.CopyFrom(skn, tSize);
      dis.Position := 0;
      btnArray[i].Bitmaps.Disabled.LoadFromStream(dis);

      skn.Read(tSize, Sizeof(Int64));
      down.CopyFrom(skn, tSize);
      down.Position := 0;
      btnArray[i].Bitmaps.Down.LoadFromStream(down);

      skn.Read(tSize, Sizeof(Int64));
      hot.CopyFrom(skn, tSize);
      hot.Position := 0;
      btnArray[i].Bitmaps.Hot.LoadFromStream(hot);

      skn.Read(tSize, Sizeof(Int64));
      up.CopyFrom(skn, tSize);
      up.Position := 0;
      btnArray[i].Bitmaps.Up.LoadFromStream(up);
    end;
  end;

var
  rc: RadioConf;
  lc: LabelConf;
  pc: PanelConf;
  bc: BtnConf;
  bSize, btnSize: Int64;
  downS, hotS, upS, disS: TMemoryStream;
  skn, BackStream: TMemoryStream;
  btnArr: array[0..7] of TRzBmpButton;
begin
  if not FileExists(all) then
  begin
    ShowMessage('Ƥ���ļ�������');
    exit;
  end;
  BackStream := TMemoryStream.Create;
  skn := TMemoryStream.Create;
  skn.LoadFromFile(all);
  btnArr[0] := btnStartGame;
  btnArr[1] := RzBmpButton3;
  btnArr[2] := RzBmpButton1;
  btnArr[3] := btnEditGame;
  btnArr[4] := btNewAccount;
  btnArr[5] := btnChangePassword;
  btnArr[6] := btnGetBackPassword;
  btnArr[7] := btnEditGameList;

  try
    downS := TMemoryStream.Create;
    hotS := TMemoryStream.Create;
    upS := TMemoryStream.Create;
    disS := TMemoryStream.Create;

    skn.Position := 0;
    skn.Read(rc, Sizeof(rc));
    ckWindowed.Left := rc.Left;
    ckWindowed.Top := rc.Top + panel1.Height;
    ckWindowed.Checked := rc.bWindow;

    skn.Read(lc, Sizeof(lc)); //��Ļ�ֱ��ʱ�ǩ
    RzLabel4.Left := lc.Left;
    RzLabel4.Top := lc.Top + panel1.Height;

    skn.Read(lc, Sizeof(lc)); //��ǰ״̬��ǩ
    RzLabel3.Left := lc.Left;
    RzLabel3.Top := lc.Top + panel1.Height;

    skn.Read(lc, Sizeof(lc)); //��ѡ���������½
    RzLabelStatus.Left := lc.Left;
    RzLabelStatus.Top := lc.Top + panel1.Height;

    skn.Read(lc, Sizeof(lc)); //��ǰ�ļ�
    RzLabel1.Left := lc.Left;
    RzLabel1.Top := lc.Top + panel1.Height;

    skn.Read(lc, Sizeof(lc)); //�����ļ�
    RzLabel2.Left := lc.Left;
    RzLabel2.Top := lc.Top + panel1.Height;

    skn.Read(pc, Sizeof(pc)); //�������б�
    PanelServerList.Left := pc.Left;
    PanelServerList.Top := pc.Top + panel1.Height;
    PanelServerList.Width := pc.Width;
    PanelServerList.Height := pc.Height;

    skn.Read(pc, Sizeof(pc)); //��վ����
    PanelWebBrowser.Left := pc.Left;
    PanelWebBrowser.Top := pc.Top + panel1.Height;
    PanelWebBrowser.Width := pc.Width;
    PanelWebBrowser.Height := pc.Height;

    skn.Read(pc, Sizeof(pc)); //��Ϸ�ֱ���ComboBox
    Panel2.Left := pc.Left;
    Panel2.Top := pc.Top + panel1.Height;
    Panel2.Width := pc.Width;
    Panel2.Height := pc.Height;

    skn.Read(pc, Sizeof(pc)); //��ǰ�ļ�
    PanelProcessCur.Left := pc.Left;
    PanelProcessCur.Top := pc.Top + panel1.Height;
    PanelProcessCur.Width := pc.Width;
    PanelProcessCur.Height := pc.Height;

    skn.Read(pc, Sizeof(pc)); //�����ļ�
    PanelProcessMax.Left := pc.Left;
    PanelProcessMax.Top := pc.Top + panel1.Height;
    PanelProcessMax.Width := pc.Width;
    PanelProcessMax.Height := pc.Height;

    skn.Read(bSize, Sizeof(Int64));
    BackStream.CopyFrom(skn, bSize);
    BackStream.Position := 0;
    BackStream.SaveToFile('main.png');
    ImageMain.Picture.LoadFromFile('main.png');

    skn.Read(bc, Sizeof(bc)); //��С����ť
    btnMinSize.Left := bc.Left;
    btnMinSize.Top := bc.Top + panel1.Height;
    btnMinSize.Width := bc.Width;
    btnMinSize.Height := bc.Height;
    btnMinSize.Visible := bc.bShow;

    skn.Read(btnSize, Sizeof(Int64));
    downS.CopyFrom(skn, btnSize);
    downS.Position := 0;
    btnMinSize.Bitmaps.Down.LoadFromStream(downS);

    skn.Read(btnSize, Sizeof(Int64));
    hotS.CopyFrom(skn, btnSize);
    hotS.Position := 0;
    btnMinSize.Bitmaps.Hot.LoadFromStream(hotS);

    skn.Read(btnSize, Sizeof(Int64));
    upS.CopyFrom(skn, btnSize);
    upS.Position := 0;
    btnMinSize.Bitmaps.Up.LoadFromStream(upS);

    skn.Read(bc, Sizeof(bc)); //�رհ�ť
    btnColse.Left := bc.Left;
    btnColse.Top := bc.Top + panel1.Height;
    btnColse.Width := bc.Width;
    btnColse.Height := bc.Height;
    btnColse.Visible := bc.bShow;

    downS.Clear;
    hotS.Clear;
    upS.Clear;
    skn.Read(btnSize, Sizeof(Int64));
    downS.CopyFrom(skn, btnSize);
    downS.Position := 0;
    btnColse.Bitmaps.Down.LoadFromStream(downS);

    skn.Read(btnSize, Sizeof(Int64));
    hotS.CopyFrom(skn, btnSize);
    hotS.Position := 0;
    btnColse.Bitmaps.Hot.LoadFromStream(hotS);

    skn.Read(btnSize, Sizeof(Int64));
    upS.CopyFrom(skn, btnSize);
    upS.Position := 0;
    btnColse.Bitmaps.Up.LoadFromStream(upS);

    DecRzBmpButton(btnArr, skn, disS, downS, hotS, upS);

  finally
    downS.Free;
    hotS.Free;
    upS.Free;
    disS.Free;
    skn.Free;
    BackStream.Free;
  end;
end;

{===========================�����½��Ƥ��===============================}
procedure TfrmMain.Button9Click(Sender: TObject);
var
  all: TMemoryStream;
begin
  if ImageMain.Picture.Graphic <> nil then begin
    try
      all := TMemoryStream.Create;
      BuildRagSkp(all);
      all.Position := 0;
      all.SaveToFile('Ĭ��Ƥ��.rag');
    finally
      all.Free;
      Application.MessageBox('Ĭ��Ƥ��.rag �������ڱ�Ŀ¼�£�', '��ʾ��Ϣ', MB_ICONINFORMATION + MB_OK);
    end;
  end
  else
    Application.MessageBox('��ѡ��һ������ͼƬ������', '��ʾ��Ϣ', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.BuildRagSkp(all: TMemoryStream);
  procedure AddRzBmpButton(btnArray: array of TRzBmpButton; showArray: array of Boolean;
    All, dis, down, hot, up: TMemoryStream);
  var
    bc: BtnConf;
    tSize: Integer;
    i: Integer;
  begin
    for I := low(btnArray) to high(btnArray) do begin

      bc.Left := btnArray[i].Left;
      bc.Top := btnArray[i].Top - Panel1.Height;
      bc.Width := btnArray[i].Width;
      bc.Height := btnArray[i].Height;
      bc.bShow := showArray[i];//���������ֵ��Ƥ���ļ��ж�����ͨ����ť�Ҽ��˵�������


      All.Write(bc, Sizeof(bc));

      dis.Clear; down.Clear; hot.Clear; up.Clear;
      btnArray[i].Bitmaps.Disabled.SaveToStream(dis);
      btnArray[i].Bitmaps.Down.SaveToStream(down);
      btnArray[i].Bitmaps.Hot.SaveToStream(hot);
      btnArray[i].Bitmaps.Up.SaveToStream(up);

      tSize := dis.Size;
      All.Write(tSize, Sizeof(Int64));
      dis.Position := 0;
      All.CopyFrom(dis, dis.Size);

      tSize := down.Size;
      All.Write(tSize, Sizeof(Int64));
      down.Position := 0;
      All.CopyFrom(down, down.Size);

      tSize := hot.Size;
      All.Write(tSize, Sizeof(Int64));
      hot.Position := 0;
      All.CopyFrom(hot, hot.Size);

      tSize := up.Size;
      All.Write(tSize, Sizeof(Int64));
      up.Position := 0;
      All.CopyFrom(up, up.Size);
    end;
  end;

var
  BackStream: TMemoryStream;//���汳��ͼƬ
  TStream: TMemoryStream;//��ʱ�ڴ���

  disStream: TMemoryStream; //��ť�Ľ���ͼƬ
  downStream: TMemoryStream;//��ť�İ���ͼƬ
  hotStream: TMemoryStream; //��ť����껮��ͼƬ
  upStream: TMemoryStream; //��ť�ĵ���ͼƬ

  rc: RadioConf;
  lc, tc: LabelConf;
  pc, tpc: PanelConf;
  bc, tbc: BtnConf;
  bSize, tSize: Int64;

  btnArr: Array[0..7] of TRzBmpButton;
  showArr: Array[0..7] of Boolean;
begin
  btnArr[0] := btnStartGame;         btnArr[1] := RzBmpButton3;
  btnArr[2] := RzBmpButton1;         btnArr[3] := btnEditGame;
  btnArr[4] := btNewAccount;         btnArr[5] := btnChangePassword;
  btnArr[6] := btnGetBackPassword;   btnArr[7] := btnEditGameList;

  showArr[0] := bShowStartGame;      showArr[1] := bShowWebSite;
  showArr[2] := bShowZhuangBei;      showArr[3] := bShowContuctUs;
  showArr[4] := bShowAccount;        showArr[5] := bShowChangePass;
  showArr[6] := bShowGetBackPass;    showArr[7] := bShowEditGameList;

  try
    BackStream := TMemoryStream.Create;
    TStream := TMemoryStream.Create;
    disStream := TMemoryStream.Create;
    downStream := TMemoryStream.Create;
    hotStream := TMemoryStream.Create;
    upStream := TMemoryStream.Create;

    ImageMain.Picture.Graphic.SaveToStream(BackStream); //���汳��ͼƬ

    rc.Left := ckWindowed.Left; //�Ƿ񴰿�״̬  ����RadioBox
    rc.Top := ckWindowed.Top - Panel1.Height;
    rc.bWindow := ckWindowed.Checked;
    all.Write(rc, Sizeof(rc));

    lc.Left := RzLabel4.Left;  //��Ϸ�ֱ���
    lc.Top := RzLabel4.Top - Panel1.Height;
    all.Write(lc, Sizeof(lc));

    lc.Left := RzLabel3.Left;  //��ǰ״̬
    lc.Top := RzLabel3.Top - Panel1.Height;
    all.Write(lc, Sizeof(lc));

    lc.Left := RzLabelStatus.Left; //��ѡ���������½
    lc.Top := RzLabelStatus.Top - Panel1.Height;
    all.Write(lc, Sizeof(lc));

    lc.Left := RzLabel1.Left;    //��ǰ�ļ�
    lc.Top := RzLabel1.Top - Panel1.Height;
    all.Write(lc, Sizeof(lc));

    lc.Left := RzLabel2.Left;  //�����ļ�
    lc.Top := RzLabel2.Top - Panel1.Height;
    all.Write(lc, Sizeof(lc));

    //����Panel���Ĳ���
    pc.Left := PanelServerList.Left;   //�������б�
    pc.Top := PanelServerList.Top - Panel1.Height;
    pc.Width := PanelServerList.Width;
    pc.Height := PanelServerList.Height;
    all.Write(pc, Sizeof(pc));

    pc.Left := PanelWebBrowser.Left;   //��վ����
    pc.Top := panelWebBrowser.Top - Panel1.Height;
    pc.Width := PanelWebBrowser.Width;
    pc.Height := PanelWebBrowser.Height;
    all.Write(pc, Sizeof(pc));

    pc.Left := Panel2.Left;         //��Ϸ�ֱ���
    pc.Top := Panel2.Top - Panel1.Height;
    pc.Width := Panel2.Width;
    pc.Height := Panel2.Height;
    all.Write(pc, Sizeof(pc));

    pc.Left := PanelProcessCur.Left; //��ǰ�ļ�
    pc.Top := PanelProcessCur.Top - Panel1.Height;
    pc.Width := PanelProcessCur.Width;
    pc.Height := PanelProcessCur.Height;
    all.Write(pc, Sizeof(pc));

    pc.Left := PanelProcessMax.Left; //�����ļ�
    pc.Top := PanelProcessMax.Top - Panel1.Height;
    pc.Width := PanelProcessMax.Width;
    pc.Height := PanelProcessMax.Height;
    all.Write(pc, Sizeof(pc));

    tSize := BackStream.Size; //����ͼƬSize
    all.Write(tSize, Sizeof(Int64));//�ѱ���ͼƬ��Sizeд�����ڴ���
    BackStream.Position := 0;
    all.CopyFrom(BackStream, BackStream.Size);//�ѱ���ͼƬ�������ڴ���

    //���￪ʼ������С���������ť״̬������ͼƬ
    bc.Left := btnMinSize.Left;
    bc.Top := btnMinSize.Top - Panel1.Height;
    bc.Width := btnMinSize.Width;
    bc.Height := btnMinSize.Height;
    bc.bShow := True;
    all.Write(bc, Sizeof(bc));

    btnMinSize.Bitmaps.Down.SaveToStream(downStream);
    btnMinSize.Bitmaps.Hot.SaveToStream(hotStream);
    btnMinSize.Bitmaps.Up.SaveToStream(upStream);

    tSize := downStream.Size;
    all.Write(tSize, Sizeof(Int64));
    downStream.Position := 0;
    all.CopyFrom(downStream, downStream.Size);

    tSize := hotStream.Size;
    all.Write(tSize, Sizeof(Int64));
    hotStream.Position := 0;
    all.CopyFrom(hotStream, hotStream.Size);

    tSize := upStream.Size;
    all.Write(tSize, Sizeof(Int64));
    upStream.Position := 0;
    all.CopyFrom(upStream, upStream.Size);


    ////���￪ʼ����رհ�ť����������ť״̬������ͼƬ
    bc.Left := btnColse.Left;
    bc.Top := btnColse.Top - Panel1.Height;
    bc.Width := btnColse.Width;
    bc.Height := btnColse.Height;
    bc.bShow := True;
    all.Write(bc, Sizeof(bc));

    downStream.Clear; hotStream.Clear; upStream.Clear;
    btnColse.Bitmaps.Down.SaveToStream(downStream);
    btnColse.Bitmaps.Hot.SaveToStream(hotStream);
    btnColse.Bitmaps.Up.SaveToStream(upStream);

    tSize := downStream.Size;
    all.Write(tSize, Sizeof(Int64));
    downStream.Position := 0;
    all.CopyFrom(downStream, downStream.Size);

    tSize := hotStream.Size;
    all.Write(tSize, Sizeof(Int64));
    hotStream.Position := 0;
    all.CopyFrom(hotStream, hotStream.Size);

    tSize := upStream.Size;
    all.Write(tSize, Sizeof(Int64));
    upStream.Position := 0;
    all.CopyFrom(upStream, upStream.Size);

    //8�����ܰ�ť
    AddRzBmpButton(btnArr, showArr, all, disStream, downStream, hotStream, upStream);

  finally
    BackStream.Free;
    TStream.Free;
    disStream.Free;
    downStream.Free;
    hotStream.Free;
    upStream.Free;
  end;
end;




procedure TfrmMain.ButtonPicClick(Sender: TObject);
var
  s, Dir: string;
  Folder: WideString;
  //Jpg: TJpegImage;
begin
  Dir := ExtractFilePath(ParamStr(0));
  if FileCtrl.SelectDirectory('ѡ��Ŀ¼:', Folder, Dir, [sdNewUI, sdNewFolder], TWinControl(Self)) then begin
    EditPic.Text := Dir;
    s := Dir + '\main.png';//'\main.jpg';
    if FileExists(s) then begin
      //Jpg := TJpegImage.Create;
      try
        try
          mJpg.Clear;   //mJph��MemoryStream
          mJpg.LoadFromFile(s);
          //Jpg.LoadFromFile(s);
          //ImageMain.Picture.Graphic := Jpg;

          ImageMain.Picture.LoadFromFile(s);
        except

        end;
      finally
        //Jpg.Free;
      end;
      btnCreatePlug.Enabled := true;
    end else
      MessageBox(0, PChar('Ŀ¼�в����� main.png ������ͼƬ�ļ���'), '����', MB_ICONERROR + MB_OK);
  end;
end;

procedure TfrmMain.ckWindowedMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //ManipulateControl(TControl(Sender), Shift, X, Y, 5);
  ManipulateControl(TControl(Sender), Shift, 6, 6, 5);
end;

procedure TfrmMain.PrepareDrop;
begin
  GetCursorPos(FPoint);
  FMouseDowned := True;
end;

procedure TfrmMain.Droping(btn: TRzBmpButton);
var
  P: TPoint;
begin
  if FMouseDowned then
  begin
    GetCursorPos(P);
    btn.Top := btn.Top + P.Y - FPoint.Y;
    btn.Left := btn.Left + P.X - FPoint.X;
    FPoint := P;
  end;
end;

procedure TfrmMain.DropingLabel(l: TRzLabel);
var
  P: TPoint;
begin
  if FMouseDowned then
  begin
    GetCursorPos(P);
    l.Top := l.Top + P.Y - FPoint.Y;
    l.Left := l.Left + P.X - FPoint.X;
    FPoint := P;
  end;
end;

procedure TfrmMain.DropOver;
begin
  FMouseDowned := FALSE;
end;

procedure TfrmMain.DropMoveBtn(aHandle: THandle);
begin
  ReleaseCapture();
  SendMessage(aHandle{btnStartGame.Handle}, WM_SYSCOMMAND, $F012, 0);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := 'LEGENDM2-��½��������(�����Զ���Ƥ�� �� ��½������)';

  frmMain.AdvStringGrid1.Cells[0, 0] := '��Ʒ����';
  frmMain.AdvStringGrid1.Cells[1, 0] := '��Ʒ���';
  frmMain.AdvStringGrid1.Cells[2, 0] := '��Ʒ��ʾ';
  frmMain.AdvStringGrid1.Cells[3, 0] := '�Զ�ʰȡ';
  frmMain.AdvStringGrid1.Cells[4, 0] := '��ʾ����';
  LoadClientPatchConfig(nil);
  PageControl1.ActivePageIndex := 0;
{$IFNDEF PATCHMAN}
  TabSheet3.Visible := False;
  TabSheet3.Caption := '���ɲ���(����)';
{$ENDIF}

  //���ڱ��水ť�Ƿ�ɼ�
  bShowStartGame := True;
  bShowWebSite := True;
  bShowZhuangBei := True;
  bShowContuctUs := True;
  bShowAccount := True;
  bShowChangePass := True;
  bShowGetBackPass := True;
  bShowEditGameList := True;
end;

procedure TfrmMain.InitSetBtnImgForm(Btn: TRzBmpButton);
var
  FrmSetBtn: TFrmSetBtnImage;
begin
  //if Btn = BtnStartGame then begin
    FrmSetBtn := TFrmSetBtnImage.Create(Application);
    with FrmSetBtn do begin
      Image1.Picture.Bitmap.Assign(Btn.Bitmaps.Up);
      Image2.Picture.Bitmap.Assign(Btn.Bitmaps.Hot);
      Image3.Picture.Bitmap.Assign(Btn.Bitmaps.Down);
      Image4.Picture.Bitmap.Assign(Btn.Bitmaps.Disabled);

      if ShowModal() = mrOK then begin
        Btn.Bitmaps.Up.Assign(Image1.Picture.Bitmap);
        Btn.Bitmaps.Hot.Assign(Image2.Picture.Bitmap);
        Btn.Bitmaps.Down.Assign(Image3.Picture.Bitmap);
        Btn.Bitmaps.Disabled.Assign(Image4.Picture.Bitmap);
      end;
    end;

  //end;
end;

procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 2 then
    Edit1.SetFocus;
{$IFNDEF PATCHMAN}
  TabSheet3.Visible := False;
  TabSheet3.Caption := '���ɲ���(����)';
{$ENDIF}
end;

procedure TfrmMain.PanelProcessCurMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ManipulateControl(TControl(Sender), Shift, X, Y, 2);
end;

procedure TfrmMain.PanelProcessMaxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ManipulateControl(TControl(Sender), Shift, X, Y, 2);
end;

procedure TfrmMain.PanelServerListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ManipulateControl(TControl(Sender), Shift, X, Y, 5);
end;

procedure TfrmMain.PopContactUsPopup(Sender: TObject);
begin
  n8.Checked := bShowContuctUs;
end;

procedure TfrmMain.PopExitPopup(Sender: TObject);
begin
  n18.Checked := bShowEditGameList;
end;

procedure TfrmMain.PopFindPassPopup(Sender: TObject);
begin
  n16.Checked := bShowGetBackPass;
end;

procedure TfrmMain.PopPassPopup(Sender: TObject);
begin
  n14.Checked := bShowChangePass;
end;

procedure TfrmMain.PopRegisterPopup(Sender: TObject);
begin
  N12.Checked := bShowAccount;
end;

procedure TfrmMain.PopStartGamePopup(Sender: TObject);
begin
  n2.Checked := bShowStartGame;
end;

procedure TfrmMain.PopWebSitePopup(Sender: TObject);
begin
  n4.Checked := bShowWebSite;
end;

procedure TfrmMain.PopZhuangBeiPopup(Sender: TObject);
begin
  n6.Checked := bShowZhuangBei;
end;

procedure TfrmMain.RzBmpButton1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.RzBmpButton1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(RzBmpButton1);
end;

procedure TfrmMain.RzBmpButton1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzBmpButton3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.RzBmpButton3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(RzBmpButton3);
end;

procedure TfrmMain.RzBmpButton3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DropingLabel(RzLabel1);
end;

procedure TfrmMain.RzLabel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabel2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DropingLabel(RzLabel2);
end;

procedure TfrmMain.RzLabel2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabel3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabel3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DropingLabel(RzLabel3);
end;

procedure TfrmMain.RzLabel3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabel4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabel4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //ManipulateControl(TControl(Sender), Shift, 6, 6, 5);
  DropingLabel(RzLabel4);
end;

procedure TfrmMain.RzLabel4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabelStatusMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabelStatusMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DropingLabel(RzLabelStatus);
end;

procedure TfrmMain.RzLabelStatusMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

initialization
  sPath := ExtractFilePath(Application.ExeName);
  mJpg := TMemoryStream.Create();

finalization
  if mJpg <> nil then mJpg.Free;

end.
