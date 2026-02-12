unit Acpi;

interface

uses Uacpi;

const
  UACPI_STATUS_MESSAGE: array [UACPI_STATUS_OK..UACPI_STATUS_DENIED] of String = (
    'OK',
    'MAPPING_FAILED',
    'OUT_OF_MEMORY',
    'BAD_CHECKSUM',
    'INVALID_SIGNATURE',
    'INVALID_TABLE_LENGTH',
    'NOT_FOUND',
    'INVALID_ARGUMENT',
    'UNIMPLEMENTED',
    'ALREADY_EXISTS',
    'INTERNAL_ERROR',
    'TYPE_MISMATCH',
    'INIT_LEVEL_MISMATCH',
    'NAMESPACE_NODE_DANGLING',
    'NO_HANDLER',
    'NO_RESOURCE_END_TAG',
    'COMPILED_OUT',
    'HARDWARE_TIMEOUT',
    'TIMEOUT',
    'OVERRIDDEN',
    'DENIED'
  );

  UACPI_STATUS_AML_MESSAGE: array [UACPI_STATUS_AML_UNDEFINED_REFERENCE..UACPI_STATUS_AML_CALL_STACK_DEPTH_LIMIT] of String = (
    'AML_UNDEFINED_REFERENCE',
    'AML_INVALID_NAMESTRING',
    'AML_OBJECT_ALREADY_EXISTS',
    'AML_INVALID_OPCODE',
    'AML_INCOMPATIBLE_OBJECT_TYPE',
    'AML_BAD_ENCODING',
    'AML_OUT_OF_BOUNDS_INDEX',
    'AML_SYNC_LEVEL_TOO_HIGH',
    'AML_INVALID_RESOURCE',
    'AML_LOOP_TIMEOUT',
    'AML_CALL_STACK_DEPTH_LIMIT'
  );

procedure Initialize;

implementation

uses Limine, Log, SysUtils, Utilities;

var
  RsdpRequest: TLimineRsdpRequest; external name '_limine_request_rsdp';

function uacpi_kernel_get_rsdp(AddressPtr: puacpi_phys_addr): uacpi_status; cdecl; public;
begin
  if Assigned(RsdpRequest.Response) then begin
    // Limine protocol base revision 4 states that the RSDP address will be virtual (HHDM).
    AddressPtr^ := uacpi_phys_addr(RemoveHhdmOffset(PtrUInt(RsdpRequest.Response^.Address)));
    {$ifndef NDEBUG}
    Log.TraceLn('uACPI RSDP found at physical address ' + IntToHex(AddressPtr^));
    {$endif}
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
  result := Pointer(AddHhdmOffset(Address));
  {$ifndef NDEBUG}
  Log.TraceLn('uACPI map called on address ' + IntToHex(Address) +
    ' of size ' + IntToStr(Size) + '. Mapped to ' + IntToHex(PtrUInt(result)) + '.');
  {$endif}
end;

procedure uacpi_kernel_unmap(Ptr: Pointer; Size: uacpi_size); cdecl; public;
begin
  {$ifndef NDEBUG}
  Log.TraceLn('uACPI unmap called on pointer ' + IntToHex(PtrUInt(Ptr)) +
    ' of size ' + IntToStr(Size) + '. No action taken.');
  {$endif}
end;

procedure Initialize;
var
  Buffer: array [0..4095] of Byte;
  Status: uacpi_status;
begin
  Status := uacpi_setup_early_table_access(@Buffer, SizeOf(Buffer));
  case Status of
    {$ifndef NDEBUG}
    UACPI_STATUS_OK: Log.DebugLn('ACPI initialized.');
    {$endif}

    UACPI_STATUS_MAPPING_FAILED..UACPI_STATUS_DENIED:
      Log.FatalLn('uACPI status: ' + UACPI_STATUS_MESSAGE[Status]);

    UACPI_STATUS_AML_UNDEFINED_REFERENCE..UACPI_STATUS_AML_CALL_STACK_DEPTH_LIMIT:
      Log.FatalLn('uACPI status: ' + UACPI_STATUS_AML_MESSAGE[Status]);
  end;
end;

end.
