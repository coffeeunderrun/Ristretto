unit DeviceMgr;

interface

uses Device.Common;

procedure RegisterDevice(const Device: TDevice);

implementation

var
  DeviceArr: array of TDevice;

procedure RegisterDevice(const Device: TDevice);
begin
  SetLength(DeviceArr, Length(DeviceArr) + 1);
  DeviceArr[High(DeviceArr)] := Device;
  if Length(Device.Descriptor.PnpIdArr) > 0 then Writeln(LogInfo, 'Registered device: ', Device.Descriptor.PnpIdArr[0]);
end;

end.
