unit uConstantGroup;

interface

uses
  System.SysUtils,
  uParserValue, uTextProc, uFastFields;

type
  // ����������� ��������, ���������� ��� ���������
  TConstantValue = class(TValue)
  public
    constructor Create(const AValue: String); reintroduce; virtual;
  end;

  TVariable = class(TConstantValue)
  strict private
//    FPlacedValue: Double;
//    FLowName: String; // ������� ��� � ������ ��������
    FPlaced: Boolean;
    FValue: TValue;
    FValueStack: TFastFields;
    function GetName: string;
//    procedure PlaceValue(const AValue: Double);// ������ ������ Text
  public
//    property LowName: string read FlowName; // �������� ��� �� ���� ����� ����������
    property Name: string read GetName; // �������� ��� �� ���� ����� ����������
    property ValueStack: TFastFields read FValueStack write FValueStack;
    //procedure PlaceValue(const AValue: TValue);
    function Value: Double; override;
    constructor Create(const AValue: String); override;
  end;



  TDouble = class(TConstantValue)
  public
    function Value: Double; override;
  end;

implementation

{ TVariable }

constructor TVariable.Create(const AValue: String);
begin
  inherited;
  Text := AValue;
//  FLowName := LowerCase(AValue);
  FPlaced := False;
  Self.BoundLeft := 1;
  Self.BoundRight := Length(AValue)
end;

function TVariable.GetName: string;
begin
  Result := LowerCase(Self.Text);
end;

{procedure TVariable.PlaceValue(const AValue: Double);
begin
  FPlaced := True;
  FPlacedValue := AValue;
end; }

function TVariable.Value: Double;
begin
  if not FPlaced then
  begin
    if FValueStack = Nil then
      raise Exception.Create('�� ����� ���� �������� ��� ��������������� ���������.');

    if FValueStack.IsHere(Name) then
    begin
      FValue := FValueStack.Items[Name];
      FPlaced := True;
    end else
      raise Exception.Create('�� ������ �������� ���������� �' + Name + '�');
  end;

   Result := FValue.Value;
{ ������� ���� ��� ������ �����������. �� �� �� �����.
  if FPlaced then
    Result := FPlacedValue
  else
    raise Exception.Create('�� ������ �������� ���������� �' + Name + '�');}
end;

{ TDouble }

function TDouble.Value: Double;
var
  vA: Double;
  vErr: Integer;
begin
  Val(Text, vA, vErr);

  if vErr = 0 then
    Result := vA
  else
    raise Exception.Create('������ ������������� ��������, ���������� ��������� � ����� � ��������� ������ �' + Text + '�');
end;

{ TConstantValue }

constructor TConstantValue.Create(const AValue: String);
begin
  Text := AValue;
end;

end.
