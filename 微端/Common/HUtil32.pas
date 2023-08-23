unit HUtil32;

interface

function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
function GetValidStr3 (Str: string; var Dest: string; const Divider: array of Char): string;

implementation

function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
var
  SrcLen: Integer;
  n: Integer;
begin
  ArrestStr := '';
  Result := '';
  try
    SrcLen := Length(Source);
    if SrcLen <= 2 then
      Exit;
    if Source[1] = SearchAfter then
    begin
      Source := Copy(Source, 2, SrcLen - 1);
      SrcLen := Length(Source);
    end
    else
    begin
      n := Pos(SearchAfter, Source);
      if n > 0 then
      begin
        Source := Copy(Source, n + 1, SrcLen - (n));
        SrcLen := Length(Source);
      end
      else
      begin
        ArrestStr := '';
        Result := '';
        exit;
      end;
    end;

    n := Pos(ArrestBefore, Source);
    if n > 0 then
    begin
      ArrestStr := Copy(Source, 1, n - 1);
      Result := Copy(Source, n + 1, SrcLen - n);
    end
    else
    begin
      Result := SearchAfter + Source;
    end;
  except
    ArrestStr := '';
    Result := '';
  end;
end;

function GetValidStr3 (Str: string; var Dest: string; const Divider: array of Char): string;
const
   BUF_SIZE = 20480; //$7FFF;
var
	Buf: array[0..BUF_SIZE] of char;
   BufCount, Count, SrcLen, I, ArrCount: Longint;
   Ch: char;
label
	CATCH_DIV;
begin
  Ch:=#0;//Jacky
   try
      SrcLen := Length(Str);
      BufCount := 0;
      Count := 1;

      if SrcLen >= BUF_SIZE-1 then begin
         Result := '';
         Dest := '';
         exit;
      end;

      if Str = '' then begin
         Dest := '';
         Result := Str;
         exit;
      end;
      ArrCount := sizeof(Divider) div sizeof(char);

      while TRUE do begin
         if Count <= SrcLen then begin
            Ch := Str[Count];
            for I:=0 to ArrCount- 1 do
               if Ch = Divider[I] then
                  goto CATCH_DIV;
         end;
         if (Count > SrcLen) then begin
            CATCH_DIV:
            if (BufCount > 0) then begin
               if BufCount < BUF_SIZE-1 then begin
                  Buf[BufCount] := #0;
                  Dest := string (Buf);
                  Result := Copy (Str, Count+1, SrcLen-Count);
               end;
               break;
            end else begin
               if (Count > SrcLen) then begin
                  Dest := '';
                  Result := Copy (Str, Count+2, SrcLen-1);
                  break;
               end;
            end;
         end else begin
            if BufCount < BUF_SIZE-1 then begin
               Buf[BufCount] := Ch;
               Inc (BufCount);
            end;// else
               //ShowMessage ('BUF_SIZE overflow !');
         end;
         Inc (Count);
      end;
   except
      Dest := '';
      Result := '';
   end;
end;

end.
