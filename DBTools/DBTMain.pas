unit DBTMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Mask, bsSkinBoxCtrls, Buttons, grobal2,
  Gauges, bsSkinShellCtrls, bsSkinData, BusinessSkinForm, bsSkinCtrls, hutil32,
  inifiles, OleCtrls, TransBtn, IDDB, bsDialogs, bsSkinTabs, Menus,
  bsSkinMenus, Clipbrd, shellAPI, bsMessages, CheckLst, RzShellDialogs;

type
  TYSHUMFG = record                  //=25
    sAccount: string;        //11 帐号
    oldChrName: string;        //15角色名称
    NewChrname: string;
  end;

  pTYSHUMFG = ^TYSHUMFG;

  TForm1 = class(TForm)
    opendirdialog: TbsSkinSelectDirectoryDialog;
    bsSkinData1: TbsSkinData;
    bsCompressedStoredSkin1: TbsCompressedStoredSkin;
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinStatusBar1: TbsSkinStatusBar;
    Gauge1: TGauge;
    stStatus: TbsSkinStatusPanel;
    InputDialog: TbsSkinInputDialog;
    bsSkinPageControl1: TbsSkinPageControl;
    bsSkinTabSheet1: TbsSkinTabSheet;
    bsSkinTabSheet2: TbsSkinTabSheet;
    bsSkinTabSheet3: TbsSkinTabSheet;
    bsSkinTabSheet4: TbsSkinTabSheet;
    bsSkinTabSheet5: TbsSkinTabSheet;
    bsSkinTabSheet6: TbsSkinTabSheet;
    bsSkinTabSheet7: TbsSkinTabSheet;
    bsSkinGroupBox1: TbsSkinGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtMainDir: TbsSkinEdit;
    edtDBSPath: TbsSkinEdit;
    bsSkinEdit2: TbsSkinEdit;
    bsSkinEdit3: TbsSkinEdit;
    bsSkinGroupBox2: TbsSkinGroupBox;
    Label5: TLabel;
    bsSkinSpeedButton3: TbsSkinSpeedButton;
    Edit1: TbsSkinEdit;
    bsSkinGroupBox3: TbsSkinGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtMainIDDB: TbsSkinFileEdit;
    edtMainHumDB: TbsSkinFileEdit;
    edtMainMirDB: TbsSkinFileEdit;
    edtMainGuildBase: TbsSkinFileEdit;
    bsSkinGroupBox4: TbsSkinGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtIDDB2: TbsSkinFileEdit;
    edtHumDB2: TbsSkinFileEdit;
    edtMirDB2: TbsSkinFileEdit;
    edtGuildBase2: TbsSkinFileEdit;
    bsSkinGroupBox5: TbsSkinGroupBox;
    Label14: TLabel;
    bsSkinEdit4: TbsSkinEdit;
    Label20: TLabel;
    Label24: TLabel;
    bsSkinNumericEdit1: TbsSkinNumericEdit;
    Edit2: TEdit;
    Label25: TLabel;
    bsSkinNumericEdit2: TbsSkinNumericEdit;
    Label21: TLabel;
    bsSkinPanel1: TbsSkinPanel;
    bitbtn1: TbsSkinSpeedButton;
    bitbtn2: TbsSkinSpeedButton;
    Label15: TLabel;
    bsSkinGroupBox6: TbsSkinGroupBox;
    bsSkinGroupBox7: TbsSkinGroupBox;
    bsSkinGroupBox8: TbsSkinGroupBox;
    Label22: TLabel;
    bsSkinFileEdit1: TbsSkinFileEdit;
    Label23: TLabel;
    bsSkinFileEdit2: TbsSkinFileEdit;
    button8: TbsSkinSpeedButton;
    bsSkinCheckRadioBox2: TbsSkinCheckRadioBox;
    Label27: TLabel;
    bsSkinSpinEdit2: TbsSkinSpinEdit;
    bsSkinPanel2: TbsSkinPanel;
    bsSkinGroupBox9: TbsSkinGroupBox;
    Label16: TLabel;
    ComboBox1: TbsSkinComboBox;
    Label17: TLabel;
    combobox2: TbsSkinComboBox;
    bsSkinSpeedButton4: TbsSkinSpeedButton;
    bsSkinSpeedButton5: TbsSkinSpeedButton;
    bsSkinSpeedButton6: TbsSkinSpeedButton;
    bsSkinSpeedButton7: TbsSkinSpeedButton;
    ListView1: TListView;
    bsSkinPanel3: TbsSkinPanel;
    bsSkinGroupBox10: TbsSkinGroupBox;
    bsSkinSpeedButton8: TbsSkinSpeedButton;
    bsSkinSpeedButton9: TbsSkinSpeedButton;
    bsSkinSpeedButton10: TbsSkinSpeedButton;
    bsSkinSpeedButton11: TbsSkinSpeedButton;
    bsSkinSpeedButton12: TbsSkinSpeedButton;
    bsSkinSpeedButton13: TbsSkinSpeedButton;
    Label18: TLabel;
    ListView3: TListView;
    Label19: TLabel;
    bsSkinSplitter1: TbsSkinSplitter;
    bsSkinTabSheet8: TbsSkinTabSheet;
    bsSkinTabSheet9: TbsSkinTabSheet;
    bsSkinTabSheet10: TbsSkinTabSheet;
    bsSkinTabSheet11: TbsSkinTabSheet;
    Memo1: TMemo;
    bsSkinGroupBox11: TbsSkinGroupBox;
    bsSkinCheckRadioBox3: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox4: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox5: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox6: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox7: TbsSkinCheckRadioBox;
    Label26: TLabel;
    bsSkinCheckRadioBox1: TbsSkinCheckRadioBox;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    bsSkinSpeedButton2: TbsSkinSpeedButton;
    bsSkinSpinEdit1: TbsSkinSpinEdit;
    ListView4: TListView;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ListView2: TListView;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    bsSkinExPanel1: TbsSkinExPanel;
    ListView5: TListView;
    Label28: TLabel;
    EdFindId: TbsSkinEdit;
    bsSkinSpeedButton14: TbsSkinSpeedButton;
    bsSkinSpeedButton15: TbsSkinSpeedButton;
    bsSkinSpeedButton17: TbsSkinSpeedButton;
    bsSkinSpeedButton18: TbsSkinSpeedButton;
    bsSkinSpeedButton19: TbsSkinSpeedButton;
    Label29: TLabel;
    N9: TMenuItem;
    N10: TMenuItem;
    bsSkinMessage1: TbsSkinMessage;
    bsSkinPageControl2: TbsSkinPageControl;
    bsSkinTabSheet12: TbsSkinTabSheet;
    bsSkinTabSheet13: TbsSkinTabSheet;
    bsSkinPanel4: TbsSkinPanel;
    bsSkinHeaderControl1: TbsSkinHeaderControl;
    Memo2: TMemo;
    bsSkinPanel5: TbsSkinPanel;
    Label30: TLabel;
    bsSkinSpeedButton20: TbsSkinSpeedButton;
    edtLogBaseDir: TbsSkinFileEdit;
    CheckListBox1: TCheckListBox;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    bsSkinEdit1: TbsSkinEdit;
    Label35: TLabel;
    bsSkinSpeedButton21: TbsSkinSpeedButton;
    bsSkinSpeedButton22: TbsSkinSpeedButton;
    bsSkinCheckRadioBox8: TbsSkinCheckRadioBox;
    lbLogDirList: TbsSkinListBox;
    OpenDialog1: TRzOpenDialog;
    SaveDialog: TRzSaveDialog;
    bsSkinPanel6: TbsSkinPanel;
    Label36: TLabel;
    bsSkinNumericEdit3: TbsSkinNumericEdit;
    bsSkinNumericEdit4: TbsSkinNumericEdit;
    Label37: TLabel;
    bsSkinNumericEdit5: TbsSkinNumericEdit;
    bsSkinNumericEdit6: TbsSkinNumericEdit;
    Label38: TLabel;
    bsSkinNumericEdit7: TbsSkinNumericEdit;
    bsSkinNumericEdit8: TbsSkinNumericEdit;
    Label39: TLabel;
    bsSkinCheckRadioBox9: TbsSkinCheckRadioBox;
    procedure edtMainIDDBButtonClick(Sender: TObject);
    procedure edtMainGuildBaseButtonClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure bsSkinSpeedButton3Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure bsSkinSpeedButton4Click(Sender: TObject);
    procedure bsSkinSpeedButton5Click(Sender: TObject);
    procedure bsSkinSpeedButton7Click(Sender: TObject);
    procedure bsSkinSpeedButton6Click(Sender: TObject);
    procedure bsSkinSpeedButton8Click(Sender: TObject);
    procedure ListView3Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure bsSkinSpeedButton9Click(Sender: TObject);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure ListView4Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure bsSkinPopupMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure bsSkinSpeedButton17Click(Sender: TObject);
    procedure bsSkinSpeedButton18Click(Sender: TObject);
    procedure bsSkinSpeedButton14Click(Sender: TObject);
    procedure bsSkinSpeedButton19Click(Sender: TObject);
    procedure bsSkinSpeedButton15Click(Sender: TObject);
    procedure ListView5DblClick(Sender: TObject);
    procedure bsSkinSpeedButton10Click(Sender: TObject);
    procedure bsSkinSpeedButton13Click(Sender: TObject);
    procedure bsSkinFileEdit2ButtonClick(Sender: TObject);
    procedure bsSkinSpeedButton20Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bitbtn2Click(Sender: TObject);
    procedure bsSkinCheckRadioBox9Click(Sender: TObject);
  private
    { Private declarations }
    procedure RefItemInfo(account, chrname: string; wIdx, nMakeIndex: integer; sWhere: string);
    procedure RefIDItem(Item: TListItem; DBRecord: TAccountDBRecord);
  public
    { Public declarations }
    procedure AddLog(OpPannel: string; Msg: string);
    procedure findItemCopies;
    procedure ShowIDDBPage(PageID: Integer);
    function IDInOne(ID1File, ID2File, IDOutFile, Hum1File, Mir1File, Hum2File, Mir2File, HumOutFile, MirOutFile, ReNameFile, RenameChrFile: string): Integer;
    procedure GetNewHumanRCD(var HumanRCD: THumDataInfo; slysChr2: TStringList);
  end;

var
  Form1: TForm1;

implementation

uses
  HumDB, MudUtil, ItmUnit, EditUserInfo;
{$R *.dfm}

var
  PHRcdList: array[0..99] of THumData;
  nMaxPHCount: integer;
  nCurHPRcds: Integer;
  IDPage: Integer = -1;

function CheckPath(s: string): string;
begin
  result := s;
  if s[length(s)] <> '\' then
    result := s + '\';
end;

procedure TForm1.AddLog(OpPannel: string; Msg: string);
begin
  Memo1.Lines.add('[' + OpPannel + ']  ' + Msg);
end;

function StrInList(s: string; sl: TStringList): boolean;
var
  i, j: integer;
begin
  result := false;
  for i := 0 to sl.count - 1 do
  begin
    if comparetext(sl[i], s) = 0 then
    begin
      result := true;
      break;
    end;
  end;
end;

function GetNewName(s: string; sl: TStringList): string;
var
  i: Integer;
  stmp: string;
begin
  result := s;
  stmp := s + #9;
  for i := 0 to sl.count - 1 do
  begin
    if CompareLStr(sl[i], stmp, length(stmp)) then
    begin
      result := sl[i];
      delete(result, 1, pos(#9, result));
      break;
    end;
  end;
end;

function GetNewNamexp(s, s2: string; sl: TStringList): string;
var
  i: Integer;
begin
  result := '';
  for i := 0 to sl.Count - 1 do
  begin
    if (s = sl.Strings[i]) and (pTYSHUMFG(sl.Objects[i]).oldChrName = s2) then
    begin
      result := pTYSHUMFG(sl.Objects[i]).NewChrname;
      break;
    end;
  end;
end;

procedure TForm1.GetNewHumanRCD(var HumanRCD: THumDataInfo; slysChr2: TStringList);
var
  i, j, k: Integer;
begin
  //装备
  for k := 0 to 8 do
  begin
    Application.ProcessMessages;
    if HumanRCD.Data.HumItems[k].wIndex > 0 then
    begin
      if (HumanRCD.Data.HumItems[k].MakeIndex >= bsSkinNumericEdit3.Value) and (HumanRCD.Data.HumItems[k].MakeIndex <= bsSkinNumericEdit4.Value) then
      begin
        bsSkinNumericEdit7.Value := bsSkinNumericEdit7.Value + 1;
        i := Str_ToInt(bsSkinNumericEdit7.text, 0);
        slysChr2.Add(format('人物:  %s    原始编号:  %d    转换后编号:  %d ', [HumanRCD.Data.sChrName, HumanRCD.Data.HumItems[k].MakeIndex, i]));

        HumanRCD.Data.HumItems[k].MakeIndex := i;
      end;
      if (HumanRCD.Data.HumItems[k].MakeIndex >= bsSkinNumericEdit5.Value) and (HumanRCD.Data.HumItems[k].MakeIndex <= bsSkinNumericEdit6.Value) then
      begin
        bsSkinNumericEdit8.Value := bsSkinNumericEdit8.Value + 1;
        i := Str_ToInt(bsSkinNumericEdit8.text, 0);
        HumanRCD.Data.HumItems[k].MakeIndex := i;
      end;
    end;
  end;

  //背包
  for k := Low(TBagItems) to High(TBagItems) do
  begin
    Application.ProcessMessages;
    if HumanRCD.Data.BagItems[k].wIndex > 0 then
    begin
      if (HumanRCD.Data.BagItems[k].MakeIndex >= bsSkinNumericEdit3.Value) and (HumanRCD.Data.BagItems[k].MakeIndex <= bsSkinNumericEdit4.Value) then
      begin
        bsSkinNumericEdit7.Value := bsSkinNumericEdit7.Value + 1;
        i := Str_ToInt(bsSkinNumericEdit7.text, 0);
        slysChr2.Add(format('人物:  %s    原始编号:  %d    转换后编号:  %d ', [HumanRCD.Data.sChrName, HumanRCD.Data.BagItems[k].MakeIndex, i]));
        HumanRCD.Data.BagItems[k].MakeIndex := i;
      end;
      if (HumanRCD.Data.BagItems[k].MakeIndex >= bsSkinNumericEdit5.Value) and (HumanRCD.Data.BagItems[k].MakeIndex <= bsSkinNumericEdit6.Value) then
      begin
        bsSkinNumericEdit8.Value := bsSkinNumericEdit8.Value + 1;
        i := Str_ToInt(bsSkinNumericEdit8.text, 0);
        HumanRCD.Data.BagItems[k].MakeIndex := i;
      end;
    end;
  end;

  //仓库
  for k := Low(TStorageItems) to High(TStorageItems) do
  begin
    Application.ProcessMessages;
    if HumanRCD.Data.StorageItems[k].wIndex > 0 then
    begin
      if (HumanRCD.Data.StorageItems[k].MakeIndex >= bsSkinNumericEdit3.Value) and (HumanRCD.Data.StorageItems[k].MakeIndex <= bsSkinNumericEdit4.Value) then
      begin
        bsSkinNumericEdit7.Value := bsSkinNumericEdit7.Value + 1;
        i := Str_ToInt(bsSkinNumericEdit7.text, 0);
        slysChr2.Add(format('人物:  %s    原始编号:  %d    转换后编号:  %d ', [HumanRCD.Data.sChrName, HumanRCD.Data.StorageItems[k].MakeIndex, i]));
        HumanRCD.Data.StorageItems[k].MakeIndex := i;
      end;
      if (HumanRCD.Data.StorageItems[k].MakeIndex >= bsSkinNumericEdit5.Value) and (HumanRCD.Data.StorageItems[k].MakeIndex <= bsSkinNumericEdit6.Value) then
      begin
        bsSkinNumericEdit8.Value := bsSkinNumericEdit8.Value + 1;
        i := Str_ToInt(bsSkinNumericEdit8.text, 0);
        HumanRCD.Data.StorageItems[k].MakeIndex := i;
      end;
    end;
  end;

end;

function TForm1.IDInOne(ID1File, ID2File, IDOutFile, Hum1File, Mir1File, Hum2File, Mir2File, HumOutFile, MirOutFile, ReNameFile, RenameChrFile: string): Integer;
var
  I, J, K, II: Integer;
  sl, slChr, GuildRen, guildList, guildList2, LoadList: TStringList;
  IDDB1, IDDB2, IDDBOut: TFileIDDB;
  DBRec1, DBRec2: TAccountDBRecord;
  HumDB1, HumDBOut: TFileHumDB;
  MirDB1, MirDBOut: TFileDB;
  RepChar: Char;
  RepStr, stmp, s1C: string;
  borename: boolean;
  NewName, NewChrname: string;
  ChrList: TStringList;
  QuickID: pTQuickID;
  ChrRecord: THumDataInfo;
  HumRecord: THumInfo;
  sChrName: string;
  oldAccount, oldChrName: string;
  sfn, oldGuildName, NewGuildName: string;
  nGuild1Count: Integer;
  ini1, ini2: TiniFile;
  n28: integer;
  AdjLevel: Integer;
  MaxAdjLevel: Integer;
  expired: boolean;
  slysChr2: TStringList;
  slysChr: TStringList;
  YSHUMFG: pTYSHUMFG;
begin
  result := -1;
  if not (fileexists(ID1File) or fileexists(ID2File)) then
    exit;
  sl := TStringList.Create;
  slChr := TStringList.Create;
  ChrList := TStringList.Create;
  GuildRen := TStringList.Create;
  guildList := TStringList.Create;
  guildList2 := TStringList.Create;
  LoadList := TStringList.Create;

  slysChr := TStringList.Create;
  slysChr2 := TStringList.Create;

  AdjLevel := strtoInt(bsSkinNumericEdit1.text);
  MaxAdjLevel := strtoInt(bsSkinNumericEdit1.text);
  stStatus.Caption := '正在合主区数据，请稍候...';
  try
    IDDB1 := TFileIDDB.Create(ID1File);
    try
      IDDB2 := TFileIDDB.Create(ID2File);
      try
        IDDBOut := TFileIDDB.Create(IDOutFile);
        HumDBOut := TFileHumDB.Create(HumOutFile);
        MirDBOut := TFileDB.Create(MirOutFile);
        try
          if IDDBOut.Open and HumDBOut.Open and MirDBOut.Open then
          begin
             //把1的数据拷贝到out
            AddLog('合区', '打开' + IDDB1.m_sDBFileName + '...');
            if IDDB1.Open then
            begin
              Gauge1.Progress := 0;
              AddLog('合区', '该文件共有' + inttostr(IDDB1.m_Header.nIDCount) + '条记录');
              Gauge1.MaxValue := IDDB1.m_Header.nIDCount;
              HumDB1 := TFileHumDB.Create(Hum1File);
              MirDB1 := TFileDB.Create(Mir1File);
              try
                if HumDB1.Open and MirDB1.OpenEx then
                begin
                  AddLog('合区', '文件' + HumDB1.m_sDBFileName + ' 共有' + inttostr(HumDB1.m_Header.nHumCount) + '条记录');
                  AddLog('合区', '文件' + MirDB1.m_sDBFileName + ' 共有' + inttostr(MirDB1.m_Header.nHumCount) + '条记录');
                  for I := 0 to IDDB1.m_QuickList.Count - 1 do
                  begin
                    Gauge1.Progress := I;
                    Application.ProcessMessages;
                    if IDDB1.Get(I, DBRec1) >= 0 then
                    begin
                      IDDBOut.Add(DBRec1);
                        //把帐号下的人物拷贝过去
                      ChrList.Clear;
                      HumDB1.FindByAccount(DBRec1.UserEntry.sAccount, ChrList);
                      for J := 0 to ChrList.Count - 1 do
                      begin
                        QuickID := pTQuickID(ChrList.Objects[J]);
                          //HumDB
                        if HumDB1.GetBy(QuickID.nIndex, HumRecord) then
                        begin
                          HumDBOut.Add(HumRecord);
                             //MirDB
                          sChrName := QuickID.sChrName;
                          K := MirDB1.Index(sChrName);
                          if (K >= 0) and (MirDB1.Get(K, ChrRecord) >= 0) then
                          begin
                            if bsSkinCheckRadioBox9.Checked then
                              GetNewHumanRCD(ChrRecord, slysChr2);
                            MirDBOut.Add(ChrRecord);
                          end;
                        end;
                      end;
                    end;
                  end;
                  HumDB1.Close;
                  MirDB1.Close;
                end;
              finally
                HumDB1.Free;
                MirDB1.Free;
              end;
            end;
            IDDB1.Close;
             //把2的数据放到out
            if IDDB2.Open then
            begin
              Gauge1.Progress := 0;
              Gauge1.MaxValue := IDDB2.m_Header.nIDCount;

              stStatus.Caption := '正在合从区数据，请稍候...';

              HumDB1 := TFileHumDB.Create(Hum2File);
              MirDB1 := TFileDB.Create(Mir2File);
              if expired or (HumDB1.Open and MirDB1.Open) then
              begin
                AddLog('合区', '文件' + HumDB1.m_sDBFileName + ' 共有' + inttostr(HumDB1.m_Header.nHumCount) + '条记录');
                AddLog('合区', '文件' + MirDB1.m_sDBFileName + ' 共有' + inttostr(MirDB1.m_Header.nHumCount) + '条记录');
                for I := 0 to IDDB2.m_QuickList.Count - 1 do
                begin
                  Gauge1.Progress := I;
                  Application.ProcessMessages;
                  if IDDB2.Get(I, DBRec1) >= 0 then
                  begin
                      //合并帐号
                    RepChar := '0';
                    RepStr := Edit2.text;
                    borename := false;
                    NewName := DBRec1.UserEntry.sAccount;
                    oldAccount := NewName;
                    while (IDDBOut.Index(NewName) >= 0) and (RepChar <= 'z') do
                    begin
                      if RepChar <> '0' then
                      begin
                        RepChar := Chr(ord(RepChar) + 1);
                        RepStr := RepChar;
                      end
                      else
                        RepChar := 'a';
                      NewName := Copy(NewName, 1, 10 - Length(RepStr)) + RepStr;
                      borename := True;
                    end;
                    if borename then
                    begin
                      sl.Add(DBRec1.UserEntry.sAccount + #9 + NewName);
                      DBRec1.UserEntry.sAccount := NewName;
                    end;
                    IDDBOut.Add(DBRec1);
                      //帐号下人物处理
                    ChrList.Clear;
                    HumDB1.FindByAccount(oldAccount, ChrList);
                    for J := 0 to ChrList.Count - 1 do
                    begin
                      QuickID := pTQuickID(ChrList.Objects[J]);
                        //HumDB
                      if HumDB1.GetBy(QuickID.nIndex, HumRecord) then
                      begin
                        RepChar := '0';
                        RepStr := Edit2.text;
                        borename := false;
                        NewChrname := HumRecord.sChrName;
                        oldChrName := HumRecord.sChrName;
                        while (HumDBOut.Index(NewChrname) >= 0) and (RepChar <= 'z') do
                        begin
                          if RepChar <> '0' then
                          begin
                            RepChar := Chr(ord(RepChar) + 1);
                            RepStr := RepChar;
                          end
                          else
                            RepChar := 'a';
                          NewChrname := Copy(oldChrName, 1, 14 - Length(RepStr)) + RepStr;
                          borename := True;
                        end;
                        if borename then
                        begin  //重名，则修改
                          slChr.Add(oldChrName + #9 + NewChrname);
                          NEW(YSHUMFG);
                          YSHUMFG.sAccount := NewName;
                          YSHUMFG.oldChrName := oldChrName;
                          YSHUMFG.NewChrname := NewChrname;
                          slysChr.AddObject(NewName, TObject(YSHUMFG));
                        end;
                  //        HumRecord.Header.sAccount:=Newname;
                        HumRecord.Header.sName := NewChrname;
                        HumRecord.sAccount := NewName; //使用新的帐号
                        HumRecord.sChrName := NewChrname;
                        HumDBOut.Add(HumRecord);
                          //MirDB
                        sChrName := QuickID.sChrName;
                        K := MirDB1.Index(sChrName);
                        if (K >= 0) and (MirDB1.Get(K, ChrRecord) >= 0) then
                        begin
            //                 ChrRecord.Header.sAccount:=NewName;
                          ChrRecord.Header.sName := NewChrname;
                          ChrRecord.Data.sAccount := NewName;
                          ChrRecord.Data.sChrName := NewChrname;
                             //等级调整
                          if AdjLevel <> 0 then
                          begin
                            if ChrRecord.Data.Abil.Level + AdjLevel < 1 then
                              ChrRecord.data.Abil.Level := 1
                            else if ChrRecord.data.Abil.Level + AdjLevel > MaxAdjLevel then
                              ChrRecord.Data.Abil.Level := MaxAdjLevel
                            else
                              ChrRecord.Data.Abil.Level := ChrRecord.Data.Abil.Level + AdjLevel;
                          end;

                          if bsSkinCheckRadioBox9.Checked then
                            GetNewHumanRCD(ChrRecord, slysChr2);
                          MirDBOut.Add(ChrRecord);
                        end
                        else
                          AddLog('数据丢失', '未找到人物数据：' + oldAccount + ':' + sChrName);
                      end;
                    end;
                  end;
                end;
              end;
              IDDB2.Close;
            end;
            AddLog('合区', '数据合并完成!');
            AddLog('合区', '文件' + IDDBOut.m_sDBFileName + ' 共有' + inttostr(IDDBOut.m_Header.nIDCount) + '条记录');
            AddLog('合区', '文件' + HumDBOut.m_sDBFileName + ' 共有' + inttostr(HumDBOut.m_Header.nHumCount) + '条记录');
            AddLog('合区', '文件' + MirDBOut.m_sDBFileName + ' 共有' + inttostr(MirDBOut.m_Header.nHumCount) + '条记录');
            IDDBOut.Close;
            MirDBOut.Close;
            HumDBOut.Close;
            sl.SaveToFile(ReNameFile);
            slChr.SaveToFile(RenameChrFile);
          end;
        finally
          IDDBOut.Free;
          HumDBOut.Free;
          MirDBOut.Free;
        end;
      finally
        IDDB2.Free;
      end;
    finally
      IDDB1.Free;
    end;

    IDDBOut := TFileIDDB.Create(IDOutFile);
    HumDBOut := TFileHumDB.Create(HumOutFile);
    MirDBOut := TFileDB.Create(MirOutFile);
    stStatus.Caption := '开始合并英雄关联数据。。';
    try
      if IDDBOut.Open and HumDBOut.Open and MirDBOut.Open then
      begin
        Gauge1.Progress := 0;
        Gauge1.MaxValue := IDDBOut.m_Header.nIDCount;
        for I := 0 to IDDBOut.m_Header.nIDCount - 1 do
        begin
          Gauge1.Progress := I;
          Application.ProcessMessages;
          if IDDBOut.Get(I, DBRec1) >= 0 then
          begin

            ChrList.Clear;
            HumDBOut.FindByAccount(DBRec1.UserEntry.sAccount, ChrList);

            for J := 0 to ChrList.Count - 1 do
            begin
              QuickID := pTQuickID(ChrList.Objects[J]);
              sChrName := QuickID.sChrName;
              K := MirDBOut.Index(sChrName);
              if (K >= 0) and (MirDBOut.Get(K, ChrRecord) >= 0) then
              begin

                if (ChrRecord.Data.sHeroName <> '') then
                begin
                  NewChrname := GetNewNamexp(ChrRecord.Data.sAccount, ChrRecord.Data.sHeroName, slysChr);
                  if NewChrname <> '' then
                    ChrRecord.Data.sHeroName := NewChrname;
                end;
                if (ChrRecord.Data.sHeroMasterName <> '') then
                begin
                  NewChrname := GetNewNamexp(ChrRecord.Data.sAccount, ChrRecord.Data.sHeroMasterName, slysChr);
                  if NewChrname <> '' then
                    ChrRecord.Data.sHeroMasterName := NewChrname;
                end;

                MirDBOut.Update(K, ChrRecord);

              end;
            end;
          end;
        end;
      end;

      IDDBOut.Close;
      MirDBOut.Close;
      HumDBOut.Close;
      slysChr2.SaveToFile(bsSkinEdit4.Text + 'GM刷出装备编号转换记录.txt');
    finally
      IDDBOut.Free;
      HumDBOut.Free;
      MirDBOut.Free;
      slysChr.Free;
      slysChr2.Free;
    end;
    stStatus.Caption := '合并英雄关联数据完成。。';
    AddLog('合区', '合并英雄关联数据完成!');
    Application.ProcessMessages;
     //合并行会
     //1）把A行会数据直接拷贝过去
    sfn := edtMainGuildBase.Text + 'Guildlist.txt';
    if fileexists(sfn) then
    begin
      guildList.LoadFromFile(sfn);
    end;
    nGuild1Count := guildList.Count;
    ForceDirectories(bsSkinEdit4.Text + 'Guilds\');

    stStatus.Caption := '合并主行会...';
    Gauge1.Progress := 0;
    Gauge1.MaxValue := nGuild1Count;
    for I := 0 to nGuild1Count - 1 do
    begin
      Gauge1.Progress := I + 1;
      Application.ProcessMessages;
      oldGuildName := guildList[I];
      sfn := edtMainGuildBase.Text + 'Guilds\' + oldGuildName + '.ini';
      if fileexists(sfn) then
        copyfile(pchar(sfn), pchar(bsSkinEdit4.Text + 'Guilds\' + oldGuildName + '.ini'), false);
      sfn := edtMainGuildBase.Text + 'Guilds\' + oldGuildName + '.txt';
      if fileexists(sfn) then
        copyfile(pchar(sfn), pchar(bsSkinEdit4.Text + 'Guilds\' + oldGuildName + '.txt'), false);
    end;
     //2)把第二个行会数据合并进去
    sfn := edtGuildBase2.Text + 'Guildlist.txt';
    if fileexists(sfn) then
    begin
      guildList2.LoadFromFile(sfn);
    end;
     //检查行会重命名,并把B行会名称合并进去
    for I := 0 to guildList2.Count - 1 do
    begin
      oldGuildName := guildList2[I];
      RepChar := '0';
      RepStr := Edit2.text;
      borename := false;
      NewGuildName := oldGuildName;
      while StrInList(NewGuildName, guildList) and (RepChar <= 'z') do
      begin
        if RepChar <> '0' then
        begin
          RepChar := Chr(ord(RepChar) + 1);
          RepStr := RepChar;
        end
        else
          RepChar := 'a';
        NewGuildName := oldGuildName + RepStr;
        borename := True;
      end;
      guildList.Add(NewGuildName);
      if borename then
        GuildRen.Add(oldGuildName + #9 + NewGuildName);
    end;
     //把B行会数据合并进去，主要是检查行会成员重名的修改
    stStatus.Caption := '合并第二个分区行会...';
    Gauge1.Progress := 0;
    Gauge1.MaxValue := guildList.Count - nGuild1Count;
    for I := nGuild1Count to guildList.Count - 1 do
    begin
      Gauge1.Progress := I - nGuild1Count + 1;
      Application.ProcessMessages;

      oldGuildName := guildList2[I - nGuild1Count];
      NewGuildName := guildList[I];
        //行会配置信息合并
      ini1 := TIniFile.Create(edtGuildBase2.Text + 'Guilds\' + oldGuildName + '.ini');
      try
        ini2 := TIniFile.Create(bsSkinEdit4.Text + 'Guilds\' + NewGuildName + '.ini');
        try
          ini2.WriteString('Guild', 'GuildName', NewGuildName);
          ini2.WriteInteger('Guild', 'BuildPoint', ini1.ReadInteger('Guild', 'BuildPoint', 0));
          ini2.WriteInteger('Guild', 'Aurae', ini1.ReadInteger('Guild', 'Aurae', 0));
          ini2.WriteInteger('Guild', 'Stability', ini1.ReadInteger('Guild', 'Stability', 0));
          ini2.WriteInteger('Guild', 'Flourishing', ini1.ReadInteger('Guild', 'Flourishing', 0));
          ini2.WriteInteger('Guild', 'ChiefItemCount', ini1.ReadInteger('Guild', 'ChiefItemCount', 0));
          ini2.WriteInteger('Guild', 'GuildExp', ini1.ReadInteger('Guild', 'GuildExp', 0));
        finally
          ini2.free;
        end;
      finally
        ini1.Free;
      end;

      sfn := edtGuildBase2.Text + 'Guilds\' + oldGuildName + '.txt';
      if not fileexists(sfn) then
        continue;
      LoadList.LoadFromFile(sfn);
      for J := 0 to LoadList.Count - 1 do
      begin
        stmp := LoadList.Strings[J];
        if (stmp = '') or (stmp[1] = ';') or (stmp[1] = '#') then
          Continue;
        if stmp[1] <> '+' then
        begin
          if stmp = '公告' then
            n28 := 1;
          if stmp = '敌对行会' then
            n28 := 2;
          if stmp = '联盟行会' then
            n28 := 3;
          if stmp = '行会成员' then
            n28 := 4;
          Continue;
        end;
        stmp := Copy(stmp, 2, Length(stmp) - 1);
        case n28 of    //
          1:
            ;      //公告信息，无须修改
          2, 3:
            begin  //敌对/联盟行会，要修改行会名称为新的名称
              LoadList[J] := '+';
              while (stmp <> '') do
              begin
                stmp := GetValidStr3(stmp, s1C, [' ', ',']);
                if s1C = '' then
                  break;
                s1C := GetNewName(s1C, GuildRen);
                LoadList[J] := LoadList[J] + s1C + ' ';
              end;
            end;
          4:
            begin
              LoadList[J] := '+';
              while (stmp <> '') do
              begin
                stmp := GetValidStr3(stmp, s1C, [' ', ',']);
                if s1C = '' then
                  break;
                s1C := GetNewName(s1C, slChr);
                LoadList[J] := LoadList[J] + s1C + ' ';
              end;
            end;
        end;
      end;
      sfn := bsSkinEdit4.Text + 'Guilds\' + oldGuildName + '.txt';
      LoadList.SaveToFile(sfn);
    end;
    guildList.SaveToFile(bsSkinEdit4.Text + 'GuildList.txt');
    GuildRen.SaveToFile(bsSkinEdit4.Text + '重名行会.txt');
  finally
    sl.Free;
    slChr.Free;
    ChrList.Free;
    GuildRen.free;
    guildList.Free;
    guildList2.Free;
    LoadList.Free;
    stStatus.Caption := '就绪';
    Label15.Caption := '合并结果：以完成,请查看操作日志！'
  end;
end;

procedure TForm1.edtMainIDDBButtonClick(Sender: TObject);
begin
  if Opendialog1.InitialDir = '' then
    opendialog1.InitialDir := edtMainDir.Text;
  Opendialog1.Filter := '传奇数据库(*.DB)|*.DB|所有文件(*.*)|*.*';
  Opendialog1.FileName := TbsSkinFileEdit(Sender).Text;
  if opendialog1.Execute then
    TbsSkinFileEdit(Sender).Text := Opendialog1.FileName;
end;

procedure TForm1.edtMainGuildBaseButtonClick(Sender: TObject);
begin
  opendirdialog.Directory := TbsSkinFileEdit(Sender).Text;
  if opendirdialog.Execute then
  begin
    TbsSkinFileEdit(Sender).Text := opendirdialog.Directory;
    if length(TbsSkinFileEdit(Sender).Text) > 0 then
      if TbsSkinFileEdit(Sender).Text[Length(TbsSkinFileEdit(Sender).Text)] <> '\' then
        TbsSkinFileEdit(Sender).Text := TbsSkinFileEdit(Sender).Text + '\';
    if Sender = edtLogBaseDir then
      bsSkinSpeedButton20Click(Sender);
  end;

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
   if bsSkinEdit4.Text='' then begin
     messagebox(handle,'请选择输出目录！','错误',0);
     exit;
   end;
  if bsSkinEdit4.Text[length(bsSkinEdit4.Text)]<>'\' then
    bsSkinEdit4.Text:=bsSkinEdit4.Text+'\';

  IDinOne(edtMainIDDB.Text,edtIDDB2.Text,bsSkinEdit4.Text+'ID.DB',
  edtMainHumDB.Text,edtMainMirDB.Text,
  edtHumDB2.Text,edtMirDB2.Text,
  bsSkinEdit4.Text+'Hum.DB',bsSkinEdit4.Text+'Mir.DB',
  bsSkinEdit4.Text+'ID重名记录.txt',bsSkinEdit4.Text+'人物重名记录.txt');
  bitbtn1.Enabled:=False;  //合并后关闭合并按钮防止再次点击导致数据叠加
end;


//整理数据库
procedure TForm1.Button8Click(Sender: TObject);
var
  HumDB: TFileHumDB;
  MirDB: TFileDB;
  MirRec: THumDataInfo;
  HumRec: THumInfo;
  i: integer;
begin
  HumDB := TFileHumDB.Create(bsSkinFileEdit2.Text);
  MirDB := TFileDB.Create(bsSkinFileEdit1.Text);
  try
    if MirDB.Open then
    begin
      if HumDB.Open then
      begin
        stStatus.Caption := '正在重建Hum.DB，请稍候...';
        gauge1.Progress := 0;
        gauge1.MaxValue := MirDB.m_MirQuickList.Count;
        for i := 0 to MirDB.m_MirQuickList.Count - 1 do
        begin
          if MirDB.Get(i, MirRec) <> -1 then
          begin
            fillchar(HumRec, sizeof(THumInfo), 0);
            HumRec.Header.dCreateDate := MirRec.Header.dCreateDate;
            HumRec.Header.sName := MirRec.Data.sChrName;
            HumRec.Header.boDeleted := MirRec.Header.boDeleted;
            HumRec.sAccount := MirRec.Data.sAccount;
            HumRec.boSelected := false;
            HumRec.boDeleted := MirRec.Header.boDeleted;
            HumRec.dModDate := MirRec.Header.dCreateDate;
            HumRec.btCount := 0;
            HumRec.sChrName := MirRec.Data.sChrName;
            HumDB.Add(HumRec);
          end;
          gauge1.Progress := i + 1;
        end;
        HumDB.Close;
      end;
      MirDB.Close;
    end;
  finally
    HumDB.Free;
    MirDB.Free;
    stStatus.Caption := '重建Hum.DB完成';
  end;
end;

procedure TForm1.bsSkinSpeedButton3Click(Sender: TObject);
var
  i: integer;
begin
  Query.DatabaseName := edit1.Text;
  LoadMagicDB();
  LoadItemsDB;
end;

procedure TForm1.ComboBox1DropDown(Sender: TObject);
begin
  if StdItemList.Count = 0 then
  begin
    bsSkinSpeedButton3click(self);
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  i: integer;
  nStdMode: Integer;
  s: string;
begin
  s := Combobox1.Text;
  if s = '' then
    exit;
  delete(s, pos('-', s), 100);
  nStdMode := Str_ToInt(s, 0);
  combobox2.Items.Clear;
  for i := 0 to StdItemList.Count - 1 do
  begin
    if pTStdItem(StdItemList[i]).StdMode = nStdMode then
    begin
      combobox2.Items.Add(InttoStr(i + 1) + '-' + pTStdItem(StdItemList[i]).Name);
    end;
  end;
  if combobox2.Items.Count > 0 then
    combobox2.ItemIndex := 0;
end;

procedure TForm1.bsSkinSpeedButton4Click(Sender: TObject);
var
  i: integer;
  nStdMode: integer;
  S: string;
  boFound: boolean;
begin
  S := combobox2.Text;
  if S = '' then
    exit;
  delete(S, pos('-', S), 100);
  nStdMode := Str_ToInt(S, 1);
  boFound := false;
  for i := 0 to Listview1.Items.Count - 1 do
  begin
    if Listview1.Items[i].Caption = S then
    begin
      boFound := true;
      break;
    end;
  end;
  if not boFound then
  begin
    with Listview1.Items.Add do
    begin
      Caption := S;
      Subitems.Add(pTStdItem(StdItemList[nStdMode - 1]).Name);
    end;
  end;
end;

procedure TForm1.bsSkinSpeedButton5Click(Sender: TObject);
var
  i, j: integer;
  nStdMode: Integer;
  s: string;
  boFound: boolean;
begin
  s := Combobox1.Text;
  if s = '' then
    exit;
  delete(s, pos('-', s), 100);
  nStdMode := Str_ToInt(s, 0);
  for i := 0 to StdItemList.Count - 1 do
  begin
    if pTStdItem(StdItemList[i]).StdMode = nStdMode then
    begin
      boFound := false;
      for j := 0 to Listview1.Items.Count - 1 do
      begin
        if Listview1.Items[j].Caption = inttostr(i + 1) then
        begin
          boFound := true;
          break;
        end;
      end;
      if not boFound then
      begin
        with Listview1.Items.Add do
        begin
          Caption := inttostr(i + 1);
          Subitems.Add(pTStdItem(StdItemList[i]).Name);
        end;
      end;
    end;
  end;
end;

procedure TForm1.bsSkinSpeedButton7Click(Sender: TObject);
begin
  Listview1.Items.Clear;
end;

procedure TForm1.bsSkinSpeedButton6Click(Sender: TObject);
begin
  if Listview1.Selected = nil then
    exit;
  Listview1.DeleteSelected;
end;

procedure TForm1.RefItemInfo(account, chrname: string; wIdx, nMakeIndex: integer; sWhere: string);
begin
  with Listview3.Items.Add do
  begin
    Caption := account;
    Subitems.Add(chrname);
    Subitems.Add(GetStdItemName(wIdx));
    Subitems.Add(inttostr(wIdx));
    SubItems.Add(inttostr(nMakeIndex));
    SubItems.Add(sWhere);
  end;
end;

procedure TForm1.findItemCopies;
var
  i: integer;
  sLastIdx: string;
  boIsNewID: boolean;
begin
  if Listview3.Items.Count = 0 then
    exit;
  Listview2.Items.BeginUpdate;
  try
    Listview2.Items.Clear;
    boIsNewID := true;
    sLastIdx := Listview3.Items[0].SubItems[3];
    for i := 1 to Listview3.Items.Count - 1 do
    begin
      if Listview3.Items[i].SubItems[3] = sLastIdx then
      begin
        if boIsNewID then
        begin
          ListView2.Items.Add.Assign(Listview3.Items[i - 1]);
        end;
        boIsNewID := False;
        ListView2.Items.Add.Assign(Listview3.Items[i]);
      end
      else
        boIsNewID := true;
      sLastIdx := Listview3.Items[i].SubItems[3];
    end;
  finally
    Listview2.Items.EndUpdate;
  end;
  Label19.Caption := '复制品所属列表（ ' + inttostr(Listview2.Items.Count) + ' 条）';
end;

procedure TForm1.bsSkinSpeedButton8Click(Sender: TObject);
var
  i, j, k: Integer;
  wIdx: integer;
  HumanRCD: THumDataInfo;
  expired: boolean;
begin
  if Listview1.Items.Count = 0 then
    exit;
  edtDBSPath.Text := CheckPath(edtDBSPath.Text);
  HumDataDB := TFileDB.Create(edtDBSPath.Text + MIRDBNAME);
  ListView3.Items.BeginUpdate;
  stStatus.Caption := '正在查找，请稍候...';
  try
    ListView3.Items.Clear;
    if HumDataDB.Open then
    begin
      gauge1.Progress := 0;
      gauge1.MaxValue := HumDataDB.m_MirQuickList.Count;
      for i := 0 to HumDataDB.m_MirQuickList.Count - 1 do
      begin
        if HumDataDB.Get(i, HumanRCD) >= 0 then
        begin
          for j := 0 to ListView1.Items.Count - 1 do
          begin
            wIdx := StrToInt(ListView1.Items[j].Caption);
                //装备
            for k := 0 to 8 do
            begin
              if HumanRCD.Data.HumItems[k].wIndex = wIdx then
              begin
                RefItemInfo(HumanRCD.Data.sAccount, HumanRCD.Data.sChrName, HumanRCD.Data.HumItems[k].wIndex, HumanRCD.Data.HumItems[k].MakeIndex, '-' + inttostr(k));
              end;
            end;
                //包裹
            if not expired then
            begin
              for k := Low(TBagItems) to High(TBagItems) do
              begin
                if HumanRCD.Data.BagItems[k].wIndex = wIdx then
                begin
                  RefItemInfo(HumanRCD.Data.sAccount, HumanRCD.Data.sChrName, HumanRCD.Data.BagItems[k].wIndex, HumanRCD.Data.BagItems[k].MakeIndex, inttostr(k));
                end;
              end;
                //仓库
              for k := Low(TStorageItems) to High(TStorageItems) do
              begin
                if HumanRCD.Data.StorageItems[k].wIndex = wIdx then
                begin
                  RefItemInfo(HumanRCD.Data.sAccount, HumanRCD.Data.sChrName, HumanRCD.Data.StorageItems[k].wIndex, HumanRCD.Data.StorageItems[k].MakeIndex, inttostr(100 + k));
                end;
              end;
            end;
          end;
        end;
        gauge1.Progress := i + 1;
      end;
      HumDataDB.Close;
    end;
    Label18.Caption := '物品所属列表（ ' + inttostr(Listview3.Items.Count) + ' 条）';
  finally
    HumDataDB.Free;
    Listview3.Items.EndUpdate;
    stStatus.Caption := '就绪';
  end;
  findItemCopies;
end;

procedure TForm1.ListView3Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Compare := Str_ToInt(Item1.SubItems[3], 0) - Str_ToInt(Item2.SubItems[3], 0);
end;

procedure TForm1.bsSkinSpeedButton9Click(Sender: TObject);
var
  sMakeIndex: string;
  nMakeIndex: integer;
  i, j, k: Integer;
  HumanRCD: THumDataInfo;
begin
  sMakeIndex := InputDialog.InputBox('查找物品', '请输入要查找的物品制造编码：', '');
  if sMakeIndex = '' then
    exit;
  nMakeIndex := Str_ToInt(sMakeIndex, 0);
  if nMakeIndex = 0 then
    exit;

  edtDBSPath.Text := CheckPath(edtDBSPath.Text);
  HumDataDB := TFileDB.Create(edtDBSPath.Text + MIRDBNAME);
  ListView3.Items.BeginUpdate;
  try
    ListView3.Items.Clear;
    if HumDataDB.Open then
    begin
      gauge1.Progress := 0;
      stStatus.Caption := '正在查找，请稍候...';
      gauge1.MaxValue := HumDataDB.m_MirQuickList.Count;
      for i := 0 to HumDataDB.m_MirQuickList.Count - 1 do
      begin
        if HumDataDB.Get(i, HumanRCD) >= 0 then
        begin
                //装备
          for k := 0 to 8 do
          begin
            if HumanRCD.Data.HumItems[k].MakeIndex = nMakeIndex then
            begin
              RefItemInfo(HumanRCD.Data.sAccount, HumanRCD.Data.sChrName, HumanRCD.Data.HumItems[k].wIndex, HumanRCD.Data.HumItems[k].MakeIndex, '-' + inttostr(k));
            end;
          end;
                //包裹
          for k := Low(TBagItems) to High(TBagItems) do
          begin
            if HumanRCD.Data.BagItems[k].MakeIndex = nMakeIndex then
            begin
              RefItemInfo(HumanRCD.Data.sAccount, HumanRCD.Data.sChrName, HumanRCD.Data.BagItems[k].wIndex, HumanRCD.Data.BagItems[k].MakeIndex, inttostr(k));
            end;
          end;
                //仓库
          for k := Low(TStorageItems) to High(TStorageItems) do
          begin
            if HumanRCD.Data.StorageItems[k].MakeIndex = nMakeIndex then
            begin
              RefItemInfo(HumanRCD.Data.sAccount, HumanRCD.Data.sChrName, HumanRCD.Data.StorageItems[k].wIndex, HumanRCD.Data.StorageItems[k].MakeIndex, inttostr(100 + k));
            end;
          end;
        end;
        gauge1.Progress := i + 1;
      end;
      HumDataDB.Close;
      Label18.Caption := '物品所属列表（ ' + inttostr(Listview3.Items.Count) + ' 条）';
    end;
  finally
    HumDataDB.Free;
    Listview3.Items.EndUpdate;
    stStatus.Caption := '就绪';
  end;
  findItemCopies;
end;

procedure TForm1.bsSkinSpeedButton1Click(Sender: TObject);
var
  i, j: integer;
  HumRcd: THumDataInfo;
  nIdx: integer;
begin
  fillchar(PHRcdList, sizeof(THumData) * 100, 0);
  nMaxPHCount := Str_ToInt(bsSkinSpinEdit1.Text, 100);
  nCurHPRcds := 0;
  edtDBSPath.Text := CheckPath(edtDBSPath.Text);
  HumDataDB := TFileDB.Create(edtDBSPath.Text + MIRDBNAME);
  Listview4.Items.BeginUpdate;
  stStatus.Caption := '正在分析，请稍候...';
  try
    Listview4.Items.Clear;
    if HumDataDB.Open then
    begin
      gauge1.Progress := 0;
      gauge1.MaxValue := HumDataDB.m_MirQuickList.Count;
      for i := 0 to HumDataDB.m_MirQuickList.Count - 1 do
      begin
        if HumDataDB.Get(i, HumRcd) >= 0 then
        begin
          if not bsSkinCheckRadioBox1.Checked {and (HumRcd.Data.btYuanLevel>0)} then
            continue;
          if nCurHPRcds < nMaxPHCount then
          begin
            PHRcdList[nCurHPRcds] := HumRcd.Data;
            inc(nCurHPRcds);
          end
          else
          begin
            nIdx := -1;
            for j := 0 to nCurHPRcds - 1 do
            begin
              if bsSkinCheckRadioBox3.Checked then
              begin           //等级
                if (HumRcd.Data.Abil.Level > PHRcdList[j].Abil.Level) or ((HumRcd.Data.Abil.Level = PHRcdList[j].Abil.Level) and (HumRcd.Data.Abil.Exp > PHRcdList[j].Abil.Exp)) then
                  nIdx := j;
              end
              else if bsSkinCheckRadioBox4.Checked then
              begin  //金币
                if HumRcd.Data.nGold > PHRcdList[j].nGold then
                  nIdx := j;
              end
              else if bsSkinCheckRadioBox5.checked then
              begin  //元宝
                if HumRcd.Data.nGameGold > PHRcdList[j].nGameGold then
                  nIdx := j;
              end
              else if bsSkinCheckRadioBox6.checked then
              begin  //游戏点
                if HumRcd.Data.nGamePoint > PHRcdList[j].nGamePoint then
                  nIdx := j;
              end
              else if bsSkinCheckRadioBox7.checked then
              begin  //声望
                if HumRcd.Data.btCreditPoint > PHRcdList[j].btCreditPoint then
                  nIdx := j;
              end;
            end;
            if nIdx >= 0 then
              PHRcdList[nIdx] := HumRcd.Data;
          end;
          gauge1.Progress := i + 1;
        end;
      end;
      for i := 0 to nCurHPRcds - 1 do
      begin
        with Listview4.Items.Add do
        begin
          SubItems.add(PHRcdList[i].sChrName);
          SubItems.add(PHRcdList[i].sAccount);
          SubItems.add(JobToStr(PHRcdList[i].btJob));
          SubItems.add(SexToStr(PHRcdList[i].btSex));
          SubItems.add(IntToStr(PHRcdList[i].Abil.Level));
          SubItems.add(IntToStr(PHRcdList[i].Abil.Exp));
          SubItems.add(IntToStr(PHRcdList[i].nGold));
          SubItems.add(IntToStr(PHRcdList[i].nGameGold));
          SubItems.add(IntToStr(PHRcdList[i].nGamePoint));
          SubItems.add(IntToStr(PHRcdList[i].btCreditPoint));
        end;
      end;
    end;
  finally
    ListView4.Items.EndUpdate;
    HumDataDB.Free;
    stStatus.Caption := '就绪';
  end;
  for i := 0 to Listview4.Items.Count - 1 do
  begin
    Listview4.Items[i].Caption := Inttostr(i + 1);
  end;
end;

procedure TForm1.ListView4Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if bsSkinCheckRadioBox3.Checked then
    Compare := StrToInt(Item2.SubItems[4]) - StrToInt(Item1.SubItems[4])
  else if bsSkinCheckRadioBox4.Checked then
    Compare := StrToInt(Item2.SubItems[6]) - StrToInt(Item1.SubItems[6])
  else if bsSkinCheckRadioBox5.Checked then
    Compare := StrToInt(Item2.SubItems[7]) - StrToInt(Item1.SubItems[7])
  else if bsSkinCheckRadioBox6.Checked then
    Compare := StrToInt(Item2.SubItems[8]) - StrToInt(Item1.SubItems[8])
  else if bsSkinCheckRadioBox7.Checked then
    Compare := StrToInt(Item2.SubItems[9]) - StrToInt(Item1.SubItems[9])
end;

procedure TForm1.bsSkinPopupMenu1Popup(Sender: TObject);
begin
  bsSkinPopupMenu1.Items[0].Enabled := Listview2.Items.Count > 0;
  bsSkinPopupMenu1.Items[1].Enabled := Listview2.Selected <> nil;
  bsSkinPopupMenu1.Items[2].Enabled := Listview2.Selected <> nil;
  bsSkinPopupMenu1.Items[3].Enabled := Listview2.Selected <> nil;

  bsSkinPopupMenu1.Items[5].Enabled := Listview2.Selected <> nil;
  bsSkinPopupMenu1.Items[6].Enabled := Listview2.Selected <> nil;
  bsSkinPopupMenu1.Items[7].Enabled := Listview2.Selected <> nil;
end;

//清理复制物品  Development 2019-01-23
procedure ClearCopiedItem(s: string; var HumRcd: THumDataInfo);
var
  nWhere: byte;
  nOrdID: Integer;
begin
  if s[1] = '-' then
  begin //装备
    nWhere := 0;
  end
  else
    nWhere := 1;             //包裹
  nOrdID := StrToInt(s);
  if nWhere = 0 then
    nOrdID := -nOrdID;
  if nOrdID >= 100 then
  begin   //仓库
    nWhere := 2;
    nOrdID := nOrdID - 100;
  end;
  case nWhere of
    0:
      begin   //装备
        if nOrdID < 9 then
          HumRcd.Data.HumItems[nOrdID].wIndex := 0
      end;
    1:
      begin //包裹
        HumRcd.Data.BagItems[nOrdID].wIndex := 0;
      end;
    2:
      begin //仓库
        HumRcd.Data.StorageItems[nOrdID].wIndex := 0;
      end;
  end;
end;
//清除列出的所有复制品

procedure TForm1.N1Click(Sender: TObject);
var
  i: integer;
  HumRcd: THumDataInfo;
  s: string;
  nIdx: integer;
begin
  edtDBSPath.Text := CheckPath(edtDBSPath.Text);
  HumDataDB := TFileDB.Create(edtDBSPath.Text + MIRDBNAME);
  Listview2.Items.BeginUpdate;
  stStatus.Caption := '正在清除查到的复制品...';
  try
    if HumDataDB.Open then
    begin
      gauge1.Progress := 0;
      gauge1.MaxValue := ListView2.Items.Count;
      for i := ListView2.Items.Count - 1 downto 0 do
      begin
        nIdx := HumDataDB.m_MirQuickList.GetIndex(Listview2.Items[i].SubItems[0]);
        if (nIdx >= 0) and (HumDataDB.Get(nIdx, HumRcd) >= 0) then
        begin
          s := ListView2.Items[i].SubItems[4];
          ClearCopiedItem(s, HumRcd);
          if HumDataDB.Update(nIdx, HumRcd) then
            Listview2.Items.Delete(i);
        end;
      end;
      gauge1.Progress := i + 1;
    end;
  finally
    ListView2.Items.EndUpdate;
    HumDataDB.Free;
    stStatus.Caption := '就绪';
  end;
end;
//清除本条复制品

procedure TForm1.N2Click(Sender: TObject);
var
  HumRcd: THumDataInfo;
  s: string;
  nIdx: integer;
begin
  edtDBSPath.Text := CheckPath(edtDBSPath.Text);
  if Listview2.Selected = nil then
    exit;
  HumDataDB := TFileDB.Create(edtDBSPath.Text + MIRDBNAME);
  Listview2.Items.BeginUpdate;
  try
    if HumDataDB.Open then
    begin
      nIdx := HumDataDB.m_MirQuickList.GetIndex(Listview2.Selected.SubItems[0]);
      if (nIdx >= 0) and (HumDataDB.Get(nIdx, HumRcd) >= 0) then
      begin
        s := ListView2.Selected.SubItems[4];
        ClearCopiedItem(s, HumRcd);
        if HumDataDB.Update(nIdx, HumRcd) then
          Listview2.DeleteSelected;
      end;
    end;
  finally
    ListView2.Items.EndUpdate;
    HumDataDB.Free;
  end;
end;
//清除本物品所有复制品

procedure TForm1.N3Click(Sender: TObject);
var
  i: integer;
  HumRcd: THumDataInfo;
  s: string;
  nIdx: integer;
  sWIDX: string;
  expired: boolean;
begin
  if Listview2.Selected = nil then
    exit;

  sWIDX := Listview2.Selected.SubItems[2];
  edtDBSPath.Text := CheckPath(edtDBSPath.Text);
  HumDataDB := TFileDB.Create(edtDBSPath.Text + MIRDBNAME);
  Listview2.Items.BeginUpdate;
  stStatus.Caption := '正在清除查到的复制品...';
  try
    if HumDataDB.Open then
    begin
      gauge1.Progress := 0;
      gauge1.MaxValue := ListView2.Items.Count;
      for i := ListView2.Items.Count - 1 downto 0 do
      begin
        if Listview2.Items[i].SubItems[2] = sWIDX then
        begin
          nIdx := HumDataDB.m_MirQuickList.GetIndex(Listview2.Items[i].SubItems[0]);
          if expired or (nIdx >= 0) and (HumDataDB.Get(nIdx, HumRcd) >= 0) then
          begin
            s := ListView2.Items[i].SubItems[4];
            ClearCopiedItem(s, HumRcd);
            if HumDataDB.Update(nIdx, HumRcd) then
              Listview2.Items.Delete(i);
          end;
        end;
      end;
      gauge1.Progress := i + 1;
    end;
  finally
    ListView2.Items.EndUpdate;
    HumDataDB.Free;
    stStatus.Caption := '就绪';
  end;
end;

procedure TForm1.N4Click(Sender: TObject);
var
  i: integer;
  HumRcd: THumDataInfo;
  s: string;
  nIdx: integer;
  sWIDX: string;
begin
  if Listview2.Selected = nil then
    exit;
  sWIDX := Listview2.Selected.SubItems[3];
  edtDBSPath.Text := CheckPath(edtDBSPath.Text);
  HumDataDB := TFileDB.Create(edtDBSPath.Text + MIRDBNAME);
  Listview2.Items.BeginUpdate;
  stStatus.Caption := '正在清除查到的复制品...';
  try
    if HumDataDB.Open then
    begin
      gauge1.Progress := 0;
      gauge1.MaxValue := ListView2.Items.Count;
      for i := ListView2.Items.Count - 1 downto 0 do
      begin
        if Listview2.Items[i].SubItems[3] = sWIDX then
        begin
          nIdx := HumDataDB.m_MirQuickList.GetIndex(Listview2.Items[i].SubItems[0]);
          if (nIdx >= 0) and (HumDataDB.Get(nIdx, HumRcd) >= 0) then
          begin
            s := ListView2.Items[i].SubItems[4];
            ClearCopiedItem(s, HumRcd);
            if HumDataDB.Update(nIdx, HumRcd) then
              Listview2.Items.Delete(i);
          end;
        end;
      end;
      gauge1.Progress := i + 1;
    end;
  finally
    ListView2.Items.EndUpdate;
    HumDataDB.Free;
    stStatus.Caption := '就绪';
  end;

end;

procedure TForm1.N6Click(Sender: TObject);
begin
  if Listview2.Selected = nil then
    exit;
  Clipboard.SetTextBuf(PChar(Listview2.Selected.Caption));
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  if Listview2.Selected = nil then
    exit;
  Clipboard.SetTextBuf(PChar(Listview2.Selected.SubItems[0]));
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  if Listview2.Selected = nil then
    exit;
  Clipboard.SetTextBuf(PChar(Listview2.Selected.SubItems[3]));
end;


procedure TForm1.RefIDItem(Item: TListItem; DBRecord: TAccountDBRecord);
begin
  with Item do
  begin
    SubItems.Add(DBRecord.UserEntry.sAccount);
    SubItems.Add(DBRecord.UserEntry.sPassword);
    SubItems.Add(DBRecord.UserEntry.sUserName);
    SubItems.Add(DBRecord.UserEntry.sSSNo);
    SubItems.Add(DBRecord.UserEntryAdd.sBirthDay);
    SubItems.Add(DBRecord.UserEntry.sQuiz);
    SubItems.Add(DBRecord.UserEntry.sAnswer);
    SubItems.Add(DBRecord.UserEntryAdd.sQuiz2);
    SubItems.Add(DBRecord.UserEntryAdd.sAnswer2);
    SubItems.Add(DBRecord.UserEntry.sPhone);
    SubItems.Add(DBRecord.UserEntryAdd.sMobilePhone);
    SubItems.Add(DBRecord.UserEntryAdd.sMemo);
    SubItems.Add(DBRecord.UserEntryAdd.sMemo2);
    try
      SubItems.Add(DateTimeToStr(DBRecord.Header.CreateDate));
    except
      SubItems.Add('');
    end;
    try
      SubItems.Add(DateTimeToStr(DBRecord.Header.UpdateDate));
    except
      SubItems.Add('');
    end;
    SubItems.Add(DBRecord.UserEntry.sEMail);
  end;
end;

procedure TForm1.ShowIDDBPage(PageID: Integer);
var
  i: Integer;
  DBRecord: TAccountDBRecord;
  startIdx, EndIdx: integer;
  nPageCount: integer;
  Item: TListItem;
begin
  bsSkinEdit2.Text := CheckPath(bsSkinEdit2.text);
  AccountDB := TFileIDDB.Create(bsSkinEdit2.Text + 'IDDB\ID.DB');
  ListView5.Items.BeginUpdate;
  try
    ListView5.Items.Clear;
    if AccountDB.Open then
    begin
      startIdx := PageID * 100;
      if startIdx >= AccountDB.m_QuickList.Count then
        startIdx := 0;
      EndIdx := startIdx + 100;
      if EndIdx > AccountDB.m_QuickList.Count then
        EndIdx := AccountDB.m_QuickList.Count;
      IDPage := startIdx div 100;
      nPageCount := AccountDB.m_QuickList.Count div 100;
      if AccountDB.m_QuickList.Count mod 100 > 0 then
        Inc(nPageCount);
      Label29.Caption := format('共 %d 页/第 %d 页，每页100条', [nPageCount, startIdx div 100 + 1]);
      for i := startIdx to EndIdx - 1 do
      begin
        Item := ListView5.Items.Add;
        Item.Caption := IntToStr(i + 1);
        if AccountDB.Get(i, DBRecord) >= 0 then
          RefIDItem(Item, DBRecord);
      end;
      AccountDB.Close;
    end;
  finally
    AccountDB.Free;
    ListView5.Items.EndUpdate;
  end;
end;

procedure TForm1.bsSkinSpeedButton17Click(Sender: TObject);
begin
  Dec(IDPage);
  if IDPage < 0 then
    IDPage := 0;
  ShowIDDBPage(IDPage);
end;

procedure TForm1.bsSkinSpeedButton18Click(Sender: TObject);
begin
  Inc(IDPage);
  ShowIDDBPage(IDPage);
end;

procedure TForm1.bsSkinSpeedButton14Click(Sender: TObject);
var
  sAccount: string;
  AccountList: TStringList;
  i, nIndex: Integer;
  DBRecord: TAccountDBRecord;
begin
  sAccount := Trim(EdFindId.Text);
  if sAccount = '' then
    exit;
  bsSkinEdit2.Text := CheckPath(bsSkinEdit2.text);
  AccountDB := TFileIDDB.Create(bsSkinEdit2.Text + 'IDDB\ID.DB');
  ListView5.Items.BeginUpdate;
  AccountList := TStringList.Create;
  try
    ListView5.Items.Clear;
    if AccountDB.Open then
    begin
      if AccountDB.FindByName(sAccount, AccountList) > 0 then
      begin
        for i := 0 to AccountList.Count - 1 do
        begin
          nIndex := Integer(AccountList.Objects[i]);
          if AccountDB.GetBy(nIndex, DBRecord) then
          begin
            RefIDItem(Listview5.Items.Add, DBRecord);
          end;
        end;
      end;
    end;
  finally
    AccountDB.Free;
    AccountList.Free;
    ListView5.Items.EndUpdate;
    Label29.Caption := '找到 ' + inttostr(Listview5.items.count) + ' 条数据';
  end;

end;

procedure TForm1.bsSkinSpeedButton19Click(Sender: TObject);
var
  s: string;
  i: integer;
begin
  s := InputDialog.InputBox('跳转到...', '请输入要快速到达的页码', '0');
  i := Str_ToInt(s, -1);
  if i <= 0 then
    exit;
  ShowIDDBPage(i - 1);
end;

procedure TForm1.bsSkinSpeedButton15Click(Sender: TObject);
var
  nIndex: Integer;
  sAccount: string;
  DBRecord: TAccountDBRecord;
  bo11: boolean;
begin
  if Listview5.Selected = nil then
    exit;
  sAccount := Listview5.Selected.SubItems[0];
  if sAccount = '' then
    exit;
  bo11 := False;
  bsSkinEdit2.Text := CheckPath(bsSkinEdit2.text);
  AccountDB := TFileIDDB.Create(bsSkinEdit2.Text + 'IDDB\ID.DB');
  try
    try
      if AccountDB.OpenEx then
      begin
        nIndex := AccountDB.Index(sAccount);
        if nIndex >= 0 then
          if AccountDB.Get(nIndex, DBRecord) >= 0 then
            bo11 := True;
      end;
    finally
      AccountDB.Close;
    end;
    if FrmUserInfoEdit.sub_466AEC(DBRecord) then
    begin
      try
        if AccountDB.Open then
        begin
          nIndex := AccountDB.Index(sAccount);
          if nIndex >= 0 then
            if AccountDB.Update(nIndex, DBRecord) then
            begin
              Listview5.Selected.Caption := Inttostr(nIndex + 1);
              Listview5.Selected.SubItems.Clear;
              RefIDItem(Listview5.Selected, DBRecord);
            end;
        end;
      finally
        AccountDB.Close;
      end;
    end;
  finally
    AccountDB.Free;
  end;
end;

procedure TForm1.ListView5DblClick(Sender: TObject);
begin
  if ListView5.Selected <> nil then
    bsSkinSpeedButton15Click(Sender);
end;
{var
  MakeIdxList:Array[1..70000000]  of integer;
  MakeIdxCount:Array[1..70000000]  of byte;
  MakeIdxListCount:Integer; }

procedure TForm1.bsSkinSpeedButton10Click(Sender: TObject);
var
  I: Integer;
begin
  //SetLength(MakeIdxList,280000000);
  //SetLength(MakeIdxCount,280000000);
  {for i:=low(MakeIdxList) to high(MakeIdxList) do begin
    MakeIdxList[i]:=0;
    MakeIdxCount[i]:=0;
  end;
  MakeIdxListCount:=0; }
end;

procedure TForm1.bsSkinSpeedButton13Click(Sender: TObject);
begin
  //导出复制品数据到文件
end;

procedure TForm1.bsSkinFileEdit2ButtonClick(Sender: TObject);
begin
  if SaveDialog.InitialDir = '' then
    SaveDialog.InitialDir := edtMainDir.Text;
  SaveDialog.FileName := TbsSkinFileEdit(Sender).Text;
  SaveDialog.Filter := '传奇数据库(*.DB)|*.DB|所有文件(*.*)|*.*';
  if SaveDialog.Execute then
    TbsSkinFileEdit(Sender).Text := SaveDialog.FileName;
end;

procedure TForm1.bsSkinSpeedButton20Click(Sender: TObject);
var
  i: integer;
  R: TSearchRec;
begin
  edtLogBaseDir.Text := CheckPath(edtLogBaseDir.text);
  lbLogDirList.Items.Clear;
  i := FindFirst(edtLogBaseDir.Text + '*.*', faDirectory, R);
  while i = 0 do
  begin
    if (R.Name <> '.') and (R.Name <> '..') then
    begin
      lbLogDirList.Items.Add(R.Name);
    end;
    i := FindNext(R);
  end;
  FindClose(R);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.Title := Caption;
end;

procedure TForm1.bitbtn2Click(Sender: TObject);
begin
  ShellExecute(0, nil, pchar(bsSkinEdit4.Text + 'ID重名记录.txt'), nil, nil, SW_SHOWNORMAL);
  ShellExecute(0, nil, pchar(bsSkinEdit4.Text + '人物重名记录.txt'), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.bsSkinCheckRadioBox9Click(Sender: TObject);
begin
  bsSkinNumericEdit3.Enabled := bsSkinCheckRadioBox9.Checked;
  bsSkinNumericEdit4.Enabled := bsSkinCheckRadioBox9.Checked;
  bsSkinNumericEdit5.Enabled := bsSkinCheckRadioBox9.Checked;
  bsSkinNumericEdit6.Enabled := bsSkinCheckRadioBox9.Checked;
  bsSkinNumericEdit7.Enabled := bsSkinCheckRadioBox9.Checked;
  bsSkinNumericEdit8.Enabled := bsSkinCheckRadioBox9.Checked;
end;

end.

