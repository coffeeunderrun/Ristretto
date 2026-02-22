unit Acpi.IO;

interface

implementation

uses SysUtils, Uacpi;

{$ifndef UACPI_BAREBONES_MODE}

{ PCI }

function uacpi_kernel_pci_device_open(Address: Tuacpi_pci_address; out OutHandle: Tuacpi_handle): Tuacpi_status; cdecl; public;
begin
  OutHandle := Tuacpi_handle(-1);
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_pci_device_open called.');
end;

procedure uacpi_kernel_pci_device_close(Handle: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_pci_device_close called.');
end;

function uacpi_kernel_pci_read8(Device: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u8): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_pci_read8 called.');
end;

function uacpi_kernel_pci_read16(Device: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_pci_read16 called.');
end;

function uacpi_kernel_pci_read32(Device: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u32): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_pci_read32 called.');
end;

function uacpi_kernel_pci_write8(Device: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u8): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_pci_write8 called.');
end;

function uacpi_kernel_pci_write16(Device: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_pci_write16 called.');
end;

function uacpi_kernel_pci_write32(Device: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u32): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_pci_write32 called.');
end;

{ IO }
function uacpi_kernel_io_map(Base: Tuacpi_io_addr; Len: Tuacpi_size; out OutHandle: Tuacpi_handle): Tuacpi_status; cdecl; public;
begin
  OutHandle := Tuacpi_handle(-1);
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_io_map called.');
end;

procedure uacpi_kernel_io_unmap(Handle: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_io_unmap called.');
end;

function uacpi_kernel_io_read8(Handle: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u8): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_io_read8 called.');
end;

function uacpi_kernel_io_read16(Handle: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_io_read16 called.');
end;

function uacpi_kernel_io_read32(Handle: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u32): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_io_read32 called.');
end;

function uacpi_kernel_io_write8(Handle: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u8): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_io_write8 called.');
end;

function uacpi_kernel_io_write16(Handle: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_io_write16 called.');
end;

function uacpi_kernel_io_write32(Handle: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u32): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_io_write32 called.');
end;

{$endif UACPI_BAREBONES_MODE}

end.
