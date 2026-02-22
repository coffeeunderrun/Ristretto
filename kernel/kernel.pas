program Kernel;

{ SysUtils should be first to ensure heap is initialized before any units attempt to use it. }
uses SysUtils, Acpi, Arch, Terminal, Logger.Serial;

const
  Logo: String =
    ' ______ __       __              __   __         '#10 +
    '|   __ |__.-----|  |_.----.-----|  |_|  |_.-----.'#10 +
    '|      |  |__ --|   _|   _|  -__|   _|   _|  _  |'#10 +
    '|___|__|__|_____|____|__| |_____|____|____|_____|'#10;

begin
  Terminal.Initialize;
  Terminal.Clear;

  WriteLn(Logo);

  Arch.PerProcInitialize;
  Arch.OneTimeInitialize;
  Acpi.Initialize;
end.
