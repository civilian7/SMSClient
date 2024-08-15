unit FBC.SMSGateway;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Net.HttpClient,
  System.NetEncoding,

  FBC.Json;

type
  ISMSResult = interface
    ['{E9D3A436-E108-456C-8641-3B4DAD6D6046}']
    function GetCode: Integer;
    function GetData: TJSONObject;

    property Code: Integer read GetCode;
    property Data: TJSONObject read GetData;
  end;

  TSMSResult = class(TInterfacedObject, ISMSResult)
  private
    FCode: Integer;
    FData: TJSONObject;
    FMessage: string;

    function GetCode: Integer;
    function GetData: TJSONObject;
  public
    constructor Create(AResponse: IHttpResponse);
    destructor Destroy; override;

    property Code: Integer read GetCode;
    property Data: TJSONObject read GetData;
  end;

  TSMSClient = class
  private
    FHttpClient: THttpClient;
    FPassword: string;
    FURL: string;
    FUserID: string;

    procedure CheckHttpClient;
    function  GetCredential: string;
    function  HttpGet(const AResourceID: string): ISMSResult;
    function  HttpPost(const AResourceID, AData: string): ISMSResult;
  public
    constructor Create;
    destructor Destroy; override;

    function DeviceInfo: ISMSResult;
    function GetMessage(const AIndex: Integer): ISMSResult;
    function Health: ISMSResult;
    function Logs: ISMSResult;
    function Send(const ANumbers, AMessage: string): ISMSResult;

    property Password: string read FPassword write FPassword;
    property UserID: string read FUserID write FUserID;
    property URL: string read FURL write FURL;
  end;

implementation

{ TSMSResult }

constructor TSMSResult.Create(AResponse: IHttpResponse);
begin
  AResponse.ContentStream.Position := 0;

  FCode := AResponse.StatusCode;
  FData := TJSONObject.ParseFromStream(AResponse.ContentStream) as TJSONObject;
end;

destructor TSMSResult.Destroy;
begin
  FData.Free;

  inherited;
end;

function TSMSResult.GetCode: Integer;
begin
  Result := FCode;
end;

function TSMSResult.GetData: TJSONObject;
begin
  Result := FData;
end;

{ TSMSClient }

constructor TSMSClient.Create;
begin
  FPassword := '';
  FUserID := '';
  FURL := '127.0.0.1:8080';
end;

destructor TSMSClient.Destroy;
begin
  if Assigned(FHttpClient) then
    FHttpClient.Free;

  inherited;
end;

procedure TSMSClient.CheckHttpClient;
begin
  if not Assigned(FHttpClient) then
  begin
    FHttpClient := THttpClient.Create;
    FHttpClient.ContentType := 'application/json';
    FHttpClient.CustomHeaders['authorization'] := GetCredential;
  end;
end;

function TSMSClient.DeviceInfo: ISMSResult;
begin
  Result := HttpGet('/device');
end;

function TSMSClient.GetCredential: string;
var
  LBase64: TBase64Encoding;
begin
  LBase64 := TBase64Encoding.Create(0);
  try
    Result := 'Basic ' + LBase64.Encode(FUserID + ':' + FPassword);
  finally
    LBase64.Free;
  end;
end;

function TSMSClient.GetMessage(const AIndex: Integer): ISMSResult;
begin
  CheckHttpClient;
  Result := HttpGet(Format('/message/%d', [AIndex]));
end;

function TSMSClient.Health: ISMSResult;
begin
  CheckHttpClient;
  Result := HttpGet('/health');
end;

function TSMSClient.HttpGet(const AResourceID: string): ISMSResult;
begin
  CheckHttpClient;
  Result := TSMSResult.Create(FHttpClient.Get(FURL + AResourceID));
end;

function TSMSClient.HttpPost(const AResourceID, AData: string): ISMSResult;
var
  LStream: TMemoryStream;
begin
  LStream := TStringStream.Create(AData, TEncoding.UTF8);
  try
    CheckHttpClient;
    Result := TSMSResult.Create(FHttpClient.Post(FURL + AResourceID, LStream));
  finally
    LStream.Free;
  end;
end;

function TSMSClient.Logs: ISMSResult;
begin
  CheckHttpClient;
  Result := HttpGet('/logs');
end;

function TSMSClient.Send(const ANumbers, AMessage: string): ISMSResult;
var
  LData: TJSONObject;
  LNumbers: TArray<string>;
  i: Integer;
begin
  LData := TJSONObject.Create;
  try
    LNumbers := ANumbers.Split([',']);

    LData.S['message'] := AMessage;
    for i := 0 to High(LNumbers) do
      LData.A['phoneNumbers'].Add(LNumbers[i]);

    Result := HttpPost('/message', LData.ToJSON);
  finally
    LData.Free;
  end;
end;

end.
