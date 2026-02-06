unit Arch;

interface

procedure Initialize;

implementation

uses Gdt, Idt, Paging;

procedure Initialize;
begin
  Gdt.Initialize;
  Idt.Initialize;
  Paging.Initialize;
end;

end.
