unit MapUnit;

interface

uses
  Windows, Classes, SysUtils, Grobal2;



type
  TMapHeader = packed record
    wWidth: Word;
    wHeight: Word;
    sTitle: string[15];
    UpdateDate: TDateTime;
    Reserved: array[0..23] of Char;
  end;

  TLegendMap = class
  private
    m_dwMapSize:LongWord;                                                       //解压大小
    m_dwZipSize:LongWord;                                                       //压缩大小
    m_sMapname:string;
    m_pLoadData:PAnsiChar;
    m_pZipData:PAnsiChar;
    m_boLoadData:Boolean;
    m_hFileStream:TFileStream;
    m_boInitialize:Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    function getMapSize():LongWord;
    function getZipSize():LongWord;
    function getMapData():PAnsiChar;
    function getZipData():PAnsiChar;
  public
    property FileName: string read m_sMapname write m_sMapname;
  end;

implementation

uses
  SDK;

constructor TLegendMap.Create;
begin
  m_boLoadData:=False;
  m_dwMapSize:= 0;
  m_dwZipSize:= 0;
  m_sMapname:= '';
  m_pZipData:= nil;
  m_pLoadData:= nil;
  m_hFileStream:= nil;
  m_boInitialize:= False;
end;

procedure TLegendMap.Initialize;
begin
  if (m_sMapname = '') or m_boInitialize or (m_hFileStream <> nil) or (not FileExists(m_sMapname)) then
    exit;
  m_hFileStream := TFileStream.Create(m_sMapname, fmOpenReadWrite or fmShareDenyNone);
  if m_hFileStream <> nil then begin
    m_boInitialize := True;
    m_dwMapSize:= m_hFileStream.Seek(0, soEnd);
  end;
end;

function TLegendMap.getMapSize():LongWord;
begin
  result:= m_dwMapSize;
end;

function TLegendMap.getZipSize():LongWord;
begin
  Result:= m_dwZipSize;
  if not m_boLoadData then begin
    m_boLoadData:= True;
    GetMem(m_pLoadData, m_dwMapSize);
    FillChar(m_pLoadData^, m_dwMapSize, 0);
    m_hFileStream.Seek(0, soBeginning);
    m_hFileStream.Read(m_pLoadData^, m_dwMapSize);
    m_dwZipSize:= ZIPCompress(m_pLoadData, m_dwMapSize, DEFALUT_ZIP_LEVEL, m_pZipData);
    Result:= m_dwZipSize;
  end;
end;

function TLegendMap.getMapData():PAnsiChar;
begin
  Result:= m_pLoadData;
end;

function TLegendMap.getZipData():PAnsiChar;
begin
  Result:= m_pZipData;
end;

destructor TLegendMap.Destroy;
begin
  FreeMem(m_pZipData);
  FreeMem(m_pLoadData);
  m_pZipData:= nil;
  m_pLoadData:= NIL;
  m_hFileStream.Free;
  m_hFileStream:= nil;
end;

end.
