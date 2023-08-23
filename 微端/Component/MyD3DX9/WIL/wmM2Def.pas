unit wmM2Def;

interface
uses
  Windows, Classes, Graphics, SysUtils, DirectX, HGETextures, WIL;

type
  TWMImageHeader = packed record
    Title: string[40];
    bitCount: array[0..2] of byte;
    ImageCount: integer;
    ColorCount: integer;
    PaletteSize: integer;
    IndexOffset: integer;
  end;

  TWMIndexHeader = packed record
    Title: string[40];
    bitCount: array[0..2] of byte;
    IndexCount: integer;
    VerFlag: integer;
  end;
  PTWMIndexHeader = ^TWMIndexHeader;

  TWMImageInfo = packed record
    DXInfo: TDXTextureInfo;
    nSize: Integer;
  end;
  PTWMImageInfo = ^TWMImageInfo;


  TWMM2DefImages = class(TWMBaseImages)
  private
    FHeader: TWMImageHeader;
    FIdxHeader: TWMIndexHeader;
    FIdxFile: string;
    FNewFmt: Boolean;
    Fbo16bit: Boolean;
  protected
    procedure LoadIndex(idxfile: string); override;
  public
    constructor Create(); override;
    function Initialize(): Boolean; override;
    procedure Finalize; override;
    property bo16bit: Boolean read Fbo16bit;
  end;

  function ExtractFileNameOnly(const fname: string): string;
implementation

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

constructor TWMM2DefImages.Create;
begin
  inherited;
  FReadOnly := True;
  Fbo16bit := False;
end;

procedure TWMM2DefImages.Finalize;
begin
  inherited;
end;

function TWMM2DefImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    FFileStream.Read(FHeader, SizeOf(TWMImageHeader));
    Fbo16bit := FHeader.ColorCount = $10000;
    if FHeader.IndexOffset <> 0 then begin
      FNewFmt := True;
    end
    else begin
      FNewFmt := False;
      FFileStream.Seek(-4, soFromCurrent);
    end;
    FImageCount := FHeader.ImageCount;
    FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIX';
    LoadIndex(FIdxFile);
    InitializeTexture;
  end;
end;


procedure TWMM2DefImages.LoadIndex(idxfile: string);
var
  fhandle, i, value: integer;
  pvalue: PInteger;
  CharBuffer: array[0..4] of AnsiChar;
begin
  FIndexList.Clear;
  FImageCount := 0;
  if FileExists(idxfile) then begin
    fhandle := FileOpen(idxfile, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileRead(fhandle, CharBuffer[0], 5);
      if not (CompareText(string(CharBuffer), 'MirOf') = 0) then
        FileSeek(fHandle, 0, 0);

      if not FNewFmt then
        FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader) - 4)
      else
        FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader));

      if FIdxHeader.IndexCount > MAXIMAGECOUNT then exit;

      GetMem(pvalue, 4 * FIdxHeader.IndexCount);
      if FileRead(fhandle, pvalue^, 4 * FIdxHeader.IndexCount) = (4 * FIdxHeader.IndexCount) then begin
        for i := 0 to FIdxHeader.IndexCount - 1 do begin
          value := PInteger(integer(pvalue) + 4 * i)^;
          FIndexList.Add(pointer(value));
        end;
      end;
      FreeMem(pvalue);
      FileClose(fhandle);
    end;
    FImageCount := FIndexList.Count;
  end;
end;





end.

