unit uEngine2DUnclickableObject;

interface

uses
  FMX.Objects, System.Types, System.Generics.Collections,
  uEngine2DClasses, uGeometryClasses;

type
  // ������� ����� ��� ������� ��������� ������
  // Base class for SO Engine Object
  tEngine2DUnclickableObject = class abstract
  private
    function GetCenter: TPointF;
    procedure SetCenter(const Value: TPointF);
    function GetScalePoint: TPointF;
    procedure SetScalePoint(const Value: TPointF);
  protected
    fPosition: TPosition;
    fVisible: Boolean; // ������������ ������ ��� ���
    fOpacity: Single; // ������������
    fSelectable: Boolean; // ��������� �� � ���������
    fImage: TImage;
    fGroup: string;
    fClonedFrom: tEngine2DUnclickableObject;
    function GetW: single; virtual; abstract;
    function GetH: single; virtual; abstract;

    procedure SetPosition(const Value: TPosition);
    procedure SetX(AValue: single); virtual;
    procedure SetY(AValue: single); virtual;
    procedure SetScaleX(const Value: single); virtual;
    procedure SetScaleY(const Value: single); virtual;
    procedure SetScale(AValue: single); virtual;
    procedure SetRotate(AValue: single); virtual;
    procedure SetOpacity(const Value: single); virtual;
  public
    // ����������� ��������
    property Image: TImage read fImage write fImage; // � ���� ������ ���������� ���������.

    // Geometrical properties �������������� ��������
    property Position: TPosition read fPosition write SetPosition; // ������� ��������� ���� ������ � ������� �������
    property x: single read fPosition.x write setX; // ���������� X �� ������� �������
    property y: single read fPosition.y write setY; // ���������� Y �� ������� �������
    property Center: TPointF read GetCenter write SetCenter;
    property ScalePoint: TPointF read GetScalePoint write SetScalePoint;
    property w: single read getW; // ������������ ������
    property h: single read getH; // ������������ ������
    property Rotate: single read fPosition.rotate write setRotate; // ���� �������� ������������ ������
    property ScaleX: single read fPosition.ScaleX write setScaleX;  // ������� ������� �� ����� ���������
    property ScaleY: single read fPosition.scaleY write setScaleY;  // ������� ������� �� ����� ���������
    property Scale: single write setScale;  // ������� ������� �� ����� ���������

    // Parametres for classification and modification of Object ��������� ���  ������������� � �����������
    property Group: string read fGroup write fGroup; // ������ ��� �������� ������� - �������� ��������
    property Opacity: single read fOpacity write SetOpacity; // ������������
    property Visible: boolean read fVisible write fVisible; // ������� ������ ��� ���
    property Selectable: boolean read fSelectable write fSelectable; // ������� ������ ��� ���

    procedure Repaint; virtual; abstract; // ��������� ��������� �������, �������������� �������� ��� ������� � �.�.

    constructor Create; virtual;
    destructor Destroy; override;
  end;

implementation

uses
  uEngine2D;

{ t2dEngineObject }

constructor tEngine2DUnclickableObject.Create;
begin
  fPosition.ScaleX := 1;
  fPosition.ScaleY := 1;
  fPosition.rotate := 0;
  fPosition.x := 0;
  fPosition.y := 0;
  Self.Opacity := 1;
  fVisible := true;
  fSelectable := true;
end;

destructor tEngine2DUnclickableObject.Destroy;
begin
  fImage := Nil;
end;

function tEngine2DUnclickableObject.GetCenter: TPointF;
begin
  Result := PointF(Position.X, Position.Y);
end;

function tEngine2DUnclickableObject.GetScalePoint: TPointF;
begin
  Result := PointF(FPosition.ScaleX, FPosition.ScaleY)
end;

{procedure tEngine2DUnclickableObject.Format;
begin
  if fFormatter.Text = '' then
    Exit;


  if fFormatter.x <> Nil then
    Self.x := fFormatter.X.Value;
  if fFormatter.y <> Nil then
    Self.y := fFormatter.y.Value;
  if fFormatter.Width <> Nil then
    Self.w := fFormatter.Width.Value;
  if fFormatter.Height <> Nil then
    Self.h := fFormatter.Height.Value;
  if fFormatter.MinWidth <> Nil then
    if Self.h * Self.Scale < fFormatter.MinWidth.Value then
      fFo
    Self.h := fFormatter.Height.Value;

end; }

{ne2DUnclickableObject.sendToFront;
begin

//  tEngine2d(fParent).spriteToFront(fCreationNumber);
end; }

{procedure tEngine2DUnclickableObject.SetAnimation(AValue: tAnimation);
begin
  fAnimation := AValue;
  fAnimation.Init;
end;                      }

procedure tEngine2DUnclickableObject.SetCenter(const Value: TPointF);
begin
  Self.X := Value.X;
  Self.Y:= Value.Y
end;

procedure tEngine2DUnclickableObject.SetOpacity(const Value: Single);
begin
  fOpacity := Value;
end;

procedure tEngine2DUnclickableObject.SetPosition(const Value: TPosition);
begin
  fPosition := Value;
end;

procedure tEngine2DUnclickableObject.setRotate(AValue: Single);
begin
  fPosition.rotate := AValue;
end;

procedure tEngine2DUnclickableObject.setScale(AValue: Single);
var
  vSoot: Single;
begin
  if (fPosition.ScaleX) <> 0 then
  begin
    vSoot := fPosition.ScaleY / fPosition.scaleX;
  end
  else begin
    vSoot := 1;
  end;

  fPosition.scaleX := AValue;
  fPosition.scaleY := vSoot * AValue;
end;

procedure tEngine2DUnclickableObject.SetScalePoint(const Value: TPointF);
begin
  Self.ScaleX := Value.X;
  Self.ScaleY:= Value.Y
end;

procedure tEngine2DUnclickableObject.setScaleX(const Value: Single);
begin
  fPosition.ScaleX := Value;
end;

procedure tEngine2DUnclickableObject.setScaleY(const Value: single);
begin
  fPosition.scaleY := Value;
end;

procedure tEngine2DUnclickableObject.setX(AValue: single);
begin
  fPosition.x := AValue;
end;

procedure tEngine2DUnclickableObject.setY(AValue: single);
begin
  fPosition.y := AValue;
end;

end.







