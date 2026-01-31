program Kernel;

uses Arch, Limine, Framebuffer, Terminal, Uacpi;

{$define LIMINE_REQUEST_FRAMEBUFFER}
{$define LIMINE_REQUEST_RSDP}
{$I limine.inc}

const
  Logo: String =
    ' ______ __       __              __   __         '#10 +
    '|   __ |__.-----|  |_.----.-----|  |_|  |_.-----.'#10 +
    '|      |  |__ --|   _|   _|  -__|   _|   _|  _  |'#10 +
    '|___|__|__|_____|____|__| |_____|____|____|_____|'#10#10;

var
  Buffer: array [0..4095] of Byte;
  Status: UacpiStatus;

begin
  if not Limine.BaseRevisionSupported then exit;

  Terminal.Write(Logo);

  Status := UacpiSetupEarlyTableAccess(@Buffer, SizeOf(Buffer));
end.
