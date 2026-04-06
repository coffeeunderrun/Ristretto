unit Device.Common;

interface

type
  PDeviceId = ^TDeviceId;
  TDeviceId = record
    Value: PChar;
  end;

  TDeviceDescriptor = record
    IdArray: PDeviceId;
    IdCount: SizeUInt;
  end;

implementation

end.
