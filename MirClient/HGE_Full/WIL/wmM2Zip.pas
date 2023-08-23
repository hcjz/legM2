unit wmM2Zip;

interface
uses
  Windows, Classes, Graphics, SysUtils, HGETextures, HUtil32, Wil, DirectXGraphics;

type
  TWZImageInfo = record
    BitMode: Byte; //3=8Î» 5=16Î»
    unKnow1: array [0 .. 2] of Byte;
    DXInfo: TDXTextureInfo;
    nZipSize: Integer; //0=Î´Ñ¹Ëõ
  end;
  PTWZImageInfo = ^TWZImageInfo;

  TWZIndexHeader = record
    Title: string[43];
    IndexCount: Integer;
  end;
  PTWZIndexHeader = ^TWZIndexHeader;

  TWMM2ZipImages = class(TWMBaseImages)
  private
    FIdxHeader: TWZIndexHeader;
    FIdxFile: string;
    Fbo16bit: Boolean;
    procedure LoadIndex(idxfile: string);
    function CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
  protected
    procedure LoadDxImage(index: Integer; position: Integer; pDXTexture: pTDXTextureSurface); override;
{$IFDEF WORKFILE}
    function GetImageBitmapEx(index: Integer; out btType: Byte): TBitmap; override;
{$ENDIF}
  public
    constructor Create(); override;
    function Initialize(): Boolean; override;
    procedure Finalize; override;
{$IFDEF WORKFILE}
    function CanDrawData(index: Integer): Boolean; override;
    function CopyDataToTexture(index: Integer; Texture: TDXImageTexture): Boolean; override;

{$ENDIF}
  end;

implementation

{ TWMM2ZipImages }

{$IFDEF WORKFILE}
function TWMM2ZipImages.GetImageBitmapEx(index: Integer; out btType: Byte): TBitmap;
var
  nPosition: Integer;
  ImgInfo: TWZImageInfo;
  inBuffer, outBuffer, WriteBuffer, ReadBuffer: PChar;
  {outSize, }nLen: Integer;
  Y: Integer;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
  if (index < 0) or (index >= FImageCount) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    FFileStream.Read(ImgInfo, SizeOf(TWZImageInfo));
    if (ImgInfo.DXInfo.nWidth > MAXIMAGESIZE) or (ImgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (ImgInfo.DXInfo.nWidth < MINIMAGESIZE) or (ImgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    Fbo16bit := ImgInfo.BitMode = 5;
    if Fbo16bit then begin
      nLen  := WidthBytes(16, ImgInfo.DXInfo.nWidth);
      //ReadSize := nLen * ImgInfo.DXInfo.nHeight; //;//* 2;
    end else begin
      nLen  := WidthBytes(8, ImgInfo.DXInfo.nWidth);
      //ReadSize := nLen * ImgInfo.DXInfo.nHeight;
    end;
    if (ImgInfo.nZipSize <= 0) then
      exit;
    GetMem(inBuffer, ImgInfo.nZipSize);
    outBuffer := nil;
    try
      if FFileStream.Read(inBuffer^, ImgInfo.nZipSize) = ImgInfo.nZipSize then
      begin
        {outSize := }ZIPDecompress(inBuffer, ImgInfo.nZipSize, 0, outBuffer);
        FLastImageInfo := ImgInfo.DXInfo;
        if Fbo16bit then begin
          Result := TBitmap.Create;
          Result.PixelFormat := pf16bit;
          Result.Width := ImgInfo.DXInfo.nWidth;
          Result.Height := ImgInfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do begin
            WriteBuffer := Result.ScanLine[Result.Height - Y - 1];
            ReadBuffer := @outBuffer[Y * nLen];
            Move(ReadBuffer^, WriteBuffer^, Result.Width * 2);
          end;
        end else begin
          Result := TBitmap.Create;
          Result.PixelFormat := pf8bit;
          Result.Width := ImgInfo.DXInfo.nWidth;
          Result.Height := ImgInfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do begin
            WriteBuffer := Result.ScanLine[Result.Height - Y - 1];
            ReadBuffer := @outBuffer[Y * nLen];
            Move(ReadBuffer^, WriteBuffer^, Result.Width);
          end;
          SetDIBColorTable(Result.Canvas.Handle, 0, 256, m_DefMainPalette);
        end;
        FreeMem(outBuffer);
      end;
    finally
      FreeMem(inBuffer);
    end;
  end;
end;

function TWMM2ZipImages.CanDrawData(index: Integer): Boolean;
var
  nPosition: Integer;
  ImgInfo: TWMImageInfo;
begin
  Result := False;
  if (index < 0) or (index >= FImageCount) then exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if nPosition <= 0 then exit;
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    if not FNewFmt then FFileStream.Read(ImgInfo, SizeOf(ImgInfo) - SizeOf(Integer))
    else FFileStream.Read(ImgInfo, SizeOf(ImgInfo));
    if (ImgInfo.DXInfo.nWidth > MAXIMAGESIZE) or (ImgInfo.DXInfo.nHeight > MAXIMAGESIZE) then Exit;
    if (ImgInfo.DXInfo.nWidth < MINIMAGESIZE) or (ImgInfo.DXInfo.nHeight < MINIMAGESIZE) then Exit;
    Result := True;
  end;
end;

function TWMM2ZipImages.CopyDataToTexture(index: Integer; Texture: TDXImageTexture): Boolean;
var
  nPosition: Integer;
  ImgInfo: TWZImageInfo;
  inBuffer, outBuffer: PChar;
  {outSize, }nLen: Integer;
begin
  Result := False;
  if (index < 0) or (index >= FImageCount) or (Texture = nil) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    FFileStream.Read(ImgInfo, SizeOf(ImgInfo));
    if (ImgInfo.DXInfo.nWidth > MAXIMAGESIZE) or (ImgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (ImgInfo.DXInfo.nWidth < MINIMAGESIZE) or (ImgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    Fbo16bit := ImgInfo.BitMode = 5;
    if Fbo16bit then begin
      nLen := WidthBytes(16, ImgInfo.DXInfo.nWidth);
      //ReadSize := nLen * ImgInfo.DXInfo.nHeight;
    end else begin
      nLen := WidthBytes(8, ImgInfo.DXInfo.nWidth);
      //ReadSize := nLen * ImgInfo.DXInfo.nHeight;
    end;
    if (ImgInfo.nZipSize <= 0) then
      exit;
    GetMem(inBuffer, ImgInfo.nZipSize);
    outBuffer := nil;
    try
      if FFileStream.Read(inBuffer^, ImgInfo.nZipSize) = ImgInfo.nZipSize then begin
        {outSize := }ZIPDecompress(inBuffer, ImgInfo.nZipSize, 0, outBuffer);
        FLastImageInfo := ImgInfo.DXInfo;
        Texture.Active := False;
        Texture.Format := D3DFMT_A1R5G5B5;
        Texture.Size := Point(ImgInfo.DXInfo.nWidth, ImgInfo.DXInfo.nHeight);
        Texture.PatternSize := Point(ImgInfo.DXInfo.nWidth, ImgInfo.DXInfo.nHeight);
        Texture.Active := True;
        Result := CopyImageDataToTexture(outBuffer, Texture, nLen, ImgInfo.DXInfo.nHeight);
        FreeMem(outBuffer);
      end;
    finally
      FreeMem(inBuffer);
    end;
  end;
end;
{$ENDIF}

function TWMM2ZipImages.CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      if Fbo16bit then begin
        FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
        for Y := 0 to Height - 1 do begin
          WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
          ReadBuffer := @Buffer[(Height - 1 - Y) * Width];
          LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Texture.Width);
        end;
      end else begin
        FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
        WriteBuffer := Pointer(Integer(Access.Bits));
        ReadBuffer := @Buffer[(Height - 1) * Width];
        for Y := 0 to Height - 1 do begin
          LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Texture.Width);
          Inc(WriteBuffer, Access.Pitch);
          Dec(ReadBuffer, Width);
        end;
      end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;

constructor TWMM2ZipImages.Create;
begin
  inherited;
  FReadOnly := True;
end;

procedure TWMM2ZipImages.Finalize;
begin
  inherited;
end;

function TWMM2ZipImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WZX';
    LoadIndex(FIdxFile);
    InitializeTexture;
  end;
end;

procedure TWMM2ZipImages.LoadDxImage(index: Integer; position: Integer; pDXTexture: pTDXTextureSurface);
var
  ImgInfo: TWZImageInfo;
  inBuffer, outBuffer: PChar;
  nLen, ReadSize: Integer;
begin
  pDXTexture.boNotRead := True;
  if FFileStream.Seek(position, 0) = position then begin;
    FFileStream.Read(ImgInfo, SizeOf(ImgInfo));
    if (ImgInfo.DXInfo.nWidth > MAXIMAGESIZE) or (ImgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (ImgInfo.DXInfo.nWidth < MINIMAGESIZE) or (ImgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    Fbo16bit := ImgInfo.BitMode = 5;
    if Fbo16bit then begin
      nLen := WidthBytes(16, ImgInfo.DXInfo.nWidth);
      ReadSize := ImgInfo.DXInfo.nWidth * ImgInfo.DXInfo.nHeight * 2;
    end else begin
      nLen := WidthBytes(8, ImgInfo.DXInfo.nWidth);
      ReadSize := ImgInfo.DXInfo.nWidth * ImgInfo.DXInfo.nHeight;
    end;
    if (ImgInfo.nZipSize > 0) then begin //Ñ¹ËõµÄÎÆÀí
      GetMem(inBuffer, ImgInfo.nZipSize);
      outBuffer := nil;
      try
        if FFileStream.Read(inBuffer^, ImgInfo.nZipSize) = ImgInfo.nZipSize then begin
          ZIPDecompress(inBuffer, ImgInfo.nZipSize, 0, outBuffer);
          pDXTexture.Surface := MakeDXImageTexture(ImgInfo.DXInfo.nWidth, ImgInfo.DXInfo.nHeight, WilFMT_A1R5G5B5);
          if pDXTexture.Surface <> nil then begin
            if not CopyImageDataToTexture(outBuffer, pDXTexture.Surface, nLen, ImgInfo.DXInfo.nHeight) then
            begin
              pDXTexture.Surface.Free;
              pDXTexture.Surface := nil;
            end
            else begin
              pDXTexture.boNotRead := False;
              pDXTexture.nPx := ImgInfo.DXInfo.px;
              pDXTexture.nPy := ImgInfo.DXInfo.py;
            end;
          end;
          FreeMem(outBuffer);
        end;
      finally
        FreeMem(inBuffer);
      end;
    end else begin //Î´Ñ¹ËõµÄÎÆÀí
      outBuffer := nil;
      GetMem(outBuffer, ReadSize);
      FFileStream.Read(outBuffer^, ReadSize);
      try
        pDXTexture.Surface := MakeDXImageTexture(ImgInfo.DXInfo.nWidth, ImgInfo.DXInfo.nHeight, WilFMT_A1R5G5B5);
        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(outBuffer, pDXTexture.Surface, nLen, ImgInfo.DXInfo.nHeight) then
          begin
            pDXTexture.Surface.Free;
            pDXTexture.Surface := nil;
          end
          else begin
            pDXTexture.boNotRead := False;
            pDXTexture.nPx := ImgInfo.DXInfo.px;
            pDXTexture.nPy := ImgInfo.DXInfo.py;
          end;
        end;
      finally
        FreeMem(outBuffer);
      end;
    end;
  end;
end;

procedure TWMM2ZipImages.LoadIndex(idxfile: string);
var
  F, i, value: Integer;
  pvalue: PInteger;
begin
  FIndexList.Clear;
  FImageCount := 0;
  if FileExists(idxfile) then begin
    F := FileOpen(idxfile, fmOpenRead or fmShareDenyNone);
    if F > 0 then begin
      FileSeek(F, 0, 0);
      FileRead(F, FIdxHeader, sizeof(TWZIndexHeader));
      if FIdxHeader.IndexCount > MAXIMAGECOUNT then exit;
      GetMem(pvalue, 4 * FIdxHeader.IndexCount);
      if FileRead(F, pvalue^, 4 * FIdxHeader.IndexCount) = (4 * FIdxHeader.IndexCount) then begin
        for i := 0 to FIdxHeader.IndexCount - 1 do begin
          value := PInteger(Integer(pvalue) + 4 * i)^;
          FIndexList.Add(pointer(value));
        end;
      end;
      FreeMem(pvalue);
      FileClose(F);
    end;
    FImageCount := FIndexList.Count;
  end;
end;

end.
