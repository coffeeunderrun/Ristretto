unit ArchApi;

interface

type
  TAllocateFrameCallback = function: PtrUInt;
  TDeallocateFrameCallback = procedure(Frame: PtrUInt);

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

var
  PageSize: SizeUInt; external name '_arch_page_size';

procedure LoadRootFrame(RootFrame: PtrUInt); external name '_arch_load_root_frame';

function MapPage(
  RootFrame, Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback
): Pointer; external name '_arch_map_page';

function MapPageRange(
  RootFrame, Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback
): Pointer; external name '_arch_map_page_range';

procedure UnMapPage(
  RootFrame, Page: PtrUInt;
  const DeallocateFrame: TDeallocateFrameCallback
); external name '_arch_unmap_page';

procedure UnMapPageRange(
  RootFrame, Page: PtrUInt;
  Size: SizeUInt;
  const DeallocateFrame: TDeallocateFrameCallback
); external name '_arch_unmap_page_range';

implementation

end.
