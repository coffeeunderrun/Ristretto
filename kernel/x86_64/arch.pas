unit Arch;

interface

{$I arch.inc}

implementation

{ Order of unit initialization is important }
uses Gdt, Idt, Pmm, Acpi;

end.
