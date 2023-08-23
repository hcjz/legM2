{ A speedbutton kind o button with regular,inset,explorer and no border styles }
{ by Peter Thörnqvist Jan 1997                                        }
{ 15 mar 1997: fixed MouseEnter/ MouseExit omission                   }
{ 7 apr 1997: fixed stupid bug in MouseMove handler (thanks to Magnus Myhrberg) }
{ 19 April 1997: Added Explorer style button and run-time mov(e?)able.
    (thanks to Alejandro Llorca)																			 }
{ 2 May 1997: added support for unfocused bitmap (fsExplorer) and
              disabled bitmap                                         }
{ 19 May 1997: added support for Down, Wordwrap and PopUpMenu         }
{ 16 june 1997: added CMEnabledChanged handler so button will go up   }
{ when disabled programmatically and also fixed csDoubleClicks bug (both by Sebastien Gandon) }
unit TransBtn;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,  CommCtrl,
  ExtCtrls,Menus, Forms;


type
  TNumGlyphs = 1..4;
  TFrameStyle = (fsRegular,fsIndent,fsExplorer,fsNone,fsLight,fsDark,fsMono);
  TButtonState=(bsUp,bsDown,bsExclusive);
  TTextAlign=(ttaTopLeft,ttaTop,ttaTopRight,ttaRight,ttaBottomRight,
              ttaBottom,ttaBottomLeft,ttaLeft,ttaCenter);

type
  TTransparentButton = class(TGraphicControl)
  private
    FIsDown:           Boolean;
    FTextAlign:        TTextAlign;
    FCaption:          TCaption;
    FAutoGray:         Boolean;          
    FTransparent:      Boolean;
    FMouseDown:        Boolean;
    FMouseInside:      Boolean;
    FShowPressed:      Boolean;
    FSpacing:          integer;
    FGlyph:            TBitmap;
    FGrayGlyph:        TBitmap;
    FPopUpMenu:        TPopUpMenu;
    FDisabledGlyph:    TBitmap;
    FState:            TButtonState;
    FBorderSize:       Cardinal;
    FNumGlyphs:        TNumGlyphs;
    ImList:            TImageList;
    FOutline:          TFrameStyle;
    FOnMouseEnter:     TNotifyEvent;
    FOnMouseExit:      TNotifyEvent;
    FInsideButton:     Boolean;
    FWordWrap:         Boolean;
    FStayDown:         Boolean;
    { added by Alejandro Llorca }
    FMovable:          Boolean; { to make it movable at runtime}
    PosY,PosX:         integer; {mousepos on start drag}
		 { ... }
{    Norris}
    FPattern: TBitmap;   {Fill pattern when button is set to stay down}
    procedure SetStayDown(Value:boolean);
    procedure SetWordWrap(Value:boolean);
    procedure SetSpacing(Value:integer);
    procedure SetTextAlign(Value:TTextAlign);
    procedure SetCaption(Value: TCaption);
    procedure SetGlyph(Bmp: TBitmap);
    procedure SetNumGlyphs(Value: TNumGlyphs);
    procedure SetFrameStyle(Value: TFrameStyle);
    procedure SetTransparent(Value:boolean);
    procedure SetBorderWidth(Value:Cardinal);
    procedure GlyphChanged(Sender:TObject);
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure Notification(AComponent: TComponent; Operation:TOperation);override;
    procedure AddGlyphs(aGlyph:TBitmap;aColor:TColor;Value:integer);
    procedure DrawTheText(aRect: TRect);
    procedure DrawTheBitmap(aRect:TRect);
    function  InsideBtn(X,Y: Integer): boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure Paint;  override;
    procedure PaintButton;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Click;override;
    property Canvas;
  published
    property AutoGray:boolean read FAutoGray write FAutoGray default True;
    property BorderWidth:Cardinal read FBorderSize write SetBorderWidth default 1;
    property Caption: TCaption read FCaption write SetCaption;
    property Down: boolean read FStayDown write SetStayDown default False;
    property Enabled;
    property Font;
    property FrameStyle: TFrameStyle read FOutline write SetFrameStyle default fsExplorer;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property NumGlyphs: TNumGlyphs read FNumGlyphs write SetNumGlyphs default 1;
    property ParentFont;
    property ParentShowHint;
    property PopUpMenu: TPopUpMenu read FPopUpMenu write FPopUpMenu;
    property ShowHint;
    property ShowPressed:boolean read FShowPressed write FShowPressed default True;
    property Spacing:integer read FSpacing write SetSpacing default 2;
    property TextAlign:TTextAlign read FTextAlign write SetTextAlign default ttaCenter;
    property Transparent: boolean read FTransparent write SetTransparent default True;
    property Visible;
    property WordWrap:boolean read FWordWrap write SetWordWrap default False;
    property OnClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseExit:  TNotifyEvent read FOnMouseExit  write FOnMouseExit;
    { AL: }
    property Movable: Boolean read FMovable write FMovable default False;
  end;


procedure Register;

implementation

{ create a grayed version of a color bitmap }
{ SLOW! don't use in realtime! }
procedure MonoBitmap(Bmp:TBitmap;R,G,B:integer);
var i,j:integer;col:longint;
begin
  if Bmp.Empty then Exit;
  for i := 0 to Bmp.Width do
    for j := 0 to Bmp.Height do
    begin
      Col := Bmp.Canvas.Pixels[i,j];
      Col := (GetRValue(Col)*R + GetGValue(Col)*G + GetBValue(Col)*B) div (R+G+B);
      Bmp.Canvas.Pixels[i,j] := RGB(Col,Col,Col);
    end;
end;

{ create a disabled bitmap from a regular one, works best when bitmap has been
reduced to a few colors. Used by BWBitmap }
procedure DisabledBitmap(Bmp:TBitmap);
const ROP_DSPDxax = $00E20746;
var MonoBmp,TmpImage: TBitmap;
    W,H:integer;
begin
 if Bmp.Empty then Exit;
	MonoBmp := TBitmap.Create;
 TmpImage := TBitmap.Create;
 W := Bmp.Width;
 H := Bmp.Height;

 with TmpImage do
 begin
   Width := W;
   Height := H;
   Canvas.Brush.Color := clBtnFace;
 end;

	try
   with MonoBmp do
   begin
     Assign(Bmp);
     Canvas.Font.Color := clWhite;
     Canvas.Brush.Color := clBlack;
     Monochrome := True;
   end;

   with TmpImage.Canvas do
   begin
     Brush.Color := clBtnFace;
     FillRect(Rect(0,0,W,H));
     Brush.Color := clBtnHighLight;
     SetTextColor(Handle, clBlack);
     SetBkColor(Handle, clWhite);
     BitBlt(Handle, 1, 1, W+1, H+1,MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
     Brush.Color := clBtnShadow;
     SetTextColor(Handle, clBlack);
     SetBkColor(Handle, clWhite);
     BitBlt(Handle, 0, 0, W, H,MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
   end;
   Bmp.Assign(TmpImage);
finally
 MonoBmp.Free;
 TmpImage.Free;
end;
end;

{ create a disabled bitmap by changing all colors to either black or tCol and then
  running it through DisabledBitmap }
{ SLOW! don't use in realtime! }
procedure BWBitmap(Bmp:TBitmap);
var i,j,W,H:integer;tcol:TColor;col:longint;
begin
  if Bmp.Empty then Exit;

  W := Bmp.Width;
  H := Bmp.Height;
  tCol := Bmp.Canvas.Pixels[0,0];

  for i := 0 to W do
    for j := 0 to H do
    begin
    Col := Bmp.Canvas.Pixels[i,j];
    if (Col <> clWhite) and (Col <> tCol) then
      Col := clBlack
    else
      Col := tCol;
    Bmp.Canvas.Pixels[i,j] := Col;
    end;
  DisabledBitmap(Bmp);
end;

function CreateBrushPattern: TBitmap;
var X, Y: Integer;
begin
  Result := TBitmap.Create;
  Result.Width := 8;     { must have this size }
  Result.Height := 8;
  with Result.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;
    FillRect(Rect(0, 0, Result.Width, Result.Height));
    for Y := 0 to 7 do
      for X := 0 to 7 do
        if (Y mod 2) = (X mod 2) then  { toggles between even/odd pixles }
          Pixels[X, Y] := clWhite;     { on even/odd rows }
  end;
end;

constructor TTransparentButton.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   if (csOpaque in ControlStyle) then
     ControlStyle := ControlStyle - [csOpaque];
   if (csDoubleClicks in ControlStyle) then
     ControlStyle := ControlStyle - [csDoubleClicks];
   FNumGlyphs:= 1;
   FState := bsUp;
   FMouseInside := False;
   FAutoGray := True;
   FShowPressed := True;
   FBorderSize := 1;
   FStayDown := False;
   SetBounds(0,0,40,40);
   FTransparent := True;

   ImList := TImageList.CreateSize(Width,Height);
   FGlyph:= TBitmap.Create;
   FGrayGlyph := TBitmap.Create;
   FDisabledGlyph := TBitmap.Create;
   FGlyph.OnChange := GlyphChanged;

   FNumGlyphs := 1;
   FSpacing := 2;
   FMouseDown:= False;
   FTextAlign := ttaCenter;
   FInsideButton := False;
   FWordwrap := False;
   FMovable:= False;
   FOutline := fsExplorer;
   FIsDown := False;
   { Norris }
   FPattern := CreateBrushPattern;
end;

destructor  TTransparentButton.Destroy;
begin
   FGlyph.Free;
   FGrayGlyph.Free;
   FDisabledGlyph.Free;
   ImList.Free;
   FPattern.Free;
   inherited Destroy;
end;

procedure TTransparentButton.AddGlyphs(aGlyph:TBitmap;aColor:TColor;Value:integer);
var Bmp:TBitmap;i,TmpWidth:integer;Dest,Source:TRect;
begin
      Bmp := TBitmap.Create;
try
      if aGlyph.Empty then Exit;
      if not aGlyph.Empty then
      begin
      { destroy old list }
        ImList.Clear;
        TmpWidth := aGlyph.Width div FNumGlyphs;
        ImList.Width := TmpWidth;
        ImList.Height := aGlyph.Height;
        Bmp.Width := ImList.Width;
        Bmp.Height := ImList.Height;
        Dest := Rect(0,0,Bmp.Width,Bmp.Height);
        { create the imagelist }
        for i := 0 to FNumGlyphs - 1 do
        begin
          Source := Rect(i * Bmp.Width,0,i * Bmp.Width + Bmp.Width,Bmp.Height);
          Bmp.Canvas.CopyRect(Dest,aGlyph.Canvas,Source);
          if i = 0 then { first picture }
          begin
          { create the disabled and grayed bitmaps too }
            FGrayGlyph.Assign(Bmp);
            MonoBitmap(FGrayGlyph,11,59,30);
            FDisabledGlyph.Assign(Bmp);
            BWBitmap(FDisabledGlyph);
          end;
          ImList.AddMasked(Bmp,Bmp.TransparentColor);
        end;
        { add last }
        ImList.AddMasked(FGrayGlyph,FGrayGlyph.TransparentColor);
        ImList.AddMasked(FDisabledGlyph,FDisabledGlyph.TransparentColor);
      end;
finally
      Bmp.Free;
end;
    Invalidate;
end;

procedure TTransparentButton.SetGlyph(Bmp: TBitmap);
begin
  FGlyph.Assign(Bmp);
  Invalidate;
end;

procedure TTransparentButton.SetNumGlyphs(Value: TNumGlyphs);
begin
   if FNumGlyphs <> Value then
   begin
    FNumGlyphs:= Value;
    Invalidate;
   end;
end;

procedure TTransparentButton.SetFrameStyle(Value: TFrameStyle);
begin
   if FOutline <> Value then
   begin
     FOutline:= Value;
     Invalidate;
   end;
end;

procedure TTransparentButton.SetTransparent(Value:boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    Invalidate;
  end;
end;

procedure TTransparentButton.SetCaption(Value: TCaption);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Invalidate;
  end;
end;


procedure TTransparentButton.SetBorderWidth(Value:Cardinal);
begin
  if FBorderSize <> Value then
  begin
    FBorderSize := Value;
    Invalidate;
  end;
end;

procedure TTransparentButton.SetStayDown(Value:boolean);
begin
  if FStayDown <> Value then
  begin
    FStayDown := Value;
    if FStayDown then
    begin
     FMouseDown := True;
     FState := bsDown;
{     Click; }{ uncomment and see what happens... }
    end
    else
    begin
     FMouseDown := False;
     FState := bsUp;
    end;
    Repaint;
  end;
end;

procedure TTransparentButton.SetWordWrap(Value:boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordwrap := Value;
    Invalidate;
  end;
end;

procedure TTransparentButton.SetSpacing(Value:integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

procedure TTransparentButton.SetTextAlign(Value:TTextAlign);
begin
  if FTextAlign <> Value then
  begin
    FTextAlign := Value;
    Invalidate;
  end;
end;

function TTransparentButton.InsideBtn(X,Y: Integer): boolean;
begin
  Result := PtInRect(Rect(0,0,Width,Height),Point(X,Y));
end;

{ paint everything but bitmap and text }
procedure TTransparentButton.Paint;
var TmpRect:TRect;
begin
   TmpRect := Rect(0,0,Width,Height);
   { draw the outline }
   with Canvas do
   begin
     Brush.Color:= clBtnFace;
     Pen.Color := clBlack;
     Pen.Width := BorderWidth;

     case FrameStyle of
     fsNone:
     begin
       if not Transparent then
         FillRect(Rect(0,0,width,height));
       if (csDesigning in ComponentState) then
         Frame3D(Canvas,TmpRect,clBlack,clBlack,1);
     end;

     fsExplorer:
     begin
       if not Transparent then
         FillRect(Rect(0,0,width,height));
       if (csDesigning in ComponentState) then
         Frame3D(Canvas,TmpRect,clBtnHighLight,clBtnShadow,1);
     end;

     fsRegular:
     begin
       { draw outline }
       Pen.Color := clBlack;
       if not Transparent then
         Rectangle(1,1,Width,Height)
       else
       begin
         TmpRect := Rect(1,1,Width,Height);
         Frame3D(Canvas,TmpRect,clBlack,clBlack,BorderWidth);
       end;
     end;

     fsIndent:
     begin
      { draw outline }
       Pen.Color := clBtnShadow;
       if not Transparent then
         Rectangle(0,0,Width-1,Height-1)
       else
       begin
         TmpRect := Rect(0,0,Width-1,Height-1);
         Frame3D(Canvas,TmpRect,clBtnShadow,clBtnShadow,BorderWidth)
       end;
       TmpRect := Rect(1,1,Width,Height);
       Frame3D(Canvas,TmpRect,clBtnHighLight,clBtnHighLight,BorderWidth);
     end;
     fsLight:
     begin
       if not Transparent then
         FillRect(Rect(0,0,width,height));
       if (csDesigning in ComponentState) then
         Frame3D(Canvas,TmpRect,clBtnHighLight,clBtnShadow,1);
     end;

     fsDark:
     begin
       if not Transparent then
         FillRect(Rect(0,0,width,height));
       if (csDesigning in ComponentState) then
         Frame3D(Canvas,TmpRect,clBtnFace,cl3DDkShadow,1);
     end;

     fsMono:
     begin
       if not Transparent then
         FillRect(Rect(0,0,width,height));
       if (csDesigning in ComponentState) then
         Frame3D(Canvas,TmpRect,clBtnHighLight,cl3DDkShadow,1);
     end;

     end; { case }

     TmpRect := Rect(1,1,Width-1,Height-1);

     if (FState = bsDown) then
     begin
      if not (FrameStyle=fsNone) then
      begin
        InflateRect(TmpRect,1,1);
        case FrameStyle of
        fsRegular:
        if ShowPressed then
        begin
          Frame3D(Canvas,TmpRect,clBlack,clBtnHighLight,BorderWidth);
          Frame3D(Canvas,TmpRect,clBtnShadow,clBtnFace,BorderWidth);
        end;

        fsExplorer:
        if FInsideButton or FStayDown then
        begin
          if ShowPressed then
            Frame3D(Canvas,TmpRect,clBtnShadow,clBtnHighLight,BorderWidth)
          else
            Frame3D(Canvas,TmpRect,clBtnHighLight,clBtnShadow,BorderWidth);
        end;

        fsIndent:
        if ShowPressed then
        begin
          Frame3D(Canvas,TmpRect,clBlack,clBtnHighLight,BorderWidth);
          Frame3D(Canvas,TmpRect,clBtnShadow,clBtnFace,BorderWidth);
        end;

       fsLight:
         if ShowPressed then
           Frame3D(Canvas,TmpRect,clBtnShadow,clBtnHighLight,1);

       fsDark:
         if ShowPressed then
           Frame3D(Canvas,TmpRect,cl3DDkShadow,clBtnFace,1);

       fsMono:
         if ShowPressed then
           Frame3D(Canvas,TmpRect,cl3DDkShadow,clBtnHighLight,1);

        end; { case }
      end;
    end;

     if (FState = bsUp) then
     begin
       InflateRect(TmpRect,1,1);

       case FrameStyle of
       fsRegular:
       begin
         Frame3D(Canvas,TmpRect,clBtnHighLight,clBlack,BorderWidth);
         Frame3D(Canvas,TmpRect,clBtnFace,clBtnShadow,BorderWidth);
       end;

       fsExplorer:
       if FInsideButton then
         Frame3D(Canvas,TmpRect,clBtnHighLight,clBtnShadow,BorderWidth);

       fsIndent:
         Frame3D(Canvas,TmpRect,clBtnShadow,clBtnHighLight,BorderWidth);
       fsLight: Frame3D(Canvas,TmpRect,clBtnHighLight,clBtnShadow,1);
       fsDark:  Frame3D(Canvas,TmpRect,clBtnFace,cl3DDkShadow,1);
       fsMono:  Frame3D(Canvas,TmpRect,clBtnHighLight,cl3DDkShadow,1);

       end; { case }
    end;
   end; { with Canvas do }

   { repaint rest }
   PaintButton;
end;

procedure TTransparentButton.PaintButton;
var Dest:TRect;TmpWidth:integer;
begin
   with Canvas do
   begin
    { find glyph bounding rect - adjust according to textalignment}
    TmpWidth := FGlyph.Width div NumGlyphs;

    if TmpWidth <= 0 then TmpWidth := FGlyph.Width;

    { do top }
    if TextAlign in [ttaBottomLeft,ttaBottom,ttaBottomRight] then
        Dest.Top := Spacing
    else if TextAlign in [ttaTopLeft,ttaTop,ttaTopRight] then
      Dest.Top := Height - FGlyph.Height - Spacing
    else
      Dest.Top :=  (Height - FGlyph.Height) div 2;

    { do left }
    if TextAlign = ttaLeft then
      Dest.Left := Width - TmpWidth- Spacing
    else if TextAlign = ttaRight then
      Dest.Left := Spacing
    else { left, center, right }
      Dest.Left := (Width - TmpWidth) div 2;

{
    if Dest.Top < Spacing then Dest.Top := Spacing;
    if Dest.Left < Spacing then Dest.Left := Spacing;
}
    
    Dest.Bottom:= Dest.Top + FGlyph.Height;
    Dest.Right := Dest.Left + TmpWidth;
    
{
    if Dest.Bottom > Height - Spacing then
       Dest.Top := Height - FGlyph.Height - Spacing;
}

    if not FGlyph.Empty then
    begin
      DrawTheBitmap(Dest);
      FGlyph.Dormant;
    end;
   { finally, do the caption }
    if Length(FCaption) > 0 then
      DrawTheText(Dest);
 end;
end;

{ aRect contains the bitmap bounds }
procedure TTransparentButton.DrawTheText(aRect: TRect);
var Flags,MidX,MidY: Integer;DC:THandle; { Col:TColor; }
    tmprect:TRect;
begin

  Canvas.Font := Self.Font;
  DC := Canvas.Handle; { reduce calls to GetHandle }

  if FWordWrap then
    Flags := DT_WORDBREAK
  else
    Flags := DT_SINGLELINE;

  tmpRect := Rect(0,0,Width,Height);

  { calculate width and height of text: }
  DrawText(DC, PChar(FCaption), Length(FCaption), tmpRect, Flags or DT_CALCRECT);
  MidY := tmpRect.Bottom - tmpRect.Top;
  MidX := tmpRect.Right-tmpRect.Left;
  Flags := DT_CENTER;
  { div 2 and shr 1 generates the exact same Asm code... }
  case TextAlign of
      ttaTop:
        OffsetRect(tmpRect,Width div 2-MidX div 2,aRect.Top - MidY - Spacing);
      ttaTopLeft:
        OffsetRect(tmpRect,Spacing,aRect.Top - MidY - Spacing);
      ttaTopRight:
        OffsetRect(tmpRect,Width - tmpRect.right - Spacing,aRect.Top - MidY - Spacing);
      ttaBottom:
        OffsetRect(tmpRect,Width div 2-MidX div 2,aRect.Bottom + Spacing);
      ttaBottomLeft:
        OffsetRect(tmpRect,Spacing,aRect.Bottom + Spacing);
      ttaBottomRight:
        OffsetRect(tmpRect,Width - MidX - Spacing,aRect.Bottom + Spacing);
      ttaCenter:
        OffsetRect(tmpRect,Width div 2 - MidX div 2,Height div 2 - MidY div 2);
      ttaRight:
        OffsetRect(tmpRect,Width  - MidX - Spacing,Height div 2 - MidY div 2);
      ttaLeft:
        OffsetRect(tmpRect,Spacing,Height div 2 - MidY div 2);
  end; { case }
  if FWordWrap then
    Flags := Flags or DT_WORDBREAK or DT_NOCLIP
  else
    Flags := Flags or DT_SINGLELINE or DT_NOCLIP;

  if ((FState = bsDown) and FShowPressed) then
      OffsetRect(tmpRect,1,1);

  SetBkMode(DC,Windows.TRANSPARENT);

  if not Enabled then
  begin
  { draw disabled text }
  {    Col := GetSysColor(COLOR_GRAYTEXT);
      SetTextColor(DC,Col);}
    SetTextColor(DC,ColorToRGB(clBtnHighLight));
    OffsetRect(tmpRect,1,1);
    DrawText(DC, PChar(FCaption), Length(FCaption), tmpRect, Flags);
    OffsetRect(tmpRect,-1,-1);
    SetTextColor(DC,ColorToRGB(clBtnShadow));
  end
  else
    SetTextColor(DC,self.Font.Color);

  DrawText(DC, PChar(FCaption), Length(FCaption), tmpRect, Flags);
end;

procedure TTransparentButton.DrawTheBitmap(aRect:TRect);
var index:integer;
{  HelpRect:TRect; }
begin
   with ImList do
   begin
     Index := 0;

     case FNumGlyphs of   {normal,disabled,down,down }
     2: if not Enabled then Index := 1;
     3: if not Enabled then
          Index := 1
        else if (FState = bsDown) then
          Index := 2;
     4: if not Enabled then
          Index := 1
        else if (FState = bsDown) then
          Index := 2;
        else
          Index := 0;
     end; { case }

     if FGlyph.Empty then Exit;

     if ((FState = bsDown) and FShowPressed) then
       OffsetRect(aRect,1,1);
     { do we need the grayed bitmap ? }
     if (FrameStyle = fsExplorer) and FAutoGray and not FInsideButton then
       Index := Count-2;

     { do we need the disabled bitmap ? }
     if not Enabled and (FNumGlyphs = 1) then Index := Count-1;

     { Norris }
     if {FIsDown and }FStayDown and (FState = bsDown) then
     begin
{       HelpRect := ClientRect;
       InflateRect(HelpRect, -2, -2);
       Canvas.Brush.Bitmap := FPattern;
       Self.Canvas.FillRect(HelpRect);
}     end;

     if Transparent then
       ImageList_DrawEx(Handle, Index, Canvas.Handle, aRect.Left,aRect.Top,0, 0,
         clNone, clNone, ILD_Transparent)
     else
       ImageList_DrawEx(Handle, Index, Canvas.Handle, aRect.Left,aRect.Top,0, 0,
         ColorToRGB(clBtnFace), CLR_DEFAULT, ILD_Normal);
   end; { with ImList do }
end;


procedure TTransparentButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tmp:TPoint;Msg:TMsg;
begin
  if not Enabled then Exit;

  if FIsDown then Exit
  else FIsDown := not FIsDown;

  inherited MouseDown(Button,Shift,X,Y);

   If FMovable then begin
     posX:= X;  {we get the mouse position}
     posY:= Y;
     {we start moving the button, if Movable, with MouseMove}
   end;

   if Assigned(OnMouseDown) then OnMouseDown(Self,Button,Shift,X,Y);

   if InsideBtn(X,Y) then
   begin
     FMouseDown := True;
     FState := bsDown;
     Repaint; 
   end;



   if Assigned(FPopUpMenu) then
   begin
     { calc where to put menu }
			tmp := ClientToScreen(Point(0, Height));
			FPopUpMenu.Popup(tmp.X, tmp.Y);
     { wait 'til menu is done }
			while PeekMessage(Msg, 0, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE) do
				;
     { release button }
     MouseUp(Button,Shift,X,Y);
   end;
end;


procedure TTransparentButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  if not Enabled then Exit;
  if not FIsDown then Exit
  else FIsDown := not FIsDown;
  if FStayDown then Exit;
  inherited MouseUp(Button,Shift,X,Y);

  FMouseDown := False;
  FState := bsUp;
  Repaint;
  if Assigned(OnMouseUp) then OnMouseUp(Self,Button,Shift,X,Y);
end;


procedure TTransparentButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
   inherited MouseMove(Shift,X,Y);
   if Assigned(OnMouseMove) then OnMouseMove(Self,Shift,X,Y);
   if FMouseDown then
   begin
     if Movable then begin Top:=Top+Y-PosY; Left:=Left+X-PosX end; {moving the button}
     if not InsideBtn(X,Y) then
     begin
       if FState = bsDown then { mouse has slid off, so release }
       begin
         FState := bsUp;
         Repaint;
       end;
     end
     else
     begin
       if FState = bsUp then { mouse has slid back on, so push }
       begin
         FState := bsDown;
         Repaint; 
       end;
     end;
   end;
end;


procedure TTransparentButton.GlyphChanged(Sender:TObject);
var GlyphNum:integer;
begin
  Invalidate;
  GlyphNum := 1;
  if (Glyph <> nil) and (Glyph.Height > 0) then
  begin
    if Glyph.Width mod Glyph.Height = 0 then
    begin
      GlyphNum := Glyph.Width div Glyph.Height;
      if GlyphNum > 4 then GlyphNum := 1;
      SetNumGlyphs(GlyphNum);
    end;
  AddGlyphs(Glyph,Glyph.TransparentColor {Glyph.Canvas.Pixels[0,0]},GlyphNum);
  end;
end;

{ Handle speedkeys (Alt + key) }
procedure TTransparentButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, FCaption) and Enabled then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TTransparentButton.CMEnabledChanged(var Message: TMessage);
begin
 if not(Enabled) then
 begin
  	FState := bsUp;
  	FMousedown := False;
 	FIsDown := False;
 	FInsideButton := False;
 end;
 Repaint; 
end;

procedure TTransparentButton.CMMouseEnter(var msg: TMessage);
begin
  if Enabled then
  begin
    FInsideButton := True;
    if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
    if (FrameStyle = fsExplorer) then Repaint; 
  end;
end;

procedure TTransparentButton.CMMouseLeave(var msg: TMessage);
begin
  if Enabled then
  begin
    if FInsideButton then FInsideButton := False;
    if Assigned(FOnMouseExit) then FOnMouseExit(Self);
    if (FrameStyle = fsExplorer) then Repaint; 
  end;

end;

procedure TTransparentButton.Click;
begin
  inherited Click;
end;
procedure TTransparentButton.Notification(AComponent: TComponent; Operation:TOperation);
begin
	if (Operation = opRemove) and (AComponent = FPopUpMenu) then
		FPopUpMenu := nil ;
end;


procedure Register;
begin
     RegisterComponents('Personal',[TTransparentButton]);
end;
end.
