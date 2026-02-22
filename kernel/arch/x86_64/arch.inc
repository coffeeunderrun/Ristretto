uses Cpu, Gdt, Idt, Isr, Paging, Tss;

procedure OneTimeInitialize;
begin
  Idt.Initialize;
  Paging.Initialize;
end;

procedure PerProcInitialize;
begin
  Cpu.Initialize;
  Gdt.Initialize;
  Tss.Initialize;
end;

procedure LoadRootFrame(RootFrame: PtrUInt); assembler; nostackframe;
asm
  mov rax, RootFrame
  mov cr3, rax
end;

procedure InvalidatePage(Page: PtrUInt); assembler; nostackframe;
asm
  mov rax, Page
  invlpg [rax]
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

begin
  PAGE_SIZE := $1000;
end.
