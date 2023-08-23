unit cliUtil;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HGE, HGECanvas, HGETextures, WIL, Grobal2, StdCtrls, HUtil32, mmSystem;

  procedure LoadColorLevels(); //加载颜色
  procedure UnLoadColorLevels(); //释放颜色
  function GetTempSurface(ColorFormat: TWILColorFormat): TDXImageTexture;

  procedure DrawBlendR(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; sSufLeft, sSufTop, sSufWidth, sSufHeight, BlendMode: Integer);
  procedure DrawBlendEx(dsuf: TDirectDrawSurface; x, y: integer; Rect: TRect; ssuf: TDirectDrawSurface; blendmode: integer);
  procedure DrawBlend(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; BlendMode: Integer);
  procedure DrawBlendStretchEX(dsuf: TDirectDrawSurface;SrcRect, Rect: TRect; ssuf: TDirectDrawSurface; blendmode: integer);
  procedure DrawEffect(dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; eff: TColorEffect; boBlend:
    Boolean; blendmode: integer = 0);
  procedure MakeDark(DarkLevel: integer); //淡入淡出效果

implementation

uses
  HGEBase, MShare;

var
  GrayScaleByR5G6B5: array[Word] of Word;
  GrayScaleByA1R5G5B5: array[Word] of Word;
  GrayScaleByA4R4G4B4: array[Word] of Word;
  GSA1R5G5B5ToA4R4G4B4: array[Word] of Word;
  ImgMixSurfaceR5G6B5: TDXImageTexture;
  ImgMixSurfaceA1R5G5B5: TDXImageTexture; //0x0C
  ImgMixSurfaceA4R4G4B4: TDXImageTexture; //0x0C
  ImgMaxSurfaceR5G6B5: TDXImageTexture;
  ImgMaxSurfaceA1R5G5B5: TDXImageTexture; //0x0C
  ImgMaxSurfaceA4R4G4B4: TDXImageTexture; //0x0C
  boA1R5G5B5, boR5G6B5, boA4R4G4B4: Boolean;

procedure MakeDark(DarkLevel: integer); //淡入淡出效果
begin
  if not DarkLevel in [1..30] then exit;
  g_DXCanvas.FillRectAlpha(Rect(0, 0, SCREENWIDTH, SCREENHEIGHT), 0, round((30 - DarkLevel) * 255 / 30));
end;

procedure DrawEffect(dsuf: TDirectDrawSurface; x, y: integer; ssuf: TDirectDrawSurface; eff: TColorEffect; boBlend:
  Boolean; blendmode: integer);
var
  nColor: Integer;
  SourceAccess, TargetAccess: TDXAccessInfo;
  peff: PByte;
  TargetTexture: TDXImageTexture;
  SourcePtr, TargetPtr: PChar;
  I, nCount: Integer;
  DrawFx: Cardinal;
  nWidth, nHeight: Integer;
begin
  if boBlend then nColor := Integer($80000000)
    else nColor := Integer($FF000000);
  if blendmode = 0 then begin
    DrawFx := fxBlend;
  end
  else begin
    DrawFx := fxAnti;
  end;

  case eff of
    ceNone: ;
    ceGrayScale: begin  //麻痹效果(黑白效果，灰度)
        nWidth := ssuf.Width;
        nHeight := ssuf.Height;
        if (nWidth > SCREENWIDTH) then nWidth := SCREENWIDTH;
        if (nHeight > SCREENHEIGHT) then nHeight := SCREENHEIGHT;
        if ssuf.Lock(lfReadOnly, SourceAccess) then begin
          try
            case SourceAccess.Format of
              COLOR_A1R5G5B5: begin
                  peff := @GrayScaleByA1R5G5B5[0];
                  TargetTexture := GetTempSurface(WILFMT_A1R5G5B5);
                end;
              COLOR_A4R4G4B4: begin
                  peff := @GrayScaleByA4R4G4B4[0];
                  TargetTexture := GetTempSurface(WILFMT_A4R4G4B4);
                end;
              COLOR_R5G6B5: begin
                  peff := @GrayScaleByR5G6B5[0];
                  TargetTexture := GetTempSurface(WILFMT_R5G6B5);
                end;
            else
              exit;
            end;
            if (peff <> nil) and (TargetTexture <> nil) then begin
              TargetTexture.PatternSize := Point(nWidth, nHeight);
              if TargetTexture.Lock(lfWriteOnly, TargetAccess) then begin
                Try
                  nCount := nWidth;
                  for I := 0 to nHeight - 1 do begin
                    SourcePtr := PChar(Integer(SourceAccess.Bits) + (SourceAccess.Pitch * I));
                    TargetPtr := PChar(Integer(TargetAccess.Bits) + (TargetAccess.Pitch * I));
                    asm
                      push esi
                      push edi
                      push ebx
                      push edx
                      push eax

                      mov esi, SourcePtr
                      mov edi, TargetPtr
                      mov ecx, nCount
                      mov edx, peff
                    @pixloop:
                      movzx eax, [esi].Word
                      add esi, 2

                      shl eax, 1
                      mov ax, [edx+eax].word

                      mov [edi], ax
                      add edi, 2

                      dec ecx
                      jnz @pixloop

                      pop eax
                      pop edx
                      pop ebx
                      pop edi
                      pop esi
                    end;
                  end;
                Finally
                  TargetTexture.Unlock;
                End;
              end;
            end;
          finally
            ssuf.Unlock;
          end;
          if TargetTexture <> nil then
            Dsuf.Draw(x, y, TargetTexture.ClientRect, TargetTexture, clWhite or nColor, DrawFx);
        end;
      end;

    ceGrayScaleMMX: begin //死亡混合效果 2018-12-30
        dsuf.Draw(x, y, ssuf.ClientRect, ssuf,Blend_GrayScale);
        Dsuf.Draw(x, y, ssuf.ClientRect, ssuf, $FF696969, fxAnti); //光亮效果 深灰色
    end;
    ceBright: begin//高亮效果
      Dsuf.Draw(x, y, ssuf.ClientRect, ssuf, clWhite or nColor, fxBlend); //亮度适中，接近小火炬
      Dsuf.Draw(x, y, ssuf.ClientRect, ssuf, $FF696969, fxAnti); //光亮效果 深灰色
    end;
    ceRed: Dsuf.Draw(x, y, ssuf.ClientRect, ssuf, clRed or nColor, DrawFx);//红毒效果
    ceGreen: Dsuf.Draw(x, y, ssuf.ClientRect, ssuf, clGreen or nColor, DrawFx);//绿毒效果
    ceBlue: Dsuf.Draw(x, y, ssuf.ClientRect, ssuf, clBlue or nColor, DrawFx);
    ceYellow: Dsuf.Draw(x, y, ssuf.ClientRect, ssuf, clYellow or nColor, DrawFx);
    ceFuchsia: Dsuf.Draw(x, y, ssuf.ClientRect, ssuf, clFuchsia or nColor, DrawFx);
  end;
end;

procedure DrawBlendStretchEX(dsuf: TDirectDrawSurface; SrcRect , Rect: TRect; ssuf: TDirectDrawSurface; blendmode: integer);
begin
  dsuf.StretchDraw(SrcRect, Rect, ssuf, SetA($80FFFFFF, blendmode), fxBlend);
end;

procedure DrawBlend(dSuf: TDirectDrawSurface; X, Y: Integer; sSuf: TDirectDrawSurface; BlendMode: Integer);
begin
  if (dsuf <> nil) and (ssuf <> nil) then  begin
    if blendmode = 0 then
       dsuf.Draw(x, y, ssuf.ClientRect, ssuf, $80FFFFFF, fxBlend)
    else dsuf.Draw(x, y, ssuf.ClientRect, ssuf, fxAnti);
  end;
end;

procedure DrawBlendEX(dsuf: TDirectDrawSurface; x, y: integer; Rect: TRect; ssuf: TDirectDrawSurface; blendmode: integer);
begin
  dsuf.Draw(x, y, Rect, ssuf, SetA($80FFFFFF, blendmode), fxBlend);
end;

procedure DrawBlendR(                //BltAlphaFast_MMX
  dSuf: TDirectDrawSurface;             //eax
  X,                                    //edx
  Y: Integer;                           //ecx
  sSuf: TDirectDrawSurface;             //[ebp+$1C]
  sSufLeft,                             //[ebp+$18]
  sSufTop,                              //[ebp+$14]
  sSufWidth,                            //[ebp+$10]
  sSufHeight,                           //[ebp+$0C]
  BlendMode: Integer);                  //[ebp+$08]
begin
  if (dsuf <> nil) and (ssuf <> nil) then
  begin
    if blendmode = 0 then
      dsuf.Draw(x, y, Rect(sSufLeft,            //[ebp+$18]
        sSufTop,                                //[ebp+$14]
        sSufWidth,                              //[ebp+$10]
        sSufHeight), ssuf, $80FFFFFF, fxBlend)
    else dsuf.Draw(x, y, Rect(sSufLeft,         //[ebp+$18]
          sSufTop,                              //[ebp+$14]
          sSufWidth,                            //[ebp+$10]
          sSufHeight), ssuf, fxAnti);
  end;
end;

function GetTempSurface(ColorFormat: TWILColorFormat): TDXImageTexture;
begin
  Result := nil;
  case ColorFormat of
    WILFMT_A1R5G5B5: begin
      if boA1R5G5B5 then Result := ImgMaxSurfaceA1R5G5B5
      else Result := ImgMixSurfaceA1R5G5B5;
      boA1R5G5B5 := not boA1R5G5B5;
    end;
    WILFMT_A4R4G4B4: begin
      if boA4R4G4B4 then Result := ImgMaxSurfaceA4R4G4B4
      else Result := ImgMixSurfaceA4R4G4B4;
      boA4R4G4B4 := not boA4R4G4B4;
    end;
    WILFMT_R5G6B5: begin
      if boR5G6B5 then Result := ImgMaxSurfaceR5G6B5
      else Result := ImgMixSurfaceR5G6B5;
      boR5G6B5 := not boR5G6B5;
    end;
  end;
  if Result <> nil then
    Result.PatternSize := Point(SCREENWIDTH, SCREENHEIGHT);
end;

procedure LoadColorLevels();
var
  i: integer;
  nA, nR, nG, nB, nX: Byte;
begin
  ImgMixSurfaceR5G6B5 := MakeDXImageTexture(SCREENWIDTH, SCREENHEIGHT, WILFMT_R5G6B5);
  ImgMixSurfaceA1R5G5B5 := MakeDXImageTexture(SCREENWIDTH, SCREENHEIGHT, WILFMT_A1R5G5B5);
  ImgMixSurfaceA4R4G4B4 := MakeDXImageTexture(SCREENWIDTH, SCREENHEIGHT, WILFMT_A4R4G4B4);
  ImgMaxSurfaceR5G6B5 := MakeDXImageTexture(SCREENWIDTH, SCREENHEIGHT, WILFMT_R5G6B5);
  ImgMaxSurfaceA1R5G5B5 := MakeDXImageTexture(SCREENWIDTH, SCREENHEIGHT, WILFMT_A1R5G5B5);
  ImgMaxSurfaceA4R4G4B4 := MakeDXImageTexture(SCREENWIDTH, SCREENHEIGHT, WILFMT_A4R4G4B4);
  ImgMixSurfaceR5G6B5.Canvas := g_DXCanvas;
  ImgMixSurfaceA1R5G5B5.Canvas := g_DXCanvas;
  ImgMixSurfaceA4R4G4B4.Canvas := g_DXCanvas;
  ImgMaxSurfaceR5G6B5.Canvas := g_DXCanvas;
  ImgMaxSurfaceA1R5G5B5.Canvas := g_DXCanvas;
  ImgMaxSurfaceA4R4G4B4.Canvas := g_DXCanvas;
  GrayScaleByR5G6B5[0] := 0;
  GrayScaleByA1R5G5B5[0] := 0;
  GrayScaleByA4R4G4B4[0] := 0;
  for I := Low(Word) to High(Word) do begin
    //R5G6B5
    nB := BYTE((Word(I) and $1F) shl 3);
    nG := BYTE((Word(I) and $7E0) shr 3);
    nR := BYTE((Word(I) and $F800) shr 8);
    nX := (nR + nG + nB) div 3;
    GrayScaleByR5G6B5[I] := ((Word(nX) and $F8) shl 8) + (Word(nX) and $FC shl 3) + (Word(nX) shr 3);

    //A1R5G5B5
    nB := BYTE((Word(I) and $1F) shl 3);
    nG := BYTE((Word(I) and $3E0) shr 2);
    nR := BYTE((Word(I) and $7C00) shr 7);
    nA := BYTE((Word(I) and $8000) shr 15);
    nX := (nR + nG + nB) div 3;
    GrayScaleByA1R5G5B5[I] := Word(nA) shl 15 + ((Word(nX) and $F8) shl 7) + (Word(nX) and $F8 shl 2) + (Word(nX) shr 3);

    //A4R4G4B4
    nB := BYTE((Word(I) and $F) shl 4);
    nG := BYTE(Word(I) and $F0);
    nR := BYTE((Word(I) and $F00) shr 4);
    nA := BYTE((Word(I) and $F000) shr 8);
    nX := (nR + nG + nB) div 3;
    GrayScaleByA4R4G4B4[I] := Word(nA) and $F0 shl 8 + ((Word(nX) and $F0) shl 4) + (Word(nX) and $F0) + (Word(nX) shr 4);

    nB := BYTE((Word(I) and $1F) shl 3);
    nG := BYTE((Word(I) and $3E0) shr 2);
    nR := BYTE((Word(I) and $7C00) shr 7);
    nA := BYTE((Word(I) and $8000) shr 15);
    nX := (nR + nG + nB) div 3;
    if nA = 0 then
      GSA1R5G5B5ToA4R4G4B4[I] := ((Word(nX) and $F0) shl 4) + (Word(nX) and $F0) + (Word(nX) shr 4)
    else
      GSA1R5G5B5ToA4R4G4B4[I] := $F000 + ((Word(nX) and $F0) shl 4) + (Word(nX) and $F0) + (Word(nX) shr 4);
  end;
end;

procedure UnLoadColorLevels();
begin
  if ImgMixSurfaceR5G6B5 <> nil then
    ImgMixSurfaceR5G6B5.Free;
  if ImgMixSurfaceA1R5G5B5 <> nil then
    ImgMixSurfaceA1R5G5B5.Free;
  if ImgMixSurfaceA4R4G4B4 <> nil then
    ImgMixSurfaceA4R4G4B4.Free;
  ImgMixSurfaceR5G6B5 := nil;
  ImgMixSurfaceA1R5G5B5 := nil;
  ImgMixSurfaceA4R4G4B4 := nil;
  if ImgMaxSurfaceR5G6B5 <> nil then
    ImgMaxSurfaceR5G6B5.Free;
  if ImgMaxSurfaceA1R5G5B5 <> nil then
    ImgMaxSurfaceA1R5G5B5.Free;
  if ImgMaxSurfaceA4R4G4B4 <> nil then
    ImgMaxSurfaceA4R4G4B4.Free;
  ImgMaxSurfaceR5G6B5 := nil;
  ImgMaxSurfaceA1R5G5B5 := nil;
  ImgMaxSurfaceA4R4G4B4 := nil;
end;

end.

