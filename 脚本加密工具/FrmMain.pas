unit FrmMain;

interface

uses
  Windows, Messages, SysUtils,StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ShlObj,MD5Unit,DES,ImageHlp, ExtCtrls,Shellapi;

Const
  DEFPASS   = 0;
  BLUEYUE   = 1;
  PLUGSKY   = 2;
  DECRYPASS = DEFPASS;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Button5: TButton;
    Panel2: TPanel;
    Button4: TButton;
    Button3: TButton;
    Edit2: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel3: TPanel;
    ListBox1: TListBox;
    Panel4: TPanel;
    CheckBox1: TCheckBox;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function BrowseForFolder(hd:HWND;sTitle:String):String;

var
  Form1: TForm1;
  Dirs:String;

implementation

{$IF DECRYPASS = DEFPASS  THEN}
ResourceString
  sMsg = 'ENCYPTSCRIPTFLAG';
{$IFEND}
{$IF DECRYPASS = BLUEYUE  THEN}
ResourceString
  sMsg = 'YUEENCYPTSCRIPTFLAG';
{$IFEND}
{$IF DECRYPASS = PLUGSKY  THEN}
ResourceString
  sMsg = 'PLUGENCYPTSCRIPTFLAG';
{$IFEND}


{$R *.dfm}

function BrowseForFolder(hd:HWND;sTitle:String):String;
var
  BrowseInfo : TBrowseInfo;
  sBuf       : array[0..511] of Char;
begin
  FillChar(BrowseInfo,SizeOf(TBrowseInfo),#0);
  BrowseInfo.hwndOwner:=hd;
  BrowseInfo.lpszTitle:=PChar(sTitle);
  BrowseInfo.ulFlags:=64;
  SHGetPathFromIDList(SHBrowseForFolder(BrowseInfo),@sBuf);
  Result:=Trim(sBuf);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i,II:Integer;
  sFileName:String;
  TempList,SaveList:TStringLIst;
  sKey,sText:String;
  boAdd:Boolean;
begin
Try
  TempList:=TStringList.Create;
  SaveList:=TStringList.Create;
  Try
  sKey:=EncryStrHex(GetMD5Text(Edit2.Text),sMsg);
  for II:=0 to ListBox1.Items.Count-1 do begin
    sFileName:=ListBox1.Items.Strings[II];
    if FileExists(sFileName) then begin
      TempList.Clear;
      TempList.LoadFromFile(sFileName);
      boAdd:=False;
      SaveList.Clear;
      For i:=0 to TempList.Count -1 do begin
        sText:=TempList.Strings[I];
        if I=0 then begin
          if sText=sMsg then break;
          if CheckBox1.Checked then begin
            TempList.SaveToFile(sFileName+'.bak');
          end;
          SaveList.Add(sMsg);
          {$IF DECRYPASS = PLUGSKY  THEN}
            SaveList.Add('legendm2 des codes');
          {$ELSE}
            SaveList.Add(UpperCase(GetMD5Text(Edit2.Text)));
          {$IFEND}

          boAdd:=True;
        end;
        {$IF DECRYPASS = PLUGSKY  THEN}
          SaveList.Add(EncryStrHex(sText,'legendm2 des codes'));
        {$ELSE}
          SaveList.Add(EncryStrHex(sText,sKey));
        {$IFEND}
      end;
      if boAdd then SaveList.SaveToFile(sFileName);
    end;
  end;
  Application.MessageBox('全部加密完成！','提示信息',MB_Ok or MB_ICONASTERISK);
  Finally
    TempList.Free;
    SaveList.Free;
  end;
Except
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i,II:Integer;
  sFileName:String;
  TempList,SaveList:TStringLIst;
  sKey,sText:String;
  boAdd:Boolean;
begin
Try
  TempList:=TStringList.Create;
  SaveList:=TStringList.Create;
  Try
  for II:=0 to ListBox1.Items.Count-1 do begin
    sFileName:=ListBox1.Items.Strings[II];
    if FileExists(sFileName) then begin
      TempList.Clear;
      TempList.LoadFromFile(sFileName);
      boAdd:=False;
      SaveList.Clear;
      For i:=0 to TempList.Count -1 do begin
        sText:=TempList.Strings[I];
        if I=0 then begin
          if sText<>sMsg then break;
          if CheckBox1.Checked then begin
            TempList.SaveToFile(sFileName+'.bak');
          end;
        end else
        if I=1 then begin
          {$IF DECRYPASS = PLUGSKY  THEN}
              sKey:='legendm2 des codes';
              boAdd:=True;
          {$ELSE}
            Try
              sKey:=EncryStrHex(GetMD5Text(Edit2.Text),sMsg);
              boAdd:=True;
            Except
              break;
            end;
          {$IFEND}
        end else begin
          Try
            SaveList.Add(DecryStrHex(sText,sKey));
          Except
            break;
          end;
        end;
      end;
      if boAdd then SaveList.SaveToFile(sFileName);
    end;
  end;
  Application.MessageBox('全部解密完成！','提示信息',MB_Ok or MB_ICONASTERISK);
  Finally
    TempList.Free;
    SaveList.Free;
  end;
Except
end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  ListBox1.Items.Clear;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i:integer;
begin
  with OpenDialog1 do begin
    if Execute then begin
      for I:=0 to Files.Count -1 do begin
        ListBox1.Items.Add(Files[I]);
      end;
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex > -1 then begin
    ListBox1.Items.Delete(ListBox1.ItemIndex);
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  i:Integer;
  sFileName:String;
begin
  for i:=0 to ListBox1.Items.Count-1 do begin
    sFileName:=ListBox1.Items.Strings[I];
    if FileExists(sFileName+'.bak') then begin
      CopyFile(PChar(sFileName+'.bak'),PChar(sFileName),False);
      DeleteFile(sFileName+'.bak');
    end;
  end;
  Application.MessageBox('备份恢复完成！','提示信息',MB_Ok or MB_ICONASTERISK);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  i:Integer;
  sFileName:String;
begin
  if Application.MessageBox('是否确定删除备份文件，删除后将无法恢复！','提示信息',MB_OKCANCEL or MB_ICONQUESTION) = mrOk then begin
    for i:=0 to ListBox1.Items.Count-1 do begin
      sFileName:=ListBox1.Items.Strings[I];
      DeleteFile(sFileName+'.bak');
    end;
    Application.MessageBox('删除备份文件成功！','提示信息',MB_Ok or MB_ICONASTERISK);
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  ListBox1.Items.SaveToFile(Dirs+'FilePath.txt');
  Application.MessageBox('保存路径成功，保存文件为 FilePath.txt ！','提示信息',MB_Ok or MB_ICONASTERISK);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{$IF DECRYPASS = BLUEYUE  THEN}
  Form1.Caption:=Form1.Caption+'(BlueYue)';
{$IFEND}
{$IF DECRYPASS = PLUGSKY  THEN}
  Form1.Caption:=Form1.Caption+'(Sky215)';
  Edit2.Enabled:=False;
{$IFEND}
  Dirs:=GetCurrentDir;
  if RightStr(Dirs,1)<>'\' then Dirs:=Dirs+'\';
  if FileExists(Dirs+'FilePath.txt') then begin
    ListBox1.Items.LoadFromFile(Dirs+'FilePath.txt');
  end;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex > -1 then
    ShellExecute(Handle,
               'Open',
               PChar(ListBox1.Items.Strings[ListBox1.ItemIndex]),
               '',
               '',
               SW_SHOWNORMAL);
    //WinExec(PChar(),SW_SHOW);}
end;

end.
