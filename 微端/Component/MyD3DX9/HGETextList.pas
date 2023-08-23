unit HGETextList;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, HGECanvas, HGETextures,
 DirectXD3D9, Wilpion;

type
  TOutImag = record
     Text: string;
     FColor: Integer;
     BColor: Integer;
     W: integer;
     H: integer;
     MW:integer;
     FontSize:Integer;
     wLatestTime: LongWord;
     Surface: TDirectDrawSurface;
  end;
  pTOutImag = ^TOutImag;

  TDextOutImage = class
   private
    TexOutList: TList;
   protected
    dwMemChecktTick: LongWord;
   public
    constructor Create;
    destructor Destroy(); override;
    procedure FreeTextImgeMemorys();
    function CakeTextImgeOut(Str:string; var SW:Integer): TDirectDrawSurface;overload;
    function CakeTextImgeOut(Str:string; FColor,BColor: Cardinal; var SW,SH:Integer): TDirectDrawSurface;overload;
    function CakeTextImgeOut(Str:string; FColor,BColor: Cardinal; FontSize: Integer; var SW,SH:Integer): TDirectDrawSurface;overload;
    function OPTextImgeOut(DXCanvas: TDXDrawCanvas; Str:string; var OutW:integer): TDirectDrawSurface;overload;
    function OPTextImgeOut(DXCanvas: TDXDrawCanvas; Str:string; FColor,BColor: Cardinal;
          var OutW,OutH:integer): TDirectDrawSurface;overload;
    function OPTextImgeOut(DXCanvas: TDXDrawCanvas; Str:string; FColor,BColor: Cardinal; FontSize, FStyle: Integer;
          var OutW,OutH:integer): TDirectDrawSurface;overload;

  end;

implementation

constructor TDextOutImage.Create;
begin
  inherited;
  TexOutList := TList.Create;
  dwMemChecktTick := GetTickCount;
end;

destructor TDextOutImage.Destroy;
var
 I: Integer;
begin
  if TexOutList.Count > 0 then begin
      for I:= 0 to TexOutList.Count - 1  do begin
        if pTOutImag(TexOutList[I]) <> nil then begin
           if pTOutImag(TexOutList[I]).Surface <> nil then  begin
             pTOutImag(TexOutList[I]).Surface.Free;
             pTOutImag(TexOutList[I]).Surface := nil;
           end;
           Dispose(pTOutImag(TexOutList[I]));
        end;
      end;

  end;
  TexOutList.Free;
  inherited;
end;

procedure TDextOutImage.FreeTextImgeMemorys();
var
 I: Integer;
begin
  if TexOutList.Count > 0 then begin
    if GetTickCount - dwMemChecktTick > 180000 then begin
       dwMemChecktTick := GetTickCount;
      for i := TexOutList.Count - 1 downto 0 do begin
        if pTOutImag(TexOutList[I]) <> nil then begin
          if GetTickCount - pTOutImag(TexOutList[I]).wLatestTime > 600000 then begin
            if pTOutImag(TexOutList[I]).Surface <> nil then  begin
              pTOutImag(TexOutList[I]).Surface.Free;
              pTOutImag(TexOutList[I]).Surface := nil;
            end;
             Dispose(pTOutImag(TexOutList[I]));
             TexOutList.Delete(I);
          end;
        end;
      end;
    end;
  end;
end;

function TDextOutImage.CakeTextImgeOut(Str:string; var SW:Integer): TDirectDrawSurface;
var
 I: Integer;
 TextOutImage: pTOutImag;
begin
 Result := nil;
    if TexOutList.Count > 0 then begin
      I := 0;
      while True do begin
         if I >= TexOutList.Count then Break;
        TextOutImage := pTOutImag(TexOutList[I]);
        if (TextOutImage <> nil) and (TextOutImage.Surface <> nil) then begin
          if (str = TextOutImage.Text) then begin
            pTOutImag(TexOutList[I]).wLatestTime := GetTickCount;
            Result := TextOutImage.Surface;
            SW := TextOutImage.MW;
            Break;
          end;
        end;
        Inc(I);
      end;
    end;
end;

function TDextOutImage.CakeTextImgeOut(Str:string; FColor,BColor: Cardinal; var SW,SH:Integer): TDirectDrawSurface;
var
 I: Integer;
 TextOutImage: pTOutImag;
begin
 Result := nil;
    if TexOutList.Count > 0 then begin
      I := 0;
      while True do begin
         if I >= TexOutList.Count then Break;
        TextOutImage := pTOutImag(TexOutList[I]);
        if (TextOutImage <> nil) and (TextOutImage.Surface <> nil) then begin
          if (str = TextOutImage.Text) and (FColor = TextOutImage.FColor) and (BColor = TextOutImage.BColor) then begin
            pTOutImag(TexOutList[I]).wLatestTime := GetTickCount;
            Result := TextOutImage.Surface;
            SW := TextOutImage.W;
            SH := TextOutImage.H;
            Break;
          end;
        end;
        Inc(I);
      end;
    end;
end;



function TDextOutImage.CakeTextImgeOut(Str:string; FColor,BColor: Cardinal; FontSize: Integer; var SW,SH:Integer): TDirectDrawSurface;
var
 I: Integer;
 TextOutImage: pTOutImag;
begin
 Result := nil;
    if TexOutList.Count > 0 then begin
      I := 0;
      while True do begin
        if I >= TexOutList.Count then Break;
        TextOutImage := pTOutImag(TexOutList[I]);
        if (TextOutImage <> nil) and (TextOutImage.Surface <> nil) then begin
          if (str = TextOutImage.Text) and (FColor = TextOutImage.FColor)
           and (BColor = TextOutImage.BColor) and (TextOutImage.FontSize = FontSize) then begin
            pTOutImag(TexOutList[I]).wLatestTime := GetTickCount;
            Result := TextOutImage.Surface;
            SW := TextOutImage.W;
            SH := TextOutImage.H;
            Break;
          end;
        end;
        Inc(I);
      end;
    end;
end;

function TDextOutImage.OPTextImgeOut(DXCanvas: TDXDrawCanvas; Str:string; var OutW:integer): TDirectDrawSurface;
var
 Image: pTOutImag;
 Sw,Sh: Integer;
 bitmap: TBitmap;
begin
 Result := nil;
 OutW := 0;
 if (Str <> '') then begin
   FreeTextImgeMemorys();
   Result := CakeTextImgeOut(Str,OutW);
   if Result <> nil then Exit;
   if DXCanvas <> nil then begin
     New(Image);
     bitmap := TBitmap.Create;
     bitmap.Canvas.font.Name := 'ËÎÌו';
     bitmap.Canvas.Font.Size := 9;
     bitmap.PixelFormat := pf16bit;
     Sw := bitmap.Canvas.TextWidth(Str);
     Sh := bitmap.Canvas.TextHeight(Str);
     bitmap.Width := Sw;
     bitmap.Height := Sh;
     Image.Surface := TDXImageTexture.Create(nil);
     Image.Surface.Size := Point(Sw, Sh);
     Image.Surface.PatternSize := Point(Sw, Sh);
     Image.Surface.Format := D3DFMT_A1R5G5B5;
     Image.Surface.Active := True;
     bitmap.Canvas.Brush.Color := TColor(0);
     bitmap.Canvas.FillRect(Rect(0, 0, Sw, Sh));
     SetBkMode(Bitmap.Canvas.Handle, TRANSPARENT);
     bitmap.Canvas.Font.Color := clWhite;
     TextOut(bitmap.Canvas.Handle, 0, 0, PChar(str), Length(str));
     Image.Surface.LoadBitmapToDTexture(bitmap);
     Image.Text := str;
     Image.W := Sw div 2;
     Image.H := Sh div 2;
     Image.MW := Sw;
     Image.wLatestTime := GetTickCount;
     TexOutList.Add(Image);
     bitmap.Free;
     Result := Image.Surface;
     OutW := Image.MW;
   end;
 end;
end;


function TDextOutImage.OPTextImgeOut(DXCanvas: TDXDrawCanvas; Str:string; FColor,BColor: Cardinal;
          var OutW,OutH:integer): TDirectDrawSurface;
var
 Image: pTOutImag;
 Sw,Sh: Integer;
begin
 Result := nil;
 OutW := 0;
 OutH := 0;
 if (Str <> '') then begin
   FreeTextImgeMemorys();
   Result := CakeTextImgeOut(Str,FColor,BColor,OutW,OutH);
   if Result <> nil then Exit;
   if DXCanvas <> nil then begin
     New(Image);
     Sw := DXCanvas.TextWidth(Str) + 2;
     Sh := DXCanvas.TextHeight(Str)+ 2;
     Image.Surface := TDXImageTexture.Create(DXCanvas);
     Image.Surface.Size := Point(Sw, Sh);
     Image.Surface.PatternSize := Point(Sw, Sh);
     Image.Surface.Format := D3DFMT_A4R4G4B4;
     Image.Surface.Active := True;
     Image.Surface.Clear;
     Image.Surface.TextOutEx(1,1,Str,FColor,BColor);
     Image.Text := str;
     Image.FColor := Fcolor;
     Image.BColor := Bcolor;
     Image.W := Sw div 2;
     Image.H := Sh div 2;
     Image.FontSize := 9;
     Image.wLatestTime := GetTickCount;
     TexOutList.Add(Image);
   end;
 end;
end;



function TDextOutImage.OPTextImgeOut(DXCanvas: TDXDrawCanvas; Str:string; FColor,BColor: Cardinal;
         FontSize, FStyle: Integer; var OutW,OutH:integer): TDirectDrawSurface;
var
 Image: pTOutImag;
 Sw,Sh: Integer;
 bitmap: TBitmap;
begin
 Result := nil;
 OutW := 0;
 OutH := 0;
 if (Str <> '') then begin
   FreeTextImgeMemorys();
   if Bcolor = clBlack then Bcolor := $00000008;
   Result := CakeTextImgeOut(Str,FColor,BColor,FontSize,OutW,OutH);
   if Result <> nil then Exit;
   if DXCanvas <> nil then begin
     New(Image);
     bitmap := TBitmap.Create;
     bitmap.Canvas.font.Name := 'ËÎÌו';
     bitmap.Canvas.Font.Size := FontSize;
     bitmap.PixelFormat := pf16bit;
     if FStyle > 0 then
     bitmap.Canvas.Font.Style:=[fsBold];
     Sw := bitmap.Canvas.TextWidth(Str)+4;
     Sh := bitmap.Canvas.TextHeight(Str)+4;
     bitmap.Width := Sw;
     bitmap.Height := Sh;
     Image.Surface := TDXImageTexture.Create(nil);
     Image.Surface.Size := Point(Sw, Sh);
     Image.Surface.PatternSize := Point(Sw, Sh);
     Image.Surface.Format := D3DFMT_A1R5G5B5;
     Image.Surface.Active := True;
     bitmap.Canvas.Brush.Color := TColor(0);
     bitmap.Canvas.FillRect(Rect(0, 0, Sw, Sh));
     SetBkMode(Bitmap.Canvas.Handle, TRANSPARENT);
     bitmap.Canvas.Font.Color := bcolor;
     TextOut(bitmap.Canvas.Handle, 0, 1, PChar(str), Length(str));
     TextOut(bitmap.Canvas.Handle, 2, 1, PChar(str), Length(str));
     TextOut(bitmap.Canvas.Handle, 1, 0, PChar(str), Length(str));
     TextOut(bitmap.Canvas.Handle, 1, 2, PChar(str), Length(str));
     bitmap.Canvas.Font.Color := fcolor;
     TextOut(bitmap.Canvas.Handle, 1, 1, PChar(str), Length(str));
     Image.Surface.LoadBitmapToDTexture(bitmap);
     Image.Text := str;
     Image.FColor := Fcolor;
     Image.BColor := Bcolor;
     Image.FontSize := FontSize;
     Image.W := Sw div 2;
     Image.H := Sh div 2;
     Image.wLatestTime := GetTickCount;
     TexOutList.Add(Image);
     bitmap.Free;
   end;
 end;
end;



end.
