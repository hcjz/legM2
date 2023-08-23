unit SCFastMemory;

interface

uses
  SysUtils, Windows;

implementation

var
  InProc: Boolean;
  TimerID: Integer;

procedure SaveMemory;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin //整理内存
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
  end;
end;

//定时器要执行的回调函数
procedure HearBeatProc(Wnd: HWnd; Msg, EVEnt, dwTime: Integer); stdcall;
begin
  if (InProc = False) then
  begin
    InProc := True;
    try
      SaveMemory;
    finally
      InProc := False;
    end;
  end;
end;  

initialization
  SetTimer(0, 0, 3000, @HearBeatProc); //创建一个定时器
finalization
  KillTimer(0, TimerID);

end.
