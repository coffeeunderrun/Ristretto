unit Driver.Manager;

interface

uses Driver.Common;

procedure Initialize;

procedure RegisterDriver(constref DriverInformation: TDriverInformation);

implementation

uses SysUtils, Driver;

var
  DriverInfoStart: Pointer; external name '_driver_info_start';
  DriverInfoEnd: Pointer; external name '_driver_info_end';
  DriverArray: array of PDriver;
  DriverCount: SizeUInt;

procedure Initialize;
var
  DriverInformation: PDriverInformation;
  DriverIndex: SizeUInt;
begin
  DriverCount := (PtrUInt(@DriverInfoEnd) - PtrUInt(@DriverInfoStart)) div SizeOf(TDriverInformation);
  SetLength(DriverArray, DriverCount);

  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Built-in drivers: start=$%P, end=$%P, count=%d.', [@DriverInfoStart, @DriverInfoEnd, DriverCount]));
  {$endif}

  // Load built-in drivers from the linker section.
  DriverInformation := PDriverInformation(@DriverInfoStart);
  for DriverIndex := 0 to DriverCount - 1 do RegisterDriver(DriverInformation[DriverIndex]);
  // begin
  //   DriverArray[DriverIndex] := @Driver[DriverIndex];
  //   assert(Assigned(DriverArray[DriverIndex]), 'Assigned(DriverArray[DriverIndex])');

  //   WriteLn(LogInfo, Format('Register driver: %s.', [DriverArray[DriverIndex]^.Descriptor.Name]));

  //   // if Assigned(DriverArray[DriverIndex]^.Initialize) then DriverArray[DriverIndex]^.Initialize;
  //   // if Assigned(OnDriverRegistered) then OnDriverRegistered(DriverArray[DriverIndex]);
  // end;

  WriteLn(LogInfo, 'Driver.Manager initialized.');
end;

procedure RegisterDriver(constref DriverInformation: TDriverInformation);
var
  Driver: PDriver;
  DriverIndex: SizeUInt;
  WasAssigned: Boolean;
begin
  New(Driver);
  Driver^.Create(DriverInformation);

  // Try to add driver to empty array slot if available.
  WasAssigned := false;
  if Length(DriverArray) > 0 then
    for DriverIndex := 0 to High(DriverArray) do
      if not Assigned(DriverArray[DriverIndex]) then begin
        DriverArray[DriverIndex] := Driver;
        WasAssigned := true;
        break;
      end;

  // Append driver to end of array if no empty slot was found.
  if not WasAssigned then begin
    SetLength(DriverArray, Length(DriverArray) + 1);
    DriverArray[High(DriverArray)] := Driver;
  end;

  if Driver^.Descriptor.IdCount > 0 then
    WriteLn(LogInfo, Format('Register driver: %s.', [Driver^.Descriptor.IdArray[0].Value]));
end;

end.
