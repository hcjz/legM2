unit Share;

interface
uses
  Windows, Messages, Classes, SysUtils, IniFiles, Grobal2, MudUtil, tlhelp32, PsAPI;

type
 //无用定义用于填充
  Ttest = record
    test: string;
  end;
  pTtest = ^Ttest;

var


//Hum.DB定义
n4ADAFC                   : Integer;
n4ADB04                   : Integer;
n4ADB00                   : Integer;
n4ADAE4                   : Integer;
n4ADAF0                   : Integer;
n4ADAE8                   : Integer;
n4ADAEC                   : Integer;
boHumDBReady              : Boolean;
boDataDBReady             : Boolean;
HumDB_CS                  : TRTLCriticalSection;

//ID.DB定义
g_n472A6C                 : Integer;
g_n472A74                 : Integer;
g_n472A70                 : Integer;
g_boDataDBReady           : Boolean;  //0x00472A78

implementation


initialization
  InitializeCriticalSection(HumDB_CS);

finalization
  DeleteCriticalSection(HumDB_CS);

end.

