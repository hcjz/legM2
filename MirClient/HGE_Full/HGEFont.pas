unit HGEFont;

interface
uses
  Windows, Classes, Graphics, SysUtils, HGE, HGEBase, HGETextures, DirectXGraphics,D3DX81mo,
  Math, Forms;

type
  TBugTextOut = procedure(Msg: string);

  pTFontText = ^TFontText;
  TFontText = packed record
    Font: TDXTexture;
    Text: string;
    Time: LongWord;
    Name: TFontName;
    Size: Integer;
    Style: TFontStyles;
    FColor: TColor;
    Bcolor: TColor;
  end;

  TImageFont = class
    FontList: TList;
    FontTextList: TList;
    FreeOutTimeTick: LongWord;
    FreeFontTextOutTimeTick: LongWord;
  private
    procedure FreeOutTime;
    procedure FreeFontTextOutTime;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Clear;
    function TextHeight(const Text: string): Integer;
    function TextWidth(const Text: string): Integer;
    procedure FreeOldMemorys();
    function GetTextDIB(Text: string; FColor: TColor; BColor: TColor = clBlack): TDXTexture;
    function GetTextDIBEX(Text: string; FColor: TColor; BColor: TColor = clBlack): TDXTexture;
  end;

var
  ImageFont: TImageFont = nil;
  MainForm: TForm = nil;
  BugTextOut: TBugTextOut = nil;

implementation

procedure TextOutFile(Msg: string);
begin
  if @BugTextOut <> nil then
    BugTextOut(Msg);
end;

constructor TImageFont.Create();
begin
  FontList := TList.Create;
  FontTextList := TList.Create;
  FreeOutTimeTick := GetTickCount;
  FreeFontTextOutTimeTick := GetTickCount;
end;

destructor TImageFont.Destroy;
begin
  Clear;
  FontList.Free;
  FontTextList.Free;
  inherited;
end;

procedure TImageFont.Clear;
var
  I: Integer;
  FontText: pTFontText;
begin
  for I := 0 to FontList.Count - 1 do begin
    FontText := FontList.Items[I];
    FontText.Font.Free;
    Dispose(FontText);
  end;
  FontList.Clear;

  for I := 0 to FontTextList.Count - 1 do begin
    FontText := FontTextList.Items[I];
    FontText.Font.Free;
    Dispose(FontText);
  end;
  FontTextList.Clear;
end;

procedure TImageFont.FreeOldMemorys();
begin
  FreeOutTime;
  FreeFontTextOutTime;
end;

procedure TImageFont.FreeOutTime;
var
  I: Integer;
  FontText: pTFontText;
begin
  if (GetTickCount - FreeOutTimeTick > 1000 * 10) then begin
    FreeOutTimeTick := GetTickCount;

    for I := FontList.Count - 1 downto 0 do begin
      FontText := FontList.Items[I];
      if (GetTickCount - FontText.Time > 1000 * 60 * 2) then begin
        FontList.Delete(I);

        try
          FontText.Font.Free;
        except
          TextOutFile('FreeOutTimeTick1');
        end;

        try
          Dispose(FontText);
        except
          TextOutFile('FreeOutTimeTick2');
        end;
      end;
    end;
  end;
end;

procedure TImageFont.FreeFontTextOutTime;
var
  I: Integer;
  FontText: pTFontText;
begin
  if (GetTickCount - FreeFontTextOutTimeTick > 1000 * 10) then begin
    FreeFontTextOutTimeTick := GetTickCount;

    for I := FontTextList.Count - 1 downto 0 do begin
      FontText := FontTextList.Items[I];
      if (GetTickCount - FontText.Time > 1000 * 60 * 2) then begin
        FontTextList.Delete(I);

        try
          FontText.Font.Free;
        except
          TextOutFile('FreeFontTextOutTime1');
        end;

        try
          Dispose(FontText);
        except
          TextOutFile('FreeFontTextOutTime2');
        end;
      end;
    end;
  end;
end;

function TImageFont.TextWidth(const Text: string): Integer;
var
  HHDC: hdc;
  tempDC: hdc;
  Point: Size;
begin
 // 创建兼容DC并选入字体          TextWidth(Text), DIB.TextHeight
  tempDC := GetDC(MainForm.Handle);
  HHDC := CreateCompatibleDC(tempDC);
  SelectObject(HHDC, MainForm.Canvas.Font.Handle);
  Windows.GetTextExtentPoint32(HHDC, PChar(Text), Length(Text), Point);
  Result := Point.cx;
  DeleteDC(HHDC);
  ReleaseDC(0, tempDC);
end;

function TImageFont.TextHeight(const Text: string): Integer;
var
  HHDC: hdc;
  tempDC: hdc;
  Point: Size;
begin
 // 创建兼容DC并选入字体          TextWidth(Text), DIB.TextHeight
  tempDC := GetDC(MainForm.Handle);
  HHDC := CreateCompatibleDC(tempDC);
  SelectObject(HHDC, MainForm.Canvas.Font.Handle);
  Windows.GetTextExtentPoint32(HHDC, PChar(Text), Length(Text), Point);
  Result := Point.cy;
  DeleteDC(HHDC);
  ReleaseDC(0, tempDC);
end;

function TImageFont.GetTextDIB(Text: string; FColor: TColor; BColor: TColor): TDXTexture;
var
  I: Integer;
  FontText: pTFontText;
begin
  Result := nil;
  if FColor = clBlack then FColor := $00050505;
  for I := 0 to FontList.Count - 1 do begin
    FontText := FontList.Items[I];
    if (CompareStr(FontText.Text, Text) = 0) and
      (CompareText(MainForm.Canvas.Font.Name, FontText.Name) = 0) and
      (MainForm.Canvas.Font.Size = FontText.Size) and
      (MainForm.Canvas.Font.Style = FontText.Style) and
      (FColor = FontText.FColor) and
      (BColor = FontText.BColor) then begin
      FontText.Time := GetTickCount;
      Result := FontText.Font;
      Exit;
    end;
  end;
end;

function TImageFont.GetTextDIBEX(Text: string; FColor: TColor; BColor: TColor): TDXTexture;
var
  I: Integer;
  FontText: pTFontText;
begin
  Result := nil;
  if FColor = clBlack then FColor := $00050505;
  for I := 0 to FontTextList.Count - 1 do begin
    FontText := FontTextList.Items[I];
    if (CompareStr(FontText.Text, Text) = 0) and
      (CompareText(MainForm.Canvas.Font.Name, FontText.Name) = 0) and
      (MainForm.Canvas.Font.Size = FontText.Size) and
      (MainForm.Canvas.Font.Style = FontText.Style) and
      (FColor = FontText.FColor) and
      (BColor = FontText.BColor) then begin
      FontText.Time := GetTickCount;
      Result := FontText.Font;
      Exit;
    end;
  end;
end;

end.
