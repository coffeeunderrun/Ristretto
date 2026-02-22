unit Acpi.Irq;

interface

implementation

uses SysUtils, Uacpi;

{$ifndef UACPI_BAREBONES_MODE}

function uacpi_kernel_install_interrupt_handler(
  Irq: Tuacpi_u32;
  Handler: Tuacpi_interrupt_handler;
  Ctx: Tuacpi_handle;
  out OutIrqHandle: Tuacpi_handle
): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  OutIrqHandle := Tuacpi_handle(-1);
  WriteLn(LogTrace, 'uacpi_kernel_install_interrupt_handler called.');
end;

function uacpi_kernel_uninstall_interrupt_handler(
  Handler: Tuacpi_interrupt_handler;
  IrqHandle: Tuacpi_handle
): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_uninstall_interrupt_handler called.');
end;

{$endif UACPI_BAREBONES_MODE}

end.
