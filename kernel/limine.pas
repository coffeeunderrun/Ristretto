unit Limine;

interface

const
  LIMINE_MEDIA_TYPE_GENERIC = 0;
  LIMINE_MEDIA_TYPE_OPTICAL = 1;
  LIMINE_MEDIA_TYPE_TFTP = 2;

type
  TLimineUuid = record
    A: UInt32;
    B: UInt16;
    C: UInt16;
    D: array [0..7] of UInt8;
  end;

  PLimineFile = ^TLimineFile;
  TLimineFile = record
    Revision: UInt64;
    Address: Pointer;
    Size: UInt64;
    Path: PChar;
    Str: PChar;
    MediaType: UInt32;
    Unused: UInt32;
    TftpIp: UInt32;
    TftpPort: UInt32;
    PartitionIndex: UInt32;
    MbrDiskId: UInt32;
    GptDiskUuid: TLimineUuid;
    GptPartUuid: TLimineUuid;
    PartUuid: TLimineUuid;
  end;
  ALimineFile = array of TLimineFile;

{ ** Base Revision ********************************************************** }
var
  LimineBaseRevision: array [0..3] of UInt64; external name '_limine_request_base_revision';

{ ** Bootloader Info ******************************************************** }
type
  PLimineBootloaderInfoResponse = ^TLimineBootloaderInfoResponse;
  TLimineBootloaderInfoResponse = record
    Revision: UInt64;
    Name: PChar;
    Version: PChar;
  end;

  TLimineBootloaderInfoRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineBootloaderInfoResponse;
  end;

var
  LimineBootloaderInfoRequest: TLimineBootloaderInfoRequest; external name '_limine_request_bootloader_info';

{ ** Bootloader Performance ************************************************* }
type
  PLimineBootloaderPerformanceResponse = ^TLimineBootloaderPerformanceResponse;
  TLimineBootloaderPerformanceResponse = record
    Revision: UInt64;
    ResetUsec: UInt64;
    InitUsec: UInt64;
    ExecUsec: UInt64;
  end;

  TLimineBootloaderPerformanceRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineBootloaderPerformanceResponse;
  end;

var
  LimineBootloaderPerformanceRequest: TLimineBootloaderPerformanceRequest; external name '_limine_request_bootloader_performance';

{ ** Date At Boot *********************************************************** }
type
  PLimineDateAtBootResponse = ^TLimineDateAtBootResponse;
  TLimineDateAtBootResponse = record
    Revision: UInt64;
    Timestamp: Int64;
  end;

  TLimineDateAtBootRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineDateAtBootResponse;
  end;

var
  LimineDateAtBootRequest: TLimineDateAtBootRequest; external name '_limine_request_date_at_boot';

{ ** Device Tree Blob ******************************************************* }
type
  PLimineDeviceTreeBlobResponse = ^TLimineDeviceTreeBlobResponse;
  TLimineDeviceTreeBlobResponse = record
    Revision: UInt64;
    DeviceTreeBlob: Pointer;
  end;

  TLimineDeviceTreeBlobRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineDeviceTreeBlobResponse;
  end;

var
  LimineDeviceTreeBlobRequest: TLimineDeviceTreeBlobRequest; external name '_limine_request_device_tree_blob';

{ ** EFI Memory Map ********************************************************* }
type
  PLimineEfiMemoryMapResponse = ^TLimineEfiMemoryMapResponse;
  TLimineEfiMemoryMapResponse = record
    Revision: UInt64;
    MemoryMap: Pointer;
    MemoryMapSize: UInt64;
    DescriptorSize: UInt64;
    DescriptorVersion: UInt64;
  end;

  TLimineEfiMemoryMapRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineEfiMemoryMapResponse;
  end;

var
  LimineEfiMemoryMapRequest: TLimineEfiMemoryMapRequest; external name '_limine_request_efi_memory_map';

{ ** EFI System Table ******************************************************* }
type
  PLimineEfiSystemTableResponse = ^TLimineEfiSystemTableResponse;
  TLimineEfiSystemTableResponse = record
    Revision: UInt64;
    Address: UInt64;
  end;

  TLimineEfiSystemTableRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineEfiSystemTableResponse;
  end;

var
  LimineEfiSystemTableRequest: TLimineEfiSystemTableRequest; external name '_limine_request_efi_system_table';

{ ** Entry Point ************************************************************ }
type
  PLimineEntryPointResponse = ^TLimineEntryPointResponse;
  TLimineEntryPointResponse = record
    Revision: UInt64;
  end;

  TLimineEntryPointRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineEntryPointResponse;
    Entry: Procedure;
  end;

var
  LimineEntryPointRequest: TLimineEntryPointRequest; external name '_limine_request_entry_point';

{ ** Executable Address Request ********************************************* }
type
  PLimineExecutableAddressResponse = ^TLimineExecutableAddressResponse;
  TLimineExecutableAddressResponse = record
    Revision: UInt64;
    PhysicalBase: UInt64;
    VirtualBase: UInt64;
  end;

  TLimineExecutableAddressRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineExecutableAddressResponse;
  end;

var
  LimineExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';

{ ** Executable Command Line ************************************************ }
type
  PLimineExecutableCommandLineResponse = ^TLimineExecutableCommandLineResponse;
  TLimineExecutableCommandLineResponse = record
    Revision: UInt64;
    CommandLine: PChar;
  end;

  TLimineExecutableCommandLineRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineExecutableCommandLineResponse;
  end;

var
  LimineExecutableCommandLineRequest: TLimineExecutableCommandLineRequest; external name '_limine_request_executable_command_line';

{ ** Executable File ******************************************************** }
type
  PLimineExecutableFileResponse = ^TLimineExecutableFileResponse;
  TLimineExecutableFileResponse = record
    Revision: UInt64;
    ExecutableFile: PLimineFile;
  end;

  TLimineExecutableFileRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineExecutableFileResponse;
  end;

var
  LimineExecutableFileRequest: TLimineExecutableFileRequest; external name '_limine_request_executable_file';

{ ** Firmware Type ********************************************************** }
const
  LIMINE_FIRMWARE_TYPE_X86BIOS = 0;
  LIMINE_FIRMWARE_TYPE_EFI32 = 1;
  LIMINE_FIRMWARE_TYPE_EFI64 = 2;
  LIMINE_FIRMWARE_TYPE_SBI = 3;

type
  PLimineFirmwareTypeResponse = ^TLimineFirmwareTypeResponse;
  TLimineFirmwareTypeResponse = record
    Revision: UInt64;
    FirmwareType: UInt64;
  end;

  TLimineFirmwareTypeRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineFirmwareTypeResponse;
  end;

var
  LimineFirmwareTypeRequest: TLimineFirmwareTypeRequest; external name '_limine_request_firmware_type';

{ ** Framebuffer Request **************************************************** }
type
  PLimineVideoMode = ^TLimineVideoMode;
  TLimineVideoMode = record
    Pitch: UInt64;
    Width: UInt64;
    Height: UInt64;
    BitsPerPixel: UInt16;
    MemoryModel: UInt8;
    RedMaskSize: UInt8;
    RedMaskShift: UInt8;
    GreenMaskSize: UInt8;
    GreenMaskShift: UInt8;
    BlueMaskSize: UInt8;
    BlueMaskShift: UInt8;
  end;
  ALimineVideoMode = array of TLimineVideoMode;

  PLimineFramebuffer = ^TLimineFramebuffer;
  TLimineFramebuffer = record
    Address: Pointer;
    Width: UInt64;
    Height: UInt64;
    Pitch: UInt64;
    BitsPerPixel: UInt16;
    MemoryModel: UInt8;
    RedMaskSize: UInt8;
    RedMaskShift: UInt8;
    GreenMaskSize: UInt8;
    GreenMaskShift: UInt8;
    BlueMaskSize: UInt8;
    BlueMaskShift: UInt8;
    Unused: array [0..6] of UInt8;
    EdidSize: UInt64;
    Edid: Pointer;
    ModeCount: UInt64;
    Modes: ^ALimineVideoMode;
  end;
  ALimineFramebuffer = array of TLimineFramebuffer;

  PLimineFramebufferResponse = ^TLimineFramebufferResponse;
  TLimineFramebufferResponse = record
    Revision: UInt64;
    FramebufferCount: UInt64;
    Framebuffers: ^ALimineFramebuffer;
  end;

  TLimineFramebufferRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineFramebufferResponse;
  end;

var
  LimineFramebufferRequest: TLimineFramebufferRequest; external name '_limine_request_framebuffer';

{ ** Higher Half Direct Map ************************************************* }
type
  PLimineHigherHalfDirectMapResponse = ^TLimineHigherHalfDirectMapResponse;
  TLimineHigherHalfDirectMapResponse = record
    Revision: UInt64;
    Offset: UInt64;
  end;

  TLimineHigherHalfDirectMapRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineHigherHalfDirectMapResponse;
  end;

var
  LimineHigherHalfDirectMapRequest: TLimineHigherHalfDirectMapRequest; external name '_limine_request_higher_half_direct_map';

{ ** Memory Map ************************************************************* }
const
  LIMINE_MEMMAP_USABLE = 0;
  LIMINE_MEMMAP_RESERVED = 1;
  LIMINE_MEMMAP_ACPI_RECLAIMABLE = 2;
  LIMINE_MEMMAP_ACPI_NVS = 3;
  LIMINE_MEMMAP_BAD_MEMORY = 4;
  LIMINE_MEMMAP_BOOTLOADER_RECLAIMABLE = 5;
  LIMINE_MEMMAP_EXECUTABLE_AND_MODULES = 6;
  LIMINE_MEMMAP_FRAMEBUFFER = 7;
  LIMINE_MEMMAP_ACPI_TABLES = 8;

type
  PLimineMemoryMapEntry = ^TLimineMemoryMapEntry;
  TLimineMemoryMapEntry = record
    Base: UInt64;
    Length: UInt64;
    EntryType: UInt64;
  end;
  ALimineMemoryMapEntry = array of TLimineMemoryMapEntry;

  PLimineMemoryMapResponse = ^TLimineMemoryMapResponse;
  TLimineMemoryMapResponse = record
    Revision: UInt64;
    EntryCount: UInt64;
    Entries: ^ALimineMemoryMapEntry;
  end;

  TLimineMemoryMapRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineMemoryMapResponse;
  end;

var
  LimineMemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';

{ ** Module ***************************************************************** }
const
  LIMINE_INTERNAL_MODULE_REQUIRED = 1;
  LIMINE_INTERNAL_MODULE_COMPRESSED = 2;

type
  PLimineInternalModule = ^TLimineInternalModule;
  ALimineInternalModule = array of PLimineInternalModule;
  TLimineInternalModule = record
    Path: PChar;
    Str: PChar;
    Flags: UInt64;
  end;

  PLimineModuleResponse = ^TLimineModuleResponse;
  TLimineModuleResponse = record
    Revision: UInt64;
    ModuleCount: UInt64;
    Modules: ^ALimineFile;
  end;

  TLimineModuleRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineModuleResponse;
    { Request revision 1 }
    InternalModuleCount: UInt64;
    InternalModules: ^ALimineInternalModule;
  end;

var
  LimineModuleRequest: TLimineModuleRequest; external name '_limine_request_module';

{ ** Multiprocessor ********************************************************* }
const
  LIMINE_MULTIPROCESSOR_REQUEST_X86_64_X2APIC = 1;

type
  PLimineMultiprocessorInfo = ^TLimineMultiprocessorInfo;

  TLimineGotoAddress = Procedure(Info: PLimineMultiprocessorInfo);

  TLimineMultiprocessorInfo = record
    ProcessorId: UInt32;
{$if defined(CPUX86_64)}
    LapicId: UInt32;
    Reserved: UInt64;
{$elseif defined(CPUAARCH64)}
    Reserved1: UInt32;
    Mpidr: UInt32;
    Reserved2: UInt32;
{$elseif defined(CPURISCV64)}
    Hartid: UInt64;
    Reserved: UInt64;
{$endif}
    GotoAddress: TLimineGotoAddress;
    ExtraArgument: UInt64;
  end;
  ALimineMultiprocessorInfo = array of TLimineMultiprocessorInfo;

  PLimineMultiprocessorResponse = ^TLimineMultiprocessorResponse;
  TLimineMultiprocessorResponse = record
    Revision: UInt64;
{$if defined(CPUX86_64)}
    Flags: UInt32;
    BspLapicId: UInt32;
{$elseif defined(CPUAARCH64)}
    Flags: UInt64;
    BspMpidr: UInt64;
{$elseif defined(CPURISCV64)}
    Flags: UInt64;
    BspHartId: UInt64;
{$endif}
    CpuCount: UInt64;
    Cpus: ^ALimineMultiprocessorInfo;
  end;

  TLimineMultiprocessorRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineMultiprocessorResponse;
    Flags: UInt64;
  end;

var
  LimineMultiprocessorRequest: TLimineMultiprocessorRequest; external name '_limine_request_multiprocessor';

{ ** Paging Mode ************************************************************ }
const
  LIMINE_PAGING_MODE_X86_64_4LVL    = 0;
  LIMINE_PAGING_MODE_X86_64_5LVL    = 1;
  LIMINE_PAGING_MODE_X86_64_DEFAULT = LIMINE_PAGING_MODE_X86_64_4LVL;
  LIMINE_PAGING_MODE_X86_64_MIN     = LIMINE_PAGING_MODE_X86_64_4LVL;

  LIMINE_PAGING_MODE_AARCH64_4LVL    = 0;
  LIMINE_PAGING_MODE_AARCH64_5LVL    = 1;
  LIMINE_PAGING_MODE_AARCH64_DEFAULT = LIMINE_PAGING_MODE_AARCH64_4LVL;
  LIMINE_PAGING_MODE_AARCH64_MIN     = LIMINE_PAGING_MODE_AARCH64_4LVL;

  LIMINE_PAGING_MODE_RISCV_SV39    = 0;
  LIMINE_PAGING_MODE_RISCV_SV48    = 1;
  LIMINE_PAGING_MODE_RISCV_SV57    = 2;
  LIMINE_PAGING_MODE_RISCV_DEFAULT = LIMINE_PAGING_MODE_RISCV_SV48;
  LIMINE_PAGING_MODE_RISCV_MIN     = LIMINE_PAGING_MODE_RISCV_SV39;

  LIMINE_PAGING_MODE_LOONGARCH_4LVL    = 0;
  LIMINE_PAGING_MODE_LOONGARCH_DEFAULT = LIMINE_PAGING_MODE_LOONGARCH_4LVL;
  LIMINE_PAGING_MODE_LOONGARCH_MIN     = LIMINE_PAGING_MODE_LOONGARCH_4LVL;

type
  PLiminePagingModeResponse = ^TLiminePagingModeResponse;
  TLiminePagingModeResponse = record
    Revision: UInt64;
    Mode: UInt64;
  end;

  TLiminePagingModeRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLiminePagingModeResponse;
    Mode: UInt64;
    { Request revision 1 and above }
    MaxMode: UInt64;
    MinMode: UInt64;
  end;

var
  LiminePagingModeRequest: TLiminePagingModeRequest; external name '_limine_request_paging_mode';

{ ** Stack Size ************************************************************* }
type
  PLimineStackSizeResponse = ^TLimineStackSizeResponse;
  TLimineStackSizeResponse = record
    Revision: UInt64;
  end;

  TLimineStackSizeRequest = record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineStackSizeResponse;
    StackSize: UInt64;
  end;

var
  LimineStackSizeRequest: TLimineStackSizeRequest; external name '_limine_request_stack_size';

function BaseRevisionSupported: Boolean; inline;

implementation

function BaseRevisionSupported: Boolean;
begin
  BaseRevisionSupported := LimineBaseRevision[2] = 0;
end;

end.
