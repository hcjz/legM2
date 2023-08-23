{------------------------------------------------------------------------------}
{ �ؼ���Ԫ����: MWil.pas                                                       }
{ ��Ԫ����: ������ķ� (QQ:409976)                                             }
{ ����: 2012-10-30                                                             }
{ ���ܽ���:                                                                    }
{   Wil,Wis,Wzl �ļ���ȡ��Ԫ                                                   }
{------------------------------------------------------------------------------}
unit WIL;

interface

uses
  Windows, Classes, Graphics, SysUtils, Wilpion, Dialogs, MapFiles,
  DirectXD3D9, HGETextures, HGECanvas, HUtil32, ZLIB;

type
   TWMILColorFormat = (WMILFMT_A4R4G4B4, WMILFMT_A1R5G5B5, WMILFMT_R5G6B5, WMILFMT_A8R8G8B8);

const
   MINIMAGESIZE = 2;
   MAXIMAGESIZE = 2048;
   ColorFormat: array[TWMILColorFormat] of TD3DFormat = (D3DFMT_A4R4G4B4, D3DFMT_A1R5G5B5, D3DFMT_R5G6B5, D3DFMT_A8R8G8B8);

(*====WIL �ļ�ͷ��ʽ ========================================================*)
type
   TWMImageHeader = record      // WIL�ļ�ͷ��ʽ(56Byte)
      Title         :String[40];  // ���ļ�����
      ImageCount    :integer;     // ͼƬ����
      ColorCount    :integer;     // ɫ������
      PaletteSize   :integer;     // ��ɫ���С
      VerFlag       :integer;     // δ֪(��ʽ?)
   end;
   PTWMImageHeader = ^TWMImageHeader;

   TWMImageInfo = record
      nWidth        :SmallInt;  // λͼ���
      nHeight       :SmallInt;  // λͼ�߶�
      px            :smallint;  // λ��X
      py            :smallint;  // λ��Y
      bits          :PByte;     // ����
   end;
   PTWMImageInfo = ^TWMImageInfo;

(*====WIX �ļ�ͷ��ʽ ========================================================*)
   TWMIndexHeader = record         //WIX�ļ�ͷ��ʽ
      Title          :string[40];  // ���ļ�����
      IndexCount     :integer;     // ��������
      VerFlag        :integer;     // δ֪ (��ʽ?)
   end;
   PTWMIndexHeader = ^TWMIndexHeader;

   TWMIndexInfo = record
      Position       :integer;
      Size           :integer;
   end;
   PTWMIndexInfo = ^TWMIndexInfo;

(*====WZL �ļ�ͷ��ʽ ========================================================*)
 type
   TWzlImageHeader = record                   //wzl�ļ�ͷ��ʽ
       Title         :string[18];             //www.shandagames.com
       aTemp1        :array[0..24] of Char;
       ImageCount    :integer;                //ͼƬ����
       aTemp2        :array[0..17] of Char;
   end;
   PTWzlImageHeader = ^TWzlImageHeader;

   TWzxIndexHeader = record                   //wzX�ļ�ͷ
       Title         :string[18];             //www.shandagames.com
       bTemp1        :array[0..24] of Char;   //
       IndexCount    :integer;                //ͼƬ����
   end;
   PTWzxIndexHeader = ^TWzxIndexHeader;

   TWzlImgInfo  =  record                    //wzl�ļ���ʽ
       btEn1         :Byte;                  //1
       btEn2         :Byte;                  //1
       bt2           :Byte;                  //1
       bt3           :Byte;                  //1
       nWidth        :smallint;              //2ͼƬ���
       nHeight       :smallint;              //2ͼƬ�߶�
       wPx           :smallint;              //2λ��X
       wPy           :smallint;              //2λ��Y
       Length        :integer;               //4���ݴ�С
   end;
   PTWzlImgInfo = ^TWzlImgInfo;

(*====  MWIL  ͨ���� ========================================================*)
 type
   TDXImage = record
       nPx          :SmallInt;
       nPy          :SmallInt;
       Surface      :TDXImageTexture;
       dwLatestTime :LongWord;
   end;
   pTDxImage = ^TDXImage;

   TDxImageArr   = array[0..MaxListSize div 4] of TDxImage;
   PTDxImageArr  = ^TDxImageArr;


(*====  MWIL (WIL.WIS.WZL)  ������ ===========================================*)
   TWMImages = class
   private
      FFileName         :String;              // �ļ���
      FImageCount       :integer;             // ͼƬ����
      FFileMode         :Byte;                //�ļ���ʽ 0 = WIL 1=WZL
      btVersion         :Byte;
      FAppr             :Word;
      FBytesPerPixels   :byte;                //���ݳ���
      m_nPosition       :Integer;             //����ָ��

(*====  MWIL ͨ�� ===========================================================*)
      procedure LoadIndex (idxfile: string);
      procedure FreeOldMemorys;
      function  FGetImageSurface (index: integer): TDXImageTexture;
      function  WidthBytes(w: integer): integer;
(*====  MWIL-WIL�� ==========================================================*)
      procedure LoadDxImage (position: integer; pdximg: PTDxImage);
      function  WILCopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word; mode: Integer=0): Boolean;
(*====  MWIL-WZL�� ==========================================================*)
      function  WZLWidthBytes(nBit, nWidth: Integer): Integer;
      procedure LoadWZLDxImage (position: integer; pdximg: PTDxImage);
      function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PChar): Integer;
      function CopyWZLDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word; bt:Boolean = false): Boolean;
(*====  MWIL ͨ�� ===========================================================*)
   protected
      m_dwMemChecktTick  :LongWord;
   public
      m_ImgArr           :pTDxImageArr;
      m_IndexList        :TList;
      m_FileStream       :TFileStream;
      constructor Create; dynamic;
      destructor Destroy; override;
      procedure Initialize;
      procedure Finalize;
      procedure ClearCache;
      function  GetCachedImage (index: integer; var px, py: integer): TDXImageTexture;
      function  GetCachedSurface (index: integer): TDXImageTexture;
      property Images[index: integer]: TDXImageTexture read FGetImageSurface;
   published
      property FileName: string read FFileName write FFileName;
      property ImageCount: integer read FImageCount;
      property Appr:Word read FAppr write FAppr;
   end;

   function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWMILColorFormat; DrawCanvas: TDXDrawCanvas = nil): TDXImageTexture;

implementation

function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise ECompressionError.Create('ZIP Error');
end;

function DCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise EDecompressionError.Create('ZIP Error');
end;


function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWMILColorFormat; DrawCanvas: TDXDrawCanvas): TDXImageTexture;
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



(*====  MWIL ͨ�� ===========================================================*)

function TWMImages.WidthBytes(w: integer): integer; //(---ͨ��---)
begin
  Result := (((w * 8) + 31) div 32) * 4;
end;


constructor TWMImages.Create; //(---ͨ��---)
begin
   inherited;
   FFileName := '';
   FFileMode := 0;
   FImageCount := 0;
   m_FileStream := nil;
   m_ImgArr := nil;
   m_IndexList := TList.Create;
   m_dwMemChecktTick := GetTickCount;
   btVersion:=0;
   m_nPosition := 0;
end;


destructor TWMImages.Destroy; //(---ͨ��---)
begin
   m_IndexList.Free;
   if m_FileStream <> nil then m_FileStream.Free;
   inherited Destroy;
end;


procedure TWMImages.Initialize; //(---ͨ��---)
var
  Idxfile: String;
  logoBool: Boolean;
  Header :TWMImageHeader; //wil
  WZLHeader :TWzlImageHeader;//wzl
begin
   if (FFileName = '') then begin
    Exit;
   end;
     logoBool := False;
     if Comparetext(ExtractFileExt(FFileName), '.WZL') = 0 then begin
       if FileExists (FFileName) then begin //wzl
         logoBool := True;
         FFileMode := 1;
       end else begin
         FFileName := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIL';
         if FileExists (FFileName) then begin //WIL
           logoBool := True;
           FFileMode := 0;
         end;
       end;
     end else
     if Comparetext(ExtractFileExt(FFileName), '.WIL') = 0 then begin
       if FileExists (FFileName) then begin //wil
         logoBool := True;
         FFileMode := 0;
       end else begin
         FFileName := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WZL';
         if FileExists (FFileName) then begin //wzl
           logoBool := True;
           FFileMode := 1;
          end;
       end;
     end;
     if logoBool then begin
       case FFileMode of
        0: begin //WIL
           if m_FileStream = nil then
           m_FileStream := TFileStream.Create (FFileName, fmOpenRead or fmShareDenyNone);
           m_FileStream.Read (Header, SizeOf(TWMImageHeader));
           if header.VerFlag = 0 then begin
             btVersion:=1;
             m_FileStream.Seek(-4,soFromCurrent);
           end;
           FImageCount := Header.ImageCount;
           //�ڶ�ȡ�ļ�ͷʱ���ļ�ͷ��λɫ������ж�ȡ��ֱ�WILͼƬΪ��λɫ
           if header.ColorCount=256 then begin
             FBytesPerPixels:=1;
           end else if header.ColorCount=65536 then begin
             FBytesPerPixels:=2;
           end else if header.colorcount=16777216 then begin
             FBytesPerPixels:=4;
           end else if header.ColorCount>16777216 then begin
             FBytesPerPixels:=4;
           end;
           if Header.ImageCount > 0 then begin
             m_ImgArr:=AllocMem(SizeOf(TDxImage) * FImageCount);
             if m_ImgArr = nil then
             raise Exception.Create (' ImgArr = nil');
             idxfile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIX';
             LoadIndex (idxfile);  //����ͼƬλ�ô�С
           end;
         end;
        1: begin //WZL
           if m_FileStream = nil then
             m_FileStream := TFileStream.Create (FFileName, fmOpenRead or fmShareDenyNone);
             m_FileStream.Read (WZLHeader, SizeOf(TWzlImageHeader));
           if WZLHeader.ImageCount > 0 then begin
             FImageCount := WZLHeader.ImageCount;
             m_ImgArr:=AllocMem(SizeOf(TDxImage) * FImageCount);
             if m_ImgArr = nil then
             raise Exception.Create (' ImgArr = nil');
             idxfile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WZX';
             LoadIndex (idxfile);  //����ͼƬλ�ô�С
           end;
         end;
       end;
     end;

end;

//װ��WIX���� WZX�ļ����ݵ��ڴ�
procedure TWMImages.LoadIndex (idxfile: string); //(---ͨ��---)
var
   fhandle, i, value: integer;
   header: TWMIndexHeader;
   WzlHeader: TWzxIndexHeader;
   pvalue: PInteger;
begin
  m_IndexList.Clear;
  if FileExists (idxfile) then begin
    fhandle := FileOpen (idxfile, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      if FFileMode = 0 then begin//wil
        if btVersion <> 0 then  FileRead (fhandle, header, sizeof(TWMIndexHeader) - 4)
        else  FileRead (fhandle, header, sizeof(TWMIndexHeader));
        GetMem (pvalue, 4*header.IndexCount);
        FileRead (fhandle, pvalue^, 4*header.IndexCount);
        if header.IndexCount > 0 then
        for i:=0 to header.IndexCount-1 do begin
          value := PInteger(integer(pvalue) + 4*i)^;
          m_IndexList.Add (pointer(value));
        end;
      end else begin //WZL
        FileRead (fhandle, WzlHeader, sizeof(TWzxIndexHeader));
        GetMem (pvalue, 4*WzlHeader.IndexCount);
        FileRead (fhandle, pvalue^, 4*WzlHeader.IndexCount);
        if WzlHeader.IndexCount > 0 then
        for i:=0 to WzlHeader.IndexCount-1 do begin
          value := PInteger(integer(pvalue) + 4*i)^;
          m_IndexList.Add (pointer(value));
        end;
      end;
      FreeMem(pvalue);
      FileClose (fhandle);
    end;
  end;
end;

//��ʼ��ǰ�����ͷ�װ�ص�����ͼƬ
procedure TWMImages.Finalize; //(---ͨ��---)
var
   i: integer;
begin
  for i:=0 to FImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      m_ImgArr[i].Surface.Free;
      m_ImgArr[i].Surface := nil;
    end;
  end;
  if m_FileStream <> nil then FreeAndNil(m_FileStream);

end;

procedure TWMImages.ClearCache; //(---ͨ��---)
var
   i: integer;
begin
   if FImageCount > 0 then
   for i:=0 to FImageCount - 1 do begin
      if m_ImgArr[i].Surface <> nil then begin
         m_ImgArr[i].Surface.Free;
         m_ImgArr[i].Surface := nil;
      end;
   end;
end;

function  TWMImages.FGetImageSurface (index: integer): TDXImageTexture; //(---ͨ��---)
begin
   Result := GetCachedSurface (index);
end;

procedure TWMImages.FreeOldMemorys; //(---ͨ��---)
var
   i: integer;
begin
   if FImageCount > 0 then
   for i:=0 to FImageCount - 1 do begin
      if m_ImgArr[i].Surface <> nil then begin
         if GetTickCount - m_ImgArr[i].dwLatestTime > 5 * 60 * 1000 then begin
            m_ImgArr[i].Surface.Free;
            m_ImgArr[i].Surface := nil;
         end;
      end;
   end;
end;


//����ָ��ͼƬ�ŵ�ͼ��
function  TWMImages.GetCachedSurface (index: integer): TDXImageTexture;  //(---ͨ��---)
var
  nPosition:Integer;
begin
  Result := nil;
  try
    if (index < 0) or (index >= FImageCount) then exit;
    if GetTickCount - m_dwMemChecktTick > 10000 then  begin
      m_dwMemChecktTick := GetTickCount;
      FreeOldMemorys;
    end;
    if m_ImgArr[index].Surface = nil then begin  //��ָ��ͼƬ�Ѿ��ͷţ�������װ��.
      if index < m_IndexList.Count then begin
        case FFileMode of
          0: begin //WIL
               nPosition := Integer(m_IndexList[index]);
               LoadDxImage (nPosition, @m_ImgArr[index]);
             end;
          1: begin  //WZL
              nPosition := Integer(m_IndexList[index]);
              LoadWZLDxImage(nPosition, @m_ImgArr[index]);
             end;
        end;
         m_ImgArr[index].dwLatestTime := GetTickCount;
         Result := m_ImgArr[index].Surface;
      end;
    end else begin
      m_ImgArr[index].dwLatestTime := GetTickCount;
      Result := m_ImgArr[index].Surface;
    end;
  except

  end;
end;

function  TWMImages.GetCachedImage (index: integer; var px, py: integer): TDXImageTexture; //(---ͨ��---)
var
   position: integer;
begin
   Result := nil;
   try
    if (index < 0) or (index >= FImageCount) then Exit;
    if GetTickCount - m_dwMemChecktTick > 10000 then  begin
      m_dwMemChecktTick := GetTickCount;
      FreeOldMemorys;
    end;
    if m_ImgArr[index].Surface = nil then begin //����װ��
      if index < m_IndexList.Count then begin
        case FFileMode of
          0: begin //WIL
               position := Integer(m_IndexList[index]);
               LoadDxImage (position, @m_ImgArr[index]);
             end;
          1: begin //WZL
              position := Integer(m_IndexList[index]);
              LoadWZLDxImage(position, @m_ImgArr[index]);
             end;
        end;
         m_ImgArr[index].dwLatestTime := GetTickCount;
         px := m_ImgArr[index].nPx;
         py := m_ImgArr[index].nPy;
         Result := m_ImgArr[index].Surface;
      end;

    end else begin
      m_ImgArr[index].dwLatestTime := GetTickCount;
      px := m_ImgArr[index].nPx;
      py := m_ImgArr[index].nPy;
      Result := m_ImgArr[index].Surface;
    end;
   except

   end;
end;


(*====  MWIL-WIl�� ==========================================================*)
function TWMImages.WILCopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word; mode: Integer): Boolean; //(---WIl---)
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      if mode > 1 then begin //16λ
        FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
        Y := 0;
        while True do begin
         if Y >= Height then Break;
          WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
          ReadBuffer := @Buffer[(Height - 1 - Y) * Width];
          LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Texture.Width);
          Inc(Y);
        end;
      end else begin  //8λ
        FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
        WriteBuffer := Pointer(Integer(Access.Bits));
        ReadBuffer := @Buffer[(Height - 1) * Width];
        Y := 0;
         while True do begin
          if Y >= Height then Break;
          LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Texture.Width);
          Inc(WriteBuffer, Access.Pitch);
          Dec(ReadBuffer, Width);
          Inc(Y);
         end;
      end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;

procedure TWMImages.LoadDxImage (position: integer; pdximg: PTDxImage); //(---WIl---)
var
   imginfo: TWMImageInfo;
   Buffer: PChar;
   imgLen, dataLen, mlen: integer;
begin
   m_FileStream.Seek (position, 0);
   if btVersion <> 0 then m_FileStream.Read (imginfo, SizeOf(TWMImageInfo)-4)
   else m_FileStream.Read (imginfo, SizeOf(TWMImageInfo));
    if (imginfo.nWidth > MAXIMAGESIZE) or (imgInfo.nHeight > MAXIMAGESIZE) then Exit;
    if (imginfo.nWidth < MINIMAGESIZE) or (imgInfo.nHeight < MINIMAGESIZE) then  Exit;
     if FBytesPerPixels >= 2 then begin
       dataLen := ((imginfo.nWidth * FBytesPerPixels + 3) div 4) * 4;
       imgLen := dataLen div 2;
      end else begin
      dataLen := ((imginfo.nWidth + 3) div 4) * 4;
      imgLen := dataLen;
     end;
     mlen := dataLen * imginfo.nHeight;
     
     GetMem(Buffer, mlen);
     try
       if m_FileStream.Read(Buffer^, mlen) = mlen then begin
         pdximg.surface := MakeDXImageTexture(imginfo.nWidth, imginfo.nHeight, WMILFMT_A1R5G5B5);
         if pdximg.Surface <> nil then begin
           if not WILCopyImageDataToTexture(Buffer, pdximg.Surface, dataLen, imginfo.nHeight,FBytesPerPixels) then begin
             pdximg.Surface.Free;
             pdximg.Surface := nil;
           end else begin
             pdximg.nPx := imginfo.px;
             pdximg.nPy := imginfo.py;
           end;
         end;
       end;
     finally
       FreeMem(Buffer);
     end;
end;



(*====  MWIL-WZL�� ==========================================================*)

function TWMImages.WZlWidthBytes(nBit, nWidth: Integer): Integer;
begin
  Result := (((nWidth * nBit) + 31) shr 5) * 4;
end;


procedure TWMImages.LoadWZLDxImage (position: integer; pdximg: PTDxImage);
var
  imginfo: TWzlImgInfo;
  mlen, dataLen: integer;
  Fbo16bit: Boolean;
  inBuffer, outBuffer: PChar;
begin
  m_FileStream.Seek (position, 0);
  m_FileStream.Read (imginfo, SizeOf(TWzlImgInfo));
  if (imginfo.nWidth > MAXIMAGESIZE) or (imgInfo.nHeight > MAXIMAGESIZE) then Exit;
  if (imginfo.nWidth < MINIMAGESIZE) or (imgInfo.nHeight < MINIMAGESIZE) then Exit;;
  Fbo16bit := imginfo.btEn1 = 5;
  if Fbo16bit then begin
      dataLen := WZLWidthBytes(16, imginfo.nWidth);
  end else begin
      dataLen := WZLWidthBytes(8, imginfo.nWidth);
  end;
    if imginfo.Length > 0 then begin //ѹ����
      GetMem(inBuffer, imginfo.Length);
      outBuffer := nil;
      try
        if m_FileStream.Read(inBuffer^, imginfo.Length) = imginfo.Length then begin
           ZIPDecompress(inBuffer, imginfo.Length, 0, outBuffer);
           pdximg.surface := MakeDXImageTexture(imginfo.nWidth, imginfo.nHeight, WMILFMT_A1R5G5B5);
           if pdximg.Surface <> nil then begin
              if not CopyWZLDataToTexture(outBuffer, pdximg.Surface, dataLen, imginfo.nHeight,Fbo16bit) then begin
                pdximg.Surface.Free;
                pdximg.Surface := nil;
              end else begin
                pdximg.nPx := imginfo.wpx;
                pdximg.nPy := imginfo.wpy;
              end;
           end;
           FreeMem(outBuffer);
        end;
      finally
         FreeMem(inBuffer);
      end;
    end else begin //δѹ��
      mlen := dataLen * imginfo.nHeight;
      GetMem(inBuffer, mlen);
      try
        if m_FileStream.Read(inBuffer^, mlen) = mlen then begin
          pdximg.surface := MakeDXImageTexture(imginfo.nWidth, imginfo.nHeight, WMILFMT_A1R5G5B5);
           if pdximg.Surface <> nil then begin
              if not CopyWZLDataToTexture(inBuffer, pdximg.Surface, dataLen, imginfo.nHeight,Fbo16bit) then begin
                pdximg.Surface.Free;
                pdximg.Surface := nil;
              end else begin
                pdximg.nPx := imginfo.wpx;
                pdximg.nPy := imginfo.wpy;
              end;
           end;
        end;
      finally
        FreeMem(inBuffer);
      end;
    end;
end;


function TWMImages.ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PChar): Integer;
var
  strm: TZStreamRec;
  P: Pointer;
  BufInc: Integer;
begin
  SafeFillChar(strm, sizeof(strm), 0);
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
  end;
end;

function TWMImages.CopyWZLDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word; bt:boolean): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      if bt then begin
        FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
       // for Y := 0 to Height - 1 do begin
        Y := 0;
        while True do begin
         if Y >= Height then Break;
          WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
          ReadBuffer := @Buffer[(Height - 1 - Y) * Width];
          LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Texture.Width);
          Inc(Y);
        end;
        //end;
      end else begin
        FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
        WriteBuffer := Pointer(Integer(Access.Bits));
        ReadBuffer := @Buffer[(Height - 1) * Width];
        //for Y := 0 to Height - 1 do begin
         Y := 0;
         while True do begin
          if Y >= Height then Break;
          LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Texture.Width);
          Inc(WriteBuffer, Access.Pitch);
          Dec(ReadBuffer, Width);
          Inc(Y);
         end;
        //end;
      end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;


end.
