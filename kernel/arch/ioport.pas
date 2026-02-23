unit IoPort;

interface

function ReadIoPort8(Port: UInt16): UInt8; inline;
function ReadIoPort16(Port: UInt16): UInt16; inline;
function ReadIoPort32(Port: UInt16): UInt32; inline;

procedure WriteIoPort8(Port: UInt16; Value: UInt8); inline;
procedure WriteIoPort16(Port: UInt16; Value: UInt16); inline;
procedure WriteIoPort32(Port: UInt16; Value: UInt32); inline;

implementation

{$I ioport.inc}

end.
