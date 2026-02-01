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
  Status: UacpiStatus;

function KernelGetRsdp(AddressPtr: PUacpiPhysAddr): UacpiStatus; cdecl; public name 'uacpi_kernel_get_rsdp';
begin
  if Rsdp.Response <> nil then begin
    AddressPtr^ := UacpiPhysAddr(Rsdp.Response^.Address);
    exit(UACPI_STATUS_OK);
  end;

  result := UACPI_STATUS_NOT_FOUND;
end;

procedure KernelLog(LogLevel: UacpiLogLevel; const Message: PUacpiChar); cdecl; public name 'uacpi_kernel_log';
begin
  case LogLevel of
    UACPI_LOG_ERROR: Log.Error(Message);
    UACPI_LOG_WARN: Log.Warn(Message);
    UACPI_LOG_INFO: Log.Info(Message);
    UACPI_LOG_TRACE: Log.Trace(Message);
    UACPI_LOG_DEBUG: Log.Debug(Message);
  end;
end;

function KernelMap(Address: UacpiPhysAddr; Size: UacpiSize): Pointer; cdecl; public name 'uacpi_kernel_map';
begin
  result := nil;
end;

procedure KernelUnmap(Ptr: Pointer; Size: UacpiSize); cdecl; public name 'uacpi_kernel_unmap';
begin
end;

begin
  if not Limine.BaseRevisionSupported then exit;

  Terminal.Write(Logo);

  Status := Uacpi.SetupEarlyTableAccess(@Buffer, SizeOf(Buffer));
end.
