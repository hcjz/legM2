unit sDBText;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, db, sLabel{$IFDEF LOGGED}, sDebugMsgs{$ENDIF};

type
  TsDBText = class(TsLabel)
  private
    FDataLink: TFieldDataLink;
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetFieldText: string;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    function GetField: TField;
  protected
    function GetLabelText: string; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetAutoSize(Value: Boolean); override;
    procedure WndProc (var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure Loaded; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

implementation

uses dbconsts;

{ TsDBText }

procedure TsDBText.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

constructor TsDBText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShowAccelChar := False;
  FDataLink := TFieldDataLink.Create;
  FDataLink.OnDataChange := DataChange;
end;

procedure TsDBText.DataChange(Sender: TObject);
begin
  if Assigned(FDataLink) and Assigned(FDataLink.Field)
    then Caption := GetFieldText
    else if csDesigning in ComponentState then Caption := Name else Caption := '';
end;

destructor TsDBText.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

function TsDBText.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TsDBText.GetDataField: string;
begin
  if Assigned(FDataLink) then Result := FDataLink.FieldName else Result := '';
end;

function TsDBText.GetDataSource: TDataSource;
begin
  if Assigned(FDataLink) and Assigned(FDataLink.DataSource) then Result := FDataLink.DataSource else Result := nil;
end;

function TsDBText.GetField: TField;
begin
  if Assigned(FDataLink) then Result := FDataLink.Field else Result := nil;
end;

function TsDBText.GetFieldText: string;
begin
  if Assigned(FDataLink) and Assigned(FDataLink.Field)
    then Result := FDataLink.Field.DisplayText
    else if csDesigning in ComponentState then Result := Name else Result := '';
end;

function TsDBText.GetLabelText: string;
begin
  if not (csDesigning in ComponentState) and not (Assigned(FDataLink) and Assigned(FDataLink.Field))
    then Result := ''
    else if csPaintCopy in ControlState then Result := GetFieldText else Result := Caption;
end;

procedure TsDBText.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TsDBText.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TsDBText.SetAutoSize(Value: Boolean);
begin
  if AutoSize <> Value then begin
    if Value and FDataLink.DataSourceFixed then DatabaseError('Operation not allowed in a DBCtrlGrid');
    inherited SetAutoSize(Value);
  end;
end;

procedure TsDBText.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TsDBText.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TsDBText.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

function TsDBText.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

procedure TsDBText.WndProc(var Message: TMessage);
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
  inherited;
end;

end.
