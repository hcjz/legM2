unit ItmUnit;

interface
uses
  Windows,Classes,SysUtils,DBTables,Grobal2;

const
  MIRDBNAME = 'FDB\Mir.DB';
  HUMDBNAME = 'FDB\Hum.DB';

var
  Query: TQuery;
  StdItemList,MagicList:TList;

  function LoadItemsDB: Integer;
  function LoadMagicDB():Integer;
  function GetStdItemName(wIdx:Integer):String;
  function JobToStr(i:integer):String;
  function SexToStr(i:integer):String;
implementation
uses DBTMain;
function JobToStr(i:integer):String;
begin
  if i=0 then result:='战'
  else if i=1 then result:='法'
  else if i=2 then result:='道'
  else result:='';
end;
function SexToStr(i:integer):String;
begin
  if i=0 then result:='男'
  else if i=1 then result:='女'
  else result:='';
end;
function GetStdItemName(wIdx:Integer):String;
begin
  result:='';
  if (widx<=0) or (widx>StdItemList.Count) then exit;
  result:=pTStdItem(StdItemList[wIdx-1]).Name;
end;
//加载物品列表
function LoadItemsDB: Integer;
var
  i,Idx:Integer;
  StdItem:pTStdItem;
ResourceString
  sSQLString = 'select * from StdItems order by idx';
begin
  try
    StdItemList.Clear;
    Result := -1;
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      Result:= -2;
    end;
    for i:=0 to Query.RecordCount -1 do begin
      New(StdItem);
      Idx            := Query.FieldByName('Idx').AsInteger;
      StdItem.Name      := Query.FieldByName('Name').AsString;
      StdItem.StdMode   := Query.FieldByName('StdMode').AsInteger;
      StdItem.Shape     := Query.FieldByName('Shape').AsInteger;
      StdItem.Weight    := Query.FieldByName('Weight').AsInteger;
      StdItem.AniCount  := Query.FieldByName('AniCount').AsInteger;
      StdItem.Source    := Query.FieldByName('Source').AsInteger;
      StdItem.Reserved  := Query.FieldByName('Reserved').AsInteger;
      StdItem.Looks     := Query.FieldByName('Looks').AsInteger;
      StdItem.DuraMax   := Word(Query.FieldByName('DuraMax').AsInteger);
      StdItem.AC        := MakeLong(ROUND(Query.FieldByName('Ac').AsInteger ),ROUND(Query.FieldByName('Ac2').AsInteger));
      StdItem.MAC       := MakeLong(ROUND(Query.FieldByName('Mac').AsInteger ),ROUND(Query.FieldByName('MAc2').AsInteger ));
      StdItem.DC        := MakeLong(ROUND(Query.FieldByName('Dc').AsInteger  ),ROUND(Query.FieldByName('Dc2').AsInteger ));
      StdItem.MC        := MakeLong(ROUND(Query.FieldByName('Mc').AsInteger ),ROUND(Query.FieldByName('Mc2').AsInteger));
      StdItem.SC        := MakeLong(ROUND(Query.FieldByName('Sc').AsInteger ),ROUND(Query.FieldByName('Sc2').AsInteger));
      StdItem.Need      := Query.FieldByName('Need').AsInteger;
      StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;
      StdItem.Price     := Query.FieldByName('Price').AsInteger;
      StdItem.NeedIdentify:=0;
      if StdItemList.Count = Idx then begin
        StdItemList.Add(StdItem);
        Result := 1;
      end else begin
        Form1.AddLog('初始化',format('加载物品(Idx:%d Name:%s)数据失败，Idx不连续！！！',[Idx,StdItem.Name]));
        Result := -100;
        exit;
      end;
      Query.Next;
    end;
  finally
    Query.Close;
  end;
end;

//加载技能数据库
function LoadMagicDB():Integer;
var
  i:Integer;
  Magic:pTMagic;
ResourceString
  sSQLString = 'select * from Magic';
begin
  Result:= -1;
    MagicList.Clear;
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      Result:= -2;
    end;
    for i:=0 to Query.RecordCount -1 do begin
      New(Magic);
      Magic.wMagicId      := Query.FieldByName('MagId').AsInteger;
      Magic.sMagicName    := Query.FieldByName('MagName').AsString;
      Magic.btEffectType  := Query.FieldByName('EffectType').AsInteger;
      Magic.btEffect      := Query.FieldByName('Effect').AsInteger;
      Magic.wSpell        := Query.FieldByName('Spell').AsInteger;
      Magic.wPower        := Query.FieldByName('Power').AsInteger;
      Magic.wMaxPower     := Query.FieldByName('MaxPower').AsInteger;
      Magic.btJob         := Query.FieldByName('Job').AsInteger;
      Magic.TrainLevel[0] := Query.FieldByName('NeedL1').AsInteger;
      Magic.TrainLevel[1] := Query.FieldByName('NeedL2').AsInteger;
      Magic.TrainLevel[2] := Query.FieldByName('NeedL3').AsInteger;
      Magic.TrainLevel[3] := Query.FieldByName('NeedL3').AsInteger;
      Magic.MaxTrain[0]   := Query.FieldByName('L1Train').AsInteger;
      Magic.MaxTrain[1]   := Query.FieldByName('L2Train').AsInteger;
      Magic.MaxTrain[2]   := Query.FieldByName('L3Train').AsInteger;
      Magic.MaxTrain[3]   := Magic.MaxTrain[2];
      Magic.btTrainLv     := 3;
      Magic.dwDelayTime   := Query.FieldByName('Delay').AsInteger;
      Magic.btDefSpell    := Query.FieldByName('DefSpell').AsInteger;
      Magic.btDefPower    := Query.FieldByName('DefPower').AsInteger;
      Magic.btDefMaxPower := Query.FieldByName('DefMaxPower').AsInteger;
      Magic.sDescr        := Query.FieldByName('Descr').AsString;
      if Magic.wMagicId > 0 then begin
        MagicList.Add(Magic);
      end else begin
        Dispose(Magic);
      end;
      Result := 1;
      Query.Next;
    end;
    Query.Close;
end;
initialization
  Query:=TQuery.Create(nil);
  StdItemList:=TList.Create;
  MagicList:=TList.Create;
finalization
  Query.Free;
  StdItemList.Free;
  MagicList.Free;
end.
