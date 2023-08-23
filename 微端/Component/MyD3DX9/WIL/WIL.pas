unit WIL;

interface
uses
  Windows, Classes, Graphics, SysUtils, DirectX, DirectXD3D9, HGETextures, ZLIB,
  HGECanvas;


{$INCLUDE BitChange.inc}

type
  TWILColorFormat = (WILFMT_A4R4G4B4, WILFMT_A1R5G5B5, WILFMT_R5G6B5, WILFMT_A8R8G8B8);

const
  MAXIMAGECOUNT = 10000000;
  MINIMAGESIZE = 2;
  MAXIMAGESIZE = 2048;
  DEFAULTWZLHEADSIZE  = 64;
  DEFAULTIDXHEADSIZE  = 48;

  FILETYPE_IMAGE = $1F;
  FILETYPE_DATA = $2F;
  FILETYPE_WAVA = $3F;
  FILETYPE_MP3 = $4F;

  UPDATEIMAGETIME   = 15000;

  ColorFormat: array[TWILColorFormat] of TD3DFormat = (D3DFMT_A4R4G4B4, D3DFMT_A1R5G5B5, D3DFMT_R5G6B5, D3DFMT_A8R8G8B8);

type
  PRGBQuads = ^TRGBQuads;
  TRGBQuads = array[0..255] of TRGBQuad;

  TColorEffect = (ceNone, ceGrayScale, ceLowGrayScale, ceBright, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);
  TDataType = (dtAll, dtMusic, dtData, dtMP3, dtWav);

  TLibType = (ltLoadBmp, ltUseCache, ltFileData);

  TWILType = (t_wmM2Def, t_wmM2wis, t_wmM2Zip, t_wmM3Zip);

  TZIPLevel = 0..9;

  pTDXTextureSurface = ^TDXTextureSurface;
  TDXTextureSurface = packed record
    nPx: SmallInt;
    nPy: SmallInt;
    Surface: TDXImageTexture;
    dwLatestTime: LongWord;
    boNotRead: Boolean;
    boLoading: Boolean;
    boUpdate:Boolean;
    nSize:Integer;
    nCurSize:Integer;
    liUpdateTime:LARGE_INTEGER;
  end;

  TDXTextureInfo = record
    nWidth: Word;
    nHeight: Word;
    px: smallint;
    py: smallint;
  end;
  pTDXTextureInfo = ^TDXTextureInfo;

  TWZIndexHeader = record
    Title: string[43];
    IndexCount: Integer;
  end;
  PTWZIndexHeader = ^TWZIndexHeader;


  TWMBaseImages = class;
  TOnInitializeImages = procedure(WMImages: TWMBaseImages) of object;
  TOnUpdateImages = procedure(WMImages: TWMBaseImages; nIndex: Integer) of object;

  TWMBaseImages = class
  private
    FAutoFreeMemorys: Boolean;
    FAutoFreeMemorysTick: LongWord;
    FAutoFreeMemorysTime: LongWord;
    FFreeSurfaceTick: LongWord;
    FWILType: TWILType;
    FUpdateHeadTime:LARGE_INTEGER;
    FOnUpdateImages: TOnUpdateImages;
    FOnInitializeImages:TOnInitializeImages;
    function GetImageSurface(index: integer): TDXImageTexture;
    function GetMemoryStream(index: integer): TMemoryStream;

  protected
    FLibType: TLibType;
    FBoChangeAlpha: Boolean;
    FSurfaceCount: Integer;
    FFileName: string;
    FPassword: string;
    FInitialize: Boolean;
    FUpdateFileHead:Boolean;
    FImageCount: integer;
    FReadOnly: Boolean;
    FboEncryVer: Boolean;
    FIdxFile: string;
    FFileStream: TFileStream;
    FIndexStream: TFileStream;
    m_csCriticalSection: TRTLCriticalSection;
    FDxTextureArr: array of TDXTextureSurface;
    function InitializeTexture(): Boolean;
    function CheckImagesDirectoryFiles:Boolean;
    procedure LoadIndex(idxfile: string); virtual; abstract;
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); dynamic;
    function GetStream(index: integer): TMemoryStream; dynamic;
    function GetFormatBitLen(AFormat: TWILColorFormat): Byte;
  public
    FIndexList: TList;
    m_dwRecogid:LongWord;             //微端服务器资源标识
    m_DefMainPalette: TRgbQuads;
    constructor Create(); dynamic;
    destructor Destroy; override;

    function Initialize(): Boolean; dynamic;
    procedure Finalize; dynamic;
    procedure FreeTexture;
    procedure FreeTextureByTime;

    procedure UpdateImageSize(nIndex, nSize:Integer);
    procedure SynchronizeProcessImagesWrite(nIndex:Integer; pData:PBYTE; dwTrans:LongWord); virtual;
    procedure SynchronizeProcessImagesHeadNotFound(nIndex:Integer); virtual;
    procedure SynchronizeProcessImagesHeadWrite(pData:PAnsiChar; nSize:Integer);
    function LoadImage(nImage:Integer):PAnsiChar; dynamic;
    function GetDataStream(index: Integer; DataType: TDataType): TMemoryStream; dynamic;
    function GetCachedImageEx(index: integer; var px, py: integer): TDXImageTexture;
    function GetCachedImage(index: integer; var px, py: integer): TDXImageTexture;
    property boInitialize: Boolean read FInitialize;
    property ImageCount: integer read FImageCount;
    property FileName: string read FFileName write FFileName;
    property Password: string read FPassword write FPassword;
    property LibType: TLibType read FLibType write FLibType;
    property EncryVer: Boolean read FboEncryVer;
    property SurfaceCount: Integer read FSurfaceCount;
    property ReadOnly: Boolean read FReadOnly;
    property Images[index: integer]: TDXImageTexture read GetImageSurface;
    property Files[index: integer]: TMemoryStream read GetMemoryStream;
    property OnUpdateImages: TOnUpdateImages read FOnUpdateImages write FOnUpdateImages;
    property OnInitializeImages: TOnInitializeImages read FOnInitializeImages write FOnInitializeImages;
    property AutoFreeMemorys: Boolean read FAutoFreeMemorys write FAutoFreeMemorys;
    property AutoFreeMemorysTick: LongWord read FAutoFreeMemorysTick write FAutoFreeMemorysTick;
    property FreeSurfaceTick: LongWord read FFreeSurfaceTick write FFreeSurfaceTick;

    property WILType: TWILType read FWILType write FWILType;
  end;

  TWMImages = TWMBaseImages;
  pTWMImages = ^TWMImages;

procedure LineX8_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
procedure LineR5G6B5_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
function CreateWMImages(WILType: TWILType): TWMBaseImages;
function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PAnsiChar): Integer;
function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PAnsiChar): Integer;
function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWILColorFormat; DrawCanvas: TDXDrawCanvas = nil): TDXImageTexture;
function WidthBytes(nBit, nWidth: Integer): Integer;

var
  g_hMutexShareReadWrite:THandle = 0;


implementation

uses
  wmM2Def, wmM2Zip;

var
  g_dbFrequency     : Double = 0;                                               //系统时钟
  g_liWzlStartTime     : LARGE_INTEGER;
  g_ImagesPath      : string;
  g_AppPath         : string;

function WidthBytes(nBit, nWidth: Integer): Integer;
begin
  Result := (((nWidth * nBit) + 31) shr 5) * 4;
end;

function CreateWMImages(WILType: TWILType): TWMBaseImages;
begin
  Result := nil;
  case WILType of
    t_wmM2Def: Result := TWMM2DefImages.Create;
    t_wmM2Zip: Result := TWMM2ZipImages.Create;
  end;
  if Assigned(Result) then
    Result.WILType := WILType;
end;

function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then begin
    raise ECompressionError.Create('ZIP Error');
  end;
end;

function DCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then begin
    raise EDecompressionError.Create('ZIP Error');
  end;
end;

function StringToStream(mString: string; mStream: TStream): Boolean;
{   返回将字符串保存到内存流是否成功   }
var
  I:   Integer;
begin
  Result:= True;
  try
    mStream.Size   :=   0;
    mStream.Position   :=   0;
    for I := 1 to Length(mString) do
      mStream.Write(mString[I], 1);
  except
    Result   :=   False;
  end;
end;

function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PAnsiChar): Integer;
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
    {$IF CompilerVersion >= 21.0}
    strm.next_out := PByte(OutBuf);
    {$ELSE}
    strm.next_out := OutBuf;
    {$IFEND}
    strm.avail_out := Result;
    CCheck(deflateInit_(strm, Level, zlib_version, sizeof(strm)));
    try
      while CCheck(deflate(strm, Z_FINISH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, 256);
        ReallocMem(OutBuf, Result);
        {$IF CompilerVersion >= 21.0}
        strm.next_out := PByte(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        {$ELSE}
        strm.next_out := PAnsiChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        {$IFEND}
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
  end;
end;

function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PAnsiChar): Integer;
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
    {$IF CompilerVersion >= 21.0}
    strm.next_out := PByte(OutBuf);
    {$ELSE}
    strm.next_out := OutBuf;
    {$IFEND}
    strm.avail_out := Result;
    DCheck(inflateInit_(strm, zlib_version, sizeof(strm)));
    try
      while DCheck(inflate(strm, Z_NO_FLUSH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, BufInc);
        ReallocMem(OutBuf, Result);
        {$IF CompilerVersion >= 21.0}
        strm.next_out := PByte(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        {$ELSE}
        strm.next_out := PAnsiChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        {$IFEND}
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
  end;
end;


{ TWMBaseImages }

constructor TWMBaseImages.Create;
begin
  inherited;
  FUpdateFileHead:= False;
  FInitialize := False;
  FImageCount := 0;
  FFileName := '';
  FReadOnly := True;
  m_dwRecogid:= 0;
  FAutoFreeMemorys := False;
  FAutoFreeMemorysTick := 10 * 1000;
  FFreeSurfaceTick := 60 * 1000;
  FAutoFreeMemorysTime := GetTickCount;
  FFileStream := nil;
  FDxTextureArr := nil;
  FIndexList := TList.Create;
  FSurfaceCount := 0;
  FPassword := '';
  FboEncryVer := False;
  FLibType := ltUseCache;
  InitializeCriticalSection(m_csCriticalSection);
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
        FDxTextureArr[I].boLoading:= False;
      end;
    end;
  FSurfaceCount := 0;
end;

procedure TWMBaseImages.FreeTextureByTime;
var
  i: integer;
begin
  if FDxTextureArr <> nil then begin
    for I := 0 to High(FDxTextureArr) do begin
      if (FDxTextureArr[I].Surface <> nil) and (GetTickCount - FDxTextureArr[I].dwLatestTime > FFreeSurfaceTick) then begin
        if FSurfaceCount > 0 then
          Dec(FSurfaceCount);
        FDxTextureArr[I].Surface.Free;
        FDxTextureArr[I].Surface := nil;
      end;
    end;
  end;
end;

destructor TWMBaseImages.Destroy;
begin
  Finalize;
  FDxTextureArr := nil;
  FIndexList.Free;
  if g_hMutexShareReadWrite <> 0 then begin
    CloseHandle(g_hMutexShareReadWrite);
    g_hMutexShareReadWrite:=0;
  end;
  DeleteCriticalSection(m_csCriticalSection);
  inherited;
end;

function TWMBaseImages.LoadImage(nImage:Integer):PAnsiChar;
begin
  Result:= nil;
end;

function TWMBaseImages.GetCachedImageEx(index: integer; var px, py: integer): TDXImageTexture;
begin
  Result := nil;
  if (index < 0) or (index >= FImageCount) or (FLibType <> ltUseCache) or (not FInitialize) then
    exit;
  if (index < FIndexList.Count) and (index <= High(FDxTextureArr)) then begin
    if (FDxTextureArr[index].Surface = nil) and (not FDxTextureArr[index].boNotRead) and (not FDxTextureArr[index].boLoading) then begin
      try
        LoadDxImage(index, Integer(FIndexList[index]), @FDxTextureArr[index]);
        if FDxTextureArr[index].Surface <> nil then
          Inc(FSurfaceCount);
      except
        FDxTextureArr[index].Surface := nil;
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

function TWMBaseImages.GetCachedImage(index: integer; var px, py: integer): TDXImageTexture;
var
  liQueryTime:LARGE_INTEGER;
begin
  Result:= nil;
  //进入互斥临界区
  WaitForSingleObject(g_hMutexShareReadWrite, INFINITE);
  //资源文件没有加载则退出
  if not FInitialize then begin
    WaitForSingleObject(g_hMutexShareReadWrite, INFINITE);
    if not CheckImagesDirectoryFiles then begin
      FFileStream := TFileStream.Create(FFileName, fmCreate or fmOpenReadWrite or fmShareDenyNone);
      FFileStream.Free;
      FFileStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyNone);
      FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.wzx';
      FIndexStream := TFileStream.Create(FIdxFile, fmCreate or fmOpenReadWrite or fmShareDenyNone);
      FIndexStream.Free;
      FIndexStream := TFileStream.Create(FIdxFile, fmOpenReadWrite or fmShareDenyNone);
    end;
    ReleaseMutex(g_hMutexShareReadWrite);
    //自动更新文件头
    if not FUpdateFileHead then begin
      QueryPerformanceCounter(Int64(liQueryTime));
      if (((liQueryTime.QuadPart - FUpdateHeadTime.QuadPart) / g_dbFrequency) >= UPDATEIMAGETIME) then begin
        if Assigned(FOnInitializeImages) then begin
          FOnInitializeImages(Self);
        end;
        FUpdateHeadTime.QuadPart:= liQueryTime.QuadPart;
      end;
    end;
  end else begin
    //在总数之间
    if (index >= 0) and (index < FImageCount) then begin
      //读取纹理列表
      Result := GetCachedImageEx(index, px, py);
      if (Result = nil) and (not FDxTextureArr[index].boUpdate) then begin
        //自动更新资源
        QueryPerformanceCounter(Int64(liQueryTime));
        if (((liQueryTime.QuadPart - FDxTextureArr[index].liUpdateTime.QuadPart) / g_dbFrequency) >= UPDATEIMAGETIME) then begin
          FDxTextureArr[index].liUpdateTime.QuadPart:= liQueryTime.QuadPart;
          if Assigned(FOnUpdateImages) then begin
            FOnUpdateImages(Self, index);
          end;
        end;
      end;
    end;
  end;
  ReleaseMutex(g_hMutexShareReadWrite);
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
  if FIndexStream <> nil then
    FIndexStream.Free;
  FIndexStream := nil;
end;

function TWMBaseImages.CheckImagesDirectoryFiles:Boolean;
var
  szPath:string;
begin
  Result:= False;
  szPath:= g_AppPath + FFileName;
  //检测文件是否存在
  if FileExists(szPath) then begin
    Result:= True;
  end;
end;

procedure TWMBaseImages.SynchronizeProcessImagesHeadNotFound(nIndex:Integer);
begin

end;

procedure TWMBaseImages.SynchronizeProcessImagesHeadWrite(pData:PAnsiChar; nSize:Integer);
var
  pIndexData:PAnsiChar;
  Idx:TWZIndexHeader;
begin
  //进入互斥临界区
  WaitForSingleObject(g_hMutexShareReadWrite, INFINITE);
  //检查资源目录是否有该资源文件。
  if CheckImagesDirectoryFiles then begin
    //文件不存在则创建文件并更新。
    Idx:= pTWZIndexHeader(pData)^;
    FFileStream.WriteBuffer(pData^, DEFAULTWZLHEADSIZE);
    FIndexStream.WriteBuffer(pData^, DEFAULTIDXHEADSIZE);
    GetMem(pIndexData, idx.IndexCount * 4);
    FillChar(pIndexData^, idx.IndexCount * 4, 0);
    FIndexStream.WriteBuffer(pIndexData^, idx.IndexCount * 4);
    FreeMem(pIndexData);
  end;
  Initialize;
  FUpdateFileHead:= True;
  ReleaseMutex(g_hMutexShareReadWrite);
end;

procedure TWMBaseImages.UpdateImageSize(nIndex, nSize:Integer);
begin
  FDxTextureArr[nIndex].nSize:= nSize;
  if nSize = 0 then
    FDxTextureArr[nIndex].boUpdate:= True;
end;

procedure TWMBaseImages.SynchronizeProcessImagesWrite(nIndex:Integer; pData:PBYTE; dwTrans:LongWord);
var
  nOffset:Integer;
  Idx:TWZIndexHeader;
  pIndexData:PAnsiChar;
begin
  //进入互斥临界区
  WaitForSingleObject(g_hMutexShareReadWrite, INFINITE);
  if not FDxTextureArr[nIndex].boUpdate then begin
    Idx:= pTWZIndexHeader(pData)^;
    FFileStream.WriteBuffer(pData^, DEFAULTWZLHEADSIZE);
    FIndexStream.WriteBuffer(pData^, DEFAULTIDXHEADSIZE);
    GetMem(pIndexData, idx.IndexCount * 4);
    FillChar(pIndexData^, idx.IndexCount * 4, 0);
    FIndexStream.WriteBuffer(pIndexData^, idx.IndexCount * 4);
    FreeMem(pIndexData);
    //重新加载
    Initialize;
    nOffset:= Integer(FIndexList[nIndex]) + sizeof(TWMImageInfo);
    FFileStream.Seek(nOffset, soBeginning);
    FFileStream.WriteBuffer(pData^, dwTrans);
    FDxTextureArr[nIndex].boNotRead:= False;
    FDxTextureArr[nIndex].boUpdate:= True;
    FDxTextureArr[nIndex].boLoading:= False;
  end;
  ReleaseMutex(g_hMutexShareReadWrite);
end;

function TWMBaseImages.GetImageSurface(index: integer): TDXImageTexture;
var
  px, py: Integer;
  liQueryTime:LARGE_INTEGER;
begin
  Result:= nil;
  //资源文件没有加载则退出
  if not FInitialize then begin
    WaitForSingleObject(g_hMutexShareReadWrite, INFINITE);
    if not CheckImagesDirectoryFiles then begin
      FFileStream := TFileStream.Create(FFileName, fmCreate or fmOpenReadWrite or fmShareDenyNone);
      FFileStream.Free;
      FFileStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyNone);
      FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.wzx';
      FIndexStream := TFileStream.Create(FIdxFile, fmCreate or fmOpenReadWrite or fmShareDenyNone);
      FIndexStream.Free;
      FIndexStream := TFileStream.Create(FIdxFile, fmOpenReadWrite or fmShareDenyNone);
    end;
    ReleaseMutex(g_hMutexShareReadWrite);
      //自动更新文件头
    if not FUpdateFileHead then begin
      QueryPerformanceCounter(Int64(liQueryTime));
      if (((liQueryTime.QuadPart - FUpdateHeadTime.QuadPart) / g_dbFrequency) >= UPDATEIMAGETIME) then begin
        if Assigned(FOnInitializeImages) then begin
          FOnInitializeImages(Self);
        end;
        FUpdateHeadTime.QuadPart:= liQueryTime.QuadPart;
      end;
    end;
  end else begin
    //在总数之间
    if (index >= 0) and (index < FImageCount) then begin
      //读取纹理列表
      Result := GetCachedImageEx(index, px, py);
      if (Result = nil) and (not FDxTextureArr[index].boUpdate) then begin
        //自动更新资源
        QueryPerformanceCounter(Int64(liQueryTime));
        if (((liQueryTime.QuadPart - FDxTextureArr[index].liUpdateTime.QuadPart) / g_dbFrequency) >= UPDATEIMAGETIME) then begin
          if Assigned(FOnUpdateImages) then begin
            FOnUpdateImages(Self, index);
          end;
          FDxTextureArr[index].liUpdateTime.QuadPart:= liQueryTime.QuadPart;
        end;
      end;
    end;
  end;
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
  //全局初始化互斥对象
  if g_hMutexShareReadWrite = 0 then
    g_hMutexShareReadWrite := CreateMutex(nil, FALSE, 'RM00000638734WZL');

  if g_dbFrequency = 0 then begin
    QueryPerformanceFrequency(Int64(g_liWzlStartTime));
    g_dbFrequency:= g_liWzlStartTime.QuadPart / 1000;
  end;

  if g_ImagesPath = '' then begin
    g_AppPath:= ExtractFilePath(ParamStr(0));
  end;

  if (FFileName = '') or FInitialize or (not FileExists(FFileName)) then
    exit;
  if FFileStream = nil then
    FFileStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyNone);
  Result := FFileStream <> nil;
  
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
end;

function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWILColorFormat; DrawCanvas: TDXDrawCanvas): TDXImageTexture;
begin
  Result := TDXImageTexture.Create;
  with Result do begin
    Size := Point(nWidth, nHeight);
    PatternSize := Point(nWidth, nHeight);
    Format :=  ColorFormat[WILColorFormat];
    Active := True;
  end;
  if not Result.Active then begin
    Result.Free;
    Result := nil;
  end else begin
    Result.Canvas := DrawCanvas;
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


end.

