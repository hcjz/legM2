unit frmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, ShlObj, ActiveX, Controls, Forms, Dialogs, StdCtrls,
  GShare, uConfig;

type
  TfrmUpdateConfig = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditResourcePath: TEdit;
    btnSelDirectory: TButton;
    EditServerAddr: TEdit;
    EditServerPort: TEdit;
    btnSaveOK: TButton;
    procedure btnSelDirectoryClick(Sender: TObject);
    procedure EditResourcePathChange(Sender: TObject);
    procedure btnSaveOKClick(Sender: TObject);
    procedure EditServerAddrChange(Sender: TObject);
    procedure EditServerPortChange(Sender: TObject);
  private
    { Private declarations }
    m_boOpened:Boolean;
    m_boModValued: Boolean;
    procedure ModValue;
    procedure uModValue;
    procedure RefGameVarConf;
  public
    { Public declarations }
    procedure Open;
  end;

var
  frmUpdateConfig: TfrmUpdateConfig;

implementation

{$R *.dfm}

function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: lParam): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpData);
  result := 0;
end;

function SelectDirectory(const Caption: string; const Root: WideString;
  var Directory: string; Owner: THandle): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  result := FALSE;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do begin
        hwndOwner := Owner;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        if Directory <> '' then begin
          lpfn := SelectDirCB;
          lParam := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);
      end;
      result := ItemIDList <> nil;
      if result then begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

procedure TfrmUpdateConfig.Open;
begin
  m_boOpened := False;
  uModValue;
  RefGameVarConf;
  m_boOpened := True;
  ShowModal;
end;

procedure TfrmUpdateConfig.RefGameVarConf;
begin
  EditResourcePath.Text:= m2ConfigManage.m2ConFigEx.szResourcePath;
  EditServerAddr.Text:= m2ConfigManage.m2ConFigEx.szGateAddr;
  EditServerPort.Text:= IntToStr(m2ConfigManage.m2ConFigEx.wdGatePort);
end;

procedure TfrmUpdateConfig.EditResourcePathChange(Sender: TObject);
begin
  if not m_boOpened then Exit;
  m2ConfigManage.m2ConFigEx.szResourcePath := EditResourcePath.Text;
  ModValue();
end;

procedure TfrmUpdateConfig.EditServerAddrChange(Sender: TObject);
begin
  if not m_boOpened then Exit;
  m2ConfigManage.m2ConFigEx.szGateAddr := EditServerAddr.Text;
  ModValue();
end;

procedure TfrmUpdateConfig.EditServerPortChange(Sender: TObject);
begin
  if (not m_boOpened) or (EditServerPort.Text = '') then Exit;
  m2ConfigManage.m2ConFigEx.wdGatePort := StrToInt(EditServerPort.Text);
  ModValue();
end;

procedure TfrmUpdateConfig.ModValue;
begin
  m_boModValued := True;
  btnSaveOK.Enabled:= True;
end;

procedure TfrmUpdateConfig.uModValue;
begin
  m_boModValued := True;
  btnSaveOK.Enabled:= False;
end;

procedure TfrmUpdateConfig.btnSaveOKClick(Sender: TObject);
begin
  m2ConfigManage.SaveDBConfig;
  uModValue;
end;

procedure TfrmUpdateConfig.btnSelDirectoryClick(Sender: TObject);
var
  sNewDir: string;
begin
  if SelectDirectory('请选择数据目录', '', sNewDir, Handle) then begin
    EditResourcePath.text:= sNewDir;
  end;
end;

end.
