unit DriverMgr;

interface

procedure Initialize;

implementation

uses Driver.Common, SysUtils;

var
  DriverStart: Pointer; external name '_driver_start';
  DriverEnd: Pointer; external name '_driver_end';
  DriverArr: array of PDriver;
  DriverCount: SizeInt;

procedure Initialize;
var
  DriverPtr: PDriver;
begin
  SetLength(DriverArr, (PtrUInt(@DriverEnd) - PtrUInt(@DriverStart)) div SizeOf(TDriver));
  DriverCount := 0;

  WriteLn(LogDebug, Format('Built-in drivers: start=$%P, end=$%P, count=%d.', [@DriverStart, @DriverEnd, Length(DriverArr)]));

  DriverPtr := PDriver(@DriverStart);
  while DriverPtr < PDriver(@DriverEnd) do begin
    DriverArr[DriverCount] := DriverPtr;
    Inc(DriverCount);
    WriteLn(LogInfo, Format('Driver registered: %s.', [DriverPtr^.Descriptor.PnpIdArr[0]]));

    if Assigned(DriverPtr) and Assigned(DriverPtr^.Initialize) then DriverPtr^.Initialize;
    Inc(DriverPtr);
  end;

  WriteLn(LogInfo, 'Drivers initialized.');
end;

end.
