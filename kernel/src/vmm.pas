unit Vmm;

interface

procedure Initialize;

implementation

uses ArchApi, Framebuffer, Limine, Log, Pmm, SysUtils;

var
  ExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';
  HhdmRequest: TLimineHhdmRequest; external name '_limine_request_hhdm';
  KernelStart: Pointer; external name '_kernel_start';
  KernelEnd: Pointer; external name '_kernel_end';
  HhdmOffset: PtrUInt;

function GetFrameWithHhdmOffset(Frame: PtrUInt): PtrUInt; inline;
begin
  result := Frame + HhdmOffset;
end;

function CreateKernelAddressSpace: PtrUInt;
var
  RootFrame: PtrUInt;
  I: SizeUInt;
begin
  RootFrame := 0;
  if not CreateRootFrame(RootFrame, @EarlyAllocateFrame, @GetFrameWithHhdmOffset) then
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
    @EarlyAllocateFrame, @GetFrameWithHhdmOffset
  ) then Panic('Failed to map kernel executable region.');

  { TODO: Use proper flags based on memory types. }
  // Use higher-half direct mapping to map physical memory.
  with MemoryMapRequest.Response^ do
    for I := 0 to EntryCount - 1 do with Entries^[I] do
      if not MapPageRange(
        RootFrame,
        Base,
        GetFrameWithHhdmOffset(Base),
        Length,
        [MemoryAccessGlobal, MemoryAccessWrite],
        MemoryCacheWriteBack,
        @EarlyAllocateFrame,
        @GetFrameWithHhdmOffset
      ) then Panic('Failed to map physical memory range.');
      end;

  { TODO: This can be handled in the above loop. }
  // Map the framebuffer region.
  MapPageRange(RootFrame,
    Framebuffer.GetVirtualBase - HhdmOffset,
    Framebuffer.GetVirtualBase,
    Framebuffer.GetSize,
    [MemoryAccessGlobal, MemoryAccessWrite], MemoryCacheWriteCombining,
    @EarlyAllocateFrame, @GetFrameWithHhdmOffset
  );

  result := RootFrame;
end;

procedure Initialize;
begin
{$ifndef NDEBUG}
  Log.DebugLn('HHDM Offset=' + IntToHex(HhdmRequest.Response^.Offset) +
    ' KernelStart=' + IntToHex(PtrUInt(@KernelStart)) +
    ' KernelEnd=' + IntToHex(PtrUInt(@KernelEnd)));
{$endif}

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

  if not Assigned(HhdmRequest.Response) then
    Panic('No HHDM response from Limine.');
end.
