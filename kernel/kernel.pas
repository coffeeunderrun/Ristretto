program Kernel;

uses Arch, Limine, Log, Framebuffer, Terminal, Uacpi;

{$define LIMINE_REQUEST_FRAMEBUFFER}
{$define LIMINE_REQUEST_RSDP}
{$I limine.inc}

const
  Logo: String =
    ' ______ __       __              __   __         '#10 +
    '|   __ |__.-----|  |_.----.-----|  |_|  |_.-----.'#10 +
    '|      |  |__ --|   _|   _|  -__|   _|   _|  _  |'#10 +
    '|___|__|__|_____|____|__| |_____|____|____|_____|'#10#10;

var
  Rsdp: TLimineRsdpRequest; external name '_limine_request_rsdp';
  Buffer: array [0..4095] of Byte;
  Status: uacpi_status;

function uacpi_kernel_get_rsdp(AddressPtr: puacpi_phys_addr): uacpi_status; cdecl; public;
begin
  if Assigned(Rsdp.Response) then begin
    AddressPtr^ := uacpi_phys_addr(Rsdp.Response^.Address);
    exit(UACPI_STATUS_OK);
  end;

  result := UACPI_STATUS_NOT_FOUND;
end;

procedure uacpi_kernel_log(LogLevel: uacpi_log_level; const Message: puacpi_char); cdecl; public;
begin
  case LogLevel of
    UACPI_LOG_ERROR: Log.Error(Message);
    UACPI_LOG_WARN: Log.Warn(Message);
    UACPI_LOG_INFO: Log.Info(Message);
    UACPI_LOG_TRACE: Log.Trace(Message);
    UACPI_LOG_DEBUG: Log.Debug(Message);
  end;
end;

function uacpi_kernel_map(Address: uacpi_phys_addr; Size: uacpi_size): Pointer; cdecl; public;
begin
  result := nil;
end;

procedure uacpi_kernel_unmap(Ptr: Pointer; Size: uacpi_size); cdecl; public;
begin
end;

begin
  if not Limine.BaseRevisionSupported then exit;

  Terminal.Write(Logo);

  Status := uacpi_setup_early_table_access(@Buffer, SizeOf(Buffer));
end.
