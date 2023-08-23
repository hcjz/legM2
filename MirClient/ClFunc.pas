unit ClFunc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CnHashTable,
  HGE,HGECanvas,HGETextures, Grobal2, ExtCtrls, HUtil32, EDcode, HashList;



var
  DropItems         : TList;

function fmstr(Str: string; Len: Integer): string;
function GetGoldStr(gold: Integer): string;
procedure Savebagsdat(flname: string; pbuf: PByte);
procedure Loadbagsdat(flname: string; pbuf: PByte);
procedure ClearBag;
procedure HeroClearBag;
function AddItemBag(cu: TClientItem; idx: Integer = -1): Boolean;
function HeroAddItemBag(cu: TClientItem): Boolean;
function UpdateItemBag(cu: TClientItem): Boolean;
function HeroUpdateItemBag(cu: TClientItem): Boolean;
function DelItemBag(iname: string; iindex: Integer): Boolean;
function HeroDelItemBag(iname: string; iindex: Integer): Boolean;
procedure ArrangeItembag;
procedure ArrangeHeroItembag;
procedure AddDropItem(ci: TClientItem);
function GetDropItem(iname: string; MakeIndex: Integer): PTClientItem;
procedure DelDropItem(iname: string; MakeIndex: Integer);
procedure AddDealItem(ci: TClientItem);
procedure AddYbDealItem(ci: TClientItem);
function AddStallItem(ci: TClientItem): Boolean;
function DelStallItem(ci: TClientItem): Boolean;
function CanAddStallItem(): Boolean;
function StallItemCount(): Integer;
procedure DelDealItem(ci: TClientItem);
procedure MoveDealItemToBag;
procedure AddDealRemoteItem(ci: TClientItem);
procedure DelDealRemoteItem(ci: TClientItem);
function GetDistance(sX, sY, dx, dy: Integer): Integer;
procedure GetNextPosXY(dir: Byte; var X, Y: Integer);
procedure GetNextRunXY(dir: Byte; var X, Y: Integer);
procedure GetNextHorseRunXY(dir: Byte; var X, Y: Integer);
function GetNextDirection(sX, sY, dx, dy: Integer): Byte;
function GetBack(dir: Integer): Integer;
procedure GetBackPosition(sX, sY, dir: Integer; var NewX, NewY: Integer);
procedure GetBackPosition2(sX, sY, dir: Integer; var NewX, NewY: Integer);
procedure GetFrontPosition(sX, sY, dir: Integer; var NewX, NewY: Integer);
function GetFlyDirection(sX, sY, ttx, tty: Integer): Integer;
function GetFlyDirection16(sX, sY, ttx, tty: Integer): Integer;
function PrivDir(ndir: Integer): Integer;
function NextDir(ndir: Integer): Integer;


function GetTakeOnPosition(smode: TClientStdItem; UseItems: array of TClientItem; bPos: Boolean = False): Integer;

function IsKeyPressed(Key: Byte): Boolean;
procedure AddChangeFace(recogid: Integer);
procedure DelChangeFace(recogid: Integer);
function IsChangingFace(recogid: Integer): Boolean;
procedure GetNextHitPosition(sX, sY: Integer; var NewX, NewY: Integer);
function ChangeItemCount(mindex: Integer; Count, MsgNum: word; iname: string): Boolean;
function HEroChangeItemCount(mindex: Integer; Count, MsgNum: word; iname: string): Boolean;
function SellItemProg(remain, sellcnt: word): Boolean;
function DelCountItemBag(iname: string; iindex: Integer; Count: word): Boolean;
procedure ResultDealItem(ci: TClientItem; mindex: Integer; Count: word);


function UpdateBagStallItem(cu: TClientItem; ststus: Byte): Boolean;
function FillBagStallItem(ststus: Byte): Boolean;


implementation

uses
  ClMain, MShare, FState, StallSystem, cliUtil;

procedure GetNextHitPosition(sX, sY: Integer; var NewX, NewY: Integer);
var
  dx, dy, dir       : Integer;
begin

  dir := GetNextDirection(sX, sY, NewX, NewY);
  NewX := sX;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY - 2;
    DR_DOWN: NewY := NewY + 2;
    DR_LEFT: NewX := NewX + 2;
    DR_RIGHT: NewX := NewX - 2;
    DR_UPLEFT: begin
        NewX := NewX - 2;
        NewY := NewY - 2;
      end;
    DR_UPRIGHT: begin
        NewX := NewX + 2;
        NewY := NewY + 2;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX - 2;
        NewY := NewY + 2;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX + 2;
        NewY := NewY + 2;
      end;
  end;
end;


function fmstr(Str: string; Len: Integer): string;
var
  i                 : Integer;
begin
  try
    Result := Str + ' ';
    for i := 1 to Len - Length(Str) - 1 do
      Result := Result + ' ';
  except
    Result := Str + ' ';
  end;
end;

function GetGoldStr(gold: Integer): string;
var
  i, n              : Integer;
  Str               : string;
begin
  Str := IntToStr(gold);
  n := 0;
  Result := '';
  for i := Length(Str) downto 1 do begin
    if n = 3 then begin
      Result := Str[i] + ',' + Result;
      n := 1;
    end else begin
      Result := Str[i] + Result;
      Inc(n);
    end;
  end;
end;

procedure Savebagsdat(flname: string; pbuf: PByte);
var
  fhandle           : Integer;
begin
  if FileExists(flname) then
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone)
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then begin
    FileWrite(fhandle, pbuf^, SizeOf(TClientItem) * MAXBAGITEMCL);
    FileClose(fhandle);
  end;
end;

procedure Loadbagsdat(flname: string; pbuf: PByte);
var
  fhandle           : Integer;
begin
  if FileExists(flname) then begin
    fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileRead(fhandle, pbuf^, SizeOf(TClientItem) * MAXBAGITEMCL);
      FileClose(fhandle);
    end;
  end;
end;

procedure ClearBag;
var
  i                 : Integer;
begin
  for i := 0 to MAXBAGITEMCL - 1 do
    g_ItemArr[i].s.Name := '';
end;

procedure HeroClearBag;
var
  i                 : Integer;
begin
  for i := 0 to MAXBAGITEMCL - 1 do
    g_HeroItemArr[i].s.Name := '';
end;

function AddItemBag(cu: TClientItem; idx: Integer): Boolean;
var
  i                 : Integer;
  InputCheck        : Boolean;
begin
  Result := False;
  InputCheck := False;
  if cu.s.Name = '' then Exit;
  if FrmDlg.DWRefine.Visible then begin
    for i := Low(g_RefineItems) to High(g_RefineItems) do
      if (g_RefineItems[i].item.MakeIndex = cu.MakeIndex) and
        (g_RefineItems[i].item.s.Name = cu.s.Name) and
        (g_RefineItems[i].item.s.Overlap < 1) then
        Exit;
    if (g_RIWhere > 0) then begin
      if g_RefineItems[g_RIWhere - 1].item.s.Name <> '' then begin
        g_MovingItem := g_RefineItems[g_RIWhere - 1];
        g_boItemMoving := True;
      end;
      g_RefineItems[g_RIWhere - 1].item := cu;
      g_RIWhere := 0;
      Exit;
    end else begin
      for i := Low(g_RefineItems) to High(g_RefineItems) do
        if g_RefineItems[i].item.s.Name = '' then begin
          g_RefineItems[i].item := cu;
          Exit;
        end;
    end;
  end;
  if (idx >= 0) then begin
    if (g_ItemArr[idx].s.Name = '') then begin
      g_ItemArr[idx] := cu;
      Result := True;
      Exit;
    end;
  end;
  for i := 0 to MAXBAGITEMCL - 1 do begin
    if (g_ItemArr[i].MakeIndex = cu.MakeIndex) and (g_ItemArr[i].s.Name = cu.s.Name) and (g_ItemArr[i].s.Overlap < 1) then
      Exit;
  end;
  if cu.s.Name = '' then Exit;
  if cu.s.StdMode <= 3 then
    for i := 0 to 5 do
      if g_ItemArr[i].s.Name = '' then begin
        g_ItemArr[i] := cu;
        Result := True;
        Exit;
      end;

  for i := 6 to MAXBAGITEMCL - 1 do begin
    if (g_ItemArr[i].s.Overlap > 0) and (g_ItemArr[i].s.Name = cu.s.Name) and
      (g_ItemArr[i].MakeIndex = cu.MakeIndex) then begin
      g_ItemArr[i].Dura := g_ItemArr[i].Dura + cu.Dura;
      cu.Dura := 0;
      InputCheck := True;
    end;
  end;

  if not InputCheck then begin
    for i := 6 to MAXBAGITEMCL - 1 do
      if g_ItemArr[i].s.Name = '' then begin
        g_ItemArr[i] := cu;
        Result := True;
        Break;
      end;
  end;
  ArrangeItembag;
end;

function HeroAddItemBag(cu: TClientItem): Boolean;
var
  i                 : Integer;
  InputCheck        : Boolean;
begin
  Result := False;
  InputCheck := False;
  for i := 0 to MAXBAGITEMCL - 1 do begin
    if (g_HeroItemArr[i].MakeIndex = cu.MakeIndex) and (g_HeroItemArr[i].s.Name = cu.s.Name) and (g_HeroItemArr[i].s.Overlap < 1) then
      Exit;
  end;
  if cu.s.Name = '' then Exit;

  for i := 0 to MAXBAGITEMCL - 1 - 6 do begin
    if (g_HeroItemArr[i].s.Overlap > 0) and (g_HeroItemArr[i].s.Name = cu.s.Name) and
      (g_HeroItemArr[i].MakeIndex = cu.MakeIndex) then begin
      g_HeroItemArr[i].Dura := g_HeroItemArr[i].Dura + cu.Dura;
      cu.Dura := 0;
      InputCheck := True;
    end;
  end;

  if not InputCheck then begin
    for i := 0 to MAXBAGITEMCL - 1 - 6 do begin
      if g_HeroItemArr[i].s.Name = '' then begin
        g_HeroItemArr[i] := cu;
        Result := True;
        Break;
      end;
    end;
  end;
  ArrangeHeroItembag;
end;

function UpdateItemBag(cu: TClientItem): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  for i := MAXBAGITEMCL - 1 downto 0 do begin
    if (g_ItemArr[i].s.Name = cu.s.Name) and (g_ItemArr[i].MakeIndex = cu.MakeIndex) then begin
      g_ItemArr[i] := cu;
      Result := True;
      Break;
    end;
  end;
end;

function UpdateBagStallItem(cu: TClientItem; ststus: Byte): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  for i := MAXBAGITEMCL - 1 downto 6 do begin
    if (g_ItemArr[i].s.Name = cu.s.Name) and (g_ItemArr[i].MakeIndex = cu.MakeIndex) then begin
      g_ItemArr[i].s.NeedIdentify := ststus;
      Result := True;
      Break;
    end;
  end;
end;

function FillBagStallItem(ststus: Byte): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  for i := MAXBAGITEMCL - 1 downto 6 do begin
    if (g_ItemArr[i].s.Name <> '') and (g_ItemArr[i].s.NeedIdentify <> ststus) then begin
      g_ItemArr[i].s.NeedIdentify := ststus;
      Result := True;
    end;
  end;
end;

function HeroUpdateItemBag(cu: TClientItem): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  for i := MAXBAGITEMCL - 1 downto 0 do begin
    if g_HeroItemArr[i].s.Name = '' then Continue;
    if (g_HeroItemArr[i].s.Name = cu.s.Name) and (g_HeroItemArr[i].MakeIndex = cu.MakeIndex) then begin
      g_HeroItemArr[i] := cu;
      Result := True;
      Break;
    end;
  end;
end;

function DelItemBag(iname: string; iindex: Integer): Boolean;
var
  i                 : Integer;
begin
  {if (g_SellDlgItem.s.Name = iname) and (g_SellDlgItem.MakeIndex = iindex) then begin
    g_SellDlgItem.s.Name := '';
    Result := True;
  end;
  if (g_EatingItem.s.Name = iname) and (g_EatingItem.MakeIndex = iindex) then begin
    g_EatingItem.s.Name := '';
    Result := True;
  end;
  if g_boItemMoving and (g_MovingItem.item.s.Name = iname) and (g_MovingItem.item.MakeIndex = iindex) then begin
    g_MovingItem.item.s.Name := '';
    g_boItemMoving := False;
    Result := True;
  end;
  if (g_WaitingUseItem.item.s.Name = iname) and (g_WaitingUseItem.item.MakeIndex = iindex) then begin
    g_WaitingUseItem.item.s.Name := '';
    Result := True;
  end;}

  Result := False;
  for i := MAXBAGITEMCL - 1 downto 0 do begin
    if (g_ItemArr[i].s.Name = iname) and (g_ItemArr[i].MakeIndex = iindex) then begin
      FillChar(g_ItemArr[i], SizeOf(TClientItem), #0);
      Result := True;
      Break;
    end;
  end;

  if g_mySelf <> nil then
    for i := 10 - 1 downto 0 do begin
      if (g_mySelf.m_StallMgr.mBlock.Items[i].s.Name = iname) and (g_mySelf.m_StallMgr.mBlock.Items[i].MakeIndex = iindex) then begin
        FillChar(g_mySelf.m_StallMgr.mBlock.Items[i], SizeOf(TClientItem), #0);
        Result := True;
        Break;
      end;
    end;
  ArrangeItembag;
end;

function HeroDelItemBag(iname: string; iindex: Integer): Boolean;
var
  i                 : Integer;
begin
  Result := False;

  {if (g_SellDlgItem.s.Name = iname) and (g_SellDlgItem.MakeIndex = iindex) then begin
    g_SellDlgItem.s.Name := '';
    Result := True;
  end;
  if (g_EatingItem.s.Name = iname) and (g_EatingItem.MakeIndex = iindex) then begin
    g_EatingItem.s.Name := '';
    Result := True;
  end;
  if g_boItemMoving and (g_MovingItem.item.s.Name = iname) and (g_MovingItem.item.MakeIndex = iindex) then begin
    g_MovingItem.item.s.Name := '';
    g_boItemMoving := False;
    Result := True;
  end;
  if (g_WaitingUseItem.item.s.Name = iname) and (g_WaitingUseItem.item.MakeIndex = iindex) then begin
    g_WaitingUseItem.item.s.Name := '';
    Result := True;
  end;}

  for i := MAXBAGITEMCL - 1 downto 0 do begin
    if (g_HeroItemArr[i].s.Name = iname) and (g_HeroItemArr[i].MakeIndex = iindex) then begin
      FillChar(g_HeroItemArr[i], SizeOf(TClientItem), #0);
      Result := True;
      Break;
    end;
  end;
  ArrangeHeroItembag;
end;

procedure ArrangeItembag;
var
  i, k              : Integer;
begin
  for i := 0 to MAXBAGITEMCL - 1 do begin
    if g_ItemArr[i].s.Name <> '' then begin
      for k := i + 1 to MAXBAGITEMCL - 1 do begin //清理复制
        if (g_ItemArr[i].s.Name = g_ItemArr[k].s.Name) and (g_ItemArr[i].MakeIndex = g_ItemArr[k].MakeIndex) then begin
          if g_ItemArr[i].s.Overlap > 0 then begin
            g_ItemArr[i].Dura := g_ItemArr[i].Dura + g_ItemArr[k].Dura;
            FillChar(g_ItemArr[k], SizeOf(TClientItem), #0);
          end else begin
            FillChar(g_ItemArr[k], SizeOf(TClientItem), #0);
          end;
        end;
      end;

      if (g_ItemArr[i].s.Name = g_MovingItem.item.s.Name) and (g_ItemArr[i].MakeIndex = g_MovingItem.item.MakeIndex) and (g_ItemArr[i].s.Overlap < 1) then begin
        g_MovingItem.Index := 0;
        g_MovingItem.item.s.Name := '';
        g_boItemMoving := False;
      end;
    end;
  end;
  for i := 46 to MAXBAGITEMCL - 1 do begin
    if g_ItemArr[i].s.Name <> '' then begin
      for k := 6 to 45 do begin
        if g_ItemArr[k].s.Name = '' then begin
          g_ItemArr[k] := g_ItemArr[i];
          g_ItemArr[i].s.Name := '';
          Break;
        end;
      end;
    end;
  end;
end;

procedure ArrangeHeroItembag;
var
  i, k              : Integer;
begin
  for i := 0 to MAXBAGITEMCL - 1 do begin
    if g_HeroItemArr[i].s.Name <> '' then begin
      for k := i + 1 to MAXBAGITEMCL - 1 do begin
        if (g_HeroItemArr[i].s.Name = g_HeroItemArr[k].s.Name) and (g_HeroItemArr[i].MakeIndex = g_HeroItemArr[k].MakeIndex) then begin
          if g_HeroItemArr[i].s.Overlap > 0 then begin
            g_HeroItemArr[i].Dura := g_HeroItemArr[i].Dura + g_HeroItemArr[k].Dura;
            FillChar(g_HeroItemArr[k], SizeOf(TClientItem), #0);
          end else begin
            FillChar(g_HeroItemArr[k], SizeOf(TClientItem), #0);
          end;
        end;
      end;
      if (g_HeroItemArr[i].s.Name = g_MovingItem.item.s.Name) and (g_HeroItemArr[i].MakeIndex = g_MovingItem.item.MakeIndex) and (g_HeroItemArr[i].s.Overlap < 1) then begin
        g_MovingItem.Index := 0;
        g_MovingItem.item.s.Name := '';
        g_boItemMoving := False;
      end;
    end;
  end;
end;

procedure AddDropItem(ci: TClientItem);
var
  pc                : PTClientItem;
begin
  New(pc);
  pc^ := ci;
  DropItems.Add(pc);
end;

function GetDropItem(iname: string; MakeIndex: Integer): PTClientItem;
var
  i                 : Integer;
begin
  Result := nil;
  for i := 0 to DropItems.Count - 1 do begin
    if (PTClientItem(DropItems[i]).s.Name = iname) and (PTClientItem(DropItems[i]).MakeIndex = MakeIndex) then begin
      Result := PTClientItem(DropItems[i]);
      Break;
    end;
  end;
end;

procedure DelDropItem(iname: string; MakeIndex: Integer);
var
  i                 : Integer;
begin
  for i := 0 to DropItems.Count - 1 do begin
    if (PTClientItem(DropItems[i]).s.Name = iname) and (PTClientItem(DropItems[i]).MakeIndex = MakeIndex) then begin
      Dispose(PTClientItem(DropItems[i]));
      DropItems.Delete(i);
      Break;
    end;
  end;
end;

{----------------------------------------------------------}

procedure AddDealItem(ci: TClientItem);
var
  i                 : Integer;
begin
  for i := 0 to 10 - 1 do begin
    if (g_DealItems[i].s.Name = ci.s.Name) and (g_DealItems[i].s.Overlap > 0) then begin
      g_DealItems[i].Dura := g_DealItems[i].Dura + ci.Dura;
      Break;
    end else if g_DealItems[i].s.Name = '' then begin
      g_DealItems[i] := ci;
      Break;
    end;
  end;
end;

procedure AddYbDealItem(ci: TClientItem);
var
  i                 : Integer;
begin
  for i := 0 to 10 - 2 do begin
    if g_YbDealItems[i].s.Name = '' then begin
      g_YbDealItems[i] := ci;
      Break;
    end;
  end;
end;

function CanAddStallItem(): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  for i := 0 to 10 - 1 do begin
    if g_mySelf.m_StallMgr.mBlock.Items[i].s.Name = '' then begin
      Result := True;
      Break;
    end;
  end;
end;

function StallItemCount(): Integer;
var
  i                 : Integer;
begin
  Result := 0;
  for i := 0 to 10 - 1 do begin
    if g_mySelf.m_StallMgr.mBlock.Items[i].s.Name <> '' then begin
      Inc(Result);
      //Break;
    end;
  end;
end;

function AddStallItem(ci: TClientItem): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  for i := 0 to 10 - 1 do begin
    if g_mySelf.m_StallMgr.mBlock.Items[i].s.Name <> '' then begin
      if g_mySelf.m_StallMgr.mBlock.Items[i].MakeIndex = ci.MakeIndex then begin
        g_mySelf.m_StallMgr.mBlock.Items[i] := ci;
        Result := True;
        Exit;
      end;
    end;
  end;

  for i := 0 to 10 - 1 do begin
    if g_mySelf.m_StallMgr.mBlock.Items[i].s.Name = '' then begin
      g_mySelf.m_StallMgr.mBlock.Items[i] := ci;
      Result := True;
      Break;
    end;
  end;
end;

function DelStallItem(ci: TClientItem): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  for i := 0 to 10 - 1 do begin
    if (g_mySelf.m_StallMgr.mBlock.Items[i].s.Name = ci.s.Name) and (ci.MakeIndex = g_mySelf.m_StallMgr.mBlock.Items[i].MakeIndex) then begin
      g_mySelf.m_StallMgr.mBlock.Items[i].s.Name := '';
      Result := True;
      //Break;
    end;
  end;
end;

procedure DelDealItem(ci: TClientItem);
var
  i                 : Integer;
begin
  for i := 0 to 10 - 1 do begin
    if (g_DealItems[i].s.Name = ci.s.Name) and (g_DealItems[i].MakeIndex = ci.MakeIndex) then begin
      FillChar(g_DealItems[i], SizeOf(TClientItem), #0);
      Break;
    end;
  end;
end;

procedure MoveDealItemToBag;
var
  i                 : Integer;
begin
  for i := 0 to 10 - 1 do begin
    if g_DealItems[i].s.Name <> '' then
      if g_DealItems[i].s.Overlap <= 0 then
        AddItemBag(g_DealItems[i]);
  end;
  FillChar(g_DealItems, SizeOf(TClientItem) * 10, #0);
end;

procedure AddDealRemoteItem(ci: TClientItem);
var
  i                 : Integer;
begin
  for i := 0 to 20 - 1 do begin
    if (g_DealRemoteItems[i].s.Name = ci.s.Name) and (ci.s.Overlap > 0) then begin
      g_DealRemoteItems[i].MakeIndex := ci.MakeIndex;
    end else if g_DealRemoteItems[i].s.Name = '' then begin
      g_DealRemoteItems[i] := ci;
      Break;
    end;
  end;
end;

procedure DelDealRemoteItem(ci: TClientItem);
var
  i                 : Integer;
begin
  for i := 0 to 20 - 1 do begin
    if (g_DealRemoteItems[i].s.Name = ci.s.Name) and (g_DealRemoteItems[i].MakeIndex = ci.MakeIndex) then begin
      FillChar(g_DealRemoteItems[i], SizeOf(TClientItem), #0);
      Break;
    end;
  end;
end;

{----------------------------------------------------------}

function GetDistance(sX, sY, dx, dy: Integer): Integer;
begin
  Result := _MAX(abs(sX - dx), abs(sY - dy));
end;

procedure GetNextPosXY(dir: Byte; var X, Y: Integer);
begin
  case dir of
    DR_UP: begin
        X := X;
        Y := Y - 1;
      end;
    DR_UPRIGHT: begin
        X := X + 1;
        Y := Y - 1;
      end;
    DR_RIGHT: begin
        X := X + 1;
        Y := Y;
      end;
    DR_DOWNRIGHT: begin
        X := X + 1;
        Y := Y + 1;
      end;
    DR_DOWN: begin
        X := X;
        Y := Y + 1;
      end;
    DR_DOWNLEFT: begin
        X := X - 1;
        Y := Y + 1;
      end;
    DR_LEFT: begin
        X := X - 1;
        Y := Y;
      end;
    DR_UPLEFT: begin
        X := X - 1;
        Y := Y - 1;
      end;
  end;
end;

procedure GetNextRunXY(dir: Byte; var X, Y: Integer);
begin
  case dir of
    DR_UP: begin
        X := X;
        Y := Y - 2;
      end;
    DR_UPRIGHT: begin
        X := X + 2;
        Y := Y - 2;
      end;
    DR_RIGHT: begin
        X := X + 2;
        Y := Y;
      end;
    DR_DOWNRIGHT: begin
        X := X + 2;
        Y := Y + 2;
      end;
    DR_DOWN: begin
        X := X;
        Y := Y + 2;
      end;
    DR_DOWNLEFT: begin
        X := X - 2;
        Y := Y + 2;
      end;
    DR_LEFT: begin
        X := X - 2;
        Y := Y;
      end;
    DR_UPLEFT: begin
        X := X - 2;
        Y := Y - 2;
      end;
  end;
end;

procedure GetNextHorseRunXY(dir: Byte; var X, Y: Integer);
begin
  case dir of
    DR_UP: begin
        X := X;
        Y := Y - 3;
      end;
    DR_UPRIGHT: begin
        X := X + 3;
        Y := Y - 3;
      end;
    DR_RIGHT: begin
        X := X + 3;
        Y := Y;
      end;
    DR_DOWNRIGHT: begin
        X := X + 3;
        Y := Y + 3;
      end;
    DR_DOWN: begin
        X := X;
        Y := Y + 3;
      end;
    DR_DOWNLEFT: begin
        X := X - 3;
        Y := Y + 3;
      end;
    DR_LEFT: begin
        X := X - 3;
        Y := Y;
      end;
    DR_UPLEFT: begin
        X := X - 3;
        Y := Y - 3;
      end;
  end;
end;

function GetNextDirection(sX, sY, dx, dy: Integer): Byte;
var
  flagx, flagy      : Integer;
begin
  Result := DR_DOWN;
  if sX < dx then flagx := 1
  else if sX = dx then flagx := 0
  else flagx := -1;
  if abs(sY - dy) > 2 then if (sX >= dx - 1) and (sX <= dx + 1) then flagx := 0;

  if sY < dy then flagy := 1
  else if sY = dy then flagy := 0
  else flagy := -1;
  if abs(sX - dx) > 2 then if (sY > dy - 1) and (sY <= dy + 1) then flagy := 0;

  if (flagx = 0) and (flagy = -1) then Result := DR_UP;
  if (flagx = 1) and (flagy = -1) then Result := DR_UPRIGHT;
  if (flagx = 1) and (flagy = 0) then Result := DR_RIGHT;
  if (flagx = 1) and (flagy = 1) then Result := DR_DOWNRIGHT;
  if (flagx = 0) and (flagy = 1) then Result := DR_DOWN;
  if (flagx = -1) and (flagy = 1) then Result := DR_DOWNLEFT;
  if (flagx = -1) and (flagy = 0) then Result := DR_LEFT;
  if (flagx = -1) and (flagy = -1) then Result := DR_UPLEFT;
end;

function GetBack(dir: Integer): Integer;
begin
  Result := DR_UP;
  case dir of
    DR_UP: Result := DR_DOWN;
    DR_DOWN: Result := DR_UP;
    DR_LEFT: Result := DR_RIGHT;
    DR_RIGHT: Result := DR_LEFT;
    DR_UPLEFT: Result := DR_DOWNRIGHT;
    DR_UPRIGHT: Result := DR_DOWNLEFT;
    DR_DOWNLEFT: Result := DR_UPRIGHT;
    DR_DOWNRIGHT: Result := DR_UPLEFT;
  end;
end;

procedure GetBackPosition(sX, sY, dir: Integer; var NewX, NewY: Integer);
begin
  NewX := sX;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY + 1;
    DR_DOWN: NewY := NewY - 1;
    DR_LEFT: NewX := NewX + 1;
    DR_RIGHT: NewX := NewX - 1;
    DR_UPLEFT: begin
        NewX := NewX + 1;
        NewY := NewY + 1;
      end;
    DR_UPRIGHT: begin
        NewX := NewX - 1;
        NewY := NewY + 1;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX + 1;
        NewY := NewY - 1;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX - 1;
        NewY := NewY - 1;
      end;
  end;
end;

procedure GetBackPosition2(sX, sY, dir: Integer; var NewX, NewY: Integer);
begin
  NewX := sX;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY + 2;
    DR_DOWN: NewY := NewY - 2;
    DR_LEFT: NewX := NewX + 2;
    DR_RIGHT: NewX := NewX - 2;
    DR_UPLEFT: begin
        NewX := NewX + 2;
        NewY := NewY + 2;
      end;
    DR_UPRIGHT: begin
        NewX := NewX - 2;
        NewY := NewY + 2;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX + 2;
        NewY := NewY - 2;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX - 2;
        NewY := NewY - 2;
      end;
  end;
end;

procedure GetFrontPosition(sX, sY, dir: Integer; var NewX, NewY: Integer);
begin
  NewX := sX;
  NewY := sY;
  case dir of
    DR_UP: NewY := NewY - 1;
    DR_DOWN: NewY := NewY + 1;
    DR_LEFT: NewX := NewX - 1;
    DR_RIGHT: NewX := NewX + 1;
    DR_UPLEFT: begin
        NewX := NewX - 1;
        NewY := NewY - 1;
      end;
    DR_UPRIGHT: begin
        NewX := NewX + 1;
        NewY := NewY - 1;
      end;
    DR_DOWNLEFT: begin
        NewX := NewX - 1;
        NewY := NewY + 1;
      end;
    DR_DOWNRIGHT: begin
        NewX := NewX + 1;
        NewY := NewY + 1;
      end;
  end;
end;

function GetFlyDirection(sX, sY, ttx, tty: Integer): Integer;
var
  fx, fy            : Real;
begin
  fx := ttx - sX;
  fy := tty - sY;
  sX := 0;
  sY := 0;
  Result := DR_DOWN;
  if fx = 0 then begin
    if fy < 0 then Result := DR_UP
    else Result := DR_DOWN;
    Exit;
  end;
  if fy = 0 then begin
    if fx < 0 then Result := DR_LEFT
    else Result := DR_RIGHT;
    Exit;
  end;
  if (fx > 0) and (fy < 0) then begin
    if - fy > fx * 2.5 then Result := DR_UP
    else if - fy < fx / 3 then Result := DR_RIGHT
    else Result := DR_UPRIGHT;
  end;
  if (fx > 0) and (fy > 0) then begin
    if fy < fx / 3 then Result := DR_RIGHT
    else if fy > fx * 2.5 then Result := DR_DOWN
    else Result := DR_DOWNRIGHT;
  end;
  if (fx < 0) and (fy > 0) then begin
    if fy < -fx / 3 then Result := DR_LEFT
    else if fy > -fx * 2.5 then Result := DR_DOWN
    else Result := DR_DOWNLEFT;
  end;
  if (fx < 0) and (fy < 0) then begin
    if - fy > -fx * 2.5 then Result := DR_UP
    else if - fy < -fx / 3 then Result := DR_LEFT
    else Result := DR_UPLEFT;
  end;
end;

function GetFlyDirection16(sX, sY, ttx, tty: Integer): Integer;
var
  fx, fy            : Real;
begin
  fx := ttx - sX;
  fy := tty - sY;
  sX := 0;
  sY := 0;
  Result := 0;
  if fx = 0 then begin
    if fy < 0 then Result := 0
    else Result := 8;
    Exit;
  end;
  if fy = 0 then begin
    if fx < 0 then Result := 12
    else Result := 4;
    Exit;
  end;
  if (fx > 0) and (fy < 0) then begin
    Result := 4;
    if - fy > fx / 4 then Result := 3;
    if - fy > fx / 1.9 then Result := 2;
    if - fy > fx * 1.4 then Result := 1;
    if - fy > fx * 4 then Result := 0;
  end;
  if (fx > 0) and (fy > 0) then begin
    Result := 4;
    if fy > fx / 4 then Result := 5;
    if fy > fx / 1.9 then Result := 6;
    if fy > fx * 1.4 then Result := 7;
    if fy > fx * 4 then Result := 8;
  end;
  if (fx < 0) and (fy > 0) then begin
    Result := 12;
    if fy > -fx / 4 then Result := 11;
    if fy > -fx / 1.9 then Result := 10;
    if fy > -fx * 1.4 then Result := 9;
    if fy > -fx * 4 then Result := 8;
  end;
  if (fx < 0) and (fy < 0) then begin
    Result := 12;
    if - fy > -fx / 4 then Result := 13;
    if - fy > -fx / 1.9 then Result := 14;
    if - fy > -fx * 1.4 then Result := 15;
    if - fy > -fx * 4 then Result := 0;
  end;
end;

function PrivDir(ndir: Integer): Integer;
begin
  if ndir - 1 < 0 then Result := 7
  else Result := ndir - 1;
end;

function NextDir(ndir: Integer): Integer;
begin
  if ndir + 1 > 7 then Result := 0
  else Result := ndir + 1;
end;

function GetTakeOnPosition(smode: TClientStdItem; UseItems: array of TClientItem; bPos: Boolean = False): Integer;
begin
  Result := -1;
  case smode.StdMode of
    5, 6: Result := U_WEAPON;
    7: Result := U_CHARM;
    10, 11: Result := U_DRESS;
    15: Result := U_HELMET;
    16: Result := U_HELMETEX;
{$IFNDEF UI_0508}
    12, 13: Result := U_FASHION;
    17: Result := U_DRUM;
    18: Result := U_HORSE;
{$ENDIF}
    19, 20, 21: Result := U_NECKLACE;
    22, 23: begin
        Result := U_RINGL;
        if bPos then begin
          if g_boTakeOnPos then
            Result := U_RINGL
          else
            Result := U_RINGR;
          g_boTakeOnPos := not g_boTakeOnPos;
          //if UseItems[Result].S.Name = '' then Result := U_RINGR;
        end;
      end;
    24, 26: begin
        Result := U_ARMRINGR;
        if bPos then begin
          if g_boTakeOnPos then
            Result := U_ARMRINGR
          else
            Result := U_ARMRINGL;
          g_boTakeOnPos := not g_boTakeOnPos;
          //if UseItems[U_ARMRINGR].S.Name <> '' then Result := U_ARMRINGL;
        end;
      end;
    30: Result := U_RIGHTHAND;
    2..4, 25: Result := U_BUJUK;
    41..50: if not (smode.shape in [9..45]) then Result := U_BUJUK;
    27: Result := U_BELT; //腰带
    28: Result := U_BOOTS; //靴子
    29: Result := U_CHARM; //宝石
  end;
end;

function IsKeyPressed(Key: Byte): Boolean;
var
  keyvalue          : TKeyBoardState;
begin
  Result := False;
  FillChar(keyvalue, SizeOf(TKeyBoardState), #0);
  if GetKeyboardState(keyvalue) then
    if (keyvalue[Key] and $80) <> 0 then
      Result := True;
end;

procedure AddChangeFace(recogid: Integer);
begin
  g_ChangeFaceReadyList.Add(Pointer(recogid));
end;

procedure DelChangeFace(recogid: Integer);
var
  i                 : Integer;
begin
  i := g_ChangeFaceReadyList.IndexOf(Pointer(recogid));
  if i > -1 then g_ChangeFaceReadyList.Delete(i);
end;

function IsChangingFace(recogid: Integer): Boolean;
begin
  Result := g_ChangeFaceReadyList.IndexOf(Pointer(recogid)) > -1;
end;

function ChangeItemCount(mindex: Integer; Count, MsgNum: word; iname: string): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  //if g_MovingItem.item.s.StdMode = 7 then FrmDlg.CancelItemMoving;

  for i := Low(g_TIItems) to High(g_TIItems) do begin
    if (g_TIItems[i].item.s.Name = iname) and (g_TIItems[i].item.s.Overlap > 0) and (g_TIItems[i].item.MakeIndex = mindex) then begin
      g_TIItems[i].item.Dura := Count;
      Result := True;
    end;
  end;
  for i := Low(g_spItems) to High(g_spItems) do begin
    if (g_spItems[i].item.s.Name = iname) and (g_spItems[i].item.s.Overlap > 0) and (g_spItems[i].item.MakeIndex = mindex) then begin
      g_spItems[i].item.Dura := Count;
      Result := True;
    end;
  end;

  if (g_SellDlgItem.s.Name = iname) and (g_SellDlgItem.s.Overlap > 0) and (g_SellDlgItem.MakeIndex = mindex) then begin
    g_SellDlgItem.Dura := Count;
    Result := True;
  end;
  if (g_EatingItem.s.Name = iname) and (g_EatingItem.s.Overlap > 0) and (g_EatingItem.MakeIndex = mindex) then begin
    g_EatingItem.Dura := Count;
    Result := True;
  end;
  if (g_MovingItem.item.s.Name = iname) and (g_MovingItem.item.s.Overlap > 0) and (g_MovingItem.item.MakeIndex = mindex) then begin
    g_MovingItem.item.Dura := Count;
    Result := True;
  end;
  if (g_WaitingUseItem.item.s.Name = iname) and (g_WaitingUseItem.item.s.Overlap > 0) and (g_WaitingUseItem.item.MakeIndex = mindex) then begin
    g_WaitingUseItem.item.Dura := Count;
    Result := True;
  end;
  g_WaitingUseItem.item.s.Name := '';

  for i := 0 to MAXBAGITEMCL - 1 do begin
    if (g_ItemArr[i].MakeIndex = mindex) and (g_ItemArr[i].s.Name = iname) and
      (g_ItemArr[i].s.Overlap > 0) then begin
      if Count < 1 then begin
        g_ItemArr[i].s.Name := '';
        Count := 0;
      end;
      g_ItemArr[i].Dura := Count;
      Result := True;
      Break;
    end;
  end;
  ArrangeItembag;

  if (Result = False) and (not g_BoDealEnd) then begin
    for i := 0 to 10 - 1 do begin
      if (g_DealItems[i].s.Name = iname) and (g_DealItems[i].s.Overlap > 0) and (g_DealItems[i].MakeIndex = mindex) then begin
        if Count < 1 then begin
          g_DealItems[i].s.Name := '';
          Count := 0;
        end;
        g_DealItems[i].Dura := Count;
        Result := True;
        Break;
      end;
    end;
  end;

  if (Result = False) and (not g_BoDealEnd) then begin
    for i := 0 to 19 do begin
      if (g_DealRemoteItems[i].s.Name = iname) and (g_DealRemoteItems[i].s.Overlap > 0) and (g_DealRemoteItems[i].MakeIndex = mindex) then begin
        if Count < 1 then begin
          g_DealRemoteItems[i].s.Name := '';
          Count := 0;
        end;
        g_DealRemoteItems[i].Dura := Count;
        Result := True;
        Break;
      end;
    end;
  end;

  if MsgNum = 1 then DScreen.AddSysMsg(iname + ' 被发现');

end;

function HEroChangeItemCount(mindex: Integer; Count, MsgNum: word; iname: string): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  //if g_MovingItem.item.s.StdMode = 7 then FrmDlg.CancelItemMoving;
  for i := Low(g_TIItems) to High(g_TIItems) do begin
    if (g_TIItems[i].item.s.Name = iname) and (g_TIItems[i].item.s.Overlap > 0) and (g_TIItems[i].item.MakeIndex = mindex) then begin
      g_TIItems[i].item.Dura := Count;
      Result := True;
    end;
  end;
  for i := Low(g_spItems) to High(g_spItems) do begin
    if (g_spItems[i].item.s.Name = iname) and (g_spItems[i].item.s.Overlap > 0) and (g_spItems[i].item.MakeIndex = mindex) then begin
      g_spItems[i].item.Dura := Count;
      Result := True;
    end;
  end;
  if (g_SellDlgItem.s.Name = iname) and (g_SellDlgItem.s.Overlap > 0) and (g_SellDlgItem.MakeIndex = mindex) then begin
    g_SellDlgItem.Dura := Count;
    Result := True;
  end;
  if (g_EatingItem.s.Name = iname) and (g_EatingItem.s.Overlap > 0) and (g_EatingItem.MakeIndex = mindex) then begin
    g_EatingItem.Dura := Count;
    Result := True;
  end;
  if (g_MovingItem.item.s.Name = iname) and (g_MovingItem.item.s.Overlap > 0) and (g_MovingItem.item.MakeIndex = mindex) then begin
    g_MovingItem.item.Dura := Count;
    Result := True;
  end;
  if (g_WaitingUseItem.item.s.Name = iname) and (g_WaitingUseItem.item.s.Overlap > 0) and (g_WaitingUseItem.item.MakeIndex = mindex) then begin
    g_WaitingUseItem.item.Dura := Count;
    Result := True;
  end;
  g_WaitingUseItem.item.s.Name := '';

  for i := 0 to MAXBAGITEMCL - 1 do begin
    if (g_HeroItemArr[i].MakeIndex = mindex) and (g_HeroItemArr[i].s.Name = iname) and (g_HeroItemArr[i].s.Overlap > 0) then begin
      if Count < 1 then begin
        g_HeroItemArr[i].s.Name := '';
        Count := 0;
      end;
      g_HeroItemArr[i].Dura := Count;
      Result := True;
      Break;
    end;
  end;
  ArrangeHeroItembag;

  if MsgNum = 1 then DScreen.AddSysMsg(iname + ' 在英雄包裹内被发现');

end;

function SellItemProg(remain, sellcnt: word): Boolean;
var
  i                 : Integer;
begin

  Result := False;
  for i := 0 to MAXBAGITEMCL - 1 do begin
    if (g_ItemArr[i].MakeIndex = g_SellDlgItemSellWait.item.MakeIndex) and
      (g_ItemArr[i].s.Name = g_SellDlgItemSellWait.item.s.Name) and
      (g_ItemArr[i].s.Overlap > 0) then begin
      if remain < 1 then begin
        g_ItemArr[i].s.Name := '';
        remain := 0;
      end;
      g_ItemArr[i].Dura := remain;
      Result := True;
    end;
  end;

end;

function DelCountItemBag(iname: string; iindex: Integer; Count: word): Boolean;
var
  i                 : Integer;
begin
  Result := False;
  for i := MAXBAGITEMCL - 1 downto 0 do begin
    if g_ItemArr[i].s.Name = iname then begin
      if g_ItemArr[i].s.Overlap > 0 then begin
        g_ItemArr[i].Dura := g_ItemArr[i].Dura - Count;
        if g_ItemArr[i].Dura <= 0 then begin
          g_ItemArr[i].s.Name := '';
          g_ItemArr[i].Dura := 0;
        end;
      end
      else if g_ItemArr[i].MakeIndex = iindex then begin
        FillChar(g_ItemArr[i], SizeOf(TClientItem), #0);
        Result := True;
        Break;
      end;
    end;
  end;
  ArrangeItembag;
end;

procedure ResultDealItem(ci: TClientItem; mindex: Integer; Count: word);
var
  i                 : Integer;
begin
  for i := 0 to 10 - 1 do begin

    if (g_DealItems[i].s.Name = ci.s.Name) and (g_DealItems[i].s.Overlap > 0) then begin
      if (g_DealItems[i].s.Name = ci.s.Name) and (g_DealItems[i].MakeIndex = mindex) then
        g_DealItems[i].Dura := g_DealItems[i].Dura + ci.Dura;
      g_DealItems[i].MakeIndex := mindex;
      Break;
    end
    else if g_DealItems[i].s.Name = '' then begin
      g_DealItems[i] := ci;
      g_DealItems[i].MakeIndex := mindex;
      Break;
    end;
  end;

  for i := 0 to MAXBAGITEMCL - 1 do begin
    if (g_ItemArr[i].s.Name = ci.s.Name) and (g_ItemArr[i].s.Overlap > 0) and
      (g_ItemArr[i].MakeIndex = ci.MakeIndex) then begin
      if Count < 1 then begin
        g_ItemArr[i].s.Name := '';
        Count := 0;
      end;
      g_ItemArr[i].Dura := Count;
    end;
  end;

end;

initialization
  DropItems := TList.Create;

finalization
  DropItems.Free;

end.

