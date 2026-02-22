unit Acpi.Mem;

interface

implementation

uses HeapMgr, Hhdm, SysUtils, Uacpi;

function uacpi_kernel_map(Address: Tuacpi_phys_addr; Size: Tuacpi_size): Pointer; cdecl; public;
begin
  result := Pointer(AddHhdmOffset(Address));
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI map: paddr=$%.16X, vaddr=$%P, size=%d bytes.', [Address, result, Size]));
  {$endif}
end;

procedure uacpi_kernel_unmap(Ptr: Pointer; Size: Tuacpi_size); cdecl; public;
begin
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI unmap: vaddr=$%P, size=%d bytes.', [Ptr, Size]));
  {$endif}
end;

{$ifndef UACPI_BAREBONES_MODE}

function uacpi_kernel_alloc(Size: Tuacpi_size): Pointer; cdecl; public;
begin
  result := GetMem(Size);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI alloc: vaddr=$%P, size=%d bytes.', [result, Size]));
  {$endif}
end;

{$ifdef UACPI_NATIVE_ALLOC_ZEROED}
function uacpi_kernel_alloc_zeroed(Size: Tuacpi_size): Pointer; cdecl; public;
begin
  result := GetMem(Size);
  if Assigned(result) then FillByte(result^, Size, 0);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI alloc_zeroed: vaddr=$%P, size=%d bytes.', [result, Size]));
  {$endif}
end;
{$endif UACPI_NATIVE_ALLOC_ZEROED}

{$ifndef UACPI_SIZED_FREES}
procedure uacpi_kernel_free(Mem: Pointer); cdecl; public;
begin
  FreeMem(Mem);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI free: vaddr=$%P.', [Mem]));
  {$endif}
end;
{$else UACPI_SIZED_FREES}
procedure uacpi_kernel_free(Mem: Pointer; SizeHint: Tuacpi_size); cdecl; public;
begin
  FreeMem(Mem, SizeHint);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI free: vaddr=$%P, size=%d bytes.', [Mem, SizeHint]));
  {$endif}
end;
{$endif UACPI_SIZED_FREES}

{$endif UACPI_BAREBONES_MODE}

end.
