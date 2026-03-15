unit DeviceMgr;

interface

uses Device;

procedure RegisterDevice(const Descriptor: TDeviceDescriptor);

implementation

uses SysUtils;

var
  DeviceArr: array of TDevice;

procedure RegisterDevice(const Descriptor: TDeviceDescriptor);
begin
  SetLength(DeviceArr, Length(DeviceArr) + 1);
  DeviceArr[High(DeviceArr)].Initialize(Descriptor, nil);
  if Length(Descriptor.IdArr) > 0 then Writeln(LogInfo, Format('Registered device: %s.', [Descriptor.IdArr[0].Value]));
end;

end.
