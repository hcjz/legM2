unit WavUnit;

interface

uses
  Windows, Classes, SysUtils, Grobal2, SDK;

type
  TSounds = class
  private
    m_boLoadData:Boolean;                                                       // «∑Òº”‘ÿª∫¥Ê
    m_dwWavSize:LongWord;
    m_dwZipSize:LongWord;
    m_pZipData:PAnsiChar;
    m_pLoadData:PAnsiChar;
    m_sWavname:string;
    m_hFileStream:TFileStream;
    m_boInitialize:Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    function getWavSize():LongWord;
    function getZipSize():LongWord;
    function getWavData():PAnsiChar;
    function getZipData():PAnsiChar;
  public
    property FileName: string read m_sWavname write m_sWavname;
  end;

implementation

constructor TSounds.Create;
begin
  m_dwWavSize:= 0;
  m_dwZipSize:= 0;
  m_sWavname:= '';
  m_pZipData:= nil;
  m_pLoadData:= nil;
  m_boLoadData:= False;
  m_hFileStream:= nil;
  m_boInitialize:= False;
end;

procedure TSounds.Initialize;
begin
  if (m_sWavname = '') or m_boInitialize or (m_hFileStream <> nil) or (not FileExists(m_sWavname)) then
    exit;
  m_hFileStream := TFileStream.Create(m_sWavname, fmOpenReadWrite or fmShareDenyNone);
  if m_hFileStream <> nil then begin
    m_boInitialize := True;
    m_dwWavSize:= m_hFileStream.Seek(0, soEnd);
  end;
end;

function TSounds.getWavSize():LongWord;
begin
  result:= m_dwWavSize;
end;

function TSounds.getZipSize():LongWord;
begin
  Result:= m_dwZipSize;
  if not m_boLoadData then begin
    m_boLoadData:= True;
    GetMem(m_pLoadData, m_dwWavSize);
    FillChar(m_pLoadData^, m_dwWavSize, 0);
    m_hFileStream.Seek(0, soBeginning);
    m_hFileStream.Read(m_pLoadData^, m_dwWavSize);
    m_dwZipSize:= ZIPCompress(m_pLoadData, m_dwWavSize, DEFALUT_ZIP_LEVEL, m_pZipData);
    Result:= m_dwZipSize;
  end;
end;

function TSounds.getWavData():PAnsiChar;
begin
  Result:= m_pLoadData;
end;

function TSounds.getZipData():PAnsiChar;
begin
  Result:= m_pZipData;
end;

destructor TSounds.Destroy;
begin
  FreeMem(m_pZipData);
  FreeMem(m_pLoadData);
  m_pZipData:= nil;
  m_pLoadData:= nil;
  m_hFileStream.Free;
  m_hFileStream:= nil;
end;


end.
