unit Driver.Hpet;

interface

implementation

uses SysUtils, Device.Common, Driver.Common;

function MatchDevice(constref DeviceDescriptor: TDeviceDescriptor): Cardinal; cdecl; forward;
function ProbeDevice(constref DeviceDescriptor: TDeviceDescriptor): Boolean; cdecl; forward;
function AttachDevice(constref DeviceDescriptor: TDeviceDescriptor): Boolean; cdecl; forward;
procedure DetachDevice(constref DeviceDescriptor: TDeviceDescriptor); cdecl; forward;

const
  DriverIdArray: array [0..0] of TDriverId = (
    (Value: 'PNP0103')
  );

  DriverDescriptor: TDriverDescriptor = (
    Name: 'HPET';
    IdArray: @DriverIdArray;
    IdCount: SizeOf(DriverIdArray) div SizeOf(TDriverId);
  );

  DriverOperations: TDriverOperations = (
    Initialize: nil;
    Finalize: nil;

    MatchDevice: @MatchDevice;
    ProbeDevice: @ProbeDevice;
    AttachDevice: @AttachDevice;
    DetachDevice: @DetachDevice;
  );

  DriverInformation: TDriverInformation = (
    AbiVersion: 1;
    Descriptor: @DriverDescriptor;
    Operations: @DriverOperations;
  ); public name '_driver_info_hpet';

function MatchDevice(constref DeviceDescriptor: TDeviceDescriptor): Cardinal; cdecl;
begin
  WriteLn(LogTrace, 'HpetDriver.MatchDevice called.');
  result := 0;
end;

function ProbeDevice(constref DeviceDescriptor: TDeviceDescriptor): Boolean; cdecl;
begin
  WriteLn(LogTrace, 'HpetDriver.ProbeDevice called.');
  result := false;
end;

function AttachDevice(constref DeviceDescriptor: TDeviceDescriptor): Boolean; cdecl;
begin
  WriteLn(LogTrace, 'HpetDriver.AttachDevice called.');
  result := false;
end;

procedure DetachDevice(constref DeviceDescriptor: TDeviceDescriptor); cdecl;
begin
  WriteLn(LogTrace, 'HpetDriver.DetachDevice called.');
end;

end.

      IdArray: @DriverIdArray;
      IdCount: SizeOf(DriverIdArray) div SizeOf(TDriverId);
    );
    Operations: (
      Initialize: nil;
      Finalize: nil;

      MatchDevice: @MatchDevice;
      ProbeDevice: @ProbeDevice;
      AttachDevice: @AttachDevice;
      DetachDevice: @DetachDevice;
    );
  ); public name '_driver_info_hpet';

function MatchDevice(constref DeviceDescriptor: TDeviceDescriptor): Cardinal; cdecl;
begin
  WriteLn(LogTrace, 'HpetDriver.MatchDevice called.');
  result := 0;
end;

function ProbeDevice(constref DeviceDescriptor: TDeviceDescriptor): Boolean; cdecl;
begin
  WriteLn(LogTrace, 'HpetDriver.ProbeDevice called.');
  result := false;
end;

function AttachDevice(constref DeviceDescriptor: TDeviceDescriptor): Boolean; cdecl;
begin
  WriteLn(LogTrace, 'HpetDriver.AttachDevice called.');
  result := false;
end;

procedure DetachDevice(constref DeviceDescriptor: TDeviceDescriptor); cdecl;
begin
  WriteLn(LogTrace, 'HpetDriver.DetachDevice called.');
end;

end.
