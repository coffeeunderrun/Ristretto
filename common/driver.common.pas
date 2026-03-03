unit Driver.Common;

interface

uses Device.Common;

type
  TDriverDescriptor = record
    PnpIdArr: array of PChar;
  end;

  PDriver = ^TDriver;
  TDriver = record
    Descriptor: TDriverDescriptor;

    Initialize: function: Boolean;
    Finalize: procedure;

    Probe: function(DeviceDescriptor: PDeviceDescriptor): Boolean;
    Attach: function(DeviceDescriptor: PDeviceDescriptor): Boolean;
    Detach: procedure(DeviceDescriptor: PDeviceDescriptor);
  end;

implementation

end.
