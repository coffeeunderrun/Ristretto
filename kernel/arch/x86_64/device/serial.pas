unit Serial;

{ TODO:
  - Register interrupt handler dispatch.
  - Register with a device manager/API abstraction.
  - Implement read/write buffers. Would TMemoryStream (object) work here? }

interface

procedure Initialize;

procedure Write(const Text: String);

implementation

uses Ports;

procedure Initialize;
begin
  { TODO: Initialize the serial port. }
end;

procedure Write(const Text: String);
var
  Ch: Char;
begin
  for Ch in Text do begin
    while (Port[$3FD] and $20) = 0 do;
    Port[$3F8] := Byte(Ch);
  end;
end;

end.
