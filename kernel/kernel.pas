program Kernel;

uses Limine, Framebuffer, Terminal;

{$DEFINE LIMINE_REQUEST_FRAMEBUFFER}
{$I limine.inc}

procedure Halt(); assembler; nostackframe;
asm
@loop:
  hlt
  jmp @loop
end;

var
  Ch: Char;

begin
  if not Limine.BaseRevisionSupported then Halt;

  Framebuffer.Initialize;
  Framebuffer.Clear(ColorBlack);

  Terminal.Initialize;
  Terminal.Write('Ristretto v0.1' + #10, ColorYellow);

  for Ch := #0 to #255 do begin
    Terminal.Write(PChar(@Ch));
  end;

  Halt;
end.
