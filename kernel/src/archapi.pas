unit ArchApi;

interface

type
  TAllocateFrameCallback = function(var Frame: PtrUInt; Size: SizeUInt): Boolean;

  TGetPageFromFrameCallback = function(Frame: PtrUInt): PtrUInt;

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

{ Creates the root frame for a virtual address space.
  - RootFrame: Reference to the frame to allocate.
  - AllocateFrame: A callback function to allocate the frame.
  - GetPageFromFrame: A callback function to get the virtual address of the frame.
  Returns true on success. }
function CreateRootFrame(
  var RootFrame: PtrUInt;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_create_root_frame';

{ Loads a root frame to switch address space.
  - RootFrame: The root frame of the address space. }
procedure LoadRootFrame(
  const RootFrame: PtrUInt
); external name '_arch_load_root_frame';

{ Maps a single page in the address space determined by the root frame.
  - RootFrame: The root frame of the address space.
  - Frame: The physical frame to map.
  - Page: The virtual page to map the frame to.
  - MemoryAccess: The memory access flags.
  - MemoryCache: The memory cache setting.
  - AllocateFrame: A callback function to allocate frames as needed.
  - GetPageFromFrame: A callback function to get the virtual address of frames as needed.
  Returns true on success. }
function MapPage(
  RootFrame, Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_map_page';

{ Maps a range of pages in the address space determined by the root frame.
  - RootFrame: The root frame of the address space.
  - Frame: The physical frame to map.
  - Page: The starting virtual page to map the frame to.
  - Size: The size of the range to map, in bytes.
  - MemoryAccess: The memory access flags.
  - MemoryCache: The memory cache setting.
  - AllocateFrame: A callback function to allocate frames as needed.
  - GetPageFromFrame: A callback function to get the virtual address of frames as needed.
  Returns true on success. }
function MapPageRange(
  RootFrame, Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_map_page_range';

implementation

end.
