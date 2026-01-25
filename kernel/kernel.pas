program Kernel;

uses Arch, Limine, Framebuffer, SysUtils, Terminal;

{$define LIMINE_REQUEST_FRAMEBUFFER}
{$I limine.inc}

const
  Logo: String =
    ' ______ __       __              __   __         '#10 +
    '|   __ |__.-----|  |_.----.-----|  |_|  |_.-----.'#10 +
    '|      |  |__ --|   _|   _|  -__|   _|   _|  _  |'#10 +
    '|___|__|__|_____|____|__| |_____|____|____|_____|'#10#10;

begin
  if not Limine.BaseRevisionSupported then exit;

  Terminal.Write(Logo);
  Terminal.Write('IntToStr Test: ' + IntToStr(3735928559) + #10);
  Terminal.Write('IntToHex Test: ' + IntToHex(3735928559) + #10);
end.
