unit uConfig;

interface

uses
  Windows, SysUtils, IniFiles, GShare;

type
  Tm2ConFigEx = record
    szGateAddr: string;                                                         //服务器地址
    wdGatePort: Word;                                                           //服务器端口
    dwUserLimit:  LongWord;                                                     //在线人数限制
    szResourcePath:string;                                                      //资源路径
    boMapView:Boolean;                                                          //是否开启文件映射
  end;

  Tm2ConfigManage = class(TObject)
  protected
    m2IniConfig: TIniFile;
  public
    m2ConFigEx: Tm2ConFigEx;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadDBConfig;
    procedure SaveDBConfig;
  end;

var
  m2ConfigManage: Tm2ConfigManage;

implementation

constructor Tm2ConfigManage.Create;
begin
  inherited;
  m2ConFigEx.szGateAddr := '127.0.0.1';
  m2ConFigEx.wdGatePort := 8000;
  m2ConFigEx.dwUserLimit  := 2000;
  m2ConFigEx.szResourcePath := '';
  m2ConFigEx.boMapView:= False;
end;

procedure Tm2ConfigManage.LoadDBConfig;
begin
  if m2IniConfig = nil then
    m2IniConfig := TIniFile.Create('.\Config.ini');

  if m2IniConfig.ReadString('MinUpdateSrv', 'GateAddr', '') = '' then
    m2IniConfig.WriteString('MinUpdateSrv', 'GateAddr', m2ConFigEx.szGateAddr);
  m2ConFigEx.szGateAddr := m2IniConfig.ReadString('MinUpdateSrv', 'GateAddr', m2ConFigEx.szGateAddr);

  if m2IniConfig.ReadInteger('MinUpdateSrv', 'GatePort', 0) = 0 then
    m2IniConfig.WriteInteger('MinUpdateSrv', 'GatePort', m2ConFigEx.wdGatePort);
  m2ConFigEx.wdGatePort := m2IniConfig.ReadInteger('MinUpdateSrv', 'GatePort', 0);

  if m2IniConfig.ReadInteger('MinUpdateSrv', 'UserLimit', 0) = 0 then
    m2IniConfig.WriteInteger('MinUpdateSrv', 'UserLimit', m2ConFigEx.dwUserLimit);
  m2ConFigEx.dwUserLimit := m2IniConfig.ReadInteger('MinUpdateSrv', 'UserLimit', 0);

  if m2IniConfig.ReadString('MinUpdateSrv', 'MirPath', '') = '' then
    m2IniConfig.WriteString('MinUpdateSrv', 'MirPath', m2ConFigEx.szResourcePath);
  m2ConFigEx.szResourcePath := m2IniConfig.ReadString('MinUpdateSrv', 'MirPath', m2ConFigEx.szResourcePath);

  if m2IniConfig.ReadInteger('MinUpdateSrv', 'MapView', 0) = -1 then
    m2IniConfig.WriteInteger('MinUpdateSrv', 'MapView', Integer(m2ConFigEx.boMapView));
  m2ConFigEx.boMapView := Boolean(m2IniConfig.ReadInteger('MinUpdateSrv', 'MapView', 0));
end;

procedure Tm2ConfigManage.SaveDBConfig;
begin
  m2IniConfig.WriteString('MinUpdateSrv', 'GateAddr', m2ConFigEx.szGateAddr);
  m2IniConfig.WriteInteger('MinUpdateSrv', 'GatePort', m2ConFigEx.wdGatePort);
  m2IniConfig.WriteInteger('MinUpdateSrv', 'UserLimit', m2ConFigEx.dwUserLimit);
  m2IniConfig.WriteString('MinUpdateSrv', 'MirPath', m2ConFigEx.szResourcePath);
  m2IniConfig.WriteInteger('MinUpdateSrv', 'MapView', Integer(m2ConFigEx.boMapView));
end;

destructor Tm2ConfigManage.Destroy;
begin
  if m2IniConfig <> nil then
    m2IniConfig.Free;
  inherited;
end;

end.
