unit LooksFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls;

type
  TfrmLooksFile = class(TForm)
    tabData: TPageControl;
    Wzl: TTabSheet;
    Map: TTabSheet;
    Wav: TTabSheet;
    meWzlRunLog: TMemo;
    MeMapRunLog: TMemo;
    meWavRunLog: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open;
  end;

var
  frmLooksFile: TfrmLooksFile;

implementation

{$R *.dfm}

procedure TfrmLooksFile.Open;
begin
  ShowModal;
end;

end.
