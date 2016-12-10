unit uSoAnimation;

interface

uses
  uSoObject, uSoTypes,
  uEngine2DStatus, uEngine2DClasses, uSoBasePart;

type
  TEngineThreadParams = class
  private
    FEngineStatus: TEngine2DStatus;
    function GetFPS: Single;
    function GetSpeed: Single;
  public
    property Speed: Single read GetSpeed;
    property FPS: Single read GetFPS;
    constructor Create(const AEngineStatus: TEngine2DStatus);
  end;

  TSoAnimation = class abstract(TSoBasePart)
  strict private
    FThreadParams: TEngineThreadParams;
    FTimeTotal: Integer; // How many milliseconds this animation will run
    FTimePassed: Double; // How many millisecnds passed
    FOnFinish: TNotifyEvent;
    FOnCancel: TNotifyEvent;
    FOnStart: TNotifyEvent; // Set the initial condition for object // ������ ����� ���������� ��� ������ ������ ClearForSubject � TAnimationList. �� ������ ��������� ��������� ������� � ����������.
    procedure Finalize; virtual; abstract; // Set the final values that animates for object  // ��� ������, ��� �������� ��������� ���� �������� ����� ��-�� ������� ���. ��� ���, ��� ��� ����, ����� ��������� �������� ����������
    procedure RecoverStart; virtual; abstract;
   public
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnFinish: TNotifyEvent read FOnFinish write FOnFinish;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property Subject: TSoObject read FSubject;// write SetSubject;//GetSubject write
    property TimeTotal: Integer read FTimeTotal; // ����� � ��, ������� �������� ����� �������
    property TimePassed: Double read FTimePassed;// ����� � ��, ������� �������� ��� ������
    procedure Cancel; virtual; abstract; // Returns subject properties to Start and stop animation;
    function Animate: Byte; virtual; // Main method to animate object // ������� ������� �������. ����� True, �� ������ �������� ������� ���������
    constructor Create(const ASubject: TSoObject; const AThreadParams: TEngineThreadParams); virtual;
    destructor Destroy; override;
  const
    CDefaultTotalTime = 500; // Default time for animation // ����� �� ��������, �� ���������. ���� ������ ������� �����������, �������� ��������������� � ���������� ����� Animate
  end;

implementation

{ TEngineThreadParams }

constructor TEngineThreadParams.Create(const AEngineStatus: TEngine2DStatus);
begin
  FEngineStatus := AEngineStatus;
end;

function TEngineThreadParams.GetFPS: Single;
begin
  Result := FEngineStatus.EngineFPS;
end;

function TEngineThreadParams.GetSpeed: Single;
begin
  Result := FEngineStatus.EngineSpeed;
end;

{ TSoAnimation }

function TSoAnimation.Animate: Byte;
begin

end;

constructor TSoAnimation.Create(const ASubject: TSoObject;
  const AThreadParams: TEngineThreadParams);
begin
  inherited Create(ASubject);

  FSubject.AddDestroyHandler(OnSubjectDestroy);
  FThreadParams := AThreadParams;
end;

destructor TSoAnimation.Destroy;
begin
  FThreadParams := nil;
  inherited;
end;

end.

