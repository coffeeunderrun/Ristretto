unit Acpi;

interface

uses Uacpi;

const
  UACPI_STATUS_MESSAGE: array [UACPI_STATUS_OK..UACPI_STATUS_DENIED] of String = (
    'UACPI_STATUS_OK',
    'UACPI_STATUS_MAPPING_FAILED',
    'UACPI_STATUS_OUT_OF_MEMORY',
    'UACPI_STATUS_BAD_CHECKSUM',
    'UACPI_STATUS_INVALID_SIGNATURE',
    'UACPI_STATUS_INVALID_TABLE_LENGTH',
    'UACPI_STATUS_NOT_FOUND',
    'UACPI_STATUS_INVALID_ARGUMENT',
    'UACPI_STATUS_UNIMPLEMENTED',
    'UACPI_STATUS_ALREADY_EXISTS',
    'UACPI_STATUS_INTERNAL_ERROR',
    'UACPI_STATUS_TYPE_MISMATCH',
    'UACPI_STATUS_INIT_LEVEL_MISMATCH',
    'UACPI_STATUS_NAMESPACE_NODE_DANGLING',
    'UACPI_STATUS_NO_HANDLER',
    'UACPI_STATUS_NO_RESOURCE_END_TAG',
    'UACPI_STATUS_COMPILED_OUT',
    'UACPI_STATUS_HARDWARE_TIMEOUT',
    'UACPI_STATUS_TIMEOUT',
    'UACPI_STATUS_OVERRIDDEN',
    'UACPI_STATUS_DENIED'
  );

  UACPI_STATUS_AML_MESSAGE: array [UACPI_STATUS_AML_UNDEFINED_REFERENCE..UACPI_STATUS_AML_CALL_STACK_DEPTH_LIMIT] of String = (
    'UACPI_STATUS_AML_UNDEFINED_REFERENCE',
    'UACPI_STATUS_AML_INVALID_NAMESTRING',
    'UACPI_STATUS_AML_OBJECT_ALREADY_EXISTS',
    'UACPI_STATUS_AML_INVALID_OPCODE',
    'UACPI_STATUS_AML_INCOMPATIBLE_OBJECT_TYPE',
    'UACPI_STATUS_AML_BAD_ENCODING',
    'UACPI_STATUS_AML_OUT_OF_BOUNDS_INDEX',
    'UACPI_STATUS_AML_SYNC_LEVEL_TOO_HIGH',
    'UACPI_STATUS_AML_INVALID_RESOURCE',
    'UACPI_STATUS_AML_LOOP_TIMEOUT',
    'UACPI_STATUS_AML_CALL_STACK_DEPTH_LIMIT'
  );

implementation

uses Limine, Log;

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
  Status := uacpi_setup_early_table_access(@Buffer, SizeOf(Buffer));
  case Status of
    UACPI_STATUS_OK:
      Log.Debug('Unit initialized: ACPI');

    UACPI_STATUS_MAPPING_FAILED..UACPI_STATUS_DENIED:
      Log.Fatal(UACPI_STATUS_MESSAGE[Status]);

    UACPI_STATUS_AML_UNDEFINED_REFERENCE..UACPI_STATUS_AML_CALL_STACK_DEPTH_LIMIT:
      Log.Fatal('uACPI early table access setup failed.');
  end;
end.
