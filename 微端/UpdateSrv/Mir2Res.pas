unit Mir2Res;

interface

uses
  Windows, Classes, SysUtils, EDcode;

const
  MAXIMAGECOUNT = 10000000;
  MINIMAGESIZE = 2;
  MAXIMAGESIZE = 2048;

  DEFAULTHEADOFFSET  = 0;
  DEFAULTHEADSIZE   = 64;

type
  TWILType = (t_wmM2Def, t_wmM2wis, t_wmM2Zip, t_wmM3Zip);

  TWZIndexHeader = record
    Title: string[43];
    IndexCount: Integer;
  end;
  PTWZIndexHeader = ^TWZIndexHeader;

  TWMIndexHeader = packed record
    Title: string[40];
    bitCount: array[0..2] of byte;
    IndexCount: integer;
    VerFlag: integer;
  end;
  PTWMIndexHeader = ^TWMIndexHeader;

  TWZImageInfo = record
    Encode: Byte;
    unKnow1: array [0 .. 2] of Byte;
    nWidth: Word;
    nHeight: Word;
    px: smallint;
    py: smallint;
    nSize: Integer;
  end;
  PTWZImageInfo = ^TWZImageInfo;

  TWMImageInfo = packed record
    nWidth: Word;
    nHeight: Word;
    px: smallint;
    py: smallint;
    nSize: Integer;
  end;
  PTWMImageInfo = ^TWMImageInfo;

  TWMImages = class(TObject)
  private
    m_hFileStream:THandle;                                                      //内存映射模式句柄
    m_nImageCount:Integer;
    m_szWzlFile:string;
    m_szWzxFile:string;
    m_boInitialize:Boolean;
    m_wmIdxHeader:TWZIndexHeader;
    m_bo16BitCount:Boolean;
    m_pWzlData:PByte;
    m_pWzxData:PByte;
    m_szHeadStr:string;
    m_WILType: TWILType;
    FIndexList: TList;
    pIndexValue: PLongWord;
    m_hWzlStream:TFileStream;                                                   //文件流模式句柄
  private
    procedure LoadIndex(idxfile: string);
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure Initialize;
    function GateFileHeadData(var nZip:Integer):string;
    function GetImageInfo(index:Integer; var nZip, nSize:Integer):string;
    function GetImageData(index: integer; var dwSize:Integer):PAnsiChar;
    property FileName: string read m_szWzlFile write m_szWzlFile;
  end;

implementation

uses
  CShare;

function WidthBytes(nBit, nWidth: Integer): Integer;
begin
  Result := (((nWidth * nBit) + 31) shr 5) * 4;
end;

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

constructor TWMImages.Create;
begin
  inherited Create;
  m_hFileStream:= 0;
  m_nImageCount:= 0;
  m_szWzlFile:= '';
  m_szWzxFile:= '';
  m_szHeadStr:= '';
  m_boInitialize:= False;
  m_bo16BitCount:= False;
  m_pWzlData:= nil;
  m_pWzxData:= nil;
  m_hWzlStream:= nil;
  pIndexValue:= NIL;
  FIndexList := TList.Create;
  FillChar(m_wmIdxHeader, sizeof(TWZIndexHeader), #0);
end;

procedure TWMImages.Initialize;
var
  m_hWilMap: THandle;
  ZipInfo:TWZIndexHeader;
  DefInfo:TWMIndexHeader;
begin
  if (m_szWzlFile = '') or m_boInitialize or (m_hFileStream <> 0) or (not FileExists(m_szWzlFile)) then
    exit;
  if g_boMapView then begin
    //内存映射模式
    m_hFileStream := CreateFileA(PAnsiChar(AnsiString(m_szWzlFile)), GENERIC_READ, FILE_SHARE_READ,  nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if m_hFileStream <> 0 then begin
      m_boInitialize := True;
      m_hWilMap := CreateFileMapping(m_hFileStream, nil, PAGE_READONLY, 0, 0, nil);
      if m_hWilMap <> 0 then begin
        m_pWzlData := PBYTE(MapViewOfFile(m_hWilMap, FILE_MAP_READ, 0, 0, 0));
        CloseHandle(m_hWilMap);
      end;
      CloseHandle(m_hFileStream);
      if m_pWzlData <> nil then begin
        m_szWzxFile := ExtractFilePath(m_szWzlFile) + ExtractFileNameOnly(m_szWzlFile) + '.WZX';
        LoadIndex(m_szWzxFile);
        m_WILType:= t_wmM2Zip;
        if m_pWzxData <> nil then begin
          ZipInfo:= pTWZIndexHeader(m_pWzxData)^;
          m_szHeadStr:= EncodeBuffer((@ZipInfo), sizeof(TWZIndexHeader));
        end;
      end;
    end else begin
      //加载wil文件
      m_szWzlFile := ExtractFilePath(m_szWzlFile) + ExtractFileNameOnly(m_szWzlFile) + '.WIL';
      m_hFileStream := CreateFileA(PAnsiChar(AnsiString(m_szWzlFile)), GENERIC_READ, FILE_SHARE_READ,  nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      if m_hFileStream <> 0 then begin
        m_boInitialize := True;
        m_hWilMap := CreateFileMapping(m_hFileStream, nil, PAGE_READONLY, 0, 0, nil);
        if m_hWilMap <> 0 then begin
          m_pWzlData := PBYTE(MapViewOfFile(m_hWilMap, FILE_MAP_READ, 0, 0, 0));
          CloseHandle(m_hWilMap);
        end;
        CloseHandle(m_hFileStream);
        if m_pWzlData <> nil then begin
          m_szWzxFile := ExtractFilePath(m_szWzlFile) + ExtractFileNameOnly(m_szWzlFile) + '.Wix';
          LoadIndex(m_szWzxFile);
          m_WILType:= t_wmM2Def;
          if m_pWzxData <> nil then begin
            DefInfo:= pTWMIndexHeader(m_pWzxData)^;
            m_szHeadStr:= EncodeBuffer((@DefInfo), sizeof(TWMIndexHeader));
          end;
        end;
      end;
    end;
  end else begin
    //普通文件流模式
    m_hWzlStream := TFileStream.Create(m_szWzlFile, fmOpenReadWrite or fmShareDenyNone);
    if m_hWzlStream <> nil then begin
      //wzl加载
      m_boInitialize := True;
      m_szWzxFile := ExtractFilePath(m_szWzlFile) + ExtractFileNameOnly(m_szWzlFile) + '.WZX';
      LoadIndex(m_szWzxFile);
      m_WILType:= t_wmM2Zip;
      m_hWzlStream.Read(ZipInfo, SizeOf(TWZIndexHeader));
      m_szHeadStr:= EncodeBuffer((@ZipInfo), sizeof(TWZIndexHeader));
    end else begin
      m_szWzlFile := ExtractFilePath(m_szWzlFile) + ExtractFileNameOnly(m_szWzlFile) + '.WIL';
      m_hWzlStream := TFileStream.Create(m_szWzlFile, fmOpenReadWrite or fmShareDenyNone);
      if m_hWzlStream <> nil then begin
        //wzl加载
        m_boInitialize := True;
        m_szWzxFile := ExtractFilePath(m_szWzlFile) + ExtractFileNameOnly(m_szWzlFile) + '.WIX';
        LoadIndex(m_szWzxFile);
        m_WILType:= t_wmM2Def;
        m_hWzlStream.Read(DefInfo, SizeOf(TWMIndexHeader));
        m_szHeadStr:= EncodeBuffer((@DefInfo), sizeof(TWZIndexHeader));
      end;
    end;
  end;
end;

procedure TWMImages.LoadIndex(idxfile: string);
var
  fhandle: integer;
  m_hWzxMap: THandle;
  i:Integer;
  value: LongWord;
begin
  m_nImageCount := 0;
  if FileExists(idxfile) then begin
    if g_boMapView then begin
      fhandle := CreateFileA(PAnsiChar(AnsiString(idxfile)), GENERIC_READ, FILE_SHARE_READ,  nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      if fhandle <> 0 then begin
        m_hWzxMap := CreateFileMapping(fhandle, nil, PAGE_WRITECOPY, 0, 0, nil);
        if m_hWzxMap <> 0 then begin
          m_pWzxData := PBYTE(MapViewOfFile(m_hWzxMap, FILE_MAP_COPY, 0, 0, 0));
          CloseHandle(m_hWzxMap);
        end;
        CloseHandle(fhandle);
      end;
      if m_pWzxData <> nil then begin
        m_wmIdxHeader:= pTWZIndexHeader(m_pWzxData)^;
        m_nImageCount := m_wmIdxHeader.IndexCount;
      end;
    end else begin
      fhandle := CreateFileA(PAnsiChar(AnsiString(idxfile)), GENERIC_READ, FILE_SHARE_READ,  nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      if fhandle <> 0 then begin
        m_hWzxMap := CreateFileMapping(fhandle, nil, PAGE_WRITECOPY, 0, 0, nil);
        if m_hWzxMap <> 0 then begin
          m_pWzxData := PBYTE(MapViewOfFile(m_hWzxMap, FILE_MAP_COPY, 0, 0, 0));
          CloseHandle(m_hWzxMap);
        end;
        CloseHandle(fhandle);
      end;
      if m_pWzxData <> nil then begin
        m_wmIdxHeader:= pTWZIndexHeader(m_pWzxData)^;
        m_nImageCount := m_wmIdxHeader.IndexCount;
        if m_wmIdxHeader.IndexCount > 0 then begin
          for i := 0 to m_wmIdxHeader.IndexCount - 1 do begin
            value := PLongWord(LongWord(m_pWzxData) + LongWord(sizeof(TWZIndexHeader) + 4 * i))^;
            FIndexList.Add(pointer(value));
          end;
        end;
        UnmapViewOfFile(m_pWzxData);
        m_pWzxData:= nil;
      end;
    end;
  end;
end;

function TWMImages.GateFileHeadData(var nZip:Integer):string;
begin
  nZip:= 0;
  if (m_WILType = t_wmM2Zip) then nZip:= 1;

  Result:= m_szHeadStr;
end;

function TWMImages.GetImageInfo(index:Integer; var nZip, nSize:Integer):string;
var
  nImageOffset:Integer;
  Info:TWZImageInfo;
  bo16bit:Boolean;
  nLen: Integer;
begin
  Result:= '';
  nZip:= 0;
  nSize:= 0;
  if (index >= 0) and (index < m_nImageCount) then begin
    if g_boMapView then begin
      //文件映射模式
      if m_WilType = t_wmM2Zip then begin
        //已压缩图片
        nImageOffset:=  pInteger(m_pWzxData^ + sizeof(TWZIndexHeader) + Index * $4)^;
        if nImageOffset <> 0 then begin
          nZip:= 1;
          Info:= pTWZImageInfo(m_pWzlData^ + nImageOffset)^;
          if (Info.nWidth > MAXIMAGESIZE) or (Info.nHeight > MAXIMAGESIZE) then
            Exit;
          if (Info.nWidth < MINIMAGESIZE) or (Info.nHeight < MINIMAGESIZE) then
            Exit;

          Result:= EncodeBuffer(@Info, sizeof(TWZImageInfo));
          //检测是否是未压缩数据
          if Info.nSize = 0 then begin
            bo16bit := Info.Encode = 5;
            if bo16bit then begin
              nLen := WidthBytes(16, Info.nWidth);
              nSize := nLen * Info.nHeight + sizeof(TWZImageInfo);
            end else begin
              nLen := WidthBytes(8, Info.nWidth);
              nSize := nLen * Info.nHeight + sizeof(TWZImageInfo);
            end;
          end;
        end;
      end else begin
        //未压缩图片
        nImageOffset:=  pInteger(m_pWzxData^ + sizeof(TWMIndexHeader) + Index * $4)^;
        nZip:= 0;
        Info:= pTWZImageInfo(m_pWzlData^ + nImageOffset)^;
        Result:= EncodeBuffer(@Info, sizeof(TWMImageInfo));
      end;
    end else begin
      nImageOffset:= Integer(FIndexList[index]);
      if (m_hWzlStream.Seek(nImageOffset, 0) = nImageOffset) and (nImageOffset <> 0) then begin
        if m_WilType = t_wmM2Zip then begin
          nZip:= 1;
          m_hWzlStream.Read(Info, SizeOf(TWZImageInfo));
          Result:= EncodeBuffer(@Info, sizeof(TWZImageInfo));
          //检测是否是未压缩数据
          if Info.nSize = 0 then begin
            bo16bit := Info.Encode = 5;
            if bo16bit then begin
              nLen := WidthBytes(16, Info.nWidth);
              nSize := nLen * Info.nHeight + sizeof(TWZImageInfo);
            end else begin
              nLen := WidthBytes(8, Info.nWidth);
              nSize := nLen * Info.nHeight + sizeof(TWZImageInfo);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TWMImages.GetImageData(index: integer; var dwSize:Integer):PAnsiChar;
var
  nImageOffset:Integer;
  Info:TWZImageInfo;
  nInfoSize, nLen, ReadSize: Integer;
  bo16bit:Boolean;
  pData:PAnsiChar;
begin
  Result:= nil;
  dwSize:= 0;
  if (index >= 0) and (index < m_nImageCount) then begin
    if g_boMapView then begin
      nImageOffset:=  pInteger(m_pWzxData^ + sizeof(TWZIndexHeader) + Index * $4)^;
      if nImageOffset <> 0 then begin
        Info:= pTWZImageInfo(m_pWzlData^ + nImageOffset)^;
        if (Info.nWidth > MAXIMAGESIZE) or (Info.nHeight > MAXIMAGESIZE) then
          exit;
        if (Info.nWidth < MINIMAGESIZE) or (Info.nHeight < MINIMAGESIZE) then
          exit;
        bo16bit := Info.Encode = 5;
        if bo16bit then begin
          nLen := WidthBytes(16, Info.nWidth);
          ReadSize := nLen * Info.nHeight;
        end else begin
          nLen := WidthBytes(8, Info.nWidth);
          ReadSize := nLen * Info.nHeight;
        end;
        //读取数据
        nInfoSize:= sizeof(TWZImageInfo);
        if Info.nSize = 0 then begin
          dwSize:= ReadSize + nInfoSize;
        end else begin
          dwSize:= Info.nSize + nInfoSize;
        end;
        Result:= PAnsiChar(m_pWzlData^ + nImageOffset);
      end else begin
        Result:= nil;
      end;
    end else begin
      nImageOffset:= Integer(FIndexList[index]);
      if nImageOffset <> 0 then begin
        if (m_hWzlStream.Seek(nImageOffset, 0) = nImageOffset) and (nImageOffset <> 0) then begin
          m_hWzlStream.Read(Info, SizeOf(TWZImageInfo));
          if (Info.nWidth > MAXIMAGESIZE) or (Info.nHeight > MAXIMAGESIZE) then
          exit;
          if (Info.nWidth < MINIMAGESIZE) or (Info.nHeight < MINIMAGESIZE) then
            exit;
          bo16bit := Info.Encode = 5;
          if bo16bit then begin
            nLen := WidthBytes(16, Info.nWidth);
            ReadSize := nLen * Info.nHeight;
          end else begin
            nLen := WidthBytes(8, Info.nWidth);
            ReadSize := nLen * Info.nHeight;
          end;
          //读取数据
          nInfoSize:= sizeof(TWZImageInfo);
          if Info.nSize = 0 then begin
            dwSize:= ReadSize + nInfoSize;
          end else begin
            dwSize:= Info.nSize + nInfoSize;
          end;
          GetMem(pData, dwSize);
          m_hWzlStream.Seek(nImageOffset, soBeginning);
          m_hWzlStream.Read(pData^, dwSize);
          Result:= pData;
        end;
      end;
    end;
  end;
end;

destructor TWMImages.Destroy;
begin
  if g_boMapView then begin
    UnmapViewOfFile(m_pWzlData);
  end else begin
    FIndexList.Free;
    m_hWzlStream.Free;
  end;
  inherited Destroy;
end;

end.
