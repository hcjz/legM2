unit EDcode;

interface

{$INCLUDE EDcodeCfg.inc}

uses
  Windows, SysUtils, Grobal2;

function EncodeMessage(sMsg: TDefaultMessage): string;
function DecodeMessage(Str: string): TDefaultMessage;
function EncodeString(Str: string): string;
function DecodeString(Str: string): string;
function EncodeBuffer(buf: PChar; bufsize: Integer): string;
function EncodeBuffer2(buf: PChar; bufsize: Integer): string;
procedure DecodeBuffer(src: string; buf: PChar; bufsize: Integer);
procedure DecodeBuffer2(src: string; buf: PChar; bufsize: Integer);
procedure Decode6BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
procedure Encode6BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer);
procedure Decode8BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
procedure Encode8BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer);
function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage;
function EncodeBuf(buf, len, DstBuf: Integer): Integer;
function DeCodeBuf(buf, len, DstBuf: Integer): Integer;

implementation

uses
  HUtil32;

function EncodeBuf(buf, len, DstBuf: Integer): Integer;
var
  no, i: Integer;
  temp, remainder, c, bySeed, byBase: Byte;
  RPos: Integer;
begin
  if (len = 0) or (PChar(buf) = nil) then begin
    Result := 0;
    Exit;
  end;

  no := 2;
  remainder := 0;
  RPos := DstBuf;
{$IFDEF SIGN3D}
  bySeed := $AC;
  byBase := $3C;
{$ELSE}
  bySeed := $EB; //BB
  byBase := $3B; //2B
{$ENDIF}
  for i := 0 to len - 1 do begin
    c := pByte(buf)^ xor bySeed;
    Inc(buf);
    if no = 6 then begin
      PChar(DstBuf)^ := Chr((c and $3F) + byBase);
      Inc(DstBuf);
      remainder := remainder or ((c shr 2) and $30);
      PChar(DstBuf)^ := Chr(remainder + byBase);
      Inc(DstBuf);
      remainder := 0;
    end else begin
      temp := c shr 2;
      PChar(DstBuf)^ := Chr(((temp and $3C) or (c and $3)) + byBase);
      Inc(DstBuf);
      remainder := (remainder shl 2) or (temp and $3);
    end;
    no := no mod 6 + 2;
  end;
  if no <> 2 then begin
    PChar(DstBuf)^ := Chr(remainder + byBase);
    Inc(DstBuf);
  end;
  Result := DstBuf - RPos;
  PChar(DstBuf)^ := #0;
end;

function DeCodeBuf(buf, len, DstBuf: Integer): Integer;
var
  nCycles, nBytesLeft, i, CurCycleBegin: Integer;
  temp, remainder, c, bySeed, byBase: Byte;
  RPos: Integer;
begin
  if (len = 0) or (PChar(buf) = nil) then begin
    Result := 0;
    Exit;
  end;

  RPos := DstBuf;
  nCycles := len div 4;
  nBytesLeft := len mod 4;
{$IFDEF SIGN3D}
  bySeed := $AC;
  byBase := $3C;
{$ELSE}
  bySeed := $EB; //$BB
  byBase := $3B; //2B
{$ENDIF}
  for i := 0 to nCycles - 1 do begin
    CurCycleBegin := i * 4;
    remainder := pByte(buf + CurCycleBegin + 3)^ - byBase;
    temp := pByte(buf + CurCycleBegin)^ - byBase;
    c := ((temp shl 2) and $F0) or (remainder and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
    temp := pByte(buf + CurCycleBegin + 1)^ - byBase;
    c := ((temp shl 2) and $F0) or ((remainder shl 2) and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
    temp := pByte(buf + CurCycleBegin + 2)^ - byBase;
    c := temp or ((remainder shl 2) and $C0);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
  end;
  if nBytesLeft = 2 then begin
    remainder := pByte(buf + len - 1)^ - byBase;
    temp := pByte(buf + len - 2)^ - byBase;
    c := ((temp shl 2) and $F0) or ((remainder shl 2) and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
  end else if nBytesLeft = 3 then begin
    remainder := pByte(buf + len - 1)^ - byBase;
    temp := pByte(buf + len - 3)^ - byBase;
    c := ((temp shl 2) and $F0) or (remainder and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
    temp := pByte(buf + len - 2)^ - byBase;
    c := ((temp shl 2) and $F0) or ((remainder shl 2) and $0C) or (temp and $3);
    PChar(DstBuf)^ := Chr(c xor bySeed);
    Inc(DstBuf);
  end;
  Result := DstBuf - RPos;
  PChar(DstBuf)^ := #0;
end;

function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): TDefaultMessage;
begin
  Result.Recog := nRecog;
  Result.Ident := wIdent;
  Result.Param := wParam;
  Result.Tag := wTag;
  Result.Series := wSeries;
end;

procedure Encode6BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer);
var
  i, nRestCount, nDestPos: Integer;
  btMade, btCh, btRest: Byte;
begin
  nRestCount := 0;
  btRest := 0;
  nDestPos := 0;
  for i := 0 to nSrcLen - 1 do begin
    if nDestPos >= nDestLen then Break;
    btCh := Byte(pSrc[i]);
    btMade := Byte((btRest or (btCh shr (2 + nRestCount))) and $3F);
    btRest := Byte(((btCh shl (8 - (2 + nRestCount))) shr 2) and $3F);
    Inc(nRestCount, 2);
    if nRestCount < 6 then begin
      PDest[nDestPos] := Char(btMade + $3C);
      Inc(nDestPos);
    end else begin
      if nDestPos < nDestLen - 1 then begin
        PDest[nDestPos] := Char(btMade + $3C);
        PDest[nDestPos + 1] := Char(btRest + $3C);
        Inc(nDestPos, 2);
      end else begin
        PDest[nDestPos] := Char(btMade + $3C);
        Inc(nDestPos);
      end;
      nRestCount := 0;
      btRest := 0;
    end;
  end;
  if nRestCount > 0 then begin
    PDest[nDestPos] := Char(btRest + $3C);
    Inc(nDestPos);
  end;
  PDest[nDestPos] := #0;
end;

procedure Decode6BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
const
  Masks: array[2..6] of Byte = ($FC, $F8, $F0, $E0, $C0);
var
  i, {nLen,} nBitPos, nMadeBit, nBufPos: Integer;
  btCh, btTmp, btByte: Byte;
begin
  nBitPos := 2;
  nMadeBit := 0;
  nBufPos := 0;
  btTmp := 0;
  btCh := 0;
  for i := 0 to nSrcLen - 1 do begin
    if Integer(sSource[i]) - $3C >= 0 then
      btCh := Byte(sSource[i]) - $3C
    else begin
      nBufPos := 0;
      Break;
    end;
    if nBufPos >= nBufLen then Break;
    if (nMadeBit + 6) >= 8 then begin
      btByte := Byte(btTmp or ((btCh and $3F) shr (6 - nBitPos)));
      pBuf[nBufPos] := Char(btByte);
      Inc(nBufPos);
      nMadeBit := 0;
      if nBitPos < 6 then Inc(nBitPos, 2)
      else begin
        nBitPos := 2;
        Continue;
      end;
    end;
    btTmp := Byte(Byte(btCh shl nBitPos) and Masks[nBitPos]);
    Inc(nMadeBit, 8 - nBitPos);
  end;
  pBuf[nBufPos] := #0;
end;

function DecodeMessage(Str: string): TDefaultMessage;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
  Msg: TDefaultMessage;
begin
{$IFDEF ISWOL}
  {EnterCriticalSection(CSEncode);
  try}
  if Str = '' then begin
    FillChar(Msg, SizeOf(Msg), 0);
    Result := Msg;
    Exit;
  end;
  DeCodeBuf(Integer(PChar(Str)), Length(Str), Integer(@EncBuf));
  Move(EncBuf, Msg, SizeOf(TDefaultMessage));
  Result := Msg;
  {finally
    LeaveCriticalSection(CSEncode);
  end;}
{$ELSE}
  Decode6BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
  Move(EncBuf, Msg, SizeOf(TDefaultMessage));
  Result := Msg;
{$ENDIF}
end;

function DecodeString(Str: string): string;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
begin
{$IFDEF ISWOL}
  {EnterCriticalSection(CSEncode);
  try}
  if Str = '' then begin
    Result := '';
    Exit;
  end;
  DeCodeBuf(Integer(PChar(Str)), Length(Str), Integer(@EncBuf));
  Result := StrPas(EncBuf);
  {finally
    LeaveCriticalSection(CSEncode);
  end;}
{$ELSE}
  Decode6BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
{$ENDIF}
end;

procedure DecodeBuffer(src: string; buf: PChar; bufsize: Integer);
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
begin
{$IFDEF ISWOL}
  {EnterCriticalSection(CSEncode);
  try}
  if src = '' then begin
    Exit;
  end;
  DeCodeBuf(Integer(PChar(src)), Length(src), Integer(@EncBuf));
  Move(EncBuf, buf^, bufsize);
  {finally
    LeaveCriticalSection(CSEncode);
  end;}
{$ELSE}
  Decode6BitBuf(PChar(src), @EncBuf, Length(src), SizeOf(EncBuf));
  Move(EncBuf, buf^, bufsize);
{$ENDIF}
end;

procedure DecodeBuffer2(src: string; buf: PChar; bufsize: Integer);
var
  EncBuf: array[0..BUFFERSIZE * 2 - 1] of Char;
begin
{$IFDEF ISWOL}
  {EnterCriticalSection(CSEncode);
  try}
  DeCodeBuf(Integer(PChar(src)), Length(src), Integer(@EncBuf));
  Move(EncBuf, buf^, bufsize);
  {finally
    LeaveCriticalSection(CSEncode);
  end;}
{$ELSE}
  Decode6BitBuf(PChar(src), @EncBuf, Length(src), SizeOf(EncBuf));
  Move(EncBuf, buf^, bufsize);
{$ENDIF}
end;

function EncodeMessage(sMsg: TDefaultMessage): string;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
begin
{$IFDEF ISWOL}
  //Move(sMsg, TempBuf, SizeOf(TDefaultMessage));
  {EnterCriticalSection(CSEncode);
  try}
  EncodeBuf(Integer(@sMsg), SizeOf(TDefaultMessage), Integer(@EncBuf));
  Result := StrPas(EncBuf);
  {finally
    LeaveCriticalSection(CSEncode);
  end;}
{$ELSE}
  Move(sMsg, TempBuf, SizeOf(TDefaultMessage));
  Encode6BitBuf(@TempBuf, @EncBuf, SizeOf(TDefaultMessage), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
{$ENDIF}
end;

function EncodeString(Str: string): string;
var
  EncBuf: array[0..BUFFERSIZE - 1] of Char;
begin
  if Str = '' then begin
    Result := '';
    Exit;
  end;

{$IFDEF ISWOL}
  {EnterCriticalSection(CSEncode);
  try}
  EncodeBuf(Integer(PChar(Str)), Length(Str), Integer(@EncBuf));
  Result := StrPas(EncBuf);
  {finally
    LeaveCriticalSection(CSEncode);
  end;}
{$ELSE}
  Encode6BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
{$ENDIF}
end;

function EncodeBuffer(buf: PChar; bufsize: Integer): string;
var
  EncBuf, TempBuf: array[0..BUFFERSIZE - 1] of Char;
begin
  if (buf = nil) or (bufsize = 0) then begin
    Result := '';
    Exit;
  end;
{$IFDEF ISWOL}
  {EnterCriticalSection(CSEncode);
  try}
  if bufsize < BUFFERSIZE then begin
    Move(buf^, TempBuf, bufsize);
    EncodeBuf(Integer(@TempBuf), bufsize, Integer(@EncBuf));
    Result := StrPas(EncBuf);
  end else
    Result := '';
  {finally
    LeaveCriticalSection(CSEncode);
  end;}
{$ELSE}
  if bufsize < BUFFERSIZE then begin
    Move(buf^, TempBuf, bufsize);
    Encode6BitBuf(@TempBuf, @EncBuf, bufsize, SizeOf(EncBuf));
    Result := StrPas(EncBuf);
  end else
    Result := '';
{$ENDIF}
end;

function EncodeBuffer2(buf: PChar; bufsize: Integer): string;
var
  EncBuf, TempBuf: array[0..BUFFERSIZE * 2 - 1] of Char;
begin
  if (buf = nil) or (bufsize = 0) then begin
    Result := '';
    Exit;
  end;
{$IFDEF ISWOL}
  {EnterCriticalSection(CSEncode);
  try}
  if bufsize < BUFFERSIZE * 2 then begin
    Move(buf^, TempBuf, bufsize);
    EncodeBuf(Integer(@TempBuf), bufsize, Integer(@EncBuf));
    Result := StrPas(EncBuf);
  end else
    Result := '';
  {finally
    LeaveCriticalSection(CSEncode);
  end;}
{$ELSE}
  if bufsize < BUFFERSIZE then begin
    Move(buf^, TempBuf, bufsize);
    Encode6BitBuf(@TempBuf, @EncBuf, bufsize, SizeOf(EncBuf));
    Result := StrPas(EncBuf);
  end else
    Result := '';
{$ENDIF}
end;

{function MyEnCodeString(Str: string): string;
//var
  //EncBuf                    : array[0..BUFFERSIZE - 1] of Char;
begin
  Encode8BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
end;

function MyDeCodeString(Str: string): string;
//var
  //EncBuf                    : array[0..BUFFERSIZE - 1] of Char;
begin
  Decode8BitBuf(PChar(Str), @EncBuf, Length(Str), SizeOf(EncBuf));
  Result := StrPas(EncBuf);
end;}

procedure Encode8BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer);
var
  i, nRestCount, nDestPos: Integer;
  btMade, btCh, btRest: Byte;
begin
  nRestCount := 0;
  btRest := 0;
  nDestPos := 0;
  for i := 0 to nSrcLen - 1 do begin
    if nDestPos >= nDestLen then Break;
    btCh := Byte(pSrc[i]);
    btMade := Byte((btRest or (btCh shr (2 + nRestCount))) and $3F);
    btRest := Byte(((btCh shl (8 - (2 + nRestCount))) shr 2) and $3F);
    Inc(nRestCount, 2);
    if nRestCount < 6 then begin
      PDest[nDestPos] := Char(btMade + $23);
      Inc(nDestPos, 1);
    end else begin
      if nDestPos < nDestLen - 1 then begin
        PDest[nDestPos] := Char(btMade + $23);
        PDest[nDestPos + 1] := Char(btRest + $23);
        Inc(nDestPos, 2);
      end else begin
        PDest[nDestPos] := Char(btMade + $23);
        Inc(nDestPos, 1);
      end;
      nRestCount := 0;
      btRest := 0;
    end;
  end;
  if nRestCount > 0 then begin
    PDest[nDestPos] := Char(btRest + $23);
    Inc(nDestPos, 1);
  end;
  PDest[nDestPos] := #0;
end;

procedure Decode8BitBuf(sSource: PChar; pBuf: PChar; nSrcLen, nBufLen: Integer);
const
  Masks: array[2..6] of Byte = ($FC, $F8, $F0, $E0, $C0);
var
  i, nBitPos, nMadeBit, nBufPos: Integer;
  btCh, btTmp, btByte: Byte;
begin
  nBitPos := 2;
  nMadeBit := 0;
  nBufPos := 0;
  btTmp := 0;
  btCh := 0;
  for i := 0 to nSrcLen - 1 do begin
    if Integer(sSource[i]) - $23 >= 0 then
      btCh := Byte(sSource[i]) - $23
    else begin
      nBufPos := 0;
      Break;
    end;
    if nBufPos >= nBufLen then Break;
    if (nMadeBit + 6) >= 8 then begin
      btByte := Byte(btTmp or ((btCh and $3F) shr (6 - nBitPos)));
      pBuf[nBufPos] := Char(btByte);
      Inc(nBufPos, 1);
      nMadeBit := 0;
      if nBitPos < 6 then Inc(nBitPos, 2)
      else begin
        nBitPos := 2;
        Continue;
      end;
    end;
    btTmp := Byte(Byte(btCh shl nBitPos) and Masks[nBitPos]);
    Inc(nMadeBit, 8 - nBitPos);
  end;
  pBuf[nBufPos] := #0;
end;

(*
function EnCrypt(Str: string; Key: string): string;
var
  KeyLen, KeyPos, Offset, SrcPos, SrcAsc: Integer;
  Dest                      : ShortString;
begin
  {if Str <> '' then begin
    KeyLen := Length(Key);
    KeyPos := 0;
    Randomize;
    Offset := Random(256);
    Dest := Format('%1.2x', [Offset]);
    for SrcPos := 1 to Length(Str) do begin
      SrcAsc := (Ord(Str[SrcPos]) + Offset) mod 255;
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      SrcAsc := SrcAsc xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x', [SrcAsc]);
      Offset := SrcAsc;
    end;
    Result := Dest;
  end else
    Result := ''; }
  Result := __En__(Str, Key);
end;

function DeCrypt(Str: string; Key: string): string;
var
  KeyLen, KeyPos, Offset, SrcPos, SrcAsc, TmpSrcAsc: Integer;
  Dest                      : string;
  //iStrL                     : Integer;
begin
  {if Str <> '' then begin
    //iStrL := Length(Str);
    //Str := LeftStr(Str, iStrL - 1);
    //Str := RightStr(Str, iStrL - 2);
    KeyLen := Length(Key);
    KeyPos := 0;
    Offset := StrToInt('$' + Copy(Str, 1, 2));
    SrcPos := 3;
    repeat
      SrcAsc := StrToInt('$' + Copy(Str, SrcPos, 2));
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
      if TmpSrcAsc <= Offset then
        TmpSrcAsc := 255 + TmpSrcAsc - Offset
      else
        TmpSrcAsc := TmpSrcAsc - Offset;
      Dest := Dest + Chr(TmpSrcAsc);
      Offset := SrcAsc;
      SrcPos := SrcPos + 2;
    until SrcPos >= Length(Str);
    Result := Dest;
  end else
    Result := '';}
  Result := __De__(Str, Key);
end;
*)
initialization
  //InitializeCriticalSection(CSEncode);

finalization
  //DeleteCriticalSection(CSEncode);

end.
