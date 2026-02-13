program Kernel;

uses Acpi, Arch, Limine, Pmm, Terminal, Vmm;

{$define LIMINE_REQUEST_EXECUTABLE_ADDRESS}
{$define LIMINE_REQUEST_FRAMEBUFFER}
{$define LIMINE_REQUEST_HHDM}
{$define LIMINE_REQUEST_MEMORY_MAP}
{$define LIMINE_REQUEST_PAGING_MODE}
{$define LIMINE_REQUEST_RSDP}
{$I limine.inc}

const
  Logo: String =
    ' ______ __       __              __   __         '#10 +
    '|   __ |__.-----|  |_.----.-----|  |_|  |_.-----.'#10 +
    '|      |  |__ --|   _|   _|  -__|   _|   _|  _  |'#10 +
    '|___|__|__|_____|____|__| |_____|____|____|_____|'#10;

begin
  if not Limine.BaseRevisionSupported then Panic('Limine Base Revision not supported.');

  Terminal.Clear;
  Terminal.WriteLn(Logo);

  Arch.Initialize;
  Vmm.Initialize;
  Pmm.Initialize;
  Acpi.Initialize;
end.
