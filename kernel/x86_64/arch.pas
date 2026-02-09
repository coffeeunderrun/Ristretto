unit Arch;

interface

procedure Initialize;

implementation

uses Cpu, Gdt, Idt, Paging;

procedure Initialize;
begin
  Cpu.Initialize;
  Gdt.Initialize;
  Idt.Initialize;
  Paging.Initialize;
end;

end.
