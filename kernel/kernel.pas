program Kernel;

uses Limine, Log, Framebuffer, Terminal;

{$DEFINE LIMINE_REQUEST_FRAMEBUFFER}
{$I limine.inc}

procedure Halt; assembler; nostackframe;
asm
@loop:
  hlt
  jmp @loop
end;

begin
  if not Limine.BaseRevisionSupported then Halt;

  Framebuffer.Initialize;
  Framebuffer.Clear(ColorBlack);

  Terminal.Initialize;
  Terminal.Write('Ristretto v0.1' + #10);

  Halt;
end.
