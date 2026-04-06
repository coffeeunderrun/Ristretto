unit Device;

{$modeswitch advancedrecords}

interface

uses Device.Common;

type
  PDevice = ^TDevice;
  PPDevice = ^PDevice;

  TDevice = record
  private
    FDescriptor: TDeviceDescriptor;
    FParent: PDevice;
    FChildArray: PPDevice;
    FChildCount: SizeUInt;
    FDriverPtr: Pointer;
    FLockPtr: Pointer;
    FReferenceCount: SizeUInt;

    function GetChild(Index: SizeUInt): PDevice;

  public
    property Descriptor: TDeviceDescriptor read FDescriptor;
    property Parent: PDevice read FParent;
    property ChildArray[Index: SizeUInt]: PDevice read GetChild;
    property ChildCount: SizeUInt read FChildCount;

    constructor Create(constref ADescriptor: TDeviceDescriptor; const AParent: PDevice);
    procedure Finalize;

    procedure AddChild(const Child: PDevice);
    procedure RemoveChild(const Child: PDevice);

    procedure AddReference;
    procedure RemoveReference;

    procedure Lock;
    procedure Unlock;
  end;

implementation

uses SysUtils;

function TDevice.GetChild(Index: SizeUInt): PDevice;
begin
  if Assigned(FChildArray) and (Index < FChildCount) then
    result := FChildArray[Index]
  else
    result := nil;
end;

constructor TDevice.Create(constref ADescriptor: TDeviceDescriptor; const AParent: PDevice);
var
  DeviceIndex: SizeUInt;
begin
  WriteLn(LogTrace, 'TDevice.Create called.');

  with ADescriptor do begin
    FDescriptor.IdCount := IdCount;

    if Assigned(IdArray) then begin
      GetMem(FDescriptor.IdArray, IdCount * SizeOf(TDeviceId));

      for DeviceIndex := 0 to IdCount - 1 do begin
        if not Assigned(IdArray[DeviceIndex].Value) then continue;

        GetMem(FDescriptor.IdArray[DeviceIndex].Value, StrLen(IdArray[DeviceIndex].Value) + 1);
        Move(IdArray[DeviceIndex].Value^, FDescriptor.IdArray[DeviceIndex].Value^, StrLen(IdArray[DeviceIndex].Value) + 1);

        {$ifndef NDEBUG}
        WriteLn(LogDebug, Format('Device ID: %s.', [FDescriptor.IdArray[DeviceIndex].Value]));
        {$endif}
      end;
    end;
  end;

  FParent := AParent;
  FChildArray := nil;
  FChildCount := 0;
  FDriverPtr := nil;
  FLockPtr := nil;
  FReferenceCount := 0;
end;

procedure TDevice.Finalize;
var
  DeviceIndex: SizeUInt;
begin
  WriteLn(LogTrace, 'TDevice.Finalize called.');

  with FDescriptor do begin
    if Assigned(IdArray) then begin
      for DeviceIndex := 0 to IdCount - 1 do
        if Assigned(IdArray[DeviceIndex].Value) then FreeMem(IdArray[DeviceIndex].Value);
      FreeMem(IdArray);
    end;
  end;

  if Assigned(FParent) then FParent^.RemoveChild(@Self);
  if Assigned(FChildArray) then FreeMem(FChildArray);
  if Assigned(FLockPtr) then FreeMem(FLockPtr);
end;

procedure TDevice.AddChild(const Child: PDevice);
begin
  WriteLn(LogTrace, 'TDevice.AddChild called.');
end;

procedure TDevice.RemoveChild(const Child: PDevice);
begin
  WriteLn(LogTrace, 'TDevice.RemoveChild called.');
end;

procedure TDevice.AddReference;
begin
  InterlockedIncrement64(FReferenceCount);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Device reference count increased: %d.', [FReferenceCount]));
  {$endif}
end;

procedure TDevice.RemoveReference;
begin
  InterlockedDecrement64(FReferenceCount);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Device reference count decreased: %d.', [FReferenceCount]));
  {$endif}
end;

procedure TDevice.Lock;
begin
  WriteLn(LogTrace, 'TDevice.Lock called.');
end;

procedure TDevice.Unlock;
begin
  WriteLn(LogTrace, 'TDevice.Unlock called.');
end;

end.
