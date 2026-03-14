unit DriverMgr;

interface

uses Driver;

procedure Initialize;

implementation

uses SysUtils;

var
  DriverStart: Pointer; external name '_driver_start';
  DriverEnd: Pointer; external name '_driver_end';
  DriverArr: array of PDriver;
  DriverCount: SizeUInt;

procedure Initialize;
var
  DriverPtr: PDriver;
begin
  SetLength(DriverArr, (PtrUInt(@DriverEnd) - PtrUInt(@DriverStart)) div SizeOf(TDriver));
  DriverCount := 0;

  WriteLn(LogDebug, Format('Built-in drivers: start=$%P, end=$%P, count=%d.', [@DriverStart, @DriverEnd, Length(DriverArr)]));

  // Load built-in drivers from the linker section.
  DriverPtr := PDriver(@DriverStart);
  while DriverPtr < PDriver(@DriverEnd) do begin
    DriverArr[DriverCount] := DriverPtr;
    Inc(DriverCount);
    WriteLn(LogInfo, Format('Driver registered: %s.', [DriverPtr^.Name]));

    if Assigned(DriverPtr) and Assigned(DriverPtr^.Initialize) then DriverPtr^.Initialize;
    Inc(DriverPtr);
  end;

  WriteLn(LogInfo, 'Drivers initialized.');
end;

end.
