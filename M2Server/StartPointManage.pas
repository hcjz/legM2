unit StartPointManage;

interface

uses
  Classes, Windows, SysUtils, Envir, Event, MudUtil;

type
  TStartPointManager = class
  public
    m_InfoList: TList;
    constructor Create();
    destructor Destroy; override;
    function Initialize(var s: string): Boolean;
    procedure CreateAureole();
  end;

implementation

uses M2Share, HUtil32, Grobal2;

constructor TStartPointManager.Create;
begin
  m_InfoList := TList.Create;
end;

destructor TStartPointManager.Destroy;
var
  i                         : Integer;
begin
  for i := 0 to m_InfoList.Count - 1 do
    Dispose(pTStartPointInfo(m_InfoList.Items[i]));
  m_InfoList.Free;
  inherited;
end;

function TStartPointManager.Initialize(var s: string): Boolean;
var
  i                         : Integer;
  sFileName, tStr, sMAP, sX, sY, sQuiz, sSize, sType, sPKZone, sPKFire: string;
  nX, nY, nQuiz, nSize, nType, nPKZONE, nPKFIRE: Integer;
  LoadList                  : TStringList;
  StartPointInfo            : pTStartPointInfo;
  Envir                     : TEnvirnoment;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'StartPoint.txt';
  if FileExists(sFileName) then begin
    m_InfoList.Clear;
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      tStr := Trim(LoadList.Strings[i]);
      if (tStr <> '') and (tStr[1] <> ';') then begin
        tStr := GetValidStr3(tStr, sMAP, [' ', #9]);
        tStr := GetValidStr3(tStr, sX, [' ', #9]);
        tStr := GetValidStr3(tStr, sY, [' ', #9]);
        tStr := GetValidStr3(tStr, sQuiz, [' ', #9]);
        tStr := GetValidStr3(tStr, sSize, [' ', #9]);
        tStr := GetValidStr3(tStr, sType, [' ', #9]);
        tStr := GetValidStr3(tStr, sPKZone, [' ', #9]);
        tStr := GetValidStr3(tStr, sPKFire, [' ', #9]);
        if (sMAP <> '') and (sX <> '') and (sY <> '') then begin
          Envir := g_MapManager.FindMap(sMAP);
          if Envir = nil then
            Continue;
          New(StartPointInfo);
          StartPointInfo.Envir := Envir;
          StartPointInfo.sMapName := sMAP;
          StartPointInfo.nX := Str_ToInt(sX, 0);
          StartPointInfo.nY := Str_ToInt(sY, 0);
          StartPointInfo.boQUIZ := Str_ToInt(sQuiz, 0) = 1;
          nSize := Str_ToInt(sSize, 0);
          if nSize <= 0 then nSize := g_Config.nSafeZoneSize;
          StartPointInfo.nSize := nSize;
          StartPointInfo.nType := Str_ToInt(sType, 0);
          StartPointInfo.boPKZone := Str_ToInt(sPKZone, 0) = 1;
          StartPointInfo.boPKFire := Str_ToInt(sPKFire, 0) = 1;
          StartPointInfo.dwCrTick := GetTickCount();
          m_InfoList.Add(StartPointInfo);
          Result := True;
        end;
      end;
    end;
    LoadList.Free;
  end;
end;

procedure TStartPointManager.CreateAureole();
var
  i, nCoordinate            : Integer;
  StartPointInfo            : pTStartPointInfo;
  AureoleEvent              : TSafeZoneAureoleEvent;
  nStartX, nStartY, nEndX, nEndY: Integer;
begin
  for i := 0 to m_InfoList.Count - 1 do begin
    StartPointInfo := m_InfoList.Items[i];
    nStartX := StartPointInfo.nX - StartPointInfo.nSize;
    nEndX := StartPointInfo.nX + StartPointInfo.nSize;
    nStartY := StartPointInfo.nY - StartPointInfo.nSize;
    nEndY := StartPointInfo.nY + StartPointInfo.nSize;
    for nCoordinate := nStartX to nEndX do begin
      AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nCoordinate, nStartY, StartPointInfo.nType);
      g_EventManager.AddEvent(AureoleEvent);

      AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nCoordinate, nEndY, StartPointInfo.nType);
      g_EventManager.AddEvent(AureoleEvent);
    end;
    for nCoordinate := nStartY to nEndY do begin
      AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nStartX, nCoordinate, StartPointInfo.nType);
      g_EventManager.AddEvent(AureoleEvent);

      AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nEndX, nCoordinate, StartPointInfo.nType);
      g_EventManager.AddEvent(AureoleEvent);
    end;
  end;
end;

end.

