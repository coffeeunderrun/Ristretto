function ReadIoPort8(Port: UInt16): UInt8; assembler; nostackframe;
asm
  mov dx, Port
  in al, dx
end;

function ReadIoPort16(Port: UInt16): UInt16; assembler; nostackframe;
asm
  mov dx, Port
  in ax, dx
end;

function ReadIoPort32(Port: UInt16): UInt32; assembler; nostackframe;
asm
  mov dx, Port
  in eax, dx
end;

procedure WriteIoPort8(Port: UInt16; Value: UInt8); assembler; nostackframe;
asm
  mov dx, Port
  mov al, Value
  out dx, al
end;

procedure WriteIoPort16(Port: UInt16; Value: UInt16); assembler; nostackframe;
asm
  mov dx, Port
  mov ax, Value
  out dx, ax
end;

procedure WriteIoPort32(Port: UInt16; Value: UInt32); assembler; nostackframe;
asm
  mov dx, Port
  mov eax, Value
  out dx, eax
end;
