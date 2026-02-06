uses Cpu, Gdt, Idt, Paging;

procedure Initialize;
begin
  Gdt.Initialize;
  Idt.Initialize;
  Cpu.Initialize;
  Paging.Initialize;
end;
