program Kernel;

uses Arch, Limine, Framebuffer, Terminal;

{$DEFINE LIMINE_REQUEST_FRAMEBUFFER}
{$I limine.inc}

const
  Logo: ShortString =
    ' ______ __       __              __   __         '#10 +
    '|   __ |__.-----|  |_.----.-----|  |_|  |_.-----.'#10 +
    '|      |  |__ --|   _|   _|  -__|   _|   _|  _  |'#10 +
    '|___|__|__|_____|____|__| |_____|____|____|_____|'#10#10;

begin
  if not Limine.BaseRevisionSupported then exit;

  Terminal.Write(Logo);
end.
