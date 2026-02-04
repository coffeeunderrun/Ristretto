program Kernel;

uses Arch, Framebuffer, Limine, Terminal;

{$define LIMINE_REQUEST_FRAMEBUFFER}
{$define LIMINE_REQUEST_HHDM}
{$define LIMINE_REQUEST_MEMORY_MAP}
{$define LIMINE_REQUEST_RSDP}
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
end.
