unit Driver.Common;

interface

uses Device.Common;

type
  PDriverId = ^TDriverId;
  TDriverId = record
    Value: PChar;
  end;

  PDriverDescriptor = ^TDriverDescriptor;
  TDriverDescriptor = record
    Name: PChar;
    IdArray: PDriverId;
    IdCount: SizeUInt;
  end;

  PDriverOperations = ^TDriverOperations;
  TDriverOperations = record
    Initialize: function: Boolean; cdecl;
    Finalize: procedure; cdecl;

    MatchDevice: function(constref DeviceDescriptor: TDeviceDescriptor): Cardinal; cdecl;
    ProbeDevice: function(constref DeviceDescriptor: TDeviceDescriptor): Boolean; cdecl;
    AttachDevice: function(constref DeviceDescriptor: TDeviceDescriptor): Boolean; cdecl;
    DetachDevice: procedure(constref DeviceDescriptor: TDeviceDescriptor); cdecl;
  end;

  PDriverInformation = ^TDriverInformation;
  TDriverInformation = record
    AbiVersion: Cardinal;
    Descriptor: PDriverDescriptor;
    Operations: PDriverOperations;
  end;

implementation

end.
