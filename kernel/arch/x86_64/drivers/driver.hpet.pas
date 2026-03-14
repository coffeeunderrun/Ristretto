unit Driver.Hpet;

interface

implementation

uses Device, Driver, SysUtils;

function MatchDevice(const DeviceDescriptor: TDeviceDescriptor): Integer; forward;
function ProbeDevice(const Device: PDevice): Boolean; forward;
function AttachDevice(const Device: PDevice): Boolean; forward;
procedure DetachDevice(const Device: PDevice); forward;

const
  HpetDriver: TDriver = (
    FName: 'HPET';
    FIdArr: (
      (Value: 'PNP0103')
    );

    Initialize: nil;
    Finalize: nil;

    MatchDevice: @MatchDevice;
    ProbeDevice: @ProbeDevice;
    AttachDevice: @AttachDevice;
    DetachDevice: @DetachDevice;
  ); public name '_driver_hpet';

function MatchDevice(const DeviceDescriptor: TDeviceDescriptor): Integer;
begin
  result := 0;
end;

function ProbeDevice(const Device: PDevice): Boolean;
begin
  result := false;
end;

function AttachDevice(const Device: PDevice): Boolean;
begin
  result := false;
end;

procedure DetachDevice(const Device: PDevice);
begin
end;

end.
