unit Driver.Hpet;

interface

implementation

uses Device.Common, Driver.Common, SysUtils;

function Probe(DeviceDescriptor: PDeviceDescriptor): Boolean; forward;
function Attach(DeviceDescriptor: PDeviceDescriptor): Boolean; forward;
procedure Detach(DeviceDescriptor: PDeviceDescriptor); forward;

const
  HpetDriver: TDriver = (
    Descriptor: (
      PnpIdArr: ('PNP0103');
    );

    Initialize: nil;
    Finalize: nil;

    Probe: @Probe;
    Attach: @Attach;
    Detach: @Detach;
  ); public name '_driver_hpet';

function Probe(DeviceDescriptor: PDeviceDescriptor): Boolean;
var
  DevIndex, DrvIndex: SizeInt;
begin
  if not Assigned(DeviceDescriptor) then exit(false);
  if Length(DeviceDescriptor^.PnpIdArr) = 0 then exit(false);

  for DevIndex := 0 to High(DeviceDescriptor^.PnpIdArr) do
    for DrvIndex := 0 to High(HpetDriver.Descriptor.PnpIdArr) do
      if DeviceDescriptor^.PnpIdArr[DevIndex] = HpetDriver.Descriptor.PnpIdArr[DrvIndex] then exit(true);

  result := false;
end;

function Attach(DeviceDescriptor: PDeviceDescriptor): Boolean;
begin
  result := true;
end;

procedure Detach(DeviceDescriptor: PDeviceDescriptor);
begin
end;

end.
