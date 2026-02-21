unit Arch;

interface

procedure OneTimeInitialize;
procedure PerProcInitialize;

implementation

uses Color, Cpu, Gdt, Idt, Isr, Paging, Pmm, Tss, Vmm;

procedure OneTimeInitialize;
begin
  Idt.Initialize;
  Paging.Initialize;
  Vmm.Initialize;
  Pmm.Initialize;
end;

procedure PerProcInitialize;
begin
  Cpu.Initialize;
  Gdt.Initialize;
  Tss.Initialize;
end;

procedure Panic; noreturn; public name '_arch_panic';
begin
  WriteLn(LogFatal, 'Panic!');
  WriteLn('Panic!');
  Halt;
end;

procedure Panic(Msg: String); noreturn; public name '_arch_panic_msg';
begin
  WriteLn(LogFatal, 'Panic: ', Msg);
  WriteLn('Panic: ', Msg);
  Halt;
end;

end.
