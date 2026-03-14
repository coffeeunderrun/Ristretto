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
  public
    property Descriptor: TDeviceDescriptor read FDescriptor;
    property Parent: PDevice read FParent;
    property Children: PDeviceArray read FChildren;
    property DriverPtr: Pointer read FDriverPtr;

    class operator Initialize(var Device: TDevice);
    class operator Finalize(var Device: TDevice);

    constructor Create(const ADescriptor: TDeviceDescriptor; const AParent: PDevice);

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
  Device.FDescriptor := default(TDeviceDescriptor);
  Device.FParent := nil;
  Device.FChildren := [];
  Device.FDriverPtr := nil;
  Device.FLockPtr := nil;
  Device.FReferenceCount := 0;
end;

class operator TDevice.Finalize(var Device: TDevice);
var
  I: SizeUInt;
begin
  with Device.FDescriptor do begin
    if (not Assigned(IdArr)) or (Length(IdArr) = 0) then exit;

    for I := 0 to High(IdArr) do begin
      if not Assigned(IdArr[I].Value) then continue;
      FreeMem(IdArr[I].Value);
    end;
  end;
end;

constructor TDevice.Create(const ADescriptor: TDeviceDescriptor; const AParent: PDevice);
var
  I: SizeUInt;
begin
  if Assigned(FParent) then FParent^.AddChild(@Self);
  if (not Assigned(ADescriptor.IdArr)) or (Length(ADescriptor.IdArr) = 0) then exit;

  SetLength(FDescriptor.IdArr, Length(ADescriptor.IdArr));

  // Deep copy ID strings from provided descriptor.
  with ADescriptor do for I := 0 to High(IdArr) do begin
    if not Assigned(IdArr[I].Value) then continue;
    GetMem(FDescriptor.IdArr[I].Value, StrLen(IdArr[I].Value) + 1);
    Move(IdArr[I].Value^, FDescriptor.IdArr[I].Value^, StrLen(IdArr[I].Value) + 1);
    WriteLn(LogDebug, Format('Device ID: %s.', [FDescriptor.IdArr[I].Value]));
  end;
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
