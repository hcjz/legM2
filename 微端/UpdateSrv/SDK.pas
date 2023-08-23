unit SDK;

interface

uses
  ZLIB;

type
  TZIPLevel = 0..9;

  function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PAnsiChar): Integer;

implementation

function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then begin
    //{$IF CompilerVersion >= 21.0}
    //raise EZCompressionError.Create('ZIP Error');
   // {$ELSE}
    raise ECompressionError.Create('ZIP Error');
   // {$IFEND}
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
    //{$IF CompilerVersion >= 21.0}
    //strm.next_out := PByte(OutBuf);
    //{$ELSE}
    strm.next_out := OutBuf;
    //{$IFEND}
    strm.avail_out := Result;
    CCheck(deflateInit_(strm, Level, zlib_version, sizeof(strm)));
    try
      while CCheck(deflate(strm, Z_FINISH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, 256);
        ReallocMem(OutBuf, Result);
        //{$IF CompilerVersion >= 21.0}
        //strm.next_out := PByte(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        //{$ELSE}
        strm.next_out := PAnsiChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        //{$IFEND}
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

end.
