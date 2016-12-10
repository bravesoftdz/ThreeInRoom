unit uLogicAssets;

interface

uses
  uSoObject, uSoTypes, uGeometryClasses, System.Math, uIntersectorMethods, uSoObjectDefaultProperties,
  uSoColliderObjectTypes, uAcceleration, uModelClasses;

type
  TFireKoef = record
    Left, Right: Single;
  end;

  TLogicAssets = class
  private
    class function MakeTurnToDestination(const AShip: TSoObject; const ADir, ATurnRate: Single): TFireKoef;
    class procedure MovingThroughSidesInner(ASoObject, AWorld: TSoObject);
  public
    class procedure OnTestMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    //(Sender: TObject; AEventArgs: TMouseEventArgs);
    class procedure MovingThroughSides(ASoObject: TSoObject);
    class procedure MovingByAcceleration(ASoObject: TSoObject);
    class procedure MovingToDestination(ASoObject: TSoObject);
    class procedure FollowTheShip(ASoObject: TSoObject);
    class procedure OnCollideAsteroid(ASender: TObject; AEvent: TObjectCollidedEventArgs);
    class procedure OnCollideShip(ASender: TObject; AEvent: TObjectCollidedEventArgs);
  end;

implementation

uses
  uModel, uSoSprite, uSoSound, uSoColliderObject, uSoMouseHandler;

{ TLogicAssets }

class procedure TLogicAssets.FollowTheShip(ASoObject: TSoObject);
var
  vShip: TSoObject;
begin
  vShip := ASoObject['Ship'].Val<TSoObject>;
  ASoObject.Center := vShip.Position.XY;
  ASoObject.Rotate := vShip.Position.Rotate;

  ASoObject[Rendition].Val<TSoSprite>.NextFrame;
  ASoObject[Rendition].Val<TSoSprite>.Opacity := 0.6 + Random(40) / 100;
end;

class function TLogicAssets.MakeTurnToDestination(const AShip: TSoObject;
  const ADir, ATurnRate: Single): TFireKoef;
var
  vTurnRate: Single;
begin
    vTurnRate := Min(Abs(ADir), ATurnRate);
    if (ADir < 0)  then
    begin
      AShip.Rotate := NormalizeAngle(AShip.Rotate - vTurnRate);
      Result.Left := 1;
      Result.Right := 0.4;
    end
    else begin
      AShip.Rotate := NormalizeAngle(AShip.Rotate + vTurnRate);
      Result.Left := 0.4;
      Result.Right := 1;
    end;

    if ((Abs(ADir) > 165) and (Abs(ADir) < 180)) or ((Abs(ADir) > 0) and (Abs(ADir) < 15)) then
    begin
      Result.Left := 1;
      Result.Right := 1;
    end;
end;

class procedure TLogicAssets.MovingByAcceleration(ASoObject: TSoObject);
var
  vAcceleration: TAcceleration;
begin
  with ASoObject do begin
    vAcceleration := ASoObject['Acceleration'].Val<TAcceleration>;
    X := X + vAcceleration.Dx;
    Y := Y + vAcceleration.Dy;
    Rotate := Rotate + vAcceleration.Da;
  end;
  MovingThroughSidesInner(ASoObject, ASoObject['World'].Val<TSoObject>);
end;

class procedure TLogicAssets.MovingThroughSidesInner(ASoObject, AWorld: TSoObject);
begin
  with ASoObject do begin
   if X < - Width then
     X := AWorld.Width + Width;

   if Y  < - Height then
     Y := AWorld.Height + Height;

   if X > AWorld.Width + Width  then
     X := - Width;

   if Y > AWorld.Height + Height then
     Y := - Height;
  end;
end;

class procedure TLogicAssets.MovingThroughSides(ASoObject: TSoObject);
begin
exit;
  ASoObject.X := ASoObject.X + Random * 3;
  ASoObject.Y := ASoObject.Y + Random * 3;
  ASoObject.Rotate := ASoObject.Rotate + Random * 2;
   MovingThroughSidesInner(ASoObject, ASoObject['World'].Val<TSoObject>);
end;

class procedure TLogicAssets.MovingToDestination(ASoObject: TSoObject);
var
 // vAcceleration: TAcceleration;
  vDest: TDestination;
  vAngle, vDir: Single;
  vDx, vDy: Single;
  vIsHere: Boolean;
  vRend: TSoSprite;
begin
  vDx := 2;
  vDy := 2;
  with ASoObject do begin
//    vAcceleration := ASoObject['Acceleration'].Val<TAcceleration>;
    vDest := ASoObject['Destination'].Val<TDestination>;

    vIsHere := True;
    if (X <= vDest.X + vDx) and (X >= vDest.X - vDx) then
    begin
      X := vDest.X;
    end else
      vIsHere := False;

    if (Y <= vDest.Y + vDy) and (Y >= vDest.Y - vDy) then
    begin
      Y := vDest.Y
    end else
      vIsHere := False;

    if vIsHere then
      Exit;


   if (X > vDest.X) then
   begin
     vDx := -Abs(vDx);
     ScaleX := -1;
   end else
    ScaleX := 1;

   if (Y > vDest.Y) then
   begin
     vDy := -Abs(vDy);
   end;

   X := X + vDx;
   Y := Y + vDy;

   vRend := ASoObject[Rendition].Val<TSoSprite>;
   vRend.NextFrame;

  end;
end;

class procedure TLogicAssets.OnCollideAsteroid(ASender: TObject; AEvent: TObjectCollidedEventArgs);
begin
//  TSoColliderObj(ASender).Subject[Sound].Val<TSoSound>.Play;
end;

class procedure TLogicAssets.OnCollideShip(ASender: TObject; AEvent: TObjectCollidedEventArgs);
begin
 // TSoColliderObj(ASender).Subject[Sound].Val<TSoSound>.Play;
end;

class procedure TLogicAssets.OnTestMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  vObj: TSoObject;
begin
  vObj := TSoMouseHandler(Sender).Subject;

  vObj.Properties[Collider].Val<TSoColliderObj>.ApplyForce((Random - 0.5) * 1000, (Random - 0.5) * 1000);
end;

end.
