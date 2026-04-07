unit Device.Manager;

interface

uses Device.Common;

procedure Initialize;

procedure RegisterDevice(const DeviceDescriptor: TDeviceDescriptor);

implementation

uses SysUtils, Device;

var
  DeviceArray: array of PDevice;

procedure Initialize;
begin
  WriteLn(LogInfo, 'Device.Manager initialized.');
end;

procedure RegisterDevice(const DeviceDescriptor: TDeviceDescriptor);
var
  Device: PDevice;
  DeviceIndex: SizeUInt;
  WasAssigned: Boolean;
begin
  New(Device);
  Device^.Create(DeviceDescriptor, nil);

  // Try to add device to empty array slot if available.
  WasAssigned := false;
  if Length(DeviceArray) > 0 then
    for DeviceIndex := 0 to High(DeviceArray) do
      if not Assigned(DeviceArray[DeviceIndex]) then begin
        DeviceArray[DeviceIndex] := Device;
        WasAssigned := true;
        break;
      end;

  // Append device to end of array if no empty slot was found.
  if not WasAssigned then begin
    SetLength(DeviceArray, Length(DeviceArray) + 1);
    DeviceArray[High(DeviceArray)] := Device;
  end;

  if Device^.Descriptor.IdCount > 0 then
    WriteLn(LogInfo, Format('Register device: %s.', [Device^.Descriptor.IdArray[0].Value]));
end;

end.
