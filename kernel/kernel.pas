program Kernel;

uses Acpi, Arch, Log, Pmm, Terminal, Vmm;

const
  Logo: String =
    ' ______ __       __              __   __         '#10 +
    '|   __ |__.-----|  |_.----.-----|  |_|  |_.-----.'#10 +
    '|      |  |__ --|   _|   _|  -__|   _|   _|  _  |'#10 +
    '|___|__|__|_____|____|__| |_____|____|____|_____|'#10;

begin
  Terminal.Clear;
  Terminal.WriteLn(Logo);

  Log.Initialize;

  Arch.Initialize;
  Vmm.Initialize;
  Pmm.Initialize;
  Acpi.Initialize;
end.
