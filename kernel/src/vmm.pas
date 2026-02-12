unit Vmm;

interface

procedure Initialize;

implementation

uses ArchApi, Framebuffer, Limine, Log, Pmm, SysUtils, Utilities;

var
  ExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';
  KernelEnd: Pointer; external name '_kernel_end';
  KernelTextStart: Pointer; external name '_kernel_text_start';
  KernelTextEnd: Pointer; external name '_kernel_text_end';
  KernelRodataStart: Pointer; external name '_kernel_rodata_start';
  KernelRodataEnd: Pointer; external name '_kernel_rodata_end';
  KernelRootFrame: PtrUInt;
  BumpAllocatorPtr: PtrUInt;

function CreateKernelAddressSpace: PtrUInt;
var
  RootFrame, KernelFrame, KernelPage: PtrUInt;
  EntryIndex: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
begin
  RootFrame := EarlyAllocateFrame;
  if RootFrame = High(PtrUInt) then Panic('Failed to create kernel address space root frame.');

  FillByte(Pointer(AddHhdmOffset(RootFrame))^, PageSize, 0);

  // Map the kernel region.
  MemoryCache := MemoryCacheWriteBack;
  KernelFrame := ExecutableAddressRequest.Response^.PhysicalBase;
  KernelPage := ExecutableAddressRequest.Response^.VirtualBase;

  while KernelPage < PtrUInt(@KernelEnd) do begin
    // Kernel text segment.
    if (KernelPage >= PtrUInt(@KernelTextStart)) and (KernelPage < PtrUInt(@KernelTextEnd)) then
      MemoryAccess := [MemoryAccessGlobal, MemoryAccessExecute]
    // Kernel rodata segment.
    else if (KernelPage >= PtrUInt(@KernelRodataStart)) and (KernelPage < PtrUInt(@KernelRodataEnd)) then
      MemoryAccess := [MemoryAccessGlobal]
    // Kernel data, bss, and Limine Request segments.
    else
      MemoryAccess := [MemoryAccessGlobal, MemoryAccessWrite];

    if not Assigned(MapPage(RootFrame, KernelFrame, KernelPage, MemoryAccess, MemoryCache, @EarlyAllocateFrame)) then
      Panic('Failed to map kernel.');

    Inc(KernelFrame, PageSize);
    Inc(KernelPage, PageSize);
  end;

  // Use higher-half direct mapping.
  MemoryAccess := [MemoryAccessGlobal, MemoryAccessWrite];

  with MemoryMapRequest.Response^ do
    for EntryIndex := 0 to EntryCount - 1 do with Entries^[EntryIndex] do begin
      if EntryType = LIMINE_MEMMAP_FRAMEBUFFER then
        MemoryCache := MemoryCacheWriteCombining
      else
        MemoryCache := MemoryCacheWriteBack;

      if not Assigned(MapPageRange(RootFrame, Base, AddHhdmOffset(Base), Length,
        MemoryAccess, MemoryCache, @EarlyAllocateFrame)) then Panic('Failed to map HHDM.');
    end;

  result := RootFrame;
end;

procedure Initialize;
begin
  KernelRootFrame := CreateKernelAddressSpace;
  LoadRootFrame(KernelRootFrame);

{$ifndef NDEBUG}
  Log.DebugLn('VMM initialized.');
{$endif}
end;

begin
  if not Assigned(ExecutableAddressRequest.Response) then Panic('No executable address response.');
  if not Assigned(MemoryMapRequest.Response) then Panic('No memory map response.');

  BumpAllocatorPtr := PtrUInt(@KernelEnd);
end.
