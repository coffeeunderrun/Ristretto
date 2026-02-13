unit Vmm;

interface

uses ArchApi;

procedure Initialize;

function AllocateKernelPage(MemoryAccess: TMemoryAccessSet; MemoryCache: TMemoryCache): Pointer;
function AllocateKernelPageRange(Size: SizeUInt; MemoryAccess: TMemoryAccessSet; MemoryCache: TMemoryCache): Pointer;

procedure DeallocateKernelPage(Page: Pointer);
procedure DeallocateKernelPageRange(Page: Pointer; Size: SizeUInt);

implementation

uses Framebuffer, Limine, Log, Pmm, Utilities;

var
  ExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';
  KernelEnd: Pointer; external name '_kernel_end';
  KernelTextStart: Pointer; external name '_kernel_text_start';
  KernelTextEnd: Pointer; external name '_kernel_text_end';
  KernelRodataStart: Pointer; external name '_kernel_rodata_start';
  KernelRodataEnd: Pointer; external name '_kernel_rodata_end';
  KernelRootFrame: PtrUInt;
  BumpAllocatorKernelPage: PtrUInt;

procedure CreateKernelAddressSpace;
var
  KernelFrame, KernelPage: PtrUInt;
  EntryIndex: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  Ptr: Pointer;
begin
  KernelRootFrame := EarlyAllocateFrame;
  if KernelRootFrame = High(PtrUInt) then Panic('Failed to create kernel address space root frame.');

  FillByte(Pointer(AddHhdmOffset(KernelRootFrame))^, PageSize, 0);

  // Kernel segments
  MemoryCache := MemoryCacheWriteBack;
  KernelFrame := ExecutableAddressRequest.Response^.PhysicalBase;
  KernelPage := ExecutableAddressRequest.Response^.VirtualBase;

  while KernelPage < PtrUInt(@KernelEnd) do begin
    if (KernelPage >= PtrUInt(@KernelTextStart)) and (KernelPage < PtrUInt(@KernelTextEnd)) then
      MemoryAccess := [MemoryAccessGlobal, MemoryAccessExecute]
    else if (KernelPage >= PtrUInt(@KernelRodataStart)) and (KernelPage < PtrUInt(@KernelRodataEnd)) then
      MemoryAccess := [MemoryAccessGlobal]
    else
      MemoryAccess := [MemoryAccessGlobal, MemoryAccessWrite];

    Ptr := MapPage(KernelRootFrame, KernelFrame, KernelPage, MemoryAccess, MemoryCache, @EarlyAllocateFrame);
    if not Assigned(Ptr) then Panic('Failed to map kernel.');

    Inc(KernelFrame, PageSize);
    Inc(KernelPage, PageSize);
  end;

  // HHDM
  MemoryAccess := [MemoryAccessGlobal, MemoryAccessWrite];

  with MemoryMapRequest.Response^ do
    for EntryIndex := 0 to EntryCount - 1 do with Entries^[EntryIndex] do begin
      if EntryType = LIMINE_MEMMAP_FRAMEBUFFER then
        MemoryCache := MemoryCacheWriteCombining
      else
        MemoryCache := MemoryCacheWriteBack;

      Ptr := MapPageRange(
        KernelRootFrame,
        Base,
        AddHhdmOffset(Base),
        Length,
        MemoryAccess,
        MemoryCache,
        @EarlyAllocateFrame
      );
      if not Assigned(Ptr) then Panic('Failed to map HHDM.');
    end;
end;

procedure Initialize;
begin
  CreateKernelAddressSpace;
  LoadRootFrame(KernelRootFrame);

  {$ifndef NDEBUG}
  Log.DebugLn('VMM initialized.');
  {$endif}
end;

function AllocateKernelPage(MemoryAccess: TMemoryAccessSet; MemoryCache: TMemoryCache): Pointer;
begin
  result := MapPage(
    KernelRootFrame,
    AllocateFrame,
    BumpAllocatorKernelPage,
    MemoryAccess,
    MemoryCache,
    @AllocateFrame,
    @InvalidatePage
  );

  if not Assigned(result) then begin
    Log.ErrorLn('Failed to allocate kernel page.');
    exit(nil);
  end;

  BumpAllocatorKernelPage += PageSize;
end;

function AllocateKernelPageRange(Size: SizeUInt; MemoryAccess: TMemoryAccessSet; MemoryCache: TMemoryCache): Pointer;
begin
  result := MapPageRange(
    KernelRootFrame,
    AllocateFrame,
    BumpAllocatorKernelPage,
    Size,
    MemoryAccess,
    MemoryCache,
    @AllocateFrame,
    @InvalidatePage
  );

  if not Assigned(result) then begin
    Log.ErrorLn('Failed to allocate kernel page range.');
    exit(nil);
  end;

  BumpAllocatorKernelPage += Align(Size, PageSize);
end;

procedure DeallocateKernelPage(Page: Pointer);
begin
  UnMapPage(KernelRootFrame, PtrUInt(Page), @DeallocateFrame, @InvalidatePage);
end;

procedure DeallocateKernelPageRange(Page: Pointer; Size: SizeUInt);
begin
  UnMapPageRange(KernelRootFrame, PtrUInt(Page), Size, @DeallocateFrame, @InvalidatePage);
end;

begin
  if not Assigned(ExecutableAddressRequest.Response) then Panic('No executable address response.');
  if not Assigned(MemoryMapRequest.Response) then Panic('No memory map response.');

  BumpAllocatorKernelPage := PtrUInt(Align(@KernelEnd, PageSize));
end.
