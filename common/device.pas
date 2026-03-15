unit Device;

{$modeswitch advancedrecords}

interface

type
  TDeviceId = record
    Value: PChar;
  end;

  TDeviceDescriptor = record
    IdArr: array of TDeviceId;
  end;

  PDevice = ^TDevice;
  PDeviceArray = array of PDevice;

  TDevice = record
  private
    FDescriptor: TDeviceDescriptor;
    FParent: PDevice;
    FChildren: array of PDevice;
    FDriverPtr: Pointer;
    FLockPtr: Pointer;
    FReferenceCount: SizeUInt;

    class operator Initialize(var Device: TDevice);

  public
    property Descriptor: TDeviceDescriptor read FDescriptor;
    property Parent: PDevice read FParent;
    property Children: PDeviceArray read FChildren;
    property DriverPtr: Pointer read FDriverPtr;

    procedure Initialize(const ADescriptor: TDeviceDescriptor; const AParent: PDevice);
    procedure Finalize;

    procedure AddChild(const Child: PDevice);
    procedure AddReference;
    procedure RemoveReference;
    procedure Lock;
    procedure Unlock;
  end;

implementation

uses SysUtils;

class operator TDevice.Initialize(var Device: TDevice);
begin
  with Device do begin
    FDescriptor := default(TDeviceDescriptor);
    FParent := nil;
    FChildren := [];
    FDriverPtr := nil;
    FLockPtr := nil;
    FReferenceCount := 0;
  end;
  WriteLn(LogTrace, 'TDevice.Initialize called.');
end;

procedure TDevice.Initialize(const ADescriptor: TDeviceDescriptor; const AParent: PDevice);
var
  I: SizeUInt;
begin
  assert(Length(FDescriptor.IdArr) = 0, 'Length(FDescriptor.IdArr) = 0');

  FParent := AParent;
  if Assigned(FParent) then FParent^.AddChild(@Self);

  // Deep copy IDs if provided descriptor contains any.
  if (not Assigned(ADescriptor.IdArr)) or (Length(ADescriptor.IdArr) = 0) then exit;
  SetLength(FDescriptor.IdArr, Length(ADescriptor.IdArr));

  with ADescriptor do for I := 0 to High(IdArr) do begin
    if not Assigned(IdArr[I].Value) then continue;
    GetMem(FDescriptor.IdArr[I].Value, StrLen(IdArr[I].Value) + 1);
    Move(IdArr[I].Value^, FDescriptor.IdArr[I].Value^, StrLen(IdArr[I].Value) + 1);
    WriteLn(LogDebug, Format('Device ID: %s.', [FDescriptor.IdArr[I].Value]));
  end;
end;

procedure TDevice.Finalize;
var
  I: SizeUInt;
begin
  with FDescriptor do
    if Assigned(IdArr) and (Length(IdArr) > 0) then
      for I := 0 to High(IdArr) do
        if Assigned(IdArr[I].Value) then FreeMem(IdArr[I].Value);
end;

procedure TDevice.AddChild(const Child: PDevice);
begin
  SetLength(FChildren, Length(FChildren) + 1);
  FChildren[High(FChildren)] := Child;
end;

procedure TDevice.AddReference;
begin
  InterlockedIncrement64(FReferenceCount);
  WriteLn(LogDebug, Format('Device reference count increased: %d.', [FReferenceCount]));
end;

procedure TDevice.RemoveReference;
begin
  InterlockedDecrement64(FReferenceCount);
  WriteLn(LogDebug, Format('Device reference count decreased: %d.', [FReferenceCount]));
end;

procedure TDevice.Lock;
begin
end;

procedure TDevice.Unlock;
begin
end;

end.
