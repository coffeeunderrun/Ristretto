program Kernel;

uses Limine, Framebuffer, Terminal;

const
  LimineBeginRequests: array[0..3] of UInt64 = ($F6B8F4B39DE7D1AE, $FAB91A6940FCB9CF, $785C6ED015D3E316, $181E920A7852B9D9); export;
  LimineRequestBaseRevision: array[0..3] of UInt64 = ($F9562B2D5C95A6C8, $6A7B384944536BDC, 4, 0); export;

  LimineRequestFramebuffer: TLimineFramebufferRequest = (
    Id: ($C7B1DD30DF4C8B88, $0A82E883A194F07B, $9D5827DCD881DD75, $A3148604F6FAB11B)
  ); export;

  LimineEndRequests: array[0..1] of UInt64 = ($ADC0E0531BB10D03, $9572709F31764C62); export;

procedure Halt(); assembler; nostackframe;
asm
@loop:
  hlt
  jmp @loop
end;

begin
  if LimineRequestBaseRevision[2] <> 0 then Halt;

  Framebuffer.Initialize;
  Framebuffer.Clear(ColorBlack);

  Terminal.Initialize;
  Terminal.PutText(0, 0, ColorYellow, ColorBlack, 'Ristretto v0.1');

  Halt;
end.
