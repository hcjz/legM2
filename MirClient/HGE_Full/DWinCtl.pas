unit DWinCtl;

interface

uses
  Windows, Classes, Graphics, SysUtils, Controls, StdCtrls, Messages, Forms,
  Grids, HUtil32, WIL, HGE, HGECanvas, HGETextures, HGEFont, Vectors2px,
  HGEBase, DirectXGraphics, Clipbrd, Math;



const
  LineSpace                 = 2;

  LineSpace2                = 8;

  DECALW                    = 6;
  DECALH                    = 4;
  DEFFONTNAME = '宋体';
  DEFFONTSIZE = 9;

type



  TDBtnState = (tnor, tdown, tmove, tdisable);
  TClickSound = (csNone, csStone, csGlass, csNorm);
  TDControl = class;
  TOnDirectPaint = procedure(Sender: TObject; dsurface: TDXTexture) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: Char) of object;
  TOnKeyDown = procedure(Sender: TObject; var Key: Word; Shift: TShiftState) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnClick = procedure(Sender: TObject) of object;
  TOnClickEx = procedure(Sender: TObject; X, Y: Integer) of object;
  TOnInRealArea = procedure(Sender: TObject; X, Y: Integer; var IsRealArea: Boolean) of object;
  TOnGridSelect = procedure(Sender: TObject; ACol, ARow: Integer; Shift: TShiftState) of object;
  TOnGridPaint = procedure(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; dsurface: TDXTexture) of object;
  TOnClickSound = procedure(Sender: TObject; Clicksound: TClickSound) of object;
  //TMouseWheelEvent = procedure(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean) of object;
  TOnTextChanged = procedure(Sender: TObject; sText: string) of object;
  TColors = class(TGraphicsObject)
  private
    FDisabled: TColor;
    FBkgrnd: TColor;
    FSelected: TColor;
    FBorder: TColor;
    FFont: TColor;
    FHot: TColor;
    FDown: TColor;
    FLine: TColor;
    FUp: TColor;
  public
    constructor Create();
  published
    property Disabled: TColor read FDisabled write FDisabled;
    property Background: TColor read FBkgrnd write FBkgrnd;
    property Selected: TColor read FSelected write FSelected;
    property Border: TColor read FBorder write FBorder;
    property Font: TColor read FFont write FFont;
    property Up: TColor read FUp write FUp;
    property Hot: TColor read FHot write FHot;
    property Down: TColor read FDown write FDown;
    property Line: TColor read FLine write FLine;
  end;
  TDControl = class(TCustomControl)
  protected
    //bMouseMove: Boolean;
    //FIsManager: Boolean;
    FPageActive: Boolean;
    FCaption: string;
    FDParent: TDControl;
    FEnableFocus: Boolean;
    FOnDirectPaint: TOnDirectPaint;
    FOnDirectPaint2: TOnDirectPaint;
    FOnKeyPress: TOnKeyPress;
    FOnKeyDown: TOnKeyDown;
    FOnMouseMove: TOnMouseMove;
    FOnMouseDown: TOnMouseDown;
    FOnMouseUp: TOnMouseUp;
    FOnDblClick: TNotifyEvent;
    FOnClick: TOnClickEx;
    FOnInRealArea: TOnInRealArea;
    FOnBackgroundClick: TOnClick;
    //FOnProcess: TNotifyEvent;
    //FOnMouseWheel: TMouseWheelEvent;
    procedure SetCaption(Str: string);
    //function  GetMouseMove: Boolean;
    //function  GetClientRect: TRect; override;
    //procedure CMMouseWheel(var Message: TCMMouseWheel); message CM_MOUSEWHEEL;
  protected
    FVisible: Boolean;
    //procedure CaptionChaged; dynamic;
  public
    //ReloadTex: Boolean;
    ImageSurface: TDXTexture;
    Background: Boolean;
    DControls: TList;
    WLib: TWMImages;
    ULib: TUIBImages;
    FaceIndex: Integer;
    FaceName: string;

    FRightClick: Boolean;
    WantReturn: Boolean;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Loaded; override;
    //procedure Process; dynamic;
    function SurfaceX(X: Integer): Integer;
    function SurfaceY(Y: Integer): Integer;
    function LocalX(X: Integer): Integer;
    function LocalY(Y: Integer): Integer;
    procedure AddChild(dcon: TDControl);
    procedure ChangeChildOrder(dcon: TDControl);
    function InRange(X, Y: Integer; Shift: TShiftState): Boolean; dynamic;
    function KeyPress(var Key: Char): Boolean; virtual;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; virtual;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; virtual;
    function DblClick(X, Y: Integer): Boolean; virtual;
    function Click(X, Y: Integer): Boolean; virtual;
    function CanFocusMsg: Boolean;
    procedure AdjustPos(X, Y: Integer); overload;
    procedure AdjustPos(X, Y, W, H: Integer); overload;
    procedure SetImgIndex(Lib: TWMImages; Index: Integer); overload;
    procedure SetImgIndex(Lib: TWMImages; Index, X, Y: Integer); overload;
    
    procedure SetImgName(Lib: TUIBImages; F: string);
    procedure DirectPaint(dsurface: TDXTexture); virtual;
    //function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; virtual;
    property PageActive: Boolean read FPageActive write FPageActive;
    //property MouseMoveing: Boolean read GetMouseMove;
    property ClientRect: TRect read GetClientRect;
  published
    //property OnProcess: TNotifyEvent read FOnProcess write FOnProcess;
    property OnDirectPaint: TOnDirectPaint read FOnDirectPaint write FOnDirectPaint;
    property OnDirectPaint2: TOnDirectPaint read FOnDirectPaint2 write FOnDirectPaint2;
    property OnKeyPress: TOnKeyPress read FOnKeyPress write FOnKeyPress;
    property OnKeyDown: TOnKeyDown read FOnKeyDown write FOnKeyDown;
    property OnMouseMove: TOnMouseMove read FOnMouseMove write FOnMouseMove;
    property OnMouseDown: TOnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TOnMouseUp read FOnMouseUp write FOnMouseUp;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnInRealArea: TOnInRealArea read FOnInRealArea write FOnInRealArea;
    property OnBackgroundClick: TOnClick read FOnBackgroundClick write FOnBackgroundClick;
    //property OnMouseWheel: TMouseWheelEvent read FOnMouseWheel write FOnMouseWheel;

    property Caption: string read FCaption write SetCaption;
    property DParent: TDControl read FDParent write FDParent;
    property Visible: Boolean read FVisible write FVisible;
    property EnableFocus: Boolean read FEnableFocus write FEnableFocus;
    property Color;
    property Font;
    property Hint;
    property ShowHint;
    property Align;
  end;

  TDButton = class(TDControl)
  private
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
  public
    FFloating: Boolean;
    CaptionEx: string;
    btnState: TDBtnState;
    Downed: Boolean;
    Arrived: Boolean;
    SpotX, SpotY: Integer;
    Clicked: Boolean;
    ClickInv: LongWord;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDCheckBox = class(TDControl)
  private
    FArrived: Boolean;
    FChecked: Boolean;
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
  public
    Downed: Boolean;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    property Checked: Boolean read FChecked write FChecked;
    property Arrived: Boolean read FArrived write FArrived;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDCustomControl = class(TDControl)
  protected
    FEnabled: Boolean;
    FTransparent: Boolean;
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
    FFrameVisible: Boolean;
    FFrameHot: Boolean;
    FFrameSize: byte;
    FFrameColor: TColor;
    FFrameHotColor: TColor;
    procedure SetTransparent(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetFrameVisible(Value: Boolean);
    procedure SetFrameHot(Value: Boolean);
    procedure SetFrameSize(Value: byte);
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameHotColor(Value: TColor);
  protected
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
    property FrameVisible: Boolean read FFrameVisible write SetFrameVisible default True;
    property FrameHot: Boolean read FFrameHot write SetFrameHot default False;
    property FrameSize: byte read FFrameSize write SetFrameSize default 1;
    property FrameColor: TColor read FFrameColor write SetFrameColor default $00406F77;
    property FrameHotColor: TColor read FFrameHotColor write SetFrameHotColor default $00599AA8;
  public
    Downed: Boolean;
    //OnEnterKey: procedure of object;
    //OntTabKey: procedure of object;
    procedure OnDefaultEnterKey;
    procedure OnDefaultTabKey;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDxScrollBarBar = class(TDCustomControl)
  protected
    StartPosY, TotH, hAuteur, dify: Integer;
    Selected: Boolean;
    TmpList: TStrings;
  public
    ModPos: Integer;
    procedure AJust_H;
    function GetPos: Integer;
    procedure MoveBar(nposy: Integer);
    procedure MoveModPos(nMove: Integer);
    procedure DirectPaint(dsurface: TDXTexture); override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    constructor Create(aowner: TComponent; nTmpList: TStrings);
  end;

  TDxScrollBarUp = class(TDCustomControl)
  protected
    Selected: Boolean;
  public
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDXTexture); override;
  end;

  TDxScrollBarDown = class(TDxScrollBarUp)
  public
    procedure DirectPaint(dsurface: TDXTexture); override;
  end;

  TDxScrollBar = class(TDCustomControl)
  protected
    TotH: Integer;
    BUp: TDxScrollBarUp;
    BDown: TDxScrollBarDown;
    Bar: TDxScrollBarBar;
  public
    function GetPos: Integer;
    procedure MoveModPos(nMove: Integer);
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    constructor Create(aowner: TComponent; nTmpList: TStrings);
  end;

  TDxHint = class(TDCustomControl)
  private
    FItems: TStrings;
    FBackColor: TColor;
    FSelectionColor: TColor;
    FParentControl: TDControl;
    function GetItemSelected: Integer;
    procedure SetItems(Value: TStrings);
    procedure SetBackColor(Value: TColor);
    procedure SetSelectionColor(Value: TColor);
    procedure SetItemSelected(Value: Integer);
  public
    FSelected: Integer;
    FOnChangeSelect: procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
    FOnMouseMoveSelect: procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
    property Items: TStrings read FItems write SetItems;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clSilver;
    property ItemSelected: Integer read GetItemSelected write SetItemSelected;
    property ParentControl: TDControl read FParentControl write FParentControl;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TDXTexture); override;
  end;

  TDEdit = class(TDControl)
  private
    FPasswordChar: Char;
    FText: Widestring;
    FOnChange:TNotifyEvent;
    FFont:TFont;
    F3D:boolean;
    FColor:TColor;
    FTransparent:boolean;
    FMaxLength: Integer;
    XDif:integer;
    FSelCol:TColor;
    CursorTime:integer;
    InputStr:string;
    KeyByteCount: Byte;
    boDoubleByte: Boolean;

    SelStop:integer;
    FReadOnly : Boolean;
    procedure DoMove; //光标闪烁
    procedure DelSelText;
    function CopySelText():string;
    procedure SetText (str: Widestring);
    procedure SetMaxLength(const Value: Integer);
    procedure SetSelLength(Value: Integer);
    function GetSelLength: Integer;
    procedure SetPasswordChar(Value: Char);
  protected
    DrawFocused:boolean;
    DrawEnabled:boolean;
    DrawHovered:boolean;
    CursorVisible:boolean;
    BlinkSpeed:integer;
    Hovered:boolean;
    function  GetSelCount:integer;
  public
    SelStart:integer;
    Moveed: Boolean; //20080624
    procedure SetFocus();
    property SelCount:integer read GetSelCount;
    function MouseToSelPos(AX:integer):integer;
    function  KeyDown (var Key: Word; Shift: TShiftState): Boolean; override;
    function  KeyPress (var Key: Char): Boolean; override;
    function  MouseMove (Shift: TShiftState; X, Y: Integer): Boolean; override;
    function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function  MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint (dsurface: TDXTexture); override;
    procedure Update;override;
    constructor Create (AOwner: TComponent); override;
    procedure Paint; override;
    destructor Destroy; override;
  published
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
    property Text: Widestring read FText write SetText;
    property MaxLength: Integer read FMaxLength write SetMaxLength;
    property Font:TFont read FFont write FFont;
    property Ctrl3D:boolean read F3D write F3D;
    property ReadOnly : Boolean read FReadOnly write FReadOnly;
    property Color:TColor read FColor write FColor;
    property SelLength :Integer read GetSelLength write SetSelLength;
    property SelectionColor:TColor read FSelCol write FSelCol;
    property Transparent:boolean read FTransparent write FTransparent;
    property PasswordChar: Char read FPasswordChar write SetPasswordChar default #0;
  end;

  //增加DEdit菜单支持By TasNat at: 2012-06-30 15:46:33
  TDEditMenuProc = procedure (DEdit : TDEdit);
  TDEditMenu = class(TDControl)
    DEdit : TDEdit;
    Menus : TStringList;              
  public
    FocusItemIndex : Integer;//鼠标所在项
    ItemHeight : DWord;
    XX, YY : Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint (dsurface: TDXTexture); override;
    function MouseMove (Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Popup(ADEdit : TDEdit; X, Y: Integer);
  end;

  TDGrid = class(TDControl)
  private
    FColCount, FRowCount: Integer;
    FColWidth, FRowHeight: Integer;
    FViewTopLine: Integer;
    SelectCell: TPoint;
    DownPos: TPoint;
    FOnGridSelect: TOnGridSelect;
    FOnGridMouseMove: TOnGridSelect;
    FOnGridPaint: TOnGridPaint;
    function GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
  public
    tButton: TMouseButton;
    cx, cy: Integer;
    Col, Row: Integer;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function Click(X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDXTexture); override;
  published
    property ColCount: Integer read FColCount write FColCount;
    property RowCount: Integer read FRowCount write FRowCount;
    property ColWidth: Integer read FColWidth write FColWidth;
    property RowHeight: Integer read FRowHeight write FRowHeight;
    property ViewTopLine: Integer read FViewTopLine write FViewTopLine;
    property OnGridSelect: TOnGridSelect read FOnGridSelect write FOnGridSelect;
    property OnGridMouseMove: TOnGridSelect read FOnGridMouseMove write FOnGridMouseMove;
    property OnGridPaint: TOnGridPaint read FOnGridPaint write FOnGridPaint;
  end;

  TDWindow = class(TDButton)
  private
    FFloating: Boolean;
  protected
    procedure SetVisible(flag: Boolean);
  public
    //FloatingEx: Boolean;
    FMoveRange: Boolean;
    SpotX, SpotY: Integer;
    DialogResult: TModalResult;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Show;
    function ShowModal: Integer;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
  end;

  TDWinManager = class({TDControl}TComponent)
  private
  public
    DWinList: TList;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure AddDControl(dcon: TDControl; Visible: Boolean);
    procedure DelDControl(dcon: TDControl);
    procedure ClearAll;
    //procedure Process;
    function KeyPress(var Key: Char): Boolean;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function DblClick(X, Y: Integer): Boolean;
    function Click(X, Y: Integer): Boolean;
    procedure DirectPaint(dsurface: TDXTexture);
  end;

  TDMoveButton = class(TDButton)
  private
    FFloating: Boolean;
    SpotX, SpotY: Integer;
  protected
    procedure SetVisible(flag: Boolean);
  public
    DialogResult: TModalResult;
    FOnClick: TOnClickEx;
    SlotLen: Integer;
    RLeft: Integer;
    RTop: Integer;
    Position: Integer;
    outHeight: Integer;
    Max: Integer;
    Reverse: Boolean;
    LeftToRight: Boolean;
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Show;
    function ShowModal: Integer;
    procedure UpdatePos(pos: Integer; force: Boolean = False);
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property FBoxMoveTop: Integer read SlotLen write SlotLen;
    property TypeRLeft: Integer read RLeft write RLeft;
    property TypeRTop: Integer read RTop write RTop;
    property TReverse: Boolean read Reverse write Reverse;
  end;

{==============TDPopupMenu创建===============}
  TDPopupMenu = class;
  TMenuStyle = (sXP, sVista);
  TImageIndex = type Integer;

  TDMenuItem = class(TObject)
  private
    FVisible: Boolean;
    FEnabled: Boolean;
    FCaption: string;
    FMenu: TDPopupMenu;
    FChecked: Boolean;
  public
    constructor Create();
    destructor Destroy; override;
    property Visible: Boolean read FVisible write FVisible;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Caption: string read FCaption write FCaption;
    property Checked: Boolean read FChecked write FChecked;
    property Menu: TDPopupMenu read FMenu write FMenu;
  end;

  TDPopupMenu = class(TDControl)
  private
    FItems: TStrings;
    FColors: TColors;
    FMoveItemIndex: Integer;
    FItemSize: Integer;
    FMouseMove: Boolean;
    FOwnerMenu: TDPopupMenu;
    FItemIndex: Integer;
    FOwnerItemIndex: TImageIndex;
    FActiveMenu: TDPopupMenu;
    FDControl: TDControl;
    FStyle: TMenuStyle;
    function GetMenu(Index: Integer): TDPopupMenu;
    procedure SetMenu(Index: Integer; Value: TDPopupMenu);
    function GetItem(Index: Integer): TDMenuItem;
    function GetCount: Integer;
    procedure SetOwnerItemIndex(Value: TImageIndex);
    procedure SetOwnerMenu(Value: TDPopupMenu);
    procedure SetItems(Value: TStrings);
    function GetItems: TStrings;
    procedure SetColors(Value: TColors);
    procedure SetItemIndex(Value: Integer);
  protected
    procedure CreateWnd; override;
  public
    Downed: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
   // procedure Process; override;
    function InRange(X, Y: Integer; Shift: TShiftState): Boolean; override;
    procedure DirectPaint(dsurface: TDXTexture); override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function Click(X, Y: Integer): Boolean; override;
    procedure Show; overload;
    procedure Show(d: TDControl); overload;
    procedure Hide;
    procedure Insert(Index: Integer; ACaption: string; Item: TDPopupMenu);
    procedure Delete(Index: Integer);
    procedure Clear;
    function Find(ACaption: string): TDPopupMenu;
    function IndexOf(Item: TDPopupMenu): Integer;
    procedure Add(ACaption: string; Item: TDPopupMenu);
    procedure Remove(Item: TDPopupMenu);
    property Count: Integer read GetCount;
    property Menus[Index: Integer]: TDPopupMenu read GetMenu write SetMenu;
    property Items[Index: Integer]: TDMenuItem read GetItem;
    property DControl: TDControl read FDControl write FDControl;
  published
    property OwnerMenu: TDPopupMenu read FOwnerMenu write SetOwnerMenu;
    property OwnerItemIndex: TImageIndex read FOwnerItemIndex write SetOwnerItemIndex default -1;
    property MenuItems: TStrings read GetItems write SetItems;
    property Colors: TColors read FColors write SetColors;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Style: TMenuStyle read FStyle write FStyle;
  end;
{==============TDPopupMenu结束===============}


{===========================EDIT创建===================}
  TDComboBox = class;

  TDxCustomListBox = class(TDCustomControl)
  private
    FItems: TStrings;
    FBackColor: TColor;
    FSelectionColor: TColor;
    FParentComboBox: TDComboBox;
    function GetItemSelected: Integer;
    procedure SetItems(Value: TStrings);
    procedure SetBackColor(Value: TColor);
    procedure SetSelectionColor(Value: TColor);
    procedure SetItemSelected(Value: Integer);
  public
    ChangingHero: Boolean;
    FSelected: Integer;
    FOnChangeSelect: procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
    FOnMouseMoveSelect: procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
    property Items: TStrings read FItems write SetItems;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clSilver;
    property ItemSelected: Integer read GetItemSelected write SetItemSelected;
    property ParentComboBox: TDComboBox read FParentComboBox write FParentComboBox;

    //procedure ChangeSelect(ChangeSelect: Integer);
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TDXTexture); override;
  end;

  TDListBox = class(TDxCustomListBox)
  published
    property Enabled;
    property Transparent;
    property BackColor;
    property SelectionColor;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property ParentComboBox;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TAlignment = (taCenter, taLeftJustify {, taRightJustify});

  TDxCustomEdit = class(TDCustomControl)
  private
    FAtom: Word;
    FHotKey: Cardinal;
    FIsHotKey: Boolean;
    FAlignment: TAlignment;
    FClick: Boolean;
    FSelClickStart: Boolean;
    FSelClickEnd: Boolean;
    FCurPos: Integer;
    FClickX: Integer;
    FSelStart: Integer;
    FSelEnd: Integer;
    FStartTextX: Integer;

    FSelTextStart: Integer;
    FSelTextEnd: Integer;

    FMaxLength: Integer;
    FShowCaretTick: LongWord;
    FShowCaret: Boolean;
    FNomberOnly: Boolean;
    FSecondChineseChar: Boolean;
    FPasswordChar: Char;
    FOnTextChanged: TOnTextChanged;
    procedure SetSelStart(Value: Integer);
    procedure SetSelEnd(Value: Integer);
    procedure SetMaxLength(Value: Integer);
    procedure SetPasswordChar(Value: Char);
    procedure SetNomberOnly(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetIsHotKey(Value: Boolean);
    procedure SetHotKey(Value: Cardinal);
    procedure SetAtom(Value: Word);
    procedure SetSelLength(Value: Integer);
    function ReadSelLength(): Integer;
  protected
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property NomberOnly: Boolean read FNomberOnly write SetNomberOnly default False;
    property IsHotKey: Boolean read FIsHotKey write SetIsHotKey default False;
    property Atom: Word read FAtom write SetAtom default 0;
    property HotKey: Cardinal read FHotKey write SetHotKey default 0;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property PasswordChar: Char read FPasswordChar write SetPasswordChar default #0;
  public
    DxHint: TDxHint;
    m_InputHint: string;
    FMiniCaret: byte;
    FCaretColor: TColor;
    procedure ShowCaret();
    procedure SetFocus(); override;
    procedure ChangeCurPos(nPos: Integer; boLast: Boolean = False);
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDXTexture); override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyPressEx(var Key: Char): Boolean;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function SetOfHotKey(HotKey: Cardinal): Word;
    property Text: string read FCaption write SetCaption;
    property SelStart: Integer read FSelStart write SetSelStart;
    property SelEnd: Integer read FSelEnd write SetSelEnd;
    property SelLength: Integer read ReadSelLength write SetSelLength;
    property OnTextChanged: TOnTextChanged read FOnTextChanged write FOnTextChanged;
    ///
  end;

  TDxEdit = class(TDxCustomEdit)
  published
    property Alignment;
    property IsHotKey;
    property HotKey;
    property Enabled;
    property MaxLength;
    property NomberOnly;
    property Transparent;
    property PasswordChar;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;

  TDComboBox = class(TDxCustomEdit)
  private
    FDropDownList: TDListBox;
  protected
    //
  public
    constructor Create(aowner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    //function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
  published
    property Enabled;
    property MaxLength;
    property NomberOnly;
    property Transparent;
    property PasswordChar;
    property FrameVisible;
    property FrameHot;
    property FrameSize;
    property FrameColor;
    property FrameHotColor;
    property DropDownList: TDListBox read FDropDownList write FDropDownList;
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;
{==========================EDIT结束=========================================================}

procedure Register;
procedure SetDFocus(dcon: TDControl);
procedure ReleaseDFocus;
procedure SetDCapture(dcon: TDControl);
procedure ReleaseDCapture;

var
  MouseCaptureControl       : TDControl; //mouse message
  FocusedControl            : TDControl; //Key message
  MouseMoveControl: TDControl;
  ActiveMenu: TDPopupMenu; //TDPopupMenu定义
  lDEditMenu : TDEditMenu;
  MainWinHandle             : Integer;
  ModalDWindow              : TDControl;
  g_MainHWnd                : HWnd;
  DisplaySize: TPoint2px;
  LastMenuControl           : TDxEdit = nil;  //Edit定义
  HotKeyProc : function (HotKey: Cardinal): Boolean of object;//Edit定义
implementation


//uses
//  ClMain, FState;

procedure Register;
begin
  RegisterComponents('MirGame', [TDWinManager, TDPopupMenu, TDButton, TDCheckBox,
  TDGrid, TDWindow, TDMoveButton, TDEdit, TDxEdit, TDComboBox, TDListBox, TDxHint]);
end;

procedure SetDFocus(dcon: TDControl);
begin
  FocusedControl := dcon;
end;

procedure ReleaseDFocus;
begin
  FocusedControl := nil;
end;

procedure SetDCapture(dcon: TDControl);
begin
  MouseCaptureControl := dcon;
end;

procedure ReleaseDCapture;
begin
  MouseCaptureControl := nil;
end;

{================================Edit函数============================}
function IsKeyPressed(Key: Byte): Boolean;
var
  keyvalue          : TKeyBoardState;
begin
  Result := False;
  FillChar(keyvalue, SizeOf(TKeyBoardState), #0);
  if GetKeyboardState(keyvalue) then
    if (keyvalue[Key] and $80) <> 0 then
      Result := True;
end;

const
  // Windows 2000/XP multimedia keys (adapted from winuser.h and renamed to avoid potential conflicts)
  // See also: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/WindowsUserInterface/UserInput/VirtualKeyCodes.asp
  _VK_BROWSER_BACK = $A6; // Browser Back key
  _VK_BROWSER_FORWARD = $A7; // Browser Forward key
  _VK_BROWSER_REFRESH = $A8; // Browser Refresh key
  _VK_BROWSER_STOP = $A9; // Browser Stop key
  _VK_BROWSER_SEARCH = $AA; // Browser Search key
  _VK_BROWSER_FAVORITES = $AB; // Browser Favorites key
  _VK_BROWSER_HOME = $AC; // Browser Start and Home key
  _VK_VOLUME_MUTE = $AD; // Volume Mute key
  _VK_VOLUME_DOWN = $AE; // Volume Down key
  _VK_VOLUME_UP = $AF; // Volume Up key
  _VK_MEDIA_NEXT_TRACK = $B0; // Next Track key
  _VK_MEDIA_PREV_TRACK = $B1; // Previous Track key
  _VK_MEDIA_STOP = $B2; // Stop Media key
  _VK_MEDIA_PLAY_PAUSE = $B3; // Play/Pause Media key
  _VK_LAUNCH_MAIL = $B4; // Start Mail key
  _VK_LAUNCH_MEDIA_SELECT = $B5; // Select Media key
  _VK_LAUNCH_APP1 = $B6; // Start Application 1 key
  _VK_LAUNCH_APP2 = $B7; // Start Application 2 key
  // Self-invented names for the extended keys
  NAME_VK_BROWSER_BACK = 'Browser Back';
  NAME_VK_BROWSER_FORWARD = 'Browser Forward';
  NAME_VK_BROWSER_REFRESH = 'Browser Refresh';
  NAME_VK_BROWSER_STOP = 'Browser Stop';
  NAME_VK_BROWSER_SEARCH = 'Browser Search';
  NAME_VK_BROWSER_FAVORITES = 'Browser Favorites';
  NAME_VK_BROWSER_HOME = 'Browser Start/Home';
  NAME_VK_VOLUME_MUTE = 'Volume Mute';
  NAME_VK_VOLUME_DOWN = 'Volume Down';
  NAME_VK_VOLUME_UP = 'Volume Up';
  NAME_VK_MEDIA_NEXT_TRACK = 'Next Track';
  NAME_VK_MEDIA_PREV_TRACK = 'Previous Track';
  NAME_VK_MEDIA_STOP = 'Stop Media';
  NAME_VK_MEDIA_PLAY_PAUSE = 'Play/Pause Media';
  NAME_VK_LAUNCH_MAIL = 'Start Mail';
  NAME_VK_LAUNCH_MEDIA_SELECT = 'Select Media';
  NAME_VK_LAUNCH_APP1 = 'Start Application 1';
  NAME_VK_LAUNCH_APP2 = 'Start Application 2';

const
  mmsyst = 'winmm.dll';
  kernel32 = 'kernel32.dll';
  HotKeyAtomPrefix = 'HotKeyManagerHotKey';
  ModName_Shift = 'Shift';
  ModName_Ctrl = 'Ctrl';
  ModName_Alt = 'Alt';
  ModName_Win = 'Win';
  VK2_SHIFT = 32;
  VK2_CONTROL = 64;
  VK2_ALT = 128;
  VK2_WIN = 256;

var
  EnglishKeyboardLayout: HKL;
  ShouldUnloadEnglishKeyboardLayout: Boolean;
  LocalModName_Shift: string = ModName_Shift;
  LocalModName_Ctrl: string = ModName_Ctrl;
  LocalModName_Alt: string = ModName_Alt;
  LocalModName_Win: string = ModName_Win;

function IsExtendedKey(Key: Word): Boolean;
begin
  Result := ((Key >= _VK_BROWSER_BACK) and (Key <= _VK_LAUNCH_APP2));
end;

function GetHotKey(Modifiers, Key: Word): Cardinal;
var
  HK: Cardinal;
begin
  HK := 0;
  if (Modifiers and MOD_ALT) <> 0 then
    Inc(HK, VK2_ALT);
  if (Modifiers and MOD_CONTROL) <> 0 then
    Inc(HK, VK2_CONTROL);
  if (Modifiers and MOD_SHIFT) <> 0 then
    Inc(HK, VK2_SHIFT);
  if (Modifiers and MOD_WIN) <> 0 then
    Inc(HK, VK2_WIN);
  HK := HK shl 8;
  Inc(HK, Key);
  Result := HK;
end;


procedure SeparateHotKey(HotKey: Cardinal; var Modifiers, Key: Word);
var
  Virtuals: Integer;
  v: Word;
  X: Word;
begin
  Key := Byte(HotKey);
  X := HotKey shr 8;
  Virtuals := X;
  v := 0;
  if (Virtuals and VK2_WIN) <> 0 then
    Inc(v, MOD_WIN);
  if (Virtuals and VK2_ALT) <> 0 then
    Inc(v, MOD_ALT);
  if (Virtuals and VK2_CONTROL) <> 0 then
    Inc(v, MOD_CONTROL);
  if (Virtuals and VK2_SHIFT) <> 0 then
    Inc(v, MOD_SHIFT);
  Modifiers := v;
end;

function HotKeyToText(HotKey: Cardinal; Localized: Boolean): string;

  function GetExtendedVKName(Key: Word): string;
  begin
    case Key of
      _VK_BROWSER_BACK: Result := NAME_VK_BROWSER_BACK;
      _VK_BROWSER_FORWARD: Result := NAME_VK_BROWSER_FORWARD;
      _VK_BROWSER_REFRESH: Result := NAME_VK_BROWSER_REFRESH;
      _VK_BROWSER_STOP: Result := NAME_VK_BROWSER_STOP;
      _VK_BROWSER_SEARCH: Result := NAME_VK_BROWSER_SEARCH;
      _VK_BROWSER_FAVORITES: Result := NAME_VK_BROWSER_FAVORITES;
      _VK_BROWSER_HOME: Result := NAME_VK_BROWSER_HOME;
      _VK_VOLUME_MUTE: Result := NAME_VK_VOLUME_MUTE;
      _VK_VOLUME_DOWN: Result := NAME_VK_VOLUME_DOWN;
      _VK_VOLUME_UP: Result := NAME_VK_VOLUME_UP;
      _VK_MEDIA_NEXT_TRACK: Result := NAME_VK_MEDIA_NEXT_TRACK;
      _VK_MEDIA_PREV_TRACK: Result := NAME_VK_MEDIA_PREV_TRACK;
      _VK_MEDIA_STOP: Result := NAME_VK_MEDIA_STOP;
      _VK_MEDIA_PLAY_PAUSE: Result := NAME_VK_MEDIA_PLAY_PAUSE;
      _VK_LAUNCH_MAIL: Result := NAME_VK_LAUNCH_MAIL;
      _VK_LAUNCH_MEDIA_SELECT: Result := NAME_VK_LAUNCH_MEDIA_SELECT;
      _VK_LAUNCH_APP1: Result := NAME_VK_LAUNCH_APP1;
      _VK_LAUNCH_APP2: Result := NAME_VK_LAUNCH_APP2;
    else
      Result := '';
    end;
  end;

  function GetModifierNames: string;
  var
    s: string;
  begin
    s := '';
    if Localized then begin
      if (HotKey and $4000) <> 0 then // scCtrl
        s := s + LocalModName_Ctrl + '+';
      if (HotKey and $2000) <> 0 then // scShift
        s := s + LocalModName_Shift + '+';
      if (HotKey and $8000) <> 0 then // scAlt
        s := s + LocalModName_Alt + '+';
      if (HotKey and $10000) <> 0 then
        s := s + LocalModName_Win + '+';
    end
    else begin
      if (HotKey and $4000) <> 0 then // scCtrl
        s := s + ModName_Ctrl + '+';
      if (HotKey and $2000) <> 0 then // scShift
        s := s + ModName_Shift + '+';
      if (HotKey and $8000) <> 0 then // scAlt
        s := s + ModName_Alt + '+';
      if (HotKey and $10000) <> 0 then
        s := s + ModName_Win + '+';
    end;
    Result := s;
  end;

  function GetVKName(Special: Boolean): string;
  var
    scanCode: Cardinal;
    KeyName: array[0..255] of Char;
    oldkl: HKL;
    Modifiers, Key: Word;
  begin
    Result := '';
    if Localized then {// Local language key names}  begin
      if Special then
        scanCode := (MapVirtualKey(Byte(HotKey), 0) shl 16) or (1 shl 24)
      else
        scanCode := (MapVirtualKey(Byte(HotKey), 0) shl 16);
      if scanCode <> 0 then begin
        GetKeyNameText(scanCode, KeyName, SizeOf(KeyName));
        Result := KeyName;
      end;
    end
    else {// English key names}  begin
      if Special then
        scanCode := (MapVirtualKeyEx(Byte(HotKey), 0, EnglishKeyboardLayout) shl 16) or (1 shl 24)
      else
        scanCode := (MapVirtualKeyEx(Byte(HotKey), 0, EnglishKeyboardLayout) shl 16);
      if scanCode <> 0 then begin
        oldkl := GetKeyboardLayout(0);
        if oldkl <> EnglishKeyboardLayout then
          ActivateKeyboardLayout(EnglishKeyboardLayout, 0); // Set English kbd. layout
        GetKeyNameText(scanCode, KeyName, SizeOf(KeyName));
        Result := KeyName;
        if oldkl <> EnglishKeyboardLayout then begin
          if ShouldUnloadEnglishKeyboardLayout then
            UnloadKeyboardLayout(EnglishKeyboardLayout); // Restore prev. kbd. layout
          ActivateKeyboardLayout(oldkl, 0);
        end;
      end;
    end;

    if Length(Result) <= 1 then begin
      // Try the internally defined names
      SeparateHotKey(HotKey, Modifiers, Key);
      if IsExtendedKey(Key) then
        Result := GetExtendedVKName(Key);
    end;
  end;

var
  KeyName: string;
begin
  case Byte(HotKey) of
    // PgUp, PgDn, End, Home, Left, Up, Right, Down, Ins, Del
    $21..$28, $2D, $2E: KeyName := GetVKName(True);
  else
    KeyName := GetVKName(False);
  end;
  Result := GetModifierNames + KeyName;
end;
{===============================Edit函数结束================================================}


{ TColors }

constructor TColors.Create;
begin
  inherited Create;
  FDisabled := clBtnFace;
  FSelected := clWhite;
  FBkgrnd := clWhite;
  FBorder := $007F7F7F;
  FFont := clBlack;
  FUp := $00F1EFAB;
  FHot := clNavy;
  FDown := $00F1EFAB;
  FLine := clBtnFace;
end;
{----------------------------- TDControl -------------------------------}

constructor TDControl.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  DParent := nil;
  inherited Visible := False;
  FEnableFocus := False;
  Background := False;
  //FIsManager := False;
  //bMouseMove := False;
  FOnDirectPaint := nil;
  FOnDirectPaint2 := nil;
  FOnKeyPress := nil;
  FOnKeyDown := nil;
  FOnMouseMove := nil;
  FOnMouseDown := nil;
  FOnMouseUp := nil;
  FOnInRealArea := nil;
  //FOnMouseWheel := nil;
  DControls := TList.Create;
  FDParent := nil;

  Width := 80;
  Height := 24;
  FCaption := '';
  FVisible := True;
  WLib := nil;
  ULib := nil;
  ImageSurface := nil;
  FaceIndex := 0;
  FaceName := '';
  PageActive := False;
  //FRightClick := False;
end;

destructor TDControl.Destroy;
begin
  if Self = MouseMoveControl then MouseMoveControl := nil;
  DControls.Free;
  inherited Destroy;
end;

procedure TDControl.SetCaption(Str: string);
begin
  FCaption := Str;
  if csDesigning in ComponentState then begin
    Refresh;
  end;
end;

//function TDControl.GetMouseMove: Boolean;
//begin
//  Result := MouseMoveControl = Self;
//end;

//function TDControl.GetClientRect: TRect;
//begin
//  Result.Left := SurfaceX(Left);
//  Result.Top := SurfaceY(Top);
//  Result.Right := Result.Left + Width;
//  Result.Bottom := Result.Top + Height;
//end;

procedure TDControl.AdjustPos(X, Y: Integer);
begin
  Top := Y;
  Left := X;
  //PTop := Top;
end;

procedure TDControl.AdjustPos(X, Y, W, H: Integer);
begin
  Left := X;
  Top := Y;
  Width := W;
  Height := H;
  //PTop := Top;
end;

procedure TDControl.Paint;
begin
  if csDesigning in ComponentState then begin
    if self is TDWindow then begin
      with Canvas do begin
        Pen.Color := clNavy;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        LineTo(Width - 1, Height - 1);
        MoveTo(Width - 1, 0);
        LineTo(0, Height - 1);
        TextOut((Width - TextWidth(Caption)) div 2, (Height - TextHeight(Caption)) div 2, Caption);
      end;
    end else begin
      with Canvas do begin
        Pen.Color := clNavy;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        TextOut((Width - TextWidth(Caption)) div 2, (Height - TextHeight(Caption)) div 2, Caption);
      end;
    end;
  end;
end;

procedure TDControl.Loaded;
var
  i                         : Integer;
  dcon                      : TDControl;
begin
  if not (csDesigning in ComponentState) then begin
    if Parent <> nil then begin
      for i := 0 to TControl(Parent).ComponentCount - 1 do begin
        if TControl(Parent).Components[i] is TDControl then begin
          dcon := TDControl(TControl(Parent).Components[i]);
          if dcon.DParent = self then begin
            AddChild(dcon);
          end;
        end;
      end;
    end;
  end;
end;

//procedure TDControl.Process;
//var
//  I: Integer;
//begin
//  if Assigned(FOnProcess) then FOnProcess(Self);
//  for I := 0 to DControls.Count - 1 do
//    if TDControl(DControls[I]).Visible then
//      TDControl(DControls[I]).Process;
//end;


function TDControl.SurfaceX(X: Integer): Integer;
var
  d                         : TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then Break;
    X := X + d.DParent.Left;
    d := d.DParent;
  end;
  Result := X;
end;

function TDControl.SurfaceY(Y: Integer): Integer;
var
  d                         : TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then Break;
    Y := Y + d.DParent.Top;
    d := d.DParent;
  end;
  Result := Y;
end;

function TDControl.LocalX(X: Integer): Integer;
var
  d                         : TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then Break;
    X := X - d.DParent.Left;
    d := d.DParent;
  end;
  Result := X;
end;

function TDControl.LocalY(Y: Integer): Integer;
var
  d                         : TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then Break;
    Y := Y - d.DParent.Top;
    d := d.DParent;
  end;
  Result := Y;
end;

procedure TDControl.AddChild(dcon: TDControl);
begin
  DControls.Add(Pointer(dcon));
end;

procedure TDControl.ChangeChildOrder(dcon: TDControl);
var
  i                         : Integer;
begin
  if not (dcon is TDWindow) then Exit;
  if TDWindow(dcon).Floating then begin
    for i := 0 to DControls.count - 1 do begin
      if dcon = DControls[i] then begin
        DControls.Delete(i);
        Break;
      end;
    end;
    DControls.Add(dcon);
  end;
end;

function TDControl.InRange(X, Y: Integer; Shift: TShiftState): Boolean;
var
  boInRange                 : Boolean;
  d                         : TDXTexture;
begin
  if (X >= Left) and (X < (Left + Width)) and (Y >= Top) and (Y < (Top + Height))
    and (((ssRight in Shift) {and FRightClick}) or not (ssRight in Shift)) then begin
    boInRange := True;
    if Assigned(FOnInRealArea) then
      FOnInRealArea(self, X - Left, Y - Top, boInRange)
    else if ImageSurface <> nil then begin
      if ImageSurface.Pixels[X - Left, Y - Top] <= 0 then
        boInRange := False;
    end else if WLib <> nil then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then begin
        if d.Pixels[X - Left, Y - Top] <= 0 then
          boInRange := False;
      end;
    end else if ULib <> nil then begin
      d := ULib.Images[FaceName];
      if d <> nil then begin
        if d.Pixels[X - Left, Y - Top] <= 0 then
          boInRange := False;
      end;
    end;                              
    Result := boInRange;
  end else
    Result := False;
end;

function TDControl.KeyPress(var Key: Char): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if Background then Exit;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyPress(Key) then begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = self) then begin
    if Assigned(FOnKeyPress) then
      FOnKeyPress(self, Key);
    Result := True;
  end;
end;

function TDControl.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if Background then Exit;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyDown(Key, Shift) then begin
        Result := True;
        Exit;
      end;
  if (FocusedControl = self) then begin
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    Result := True;
  end;
end;

function TDControl.CanFocusMsg: Boolean;
begin
  if (MouseCaptureControl = nil) or ((MouseCaptureControl <> nil) and ((MouseCaptureControl = self) or (MouseCaptureControl = DParent))) then
    Result := True
  else
    Result := False;
end;

//procedure TDControl.CaptionChaged;
//begin
//
//end;



function TDControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
  dc                        : TDControl;
begin
  Result := False;

  for i := DControls.count - 1 downto 0 do begin
    dc := TDControl(DControls[i]);
    if dc.Visible then begin
      //if (ssRight in Shift) and not dc.FRightClick then Continue;
      if dc.MouseMove(Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
    end;
  end;

  if (MouseCaptureControl <> nil) then begin
    if (MouseCaptureControl = self) then begin

      //if (ssRight in Shift) and not FRightClick then Exit;

      if  Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;
  if InRange(X, Y, Shift) then begin
     MouseMoveControl := Self;
    if  Assigned(FOnMouseMove) then
      FOnMouseMove(self, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
  dc                        : TDControl;
begin
  Result := False;

  for i := DControls.count - 1 downto 0 do begin
    dc := TDControl(DControls[i]);
    if dc.Visible then begin

      if dc.MouseDown(Button, Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
    end;
  end;

  if Background then begin
    if Assigned(FOnBackgroundClick) then begin
      WantReturn := False;
      FOnBackgroundClick(self);
      if WantReturn then Result := True;
    end;
    ReleaseDFocus;
    Exit;
  end;

  if CanFocusMsg then begin
    if InRange(X, Y, Shift) or (MouseCaptureControl = self) then begin
      MouseMoveControl := nil;
      //if (Button = mbRight) and not FRightClick then Exit;

      if Assigned(FOnMouseDown) then
        FOnMouseDown(self, Button, Shift, X, Y);
      if EnableFocus then begin
        if (self is TDxHint) and (TDxHint(self).ParentControl <> nil) then begin
          SetDFocus(TDxHint(self).ParentControl);
        end else
          SetDFocus(self);
      end;
      Result := True;
    end;
  end;
end;

function TDControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
  dc                        : TDControl;
begin
  Result := False;
  for i := DControls.count - 1 downto 0 do begin
    dc := TDControl(DControls[i]);
    if dc.Visible then begin
      if (dc is TDxHint) then dc.Visible := False;
      //if (Button = mbRight) and not dc.FRightClick then Continue;
      if dc.MouseUp(Button, Shift, X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
    end;
  end;

  if (MouseCaptureControl <> nil) then begin //MouseCapture
    if (MouseCaptureControl = self) then begin

      //if (Button = mbRight) and not FRightClick then Exit;

      if Assigned(FOnMouseUp) then
        FOnMouseUp(self, Button, Shift, X, Y);
      Result := True;
    end;
    Exit;
  end;

  if Background then Exit;

  if InRange(X, Y, Shift) then begin
    if Assigned(FOnMouseUp) then
      FOnMouseUp(self, Button, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.DblClick(X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then begin //MouseCapture
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnDblClick) then
        FOnDblClick(self);
      Result := True;
    end;
    Exit;
  end;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).DblClick(X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if Background then Exit;
  if InRange(X, Y, [ssDouble]) then begin
    if Assigned(FOnDblClick) then
      FOnDblClick(self);
    Result := True;
  end;
end;

function TDControl.Click(X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then begin //MouseCapture
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnClick) then begin
        FOnClick(self, X, Y);
      end;
      Result := True;
    end;
    Exit;
  end;
  for i := DControls.count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).Click(X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if Background then Exit;
  if InRange(X, Y, [ssDouble]) then begin
    if Assigned(FOnClick) then begin
      FOnClick(self, X, Y);
    end;
    Result := True;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; Index: Integer);
var
  d                         : TDXTexture;
  pt                        : TPoint;
begin
  WLib := Lib;
  FaceIndex := Index;
  if Lib <> nil then begin
    d := Lib.Images[FaceIndex];
    if d <> nil then begin
      Width := d.Width;
      Height := d.Height;
    end;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; Index, X, Y: Integer);
var
  d                         : TDXTexture;
  pt                        : TPoint;
begin
  WLib := Lib;
  FaceIndex := Index;
  Self.Left := X;
  Self.Top := Y;
  if Lib <> nil then begin
    d := Lib.Images[FaceIndex];
    if d <> nil then begin
      Width := d.Width;
      Height := d.Height;
    end;
  end;
end;

procedure TDControl.SetImgName(Lib: TUIBImages; F: string);
var
  d                         : TDXTexture;
begin
  try
    ULib := Lib;
    FaceName := F;
    if Lib <> nil then begin
      d := Lib.Images[F];
      if d <> nil then begin
        Width := d.Width;
        Height := d.Height;
      end else if not Background then   //123456
        ;                               //ReloadTex := True;
    end;
  except
    on E: Exception do begin
    //  debugOutStr('TDControl.SetImgName ' + E.Message);
    end;
  end;
end;

procedure TDControl.DirectPaint(dsurface: TDXTexture);
var
  i                         : Integer;
  d                         : TDXTexture;
begin
  if Assigned(FOnDirectPaint) then begin
    FOnDirectPaint(self, dsurface);
//    //123456
//    if ReloadTex then begin
//      if (WLib <> nil) and (FaceIndex > 0) then begin
//        d := WLib.Images[FaceIndex];
//        if d <> nil then begin
//          ReloadTex := False;
//          Width := d.Width;
//          Height := d.Height;
//        end;
//      end;
//    end;
  end else if WLib <> nil then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if not Background and (WLib <> nil) and (FaceIndex > 0) then begin
      SetImgIndex(WLib, FaceIndex);
    end;
  end else if ULib <> nil then begin
    d := ULib.Images[FaceName];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if not Background and (ULib <> nil) and (FaceName <> '') then begin
      SetImgName(ULib, FaceName);
    end;
  end;
  for i := 0 to DControls.count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
  if Assigned(FOnDirectPaint2) then
    FOnDirectPaint2(self, dsurface);
end;

{--------------------- TDButton --------------------------}

constructor TDButton.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  Downed := False;
  Arrived := False;
  FFloating := False;
  FOnClick := nil;
  CaptionEx := '';
  FEnableFocus := True;
  FClickSound := csNone;
  btnState := tnor;
  ClickInv := 0;
  Clicked := True;
end;

function TDButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at                    : Integer;
begin
  Result := False;
  if btnState = tdisable then Exit;
  btnState := tnor;

  Result := inherited MouseMove(Shift, X, Y);
  Arrived := Result;
  if (not Background) and (not Result) then begin
    //Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then
      if InRange(X, Y, Shift) then begin
        Downed := True;
      end else begin
        Downed := False;
      end;
  end;

  if Result and FFloating and (MouseCaptureControl = self) then begin
    if (SpotX <> X) or (SpotY <> Y) then begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      Left := al;
      Top := at;
      SpotX := X;
      SpotY := Y;
      //DScreen.AddChatBoardString(format(' - %d %d %d', [tag, Left, Top]), clWhite, clRed);
    end;
  end;
end;

function TDButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if btnState = tdisable then Exit;

  if inherited MouseDown(Button, Shift, X, Y) then begin
    if GetTickCount - ClickInv <= 150 then begin
      //SetDCapture(self);
      Result := True;
      Exit;
    end;

    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;

    if Result then begin
      if Floating then begin
        if DParent <> nil then
          DParent.ChangeChildOrder(self);
      end;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

function TDButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if btnState = tdisable then Exit;

  if inherited MouseUp(Button, Shift, X, Y) then begin
    if not Downed then begin
      Result := True;
      ClickInv := 0;
      Exit;
    end;
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y, Shift) then begin

        if GetTickCount - ClickInv <= 150 then begin
          //Result := True;
          Downed := False;
          Exit;
        end;
        ClickInv := GetTickCount;

        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;

    Downed := False;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{--------------------- TDCheckBox --------------------------}

constructor TDCheckBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FArrived := False;
  Checked := False;
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
end;

function TDCheckBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  FArrived := Result;
  if (not Background) and (not Result) then begin
    //Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then
      if InRange(X, Y, Shift) then
        Downed := True
      else
        Downed := False;
  end;
end;

function TDCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;
  end;
end;

function TDCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y, Shift) then begin
        Checked := not Checked;
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{--------------------- TDCustomControl --------------------------}

constructor TDCustomControl.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  Downed := False;
  FOnClick := nil;
  FEnableFocus := True;
  FClickSound := csNone;
  FTransparent := True;
  FEnabled := True;
  FFrameVisible := True;
  FFrameHot := False;
  FFrameSize := 1;
  FFrameColor := $00406F77;
  FFrameHotColor := $00599AA8;
end;

procedure TDCustomControl.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then
    FTransparent := Value;
end;

procedure TDCustomControl.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
    FEnabled := Value;
end;

procedure TDCustomControl.SetFrameVisible(Value: Boolean);
begin
  if FFrameVisible <> Value then
    FFrameVisible := Value;
end;

procedure TDCustomControl.SetFrameHot(Value: Boolean);
begin
  if FFrameHot <> Value then
    FFrameHot := Value;
end;

procedure TDCustomControl.SetFrameSize(Value: byte);
begin
  if FFrameSize <> Value then
    FFrameSize := Value;
end;

procedure TDCustomControl.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then begin
    FFrameColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDCustomControl.SetFrameHotColor(Value: TColor);
begin
  if FFrameHotColor <> Value then begin
    FFrameHotColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDCustomControl.OnDefaultEnterKey;
begin
  //
end;

procedure TDCustomControl.OnDefaultTabKey;
begin
  //
end;

function TDCustomControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if FEnabled and not Background then begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

function TDCustomControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if FEnabled then begin
      if (not Background) and (MouseCaptureControl = nil) then begin
        Downed := True;
        SetDCapture(self);
      end;
    end;
    Result := True;
  end;
end;

function TDCustomControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if FEnabled and not Background then begin
      if InRange(X, Y, Shift) then begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    Exit;
  end else begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

procedure DEditMenu_Cut(DEdit : TDEdit);
var
  Key: Word;
begin
  Key := Ord('x');
  DEdit.KeyDown(Key, [ssCtrl]);
end;


procedure DEditMenu_Copy(DEdit : TDEdit);
var
  Key: Word;
begin
  Key := Ord('c');
  DEdit.KeyDown(Key, [ssCtrl]);
end;

procedure DEditMenu_Paste(DEdit : TDEdit);
var
  Key: Word;
begin
  Key := Ord('v');
  DEdit.KeyDown(Key, [ssCtrl]);
end;

procedure DEditMenu_Delete(DEdit : TDEdit);
var
  Key: Word;
begin
  Key := VK_DELETE;
  DEdit.KeyDown(Key, [ssCtrl]);
end;

procedure DEditMenu_SelectAll(DEdit : TDEdit);
begin

end;

{--------------------- TDEditMenu --------------------------}
constructor TDEditMenu.Create(AOwner: TComponent);
begin
  inherited;
  ItemHeight := 15;
  Width := 50;

  Menus := TStringList.Create;
  Menus.AddObject('  剪切', TObject(@DEditMenu_Cut));
  Menus.AddObject('  复制', TObject(@DEditMenu_Copy));
  Menus.AddObject('  粘贴', TObject(@DEditMenu_Paste));
  Menus.AddObject('  删除', TObject(@DEditMenu_Delete));
  Menus.AddObject('-', nil);
  Menus.AddObject('  全选', TObject(@DEditMenu_SelectAll));
  Height := Menus.Count * ItemHeight;
  Visible := False;
end;

destructor TDEditMenu.Destroy;
begin
  Menus.Free;
  inherited;
end;


procedure TDEditMenu.DirectPaint (dsurface: TDXTexture);
var
  I : Integer;
begin
  for I := 0 to Menus.Count - 1 do begin

    if FocusItemIndex <> I then
      dsurface.FillRect(Bounds(SurfaceX(Left), SurfaceY(Top) + ItemHeight * I, Width, ItemHeight), clWhite)
    else
      dsurface.FillRect(Bounds(SurfaceX(Left), SurfaceY(Top) + ItemHeight * I, Width, ItemHeight), clBlue);
    if Menus[I] = '-' then begin
      dsurface.FillRect(Bounds(SurfaceX(Left), SurfaceY(Top) + MainForm.Canvas.TextHeight('bp') div 2  + ItemHeight * I, Width, 1), 0);
      Continue;
    end;
    if FocusItemIndex = I then
      g_DXCanvas.TextOut(SurfaceX(Left),      //-16777209    -16777187
            SurfaceY(Top) + ItemHeight * I, clWhite, Menus[I])
    else
    if Menus.Objects[I] <> nil then
      g_DXCanvas.TextOut(SurfaceX(Left),      //-16777209    -16777187
            SurfaceY(Top) + ItemHeight * I, $00000007, Menus[I])
    else
      g_DXCanvas.TextOut(SurfaceX(Left),
            SurfaceY(Top) + ItemHeight * I, $FF6D6D6D, Menus[I])
  end;
  {AspTextureFont.TextOut(SurfaceX(GLeft) + 50,
            SurfaceY(GTop) , clGrayText, Format('%d.%d',[XX, YY]), [])}
end;

function TDEditMenu.MouseMove (Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Dec(X, Left);
  if (X > 0) and (X < Width) then
    FocusItemIndex := (Y - Top) div ItemHeight
  else
    //FocusItemIndex := -1;
end;

function TDEditMenu.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := (FocusItemIndex >= 0) and (FocusItemIndex < Menus.Count) and (Menus.Objects[FocusItemIndex] <> nil);
  if Result then
    TDEditMenuProc(Menus.Objects[FocusItemIndex])(DEdit);
  Visible := False;
end;

procedure TDEditMenu.Popup(ADEdit : TDEdit; X, Y: Integer);
begin
  DEdit := ADEdit;
  Left := X;
  Top := Y;
  Top := Min(Top, DisplaySize.y - Height);
  Left := Min(Left, DisplaySize.x - Width);
  Visible := True;
  if DEdit.SelCount > 0 then begin
    Menus.Objects[0] := TObject(@DEditMenu_Cut);
    Menus.Objects[1] := TObject(@DEditMenu_Copy);
    //Menus.AddObject('粘贴', TObject(@DEditMenu_Paste);
    Menus.Objects[3] := TObject(@DEditMenu_Delete);
  end else begin
    Menus.Objects[0] := nil;
    Menus.Objects[1] := nil;
    Menus.Objects[3] := nil;
  end;

  if DEdit.SelCount <> DEdit.GetTextLen then //全选
    Menus.Objects[5] := TObject(@DEditMenu_SelectAll)
  else
    Menus.Objects[5] := nil;

  if Clipboard.AsText = '' then //粘贴
    Menus.Objects[2] := TObject(@DEditMenu_Paste)
  else
    Menus.Objects[2] := nil;
   
end;

{--------------------- TDEdit --------------------------}
constructor TDEdit.Create(AOwner: TComponent);
begin
  inherited Create (AOwner);   //组件创建
  if lDEditMenu = nil then begin
    lDEditMenu := TDEditMenu.Create(nil);
    lDEditMenu.DParent := nil;
  end;
  FColor := clWhite;           //字体颜色
  {Width := 30;                //宽度
  Height := 19;                //高度}
  //Cursor := crIBeam;           //光标
  BorderWidth := 2;            //边框宽度
  Font := TFont.Create;        //字体创建
  //FCanGetFocus := true;
  Moveed := False; 
  BlinkSpeed := 20;            //光标闪烁
  FSelCol := clBlue;      //选择颜色
  FText:= '';
  KeyByteCount := 0;
  FMaxLength := 0;
  //FEnableFocus := True;        //是否有焦点
end;
//删除文字
procedure TDEdit.DelSelText;
var s:integer;
begin
  s := selStart;
  if SelStart > SelStop then s := SelStop;
  Delete(FText,S+1,SelCount);
  SelStart := s;
  SelStop := s;
end;

function TDEdit.CopySelText():string;
var
  s:Integer;
begin
  Result := '';
  s := SelStart;
  if SelStart > SelStop then s := SelStop;
  Result := Copy(FText,S+1,SelCount);
end;
//画的方法
procedure TDEdit.DirectPaint(dsurface: TDXTexture);
function CharPos(Index: Integer): Integer;
var
  sText: WideString;
  TextBefore: WideString;
begin
     //-------modi by huasoft-------------------------------------
     // (2) Extract part of text prior to selector
    sText := FText;
    TextBefore := '';

    if (Index > 0) then TextBefore := Copy(sText, 1, Index);

    Result := MainForm.Canvas.TextWidth(TextBefore);
end;
var 
    SelStartX:integer;
    SelStopX:integer;
    Ypos:integer;
    sTemPass: string;
    I: Integer;
    TextHeight : Integer;
    SelRect: TRect;
    fC : TColor;
    rgn:{THandle}HRGN;
begin
  if not FTransparent then begin
      dsurface.FillRect(ClientRect, FColor);
  end;
  inherited DirectPaint(dsurface);
    SelStartX := MainForm.Canvas.TextWidth(copy(FText,1,SelStart));
    SelStopX := MainForm.Canvas.TextWidth(copy(FText,1,SelStop));
    YPos := ((Height) - MainForm.Canvas.TextHeight(FText)) div 2;
    XDif := 0;
    if SelStopX > Width-5 then XDif := SelStopX-Width+MainForm.Canvas.TextWidth('W')*2;
    {*********此函数为选择了某字符而变色*******}
    //showmessage(inttostr(SurfaceX(Left)));
      //Canvas.FillRect(rect(X+SelStartX+1-XDif,Y+borderwidth+1,X+SelStopX+1-XDif,Y+Self.Height-BorderWidth));
    fC := FFont.Color;
    TextHeight := MainForm.Canvas.TextHeight(FText);
    if (SelCount > 0) and (FocusedControl = Self) and Enabled then begin
      SelRect := Bounds(SurfaceX(Left) + 2, SurfaceY(Top) + (Height - TextHeight) div 2, Width - 1, TextHeight);
      SelRect.Left := SurfaceX(Left) + 2 + CharPos(Min(SelStart, SelStop));
      SelRect.Right := SurfaceX(Left) + 2 + Min(CharPos(Max(SelStart, SelStop)), Width);
      dsurface.FillRect(SelRect, FSelCol);
      fC := $FFFFFFFF;//选择后字体颜色为白色
      //end;
    end;
    //Brush.Style := bsClear;
    {******************************************}
    //输出Capiton内容
    if Enabled then begin
      if FPasswordChar = #0 then begin
        g_DXCanvas.TextRectX(rect(SurfaceX(Left),SurfaceY(Top),SurfaceX(Left)+Width,SurfaceY(Top)+Height),
            {Bounds(0, 0, Width, Height),} SurfaceX(Left)+BorderWidth-XDif, SurfaceY(Top)+YPos + 1,FText, fC);
      end else begin
        sTemPass := '';
        for i := 1 to length(FText) do sTemPass := sTemPass + '*';
        g_DXCanvas.TextRectX(rect(SurfaceX(Left),SurfaceY(Top),SurfaceX(Left)+Width,SurfaceY(Top)+Height),
            {Bounds(0, 0, Width, Height),} SurfaceX(Left)+BorderWidth-XDif, SurfaceY(Top)+YPos + 1,sTemPass, fC);
      end;
    end;
    DoMove;
    if (FocusedControl=self) and Enabled then
      if cursorvisible then   //光标是否可见   闪烁用的这个
    begin
      //画光标

     dsurface.FillRect(Bounds(SurfaceX(Left)+SelStopX+BorderWidth-XDif,
                            SurfaceY(Top) + (Height - TextHeight) div 2+ 2,
                            1,
                            TextHeight - 2), FFont.Color);
    end;
end;
//光标闪烁函数
procedure TDEdit.DoMove;
begin
  CursorTime := CursorTime + 1;
  If CursorTime > BlinkSpeed then
  begin
    CursorVisible := not CursorVisible;
    CursorTime := 0;
  end;
end;
//得到选择数量
function TDEdit.GetSelCount: integer;
begin
  result := abs(SelStop-SelStart);
end;
//最大输入数量
procedure TDEdit.SetMaxLength(const Value: Integer);
begin
  FMaxLength := Value;

  if (FMaxLength > 0) and (Length(string(FText)) > FMaxLength) then
  begin
    FText := Copy(FText, 1, FMaxLength);
    if (SelStart > Length(string(FText))) then SelStart := Length(string(FText));
  end;
end;

function TDEdit.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  AddTx: string;
begin
  //if not FVisible then ReleaseDFocus;
  if not FVisible or not DParent.FVisible then Exit;
  Result := inherited KeyDown(Key, Shift); //处理按键 主程序不执行了按键效果
  if (Result) and (not Background) and Enabled then begin
      //Result := inherited KeyDown(Key, Shift); 
      CursorVisible := true;
      CursorTime := 0;
      if key = VK_BACK then begin
        if SelCount = 0 then begin
          Delete(FText,SelStart,1);
          SelStart := SelStart-1;
          SelStop := SelStart;
        end else begin
          DelSelText;
        end;
        if (Assigned(FOnChange)) then FOnChange(Self);
      end;
      if key = VK_DELETE then begin
        if SelCount = 0 then begin
          Delete(FText,SelStart+1,1);
        end else
          DelSelText;
        if (Assigned(FOnChange)) then FOnChange(Self);
      end;
      if key = VK_LEFT then begin
        if ssShift in Shift then begin
          SelStop := SelStop-1;
        end else begin
          if SelStop < SelStart then begin
            SelStart := SelStop;
          end else begin
            if SelStop > SelStart then begin
              SelStart := SelStop;
            end else begin
              SelStart := SelStart-1;
              SelStop := SelStart;
            end;
          end;
        end;
      end;
      if key = VK_HOME then begin
        if ssShift in Shift then begin
          SelStop := 0;
        end else begin
          SelStart := 0;
          SelStop := 0;
        end;
      end;
      if key = VK_END then begin
        if ssShift in Shift then begin
          SelStop := Length(FText);
        end else begin
          SelStart := Length(FText);
          SelStop := Length(FText);
        end;
      end;
      if key = VK_RIGHT then begin
        if ssShift in Shift then begin
          SelStop := SelStop+1;
        end else begin
          if SelStop < SelStart then begin
            SelStart := SelStop;
          end else begin
            if SelStop > SelStart then begin
              SelStart := SelStop;
            end else begin
              SelStart := SelStart+1;
              SelStop := SelStart;
            end;
          end;
        end;
      end;
      if (ssCtrl in Shift) then begin
        case Key of
          Byte('V'),Byte('v') : begin   //粘贴代码
            DelSelText;//先删除选择的文字By TasNat at:2012-12-13 10:37:33
            AddTx := Clipboard.AsText;
            Insert(AddTx, FText, SelStart + 1);
            Inc(SelStart, Length(AddTx));
            if (FMaxLength > 0) and (Length(FText) > FMaxLength) then begin
              FText := Copy(FText, 1, FMaxLength);
              if (SelStart > Length(FText)) then SelStart := Length(FText);
            end;
            SelStop := SelStart;
            if (Assigned(FOnChange)) then FOnChange(Self);
          end;
          Byte('C'),Byte('c'): begin   //复制
            Clipboard.AsText := CopySelText();
          end;
          Byte('X'),Byte('x'): if SelCount > 0 then begin   //剪贴
            Clipboard.AsText := CopySelText();
            DelSelText;
            if (Assigned(FOnChange)) then FOnChange(Self);
          end;
        end;
      end;
      if SelStart < 0 then SelStart := 0;
      if SelStart > Length(FText) then SelStart := Length(FText);
      if SelStop < 0 then SelStop := 0;
      if SelStop > Length(FText) then SelStop := Length(FText);
  end;
end;

function TDEdit.KeyPress(var Key: Char): Boolean;
begin

  if not FVisible or not DParent.FVisible then Exit;
  if (inherited KeyPress(Key)) and (not Background) then begin
      Result := inherited KeyPress(Key); //处理按键 主程序不执行了按键效果
    if Enabled then begin
      if (ord(key) > 31) {and ((ord(key) < 127) or (ord(key) > 159))} then begin
        if SelCount > 0 then DelSelText;

          {if (FMaxLength > 0) and (Length(string(FText)) > FMaxLength) then
          begin
            FText := Copy(FText, 1, FMaxLength);
            if (SelStop > Length(string(FText))) then SelStop := Length(string(FText));
          end;  }

     //--------------By huasoft-------------------------------------------------------
        if ((FMaxLength < 1) or (Length(string(FText)) < FMaxLength)) then begin
        if  IsDBCSLeadByte(Ord(Key)) or boDoubleByte then //判断是否是汉字
        begin
            boDoubleByte :=true;
            Inc(KeyByteCount);          //字节数
            InputStr:=InputStr+ Key;
        end;


        if not boDoubleByte then begin
          if SelStart >= Length(FText) then begin
            FText := FText + Key;
          end else begin
            Insert(Key,FText,SelStart+1);
          end;
          Inc(SelStart);
        end else begin
          if KeyByteCount >= 2 then begin   //字节数为2则为汉字
            if SelStart >= Length(FText) then begin
              FText := FText + InputStr;
            end else begin
              Insert(InputStr,FText,SelStart+1);
            end;
          boDoubleByte := False;
          KeyByteCount := 0;
          InputStr := '';
          Inc(SelStart);
          end;
        end;
          //SelStart := SelStart+1;
          SelStop := SelStart;
        end;
        if (Assigned(FOnChange)) then FOnChange(Self);
      end;
    end;
  end;
end;

function TDEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  if not FVisible or not DParent.FVisible then Exit;
  if (lDEditMenu <> nil) and (lDEditMenu.DEdit = Self) and lDEditMenu.Visible then
    lDEditMenu.MouseMove(Shift, SurfaceX(X), SurfaceY(Y));
   //if ssLeft in Shift then begin
   Result := inherited MouseMove (Shift, X, Y);
   Moveed := Result;
   if ssLeft in Shift then begin
     if (not Background){ and (not Result)} then begin
        Result := inherited MouseMove (Shift, X, Y);
        if MouseCaptureControl = self then begin
           {if InRange (X, Y) then} SelStop := MouseToSelPos(x-left);
           //else Downed := FALSE;
        end;
     end;
   end;

end;

//这个是鼠标按下的事件   没问题
function TDEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := (lDEditMenu <> nil) and (lDEditMenu.DEdit = Self) and lDEditMenu.Visible and
    lDEditMenu.MouseDown(Button, Shift, X, Y);
  if not FVisible or not DParent.FVisible or Result then Exit;
   Result := FALSE;
   if inherited MouseDown (Button, Shift, X, Y) then begin
      if Enabled then begin
        if (not Background) and (MouseCaptureControl=nil) then begin
           case Button of
             mbRight : if (ActiveMenu = nil) or (not ActiveMenu.Visible) then lDEditMenu.Popup(Self, SurfaceX(X),SurfaceY(Y));
             {mbLeft : }else begin
               SelStart := MouseToSelPos(x-left);
               SelStop := SelStart;
               SetDCapture (self);
             end;
           end;

        end;
        Result := TRUE;
      end;
   end;
end;

function TDEdit.MouseToSelPos(AX: integer): integer;
var
  I:integer;
  AX1: Integer;
begin
  Result := length(FText);
  AX1 := AX-Borderwidth+XDif -3;
  if Result <= 0 then begin //2080629
    Exit;
  end;
  for i := 0 to Result do begin
    if MainForm.Canvas.TextWidth(copy(FText,1,I)) >= AX1 then begin
      Result := I;
      break;
    end;
  end;
end;

procedure TDEdit.SetSelLength(Value: Integer);
begin
  if SelStart > 0 then
    SelStop := SelStart + Value;
end;


function TDEdit.GetSelLength: Integer;
begin
  Result := SelStart;
  if Result > 0 then
    Result := SelStop + Result;
end;

procedure TDEdit.Update;
begin
  inherited;

end;

function TDEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
   Result := FALSE;
   if inherited MouseUp(Button, Shift, X, Y) then begin
      if Enabled then begin
        ReleaseDCapture;
        if not Background then begin
           if InRange (X, Y, Shift) then begin
              if Assigned (FOnClick) then FOnClick(self, X, Y);
           end;
        end;
        Result := TRUE;
        exit;
      end;
   end else begin
      ReleaseDCapture;
   end;
end;

procedure TDEdit.SetText (str: Widestring);
begin
   FText := str;
   if csDesigning in ComponentState then begin
      Refresh;
   end;
end;

procedure TDEdit.SetFocus;
begin
  SetDFocus (self);
end;

destructor TDEdit.Destroy;
begin
  Font.Free;
  inherited;
end;

procedure TDEdit.SetPasswordChar(Value: Char);
begin
  if FPasswordChar <> Value then FPasswordChar := Value;
end;

procedure TDEdit.Paint;
begin
  if csDesigning in ComponentState then begin
    with Canvas do begin
      Brush.Color := clWhite;
      FillRect(ClipRect);
      Pen.Color := cl3DDkShadow;
      MoveTo(0, 0);
      LineTo(Width - 1, 0);
      LineTo(Width - 1, Height - 1);
      LineTo(0, Height - 1);
      LineTo(0, 0);
      TextOut((Width - TextWidth(Text)) div 2, (Height - TextHeight(Text)) div 2 - 1, Text);
    end;
  end;
end;

{--------------------- TDxScrollBarBar --------------------------}

constructor TDxScrollBarBar.Create(aowner: TComponent; nTmpList: TStrings);
begin
  inherited Create(aowner);
  Selected := False;
  dify := 0;
  ModPos := 0;
  TmpList := nTmpList;
  hAuteur := Height;
  TotH := DParent.Height;
  StartPosY := Top;
  AJust_H;
end;

procedure TDxScrollBarBar.AJust_H;
var
  tmph                      : Single;
begin
//  tmph := TmpList.count * Font.Height;
//  if ((tmph > TotH) and (hAuteur <> 0) and (tmph <> 0) and (TotH <> 0)) then begin
//    Height := Trunc(hAuteur / (tmph / TotH));
//  end else
//    Height := hAuteur;
//  if (Height < Width) then
//    Height := Width;
end;

function TDxScrollBarBar.GetPos: Integer;
begin
  Result := ModPos;
end;

procedure TDxScrollBarBar.DirectPaint(dsurface: TDXTexture);
begin
  AJust_H;
//  with dsurface.Canvas do begin
//    Brush.Style := bsSolid;
//    if Selected then
//      Brush.Color := clGray
//    else
//      Brush.Color := clLtGray;
//    Rectangle(SurfaceX(Left), SurfaceY(StartPosY), SurfaceX(Left + Width), SurfaceY(StartPosY + hAuteur));
//    if Selected then
//      Brush.Color := clLtGray
//    else
//      Brush.Color := clGray;
//    RoundRect(SurfaceX(Left + 1), SurfaceY(Top + 1), SurfaceX(Left + Width - 1), SurfaceY(Top + Height - 1), Width div 2, Width div 2);
//    Release;
//  end;
  //inherited DirectPaint(dsurface);
end;

function TDxScrollBarBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseDown(Button, Shift, X, Y);
  if ret then begin
    Selected := True;
    dify := Top - SurfaceY(Y);
    ret := True;
  end;
  Result := ret;
end;

function TDxScrollBarBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if (Selected) then begin
    MoveBar(SurfaceY(Y) + dify);
    Selected := False;
    ret := True;
  end;
  Result := ret;
end;

function TDxScrollBarBar.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseMove(Shift, X, Y);
  if ret then begin                     //InRange
    if Selected then begin
      MoveBar(SurfaceY(Y) + dify);
      ret := True;
    end;
  end;
  Result := ret;
end;

procedure TDxScrollBarBar.MoveBar(nposy: Integer);
var
  tmph                      : Integer;
begin
//  Top := nposy;
//  if Top < StartPosY then
//    Top := StartPosY;
//  if Top > hAuteur - Height + StartPosY then
//    Top := hAuteur - Height + StartPosY;
//  if ((hAuteur - Height) = 0) then
//    ModPos := 0
//  else begin
//    tmph := TmpList.count * Font.Height;
//    ModPos := (Top - StartPosY) * (TotH - tmph) div (hAuteur - Height);
//  end;
end;

procedure TDxScrollBarBar.MoveModPos(nMove: Integer);
begin
//  ModPos := (ModPos + nMove) div Font.Height * Font.Height;
//  if ((TotH - (TmpList.count * Font.Height)) = 0) then
//    Top := 0
//  else
//    Top := StartPosY + ModPos * (hAuteur - Height) div (TotH - (TmpList.count * Font.Height));
//  if Top < StartPosY then
//    MoveBar(StartPosY);
//  if Top > hAuteur - Height + StartPosY then
//    MoveBar(hAuteur - Height + StartPosY);
end;

{------------------------- TDxScrollBarUp --------------------------}

function TDxScrollBarUp.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseDown(Button, Shift, X, Y);
  if ret {and (check_click_in(X, Y)))} then begin
    Selected := True;
    ret := True;
  end;
  Result := ret;
end;

function TDxScrollBarUp.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if Selected then begin
    Selected := False;
    //if ((not ret) and (check_click_in(X, Y))) then
    //  ret := True;
  end;
  Result := ret;
end;

procedure TDxScrollBarUp.DirectPaint(dsurface: TDXTexture);
const
  DECAL                     = 3;
begin
//  with dsurface.Canvas do begin
//    Brush.Style := bsSolid;
//    if Selected then
//      Brush.Color := clGray
//    else
//      Brush.Color := clLtGray;
//    Rectangle(Left, Top + 1, Left + Width, Top + Width + 1);
//    if Selected then
//      Brush.Color := clLtGray
//    else
//      Brush.Color := clGray;
//    Polygon([Point(Left + DECAL, Top + 1 + Width - DECAL),
//      Point(Left + Width - 10, Top + 1 + DECAL),
//        Point(Left + Width - DECAL, Top + 1 + Width - DECAL)]);
//    Release;
//  end;
  //inherited DirectPaint(dsurface);
end;

{------------------------- TDxScrollBarDown --------------------------}

procedure TDxScrollBarDown.DirectPaint(dsurface: TDXTexture);
const
  DECAL                     = 3;
begin
//  with dsurface.Canvas do begin
//    Brush.Style := bsSolid;
//    if (Selected) then
//      Brush.Color := clGray
//    else
//      Brush.Color := clLtGray;
//    Rectangle(Left, Top + 1, Left + Width, Top + Width + 1);
//    if (Selected) then
//      Brush.Color := clLtGray
//    else
//      Brush.Color := clGray;
//    Polygon([Point(Left + DECAL, Top + 1 + DECAL),
//      Point(Left + Width - 10, Top + 1 + Width - DECAL),
//        Point(Left + Width - DECAL, Top + 1 + DECAL)]);
//    Release;
//  end;
  //inherited show(x1,y1,x2,y2,dxdraw);
end;

{------------------------- TDxScrollBar --------------------------}

constructor TDxScrollBar.Create(aowner: TComponent; nTmpList: TStrings);
begin
  inherited Create(aowner);
  Bar := TDxScrollBarBar.Create(aowner, nTmpList);
  BUp := TDxScrollBarUp.Create(aowner);
  BDown := TDxScrollBarDown.Create(aowner);
  TotH := DParent.Height - 2;
  AddChild(Bar);
  AddChild(BUp);
  AddChild(BDown);
end;

function TDxScrollBar.GetPos: Integer;  //retourne la position du debut
begin
  Result := Bar.GetPos;
end;

function TDxScrollBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
begin
//  ret := BUp.MouseUp(Button, Shift, X - Left, Y - Top);
//  if ret then
//    MoveModPos(Font.Height);
//  if not ret then begin
//    ret := BDown.MouseUp(Button, Shift, X - Left, Y - Top);
//    if ret then
//      MoveModPos(-Font.Height);
//  end;
//  if not ret then
//    ret := Bar.MouseUp(Button, Shift, X - Left, Y - Top);
//  //ret := inherited MouseUp(Button, Shift, X, Y);
//  if ret then begin
//    if Y > Bar.Top then
//      MoveModPos(-TotH)
//    else
//      MoveModPos(TotH);
//    ret := True;
//  end;
//  Result := ret;
end;

procedure TDxScrollBar.MoveModPos(nMove: Integer);
begin
  Bar.MoveModPos(nMove);
end;
{-------------------------TDxHint--------------------------}

constructor TDxHint.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FSelected := -1;
  FItems := TStringList.Create;
  FBackColor := clWhite;
  FSelectionColor := clSilver;
  FOnChangeSelect := nil;
  FOnMouseMoveSelect := nil;
  FParentControl := nil;
end;

destructor TDxHint.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TDxHint.GetItemSelected: Integer;
begin
  if (FSelected > FItems.count - 1) or (FSelected < 0) then
    Result := -1
  else
    Result := FSelected;
end;

procedure TDxHint.SetItemSelected(Value: Integer);
begin
  if (Value > FItems.count - 1) or (Value < 0) then
    FSelected := -1
  else
    FSelected := Value;
end;

procedure TDxHint.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then begin
    FBackColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDxHint.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then begin
    FSelectionColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

function TDxHint.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
end;

function TDxHint.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  TmpSel                    : Integer;
begin
  FSelected := -1;
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FEnabled and not Background then begin

    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y - LineSpace2 + 2) div (-Font.Height + LineSpace2);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if Assigned(FOnMouseMoveSelect) then
      FOnMouseMoveSelect(self, Shift, X, Y);
  end;
end;

function TDxHint.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  c                         : Char;
  ret                       : Boolean;
  TmpSel                    : Integer;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then begin
    TmpSel := FSelected;

    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y - LineSpace2 + 2) div (-Font.Height + LineSpace2);

    if FSelected > FItems.count - 1 then
      FSelected := -1;

    if (FSelected > -1) and (FSelected < FItems.count) and
      (FParentControl <> nil) and (FParentControl is TDxCustomEdit) then begin
      if (FItems.Objects[FSelected] <> nil) then begin
        Result := True;
        Exit;
      end;
      if tag = 0 then begin
        c := #0;
        case FSelected of
          0: c := #24;                  //剪切
          1: c := #3;                   //复制
          2: c := #22;                  //粘贴
          3: c := #8;                   //删除
          4: begin                      //全选
              TDxCustomEdit(FParentControl).SelStart := 0;
              TDxCustomEdit(FParentControl).SelEnd := Length(TDxCustomEdit(FParentControl).Caption);
              TDxCustomEdit(FParentControl).ChangeCurPos(TDxCustomEdit(FParentControl).SelEnd, True);
            end;
        end;
        if (c <> #0) then begin
          TDxCustomEdit(FParentControl).KeyPressEx(c);
        end;
      end else if tag = 1 then begin

      end;
    end;

    if Assigned(FOnChangeSelect) then
      FOnChangeSelect(self, Button, Shift, X, Y);

    Visible := False;
    ret := True;
  end;
  Result := ret;
end;

function TDxHint.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited KeyDown(Key, Shift);
  if ret then begin
    case Key of
      VK_PRIOR: begin
          ItemSelected := ItemSelected - Height div -Font.Height;
          if (ItemSelected = -1) then ItemSelected := 0;
        end;
      VK_NEXT: begin
          ItemSelected := ItemSelected + Height div -Font.Height;
          if ItemSelected = -1 then ItemSelected := FItems.count - 1;
        end;
      VK_UP: if ItemSelected - 1 > -1 then
          ItemSelected := ItemSelected - 1;
      VK_DOWN: if ItemSelected + 1 < FItems.count then
          ItemSelected := ItemSelected + 1;
    end;
  end;
  Result := ret;
end;

procedure TDxHint.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

//游戏命令输出  Development修改 2018-12-31
procedure TDxHint.DirectPaint(dsurface: TDXTexture);
var
  fy, nY, L, T, i, oSize: Integer;
  OldColor, BrushColor, FontColor: TColor;
  FontStyle: TFontStyles;
  HintSurface_B: TDirectDrawSurface;
    r: TRect;
  sX, sY: Integer;
   d: TDirectDrawSurface;
begin

  if Assigned(FOnDirectPaint) then
  begin
    FOnDirectPaint(self, dsurface);
    Exit;
  end;

  L := SurfaceX(Left);
  T := SurfaceY(Top);
  HintSurface_B := TDirectDrawSurface.Create(g_DXCanvas);
  HintSurface_B.Size := Point(800 - 100, 600 - 5);
  HintSurface_B.Format := D3DFMT_A4R4G4B4;
  HintSurface_B.Active := True;

  if tag = 0 then
  begin
    try
      OldColor := MainForm.Canvas.Font.Color;
      oSize := MainForm.Canvas.Font.Size;
      FontStyle := MainForm.Canvas.Font.Style;
      MainForm.Canvas.Font.Style := self.Font.Style;
      MainForm.Canvas.Font.Color := clBlack;
      MainForm.Canvas.Font.Size := self.Font.Size;
      MainForm.Canvas.Brush.Style := bsSolid;



      BrushColor := clWebOliveDrab; //框架背景颜色设置 Development 2018-12-31
      g_DXCanvas.FillRectAlpha(Rect(L, T + 1, L + Width, T + Height - 1), clWebOlive, 150);




      MainForm.Canvas.Brush.Style := bsClear;
      if (FSelected > -1) and (FSelected < FItems.count) then
      begin
        if (FItems.Objects[FSelected] = nil) then
        begin

          nY := T + (-MainForm.Canvas.Font.Height + LineSpace2) * FSelected;
          fy := nY + (-MainForm.Canvas.Font.Height + LineSpace2);
          if (nY < T + Height - 1) and (fy > T + 1) then
          begin
            if (fy > T + Height - 1) then
              fy := T + Height - 1;
            if (nY < T + 1) then
              nY := T + 1;
            g_DXCanvas.FillRectAlpha(Rect(L + 2, nY + 2, L + Width - 2, fy + 5), clBlue, 255);
          end;
        end;
      end;

      MainForm.Canvas.Brush.Style := bsClear;
      for i := 0 to FItems.count - 1 do
      begin
        if (FSelected = i) and (FItems.Objects[i] = nil) then
        begin
          FontColor := clWhite
        end
        else if (FItems.Objects[i] <> nil) then
          FontColor := clSilver
        else
        begin
          FontColor := clWebLime; //打开EDIT复制粘贴时显示的文字颜色 Development 2019-01-09
        end;
        g_DXCanvas.TextOut(L + LineSpace2, LineSpace2 + T + (-MainForm.Canvas.Font.Height + LineSpace2) * i, FontColor, FItems.Strings[i]);
      end;
      MainForm.Canvas.Font.Style := FontStyle;
      MainForm.Canvas.Font.Color := OldColor;
      MainForm.Canvas.Font.Size := oSize;
    finally

    end;
    Exit;
  end;

  try
    OldColor := MainForm.Canvas.Font.Color;
    oSize := MainForm.Canvas.Font.Size;
    FontStyle := MainForm.Canvas.Font.Style;
    MainForm.Canvas.Font.Style := self.Font.Style;
    MainForm.Canvas.Font.Color := clWhite;
    MainForm.Canvas.Font.Size := self.Font.Size;

    BrushColor := clWebOliveDrab; //框架背景颜色设置 Development 2018-12-31
    g_DXCanvas.FillRectAlpha(Rect(L, T + 1, L + Width, T + Height - 1), clWebOlive, 150);

    BrushColor := clWebBlue; //鼠标指针选择时的背景颜色设置 Development 2018-12-31
    if (FSelected > -1) and (FSelected < FItems.count) then
    begin
      if (FItems.Objects[FSelected] = nil) then
      begin

        nY := T + (-MainForm.Canvas.Font.Height + LineSpace2) * FSelected;
        fy := nY + (-MainForm.Canvas.Font.Height + LineSpace2);
        if (nY < T + Height - 1) and (fy > T + 1) then
        begin
          if (fy > T + Height - 1) then
            fy := T + Height - 1;
          if (nY < T + 1) then
            nY := T + 1;
          g_DXCanvas.FillRectAlpha(Rect(L, nY + 2, L + Width, fy + 5), BrushColor, 255);
        end;
      end;
    end;

    MainForm.Canvas.Brush.Style := bsClear;
    for i := 0 to FItems.count - 1 do begin
      if (FSelected = i) and (FItems.Objects[i] = nil) then begin
        FontColor := clWhite
      end else if (FItems.Objects[i] <> nil) then
        FontColor := clSilver
      else begin
        FontColor := clWhite;
      end;
      g_DXCanvas.TextOut(L + LineSpace2, LineSpace2 + T + (-MainForm.Canvas.Font.Height + LineSpace2) *
      i,FontColor, FItems.Strings[i]);
    end;
    MainForm.Canvas.Font.Style := FontStyle;
    MainForm.Canvas.Font.Color := OldColor;
    MainForm.Canvas.Font.Size := oSize;
  finally

  end;
end;

{------------------------- TDGrid --------------------------}

constructor TDGrid.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FColCount := 8;
  FRowCount := 5;
  FColWidth := 36;
  FRowHeight := 32;
  FOnGridSelect := nil;
  FOnGridMouseMove := nil;
  FOnGridPaint := nil;
  tButton := mbLeft;
end;

function TDGrid.GetColRow(X, Y: Integer; var ACol, ARow: Integer): Boolean;
begin
  Result := False;
  //DScreen.AddChatBoardString('TDGrid.GetColRow ...', clWhite, clRed);
  if InRange(X, Y, [ssDouble]) then begin
    ACol := (X - Left) div FColWidth;
    ARow := (Y - Top) div FRowHeight;
    Result := True;
  end;
end;

function TDGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow                : Integer;
begin
  Result := False;
  //DScreen.AddChatBoardString('TDGrid.MouseDown ...', clWhite, clRed);
  //if mbLeft = Button then begin
  if Button in [mbLeft, mbRight] then begin
    if GetColRow(X, Y, ACol, ARow) then begin
      SelectCell.X := ACol;
      SelectCell.Y := ARow;
      DownPos.X := X;
      DownPos.Y := Y;
      //if mbLeft = Button then SetDCapture (self);
      SetDCapture(self);
      Result := True;
    end;
  end;
end;

function TDGrid.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow                : Integer;
begin
  Result := False;
  //DScreen.AddChatBoardString('TDGrid.MouseMove ...', clWhite, clRed);
  if InRange(X, Y, Shift) then begin
    if GetColRow(X, Y, ACol, ARow) then begin
      if Assigned(FOnGridMouseMove) then
        FOnGridMouseMove(self, ACol, ARow, Shift);
    end;
    Result := True;
  end;
end;

function TDGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ACol, ARow                : Integer;
begin
  Result := False;

  //DScreen.AddChatBoardString('TDGrid.MouseUp ...', clWhite, clRed);

  if Button in [mbLeft, mbRight] then begin
    if GetColRow(X, Y, ACol, ARow) then begin
      if (SelectCell.X = ACol) and (SelectCell.Y = ARow) then begin
        Col := ACol;
        Row := ARow;
        if Assigned(FOnGridSelect) then begin
          self.tButton := Button;
          FOnGridSelect(self, ACol, ARow, Shift);
        end;
      end;
      Result := True;
    end;
    ReleaseDCapture;
  end;
end;

function TDGrid.Click(X, Y: Integer): Boolean;
var
  ACol, ARow                : Integer;
begin
  Result := False;
  {if GetColRow(X, Y, ACol, ARow) then begin
    if Assigned(FOnGridSelect) then
      FOnGridSelect(Self, ACol, ARow, []);
    Result := True;
  end;}
end;

procedure TDGrid.DirectPaint(dsurface: TDXTexture);
var
  i, j                      : Integer;
  rc                        : TRect;
begin
  if Assigned(FOnGridPaint) then
    for i := 0 to FRowCount - 1 do
      for j := 0 to FColCount - 1 do begin
        rc := Rect(Left + j * FColWidth, Top + i * FRowHeight, Left + j * (FColWidth + 1) - 1, Top + i * (FRowHeight + 1) - 1);
        if (SelectCell.Y = i) and (SelectCell.X = j) then
          FOnGridPaint(self, j, i, rc, [gdSelected], dsurface)
        else
          FOnGridPaint(self, j, i, rc, [], dsurface);
      end;
end;

{--------------------- TDWindown --------------------------}

constructor TDWindow.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FFloating := False;
  FMoveRange := False;
  FEnableFocus := True;
  Width := 120;
  Height := 120;
end;

procedure TDWindow.SetVisible(flag: Boolean);
begin
  FVisible := flag;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
end;

function TDWindow.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at                    : Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  //if not FloatingEx then exit;
  if Result and FFloating and (MouseCaptureControl = self) then begin
    if (SpotX <> X) or (SpotY <> Y) then begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      if FMoveRange then begin
//        if al + Width < WINLEFT then al := WINLEFT - Width;
//        if al > WINRIGHT then al := WINRIGHT;
//        if at + Height < WINTOP then at := WINTOP - Height;
//        if at + Height > BOTTOMEDGE then at := BOTTOMEDGE - Height;

        {if al < 0 then al := 0;
        if al + Width > SCREENWIDTH then al := SCREENWIDTH - Width;
        if at < 0 then at := 0;
        if at + Height > SCREENHEIGHT then at := SCREENHEIGHT - Height;}
      end;
      Left := al;
      Top := at;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

function TDWindow.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if Floating then begin
      if DParent <> nil then
        DParent.ChangeChildOrder(self);
    end;
    SpotX := X;
    SpotY := Y;
  end;
end;

function TDWindow.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;

procedure TDWindow.Show;
begin
  Visible := True;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
  if EnableFocus then SetDFocus(self);
end;

function TDWindow.ShowModal: Integer;
begin
  Result := 0;                          //Jacky
  Visible := True;
  ModalDWindow := self;
  if EnableFocus then SetDFocus(self);
end;

{--------------------- TDWinManager --------------------------}

constructor TDWinManager.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  DWinList := TList.Create;
  //FIsManager := True;
  MouseCaptureControl := nil;
  FocusedControl := nil;
end;

destructor TDWinManager.Destroy;
begin
  inherited Destroy;
end;

procedure TDWinManager.ClearAll;
begin
  DWinList.Clear;
end;

//procedure TDWinManager.Process;
//var
//  I: Integer;
//begin
//  for I := 0 to DWinList.Count - 1 do begin
//    if TDControl(DWinList[I]).Visible then begin
//      TDControl(DWinList[I]).Process;
//    end;
//  end;
//  if ModalDWindow <> nil then begin
//    if ModalDWindow.Visible then
//      with ModalDWindow do
//        Process;
//  end;
////  if ActiveMenu <> nil then begin
////    if ActiveMenu.Visible then
////      with ActiveMenu do begin
////        Process;
////      end;
////  end;
//end;

procedure TDWinManager.AddDControl(dcon: TDControl; Visible: Boolean);
begin
  dcon.Visible := Visible;
  DWinList.Add(dcon);
end;

procedure TDWinManager.DelDControl(dcon: TDControl);
var
  i                         : Integer;
begin
  for i := 0 to DWinList.count - 1 do
    if DWinList[i] = dcon then begin
      DWinList.Delete(i);
      Break;
    end;
end;

function TDWinManager.KeyPress(var Key: Char): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := KeyPress(Key);
      Exit;
    end else
      ModalDWindow := nil;
    Key := #0;
  end;

  if FocusedControl <> nil then begin
    if FocusedControl.Visible then begin
      Result := FocusedControl.KeyPress(Key);
    end else
      ReleaseDFocus;
  end;
end;

function TDWinManager.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := KeyDown(Key, Shift);
      Exit;
    end else
      ModalDWindow := nil;
  end;
  if FocusedControl <> nil then begin
    if FocusedControl.Visible then
      Result := FocusedControl.KeyDown(Key, Shift)
    else
      ReleaseDFocus;
  end;
end;

function TDWinManager.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseMove(Shift, LocalX(X), LocalY(Y));
      Result := True;
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseMove(Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseMove(Shift, X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      Result := True;
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseDown(Button, Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseDown(Button, Shift, X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseUp(Button, Shift, X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

function TDWinManager.DblClick(X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := DblClick(LocalX(X), LocalY(Y));
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := DblClick(LocalX(X), LocalY(Y));
  end else begin
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).DblClick(X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TDWinManager.Click(X, Y: Integer): Boolean;
var
  i                         : Integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := Click(LocalX(X), LocalY(Y));
      Exit;
    end else ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := Click(LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).Click(X, Y) then begin
          Result := True;
          Break;
        end;
      end;
    end;
end;

procedure TDWinManager.DirectPaint(dsurface: TDXTexture);
var
  i                         : Integer;
begin
  for i := 0 to DWinList.count - 1 do
  begin
    if TDControl(DWinList[i]).Visible then
    begin
      try
        TDControl(DWinList[i]).DirectPaint (dsurface);
      except
        //修复在异常导致部分界面不显示
      end;
    end;
  end;
  try
    if ModalDWindow <> nil then begin
      if ModalDWindow.Visible then
        with ModalDWindow do
          DirectPaint(dsurface);
    end;
  except
    //修复在异常导致部分界面不显示
  end;
end;

{--------------------- TDmoveButton --------------------------}

constructor TDMoveButton.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FFloating := True;
  FEnableFocus := False;
  Width := 30;
  Height := 30;
  LeftToRight := True;
  //bMouseMove := True;
end;

procedure TDMoveButton.SetVisible(flag: Boolean);
begin
  FVisible := flag;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
end;

function TDMoveButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  n, al, at, ot             : Integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Max <= 0 then Exit;
  if ssLeft in Shift then begin
    if Result and FFloating and (MouseCaptureControl = self) then begin
      n := Position;
      try
        if Max <= 0 then Exit;
        if (SpotX <> X) or (SpotY <> Y) then begin
          if LeftToRight then begin
            if not Reverse then begin
              ot := SlotLen - Width;
              al := RTop;               //RLeft;
              at := Left + (X - SpotX);
              if at < RLeft then at := RLeft;
              if at + Width > RLeft + SlotLen then at := RLeft + SlotLen - Width;
              Position := Round((at - RLeft) / (ot / Max));
              if Position < 0 then Position := 0;
              if Position > Max then Position := Max;
              Left := at;
              Top := al;
              SpotX := X;
              SpotY := Y;
            end else begin
              al := RTop;               //RLeft;
              at := Left + (X - SpotX);
              if at < RLeft - SlotLen then at := RLeft - SlotLen;
              if at > RLeft then at := RLeft;
              Position := Round((at - RLeft) / (SlotLen / Max));
              if Position < 0 then Position := 0;
              if Position > Max then Position := Max;
              Left := at;
              Top := al;
              SpotX := X;
              SpotY := Y;
            end;
          end else begin
            if not Reverse then begin
              ot := SlotLen - Height;
              al := RLeft;
              at := Top + (Y - SpotY);
              if at < RTop then at := RTop;
              if at + Height > RTop + SlotLen then at := RTop + SlotLen - Height;
              Position := Round((at - RTop) / (ot / Max));
              if Position < 0 then Position := 0;
              if Position > Max then Position := Max;
              Left := al;
              Top := at;
              SpotX := X;
              SpotY := Y;
            end else begin
              al := RLeft;
              at := Top + (Y - SpotY);
              if at < RTop - SlotLen then at := RTop - SlotLen;
              if at > RTop then at := RTop;
              Position := Round((at - RTop) / (SlotLen / Max));
              if Position < 0 then Position := 0;
              if Position > Max then Position := Max;
              Left := al;
              Top := at;
              SpotX := X;
              SpotY := Y;
            end;
          end;

        end;
      finally
        if (n <> Position) and Assigned(FOnMouseMove) then
          FOnMouseMove(self, Shift, X, Y);
      end;
    end;
  end;
end;

procedure TDMoveButton.UpdatePos(pos: Integer; force: Boolean);
begin
  if Max <= 0 then Exit;
  //if not force and (Position = pos) then Exit;
  //if (pos < 0) or (pos > Max) then Exit;
  Position := pos;
  if Position < 0 then Position := 0;
  if Position > Max then Position := Max;
  if LeftToRight then begin
    Left := RLeft + Round((SlotLen - Width) / Max * Position);
    if Left < RLeft then Left := RLeft;
    if Left > RLeft + SlotLen - Width then Left := RLeft + SlotLen - Width;
  end else begin
    Top := RTop + Round((SlotLen - Height) / Max * Position);
    if Top < RTop then Top := RTop;
    if Top > RTop + SlotLen - Height then Top := RTop + SlotLen - Height;
  end;
end;

function TDMoveButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if Floating then begin
      if DParent <> nil then
        DParent.ChangeChildOrder(self);
    end;
    SpotX := X;
    SpotY := Y;
  end;
end;

function TDMoveButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;

procedure TDMoveButton.Show;
begin
  Visible := True;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
  if EnableFocus then SetDFocus(self);
end;

function TDMoveButton.ShowModal: Integer;
begin
  Result := 0;
  Visible := True;
  ModalDWindow := self;
  if EnableFocus then SetDFocus(self);
end;



{==========================TDPopupMenu创建过程================================}

{ TDMenuItem }

constructor TDMenuItem.Create();
begin
  inherited;
  FVisible := True;
  FEnabled := True;
  FChecked := False;
  FCaption := '';
  FMenu := nil;
end;

destructor TDMenuItem.Destroy;
begin
  //if FMenu <> nil then FMenu.Free;
  inherited;
end;
{ TDPopupMenu }

constructor TDPopupMenu.Create(AOwner: TComponent);
begin
  inherited Create(aowner);
  FItems := TStringList.Create();
  FColors := TColors.Create;
  FActiveMenu := nil;
  FOwnerMenu := nil;
  FOwnerItemIndex := 0;
  FMoveItemIndex := -1;
  FItemIndex := -1;
  Width := 150;
  Height := 100;
  FStyle := sXP;
  Add('Item1', nil);
  Add('Item2', nil);
  Add('Item3', nil);
  Add('Item4', nil);
end;

destructor TDPopupMenu.Destroy;
begin
  while Count > 0 do begin
    Items[0].Free;
    Delete(0);
  end;
  FItems.Free;
  FColors.Free;
  inherited Destroy;
end;

procedure TDPopupMenu.Paint;
var
  I: Integer;
begin
  if csDesigning in ComponentState then begin
    with Canvas do begin
      Brush.Color := clMenu;
      FillRect(ClipRect);
      Pen.Color := clInactiveBorder;

      for I := 0 to Count - 1 do begin
        MoveTo(5, Height div Count * I);
        LineTo(Width - 5, Height div Count * I);
        TextOut((Width - TextWidth(FItems[I])) div 2, Height div Count * I + (Height div Count - TextHeight(FItems[I])) div 2, FItems[I]);
      end;

      MoveTo(0, 0);
      LineTo(Width - 1, 0);
      LineTo(Width - 1, Height - 1);
      LineTo(0, Height - 1);
      LineTo(0, 0);
    end;
  end;
end;

procedure TDPopupMenu.CreateWnd;
begin
  inherited;
  if FItems = nil then FItems := TStringList.Create();
end;

procedure TDPopupMenu.SetOwnerMenu(Value: TDPopupMenu);
var
  Index: Integer;
begin
  if FOwnerMenu <> Value then begin
    if (FOwnerMenu <> nil) then begin
      Index := FOwnerMenu.IndexOf(Self);
      if Index >= 0 then begin
        FOwnerMenu.Menus[Index] := nil;
      end;
    end;
    FOwnerMenu := Value;
  end;
end;

procedure TDPopupMenu.SetOwnerItemIndex(Value: TImageIndex);
var
  Index: Integer;
begin
  if FOwnerMenu <> nil then begin
    if (FOwnerItemIndex >= 0) and (FOwnerItemIndex < FOwnerMenu.Count) then FOwnerMenu.Menus[FOwnerItemIndex] := nil;
    if (Value >= 0) and (Value < FOwnerMenu.Count) then begin
      for Index := Value to FOwnerMenu.Count - 1 do begin
        if FOwnerMenu.Menus[Index] = nil then begin
          FOwnerMenu.Menus[Index] := Self;
          FOwnerItemIndex := Index;
          Break;
        end;
      end;
    end else FOwnerItemIndex := -1;
  end else FOwnerItemIndex := -1;
end;

function TDPopupMenu.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TDPopupMenu.GetItems: TStrings;
begin
  if csDesigning in ComponentState then Refresh;
  Result := FItems;
end;

procedure TDPopupMenu.SetColors(Value: TColors);
begin
  FColors.Assign(Value);
end;

procedure TDPopupMenu.SetItems(Value: TStrings);
var
  I: Integer;
begin
  Clear;
  FItems.Assign(Value);
  for I := 0 to FItems.Count - 1 do begin
    FItems.Objects[I] := nil;
    FItems.Objects[I] := TDMenuItem.Create;
  end;
end;

procedure TDPopupMenu.SetItemIndex(Value: Integer);
begin
  FItemIndex := Value;
  if FItemIndex >= FItems.Count then FItemIndex := -1;
  {if FItemIndex <> Value then begin

  end;}
end;

function TDPopupMenu.GetItem(Index: Integer): TDMenuItem;
begin
  if (Index >= 0) and (Index < FItems.Count) then begin
    if FItems.Objects[Index] = nil then begin
      FItems.Objects[Index] := TDMenuItem.Create;
    end;
    Result := TDMenuItem(FItems.Objects[Index]);
  end else Result := nil;
end;

function TDPopupMenu.GetMenu(Index: Integer): TDPopupMenu;
begin
  if (Index >= 0) and (Index < FItems.Count) then begin
    if FItems.Objects[Index] = nil then begin
      FItems.Objects[Index] := TDMenuItem.Create;
    end;
    Result := TDPopupMenu(TDMenuItem(FItems.Objects[Index]).Menu);
  end else Result := nil;
end;

procedure TDPopupMenu.SetMenu(Index: Integer; Value: TDPopupMenu);
begin
  if FItems.Objects[Index] = nil then begin
    FItems.Objects[Index] := TDMenuItem.Create;
  end;
  TDMenuItem(FItems.Objects[Index]).Menu := Value;
end;

procedure TDPopupMenu.Insert(Index: Integer; ACaption: string; Item: TDPopupMenu);
var
  MenuItem: TDMenuItem;
begin
  MenuItem := TDMenuItem.Create();
  MenuItem.Menu := Item;
  FItems.InsertObject(Index, ACaption, MenuItem);
  //if csDesigning in ComponentState then Refresh;
end;

function TDPopupMenu.IndexOf(Item: TDPopupMenu): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do begin
    if FItems.Objects[I] = nil then begin
      FItems.Objects[I] := TDMenuItem.Create();
    end;
    if TDMenuItem(FItems.Objects[I]).Menu = Item then begin
      Result := I;
      Exit;
    end;
  end;
end;

procedure TDPopupMenu.Add(ACaption: string; Item: TDPopupMenu);
begin
  Insert(GetCount, ACaption, Item);
end;

procedure TDPopupMenu.Remove(Item: TDPopupMenu);
var
  I: Integer;
begin
  I := IndexOf(Item); if I >= 0 then Delete(I);
end;

procedure TDPopupMenu.Delete(Index: Integer);
begin
  FItems.Delete(Index);
end;

procedure TDPopupMenu.Clear;
begin
  FItemIndex := -1;
  while Count > 0 do begin
    Items[0].Free;
    Delete(0);
  end;
end;

function TDPopupMenu.Find(ACaption: string): TDPopupMenu;
var
  I: Integer;
begin
  Result := nil;
//  ACaption := StripHotkey(ACaption);
//  for I := 0 to Count - 1 do
//    if AnsiSameText(ACaption, StripHotkey(Items[I].Caption)) then
//    begin
//      Result := Menus[I];
//      System.Break;
//    end;
end;

procedure TDPopupMenu.Show;
begin
  FMoveItemIndex := -1;
  Visible := True;
  {if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(Self);
  end;
  if EnableFocus then SetDFocus(Self); }
  ActiveMenu := Self;
end;

procedure TDPopupMenu.Show(d: TDControl);
begin
  //if Count = 0 then Exit;
  FMoveItemIndex := -1;
  Visible := True;
  DControl := d;
 { if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(Self);
  end;  }
  //if EnableFocus then SetDFocus(Self);
  ActiveMenu := Self;
end;

procedure TDPopupMenu.Hide;
var
  I: Integer;
begin
  //inherited;
  Visible := False;

  if ActiveMenu = Self then ActiveMenu := nil;
  if OwnerMenu <> nil then ActiveMenu := OwnerMenu;
  for I := 0 to Count - 1 do begin
    if (Menus[I] <> nil) { and (not Items[I].Visible)} then begin
      Menus[I].Hide;
    end;
  end;
end;

function TDPopupMenu.InRange(X, Y: Integer; Shift: TShiftState): Boolean;
var
  boInrange: Boolean;
begin
  if (X >= Left) and (X < Left + Width) and (Y >= Top) and (Y < Top + Height) then begin
    boInrange := True;
    if Assigned(OnInRealArea) then
      OnInRealArea(Self, X - Left, Y - Top, boInrange);
    Result := boInrange;
  end else
    Result := False;
end;

//procedure TDPopupMenu.Process;
//var
//  I, n1C, n2C: Integer;
//  OldSize: Integer;
//begin
//  //if Assigned(OnProcess) then OnProcess(Self);
//  if not Assigned(MainForm) then Exit;
//  OldSize := MainForm.Canvas.Font.Size;
//
//  MainForm.Canvas.Font.Size := 9;
//
//  FItemSize := Round(MainForm.Canvas.TextHeight('0') * 1.5);
//
//  n1C := 0;
//
//  if FStyle = sVista then begin
//    for I := 0 to FItems.Count - 1 do begin
//      if n1C < MainForm.Canvas.TextWidth(FItems.Strings[I]) then
//        n1C := MainForm.Canvas.TextWidth(FItems.Strings[I]);
//    end;
//
//    n1C := n1C + MainForm.Canvas.TextHeight('0') * 4;
//    if n1C <> Width then Width := n1C;
//  end;
//
//  if FStyle = sVista then begin
//    n2C := FItemSize * FItems.Count + MainForm.Canvas.TextHeight('0') * 2;
//    if n2C <> Height then Height := n2C;
//  end else begin
//    n2C := FItemSize * FItems.Count + MainForm.Canvas.TextHeight('0') div 2;
//    if n2C <> Height then Height := n2C;
//  end;
//
//  MainForm.Canvas.Font.Size := OldSize;
//
//  for I := 0 to DControls.Count - 1 do
//    if TDControl(DControls[I]).Visible then
//      TDControl(DControls[I]).Process;
//end;

procedure TDPopupMenu.DirectPaint(dsurface: TDXTexture);
var
  d: TDXTexture;
  I, nIndex: Integer;
  rc: TRect;
  nX, nY: Integer;
  OldSize: Integer;
  CColor: TColor;
begin
  if Assigned(OnDirectPaint) then
    OnDirectPaint(Self, dsurface)
  else
    if WLib <> nil then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;

  OldSize := MainForm.Canvas.Font.Size;
  MainForm.Canvas.Font.Size := 9;

{------------------------------------------------------------------------------}
  g_DXCanvas.FillRect(ClientRect, FColors.Background);
  g_DXCanvas.FrameRect(ClientRect, FColors.Border);
{------------------------------------------------------------------------------}
  if FItems.Count > 0 then begin
{------------------------------------------------------------------------------}
    nIndex := 0;
    nX := 3;
    nY := 3;
{------------------------------------------------------------------------------}
    for I := 0 to FItems.Count - 1 do begin
      if FMoveItemIndex = I then begin
        if Items[I].Enabled then CColor := FColors.Selected
        else CColor := FColors.Disabled;
      end else begin
        if Items[I].Enabled then CColor := FColors.Font
        else CColor := FColors.Disabled;
      end;
      if Items[I].Visible then begin

        rc := ClientRect;
        rc.Left := rc.Left + nX;
        rc.Top := rc.Top + nY + nIndex * FItemSize;
        rc.Right := rc.Left + Width - nX * 2;
        rc.Bottom := rc.Top + FItemSize;

        if FItems[I] = '-' then begin
          nY := (I * FItemSize) + FItemSize div 2;
          rc.Top := SurfaceY(Top) + nY;
          rc.Bottom := rc.Top + 1;
          g_DXCanvas.FrameRect(rc, FColors.Line);
        end else begin
          if FMoveItemIndex = nIndex then begin
            g_DXCanvas.FillRect(rc, FColors.Hot);
            g_DXCanvas.TextOut(rc.Left, rc.Top + (FItemSize - MainForm.Canvas.TextHeight('Pp')) div 2, CColor, FItems[I]);
          end else begin
            g_DXCanvas.TextOut(rc.Left, rc.Top + (FItemSize - MainForm.Canvas.TextHeight('Pp')) div 2, CColor, FItems[I]);
          end;
        end;
        Inc(nIndex);
      end;
    end;
  end;
  MainForm.Canvas.Font.Size := OldSize;

  for I := 0 to DControls.Count - 1 do
    if TDControl(DControls[I]).Visible then
      TDControl(DControls[I]).DirectPaint(dsurface);
end;

function TDPopupMenu.KeyPress(var Key: Char): Boolean;
begin

end;

function TDPopupMenu.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin

end;

function TDPopupMenu.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if (not Background) and (not Result) then begin
    Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = Self then
      if InRange(X, Y, Shift) then Downed := True
      else Downed := False;   
  end;
  FMouseMove := Result;                       
  if (FItemSize <> 0) and FMouseMove and (Count > 0) then begin
    FMoveItemIndex := (Y - Top - 3) div FItemSize;
    if (FMoveItemIndex >= 0) and (FMoveItemIndex < FItems.Count) then begin
      if Menus[FMoveItemIndex] <> FActiveMenu then begin
        if FActiveMenu <> nil then FActiveMenu.Hide;
        FActiveMenu := nil;
        if Items[FMoveItemIndex].Enabled then begin
          FActiveMenu := Menus[FMoveItemIndex];
          if (FActiveMenu <> nil) and (not FActiveMenu.Visible) then FActiveMenu.Show(Self);
        end;
      end;
    end else begin
      if FActiveMenu <> nil then FActiveMenu.Hide;
      FActiveMenu := nil;
      FMoveItemIndex := -1;
    end;
  end else FMoveItemIndex := -1;
end;

function TDPopupMenu.Click(X, Y: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
 { if (ActiveMenu <> nil) then begin
    if (ActiveMenu = Self) then begin

      if Assigned(FOnClick) then
        FOnClick(Self, X, Y);

      Result := True;
    end;
    Exit;
  end; }
  for I := DControls.Count - 1 downto 0 do
    if TDControl(DControls[I]).Visible then
      if TDControl(DControls[I]).Click(X - Left, Y - Top) then begin
        Result := True;
        Exit;
      end;
  if InRange(X, Y, [ssDouble]) then begin
    if Assigned(OnClick) then
      OnClick(Self, X, Y);
    Result := True;
  end;
end;

function TDPopupMenu.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    //if (not Background) and (MouseCaptureControl = nil) then begin
    //Downed := True;
      //SetDCapture(Self);
   // end;
    Result := True;
  end;
  //FMouseDown := Result;
  if (FItemSize <> 0) {and FMouseDown} and (Count > 0) then begin
    FItemIndex := (Y {- MainForm.Canvas.TextHeight('0')} - Top - 3) div FItemSize;
  end;
end;

function TDPopupMenu.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    Result := True;
    Downed := False;
    //FMouseDown := not Result;
    if InRange(X, Y, Shift) then begin
      if Button = mbLeft then begin
        FMouseMove := Result;
        if (FItemIndex >= 0) and (FItemIndex < Count) and Items[FItemIndex].Enabled then begin
          if (FActiveMenu <> nil) then begin
            if (not FActiveMenu.Visible) then FActiveMenu.Show(Self);
          end else Hide;
        end else if (Count <= 0) then Hide;
      end;
    end;
  end else begin
    ReleaseCapture;
    Downed := False;
  end;
end;

{==========================TDPopupMenu结束过程================================}


{==========================Edit过程开始========================================}
{--------------------- TDxCustomEdit --------------------------}

constructor TDxCustomEdit.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  Downed := False;
  FMiniCaret := 0;
  m_InputHint := '';
  DxHint := nil;
  FCaretColor := clWhite;
  FOnClick := nil;
  FEnableFocus := True;
  FClick := False;
  FSelClickStart := False;
  FSelClickEnd := False;
  FClickX := 0;
  FSelStart := -1;
  FSelEnd := -1;
  FStartTextX := 0;
  FSelTextStart := 0;
  FSelTextEnd := 0;
  FCurPos := 0;
  FClickSound := csNone;
  FShowCaret := True;
  FNomberOnly := False;
  FIsHotKey := False;
  FHotKey := 0;
  FTransparent := True;
  FEnabled := True;
  FSecondChineseChar := False;
  FShowCaretTick := GetTickCount;
  FFrameVisible := True;
  FFrameHot := False;
  FFrameSize := 1;
  FFrameColor := $00406F77;
  FFrameHotColor := $00599AA8;
  FAlignment := taLeftJustify;
  //FRightClick := True;
end;

procedure TDxCustomEdit.SetSelLength(Value: Integer);
begin
  SetSelStart(Value - 1);
  SetSelEnd(Value - 1);
end;

function TDxCustomEdit.ReadSelLength(): Integer;
begin
  Result := abs(FSelStart - FSelEnd);
end;

procedure TDxCustomEdit.SetSelStart(Value: Integer);
begin
  if FSelStart <> Value then
    FSelStart := Value;
end;

procedure TDxCustomEdit.SetSelEnd(Value: Integer);
begin
  if FSelEnd <> Value then
    FSelEnd := Value;
end;

procedure TDxCustomEdit.SetMaxLength(Value: Integer);
begin
  if FMaxLength <> Value then
    FMaxLength := Value;
end;

procedure TDxCustomEdit.SetPasswordChar(Value: Char);
begin
  if FPasswordChar <> Value then
    FPasswordChar := Value;
end;

procedure TDxCustomEdit.SetNomberOnly(Value: Boolean);
begin
  if FNomberOnly <> Value then
    FNomberOnly := Value;
end;

procedure TDxCustomEdit.SetIsHotKey(Value: Boolean);
begin
  if FIsHotKey <> Value then
    FIsHotKey := Value;
end;

procedure TDxCustomEdit.SetHotKey(Value: Cardinal);
begin
  if FHotKey <> Value then
    FHotKey := Value;
end;

procedure TDxCustomEdit.SetAtom(Value: Word);
begin
  if FAtom <> Value then
    FAtom := Value;
end;

procedure TDxCustomEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
    FAlignment := Value;
end;

procedure TDxCustomEdit.ShowCaret();
begin
  FShowCaret := True;
  FShowCaretTick := GetTickCount;
end;

procedure TDxCustomEdit.SetFocus();
begin
  SetDFocus(self);
end;

procedure TDxCustomEdit.ChangeCurPos(nPos: Integer; boLast: Boolean = False);
begin
  if Caption = '' then Exit;

  if boLast then begin
    FCurPos := Length(Caption);
    Exit;
  end;

  if nPos = 1 then begin                //Right ->
    case ByteType(Caption, FCurPos + 1) of
      mbSingleByte: nPos := 1;
      mbLeadByte: nPos := 2;            //汉字的第一个字节
      mbTrailByte: nPos := 2;           //汉字的第二个字节
    end;
  end else begin                        //Left <-
    case ByteType(Caption, FCurPos) of
      mbSingleByte: nPos := -1;
      mbLeadByte: nPos := -2;
      mbTrailByte: nPos := -2;
    end;
  end;

  if ((FCurPos + nPos) <= Length(Caption)) then begin
    if ((FCurPos + nPos) >= 0) then
      FCurPos := FCurPos + nPos;
  end;

  {if nPos = 1 then begin
    if ((FCurPos + 1) <= Length(Caption)) and (Caption[FCurPos + 1] > #$80) then
      nPos := 2
  end else begin
    if ((FCurPos + 0) <= Length(Caption)) and (Caption[FCurPos + 0] > #$80) then
      nPos := -2;
  end;

  if ((FCurPos + nPos) <= Length(Caption)) then begin
    if ((FCurPos + nPos) >= 0) then
      FCurPos := FCurPos + nPos;
  end;}

  if FSelClickStart then begin
    FSelClickStart := False;
    FSelStart := FCurPos;
  end;
  if FSelClickEnd then begin
    FSelClickEnd := False;
    FSelEnd := FCurPos;
  end;
end;

function TDxCustomEdit.KeyPress(var Key: Char): Boolean;
var
  s, cStr                   : string;
  i, nlen, cpLen            : Integer;
  pStart                    : Integer;
  pEnd                      : Integer;
begin
  if not FEnabled or FIsHotKey then Exit;
  if not self.Visible then Exit;
  if (self.DParent = nil) or (not self.DParent.Visible) then Exit;
  s := Caption;
  try
    if (Ord(Key) in [VK_RETURN, VK_ESCAPE]) then begin
      Result := inherited KeyPress(Key);
      Exit;
    end;
    if not FNomberOnly and IsKeyPressed(VK_CONTROL) and (Ord(Key) in [1..27]) then begin
      //MessageBox(0, PChar(IntToStr(Ord(Key))), '', mb_ok);
      if (Ord(Key) = 22) then begin     //CTRL + V
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
          if FSelStart > FSelEnd then begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Clipboard.AsText;
          if cStr <> '' then begin
            cpLen := FMaxLength - Length(Caption) + abs(FSelStart - FSelEnd);
            FSelStart := -1;
            FSelEnd := -1;
            Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
            FCurPos := pStart;

            nlen := Length(cStr);
            if nlen < cpLen then cpLen := nlen;
            Caption := Copy(Caption, 1, FCurPos) + Copy(cStr, 1, cpLen) + Copy(Caption, FCurPos + 1, Length(Caption));
            Inc(FCurPos, cpLen);

          end;
        end else begin
          cpLen := FMaxLength - Length(Caption);
          if cpLen > 0 then begin
            cStr := Clipboard.AsText;
            if cStr <> '' then begin
              nlen := Length(cStr);
              if nlen < cpLen then cpLen := nlen;
              Caption := Copy(Caption, 1, FCurPos) + Copy(cStr, 1, cpLen) + Copy(Caption, FCurPos + 1, Length(Caption));
              Inc(FCurPos, cpLen);
            end;
          end else Beep;
        end;
      end;

      if (Ord(Key) = 3) and (FPasswordChar = #0) and (Caption <> '') then begin //CTRL + C
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
          if FSelStart > FSelEnd then begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Copy(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then begin
            Clipboard.AsText := cStr;
          end;
        end;
      end;

      if (Ord(Key) = 24) and (FPasswordChar = #0) and (Caption <> '') then begin //CTRL + X
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
          if FSelStart > FSelEnd then begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Copy(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then begin
            Clipboard.AsText := cStr;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
          FCurPos := pStart;
        end;
      end;

      if (Ord(Key) = 1) and not FIsHotKey and (Caption <> '') then begin //CTRL + A
        FSelStart := 0;
        FSelEnd := Length(Caption);
        FCurPos := FSelEnd;
      end;

      Result := inherited KeyPress(Key);
      Exit;
    end;

    Result := inherited KeyPress(Key);
    if Result then begin
      ShowCaret();
      case Ord(Key) of
        VK_BACK: begin
            if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
              if FSelStart > FSelEnd then begin
                pStart := FSelEnd;
                pEnd := FSelStart;
              end;
              if FSelStart < FSelEnd then begin
                pStart := FSelStart;
                pEnd := FSelEnd;
              end;
              FSelStart := -1;
              FSelEnd := -1;
              Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
              FCurPos := pStart;
            end else begin
              if (FCurPos > 0) then begin
                nlen := 1;
                case ByteType(Caption, FCurPos) of
                  mbSingleByte: nlen := 1;
                  mbLeadByte: nlen := 2;
                  mbTrailByte: nlen := 2;
                end;
                Caption := Copy(Caption, 1, FCurPos - nlen) + Copy(Caption, FCurPos + 1, Length(Caption));
                Dec(FCurPos, nlen);

                {if (FCurPos >= 2) and (Caption[FCurPos] > #$80) and (Caption[FCurPos - 1] > #$80) then begin
                  Caption := Copy(Caption, 1, FCurPos - 2) + Copy(Caption, FCurPos + 1, Length(Caption));
                  Dec(FCurPos, 2);
                end else begin
                  Caption := Copy(Caption, 1, FCurPos - 1) + Copy(Caption, FCurPos + 1, Length(Caption));
                  Dec(FCurPos);
                end;}
              end;
            end;
          end;
      else begin
          if (FMaxLength <= 0) or (FMaxLength > MaxChar) then FMaxLength := MaxChar;
          if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
            if FSelStart > FSelEnd then begin
              pStart := FSelEnd;
              pEnd := FSelStart;
            end;
            if FSelStart < FSelEnd then begin
              pStart := FSelStart;
              pEnd := FSelEnd;
            end;
            if FNomberOnly then begin
              if (Key >= #$30) and (Key <= #$39) then begin
                FSelStart := -1;
                FSelEnd := -1;
                Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
                FCurPos := pStart;
                FSecondChineseChar := False;
                if Length(Caption) < FMaxLength then begin
                  Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                  Inc(FCurPos);
                end else Beep;
              end else
                Beep;
            end else begin
              FSelStart := -1;
              FSelEnd := -1;
              Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
              FCurPos := pStart;
              if Key > #$80 then begin
                if FSecondChineseChar then begin
                  FSecondChineseChar := False;
                  if Length(Caption) < FMaxLength then begin
                    Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                    Inc(FCurPos);
                  end else Beep;
                end else begin
                  if Length(Caption) + 1 < FMaxLength then begin
                    FSecondChineseChar := True;
                    Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                    Inc(FCurPos);
                  end else Beep;
                end;
              end else begin
                FSecondChineseChar := False;
                if Length(Caption) < FMaxLength then begin
                  Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                  Inc(FCurPos);
                end else Beep;
              end;
            end;
          end else begin
            if FNomberOnly then begin
              if (Key >= #$30) and (Key <= #$39) then begin
                FSelStart := -1;
                FSelEnd := -1;
                FSecondChineseChar := False;
                if Length(Caption) < FMaxLength then begin
                  Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                  Inc(FCurPos);
                end;
              end else
                Beep;
            end else begin
              FSelStart := -1;
              FSelEnd := -1;
              if Key > #$80 then begin
                if FSecondChineseChar then begin
                  FSecondChineseChar := False;
                  if Length(Caption) < FMaxLength then begin
                    Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                    Inc(FCurPos);
                    FSelStart := FCurPos;
                  end else Beep;
                end else begin
                  if Length(Caption) + 1 < FMaxLength then begin
                    FSecondChineseChar := True;
                    Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                    Inc(FCurPos);
                    FSelStart := FCurPos;
                  end else Beep;
                end;
              end else begin
                FSecondChineseChar := False;
                if Length(Caption) < FMaxLength then begin
                  Caption := Copy(Caption, 1, FCurPos) + Key + Copy(Caption, FCurPos + 1, Length(Caption));
                  Inc(FCurPos);
                  FSelStart := FCurPos;
                end else Beep;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    if s <> Caption then begin
      if Assigned(FOnTextChanged) then FOnTextChanged(self, Caption);
    end;
  end;
end;

function TDxCustomEdit.KeyPressEx(var Key: Char): Boolean;
var
  s, cStr                   : string;
  i, nlen, cpLen            : Integer;
  pStart                    : Integer;
  pEnd                      : Integer;
begin
  if not FEnabled or FIsHotKey then Exit;
  if not self.Visible then Exit;
  if (self.DParent = nil) or (not self.DParent.Visible) then Exit;

  s := Caption;
  try
    if not FNomberOnly and (Ord(Key) in [1..27]) then begin
      if (Ord(Key) = 22) then begin     //CTRL + V
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
          if FSelStart > FSelEnd then begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Clipboard.AsText;
          if cStr <> '' then begin
            cpLen := FMaxLength - Length(Caption) + abs(FSelStart - FSelEnd);
            FSelStart := -1;
            FSelEnd := -1;
            Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
            FCurPos := pStart;

            nlen := Length(cStr);
            if nlen < cpLen then cpLen := nlen;
            Caption := Copy(Caption, 1, FCurPos) + Copy(cStr, 1, cpLen) + Copy(Caption, FCurPos + 1, Length(Caption));
            Inc(FCurPos, cpLen);
          end;
        end else begin
          cpLen := FMaxLength - Length(Caption);
          if cpLen > 0 then begin
            cStr := Clipboard.AsText;
            if cStr <> '' then begin
              nlen := Length(cStr);
              if nlen < cpLen then cpLen := nlen;
              Caption := Copy(Caption, 1, FCurPos) + Copy(cStr, 1, cpLen) + Copy(Caption, FCurPos + 1, Length(Caption));
              Inc(FCurPos, cpLen);
            end;
          end else Beep;
        end;
      end;

      if (Ord(Key) = 3) and (FPasswordChar = #0) and (Caption <> '') then begin //CTRL + C
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
          if FSelStart > FSelEnd then begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Copy(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then begin
            Clipboard.AsText := cStr;
          end;
        end;
      end;

      if (Ord(Key) = 24) and (FPasswordChar = #0) and (Caption <> '') then begin //CTRL + X
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
          if FSelStart > FSelEnd then begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          cStr := Copy(Caption, pStart + 1, abs(FSelStart - FSelEnd));
          if cStr <> '' then begin
            Clipboard.AsText := cStr;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
          FCurPos := pStart;
        end;
      end;

      if (Ord(Key) = 1) and not FIsHotKey and (Caption <> '') then begin //CTRL + A
        FSelStart := 0;
        FSelEnd := Length(Caption);
        FCurPos := FSelEnd;
      end;

      if (Ord(Key) = VK_BACK) and not FIsHotKey and (Caption <> '') then begin //CTRL + A
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
          if FSelStart > FSelEnd then begin
            pStart := FSelEnd;
            pEnd := FSelStart;
          end;
          if FSelStart < FSelEnd then begin
            pStart := FSelStart;
            pEnd := FSelEnd;
          end;
          FSelStart := -1;
          FSelEnd := -1;
          Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
          FCurPos := pStart;
        end;
      end;
    end;
  finally
    if s <> Caption then begin
      if Assigned(FOnTextChanged) then FOnTextChanged(self, Caption);
    end;
  end;
end;

//const
//  HotKeyAtomPrefix          = 'Blue_HotKey';

function TDxCustomEdit.SetOfHotKey(HotKey: Cardinal): Word;
var
  Modifiers, Key            : Word;
  Atom                      : Word;
begin
  Result := 0;
  if (HotKey <> 0) {and not frmMain.IsRegisteredHotKey(HotKey)} then begin
    if FAtom <> 0 then begin
      UnregisterHotKey(g_MainHWnd, FAtom);
      GlobalDeleteAtom(FAtom);
    end;
    Result := 0;
    FHotKey := HotKey;
    Caption := HotKeyToText(HotKey, True);
  end;
end;

function TDxCustomEdit.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  pStart, pEnd              : Integer;
  M                         : Word;
  HK                        : Cardinal;
  ret {, IsRegistered}      : Boolean;
  s, tmpStr                 : string;
begin
  if not FEnabled then Exit;
  s := Caption;
  try
    ret := inherited KeyDown(Key, Shift);
    if ret then begin
      if FIsHotKey then begin
        if Key in [VK_BACK, VK_DELETE] then begin
          if (FHotKey <> 0) then begin
            FHotKey := 0;
            FAtom := 0;
          end;
          Caption := '';
          Exit;
        end;
        if (Key = VK_TAB) or (Char(Key) in ['A'..'Z', 'a'..'z']) then begin
          M := 0;
          if ssCtrl in Shift then M := M or MOD_CONTROL;
          if ssAlt in Shift then M := M or MOD_ALT;
          if ssShift in Shift then M := M or MOD_SHIFT;
          HK := GetHotKey(M, Key);
          if (HK <> 0) and (FHotKey <> 0) then begin
            FAtom := 0;
            FHotKey := 0;
            Caption := '';
          end;
          if (HK <> 0) then SetOfHotKey(HK);
        end;
      end else begin

        if (Char(Key) in ['0'..'9', 'A'..'Z', 'a'..'z']) then
          ShowCaret();

        if ssShift in Shift then begin
          case Key of
            VK_RIGHT: begin
                FSelClickEnd := True;
                ChangeCurPos(1);
              end;
            VK_LEFT: begin
                FSelClickEnd := True;
                ChangeCurPos(-1);
              end;
            VK_HOME: begin
                FSelEnd := FCurPos;
                FSelStart := 0;
              end;
            VK_END: begin
                FSelStart := FCurPos;
                FSelEnd := Length(Text);
              end;
          end;
        end else begin
          case Key of
            VK_LEFT: begin
                FSelStart := -1;
                FSelEnd := -1;
                FSelClickStart := True;
                ChangeCurPos(-1);
              end;
            VK_RIGHT: begin
                FSelStart := -1;
                FSelEnd := -1;
                FSelClickStart := True;
                ChangeCurPos(1);
              end;
            VK_HOME: begin
                FSelStart := -1;
                FSelEnd := -1;
                FCurPos := 0;
                FSelClickStart := True;
              end;
            VK_END: begin
                FSelStart := -1;
                FSelEnd := -1;
                FCurPos := Length(Text);
                FSelClickStart := True;
              end;
            VK_DELETE: begin
                if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) then begin
                  if FSelStart > FSelEnd then begin
                    pStart := FSelEnd;
                    pEnd := FSelStart;
                  end;
                  if FSelStart < FSelEnd then begin
                    pStart := FSelStart;
                    pEnd := FSelEnd;
                  end;
                  FSelStart := -1;
                  FSelEnd := -1;
                  Caption := Copy(Caption, 1, pStart) + Copy(Caption, pEnd + 1, Length(Caption));
                  FCurPos := pStart;
                end else begin
                  if FCurPos < Length(Caption) then begin
                    pEnd := 1;
                    case ByteType(Caption, FCurPos + 1) of
                      mbSingleByte: pEnd := 1;
                      mbLeadByte: pEnd := 2; //汉字的第一个字节
                      mbTrailByte: pEnd := 2; //汉字的第二个字节
                    end;
                    Caption := Copy(Caption, 1, FCurPos) + Copy(Caption, FCurPos + pEnd + 1, Length(Caption));

                    {if (FCurPos < Length(Caption) - 1) and (Caption[FCurPos + 1] > #$80) then
                      Caption := Copy(Caption, 1, FCurPos) + Copy(Caption, FCurPos + 3, Length(Caption))
                    else
                      Caption := Copy(Caption, 1, FCurPos) + Copy(Caption, FCurPos + 2, Length(Caption));}
                  end;
                end;
              end;
          end;
        end;
      end;
    end;
    Result := ret;
  finally
    if s <> Caption then begin
      if Assigned(FOnTextChanged) then FOnTextChanged(self, Caption);
    end;
  end;
end;

procedure TDxCustomEdit.DirectPaint(dsurface: TDXTexture);
var
  bFocused, bIsChinese      : Boolean;
  i, oCSize, WidthX,
    nl, nr, nt              : Integer;
  tmpword                   : string[255];
  tmpColor, OldColor, OldBColor: TColor;
  ob, op, ofc, oFColor,FontColor,BrushColor      : TColor;
  OldFont                   : TFont;
  off, ss, se, cPos         : Integer;
begin
  if not Visible then Exit;
  nl := SurfaceX(Left);
  //nr := SurfaceX(Left + Width);
  nt := SurfaceY(Top);

  if (FocusedControl <> self) and (DxHint <> nil) then
    DxHint.Visible := False;

  if FEnabled and not FIsHotKey then begin
    if GetTickCount - FShowCaretTick >= 400 then begin
      FShowCaretTick := GetTickCount;
      FShowCaret := not FShowCaret;
    end;
    if (FCurPos > Length(Caption)) then
      FCurPos := Length(Caption);
  end;

  if (FPasswordChar <> #0) and not FIsHotKey then begin
    tmpword := '';
    for i := 1 to Length(Caption) do
      if Caption[i] <> FPasswordChar then
        tmpword := tmpword + FPasswordChar;
  end else
    tmpword := Caption;

  op := MainForm.Canvas.Pen.Color;
  ob := MainForm.Canvas.Brush.Color;
  ofc := MainForm.Canvas.Font.Color;
  oCSize := MainForm.Canvas.Font.Size;
  with g_DXCanvas do begin
    MainForm.Canvas.Font.Size := self.Font.Size;

    if FEnabled or (self is TDComboBox) then begin
      FontColor := self.Font.Color;
      BrushColor := self.Color;
    end else begin
      FontColor := self.Font.Color;
      BrushColor := clGray;
    end;

    if not FIsHotKey and FEnabled and FClick then begin
      FClick := False;

      if (FClickX < 0) then
        FClickX := 0;
      se := TextWidth(tmpword);
      if FClickX > se then
        FClickX := se;

      cPos := FClickX div 6;
      case ByteType(tmpword, cPos + 1) of
        mbSingleByte: FCurPos := cPos;
        mbLeadByte: begin               //双字节字符的首字符
            FCurPos := cPos;
          end;
        mbTrailByte: begin              //多字节字符首字节之后的字符
            if cPos mod 2 = 0 then begin
              if FClickX mod 6 in [3..5] then
                FCurPos := cPos + 1
              else
                FCurPos := cPos - 1;
            end else begin
              if FClickX mod 12 in [6..11] then
                FCurPos := cPos + 1
              else
                FCurPos := cPos - 1;
            end;
          end;
      end;

      if FSelClickStart then begin
        FSelClickStart := False;
        FSelStart := FCurPos;
      end;
      if FSelClickEnd then begin
        FSelClickEnd := False;
        FSelEnd := FCurPos;
      end;

    end;

    WidthX := TextWidth(Copy(tmpword, 1, FCurPos));
    if WidthX + 3 - FStartTextX > Width then
      FStartTextX := WidthX + 3 - Width;

    if ((WidthX - FStartTextX) < 0) then
      FStartTextX := FStartTextX + (WidthX - FStartTextX);


    if FTransparent then begin
      if FEnabled then begin
        FontColor := self.Font.Color;
        case FAlignment of
          taCenter: begin
              TextOut((nl - FStartTextX) + ((Width - TextWidth(tmpword)) div 2 - 2), nt,FontColor, tmpword);
            end;
          taLeftJustify: begin
              ss := nl - FStartTextX;
              MainForm.Canvas.Brush.Style := bsClear;
              TextRect(Rect(nl, nt - 3 - Integer(FMiniCaret), nl + Width - 3, nt + Height),
                string(tmpword),FontColor);
            end;
        end;
        //复制文字以及背景
        if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then begin
          ss := TextWidth(Copy(tmpword, 1, FSelStart));
          se := TextWidth(Copy(tmpword, 1, FSelEnd));
          MainForm.Canvas.Brush.Style := bsClear;
          BrushColor := clSkyBlue; //clBlue;        //GetRGB(4); //背景色 账号和密码
          //增加选取复制文字背景
          //FillRectAlpha(Rect(  _MAX(nl - 1, nl + ss - 1 - FStartTextX), nt - 1 - Integer(FMiniCaret), _MIN(nl + self.Width + 1, nl + se + 1 - FStartTextX), nt + TextHeight('c') + 1 - Integer(FMiniCaret)),BrushColor,255);
          FontColor := clWhite;
          if FSelStart < FSelEnd then begin   //复制文字显示
              FillRectAlpha(Rect(
                nl + ss - 1,
                nt - 3 - Integer(FMiniCaret),
                nl + ss + TextWidth(Copy(tmpword, FSelStart+1, FSelEnd-FSelStart)) + 1,
                nt + TextHeight('c') + 2 - Integer(FMiniCaret) * 1),BrushColor,255);
              TextRectR(
                Rect(
                nl + ss - 1,
                nt - 3 - Integer(FMiniCaret),
                nl + ss + TextWidth(Copy(tmpword, FSelStart+1, FSelEnd-FSelStart)) + 1,
                nt + TextHeight('c') + 2 - Integer(FMiniCaret) * 1),
                Copy(tmpword, FSelStart+1, FSelEnd-FSelStart),FontColor);
            end else begin
              FillRectAlpha(Rect(
                nl + se - 1,
                nt - 3 - Integer(FMiniCaret),
                nl + se + TextWidth(Copy(tmpword, FSelEnd+1, FSelStart-FSelEnd)) + 1,
                nt + TextHeight('c') + 2 - Integer(FMiniCaret)),BrushColor,255);
              TextRectR(
                Rect(
                nl + se - 1,
                nt - 3 - Integer(FMiniCaret),
                nl + se + TextWidth(Copy(tmpword, FSelEnd+1, FSelStart-FSelEnd)) + 1,
                nt + TextHeight('c') + 2 - Integer(FMiniCaret)),
                Copy(tmpword, FSelEnd+1, FSelStart-FSelEnd),FontColor);
          end;
        end;
      end;
    end else begin
      if FFrameVisible then begin
        if FEnabled or (self is TDComboBox) then begin
          if FFrameHot then tmpColor := FFrameHotColor else tmpColor := FFrameColor;
        end else
          tmpColor := clGray;

        MainForm.Canvas.Brush.Style := bsClear;
        BrushColor := tmpColor; //TDxEdit 矩形边框颜色
        FillRectAlpha(Rect(nl - 3, nt - 4, nl + Width - 1, nt + Height), BrushColor, 255)
      end;

      if FIsHotKey then begin //是否热键
        bFocused := FocusedControl = self;
        if FEnabled then begin //可用
          MainForm.Canvas.Brush.Style := bsClear;
          MainForm.Canvas.Pen.Color := clBlack;
          BrushColor := clBlack; //TDxEdit 填充颜色 可用
          FillRectAlpha(Rect(nl + FFrameSize - 3 + Integer(bFocused),
           nt + FFrameSize - 3 + Integer(bFocused), nl + Width - FFrameSize - 1 - Integer(bFocused),
           nt + Height - FFrameSize - 1 - Integer(bFocused)), BrushColor, 255);

          if bFocused then
            FontColor := clLime //选中颜色
          else
            FontColor := self.Font.Color; //正常显示颜色
        end else begin
          MainForm.Canvas.Brush.Style := bsClear;
//          MainForm.Canvas.Pen.Color := self.Color;
         BrushColor := self.Color; //TDxEdit 填充颜色 不可用
         FillRectAlpha(Rect(nl + FFrameSize - 3, nt + FFrameSize - 3,
          nl + Width - FFrameSize - 1, nt + Height - FFrameSize - 1), BrushColor, 255);

          FontColor := clGray;
        end;
        case FAlignment of
          taCenter: TextOut((nl - FStartTextX) + ((Width - TextWidth(tmpword)) div 2 - 2), nt,FontColor, tmpword);
          taLeftJustify: begin
              TextOut(nl - FStartTextX, nt,FontColor, tmpword);
            end;
        end;
      end else begin  
        MainForm.Canvas.Brush.Style := bsClear;
        BrushColor := self.Color; //TDxEdit+TDComboBox 背景填充颜色
        FillRectAlpha(Rect(nl - 3 + FFrameSize, nt - 4 + FFrameSize,
        nl + Width - 1 - FFrameSize, nt + Height - FFrameSize), BrushColor, 255);
        if FEnabled then begin

          case FAlignment of
            taCenter: TextOut(
                (nl - FStartTextX) + ((Width - TextWidth(tmpword)) div 2 - 2),
                nt - Integer(FMiniCaret) * 1,FontColor,
                tmpword);
            taLeftJustify: begin
                ss := nl - FStartTextX;
                MainForm.Canvas.Brush.Style := bsClear;
                TextRectR(Rect(nl, nt - Integer(FMiniCaret) - 3, nl + Width - 1, nt + Height),
                tmpword,FontColor);

              end;
          end;

          if (FSelStart > -1) and (FSelEnd > -1) and (FSelStart <> FSelEnd) and (FocusedControl = self) then begin
            ss := TextWidth(Copy(tmpword, 1, FSelStart));
            se := TextWidth(Copy(tmpword, 1, FSelEnd));
            MainForm.Canvas.Brush.Style := bsClear;
            BrushColor := clSkyBlue; //clBlue;      //GetRGB(4); 文字选中颜色   摆摊界面
            {FillRectAlpha(Rect(
                _MAX(nl - 1, nl + ss - 1 - FStartTextX),
                nt - 1 - Integer(FMiniCaret) * 1,
                _MIN(nl + self.Width + 1, nl + se + 1 - FStartTextX),
                nt + TextHeight('c') + 1 - Integer(FMiniCaret) * 1),BrushColor,255);}

            FontColor := clWhite;
            if FSelStart < FSelEnd then begin
              FillRectAlpha(Rect(
                nl + ss - 1,
                nt - 3 - Integer(FMiniCaret),
                nl + ss + TextWidth(Copy(tmpword, FSelStart+1, FSelEnd-FSelStart)) + 1,
                nt + TextHeight('c') + 2 - Integer(FMiniCaret) * 1), BrushColor, 255);
              TextRectR(
                Rect(
                nl + ss - 1,
                nt - 3 - Integer(FMiniCaret),
                nl + ss + TextWidth(Copy(tmpword, FSelStart+1, FSelEnd-FSelStart)) + 1,
                nt + TextHeight('c') + 2 - Integer(FMiniCaret) * 1),
                Copy(tmpword, FSelStart+1, FSelEnd-FSelStart),FontColor);
            end else begin
              FillRectAlpha(Rect(
                nl + se - 1,
                nt - 3 - Integer(FMiniCaret),
                nl + se + TextWidth(Copy(tmpword, FSelEnd+1, FSelStart-FSelEnd)) + 1,
                nt + TextHeight('c') + 2 - Integer(FMiniCaret)),BrushColor,255);
              TextRectR(
                Rect(
                nl + se - 1,
                nt - 3 - Integer(FMiniCaret),
                nl + se + TextWidth(Copy(tmpword, FSelEnd+1, FSelStart-FSelEnd)) + 1,
                nt + TextHeight('c') + 2 - Integer(FMiniCaret)),
                Copy(tmpword, FSelEnd+1, FSelStart-FSelEnd),FontColor);
            end;

          end;
          FontColor := self.Font.Color;

        end else begin
          FontColor := clYellow;

          case FAlignment of
            taCenter: TextOut(
                (nl - FStartTextX) + ((Width - TextWidth(tmpword)) div 2 - 2),
                nt - Integer(FMiniCaret) * 1,FontColor,
                tmpword);
            taLeftJustify: begin
                ss := nl - FStartTextX;
                MainForm.Canvas.Brush.Style := bsClear;
                TextRectR(Rect(nl, nt - 4 - Integer(FMiniCaret), nl + Width - 1, nt + Height + 1),
                tmpword,FontColor);
              end;
          end;
        end;
      end;
      if self is TDComboBox then begin
        FontColor := clWhite;
//        MainForm.Canvas.Pen.Color := tmpColor;
//        MainForm.Canvas.Brush.Style := bsClear;
//        BrushColor := tmpColor;
        Polygon([
          Point(nl + Width - DECALW * 2 + Integer(Downed), nt + (Height - DECALH) div 2 - 2 + Integer(Downed)),
          Point(nl + Width - DECALW + Integer(Downed), nt + (Height - DECALH) div 2 - 2 + Integer(Downed)),
          Point(nl + Width - DECALW - DECALW div 2 + Integer(Downed), nt + (Height - DECALH) div 2 + DECALH - 2 + Integer(Downed))
            ],FontColor,True);
      end;
    end;
    if FEnabled then begin //闪动光标
      if (FocusedControl = self) then begin
        begin
          SetFrameHot(True);
          if (Length(tmpword) >= FCurPos) and (FShowCaret and not FIsHotKey) then begin
//            MainForm.Canvas.Pen.Color := FCaretColor;
//            MainForm.Canvas.Brush.Style := bsClear;
            BrushColor := clRed;
            case FAlignment of
              taCenter: begin
                  FillRectAlpha(Rect(nl + WidthX - FStartTextX + ((Width - TextWidth(tmpword)) div 2 - 2),
                    nt - Integer(FMiniCaret <> 0) * 1,
                    nl + WidthX + 2 - Integer(FMiniCaret <> 0) - FStartTextX + ((Width - TextWidth(tmpword)) div 2 - 2),
                    nt - Integer(FMiniCaret <> 0) * 1 + TextHeight('c')),FCaretColor,255 )
                end;
              taLeftJustify: begin
                  FillRectAlpha(Rect(nl + WidthX - FStartTextX,
                    nt - Integer(FMiniCaret) * 1 - Integer(FMiniCaret = 0),
                    nl + WidthX + 2 - FStartTextX - Integer(FMiniCaret <> 0),
                    nt - Integer(FMiniCaret) * 1 + TextHeight('c') + Integer(FMiniCaret = 0)),FCaretColor,255
                    );
                end;
            end;

          end;
        end;
      end;
    end;
{$IF NEWUUI}
    if (Text = '') and (g_SendSayList.count > 0) and (m_InputHint <> '') then begin
      FontColor := clSilver;
      g_DXCanvas.TextOut(nl + self.Width - g_DXCanvas.TextWidth(m_InputHint) - 4, nt - Integer(FMiniCaret),FontColor, m_InputHint);
    end;
{$ELSE}
    if (Text = '') and (m_InputHint <> '') then begin
      FontColor := clGray;
      g_DXCanvas.TextOut(nl + self.Width - g_DXCanvas.TextWidth(m_InputHint) - 4, nt - Integer(FMiniCaret),FontColor, m_InputHint);
    end;
{$IFEND NEWUUI}
  end;
  MainForm.Canvas.Font.Size := oCSize;
  MainForm.Canvas.Pen.Color := op;
  MainForm.Canvas.Brush.Color := ob;
  MainForm.Canvas.Font.Color := ofc;

  for i := 0 to DControls.count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
end;

function TDxCustomEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickEnd := False;
  if inherited MouseMove(Shift, X, Y) then begin
    if [ssLeft] = Shift then begin
      if FEnabled and not FIsHotKey and (MouseCaptureControl = self) and (Caption <> '') then begin
        FClick := True;
        FSelClickEnd := True;
        FClickX := X - Left + FStartTextX;
      end;
    end else begin
      //if DxHint <> nil then
      //  DxHint.Visible := False;
    end;
    Result := True;
  end;
end;

function TDxCustomEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickStart := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if FEnabled and not FIsHotKey and (MouseCaptureControl = self) then begin
      if Button = mbLeft then begin
        FSelEnd := -1;
        FSelStart := -1;
        FClick := True;
        FSelClickStart := True;
        FClickX := X - Left + FStartTextX;
      end;
    end else begin
      //if DxHint <> nil then
      //  DxHint.Visible := False;
    end;
    Result := True;
  end;
end;

function TDxCustomEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  FSelClickEnd := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    if FEnabled and not FIsHotKey and (MouseCaptureControl = self) then begin
      if Button = mbLeft then begin
        FSelEnd := -1;
        FClick := True;
        FSelClickEnd := True;
        FClickX := X - Left + FStartTextX;
      end;
    end else begin
      //if DxHint <> nil then
      //  DxHint.Visible := False;
    end;
    Result := True;
  end;
end;

{--------------------- TDComboBox --------------------------}

constructor TDComboBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  DropDownList := nil;
  FShowCaret := False;
  FTransparent := False;
  FEnabled := False;
  FDropDownList := nil;
end;

function TDComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := True;
      SetDCapture(self);
    end;
    if (FDropDownList <> nil) and not FDropDownList.ChangingHero then begin
      FDropDownList.Visible := not FDropDownList.Visible;
    end;
    Result := True;
  end else if FDropDownList <> nil then begin
    if FDropDownList.Visible then
      FDropDownList.Visible := False;
  end;
end;

function TDComboBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if not Background then begin
    if Result then
      SetFrameHot(True)
    else if FocusedControl <> self then
      SetFrameHot(False);
  end;
end;

{------------------------- TDxCustomListBox --------------------------}

constructor TDxCustomListBox.Create(aowner: TComponent);
begin
  inherited Create(aowner);
  FSelected := -1;
  ChangingHero := False;
  FItems := TStringList.Create;
  FBackColor := clWhite;
  FSelectionColor := clSilver;
  FOnChangeSelect := nil;               //ChangeSelect;
  FOnMouseMoveSelect := nil;
  ParentComboBox := nil;
  FParentComboBox := nil;
  //DxScroll := TDxScrollBar.Create(w - 20, 0, 20, h - 2, Self, FItems, Font, h - 2);
  //add_fenetre(DxScroll);
end;

destructor TDxCustomListBox.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TDxCustomListBox.GetItemSelected: Integer;
begin
  if (FSelected > FItems.count - 1) or (FSelected < 0) then
    Result := -1
  else
    Result := FSelected;
  //if Assigned(FOnChangeSelect) then begin
  // FOnChangeSelect(Self, FSelected);
  //end;
end;

procedure TDxCustomListBox.SetItemSelected(Value: Integer);
begin
  if (Value > FItems.count - 1) or (Value < 0) then
    FSelected := -1
  else
    FSelected := Value;
  {if Assigned(FOnChangeSelect) then begin
    FOnChangeSelect(Self, FSelected);
  end;}
end;

procedure TDxCustomListBox.SetBackColor(Value: TColor);
begin
  if FBackColor <> Value then begin
    FBackColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

procedure TDxCustomListBox.SetSelectionColor(Value: TColor);
begin
  if FSelectionColor <> Value then begin
    FSelectionColor := Value;
    Perform(CM_COLORCHANGED, 0, 0);
  end;
end;

function TDxCustomListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  //DScreen.AddChatBoardString('MouseDown', clWhite, clRed);
  Result := inherited MouseDown(Button, Shift, X, Y);
end;

function TDxCustomListBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  TmpSel                    : Integer;
begin
  FSelected := -1;
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FEnabled and not Background then begin

    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y) div (-MainForm.Canvas.Font.Height + LineSpace);
    if FSelected > FItems.count - 1 then
      FSelected := -1;
    if Assigned(FOnMouseMoveSelect) then
      FOnMouseMoveSelect(self, Shift, X, Y);
  end;
end;

function TDxCustomListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ret                       : Boolean;
  TmpSel                    : Integer;
begin
  ret := inherited MouseUp(Button, Shift, X, Y);
  if ret then begin
    TmpSel := FSelected;
    if (FItems.count = 0) then
      FSelected := -1
    else
      FSelected := (-Top + Y) div (-MainForm.Canvas.Font.Height + LineSpace);

    if FSelected > FItems.count - 1 then
      FSelected := -1;

    if FSelected <> -1 then begin
      if ParentComboBox <> nil then begin
        if ParentComboBox.Caption <> FItems[FSelected] then begin
          if Caption = 'SelectHeroList' then begin
//            ChangingHero := True;
//            frmDlg.QueryChangeHero(FItems[FSelected]);
          end else
            ParentComboBox.Caption := FItems[FSelected];
        end;
      end;
      if Integer(FItems.Objects[FSelected]) > 0 then
        ParentComboBox.tag := Integer(FItems.Objects[FSelected]);
    end;
    if Assigned(FOnChangeSelect) then
      FOnChangeSelect(self, Button, Shift, X, Y);
    Visible := False;
    ret := True;
  end;
  Result := ret;
end;

function TDxCustomListBox.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  ret                       : Boolean;
begin
  ret := inherited KeyDown(Key, Shift);
  if ret then begin
    case Key of
      VK_PRIOR: begin
          ItemSelected := ItemSelected - Height div -MainForm.Canvas.Font.Height;
          if (ItemSelected = -1) then ItemSelected := 0;
        end;
      VK_NEXT: begin
          ItemSelected := ItemSelected + Height div -MainForm.Canvas.Font.Height;
          if ItemSelected = -1 then ItemSelected := FItems.count - 1;
        end;
      VK_UP: if ItemSelected - 1 > -1 then
          ItemSelected := ItemSelected - 1;
      VK_DOWN: if ItemSelected + 1 < FItems.count then
          ItemSelected := ItemSelected + 1;
    end;
    {case Key of
      VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN: if (ItemSelected <> -1) then begin
          while (((-DxScroll.GetPos + Height) div -Font.Height) <= ItemSelected) do
            DxScroll.MoveModPos(Font.Height);
          while (((-DxScroll.GetPos) div -Font.Height) > ItemSelected) do
            DxScroll.MoveModPos(-Font.Height);
        end;
    end;}
  end;
  Result := ret;
end;

{procedure TDxCustomListBox.ChangeSelect(ChangeSelect: Integer);
begin
  //
end;}

procedure TDxCustomListBox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TDxCustomListBox.DirectPaint(dsurface: TDXTexture);
var
  fy, nY, L, T, i, oSize    : Integer;
  OldColor,{BrushColor,}FontColor                  : TColor;
begin
  if Assigned(FOnDirectPaint) then begin
    FOnDirectPaint(self, dsurface);
    Exit;
  end;
  L := SurfaceX(Left);
  T := SurfaceY(Top);
  with g_DXCanvas do begin
    try
      OldColor := MainForm.Canvas.Font.Color;
      oSize := MainForm.Canvas.Font.Size;
      //MainForm.Canvas.Font.Color := clBlack;
      //MainForm.Canvas.Font.Size := self.Font.Size;
      //MainForm.Canvas.Brush.Style := bsSolid;
      //BrushColor := SelectionColor;
      FillRectAlpha(Rect(L, T, L + Width, T + Height), clGray, 200); //TDListBox 背景颜色
      //BrushColor := BackColor;
      if FSelected <> -1 then begin
        nY := T + (-MainForm.Canvas.Font.Height + LineSpace) * FSelected;
        fy := nY + (-MainForm.Canvas.Font.Height + LineSpace);
        if (nY < T + Height - 1) and (fy > T + 1) then begin
          if (fy > T + Height - 1) then fy := T + Height - 1;
          if (nY < T + 1) then nY := T + 1;
          FillRectAlpha(Rect(L + 1, nY, L + Width - 1, fy + 2), SelectionColor, 255);
        end;
      end;                                             
      //MainForm.Canvas.Brush.Style := bsClear;
      for i := 0 to FItems.count - 1 do begin
        if FSelected = i then begin
          FontColor := OldColor;
          g_DXCanvas.BoldTextOut(L + 2, 2 + T + (-MainForm.Canvas.Font.Height + LineSpace) * i, FontColor, FItems.Strings[i]);
        end else begin
          FontColor := clWhite;
          g_DXCanvas.BoldTextOut(L + 2, 2 + T + (-MainForm.Canvas.Font.Height + LineSpace) * i, FontColor, FItems.Strings[i]);
        end;
      end;
      MainForm.Canvas.Font.Color := OldColor;
      MainForm.Canvas.Font.Size := oSize;
    finally
    end;
  end;
end;
{==============================================Edit过程结束==================================}

end.

