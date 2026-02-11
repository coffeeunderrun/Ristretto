unit Vmm;

interface

procedure Initialize;

implementation

uses ArchApi, Framebuffer, Limine, Log, Pmm, SysUtils, Utilities;

const
  KernelAccessExecutable = [MemoryAccessGlobal, MemoryAccessExecute];
  KernelAccessWritable = [MemoryAccessGlobal, MemoryAccessWrite];
  KernelAccessReadOnly = [MemoryAccessGlobal];

var
  ExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';
  KernelEnd: Pointer; external name '_kernel_end';
  KernelTextStart: Pointer; external name '_kernel_text_start';
  KernelTextEnd: Pointer; external name '_kernel_text_end';
  KernelRodataStart: Pointer; external name '_kernel_rodata_start';
  KernelRodataEnd: Pointer; external name '_kernel_rodata_end';

function CreateKernelAddressSpace: PtrUInt;
var
  RootFrame, KernelFrame, KernelPage: PtrUInt;
  EntryIndex: SizeUInt;
  MapSuccess: Boolean;
begin
  RootFrame := 0;

  if not CreateRootFrame(RootFrame, @EarlyAllocateFrame, @AddHhdmOffset) then
    Panic('Failed to create kernel address space root frame.');

  // Map the kernel region.
  KernelFrame := ExecutableAddressRequest.Response^.PhysicalBase;
  KernelPage := ExecutableAddressRequest.Response^.VirtualBase;
  while KernelPage < PtrUInt(@KernelEnd) do begin
    // Map kernel text as executable.
    if (KernelPage >= PtrUInt(@KernelTextStart)) and (KernelPage < PtrUInt(@KernelTextEnd)) then
      MapSuccess := MapPage(RootFrame, KernelFrame, KernelPage,
        KernelAccessExecutable, MemoryCacheWriteBack, @EarlyAllocateFrame, @AddHhdmOffset)
    // Map kernel rodata as read-only.
    else if (KernelPage >= PtrUInt(@KernelRodataStart)) and (KernelPage < PtrUInt(@KernelRodataEnd)) then
      MapSuccess := MapPage(RootFrame, KernelFrame, KernelPage,
        KernelAccessReadOnly, MemoryCacheWriteBack, @EarlyAllocateFrame, @AddHhdmOffset)
    // Map the rest of the kernel as writable.
    else
      MapSuccess := MapPage(RootFrame, KernelFrame, KernelPage,
      KernelAccessWritable, MemoryCacheWriteBack, @EarlyAllocateFrame, @AddHhdmOffset);

    if not MapSuccess then Panic('Failed to map kernel.');

    Inc(KernelFrame, PageSize);
    Inc(KernelPage, PageSize);
  end;

  // Use higher-half direct mapping.
  with MemoryMapRequest.Response^ do
    for EntryIndex := 0 to EntryCount - 1 do with Entries^[EntryIndex] do begin
      if EntryType = LIMINE_MEMMAP_FRAMEBUFFER then
        MapSuccess := MapPageRange(RootFrame, Base, AddHhdmOffset(Base), Length,
        KernelAccessWritable, MemoryCacheWriteCombining, @EarlyAllocateFrame, @AddHhdmOffset)
      else
        MapSuccess := MapPageRange(RootFrame, Base, AddHhdmOffset(Base), Length,
        KernelAccessWritable, MemoryCacheWriteBack, @EarlyAllocateFrame, @AddHhdmOffset);

      if not MapSuccess then Panic('Failed to map HHDM.');
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
