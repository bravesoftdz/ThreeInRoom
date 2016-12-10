unit uEngine2DAnimation;

interface

uses
  uSoTypes,
  uNamedList, uEngine2DClasses, uClasses, uGeometryClasses, uEngine2DStatus;

type
  // ����� ������������ ������ DelayedCreate, �� �� ���������� �� �������
  // DelayedAnimation. DelayedCreate ��� �������� �������� ��� ������������
  // ����������� ��������� �������, �.�. ��� Setup'�. ��� ������������ �����
  // �������� ������ ��������� ���� ��������� ��������� ����� ������
  // ������������, �.�. �������� ���� ������ �������� ������� ��� Next,
  // �.�. ��������� �� �����-�� ���������.

  // I use Term "Delayed create" but it has another term than DelayedAnimation
  // "Delayed create" creates animation at this moment, but it don't save the
  // Initial conditions, because it dont use Setup in this moment/
  // It can be used in situation like when it's the second animation in animation queue

  TAnimation = class
  strict private
    FSubject: Pointer; // Pointer to object for animation. ��������� �� ������ ��������
    FOnDeleteSubject: TNotifyEvent;
    FStatus: TEngine2DStatus;
    FNextAnimation: TAnimation;
    FSetupped: Boolean;
    FStopped: Boolean;
    FFinalized: Boolean;
    FStartPos: TPosition;
    FTimeTotal: Integer;
    FTimePassed: Double;
    FOnSetup: TProcedure;
    FOnDestroy: TProcedure;
    FOnFinalize: TProcedure;
    procedure SetSubject(const Value: Pointer);
   public
    property OnDeleteSubject: TNotifyEvent read FOnDeleteSubject write FOnDeleteSubject;
    property Status: TEngine2DStatus read FStatus write FStatus;
    property Stopped: Boolean read FStopped write FStopped; // ���� �������� �����������, ��� ������ �� ������, ��� �������
    property Finalized: Boolean read FFinalized; // �������������� �� ��������
    property Subject: Pointer read FSubject write SetSubject;//GetSubject write
    property NextAnimation: TAnimation read FNextAnimation write FNextAnimation; // ��������, ������� ���������� ����� ����� ������
    property Setupped: Boolean read FSetupped;// write FSetupped; // ��� ���������� �������������
    property StartPosition: TPosition read FStartPos write FStartPos;
    property TimeTotal: Integer read FTimeTotal write FTimeTotal; // ����� � ��, ������� �������� ����� �������
    property TimePassed: Double read FTimePassed write FTimePassed; // ����� � ��, ������� �������� ��� ������
    property OnDestroy: TProcedure read FOnDestroy write FOnDestroy; // ��������� �� ����������� ��������
    property OnSetup: TProcedure read FOnSetup write FOnSetup; // ��������� �� ����� ��������
    property OnFinalize: TProcedure read FOnFinalize write FOnFinalize; // ��������� �� ����� ��������
    procedure RecoverStart; virtual; // Set the initial condition for object // ������ ����� ���������� ��� ������ ������ ClearForSubject � TAnimationList. �� ������ ��������� ��������� ������� � ����������.
    procedure Finalize; virtual; // Set the final condtion for object  // ��� ������, ��� �������� ��������� ���� �������� ����� ��-�� ������� ���. ��� ���, ��� ��� ����, ����� ��������� �������� ����������
    function Animate: Byte; virtual; // Main method to animate object // ������� ������� �������. ����� True, �� ������ �������� ������� ���������

    function AddNextAnimation(AAnimation: TAnimation): Integer; // ��������� ��������� ��������, � ���� ��������� �������� ��� ����, �� ��������� ��������� �������� ��������� �������� � �.�. ������ ��������� ����� ��������� ��������
    procedure Setup; virtual; // It's used for delayed create // ����� ��� ����������� ������. �� ���� ����� �������� ���������� ��������� ���������, �������� ��������� ���������
    procedure DeleteSubject;
    procedure HideSubject;
    constructor Create; virtual;
    destructor Destroy; override;
  const
    CDefaultTotalTime = 500; // Default time for animation // ����� �� ��������, �� ���������. ���� ������ ������� �����������, �������� ��������������� � ���������� ����� Animate
    // Animation statues:
    CAnimationEnd = 0;  // ����� �������� ���������, ��� ��������� �� ������ ��������
    CAnimationInProcess = 1;  // ���� �������� �� �����������
    CNextAnimationInProcess = 2;  // ���� �������� �� �����������
  end;

implementation

uses
  uEngine2D, uEngine2DObject;

{ tEngine2DAnimation }

function TAnimation.AddNextAnimation(AAnimation: TAnimation): Integer;
begin
  Result := 0;
  if FNextAnimation = nil then
  begin
    FNextAnimation := AAnimation;
    Result := 1;
  end
  else
    Result := Result + FNextAnimation.AddNextAnimation(AAnimation);
end;

function tAnimation.Animate: Byte;
begin
  if FSetupped = False then
    Setup;

  Result := CAnimationInProcess;
  if TimePassed < TimeTotal then
  begin
    TimePassed := TimePassed + (1000 / FStatus.EngineFPS {vEngine.EngineThread.FPS});
    if TimePassed > TimeTotal then
      Result := CAnimationEnd;
  end else
  begin
    if FNextAnimation <> Nil then
    begin
      if not FFinalized then
        Finalize;
      Result := FNextAnimation.Animate;
      if Result <> CAnimationEnd then
        Result := CNextAnimationInProcess;
    end
    else begin
      if not FFinalized then
        Finalize;
      Result := CAnimationEnd;
    end;
  end;

end;

constructor tAnimation.Create;
begin
  FSetupped := False;
  FStopped := True; // �������� ��������� �������������, � ��������� ���� ������������� ������ ����� ���������� �������
  FFinalized := False;
  FTimeTotal := CDefaultTotalTime;
  FTimePassed := 0;
end;

{constructor tAnimation.DelayedCreate;
begin
  FSetupped := False;
  FStopped := True; // �������� ��������� �������������, � ��������� ���� ������������� ������ ����� ���������� �������
  FTimeTotal := CDefaultTotalTime;
  FTimePassed := 0;
end;   }

procedure TAnimation.DeleteSubject;
var
  vObj: tEngine2DObject;
begin
  vObj := FSubject;
  FOnDeleteSubject(vObj);
  vObj.Free;
end;

destructor tAnimation.Destroy;
begin
  if FNextAnimation <> Nil then
    FNextAnimation.Free;
  if Assigned(FOnDestroy) then
    FOnDestroy;
  inherited;
end;

procedure TAnimation.Finalize;
begin
  FFinalized := True;
  if Assigned(FOnFinalize) then
    FOnFinalize;
end;

procedure TAnimation.HideSubject;
begin
  TEngine2DObject(FSubject).Visible := False;
end;

procedure tAnimation.RecoverStart;
begin
  TEngine2DObject(FSubject).Position := FStartPos;
end;

procedure TAnimation.SetSubject(const Value: Pointer);
begin
  FSubject := Value;
  FStopped := False; //��������! ����� ������� ��������, �������� ��������� ���� �������������
//  FStartPos := tEngine2DObject(Value).Position;
end;

procedure tAnimation.Setup;
begin
  if Not Assigned(FSubject) then
    Exit;
  if Assigned(FOnSetup) then
    FOnSetup;
  FStartPos := TEngine2DObject(FSubject).Position;
  FSetupped := True;
end;

end.
