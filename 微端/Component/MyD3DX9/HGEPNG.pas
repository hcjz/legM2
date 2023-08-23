unit HGEPNG;

interface

uses
 Types, Classes, SysUtils, Graphics, PNGImage;

//---------------------------------------------------------------------------
function LoadPNGtoBMP(Stream: TStream; Dest: TBitmap): Boolean;
function LoadPNGtoTexture(Stream: TStream): Boolean;


//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
function LoadPNGtoBMP(Stream: TStream; Dest: TBitmap): Boolean;
var
 Image: TPngObject;
 ScanIndex, i: Integer;
 PxScan : PLongword;
 PxAlpha: PByte;
begin
 Result:= True;

 Image:= TPngObject.Create();
 try
  Image.LoadFromStream(Stream);
 except
  Result:= False;
 end;

 if (Result) then
  begin
   Image.AssignTo(Dest);

   if (Image.Header.ColorType = COLOR_RGBALPHA)or(Image.Header.ColorType = COLOR_GRAYSCALEALPHA) then
    begin
     Dest.PixelFormat:= pf32bit;

     for ScanIndex:= 0 to Dest.Height - 1 do
      begin
       PxScan := Dest.Scanline[ScanIndex];
       PxAlpha:= @Image.AlphaScanline[ScanIndex][0];
       for i:= 0 to Dest.Width - 1 do
        begin
         PxScan^:= (PxScan^ and $FFFFFF) or (Longword(Byte(PxAlpha^)) shl 24);
         Inc(PxScan);
         Inc(PxAlpha);
        end;
      end;
    end;
  end;

 Image.Free();
end;

function LoadPNGtoTexture(Stream: TStream): Boolean;
var
 Image: TPngObject;
 ScanIndex, i: Integer;
 PxScan : PLongword;
 PxAlpha: PByte;
 Bmp: TBitmap;
begin
 Result:= True;

 Image:= TPngObject.Create();
 try
  Image.LoadFromStream(Stream);
 except
  Result:= False;
 end;

 if (Result) then
 begin
   Bmp:= TBitmap.Create();

   Image.AssignTo(Bmp);

   if (Image.Header.ColorType = COLOR_RGBALPHA)or(Image.Header.ColorType = COLOR_GRAYSCALEALPHA) then
    begin
     Bmp.PixelFormat:= pf32bit;

     for ScanIndex:= 0 to Bmp.Height - 1 do
      begin
       PxScan := Bmp.Scanline[ScanIndex];
       PxAlpha:= @Image.AlphaScanline[ScanIndex][0];
        for i:= 0 to Bmp.Width - 1 do begin
          PxScan^:= (PxScan^ and $FFFFFF) or (Longword(Byte(PxAlpha^)) shl 24);
          Inc(PxScan);
          Inc(PxAlpha);
        end;
      end;
    end;
    Bmp.Free();
  end;

 Image.Free();
end;
//---------------------------------------------------------------------------
end.
