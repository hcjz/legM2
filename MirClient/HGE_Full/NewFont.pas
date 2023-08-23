unit NewFont;

interface

uses
  Windows, Classes, SysUtils, StrUtils, Forms, Graphics, GfxFont, HGECanvas, HGETextures,
  CnHashTable, HGEBase, HGE;

type
  TEiImageDraw = class
  public
    Font_Default: TGfxFont; //默认字体 宋体12号
    Font_Bold:TGfxFont;// 粗体字
    Font_Default_18: TGfxFont; //新增字体 宋体18号 服务器名称
    Font_Default_24: TGfxFont; //新增字体 宋体27号 游戏公告



    StartTime: LongWord;
    I:Integer;
    constructor Create();
    destructor Destroy(); override;
    procedure iniClass();
    function TextWidth(Str: WideString): Integer; //获取字体宽度
    function TextHeight(Str: WideString): Integer; //获取字体高度












    procedure TextOut(x, y: Integer; Str: WideString; FColor: Cardinal; underline: Boolean = False); overload;
    procedure TextOut(x, y: Integer; FColor: Cardinal; Str: WideString; underline: Boolean = False); overload;
    procedure TextOut(x, y: Integer; Str: WideString; FColor: Cardinal; BColor: Cardinal; underline{是否有下划线} : Boolean = False); overload; //前景字体颜色 + 背景条框颜色 + 下划线
    procedure TextOut(x, y: Integer; FColor: Cardinal; BColor: Cardinal; Str: WideString); overload;//字体颜色 + 自定义描边颜色

































    procedure DrawFont(Str: WideString; x, y: Integer; HaveBackGround{是否有背景}: Boolean;
                BackGroundColor{背景颜色}: LongWord; Haveshadow{是否有阴影/描边}: Boolean; Color: LongWord;
                show{是否有特效}: Boolean; underline{是否有下划线} :Boolean = False);

    (*   以下为新增字体而新建的函数   *)
    (*   字体类型: 宋体   Size: 18   *)
    (*   Date: 2018-02-04   *)
    function TextWidth_18(Str: WideString): Integer; //获取字体宽度
    function TextHeight_18(Str: WideString): Integer; //获取字体高度
    procedure TextOut_18(x, y: Integer; FColor: Cardinal; Str: WideString); //默认黑色描边
    procedure DrawFont_18(Str: WideString; x, y: Integer; HaveBackGround{是否有背景}: Boolean; BackGroundColor{背景颜色}: LongWord; Haveshadow{是否有阴影/描边}: Boolean; Color: LongWord; show{是否有特效}: Boolean; underline{是否有下划线} : Boolean = False);

    (*   以下为新增字体而新建的函数   *)
    (*   字体类型: 宋体   Size: 24   *)
    (*   Date: 2018-03-22   *)
    function TextWidth_24(Str: WideString): Integer; //获取字体宽度
    function TextHeight_24(Str: WideString): Integer; //获取字体高度
    procedure TextOut_24(x, y: Integer; FColor: Cardinal; BColor: Cardinal; Str: WideString); //字体颜色 + 自定义描边颜色
    procedure DrawFont_24(Str: WideString; x, y: Integer; HaveBackGround{是否有背景}: Boolean; BackGroundColor{背景颜色}: LongWord; Haveshadow{是否有阴影/描边}: Boolean; Color: LongWord; show{是否有特效}: Boolean; underline{是否有下划线} : Boolean = False);
    (*   以下为新增字体而新建的函数   *)
    (*   字体类型: 宋体   Size: 12 Dold  *)
    (*   Date: 2018-03-22   *)
    function TextWidth_Bold(Str: WideString): Integer; //获取字体宽度
    function TextHeight_Bold(Str: WideString): Integer; //获取字体高度
    procedure BoldTextOut(x, y: Integer; Str: WideString; FColor: Cardinal; underline: Boolean = False); overload;
    procedure BoldTextOut(x, y: Integer; FColor: Cardinal; Str: WideString; underline: Boolean = False); overload;
    procedure DrawFont_Bold(Str: WideString; x, y: Integer; HaveBackGround{是否有背景}: Boolean; BackGroundColor{背景颜色}: LongWord; Haveshadow{是否有阴影/描边}: Boolean; Color: LongWord; show{是否有特效}: Boolean; underline{是否有下划线} : Boolean = False);



  end;


implementation

var
  HCanvas : TDXCanvas;

constructor TEiImageDraw.Create();
begin
  inherited;
end;

destructor TEiImageDraw.Destroy();
begin
  Font_Default.Free;
  Font_Bold.Free;
  Font_Default_18.Free;
  Font_Default_24.Free;
  inherited;
end;

procedure TEiImageDraw.iniclass();
begin
  Font_Default := TGfxFont.Create('宋体', 12, False, False, False);  //字体类型 尺寸 加粗 斜体 锯齿
  Font_Bold := TGfxFont.Create('宋体', 12, True, False, False);
  Font_Default_18 := TGfxFont.Create('宋体', 18, True, False, False);
  Font_Default_24 := TGfxFont.Create('宋体', 24, True, False, False);


  StartTime := GetTickCount;
  I := 0;
end;

function TEiImageDraw.TextWidth(Str: WideString): Integer;
begin
  Result := Font_Default.GetTextSize(PWideChar(str)).cx;
end;

function TEiImageDraw.TextHeight(Str: WideString): Integer;
begin
  Result := Font_Default.GetTextSize(PWideChar(str)).cy;
end;















procedure TEiImageDraw.TextOut( x, y: Integer; FColor: Cardinal; Str: WideString; underline : Boolean);
begin
  DrawFont( Str, x, y, False, 0, True, FColor, False, underline);
end;
procedure TEiImageDraw.TextOut(x, y: Integer; Str: WideString; FColor: Cardinal; underline: Boolean = False);
begin
  DrawFont( Str, x, y, False, 0, True, FColor, False, underline);
end;


procedure TEiImageDraw.TextOut( x, y: Integer; Str: WideString; FColor: Cardinal; BColor: Cardinal; underline : Boolean);
begin //前景字体颜色 + 背景条框颜色 + 下划线
  DrawFont( Str, x, y, True, BColor, False, FColor, False, underline);
end;

procedure TEiImageDraw.TextOut(x, y: Integer; FColor: Cardinal; BColor: Cardinal; Str: WideString);
begin //字体颜色 + 自定义描边颜色
  DrawFont(Str, x, y, False, BColor, True, FColor, False);
end;

procedure TEiImageDraw.DrawFont(Str: WideString; x, y: Integer; HaveBackGround: Boolean;
BackGroundColor: LongWord; Haveshadow: Boolean; Color: LongWord; show: Boolean; underline : Boolean);
var
  OldColor: LongWord;
begin
  Color := DisplaceRB(Color or $FF000000);
  BackGroundColor := DisplaceRB(BackGroundColor or $FF000000);
  with Font_Default do begin
    OldColor := GetColor();
    str := widestring(str);
    if GetTickCount - StartTime > 150 then begin
      StartTime := GetTickCount;
      Inc(I);
      if I >=  3 then  I :=  0 ;
    end;
    if HaveBackGround then
    begin
       HCanvas.Rectangle( x, y, GetTextSize(PWideChar(str)).cx,
        GetTextSize(PWideChar(str)).cY, BackGroundColor, True);
    end;
    if show then //开启字体特效
    begin
      if Haveshadow then //开启描边
      begin
        SetColor(BackGroundColor); //描边颜色 $FF000000
        Print(x - 1, y, PWideChar(str),underline);
        Print(x + 1, y, PWideChar(str),underline);
        Print(x, y - 1, PWideChar(str),underline);
        Print(x, y + 1, PWideChar(str),underline);
        SetColor(Color,I);
        Print(x, y, PWideChar(str),underline);
        SetColor(OldColor);
      end
      else
      begin
        SetColor(Color,I);
        Print(x, y, PWideChar(str) ,underline);
        SetColor(OldColor);
      end;
    end
    else
    begin
      if Haveshadow then //开启描边
      begin
        SetColor(BackGroundColor); //描边颜色 $FF000000
        Print(x - 1, y, PWideChar(str),underline);
        Print(x + 1, y, PWideChar(str),underline);
        Print(x, y - 1, PWideChar(str),underline);
        Print(x, y + 1, PWideChar(str),underline);;
        SetColor(Color);
        Print(x, y, PWideChar(str) ,underline);
        SetColor(OldColor);
      end
      else
      begin
        SetColor(Color);
        Print(x, y, PWideChar(str),underline);
        SetColor(OldColor);
      end;
    end;
  end;
end;

(*   以下为新增字体而新建的函数   *)
(*   字体类型: 宋体   Size: 18   *)
(*   Date: 2018-02-04   *)
function TEiImageDraw.TextWidth_18(Str: WideString): Integer;
begin
  Result := Font_Default_18.GetTextSize(PWideChar(str)).cx;
end;

function TEiImageDraw.TextHeight_18(Str: WideString): Integer;
begin
  Result := Font_Default_18.GetTextSize(PWideChar(str)).cy;
end;

procedure TEiImageDraw.TextOut_18(x, y: Integer; FColor: Cardinal; Str: WideString);
begin
  DrawFont_18(Str, x, y, False, 0, True, FColor, False);
end;

procedure TEiImageDraw.DrawFont_18(Str: WideString; x, y: Integer; HaveBackGround: Boolean;
BackGroundColor: LongWord; Haveshadow: Boolean; Color: LongWord; show: Boolean; underline : Boolean);
var
  OldColor: LongWord;
begin
  Color := DisplaceRB(Color or $FF000000);
  BackGroundColor := DisplaceRB(BackGroundColor or $FF000000);
  with Font_Default_18 do begin
    OldColor := GetColor();
    str := widestring(str);
    if GetTickCount - StartTime > 150 then begin
      StartTime := GetTickCount;
      Inc(I);
      if I >=  3 then  I :=  0 ;
    end;
    if HaveBackGround then
    begin
       HCanvas.Rectangle( x, y, GetTextSize(PWideChar(str)).cx,
        GetTextSize(PWideChar(str)).cY, BackGroundColor, True);
    end;
    if show then //开启字体特效
    begin
      if Haveshadow then //开启描边
      begin
        SetColor($FF000000); //描边颜色
        Print(x - 1, y, PWideChar(str),underline);
        Print(x + 1, y, PWideChar(str),underline);
        Print(x, y - 1, PWideChar(str),underline);
        Print(x, y + 1, PWideChar(str),underline);
        SetColor(Color,I);
        Print(x, y, PWideChar(str),underline);
        SetColor(OldColor);
      end
      else
      begin
        SetColor(Color,I);
        Print(x, y, PWideChar(str) ,underline);
        SetColor(OldColor);
      end;
    end
    else
    begin
      if Haveshadow then //开启描边
      begin
        SetColor($FF000000); //描边颜色
        Print(x - 1, y, PWideChar(str),underline);
        Print(x + 1, y, PWideChar(str),underline);
        Print(x, y - 1, PWideChar(str),underline);
        Print(x, y + 1, PWideChar(str),underline);;
        SetColor(Color);
        Print(x, y, PWideChar(str) ,underline);
        SetColor(OldColor);
      end
      else
      begin
        SetColor(Color);
        Print(x, y, PWideChar(str),underline);
        SetColor(OldColor);
      end;
    end;
  end;
end;

(*   以下为新增字体而新建的函数   *)
(*   字体类型: 宋体   Size: 24   *)
(*   Date: 2018-03-22   *)
function TEiImageDraw.TextWidth_24(Str: WideString): Integer;
begin
  Result := Font_Default_24.GetTextSize(PWideChar(str)).cx;
end;

function TEiImageDraw.TextHeight_24(Str: WideString): Integer;
begin
  Result := Font_Default_24.GetTextSize(PWideChar(str)).cy;
end;

procedure TEiImageDraw.TextOut_24(x, y: Integer; FColor: Cardinal; BColor: Cardinal; Str: WideString);
begin //字体颜色 + 自定义描边颜色
  DrawFont_24(Str, x, y, False, BColor, True, FColor, False);
end;

procedure TEiImageDraw.DrawFont_24(Str: WideString; x, y: Integer; HaveBackGround: Boolean;
BackGroundColor: LongWord; Haveshadow: Boolean; Color: LongWord; show: Boolean; underline : Boolean);
var
  OldColor: LongWord;
begin
  Color := DisplaceRB(Color or $FF000000);
  BackGroundColor := DisplaceRB(BackGroundColor or $FF000000);
  with Font_Default_24 do begin
    OldColor := GetColor();
    str := widestring(str);
    if GetTickCount - StartTime > 150 then begin
      StartTime := GetTickCount;
      Inc(I);
      if I >=  3 then  I :=  0 ;
    end;
    if HaveBackGround then
    begin
       HCanvas.Rectangle( x, y, GetTextSize(PWideChar(str)).cx,
         GetTextSize(PWideChar(str)).cY, BackGroundColor, True);
    end;
    if show then //开启字体特效
    begin
      if Haveshadow then //开启描边
      begin
        SetColor(BackGroundColor); //描边颜色 $FF000000
        Print(x - 1, y, PWideChar(str),underline);
        Print(x + 1, y, PWideChar(str),underline);
        Print(x, y - 1, PWideChar(str),underline);
        Print(x, y + 1, PWideChar(str),underline);
        SetColor(Color,I);
        Print(x, y, PWideChar(str),underline);
        SetColor(OldColor);
      end
      else
      begin
        SetColor(Color,I);
        Print(x, y, PWideChar(str) ,underline);
        SetColor(OldColor);
      end;
    end
    else
    begin
      if Haveshadow then //开启描边
      begin
        SetColor(BackGroundColor); //描边颜色 $FF000000
        Print(x - 1, y, PWideChar(str),underline);
        Print(x + 1, y, PWideChar(str),underline);
        Print(x, y - 1, PWideChar(str),underline);
        Print(x, y + 1, PWideChar(str),underline);;
        SetColor(Color);
        Print(x, y, PWideChar(str) ,underline);
        SetColor(OldColor);
      end
      else
      begin
        SetColor(Color);
        Print(x, y, PWideChar(str),underline);
        SetColor(OldColor);
      end;
    end;
  end;
end;


(*   以下为新增字体而新建的函数   *)
(*   字体类型: 宋体   Size: 12 Bold  *)
(*   Date: 2018-03-22   *)

procedure TEiImageDraw.BoldTextOut( x, y: Integer; FColor: Cardinal; Str: WideString; underline : Boolean);
begin
  DrawFont_Bold( Str, x, y, False, 0, True, FColor, False, underline);
end;
procedure TEiImageDraw.BoldTextOut(x, y: Integer; Str: WideString; FColor: Cardinal; underline: Boolean = False);
begin
  DrawFont_Bold( Str, x, y, False, 0, True, FColor, False, underline);
end;


function TEiImageDraw.TextWidth_Bold(Str: WideString): Integer;
begin
  Result := Font_Bold.GetTextSize(PWideChar(str)).cx;
end;

function TEiImageDraw.TextHeight_Bold(Str: WideString): Integer;
begin
  Result := Font_Bold.GetTextSize(PWideChar(str)).cy;
end;

procedure TEiImageDraw.DrawFont_Bold(Str: WideString; x, y: Integer; HaveBackGround: Boolean;
BackGroundColor: LongWord; Haveshadow: Boolean; Color: LongWord; show: Boolean; underline : Boolean);
var
  OldColor: LongWord;
begin
  Color := DisplaceRB(Color or $FF000000);
  BackGroundColor := DisplaceRB(BackGroundColor or $FF000000);
  with Font_Bold do begin
    OldColor := GetColor();
    str := widestring(str);
    if GetTickCount - StartTime > 150 then begin
      StartTime := GetTickCount;
      Inc(I);
      if I >=  3 then  I :=  0 ;
    end;
    if HaveBackGround then
    begin
       HCanvas.Rectangle( x, y, GetTextSize(PWideChar(str)).cx,
         GetTextSize(PWideChar(str)).cY, BackGroundColor, True);
    end;
    if show then //开启字体特效
    begin
      if Haveshadow then //开启描边
      begin
        SetColor(BackGroundColor); //描边颜色 $FF000000
        Print(x - 1, y, PWideChar(str),underline);
        Print(x + 1, y, PWideChar(str),underline);
        Print(x, y - 1, PWideChar(str),underline);
        Print(x, y + 1, PWideChar(str),underline);
        SetColor(Color,I);
        Print(x, y, PWideChar(str),underline);
        SetColor(OldColor);
      end
      else
      begin
        SetColor(Color,I);
        Print(x, y, PWideChar(str) ,underline);
        SetColor(OldColor);
      end;
    end
    else
    begin
      if Haveshadow then //开启描边
      begin
        SetColor(BackGroundColor); //描边颜色 $FF000000
        Print(x - 1, y, PWideChar(str),underline);
        Print(x + 1, y, PWideChar(str),underline);
        Print(x, y - 1, PWideChar(str),underline);
        Print(x, y + 1, PWideChar(str),underline);;
        SetColor(Color);
        Print(x, y, PWideChar(str) ,underline);
        SetColor(OldColor);
      end
      else
      begin
        SetColor(Color);
        Print(x, y, PWideChar(str),underline);
        SetColor(OldColor);
      end;
    end;
  end;
end;












end.

