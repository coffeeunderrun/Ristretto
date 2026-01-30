(*
  CAUTION: This is a work-in-progress and requires further development and testing.

  HOW TO USE
  ----------
  Include limine.inc in your program or one of your units:
    {$I limine.inc}

  NOTE: Since FreePascal does not provide a way to specify section names, a
  common prefix, '_limine_request_', has been used for the exported symbols.
  If you want to contain the requests within a specific section, you will
  need to do so via the linker script.

  To set specific Limine request values, you will need to enable C-style macros:
    {$macro on}
    {$define LIMINE_<...> := value}
    {$macro off}

  The default base revision is currently 4.
  To set a specific revision:
    {$macro on}
    {$define LIMINE_BASE_REVISION := 4}
    {$macro off}
    {$I limine.inc}

  To set the entry point:
    {$macro on}
    {$define LIMINE_ENTRY_POINT := @procedure_name}
    {$macro off}
    {$define LIMINE_REQUEST_ENTRY_POINT}
    {$I limine.inc}

  To add internal modules:
    {$macro on}
    {$define LIMINE_MODULE_COUNT := <count of internal module pointers>}
    {$define LIMINE_MODULE_ARRAY := @array_of_internal_module_pointers}
    {$macro off}
    {$define LIMINE_REQUEST_MODULE}
    {$I limine.inc}

  To set the multiprocessor flags:
    {$macro on}
    {$define LIMINE_MULTIPROCESSOR_FLAGS := LIMINE_MULTIPROCESSOR_REQUEST_X86_64_X2APIC}
    {$macro off}
    {$define LIMINE_REQUEST_MULTIPROCESSOR}
    {$I limine.inc}

  To set the paging mode:
    {$macro on}
    {$define LIMINE_PAGING_MODE := LIMINE_PAGING_MODE_X86_64_DEFAULT}
    {$define LIMINE_PAGING_MODE_MIN := LIMINE_PAGING_MODE_X86_64_4LVL}
    {$define LIMINE_PAGING_MODE_MAX := LIMINE_PAGING_MODE_X86_64_5LVL}
    {$macro off}
    {$define LIMINE_REQUEST_PAGING_MODE}
    {$I limine.inc}

  To set the stack size:
    {$macro on}
    {$define LIMINE_STACK_SIZE := <size in bytes>}
    {$macro off}
    {$define LIMINE_REQUEST_STACK_SIZE}
    {$I limine.inc}

  To request specific features, include the defines prior to including limine.inc:
  {$define LIMINE_REQUEST_BOOTLOADER_INFO}
  {$define LIMINE_REQUEST_BOOTLOADER_PERFORMANCE}
  {$define LIMINE_REQUEST_DATE_AT_BOOT}
  {$define LIMINE_REQUEST_DEVICE_TREE_BLOB}
  {$define LIMINE_REQUEST_EFI_MEMORY_MAP}
  {$define LIMINE_REQUEST_EFI_SYSTEM_TABLE}
  {$define LIMINE_REQUEST_ENTRY_POINT}
  {$define LIMINE_REQUEST_EXECUTABLE_ADDRESS}
  {$define LIMINE_REQUEST_EXECUTABLE_COMMAND_LINE}
  {$define LIMINE_REQUEST_EXECUTABLE_FILE}
  {$define LIMINE_REQUEST_FIRMWARE_TYPE}
  {$define LIMINE_REQUEST_FRAMEBUFFER}
  {$define LIMINE_REQUEST_HIGHER_HALF_DIRECT_MAP}
  {$define LIMINE_REQUEST_MEMORY_MAP}
  {$define LIMINE_REQUEST_MODULE}
  {$define LIMINE_REQUEST_MULTIPROCESSOR}
  {$define LIMINE_REQUEST_PAGING_MODE}
  {$define LIMINE_REQUEST_STACK_SIZE}

  Not implemented yet:
  {$define LIMINE_REQUEST_RISCV_BSP_HART_ID}
  {$define LIMINE_REQUEST_RSDP}
  {$define LIMINE_REQUEST_SMBIOS}
*)

{$push}
{$macro on}

{$define LIMINE_COMMON_MAGIC := UInt64($C7B1DD30DF4C8B88), UInt64($0A82E883A194F07B)}

const
{ ** Start Marker *********************************************************** }
  LimineRequestStartMarker: array [0..3] of UInt64 = (
    UInt64($F6B8F4B39DE7D1AE),
    UInt64($FAB91A6940FCB9CF),
    UInt64($785C6ED015D3E316),
    UInt64($181E920A7852B9D9)
  ); export name '_limine_request_start_marker';

{ ** Base Revision ********************************************************** }
{$ifndef LIMINE_BASE_REVISION}
  {$define LIMINE_BASE_REVISION := 4}
{$endif LIMINE_BASE_REVISION}
  LimineRequestBaseRevision: array [0..3] of UInt64 = (
    UInt64($F9562B2D5C95A6C8),
    UInt64($6A7B384944536BDC),
    LIMINE_BASE_REVISION,
    0
  ); export name '_limine_request_base_revision';

{ ** Booloader Info ********************************************************* }
{$ifdef LIMINE_REQUEST_BOOTLOADER_INFO}
  LimineRequestBooloaderInfo: TLimineBootloaderInfoRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($F55038D8E2A1202F), UInt64($279426FCF5F59740));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_bootloader_info';
{$endif LIMINE_REQUEST_BOOTLOADER_INFO}

{ ** Bootloader Performance ************************************************* }
{$ifdef LIMINE_REQUEST_BOOTLOADER_PERFORMANCE}
  LimineRequestBooloaderPerformance: TLimineBootloaderPerformanceRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($6B50AD9BF36D13AD), UInt64($DC4C7E88FC759E17));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_bootloader_performance';
{$endif LIMINE_REQUEST_BOOTLOADER_PERFORMANCE}

{ ** Date At Boot *********************************************************** }
{$ifdef LIMINE_REQUEST_DATE_AT_BOOT}
  LimineRequestDateAtBoot: TLimineDateAtBootRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($502746E184C088AA), UInt64($FBC5EC83E6327893));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_date_at_boot';
{$endif LIMINE_REQUEST_DATE_AT_BOOT}

{ ** Device Tree Blob ******************************************************* }
{$ifdef LIMINE_REQUEST_DEVICE_TREE_BLOB}
  LimineRequestDeviceTreeBlob: TLimineDeviceTreeBlobRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($B40DDB48FB54BAC7), UInt64($545081493F81FFB7));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_device_tree_blob';
{$endif LIMINE_REQUEST_DEVICE_TREE_BLOB}

{ ** EFI Memory Map ********************************************************* }
{$ifdef LIMINE_REQUEST_EFI_MEMORY_MAP}
  LimineRequestEfiMemoryMap: TLimineEfiMemoryMapRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($7DF62A431D6872D5), UInt64($A4FCDFB3E57306C8));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_efi_memory_map';
{$endif LIMINE_REQUEST_EFI_MEMORY_MAP}

{ ** EFI System Table ******************************************************* }
{$ifdef LIMINE_REQUEST_EFI_SYSTEM_TABLE}
  LimineRequestEfiSystemTable: TLimineEfiSystemTableRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($5CEBA5163EAAF6D6), UInt64($0A6981610CF65FCC));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_efi_system_table';
{$endif LIMINE_REQUEST_EFI_SYSTEM_TABLE}

{ ** Entry Point ************************************************************ }
{$ifdef LIMINE_REQUEST_ENTRY_POINT}
{$ifdef LIMINE_ENTRY_POINT}
  LimineRequestEntryPoint: TLimineEntryPointRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($13D86C035A1CD3E1), UInt64($2B0CAA89D8F3026A));
    Revision: 0;
    Response: nil;
    Entry: LIMINE_ENTRY_POINT;
  ); export name '_limine_request_entry_point';
{$endif LIMINE_ENTRY_POINT}
{$endif LIMINE_REQUEST_ENTRY_POINT}

{ ** Executable Address Request ********************************************* }
{$ifdef LIMINE_REQUEST_EXECUTABLE_ADDRESS}
  LimineRequestExecutableAddress: TLimineExecutableAddressRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($71BA76863CC55F63), UInt64($B2644A48C516A487));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_executable_address';
{$endif LIMINE_REQUEST_EXECUTABLE_ADDRESS}

{ ** Executable Command Line ************************************************ }
{$ifdef LIMINE_REQUEST_EXECUTABLE_COMMAND_LINE}
  LimineRequestExecutableCommandLine: TLimineExecutableAddressRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($4B161536E598651E), UInt64($B390AD4A2F1F303A));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_executable_command_line';
{$endif LIMINE_REQUEST_EXECUTABLE_COMMAND_LINE}

{ ** Executable File ******************************************************** }
{$ifdef LIMINE_REQUEST_EXECUTABLE_FILE}
  LimineRequestExecutableFile: TLimineExecutableFileRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($AD97E90E83F1ED67), UInt64($31EB5D1C5FF23B69));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_executable_file';
{$endif LIMINE_REQUEST_EXECUTABLE_FILE}

{ ** Firmware Type ********************************************************** }
{$ifdef LIMINE_REQUEST_FIRMWARE_TYPE}
  LimineRequestFirmwareType: TLimineFirmwareTypeRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($8C2F75D90BEF28A8), UInt64($7045A4688EAC00C3));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_firmware_type';
{$endif LIMINE_REQUEST_FIRMWARE_TYPE}

{ ** Framebuffer Request **************************************************** }
{$ifdef LIMINE_REQUEST_FRAMEBUFFER}
  LimineRequestFramebuffer: TLimineFramebufferRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($9D5827DCD881DD75), UInt64($A3148604F6FAB11B));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_framebuffer';
{$endif LIMINE_REQUEST_FRAMEBUFFER}

{ ** Higher Half Direct Map ************************************************* }
{$ifdef LIMINE_REQUEST_HIGHER_HALF_DIRECT_MAP}
  LimineRequestHigherHalfDirectMap: TLimineHigherHalfDirectMapRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($48DCF1CB8AD2B852), UInt64($63984E959A98244B));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_higher_half_direct_map';
{$endif LIMINE_REQUEST_HIGHER_HALF_DIRECT_MAP}

{ ** Memory Map ************************************************************* }
{$ifdef LIMINE_REQUEST_MEMORY_MAP}
  LimineRequestMemoryMap: TLimineMemoryMapRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($67CF3D9D378A806F), UInt64($E304ACDFC50C3C62));
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_memory_map';
{$endif LIMINE_REQUEST_MEMORY_MAP}

{ ** Module ***************************************************************** }
{$ifdef LIMINE_REQUEST_MODULE}

{$ifndef LIMINE_MODULE_COUNT}
  {$define LIMINE_MODULE_COUNT := 0}
{$endif LIMINE_MODULE_COUNT}

{$ifndef LIMINE_MODULE_ARRAY}
  {$define LIMINE_MODULE_ARRAY := nil}
{$endif LIMINE_MODULE_ARRAY}

  LimineRequestModule: TLimineModuleRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($3E7E279702BE32AF), UInt64($CA1C4F3BD1280CEE));
    Revision: 0;
    Response: nil;
    InternalModuleCount: LIMINE_MODULE_COUNT;
    InternalModules: LIMINE_MODULE_ARRAY;
  ); export name '_limine_request_module';
{$endif LIMINE_REQUEST_MODULE}

{ ** Multiprocessor ********************************************************* }
{$ifdef LIMINE_REQUEST_MULTIPROCESSOR}

{$ifndef LIMINE_MULTIPROCESSOR_FLAGS}
  {$define LIMINE_MULTIPROCESSOR_FLAGS := 0}
{$endif LIMINE_MULTIPROCESSOR_FLAGS}

  LimineRequestMultiprocessor: TLimineMultiprocessorRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($95A67B819A1B857E), UInt64($A0B61B723B6A73E0));
    Revision: 0;
    Response: nil;
    Flags: LIMINE_MULTIPROCESSOR_FLAGS;
  ); export name '_limine_request_multiprocessor';
{$endif LIMINE_REQUEST_MULTIPROCESSOR}

{ ** Paging Mode ************************************************************ }
{$ifdef LIMINE_REQUEST_PAGING_MODE}

{$if defined(CPUX86_64)}
  {$ifndef LIMINE_PAGING_MODE}
    {$define LIMINE_PAGING_MODE := LIMINE_PAGING_MODE_X86_64_DEFAULT}
  {$endif LIMINE_PAGING_MODE}

  {$ifndef LIMINE_PAGING_MODE_MAX}
    {$define LIMINE_PAGING_MODE_MAX := LIMINE_PAGING_MODE_X86_64_DEFAULT}
  {$endif LIMINE_PAGING_MODE_MAX}

  {$ifndef LIMINE_PAGING_MODE_MIN}
    {$define LIMINE_PAGING_MODE_MIN := LIMINE_PAGING_MODE_X86_64_MIN}
  {$endif LIMINE_PAGING_MODE_MIN}

{$elseif defined(CPUAARCH64)}
  {$ifndef LIMINE_PAGING_MODE}
    {$define LIMINE_PAGING_MODE := LIMINE_PAGING_MODE_AARCH64_DEFAULT}
  {$endif LIMINE_PAGING_MODE}

  {$ifndef LIMINE_PAGING_MODE_MAX}
    {$define LIMINE_PAGING_MODE_MAX := LIMINE_PAGING_MODE_AARCH64_DEFAULT}
  {$endif LIMINE_PAGING_MODE_MAX}

  {$ifndef LIMINE_PAGING_MODE_MIN}
    {$define LIMINE_PAGING_MODE_MIN := LIMINE_PAGING_MODE_AARCH64_MIN}
  {$endif LIMINE_PAGING_MODE_MIN}

{$elseif defined(CPULOONGARCH64)}
  {$ifndef LIMINE_PAGING_MODE}
    {$define LIMINE_PAGING_MODE := LIMINE_PAGING_MODE_LOONGARCH_DEFAULT}
  {$endif LIMINE_PAGING_MODE}

  {$ifndef LIMINE_PAGING_MODE_MAX}
    {$define LIMINE_PAGING_MODE_MAX := LIMINE_PAGING_MODE_LOONGARCH_DEFAULT}
  {$endif LIMINE_PAGING_MODE_MAX}

  {$ifndef LIMINE_PAGING_MODE_MIN}
    {$define LIMINE_PAGING_MODE_MIN := LIMINE_PAGING_MODE_LOONGARCH_MIN}
  {$endif LIMINE_PAGING_MODE_MIN}

{$elseif defined(CPURISCV64)}
  {$ifndef LIMINE_PAGING_MODE}
    {$define LIMINE_PAGING_MODE := LIMINE_PAGING_MODE_RISCV_DEFAULT}
  {$endif LIMINE_PAGING_MODE}

  {$ifndef LIMINE_PAGING_MODE_MAX}
    {$define LIMINE_PAGING_MODE_MAX := LIMINE_PAGING_MODE_RISCV_DEFAULT}
  {$endif LIMINE_PAGING_MODE_MAX}

  {$ifndef LIMINE_PAGING_MODE_MIN}
    {$define LIMINE_PAGING_MODE_MIN := LIMINE_PAGING_MODE_RISCV_MIN}
  {$endif LIMINE_PAGING_MODE_MIN}

{$endif defined(CPUX86_64)}

  LimineRequestPagingMode: TLiminePagingModeRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($95C1A0EDAB0944CB), UInt64($A4E5CB3842F7488A));
    Revision: 0;
    Response: nil;
    Mode: LIMINE_PAGING_MODE;
    MaxMode: LIMINE_PAGING_MODE_MAX;
    MinMode: LIMINE_PAGING_MODE_MIN;
  ); export name '_limine_request_paging_mode';
{$endif LIMINE_REQUEST_PAGING_MODE}

{ ** Stack Size ************************************************************* }
{$ifdef LIMINE_REQUEST_STACK_SIZE}
{$ifdef LIMINE_STACK_SIZE}
  LimineRequestStackSize: TLimineStackSizeRequest = (
    Id: (LIMINE_COMMON_MAGIC, UInt64($224EF0460A8E8926), UInt64($E1CB0FC25F46EA3D));
    Revision: 0;
    Response: nil;
    StackSize: LIMINE_STACK_SIZE;
  ); export name '_limine_request_stack_size';
{$endif LIMINE_STACK_SIZE}
{$endif LIMINE_REQUEST_STACK_SIZE}

{ ** End Marker ************************************************************* }
  LimineRequestEndMarker: array [0..1] of UInt64 = (
    UInt64($ADC0E0531BB10D03),
    UInt64($9572709F31764C62)
  ); export name '_limine_request_end_marker';

{$pop}
