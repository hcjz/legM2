program MirDbEdit;

uses
  Forms,
  Unit1 in 'Unit1.pas' {DBEditForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDBEditForm, DBEditForm);
  Application.Run;
end.
