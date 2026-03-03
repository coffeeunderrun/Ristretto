unit Device.Common;

interface

type
  PDeviceResources = ^TDeviceResources;
  TDeviceResources = record
  end;

  PDeviceDescriptor = ^TDeviceDescriptor;
  TDeviceDescriptor = record
    PnpIdArr: array of PChar;
    Resources: PDeviceResources;
  end;

  PDevice = ^TDevice;
  TDevice = record
    Descriptor: TDeviceDescriptor;

    Parent: PDevice;
    Children: array of PDevice;

    LockPtr: Pointer;
    ReferenceCount: SizeUInt;
  end;

implementation

end.
