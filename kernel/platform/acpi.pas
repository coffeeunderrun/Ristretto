unit Acpi;

interface

uses Uacpi;

procedure Initialize;

implementation

uses Hhdm, Limine, SysUtils;

var
  RsdpRequest: TLimineRsdpRequest; external name '_limine_request_rsdp';

function uacpi_kernel_get_rsdp(AddressPtr: puacpi_phys_addr): uacpi_status; cdecl; public;
begin
  if Assigned(RsdpRequest.Response) then begin
    // Limine protocol base revision 4 states that the RSDP address will be virtual (HHDM).
    AddressPtr^ := uacpi_phys_addr(RemoveHhdmOffset(PtrUInt(RsdpRequest.Response^.Address)));
    {$ifndef NDEBUG}
    WriteLn(LogDebug, Format('uACPI RSDP found: paddr=$%.16X.', [AddressPtr^]));
    {$endif}
    exit(UACPI_STATUS_OK);
  end;

  result := UACPI_STATUS_NOT_FOUND;
end;

procedure uacpi_kernel_log(LogLevel: uacpi_log_level; const Message: puacpi_char); cdecl; public;
begin
  case LogLevel of
    UACPI_LOG_ERROR: Write(LogError, Message);
    UACPI_LOG_WARN: Write(LogWarn, Message);
    UACPI_LOG_INFO: Write(LogInfo, Message);
    UACPI_LOG_TRACE: Write(LogTrace, Message);
    UACPI_LOG_DEBUG: Write(LogDebug, Message);
  end;
end;

function uacpi_kernel_map(Address: uacpi_phys_addr; Size: uacpi_size): Pointer; cdecl; public;
begin
  result := Pointer(AddHhdmOffset(Address));
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI map: paddr=$%.16X, vaddr=$%.16X, size=%d bytes.', [Address, PtrUInt(result), Size]));
  {$endif}
end;

procedure uacpi_kernel_unmap(Ptr: Pointer; Size: uacpi_size); cdecl; public;
begin
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI unmap: vaddr=$%.16X, size=%d bytes.', [PtrUInt(Ptr), Size]));
  {$endif}
end;

procedure Initialize;
var
  Buffer: array [0..4095] of Byte;
  Status: uacpi_status;
begin
  Status := uacpi_setup_early_table_access(@Buffer, SizeOf(Buffer));
  if Status <> UACPI_STATUS_OK then begin
    WriteLn(LogFatal, Format('uACPI status: %s.', [uacpi_status_to_string(Status)]));
    uacpi_state_reset;
    exit;
  end;
end;

end.
