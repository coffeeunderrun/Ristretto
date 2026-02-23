program Kernel;

{ SysUtils should be first to ensure heap is initialized before any units attempt to use it. }
uses SysUtils, Terminal, Logger.Serial, Processor, Interrupts, Paging, Vmm, Pmm, Acpi;

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

  Processor.Initialize;
  Interrupts.Initialize;
  Vmm.Initialize;
  Pmm.Initialize;
  Acpi.Initialize;

  WriteLn(LogTrace, 'Kernel initialization complete.');
end.
