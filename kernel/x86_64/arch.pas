unit Arch;

interface

procedure Initialize;

implementation

uses Color, Cpu, Gdt, Idt, Paging, Terminal;

procedure Initialize;
begin
  Cpu.Initialize;
  Gdt.Initialize;
  Idt.Initialize;
  Paging.Initialize;
end;

procedure Panic; noreturn; public name '_arch_panic';
begin
  Halt;
end;

procedure Panic(Msg: String); noreturn; public name '_arch_panic_msg';
begin
  Terminal.Write('Panic: ' + Msg, ColorWhite, ColorLightRed);
  Halt;
end;

end.
