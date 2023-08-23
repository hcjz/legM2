unit FDBexpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Grobal2, ComCtrls,
  Spin;
type
  TFrmFDBExplore = class(TForm)
    ListBox1: TListBox;
    EdFind: TEdit;
    Label1: TLabel;
    BtnAdd: TButton;
    BtnDel: TButton;
    ListBox2: TListBox;
    BtnRebuild: TButton;
    BtnBlankCount: TButton;
    GroupBox1: TGroupBox;
    BtnAutoClean: TButton;
    Timer1: TTimer;
    BtnCopyRcd: TButton;
    BtnCopyNew: TButton;
    CkLv1: TCheckBox;
    CkLv7: TCheckBox;
    CkLv14: TCheckBox;
    ButtonFind: TButton;
    GroupBox2: TGroupBox;
    CheckBoxNoEnoughLevel: TCheckBox;
    CheckBoxDeleted: TCheckBox;
    SpinEditWeek: TSpinEdit;
    SpinEditLevel: TSpinEdit;
    ButtonRepair: TButton;
    ButtonClear: TButton;
    LbProcess: TLabel;
    TimerShowInfo: TTimer;
    SpinEditInterval: TSpinEdit;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    ProgressBar: TProgressBar;
    LabelProcessPercent: TLabel;

    procedure ListBox1Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnRebuildClick(Sender: TObject);
    procedure BtnBlankCountClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAutoCleanClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnCopyRcdClick(Sender: TObject);
    procedure BtnCopyNewClick(Sender: TObject);
    procedure EdFindKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonFindClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure TimerShowInfoTimer(Sender: TObject);
    procedure SpinEditIntervalChange(Sender: TObject);
    procedure ButtonRepairClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);

  private
    //    nClearIndex:Integer; //0x324
    //    nClearCount:Integer;//0x328
    SList_320: TStringList;
    function ClearHumanItem(var ChrRecord: THumDataInfo): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

  TClaenDB = class(TThread)
  private
    //procedure UpdateProcess();
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  FrmFDBExplore             : TFrmFDBExplore;

  {This file is generated by DeDe Ver 3.50.02 Copyright (c) 1999-2002 DaFixer}

implementation

uses {$IFDEF SQLDB} HumDB_SQL{$ELSE}HumDB{$ENDIF}, newchr, UsrSoc, frmcpyrcd, DBSMain, DBShare, DBTools, HUtil32;

var
  boCleaning                : Boolean = False;
  ClaenDB                   : TClaenDB;
  nProcID                   : Integer;
  nProcMax                  : Integer;
  UpdateProcessTick         : LongWord;

{$R *.DFM}

procedure TFrmFDBExplore.EdFindKeyPress(Sender: TObject; var Key: Char);
//var
//  i: Integer;
//  sChrName: string;
begin
  if Key <> #13 then Exit;
  ButtonFindClick(Sender);
end;

procedure TFrmFDBExplore.ListBox1Click(Sender: TObject);
//0x004A5790
begin
  ListBox2.ItemIndex := ListBox1.ItemIndex;
end;

procedure TFrmFDBExplore.BtnDelClick(Sender: TObject);
var
  nIndex                    : Integer;
begin
  if ListBox1.ItemIndex <= -1 then
    Exit;
  nIndex := Integer(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  if MessageDlg('是否确认删除人物数据 ' + IntToStr(nIndex) + ' ？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumDataDB.Open then
        HumDataDB.Delete(nIndex);
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmFDBExplore.BtnRebuildClick(Sender: TObject); //0x004A5B64
begin
  if Application.MessageBox('在重建数据库过程中，数据库服务器将停止工作，是否确认继续？', '提示信息', MB_IconInformation + MB_YesNo) = IDYes then begin
    boAutoClearDB := False;
    HumDataDB.Rebuild();
    MessageDlg('数据库重建完成！', mtInformation, [mbOK], 0);
  end;
end;

procedure TFrmFDBExplore.BtnBlankCountClick(Sender: TObject);
begin
  ListBox1.Clear;
  ListBox2.Clear;
end;

procedure TFrmFDBExplore.BtnAddClick(Sender: TObject);
var
  sChrName                  : string;
begin
  FrmNewChr.sub_49BD60(sChrName);
  FrmUserSoc.NewChrData(sChrName, 0, 0, 0);
end;

procedure TFrmFDBExplore.FormCreate(Sender: TObject);
//0x004A55B8
begin
  Timer1.Interval := dwInterval;
  SpinEditInterval.Value := dwInterval div 1000;
  SpinEdit1.Value := nLevel1;
  Timer1.Enabled := True;
  SList_320 := TStringList.Create;
  g_nClearIndex := 0;
  g_nClearCount := 0;
  g_nClearItemIndexCount := 0;
end;

procedure TFrmFDBExplore.BtnAutoCleanClick(Sender: TObject);
//0x004A5D40
begin
  boAutoClearDB := not boAutoClearDB;
  if boAutoClearDB then
    BtnAutoClean.Caption := '自动清理中'
  else
    BtnAutoClean.Caption := '已停止清理';
end;

procedure TFrmFDBExplore.Timer1Timer(Sender: TObject);

  function GetDateTime(wM, wD: Word): TDateTime;
  var
    Year, Month, Day        : Word;
    i                       : Integer;
  begin
    DecodeDate(Now, Year, Month, Day);
    for i := 0 to wM - 1 do begin
      if Month > 1 then
        Dec(Month)
      else begin
        Month := 12;
        Dec(Year);
      end;
    end;
    for i := 0 to wD - 1 do begin
      if Day > 1 then
        Dec(Day)
      else begin
        Day := 28;
        if Month > 1 then
          Dec(Month)
        else begin
          Month := 12;
          Dec(Year);
        end;
      end;
    end;
    Result := EncodeDate(Year, Month, Day);
  end;
var
  w32, wDayCount1, wLevel1, w38, wDayCount7, wLevel7, w3E, wDayCount14, wLevel14: Word;
  dt20, dt28, dt30          : TDateTime;
  n8, n10                   : Integer;
  sHumName                  : string;
  ChrRecord                 : THumDataInfo;
begin
  if not boAutoClearDB then Exit;
  w32 := 0;
  w38 := 0;
  w3E := 0;
  wDayCount1 := 0;
  wDayCount7 := 0;
  wDayCount14 := 0;
  wLevel1 := 0;
  wLevel7 := 0;
  wLevel14 := 0;
  if CkLv1.Checked then begin
    w32 := nMonth1;
    wDayCount1 := 7;
    wLevel1 := nLevel1;
  end;
  if CkLv7.Checked then begin
    w38 := nMonth2;
    wDayCount7 := nDay2;
    wLevel7 := nLevel2;
  end;
  if CkLv14.Checked then begin
    w3E := nMonth3;
    wDayCount14 := nDay3;
    wLevel14 := nLevel3;
  end;
  dt20 := GetDateTime(w32, wDayCount1);
  dt28 := GetDateTime(w38, wDayCount7);
  dt30 := GetDateTime(w3E, wDayCount14);
  g_nClearRecordCount := 0;
  sHumName := '';
  try
    if HumDataDB.Open then begin
      g_nClearRecordCount := HumDataDB.Count;
      if g_nClearIndex < g_nClearRecordCount then begin
        {n8 := HumDataDB.Get(g_nClearIndex, ChrRecord);
        if n8 >= 0 then begin
          if ((ChrRecord.Header.dCreateDate < dt20) and (ChrRecord.Data.Abil.Level <= wLevel1)) or
            ((ChrRecord.Header.dCreateDate < dt28) and (ChrRecord.Data.Abil.Level <= wLevel7)) or
            ((ChrRecord.Header.dCreateDate < dt30) and (ChrRecord.Data.Abil.Level <= wLevel14)) then begin
            n10 := n8;
            sHumName := ChrRecord.Header.sName;
            HumDataDB.Delete(n10);
            Inc(g_nClearCount);
          end
          else begin
            if ClearHumanItem(ChrRecord) then begin
              HumDataDB.Update(g_nClearIndex, ChrRecord);
            end;
          end;
          Inc(g_nClearIndex);
        end;}
        Inc(g_nClearIndex); 
      end else
        g_nClearIndex := 0;
    end;
  finally
    HumDataDB.Close;
  end;
  if sHumName <> '' then begin
    FrmDBSrv.DelHum(sHumName);
  end;
  //  FrmDBSrv.LbAutoClean.Caption:=IntToStr(g_nClearIndex) + '/' + IntToStr(g_nClearCount) + '/' + IntToStr(g_nClearRecordCount);
end;

function TFrmFDBExplore.ClearHumanItem(var ChrRecord: THumDataInfo): Boolean;
var
  i                         : Integer;
  HumItems                  : pTHumanUseItems;
  UserItem                  : pTUserItem;
  Item                      : pTUserItem;
  SaveList                  : TStringList;
  ClearList                 : TList;
  sFileName                 : string;
  sMsg                      : string;
begin
  Result := False;
  ClearList := nil;

  HumItems := @ChrRecord.Data.HumItems;
  for i := Low(THumanUseItems) to High(THumanUseItems) do begin
    UserItem := @HumItems[i];
    if UserItem.wIndex <= 0 then
      Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then
        ClearList := TList.Create;
      New(Item);
      Item^ := UserItem^;
      ClearList.Add(Item);
      UserItem.wIndex := 0;
      Result := True;
    end;
  end;
  {for i := Low(THumAddItems) to High(THumAddItems) do begin
    UserItem := @ChrRecord.Data.HumAddItems[i];
    if UserItem.wIndex <= 0 then
      Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then
        ClearList := TList.Create;
      New(Item);
      Item^ := UserItem^;
      ClearList.Add(Item);

      UserItem.wIndex := 0;
      Result := True;
    end;
  end;}
  for i := Low(TBagItems) to High(TBagItems) do begin
    UserItem := @ChrRecord.Data.BagItems[i];
    if UserItem.wIndex <= 0 then
      Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then
        ClearList := TList.Create;
      New(Item);
      Item^ := UserItem^;
      ClearList.Add(Item);
      UserItem.wIndex := 0;
      Result := True;
    end;
  end;
  for i := Low(TStorageItems) to High(TStorageItems) do begin
    UserItem := @ChrRecord.Data.StorageItems[i];
    if UserItem.wIndex <= 0 then
      Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then
        ClearList := TList.Create;
      New(Item);
      Item^ := UserItem^;
      ClearList.Add(Item);

      UserItem.wIndex := 0;
      Result := True;
    end;
  end;
  if Result then begin
    Inc(g_nClearItemIndexCount, ClearList.Count);

    SaveList := TStringList.Create;
    sFileName := 'ClearItemLog.txt';
    if FileExists(sFileName) then begin
      SaveList.LoadFromFile(sFileName);
    end;
    for i := 0 to ClearList.Count - 1 do begin
      UserItem := ClearList.Items[i];
      sMsg := ChrRecord.Data.sChrName + #9 + IntToStr(UserItem.wIndex) + #9 +
        IntToStr(UserItem.MakeIndex);
      SaveList.Insert(0, sMsg);
      Dispose(UserItem);
    end;
    SaveList.SaveToFile(sFileName);
    SaveList.Free;
  end;
  if ClearList <> nil then
    ClearList.Free;
end;

procedure TFrmFDBExplore.BtnCopyRcdClick(Sender: TObject);
//0x004A6220
var
  sSrcChrName, sDestChrName, sUserId: string;
begin
  if not FrmCopyRcd.sub_49C09C then
    Exit;
  sSrcChrName := FrmCopyRcd.s2F0;
  sDestChrName := FrmCopyRcd.s2F4;
  sUserId := FrmCopyRcd.s2F8;
  if FrmDBSrv.CopyHumData(sSrcChrName, sDestChrName, sUserId) then
    ShowMessage(sSrcChrName + ' -> ' + sDestChrName + ' 复制成功。');
end;

procedure TFrmFDBExplore.BtnCopyNewClick(Sender: TObject);
var
  sSrcChrName, sDestChrName, sUserId: string;
begin
  if not FrmCopyRcd.sub_49C09C then
    Exit;
  sSrcChrName := FrmCopyRcd.s2F0;
  sDestChrName := FrmCopyRcd.s2F4;
  sUserId := FrmCopyRcd.s2F8;
  if FrmUserSoc.NewChrData(sDestChrName, 0, 0, 0) and
    FrmDBSrv.CopyHumData(sSrcChrName, sDestChrName, sUserId) then
    ShowMessage(sSrcChrName + ' -> ' + sDestChrName + ' 复制成功。');
end;

procedure TFrmFDBExplore.ButtonFindClick(Sender: TObject);
var
  i                         : Integer;
  sChrName                  : string;
begin
  sChrName := Trim(EdFind.Text);
  if sChrName = '' then Exit;
  ListBox1.Clear;
  ListBox2.Clear;
  try
    if HumDataDB.OpenEx then begin
      HumDataDB.Find(sChrName, ListBox1.Items);
      for i := 0 to ListBox1.Items.Count - 1 do begin
        ListBox2.Items.Add(IntToStr(Integer(ListBox1.Items.Objects[i])));
      end;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmFDBExplore.ButtonClearClick(Sender: TObject);
var
  sHumDBFile, sMirDBFile, sIDXDBFile: string;
begin
  //Timer2.Enabled := True;
  if Application.MessageBox('为确保过程无误，请你先备份DB数据库，你现在就想备份吗？', '提示信息', MB_IconInformation + MB_YesNo) = IDYes then begin
    //LbProcess.Caption := '正在备份数据，请稍侯...';
    CopyFile('.\FDB\Mir.DB', '.\FDB\Mir.DB.备份', False);
    CopyFile('.\FDB\Hum.DB', '.\FDB\Hum.DB.备份', False);
    CopyFile('.\FDB\Mir.DB.idx', '.\FDB\Mir.DB.idx.备份', False);
    LbProcess.Caption := '备份数据完成，请继续其他操作...';
  end;
  if Application.MessageBox('在清理低等级人物角色数据过程中，数据库服务器将停止工作，是否确认继续？', '提示信息', MB_IconInformation + MB_YesNo) = IDYes then begin
    boAutoClearDB := False;
    boCleaning := True;
    ButtonClear.Enabled := False;
    ClaenDB := TClaenDB.Create(False);
    ClaenDB.FreeOnTerminate := True;
    TimerShowInfo.Enabled := True;
  end;
end;

procedure TFrmFDBExplore.TimerShowInfoTimer(Sender: TObject);
begin
  LbProcess.Caption := Format('正处理:%d, 已清理:%d, 总数:%d', [nProcID {g_nClearIndex}, g_nClearCount, nProcMax {g_nClearRecordCount}]);
  LabelProcessPercent.Caption := IntToStr(nProcID * 100 div nProcMax) + '%';
  ProgressBar.Position := nProcID;
  if not boCleaning then begin
    TimerShowInfo.Enabled := False;
    Close;
    ShowMessage('清理低级角色完成，将开始重建DB数据库！');
    frmDBTool.Top := Self.Top + 20;
    frmDBTool.Left := Self.Left;
    frmDBTool.Open();
    frmDBTool.PageControl1.ActivePageIndex := 1;
    //frmDBTool.ButtonStartRebuildClick(Sender);
  end;
end;

procedure TFrmFDBExplore.FormDestroy(Sender: TObject);
begin
  SList_320.Free;
end;

procedure TFrmFDBExplore.SpinEditIntervalChange(Sender: TObject);
begin
  Timer1.Interval := SpinEditInterval.Value * 1000;
  SaveConfig();
end;

procedure TClaenDB.Execute;

  function GetDateTime(wM, wD: Word): TDateTime;
  var
    Year, Month, Day        : Word;
    i                       : Integer;
  begin
    DecodeDate(Now, Year, Month, Day);
    for i := 0 to wM - 1 do begin
      if Month > 1 then
        Dec(Month)
      else begin
        Month := 12;
        Dec(Year);
      end;
    end;
    for i := 0 to wD - 1 do begin
      if Day > 1 then
        Dec(Day)
      else begin
        Day := 28;
        if Month > 1 then
          Dec(Month)
        else begin
          Month := 12;
          Dec(Year);
        end;
      end;
    end;
    Result := EncodeDate(Year, Month, Day);
  end;
var
  wMonth, wDayCount, wLevel : Word;
  dt28                      : TDateTime;
  i, n8, n10                : Integer;
  sHumName                  : string;
  ChrRecord                 : THumDataInfo;
begin
  try
    if HumDataDB.Open then begin
      nProcID := 0;
      nProcMax := HumDataDB.Count - 1;
      FrmFDBExplore.ProgressBar.Max := nProcMax;
      for i := 0 to HumDataDB.Count - 1 do begin
        nProcID := i;
        if not FrmFDBExplore.CheckBoxNoEnoughLevel.Checked and not FrmFDBExplore.CheckBoxDeleted.Checked then Exit;
        wDayCount := 0;
        wLevel := 0;
        if FrmFDBExplore.CheckBoxNoEnoughLevel.Checked then begin
          wMonth := 0;
          wDayCount := FrmFDBExplore.SpinEditWeek.Value * 7;
          wLevel := FrmFDBExplore.SpinEditLevel.Value;
        end;
        dt28 := GetDateTime(0, wDayCount);
        g_nClearRecordCount := 0;
        sHumName := '';
        try
          if HumDataDB.Open then begin
            g_nClearRecordCount := HumDataDB.Count;
            if g_nClearIndex < g_nClearRecordCount then begin
              n8 := HumDataDB.Get(g_nClearIndex, ChrRecord);
              if n8 >= 0 then begin
                if FrmFDBExplore.CheckBoxDeleted.Checked and ((ChrRecord.Header.dCreateDate < dt28) and (ChrRecord.Data.Abil.Level <= wLevel)) or
                  FrmFDBExplore.CheckBoxDeleted.Checked and (ChrRecord.Header.boDeleted) then begin
                  n10 := n8;
                  sHumName := ChrRecord.Header.sName;
                  HumDataDB.Delete(n10);
                  Inc(g_nClearCount);
                end
                else begin
                  if FrmFDBExplore.ClearHumanItem(ChrRecord) then begin
                    HumDataDB.Update(g_nClearIndex, ChrRecord);
                  end;
                end;
                Inc(g_nClearIndex);
              end;
            end
            else
              g_nClearIndex := 0;
          end;
        finally
          HumDataDB.Close;
        end;
        if sHumName <> '' then begin
          FrmDBSrv.DelHum(sHumName);
        end;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
  boCleaning := False;
  boAutoClearDB := True;
  FrmFDBExplore.ButtonClear.Enabled := True;
end;

//procedure TClaenDB.UpdateProcess;
//begin
//  if (GetTickCount - UpdateProcessTick > 1000) or (nProcID >= nProcMax) then
//    UpdateProcessTick := GetTickCount();
//end;

procedure TFrmFDBExplore.ButtonRepairClick(Sender: TObject);
begin
  ClaenDB.DoTerminate;
end;

procedure TFrmFDBExplore.SpinEdit1Change(Sender: TObject);
begin
  nLevel1 := SpinEdit1.Value;
  SaveConfig();
end;

end.
