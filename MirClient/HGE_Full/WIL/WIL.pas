﻿Unit WIL;

interface
uses
  Windows, Classes, Graphics, SysUtils, DirectXGraphics, HGETextures, HUtil32, ZLIB, HGECanvas, GList, HashList, Wilpion;

{$INCLUDE BitChange.inc}

type
  TWILColorFormat = (WILFMT_A4R4G4B4, WILFMT_A1R5G5B5, WILFMT_R5G6B5, WILFMT_A8R8G8B8);

const
  MAXIMAGECOUNT = 10000000;
  MINIMAGESIZE = 2;
  MAXIMAGESIZE = 2048;
  //位移宽高，进行加密
  //图像最大宽高不能大于 4095 不然会出错，要修改位移时的处理

  FILETYPE_IMAGE = $1F; //图像文件
  FILETYPE_DATA = $2F; //数据文件
  FILETYPE_WAVA = $3F; //WAVA文件
  FILETYPE_MP3 = $4F; //MP3文件

  ColorFormat: array[TWILColorFormat] of TD3DFormat = (D3DFMT_A4R4G4B4, D3DFMT_A1R5G5B5, D3DFMT_R5G6B5, D3DFMT_A8R8G8B8);
  g_dwLoadSurfaceTime = 60 * 1000;
  g_dwLoadSurfaceTime4 = g_dwLoadSurfaceTime * 3;
type
  //TColorEffect = (ceNone,ceGrayScale1, ceGrayScale, ceBright, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);
  TDataType = (dtAll, dtMusic, dtData, dtMP3, dtWav);

  TLibType = (ltLoadBmp, ltUseCache, ltFileData);

  TWILType = (t_wmM2Def, t_wmM2Def16, t_wmM2wis, t_wmMyImage,t_wmM2Zip);

  TZIPLevel = 0..9;

  pTDXTextureSurface = ^TDXTextureSurface;
  TDXTextureSurface = packed record
    nPx: SmallInt;
    nPy: SmallInt;
    Surface: TDXImageTexture;
    dwLatestTime: LongWord;
    boNotRead: Boolean;
  end;

  TDXTextureInfo = record
    nWidth: Word;
    nHeight: Word;
    px: smallint;
    py: smallint;
  end;
  pTDXTextureInfo = ^TDXTextureInfo;

 TDxImage = record
    ColorCount: integer;
    nHandle: THandle;
    nW: SmallInt;
    nH: SmallInt;
    Surface: TDXImageTexture;
    dwLatestTime: LongWord;
    boNotRead: Boolean;
  end;
  PTDxImage = ^TDxImage;
  TDxImageArr = array[0..MaxListSize div 4] of TDxImage;
  PTDxImageArr = ^TDxImageArr;

  TWMBaseImages = class
  private
    FAutoFreeMemorys: Boolean;
    FAutoFreeMemorysTick: LongWord;
    FAutoFreeMemorysTime: LongWord;
    FFreeSurfaceTick: LongWord;
    FWILType: TWILType;
     FAppr:Word;
    function GetImageSurface(index: integer): TDXImageTexture;
{$IFDEF WORKFILE}
    function GetImageBitmap(index: integer; out btType: Byte): TBitmap;
{$ENDIF}
    function GetMemoryStream(index: integer): TMemoryStream;
  protected
    FLibType: TLibType;
    FBoChangeAlpha: Boolean;
    FSurfaceCount: Integer;
{$IFDEF WORKFILE}
    FLastImageInfo: TDXTextureInfo;
    FLastColorFormat: TWILColorFormat;
{$ENDIF}
    FFileName: string;
    FPassword: string;
    //FFormatName: string;
    FInitialize: Boolean;
    FImageCount: integer;
    FReadOnly: Boolean;
    FboEncryVer: Boolean;
    FFileStream: TFileStream; //文件流
    FDxTextureArr: array of TDXTextureSurface;

{$IFDEF WORKFILE}
    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; dynamic;
{$ENDIF}
    function InitializeTexture(): Boolean;
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); dynamic;
    function GetStream(index: integer): TMemoryStream; dynamic;
    function GetFormatBitLen(AFormat: TWILColorFormat): Byte;
  public
    FIndexList: TList;
    m_DefMainPalette: TRgbQuads;
    constructor Create(); dynamic;
    destructor Destroy; override;

    function Initialize(): Boolean; dynamic;
    procedure Finalize; dynamic;
    procedure ClearCache;
    procedure FreeTexture;
    procedure FreeTextureByTime;
    function GetDataStream(index: Integer; DataType: TDataType): TMemoryStream; dynamic;

    function GetCachedImage(index: integer; var px, py: integer): TDXImageTexture;

{$IFDEF WORKFILE}
    function CanDrawData(index: Integer): Boolean; dynamic;
    procedure DrawZoom(paper: TCanvas; x, y, index: integer; zoom: Real);
    procedure DrawZoomEx(paper: TCanvas; x, y, index: integer; zoom: Real; leftzero: Boolean);
    function CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean; dynamic;
    function GetDataType(index: Integer): Integer; dynamic;
    property Bitmap[index: integer; out btType: Byte]: TBitmap read GetImageBitmap;

    procedure AddIndex(nIndex, nOffset: Integer); dynamic;
    function SaveIndexList(): Boolean; dynamic;
    property LastImageInfo: TDXTextureInfo read FLastImageInfo;
    property LastColorFormat: TWILColorFormat read FLastColorFormat;
    property FileStream: TFileStream read FFileStream;
{$ENDIF}

    property boInitialize: Boolean read FInitialize;
    property ImageCount: integer read FImageCount;
    property FileName: string read FFileName write FFileName;
    property Password: string read FPassword write FPassword;
    property LibType: TLibType read FLibType write FLibType;
    property EncryVer: Boolean read FboEncryVer;
    property SurfaceCount: Integer read FSurfaceCount;
//    property ChangeAlpha: Boolean read FBoChangeAlpha write FBoChangeAlpha;
    //property FormatName: string read FFormatName;
    property ReadOnly: Boolean read FReadOnly;
    property Images[index: integer]: TDXImageTexture read GetImageSurface;
    property Files[index: integer]: TMemoryStream read GetMemoryStream;

    property AutoFreeMemorys: Boolean read FAutoFreeMemorys write FAutoFreeMemorys;
    property AutoFreeMemorysTick: LongWord read FAutoFreeMemorysTick write FAutoFreeMemorysTick;
    property FreeSurfaceTick: LongWord read FFreeSurfaceTick write FFreeSurfaceTick;

    property WILType: TWILType read FWILType write FWILType;
        property Appr:Word read FAppr write FAppr;
  end;

  TWMImages = TWMBaseImages;

 TUIBImages = class(TWMBaseImages)
  private
    FHeader: TDXImage;  //修正支持16图片
    Fbo16bit: Boolean;   //修正支持16图片
    FSearchPath: string;
    FSearchFileExt: string;
    FSearchSubDir: Boolean;
    procedure UiLoadDxImage(pdximg: PTDxImage; sFileName: string);
    function FUiGetImageSurface(F: string):TDXImageTexture;
    function CopyImageDataToTexture(Bitmap: TBitmap; Texture: TDXImageTexture; Width, Height: Word): Boolean;
  public
    m_FileList: THStringList;
    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure ClearCache;
    function UiGetCachedSurface(F: string): PTDxImage;
    property Images[F: string]: TDXImageTexture read FUiGetImageSurface;
    procedure GetUibFileList(Path, ext: string);
    procedure RecurSearchFile(Path, FileType: string);
  published
    property SearchPath: string read FSearchPath write FSearchPath;
    property SearchFileExt: string read FSearchFileExt write FSearchFileExt;
    property SearchSubDir: Boolean read FSearchSubDir write FSearchSubDir default False;
    property LibType: TLibType read FLibType write FLibType default ltUseCache;
  end;

  procedure LineX8_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
  procedure LineR5G6B5_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
  function CreateWMImages(WILType: TWILType): TWMBaseImages;
  function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PChar): Integer;
  function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PChar): Integer;
  function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWILColorFormat; DrawCanvas: TDXDrawCanvas = nil): TDXImageTexture;
  function WidthBytes(nBit, nWidth: Integer): Integer;
  //function WidthBytes16(w: Integer): Integer;

implementation

uses
  wmM2Def, wmM2Wis, wmMyImage, wmM2Zip;

function WidthBytes(nBit, nWidth: Integer): Integer;
begin
  Result := (((nWidth * nBit) + 31) shr 5) * 4;
end;

function CreateWMImages(WILType: TWILType): TWMBaseImages;
begin
  Result := nil;
  case WILType of
    t_wmM2Def: Result := TWMM2DefImages.Create; //*.Wil
    t_wmM2Def16: Result := TWMM2DefBit16Images.Create; //*_16.wil
    t_wmM2wis: Result := TWMM2WisImages.Create; //*.Wis
    t_wmMyImage: Result := TWMMyImageImages.Create; //*.Pak
    t_wmM2Zip: Result := TWMM2ZipImages.Create; //*.Wzl
  end;
  if Assigned(Result) then
    Result.WILType := WILType;
end;

function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise ECompressionError.Create('ZIP Error'); //!!
end;

function DCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise EDecompressionError.Create('ZIP Error'); //!!
end;

function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PChar): Integer;
var
  strm: TZStreamRec;
  P: Pointer;
begin
  FillChar(strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  Result := ((InBytes + (InBytes div 10) + 12) + 255) and not 255;
  GetMem(OutBuf, Result);
  try
    strm.next_in := InBuf;
    strm.avail_in := InBytes;
    strm.next_out := OutBuf;
    strm.avail_out := Result;
    CCheck(deflateInit_(strm, Level, zlib_version, sizeof(strm)));
    try
      while CCheck(deflate(strm, Z_FINISH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, 256);
        ReallocMem(OutBuf, Result);
        strm.next_out := PChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        strm.avail_out := 256;
      end;
    finally
      CCheck(deflateEnd(strm));
    end;
    ReallocMem(OutBuf, strm.total_out);
    Result := strm.total_out;
  except
    FreeMem(OutBuf);
    OutBuf := nil;
    //raise
  end;
end;

function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PChar): Integer;
var
  strm: TZStreamRec;
  P: Pointer;
  BufInc: Integer;
begin
  FillChar(strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  BufInc := (InBytes + 255) and not 255;
  if OutEstimate = 0 then
    Result := BufInc
  else
    Result := OutEstimate;
  GetMem(OutBuf, Result);
  try
    strm.next_in := InBuf;
    strm.avail_in := InBytes;
    strm.next_out := OutBuf;
    strm.avail_out := Result;
    DCheck(inflateInit_(strm, zlib_version, sizeof(strm)));
    try
      while DCheck(inflate(strm, Z_FINISH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, BufInc);
        ReallocMem(OutBuf, Result);
        strm.next_out := PChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        strm.avail_out := BufInc;
      end;
    finally
      DCheck(inflateEnd(strm));
    end;
    ReallocMem(OutBuf, strm.total_out);
    Result := strm.total_out;
  except
    FreeMem(OutBuf);
    OutBuf := nil;
    //raise
  end;
end;

procedure LineR5G6B5_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
begin
  asm
    push esi
    push edi
    push ebx
    push edx

    mov esi, Source
    mov edi, Dest
    mov ecx, Count
    lea edx, R5G6B5_A1R5G5B5

  @pixloop:
    movzx eax, [esi].Word
    add esi, 2

    shl eax, 1
    mov ax, [edx+eax].word

    mov [edi], ax
    add edi, 2

    dec ecx
    jnz @pixloop

    pop edx
    pop ebx
    pop edi
    pop esi
  end;
end;

procedure LineX8_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
begin
  asm
    push esi
    push edi
    push ebx
    push edx

    mov esi, Source
    mov edi, Dest
    mov ecx, Count
    lea edx, X8_A1R5G5B5

  @pixloop:
    movzx eax, [esi].byte
    add esi, 1

    shl eax, 1
    mov ax, [edx+eax].word

    mov [edi], ax
    add edi, 2

    dec ecx
    jnz @pixloop

    pop edx
    pop ebx
    pop edi
    pop esi
  end;
end;

{ TWMBaseImages }

constructor TWMBaseImages.Create;
begin
  inherited;
  FInitialize := False;
  FImageCount := 0;
  FFileName := '';
  FReadOnly := True;
  FAutoFreeMemorys := True;
  FAutoFreeMemorysTick := 60 * 1000;
  FFreeSurfaceTick := 60 * 1000;
  FAutoFreeMemorysTime := GetTickCount;
  FFileStream := nil;
  FDxTextureArr := nil;
  FIndexList := TList.Create;
  //FBoChangeAlpha := False;
  FSurfaceCount := 0;
  FPassword := '';
  FboEncryVer := False;
  //FFormatName := '未知';
{$IFDEF WORKFILE}
  SafeFillChar(FLastImageInfo, SizeOf(FLastImageInfo), #0);
{$ENDIF}
  FLibType := ltUseCache;
end;

procedure TWMBaseImages.FreeTexture;
var
  i: integer;
begin
  if FDxTextureArr <> nil then
    for I := 0 to High(FDxTextureArr) do begin
      if FDxTextureArr[I].Surface <> nil then begin
        FDxTextureArr[I].Surface.Free;
        FDxTextureArr[I].Surface := nil;
      end;
    end;
  FSurfaceCount := 0;
end;

procedure TWMBaseImages.FreeTextureByTime;
var
  i: integer;
begin
  if FDxTextureArr <> nil then
    for I := 0 to High(FDxTextureArr) do begin
      if (FDxTextureArr[I].Surface <> nil) and (GetTickCount - FDxTextureArr[I].dwLatestTime > FFreeSurfaceTick) then begin
        if FSurfaceCount > 0 then
          Dec(FSurfaceCount);
        FDxTextureArr[I].Surface.Free;
        FDxTextureArr[I].Surface := nil;
      end;
    end;
end;

destructor TWMBaseImages.Destroy;
begin
  Finalize;
  FDxTextureArr := nil;
  FIndexList.Free;
  inherited;
end;

function TWMBaseImages.GetCachedImage(index: integer; var px, py: integer): TDXImageTexture;
begin
  Result := nil;
  if (index < 0) or (index >= FImageCount) or (FLibType <> ltUseCache) or (not FInitialize) then
    exit;
  if (index < FIndexList.Count) and (index <= High(FDxTextureArr)) then begin
    if (FDxTextureArr[index].Surface = nil) and (not FDxTextureArr[index].boNotRead) then begin
      try
        LoadDxImage(index, Integer(FIndexList[index]), @FDxTextureArr[index]);
        if FDxTextureArr[index].Surface <> nil then
          Inc(FSurfaceCount);
      except
        FDxTextureArr[index].Surface := nil;
        FDxTextureArr[index].boNotRead := True;
      end;
    end;
    Result := FDxTextureArr[index].Surface;
    px := FDxTextureArr[index].nPx;
    py := FDxTextureArr[index].nPy;
    FDxTextureArr[index].dwLatestTime := GetTickCount;
  end;
  if AutoFreeMemorys and (GetTickCount > FAutoFreeMemorysTime) then begin
    FAutoFreeMemorysTime := GetTickCount + FAutoFreeMemorysTick;
    FreeTextureByTime;
  end;
end;

function TWMBaseImages.GetDataStream(index: Integer; DataType: TDataType): TMemoryStream;
begin
  Result := nil;
end;

procedure TWMBaseImages.Finalize;
begin
  FInitialize := False;
  FreeTexture;
  FDxTextureArr := nil;
  FSurfaceCount := 0;
  if FFileStream <> nil then
    FFileStream.Free;
  FFileStream := nil;
end;
procedure TWMBaseImages.ClearCache;
var
  i: Integer;
begin
  if FDxTextureArr <> nil then
    for i := 0 to High(FDxTextureArr) do
    begin
      if FDxTextureArr[i].Surface <> nil then
      begin
        FDxTextureArr[i].Surface.Free;
        FDxTextureArr[i].Surface := nil;
      end;
    end;
  FSurfaceCount := 0;
end;
function TWMBaseImages.GetImageSurface(index: integer): TDXImageTexture;
var
  px, py: Integer;
begin
  Result := GetCachedImage(index, px, py);
end;

function TWMBaseImages.GetMemoryStream(index: integer): TMemoryStream;
begin
  Result := GetStream(index);
end;

function TWMBaseImages.GetStream(index: integer): TMemoryStream;
begin
  Result := nil;
end;

function TWMBaseImages.GetFormatBitLen(AFormat: TWILColorFormat): Byte;
begin
  if AFormat in [WILFMT_A4R4G4B4, WILFMT_A1R5G5B5, WILFMT_R5G6B5] then
    Result := 2
  else
    Result := 4;
end;

function TWMBaseImages.Initialize: Boolean;
begin
  Result := False;
  if (FFileName = '') or FInitialize or (FFileStream <> nil) or (not FileExists(FFileName)) then
    exit;
{$IFDEF WORKFILE}
  if FReadOnly then
    FFileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone)
  else
    FFileStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyNone);
{$ELSE}
  FFileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
{$ENDIF}
  Result := FFileStream <> nil;
  FInitialize := Result;
  if Result then begin
    FreeTexture;
    FDxTextureArr := nil;
    FSurfaceCount := 0;
  end;
end;

function TWMBaseImages.InitializeTexture: Boolean;
begin
  Result := False;
  FDxTextureArr := nil;
  if (not FInitialize) or (FImageCount <= 0) or (LibType <> ltUseCache) then
    exit;
  SetLength(FDxTextureArr, FImageCount);
  FillChar(FDxTextureArr[0], FImageCount * SizeOf(TDXTextureSurface), #0);
  Result := True;
end;

procedure TWMBaseImages.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
begin
  if pDXTexture.Surface <> nil then
    pDXTexture.Surface.Free;
  pDXTexture.Surface := nil;
  pDXTexture.boNotRead := True;
end;

function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWILColorFormat; DrawCanvas: TDXDrawCanvas): TDXImageTexture;
{ function GetSize(nOldSize: Word): Word;
 begin
   if nOldSize < 2 then begin
     Result := 2;
   end else
   if nOldSize < 4 then begin
     Result := 4;
   end else
   if nOldSize < 8 then begin
     Result :=8;
   end else
   if nOldSize < 16 then begin
     Result := 16;
   end else
   if nOldSize < 32 then begin
     Result := 32;
   end else
   if nOldSize < 64 then begin
     Result := 64;
   end else
   if nOldSize < 128 then begin
     Result := 128;
   end else
   if nOldSize < 256 then begin
     Result := 256;
   end else
   if nOldSize < 512 then begin
     Result := 512;
   end else
   if nOldSize < 1024 then begin
     Result := 1024;
   end else
   if nOldSize < 2048 then begin
     Result := 2048;
   end;
 end;      }
begin
  Result := TDXImageTexture.Create;
  with Result do begin
    //Behavior := tbDynamic;
    //Size := Point(GetSize(nWidth), GetSize(nHeight));
    Size := Point(nWidth, nHeight);
    PatternSize := Point(nWidth, nHeight);
    Format := {D3DFMT_A4R4G4B4} ColorFormat[WILColorFormat];
    Active := True;
  end;
  if not Result.Active then begin
    Result.Free;
    Result := nil;
  end else begin
    Result.Canvas := DrawCanvas;
  end;
end;

//工作区-----------------------------------------------------------------------------------------------------------------
{$IFDEF WORKFILE}

function TWMBaseImages.CanDrawData(index: Integer): Boolean;
begin
  Result := False;
end;

procedure TWMBaseImages.DrawZoom(paper: TCanvas; x, y, index: integer; zoom: Real);
var
  rc: TRect;
  bmp: TBitmap;
  btType: Byte;
begin
  if LibType <> ltLoadBmp then exit;
  bmp := Self.Bitmap[index, btType];
  if bmp <> nil then begin
    rc.Left := x;
    rc.Top := y;
    rc.Right := x + Round(bmp.Width * zoom);
    rc.Bottom := y + Round(bmp.Height * zoom);
    if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
      paper.StretchDraw(rc, Bmp);
      //FreeBitmap(index);
    end;
    bmp.Free;
  end;
end;

procedure TWMBaseImages.DrawZoomEx(paper: TCanvas; x, y, index: integer; zoom: Real; leftzero: Boolean);
var
  rc: TRect;
  bmp, bmp2: TBitmap;
  btType: Byte;
begin
  if LibType <> ltLoadBmp then exit;
  bmp := Self.Bitmap[index, btType];
  if bmp <> nil then begin
    Bmp2 := TBitmap.Create;
    Bmp2.Width := Round(Bmp.Width * zoom);
    Bmp2.Height := Round(Bmp.Height * zoom);
    rc.Left := x;
    rc.Top := y;
    rc.Right := x + Round(bmp.Width * zoom);
    rc.Bottom := y + Round(bmp.Height * zoom);
    if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
      Bmp2.Canvas.StretchDraw(Rect(0, 0, Bmp2.Width, Bmp2.Height), Bmp);
      if leftzero then begin
        SpliteBitmap(paper.Handle, X, Y, Bmp2, $0)
      end
      else begin
        SpliteBitmap(paper.Handle, X, Y - Bmp2.Height, Bmp2, $0);
      end;
    end;
    bmp.Free;
    bmp2.Free;
  end;
end;

function TWMBaseImages.GetDataType(index: Integer): Integer;
begin
  Result := FILETYPE_IMAGE;
end;

function TWMBaseImages.SaveIndexList(): Boolean;
begin
  Result := False;
end;

function TWMBaseImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
end;

function TWMBaseImages.GetImageBitmap(index: integer; out btType: Byte): TBitmap;
begin
  Result := GetImageBitmapEx(index, btType);
end;

procedure TWMBaseImages.AddIndex(nIndex, nOffset: Integer);
begin
  if FReadOnly or (not FInitialize) or ((nIndex > -1) and (nIndex > FIndexList.Count)) then
    exit;
  if nIndex = -1 then
    FIndexList.Add(Pointer(nOffset))
  else
    FIndexList.Insert(nIndex, Pointer(nOffset));
  Inc(FImageCount);
end;

function TWMBaseImages.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
begin
  Result := False;
end;

{$ENDIF}
constructor TUIBImages.Create();
begin
  inherited;
  FSearchPath := '';
  FSearchFileExt := '*.uib';
  FFileName := '';
  FSearchSubDir := False;
  m_FileList := THStringList.Create;
  Fbo16bit := False;
end;

destructor TUIBImages.Destroy;
var
  i                 : Integer;
begin
  for i := 0 to m_FileList.count - 1 do
    FileClose(THandle(m_FileList.Objects[i]));
  m_FileList.Free;
  inherited Destroy;
end;


procedure TUIBImages.GetUibFileList(Path, ext: string);
var
  fhandle           : THandle;
  SearchRec         : TSearchRec;
  sPath, sFile      : string;
  PDxImage          : PTDxImage;
begin

  if Copy(Path, Length(Path), 1) <> '\' then
    sPath := Path + '\'
  else
    sPath := Path;

  if FindFirst(sPath + ext, faAnyFile, SearchRec) = 0 then begin
    fhandle := FileOpen(sPath + SearchRec.Name, fmOpenRead or fmShareDenyNone);
    New(PDxImage);
    FillChar(PDxImage^, SizeOf(TDxImage), 0);
    PDxImage.nHandle := fhandle;
    m_FileList.AddObject(sPath + SearchRec.Name, TObject(PDxImage));
    while True do begin
      if FindNext(SearchRec) = 0 then begin
        fhandle := FileOpen(sPath + SearchRec.Name, fmOpenRead or fmShareDenyNone);
        New(PDxImage);
        FillChar(PDxImage^, SizeOf(TDxImage), 0);
        PDxImage.nHandle := fhandle;
        m_FileList.AddObject(sPath + SearchRec.Name, TObject(PDxImage));
      end else begin
        SysUtils.FindClose(SearchRec);
        Break;
      end;
    end;
  end;
end;

procedure TUIBImages.RecurSearchFile(Path, FileType: string);
var
  sr                : TSearchRec;
  fhandle           : THandle;
  sPath, sFile      : string;
  PDxImage          : PTDxImage;
begin

  if Copy(Path, Length(Path), 1) <> '\' then
    sPath := Path + '\'
  else
    sPath := Path;

  if FindFirst(sPath + '*.*', faAnyFile, sr) = 0 then begin
    repeat
      sFile := Trim(sr.Name);
      if sFile = '.' then Continue;
      if sFile = '..' then Continue;
      sFile := sPath + sr.Name;
      if (sr.Attr and faDirectory) <> 0 then begin
        GetUibFileList(sFile, FileType);
      end else if (sr.Attr and faAnyFile) = sr.Attr then begin
        fhandle := FileOpen(sFile, fmOpenRead or fmShareDenyNone);
        New(PDxImage);
        FillChar(PDxImage^, SizeOf(TDxImage), 0);
        PDxImage.nHandle := fhandle;
        m_FileList.AddObject(sFile, TObject(PDxImage));
      end;
    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
end;

procedure TUIBImages.Initialize;
var
  IdxFile           : string;
begin
    Fbo16bit := FHeader.ColorCount = $10000; //修正支持16图片
    if DirectoryExists(FSearchPath) then begin
      if SearchSubDir then
        RecurSearchFile(FSearchPath, FSearchFileExt)
      else
        GetUibFileList(FSearchPath, FSearchFileExt);
      FImageCount := m_FileList.count;
    end else begin
      ForceDirectories(FSearchPath);
    end;
end;

procedure TUIBImages.ClearCache;
var
  i                 : Integer;
  pdi               : PTDxImage;
begin
  for i := 0 to m_FileList.count - 1 do begin
    pdi := PTDxImage(m_FileList.Objects[i]);
    pdi.nH := 0;
    pdi.nW := 0;
    if Assigned(pdi.Surface) then
      FreeAndNil(pdi.Surface);
  end;
end;

procedure TUIBImages.Finalize;
var
  i                 : Integer;
  pdi               : PTDxImage;
begin
  ClearCache();
  for i := 0 to m_FileList.count - 1 do begin
    pdi := PTDxImage(m_FileList.Objects[i]);
    Dispose(pdi);
  end;
  m_FileList.Clear;
  FImageCount := 0;
end;

procedure TUIBImages.UiLoadDxImage(pdximg: PTDxImage;  sFileName: string);
var
  Bitmap: TBitmap;
begin
  pdximg.boNotRead := True;
   if FileExists(sFileName) then begin
    Bitmap := TBitmap.Create;
    Try
      Bitmap.LoadFromFile(sFileName);
//      DebugOutStr('AFileName2: ' + sFileName);
      if (Bitmap.Width > 2) and (Bitmap.Height > 2)  then begin
        if (Bitmap.PixelFormat = pf8bit) then  begin  //修正支持16图片
         Fbo16bit := False;
        end else Fbo16bit := True;

        pdximg.Surface := MakeDXImageTexture(Bitmap.Width, Bitmap.Height,WILFMT_A1R5G5B5);
        if pdximg.Surface <> nil then begin
          if not CopyImageDataToTexture(Bitmap, pdximg.Surface, Bitmap.Width, Bitmap.Height) then
          begin
            pdximg.Surface.Free;
            pdximg.Surface := nil;
          end
          else begin
            pdximg.boNotRead := False;
            pdximg.nW := 0;
            pdximg.nH := 0;
          end;
        end;
      end;
    Finally
      Bitmap.Free;
    End;
  end;
end;
function TUIBImages.CopyImageDataToTexture(Bitmap: TBitmap; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PAnsiChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
     if Fbo16bit then begin   //16位
      FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      WriteBuffer := Pointer(Integer(Access.Bits));
      for Y := 0 to Height - 1 do begin
        ReadBuffer := Bitmap.ScanLine[Y];
        LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
        Inc(WriteBuffer, Access.Pitch);
      end;
     end else begin   //8位
      FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      WriteBuffer := Pointer(Integer(Access.Bits));
      for Y := 0 to Height - 1 do begin
        ReadBuffer := Bitmap.ScanLine[Y];
        LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
        Inc(WriteBuffer, Access.Pitch);
      end;
     end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;

function TUIBImages.UiGetCachedSurface(F: string): PTDxImage;
var
  Index             : Integer;
  fhandle           : THandle;
  PDxImage          : PTDxImage;
begin
  Result := nil;
  try
    Index := m_FileList.IndexOf(F);
    if Index >= 0 then begin
      Result := PTDxImage(m_FileList.Objects[Index]);
      if Result.nHandle <> INVALID_HANDLE_VALUE then begin
        Result.dwLatestTime := GetTickCount;
        if not Assigned(Result.Surface) then begin
          UiLoadDxImage(Result, F);
        end;
      end;
    end else begin
      New(PDxImage);
      FillChar(PDxImage^, SizeOf(TDxImage), 0);
      PDxImage.nHandle := INVALID_HANDLE_VALUE;
      FImageCount := m_FileList.AddObject(F, TObject(PDxImage));
    end;
  except
    Result := nil;
  end;
end;

function TUIBImages.FUiGetImageSurface(F: string): TDXImageTexture;
var
  PDxImage          : PTDxImage;
begin
  PDxImage := UiGetCachedSurface(F);
  if (PDxImage <> nil) and (PDxImage.Surface <> nil) then
    Result := PDxImage.Surface
  else
    Result := nil;
end;
end.