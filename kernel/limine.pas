unit Limine;

interface

const
  LimineMediaTypeGeneric = 0;
  LimineMediaTypeOptical = 1;
  LimineMediaTypeTftp = 2;

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
  LimineFirmwareTypeX86Bios = 0;
  LimineFirmwareTypeEfi32 = 1;
  LimineFirmwareTypeEfi64 = 2;
  LimineFirmwareTypeSbi = 3;

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
  LimineMemoryMapUsable = 0;
  LimineMemoryMapReserved = 1;
  LimineMemoryMapAcpiReclaimable = 2;
  LimineMemoryMapAcpiNvs = 3;
  LimineMemoryMapBadMemory = 4;
  LimineMemoryMapBootloaderReclaimable = 5;
  LimineMemoryMapExecutableAndModules = 6;
  LimineMemoryMapFramebuffer = 7;
  LimineMemoryMapAcpiTables = 8;

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
  LimineInternalModuleRequired = 1;
  LimineInternalModuleCompressed = 2;

type
  PLimineInternalModule = ^TLimineInternalModule;
  TLimineInternalModule = record
    Path: PChar;
    Str: PChar;
    Flags: UInt64;
  end;
  ALimineInternalModule = array of TLimineInternalModule;

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


function BaseRevisionSupported: Boolean; inline;

implementation

function BaseRevisionSupported: Boolean; inline;
begin
  BaseRevisionSupported := LimineBaseRevision[2] = 0;
end;

end.
