unit HGEImageList;

interface

uses
  Windows, SysUtils, Graphics, StrUtils, Classes, HGECanvas, HGETextures, DirectXD3D9;

const
 ImageMax = 100;

type
  TImager = record
     Surface: TDXTexture;
     LoadTime: LongWord;
  end;
  pTImager = ^TImager;

  THGEImageList = class
   private
    Images: array[0..ImageMax] of TImager;
    function GetItem(Index: Integer): TDXTexture;
   protected
    dwMemChecktTick: LongWord;
   public
    constructor Create;
    destructor Destroy(); override;
    procedure RemoveAll();
    procedure FreeImgeMemorys();
    procedure LoadFromFile(XIndex: Integer; FileName: string;mode:Integer=0);overload;
    procedure LoadFromFile(XIndex: Integer; Bmap: TBitmap; mode:Integer=0);overload;
    property Items[Index: Integer]: TDXTexture read GetItem;
  end;

implementation

constructor THGEImageList.Create;
begin
  inherited;
  dwMemChecktTick := GetTickCount;
end;

destructor THGEImageList.Destroy;
begin
  RemoveAll();
  inherited;
end;

procedure THGEImageList.RemoveAll();
var
   i: integer;
begin
  for i:=0 to ImageMax do begin
    if Images[i].Surface <> nil then
    Images[i].Surface := nil;
  end;
end;

procedure THGEImageList.FreeImgeMemorys();
var
 I: Integer;
begin
    if GetTickCount - dwMemChecktTick > 30000 then begin
       dwMemChecktTick := GetTickCount;
      for I:= 0 to 89 do begin //Images
        if Images[i].Surface <> nil then begin  
          if GetTickCount - Images[I].LoadTime > 300000 then begin
             Images[i].Surface := nil;
             exit;
          end;
        end;
      end;
    end;
end;

function THGEImageList.GetItem(Index: Integer): TDXTexture;
begin
  if (Index >= 0)and(Index <= ImageMax) then begin
    Result:= Images[Index].Surface;
    if Result <> nil then  Images[Index].LoadTime := GetTickCount;
  end  else Result:= nil;
end;

procedure THGEImageList.LoadFromFile(XIndex: Integer; FileName: string; Mode:Integer);
var
  SW, SH:Integer;
begin
  if (XIndex < 0) or (XIndex > ImageMax) then  exit;
   Images[XIndex].Surface := TDXImageTexture.Create;
   if Mode > 0 then
    Images[XIndex].Surface.Format := D3DFMT_A8R8G8B8;

  if Images[XIndex].Surface <> nil then begin
    Images[XIndex].Surface.Active := True;
    Images[XIndex].Surface.LoadFromFile(FileName,SW,SH,mode);
    if (SW > 0) and (SH > 0) then begin
     Images[XIndex].Surface.Size := Point(SW,SH);
     Images[XIndex].Surface.PatternSize := Point(SW,SH);
     Images[XIndex].LoadTime := GetTickCount;
    end;
  end;

end;

procedure THGEImageList.LoadFromFile(XIndex: Integer; Bmap: TBitmap; mode:Integer);
var
  SW, SH:Integer;
begin
  if (XIndex < 0) or (XIndex > ImageMax) then  exit;
   Images[XIndex].Surface := TDXImageTexture.Create;
   if Mode > 0 then
    Images[XIndex].Surface.Format := D3DFMT_A8R8G8B8;

  if Images[XIndex].Surface <> nil then begin
    Images[XIndex].Surface.Active := True;
    Images[XIndex].Surface.LoadFromFile(Bmap,SW,SH);
    if (SW > 0) and (SH > 0) then begin
     Images[XIndex].Surface.Size := Point(SW,SH);
     Images[XIndex].Surface.PatternSize := Point(SW,SH);
     Images[XIndex].LoadTime := GetTickCount;
    end;
  end;

end;


end.
