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

{ Loads a root frame to switch address space.
  - RootFrame: The root frame of the address space. }
procedure LoadRootFrame(RootFrame: PtrUInt); external name '_arch_load_root_frame';

{ Maps a single page in the address space.
  - RootFrame: The root frame of the address space.
  - Frame: The physical frame to map.
  - Page: The virtual page to map the frame to.
  - MemoryAccess: The memory access flags.
  - MemoryCache: The memory cache setting.
  - AllocateFrame: A callback function to allocate a new frame.
  Returns pointer to the mapped page on success, nil on failure. }
function MapPage(
  RootFrame, Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback
): Pointer; external name '_arch_map_page';

{ Maps a range of pages in the address space.
  - RootFrame: The root frame of the address space.
  - Frame: The physical frame to map.
  - Page: The starting virtual page to map the frame to.
  - Size: The size of the range to map, in bytes.
  - MemoryAccess: The memory access flags.
  - MemoryCache: The memory cache setting.
  - AllocateFrame: A callback function to allocate new frames.
  Returns pointer to the mapped page on success, nil on failure. }
function MapPageRange(
  RootFrame, Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback
): Pointer; external name '_arch_map_page_range';

{ Unmaps a single page in the address space.
  - RootFrame: The root frame of the address space.
  - Page: The virtual page to unmap.
  - DeallocateFrame: A callback procedure to deallocate the frame. }
procedure UnMapPage(
  RootFrame, Page: PtrUInt;
  const DeallocateFrame: TDeallocateFrameCallback
); external name '_arch_unmap_page';

{ Unmaps a range of pages in the address space.
  - RootFrame: The root frame of the address space.
  - Page: The starting virtual page to unmap.
  - Size: The size of the range to unmap, in bytes.
  - DeallocateFrame: A callback procedure to deallocate the frames. }
procedure UnMapPageRange(
  RootFrame, Page: PtrUInt;
  Size: SizeUInt;
  const DeallocateFrame: TDeallocateFrameCallback
); external name '_arch_unmap_page_range';

implementation

end.
