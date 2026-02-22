unit Acpi;

interface

procedure Initialize;

implementation

uses Acpi.IO, Acpi.Irq, Acpi.Mem, Acpi.Sync, Acpi.Task, Hhdm, Limine, SysUtils, Uacpi;

var
  RsdpRequest: TLimineRsdpRequest; external name '_limine_request_rsdp';

procedure Initialize;
var
  Status: Tuacpi_status;
begin
  Status := uacpi_initialize(0);
  if Status <> UACPI_STATUS_OK then begin
    WriteLn(LogFatal, Format('uACPI status: %s.', [uacpi_status_to_string(Status)]));
    exit;
  end;
end;

function uacpi_kernel_get_rsdp(AddressPtr: Puacpi_phys_addr): Tuacpi_status; cdecl; public;
begin
  if Assigned(RsdpRequest.Response) then begin
    // Limine protocol base revision 4 states that the RSDP address will be virtual (HHDM).
    AddressPtr^ := Tuacpi_phys_addr(RemoveHhdmOffset(PtrUInt(RsdpRequest.Response^.Address)));
    {$ifndef NDEBUG}
    WriteLn(LogDebug, Format('uACPI RSDP found: paddr=$%.16X.', [AddressPtr^]));
    {$endif}
    exit(UACPI_STATUS_OK);
  end;

  result := UACPI_STATUS_NOT_FOUND;
end;

procedure uacpi_kernel_log(LogLevel: Tuacpi_log_level; const Message: Puacpi_char); cdecl; public;
begin
  case LogLevel of
    UACPI_LOG_ERROR: Write(LogError, Message);
    UACPI_LOG_WARN: Write(LogWarn, Message);
    UACPI_LOG_INFO: Write(LogInfo, Message);
    UACPI_LOG_TRACE: Write(LogTrace, Message);
    UACPI_LOG_DEBUG: Write(LogDebug, Message);
  end;
end;

{$ifndef UACPI_BAREBONES_MODE}

{$ifdef UACPI_KERNEL_INITIALIZATION}
function uacpi_kernel_initialize(CurrentInitLvl: Tuacpi_init_level): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
end;

procedure uacpi_kernel_deinitialize; cdecl; public;
begin
end;
{$endif UACPI_KERNEL_INITIALIZATION}

function uacpi_kernel_get_nanoseconds_since_boot: Tuacpi_u64; cdecl; public;
begin
  result := 0;
  WriteLn(LogTrace, 'uacpi_kernel_get_nanoseconds_since_boot called.');
end;

procedure uacpi_kernel_stall(Usec: Tuacpi_u8); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_stall called.');
end;

function uacpi_kernel_handle_firmware_request(Request: Tuacpi_firmware_request): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_handle_firmware_request called.');
end;

{$endif UACPI_BAREBONES_MODE}

end.
