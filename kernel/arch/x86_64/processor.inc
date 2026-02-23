uses Cpu, Gdt, Tss;

procedure Initialize;
begin
  Cpu.Initialize;
  Gdt.Initialize;
  Tss.Initialize;
end;

{ TODO: Find a better place for these.}
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
