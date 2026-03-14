unit Driver;

{$modeswitch advancedrecords}

interface

uses Device;

type
  TDriverMatchFunc = function(const DeviceDescriptor: TDeviceDescriptor): Integer;
  TDriverProbeFunc = function(const Device: PDevice): Boolean;
  TDriverAttachFunc = function(const Device: PDevice): Boolean;
  TDriverDetachProc = procedure(const Device: PDevice);

  TDriverId = record
    Value: PChar;
  end;
  TDriverIdArray = array of TDriverId;

  PDriver = ^TDriver;
  TDriver = record
  private
    FName: PChar;
    FIdArr: TDriverIdArray;
  public
    property Name: PChar read FName;
    property IdArr: TDriverIdArray read FIdArr;

  public
    Initialize: function: Boolean;
    Finalize: procedure;

    MatchDevice: TDriverMatchFunc;
    ProbeDevice: TDriverProbeFunc;
    AttachDevice: TDriverAttachFunc;
    DetachDevice: TDriverDetachProc;
  end;

implementation

end.
