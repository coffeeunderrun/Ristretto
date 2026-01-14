program Kernel;

uses Cpu, Limine, Framebuffer, Terminal;

{$DEFINE LIMINE_REQUEST_FRAMEBUFFER}
{$I limine.inc}

const
  Logo: PChar =
  '     _     _           _   _       '#10 +
  ' ___|_|___| |_ ___ ___| |_| |_ ___ '#10 +
  '|  _| |_ -|  _|  _| -_|  _|  _| _ |'#10 +
  '|_| |_|___|_| |_| |___|_| |_| |___|'#10#10;

begin
  if not Limine.BaseRevisionSupported then Halt;

  Framebuffer.Initialize;

  Terminal.Initialize;
  Terminal.Write(Logo);

  Cpu.Initialize;

  Halt;
end.
