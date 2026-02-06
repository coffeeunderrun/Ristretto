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

procedure Initialize;

implementation

uses Limine, Log, Pmm, SysUtils;

function CreateRootFrame(
  var RootFrame: PtrUInt;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_create_root_frame';

function MapPage(
  RootFrame, Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_map_page';

function MapPageRange(
  RootFrame, Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_map_page_range';

var
  ExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';
  HhdmRequest: TLimineHhdmRequest; external name '_limine_request_hhdm';
  KernelStart: Pointer; external name '_kernel_start';
  KernelEnd: Pointer; external name '_kernel_end';
  HhdmOffset: PtrUInt;

function GetFrameWithHhdmOffset(Frame: PtrUInt): PtrUInt; inline;
begin
  result := Frame + HhdmRequest.Response^.Offset;
end;

function CreateKernelAddressSpace: PtrUInt;
var
  RootFrame: PtrUInt;
  I: SizeUInt;
begin
  if not CreateRootFrame(RootFrame, @EarlyAllocateFrame, @GetFrameWithHhdmOffset) then begin
    Log.Fatal('Failed to create kernel address space root frame.');
    Halt;
  end;

  { TODO: Use proper flags based on segments. }
  // Map the kernel executable region.
  if not MapPageRange(
    RootFrame,
    ExecutableAddressRequest.Response^.PhysicalBase,
    ExecutableAddressRequest.Response^.VirtualBase,
    PtrUInt(@KernelEnd) - PtrUInt(@KernelStart),
    [MemoryAccessGlobal, MemoryAccessExecute, MemoryAccessSupervisor, MemoryAccessWrite], MemoryCacheNone,
    @EarlyAllocateFrame, @GetFrameWithHhdmOffset
  ) then begin
    Log.Fatal('Failed to map kernel executable region.');
    Halt;
  end;

  { TODO: Use proper flags based on memory types. }
  // Use higher-half direct mapping to map physical memory.
  with MemoryMapRequest.Response^ do
    for I := 0 to EntryCount - 1 do with Entries^[I] do
      if not MapPageRange(
        RootFrame, Base, GetFrameWithHhdmOffset(Base), Length,
        [MemoryAccessGlobal, MemoryAccessExecute, MemoryAccessSupervisor, MemoryAccessWrite], MemoryCacheNone,
        @EarlyAllocateFrame, @GetFrameWithHhdmOffset
      ) then begin
        Log.Fatal('Failed to map physical memory range.');
        Halt;
      end;
  result := RootFrame;
end;

procedure SwitchToAddressSpace(const RootFrame: PtrUInt); assembler; nostackframe;
asm
  mov rax, RootFrame
  mov cr3, rax
end;

procedure Initialize;
begin
  Log.Debug('HHDM Offset=' + IntToHex(HhdmRequest.Response^.Offset) +
    ' KernelStart=' + IntToHex(PtrUInt(@KernelStart)) +
    ' KernelEnd=' + IntToHex(PtrUInt(@KernelEnd)));

  SwitchToAddressSpace(CreateKernelAddressSpace);
  Log.Debug('VMM initialized.');
end;

begin
  if not Assigned(ExecutableAddressRequest.Response) then begin
    Log.Fatal('No executable address response from Limine.');
    Halt;
  end;

  if not Assigned(MemoryMapRequest.Response) then begin
    Log.Fatal('No memory map response from Limine.');
    Halt;
  end;

  if not Assigned(HhdmRequest.Response) then begin
    Log.Fatal('No HHDM response from Limine.');
    Halt;
  end;

  HhdmOffset := HhdmRequest.Response^.Offset;
end.
