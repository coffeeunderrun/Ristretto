unit Limine;

interface

const
  LIMINE_MEDIA_TYPE_GENERIC = 0;
  LIMINE_MEDIA_TYPE_OPTICAL = 1;
  LIMINE_MEDIA_TYPE_TFTP = 2;

type
  TLimineUuid = record
    A: DWord;
    B: Word;
    C: Word;
    D: array [0..7] of Byte;
  end;

  PLimineFile = ^TLimineFile;
  TLimineFile = record
    Revision: QWord;
    Address: Pointer;
    Size: QWord;
    Path: PChar;
    Str: PChar;
    MediaType: DWord;
    Unused: DWord;
    TftpIp: DWord;
    TftpPort: DWord;
    PartitionIndex: DWord;
    MbrDiskId: DWord;
    GptDiskUuid: TLimineUuid;
    GptPartUuid: TLimineUuid;
    PartUuid: TLimineUuid;
  end;
  ALimineFile = array of TLimineFile;

{ ** Bootloader Info ******************************************************** }
type
  PLimineBootloaderInfoResponse = ^TLimineBootloaderInfoResponse;
  TLimineBootloaderInfoResponse = record
    Revision: QWord;
    Name: PChar;
    Version: PChar;
  end;

  TLimineBootloaderInfoRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineBootloaderInfoResponse;
  end;

{ ** Bootloader Performance ************************************************* }
type
  PLimineBootloaderPerformanceResponse = ^TLimineBootloaderPerformanceResponse;
  TLimineBootloaderPerformanceResponse = record
    Revision: QWord;
    ResetUsec: QWord;
    InitUsec: QWord;
    ExecUsec: QWord;
  end;

  TLimineBootloaderPerformanceRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineBootloaderPerformanceResponse;
  end;

{ ** Date At Boot *********************************************************** }
type
  PLimineDateAtBootResponse = ^TLimineDateAtBootResponse;
  TLimineDateAtBootResponse = record
    Revision: QWord;
    Timestamp: Int64;
  end;

  TLimineDateAtBootRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineDateAtBootResponse;
  end;

{ ** Device Tree Blob ******************************************************* }
type
  PLimineDeviceTreeBlobResponse = ^TLimineDeviceTreeBlobResponse;
  TLimineDeviceTreeBlobResponse = record
    Revision: QWord;
    DeviceTreeBlob: Pointer;
  end;

  TLimineDeviceTreeBlobRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineDeviceTreeBlobResponse;
  end;

{ ** EFI Memory Map ********************************************************* }
type
  PLimineEfiMemoryMapResponse = ^TLimineEfiMemoryMapResponse;
  TLimineEfiMemoryMapResponse = record
    Revision: QWord;
    MemoryMap: Pointer;
    MemoryMapSize: QWord;
    DescriptorSize: QWord;
    DescriptorVersion: QWord;
  end;

  TLimineEfiMemoryMapRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineEfiMemoryMapResponse;
  end;

{ ** EFI System Table ******************************************************* }
type
  PLimineEfiSystemTableResponse = ^TLimineEfiSystemTableResponse;
  TLimineEfiSystemTableResponse = record
    Revision: QWord;
    Address: QWord;
  end;

  TLimineEfiSystemTableRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineEfiSystemTableResponse;
  end;

{ ** Entry Point ************************************************************ }
type
  PLimineEntryPointResponse = ^TLimineEntryPointResponse;
  TLimineEntryPointResponse = record
    Revision: QWord;
  end;

  TLimineEntryPointRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineEntryPointResponse;
    Entry: Procedure;
  end;

{ ** Executable Address Request ********************************************* }
type
  PLimineExecutableAddressResponse = ^TLimineExecutableAddressResponse;
  TLimineExecutableAddressResponse = record
    Revision: QWord;
    PhysicalBase: QWord;
    VirtualBase: QWord;
  end;

  TLimineExecutableAddressRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineExecutableAddressResponse;
  end;

{ ** Executable Command Line ************************************************ }
type
  PLimineExecutableCommandLineResponse = ^TLimineExecutableCommandLineResponse;
  TLimineExecutableCommandLineResponse = record
    Revision: QWord;
    CommandLine: PChar;
  end;

  TLimineExecutableCommandLineRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineExecutableCommandLineResponse;
  end;

{ ** Executable File ******************************************************** }
type
  PLimineExecutableFileResponse = ^TLimineExecutableFileResponse;
  TLimineExecutableFileResponse = record
    Revision: QWord;
    ExecutableFile: PLimineFile;
  end;

  TLimineExecutableFileRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineExecutableFileResponse;
  end;

{ ** Firmware Type ********************************************************** }
const
  LIMINE_FIRMWARE_TYPE_X86BIOS = 0;
  LIMINE_FIRMWARE_TYPE_EFI32 = 1;
  LIMINE_FIRMWARE_TYPE_EFI64 = 2;
  LIMINE_FIRMWARE_TYPE_SBI = 3;

type
  PLimineFirmwareTypeResponse = ^TLimineFirmwareTypeResponse;
  TLimineFirmwareTypeResponse = record
    Revision: QWord;
    FirmwareType: QWord;
  end;

  TLimineFirmwareTypeRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineFirmwareTypeResponse;
  end;

{ ** Framebuffer Request **************************************************** }
type
  PLimineVideoMode = ^TLimineVideoMode;
  TLimineVideoMode = record
    Pitch: QWord;
    Width: QWord;
    Height: QWord;
    BitsPerPixel: Word;
    MemoryModel: Byte;
    RedMaskSize: Byte;
    RedMaskShift: Byte;
    GreenMaskSize: Byte;
    GreenMaskShift: Byte;
    BlueMaskSize: Byte;
    BlueMaskShift: Byte;
  end;
  ALimineVideoMode = array of TLimineVideoMode;

  PLimineFramebuffer = ^TLimineFramebuffer;
  TLimineFramebuffer = record
    Address: Pointer;
    Width: QWord;
    Height: QWord;
    Pitch: QWord;
    BitsPerPixel: Word;
    MemoryModel: Byte;
    RedMaskSize: Byte;
    RedMaskShift: Byte;
    GreenMaskSize: Byte;
    GreenMaskShift: Byte;
    BlueMaskSize: Byte;
    BlueMaskShift: Byte;
    Unused: array [0..6] of Byte;
    EdidSize: QWord;
    Edid: Pointer;
    ModeCount: QWord;
    Modes: ^ALimineVideoMode;
  end;
  ALimineFramebuffer = array of TLimineFramebuffer;

  PLimineFramebufferResponse = ^TLimineFramebufferResponse;
  TLimineFramebufferResponse = record
    Revision: QWord;
    FramebufferCount: QWord;
    Framebuffers: ^ALimineFramebuffer;
  end;

  TLimineFramebufferRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineFramebufferResponse;
  end;

{ ** Higher Half Direct Map ************************************************* }
type
  PLimineHigherHalfDirectMapResponse = ^TLimineHigherHalfDirectMapResponse;
  TLimineHigherHalfDirectMapResponse = record
    Revision: QWord;
    Offset: QWord;
  end;

  TLimineHigherHalfDirectMapRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineHigherHalfDirectMapResponse;
  end;

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
    Base: QWord;
    Length: QWord;
    EntryType: QWord;
  end;
  ALimineMemoryMapEntry = array of TLimineMemoryMapEntry;

  PLimineMemoryMapResponse = ^TLimineMemoryMapResponse;
  TLimineMemoryMapResponse = record
    Revision: QWord;
    EntryCount: QWord;
    Entries: ^ALimineMemoryMapEntry;
  end;

  TLimineMemoryMapRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineMemoryMapResponse;
  end;

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
    Flags: QWord;
  end;

  PLimineModuleResponse = ^TLimineModuleResponse;
  TLimineModuleResponse = record
    Revision: QWord;
    ModuleCount: QWord;
    Modules: ^ALimineFile;
  end;

  TLimineModuleRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineModuleResponse;
    { Request revision 1 }
    InternalModuleCount: QWord;
    InternalModules: ^ALimineInternalModule;
  end;

{ ** Multiprocessor ********************************************************* }
const
  LIMINE_MULTIPROCESSOR_REQUEST_X86_64_X2APIC = 1;

type
  PLimineMultiprocessorInfo = ^TLimineMultiprocessorInfo;

  TLimineGotoAddress = Procedure(Info: PLimineMultiprocessorInfo);

  TLimineMultiprocessorInfo = record
    ProcessorId: DWord;
{$if defined(CPUX86_64)}
    LapicId: DWord;
    Reserved: QWord;
{$elseif defined(CPUAARCH64)}
    Reserved1: DWord;
    Mpidr: DWord;
    Reserved2: DWord;
{$elseif defined(CPURISCV64)}
    Hartid: QWord;
    Reserved: QWord;
{$endif}
    GotoAddress: TLimineGotoAddress;
    ExtraArgument: QWord;
  end;
  ALimineMultiprocessorInfo = array of TLimineMultiprocessorInfo;

  PLimineMultiprocessorResponse = ^TLimineMultiprocessorResponse;
  TLimineMultiprocessorResponse = record
    Revision: QWord;
{$if defined(CPUX86_64)}
    Flags: DWord;
    BspLapicId: DWord;
{$elseif defined(CPUAARCH64)}
    Flags: QWord;
    BspMpidr: QWord;
{$elseif defined(CPURISCV64)}
    Flags: QWord;
    BspHartId: QWord;
{$endif}
    CpuCount: QWord;
    Cpus: ^ALimineMultiprocessorInfo;
  end;

  TLimineMultiprocessorRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineMultiprocessorResponse;
    Flags: QWord;
  end;

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
    Revision: QWord;
    Mode: QWord;
  end;

  TLiminePagingModeRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLiminePagingModeResponse;
    Mode: QWord;
    { Request revision 1 and above }
    MaxMode: QWord;
    MinMode: QWord;
  end;

{ ** RISC-V BSP Hart ID ***************************************************** }
type
  PLimineRiscvBspHartIdResponse = ^TLimineRiscvBspHartIdResponse;
  TLimineRiscvBspHartIdResponse = record
    Revision: QWord;
    BspHartId: QWord;
  end;

  TLimineRiscvBspHartIdRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineRiscvBspHartIdResponse;
  end;

{ ** RSDP ******************************************************************* }
type
  PLimineRsdpResponse = ^TLimineRsdpResponse;
  TLimineRsdpResponse = record
    Revision: QWord;
    Address: Pointer;
  end;

  TLimineRsdpRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineRsdpResponse;
  end;

{ ** SMBIOS ***************************************************************** }
type
  PLimineSmbiosResponse = ^TLimineSmbiosResponse;
  TLimineSmbiosResponse = record
    Revision: QWord;
    Entry32: QWord;
    Entry64: QWord;
  end;

  TLimineSmbiosRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineSmbiosResponse;
  end;

{ ** Stack Size ************************************************************* }
type
  PLimineStackSizeResponse = ^TLimineStackSizeResponse;
  TLimineStackSizeResponse = record
    Revision: QWord;
  end;

  TLimineStackSizeRequest = record
    Id: array [0..3] of QWord;
    Revision: QWord;
    Response: PLimineStackSizeResponse;
    StackSize: QWord;
  end;

function BaseRevisionSupported: Boolean; inline;

implementation

var
  BaseRevision: array [0..3] of QWord; external name '_limine_request_base_revision';

function BaseRevisionSupported: Boolean;
begin
  BaseRevisionSupported := BaseRevision[2] = 0;
end;

end.