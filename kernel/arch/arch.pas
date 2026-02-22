unit Arch;

interface

const
  PAGE_SIZE: SizeUInt = 0;

type
  TAllocateFrameCallback = function: PtrUInt;
  TDeallocateFrameCallback = procedure(Frame: PtrUInt);
  TInvalidatePageCallback = procedure(Page: PtrUInt);

  TMemoryAccess = (
    MemoryAccessExecute,
    MemoryAccessGlobal,
    MemoryAccessUser,
    MemoryAccessWrite
  );
  TMemoryAccessSet = set of TMemoryAccess;

  TMemoryCache = (
    MemoryCacheNone,
    MemoryCacheWriteBack,
    MemoryCacheWriteCombining,
    MemoryCacheWriteThrough
  );

procedure OneTimeInitialize; inline;
procedure PerProcInitialize; inline;

procedure LoadRootFrame(RootFrame: PtrUInt); inline;
procedure InvalidatePage(Page: PtrUInt); inline;

function MapPage(
  RootFrame, Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
): Pointer; external name '_arch_map_page';

function MapPageRange(
  RootFrame, Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
): Pointer; external name '_arch_map_page_range';

procedure UnMapPage(
  RootFrame, Page: PtrUInt;
  const DeallocateFrame: TDeallocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
); external name '_arch_unmap_page';

procedure UnMapPageRange(
  RootFrame, Page: PtrUInt;
  Size: SizeUInt;
  const DeallocateFrame: TDeallocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
); external name '_arch_unmap_page_range';

implementation

{$I arch.inc}

end.
