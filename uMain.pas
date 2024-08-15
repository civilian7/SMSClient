unit uMain;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  FBC.SMSGateway;

type
  TfrmMain = class(TForm)
    lbURL: TLabel;
    eURL: TEdit;
    lbUserID: TLabel;
    eUserID: TEdit;
    lbNumbers: TLabel;
    eNumbers: TEdit;
    eMessage: TMemo;
    lbMessage: TLabel;
    btnSend: TButton;
    lbPassword: TLabel;
    ePassword: TEdit;
    eResult: TMemo;
    lbResult: TLabel;
    procedure btnSendClick(Sender: TObject);
  private
    FSMSClient: TSMSClient;

    procedure LoadFromFile;
    procedure SaveToFile;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TForm9 }

procedure TfrmMain.btnSendClick(Sender: TObject);
var
  LResult: ISMSResult;
begin
  FSMSClient.URL := eURL.Text;
  FSMSClient.UserID := eUserID.Text;
  FSMSClient.Password := ePassword.Text;
  LResult := FSMSClient.Send(eNumbers.Text, eMessage.Text);
  eResult.Lines.Add(LResult.Data.ToJSON(False));
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  LoadFromFile;
  FSMSClient := TSMSClient.Create;
end;

destructor TfrmMain.Destroy;
begin
  SaveToFile;
  FSMSClient.Free;

  inherited;
end;

procedure TfrmMain.LoadFromFile;
begin
  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
  begin
    eURL.Text := ReadString('SERVER', 'URL', '192.168.0.100:8080');
    eUserID.Text := ReadString('SERVER', 'USERID', '');
    ePassword.Text := ReadString('SERVER', 'PASSWORD', '');

    Free;
  end;
end;

procedure TfrmMain.SaveToFile;
begin
  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
  begin
    WriteString('SERVER', 'URL', eURL.Text);
    WriteString('SERVER', 'USERID', eUserID.Text);
    WriteString('SERVER', 'PASSWORD', ePassword.Text);

    Free;
  end;
end;

end.
