unit wmM2Zip;

interface
uses
  Windows, Classes, Graphics, SysUtils, DirectX, HGETextures, WIL;

type
  TWZIndexHeader = packed record
    Title: string[43];
    IndexCount: Integer;
  end;
  PTWZIndexHeader = ^TWZIndexHeader;

  TWZImageInfo = record
    Encode: Byte;
    unKnow1: array [0 .. 2] of Byte;
    DXInfo: TDXTextureInfo;
    nSize: Integer;
  end;
  PTWZImageInfo = ^TWZImageInfo;


  TWMM2ZipImages = class(TWMBaseImages)
  private
    FIdxHeader: TWZIndexHeader;
    Fbo16bit: Boolean;
    function CopyImageDataToTexture(Buffer: PAnsiChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
  protected
    procedure LoadIndex(idxfile: string); override;
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); override;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Initialize(): Boolean; override;
    procedure SynchronizeProcessImagesWrite(nIndex:Integer; pData:PBYTE; dwTrans:LongWord); override;
    procedure SynchronizeProcessImagesHeadNotFound(nIndex:Integer); override;
    procedure Finalize; override;
  end;
  function ExtractFileNameOnly(const fname: string): string;
implementation

{ TWMM2ZipImages }
 function ExtractFileNameOnly(const fname: string): string;
var
  extpos: Integer;
  ext, fn: string;
begin
  ext := ExtractFileExt(fname);
  fn := ExtractFileName(fname);
  if ext <> '' then
  begin
    extpos := Pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end
  else
    Result := fn;
end;

function TWMM2ZipImages.CopyImageDataToTexture(Buffer: PAnsiChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PAnsiChar;
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

procedure TWMM2ZipImages.SynchronizeProcessImagesHeadNotFound(nIndex:Integer);
begin
  FDxTextureArr[nIndex].boUpdate:= True;
  FDxTextureArr[nIndex].boNotRead:= True;
end;

procedure TWMM2ZipImages.SynchronizeProcessImagesWrite(nIndex:Integer; pData:PBYTE; dwTrans:LongWord);
var
  nOffset, nWrite:Integer;
  nPos, nIdxOffset:Integer;
  pBytes: PByte;
  Info:TWZImageInfo;
  pInfo:pTWZImageInfo;
  pIndexData:PAnsiChar;
begin
  WaitForSingleObject(g_hMutexShareReadWrite, INFINITE);
  if not FDxTextureArr[nIndex].boUpdate then begin
    pInfo:= pTWZImageInfo(pData);
    if pInfo.nSize > 0 then begin
      GetMem(pBytes, pInfo.nSize);
      nWrite:= pInfo.nSize;
    end else begin
      nWrite:= sizeof(TWZImageInfo);
      GetMem(pBytes, nWrite);
    end;

    FDxTextureArr[nIndex].boLoading:= True;
    nPos:= FFileStream.Seek(0, soEnd);
    nIdxOffset:= DEFAULTIDXHEADSIZE + nIndex * 4;
    FIndexStream.Seek(nIdxOffset, soBeginning);
    FIndexStream.WriteBuffer(nPos, sizeof(Integer));
    FIndexList[nIndex]:= pointer(nPos);
    FreeMem(pBytes);

    nOffset:= Integer(FIndexList[nIndex]);
    if nOffset <> 0 then begin
      FFileStream.Seek(nOffset, soBeginning);
      FFileStream.WriteBuffer(pData^, dwTrans);
      FDxTextureArr[nIndex].boNotRead:= False;
      FDxTextureArr[nIndex].boUpdate:= True;
      FDxTextureArr[nIndex].boLoading:= False;
    end;
  end;
  ReleaseMutex(g_hMutexShareReadWrite);
end;

procedure TWMM2ZipImages.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
var
  imginfo: TWZImageInfo;
  inBuffer, outBuffer: PAnsiChar;
  {outSize, }nLen, ReadSize: Integer;
begin
  if (FFileStream.Seek(position, 0) = position) and (position <> 0) then begin
    FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    Fbo16bit := imginfo.Encode = 5;
    if Fbo16bit then begin
      nLen := WidthBytes(16, imginfo.DXInfo.nWidth);
      ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end else begin
      nLen := WidthBytes(8, imginfo.DXInfo.nWidth);
      ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end;
    if (imginfo.nSize <= 0) then begin
      //2014.09.25 是否是未压缩位图
      if (imginfo.DXInfo.nWidth <> 0) and (imginfo.DXInfo.nHeight <> 0) then begin
        //处理未压缩资源
        GetMem(inBuffer, ReadSize);
        try
          if FFileStream.Read(inBuffer^, ReadSize) = ReadSize then begin
            pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight, WILFMT_A1R5G5B5);
            if pDXTexture.Surface <> nil then begin
              if not CopyImageDataToTexture(inBuffer, pDXTexture.Surface, nLen, imginfo.DXInfo.nHeight) then begin
                pDXTexture.Surface.Free;
                pDXTexture.Surface := nil;
              end else begin
                pDXTexture.boNotRead := False;
                pDXTexture.nPx := imginfo.DXInfo.px;
                pDXTexture.nPy := imginfo.DXInfo.py;
              end;
            end;
          end;
        finally
          FreeMem(inBuffer);
        end;
      end;
      exit;
    end;
    GetMem(inBuffer, imginfo.nSize);
    outBuffer := nil;
    try
      if FFileStream.Read(inBuffer^, imginfo.nSize) = imginfo.nSize then begin
        if inBuffer^ <> '' then begin

          ZIPDecompress(inBuffer, imginfo.nSize, 0, outBuffer);
          pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight, WILFMT_A1R5G5B5);
          if pDXTexture.Surface <> nil then begin
            if not CopyImageDataToTexture(outBuffer, pDXTexture.Surface, nLen, imginfo.DXInfo.nHeight) then
            begin
              pDXTexture.Surface.Free;
              pDXTexture.Surface := nil;
            end
            else begin
              pDXTexture.boNotRead := False;
              pDXTexture.nPx := imginfo.DXInfo.px;
              pDXTexture.nPy := imginfo.DXInfo.py;
            end;
          end;
        end;
        FreeMem(outBuffer);
      end;
    finally
      FreeMem(inBuffer);
    end;
  end;
end;

procedure TWMM2ZipImages.LoadIndex(idxfile: string);
var
  i, value: integer;
  pvalue: PInteger;
begin
  FIndexList.Clear;
  FImageCount := 0;
  if FileExists(idxfile) then begin
    if FIndexStream = nil then
      FIndexStream := TFileStream.Create(FIdxFile, fmOpenReadWrite or fmShareDenyNone);
    if FIndexStream <> nil then begin
      FIndexStream.Seek(0, 0);
      FIndexList.Clear;
      FIndexStream.Read(FIdxHeader, sizeof(TWZIndexHeader));
      if FIdxHeader.IndexCount > MAXIMAGECOUNT then exit;
      GetMem(pvalue, 4 * FIdxHeader.IndexCount);
      if FIndexStream.Read(pvalue^, 4 * FIdxHeader.IndexCount) = (4 * FIdxHeader.IndexCount) then begin
        for i := 0 to FIdxHeader.IndexCount - 1 do begin
          value := PInteger(integer(pvalue) + 4 * i)^;
          FIndexList.Add(pointer(value));
        end;
      end;
      FreeMem(pvalue);
    end;
    FImageCount := FIndexList.Count;
    if FImageCount <> 0 then begin
      FInitialize := True;
      FUpdateFileHead:=FInitialize;
    end;
  end;
end;

destructor TWMM2ZipImages.Destroy;
begin
  inherited;
end;

end.
