unit Vmm;

interface

procedure Initialize;

implementation

uses ArchApi, Framebuffer, Limine, Log, Pmm, SysUtils, Utilities;

var
  ExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';
  KernelStart: Pointer; external name '_kernel_start';
  KernelEnd: Pointer; external name '_kernel_end';

function CreateKernelAddressSpace: PtrUInt;
var
  RootFrame: PtrUInt;
  EntryIndex: SizeUInt;
  MemoryCache: TMemoryCache;
begin
  RootFrame := 0;
  if not CreateRootFrame(RootFrame, @EarlyAllocateFrame, @AddHhdmOffset) then
    Panic('Failed to create kernel address space root frame.');

  { TODO: Use proper flags based on segments. }
  // Map the kernel executable region.
  if not MapPageRange(
    RootFrame,
    ExecutableAddressRequest.Response^.PhysicalBase,
    ExecutableAddressRequest.Response^.VirtualBase,
    PtrUInt(@KernelEnd) - PtrUInt(@KernelStart),
    [MemoryAccessGlobal, MemoryAccessExecute, MemoryAccessWrite],
    MemoryCacheWriteBack,
    @EarlyAllocateFrame, @AddHhdmOffset
  ) then Panic('Failed to map kernel executable region.');

  // Use higher-half direct mapping to map physical memory.
  with MemoryMapRequest.Response^ do
    for EntryIndex := 0 to EntryCount - 1 do with Entries^[EntryIndex] do begin
      if EntryType = LIMINE_MEMMAP_FRAMEBUFFER then
        MemoryCache := MemoryCacheWriteCombining
      else
        MemoryCache := MemoryCacheWriteBack;

      if not MapPageRange(
        RootFrame,
        Base,
        AddHhdmOffset(Base),
        Length,
        [MemoryAccessGlobal, MemoryAccessWrite],
        MemoryCache,
        @EarlyAllocateFrame,
        @AddHhdmOffset
      ) then Panic('Failed to map physical memory range.');
    end;

  result := RootFrame;
end;

procedure Initialize;
begin
  LoadRootFrame(CreateKernelAddressSpace);

{$ifndef NDEBUG}
  Log.DebugLn('VMM initialized.');
{$endif}
end;

begin
  if not Assigned(ExecutableAddressRequest.Response) then
    Panic('No executable address response from Limine.');

  if not Assigned(MemoryMapRequest.Response) then
    Panic('No memory map response from Limine.');
end.
