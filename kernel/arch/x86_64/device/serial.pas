unit Serial;

{ TODO:
  - Register interrupt handler dispatch.
  - Register with a device manager/API abstraction.
  - Implement read/write buffers. }

interface

procedure Initialize;

procedure Write(const Text: String); inline;
procedure Write(Data: Byte);

implementation

const
  COM1 = $3F8;

procedure Initialize; assembler; nostackframe;
asm
  mov dx, COM1 + 1
  mov al, 00000000b // Disable interrupts
  out dx, al

  mov dx, COM1 + 3
  mov al, 10000000b // Enable DLAB
  out dx, al

  // Set baud rate to 115200
  mov dx, COM1
  mov al, $01 // Divisor low byte
  out dx, al
  xor al, al  // Divisor high byte
  out dx, al

  // Parity=none, stop bits=1, data bits=8
  mov dx, COM1 + 3
  mov al, $03
  out dx, al

  // Enable and clear FIFOs, 14-byte receive IRQ trigger
  mov dx, COM1 + 2
  mov al, 11000111b
  out dx, al

  // Loopback mode for testing
  mov dx, COM1 + 4
  mov al, 00010000b
  out dx, al

  // Test COM port
  mov dx, COM1
  mov al, $AA
  out dx, al
  in al, dx
  cmp al, $AA
  jne @init_failed

  // RTS/DSR, out 2 for interrupts
  mov dx, COM1 + 4
  mov al, 00001011b
  out dx, al

@init_failed:
end;

procedure Write(const Text: String);
var
  Ch: Char;
begin
  for Ch in Text do Write(Ord(Ch));
end;

procedure Write(Data: Byte); assembler; nostackframe;
asm
  mov dx, $3FD
@wait_for_thre:
  in al, dx
  test al, $20
  jz @wait_for_thre

  mov dx, $3F8
  mov al, Data
  out dx, al
end;

begin
  Initialize;
  WriteLn(LogInfo, 'Serial initialized.');
end.
