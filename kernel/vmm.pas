unit Vmm;

interface

type
  TGetPageFromFrameCallback = function(Frame: PtrUInt): PtrUInt;

  TMemoryAccess = (
    MemoryAccessExecute,
    MemoryAccessGlobal,
    MemoryAccessSupervisor,
    MemoryAccessWrite
  );
  TMemoryAccessSet = set of TMemoryAccess;

  TMemoryCache = (
    MemoryCacheNone,
    MemoryCacheWriteBack,
    MemoryCacheWriteCombining,
    MemoryCacheWriteThrough
  );

implementation

uses Limine, Log, Pmm, SysUtils;

function MapPage(
  var RootFrame: PtrUInt;
  Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  AllocateFrame: TAllocateFrameCallback;
  GetPageFromFrame: TGetPageFromFrameCallback): Boolean; external name '_arch_map_page';

function MapPageRange(
  var RootFrame: PtrUInt;
  Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  AllocateFrame: TAllocateFrameCallback;
  GetPageFromFrame: TGetPageFromFrameCallback): Boolean; external name '_arch_map_page_range';

var
  ExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';
  HhdmRequest: TLimineHhdmRequest; external name '_limine_request_hhdm';
  KernelStart: Pointer; external name '_kernel_start';
  KernelEnd: Pointer; external name '_kernel_end';

function GetFrameWithHhdmOffset(Frame: PtrUInt): PtrUInt; inline;
begin
  result := Frame + HhdmRequest.Response^.Offset;
end;

function CreateKernelAddressSpace: PtrUInt;
var
  RootFrame: PtrUInt;
  I: SizeUInt;
begin
  RootFrame := 0;

  { TODO: Use proper flags based on segments. }
  // Map the kernel executable region.
  MapPageRange(
    RootFrame,
    ExecutableAddressRequest.Response^.PhysicalBase,
    ExecutableAddressRequest.Response^.VirtualBase,
    PtrUInt(@KernelEnd) - PtrUInt(@KernelStart),
    [MemoryAccessGlobal, MemoryAccessExecute, MemoryAccessSupervisor, MemoryAccessWrite],
    MemoryCacheNone,
    @EarlyAllocateFrame,
    @GetFrameWithHhdmOffset
  );

  { TODO: Use proper flags based on memory types. }
  // Use higher-half direct mapping to map physical memory.
  with MemoryMapRequest.Response^ do
    for I := 1 to EntryCount do with Entries^[I] do
      MapPageRange(
        RootFrame, Base, GetFrameWithHhdmOffset(Base), Length,
        [MemoryAccessGlobal, MemoryAccessExecute, MemoryAccessSupervisor, MemoryAccessWrite],
        MemoryCacheNone,
        @EarlyAllocateFrame,
        @GetFrameWithHhdmOffset
      );

  result := RootFrame;
end;

procedure SwitchToAddressSpace(const RootFrame: PtrUInt); assembler; nostackframe;
asm
  mov rax, RootFrame
  mov cr3, rax
end;

begin
  Log.Debug('HHDM Offset=' + IntToHex(HhdmRequest.Response^.Offset) +
    ' KernelStart=' + IntToHex(PtrUInt(@KernelStart)) +
    ' KernelEnd=' + IntToHex(PtrUInt(@KernelEnd)));

  SwitchToAddressSpace(CreateKernelAddressSpace);

  Log.Debug('Unit initialized: VMM');
end.
